-------------------------------------------------------
-- Author = CuteOne
-- Patch = Unknown
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 90%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Sporadic
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Basic
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --
-------------------------------------------------------

local rotationName = "BDKJ"
---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    local spell = br.player.spell
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of enemies in range.", highlight = 1, icon = spell.bloodboil },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = spell.bloodBoil },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = spell.heartStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = spell.deathStrike }
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = spell.bonestorm },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = spell.bonestorm },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = spell.bonestorm }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = spell.iceboundFortitude },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = spell.iceboundFortitude }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = spell.mindFreeze }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
    -- Death And Decay Button
    local DndModes = {
        [1] = { mode = "On", value = 1 , overlay = "DnD Enabled", tip = "Will use DnD.", highlight = 1, icon = spell.deathAndDecay },
        [2] = { mode = "Off", value = 2 , overlay = "DnD Disabled", tip = "will NOT use DnD.", highlight = 0, icon = spell.deathAndDecay }
    };
    br.ui:createToggle(DndModes,"Dnd",5,0)
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
        local section
        local alwaysCdNever = {"|cff00FF00Always","|cffFFFF00Cooldowns","|cffFF0000Never"}
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dark Command
            br.ui:createCheckbox(section, "Dark Command", "|cffFFFFFFAuto Dark Command usage.")
            -- Blood Drinker
            br.ui:createCheckbox(section, "Blooddrinker")
            -- BoneStorm
            -- br.ui:createDropdownWithout(section, "Bone Storm Usage", {"Use with Keybind Below", "Auto Usage"}, 1, "")
            -- Dump RP
            br.ui:createCheckbox(section, "Dump RP with Death Strike")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Chains of Ice
            br.ui:createCheckbox(section, "Chains of Ice")
            -- Control Undead
            br.ui:createCheckbox(section, "Control Undead")
            -- Dark Command
            br.ui:createCheckbox(section, "Dark Command","|cffFFFFFFWill taunt selected target to begin combat.")
            -- Death Grip
            br.ui:createCheckbox(section, "Death Grip","|cffFFFFFFWill grip units out that are >8yrds away from you while in combat.")
            br.ui:createCheckbox(section, "Death Grip - Pre-Combat","|cffFFFFFFWill grip selected target to begin combat.")
            -- DnD Stand Time
            br.ui:createSpinnerWithout(section, "DnD Stand Time", 2, 0, 3, 0.25, "|cffFFFFFFSet to desired time to stand still before use. Min: 0 / Max: 3 / Interval: 0.25")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Path of Frost
            br.ui:createCheckbox(section, "Path of Frost")
        br.ui:checkSectionState(section)
        -------------------
        --- PET OPTIONS ---
        -------------------
        section = br.ui:createSection(br.ui.window.profile, "Pet Management")
            -- Raise Dead
            br.ui:createCheckbox(section, "Raise Dead")
            -- Pet Target
            br.ui:createDropdownWithout(section, "Pet Target", {"Dynamic Unit", "Only Target", "Any Unit"},1,"Select how you want pet to acquire targets.")
            -- Auto Attack/Passive
            br.ui:createCheckbox(section, "Auto Attack/Passive")
            -- Claw
            br.ui:createCheckbox(section, "Claw")
            -- Gnaw
            br.ui:createCheckbox(section, "Gnaw")
            -- Huddle
            br.ui:createSpinner(section, "Huddle", 30, 0, 100, 5, "|cffFFFFFFPet Health Percent to Cast At")
            -- Leap
            br.ui:createCheckbox(section, "Leap")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Cooldowns Time To Die Limit
            br.ui:createSpinnerWithout(section,  "Cooldowns Time To Die Limit",  30,  0,  40,  1,  "|cffFFFFFFTarget Time to die limit for using cooldowns (in sec).")
            -- Augment Rune
            br.ui:createCheckbox(section, "Augment Rune")
            -- Potion
            br.ui:createCheckbox(section, "Potion")
            -- Elixir
            br.player.module.FlaskUp("Strength",section)
            -- Racial
            br.ui:createCheckbox(section, "Racial")
            -- Trinkets
            br.player.module.BasicTrinkets(nil,section)
            -- Dancing Rune Weapon
            br.ui:createDropdownWithout(section, "Dancing Rune Weapon", alwaysCdNever, 1, "|cffFFFFFFWhen to use Raise Dead.")
            -- Raise Dead
            br.ui:createDropdownWithout(section, "Raise Dead CD", alwaysCdNever, 1, "|cffFFFFFFWhen to use Raise Dead.")
            br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Death Strike Values
            br.ui:createSpinner(section, "High Prio Deathstrike", 45, 0, 99, 5, "Use Deathstrike Immediately")
            br.ui:createSpinner(section, "Low Prio Deathstrike", 75, 0, 100, 5, "Use Deathstrike as a Offensive Ability")
            -- Vampiric Blood
            br.ui:createSpinner(section, "Vampiric Blood", 40, 0, 100, 5, "Health Percentage to use at.")
            -- Anti-Magic Shell
            br.ui:createSpinner(section, "Anti-Magic Shell", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Death Strike
            br.ui:createSpinner(section, "Death Strike", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Death Pact
            br.ui:createSpinner(section, "Death Pact", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Icebound Fortitude
            br.ui:createSpinner(section, "Icebound Fortitude", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
			-- Sacrificial Pact
            br.ui:createSpinner(section, "Sacrificial Pact", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Raise Ally
            br.ui:createDropdown(section, "Raise Ally", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Mind Freeze
            br.ui:createCheckbox(section, "Mind Freeze")
            -- Death Grip
            br.ui:createCheckbox(section, "Death Grip (Interrupt)")
            -- Asphyxiate
            br.ui:createCheckbox(section, "Asphyxiate")
            -- Asphyxiate Logic
            br.ui:createCheckbox(section, "Asphyxiate Logic")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At (0 is random)")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
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

--------------
--- Locals ---
--------------
-- BR API Locals
local buff
local cast
local cd
-- local conduit
local covenant
local debuff
local enemies
local equiped
local module
local pet
local runeforge
local runes
local runeDeficit
local runesTTM
-- local runicPower
local runicPowerDeficit
local spell
local talent
local ui
local unit
local units
local use
local var
local charges

-- General Locals
local actionList = {}
local waitForPetToAppear


--------------------
--- Action Lists ---
--------------------
-- Action List - Pet Management
actionList.PetManagement = function()
    local function getCurrentPetMode()
        local slots = _G["NUM_PET_ACTION_SLOTS"]
        local petMode = "None"
        for i = 1, slots do
            local name, _, _,isActive = br._G.GetPetActionInfo(i)
            if isActive then
                if name == "PET_MODE_ASSIST" then petMode = "Assist" end
                if name == "PET_MODE_DEFENSIVE" then petMode = "Defensive" end
                if name == "PET_MODE_PASSIVE" then petMode = "Passive" end
            end
        end
        return petMode
    end

    local petCombat = unit.inCombat("pet")
    local petExists = br.player.pet.active.exists()
    local petMode = getCurrentPetMode()
    local validTarget = unit.exists("pettarget") or (not unit.exists("pettarget") and unit.valid("target")) or unit.isDummy("target")
    if petExists and br.deadPet then br.deadPet = false end
    if waitForPetToAppear == nil or unit.mounted() or unit.flying() or br._G.UnitHasVehicleUI("player") or br._G.CanExitVehicle("player") then
        waitForPetToAppear = br._G.GetTime()
    elseif ui.checked("Raise Dead") then
        if waitForPetToAppear ~= nil and br._G.GetTime() - waitForPetToAppear > 2 then
            if cast.able.raiseDead() and (br.deadPet or (not br.deadPet and not petExists)
                or (talent.allWillServe and not pet.risenSkulker.exists()))
            then
                if cast.raiseDead("player") then waitForPetToAppear = br._G.GetTime(); ui.debug("Casting Raise Dead") return true end
            end
        end
    end
    if ui.checked("Auto Attack/Passive") then
        -- Set Pet Mode Out of Comat / Set Mode Passive In Combat
        if unit.exists("target") and ((not unit.inCombat() and petMode == "Passive") or (unit.inCombat() and (petMode == "Defensive" or petMode == "Passive"))) then
            br._G.PetAssistMode()
            ui.debug("Setting Pet to Assist")
        elseif not unit.inCombat() and petMode == "Assist" and #enemies.yards40nc > 0 then
            br._G.PetDefensiveAssistMode()
            ui.debug("Setting Pet to Defensive")
        elseif unit.inCombat() and petMode ~= "Passive" and #enemies.yards40 == 0 then
            br._G.PetPassiveMode()
            ui.debug("Setting Pet to Passive")
        end
        -- Pet Attack / retreat
        if (not br._G.UnitExists("pettarget") or not validTarget) and (unit.inCombat() or petCombat) then
            if ui.value("Pet Target") == 1 and unit.valid(units.dyn40) then
                br._G.PetAttack(units.dyn40)
            elseif ui.value("Pet Target") == 2 and validTarget then
                br._G.PetAttack("target")
            elseif ui.value("Pet Target") == 3 then
                for i=1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (unit.valid(thisUnit) or unit.isDummy(thisUnit)) then br._G.PetAttack(thisUnit); break end
                end
            end
        elseif (not unit.inCombat() or (unit.inCombat() and not validTarget and not unit.valid("target") and not unit.isDummy("target"))) and br._G.IsPetAttackActive() then
            br._G.PetStopAttack()
            br._G.PetFollow()
        end
    end
    -- Huddle
    if ui.checked("Huddle") and cast.able.huddle() and (unit.inCombat() or petCombat) and unit.hp("pet") <= ui.value("Huddle") then
        if cast.huddle() then ui.debug("Casting Huddle [Pet]") return true end
    end
    if unit.valid("pettarget") then
        -- Claw
        if ui.checked("Claw") and cast.able.claw("pettarget") and not buff.huddle.exists("pet") and validTarget and unit.distance("pettarget","pet") < 5 then
            if cast.claw("pettarget") then ui.debug("Casting Claw [Pet]") return true end
        end
        -- Leap
        if ui.checked("Leap") and cast.able.leap("pettarget") and not buff.huddle.exists("pet") and validTarget and unit.distance("pettarget","pet") > 8 then
            if cast.leap("pettarget") then ui.debug("Casting Leap [Pet]") return true end
        end
    end
    -- Gnaw
    if ui.checked("Gnaw") and cast.able.gnaw() and not buff.huddle.exists("pet") then
        for i=1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                if cast.gnaw(thisUnit) then ui.debug("Casting Gnaw [Pet]") return true end
            end
        end
    end
end -- End Action List - Pet Management

-- Action List - Extras
actionList.Extras = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Chains of Ice
    if ui.checked("Chains of Ice") and cast.able.chainsOfIce() then
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if not debuff.chainsOfIce.exists(thisUnit) and not unit.facing(thisUnit,"player") and unit.facing("player",thisUnit)
                and unit.moving(thisUnit) and unit.distance(thisUnit) > 8 and unit.inCombat()
            then
                if cast.chainsOfIce(thisUnit) then ui.debug("Casting Chains of Ice") return true end
            end
        end
    end
    -- -- Control Undead
    -- if ui.checked("Control Undead") and cast.able.controlUndead() and unit.player(var.controlledDead) then
    --     for i = 1, #enemies.yards30 do
    --         local thisUnit = enemies.yards30[i]
    --         if unit.undead(thisUnit) and not unit.isDummy(thisUnit) and not unit.isBoss(thisUnit) and unit.level(thisUnit) <= unit.level() + 1 then
    --             if cast.controlUndead(thisUnit) then ui.debug("Casting Control Undead") var.controlledDead = thisUnit return true end
    --         end
    --     end
    -- end
    -- Dark Command
    if br.isChecked("Dark Command") and unit.instance("party") then
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if br._G.UnitThreatSituation("player", thisUnit) ~= nil and br._G.UnitThreatSituation("player", thisUnit) <= 2 and br._G.UnitAffectingCombat(thisUnit) then
                if cast.darkCommand(thisUnit) then
                    return
                end
            end
        end
    end
    -- Death Grip
    if ui.checked("Death Grip") and cast.able.deathGrip() then
        local thisUnit = talent.deathsReach and units.dyn40 or units.dyn30
        if unit.inCombat() and unit.distance(thisUnit) > 10 and ((talent.deathsReach and unit.distance(thisUnit) < 40) or unit.distance(thisUnit) < 30) and not unit.isDummy(thisUnit) then
            if cast.deathGrip() then ui.debug("Casting Death Grip") return true end
        end
    end
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    -- Basic Healing Module
    module.BasicHealing()
    -- Anti-Magic Shell
    if ui.checked("Anti-Magic Shell") and cast.able.antiMagicShell() and unit.hp() < ui.value("Anti-Magic Shell") then
        if cast.antiMagicShell() then ui.debug("Casting Anti-Magic Shell") return true end
    end

     -- Rune Tap
     if ui.checked("Rune Tap") and unit.hp() <= br.value("Rune Tap") and cast.able.runeTap() and runes >= 3 and charges.runeTap.count() > 1 and not buff.runeTap.exists() then
        if cast.runeTap() then
            return
        end
    end

    -- High Prio Death Strike
    -- print(runicPowerDeficit)
    if unit.hp() <= ui.value("High Prio Deathstrike") and cast.able.deathStrike()and runicPowerDeficit < 65 then
        if cast.deathStrike() then
            -- print("High Prio Death Strike")
            -- print("395")
            return true
        end
    end
    -- -- Death Strike
    -- Death Pact
    if ui.checked("Death Pact") and cast.able.deathPact() and unit.hp() < ui.value("Death Pact") then
        if cast.deathPact() then ui.debug("Casting Death Pact") return true end
    end
    -- Icebound Fortitude
    if ui.checked("Icebound Fortitude") and cast.able.iceboundFortitude() and unit.hp() < ui.value("Icebound Fortitude") and not buff.vampiricBlood.exists() then
        if cast.iceboundFortitude() then ui.debug("Casting Icebound Fortitude") return true end
    end

    -- Vampiric Blood
    if ui.checked("Vampiric Blood") and cast.able.vampiricBlood() and unit.hp() < ui.value("Vampiric Blood") and not buff.iceboundFortitude.exists() then
        if cast.vampiricBlood() then ui.debug("Casting Vampiric Blood") return true end
    end
    -- Raise Ally
    if ui.checked("Raise Ally") then
        if ui.value("Raise Ally")==1 and cast.able.raiseAlly("target","dead")
            and unit.player("target") and unit.deadOrGhost("target") and unit.friend("target","player")
        then
            if cast.raiseAlly("target","dead") then ui.debug("Casting Raise Ally on Target") return true end
        end
        if ui.value("Raise Ally")==2 and cast.able.raiseAlly("mouseover","dead")
            and unit.player("mouseover") and unit.deadOrGhost("mouseover") and unit.friend("mouseover","player")
        then
            if cast.raiseAlly("mouseover","dead") then ui.debug("Casting Raise Ally on Mouseover") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        -- Mind Freeze
        if ui.checked("Mind Freeze") and cast.able.mindFreeze() then
            for i=1, #enemies.yards15 do
                local thisUnit = enemies.yards15[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.mindFreeze(thisUnit) then ui.debug("Casting Mind Freeze") return true end
                end
            end
        end
        --Asphyxiate
        if ui.checked("Asphyxiate") and cast.able.asphyxiate() and cd.mindFreeze.remain() > unit.gcd(true) then
            for i=1, #enemies.yards20 do
                local thisUnit = enemies.yards20[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.asphyxiate(thisUnit) then ui.debug("Casting Asphyxiate") return true end
                end
            end
        end
        --Death Grip
        if ui.checked("Death Grip (Interrupt)") and cast.able.deathGrip() then
            local theseEnemies = talent.deathsReach and enemies.yards40 or enemies.yards30
            for i = 1,  #theseEnemies do
                local thisUnit = theseEnemies[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) and unit.distance(thisUnit) > 10 then
                    if cast.deathGrip(thisUnit) then ui.debug("Casting Death Grip [Int]") return true end
                end
            end
        end
    end
end-- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    -- Potion
    -- potion,if=variable.major_cooldowns_active|fight_remains<26
    -- if ui.checked("Potion") and unit.instance("raid") and ui.useCDs() and use.able.battlePotionOfStrength()
    --     and (cd.armyOfTheDead.remain() == 0 or pet.gargoyle.exists() or buff.unholyAssault.exists())
    -- then
    --     use.battlePotionOfStrength()
    --     ui.debug("Using Battle Potion of Strength")
    -- end
    -- Dancing Rune Weapon
    if ui.alwaysCdNever("Dancing Rune Weapon") and cast.able.dancingRuneWeapon() and (unit.ttdGroup(5) >= ui.value("Cooldowns Time To Die Limit") or unit.isDummy()) then
        if cast.dancingRuneWeapon() then ui.debug("Casting Dancing Rune Weapon") return true end
    end
    -- Raise Dead
    -- raise_dead,if=!pet.ghoul.active
    if ui.alwaysCdNever("Raise Dead CD") and cast.able.raiseDead("player")
        and (br.deadPet or (not br.deadPet and ((not talent.allWillServe and not pet.active.exists()) or (talent.allWillServe and not pet.risenSkulker.exists()))))
    then
        if cast.raiseDead("player") then ui.debug("Casting Raise Dead [CD]") return true end
    end
end -- End Action List - Cooldowns

-- Action List - Racials
actionList.Racials = function()
    -- Racial
    if ui.checked("Racial") and cast.able.racial()
        -- arcane_torrent,if=runic_power.deficit>65&(pet.gargoyle.active|!talent.summon_gargoyle.enabled)&rune.deficit>=5
        and ((unit.race() == "BloodElf" and runicPowerDeficit > 65 and runeDeficit >= 5)
        -- blood_fury,if=variable.major_cooldowns_active|target.time_to_die<=buff.blood_fury.duration
        or (unit.race() == "Orc" and (var.majorCooldownsActive or unit.ttd(units.dyn5) <= cd.racial.duration()))
        -- berserking,if=variable.major_cooldowns_active|target.time_to_die<=buff.berserking.duration
        or (unit.race() == "Troll" and (var.majorCooldownsActive or unit.ttd(units.dyn5) <= cd.racial.duration()))
        -- lights_judgment,if=buff.unholy_strength.up
        or (unit.race() == "LightforgedDraenei" and buff.unholyStrength)
        -- ancestral_call,if=variable.major_cooldowns_active|target.time_to_die<=15
        or (unit.race() == "MagharOrc" and (var.majorCooldownsActive or unit.ttd(units.dyn5) <= 15))
        -- arcane_pulse,if=active_enemies>=2|(rune.deficit>=5&runic_power.deficit>=60)
        or (unit.race() == "Nightborne" and (ui.useAOE(8,2) or (runeDeficit >= 5 and runicPowerDeficit >= 60)))
        -- fireblood,if=variable.major_cooldowns_active|target.time_to_die<=buff.fireblood.duration
        or (unit.race() == "DarkIronDwarf" and (var.majorCooldownsActive or unit.ttd(units.dyn5) <= cd.racial.duration()))
        -- bag_of_tricks,if=buff.unholy_strength.up&active_enemies=1
        )
    then
        if cast.racial("player") then ui.debug("Casting Racial") return true end
    end
end -- End Action List - Racials

-- Action List - Trinkets
actionList.Trinkets = function()
    -- use_item,name=inscrutable_quantum_device,if=(cooldown.unholy_blight.remains|cooldown.dark_transformation.remains)&(pet.army_ghoul.active|pet.apoc_ghoul.active&!talent.army_of_the_damned|target.time_to_pct_20<5)|fight_remains<21
    -- use_item,slot=trinket1,if=!variable.specified_trinket&((trinket.1.proc.any_dps.duration<=15&cooldown.apocalypse.remains>20|trinket.1.proc.any_dps.duration>15&(cooldown.unholy_blight.remains>20|cooldown.dark_transformation.remains>20))&(!trinket.2.has_cooldown|trinket.2.cooldown.remains|variable.trinket_priority=1))|trinket.1.proc.any_dps.duration>=fight_remains
    -- use_item,slot=trinket2,if=!variable.specified_trinket&((trinket.2.proc.any_dps.duration<=15&cooldown.apocalypse.remains>20|trinket.2.proc.any_dps.duration>15&(cooldown.unholy_blight.remains>20|cooldown.dark_transformation.remains>20))&(!trinket.1.has_cooldown|trinket.1.cooldown.remains|variable.trinket_priority=2))|trinket.2.proc.any_dps.duration>=fight_remains
    -- use_item,slot=trinket1,if=!trinket.1.has_use_buff&(trinket.2.cooldown.remains|!trinket.2.has_use_buff)
    -- use_item,slot=trinket2,if=!trinket.2.has_use_buff&(trinket.1.cooldown.remains|!trinket.1.has_use_buff)
    -- Trinkets
    -- use_items
    module.BasicTrinkets()
end -- End Action List - Trinkets

-- Action List - Covenants
actionList.Covenants = function()
    -- Swarming Mist
    -- swarming_mist,if=variable.st_planning&runic_power.deficit>16&(cooldown.apocalypse.remains|!talent.army_of_the_damned&cooldown.dark_transformation.remains)|fight_remains<11
    if cast.able.swarmingMist("player","aoe",1,8) and ui.useST(8,2) and runicPowerDeficit > 16
        and ((cd.apocalypse.exists() or not ui.alwaysCdNever("Apocalypse")) or not talent.armyOfTheDamned
        and (cd.darkTransformation.exists() or not ui.alwaysCdNever("Dark Transformation")))
    then
        if cast.swarmingMist("player","aoe",1,8) then ui.debug("Casting Swarming Mist") return true end
    end
    -- swarming_mist,if=cooldown.apocalypse.remains&(active_enemies>=2&active_enemies<=5&runic_power.deficit>10+(active_enemies*6)|active_enemies>5&runic_power.deficit>40)
    if cast.able.swarmingMist("player","aoe",2,8) and (cd.apocalypse.exists() or not ui.alwaysCdNever("Apocalypse"))
        and #enemies.yards8 >= 2 and ((#enemies.yards8 <= 5 and runicPowerDeficit > 10 + (#enemies.yards8 * 6)) or (#enemies.yards8 > 5 and runicPowerDeficit > 40))
    then
        if cast.swarmingMist("player","aoe",2,8) then ui.debug("Casting Swarming Mist [AOE]") return true end
    end
    -- Abomination Limb
    -- abomination_limb,if=variable.st_planning&!soulbind.lead_by_example&(cooldown.apocalypse.remains|!talent.army_of_the_damned&cooldown.dark_transformation.remains)&rune.time_to_4>(3+buff.runic_corruption.remains)|fight_remains<21
    if cast.able.abominationLimb("player","aoe",1,20) and var.stPlanning and ((cd.apocalypse.exists() or not ui.alwaysCdNever("Apocalypse")) or not talent.armyOfTheDamned
        and (cd.darkTransformation.exists() or not ui.alwaysCdNever("Dark Transformation"))) and runesTTM(4) > (3 + buff.runicCorruption.remains())
    then
        if cast.abominationLimb("player","aoe",1,20) then ui.debug("Casting Abomination Limb") return true end
    end
    -- abomination_limb,if=variable.st_planning&soulbind.lead_by_example&(dot.unholy_blight_dot.remains>11|!talent.unholy_blight&cooldown.dark_transformation.remains)
    --
    -- abomination_limb,if=active_enemies>=2&rune.time_to_4>(3+buff.runic_corruption.remains)
    if cast.able.abominationLimb("player","aoe",2,20) and ui.useAOE(20,2) and runesTTM(4) > (3 + buff.runicCorruption.remains()) then
        if cast.abominationLimb("player","aoe",2,20) then ui.debug("Casting Abomination Limb [AOE]") return true end
    end
    -- Shackle the Unworthy
    -- shackle_the_unworthy,if=variable.st_planning&(cooldown.apocalypse.remains|!talent.army_of_the_damned&cooldown.dark_transformation.remains)|fight_remains<15
    if cast.able.shackleTheUnworthy() and var.stPlanning and ((cd.apocalypse.exists() or not ui.alwaysCdNever("Apocalypse")) or not talent.armyOfTheDamned
        and (cd.darkTransformation.exists() or not ui.alwaysCdNever("Dark Transformation")))
    then
        if cast.shackleTheUnworthy() then ui.debug("Casting Shackle the Unworthy") return true end
    end
    -- shackle_the_unworthy,if=active_enemies>=2&(death_and_decay.ticking|raid_event.adds.remains<=14)
    if cast.able.shackleTheUnworthy() and ui.useAOE(30,2) and buff.deathAndDecay.exists() then
        if cast.shackleTheUnworthy() then ui.debug("Casting Shackle the Unworthy [AOE]") return true end
    end
end -- End Action List - Covenants

-- Action List - Generic
actionList.Generic = function()

    if not debuff.bloodPlague.exists("target") and cast.able.deathsCaress() then
        if cast.deathsCaress() then return end
    end

    -- CAP DS
    if  runicPowerDeficit <= 65 and cast.able.deathStrike() and ui.checked("Dump RP with Death Strike") then
        -- print("CAP Death Strike")
        -- print("576")
        if cast.deathStrike() then return true end
    end

    --BloodDrinker
    if not buff.dancingRuneWeapon.exists("player") and  cast.able.blooddrinker() and talent.blooddrinker then
        if cast.blooddrinker("target") then
            return
        end
    end

    --bloodboil
    if cast.able.bloodBoil() and (charges.bloodBoil.frac() >= 1.8 and (buff.hemostasis.stack() <= (5 -  #enemies.yards8) or #enemies.yards10 > 2)) then
        if cast.bloodBoil() then
            return
        end
    end

    -- Drop extra runes
    if runes >= 4 and cast.able.heartStrike() then
        -- print("heartStrike")
        -- print("607")
        if cast.heartStrike() then return end
    end

    -- Tombstone
    if cast.able.tombstone() and (buff.boneShield.stack() > 6 and talent.tombstone and buff.death_and_decay.exists() and not cast.able.dancingRuneWeapon()) then
        if cast.tombstone() then
            return
        end
    end

    --runestrike
    if talent.runeStrike and ((charges.runeStrike.frac() >= 1.8 or buff.dancingRuneWeapon.exists()) and br.runeTimeTill(3) >= unit.gcd("player")) then
        if cast.runeStrike() then
            return
        end
    end
    --HS Cast
    if buff.dancingRuneWeapon.exists() or (br.runeTimeTill(4) < unit.gcd("player")) then
        if cast.heartStrike("target") then
            return
        end
    end

    --Low prio BB
    if buff.dancingRuneWeapon.exists("player") then
        if cast.bloodBoil() then
            return
        end
    end

    --Proc DnD
    if (buff.crimsonScourge.exists() or talent.rapidDecomposition or #enemies.yards8 >= 1) and ui.mode.dnd == 1 then
        if cast.deathAndDecay("player") then
            return
        end
    end

    if #enemies.yards8 >= 1 then
        if cast.consumption() then
            return
        end
    end

    if #enemies.yards8 >= 1 and cast.able.bloodBoil() then
        if cast.bloodBoil() then
            return
        end
    end

    if ((br.runeTimeTill(2) < unit.gcd("player")) or (buff.boneShield.stack() >= 6))
        and cast.able.heartStrike() then
            -- print("heartStrike")
            -- print("660")
            if cast.heartStrike() then
                return
            end
    end

    if runes >= 4 then
        if cast.heartStrike() then return end
    end

    if #enemies.yards8 >= 1 and talent.runeStrike then
        if cast.runeStrike() then
            return
        end
    end
    -- Any DnD
    -- any_dnd,if=(talent.defile.enabled|covenant.night_fae|runeforge.phearomones)&(!variable.pooling_runes|fight_remains<5)
    -- if ui.mode.dnd == 1 and unit.standingTime() >= ui.value("DnD Stand Time")
    --     and ((talent.defile or covenant.nightFae.active or runeforge.phearomones.equiped) and not var.poolingRunes)
    -- then
    --     if cast.able.defile("best",nil,1,8) and talent.defile then
    --         if cast.defile("best",nil,1,8) then ui.debug("Casting Defile [ST]") return true end
    --     end
    --     if cast.able.deathAndDecay("best",nil,1,8) and not talent.defile then
    --         if cast.deathAndDecay("best",nil,1,8) then ui.debug("Casting Death and Decay [ST]") return true end
    --     end
    --     if covenant.nightFae.active and cast.able.deathsDue("best",nil,1,8) then
    --         if cast.deathsDue("best",nil,1,8) then ui.debug("Casting Death's Due [ST]") return true end
    --     end
    -- end
end -- End Action List - Generic

-- Action List - PreCombat
actionList.PreCombat = function()
    -- Flask Module
    module.FlaskUp("Strength")
    -- Pre-pull
    if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
        -- Potion
        if ui.checked("Potion") and use.able.battlePotionOfStrength() and ui.useCDs() and unit.instance("raid") then
            use.battlePotionOfStrength()
            ui.debug("Using Battle Potion of Strength")
        end
        -- Army of the Dead
        if ui.alwaysCdNever("Army of the Dead") and ui.pullTimer() <= 2 and cast.able.armyOfTheDead("player") then
            if cast.armyOfTheDead("player") then ui.debug("Casting Army of the Dead [Pre-Pull]") return true end
        end
    end
    -- Pull
    if unit.valid("target") and not unit.inCombat() then
        -- Death Grip
        if ui.checked("Death Grip - Pre-Combat") and cast.able.deathGrip("target") and not unit.isDummy("target")
            and unit.distance("target") > 10 and ((talent.deathsReach and unit.distance("target") < 40) or unit.distance("target") < 30)
        then
            if cast.deathGrip("target") then ui.debug("Casting Death Grip [Pull]") return true end
        end
        -- Dark Command
        if ui.checked("Dark Command") and cast.able.darkCommand("target") and not (ui.checked("Death Grip") or cast.able.deathGrip("target")) then
            if cast.darkCommand("target") then ui.debug("Casting Dark Command [Pull]") return true end
        end
        -- Start Attack
        if cast.able.autoAttack("target") then
            if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pull]") return true end
        end
    end
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
--------------
--- Locals ---
--------------
    -- BR Player API
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    covenant                                      = br.player.covenant
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    equiped                                       = br.player.equiped
    module                                        = br.player.module
    pet                                           = br.player.pet
    runeforge                                     = br.player.runeforge
    runes                                         = br.player.power.runes.frac()
    runeDeficit                                   = math.floor(runes) - 6
    runesTTM                                      = br.player.power.runes.ttm
    runicPowerDeficit                             = br.player.power.runicPower.deficit()
    spell                                         = br.player.spell
    talent                                        = br.player.talent
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    var                                           = br.player.variables

    -- Units Declaration
    units.get(5)
    units.get(25)
    units.get(30)
    units.get(30,true)
    units.get(40)
    -- Enemies Declaration
    enemies.get(5)
    enemies.get(8)
    enemies.get(8,"target")
    enemies.get(8,"player",false,true) -- makes enemies.yards8f
    enemies.get(15)
    enemies.get(20)
    enemies.get(25)
    enemies.get(30)
    enemies.get(40)
    enemies.get(45)
    enemies.get(40,"player",true)

    -- Nil Checks
    if var.profileStop == nil then var.profileStop = false end
    -- variable,name=st_planning,value=active_enemies=1&(!raid_event.adds.exists|raid_event.adds.in>15)
    var.stPlanning = ui.useST(8,2)
    -- variable,name=major_cooldowns_active,value=pet.gargoyle.active|buff.unholy_assault.up|talent.army_of_the_damned&pet.apoc_ghoul.active|buff.dark_transformation.up
    var.deathAndDecayRemain = (cd.deathAndDecay.remain() - 10) > 0 and (cd.deathAndDecay.remain() - 10) or 0
    -- Path of Frost
    if ui.checked("Path of Frost") and cast.able.pathOfFrost() then
        if not unit.inCombat() and unit.swimming() and not buff.pathOfFrost.exists() then
            if cast.pathOfFrost() then ui.debug("Casting Path of Frost") return true end
        end
    end

    var.bloodDrinkerCheck = not cd.blooddrinker.exists() and 1 or 0

    if not var.controlledDead or not unit.exists(var.controlledDead) then var.controlledDead = "player" end

-----------------
--- Rotations ---
-----------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or ui.mode.rotation == 4 then
        if ui.checked("Auto Attack/Passive") and ui.pause(true) and br._G.IsPetAttackActive() then
            br._G.PetStopAttack()
            br._G.PetFollow()
        end
        return true
    else
--------------------
--- Pet Rotation ---
--------------------
        if actionList.PetManagement() then return true end
------------------------
-- DoD---
------------------------
        -- Cast Death and Decay
        if cast.able.deathAndDecay("best",nil,1,8) and buff.deathAndDecay.remains() < (unit.gcd(true) * 1.5)
            and charges.deathAndDecay.frac() >= 1.8 and unit.standingTime() > 3 and not buff.unholyGround.exists()  then
            if cast.deathAndDecay("best",nil,1,8) then  return true end
        end

            --marrowrend
        -- if ((buff.boneShield.remains() <= br.runeTimeTill(3)) or (buff.boneShield.remains("player") <= (unit.gcd("player") + var.bloodDrinkerCheck * (talent.blooddrinker and 1 or 0) * 2)) or (buff.boneShield.stack() < 3)) and runicPowerDeficit >= 20 then
        if runes > 2 and cast.able.marrowrend() and buff.boneShield.stack() < 8 then
            if cast.marrowrend() then
                return true
            end
        end
-----------------------
--- Extras Rotation ---
-----------------------
        if actionList.Extras() then return true end
--------------------------
--- Defensive Rotation ---
--------------------------
        if actionList.Defensive() then return true end
------------------------------
--- Out of Combat Rotation ---
------------------------------
        if actionList.PreCombat() then return true end
--------------------------
--- In Combat Rotation ---
--------------------------
        if unit.inCombat() and not var.profileStop and unit.exists("target") then
            -- auto_attack
            if cast.able.autoAttack("target") then
                if cast.autoAttack("target") then ui.debug("Casting Auto Attack") return true end
            end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
            if actionList.Interrupts() then return true end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
            if ui.value("APL Mode") == 1 then
                -- Augment Rune
                if ui.checked("Augment Rune") and use.able.battleScarredAugmentRune() and unit.instance("raid") then
                    use.battleScarredAugmentRune()
                    ui.debug("Using Augment Rune")
                end
                -- Call Action List - Trinkets
                -- call_action_list,name=trinkets
                if actionList.Trinkets() then return true end
                -- Call Action List - Covenants
                -- call_action_list,name=covenants
                if ui.alwaysCdNever("Covenant Ability") then
                    if actionList.Covenants() then return true end
                end
                -- Call Action List - Racials
                -- call_action_list,name=racials
                if actionList.Racials() then return true end
                -- Sequence
                -- sequence,if=active_enemies=1&!death_knight.disable_aotd,name=opener:army_of_the_dead:festering_strike:festering_strike:potion:unholy_blight:dark_transformation:apocalypse
                -- Call Action List - Cooldowns
                -- call_action_list,name=cooldowns
                if actionList.Cooldowns() then return true end
                -- Run Action List - AOE Burst
                -- Run Action List - Generic AOE
                -- run_action_list,name=generic_aoe,if=active_enemies>=2&(!death_and_decay.ticking&(cooldown.death_and_decay.remains>10&!talent.defile|cooldown.defile.remains>10&talent.defile))
                -- if ui.useAOE(8,2) and not buff.deathAndDecay.exists()
                --     and (cd.deathAndDecay.remains() > 10)
                -- then
                --     if actionList.Generic_AOE() then return true end
                -- end
                -- Call Action List - Generic
                -- call_action_list,name=generic
                if ui.useST(8,2) then
                    if actionList.Generic() then return true end
                end
            end -- End SimC APL
        end -- End Rotation
    end -- End Pause Check
end -- End runRotation

-- Add To Rotation List
local id = 250
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

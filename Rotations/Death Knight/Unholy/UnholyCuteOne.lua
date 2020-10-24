local rotationName = "CuteOne"
local br = _G["br"]
---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    local spell = br.player.spell
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of enemies in range.", highlight = 1, icon = spell.scourgeStrike },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = spell.scourgeStrike },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = spell.deathAndDecay },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = spell.deathCoil }
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = spell.armyOfTheDead },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = spell.armyOfTheDead },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = spell.armyOfTheDead }
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = spell.iceboundFortitude },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = spell.iceboundFortitude }
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = spell.mindFreeze }
    };
    CreateButton("Interrupt",4,0)
    -- Death And Decay Button
    DndModes = {
        [1] = { mode = "On", value = 1 , overlay = "DnD Enabled", tip = "Will use DnD.", highlight = 1, icon = spell.deathAndDecay },
        [2] = { mode = "Off", value = 2 , overlay = "DnD Disabled", tip = "will NOT use DnD.", highlight = 0, icon = spell.deathAndDecay }
    };
    CreateButton("Dnd",5,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable
    local section
    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
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
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Path of Frost
            br.ui:createCheckbox(section, "Path of Frost")
            -- Heart Essence
            br.ui:createCheckbox(section, "Use Essence")
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
            br.ui:createDropdownWithout(section, "Elixir", {"Flask of the Undertow","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
            -- Racial
            br.ui:createCheckbox(section, "Racial")
            -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use trinkets.")
            -- Ashvane's Razor Coral Stacks
            br.ui:createSpinnerWithout(section, "Ashvane's Razor Coral Stacks", 1, 1, 30, 1, "|cffFFBB00 Number of debuff stacks to cast trinket (Default=1 'SimC').")
            -- Azerite Beam Units
            br.ui:createSpinnerWithout(section, "Azerite Beam Units", 3, 1, 10, 1, "|cffFFBB00Number of Targets to use Azerite Beam on.")
            -- Apocalypse
            br.ui:createDropdownWithout(section, "Apocalypse", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Apocalypse.")
            -- Army of the Dead
            br.ui:createDropdownWithout(section, "Army of the Dead", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Army of the Dead.")
            -- Dark Transformation
            br.ui:createDropdownWithout(section, "Dark Transformation", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Dark Transformation.")
            -- Soul Reaper
            br.ui:createDropdownWithout(section, "Soul Reaper", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Soul Reaper.")
            -- Summon Gargoyle
            br.ui:createCheckbox(section, "Summon Gargoyle")
            -- Unholy BLight
            br.ui:createDropdownWithout(section, "Unholy Blight", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Unholy Blight.")
            -- Unholy Assault
            br.ui:createDropdownWithout(section, "Unholy Assault", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Unholy Assault.")
            br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to use at.")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to use at.")
            -- Anti-Magic Shell
            br.ui:createSpinner(section, "Anti-Magic Shell", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Death Strike
            br.ui:createSpinner(section, "Death Strike", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Death Pact
            br.ui:createSpinner(section, "Death Pact", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Icebound Fortitude
            br.ui:createSpinner(section, "Icebound Fortitude", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
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
local debuff
local enemies
local equiped
local essence
local pet
local race
local runes
local runeDeficit
local runesTTM
local runicPower
local runicPowerDeficit
local spell
local talent
local trait
local ui
local unit
local units
local use

-- General Locals
local actionList = {}
local var = {}

--------------------
--- Action Lists ---
--------------------
-- Action List - Pet Management
actionList.PetManagement = function()
    local function getCurrentPetMode()
        local slots = _G["NUM_PET_ACTION_SLOTS"]
        local petMode = "None"
        for i = 1, slots do
            local name, _, _,isActive = GetPetActionInfo(i)
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
    local waitForPetToAppear
    local validTarget = unit.exists("pettarget") or (not unit.exists("pettarget") and unit.valid("target")) or unit.isDummy("target")
    if petExists and br.deadPet then br.deadPet = false end
    if waitForPetToAppear == nil or IsMounted() or IsFlying() or UnitHasVehicleUI("player") or CanExitVehicle("player") then
        waitForPetToAppear = GetTime()
    elseif ui.checked("Raise Dead") then
        if waitForPetToAppear ~= nil and GetTime() - waitForPetToAppear > 2 then
            if cast.able.raiseDead() and (br.deadPet or (not br.deadPet and not petExists)
                or (talent.allWillServe and not pet.risenSkulker.exists()))
            then
                if cast.raiseDead() then waitForPetToAppear = GetTime(); ui.debug("Casting Raise Dead") return true end
            end
        end
    end
    if ui.checked("Auto Attack/Passive") then
        -- Set Pet Mode Out of Comat / Set Mode Passive In Combat
        if (not unit.inCombat() and petMode == "Passive") or (unit.inCombat() and (petMode == "Defensive" or petMode == "Passive")) then
            PetAssistMode()
            ui.debug("Setting Pet to Assist")
        elseif not unit.inCombat() and petMode == "Assist" and #enemies.yards40nc > 0 then
            PetDefensiveMode()
            ui.debug("Setting Pet to Defensive")
        elseif unit.inCombat() and petMode ~= "Passive" and #enemies.yards40 == 0 then
            PetPassiveMode()
            ui.debug("Setting Pet to Passive")
        end
        -- Pet Attack / retreat
        if (not UnitExists("pettarget") or not validTarget) and (unit.inCombat() or petCombat) then
            if ui.value("Pet Target") == 1 and unit.valid(units.dyn40) then
                PetAttack(units.dyn40)
            elseif ui.value("Pet Target") == 2 and validTarget then
                PetAttack("target")
            elseif ui.value("Pet Target") == 3 then
                for i=1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (unit.valid(thisUnit) or unit.isDummy(thisUnit)) then PetAttack(thisUnit); break end
                end
            end
        elseif (not unit.inCombat() or (unit.inCombat() and not validTarget and not unit.valid("target") and not unit.isDummy("target"))) and IsPetAttackActive() then
            PetStopAttack()
            PetFollow()
        end
    end
    -- Huddle
    if ui.checked("Huddle") and cast.able.huddle() and (unit.inCombat() or petCombat) and unit.hp("pet") <= ui.value("Huddle") then
        if cast.huddle() then ui.debug("Casting Huddle [Pet]") return true end
    end
    -- Claw
    if ui.checked("Claw") and cast.able.claw("pettarget") and not buff.huddle.exists("pet") and validTarget and unit.distance("pettarget","pet") < 5 then
        if cast.claw("pettarget") then ui.debug("Casting Claw [Pet]") return true end
    end
    -- Gnaw
    if ui.checked("Gnaw") and cast.able.gnaw() and not buff.huddle.exists("pet") then
        for i=1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if canInterrupt(thisUnit,ui.value("Interrupt At")) then
                if cast.gnaw(thisUnit) then ui.debug("Casting Gnaw [Pet]") return true end
            end
        end
    end
    -- Leap
    if ui.checked("Leap") and cast.able.leap("pettarget") and not buff.huddle.exists("pet") and validTarget and unit.distance("pettarget","pet") > 8 then
        if cast.leap("pettarget") then ui.debug("Casting Leap [Pet]") return true end
    end
end -- End Action List - Pet Management

-- Action List - Extras
actionList.Extras = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if getCombatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                StopAttack()
                ClearTarget()
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
    -- Control Undead
    if ui.checked("Control Undead") and cast.able.controlUndead() then
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if isUndead(thisUnit) and not unit.isDummy(thisUnit) and not unit.isBoss(thisUnit) and unit.level(thisUnit) <= unit.level() + 1 then
                if cast.controlUndead(thisUnit) then ui.debug("Casting Control Undead") return true end
            end
        end
    end
    -- Death Grip
    if ui.checked("Death Grip") and cast.able.deathGrip() then
        local thisUnit = talent.deathsReach and units.dyn40 or units.dyn30
        if unit.inCombat() and unit.distance(thisUnit) > 8 and ((talent.deathsReach and unit.distance(thisUnit) < 40) or unit.distance(thisUnit) < 30) and not unit.isDummy(thisUnit) then
            if cast.deathGrip() then ui.debug("Casting Death Grip") return true end
        end
    end
    -- Path of Frost
    if ui.checked("Path of Frost") and cast.able.pathOfFrost() then
        if not unit.inCombat() and unit.swimming() and not buff.pathOfFrost.exists() then
            if cast.pathOfFrost() then ui.debug("Casting Path of Frost") return true end
        end
    end
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    -- Anti-Magic Shell
    if ui.checked("Anti-Magic Shell") and cast.able.antiMagicShell() and unit.hp() < ui.value("Anti-Magic Shell") then
        if cast.antiMagicShell() then ui.debug("Casting Anti-Magic Shell") return true end
    end
    -- Death Strike
    if ui.checked("Death Strike") and cast.able.deathStrike() and (unit.hp() < ui.value("Death Strike") or buff.darkSuccor.exists()) then
        if cast.deathStrike() then ui.debug("Casting Death Strike") return true end
    end
    -- Death Pact
    if ui.checked("Death Pact") and cast.able.deathPact() and unit.hp() < ui.value("Death Pact") then
        if cast.deathPact() then ui.debug("Casting Death Pact") return true end
    end
    -- Icebound Fortitude
    if ui.checked("Icebound Fortitude") and cast.able.iceboundFortitude() and unit.hp() < ui.value("Icebound Fortitude") then
        if cast.iceboundFortitude() then ui.debug("Casting Icebound Fortitude") return true end
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
                if canInterrupt(thisUnit,ui.value("Interrupt At")) then
                    if cast.mindFreeze(thisUnit) then ui.debug("Casting Mind Freeze") return true end
                end
            end
        end
        --Asphyxiate
        if ui.checked("Asphyxiate") and cast.able.asphyxiate() and cd.mindFreeze.remain() > unit.gcd(true) then
            for i=1, #enemies.yards20 do
                local thisUnit = enemies.yards20[i]
                if canInterrupt(thisUnit,ui.value("Interrupt At")) then
                    if cast.asphyxiate(thisUnit) then ui.debug("Casting Asphyxiate") return true end
                end
            end
        end
        --Death Grip
        if ui.checked("Death Grip (Interrupt)") and cast.able.deathGrip() then
            local theseEnemies = talent.deathsReach and enemies.yards40 or enemies.yards30
            for i = 1,  #theseEnemies do
                local thisUnit = theseEnemies[i]
                if canInterrupt(thisUnit,ui.value("Interrupt At")) and unit.distance(thisUnit) > 8 then
                    if cast.deathGrip(thisUnit) then ui.debug("Casting Death Grip [Int]") return true end
                end
            end
        end
    end
end-- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    local groupTTD = 0
    for i = 1, #enemies.yards45 do
        local thisUnit = enemies.yards45[i]
        groupTTD = groupTTD + unit.ttd(thisUnit)
    end
    -- Army of the Dead
    -- army_of_the_dead
    if (ui.value("Army of the Dead") == 1 or (ui.value("Army of the Dead") == 2 and ui.useCDs()))
        and groupTTD >= ui.value("CDs TTD Limit") and cast.able.armyOfTheDead() 
    then
        if cast.armyOfTheDead() then ui.debug("Casting Army of the Dead") return true end
    end
    -- Apocalypse
    -- apocalypse,if=debuff.festering_wound.stack>=4&(active_enemies>=2|!essence.vision_of_perfection.enabled|!azerite.magus_of_the_dead.enabled|essence.vision_of_perfection.enabled&(talent.unholy_assault.enabled&cooldown.unholy_assault.remains<=3|!talent.unholy_assault.enabled))    
    if (ui.value("Apocalypse") == 1 or (ui.value("Apocalypse") == 2 and ui.useCDs()))
        and cast.able.apocalypse() and debuff.festeringWound.stack(units.dyn5) >= 4
        and (((ui.mode.rotation == 1 and #enemies.yards8 >= 2) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
            or not essence.visionOfPerfection.active or not trait.magusOfTheDead.active
            and (talent.unholyAssault and cd.unholyAssault.remain() <= 3 or not talent.unholyAssault))
        and groupTTD >= ui.value("CDs TTD Limit")
    then
        if cast.apocalypse(units.dyn5) then ui.debug("Casting Apocalypse") return true end
    end
    -- Dark Transformation
    -- dark_transformation,if=!raid_event.adds.exists|raid_event.adds.in>15
    if pet.active.exists() and cast.able.darkTransformation()
        and (ui.value("Dark Transformation") == 1 or (ui.value("Dark Transformation") == 2 and ui.useCDs())) and groupTTD >= ui.value("CDs TTD Limit")
    then
        if cast.darkTransformation() then ui.debug("Casting Dark Transformation") return true end
    end
    -- Summon Gargoyle
    -- summon_gargoyle,if=runic_power.deficit<14
    if ui.checked("Summon Gargoyle") and cast.able.summonGargoyle() and runicPowerDeficit < 14 and groupTTD >= ui.value("CDs TTD Limit") then
        if cast.summonGargoyle() then ui.debug("Casting Summon Gargoyle") return true end
    end
    -- Unholy Assault
    if (ui.value("Unholy Assault") == 1 or (ui.value("Unholy Assault") == 2 and ui.useCDs()))
        and cast.able.unholyAssault() and groupTTD >= ui.value("CDs TTD Limit")
    then
        -- unholy_assault,if=essence.vision_of_perfection.enabled&pet.apoc_ghoul.active|debuff.festering_wound.stack<4&!essence.vision_of_perfection.enabled&(!azerite.magus_of_the_dead.enabled|azerite.magus_of_the_dead.enabled&pet.apoc_ghoul.active)
        if essence.visionOfPerfection.active and pet.apocalypseGhoul.exists() or debuff.festeringWound.stack(units.dyn5) < 4
            and not essence.visionOfPerfection.active and (not trait.magusOfTheDead.active or trait.magusOfTheDead.active and pet.apocalypseGhoul.exists())
        then
            if cast.unholyAssault() then ui.debug("Casting Unholy Assauly") return true end
        end
        -- unholy_assault,if=active_enemies>=2&((cooldown.death_and_decay.remains<=gcd&!talent.defile.enabled)|(cooldown.defile.remains<=gcd&talent.defile.enabled))
        if ((ui.mode.rotation == 1 and #enemies.yards8 >= 2) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
            and ((cd.deathAndDecay.remain() <= unit.gcd(true) and not talent.defile) or (cd.defile.remain() <= unit.gcd(true) and talent.defile))
        then
            if cast.unholyAssault() then ui.debug("Casting Unholy Assault [AOE]") return true end
        end
    end
    -- Soul Reaper
    if (ui.value("Soul Reaper") == 1 or (ui.value("Soul Reaper") == 2 and ui.useCDs())) and cast.able.soulReaper() then
        -- soul_reaper,target_if=target.time_to_die<8&target.time_to_die>4
        if unit.ttd(units.dyn5) < 8 and unit.ttd(units.dyn5) > 4 then
            if cast.soulReaper() then ui.debug("Casting Soul Reaper") return true end
        end
        -- soul_reaper,if=(!raid_event.adds.exists|raid_event.adds.in>20)&rune<=(1-buff.unholy_assault.up)
        if ((ui.mode.rotation == 1 and #enemies.yards8 == 1) or (ui.mode.rotation == 3 and #enemies.yards8 > 0) or unit.isDummy())
            and runes <= (1 - var.frenzied) and groupTTD >= ui.value("CDs TTD Limit")
        then
            if cast.soulReaper() then ui.debug("Casting Soul Reaper [Low Runes]") return true end
        end
    end
    -- Unholy Blight
    -- unholu_blight
    if (ui.value("Unholy Assault") == 1 or (ui.value("Unholy Assault") == 2 and ui.useCDs())) and cast.able.unholyBlight("player","aoe",1,10) and groupTTD >= ui.value("CDs TTD Limit") then
        if cast.unholyBlight("player","aoe",1,10) then ui.debug("Casting Unholy Blight") return true end
    end
end -- End Action List - Cooldowns

-- Action List - Essences
actionList.Essences = function()
    if ui.checked("Use Essence") then
        -- Memory of Lucid Dreams
        -- memory_of_lucid_dreams,if=rune.time_to_1>gcd&runic_power<40
        if ui.useCDs() and cast.able.memoryOfLucidDreams() and runesTTM(1) > unit.gcd(true) and runicPower < 40 then
            if cast.memoryOfLucidDreams() then ui.debug("Casting Memory of Lucid Dreams") return true end
        end
        -- Blood of the Enemy
        -- blood_of_the_enemy,if=death_and_decay.ticking|pet.apoc_ghoul.active&active_enemies=1
        if ui.useCDs() and cast.able.bloodOfTheEnemy() and ((cd.deathAndDecay.remain() > 0 and #enemies.yards8t > 1)
            or (cd.defile.remain() > 0 and #enemies.yards8t > 1) or ((cd.apocalypse.remain() > 0 or var.apocBypass) and #enemies.yards5 == 1))
        then
            if cast.bloodOfTheEnemy() then ui.debug("Csating Blood of the Enemy") return true end
        end
        -- Guardian of Azeroth
        -- guardian_of_azeroth,if=cooldown.apocalypse.ready
        if ui.useCDs() and cast.able.guardianOfAzeroth() and cd.apocalypse.remain() == 0 then
            if cast.guardianOfAzeroth() then ui.debug("Casting Guardian of Azeroth") return true end
        end
        -- The Unbound Force
        -- the_unbound_force,if=buff.reckless_force.up|buff.reckless_force_counter.stack<11
        if cast.able.theUnboundForce() and (buff.recklessForce.exists() or buff.recklessForceCounter.stack() < 11) then
            if cast.theUnboundForce() then ui.debug("Casting The Unbound Force") return true end
        end
        -- Focused Azerite Beam
        -- focused_azerite_beam,if=!death_and_decay.ticking
        if cast.able.focusedAzeriteBeam() and (#enemies.yards8f >= ui.value("Azerite Beam Units") or (ui.useCDs() and #enemies.yards8f > 0)) and var.deathAndDecayRemain == 0  then
            local minCount = ui.useCDs() and 1 or ui.value("Azerite Beam Units")
            if cast.focusedAzeriteBeam(nil,"cone",minCount, 8) then ui.debug("Casting Focused Azerite Beam") return true end
        end
        -- Concentrated Flame
        -- concentrated_flame,if=dot.concentrated_flame_burn.remains=0
        if cast.able.concentratedFlame() and not debuff.concentratedFlame.exists(units.dyn5) then
            if cast.concentratedFlame() then ui.debug("Casting Concentrated Flame") return true end
        end
        -- Purifying Blast
        -- purifying_blast,if=!death_and_decay.ticking
        if ui.useCDs() and cast.able.purifyingBlast() and var.deathAndDecayRemain == 0 then
            if cast.purifyingBlast("best", nil, 1, 8) then ui.debug("") return true end
        end
        -- Worldvein Resonance
        -- worldvein_resonance,if=talent.army_of_the_damned.enabled&essence.vision_of_perfection.minor&buff.unholy_strength.up|essence.vision_of_perfection.minor&pet.apoc_ghoul.active|talent.army_of_the_damned.enabled&pet.apoc_ghoul.active&cooldown.army_of_the_dead.remains>60|talent.army_of_the_damned.enabled&pet.army_ghoul.active
        if cast.able.worldveinResonance() and talent.armyOfTheDamned and essence.visionOfPerfection.minor
            and buff.unholyStrength.exists() or essence.visionOfPerfection.minor and pet.apocalypseGhoul.active()
            or talent.armyOfTheDamned and pet.apocalypseGhoul.active() and cd.armyOfTheDead.remain() > 60
            or talent.armyOfTheDamned and pet.armyOfTheDead.active()
        then
            if cast.worldveinResonance() then ui.debug("Casting Worldvein Resonance [Army of the Dead]") return true end
        end
        -- worldvein_resonance,if=!death_and_decay.ticking&buff.unholy_strength.up&!essence.vision_of_perfection.minor&!talent.army_of_the_damned.enabled|target.time_to_die<cooldown.apocalypse.remains
        if cast.able.worldveinResonance() and var.deathAndDecayRemain == 0 and buff.unholyStrength.exists()
            and not essence.visionOfPerfection.minor and not talent.armyOfTheDamned
            or unit.ttd(units.dyn5) < cd.apocalypse.remain() or var.apocBypass
        then
            if cast.worldveinResonance() then ui.debug("Casting Worldvein Resonance") return true end
        end
        -- ripple_in_space,if=!death_and_decay.ticking
        if ui.useCDs() and cast.able.rippleInSpace() and var.deathAndDecayRemain == 0 then
            if cast.rippleInSpace() then ui.debug("Casting Ripple In Space") return true end
        end
        -- reaping_flames
        if cast.able.reapingFlames() then
            if cast.reapingFlames() then ui.debug("Casting Reaping Flames") return true end
        end
    end
end -- End Action List - Essences

-- Action List - AOE
actionList.AOE = function()
    -- Death and Decay
    -- death_and_decay,if=cooldown.apocalypse.remains
    if ui.mode.dnd == 1 and cast.able.deathAndDecay() and not talent.defile
        and (cd.apocalypse.remain() > 0 or var.apocBypass)
    then
        if cast.deathAndDecay("best",nil,1,8) then ui.debug("Casting Death and Decay") return true end
    end
    -- Defile
    -- defile,if=cooldown.apocalypse.remains
    if ui.mode.dnd == 1 and cast.able.defile() and cd.apocalypse.exists() then
        if cast.defile("best",nil,1,8) then ui.debug("Casting Defile") return true end
    end
    -- Epidemic
    -- epidemic,if=death_and_decay.ticking&runic_power.deficit<14&!talent.bursting_sores.enabled&!variable.pooling_for_gargoyle
    if cast.able.epidemic() and runicPowerDeficit < 14 and not talent.burstingSores and not var.poolForGargoyle then
        if cast.epidemic() then ui.debug("Casting Epidemic") return true end
    end
    -- epidemic,if=death_and_decay.ticking&(!death_knight.fwounded_targets&talent.bursting_sores.enabled)&!variable.pooling_for_gargoyle
    if cast.able.epidemic() and (not var.fwoundTargets and talent.burstingSores) and not var.poolForGargoyle then
        if cast.epidemic() then ui.debug("Casting Epidemic [Bursting Sores]") return true end
    end
    -- Scourge Strike
    -- scourge_strike,if=death_and_decay.ticking&cooldown.apocalypse.remains
    if cast.able.scourgeStrike() and not talent.clawingShadows and var.deathAndDecayRemain > 0 and cd.apocalypse.remain() > 0 then
        if cast.scourgeStrike() then ui.debug("Casting Scourge Strike [Apocalypse]") return true end
    end
    -- Clawing Shadows
    -- clawing_shadows,if=death_and_decay.ticking&cooldown.apocalypse.remains
    if cast.able.clawingShadows() and talent.clawingShadows and var.deathAndDecayRemain > 0 and cd.apocalypse.remain() > 0 then
        if cast.clawingShadows() then ui.debug("Casting Clawing Shadows [Apocalypse]") return true end
    end
    -- Epidemic
    -- epidemic,if=!variable.pooling_for_gargoyle
    if cast.able.epidemic() and not var.poolForGargoyle then
        if cast.epidemic() then ui.debug("Casting Epidemic [No Gargoyle Pool]") return true end
    end
    -- Festering Strike
    -- festering_strike,target_if=debuff.festering_wound.stack<=2&cooldown.death_and_decay.remains&cooldown.apocalypse.remains>5&(cooldown.army_of_the_dead.remains>5|death_knight.disable_aotd)
    if cast.able.festeringStrike() and cd.deathAndDecay.remain() > 0 and cd.apocalypse.remain() > 5
        and (cd.armyOfTheDead.reamins() > 5 or var.aotdBypass)
    then
        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if debuff.festeringWound.stack(thisUnit) <= 2 then
                if cast.festeringStrike(thisUnit) then ui.debug("Casting Festering Strike [Stack <= 2]") return true end
            end
        end
    end
    -- Death Coil
    -- death_coil,if=buff.sudden_doom.react&rune.time_to_4>gcd
    if cast.able.deathCoil() and buff.suddenDoom.exists() and runesTTM(4) > unit.gcd(true) then
        if cast.deathCoil() then ui.debug("Casting Death Coil [AOE Runes < 4]") return true end
    end
    -- death_coil,if=buff.sudden_doom.react&!variable.pooling_for_gargoyle|pet.gargoyle.exists
    if cast.able.deathCoil() and buff.suddenDoom.exists() and (not var.poolForGargoyle or pet.gargoyle.exists()) then
        if cast.deathCoil() then ui.debug("Casting Death Coil [AOE Gargoyle]") return true end
    end
    -- death_coil,if=runic_power.deficit<14&(cooldown.apocalypse.remains>5|debuff.festering_wound.stack>4)&!variable.pooling_for_gargoyle
    if cast.able.deathCoil() and runicPowerDeficit < 14 and not var.poolForGargoyle
        and (cd.apocalypse.remain() > 5 or var.apocBypass or debuff.festeringWound.stack(units.dyn5) > 4)
    then
        if cast.deathCoil() then ui.debug("Casting Death Coil [AOE Apoc/Fester]") return true end
    end
    -- Scourge Strike
    -- scourge_strike,target_if=((cooldown.army_of_the_dead.remains>5|death_knight.disable_aotd)&(cooldown.apocalypse.remains>5&debuff.festering_wound.stack>0|debuff.festering_wound.stack>4)&(target.1.time_to_die<cooldown.death_and_decay.remains+10|target.1.time_to_die>cooldown.apocalypse.remains))
    if cast.able.scourgeStrike() and not talent.clawingShadows then
        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if ((cd.armyOfTheDead.remain() > 5 or var.aotdBypass) and (cd.apocalypse.remain() > 5 and debuff.festeringWound.stack(units.dyn5) > 4) 
                and (unit.ttd(thisUnit) < cd.deathAndDecay.remain() + 10 or unit.ttd(thisUnit) > cd.apocalypse.remain()))
            then
                if cast.scourgeStrike() then ui.debug("Casting Scourge Strike [Apoc/Fester]") return true end
            end
        end
    end
    -- Clawing Shadows
    -- clawing_shadows,target_if=((cooldown.army_of_the_dead.remains>5|death_knight.disable_aotd)&(cooldown.apocalypse.remains>5&debuff.festering_wound.stack>0|debuff.festering_wound.stack>4)&(target.1.time_to_die<cooldown.death_and_decay.remains+10|target.1.time_to_die>cooldown.apocalypse.remains))
    if cast.able.clawingShadows() and talent.clawingShadows then
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if ((cd.armyOfTheDead.remain() > 5 or var.aotdBypass) and (cd.apocalypse.remain() > 5 and debuff.festeringWound.stack(units.dyn5) > 4) 
                and (unit.ttd(thisUnit) < cd.deathAndDecay.remain() + 10 or unit.ttd(thisUnit) > cd.apocalypse.remain()))
            then
                if cast.clawingShadows() then ui.debug("Casting Clawing Shadows [Apoc/Fester]") return true end
            end
        end
    end
    -- Death Coil
    -- death_coil,if=runic_power.deficit<20&!variable.pooling_for_gargoyle
    if cast.able.deathCoil() and runicPowerDeficit < 20 and not var.poolForGargoyle then
        if cast.deathCoil() then ui.debug("Death Coil [AOE High Runic Power]") return true end
    end
    -- Festering Strike
    -- festering_strike,if=((((debuff.festering_wound.stack<4&!buff.unholy_assault.up)|debuff.festering_wound.stack<3)&cooldown.apocalypse.remains<3)|debuff.festering_wound.stack<1)&(cooldown.army_of_the_dead.remains>5|death_knight.disable_aotd)
    if cast.able.festeringStrike() and (cd.armyOfTheDead.remain() > 5 or var.aotdBypass)
        and ((((debuff.festeringWound.stack(units.dyn5) < 4 and not buff.unholyAssault.exists())
            or debuff.festeringWound.stack(units.dyn5) < 3) and cd.apocalypse.remain() < 3)
                or debuff.festeringWound.stack(units.dyn5) < 1)
    then
        if cast.festeringStrike(units.dyn5) then ui.debug("Casting Festering Wounds [AOE Stacker]") return true end
    end
    -- Death Coil
    -- death_coil,if=!variable.pooling_for_gargoyle
    if cast.able.deathCoil() and not var.poolForGargoyle then
        if cast.deathCoil() then ui.debug("Casting Death Coil [AOE Dump]") return true end
    end
end -- End Action List - AOE

-- Action List - Generic
actionList.Single = function()
    -- Death Coil
    -- death_coil,if=buff.sudden_doom.react&rune.time_to_4>gcd&!variable.pooling_for_gargoyle|pet.gargoyle.active
    if cast.able.deathCoil() and buff.suddenDoom.exists() and runesTTM(4) > unit.gcd(true)
        and (not var.poolForGargoyle or pet.gargoyle.exists())
    then
        if cast.deathCoil() then ui.debug("Death Coil [ST Low Runes]") return true end
    end
    -- death_coil,if=runic_power.deficit<14&rune.time_to_4>gcd&!variable.pooling_for_gargoyle
    if cast.able.deathCoil() and runicPowerDeficit < 14 and runesTTM(4) > unit.gcd(true) and not var.poolForGargoyle then
        if cast.deathCoil() then ui.debug("Death Coil [ST High Runic Power & Low Runes]") return true end
    end
    -- Scourge Strike
    -- scourge_strike,if=debuff.festering_wound.up
    if cast.able.scourgeStrike() and not talent.clawingShadows and debuff.festeringWound.exists(units.dyn5) then
        if cast.scourgeStrike() then ui.debug("Casting Scourge Strike [ST Festering Wounds]") return true end
    end
    -- Clawing Shadows
    -- clawing_shadows,if=debuff.festering_wound.up&(cooldown.apocalypse.remains>5|debuff.festering_wound.stack>4)
    if cast.able.clawingShadows() and talent.clawingShadows and debuff.festeringWound.exists(units.dyn5)
        and (cd.apocalypse.remain() > 5 or debuff.festeringWound.stack(units.dyn5) > 4)
    then
        if cast.clawingShadows() then ui.debug("Casting Clawing Shadows [ST]") return true end
    end
    -- Death Coil
    -- death_coil,if=runic_power.deficit<20&!variable.pooling_for_gargoyle
    if cast.able.deathCoil() and runicPowerDeficit < 20 and not var.poolForGargoyle then
        if cast.deathCoil() then ui.debug("Casting Death Coil [ST High Runic Power]") return true end
    end
    -- Festering Strike
    -- festering_strike,if=debuff.festering_wound.stack<4&cooldown.apocalypse.remains<3|debuff.festering_wound.stack<1
    if cast.able.festeringStrike() and debuff.festeringWound.stack(units.dyn5) < 4
        and (cd.apocalypse.remain() < 3 or debuff.festeringWound.stack() < 1)
    then
        if cast.festeringStrike(units.dyn5) then ui.debug("Casting Festering Strike [ST]") return true end
    end
    -- Death Coil
    -- death_coil,if=!variable.pooling_for_gargoyle
    if cast.able.deathCoil() and not var.poolForGargoyle then
        if cast.deathCoil() then ui.debug("Casting Death Coil [ST Dump]") return true end
    end
end -- End Action List - Single

-- Action List - PreCombat
actionList.PreCombat = function()
    -- Flask / Crystal
    -- flask,type=flask_of_the_seventh_demon
    if ui.value("Elixir") == 1 and var.inRaid and not buff.flaskOfTheUndertow.exists() and use.able.flaskOfTheUndertow() then
        if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
        if buff.felFocus.exists() then buff.felFocus.cancel() end
        if use.flaskOfTheUndertow() then ui.debug("Using Flask of the Undertow") return true end
    end
    if ui.value("Elixir") == 2 and not buff.felFocus.exists() and use.able.repurposedFelFocuser() then
        if buff.flaskOfTheUndertow.exists() then buff.flaskOfTheUndertow.cancel() end
        if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
        if use.repurposedFelFocuser() then ui.debug("Using Repurposed Fel Focuser") return true end
    end
    if ui.value("Elixir") == 3 and not buff.whispersOfInsanity.exists() and use.able.oraliusWhisperingCrystal() then
        if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
        if buff.felFocus.exists() then buff.felFocus.cancel() end
        if use.oraliusWhisperingCrystal() then ui.debug("Using Oralius Whispering Crystal") return true end
    end
    -- Pre-pull
    if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
        -- Potion
        if ui.checked("Potion") and use.able.battlePotionOfStrength() and ui.useCDs() and var.inRaid then
            use.battlePotionOfStrength()
            ui.debug("Using Battle Potion of Strength")
        end
        -- Army of the Dead
        if ui.checked("Army of the Dead") and ui.useCDs() and ui.pullTimer() <= 2 then
            if cast.armyOfTheDead() then ui.debug("Casting Army of the Dead [Pre-Pull]") return true end
        end
        -- Azshara's Font of Power
        if (ui.value("Trinkets") == 1 or (ui.value("Trinkets") == 2 and ui.useCDs())) and equiped.azsharasFontOfPower() 
            and use.able.azsharasFontOfPower() and not unit.moving("player") and not unit.inCombat() and ui.pullTimer()<= ui.value("Pre-Pull Timer")
        then
            if use.azsharasFontOfPower() then ui.debug("Using Azshara's Font of Power [Pre-Pull]") return true end
        end               
    end 
    -- Pull
    if unit.valid("target") and not unit.inCombat() then
        -- Death Grip
        if ui.checked("Death Grip - Pre-Combat") and cast.able.deathGrip("target") and not unit.isDummy("target")
            and unit.distance("target") > 8 and ((talent.deathsReach and unit.distance("target") < 40) or unit.distance("target") < 30)
        then
            if cast.deathGrip("target") then ui.debug("Casting Death Grip [Pull]") return true end
        end
        -- Dark Command
        if ui.checked("Dark Command") and cast.able.darkCommand("target") and not (ui.checked("Death Grip") or cast.able.deathGrip("target")) then
            if cast.darkCommand("target") then ui.debug("Casting Dark Command [Pull]") return true end
        end
        -- Start Attack
        StartAttack()
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
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    equiped                                       = br.player.equiped
    essence                                       = br.player.essence
    pet                                           = br.player.pet
    race                                          = br.player.race
    runes                                         = br.player.power.runes.amount()
    runeDeficit                                   = br.player.power.runes.deficit()
    runesTTM                                      = br.player.power.runes.ttm
    runicPower                                    = br.player.power.runicPower.amount()
    runicPowerDeficit                             = br.player.power.runicPower.deficit()
    spell                                         = br.player.spell
    talent                                        = br.player.talent
    trait                                         = br.player.traits
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    -- Other Locals
    var.apocBypass                                = nil
    var.inRaid                                    = br.player.instance=="raid"
    var.combatTime                                = getCombatTime()

    -- Units Declaration
    units.get(5)
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
    enemies.get(30)
    enemies.get(40)
    enemies.get(45)
    enemies.get(40,"player",true)
    enemies.yards8r = getEnemiesInRect(10,20,false) or 0

    -- Nil Checks
    if var.profileStop == nil then var.profileStop = false end

    -- Numeric Returns
    if buff.unholyAssault.exists() then var.frenzied = 1 else var.frenzied = 0 end

    -- Variables
    -- variable,name=pooling_for_gargoyle,value=cooldown.summon_gargoyle.remains<5&talent.summon_gargoyle.enabled
    var.poolForGargoyle = cd.summonGargoyle.remain() < 5 and talent.summonGargoyle
    var.deathAndDecayRemain = 0
    if (cd.deathAndDecay.remain() - 10) > 0 then var.deathAndDecayRemain = (cd.deathAndDecay.remain() - 10) end
    var.apocBypass = ui.value("Apocalypse") == 3 or (ui.value("Apocalypse") == 2 and not ui.useCDs()) or not spell.known.apocalypse()
    var.aotdBypass = ui.value("Army of the Dead") == 3 or (ui.value("Army of the Dead") == 2 and not ui.useCDs()) or not spell.known.armyOfTheDead()
    var.fwoundTargets = false
    for i = 1, #enemies.yards5 do
        local thisUnit = enemies.yards5[i]
        if debuff.festeringWound.stack(thisUnit) > 0 then
            var.fwoundTargets = true
            break
        end
    end

    --Asphyxiate Logic
    local Asphyxiate_unitList = {
        [131009] = "Spirit of Gold",
        [134388] = "A Knot of Snakes",
        [129758] = "Irontide Grenadier"
    }
-----------------
--- Rotations ---
-----------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or pause() or ui.mode.rotation == 4 then
        if ui.checked("Auto Attack/Passive") and pause(true) and IsPetAttackActive() then
            PetStopAttack()
            PetFollow()
        end
        return true
    else
--------------------
--- Pet Rotation ---
--------------------
        if actionList.PetManagement() then return true end
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
            if not IsAutoRepeatSpell(GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                StartAttack(units.dyn5)
            end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
            if actionList.Interrupts() then return true end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
            if ui.value("APL Mode") == 1 then
                if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    -- Racial                    
                    if ui.checked("Racial") and cast.able.racial()
                        -- arcane_torrent,if=runic_power.deficit>65&(pet.gargoyle.active|!talent.summon_gargoyle.enabled)&rune.deficit>=5
                        and ((race == "BloodElf" and runicPowerDeficit > 65 and (pet.gargoyle.exists() or not talent.summonGargoyle) and runeDeficit >= 5)
                        -- blood_fury,if=pet.gargoyle.active|!talent.summon_gargoyle.enabled
                        or (race == "Orc" and (pet.gargoyle.exists() or not talent.summonGargoyle))
                        -- berserking,if=buff.unholy_assault.up|pet.gargoyle.active|(talent.army_of_the_damned.enabled&pet.apoc_ghoul.active)
                        or (race == "Troll" and (buff.unholyAssault.exists() or pet.gargoyle.exists() or (talent.armyOfTheDamned and pet.apocalypseGhoul.exists()))
                        -- lights_judgment,if=(buff.unholy_strength.up&buff.festermight.remains<=5)|active_enemies>=2&(buff.unholy_strength.up|buff.festermight.remains<=5)
                        or (race == "LightforgedDraenei" and (buff.unholyStrength and buff.festermight.remains() <= 5 
                            or ((ui.mode.rotation == 1 and #enemies.yards8 >= 2) or (ui.mode.rotation == 2 and #enemies.yards8 > 0)) and (buff.unholyStrength and buff.festermight.remains() <= 5)))
                        -- ancestral_call,if=(pet.gargoyle.active&talent.summon_gargoyle.enabled)|pet.apoc_ghoul.active
                        or (race == "MagharOrc" and ((pet.gargoyle.exists() and talent.summonGargoyle) or pet.apocalypseGhoul.exists()))
                        -- arcane_pulse,if=active_enemies>=2|(rune.deficit>=5&runic_power.deficit>=60)
                        or (race == "Nightborne" and ((ui.mode.rotation == 1 and #enemies.yards8 >= 2) or (ui.mode.rotation == 2 and #enemies.yards8 > 0) or (runeDeficit >= 5 and runicPowerDeficit >= 60)))
                        -- fireblood,if=(pet.gargoyle.active&talent.summon_gargoyle.enabled)|pet.apoc_ghoul.active
                        or (race == "DarkIronDwarf" and ((pet.gargoyle.exists() and talent.summonGargoyle) or pet.apocalypseGhoul.exists()))
                        -- bag_of_tricks,if=buff.unholy_strength.up&active_enemies=1|buff.festermight.remains<gcd&active_enemies=1
                        ))
                    then
                        if cast.racial("player") then ui.debug("Casting Racial") return true end
                    end
                    -- Augment Rune
                    if ui.checked("Augment Rune") and use.able.battleScarredAugmentRune() and var.inRaid then
                        use.battleScarredAugmentRune()
                        ui.debug("Using Augment Rune")
                    end
                    -- Trinkets
                    if (ui.value("Trinkets") == 1 or (ui.value("Trinkets") == 2 and ui.useCDs())) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                        for i = 13, 14 do
                            if use.able.slot(i) then
                                -- All Others
                                -- use_items,if=time>20|!equipped.ramping_amplitude_gigavolt_engine|!equipped.vision_of_demise
                                if var.combatTime > 20 or not (equiped.azsharasFontOfPower(i) or equiped.ashvanesRazorCoral(i) or equiped.visionOfDemise(i)
                                    or equiped.rampingAmplitudeGigavoltEngine(i) or equiped.bygoneBeeAlmanac(i)
                                    or equiped.jesHowler(i) or equiped.galecallersBeak(i) or equiped.grongsPrimalRage(i))
                                then
                                    use.slot(i)
                                    ui.debug("Using Trinket [Slot "..i.."]")
                                end
                                -- Azshara's Font of Power
                                -- actions+=/use_item,name=azsharas_font_of_power,if=(essence.vision_of_perfection.enabled&!talent.unholy_frenzy.enabled)|(!essence.condensed_lifeforce.major&!essence.vision_of_perfection.enabled)
                                if equiped.azsharasFontOfPower(i) and ((essence.visionOfPerfection.active and not talent.unholyAssault) 
                                    or (not essence.condensedLifeForce.major and not essence.visionOfPerfection.active)) and not unit.moving()
                                then
                                    use.slot(i)
                                    ui.debug("Using Azshara's Font of Power")
                                end  
                                -- actions+=/use_item,name=azsharas_font_of_power,if=cooldown.apocalypse.remains<14&(essence.condensed_lifeforce.major|essence.vision_of_perfection.enabled&talent.unholy_frenzy.enabled)
                                if equiped.azsharasFontOfPower(i) and cd.apocalypse.remain() < 14 and (essence.condensedLifeForce.major or essence.visionOfPerfection.active) and talent.unholyAssault and not unit.moving() then
                                    use.slot(i)
                                    ui.debug("Using Azshara's Font of Power")
                                end
                                -- actions+=/use_item,name=azsharas_font_of_power,if=target.1.time_to_die<cooldown.apocalypse.remains+34
                                if equiped.azsharasFontOfPower(i) and  unit.ttd(units.dyn5) < cd.apocalypse.remain() + 34 and not unit.moving() then
                                    use.slot(i)
                                    ui.debug("Using Azshara's Font of Power")
                                end
                                -- Ashvanes Razor Coral
                                -- use_item,name=ashvanes_razor_coral,if=debuff.razor_coral_debuff.stack<1
                                if equiped.ashvanesRazorCoral(i) and (cd.azsharasFontOfPower.remain() > 0 or not equiped.azsharasFontOfPower()) and debuff.razorCoral.stack(units.dyn5) == ui.value("Ashvane's Razor Coral Stacks") then
                                    use.slot(i)
                                    ui.debug("Using Ashvane's Razor Coral")
                                end
                                -- use_item,name=ashvanes_razor_coral,if=(pet.guardian_of_azeroth.active&pet.apoc_ghoul.active)|(cooldown.apocalypse.remains<gcd&!essence.condensed_lifeforce.enabled&!talent.unholy_frenzy.enabled)|(target.1.time_to_die<cooldown.apocalypse.remains+20)|(cooldown.apocalypse.remains<gcd&target.1.time_to_die<cooldown.condensed_lifeforce.remains+20)|(buff.unholy_frenzy.up&!essence.condensed_lifeforce.enabled)
                                if equiped.ashvanesRazorCoral(i) and (cd.azsharasFontOfPower.remain() > 0 or not equiped.azsharasFontOfPower()) and ((pet.guardianOfAzeroth.exists() and pet.apocalypseGhoul.exists())
                                    or (cd.apocalypse.remain() < unit.gcd(true) and not essence.condensedLifeForce.active and not talent.unholyAssault)
                                    or (unit.ttd(units.dyn5) < cd.apocalypse.remain() + 20) or (cd.apocalypse.remain() < unit.gcd(true) and unit.ttd(units.dyn5) < cd.guardianOfAzeroth.remain() + 20)
                                    or (buff.unholyAssault.exists() and not essence.condensedLifeForce.active))
                                then
                                    use.slot(i)
                                    ui.debug("Using Ashvane's Razor Coral")
                                end
                                -- Vision of Demise
                                -- use_item,name=vision_of_demise,if=(cooldown.apocalypse.ready&debuff.festering_wound.stack>=4&essence.vision_of_perfection.enabled)|buff.unholy_frenzy.up|pet.gargoyle.exists
                                if equiped.visionOfDemise(i) and ((cd.apocalypse.remain() == 0 and debuff.festeringWound.stack(units.dyn5) >= 4
                                    and essence.visionOfPerfection.active) or buff.unholyAssault.exists() or pet.gargoyle.exists())
                                then
                                    use.slot(i)
                                    ui.debug("Using Vision of Demise")
                                end
                                -- Ramping Amplitude Gigavolt Engine
                                -- use_item,name=ramping_amplitude_gigavolt_engine,if=cooldown.apocalypse.remains<2|talent.army_of_the_damned.enabled|raid_event.adds.in<5
                                if equiped.rampingAmplitudeGigavoltEngine(i) and (cd.apocalypse.remain() < 2 or talent.armyOfTheDamned) then
                                    use.slot(i)
                                    ui.debug("Using Rampaging Gigavolt Engine")
                                end
                                -- Bygone Bee Almanac
                                -- use_item,name=bygone_bee_almanac,if=cooldown.summon_gargoyle.remains>60|!talent.summon_gargoyle.enabled&time>20|!equipped.ramping_amplitude_gigavolt_engine
                                if equiped.bygoneBeeAlmanac(i) and (cd.summonGargoyle.remain() > 60
                                    or (not talent.summonGargoyle and var.combatTime > 20) or not equiped.rampingAmplitudeGigavoltEngine(i))
                                then
                                    use.slot(i)
                                    ui.debug("Using Bygone Bee ALmanac")
                                end
                                -- Jes Howler
                                -- use_item,name=jes_howler,if=pet.gargoyle.exists|!talent.summon_gargoyle.enabled&time>20|!equipped.ramping_amplitude_gigavolt_engine
                                if equiped.jesHowler(i) and (pet.gargoyle.exists() or (not talent.summonGargoyle and var.combatTime > 20)
                                    or not equiped.rampingAmplitudeGigavoltEngine(i))
                                then
                                    use.slot(i)
                                    ui.debug("Using Jes Howler")
                                end
                                -- Galecaller's Beak
                                -- use_item,name=galecallers_beak,if=pet.gargoyle.exists|!talent.summon_gargoyle.enabled&time>20|!equipped.ramping_amplitude_gigavolt_engine
                                if equiped.galecallersBeak(i) and (pet.gargoyle.exists() or (not talent.summonGargoyle and var.combatTime > 20)
                                    or not equiped.rampingAmplitudeGigavoltEngine(i))
                                then
                                    use.slot(i)
                                    ui.debug("Using Galecaller's Beak")
                                end
                                -- Grong's Primal Rage
                                -- use_item,name=grongs_primal_rage,if=rune<=3&(time>20|!equipped.ramping_amplitude_gigavolt_engine)
                                if equiped.grongsPrimalRage(i) and runes <= 3 and (var.combatTime > 20 or not equiped.rampingAmplitudeGigavoltEngine()) then
                                    use.slot(i)
                                    ui.debug("Using Grong's Primal Rage")
                                end
                            end
                        end
                    end
                    -- Potion
                    -- potion,if=cooldown.army_of_the_dead.ready|pet.gargoyle.exists|buff.unholy_frenzy.up
                    if ui.checked("Potion") and var.inRaid and ui.useCDs() and use.able.battlePotionOfStrength()
                        and (cd.armyOfTheDead.remain() == 0 or pet.gargoyle.exists() or buff.unholyAssault.exists())
                    then
                        use.battlePotionOfStrength()
                        ui.debug("Using Battle Potion of Strength")
                    end
                    -- Outbreak
                    -- outbreak,target_if=dot.virulent_plague.remains<=gcd
                    if cast.able.outbreak(units.dyn30AOE) and debuff.virulentPlague.remain(units.dyn30AOE) <= unit.gcd(true) then
                        if cast.outbreak(units.dyn30AOE) then ui.debug("Casting Outbreak") return true end
                    end
                    -- Call Action List - Essences
                    -- call_action_list,name=essences
                    if actionList.Essences() then return true end
                    -- Call Action List - Cooldowns
                    -- call_action_list,name=cooldowns
                    if actionList.Cooldowns() then return true end
                end
                -- Run Action List - AOE
                -- run_action_list,name=aoe,if=active_enemies>=2
                if ((ui.mode.rotation == 1 and #enemies.yards8 >= 2) or (ui.mode.rotation == 2 and #enemies.yards8 > 0)) then
                    if actionList.AOE() then return true end
                end
                -- Call Action List - Single
                -- call_action_list,name=generic
                if ((ui.mode.rotation == 1 and #enemies.yards8 < 2) or (ui.mode.rotation == 3 and #enemies.yards8 > 0)) then
                    if actionList.Single() then return true end
                end
            end -- End SimC APL
        end -- End Rotation
    end -- End Pause Check
end -- End runRotation

-- Add To Rotation List
local id = 252
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

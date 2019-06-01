local rotationName = "CuteOne" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.serpentSting },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.carve },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.raptorStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.exhilaration}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.aspectOfTheEagle },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.aspectOfTheEagle },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.aspectOfTheEagle }
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.aspectOfTheTurtle },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.aspectOfTheTurtle }
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.muzzle },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.muzzle }
    };
    CreateButton("Interrupt",4,0)
    -- Harpoon Button 
    HarpoonModes = {
        [1] = { mode = "On", value = 1 , overlay = "Harpoon Enabled", tip = "Will cast Harpoon.", highlight = 1, icon = br.player.spell.harpoon },
        [2] = { mode = "Off", value = 2 , overlay = "Harpoon Disabled", tip = "Will NOT cat Harpoon.", highlight = 0, icon = br.player.spell.harpoon }
    };
    CreateButton("Harpoon",5,0)
    -- MD Button
    MisdirectionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    CreateButton("Misdirection",6,0)
    --Pet summon
    PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Summon Pet 1", tip = "Summon Pet 1", highlight = 1, icon = br.player.spell.callPet1 },
        [2] = { mode = "2", value = 2 , overlay = "Summon Pet 2", tip = "Summon Pet 2", highlight = 1, icon = br.player.spell.callPet2 },
        [3] = { mode = "3", value = 3 , overlay = "Summon Pet 3", tip = "Summon Pet 3", highlight = 1, icon = br.player.spell.callPet3 },
        [4] = { mode = "4", value = 4 , overlay = "Summon Pet 4", tip = "Summon Pet 4", highlight = 1, icon = br.player.spell.callPet4 },
        [5] = { mode = "5", value = 5 , overlay = "Summon Pet 5", tip = "Summon Pet 5", highlight = 1, icon = br.player.spell.callPet5 },
        [6] = { mode = "None", value = 6 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.callPet }
    };
    CreateButton("PetSummon",7,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Harpoon
            br.ui:createCheckbox(section, "Harpoon - Opener")
            -- Misdirection
            br.ui:createDropdownWithout(section,"Misdirection", {"|cff00FF00Tank","|cffFFFF00Focus","|cffFF0000Pet"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
            -- Opener
            br.ui:createDropdownWithout(section, "Opener", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use opener.")
        br.ui:checkSectionState(section)
        -- Pet Options
        section = br.ui:createSection(br.ui.window.profile, "Pet")
            -- Auto Summon
            -- br.ui:createDropdown(section, "Auto Summon", {"Pet 1","Pet 2","Pet 3","Pet 4","Pet 5","No Pet"}, 1, "Select the pet you want to use")
            br.ui:createDropdownWithout(section, "Pet Target", {"Dynamic Unit", "Only Target", "Any Unit"},1,"Select how you want pet to acquire targets.")
            -- Auto Attack/Passive
            br.ui:createCheckbox(section, "Auto Attack/Passive")
            -- Auto Growl
            br.ui:createCheckbox(section, "Auto Growl")
            -- Cat-like Reflexes
            br.ui:createSpinner(section, "Cat-like Reflexes", 30, 0, 100, 5, "|cffFFFFFFPet Health Percent to Cast At")
            -- Claw
            br.ui:createCheckbox(section, "Claw")
            -- Dash
            br.ui:createCheckbox(section, "Dash")
            -- Play Dead / Wake Up
            br.ui:createSpinner(section, "Play Dead / Wave Up", 25,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Prowl
            br.ui:createCheckbox(section, "Prowl")
            -- Mend Pet
            br.ui:createSpinner(section, "Mend Pet",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Purge
            br.ui:createDropdown(section, "Purge", {"Every Unit","Only Target"}, 2, "Select if you want Purge only Target or every Unit arround the Pet")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Seventh Demon","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- A Murder of Crows
            br.ui:createDropdownWithout(section,"A Murder of Crows", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
            -- Aspect of the Eagle
            br.ui:createDropdownWithout(section,"Aspect of the Eagle", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
            -- Coordinated Assault
            br.ui:createDropdownWithout(section,"Coordinated Assault", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Aspect Of The Turtle
            br.ui:createSpinner(section, "Aspect Of The Turtle",  40,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Exhilaration
            br.ui:createSpinner(section, "Exhilaration",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Feign Death
            br.ui:createSpinner(section, "Feign Death", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Intimidation
            br.ui:createSpinner(section, "Intimidation", 35, 0, 100, 5,  "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Freezing Trap
            br.ui:createCheckbox(section,"Freezing Trap")
            -- Intimidation
            br.ui:createCheckbox(section,"Intimidation - Int")
            -- Muzzle
            br.ui:createCheckbox(section,"Muzzle")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupts",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  6)
            -- Cooldown Key Toggle
            br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle,  6)
            -- Defensive Key Toggle
            br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
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

--------------
--- Locals ---
--------------
-- BR API Locals
local buff
local cast
local cd
local charges
local debuff
local enemies
local focus
local focusMax
local focusRegen
local gcd
local gcdMax
local has
local inCombat
local inRaid
local item
local mode
local opener
local php
local potion
local race
local spell
local talent
local traits
local ttm
local units
local use
-- General Locals
local combatTime
local flying
local hastar
local healPot
local petCombat
local profileStop
local pullTimer
local ttd
-- Profile Specific Locals
local actionList = {}
local carveCdr
local lowestBloodseeker
local lowestSerpentSting
local lowestInternalBleeding
local maxLatentPoison
local thisRange

-----------------
--- Functions ---
-----------------

-- Custom Profile Functions
local function focusTimeTill(amount)
    if focus >= amount then return 0.5 end
    return ((amount-focus)/focusRegen)+0.5
end

local function castRegen(spellID)
    if GetSpellInfo(spellID) ~= nil then
        local desc = GetSpellDescription(spellID)
        local generates = desc:gsub("%D+", "")
        local amount = generates:sub(-2)
        return tonumber(amount)
    else
        return 0
    end
end

local function nextBomb(nextBomb)
    local _,_,currentBomb = GetSpellInfo(spell.wildfireBomb)
    local _,_,shrapnelBomb = GetSpellInfo(spell.shrapnelBomb)
    local _,_,volatileBomb = GetSpellInfo(spell.volatileBomb)
    local _,_,pheromoneBomb = GetSpellInfo(spell.pheromoneBomb)
    if talent.wildfireInfusion and nextBomb ~= nil then
        if currentBomb == shrapnelBomb then return nextBomb == spell.shrapnelBomb end -- spell.volatileBomb
        if currentBomb == volatileBomb then return nextBomb == spell.volatileBomb end -- spell.pheromoneBomb
        if currentBomb == pheromoneBomb then return nextBomb == spell.pheromoneBomb end -- spell.shrapnelBomb
    else
        return nextBomb == spell.wildfireBomb
    end
    return currentBomb == nextBomb
end

local function eagleScout()
    if buff.aspectOfTheEagle.exists() then
        return #enemies.yards40
    else
        return #enemies.yards5
    end
end

-- Multi-Dot HP Limit Set
local function canDoT(unit)
    if not isBoss() then return true end
    local unitHealthMax = UnitHealthMax(unit)
    local maxHealth = 0
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        local thisMaxHealth = UnitHealthMax(thisUnit)
        if thisMaxHealth > maxHealth then 
            maxHealth = thisMaxHealth 
        end 
    end 
    return unitHealthMax > maxHealth / 10
end

--------------------
--- Action Lists ---
--------------------
actionList = {}
-- Action List - Pet Management
actionList.PetManagement = function()
    local function getCurrentPetMode()
        local petMode = "None"
        for i = 1, NUM_PET_ACTION_SLOTS do
            local name, _, _, _, isActive = GetPetActionInfo(i)
            if isActive then
                if name == "PET_MODE_ASSIST" then petMode = "Assist" end
                if name == "PET_MODE_DEFENSIVE" then petMode = "Defensive" end
                if name == "PET_MODE_PASSIVE" then petMode = "Passive" end
            end
        end
        return petMode
    end

    local petActive = IsPetActive()
    local petExists = UnitExists("pet")
    local petCombat = UnitAffectingCombat("pet")
    local petDead = UnitIsDeadOrGhost("pet")
    local petMode = getCurrentPetMode()
    local validTarget = isValidUnit("pettarget") or (not UnitExists("pettarget") and isValidTarget("target"))

    if IsMounted() or flying or UnitHasVehicleUI("player") or CanExitVehicle("player") then
        waitForPetToAppear = GetTime()
    elseif mode.petSummon ~= 6 then
        local callPet = spell["callPet"..mode.petSummon]
        if waitForPetToAppear ~= nil and GetTime() - waitForPetToAppear > 2 then
            if cast.able.dismissPet() and petExists and petActive and (callPet == nil or UnitName("pet") ~= select(2,GetCallPetSpellInfo(callPet))) then
                if cast.dismissPet() then waitForPetToAppear = GetTime(); return true end
            elseif callPet ~= nil then
                if petDead or deadPet then
                    if cast.able.revivePet() then
                        if cast.revivePet("player") then waitForPetToAppear = GetTime(); return true end
                    end
                elseif (not petDead and not deadPet) and not (petActive or petExists) and not buff.playDead.exists("pet") then
                    if castSpell("player",callPet,false,false,false) then waitForPetToAppear = GetTime(); return true end
                end
            end
        end
        if waitForPetToAppear == nil then
            waitForPetToAppear = GetTime()
        end
    end
    if isChecked("Auto Attack/Passive") then
        -- Set Pet Mode Out of Comat / Set Mode Passive In Combat
        if not inCombat and petMode == "Passive" then
            PetAssistMode()
        elseif inCombat and petMode ~= "Passive" then
            PetPassiveMode()
        end
        -- Pet Attack / retreat
        if (not UnitExists("pettarget") or not validTarget) and (inCombat or petCombat) and not buff.playDead.exists("pet") then
            if getOptionValue("Pet Target") == 1 then
                PetAttack(units.dyn40)
            elseif getOptionValue("Pet Target") == 2 then
                PetAttack("target")
            elseif getOptionValue("Pet Target") == 3 then
                for i=1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (isValidUnit(thisUnit) or isDummy()) then PetAttack(thisUnit); break end
                end
            end
        elseif (not inCombat or (inCombat and not validTarget and not isDummy())) and IsPetAttackActive() then
            PetStopAttack()
            PetFollow()
        end
    end
    -- Manage Pet Abilities
    -- Cat-like Refelexes
    if isChecked("Cat-like Reflexes") and petCombat and cast.able.catlikeReflexes() and getHP("pet") <= getOptionValue("Cat-like Reflexes") then
        if cast.catlikeReflexes() then return end
    end
    -- Claw
    if isChecked("Claw") and petCombat and cast.able.claw("pettarget") and validTarget and getDistance("pettarget","pet") < 5 then
        if cast.claw("pettarget","pet") then return end
    end
    -- Dash
    if isChecked("Dash") and cast.able.dash() and validTarget and getDistance("pettarget","pet") > 10 then
        if cast.dash(nil,"pet") then return end
    end
    -- Purge
    if isChecked("Purge") and inCombat then
        if #enemies.yards5p > 0 then
            local dispelled = false
            local dispelledUnit = "player"
            for i = 1, #enemies.yards5p do
                local thisUnit = enemies.yards5p[i]
                if getOptionValue("Purge") == 1 or (getOptionValue("Purge") == 2 and UnitIsUnit(thisUnit,"target")) then
                    if canDispel(thisUnit,spell.spiritShock) then
                        if cast.able.spiritShock(thisUnit,"pet") then
                            if cast.spiritShock(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                        elseif cast.able.chiJiTranq(thisUnit,"pet") then
                            if cast.chiJiTranq(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                        elseif cast.able.naturesGrace(thisUnit,"pet") then
                            if cast.naturesGrace(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                        elseif cast.able.netherShock(thisUnit,"pet") then
                            if cast.netherShock(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                        elseif cast.able.sonicBlast(thisUnit,"pet") then
                            if cast.sonicBlast(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                        elseif cast.able.soothingWater(thisUnit,"pet") then
                            if cast.soothingWater(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                        elseif cast.able.sporeCloud(thisUnit,"pet") then
                            if cast.sporeCloud(thisUnit,"pet") then dispelled = true; dispelledUnit = thisUnit; break end
                        end
                    end
                end
            end
            if dispelled then Print("Casting dispel on ".. UnitName(dispelledUnit)); return end
        end
    end
    -- Growl
    if isChecked("Auto Growl") and inCombat then
        local _, autoCastEnabled = GetSpellAutocast(spell.growl)
        if autoCastEnabled then DisableSpellAutocast(spell.growl) end
        if not isTankInRange() and not buff.prowl.exists("pet") then
            if getOptionValue("Misdirection") == 3 and cast.able.misdirection("pet") and #enemies.yards8p > 1 then
                if cast.misdirection("pet") then return end
            end
            if cast.able.growl() then
                for i = 1, #enemies.yards30p do
                    local thisUnit = enemies.yards30p[i]
                    if isTanking(thisUnit) then
                        if cast.growl(thisUnit,"pet") then return end
                    end
                end
            end
        end
    end
    -- Play Dead / Wake Up
    if isChecked("Play Dead / Wake Up") and not deadPet and petCombat then
        if cast.able.playDead() and not buff.playDead.exists("pet") 
            and getHP("pet") < getOptionValue("Play Dead / Wave Up")
        then
            if cast.playDead() then return end
        end
        if cast.able.wakeUp() and buff.playDead.exists("pet") and not buff.feignDeath.exists() 
            and getHP("pet") >= getOptionValue("Play Dead / Wave Up") 
        then
            if cast.wakeUp() then return end
        end
    end
    -- Prowl
    if isChecked("Prowl") and not petCombat and cast.able.prowl() and #enemies.yards20p > 0 and not buff.prowl.exists("pet") and not IsResting() then
        if cast.prowl() then return end
    end
    -- Mend Pet
    if isChecked("Mend Pet") and cast.able.mendPet() and petExists and not deadPet
        and not petDead and getHP("pet") < getOptionValue("Mend Pet") and not buff.mendPet.exists("pet")
    then
        if cast.mendPet() then return end
    end
end -- End Action List - Pet Management

-- Action List - Extra
actionList.Extra = function()
    -- Dummy Test
    if isChecked("DPS Testing") then
        if GetObjectExists("target") then
            if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                StopAttack()
                ClearTarget()
                Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                profileStop = true
            end
        end
    end -- End Dummy Test
    -- Misdirection
    if mode.misdirection == 1 then
        if isValidUnit("target") then
            local misdirectUnit = "pet"
            if getOptionValue("Misdirection") == 1 and (inInstance or inRaid) then
                for i = 1, #br.friend do
                    local thisFriend = br.friend[i].unit
                    if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(thisFriend) == "TANK")
                        and UnitAffectingCombat(thisFriend) and not UnitIsDeadOrGhost(thisFriend)
                    then
                        misdirectUnit = thisFriend
                        break
                    end
                end
            end
            if getOptionValue("Misdirection") == 2 and not UnitIsDeadOrGhost("focus")
                and GetUnitIsFriend("focus","player")
            then
                misdirectUnit = "focus"
            end
            if GetUnitExists(misdirectUnit) and UnitAffectingCombat(misdirectUnit)
                and not UnitIsDeadOrGhost(misdirectUnit) and GetUnitIsFriend(misdirectUnit,"player")
            then
                if cast.misdirection(misdirectUnit) then return end
            end
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if useDefensive() then
        -- Pot/Stoned
        if isChecked("Pot/Stoned") and (use.able.healthstone() or canUseItem(healPot))
            and php <= getOptionValue("Pot/Stoned") and inCombat and (hasHealthPot() or has.healthstone())
        then
            if use.able.healthstone() then
                use.healthstone()
            elseif canUseItem(healPot) then
                useItem(healPot)
            end
        end
        -- Heirloom Neck
        if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
            if use.able.heirloomNeck() and item.heirloomNeck ~= 0 and item.heirloomNeck ~= item.manariTrainingAmulet then
                if use.heirloomNeck() then return true end
            end
        end
        -- Aspect of the Turtle
        if isChecked("Aspect Of The Turtle") and cast.able.aspectOfTheTurtle() and php <= getOptionValue("Aspect Of The Turtle") then
            if cast.aspectOfTheTurtle("player") then return true end
        end
        -- Exhilaration
        if isChecked("Exhilaration") and cast.able.exhilaration() and php <= getOptionValue("Exhilaration") then
            if cast.exhilaration("player") then return true end
        end
        -- Feign Death
        if isChecked("Feign Death") and cast.able.feignDeath() and php <= getOptionValue("Feign Death") then
            if cast.able.playDead() then
                if cast.playDead() then return end
            end
            if cast.feignDeath("player") then return true end
        end
        -- Intimidation
        if isChecked("Intimidation") and cast.able.intimidation() and php <= getOptionValue("Intimidation") then
            if cast.intimidation(units.dyn5p) then return true end
        end
    end -- End Defensive Toggle
end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()
    if useInterrupts() then
        local thisUnit
        -- Muzzle
        if isChecked("Muzzle") and cast.able.muzzle() then
            for i=1, #enemies.yards5 do
                thisUnit = enemies.yards5[i]
                if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                    if cast.muzzle(thisUnit) then return true end
                end
            end
        end
        -- Freezing Trap
        if isChecked("Freezing Trap") and cast.able.freezingTrap() then
            for i = 1, #enemies.yards40 do
                thisUnit = enemies.yards40[i]
                if getDistance(thisUnit) > 8 and getCastTimeRemain(thisUnit) > 3 then
                    if cast.freezingTrap(thisUnit,"ground") then return true end
                end
            end
        end
        -- Intimidation
        if isChecked("Intimidation - Int") and cast.able.intimidation() then
            for i=1, #enemies.yards5 do
                thisUnit = enemies.yards5[i]
                if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                    if cast.intimidation(thisUnit) then return true end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupt

-- Action List - Cooldowns
actionList.Cooldown = function()
    if useCDs() and getDistance(units.dyn5) < 5 then
        -- Trinkets
        if isChecked("Trinkets") then
            if canUseItem(13) then
                useItem(13)
            end
            if canUseItem(14) then
                useItem(14)
            end
        end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
        if isChecked("Racial") then --and cd.racial.remain() == 0 then
            -- blood_fury,if=cooldown.coordinated_assault.remains>30
            -- ancestral_call,if=cooldown.coordinated_assault.remains>30
            -- fireblood,if=cooldown.coordinated_assault.remains>30 
            if (cd.coordinatedAssault.remain() > 30 and (race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf")) then
                if cast.racial("player") then return true end
            end
            -- lights_judgment
            if race == "LightforgedDraenei" then
                if cast.racial("target","ground") then return true end
            end
            -- berserking,if=cooldown.coordinated_assault.remains>60|time_to_die<11
            if (cd.coordinatedAssault.remain() > 30 or ttd(units.dyn5) < 13) and race == "Troll" then
                if cast.racial("player") then return end 
            end
        end
        -- Potion
        -- potion,if=buff.coordinated_assault.up&(buff.berserking.up|buff.blood_fury.up|!race.troll&!race.orc)|time_to_die<26
        if isChecked("Potion") and inRaid and use.able.potionOfProlongedPower() and buff.coordinatedAssault.exists()
            and ((race == "Orc" or race == "Troll") and buff.racial.exists()
                or not (race == "Orc" or race == "Troll") or ttd(units.dyn5) < 26)
        then
            use.potionOfProlongedPower()
        end
    end -- End useCooldowns check
    -- Aspect of the Eagle
    -- aspect_of_the_eagle,if=target.distance>=6
    if cast.able.aspectOfTheEagle() and (getDistance("target") >= 6)
        and (getOptionValue("Aspect of the Eagle") == 1 or (getOptionValue("Aspect of the Eagle") == 2 and useCDs()))
    then
        if cast.aspectOfTheEagle() then return end
    end
    -- -- A Murder of Crows
    -- -- a_murder_of_crows
    -- if cast.able.aMurderOfCrows() and (getOptionValue("A Murder of Crows") == 1 or (getOptionValue("A Murder of Crows") == 2 and useCDs())) then
    --     if cast.aMurderOfCrows() then return end
    -- end
    -- -- Coordinated Assault
    -- -- coordinated_assault
    -- if cast.able.coordinatedAssault() and eagleScout() > 0
    --     and (getOptionValue("Coordinated Assault") == 1 or (getOptionValue("Coordinated Assault") == 2 and useCDs()))
    -- then
    --     if cast.coordinatedAssault() then return end
    -- end
end -- End Action List - Cooldowns

-- Action List - Single Target
actionList.St = function()
    -- A Murder of Crows
    -- a_murder_of_crows
    if cast.able.aMurderOfCrows() and (getOptionValue("A Murder of Crows") == 1 or (getOptionValue("A Murder of Crows") == 2 and useCDs())) then
        if cast.aMurderOfCrows() then return end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=talent.birds_of_prey.enabled&buff.coordinated_assault.up&(buff.coordinated_assault.remains<gcd|buff.blur_of_talons.up&buff.blur_of_talons.remains<gcd)
    if cast.able.mongooseBite() and talent.mongooseBite and talent.birdsOfPrey and buff.coordinatedAssault.exists() 
        and (buff.coordinatedAssault.remain() < gcdMax or buff.blurOfTalons.remain() < gcdMax) 
    then
        if cast.mongooseBite() then return end 
    end 
    -- Raptor Strike 
    -- raptor_strike,if=talent.birds_of_prey.enabled&buff.coordinated_assault.up&(buff.coordinated_assault.remains<gcd|buff.blur_of_talons.up&buff.blur_of_talons.remains<gcd)
    if cast.able.raptorStrike() and not talent.mongooseBite and talent.birdsOfPrey and buff.coordinatedAssault.exists() 
        and (buff.coordinatedAssault.remain() < gcdMax or buff.blurOfTalons.remain() < gcdMax) 
    then
        if cast.raptorStrike() then return end 
    end
    -- Serpent Sting 
    -- serpent_sting,if=buff.vipers_venom.react&buff.vipers_venom.remains<gcd
    if cast.able.serpentSting() and ttd(units.dyn40) > 3 and buff.vipersVenom.exists() and buff.vipersVenom.remain() < gcdMax then 
        if cast.serpentSting() then return end 
    end
    -- Kill Command
    -- kill_command,if=focus+cast_regen<focus.max&(!talent.alpha_predator.enabled|talent.alpha_predator.enabled&full_recharge_time<1.5*gcd&azerite.primeval_intuition.enabled&focus+cast_regen<100|!azerite.primeval_intuition.enabled&focus+cast_regen<80)
    if cast.able.killCommand() and (focus + castRegen(spell.killCommand) < focusMax and (not talent.alphaPredator or talent.alphaPredator 
        and charges.killCommand.timeTillFull() < 1.5 * gcdMax and traits.primevalIntuition.active and focus + castRegen(spell.killCommand) < 100 
        or not traits.primevalIntuition.active and focus + castRegen(spell.killCommand) < 80)) 
    then
        if cast.killCommand() then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=focus+cast_regen<focus.max&(full_recharge_time<gcd|!dot.wildfire_bomb.ticking&(buff.mongoose_fury.down|full_recharge_time<4.5*gcd))
    if cast.able.wildfireBomb() and focus + focusRegen < focusMax and (charges.wildfireBomb.timeTillFull() < gcdMax 
        or not debuff.wildfireBomb.exists(units.dyn40) and (not buff.mongooseFury.exists() or charges.wildfireBomb.timeTillFull() < 4.5 * gcdMax))
    then
        if cast.wildfireBomb() then return end
    end
    -- Serpent Sting
    -- serpent_sting,if=buff.vipers_venom.react&dot.serpent_sting.remains<4*gcd|!talent.vipers_venom.enabled&!dot.serpent_sting.ticking&!buff.coordinated_assault.up
    if cast.able.serpentSting() and ttd(units.dyn40) > 3 and ((buff.vipersVenom.exists() and debuff.serpentSting.remain(units.dyn40) < 4 * gcdMax) 
        or (not talent.vipersVenom and not debuff.serpentSting.exists(units.dyn40) and not buff.coordinatedAssault.exists()))
    then 
        if cast.serpentSting() then return end
    end
    -- serpent_sting,if=refreshable&(azerite.latent_poison.rank>2|azerite.latent_poison.enabled&azerite.venomous_fangs.enabled|(azerite.latent_poison.enabled
        --|azerite.venomous_fangs.enabled)&(!azerite.blur_of_talons.enabled|!talent.birds_of_prey.enabled|!buff.coordinated_assault.up))
    if cast.able.serpentSting() and ttd(units.dyn40) > 3 and debuff.serpentSting.refresh(units.dyn40)
        and (traits.latentPoison.rank > 2 or (traits.latentPoison.active and traits.venomousFangs.active)
        or ((traits.latentPoison.active or traits.venomousFangs.active) and (not traits.blurOfTalons.active
        or not talent.birdsOfPrey or not buff.coordinatedAssault.exists())))
    then 
        if cast.serpentSting() then return end
    end
    -- Steel Trap 
    -- steel_trap
    if cast.able.steelTrap("best",nil,1,5) then
        if cast.steelTrap("best",nil,1,5) then return end
    end
    -- Harpoon 
    -- harpoon,if=talent.terms_of_engagement.enabled
    if cast.able.harpoon() and mode.harpoon == 1 and talent.termsOfEngagement then
        if cast.harpoon() then return end
    end
    -- Coordinated Assault
    -- coordinated_assault
    if cast.able.coordinatedAssault() and eagleScout() > 0
        and (getOptionValue("Coordinated Assault") == 1 or (getOptionValue("Coordinated Assault") == 2 and useCDs()))
    then
        if cast.coordinatedAssault() then return end
    end
    -- Chakrams
    -- chakrams
    if cast.able.chakrams(nil,"rect",1,40) and enemies.yards40r > 0 then
        if cast.chakrams(nil,"rect",1,40) then return end
    end
    -- Flanking Strike
    -- flanking_strike,if=focus+cast_regen<focus.max
    if cast.able.flankingStrike() and (focus + castRegen(spell.flankingStrike) < focusMax) then
        if cast.flankingStrike() then return end
    end
    -- Kill Command 
    -- kill_command,if=focus+cast_regen<focus.max&(buff.mongoose_fury.stack<4|focus<action.mongoose_bite.cost)
    if cast.able.killCommand() and focus + castRegen(spell.killCommand) < focusMax and (buff.mongooseFury.stack() < 4 or focus < cast.cost.mongooseBite()) then 
        if cast.killCommand() then return end 
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.mongoose_fury.up|(azerite.primeval_intuition.enabled&(focus+cast_regen>110|talent.vipers_venom.enabled&focus>100))|(!azerite.primeval_intuition.enabled&(focus+cast_regen>90|talent.vipers_venom.enabled&focus+cast_regen>80))|buff.coordinated_assault.up
    if cast.able.mongooseBite() and (buff.mongooseFury.exists() or (traits.primevalIntuition.active 
        and (focus + focusRegen > 110 or talent.vipersVenom and focus > 100)) or (not traits.primevalIntuition.active 
        and (focus + focusRegen > 90 or talent.vipersVenom and focus + focusRegen > 80)) or buff.coordinatedAssault.exists()) 
    then
        if cast.mongooseBite() then return end
    end
    -- Raptor Strike
    -- raptor_strike
    if cast.able.raptorStrike() and not talent.mongooseBite then
        if cast.raptorStrike() then return end
    end
    -- Serpent Sting
    -- serpent_sting,if=dot.serpent_sting.refreshable&!buff.coordinated_assault.up
    if cast.able.serpentSting() and ttd(units.dyn40) > 3 and (debuff.serpentSting.refresh(units.dyn40) and not buff.coordinatedAssault.exists()) then
        if cast.serpentSting() then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=dot.wildfire_bomb.refreshable
    if cast.able.wildfireBomb(units.dyn40,"aoe") and (debuff.wildfireBomb.refresh(units.dyn40)) then
        if cast.wildfireBomb(units.dyn40,"aoe") then return end
    end
end -- End Action List - Single Target

-- Action List - Cleave
actionList.Cleave = function()
    -- A Murder of Crows
    -- a_murder_of_crows
    if cast.able.aMurderOfCrows() and (getOptionValue("A Murder of Crows") == 1 or (getOptionValue("A Murder of Crows") == 2 and useCDs())) then
        if cast.aMurderOfCrows() then return end
    end
    -- Coordinated Assault
    -- coordinated_assault
    if cast.able.coordinatedAssault() and eagleScout() > 0
        and (getOptionValue("Coordinated Assault") == 1 or (getOptionValue("Coordinated Assault") == 2 and useCDs()))
    then
        if cast.coordinatedAssault() then return end
    end
    -- Carve
    -- carve,if=dot.shrapnel_bomb.ticking
    if cast.able.carve(nil,"cone",2,5) and (debuff.shrapnelBomb.exists(units.dyn5)) then
        if cast.carve(nil,"cone",2,5) then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=!talent.guerrilla_tactics.enabled|full_recharge_time<gcd
    if cast.able.wildfireBomb(units.dyn40,"aoe") and (not talent.guerrillaTactics or charges.wildfireBomb.timeTillFull() < gcdMax) then
        if cast.wildfireBomb(units.dyn40,"aoe") then return end
    end
    -- Mongoose Bite
    -- mongoose_bite,target_if=max:debuff.latent_poison.stack,if=debuff.latent_poison.stack=10
    if cast.able.mongooseBite(maxLatentPoison) and talent.mongooseBite and debuff.latentPoison.stack(maxLatentPoison) == 10 then
        if cast.mongooseBite(maxLatentPoison) then return end
    end
    -- Chakrams
    -- chakrams
    if cast.able.chakrams("player","rect",2,40) and enemies.yards40r > 0 then
        if cast.chakrams("player","rect",2,40) then return end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max
    if cast.able.killCommand(lowestBloodseeker) and getDistance("pettarget","pet") < 30 and (focus + castRegen(spell.killCommand) < focusMax) then
        if cast.killCommand(lowestBloodseeker) then return end
    end
    -- Butchery
    -- butchery,if=full_recharge_time<gcd|!talent.wildfire_infusion.enabled|dot.shrapnel_bomb.ticking&dot.internal_bleeding.stack<3
    if cast.able.butchery("player","aoe") and (charges.butchery.timeTillFull() < gcdMax or not talent.wildfireInfusion
        or debuff.shrapnelBomb.exists(units.dyn40) and debuff.internalBleeding.stack(units.dyn40) < 3)
    then
        if cast.butchery("player","aoe") then return end
    end
    -- Carve
    -- carve,if=talent.guerrilla_tactics.enabled
    if cast.able.carve(nil,"cone",2,5) and (talent.guerrillaTactics) then
        if cast.carve(nil,"cone",2,5) then return end
    end
    -- Flanking Strike
    -- flanking_strike,if=focus+cast_regen<focus.max
    if cast.able.flankingStrike() and (focus + castRegen(spell.flankingStrike) < focusMax) then
        if cast.flankingStrike() then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=dot.wildfire_bomb.refreshable|talent.wildfire_infusion.enabled
    if cast.able.wildfireBomb(units.dyn40,"aoe") and (debuff.wildfireBomb.refresh(units.dyn40) or talent.wildfireInfusion) then
        if cast.wildfireBomb(units.dyn40,"aoe") then return end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=buff.vipers_venom.react
    if cast.able.serpentSting(lowestSerpentSting) and canDoT(lowestSerpentSting) and ttd(lowestSerpentSting) > 3 and (buff.vipersVenom.exists()) then
        if cast.serpentSting(lowestSerpentSting) then return end
    end
    -- Carve
    -- carve,if=cooldown.wildfire_bomb.remains>variable.carve_cdr%2
    if cast.able.carve(nil,"cone",2,5) and (cd.wildfireBomb.remain() > carveCdr / 2) then
        if cast.carve(nil,"cone",2,5) then return end
    end
    -- Steel Trap
    -- steel_trap
    if cast.able.steelTrap("best",nil,2,5) then
        if cast.steelTrap("best",nil,2,5) then return end
    end
    -- Harpoon
    -- harpoon,if=talent.terms_of_engagement.enabled
    if cast.able.harpoon() and mode.harpoon == 1 and (talent.termsOfEngagement) then
        if cast.harpoon() then return end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=refreshable&buff.tip_of_the_spear.stack<3
    if cast.able.serpentSting(lowestSerpentSting) and canDoT(lowestSerpentSting) and ttd(lowestSerpentSting) > 3 
        and (debuff.serpentSting.refresh(lowestSerpentSting) and buff.tipOfTheSpear.stack() < 3) 
    then
        if cast.serpentSting(lowestSerpentSting) then return end
    end
    -- Mongoose Bite
    -- mongoose_bite,target_if=max:debuff.latent_poison.stack
    if cast.able.mongooseBite(maxLatentPoison) and talent.mongooseBite then
        if cast.mongooseBite(maxLatentPoison) then return end
    end
    -- Raptor Strike
    -- raptor_strike,target_if=max:debuff.latent_poison.stack
    if cast.able.raptorStrike(maxLatentPoison) and not talent.mongooseBite then
        if cast.raptorStrike(maxLatentPoison) then return end
    end
end -- End Action List - Cleave

-- Action List - Wildfire Infusion
actionList.WfiSt = function()
    -- A Murder of Crows
    -- a_murder_of_crows
    if cast.able.aMurderOfCrows() and (getOptionValue("A Murder of Crows") == 1 or (getOptionValue("A Murder of Crows") == 2 and useCDs())) then
        if cast.aMurderOfCrows() then return end
    end
    -- Coordinated Assault
    -- coordinated_assault
    if cast.able.coordinatedAssault() and eagleScout() > 0
        and (getOptionValue("Coordinated Assault") == 1 or (getOptionValue("Coordinated Assault") == 2 and useCDs()))
    then
        if cast.coordinatedAssault() then return end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=azerite.wilderness_survival.enabled&next_wi_bomb.volatile&dot.serpent_sting.remains>2.1*gcd&dot.serpent_sting.remains<3.5*gcd&cooldown.wildfire_bomb.remains>2.5*gcd
    if cast.able.mongooseBite() and talent.mongooseBite and traits.wildernessSurvival.active and nextBomb(spell.volatile)
        and debuff.serpentSting.remain(units.dyn40) > 2.1 * gcdMax and debuff.serpentSting.remain(units.dyn40) < 3.5 * gcdMax
        and cd.wildfireBomb.remain() > 2.5 * gcdMax
    then
        if cast.mongooseBite() then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=full_recharge_time<gcd|(focus+cast_regen<focus.max)&(next_wi_bomb.volatile&dot.serpent_sting.ticking&dot.serpent_sting.refreshable|next_wi_bomb.pheromone&!buff.mongoose_fury.up&focus+cast_regen<focus.max-action.kill_command.cast_regen*3)
    if cast.able.wildfireBomb(units.dyn40,"aoe") and (charges.wildfireBomb.timeTillFull() < gcdMax or (focus + cast.regen.wildfireBomb() < focusMax)
        and (nextBomb(spell.volatileBomb) and debuff.serpentSting.exists(units.dyn40) and debuff.serpentSting.refresh(units.dyn40) or nextBomb(spell.pheromoneBomb)
        and not buff.mongooseFury.exists() and focus + cast.regen.wildfireBomb() < focusMax - cast.regen.killCommand() * 3))
    then
        if cast.wildfireBomb(units.dyn40,"aoe") then return end
    end
    -- Kill Command
    -- kill_command,if=focus+cast_regen<focus.max&buff.tip_of_the_spear.stack<3&(!talent.alpha_predator.enabled|buff.mongoose_fury.stack<5|focus<action.mongoose_bite.cost)
    if cast.able.killCommand() and getDistance("pettarget","pet") < 30 and (focus + castRegen(spell.killCommand) < focusMax and buff.tipOfTheSpear.stack() < 3
        and (not talent.alphaPredator or buff.mongooseFury.stack() < 5 or focus < cast.cost.mongooseBite()))
    then
        if cast.killCommand() then return end
    end
    -- Raptor Strike
    -- raptor_strike,if=dot.internal_bleeding.stack<3&dot.shrapnel_bomb.ticking&!talent.mongoose_bite.enabled
    if cast.able.raptorStrike() and (debuff.internalBleeding.stack() < 3 and debuff.shrapnelBomb.exists() and not talent.mongooseBite) then
        if cast.raptorStrike() then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.shrapnel&buff.mongoose_fury.down&(cooldown.kill_command.remains>gcd|focus>60)&!dot.serpent_sting.refreshable
    if cast.able.wildfireBomb(units.dyn40,"aoe") and (nextBomb(spell.shrapnelBomb) and not buff.mongooseFury.exists()
        and (cd.killCommand.remain() > gcdMax or focus > 60) and not debuff.serpentSting.refresh(units.dyn40))
    then
        if cast.wildfireBomb(units.dyn40,"aoe") then return end
    end
    -- Steel Trap
    -- steel_trap
    if cast.able.steelTrap("best",nil,1,5) then
        if cast.steelTrap("best",nil,1,5) then return end
    end
    -- Flanking Strike
    -- flanking_strike,if=focus+cast_regen<focus.max
    if cast.able.flankingStrike() and (focus + castRegen(spell.flankingStrike) < focusMax) then
        if cast.flankingStrike() then return end
    end
    -- Serpent Sting
    -- serpent_sting,if=buff.vipers_venom.react|refreshable&(!talent.mongoose_bite.enabled|!talent.vipers_venom.enabled|next_wi_bomb.volatile&!dot.shrapnel_bomb.ticking|azerite.latent_poison.enabled|azerite.venomous_fangs.enabled|buff.mongoose_fury.stack=5)
    if cast.able.serpentSting() and ttd(units.dyn40) > 3 and (buff.vipersVenom.exists() or debuff.serpentSting.refresh(units.dyn40) 
        and (not talent.mongooseBite or not talent.vipersVenom or nextBomb(spell.volatileBomb) 
        and not debuff.shrapnelBomb.exists(units.dyn40) or traits.latentPoison.active or traits.venomousFangs.active or buff.mongooseFury.stack() == 5))
    then
        if cast.serpentSting() then return end
    end
    -- Harpoon
    -- harpoon,if=talent.terms_of_engagement.enabled
    if cast.able.harpoon() and mode.harpoon == 1 and talent.termsOfEngagement then
        if cast.harpoon() then return end
    end
    -- Mongoose Bite
    -- mongoose_bite_eagle,if=buff.mongoose_fury.up|focus>60|dot.shrapnel_bomb.ticking
    if cast.able.mongooseBite() and talent.mongooseBite and (buff.mongooseFury.exists() or focus > 60 or debuff.shrapnelBomb.exists(units.dyn40)) then
        if cast.mongooseBite() then return end
    end
    -- Raptor Strike
    -- raptor_strike
    if cast.able.raptorStrike() and not talent.mongooseBite then
        if cast.raptorStrike() then return end
    end
    -- Serpent Sting
    -- serpent_sting,if=refreshable
    if cast.able.serpentSting() and ttd(units.dyn40) > 3 and (debuff.serpentSting.refresh(units.dyn40)) then
        if cast.serpentSting() then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.volatile&dot.serpent_sting.ticking|next_wi_bomb.pheromone|next_wi_bomb.shrapnel&focus>50
    if cast.able.wildfireBomb(units.dyn40,"aoe") and (nextBomb(spell.volatileBomb)
        and debuff.serpentSting.exists(units.dyn40) or nextBomb(spell.pheromoneBomb)
        or nextBomb(spell.shrapnelBomb) and focus > 50)
    then
        if cast.wildfireBomb(units.dyn40,"aoe") then return end
    end
end -- End Action List - Wildfire Infusion

-- Action List - Mongoose Bite / Alpha Predator / Wildfire Infusion
actionList.MbApWfiSt = function()
    -- Serpent Sting
    -- serpent_sting,if=!dot.serpent_sting.ticking
    if cast.able.serpentSting() and ttd(units.dyn40) > 3 and (not debuff.serpentSting.exists(units.dyn40)) then
        if cast.serpentSting() then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=full_recharge_time<gcd|(focus+cast_regen<focus.max)&(next_wi_bomb.volatile&dot.serpent_sting.ticking&dot.serpent_sting.refreshable|next_wi_bomb.pheromone&!buff.mongoose_fury.up&focus+cast_regen<focus.max-action.kill_command.cast_regen*3)
    if cast.able.wildfireBomb(units.dyn40,"aoe") and (charges.wildfireBomb.timeTillFull() < gcdMax or (focus + cast.regen.wildfireBomb() < focusMax)
        and (nextBomb(spell.volatileBomb) and debuff.serpentSting.exists(units.dyn40) and debuff.serpentSting.refresh(units.dyn40) or nextBomb(spell.pheromoneBomb)
        and not buff.mongooseFury.exists() and focus + cast.regen.wildfireBomb() < focusMax - castRegen(spell.killCommand) * 3))
    then
        if cast.wildfireBomb(units.dyn40,"aoe") then return end
    end
    -- Coordinated Assault
    -- coordinated_assault
    if cast.able.coordinatedAssault() and (getOptionValue("Coordinated Assault") == 1 or (getOptionValue("Coordinated Assault") == 2 and useCDs())) then
        if cast.coordinatedAssault() then return end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if cast.able.aMurderOfCrows() and (getOptionValue("A Murder of Crows") == 1 or (getOptionValue("A Murder of Crows") == 2 and useCDs())) then
        if cast.aMurderOfCrows() then return end
    end
    -- Steel Trap
    -- steel_trap
    if cast.able.steelTrap("best",nil,1,5) then
        if cast.steelTrap("best",nil,1,5) then return end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.mongoose_fury.remains&next_wi_bomb.pheromone
    if cast.able.mongooseBite() and (buff.mongooseFury.remain() and nextBomb(spell.pheromoneBomb)) then
        if cast.mongooseBite() then return end
    end
    -- Kill Command
    -- kill_command,if=focus+cast_regen<focus.max&(buff.mongoose_fury.stack<5|focus<action.mongoose_bite.cost)
    if cast.able.killCommand() and (focus + castRegen(spell.killCommand) < focusMax and (buff.mongooseFury.stack() < 5 or focus < cast.cost.mongooseBite())) then
        if cast.killCommand() then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.shrapnel&focus>60&dot.serpent_sting.remains>3*gcd
    if cast.able.wildfireBomb() and (nextBomb(spell.shrapnelBomb) and focus > 60 and debuff.serpentSting.remain(units.dyn40) > 3 * gcdMax) then
        if cast.wildfireBomb() then return end
    end
    -- Serpent Sting
    -- serpent_sting,if=refreshable&(next_wi_bomb.volatile&!dot.shrapnel_bomb.ticking|azerite.latent_poison.enabled|azerite.venomous_fangs.enabled)
    if cast.able.serpentSting() and ttd(units.dyn40) > 3 and debuff.serpentSting.refresh(units.dyn40)
        and (nextBomb(spell.volatileBomb) and (not debuff.shrapnelBomb.exists(units.dyn40) or traits.latentPoison.active or traits.venomousFangs.active))
    then
        if cast.serpentSting() then return end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.mongoose_fury.up|focus>60|dot.shrapnel_bomb.ticking
    if cast.able.mongooseBite() and (buff.mongooseFury.exists() or focus > 60 or debuff.shrapnelBomb.exists(units.dyn40)) then
        if cast.mongooseBite() then return end
    end
    -- Serpent Sting
    -- serpent_sting,if=refreshable
    if cast.able.serpentSting() and ttd(units.dyn40) > 3 and (debuff.serpentSting.refresh(units.dyn40)) then
        if cast.serpentSting() then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.volatile&dot.serpent_sting.ticking|next_wi_bomb.pheromone|next_wi_bomb.shrapnel&focus>50
    if cast.able.wildfireBomb() and (nextBomb(spell.volatileBomb) and debuff.serpentSting.exists(units.dyn40)
        or nextBomb(spell.pheromoneBomb) or nextBomb(spell.shrapnelBomb) and focus > 50)
    then
        if cast.wildfireBomb() then return end
    end
end -- End Action List - Mongoose Bite / Alpha Predator / Wildfire Infusion

-- Action List - Opener
actionList.Opener = function()
    -- Harpoon
    if isChecked("Harpoon - Opener") and mode.harpoon == 1 and cast.able.harpoon("target") and isValidUnit("target") 
        and getDistance("target") >= 8 and getDistance("target") < 30 
    then
        if cast.harpoon("target") then return end
    end
    -- Start Attack
    -- auto_attack
    if (getOptionValue("Opener") == 1 or (getOptionValue("Opener") == 2 and useCDs())) and not opener.complete then
        if isValidUnit("target") and getDistance("target") < 40
            and getFacing("player","target") and getSpellCD(61304) == 0
        then
            -- Begin
            if not opener.OPN1 then
                Print("Starting Opener")
                opener.count = opener.count + 1
                opener.OPN1 = true
                StartAttack()
                return
            -- Coordinated Assault
            elseif opener.OP1 and not opener.CA1 then
                if cd.coordinatedAssault.remain() > gcd then
                    castOpenerFail("coordinatedAssault","CA1",opener.count)
                elseif cast.able.coordinatedAssault() then 
                    castOpener("aspectOfTheWild","CA1",opener.count)
                end 
                opener.count = opener.count + 1
                return
            -- Serpent Sting
            elseif opener.CA1 and not opener.SS1 then
                if debuff.serpentSting.exists("target") then
                    castOpenerFail("serpentSting","SS1",opener.count)
                elseif cast.able.serpentSting() then 
                    castOpener("serpentSting","SS1",opener.count)
                end 
                opener.count = opener.count + 1
                return
            -- Wildfire Bomb
            elseif opener.SS1 and not opener.WB1 then
                if charges.wildfireBomb.count() == 0 then 
                    castOpenerFail("wildfireBomb","WB1",opener.count)
                elseif cast.able.wildfireBomb() then 
                    castOpener("wildfireBomb","WB1",opener.count)
                end 
                opener.count = opener.count + 1
                return
            -- Raptor Strike
            elseif opener.WB1 and not opener.RS1 then
                if not cast.able.raptorStrike() then
                    castOpenerFail("raptorStrike","RS1",opener.count)
                elseif cast.able.raptorStrike() then 
                    castOpener("raptorStrike","RS1",opener.count)
                end 
                opener.count = opener.count + 1
                return
            -- Kill Command
            elseif opener.RS1 and not opener.KC1 then
                if cd.killCommand.remain() > gcd then
                    castOpenerFail("killCommand","KC1",opener.count)
                elseif cast.able.killCommand() then 
                    castOpener("killCommand","KC1",opener.count)
                end 
                opener.count = opener.count + 1
                return
            -- End
            elseif opener.KC1 and opener.OPN1 then
                Print("Opener Complete")
                opener.count = 0
                opener.complete = true
            end
        end
    elseif (UnitExists("target") and not useCDs()) or not isChecked("Opener") then
        opener.complete = true
    end
end -- End Action List - Opener

-- Action List - Pre-Combat
actionList.PreCombat = function()
    -- Flask / Crystal
    -- flask,type=flask_of_the_seventh_demon
    if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheSeventhDemon.exists() and canUseItem(item.flaskOfTheSeventhDemon) then
        if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
        if buff.felFocus.exists() then buff.felFocus.cancel() end
        if use.flaskOfTheSeventhDemon() then return true end
    end
    if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and canUseItem(item.repurposedFelFocuser) then
        if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
        if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
        if use.repurposedFelFocuser() then return true end
    end
    if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUseItem(item.oraliusWhisperingCrystal) then
        if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
        if buff.felFocus.exists() then buff.felFocus.cancel() end
        if use.oraliusWhisperingCrystal() then return true end
    end
    -- Init Combat
    if not inCombat and getDistance("target") < 40 and isValidUnit("target") and opener.complete then
        -- Steel Trap
        -- steel_trap
        if cast.able.steelTrap("target") then
            if cast.steelTrap("target") then return end
        end
        -- Serpent Sting
        if cast.able.serpentSting("target") and ttd("target") > 3 and not debuff.serpentSting.exists("target") then
            if cast.serpentSting("target") then return end
        end
        -- Start Attack
        if not IsAutoRepeatSpell(GetSpellInfo(6603)) and getDistance("target") < 5 then
            StartAttack("target")
        end
    end
    -- Call Action List - Opener
    if actionList.Opener() then return true end
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    focus                                         = br.player.power.focus.amount()
    focusMax                                      = br.player.power.focus.max()
    focusRegen                                    = br.player.power.focus.regen()
    gcd                                           = br.player.gcd
    gcdMax                                        = br.player.gcdMax
    has                                           = br.player.has
    inCombat                                      = br.player.inCombat
    inRaid                                        = br.player.instance=="raid"
    item                                          = br.player.spell.items
    mode                                          = br.player.mode
    opener                                        = br.player.opener
    php                                           = br.player.health
    potion                                        = br.player.potion
    race                                          = br.player.race
    spell                                         = br.player.spell
    talent                                        = br.player.talent
    traits                                        = br.player.traits
    ttm                                           = br.player.power.focus.ttm()
    units                                         = br.player.units
    use                                           = br.player.use
    -- General Locals
    combatTime                                    = getCombatTime()
    flying                                        = IsFlying()
    hastar                                        = GetObjectExists("target")
    healPot                                       = getHealthPot()
    petCombat                                     = UnitAffectingCombat("pet")
    profileStop                                   = profileStop or false
    pullTimer                                     = br.DBM:getPulltimer()
    ttd                                           = getTTD
    -- Units
    units.get(5)
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(5,"pet")
    enemies.get(20,"pet")
    enemies.get(30)
    enemies.get(30,"pet")
    enemies.get(40)
    enemies.yards40r = getEnemiesInRect(10,40,false) or 0
    -- Opener Reset
    if (not inCombat and not GetObjectExists("target")) or opener.complete == nil then
        opener.count = 0
        opener.OPN1 = false
        opener.CA1 = false
        opener.SS1 = false
        opener.WB1 = false
        opener.RS2 = false
        opener.KC1 = false
        opener.complete = false
    end
    -- Profile Specific Locals
    lowestBloodseeker                             = debuff.bloodseeker.lowest(40,"remain")
    lowestSerpentSting                            = debuff.serpentSting.lowest(40,"remain")
    if buff.aspectOfTheEagle.exists() then thisRange = 40 else thisRange = 5 end
    lowestInternalBleeding                        = debuff.internalBleeding.lowest(thisRange,"stack")
    maxLatentPoison                               = debuff.latentPoison.max(thisRange,"stack")
    -- variable,name=carve_cdr,op=setif,value=active_enemies,value_else=5,condition=active_enemies<5
    if #enemies.yards5 < 5 then carveCdr = #enemies.yards5 else carveCdr = 5 end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop then
        profileStop = false
    elseif (inCombat and profileStop) or (IsMounted() or IsFlying()) or pause() or buff.feignDeath.exists() or mode.rotation==4 then
        if isChecked("Auto Attack/Passive") and pause() and IsPetAttackActive() then
            PetStopAttack()
            PetFollow()
        end
        if cast.able.playDead() and cast.last.feignDeath() and not buff.playDead.exists("pet") then
            if cast.playDead() then return end
        end
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -----------------
        --- Pet Logic ---
        -----------------
        if actionList.PetManagement() then return true end
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extra() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if inCombat and isValidUnit("target") and opener.complete and cd.global.remain() == 0 then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupt() then return true end
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            if getOptionValue("APL Mode") == 1 then
                -- Start Attack
                -- actions=auto_attack
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) and getDistance(units.dyn5) < 5 then
                    StartAttack(units.dyn5)
                end
                -- Cooldowns
                -- call_action_list,name=CDs
                if actionList.Cooldown() then return true end
                -- Call Action List - Mongoose Bite / Alpha Predator / Wildfire Infusion
                -- call_action_list,name=mb_ap_wfi_st,if=active_enemies<3&talent.wildfire_infusion.enabled&talent.alpha_predator.enabled&talent.mongoose_bite.enabled
                if eagleScout() < 3 and talent.wildfireInfusion and talent.alphaPredator and talent.mongooseBite then
                    if actionList.MbApWfiSt() then return end
                end
                -- Call Action List - Wildfire Infusion
                -- call_action_list,name=wfi_st,if=active_enemies<3&talent.wildfire_infusion.enabled
                if eagleScout() < 3 and talent.wildfireInfusion then
                    if actionList.WfiSt() then return end
                end
                -- Call Action List - Single Target
                -- call_action_list,name=st,if=active_enemies<2|azerite.blur_of_talons.enabled&talent.birds_of_prey.enabled&buff.coordinated_assault.up
                if eagleScout() < 2 or (traits.blurOfTalons.active and talent.birdsOfPrey and buff.coordinatedAssault.exists()) then
                    if actionList.St() then return end
                end
                -- Call Action List - Cleave
                -- call_action_list,name=cleave,if=active_enemies>1
                if eagleScout() > 1 then 
                    if actionList.Cleave() then return end
                end
                -- Arcane Torrent 
                -- arcane_torrent 
                if isChecked("Racial") and cast.able.racial() and race == "BloodElf" then 
                    if cast.racial() then return end 
                end
            end -- End SimC APL
            ------------------------
            --- Ask Mr Robot APL ---
            ------------------------
            if getOptionValue("APL Mode") == 2 then

            end -- End AMR
        end -- End In Combat Rotation
    end -- Pause
    return true
end -- End runRotation
local id = 255
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

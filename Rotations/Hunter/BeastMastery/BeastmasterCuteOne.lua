local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.cobraShot },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.multishot },
        [3] = { mode = "Sing", value = 2 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.killCommand },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.exhilaration}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.aspectOfTheWild },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.aspectOfTheWild },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.aspectOfTheWild }
    };
    CreateButton("Cooldown",2,0)
    -- BW Button
    BestialWrathModes = {
        [1] = { mode = "On", value = 1 , overlay = "Will use BW", tip = "Will use bw according to rotation", highlight = 1, icon = br.player.spell.bestialWrath },
        [2] = { mode = "Off", value = 2 , overlay = "Will hold BW", tip = "Will hold BW until toggled again", highlight = 0, icon = br.player.spell.bestialWrath }
    };
    CreateButton("BestialWrath",3,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.aspectOfTheTurtle },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.aspectOfTheTurtle }
    };
    CreateButton("Defensive",4,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterShot },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterShot }
    };
    CreateButton("Interrupt",5,0)
    -- MD Button
    MisdirectionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    CreateButton("Misdirection",6,0)
    -- Murder of crows
    MurderOfCrowsModes = {
        [1] = { mode = "On", value = 1 , overlay = "Always use MoC", tip = "Will Use Murder of Crows At All Times", highlight = 1, icon = br.player.spell.aMurderOfCrows },
        [2] = { mode = "CD", value = 2 , overlay = "Use MoC only on Cooldowns", tip = "Will Use Murder of Crows Only on Cooldowns", highlight = 0, icon = br.player.spell.aMurderOfCrows }
    };
    CreateButton("MurderOfCrows",7,0)
    --Pet summon
    PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Summon Pet 1", tip = "Summon Pet 1", highlight = 1, icon = br.player.spell.callPet1 },
        [2] = { mode = "2", value = 2 , overlay = "Summon Pet 2", tip = "Summon Pet 2", highlight = 1, icon = br.player.spell.callPet2 },
        [3] = { mode = "3", value = 3 , overlay = "Summon Pet 3", tip = "Summon Pet 3", highlight = 1, icon = br.player.spell.callPet3 },
        [4] = { mode = "4", value = 4 , overlay = "Summon Pet 4", tip = "Summon Pet 4", highlight = 1, icon = br.player.spell.callPet4 },
        [5] = { mode = "5", value = 5 , overlay = "Summon Pet 5", tip = "Summon Pet 5", highlight = 1, icon = br.player.spell.callPet5 },
        [6] = { mode = "None", value = 6 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.callPet }
    };
    CreateButton("PetSummon",8,0)
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
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- AoE Units
            br.ui:createSpinnerWithout(section, "Units To AoE", 2, 1, 10, 1, "|cffFFFFFFSet to desired units to start AoE at.")
            -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
            -- Opener
            br.ui:createCheckbox(section, "Opener")
        br.ui:checkSectionState(section)
        -- Pet Options
        section = br.ui:createSection(br.ui.window.profile, "Pet")
            -- Auto Summon
            -- br.ui:createDropdown(section, "Auto Summon", {"Pet 1","Pet 2","Pet 3","Pet 4","Pet 5","No Pet"}, 1, "Select the pet you want to use")
            -- Auto Attack/Passive
            br.ui:createCheckbox(section, "Auto Attack/Passive")
            -- Auto Growl
            br.ui:createCheckbox(section, "Auto Growl")
            -- Mend Pet
            br.ui:createSpinner(section, "Mend Pet",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Spirit Mend
            br.ui:createSpinner(section, "Spirit Mend", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Pet Attacks
            br.ui:createCheckbox(section, "Pet Attacks")
            -- Purge
            br.ui:createDropdown(section, "Purge", {"Every Unit","Only Target"}, 2, "Select if you want Purge only Target or every Unit arround the Pet")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Agi Pot
            br.ui:createCheckbox(section,"Potion")
            -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Seventh Demon","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF001st Only","|cff00FF002nd Only","|cffFFFF00Both","|cffFF0000None"}, 1, "|cffFFFFFFSelect Trinket Usage.")
            -- Bestial Wrath
            br.ui:createCheckbox(section,"Bestial Wrath")
            -- Trueshot
            br.ui:createCheckbox(section,"Aspect of the Wild")
            -- Stampede
            br.ui:createCheckbox(section,"Stampede")
            -- A Murder of Crows / Barrage
            br.ui:createCheckbox(section,"A Murder Of Crows / Barrage")
            -- Spitting Cobra
            br.ui:createCheckbox(section,"Spitting Cobra")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Aspect of the Turtle
            br.ui:createSpinner(section, "Aspect Of The Turtle",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Concussive Shot
            br.ui:createSpinner(section, "Concussive Shot", 10, 5, 40, 5, "|cffFFBB00Minmal range to use at.")
            -- Disengage
            br.ui:createSpinner(section, "Disengage", 5, 5, 40, 5, "|cffFFBB00Minmal range to use at.")
            -- Exhilaration
            br.ui:createSpinner(section, "Exhilaration",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Feign Death
            br.ui:createSpinner(section, "Feign Death", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Counter Shot
            br.ui:createCheckbox(section,"Counter Shot")
            -- Intimidation
            br.ui:createCheckbox(section,"Intimidation")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  6)
            -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  6)
            -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
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
local equiped
local focus
local focusRegen
local gcd
local gcdMax
local has
local inCombat
local inRaid
local item
local level
local lowestHP
local mode
local opener
local php
local potion
local race
local solo
local spell
local talent
local traits
local ttm
local units
local use

-- General Locals
local critChance
local flying
local hastar
local healPot
local leftCombat
local lootDelay
local petCombat
local profileStop
local pullTimer
local thp
local ttd

-----------------
--- Functions ---
-----------------
local function isTankInRange()
    if isChecked("Auto Growl") then
        if #br.friend > 1 then
            for i = 1, #br.friend do
                local friend = br.friend[i]
                if friend.GetRole()== "TANK" and not UnitIsDeadOrGhost(friend.unit) and getDistance(friend.unit) < 100 then
                return true
                end
            end
        end
    end
    return false
end

--------------------
--- Action Lists ---
--------------------
local actionList = {}
-- Action List - Pet Management
actionList.PetManagement = function()
    local petActive = IsPetActive()
    local petExists = UnitExists("pet")
    local petDead = UnitIsDeadOrGhost("pet")
    local validTarget = isValidUnit("pettarget")

    if IsMounted() or flying or UnitHasVehicleUI("player") or CanExitVehicle("player") then
        waitForPetToAppear = GetTime()
    elseif mode.petSummon ~= 6 then
        local callPet = spell["callPet"..mode.petSummon]
        if waitForPetToAppear ~= nil and GetTime() - waitForPetToAppear > 2 then
            if cast.able.dismissPet() and petExists and petActive and (callPet == nil or UnitName("pet") ~= select(2,GetCallPetSpellInfo(callPet))) then
                if cast.dismissPet() then waitForPetToAppear = GetTime(); return true end
            elseif callPet ~= nil then
                if petDead then
                    if cast.able.revivePet() then
                        if cast.revivePet() then waitForPetToAppear = GetTime(); return true end
                    end
                elseif not petDead and not (petActive or petExists) and not buff.playDead.exists("pet") then
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
        if petMode == nil then petMode = "None" end
        if not inCombat then
            if petMode == "Passive" then
                if petMode == "Assist" then PetAssistMode() end
                if petMode == "Defensive" then PetDefensiveMode() end
            end
            for i = 1, NUM_PET_ACTION_SLOTS do
                local name, _, _, _, isActive = GetPetActionInfo(i)
                if isActive then
                    if name == "PET_MODE_ASSIST" then petMode = "Assist" end
                    if name == "PET_MODE_DEFENSIVE" then petMode = "Defensive" end
                end
            end
        elseif inCombat and petMode ~= "Passive" then
            PetPassiveMode()
            petMode = "Passive"
        end
        -- Pet Attack / retreat
        if (not UnitExists("pettarget") or not validTarget) and (inCombat or petCombat) and not buff.playDead.exists("pet") then
            for i=1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if isValidUnit(thisUnit) or isDummy() then
                    PetAttack(thisUnit)
                    break
                end
            end
        elseif (not inCombat or (inCombat and not validTarget and not isDummy())) and IsPetAttackActive() then
            PetStopAttack()
            PetFollow()
        end
    end
    -- Cat-like Refelexes
    if isChecked("Cat-like Reflexes") and cast.able.catlikeReflexes() and inCombat and getHP("pet") <= getOptionValue("Cat-like Reflexes") then
        if cast.catlikeReflexes() then return end
    end
    -- Claw
    if isChecked("Claw") and cast.able.claw("pettarget") and validTarget and getDistance("pettarget","pet") < 5 then
        if cast.claw("pettarget") then return end
    end
    -- Dash
    if isChecked("Dash") and cast.able.dash() and validTarget and getDistance("pettarget","pet") > 10 then
        if cast.dash() then return end
    end
    -- Spirit Mend
    if isChecked("Spirit Mend") and petExists and not petDead and not petDead and lowestHP < getOptionValue("Spirit Mend") then
        local thisUnit = br.friend[1].unit
        if cast.spiritmend(thisUnit) then return end
    end

    -- Purge
    if isChecked("Purge") then
        if enemies.yards5p then
            for i = 1, #enemies.yards5p do 
                local thisUnit = enemies.yards5p[i]
                if getValue("Purge") == 1 or (getValue("Purge") == 2 and UnitIsUnit(thisUnit,"target")) then
                    local dispelled = false
                    local dispelledUnit = "player"
                            --your dispel logic
                    if canDispel(thisUnit,spell.spiritShock) then
                        if cast.able.spiritShock(thisUnit) then
                            if cast.spiritShock(thisUnit) then dispelled = true; dispelledUnit = thisUnit; break end
                        elseif cast.able.chiJiTranq(thisUnit) then
                            if cast.chiJiTranq(thisUnit) then dispelled = true; dispelledUnit = thisUnit; break end
                        elseif cast.able.naturesGrace(thisUnit) then
                            if cast.naturesGrace(thisUnit) then dispelled = true; dispelledUnit = thisUnit; break end
                        elseif cast.able.netherShock(thisUnit) then
                            if cast.netherShock(thisUnit) then dispelled = true; dispelledUnit = thisUnit; break end
                        elseif cast.able.sonicBlast(thisUnit) then
                            if cast.sonicBlast(thisUnit) then dispelled = true; dispelledUnit = thisUnit; break end
                        elseif cast.able.soothingWater(thisUnit) then
                            if cast.soothingWater(thisUnit) then dispelled = true; dispelledUnit = thisUnit; break end
                        elseif cast.able.sporeCloud(thisUnit) then
                            if cast.sporeCloud(thisUnit) then dispelled = true; dispelledUnit = thisUnit; break end
                        end
                    end
                end
            end
            if dispelled then print("casting dispel on ".. UnitName(dispelledUnit)); return end
        end
    end

    -- Growl
    if isChecked("Auto Growl") then
        local _, autoCastEnabled = GetSpellAutocast(spell.growl)
        if autoCastEnabled then DisableSpellAutocast(spell.growl) end
        if not isTankInRange() and not buff.prowl.exists("pet") then
            if cast.able.misdirection("pet") and #enemies.yards8p > 1 then
                if cast.misdirection("pet") then return end
            end
            if cast.able.growl() then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not isTanking(thisUnit) then
                        if cast.growl(thisUnit) then return end
                    end
                end
            end
        end
    end
    -- Play Dead / Wake Up
    if cast.able.playDead() and not buff.playDead.exists("pet") and getHP("pet") < 20 then
        if cast.playDead() then return end
    end
    if cast.able.wakeUp() and buff.playDead.exists("pet") and not buff.feignDeath.exists() and getHP("pet") >= 20 then
        if cast.wakeUp() then return end
    end
    -- Prowl
    if isChecked("Prowl") and not inCombat and cast.able.prowl() and #enemies.yards20p > 0 and not buff.prowl.exists("pet") and not IsResting() then
        if cast.prowl() then return end
    end
    -- Mend Pet
    if isChecked("Mend Pet") and cast.able.mendPet() and petExists and not petDead
        and not petDead and getHP("pet") < getOptionValue("Mend Pet") and not buff.mendPet.exists("pet")
    then
        if cast.mendPet() then return end
    end
    -- Spirit Mend
    if isChecked("Spirit Mend") and petExists and not petDead and not petDeads and lowestHP < getOptionValue("Spirit Mend") then
        local thisUnit = br.friend[1]
        if cast.spiritmend(thisUnit) then return end
    end
end

-- Action List - Extras
actionList.Extras = function()
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
              if inInstance or inRaid then
                  for i = 1, #br.friend do
                      if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and UnitAffectingCombat(br.friend[i].unit) then
                          if cast.misdirection(br.friend[i].unit) then return end
                      end
                  end
              else
                  if GetUnitExists("pet") then
                      if cast.misdirection("pet") then return end
                  end
              end
          end
    end
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    if useDefensive() then
        -- Pot/Stoned
        if isChecked("Pot/Stoned") and (use.able.healthstone() or canUse(healPot))
            and php <= getOptionValue("Pot/Stoned") and inCombat and (hasHealthPot() or has.healthstone())
        then
            if use.able.healthstone() then
                use.healthstone()
            elseif canUse(healPot) then
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
        if isChecked("Aspect Of The Turtle") and php <= getOptionValue("Aspect Of The Turtle") then
            if cast.aspectOfTheTurtle("player") then return end
        end
        -- Concussive Shot
        if isChecked("Concussive Shot") and getDistance("target") < getOptionValue("Concussive Shot") and isValidUnit("target") then
            if cast.concussiveShot("target") then return end
        end
        -- Disengage
        if isChecked("Disengage") and getDistance("target") < getOptionValue("Disengage") and isValidUnit("target") then
            if cast.disengage("player") then return end
        end
        -- Exhilaration
        if isChecked("Exhilaration") and php <= getOptionValue("Exhilaration") then
            if cast.exhilaration("player") then return end
        end
        -- Feign Death
        if isChecked("Feign Death") and php <= getOptionValue("Feign Death") then
            if cast.feignDeath("player") then return end
        end
    end -- End Defensive Toggle
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if useInterrupts() then
        local thisUnit
        -- Counter Shot
        if isChecked("Counter Shot") then
            for i=1, #enemies.yards40 do
            thisUnit = enemies.yards40[i]
                if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                    if cast.counterShot(thisUnit) then return end
                end
            end
        end
        -- Intimidation
        if isChecked("Intimidation") and not UnitIsDeadOrGhost("pet") and not deadPets then
            for i=1, #enemies.yards40 do
                thisUnit = enemies.yards40[i]
                if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                    if cast.intimidation(thisUnit) then return end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if useCDs() then
        -- Trinkets
        if buff.aspectOfTheWild.exists() then 
            if (getOptionValue("Trinkets") == 1 or getOptionValue("Trinkets") == 3) and canUse(13) then
                useItem(13)
            end
            if (getOptionValue("Trinkets") == 2 or getOptionValue("Trinkets") == 3) and canUse(14) then
                useItem(14)
            end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
            if isChecked("Racial") then --and cd.racial.remain() == 0 then
                -- ancestral_call,if=cooldown.bestial_wrath.remains>30
                -- fireblood,if=cooldown.bestial_wrath.remains>30
                -- berserking,if=buff.aspect_of_the_wild.up&(target.time_to_die>cooldown.berserking.duration+duration|(target.health.pct<35|!talent.killer_instinct.enabled))|target.time_to_die<13
                -- blood_fury,if=buff.aspect_of_the_wild.up&(target.time_to_die>cooldown.blood_fury.duration+duration|(target.health.pct<35|!talent.killer_instinct.enabled))|target.time_to_die<16
                -- lights_judgment,if=pet.cat.buff.frenzy.up&pet.cat.buff.frenzy.remains>gcd.max|!pet.cat.buff.frenzy.up
                if cast.able.racial() then 
                    if cd.bestialWrath.remain() > 30 and (race == "MagharOrc" or race == "DarkIronDwarf") then 
                        if cast.racial() then return end 
                    end 
                    if (buff.aspectOfTheWild.exists() 
                        and (race == "Troll" and ((ttd(units.dyn40) > cd.berserking.remain() + buff.berserking.remain() or (thp(units.dyn40) < 35 or not talent.killerInstinct)) or ttd(units.dyn40) < 13)) 
                        or (race == "Orc" and ((ttd(units.dyn40) > cd.racial.remain() + buff.bloodFury.remain() or (thp(units.dyn40) < 35 or not talent.killerInstinct)) or ttd(units.dyn40) < 16))) 
                    then
                        if cast.racial() then return end
                    end
                    if (buff.frenzy.exists("pet") and buff.frenzy.remains("pet") > gcdMax or not buff.frenzy.exists("pet") and race == "LightforgedDraenei") then
                        if cast.racial() then return end
                    end
                end
            end
            -- Potion
            --potion,if=buff.bestial_wrath.up&buff.aspect_of_the_wild.up&(target.health.pct<35|!talent.killer_instinct.enabled)|target.time_to_die<25
            -- if cast.able.potion() and (buff.bestialWrath.exists() and buff.aspectOfTheWild.exists() and (thp(units.dyn40) < 35 or not talent.killerInstinct) or ttd(units.dyn40) < 25) then
            --     if cast.potion() then return end
            -- end
        end
        -- Aspect of the Wild
        -- aspect_of_the_wild,precast_time=1.1,if=!azerite.primal_instincts.enabled
        if isChecked("Aspect of the Wild") and cast.able.aspectOfTheWild() and (not traits.primalInstincts.active) then
            if cast.aspectOfTheWild() then return end
        end
        -- Bestial Wrath
        -- bestial_wrath,precast_time=1.5,if=azerite.primal_instincts.enabled
        if isChecked("Bestial Wrath") and mode.bestialWrath == 1 and cast.able.bestialWrath() and (traits.primalInstincts.active) then
            if cast.bestialWrath() then return end
        end
    end -- End useCooldowns check
end -- End Action List - Cooldowns

-- Action List - Opener
actionList.Opener = function()
    -- Start Attack
    -- auto_attack
    if isChecked("Opener") and isBoss("target") and not opener.complete then
        if isValidUnit("target") and getDistance("target") < 5
            and getFacing("player","target") and getSpellCD(61304) == 0
        then
            -- Begin
            if not opener.OPN1 then
                Print("Starting Opener")
                opener.count = opener.count + 1
                opener.OPN1 = true
            elseif opener.OPN1 then
                Print("Opener Complete")
                opener.count = 0
                opener.complete = true
            end
        end
    elseif (UnitExists("target") and not isBoss("target")) or not isChecked("Opener") then
        opener.complete = true
    end
end -- End Action List - Opener

-- Action List - Single Target
actionList.St = function()
    -- Barbed Shot
    -- barbed_shot,if=pet.cat.buff.frenzy.up&pet.cat.buff.frenzy.remains<=gcd.max|full_recharge_time<gcd.max&cooldown.bestial_wrath.remains|azerite.primal_instincts.enabled&cooldown.aspect_of_the_wild.remains<gcd
    if cast.able.barbedShot() and (buff.frenzy.exists("pet") and buff.frenzy.remains("pet") <= gcdMax 
        or charges.barbedShot.timeTillFull() < gcdMax and cd.bestialWrath.remain() 
        or traits.primalInstincts.active and cd.aspectOfTheWild.remain() < gcdMax) 
    then
        if cast.barbedShot() then return end
    end
    -- Aspect of the Wild
    -- aspect_of_the_wild
    if isChecked("Aspect of the Wild") and useCDs() and cast.able.aspectOfTheWild() then
        if cast.aspectOfTheWild() then return end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if isChecked("A Murder Of Crows / Barrage") and mode.murderOfCrows == 1 and cast.able.aMurderOfCrows() then
        if cast.aMurderOfCrows() then return end
    end
    -- Stampede
    -- stampede,if=buff.aspect_of_the_wild.up&buff.bestial_wrath.up|target.time_to_die<15
    if isChecked("Stampede") and talent.stampede and cast.able.stampede() and (buff.aspectOfTheWild.exists() and buff.bestialWrath.exists() or ttd(units.dyn40) < 15) then
        if cast.stampede() then return end
    end
    -- Bestial Wrath
    -- bestial_wrath,if=cooldown.aspect_of_the_wild.remains>20|target.time_to_die<15
    if isChecked("Bestial Wrath") and mode.bestialWrath == 1 and cast.able.bestialWrath() and (cd.aspectOfTheWild.remain() > 20 or ttd(units.dyn40) < 15) then
        if cast.bestialWrath() then return end
    end
    -- Kill Command
    -- kill_command
    if cast.able.killCommand() then
        if cast.killCommand() then return end
    end
    -- Chimera Shot
    -- chimaera_shot
    if cast.able.chimaeraShot() then
        if cast.chimaeraShot() then return end
    end
    -- Dire Beast
    -- dire_beast
    if cast.able.direBeast() then
        if cast.direBeast() then return end
    end
    -- Barbed Shot
    -- barbed_shot,if=pet.cat.buff.frenzy.down&(charges_fractional>1.8|buff.bestial_wrath.up)|cooldown.aspect_of_the_wild.remains<pet.cat.buff.frenzy.duration-gcd&azerite.primal_instincts.enabled|azerite.dance_of_death.rank>1&buff.dance_of_death.down&crit_pct_current>40|target.time_to_die<9
    if cast.able.barbedShot() and (not buff.frenzy.exists("pet") and (charges.barbedShot.frac() > 1.8 
        or buff.bestialWrath.exists()) or cd.aspectOfTheWild.remain() < buff.frenzy.remain("pet") - gcdMax 
        and traits.primalInstincts.active or traits.danceOfDeath.rank > 1 and not buff.danceOfDeath.exists() 
        and critChance > 40 or ttd(units.dyn40) < 9) 
    then
        if cast.barbedShot() then return end
    end
    -- Barrage
    -- barrage
    if isChecked("A Murder Of Crows / Barrage") and cast.able.barrage() then
        if cast.barrage() then return end
    end
    -- Cobra Shot
    -- cobra_shot,if=(focus-cost+focus.regen*(cooldown.kill_command.remains-1)>action.kill_command.cost|cooldown.kill_command.remains>1+gcd)&cooldown.kill_command.remains>1
    if cast.able.cobraShot() and ((focus - cast.cost.cobraShot() + focusRegen * (cd.killCommand.remain() - 1) > cast.cost.killCommand() 
        or cd.killCommand.remain() > 1 + gcdMax) and cd.killCommand.remain() > 1) 
    then
        if cast.cobraShot() then return end
    end
    -- Spitting Cobra
    -- spitting_cobra
    if isChecked("Spitting Cobra") and talent.spittingCobra and cast.able.spittingCobra() then
        if cast.spittingCobra() then return end
    end
    -- Barbed Shot
    -- barbed_shot,if=charges_fractional>1.4
    if cast.able.barbedShot() and (charges.barbedShot.frac() > 1.4) then
        if cast.barbedShot() then return end
    end
end -- End Action List - Single Target

-- Action List - Cleave
actionList.Cleave = function()
    -- Barbed Shot
    -- barbed_shot,target_if=min:dot.barbed_shot.remains,if=pet.cat.buff.frenzy.up&pet.cat.buff.frenzy.remains<=gcd.max
    if cast.able.barbedShot() and (buff.frenzy.exists("pet") and buff.frenzy.remain("pet") <= gcdMax) then
        if cast.barbedShot() then return end
    end
    -- Multishot
    -- multishot,if=gcd.max-pet.cat.buff.beast_cleave.remains>0.25
    if mode.rotation == 1 and #enemies.yards8p >= getOptionValue("Units To AoE") 
        and #enemies.yards8p > 2 and cast.able.multishot() and (gcdMax - buff.beastCleave.remain("pet") > 0.25) 
    then
        if cast.multishot() then return end
    end
    -- Barbeb Shot
    -- barbed_shot,target_if=min:dot.barbed_shot.remains,if=full_recharge_time<gcd.max&cooldown.bestial_wrath.remains
    if cast.able.barbedShot() and (charges.barbedShot.timeTillFull() < gcdMax and cd.bestialWrath.remain()) then
        if cast.barbedShot() then return end
    end
    -- Aspect of the Wild
    -- aspect_of_the_wild
    if isChecked("Aspect of the Wild") and useCDs() and cast.able.aspectOfTheWild() then
        if cast.aspectOfTheWild() then return end
    end
    -- Stampede
    -- stampede,if=buff.aspect_of_the_wild.up&buff.bestial_wrath.up|target.time_to_die<15
    if isChecked("Stampede") and talent.stampede and cast.able.stampede() 
        and (buff.aspectOfTheWild.exists() and buff.bestialWrath.exists() or ttd(units.dyn40) < 15) 
    then
        if cast.stampede() then return end
    end
    -- Bestial Wrath
    -- bestial_wrath,if=cooldown.aspect_of_the_wild.remains_guess>20|talent.one_with_the_pack.enabled|target.time_to_die<15
    if isChecked("Bestial Wrath") and mode.bestialWrath == 1 and cast.able.bestialWrath() 
        and (cd.aspectOfTheWild.remains() > 20 or talent.oneWithThePack or ttd(units.dyn40) < 15) 
    then
        if cast.bestialWrath() then return end
    end
    -- Chimera Shot
    -- chimaera_shot
    if cast.able.chimaeraShot() then
        if cast.chimaeraShot() then return end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if isChecked("A Murder Of Crows / Barrage") and mode.murderOfCrows == 1 and cast.able.aMurderOfCrows() then
        if cast.aMurderOfCrows() then return end
    end
    -- Barrage
    -- barrage
    if isChecked("A Murder Of Crows / Barrage") and cast.able.barrage() then
        if cast.barrage() then return end
    end
    -- Kill Command
    -- kill_command,if=active_enemies<4|!azerite.rapid_reload.enabled
    if cast.able.killCommand() and (#enemies.yards8p < 4 or not traits.rapidReload.active) then
        if cast.killCommand() then return end
    end
    -- Dire Beast
    -- dire_beast
    if cast.able.direBeast() then
        if cast.direBeast() then return end
    end
    -- Barbed Shot
    -- barbed_shot,target_if=min:dot.barbed_shot.remains,if=pet.cat.buff.frenzy.down&(charges_fractional>1.8|buff.bestial_wrath.up)|cooldown.aspect_of_the_wild.remains<pet.cat.buff.frenzy.duration-gcd&azerite.primal_instincts.enabled|charges_fractional>1.4|target.time_to_die<9
    if cast.able.barbedShot() and (not buff.frenzy.exists("pet") and (charges.barbedShot.frac() > 1.8 or buff.bestialWrath.exists()) 
        or cd.aspectOfTheWild.remain() < buff.frenzy.remain("pet") - gcdMax and traits.primalInstincts.active 
        or charges.barbedShot.frac() > 1.4 or ttd(units.dyn40) < 9) 
    then
        if cast.barbedShot() then return end
    end
    -- Multishot
    -- multishot,if=azerite.rapid_reload.enabled&active_enemies>2
    if mode.rotation == 1 and #enemies.yards8p >= getOptionValue("Units To AoE") and #enemies.yards8p > 2 
        and cast.able.multishot() and (traits.rapidReload.active and #enemies.yards40 > 2) 
    then
        if cast.multishot() then return end
    end
    -- Cobra Shot
    -- cobra_shot,if=cooldown.kill_command.remains>focus.time_to_max&(active_enemies<3|!azerite.rapid_reload.enabled)
    if cast.able.cobraShot() and (cd.killCommand.remain() > ttm and (#enemies.yards40 < 3 or not traits.rapidReload.active)) then
        if cast.cobraShot() then return end
    end
    -- Spitting Cobra
    -- spitting_cobra
    if isChecked("Spitting Cobra") and talent.spittingCobra and cast.able.spittingCobra() then
        if cast.spittingCobra() then return end
    end
end -- End Action List - Cleave

-- Action List - PreCombat
actionList.PreCombat = function()
    if not inCombat and not (IsFlying() or IsMounted()) then
        -- Flask / Crystal
        -- flask,type=flask_of_the_seventh_demon
        if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheSeventhDemon.exists() and canUse(item.flaskOfTheSeventhDemon) then
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if use.flaskOfTheSeventhDemon() then return true end
        end
        if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and canUse(item.repurposedFelFocuser) then
            if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
            if use.repurposedFelFocuser() then return true end
        end
        if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUse(item.oraliusWhisperingCrystal) then
            if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if use.oraliusWhisperingCrystal() then return true end
        end
        -- Init Combat
        if isValidUnit("target") and getDistance("target") < 40 and opener.complete then
            -- Auto Shot
            StartAttack()
        end
    end -- End No Combat
    -- Opener
    if actionList.Opener() then return true end
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------
    --- Locals ---
    --------------
    -- BR API
    buff                               = br.player.buff
    cast                               = br.player.cast
    cd                                 = br.player.cd
    charges                            = br.player.charges
    debuff                             = br.player.debuff
    enemies                            = br.player.enemies
    equiped                            = br.player.equiped
    focus                              = br.player.power.focus.amount()
    focusRegen                         = br.player.power.focus.regen()
    gcd                                = br.player.gcd
    gcdMax                             = br.player.gcdMax
    has                                = br.player.has
    inCombat                           = br.player.inCombat
    inRaid                             = br.player.instance=="raid"
    item                               = br.player.spell.items
    level                              = br.player.level
    lowestHP                           = br.friend[1].hp
    mode                               = br.player.mode
    opener                             = br.player.opener
    php                                = br.player.health
    potion                             = br.player.potion
    race                               = br.player.race
    solo                               = #br.friend < 2
    spell                              = br.player.spell
    talent                             = br.player.talent
    traits                             = br.player.traits
    ttm                                = br.player.power.focus.ttm()
    units                              = br.player.units
    use                                = br.player.use

    -- Global Functions
    critChance                         = GetCritChance()
    flying                             = IsFlying()
    hastar                             = UnitExists("target")
    healPot                            = getHealthPot()
    lootDelay                          = getOptionValue("LootDelay")
    petCombat                          = UnitAffectingCombat("pet")
    pullTimer                          = PullTimerRemain()
    thp                                = getHP
    ttd                                = getTTD

    -- Get Best Unit for Range
    -- units.get(range, aoe)
    units.get(40)

    -- Get List of Enemies for Range
    -- enemies.get(range, from unit, no combat, variable)
    enemies.get(40)
    enemies.get(5,"pet")
    enemies.get(8,"pet")
    enemies.get(20,"pet")

    -- General Vars
    if isChecked("Spirit Mend") then br.friend:Update() end
    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil or (not inCombat and not UnitExists("target") and profileStop == true) then
        profileStop = false
    end

    -- Opener Reset
    if (not inCombat and not GetObjectExists("target")) or opener.complete == nil then
        opener.count = 0
        opener.OPN1 = false

        opener.complete = false
    end

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
        -----------------
        --- Pet Logic ---
        -----------------
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
        if inCombat and isValidUnit("target") and opener.complete then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return true end
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            if getOptionValue("APL Mode") == 1 then
                -- auto_shot
                StartAttack()
                -- call_action_list,name=cds
                if actionList.Cooldowns() then return end
                -- call_action_list,name=st,if=active_enemies<2
                if (mode.rotation == 1 and #enemies.yards8p < getOptionValue("Units To AoE")) or mode.rotation == 3 then
                    if actionList.St() then return end
                end
                -- call_action_list,name=cleave,if=active_enemies>1
                if (mode.rotation == 1 and #enemies.yards8p >= getOptionValue("Units To AoE")) or mode.rotation == 2 then
                    if actionList.Cleave() then return end
                end
            end -- End SimC APL
        end --End In Combat
    end --End Rotation Logic
end -- End runRotation
local id = 253
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
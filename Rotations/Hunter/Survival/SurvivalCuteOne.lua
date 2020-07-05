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
    -- Pet summon
    PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Summon Pet 1", tip = "Summon Pet 1", highlight = 1, icon = br.player.spell.callPet1 },
        [2] = { mode = "2", value = 2 , overlay = "Summon Pet 2", tip = "Summon Pet 2", highlight = 1, icon = br.player.spell.callPet2 },
        [3] = { mode = "3", value = 3 , overlay = "Summon Pet 3", tip = "Summon Pet 3", highlight = 1, icon = br.player.spell.callPet3 },
        [4] = { mode = "4", value = 4 , overlay = "Summon Pet 4", tip = "Summon Pet 4", highlight = 1, icon = br.player.spell.callPet4 },
        [5] = { mode = "5", value = 5 , overlay = "Summon Pet 5", tip = "Summon Pet 5", highlight = 1, icon = br.player.spell.callPet5 },
        [6] = { mode = "None", value = 6 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.callPet }
    };
    CreateButton("PetSummon",7,0)
    -- Aspect of the Eagle
    aotEModes = {
        [1] = { mode = "On", value = 1 , overlay = "Aspect of the Eagle Enabled", tip = "Aspect of the Eagle Enabled", highlight = 1, icon = br.player.spell.aspectOfTheEagle },
        [2] = { mode = "Off", value = 2 , overlay = "Aspect of the Eagle Disabled", tip = "Aspect of the Eagle Disabled", highlight = 0, icon = br.player.spell.aspectOfTheEagle }
    };
    CreateButton("aotE",8,0)
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
            -- Heart Essence
            br.ui:createCheckbox(section, "Use Essence")
        br.ui:checkSectionState(section)
        -- Pet Options
        section = br.ui:createSection(br.ui.window.profile, "Pet")
            -- Auto Summon
            -- br.ui:createDropdown(section, "Auto Summon", {"Pet 1","Pet 2","Pet 3","Pet 4","Pet 5","No Pet"}, 1, "Select the pet you want to use")
            br.ui:createDropdownWithout(section, "Pet Target", {"Dynamic Unit", "Only Target", "Any Unit", "Assist"},1,"Select how you want pet to acquire targets.")
            -- Auto Attack/Passive
            br.ui:createCheckbox(section, "Auto Attack/Passive")
            -- Auto Growl
            br.ui:createCheckbox(section, "Auto Growl")
            -- Bite/Claw
            br.ui:createCheckbox(section, "Bite / Claw")
            -- Cat-like Reflexes
            br.ui:createSpinner(section, "Cat-like Reflexes", 30, 0, 100, 5, "|cffFFFFFFPet Health Percent to Cast At")
            -- Dash
            br.ui:createCheckbox(section, "Dash")
            -- Fetch
            br.ui:createCheckbox(section, "Fetch")
            -- Play Dead / Wake Up
            br.ui:createSpinner(section, "Play Dead / Wake Up", 25,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Prowl/Spirit Walk
            br.ui:createCheckbox(section, "Prowl / Spirit Walk")
            -- Mend Pet
            br.ui:createSpinner(section, "Mend Pet",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Purge
            br.ui:createDropdown(section, "Purge", {"Every Unit","Only Target"}, 2, "Select if you want Purge only Target or every Unit arround the Pet")
            -- Spirit Mend
            br.ui:createSpinner(section, "Spirit Mend", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Survival of the Fittest
            br.ui:createSpinner(section, "Survival of the Fittest", 40, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
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
local debug
local enemies
local equiped
local essence
local focus
local focusMax
local focusRegen
local gcd
local gcdMax
local has
local inCombat
local inInstance
local inRaid
local item
local level
local mode
local opener
local php
local race
local spell
local talent
local units
local use
-- General Locals
local haltProfile
local hastar
local healPot
local minCount
local profileStop
local ttd
-- Profile Specific Locals
local actionList = {}
local carveCdr
local eagleUnit
local lowestBloodseeker
local lowestSerpentSting
local maxLatentPoison
local eagleRange

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

local function outOfMelee()
    if focus + castRegen(spell.killCommand) < focusMax then return false end
    for i = 1, #enemies.yards40f do
        local thisUnit = enemies.yards40f[i]
        if getDistance(thisUnit) > eagleRange and debuff.serpentSting.refresh(thisUnit) then return false end
    end
    return true
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
        if isValidUnit("target") and getDistance("target") < 40 then
            local misdirectUnit = "pet"
            if getOptionValue("Misdirection") == 1 and (inInstance or inRaid) then
                for i = 1, #br.friend do
                    local thisFriend = br.friend[i].unit
                    if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(thisFriend) == "TANK")
                        and not UnitIsDeadOrGhost(thisFriend)
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
            if GetUnitExists(misdirectUnit) then
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
        if isChecked("Aspect Of The Turtle") and cast.able.aspectOfTheTurtle()
            and php <= getOptionValue("Aspect Of The Turtle") and inCombat
        then
            if cast.aspectOfTheTurtle("player") then return true end
        end
        -- Exhilaration
        if isChecked("Exhilaration") and cast.able.exhilaration() and php <= getOptionValue("Exhilaration") then
            if cast.exhilaration("player") then return true end
        end
        -- Feign Death
        if isChecked("Feign Death") and cast.able.feignDeath()
            and php <= getOptionValue("Feign Death") and inCombat
        then
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
    if useCDs() and getDistance(eagleUnit) < eagleRange then
        -- Trinkets
        if isChecked("Trinkets") then
            for i = 13, 14 do
                if use.able.slot(i) and not (equiped.ashvanesRazorCoral(i) or equiped.galecallersBoon(i) or equiped.azsharasFontOfPower(i)) then
                    use.slot(i)
                end
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
        if isChecked("Potion") and inRaid and use.able.potionOfFocusedResolve() and useCDs() and buff.coordinatedAssault.exists()
        and ((race == "Orc" or race == "Troll") and buff.racial.exists()
        or not (race == "Orc" or race == "Troll") or ttd(units.dyn5) < 26)
        then
            use.potionOfFocusedResolve()
        end
    end -- End useCooldowns check
    -- Aspect of the Eagle
    -- aspect_of_the_eagle,if=target.distance>=6
    if mode.aotE == 1 and cast.able.aspectOfTheEagle() and (getDistance("target") >= 6)
    and (getOptionValue("Aspect of the Eagle") == 1 or (getOptionValue("Aspect of the Eagle") == 2 and useCDs()))
    then
        if cast.aspectOfTheEagle() then return end
    end
    -- Ashvane's Razor Coral
    -- use_item,name=ashvanes_razor_coral,if=equipped.dribbling_inkpod&(debuff.razor_coral_debuff.down|time_to_pct_30<1|(health.pct<30&buff.guardian_of_azeroth.up|buff.memory_of_lucid_dreams.up))|(!equipped.dribbling_inkpod&(buff.memory_of_lucid_dreams.up|buff.guardian_of_azeroth.up)|debuff.razor_coral_debuff.down)|target.time_to_die<20
    if equiped.ashvanesRazorCoral() and use.able.ashvanesRazorCoral() and equiped.dribblingInkpod() and ((not debuff.razorCoral.exists(eagleUnit)
        or getHP(eagleUnit) <= 30 or (getHP(eagleUnit) < 30 and buff.guardianOfAzeroth.exists() or buff.memoryOfLucidDreams.exists()))
        or (not equiped.dribblingInkpod() and (buff.memoryOfLucidDreams.exists() or buff.guardianOfAzeroth.exists()) or not debuff.razorCoral.exists(eqgleUnit))
        or (ttd(eagleUnit) < 20 and useCDs()))
    then
        use.ashvanesRazorCoral()
        return
    end
    -- Galecaller's Boon
    -- use_item,name=galecallers_boon,if=cooldown.memory_of_lucid_dreams.remains|talent.wildfire_infusion.enabled&cooldown.coordinated_assault.remains|cooldown.cyclotronic_blast.remains|!essence.memory_of_lucid_dreams.major&cooldown.coordinated_assault.remains
    if equiped.galecallersBoon() and use.able.galecallersBoon() and (cd.memoryOfLucidDreams.remain() > 0
        or talent.wildfireInfusion and cd.coordinatedAssault.remain() > 0 or cd.pocketSizedComputationDevice.remain() > 0
        or not essence.memoryOfLucidDreams.active and cd.coordinatedAssault.remain() > 0)
    then
        use.galecallersBoon()
        return
    end
    -- Azshara's Font of Power
    -- use_item,name=azsharas_font_of_power
    if equiped.azsharasFontOfPower() and use.able.azsharasFontOfPower() then
        use.azsharasFontOfPower()
        return
    end
    -- Heart Essence
    if isChecked("Use Essence") then
        -- focused_azerite_beam
        if cast.able.focusedAzeriteBeam() and enemies.yards30r >= minCount then
            if cast.focusedAzeriteBeam(nil,"rect",minCount,8) then
                return true
            end
        end
        -- blood_of_the_enemy,if=buff.coordinated_assault.up
        if useCDs() and cast.able.bloodOfTheEnemy() and buff.coordinatedAssault.exists() then
            if cast.bloodOfTheEnemy() then return end
        end
        -- purifying_blast
        if cast.able.purifyingBlast() and #enemies.yards8t >= minCount then
            if cast.purifyingBlast("best", nil, minCount, 8) then return true end
        end
        -- guardian_of_azeroth
        if useCDs() and cast.able.guardianOfAzeroth() then
            if cast.guardianOfAzeroth() then return end
        end
        -- ripple_in_space
        if useCDs() and cast.able.rippleInSpace() then
            if cast.rippleInSpace() then return end
        end
        -- concentrated_flame,if=full_recharge_time<1*gcd
        if cast.able.concentratedFlame() and charges.concentratedFlame.timeTillFull() < 1 * gcdMax then
            if cast.concentratedFlame() then return end
        end
        -- the_unbound_force,if=buff.reckless_force.up
        if cast.able.theUnboundForce() and buff.recklessForce.exists() then
            if cast.theUnboundForce() then return end
        end
        -- worldvein_resonance
        if cast.able.worldveinResonance() and getDistance(eagleUnit) < eagleRange then
            if cast.worldveinResonance() then return end
        end
        -- reaping_flames,if=target.health.pct>80|target.health.pct<=20|target.time_to_pct_20>30
        if cast.able.reapingFlames() and (getHP("target") > 80 or getHP("target") <= 20 or ttd("target",20) > 30) then
            if cast.reapingFlames() then return end
        end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=essence.memory_of_lucid_dreams.major&!cooldown.memory_of_lucid_dreams.remains
    if essence.memoryOfLucidDreams.active and cd.memoryOfLucidDreams.remain() == 0 then
        if cast.mongooseBite() then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=essence.memory_of_lucid_dreams.major&full_recharge_time<1.5*gcd&focus<action.mongoose_bite.cost&!cooldown.memory_of_lucid_dreams.remains
    if essence.memoryOfLucidDreams.active and charges.wildfireBomb.timeTillFull() < 1.5 * gcdMax
        and focus < cast.cost.mongooseBite() and cd.memoryOfLucidDreams.remain() == 0
    then
        if cast.wildfireBomb() then return end
    end
    -- Memory of Lucid Dreams
    -- memory_of_lucid_dreams,if=focus<focus.max-30&buff.coordinated_assault.up
    if useCDs() and isChecked("Use Essence") and cast.able.memoryOfLucidDreams() and getDistance(eagleUnit) < eagleRange
        and focus < focusMax - 30 and buff.coordinatedAssault.exists()
    then
        if cast.memoryOfLucidDreams() then return end
    end
end -- End Action List - Cooldowns

-- Action List - Single Target
actionList.St = function()
    -- Harpoon
    -- harpoon,if=talent.terms_of_engagement.enabled
    if cast.able.harpoon() and mode.harpoon == 1 and talent.termsOfEngagement and getDistance(units.dyn30) > 5 then
        if cast.harpoon() then debug("[ST] Harpoon - "..UnitName(units.dyn30)) return end
    end
    -- Flanking Strike
    -- flanking_strike,if=focus+cast_regen<focus.max
    if cast.able.flankingStrike() and (focus + castRegen(spell.flankingStrike) < focusMax) then
        if cast.flankingStrike() then debug("[ST] Flanking Strike - "..UnitName(units.dyn15)) return end
    end
    -- Raptor Strike
    -- raptor_strike,if=buff.coordinated_assault.up&(buff.coordinated_assault.remains<1.5*gcd|buff.blur_of_talons.up&buff.blur_of_talons.remains<1.5*gcd)
    if cast.able.raptorStrike(eagleUnit) and not talent.mongooseBite and getDistance(eagleUnit) <= eagleRange
        and buff.coordinatedAssault.exists() and (buff.coordinatedAssault.remain() < 1.5 * gcdMax
            or (buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < 1.5 * gcdMax))
    then
        if cast.raptorStrike(eagleUnit,nil,1,eagleRange) then debug("[ST] Raptor Strike (Coordinated Assault) - "..UnitName(eagleUnit)) return end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.coordinated_assault.up&(buff.coordinated_assault.remains<1.5*gcd|buff.blur_of_talons.up&buff.blur_of_talons.remains<1.5*gcd)
    if cast.able.mongooseBite(eagleUnit) and talent.mongooseBite and getDistance(eagleUnit) <= eagleRange
        and buff.coordinatedAssault.exists() and (buff.coordinatedAssault.remain() < 1.5 * gcdMax
            or (buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < 1.5 * gcdMax))
    then
        if cast.mongooseBite(eagleUnit,nil,1,eagleRange) then debug("[ST] Mongoose Bite (Coordinated Assault) - "..UnitName(eagleUnit)) return end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max
    if cast.able.killCommand(lowestBloodseeker) and (focus + castRegen(spell.killCommand) < focusMax - focusRegen or outOfMelee()) then
        if cast.killCommand(lowestBloodseeker) then debug("[ST] Kill Command - "..UnitName(lowestBloodseeker)) return end
    end
    -- Serpent Sting
    -- serpent_sting,if=buff.vipers_venom.up&buff.vipers_venom.remains<1*gcd
    if cast.able.serpentSting() and buff.vipersVenom.exists() and buff.vipersVenom.remain() < 1 * gcdMax then
        if cast.serpentSting() then debug("[ST} Serpent Sting (Viper's Venom) - "..UnitName(units.dyn40)) return end
    end
    -- Steel Trap
    -- steel_trap,if=focus+cast_regen<focus.max
    if cast.able.steelTrap() and focus + focusRegen < focusMax then
        if cast.steelTrap("best",nil,1,5) then debug("[ST] Steel Trap") return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=focus+cast_regen<focus.max&!ticking&!buff.memory_of_lucid_dreams.up&(full_recharge_time<1.5*gcd|!dot.wildfire_bomb.ticking&!buff.coordinated_assault.up|!dot.wildfire_bomb.ticking&buff.mongoose_fury.stack<1)|time_to_die<18&!dot.wildfire_bomb.ticking
    if cast.able.wildfireBomb() and focus + focusRegen < focusMax and not debuff.wildfireBomb.exists(units.dyn40) and not buff.memoryOfLucidDreams.exists()
        and (charges.wildfireBomb.timeTillFull() < 1.5 * gcdMax or not debuff.wildfireBomb.exists(units.dyn40) and not buff.coordinatedAssault.exists()
        or not debuff.wildfireBomb.exists(units.dyn40) and buff.mongooseFury.stack() < 1) or (ttd(units.dyn40) < 18 and not debuff.wildfireBomb.exists(units.dyn40))
    then
        if cast.wildfireBomb(nil,"aoe") then debug("[ST] Wildfire Bomb - "..UnitName(units.dyn40)) return end
    end
    -- -- Mongoose Bite
    -- -- mongoose_bite,if=buff.mongoose_fury.stack>5&!cooldown.coordinated_assault.remains
    -- if cast.able.mongooseBite() and talent.mongooseBite
    --     and buff.mongooseFury.stack() > 5 and cd.coordinatedAssault.remain() == 0
    -- then
    --     if cast.mongooseBite(eagleUnit,nil,1,eagleRange) then return end
    -- end
    -- Serpent Sting
    -- serpent_sting,if=buff.vipers_venom.up&dot.serpent_sting.remains<4*gcd|dot.serpent_sting.refreshable&!buff.coordinated_assault.up
    if cast.able.serpentSting() and (buff.vipersVenom.exists() and debuff.serpentSting.remain(units.dyn40) < 4 * gcdMax
        or debuff.serpentSting.refresh(units.dyn40) and not buff.coordinatedAssault.exists())
    then
        if cast.serpentSting() then debug("[ST] Serpent Sting - "..UnitName(units.dyn40)) return end
    end
    -- A Murder of Crows
    -- a_murder_of_crows,if=!buff.coordinated_assault.up
    if cast.able.aMurderOfCrows() and (getOptionValue("A Murder of Crows") == 1 or (getOptionValue("A Murder of Crows") == 2 and useCDs()))
        and not buff.coordinatedAssault.exists()
    then
        if cast.aMurderOfCrows() then debug("[ST] A Murder of Crows - "..UnitName(units.dyn40)) return end
    end
    -- Coordinated Assault
    -- coordinated_assault
    if cast.able.coordinatedAssault() and eagleScout() > 0
        and (getOptionValue("Coordinated Assault") == 1 or (getOptionValue("Coordinated Assault") == 2 and useCDs()))
    then
        if cast.coordinatedAssault() then debug("[ST] Coordinated Assault") return end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.mongoose_fury.up|focus+cast_regen>focus.max-20&talent.vipers_venom.enabled|focus+cast_regen>focus.max-1&talent.terms_of_engagement.enabled|buff.coordinated_assault.up
    if cast.able.mongooseBite(eagleUnit) and talent.mongooseBite and getDistance(eagleUnit) <= eagleRange
        and ((buff.mongooseFury.exists() or (focus + focusRegen > focusMax - 20 and talent.vipersVenom))
            or (focus + focusRegen > focusMax - 1 and talent.termsOfEngagement) or buff.coordinatedAssault.exists())
    then
        if cast.mongooseBite(eagleUnit,nil,1,eagleRange) then debug("[ST] Mongoose Bite - "..UnitName(eagleUnit)) return end
    end
    -- Raptor Strike
    -- raptor_strike
    if cast.able.raptorStrike(eagleUnit) and not talent.mongooseBite and getDistance(eagleUnit) <= eagleRange then
        if cast.raptorStrike(eagleUnit,nil,1,eagleRange) then debug("[ST] Raptor Strike - "..UnitName(eagleUnit)) return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=dot.wildfire_bomb.refreshable
    if cast.able.wildfireBomb() and debuff.wildfireBomb.refresh(units.dyn40) then
        if cast.wildfireBomb(nil,"aoe") then debug("[ST] Wildfire Bomb (Refresh) - "..UnitName(units.dyn40)) return end
    end
    -- Serpent Sting
    -- serpent_sting,if=buff.vipers_venom.up
    if cast.able.serpentSting() and buff.vipersVenom.exists() then
        if cast.serpentSting() then debug("[ST] Serpent Sting (Refresh) - "..UnitName(units.dyn40)) return end
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
    if cast.able.carve() and (debuff.shrapnelBomb.exists(units.dyn5)) then
        if cast.carve(nil,"cone",1,5) then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=!talent.guerrilla_tactics.enabled|full_recharge_time<gcd
    if cast.able.wildfireBomb() and (not talent.guerrillaTactics or charges.wildfireBomb.timeTillFull() < gcdMax) then
        if cast.wildfireBomb(nil,"aoe") then return end
    end
    -- Mongoose Bite
    -- mongoose_bite,target_if=max:debuff.latent_poison.stack,if=debuff.latent_poison.stack=10
    if cast.able.mongooseBite(maxLatentPoison) and talent.mongooseBite and debuff.latentPoison.stack(maxLatentPoison) == 10 then
        if cast.mongooseBite(maxLatentPoison,nil,1,eagleRange) then return end
    end
    -- Chakrams
    -- chakrams
    if cast.able.chakrams() and enemies.yards40r > 0 then
        if cast.chakrams(nil,"rect",1,40) then return end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max
    if cast.able.killCommand(lowestBloodseeker) and (focus + castRegen(spell.killCommand) < focusMax or outOfMelee()) then
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
    if cast.able.carve() and (talent.guerrillaTactics) then
        if cast.carve(nil,"cone",1,5) then return end
    end
    -- Flanking Strike
    -- flanking_strike,if=focus+cast_regen<focus.max
    if cast.able.flankingStrike() and (focus + castRegen(spell.flankingStrike) < focusMax) then
        if cast.flankingStrike() then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=dot.wildfire_bomb.refreshable|talent.wildfire_infusion.enabled
    if cast.able.wildfireBomb() and (debuff.wildfireBomb.refresh(units.dyn40) or talent.wildfireInfusion) then
        if cast.wildfireBomb(nil,"aoe") then return end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=buff.vipers_venom.react
    if cast.able.serpentSting(lowestSerpentSting) and canDoT(lowestSerpentSting) and (ttd(lowestSerpentSting) > 3 or isDummy()) and (buff.vipersVenom.exists()) then
        if cast.serpentSting(lowestSerpentSting) then return end
    end
    -- Carve
    -- carve,if=cooldown.wildfire_bomb.remains>variable.carve_cdr%2
    if cast.able.carve() and (cd.wildfireBomb.remain() > carveCdr / 2) then
        if cast.carve(nil,"cone",1,5) then return end
    end
    -- Steel Trap
    -- steel_trap
    if cast.able.steelTrap() then
        if cast.steelTrap("best",nil,1,5) then return end
    end
    -- Harpoon
    -- harpoon,if=talent.terms_of_engagement.enabled
    if cast.able.harpoon() and mode.harpoon == 1 and talent.termsOfEngagement and getDistance(units.dyn30) > 5 then
        if cast.harpoon() then return end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=refreshable&buff.tip_of_the_spear.stack<3
    if cast.able.serpentSting(lowestSerpentSting) and canDoT(lowestSerpentSting) and (ttd(lowestSerpentSting) > 3 or isDummy())
        and (debuff.serpentSting.refresh(lowestSerpentSting) and buff.tipOfTheSpear.stack() < 3)
    then
        if cast.serpentSting(lowestSerpentSting) then return end
    end
    -- Mongoose Bite
    -- mongoose_bite,target_if=max:debuff.latent_poison.stack
    if cast.able.mongooseBite(maxLatentPoison) and talent.mongooseBite and getDistance(maxLatentPoison) <= eagleRange then
        if cast.mongooseBite(maxLatentPoison,nil,1,eagleRange) then return end
    end
    -- Raptor Strike
    -- raptor_strike,target_if=max:debuff.latent_poison.stack
    if cast.able.raptorStrike(maxLatentPoison) and not talent.mongooseBite and getDistance(maxLatentPoison) <= eagleRange then
        if cast.raptorStrike(maxLatentPoison,nil,1,eagleRange) then return end
    end
end -- End Action List - Cleave

-- Action List - Alpha Predator
actionList.ApSt = function()
    -- Mongoose Bite
    -- mongoose_bite,if=buff.coordinated_assault.up&(buff.coordinated_assault.remains<1.5*gcd|buff.blur_of_talons.up&buff.blur_of_talons.remains<1.5*gcd)
    if cast.able.mongooseBite(eagleUnit) and talent.mongooseBite and getDistance(eagleUnit) <= eagleRange
        and buff.coordinatedAssault.exists() and (buff.coordinatedAssault.remain() < 1.5 * gcdMax
            or (buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < 1.5 * gcdMax))
    then
        if cast.mongooseBite(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Raptor Strike
    -- raptor_strike,if=buff.coordinated_assault.up&(buff.coordinated_assault.remains<1.5*gcd|buff.blur_of_talons.up&buff.blur_of_talons.remains<1.5*gcd)
    if cast.able.raptorStrike(eagleUnit) and not talent.mongooseBite and getDistance(eagleUnit) <= eagleRange
        and buff.coordinatedAssault.exists() and (buff.coordinatedAssault.remain() < 1.5 * gcdMax
            or (buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < 1.5 * gcdMax))
    then
        if cast.raptorStrike(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Flanking Strike
    -- flanking_strike,if=focus+cast_regen<focus.max
    if cast.able.flankingStrike() and (focus + castRegen(spell.flankingStrike) < focusMax) then
        if cast.flankingStrike() then return end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=full_recharge_time<1.5*gcd&focus+cast_regen<focus.max
    if cast.able.killCommand(lowestBloodseeker) and charges.killCommand.timeTillFull() < 1.5 * gcdMax
        and (focus + castRegen(spell.killCommand) < focusMax or outOfMelee())
    then
        if cast.killCommand(lowestBloodseeker) then return end
    end
    -- Steel Trap
    -- steel_trap,if=focus+cast_regen<focus.max
    if cast.able.steelTrap() and focus + focusRegen < focusMax then
        if cast.steelTrap("best",nil,1,5) then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=focus+cast_regen<focus.max&!ticking&!buff.memory_of_lucid_dreams.up&(full_recharge_time<1.5*gcd|!dot.wildfire_bomb.ticking&!buff.coordinated_assault.up|!dot.wildfire_bomb.ticking&buff.mongoose_fury.stack<1)|time_to_die<18&!dot.wildfire_bomb.ticking
    if cast.able.wildfireBomb() and focus + focusRegen < focusMax and not debuff.wildfireBomb.exists(units.dyn40) and not buff.memoryOfLucidDreams.exists()
        and (charges.wildfireBomb.timeTillFull() < 1.5 * gcdMax or not debuff.wildfireBomb.exists(units.dyn40) and not buff.coordinatedAssault.exists()
        or not debuff.wildfireBomb.exists(units.dyn40) and buff.mongooseFury.stack() < 1) or (ttd(units.dyn40) < 18 and not debuff.wildfireBomb.exists(units.dyn40)) 
    then
        if cast.wildfireBomb(nil,"aoe") then return end
    end
    -- Serpent Sting
    -- serpent_sting,if=!dot.serpent_sting.ticking&!buff.coordinated_assault.up
    if cast.able.serpentSting() and not debuff.serpentSting.exists(units.dyn40) and not buff.coordinatedAssault.exists() then
        if cast.serpentSting() then return end
    end
    -- Kill Command
    -- kill_command,if=focus+cast_regen<focus.max&(buff.mongoose_fury.stack<5|focus<action.mongoose_bite.cost)
    if cast.able.killCommand(lowestBloodseeker) and ((focus + castRegen(spell.killCommand) < focusMax
        and (buff.mongooseFury.stack() < 5 or focus < cast.cost.mongooseBite())) or outOfMelee())
    then
        if cast.killCommand(lowestBloodseeker) then return end
    end
    -- Serpent Sting
    -- serpent_sting,if=refreshable&!buff.coordinated_assault.up&buff.mongoose_fury.stack<5
    if cast.able.serpentSting() and debuff.serpentSting.refresh(units.dyn40) and not buff.coordinatedAssault.exists() and buff.mongooseFury.stack() < 5 then
        if cast.serpentSting() then return end
    end
    -- A Murder of Crows
    -- a_murder_of_crows,if=!buff.coordinated_assault.up
    if cast.able.aMurderOfCrows() and (getOptionValue("A Murder of Crows") == 1 or (getOptionValue("A Murder of Crows") == 2 and useCDs()))
        and not buff.coordinatedAssault.exists()
    then
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
    -- mongoose_bite,if=buff.mongoose_fury.up|focus+cast_regen>focus.max-10|buff.coordinated_assault.up
    if cast.able.mongooseBite(eagleUnit) and talent.mongooseBite and getDistance(eagleUnit) <= eagleRange
        and (buff.mongooseFury.exists() or focus + focusRegen > focusMax - 10 or buff.coordinatedAssault.exists())
    then
        if cast.mongooseBite(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Raptor Strike
    -- raptor_strike
    if cast.able.raptorStrike(eagleUnit) and not talent.mongooseBite and getDistance(eagleUnit) <= eagleRange then
        if cast.raptorStrike(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=!ticking
    if cast.able.wildfireBomb() and not debuff.wildfireBomb.exists(units.dyn40) then
        if cast.wildfireBomb(nil,"aoe") then return end
    end
end

-- Action List - Alpha Predator / Wildfire Infusion
actionList.ApWfi = function()
    -- Mongoose Bite
    -- mongoose_bite,if=buff.blur_of_talons.up&buff.blur_of_talons.remains<gcd
    if cast.able.mongooseBite(eagleUnit) and talent.mongooseBite and getDistance(eagleUnit) <= eagleRange
        and buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < gcdMax
    then
        if cast.mongooseBite(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Raptor Strike
    -- raptor_strike,if=buff.blur_of_talons.up&buff.blur_of_talons.remains<gcd
    if cast.able.raptorStrike(eagleUnit) and not talent.mongooseBite and getDistance(eagleUnit) <= eagleRange
        and buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < gcdMax
    then
        if cast.raptorStrike(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Serpent Sting
    -- serpent_sting,if=!dot.serpent_sting.ticking
    if cast.able.serpentSting() and not debuff.serpentSting.exists(units.dyn40) and not buff.coordinatedAssault.exists() then
        if cast.serpentSting() then return end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if cast.able.aMurderOfCrows() and (getOptionValue("A Murder of Crows") == 1 or (getOptionValue("A Murder of Crows") == 2 and useCDs())) then
        if cast.aMurderOfCrows() then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=full_recharge_time<1.5*gcd|focus+cast_regen<focus.max&(next_wi_bomb.volatile&dot.serpent_sting.ticking&dot.serpent_sting.refreshable|next_wi_bomb.pheromone&!buff.mongoose_fury.up&focus+cast_regen<focus.max-action.kill_command.cast_regen*3)
    if cast.able.wildfireBomb() and (charges.wildfireBomb.timeTillFull() < 1.5 * gcdMax or focus + focusRegen < focusMax
        and (nextBomb(spell.volatile) and debuff.serpentSting.exists(units.dyn40) and debuff.serpentSting.refresh(units.dyn40)
            or nextBomb(spell.pheromone) and not buff.mongooseFury.exists() and focus + focusRegen < focusMax - castRegen(spell.killCommand) * 3))
    then
        if cast.wildfireBomb(nil,"aoe") then return end
    end
    -- Coordinated Assault
    -- coordinated_assault
    if cast.able.coordinatedAssault() and eagleScout() > 0
        and (getOptionValue("Coordinated Assault") == 1 or (getOptionValue("Coordinated Assault") == 2 and useCDs()))
    then
        if cast.coordinatedAssault() then return end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.mongoose_fury.remains&next_wi_bomb.pheromone
    if cast.able.mongooseBite() and talent.mongooseBite and buff.mongooseFury.exists() and nextBomb(spell.pheromone) then
        if cast.mongooseBite(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Kill Command
    -- kill_command,if=full_recharge_time<1.5*gcd&focus+cast_regen<focus.max-20
    if cast.killCommand() and charges.killCommand.timeTillFull() < 1.5 * gcdMax
        and (focus + castRegen(spell.killCommand) < focusMax - 20 or outOfMelee())
    then
        if cast.killCommand() then return end
    end
    -- Steel Trap
    -- steel_trap,if=focus+cast_regen<focus.max
    if cast.able.steelTrap() and focus + focusRegen < focusMax then
        if cast.steelTrap("best",nil,1,5) then return end
    end
    -- Raptor Strike
    -- raptor_strike,if=buff.tip_of_the_spear.stack=3|dot.shrapnel_bomb.ticking
    if cast.able.raptorStrike(eagleUnit) and not talent.mongooseBite and getDistance(eagleUnit) <= eagleRange
        and (buff.tipOfTheSpear.stack() == 3 or debuff.shrapnelBomb.exists(units.dyn40))
    then
        if cast.raptorStrike(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=dot.shrapnel_bomb.ticking
    if cast.able.mongooseBite(eagleUnit) and talent.mongooseBite and getDistance(eagleUnit) <= eagleRange
        and debuff.shrapnelBomb.exists(units.dyn40)
    then
        if cast.mongooseBite(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.shrapnel&focus>30&dot.serpent_sting.remains>5*gcd
    if cast.able.wildfireBomb() and nextBomb(spell.shrapnel) and focus > 30 and debuff.serpentSting.remain(units.dyn40) > 5 * gcdMax then
        if cast.wildfireBomb(nil,"aoe") then return end
    end
    -- Chakrams
    -- chakrams,if=!buff.mongoose_fury.remains
    if cast.able.chakrams() and enemies.yards40r > 0 and not buff.mongooseFury.exists() then
        if cast.chakrams(nil,"rect",1,40) then return end
    end
    -- Serpent Sting
    -- serpent_sting,if=refreshable
    if cast.able.serpentSting() and debuff.serpentSting.refresh(units.dyn40) then
        if cast.serpentSting() then return end
    end
    -- Kill Command
    -- kill_command,if=focus+cast_regen<focus.max&(buff.mongoose_fury.stack<5|focus<action.mongoose_bite.cost)
    if cast.able.killCommand() and  ((focus + castRegen(spell.killCommand) < focusMax
        and (buff.mongooseFury.stack() < 5 or focus < cast.cost.mongooseBite())) or outOfMelee()) then
        if cast.killCommand() then return end
    end
    -- Raptor Strike
    -- raptor_strike
    if cast.able.raptorStrike(eagleUnit) and not talent.mongooseBite and getDistance(eagleUnit) <= eagleRange then
        if cast.raptorStrike(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.mongoose_fury.up|focus>40|dot.shrapnel_bomb.ticking
    if cast.able.mongooseBite(eagleUnit) and talent.mongooseBite and getDistance(eagleUnit) <= eagleRange
        and (buff.mongooseFury.exists() or focus > 40 or debuff.shrapnelBomb.exists(units.dyn40))
    then
        if cast.mongooseBite(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.volatile&dot.serpent_sting.ticking|next_wi_bomb.pheromone|next_wi_bomb.shrapnel&focus>50
    if cast.able.wildfireBomb() and (nextBomb(spell.volatileBomb) and debuff.serpentSting.exists(units.dyn40)
        or nextBomb(spell.pheromoneBomb) or nextBomb(spell.shrapnelBomb) and focus > 50)
    then
        if cast.wildfireBomb(nil,"aoe") then return end
    end
end

-- Action List - Wildfire Infusion
actionList.Wfi = function()
    -- Harpoon
    -- harpoon,if=focus+cast_regen<focus.max&talent.terms_of_engagement.enabled
    if cast.able.harpoon() and mode.harpoon == 1 and focus + focusRegen < focusMax
        and talent.termsOfEngagement and getDistance(units.dyn30) > 5
    then
        if cast.harpoon() then return end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.blur_of_talons.up&buff.blur_of_talons.remains<gcd
    if cast.able.mongooseBite(eagleUnit) and talent.mongooseBite and getDistance(eagleUnit) <= eagleRange
        and buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < gcdMax
    then
        if cast.mongooseBite(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Raptor Strike
    -- raptor_strike,if=buff.blur_of_talons.up&buff.blur_of_talons.remains<gcd
    if cast.able.raptorStrike(eagleUnit) and not talent.mongooseBite and getDistance(eagleUnit) <= eagleRange
        and buff.blurOfTalons.exists() and buff.blurOfTalons.remain() < gcdMax
    then
        if cast.raptorStrike(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Serpent Sting
    -- serpent_sting,if=buff.vipers_venom.up&buff.vipers_venom.remains<1.5*gcd|!dot.serpent_sting.ticking
    if cast.able.serpentSting() and ((buff.vipersVenom.exists() and buff.vipersVenom.remain() < 1.5 * gcdMax)
        or not debuff.serpentSting.exists(units.dyn40))
    then
        if cast.serpentSting() then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=full_recharge_time<1.5*gcd&focus+cast_regen<focus.max|(next_wi_bomb.volatile&dot.serpent_sting.ticking&dot.serpent_sting.refreshable|next_wi_bomb.pheromone&!buff.mongoose_fury.up&focus+cast_regen<focus.max-action.kill_command.cast_regen*3)
    if cast.able.wildfireBomb() and (charges.wildfireBomb.timeTillFull() < 1.5 * gcdMax
        or (nextBomb(spell.volatile) and debuff.serpentSting.refresh(units.dyn40))
        or (nextBomb(spell.pheromone) and not buff.mongooseFury.exists() and focus + focusRegen < focusMax - castRegen(spell.killCommand) * 3))
    then
        if cast.wildfireBomb(nil,"aoe") then return end
    end
    -- Kill Command
    -- kill_command,if=focus+cast_regen<focus.max-focus.regen
    if cast.able.killCommand() and (focus + castRegen(spell.killCommand) < focusMax - focusRegen or outOfMelee()) then
        if cast.killCommand() then return end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if cast.able.aMurderOfCrows() and (getOptionValue("A Murder of Crows") == 1 or (getOptionValue("A Murder of Crows") == 2 and useCDs())) then
        if cast.aMurderOfCrows() then return end
    end
    -- Steel Trap
    -- steel_trap,if=focus+cast_regen<focus.max
    if cast.able.steelTrap() and focus + focusRegen < focusMax then
        if cast.steelTrap("best",nil,1,5) then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=full_recharge_time<1.5*gcd
    if cast.able.wildfireBomb() and charges.wildfireBomb.timeTillFull() < 1.5 * gcdMax then
        if cast.wildfireBomb(nil,"aoe") then return end
    end
    -- Coordinated Assault
    -- coordinated_assault
    if cast.able.coordinatedAssault() and eagleScout() > 0
        and (getOptionValue("Coordinated Assault") == 1 or (getOptionValue("Coordinated Assault") == 2 and useCDs()))
    then
        if cast.coordinatedAssault() then return end
    end
    -- Serpent Sting
    -- serpent_sting,if=buff.vipers_venom.up&dot.serpent_sting.remains<4*gcd
    if cast.able.serpentSting() and ((buff.vipersVenom.exists() and debuff.serpentSting.remain(units.dyn40) < 4 * gcdMax)
        or (debuff.serpentSting.refresh(units.dyn40) and not buff.coordinatedAssault.exists()))
    then
        if cast.serpentSting() then return end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=dot.shrapnel_bomb.ticking|buff.mongoose_fury.stack=5
    if cast.able.mongooseBite() and talent.mongooseBite and (debuff.shrapnelBomb.exists(units.dyn40) or buff.mongooseFury.stack() == 5) then
        if cast.mongooseBite(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.shrapnel&dot.serpent_sting.remains>5*gcd
    if cast.able.wildfireBomb() and nextBomb(spell.shrapnel) and debuff.serpentSting.remain(units.dyn40) > 5 * gcdMax then
        if cast.wildfireBomb(nil,"aoe") then return end
    end
    -- Serpent Sting
    -- serpent_sting,if=refreshable
    if cast.able.serpentSting() and debuff.serpentSting.refresh(units.dyn40) then
        if cast.serpentSting() then return end
    end
    -- Chakrams
    -- chakrams,if=!buff.mongoose_fury.remains
    if cast.able.chakrams() and enemies.yards40r > 0 and not buff.mongooseFury.exists() then
        if cast.chakrams(nil,"rect",1,40) then return end
    end
    -- Mongoose Bite
    -- mongoose_bite
    if cast.able.mongooseBite(eagleUnit) and talent.mongooseBite and getDistance(eagleUnit) <= eagleRange then
        if cast.mongooseBite(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Raptor Strike
    -- raptor_strike
    if cast.able.raptorStrike(eagleUnit) and not talent.mongooseBite and getDistance(eagleUnit) <= eagleRange then
        if cast.raptorStrike(eagleUnit,nil,1,eagleRange) then return end
    end
    -- Serpent Sting
    -- serpent_sting,if=buff.vipers_venom.up
    if cast.able.serpentSting() and buff.vipersVenom.exists() then
        if cast.serpentSting() then return end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.volatile&dot.serpent_sting.ticking|next_wi_bomb.pheromone|next_wi_bomb.shrapnel
    if cast.able.wildfireBomb() and ((nextBomb(spell.volatileBomb) and debuff.serpentSting.exists(units.dyn40))
        or nextBomb(spell.pheromoneBomb) or nextBomb(spell.shrapnelBomb))
    then
        if cast.wildfireBomb(nil,"aoe") then return end
    end
end

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
        if isValidUnit("target") and getDistance("target") < eagleRange
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
            elseif opener.OPN1 and not opener.CA1 then
                if level < 40 or cd.coordinatedAssault.remain() > gcd then
                    castOpenerFail("coordinatedAssault","CA1",opener.count)
                elseif cast.able.coordinatedAssault() then
                    castOpener("coordinatedAssault","CA1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Serpent Sting
            elseif opener.CA1 and not opener.SS1 then
                if level < 12 or debuff.serpentSting.exists("target") then
                    castOpenerFail("serpentSting","SS1",opener.count)
                elseif cast.able.serpentSting() then
                    castOpener("serpentSting","SS1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Wildfire Bomb
            elseif opener.SS1 and not opener.WB1 then
                if level < 20 or charges.wildfireBomb.count() == 0 then
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
    elseif (UnitExists("target") and (getOptionValue("Opener") == 2 and not useCDs())) or getOptionValue("Opener") == 3 then
        opener.complete = true
    end
end -- End Action List - Opener

-- Action List - Pre-Combat
actionList.PreCombat = function()
    -- Flask / Crystal
    -- flask,type=flask_of_the_seventh_demon
    -- Flask / Crystal
    -- flask
    local opValue = getOptionValue("Elixir")
    if opValue == 1 and inRaid and use.able.greaterFlaskOfTheCurrents()
        and not buff.greaterFlaskOfTheCurrents.exists()
    then
        if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
        if buff.felFocus.exists() then buff.felFocus.cancel() end
        if use.greaterFlaskOfTheCurrents() then return true end
    elseif opValue == 2 and use.able.repurposedFelFocuser() and not buff.felFocus.exists()
        and (not inRaid or (inRaid and not buff.greaterFlaskOfTheCurrents.exists()))
    then
        if buff.greaterFlaskOfTheCurrents.exists() then buff.greaterFlaskOfTheCurrents.cancel() end
        if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
        if use.repurposedFelFocuser() then return true end
    elseif opValue == 3 and use.able.oraliusWhisperingCrystal()
        and not buff.whispersOfInsanity.exists()
    then
        if buff.greaterFlaskOfTheCurrents.exists() then buff.greaterFlaskOfTheCurrents.cancel() end
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
        if cast.able.serpentSting("target") and (ttd("target") > 3 or isDummy()) and not debuff.serpentSting.exists("target") then
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
    --------------------------------------
    --- Load Additional Rotation Files ---
    --------------------------------------
    if actionList.PetManagement == nil then
        loadSupport("PetCuteOne")
        actionList.PetManagement = br.rotations.support["PetCuteOne"]
    end
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    debuff                                        = br.player.debuff
    debug                                         = br.addonDebug
    enemies                                       = br.player.enemies
    equiped                                       = br.player.equiped
    essence                                       = br.player.essence
    focus                                         = br.player.power.focus.amount()
    focusMax                                      = br.player.power.focus.max()
    focusRegen                                    = br.player.power.focus.regen()
    gcd                                           = br.player.gcd
    gcdMax                                        = br.player.gcdMax
    has                                           = br.player.has
    inCombat                                      = br.player.inCombat
    inInstance                                    = br.player.instance=="party"
    inRaid                                        = br.player.instance=="raid"
    item                                          = br.player.items
    level                                         = br.player.level
    mode                                          = br.player.mode
    opener                                        = br.player.opener
    php                                           = br.player.health
    race                                          = br.player.race
    spell                                         = br.player.spell
    talent                                        = br.player.talent
    units                                         = br.player.units
    use                                           = br.player.use
    -- General Locals
    hastar                                        = GetObjectExists("target")
    healPot                                       = getHealthPot()
    minCount                                      = useCDs() and 1 or 3
    profileStop                                   = profileStop or false
    ttd                                           = getTTD
    haltProfile                                   = (inCombat and profileStop) or (IsMounted() or IsFlying()) or pause() or buff.feignDeath.exists() or mode.rotation==4
    -- Units
    units.get(5)
    units.get(15)
    units.get(30)
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(5,"pet")
    enemies.get(8,"target")
    enemies.get(8,"pet")
    enemies.get(20,"pet")
    enemies.get(30)
    enemies.get(30,"pet")
    enemies.yards30r = getEnemiesInRect(10,30,false) or 0
    enemies.get(40)
    enemies.get(40,"player",true)
    enemies.get(40,"player",false,true)
    enemies.yards40r = getEnemiesInRect(10,40,false) or 0
    -- Opener Reset
    if (not inCombat and not GetObjectExists("target")) or opener.complete == nil then
        opener.count = 0
        opener.OPN1 = false
        opener.CA1 = false
        opener.SS1 = false
        opener.WB1 = false
        opener.RS1 = false
        opener.KC1 = false
        opener.complete = false
    end
    -- Profile Specific Locals
    eagleUnit                                     = buff.aspectOfTheEagle.exists() and units.dyn40 or units.dyn5
    eagleRange                                    = buff.aspectOfTheEagle.exists() and 40 or 5
    lowestBloodseeker                             = debuff.bloodseeker.lowest(40,"remain")
    lowestSerpentSting                            = debuff.serpentSting.lowest(40,"remain")
    maxLatentPoison                               = debuff.latentPoison.max(eagleRange,"stack")

    -- variable,name=carve_cdr,op=setif,value=active_enemies,value_else=5,condition=active_enemies<5
    if #enemies.yards5 < 5 then carveCdr = #enemies.yards5 else carveCdr = 5 end

    if eagleUnit == nil then eagleUnit = "target" end

    -----------------
    --- Pet Logic ---
    -----------------
    if actionList.PetManagement() then return true end
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop then
        profileStop = false
    elseif haltProfile then
        if cast.able.playDead() and cast.last.feignDeath() and not buff.playDead.exists("pet") then
            if cast.playDead() then return end
        end
        StopAttack()
        if isDummy() then ClearTarget() end
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -----------------
        --- Pet Logic ---
        -----------------
        -- if actionList.PetManagement() then return true end
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
        if inCombat and isValidUnit("target") and opener.complete and cd.global.remain() == 0 and not cast.current.focusedAzeriteBeam() then
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
                if (mode.rotation == 1 and eagleScout() < 3) or (mode.rotation == 3 and eagleScout() > 0) or level < 28 then
                    -- Mongoose Bite
                    -- mongoose_bite,if=active_enemies=1&(talent.alpha_predator.enabled&target.time_to_die<10|target.time_to_die<5)
                    if cast.able.mongooseBite() and (mode.rotation == 3 or #enemies.yards5 == 1) and (talent.mongooseBite
                        and ((talent.alphaPredator and ttd(eagleUnit) < 10) or ttd(eagleUnit) < 5))
                    then
                        if cast.mongooseBite(eagleUnit,nil,1,eagleRange) then return end
                    end
                    -- Call Action List - Alpha Predator / Wildfire Infusion
                    -- call_action_list,name=apwfi,if=active_enemies<3&talent.chakrams.enabled&talent.alpha_predator.enabled
                    if talent.chakrams and talent.alphaPredator then
                        if actionList.ApWfi() then return end
                    end
                    -- Call Action List - Wildfire Infusion
                    -- call_action_list,name=wfi,if=active_enemies<3&talent.chakrams.enabled
                    if talent.chakrams and not talent.alphaPredator then
                        if actionList.Wfi() then return end
                    end
                    -- Call Action List - Single Target
                    -- call_action_list,name=st,if=active_enemies<3&!talent.alpha_predator.enabled&!talent.wildfire_infusion.enabled
                    if not talent.alphaPredator and not talent.wildfireInfusion then
                        if actionList.St() then return end
                    end
                    -- Call Action List - Alpha Predator
                    -- call_action_list,name=apst,if=active_enemies<3&talent.alpha_predator.enabled&!talent.wildfire_infusion.enabled
                    if talent.alphaPredator and not talent.wildfireInfusion then
                        if actionList.ApSt() then return end
                    end
                    -- Call Action List - Alpha Predator / Wildfire Infusion
                    -- call_action_list,name=apwfi,if=active_enemies<3&talent.alpha_predator.enabled&talent.wildfire_infusion.enabled
                    if talent.alphaPredator and talent.wildfireInfusion then
                        if actionList.ApWfi() then return end
                    end
                    -- Call Action List - Wildfire Infusion
                    -- call_action_list,name=wfi,if=active_enemies<3&!talent.alpha_predator.enabled&talent.wildfire_infusion.enabled
                    if not talent.alphaPredator and talent.wildfireInfusion then
                        if actionList.Wfi() then return end
                    end
                end
                -- Call Action List - Cleave
                -- call_action_list,name=cleave,if=active_enemies>1&!talent.birds_of_prey.enabled|active_enemies>2
                if ((mode.rotation == 1 and (((eagleScout() > 1 or #enemies.yards8t > 1) and not talent.birdsOfPrey)
                        or (eagleScout() > 2 or #enemies.yards8t > 2)))
                    or (mode.rotation == 2 and eagleScout() > 0)) and level >= 28
                then
                    if actionList.Cleave() then return end
                end
                -- Heart Essence - Concentrated Flame
                -- concentrated_flame
                if cast.able.concentratedFlame() then
                    if cast.concentratedFlame() then return end
                end
                -- Racial - Arcane Torrent
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

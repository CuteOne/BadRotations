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
        -- AoE
            br.ui:createSpinnerWithout(section, "Units To AoE", 3, 1, 10, 1, "|cffFFFFFFSet to desired units to start AoE at.")
        br.ui:checkSectionState(section)
    -- Pet Options
        section = br.ui:createSection(br.ui.window.profile, "Pet")
        -- Auto Summon
            br.ui:createDropdown(section, "Auto Summon", {"Pet 1","Pet 2","Pet 3","Pet 4","Pet 5","No Pet"}, 1, "Select the pet you want to use")
        -- Auto Attack/Passive
            br.ui:createCheckbox(section, "Auto Attack/Passive")
        -- Auto Growl
            br.ui:createCheckbox(section, "Auto Growl")
        -- Mend Pet
            br.ui:createSpinner(section, "Mend Pet",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
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
        -- Light's Judgment
            br.ui:createSpinner(section,"Light's Judgment", 3, 1, 5, 1, "|cffFFFFFFSet to desired targets to use Light's Judgment on. Min: 1 / Max: 5 / Interval: 1")
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
        -- Traps Key Toggle
            br.ui:createDropdownWithout(section, "Trap Mode", br.dropOptions.Toggle,  6)
        -- Artifact Key Toggle
            br.ui:createDropdownWithout(section, "Artifact Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugSurvival", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Trap",0.25)
        br.player.mode.traps = br.data.settings[br.selectedSpec].toggles["Trap"]

--------------
--- Locals ---
--------------
        local addsExist                                     = false
        local addsIn                                        = 999
        local animality                                     = false
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local canFlask                                      = canUse(br.player.flask.wod.agilityBig)
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local combo                                         = br.player.comboPoints
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff, debuffcount                           = br.player.debuff, br.player.debuffcount
        local enemies                                       = enemies or {}
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local fatality                                      = false
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local focus, focusMax, focusRegen, focusDeficit     = br.player.power.focus.amount(), br.player.power.focus.max(), br.player.power.focus.regen(), br.player.power.focus.deficit()
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local hasMouse                                      = GetObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local item                                          = br.player.spell.items
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local multidot                                      = (br.player.mode.cleave == 1 or br.player.mode.rotation == 2) and br.player.mode.rotation ~= 3
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local potion                                        = br.player.potion
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local solo                                          = #br.friend < 2
        local friendsInRange                                = friendsInRange
        local spell                                         = br.player.spell
        local t19_4pc                                       = br.player.equiped.t19 >= 4 --TierScan("T19") >= 4
        local t20_2pc                                       = br.player.equiped.t20 >= 2 --TierScan("T20") >= 2
        local t20_4pc                                       = br.player.equiped.t20 >= 4 --TierScan("T20") >= 4
        local talent                                        = br.player.talent
        local trinketProc                                   = false
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.focus.ttm()
        local units                                         = units or {}
        local use                                           = br.player.use

        units.dyn5 = br.player.units(5)
        units.dyn8 = br.player.units(8)
        units.dyn15 = br.player.units(15)
        units.dyn40 = br.player.units(40)
        enemies.yards5 = br.player.enemies(5)
        enemies.yards5t = br.player.enemies(5,br.player.units(5,true))
        enemies.yards8 = br.player.enemies(8)
        enemies.yards8t = br.player.enemies(8,br.player.units(5,true))
        enemies.yards15 = br.player.enemies(15)
        enemies.yards40 = br.player.enemies(40)
        enemies.yards40r = getEnemiesInRect(10,40,false) or 0

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        function focusTimeTill(amount)
            if focus >= amount then return 0.5 end
            return ((amount-focus)/focusRegen)+0.5
        end

        local distance5 = getDistance(units.dyn5)
        local lowestBloodseeker = debuff.bloodseeker.lowest(40,"remain")
        local lowestSerpentSting = debuff.serpentSting.lowest(40,"remain")
        local lowestInternalBleeding = debuff.bloodseeker.lowest(5,"stack")
        local lowestInternalBleeding40 = debuff.bloodseeker.lowest(40,"stack")

    -- SimC Variables
        -- variable,name=can_gcd,value=!talent.mongoose_bite.enabled|buff.mongoose_fury.down|(buff.mongoose_fury.remains-(((buff.mongoose_fury.remains*focus.regen+focus)%action.mongoose_bite.cost)*gcd.max)>gcd.max)
        local canGCD = not talent.mongooseBite or not buff.mongooseFury.exists() or (buff.mongooseFury.remain() - (((buff.mongooseFury.remain() * focusRegen + focus) / cast.cost.mongooseBite()) * gcdMax) > gcdMax)

        -- ChatOverlay(tostring(units.dyn5).." | "..tostring(units.dyn40))

        -- if UnitExists("target") then
        --     ChatOverlay(round2(getDistance("target","player","dist"),2)..", "..round2(getDistance("target","player","dist2"),2)..", "..round2(getDistance("target","player","dist3"),2)..", "..round2(getDistance("target","player","dist4"),2)..", "..round2(getDistance("target"),2))
        -- end
--------------------
--- Action Lists ---
--------------------
    -- Action List - Pet Management
        local function actionList_PetManagement()
            if UnitExists("pet") and IsPetActive() and deadPet then deadPet = false end
            if IsMounted() or IsFlying() or UnitHasVehicleUI("player") or CanExitVehicle("player") then
                waitForPetToAppear = GetTime()
            elseif isChecked("Auto Summon") then
                local callPet = nil
                for i = 1, 5 do
                    if getValue("Auto Summon") == i then callPet = spell["callPet"..i] end
                end
                if waitForPetToAppear ~= nil and GetTime() - waitForPetToAppear > 2 then
                    if cast.able.dismissPet() and UnitExists("pet") and IsPetActive() and (callPet == nil or UnitName("pet") ~= select(2,GetCallPetSpellInfo(callPet))) then
                        if cast.dismissPet() then waitForPetToAppear = GetTime(); return true end
                    elseif callPet ~= nil then
                        if UnitIsDeadOrGhost("pet") or deadPet then
                            if cast.able.heartOfThePhoenix() and inCombat then
                                if cast.heartOfThePhoenix() then waitForPetToAppear = GetTime(); return true end
                            elseif cast.able.revivePet() then
                                if cast.revivePet() then waitForPetToAppear = GetTime(); return true end
                            end
                        elseif not deadPet and not (IsPetActive() or UnitExists("pet")) then
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
                if inCombat and (isValidUnit("target") or isDummy()) and getDistance("target") < 40 and not UnitIsUnit("target","pettarget") then
                    -- Print("Pet is switching to your target.")
                    PetAttack()
                end
                if (not inCombat or (inCombat and not isValidUnit("pettarget") and not isDummy())) and IsPetAttackActive() then
                    PetStopAttack()
                    PetFollow()
                end
            end
            -- Growl
            if isChecked("Auto Growl") then
                local petGrowl = GetSpellInfo(2649)
                if isTankInRange() then
                    DisableSpellAutocast(petGrowl)
                else
                    EnableSpellAutocast(petGrowl)
                end
            end
            -- Mend Pet
            if isChecked("Mend Pet") and cast.able.mendPet() and UnitExists("pet") and not UnitIsDeadOrGhost("pet")
                and not deadPet and getHP("pet") < getOptionValue("Mend Pet") and not buff.mendPet.exists("pet")
            then
                if cast.mendPet() then return end
            end
        end
    -- Action List - Extras
        local function actionList_Extras()
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
        end -- End Action List - Extras
    -- Action List - Defensive
        local function actionList_Defensive()
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
                if isChecked("Aspect Of The Turtle") and cast.able.aspectOfTheTurtle() and php <= getOptionValue("Aspect Of The Turtle") then
                    if cast.aspectOfTheTurtle("player") then return true end
                end
        -- Exhilaration
                if isChecked("Exhilaration") and cast.able.exhilaration() and php <= getOptionValue("Exhilaration") then
                    if cast.exhilaration("player") then return true end
                end
        -- Feign Death
                if isChecked("Feign Death") and cast.able.feignDeath() and php <= getOptionValue("Feign Death") then
                    if cast.feignDeath("player") then return true end
                end
        -- Intimidation
                if isChecked("Intimidation") and cast.able.intimidation() and php <= getOptionValue("Intimidation") then
                    if cast.intimidation("player") then return true end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
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
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            if useCDs() and getDistance(units.dyn5) < 5 then
            -- Trinkets
                if isChecked("Trinkets") then
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- berserking,if=cooldown.coordinated_assault.remains>30
                -- blood_fury,if=cooldown.coordinated_assault.remains>30
                -- ancestral_call,if=cooldown.coordinated_assault.remains>30
                -- fireblood,if=cooldown.coordinated_assault.remains>30
                -- lights_judgment
                -- arcane_torrent,if=cooldown.kill_command.remains>gcd.max&focus<=30
                if isChecked("Racial") then --and cd.racial.remain() == 0 then
                    if (cd.coordinatedAssault.remain() > 30
                        and (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf"))
                        or race == "LightforgedDraenei" or (cd.killCommand.remain() > gcdMax and focus <= 30 and race == "BloodElf")
                    then
                        if race == "LightforgedDraenei" then
                            if cast.racial("target","ground") then return true end
                        else
                            if cast.racial("player") then return true end
                        end
                    end
                end
            -- Potion
                -- potion,if=buff.coordinated_assault.up&(buff.berserking.up|buff.blood_fury.up|!race.troll&!race.orc)
                if isChecked("Potion") and inRaid and use.able.potionOfProlongedPower() and buff.coordinatedAssault.exists()
                    and (buff.berserking.exists() or buff.bloodFury.exists() or not (race == "Orc" or race == "Troll"))
                then
                    use.potionOfProlongedPower()
                end
            end -- End useCooldowns check
            -- Light's Judgment (Argus)
            if isChecked("Light's Judgment") and cast.able.lightsJudgment() then
                if useCDs() then
                    if cast.lightsJudgment("target","ground",1,15) then return true end
                end
                if #enemies.yards8 >= getOptionValue("Light's Judgment") then
                    if cast.lightsJudgment("best",nil,getOptionValue("Light's Judgment"),8) then return true end
                end
            end
        end -- End Action List - Cooldowns
    -- Action List - Pre-Combat
        local function actionList_PreCombat()
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
        -- Food
            -- food,type=food,name=azshari_salad
        -- Augmentation
            -- augmentation,name=defiled
        -- Potion
            -- potion,name=prolonged_power
        -- Pre-pull
            if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

            end -- Pre-Pull
            if isValidUnit("target") and not inCombat and getDistance("target") < 40 then
        -- Steel Trap
                -- steel_trap
                if cast.able.steelTrap() then
                    if cast.steelTrap("best",nil,1,5) then return true end
                end
        -- Start Attack
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) and getDistance("target") < 5 then
                    StartAttack("target")
                end
            end
        end -- End Action List - PreCombat
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or (IsMounted() or IsFlying()) or pause() or buff.feignDeath.exists() or mode.rotation==4 then
            if isChecked("Auto Attack/Passive") and pause() and IsPetAttackActive() and not cast.active.furyOfTheEagle() then
                PetStopAttack()
                PetFollow()
            end
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
    -----------------
    --- Pet Logic ---
    -----------------
            if actionList_PetManagement() then return true end
    -----------------
    --- Defensive ---
    -----------------
            if actionList_Defensive() then return true end
    ------------------
    --- Pre-Combat ---
    ------------------
            if not inCombat and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                if actionList_PreCombat() then return true end
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations ---
-----------------------------
            if inCombat and isValidUnit(units.dyn40) and getDistance(units.dyn5) < 5 then
    -----------------
    --- Pet Logic ---
    -----------------
                if actionList_PetManagement() then return true end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return true end
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
                    if actionList_Cooldowns() then return true end
            -- Steel Trap
                    -- steel_trap
                    if cast.able.steelTrap("best",nil,1,5) then
                        if cast.steelTrap("best",nil,1,5) then return true end
                    end
            -- A Murder of Crows
                    -- a_murder_of_crows
                    if cast.able.aMurderOfCrows() and (getOptionValue("A Murder of Crows") == 1 or (getOptionValue("A Murder of Crows") == 2 and useCDs())) then
                        if cast.aMurderOfCrows() then return end
                    end
            -- Coordinated Assault
                    -- coordinated_assault
                    if cast.able.coordinatedAssault() and (getOptionValue("Coordinated Assault") == 1 or (getOptionValue("Coordinated Assault") == 2 and useCDs())) then
                        if cast.coordinatedAssault() then return end
                    end
            -- Chakrams
                    -- chakrams,if=active_enemies>1
                    if cast.able.chakrams(nil,"rect",1,40) and (enemies.yards40r > 1) then
                        if cast.chakrams(nil,"rect",1,40) then return end
                    end
            -- Kill Command
                    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&buff.tip_of_the_spear.stack<3&active_enemies<2
                    if cast.able.killCommand(lowestBloodseeker) and (focus + focusRegen < focusMax and buff.tipOfTheSpear.stack() < 3 and #enemies.yards40 < 2) then
                        if cast.killCommand(lowestBloodseeker) then return end
                    end
            -- Wildfire Bomb
                    -- wildfire_bomb,if=(focus+cast_regen<focus.max|active_enemies>1)&(dot.wildfire_bomb.refreshable&buff.mongoose_fury.down|full_recharge_time<gcd)
                    if cast.able.wildfireBomb(units.dyn40,"aoe") and ((focus + focusRegen < focusMax or #enemies.yards8t > 1)
                        and (debuff.wildfireBomb.refresh(units.dyn40) and not buff.mongooseFury.exists() or charges.wildfireBomb.timeTillFull() < gcdMax))
                    then
                        if cast.wildfireBomb(units.dyn40,"aoe") then return end
                    end
            -- Kill Command
                    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&buff.tip_of_the_spear.stack<3
                    if cast.able.killCommand(lowestBloodseeker) and (focus + focusRegen < focusMax and buff.tipOfTheSpear.stack() < 3) then
                        if cast.killCommand(lowestBloodseeker) then return end
                    end
            -- Butchery
                    -- butchery,if=(!talent.wildfire_infusion.enabled|full_recharge_time<gcd)&active_enemies>3|(dot.shrapnel_bomb.ticking&dot.internal_bleeding.stack<3)
                    if cast.able.butchery("player","aoe") and talent.butchery and ((not talent.wildfireInfusion or charges.butchery.timeTillFull() < gcdMax)
                        and #enemies.yards8 > 3 or (debuff.shrapnelBomb.exists(units.dyn8) and debuff.internalBleeding.stack(units.dyn8) < 3))
                    then
                        if cast.butchery("player","aoe") then return end
                    end
            -- Serpent Sting
                    -- serpent_sting,if=(active_enemies<2&refreshable&(buff.mongoose_fury.down|(variable.can_gcd&!talent.vipers_venom.enabled)))|buff.vipers_venom.up
                    if cast.able.serpentSting() and ((#enemies.yards40 < 2 and debuff.serpentSting.refresh(units.dyn40)
                        and (not buff.mongooseFury.exists() or (canGCD and not talent.vipersVenom))) or buff.vipersVenom.exists())
                    then
                        if cast.serpentSting() then return end
                    end
            -- Carve
                    -- carve,if=active_enemies>2&(active_enemies<6&active_enemies+gcd<cooldown.wildfire_bomb.remains|5+gcd<cooldown.wildfire_bomb.remains)
                    if cast.able.carve("player","cone",1,5) and not talent.butchery
                        and (#enemies.yards5 > 2 and (#enemies.yards5 < 6 and #enemies.yards5 + gcdMax < cd.wildfireBomb.remain() or 5 + gcdMax < cd.wildfireBomb.remain()))
                    then
                        if cast.carve("player","cone",1,5) then return end
                    end
            -- Harpoon
                    -- harpoon,if=talent.terms_of_engagement.enabled
                    if cast.able.harpoon() and (talent.termsOfEngagement) then
                        if cast.harpoon() then return end
                    end
            -- Flanking Strike
                    -- flanking_strike
                    if cast.able.flankingStrike() then
                        if cast.flankingStrike() then return end
                    end
            -- Chakrams
                    -- chakrams
                    if cast.able.chakrams(nil,"rect",1,40) then
                        if cast.chakrams(nil,"rect",1,40) then return end
                    end
            -- Serpent Sting
                    -- serpent_sting,target_if=min:remains,if=refreshable&buff.mongoose_fury.down|buff.vipers_venom.up
                    if cast.able.serpentSting(lowestSerpentSting) and (debuff.serpentSting.refresh(lowestSerpentSting) and not buff.mongooseFury.exists() or buff.vipersVenom.exists()) then
                        if cast.serpentSting(lowestSerpentSting) then return end
                    end
            -- Aspect of the Eagle
                    -- aspect_of_the_eagle,if=target.distance>=6
                    if cast.able.aspectOfTheEagle() and (getDistance(units.dyn40) >= 6) and (getOptionValue("Aspect of the Eagle") == 1 or (getOptionValue("Aspect of the Eagle") == 2 and useCDs())) then
                        if cast.aspectOfTheEagle() then return end
                    end
            -- Mongoose Bite
                    -- mongoose_bite_eagle,target_if=min:dot.internal_bleeding.stack,if=buff.mongoose_fury.up|focus>60
                    if cast.able.mongooseBite(lowestInternalBleeding40) and talent.mongooseBite and (buff.mongooseFury.exists() or focus > 60) then
                        if cast.mongooseBite(lowestInternalBleeding40) then return end
                    end
                    -- mongoose_bite,target_if=min:dot.internal_bleeding.stack,if=buff.mongoose_fury.up|focus>60
                    if cast.able.mongooseBite(lowestInternalBleeding) and talent.mongooseBite and (buff.mongooseFury.exists() or focus > 60) then
                        if cast.mongooseBite(lowestInternalBleeding) then return end
                    end
            -- Raptor Strike
                    -- raptor_strike_eagle,target_if=min:dot.internal_bleeding.stack
                    if cast.able.raptorStrike(lowestInternalBleeding40) and not talent.mongooseBite then
                        if cast.raptorStrike(lowestInternalBleeding40) then return end
                    end
                    -- raptor_strike,target_if=min:dot.internal_bleeding.stack
                    if cast.able.raptorStrike(lowestInternalBleeding) and not talent.mongooseBite then
                        if cast.raptorStrike(lowestInternalBleeding) then return end
                    end
                end -- End SimC APL
    ------------------------
    --- Ask Mr Robot APL ---
    ------------------------
                if getOptionValue("APL Mode") == 2 then

                end -- End AMR
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation
local id = 255 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.aimedShot },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.multishot },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.arcaneShot },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.aspectOfTheCheetah}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.trueshot },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.trueshot },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.trueshot }
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
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterShot },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterShot }
    };
    CreateButton("Interrupt",4,0)
-- MD Button
    MisdirectionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    CreateButton("Misdirection",5,0)
--Pet summon
    PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Summon Pet 1", tip = "Summon Pet 1", highlight = 1, icon = br.player.spell.callPet1 },
        [2] = { mode = "2", value = 2 , overlay = "Summon Pet 2", tip = "Summon Pet 2", highlight = 1, icon = br.player.spell.callPet2 },
        [3] = { mode = "3", value = 3 , overlay = "Summon Pet 3", tip = "Summon Pet 3", highlight = 1, icon = br.player.spell.callPet3 },
        [4] = { mode = "4", value = 4 , overlay = "Summon Pet 4", tip = "Summon Pet 4", highlight = 1, icon = br.player.spell.callPet4 },
        [5] = { mode = "5", value = 5 , overlay = "Summon Pet 5", tip = "Summon Pet 5", highlight = 1, icon = br.player.spell.callPet5 },
        [6] = { mode = "None", value = 6 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.callPet }
    };
    CreateButton("PetSummon",6,0)
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
        -- Barrage
            br.ui:createCheckbox(section, "Barrage")
        -- Explosive Shot
            -- br.ui:createCheckbox(section, "Explosive Shot")
        -- Misdirection
            br.ui:createDropdownWithout(section,"Misdirection", {"|cff00FF00Tank","|cffFFFF00Focus","|cffFF0000Pet"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        -- Piercing Shot
            -- br.ui:createCheckbox(section, "Piercing Shot")
            br.ui:createSpinnerWithout(section, "Piercing Shot Units", 3, 1, 5, 1, "|cffFFFFFFSet to desired units to cast Piercing Shot")
        -- Heart Essence
            br.ui:createCheckbox(section,"Use Essence")
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
            -- Bite/Claw
            br.ui:createCheckbox(section, "Bite / Claw")
            -- Cat-like Reflexes
            br.ui:createSpinner(section, "Cat-like Reflexes", 30, 0, 100, 5, "|cffFFFFFFPet Health Percent to Cast At")
            -- Dash
            br.ui:createCheckbox(section, "Dash")
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
        -- Agi Pot
            br.ui:createCheckbox(section,"Potion")
        -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Seventh Demon","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Power Reactor")
            br.ui:createCheckbox(section,"Trinkets")
        -- A Murder of Crows
            br.ui:createDropdownWithout(section,"A Murder of Crows", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
        -- Barrage
            br.ui:createDropdownWithout(section,"Barrage", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
        -- Double Tap
            br.ui:createDropdownWithout(section,"Double Tap", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
        -- Explosive Shot
            br.ui:createDropdownWithout(section,"Explosive Shot", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
        -- Piercing Shot
            br.ui:createDropdownWithout(section,"Piercing Shot", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
        -- Rapid Fire
            br.ui:createDropdownWithout(section,"Rapid Fire", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
        -- Trueshot
            br.ui:createDropdownWithout(section,"Trueshot", {"Always", "Cooldown", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Engineering: Shield-o-tronic
            br.ui:createSpinner(section, "Shield-o-tronic",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Aspect of the Turtle
            br.ui:createSpinner(section, "Aspect Of The Turtle",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Bursting Shot
            br.ui:createSpinner(section, "Bursting Shot", 1, 1, 10, 1, "|cffFFBB00Number of Enemies within 8yrds to use at.")
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
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupts",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
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
        -- Explosive Shot Key Toggle
            br.ui:createDropdown(section, "Explosive Shot Mode", br.dropOptions.Toggle,  6)
        -- Piercing Shot Key Toggle
            br.ui:createDropdown(section, "Piercing Shot Mode", br.dropOptions.Toggle,  6)
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
local actionList_PetManagement
local function runRotation()
    if br.timer:useTimer("debugMarksmanship", 0 --[[math.random(0.15,0.3)]]) then
        --print("Running: "..rotationName)

--------------------------------------
--- Load Additional Rotation Files ---
--------------------------------------
        if actionList_PetManagement == nil then
            loadSupport("PetCuteOne")
            actionList_PetManagement = br.rotations.support["PetCuteOne"]
        end

--------------
--- Locals ---
--------------
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff, debuffcount                           = br.player.debuff, br.player.debuffcount
        local enemies                                       = br.player.enemies
        local equiped                                       = br.player.equiped
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local healPot                                       = getHealthPot()
        local inCombat                                      = UnitAffectingCombat("player") --br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local item                                          = br.player.items
        local level                                         = br.player.level
        local mode                                          = br.player.mode
        local multidot                                      = (br.player.mode.cleave == 1 or br.player.mode.rotation == 2) and br.player.mode.rotation ~= 3
        local php                                           = br.player.health
        local potion                                        = br.player.potion
        local power, powerMax, powerRegen, powerDeficit     = br.player.power.focus.amount(), br.player.power.focus.max(), br.player.power.focus.regen(), br.player.power.focus.deficit()
        local pullTimer                                     = PullTimerRemain()
        local racial                                        = br.player.getRacial()
        local solo                                          = #br.friend < 2
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.focus.ttm()
        local traits                                        = br.player.traits
        local units                                         = br.player.units
        local use                                           = br.player.use

        units.get(40)
        enemies.get(5,"pet")
        enemies.get(8)
        enemies.get(8,"pet")
        enemies.get(30,"pet")
        enemies.get(40)
        enemies.get(40,"player",true)
        enemies.get(40,"player",false,true)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if rotationDebug == nil or not inCombat then rotationDebug = "Waiting" end

        local haltProfile = (inCombat and profileStop) or (IsMounted() or IsFlying()) or pause() or buff.feignDeath.exists() or mode.rotation==4

-----------------
--- Varaibles ---
-----------------
        local caExecute = talent.carefulAim and (getHP(units.dyn40) > 80 or getHP(units.dyn40) < 20)

        local function opUseCD(option)
            if option == nil then opValue = 1 else opValue = getOptionValue(option) end
            if opValue == 3 then return false end
            if (opValue == 1 or (opValue == 2 and useCDs())) then return true end
            return false
        end

        -- Explosions Gotta Have More Explosions!
        if br.player.petInfo ~= nil then
            for k,v in pairs(br.player.petInfo) do
                local thisPet = br.player.petInfo[k]
                if thisPet.id == 11492 and #getEnemies(thisPet.unit,5) > 0 then
                    -- Print("Explosions!!!!")
                    CastSpellByName(GetSpellInfo(spell.explosiveShotDetonate))
                    break
                end
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
                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        PetStopAttack()
                        PetFollow()
                        print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
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
        end -- End Action List - Extras
    -- Action List - Defensive
        local function actionList_Defensive()
            if useDefensive() then
        -- Pot/Stoned
                if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned")
                    and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUseItem(5512) then
                        useItem(5512)
                    elseif canUseItem(healPot) then
                        useItem(healPot)
                    end
                end
        -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                        end
                    end
                end
        -- Engineering: Shield-o-tronic
                if isChecked("Shield-o-tronic") and php <= getOptionValue("Shield-o-tronic")
                    and inCombat and canUseItem(118006)
                then
                    useItem(118006)
                end
        -- Aspect of the Turtle
                if isChecked("Aspect Of The Turtle") and php <= getOptionValue("Aspect Of The Turtle") then
                    if cast.aspectOfTheTurtle("player") then return end
                end
        -- Bursting Shot
                if isChecked("Bursting Shot") and #enemies.yards8 >= getOptionValue("Bursting Shot") and inCombat then
                    if cast.burstingShot("player") then return end
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
        local function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemies.yards40f do
                    thisUnit = enemies.yards40f[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("Interrupts")) then
                        if distance < 50 then
        -- Counter Shot
                            if isChecked("Counter Shot") then
                                if cast.counterShot(thisUnit) then return end
                            end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
        -- Trinkets
            -- use_items,if=buff.trueshot.up|!talent.calling_the_shots.enabled|target.time_to_die<20
            if useCDs() and #enemies.yards40f >= 1 then
                if isChecked("Power Reactor") and equiped.vigorTrinket() and use.able.vigorTrinket() then
                    if buff.vigorEngaged.exists() and buff.vigorEngaged.stack() == 6
                        and br.timer:useTimer("Vigor Engaged Delay", 6)
                    then
                        use.vigorTrinket()
                    end
                end
            end
            if useCDs() and isChecked("Trinkets") and (buff.trueshot.exists() or not talent.callingTheShots or (ttd(units.dyn40) < 20 and useCDs())) then
                if use.able.slot(13) and not equiped.vigorTrinket(13) then
                    use.slot(13)
                end
                if use.able.slot(14) and not equiped.vigorTrinket(14) then
                    use.slot(14)
                end
            end
            if useCDs() and #enemies.yards40f >= 1 then
                if isChecked("Power Reactor") and hasEquiped(165572) then
                    if buff.vigorEngaged.exists() and buff.vigorEngaged.stack() == 6 and br.timer:useTimer("vigor Engaged Delay", 6) then
                        useItem(165572)
                    end
                end
            end
        -- Hunter's Mark
            -- hunters_mark,if=debuff.hunters_mark.down&!buff.trueshot.up
            if cast.able.huntersMark() and talent.huntersMark
                and not debuff.huntersMark.exists(units.dyn40) and not buff.trueshot.exists()
            then
                if cast.huntersMark() then return end
            end
        -- Double Tap
            -- double_tap,if=cooldown.rapid_fire.remains<gcd|cooldown.rapid_fire.remains<cooldown.aimed_shot.remains|target.time_to_die<20
            if opUseCD("Double Tap") and cast.able.doubleTap() and talent.doubleTap
                and (cd.rapidFire.remain() < gcdMax or cd.rapidFire.remain() < cd.aimedShot.remain() or (ttd(units.dyn40) < 20 and useCDs()))
            then
                if cast.doubleTap() then return end
            end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
            if useCDs() and isChecked("Racial") then
                -- berserking,if=buff.trueshot.up&(target.time_to_die>cooldown.berserking.duration+duration|(target.health.pct<20|!talent.careful_aim.enabled))|target.time_to_die<13
                -- blood_fury,if=buff.trueshot.up&(target.time_to_die>cooldown.blood_fury.duration+duration|(target.health.pct<20|!talent.careful_aim.enabled))|target.time_to_die<16
                -- ancestral_call,if=buff.trueshot.up&(target.time_to_die>cooldown.ancestral_call.duration+duration|(target.health.pct<20|!talent.careful_aim.enabled))|target.time_to_die<16
                -- fireblood,if=buff.trueshot.up&(target.time_to_die>cooldown.fireblood.duration+duration|(target.health.pct<20|!talent.careful_aim.enabled))|target.time_to_die<9
                if (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf")
                    and buff.trueshot.exists() and not talent.carefulAim
                then
                    if cast.racial() then return end
                end
                -- lights_judgment
                if race == "LightforgedDraenei" then
                    if cast.racial("target","ground") then return true end
                end
            end
        -- Heart Essence
            if isChecked("Use Essence") then
                -- worldvein_resonance
                if cast.able.worldveinResonance() then
                    if cast.worldveinResonance() then return end
                end
                -- guardian_of_azeroth,if=cooldown.trueshot.remains<15
                if cast.able.guardianOfAzeroth() and cd.trueshot.remain() < 15 then
                    if cast.guardianOfAzeroth() then return end
                end
                -- ripple_in_space,if=cooldown.trueshot.remains<7
                if cast.able.rippleInSpace() and cd.trueshot.remain() < 7 then
                    if cast.rippleInSpace() then return end
                end
                -- memory_of_lucid_dreams
                if cast.able.memoryOfLucidDreams() then
                    if cast.memoryOfLucidDreams() then return end
                end
            end
        -- Potion
            -- potion,if=buff.trueshot.react&buff.bloodlust.react|buff.trueshot.up&ca_execute|target.time_to_die<25
            if useCDs() and isChecked("Potion") and canUseItem(142117) and inRaid then
                if buff.trueshot.exists() and (buff.bloodLust.exists() or caExecute or buff.trueshot.exists or (ttd(units.dyn40) < 25 and useCDs())) then
                    useItem(142117)
                end
            end
        -- Trueshot
            -- trueshot,if=focus>60&(buff.precise_shots.down&cooldown.rapid_fire.remains&target.time_to_die>cooldown.trueshot.duration_guess+duration|target.health.pct<20|!talent.careful_aim.enabled)|target.time_to_die<15
            if opUseCD("Trueshot") and cast.able.trueshot() then
                if power > 60 and ((not buff.preciseShots.exists() and cd.rapidFire.remain() > 0
                    and (ttd(units.dyn40) > 15 or getHP(units.dyn40) < 20 or not talent.carefulAim)) or (ttd(units.dyn40) < 15 and useCDs()))
                then
                    if cast.trueshot("player") then return end
                end
            end
        end -- End Action List - Cooldowns
    -- Action List - Trick Shots
        local function actionList_TrickShots()
        -- Barrage
            -- barrage
            if opUseCD("Barrage") and cast.able.barrage() and talent.barrage then
                if cast.barrage() then return end
            end
        -- Explosive Shot
            -- explosive_shot
            if opUseCD("Explosive Shot") and cast.able.explosiveShot() and talent.explosiveShot then
                if cast.explosiveShot() then return end
            end
        -- Aimed Shot
            -- aimed_shot,if=buff.trick_shots.up&ca_execute&buff.double_tap.up
            if cast.able.aimedShot() and buff.trickShots.exists() and caExecute and buff.doubleTap.exists() then
                if cast.aimedShot() then return end
            end
        -- Rapid Fire
            -- rapid_fire,if=buff.trick_shots.up&(azerite.focused_fire.enabled|azerite.in_the_rhythm.rank>1|azerite.surging_shots.enabled|talent.streamline.enabled)
            if opUseCD("Rapid Fire") and cast.able.rapidFire() and buff.trickShots.exists()
                and (traits.focusedFire.active or traits.inTheRhythm.rank > 1 or traits.surgingShots.active or talent.streamline)
            then
                if cast.rapidFire() then return end
            end
        -- Aimed Shot
            -- aimed_shot,if=buff.trick_shots.up&(buff.precise_shots.down|cooldown.aimed_shot.full_recharge_time<action.aimed_shot.cast_time|buff.trueshot.up)
            if cast.able.aimedShot() and buff.trickShots.exists()
                and (not buff.preciseShots.exists() or charges.aimedShot.timeTillFull() < cast.time.aimedShot() or buff.trueshot.exists())
            then
                if cast.aimedShot() then return end
            end
        -- Rapid Fire
            -- rapid_fire,if=buff.trick_shots.up
            if opUseCD("Rapid Fire") and cast.able.rapidFire() and buff.trickShots.exists() then
                if cast.rapidFire() then return end
            end
        -- Multishot
            -- multishot,if=buff.trick_shots.down|buff.precise_shots.up&!buff.trueshot.up|focus>70
            if cast.able.multishot() and (not buff.trickShots.exists() or buff.preciseShots.exists() and not buff.trueshot.exists() or power > 70) then
                if cast.multishot() then return end
            end
        -- Heart Essence
            if isChecked("Use Essence") then
                -- focused_azerite_beam
                if cast.able.focusedAzeriteBeam() then
                    if cast.focusedAzeriteBeam() then return end
                end
                -- purifying_blast
                if cast.able.purifyingBlast() then
                    if cast.purifyingBlast("best", nil, 1, 8) then return true end
                end
                -- concentrated_flame
                if cast.able.concentratedFlame() then
                    if cast.concentratedFlame() then return end
                end
                -- blood_of_the_enemy
                if cast.able.bloodOfTheEnemy() then
                    if cast.bloodOfTheEnemy() then return end
                end
                -- the_unbound_force
                if cast.able.theUnboundForce() then
                    if cast.theUnboundForce() then return end
                end
            end
        -- Piercing Shot
            -- piercing_shot
            if opUseCD("Piercing Shot") and cast.able.piercingShot() and talent.piercingShot then
                if cast.piercingShot() then return end
            end
        -- A Murder of Crows
            -- a_murder_of_crows
            if opUseCD("A Murder of Crows") and cast.able.aMurderOfCrows() and talent.aMurderOfCrows then
                if cast.aMurderOfCrows() then return end
            end
        -- Serpent Sting
            -- serpent_sting,if=refreshable&!action.serpent_sting.in_flight
            if cast.able.serpentSting() and talent.serpentSting and debuff.serpentSting.refresh(units.dyn40) and not cast.last.serpentSting(units.dyn40) then
                if cast.serpentSting() then return end
            end
        -- Steady Shot
            -- steady_shot
            if cast.able.steadyShot() then
                if cast.steadyShot() then return end
            end
        end -- End Action List - Trick Shots
    -- Action List - Single Target
        local function actionList_SingleTarget()
        -- Explosive Shot
            -- explosive_shot
            if opUseCD("Explosive Shot") and cast.able.explosiveShot() and talent.explosiveShot then
                if cast.explosiveShot() then return end
            end
        -- Barrage
            -- barrage,if=active_enemies>1
            if opUseCD("Barrage") and cast.able.barrage() and talent.barrage
                and ((mode.rotation == 1 and #enemies.yards40f > 1) or (mode.rotation == 2 and #enemies.yards40f > 0))
            then
                if cast.barrage() then return end
            end
        -- A Murder of Crows
            -- a_murder_of_crows
            if opUseCD("A Murder of Crows") and cast.able.aMurderOfCrows() and talent.aMurderOfCrows then
                if cast.aMurderOfCrows() then return end
            end
        -- Serpent Sting
            -- serpent_sting,if=refreshable&!action.serpent_sting.in_flight
            if cast.able.serpentSting() and talent.serpentSting and debuff.serpentSting.refresh(units.dyn40) and not cast.last.serpentSting(units.dyn40) then
                if cast.serpentSting() then return end
            end
        -- Rapid Fire
            -- rapid_fire,if=buff.trueshot.down|focus<70
            if opUseCD("Rapid Fire") and cast.able.rapidFire() and (not buff.trueshot.exists() or power < 70) then
                if cast.rapidFire() then return end
            end
        -- Arcane Shot
            -- arcane_shot,if=buff.trueshot.up&buff.master_marksman.up&!buff.memory_of_lucid_dreams.up
            if cast.able.arcaneShot() and buff.trueshot.exists()
                and buff.masterMarksman.exists() and not buff.memoryOfLucidDreams.exists()
            then
                if cast.arcaneShot() then return end
            end
        -- Aimed Shot
            -- aimed_shot,if=buff.trueshot.up|(buff.double_tap.down|ca_execute)&buff.precise_shots.down|full_recharge_time<cast_time
            if cast.able.aimedShot() and (buff.trueshot.exists() or (not buff.doubleTap.exists() or caExecute))
                and (not buff.preciseShots.exists() or charges.aimedShot.timeTillFull() < cast.time.aimedShot())
            then
                if cast.aimedShot() then return end
            end
        -- Arcane Shot
            -- arcane_shot,if=buff.trueshot.up&buff.master_marksman.up&buff.memory_of_lucid_dreams.up
            if cast.able.arcaneShot() and buff.trueshot.exists()
                and buff.masterMarksman.exists() and buff.memoryOfLucidDreams.exists()
            then
                if cast.arcaneShot() then return end
            end
        -- Piercing Shot
            -- piercing_shot
            if opUseCD("Piercing Shot") and cast.able.piercingShot() and talent.piercingShot then
                if cast.piercingShot() then return end
            end
        -- Heart Essence
            if isChecked("Use Essence") then
                -- focused_azerite_beam
                if cast.able.focusedAzeriteBeam() then
                    if cast.focusedAzeriteBeam() then return end
                end
                -- purifying_blast
                if cast.able.purifyingBlast() then
                    if cast.purifyingBlast("best", nil, 1, 8) then return true end
                end
                -- concentrated_flame
                if cast.able.concentratedFlame() then
                    if cast.concentratedFlame() then return end
                end
                -- blood_of_the_enemy
                if cast.able.bloodOfTheEnemy() then
                    if cast.bloodOfTheEnemy() then return end
                end
                -- the_unbound_force
                if cast.able.theUnboundForce() then
                    if cast.theUnboundForce() then return end
                end
            end
        -- Arcane Shot
            -- arcane_shot,if=buff.trueshot.down&(buff.precise_shots.up&(focus>41|buff.master_marksman.up)|(focus>50&azerite.focused_fire.enabled|focus>75)&(cooldown.trueshot.remains>5|focus>80)|target.time_to_die<5)
            if cast.able.arcaneShot() and not buff.trueshot.exists() and (buff.preciseShots.exists()
                and (power > 41 or buff.masterMarksman.exists()) or ((power > 50 and traits.focusedFire.active) or power > 75)
                and (cd.trueshot.remain() > 5 or power > 80) or (ttd(units.dyn40) < 5 and useCDs()))
            then
                if cast.arcaneShot() then return end
            end
        -- Steady Shot
            -- steady_shot
            if cast.able.steadyShot() then
                if cast.steadyShot() then return end
            end
        end -- End Action List - Single Target
    -- Action List - Pre-Combat
        local function actionList_PreCombat()
            rotationDebug = "Pre-Combat"
            if not inCombat and not buff.feignDeath.exists() then
            -- Flask / Crystal
                -- flask,type=flask_of_the_seventh_demon
                if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheSeventhDemon.exists() and canUseItem(item.flaskOfTheSeventhDemon) then
                    if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                    if buff.felFocus.exists() then buff.felFocus.cancel() end
                    if use.flaskOfTheSeventhDemon() then return end
                end
                if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and canUseItem(item.repurposedFelFocuser) then
                    if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                    if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                    if use.repurposedFelFocuser() then return end
                end
                if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUseItem(item.oraliusWhisperingCrystal) then
                    if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                    if buff.felFocus.exists() then buff.felFocus.cancel() end
                    if use.oraliusWhisperingCrystal() then return end
                end
            -- Summon Pet
                -- summon_pet
                if actionList_PetManagement() then return end
                if isValidUnit("target") and getDistance("target") < 40 then
            -- Hunter's Mark
                    -- hunters_mark
                    if cast.able.huntersMark() then
                        if cast.huntersMark() then return end
                    end
            -- Double Tap
                    -- double_tap,precast_time=10
                    if cast.able.doubleTap() and pullTimer <= 10 then
                        if cast.doubleTap() then return end
                    end
            -- Trueshot
                    -- trueshot,precast_time=1.5,if=active_enemies>2
            -- Aimed Shot
                    -- aimed_shot,if=active_enemies<3
                    if cast.able.aimedShot() and pullTimer <= 2 then --and ((mode.rotation == 1 and #enemies.yards40f < 3) or (mode.rotation == 3 and #enemies.yards40f > 0)) then
                        if cast.aimedShot("target") then return end
                    end
            -- Auto Shot
                    StartAttack()
                end
            end
        end
---------------------
--- Begin Profile ---
---------------------
        -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif haltProfile then
            -----------------
            --- Pet Logic ---
            -----------------
            if actionList_PetManagement() then return true end
            if cast.able.playDead() and cast.last.feignDeath() and not buff.playDead.exists("pet") then
                if cast.playDead() then return end
            end
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
-----------------
--- Pet Logic ---
-----------------
            if actionList_PetManagement() then return end
------------------
--- Pre-Combat ---
------------------
            if not inCombat then
                if actionList_PreCombat() then return end
            end
--------------------------
--- In Combat Rotation ---
--------------------------
            if inCombat and profileStop == false and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40
                and not cast.current.barrage() and not cast.current.focusedAzeriteBeam()
            then
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                if getOptionValue("APL Mode") == 1 then
                -- Auto Shot
                    -- auto_shot
                    if getDistance(units.dyn40) < 40 then
                        StartAttack()
                    end
                -- Call Action List - Cooldowns
                    -- call_action_list,name=cooldowns
                    if actionList_Cooldowns() then return end
                -- Call Action List - Single Target
                    -- call_action_list,name=st,if=active_enemies<3
                    if ((mode.rotation == 1 and #enemies.yards40f < 3) or (mode.rotation == 3 and #enemies.yards40f > 0)) then
                        if actionList_SingleTarget() then return end
                    end
                -- Call Action List - Trick Shots
                    -- call_action_list,name=trickshots,if=active_enemies>2
                    if ((mode.rotation == 1 and #enemies.yards40f > 2) or (mode.rotation == 2 and #enemies.yards40f > 0)) then
                        if actionList_TrickShots() then return end
                    end
                end -- End SimC APL
    ------------------------
    --- Ask Mr Robot APL ---
    ------------------------
                if getOptionValue("APL Mode") == 2 then

                end
            end --End In Combat
        end --End Rotation Logic
    end -- End Timer
end -- End runRotation
local id = 254
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

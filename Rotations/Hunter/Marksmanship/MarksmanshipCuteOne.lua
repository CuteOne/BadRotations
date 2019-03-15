local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.aimedShot },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.multiShot },
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
-- Explosive Shot Button
    ExplosiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Explosive Shot Enabled", tip = "Will use Explosive Shot.", highlight = 1, icon = br.player.spell.explosiveShot },
        [2] = { mode = "Off", value = 2 , overlay = "Explosive Shot Disabled", tip = "Explosive Shot will not be used.", highlight = 0, icon = br.player.spell.explosiveShot }
    };
    CreateButton("Explosive",5,0)
-- Piercing Shot Button
    PiercingModes = {
        [1] = { mode = "On", value = 1 , overlay = "Piercing Shot Enabled", tip = "Will use Piercing Shot.", highlight = 1, icon = br.player.spell.piercingShot },
        [2] = { mode = "Off", value = 2 , overlay = "Piercing Shot Disabled", tip = "Piercing Shot will not be used.", highlight = 0, icon = br.player.spell.piercingShot }
    };
    CreateButton("Piercing",6,0)
-- MD Button
    MisdirectionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    CreateButton("Misdirection",7,0)
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
        -- Piercing Shot
            -- br.ui:createCheckbox(section, "Piercing Shot")
            br.ui:createSpinnerWithout(section, "Piercing Shot Units", 3, 1, 5, 1, "|cffFFFFFFSet to desired units to cast Piercing Shot")
        -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
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
        -- Agi Pot
            br.ui:createCheckbox(section,"Potion")
        -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Seventh Demon","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
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
local function runRotation()
    if br.timer:useTimer("debugMarksmanship", 0 --[[math.random(0.15,0.3)]]) then
        --print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Explosive",0.25)
        br.player.mode.explosive = br.data.settings[br.selectedSpec].toggles["Explosive"]
        UpdateToggle("Piercing",0.25)
        br.player.mode.piercing = br.data.settings[br.selectedSpec].toggles["Piercing"]
        UpdateToggle("Misdirection",0.25)
        br.player.mode.misdirection = br.data.settings[br.selectedSpec].toggles["Misdirection"]

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
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local healPot                                       = getHealthPot()
        local inCombat                                      = UnitAffectingCombat("player") --br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local item                                          = br.player.spell.items
        local level                                         = br.player.level
        local mode                                          = br.player.mode
        local multidot                                      = (br.player.mode.cleave == 1 or br.player.mode.rotation == 2) and br.player.mode.rotation ~= 3
        local php                                           = br.player.health
        local potion                                        = br.player.potion
        local power, powerMax, powerRegen, powerDeficit     = br.player.power.focus.amount(), br.player.power.focus.max(), br.player.power.focus.regen(), br.player.power.focus.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
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
        enemies.get(8)
        enemies.get(40,"player",false,true)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if rotationDebug == nil or not inCombat then rotationDebug = "Waiting" end

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
    -- Action List - Pet Management
        local function actionList_PetManagement()
            if not talent.loneWolf then
                if IsMounted() or IsFlying() or UnitHasVehicleUI("player") or CanExitVehicle("player") then
                    waitForPetToAppear = GetTime()
                elseif isChecked("Auto Summon") then
                    local callPet = nil
                    for i = 1, 5 do
                        if getValue("Auto Summon") == i then callPet = spell["callPet"..i] end
                    end
                    if waitForPetToAppear ~= nil and GetTime() - waitForPetToAppear > 2 then
                        if UnitExists("pet") and IsPetActive() and (callPet == nil or UnitName("pet") ~= select(2,GetCallPetSpellInfo(callPet))) then
                            if cast.dismissPet() then waitForPetToAppear = GetTime(); return true end
                        elseif callPet ~= nil then
                            if UnitIsDeadOrGhost("pet") or deadPet then
                                if cast.able.heartOfThePhoenix() and inCombat then
                                    if cast.heartOfThePhoenix() then waitForPetToAppear = GetTime(); return true end
                                else
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
                    if inCombat and (isValidUnit("target") or isDummy()) and getDistance("target") < 40 and not GetUnitIsUnit("target","pettarget") then
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
                if isChecked("Mend Pet") and UnitExists("pet") and not UnitIsDeadOrGhost("pet") and not deadPet and getHP("pet") < getOptionValue("Mend Pet") and not buff.mendPet.exists("pet") then
                    if cast.mendPet() then return end
                end
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
                        PetStopAttack()
                        PetFollow()
                        print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end -- End Dummy Test
        -- Misdirection
            if mode.misdirection == 1 then
                if cd.misdirection.remain() <= 0.1 then
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
            end
        end -- End Action List - Extras
    -- Action List - Defensive
        local function actionList_Defensive()
            if useDefensive() then
        -- Pot/Stoned
                if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned")
                    and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healPot) then
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
                    and inCombat and canUse(118006)
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
            if useCDs() and isChecked("Trinkets") and (buff.trueshot.exists() or not talent.callingTheShots or ttd(units.dyn40) < 20) then
                if canUse(13) then
                    useItem(13)
                end
                if canUse(14) then
                    useItem(14)
                end
            end
        -- Hunter's Mark
            -- hunters_mark,if=debuff.hunters_mark.down&!buff.trueshot.up
            if cast.able.huntersMark() and not debuff.huntersMark.exists(units.dyn40) and not buff.trueshot.exists() then
                if cast.huntersMark() then return end
            end
        -- Double Tap 
            -- double_tap,if=cooldown.rapid_fire.remains<gcd|cooldown.rapid_fire.remains<cooldown.aimed_shot.remains|target.time_to_die<20
            if opUseCD("Double Tap") and cast.able.doubleTap() and (cd.rapidFire.remain() < gcd or cd.rapidFire.remain() < cd.aimedShot.remain() or ttd(units.dyn40) < 20) then
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
        -- Potion
            -- potion,if=buff.trueshot.react&buff.bloodlust.react|buff.trueshot.up&ca_execute|target.time_to_die<25
            if useCDs() and isChecked("Potion") and canUse(142117) and inRaid then
                if buff.trueshot.exists() and (buff.bloodLust.exists() or caExecute or buff.trueshot.exists or ttd(units.dyn40) < 25) then
                    useItem(142117)
                end
            end
        -- Trueshot
            -- trueshot,if=focus>60&(buff.precise_shots.down&cooldown.rapid_fire.remains&target.time_to_die>cooldown.trueshot.duration_guess+duration|target.health.pct<20|!talent.careful_aim.enabled)|target.time_to_die<15
            if opUseCD("Trueshot") and cast.able.trueshot() then
                if power > 60 and ((not buff.preciseShots.exists() and cd.rapidFire.remain() > 0 
                    and (ttd(units.dyn40) > 15 or getHP(units.dyn40) < 20 or not talent.carefulAim)) or ttd(units.dyn40) < 15)
                then
                    if cast.trueshot("player") then return end
                end
            end
        end -- End Action List - Cooldowns
    -- Action List - Trick Shots
        local function actionList_TrickShots()
        -- Barrage
            -- barrage
            if opUseCD("Barrage") and cast.able.barrage() then 
                if cast.barrage() then return end 
            end 
        -- Explosive Shot
            -- explosive_shot
            if opUseCD("Explosive Shot") and cast.able.explosiveShot() then
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
                and (traits.focusedFire.active() or traits.inTheRhythm.rank() > 1 or traits.surgingShots.active() or talent.streamline) 
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
            if cast.able.multishot() and (not buff.trickShots.exists() or buff.preciseShots.exists() or not buff.trueshot.exists() or power > 70) then 
                if cast.multishot() then return end 
            end
        -- Piercing Shot 
            -- piercing_shot
            if opUseCD("Piercing Shot") and cast.able.piercingShot() then 
                if cast.piercingShot() then return end 
            end 
        -- A Murder of Crows 
            -- a_murder_of_crows
            if opUseCD("A Murder of Crows") and cast.able.aMudrerOfCrows() then 
                if cast.aMudrerOfCrows() then return end 
            end
        -- Serpent Sting 
            -- serpent_sting,if=refreshable&!action.serpent_sting.in_flight
            if cast.able.serpentSting() and debuff.serpentSting.refresh(units.dyn40) and not cast.last.serpentSting(units.dyn40) then 
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
            if opUseCD("Explosive Shot") and cast.able.explosiveShot() then
                if cast.explosiveShot() then return end 
            end
        -- Barrage
            -- barrage,if=active_enemies>1
            if opUseCD("Barrage") and cast.able.barrage() and ((mode.rotation == 1 and #enemies.yards40f > 1) or (mode.rotation == 2 and #enemies.yards40f > 0)) then 
                if cast.barrage() then return end 
            end 
        -- A Murder of Crows 
            -- a_murder_of_crows
            if opUseCD("A Murder of Crows") and cast.able.aMudrerOfCrows() then 
                if cast.aMudrerOfCrows() then return end 
            end
        -- Serpent Sting 
            -- serpent_sting,if=refreshable&!action.serpent_sting.in_flight
            if cast.able.serpentSting() and debuff.serpentSting.refresh(units.dyn40) and not cast.last.serpentSting(units.dyn40) then 
                if cast.serpentSting() then return end 
            end
        -- Rapid Fire 
            -- rapid_fire,if=buff.trueshot.down|focus<70
            if opUseCD("Rapid Fire") and cast.able.rapidFire() and (not buff.trueshot.exists() or power < 70) then 
                if cast.rapidFire() then return end 
            end
        -- Arcane Shot 
            -- arcane_shot,if=buff.trueshot.up&buff.master_marksman.up
            if cast.able.arcaneShot() and buff.trueshot.exists() and buff.masterMarksman.exists() then 
                if cast.arcaneShot() then return end
            end
        -- Aimed Shot
            -- aimed_shot,if=buff.trueshot.up|(buff.double_tap.down|ca_execute)&buff.precise_shots.down|full_recharge_time<cast_time
            if cast.able.aimedShot() and (buff.trueshot.exists() or (not buff.doubleTap.exists() or caExecute))
                and (not buff.preciseShots.exists() or charges.aimedShot.timeTillFull() < cast.time.aimedShot())
            then
                if cast.aimedShot() then return end 
            end
        -- Piercing Shot 
            -- piercing_shot
            if opUseCD("Piercing Shot") and cast.able.piercingShot() then 
                if cast.piercingShot() then return end 
            end
        -- Arcane Shot 
            -- arcane_shot,if=buff.trueshot.down&(buff.precise_shots.up&(focus>41|buff.master_marksman.up)|(focus>50&azerite.focused_fire.enabled|focus>75)&(cooldown.trueshot.remains>5|focus>80)|target.time_to_die<5)
            if cast.able.arcaneShot() and not buff.trueshot.exists() and (buff.preciseShots.exists() 
                and (power > 41 or buff.masterMarksman.exists) or ((power > 50 and traits.focusedFire.active()) or power > 75) 
                and (cd.trueshot.remain() > 5 or power > 80) or ttd(units.dyn40) < 5)
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
                if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheSeventhDemon.exists() and canUse(item.flaskOfTheSeventhDemon) then
                    if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                    if buff.felFocus.exists() then buff.felFocus.cancel() end
                    if use.flaskOfTheSeventhDemon() then return end
                end
                if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and canUse(item.repurposedFelFocuser) then
                    if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                    if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                    if use.repurposedFelFocuser() then return end
                end
                if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUse(item.oraliusWhisperingCrystal) then
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
            -- Trueshot 
                    -- trueshot,precast_time=1.5,if=active_enemies>2
            -- Aimed Shot
                    -- aimed_shot,if=active_enemies<3
                    if cast.able.aimedShot() and ((mode.rotation == 1 and #enemies.yards40f < 3) or (mode.rotation == 3 and #enemies.yards40f > 0)) then
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
        elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 or buff.feignDeath.exists() then
            if not pause() and IsPetAttackActive() then
                PetStopAttack()
                PetFollow()
            end
            StopAttack()
            return true
        else
            br.player.getDebuffsCount()
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
            if inCombat and profileStop == false and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 and not cast.current.barrage() then
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

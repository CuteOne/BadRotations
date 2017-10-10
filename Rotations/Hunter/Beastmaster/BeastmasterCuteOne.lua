local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.cobraShot },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.volley },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.killCommand },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.aspectOfTheWild}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.bestialWrath },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.bestialWrath },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.bestialWrath }
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
    -- -- TT Button
    -- TitanThunderModes = {
    --     [1] = { mode = "On", value = 1 , overlay = "Auto Titan Thunder", tip = "Will Use Titan Thunder At All Times", highlight = 1, icon = br.player.spell.titansThunder },
    --     [2] = { mode = "CD", value = 2 , overlay = "CD Only Titan Thunder", tip = "Will Use Titan Thunder Only with BW", highlight = 0, icon = br.player.spell.titansThunder }
    -- };
    -- CreateButton("TitanThunder",6,0)
    -- MurderofCrowsModes = {
    --     [1] = { mode = "On", value = 1 , overlay = "Always use MoC", tip = "Will Use Murder of Crows At All Times", highlight = 1, icon = br.player.spell.aMurderOfCrows },
    --     [2] = { mode = "CD", value = 2 , overlay = "Use MoC only on Cooldowns", tip = "Will Use Murder of Crows Only on Cooldowns", highlight = 0, icon = br.player.spell.aMurderOfCrows }
    -- };
    -- CreateButton("MurderofCrows",7,0)
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
        br.ui:checkSectionState(section)
    -- Pet Options
        section = br.ui:createSection(br.ui.window.profile, "Pet")
        -- Auto Summon
            br.ui:createDropdown(section, "Auto Summon", {"Pet 1","Pet 2","Pet 3","Pet 4","Pet 5",}, 1, "Select the pet you want to use")
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
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF001st Only","|cff00FF002nd Only","|cffFFFF00Both","|cffFF0000None"}, 1, "|cffFFFFFFSelect Trinket Usage.")
        -- Bestial Wrath
            br.ui:createCheckbox(section,"Bestial Wrath")
        -- Trueshot
            br.ui:createCheckbox(section,"Aspect of the Wild")
        -- Stampede
            br.ui:createCheckbox(section,"Stampede")
        -- A Murder of Crows / Barrage
            br.ui:createCheckbox(section,"A Murder Of Crows / Barrage")
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
    -- if br.timer:useTimer("debugBeastmaster", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        br.player.mode.misdirection = br.data.settings[br.selectedSpec].toggles["Misdirection"]
        UpdateToggle("Misdirection", 0.25)
        -- br.player.mode.titanthunder = br.data.settings[br.selectedSpec].toggles["TitanThunder"]
        -- UpdateToggle("TitanThunder", 0.25)
        -- br.player.mode.murderofcrows = br.data.settings[br.selectedSpec].toggles["MurderofCrows"]
        -- UpdateToggle("MurderofCrows",0.25)


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
        local deadPet                                       = deadPet
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = enemies or {}
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local fatality                                      = false
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local hasMouse                                      = GetObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local multidot                                      = (br.player.mode.cleave == 1 or br.player.mode.rotation == 2) and br.player.mode.rotation ~= 3
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local potion                                        = br.player.potion
        local power, powerMax, powerRegen, powerDeficit     = br.player.power.focus.amount(), br.player.power.focus.max(), br.player.power.focus.regen(), br.player.power.focus.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local solo                                          = #br.friend < 2
        local friendsInRange                                = friendsInRange
        local spell                                         = br.player.spell
        local t19_2pc                                       = TierScan("T19") >= 2
        local talent                                        = br.player.talent
        local trinketProc                                   = false
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.focus.ttm()
        local units                                         = units or {}


        units.dyn40 = br.player.units(40)
        enemies.yards40 = br.player.enemies(40)

        if GetObjectExists("pet") then
            enemies.yards8pet = br.player.enemies(8,GetUnit("pet"))
        else
            enemies.yards8pet = {}
        end

        local lowestUnit = lowestUnit or units.dyn40
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if debuff.bestialFerocity.exists(thisUnit) then
                if debuff.bestialFerocity.exists(lowestUnit) then
                    lowestFerocity = debuff.bestialFerocity.remain(lowestUnit)
                else
                    lowestFerocity = 40
                end
                if debuff.bestialFerocity.remain(thisUnit) < lowestFerocity then
                    lowestUnit = thisUnit
                end
            end
        end

   		if leftCombat == nil then leftCombat = GetTime() end
		if profileStop == nil then profileStop = false end
        -- if UnitExists(units.dyn40) then
        --     ChatOverlay("Exists: "..tostring(GetUnitExists(units.dyn40))..", Not Dead: "..tostring(not UnitIsDeadOrGhost(units.dyn40))..", Enemy: "
        --         ..tostring(not UnitIsFriend(units.dyn40, "player") or UnitIsEnemy(units.dyn40, "player"))..", Attack: "..tostring(UnitCanAttack("player",units.dyn40))..", Safe: "
        --         ..tostring(isSafeToAttack(units.dyn40))..", in LoS: "..tostring(getLineOfSight("player", units.dyn40))..", in Phase: "..tostring(UnitInPhase(units.dyn40)))
        -- end

--------------------
--- Action Lists ---
--------------------
    -- Action List - Pet Management
        local function actionList_PetManagement()
            if IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player") then
                waitForPetToAppear = GetTime()
            elseif isChecked("Auto Summon") and not GetUnitExists("pet") and (UnitIsDeadOrGhost("pet") ~= nil or IsPetActive() == false) then
                if waitForPetToAppear ~= nil and GetTime() - waitForPetToAppear > 2 then
                    if deadPet == true then
                        if cast.revivePet() then return end
                    elseif deadPet == false then
                        local Autocall = getValue("Auto Summon");
                        if Autocall == 1 then
                            if cast.callPet1() then return end
                        elseif Autocall == 2 then
                            if cast.callPet2() then return end
                        elseif Autocall == 3 then
                            if cast.callPet3() then return end
                        elseif Autocall == 4 then
                            if cast.callPet4() then return end
                        elseif Autocall == 5 then
                            if cast.callPet5() then return end
                        else
                            Print("Auto Call Pet Error")
                        end
                    end
                end
                if waitForPetToAppear == nil then
                    waitForPetToAppear = GetTime()
                end
            end
            --Revive
            if isChecked("Auto Summon") and UnitIsDeadOrGhost("pet") then
                if cast.revivePet() then return; end
            end
            -- Mend Pet
            if isChecked("Mend Pet") and getHP("pet") < getValue("Mend Pet") and not UnitBuffID("pet",136) then
                if cast.mendPet() then return; end
            end
            -- Pet Attack / retreat
            if inCombat and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 then
                if not UnitIsUnit("target","pettarget") then
                    PetAttack()
                end
            else
                if IsPetAttackActive() then
                    PetStopAttack()
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
                        PetFOllow()
                        Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
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
                if isChecked("Intimidation") and talent.intimidation and cd.intimidation.remain() == 0 and
                GetUnitExists("pet") and (UnitIsDead("pet") ~= nil or UnitIsDead("pet") == false) then
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
        local function actionList_Cooldowns()
            if useCDs() then
            -- Trinkets
                -- use_items
                if useCDs() and getOptionValue("Trinkets") ~= 4 then
                    if (getOptionValue("Trinkets") == 1 or getOptionValue("Trinkets") == 3) and canUse(13) then
                        useItem(13)
                    end
                    if (getOptionValue("Trinkets") == 2 or getOptionValue("Trinkets") == 3) and canUse(14) then
                        useItem(14)
                    end
                end
            -- Racial
                -- arcane_torrent,if=focus.deficit>=30
                -- berserking,if=buff.bestial_wrath.remains>7
                -- blood_fury,if=buff.bestial_wrath.remains>7
                if isChecked("Racial") and getSpellCD(racial) == 0
                    and ((buff.bestialWrath.remain() > 7 and (br.player.race == "Orc" or br.player.race == "Troll")) 
                        or (powerDeficit >= 30 and br.player.race == "BloodElf")) 
                then
                     if castSpell("player",racial,false,false,false) then return end
                end
            -- Potion
                -- potion,if=buff.bestial_wrath.up&buff.aspect_of_the_wild.up
                if isChecked("Potion") and canUse(142117) and inRaid and (buff.bestialWrath.exists() or level < 40) and (buff.aspectOfTheWild.exists() or level < 26) then
                    useItem(142117);
                    return true
                end
            -- A Murder of Crows
                -- a_murder_of_crows,if=cooldown.bestial_wrath.remains<3|cooldown.bestial_wrath.remains>30|target.time_to_die<16
                if isChecked("A Murder of Crows / Barrage") and cd.bestialWrath.remain() < 3 or cd.bestialWrath.remain() > 30 or ttd(units.dyn40) < 16 then
                    if cast.aMurderOfCrows() then return end
                end
            -- Beastial Wrath
                -- bestial_wrath,if=!buff.bestial_wrath.up
                if isChecked("Bestial Wrath") and not buff.bestialWrath.exists() then
                    if cast.bestialWrath() then return end
                end
            -- Stampede
                -- stampede,if=buff.bloodlust.up|buff.bestial_wrath.up|cooldown.bestial_wrath.remains<=2|target.time_to_die<=14
                if isChecked("Stampede") and (hasBloodLust() or buff.bestialWrath.exists() or cd.bestialWrath.remain() <= 2 or ttd(units.dyn40) <= 14) then
                    if cast.stampede() then return end
                end
            -- Aspect of the Wild
                -- aspect_of_the_wild,if=(equipped.call_of_the_wild&equipped.convergence_of_fates&talent.one_with_the_pack.enabled)|buff.bestial_wrath.remains>7|target.time_to_die<12
                if isChecked("Aspect of the Wild") and (hasEquiped(137101) and hasEquiped(140806) and talent.oneWithThePack) or buff.bestialWrath.remain() > 7 or ttd(units.dyn40) < 12 then
                    if cast.aspectOfTheWild() then return end
                end
            end -- End useCooldowns check
        end -- End Action List - Cooldowns
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
            -- Cobra Shot
                    if cast.cobraShot("target") then return end
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
        elseif (inCombat and profileStop==true) or (IsMounted() or IsFlying()) or pause() or buff.feignDeath.exists() or mode.rotation==4 then
            if not pause() and IsPetAttackActive() then
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
            if actionList_PetManagement() then return end
    -----------------
    --- Defensive ---
    -----------------
            if actionList_Defensive() then return end
    ------------------
    --- Pre-Combat ---
    ------------------
            if not inCombat and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                if actionList_PreCombat() then return end
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations ---
-----------------------------
            if inCombat and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 then
    -----------------
    --- Pet Logic ---
    -----------------
                if actionList_PetManagement() then return end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                if getOptionValue("APL Mode") == 1 then
            -- Start Attack
                    StartAttack()
            -- Volley
                    -- volley,toggle=on
                    if talent.volley and not buff.volley.exists() then
                        if cast.volley() then return end
                    end
            -- Cooldowns
                    if actionList_Cooldowns() then return end
            -- Kill Command
                    -- kill_command,target_if=min:bestial_ferocity.remains,if=equipped.qapla_eredun_war_order|talent.aspect_of_the_beast.enabled
                    if (hasEquiped(137227) or talent.aspectOfTheBeast) then
                        if cast.killCommand(lowestUnit) then return end
                    end
            -- Dire Beast
                    -- dire_beast,if=(!equipped.qapla_eredun_war_order|cooldown.kill_command.remains>=1)|full_recharge_time<gcd.max|cooldown.titans_thunder.up|spell_targets>1
                    if not talent.direFrenzy and --[[(--]]((not hasEquiped(137227) or cd.killCommand.remain() >= 1)--[[ and (t19_2pc or not buff.bestialWrath.exists()))--]] or charges.direBeast.timeTillFull() < gcdMax or cd.titansThunder.remain() == 0 or #enemies.yards8pet >= getOptionValue("Units To AoE")) then
                        if cast.direBeast() then return end
                    end
            -- Dire Frenzy
                    -- dire_frenzy,if=(pet.cat.buff.dire_frenzy.remains<=gcd.max*1.2)|full_recharge_time<gcd.max|target.time_to_die<9
                    if talent.direFrenzy and charges.direFrenzy.count() > 0 and ((buff.direFrenzy.remain("pet") <= gcdMax * 1.2) or charges.direFrenzy.timeTillFull() < gcdMax or ttd(units.dyn40) < 9) then
                        if cast.direFrenzy() then return end
                    end
            -- Barrage
                    -- barrage,if=spell_targets.barrage>1
                    if isChecked("A Murder of Crows / Barrage") and #enemies.yards8pet >= getOptionValue("Units To AoE") then
                        if cast.barrage() then return end
                    end
            -- Titan's Thunder
                    -- titans_thunder,if=(talent.dire_frenzy.enabled&(buff.bestial_wrath.up|cooldown.bestial_wrath.remains>35))|buff.bestial_wrath.up
                    if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) then
                        if (talent.direFrenzy and (buff.bestialWrath.exists() or cd.bestialWrath.remain() > 35)) or buff.bestialWrath.exists() or (getOptionValue("Artifact") == 1 and not useCDs()) then
                            if cast.titansThunder() then return end
                        end
                    end
            -- Multishot
                    -- multishot,if=spell_targets>4&(pet.cat.buff.beast_cleave.remains<gcd.max|pet.cat.buff.beast_cleave.down)
                    if #enemies.yards8pet >= getOptionValue("Units To AoE") and getOptionValue("Units To AoE") > 4 and (buff.beastCleave.remain("pet") < gcdMax or not buff.beastCleave.exists("pet")) then
                        if cast.multiShot() then return end
                    end
            -- Kill Command
                    -- kill_command
                    if level >= 10 then 
                        if cast.killCommand() then return end
                    end
            -- Multishot
                    -- multishot,if=spell_targets>1&(pet.cat.buff.beast_cleave.remains<gcd.max|pet.cat.buff.beast_cleave.down)
                    if #enemies.yards8pet >= getOptionValue("Units To AoE") and (buff.beastCleave.remain("pet") < gcdMax or not buff.beastCleave.exists("pet")) then
                        if cast.multiShot() then return end
                    end
            -- Chimaera Shot
                    -- chimaera_shot,if=focus<90
                    if talent.chimaeraShot and power < 90 then
                        if cast.chimaeraShot() then return end
                    end
            -- Cobra Shot
                    -- cobra_shot,if=(cooldown.kill_command.remains>focus.time_to_max&cooldown.bestial_wrath.remains>focus.time_to_max)|(buff.bestial_wrath.up&(spell_targets.multishot=1|focus.regen*cooldown.kill_command.remains>action.kill_command.cost))|target.time_to_die<cooldown.kill_command.remains|(equipped.parsels_tongue&buff.parsels_tongue.remains<=gcd.max*2)
                    if (cd.killCommand.remain() > ttm and cd.bestialWrath.remain() > ttm) or ((buff.bestialWrath.exists() or level < 40) and (#enemies.yards8pet < getOptionValue("Units To AoE") 
                        or powerRegen * cd.killCommand.remain() > select(1, getSpellCost(spell.killCommand)))) or ttd(units.dyn40) < cd.killCommand.remain() or (hasEquiped(151805) and buff.parselsTongue.remain() <= gcdMax * 2) or level < 10
                    then
                        if cast.cobraShot() then return end
                    end
            -- Dire Beast
                    -- dire_beast,if=buff.bestial_wrath.up
                    if not talent.direFrenzy and (buff.bestialWrath.exists() or level < 40) then
                        if cast.direBeast() then return end
                    end
                end -- End SimC APL
			end --End In Combat
		end --End Rotation Logic
    -- end -- End Timer
end -- End runRotation
local id = 253
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

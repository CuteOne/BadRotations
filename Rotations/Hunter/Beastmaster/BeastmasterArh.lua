local rotationName = "Kuu/Arhelay"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
--        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.cobraShot },
        [1] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.volley },
        [2] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.killCommand },
--        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.aspectOfTheWild}
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
--    DefensiveModes = {
--        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.aspectOfTheTurtle },
--        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.aspectOfTheTurtle }
--    };
--    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterShot },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterShot }
    };
    CreateButton("Interrupt",3,0)
    -- MD Button
    MisdirectionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    CreateButton("Misdirection",4,0)
    -- TT Button
    TitanThunderModes = {
        [1] = { mode = "On", value = 1 , overlay = "Auto Titan Thunder", tip = "Will Use Titan Thunder At All Times", highlight = 1, icon = br.player.spell.titansThunder },
        [2] = { mode = "CD", value = 2 , overlay = "CD Only Titan Thunder", tip = "Will Use Titan Thunder Only with BW", highlight = 0, icon = br.player.spell.titansThunder }
    };
    CreateButton("TitanThunder",5,0)
	-- Murder of Crows button
--    MurderofCrowsModes = {
--        [1] = { mode = "On", value = 1 , overlay = "Always use MoC", tip = "Will Use Murder of Crows At All Times", highlight = 1, icon = br.player.spell.aMurderOfCrows },
--        [2] = { mode = "CD", value = 2 , overlay = "Use MoC only on Cooldowns", tip = "Will Use Murder of Crows Only on Cooldowns", highlight = 0, icon = br.player.spell.aMurderOfCrows }
--    };
--    CreateButton("MurderofCrows",7,0)
-- Dynamic targeting button
	DynamicTargetingModes = {
	    [1] = { mode = "On", value = 1 , overlay = "DT enabled", tip = "DT enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 0 , overlay = "DT disabled", tip = "DT disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    CreateButton("Misdirection",4,0)
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
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFKuu"}, 3, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Opener
            br.ui:createCheckbox(section,"Opener")
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
            br.ui:createCheckbox(section,"Agi-Pot")
        -- Flask / Crystal
            br.ui:createCheckbox(section,"Flask / Crystal")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Ring of Collapsing Futures
            br.ui:createCheckbox(section,"Ring of Collapsing Futures")
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
        -- Exhilaration
            br.ui:createSpinner(section, "Exhilaration",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Aspect Of The Turtle
            br.ui:createSpinner(section, "Aspect Of The Turtle",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
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
    if br.timer:useTimer("debugBeastmaster", math.random(0.15,0.3)) then
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
        br.player.mode.titanthunder = br.data.settings[br.selectedSpec].toggles["TitanThunder"]
        UpdateToggle("TitanThunder", 0.25)
        br.player.mode.murderofcrows = br.data.settings[br.selectedSpec].toggles["MurderofCrows"]
        UpdateToggle("MurderofCrows",0.25)


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
        local multishotTargets                              = getEnemies("pet",8)
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
        local talent                                        = br.player.talent
        local trinketProc                                   = false
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.focus.ttm()
        local t19_2pc                                       = TierScan("T19") >= 2
        local units                                         = units or {}

        if units.dyn40 == nil then
            units.dyn40 = br.player.units(40)
        end
        if enemies.yards40 == nil then
            enemies.yards40 = br.player.units(40)
        end

        -- BeastCleave 115939
        local beastCleaveTimer                              = getBuffDuration("pet", 115939)

        -- Focus Regen compensation for Dire Beast
        if buff.direBeast.exists() then
            powerRegen = powerRegen + 1.5
        end

        if buff.direFrenzy.exists() then
            powerRegen = powerRegen + 3
        end

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        

        if opener == nil then opener = false end

        if not inCombat and opener == true then
            MOC = false
            BW = false
            DIRE = false
            KCMS = false
            TT = false
            DIRE2 = false
            opener = false
        end

--------------------
--- Action Lists ---
--------------------
    -- Action List - Pet Management
        local function actionList_PetManagement()
            if not IsMounted() then
                if isChecked("Auto Summon") and not GetUnitExists("pet") and (UnitIsDeadOrGhost("pet") ~= nil or IsPetActive() == false) then
                  if waitForPetToAppear ~= nil and waitForPetToAppear < GetTime() - 2 then
                      if deadPet == true then
                        if castSpell("player",982) then return; end
                      elseif deadPet == false then
                        local Autocall = getValue("Auto Summon");

                        if Autocall == 1 then
                          if castSpell("player",883) then return; end
                        elseif Autocall == 2 then
                          if castSpell("player",83242) then return; end
                        elseif Autocall == 3 then
                          if castSpell("player",83243) then return; end
                        elseif Autocall == 4 then
                          if castSpell("player",83244) then return; end
                        elseif Autocall == 5 then
                          if castSpell("player",83245) then return; end
                        else
                          Print("Auto Call Pet Error")
                        end
                      end

                  end
                  if waitForPetToAppear == nil then
                    waitForPetToAppear = GetTime()
                  end
                end
            end
            --Revive
            if isChecked("Auto Summon") and UnitIsDeadOrGhost("pet") then
              if castSpell("player",982) then return; end
            end

            -- Mend Pet
            if isChecked("Mend Pet") and getHP("pet") < getValue("Mend Pet") and not UnitBuffID("pet",136) then
              if castSpell("pet",136) then return; end
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
            if br.player.mode.misdirection == 1 then
              if getSpellCD(34477) <= 0.1 then
                if (UnitThreatSituation("player", "target") ~= nil or (UnitExists("target") and isDummy("target"))) and UnitAffectingCombat("player") then
                    if inInstance or inRaid then
                        for i = 1, #br.friend do
                            if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and UnitAffectingCombat(br.friend[i].unit) then
                              CastSpellByName(GetSpellInfo(34477),br.friend[i].unit)
                            end
                        end
                    else
                        if GetUnitExists("pet") then
                          CastSpellByName(GetSpellInfo(34477),"pet")
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
        -- Exhilaration
                if isChecked("Exhilaration") and php <= getOptionValue("Exhilaration") then
                    if cast.exhilaration("player") then return end
                end
        -- Aspect of the Turtle
                if isChecked("Aspect Of The Turtle") and inCombat and php <= getOptionValue("Aspect Of The Turtle") then
                    if cast.aspectOfTheTurtle("player") then return end
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

        local function actionList_Opener()
            if opener == false then
                openerStarted = true
                if cast.aMurderOfCrows(units.dyn40) then
                    MOC = true
                    print("Murder of Crows Cast")
                end
                if MOC == true then
                    if cast.bestialWrath() then
                        BW = true
                        print("Bestial Wrath Cast")
                         MOC = false 
                    end
                end
                if BW == true then                  
                    if talent.direFrenzy then
                        if cast.direFrenzy(units.dyn40) then
                            DIRE = true 
                            print("Dire Frenzy Cast")
                            BW = false
                        end
                    elseif cast.direBeast(units.dyn40) then 
                        DIRE = true
                        print("Dire Beast Cast")
                        BW = false
                    end
                end
                if DIRE == true then
                    if #multishotTargets < 2 then
                        if cast.killCommand(units.dyn40) then
                            KCMS = true
                            print("Kill Command Cast")
                            DIRE = false
                        end
                    elseif cast.multiShot(units.dyn40) then 
                        KCMS = true
                        print("Multi Shot Cast")
                        DIRE = false
                    end
                end
                if KCMS == true then                    
                    if talent.direFrenzy then
                        if cast.titansThunder(units.dyn40) then 
                            TT = true
                            print("Titan's Thunder Cast")
                            KCMS = false 
                        end
                    else
                         TT = true
                         KCMS = false
                    end
                end
                if TT == true then
                    if talent.direFrenzy then
                        if cast.direFrenzy(units.dyn40) then
                            DIRE2 = true 
                            print("Dire Frenzy 2 Cast")
                            TT = false
                        end
                    elseif cast.direBeast(units.dyn40) then 
                        DIRE2 = true
                        print("Dire Beast 2 Cast")
                        TT = false
                    end
                end
                if DIRE2 == true then
                    if cast.aspectOfTheWild() then 
                        DIRE2 = false
                        print("Aspect of the Wild Cast")
                        print("Opener Complete")
                        opener = true
                        openerStarted = false
                        return 
                    end
                end
            end
        end

---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or (IsMounted() or IsFlying()) or pause() or mode.rotation==4 then
            if not pause() and IsPetAttackActive() then
                PetStopAttack()
                PetFollow()
            end
            return true
        else
            if buff.aspectOfTheTurtle.exists() then return end
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
--------------------------
--- In Combat Rotation ---
--------------------------
            if inCombat and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 then
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                    if actionList_Interrupts() then return end

                    if isChecked("Opener") and opener == false and isBoss(units.dyn40) then
                        if (cd.bestialWrath.remain() <= gcd and cd.aMurderOfCrows.remain() <= gcd and cd.aspectOfTheWild.remain() <= gcd and cd.titansThunder.remain() <= gcd and charges.direBeast.frac() >= 1.5) or openerStarted == true then
                            if actionList_Opener() then return end
                        else
                            opener = true
                        end
                    else
                        opener = true
                    end
    --Kuu Rewrite
                    if opener == true then
                        if getOptionValue("APL Mode") == 1 then
                    -- Start Attack
                        if getDistance(units.dyn40) < 40 then
                            StartAttack()
                        end
					-- Dire Frenzy
                        if talent.direFrenzy and getSpellCD(217200) == 0 and (((buff.direFrenzy.remain("pet") <= (gcd*1.2) or not buff.direFrenzy.exists("pet"))))then
                            if cast.direFrenzy(units.dyn40) then return end
						end
                    -- Bestial Wrath
                        if isChecked("Bestial Wrath") and useCDs() and (cd.aspectOfTheWild.remain() > 10 or cd.aspectOfTheWild.remain() <= gcd) then
                            if cast.bestialWrath() then return end
                        end
                    -- Aspect of the Wild
                        if isChecked("Aspect of the Wild") and useCDs() then
                            if (hasEquiped(137101) and hasEquiped(140806) and talent.oneWithThePack) or ((buff.bestialWrath.exists() and buff.bestialWrath.remain() >= 13) or cd.bestialWrath.remain() <= gcd) or (ttd(units.dyn40) ~= nil and ttd(units.dyn40) < 12 and isBoss(units.dyn40)) then
                                if cast.aspectOfTheWild() then return end
                            end
						end
                    -- Titan's Thunder
                        if (talent.direFrenzy or (buff.direBeast.exists() and buff.direBeast.remain() > 7) and br.player.mode.titanthunder == 1) or (buff.bestialWrath.exists() and (talent.direFrenzy or buff.direBeast.exists()) and br.player.mode.titanthunder == 2) then
                            if cast.titansThunder(units.dyn40) then return end
                        end						
                    -- Murder of Crows
                        if talent.aMurderOfCrows and isChecked("A Murder Of Crows / Barrage") and (br.player.mode.murderofcrows == 1 or (br.player.mode.murderofcrows == 2 and useCDs())) then
                            if (cd.bestialWrath.remain() < 2 or cd.bestialWrath.remain() > 50) or (buff.bestialWrath.exists() and buff.bestialWrath.remain() >= 13) or (ttd(units.dyn40) ~= nil and ttd(units.dyn40) <= 13) then
                                if cast.aMurderOfCrows(units.dyn40) then return end
                            end
						end
					-- Multi Shot
                        if #multishotTargets > 3 and (mode.rotation == 1) and (beastCleaveTimer < gcd or beastCleaveTimer == 0) then
                            if cast.multiShot(units.dyn40) then return end
							end
                    -- Kill Command
                            if cast.killCommand(units.dyn40) then return end
                    -- Dire Beast
                        if not talent.direFrenzy and cd.bestialWrath.remain() > 3 then
                            if ((not hasEquiped(137227) or cd.killCommand.remain() >= 3) and (t19_2pc or not buff.bestialWrath.exists())) or (charges.direBeast.frac() >= 1.9 or cd.titansThunder.remain() <= gcd) then
                                if cast.direBeast(units.dyn40) then return end
                            end
						end
					-- Cobra Shot during bestial wrath
                        if power >= 105 or (not talent.aspectOfTheBeast and buff.bestialWrath.exists() and powerRegen* cd.killCommand.remain() > 30) then
                            if cast.cobraShot(units.dyn40) then return end			
							end							
					-- Multi Shot
                        if #multishotTargets > 1 and (mode.rotation == 1) and (beastCleaveTimer < gcd or beastCleaveTimer == 0) then
                            if cast.multiShot(units.dyn40) then return end
							end					
                    -- Cobra Shot
                        if power >= 105 and cd.killCommand.remain() > gcd*0.7 then
                            if cast.cobraShot(units.dyn40) then return end
							end
                    end
                end
            end --End In Combat
        end --End Rotation Logic
    end -- End Timer
end -- End runRotation
local id = 253
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
local rotationName = "Cpoworks"

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
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR","|cffFFFFFFKuu"}, 3, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
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
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = enemies or {}
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local fatality                                      = false
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = ObjectExists("mouseover")
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
        local power, powerMax, powerRegen, powerDeficit     = br.player.power.amount.focus, br.player.power.focus.max, br.player.power.regen, br.player.power.focus.deficit
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local recharge                                      = br.player.recharge
        local solo                                          = #br.friend < 2
        local friendsInRange                                = friendsInRange
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local trinketProc                                   = false
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.ttm
        local units                                         = units or {}

        units.dyn40 = br.player.units(40)
        enemies.yards40 = br.player.units(40)

        -- BeastCleave 118445
        local beastCleaveTimer                              = getBuffDuration("pet", 118445)

   		if leftCombat == nil then leftCombat = GetTime() end
		if profileStop == nil then profileStop = false end

--------------------
--- Action Lists ---
--------------------
	-- Action List - Pet Management
        local function actionList_PetManagement()
            if not IsMounted() then
                if isChecked("Auto Summon") and not UnitExists("pet") and (UnitIsDead("pet") ~= nil or UnitIsDead("pet") == false) then
                  if waitForPetToAppear ~= nil and waitForPetToAppear < GetTime() - 2 then
                    if lastFailedWhistle and lastFailedWhistle > GetTime() - 3 then
                      if castSpell("player",RevivePet) then return; end
                    else
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
                if ObjectExists("target") then
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
        -- Volley
        -- Should be active all the time
            if talent.volley and not buff.volley.exists() then
                if cast.volley() then return end
            end
            --Misdirection
            -- if getSpellCD(34477) <= 0.1 then
            --     if UnitThreatSituation("player", "target") ~= nil and UnitAffectingCombat("player") then
            --         for i = 1, #br.friend do
            --             if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and UnitAffectingCombat(br.friend[i].unit) then
            --                 if UnitChecks(br.friend[i].unit) then
            --                     CastSpellByName(GetSpellInfo(34477),br.friend[i].unit)
            --                 end
            --             end
            --         end
            --     end
            -- end
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
        -- Exhilaration
                if isChecked("Aspect Of The Turtle") and php <= getOptionValue("Aspect Of The Turtle") then
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
                if isChecked("Intimidation") and talent.intimidation and cd.intimidation == 0 and
                UnitExists("pet") and (UnitIsDead("pet") ~= nil or UnitIsDead("pet") == false) then
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
                -- Blood Elf Arcane Torrent on focus deficit (SimC)
                if isChecked("Racial") and (br.player.race == "BloodElf") and powerDeficit >= 30 then
                     if castSpell("player",racial,false,false,false) then return end
                end
                if buff.bestialWrath.exists() then
                    -- Trinkets
                    if useCDs() and getOptionValue("Trinkets") ~= 4 then
                        if (getOptionValue("Trinkets") == 1 or getOptionValue("Trinkets") == 3) and canUse(13) then
                            useItem(13)
                        end
                        if (getOptionValue("Trinkets") == 2 or getOptionValue("Trinkets") == 3) and canUse(14) then
                            useItem(14)
                        end
                    end
                    -- Agi-Pot
                    if isChecked("Agi-Pot") and canUse(agiPot) and inRaid then
                        useItem(agiPot);
                        return true
                    end
                    -- Racial: Orc Blood Fury | Troll Berserking
                    if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll") then
                         if castSpell("player",racial,false,false,false) then return end
                    end
                    -- Aspect of the Wild
                    if isChecked("Aspect of the Wild") then
                        if cast.aspectOfTheWild() then return end
                    end
                    -- Stampede
                    if isChecked("Stampede") then
                        if cast.stampede(units.dyn40) then return end
                    end
                end
                -- A Murder of Crows
                if isChecked("A Murder Of Crows / Barrage") then
                    if cast.aMurderOfCrows(units.dyn40) then return end
                end
                -- Bestial Wrath
                if isChecked("Bestial Wrath") then
                    if cast.bestialWrath() then return end
                end
            end -- End useCooldowns check
        end -- End Action List - Cooldowns
    -- Action List - Single Target
        local function actionList_SingleTarget()
            -- Titan's Thunder
            -- if PetCount(DireBeast) > 0 or HasTalent(DireFrenzy)
            if buff.direBeast.exists() or talent.direFrenzy then
                if cast.titansThunder(units.dyn40) then return end
            end
            -- Dire Frenzy
            -- if CooldownSecRemaining(BestialWrath) > 7.5
            -- You get a very slight damage increase by holding onto this until Bestial Wrath if it will cool down soon.
            if cd.bestialWrath > 7.5 and cd.direFrenzy == 0 then
                if cast.direFrenzy(units.dyn40) then return end
            end
            -- Dire Beast
            if cast.direBeast(units.dyn40) then return end
            -- Kill Command
            if cast.killCommand(units.dyn40) then return end
            -- Chimaera Shot
            if cast.chimaeraShot(units.dyn40) then return end
            -- Multi-Shot
            -- if BuffRemainingSec(BeastCleaveTracker) <= GlobalCooldownSec and TargetsInRadius(MultiShot) > 1 and Power > 70 - PowerRegen * CooldownSecRemaining(KillCommand)
            if beastCleaveTimer <= gcd and #multishotTargets > 1 and power > 70 - powerRegen * cd.killCommand then
                if cast.multiShot(units.dyn40) then return end
            end
            -- Cobra Shot
            -- if Power > 70 - PowerRegen * CooldownSecRemaining(KillCommand) and TargetsInRadius(MultiShot) < 2
            -- Use Cobra Shot if it won't end up delaying a Kill Command.
            if power > 70 - powerRegen * cd.killCommand and #multishotTargets < 2 then
                if cast.cobraShot(units.dyn40) then return end
            end
        end -- End Action List - Single Target
    -- Action List - Multi Target
        local function actionList_MultiTarget()
            -- Multi-Shot
            -- if BuffRemainingSec(BeastCleaveTracker) <= GlobalCooldownSec
            if beastCleaveTimer <= gcd then
                if cast.multiShot(units.dyn40) then return end
            end
            -- Stampede
            if cast.stampede(units.dyn40) then return end
            -- Titan's Thunder
            -- if PetCount(DireBeast) > 0 or HasTalent(DireFrenzy)
            if buff.direBeast.exists() or talent.direFrenzy then
                    if cast.titansThunder(units.dyn40) then return end
                end
            -- Barrage
            if cast.barrage(units.dyn40) then return end
            -- A Murder of Crows
            -- The targeting logic is in the Target Priorities section.
            if cast.aMurderOfCrows(units.dyn40) then return end
            -- Dire Frenzy
            -- if CooldownSecRemaining(BestialWrath) > 7.5
            if cd.bestialWrath > 7.5 then
                if cast.direFrenzy(units.dyn40) then return end
            end
            -- Dire Beast
            if cast.direBeast(units.dyn40) then return end
            -- Multi-Shot
            -- if (BuffRemainingSec(BeastCleaveTracker) <= GlobalCooldownSec or TargetsInRadius(MultiShot) > 6) and (not HasTalent(Barrage) or CooldownSecRemaining(Barrage) > 3)
            if (beastCleaveTimer <= gcd or multishotTargets > 6) and (not talent.barrage or cd.barrage > 3) then
                if cast.multiShot(units.dyn40) then return end
            end
            -- Kill Command
            if cast.killCommand(units.dyn40) then return end
            -- Chimaera Shot
            if cast.chimaeraShot(units.dyn40) then return end
            -- Cobra Shot
            -- if PowerToMax <= GlobalCooldownSec * 2 * PowerRegen
            -- Pool Focus for Multi-Shot when in AoE. Only use Cobra Shot if you will cap Focus.
            if powerDeficit <= gcd * 2 * powerRegen then
                if cast.cobraShot(units.dyn40) then return end
            end
        end -- End Action List - Multi Target
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
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                    if getOptionValue("APL Mode") == 1 then
                -- Start Attack
                        if getDistance(units.dyn40) < 40 then
                            StartAttack()
                        end
                -- A Murder of Crows
                -- Should always be used
                        if isChecked("A Murder Of Crows / Barrage") then
                            if cast.aMurderOfCrows(units.dyn40) then return end
                        end
                -- DireBeast
                        if cd.bestialWrath > 3 then
                            if cast.direBeast(units.dyn40) then return end
                        end
                -- DireFrenzy
                        if cd.bestialWrath > 6 then
                            if cast.direFrenzy(units.dyn40) then return end
                        end
                -- Barrage
                        if isChecked("A Murder Of Crows / Barrage") and #multishotTargets > 1 then
                            if cast.barrage(units.dyn40) then return end
                        end
                -- Titans Thunder
                        if talent.direFrenzy or cd.direBeast >= 3 or (buff.bestialWrath.exists() and buff.direBeast.exists()) then
                            if cast.titansThunder(units.dyn40) then return end
                        end
                -- Bestial Wrath
                -- Should always be used
                        if isChecked("Bestial Wrath") then
                            if cast.bestialWrath() then return end
                        end
                -- Multi Shot
                        if #multishotTargets > 4 and (beastCleaveTimer <= gcd * 2 ) then
                            if cast.multiShot(units.dyn40) then return end
                        end
                -- Kill Command
                        if cast.killCommand(units.dyn40) then return end
                -- Multi Shot
                        if #multishotTargets > 1 and (beastCleaveTimer <= gcd) then
                            if cast.multiShot(units.dyn40) then return end
                        end
                -- Chimaera Shot
                        if power < 90 then
                            if cast.chimaeraShot(units.dyn40) then return end
                        end
                -- Cobra Shot
                        if power > 70 - powerRegen * cd.killCommand and power > 70 - powerRegen * cd.bestialWrath or (buff.bestialWrath.exists() and powerRegen * cd.killCommand > 30) then
                            if cast.cobraShot(units.dyn40) then return end
                        end
                    end -- End SimC APL
    ------------------------
    --- Ask Mr Robot APL ---
    ------------------------
                    if getOptionValue("APL Mode") == 2 then
                        -- Cooldowns
                        -- if HasBuff(BestialWrath)
                        -- Bestial Wrath
                        -- Aspect of the Wild
                        -- if PowerToMax >= 30
                        if actionList_Cooldowns() then return end
                        -- MultiTarget
                        -- if TargetsInRadius(MultiShot) > 2
                        if (#multishotTargets > 2 and mode.rotation == 1) or mode.rotation == 2 then
                            if actionList_MultiTarget() then return end
                        end
                        -- SingleTarget
                        -- if TargetsInRadius(MultiShot) <= 2
                        if actionList_SingleTarget() then return end
                    end
    --Kuu Rewrite
                    if getOptionValue("APL Mode") == 3 then
                    -- Start Attack
                        if getDistance(units.dyn40) < 40 then
                            StartAttack()
                        end
                    -- Arcane Torrent
                        if isChecked("Racial") and (br.player.race == "BloodElf") and powerDeficit >= 30 then
                            if castSpell("player",racial,false,false,false) then return end
                        end
                    -- Orc Blood Fury | Troll Berserking
                        if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll") then
                             if castSpell("player",racial,false,false,false) then return end
                        end
                    -- Volley
                        if talent.volley and not buff.volley.exists() then
                            if cast.volley() then return end
                        end
                    -- Potion of Prolonged Power
                        --TODO
                    -- Murder of Crows
                        if talent.aMurderOfCrows and isChecked("A Murder Of Crows / Barrage") and useCDs() then
                            if cast.aMurderOfCrows(units.dyn40) then return end
                        end
                    -- Stampede
                        if isChecked("Stampede") and useCDs() and (UnitBuffID("player", 2825) or UnitBuffID("player", 32182) or UnitBuffID("player", 90355) or UnitBuffID("player", 160452) or UnitBuffID("player", 80353) or buff.bestialWrath.exists() or buff.bestialWrath.remain() <= 2 or ttd(units.dyn40) <= 14) then
                            if cast.stampede(units.dyn40) then return end
                        end
                    -- Dire Beast
                        if not talent.direFrenzy and cd.bestialWrath > 3 then
                            if cast.direBeast(units.dyn40) then return end
                        end 
                    -- Dire Frenzy
                        if talent.direFrenzy and getSpellCD(217200) == 0 and ((cd.bestialWrath > 6 and (not hasEquiped(144326) or buff.direFrenzy.remain("pet") <= (gcd*1.2))) or ttd(units.dyn40) < 9) then
                            if cast.direFrenzy(units.dyn40) then return end
                        end
                    -- Aspect of the Wild
                        if isChecked("Aspect of the Wild") and useCDs() and buff.bestialWrath.exists() or ttd(units.dyn40) < 12 then
                            if cast.aspectOfTheWild() then return end
                        end
                    -- Barrage
                        if isChecked("A Murder Of Crows / Barrage") and #multishotTargets > 1 then
                            if cast.barrage(units.dyn40) then return end
                        end
                    -- Titan's Thunder
                        if talent.direFrenzy or cd.direBeast >= 3 or ((buff.bestialWrath.exists() and buff.direBeast.exists("pet"))) then
                            if cast.titansThunder(units.dyn40) then return end
                        end
                    -- Bestial Wrath
                        if isChecked("Bestial Wrath") and useCDs() and (cd.aspectOfTheWild > 10 or cd.aspectOfTheWild == 0) then
                            if cast.bestialWrath() then return end
                        end
                    -- Multi Shot
                        if #multishotTargets > 4 and (beastCleaveTimer < gcd or beastCleaveTimer == 0) then
                            if cast.multiShot(units.dyn40) then return end
                        end
                    -- Kill Command
                        if cast.killCommand(units.dyn40) then return end
                    -- Multi Shot
                        if #multishotTargets > 1 and (beastCleaveTimer < (gcd*2) or beastCleaveTimer == 0) then
                            if cast.multiShot(units.dyn40) then return end
                        end
                    -- Chimera Shot
                        if power < 90 and talent.chimeraShot then
                            if cast.chimaeraShot(units.dyn40) then return end
                        end
                    -- Cobra Shot
                        if (cd.killCommand > ttm and cd.bestialWrath > ttm) or (buff.bestialWrath.exists() and powerRegen* cd.killCommand > 30) or (ttd(units.dyn40) < cd.killCommand) then
                            if cast.cobraShot(units.dyn40) then return end
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

local rotationName = "CuteOne" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.mongooseBite },
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
-- Trap Button
    TrapModes = {
        [1] = { mode = "On", value = 1 , overlay = "Traps Enabled", tip = "Will Use Traps.", highlight = 1, icon = br.player.spell.explosiveTrap },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "Traps Will Not Be Used.", highlight = 0, icon = br.player.spell.freezingTrap }
    };
    CreateButton("Trap",5,0)
-- Artifact Button
    ArtifactModes = {
        [1] = { mode = "On", value = 1 , overlay = "Artifact Enabled", tip = "Will Use Artifact.", highlight = 1, icon = br.player.spell.furyOfTheEagle },
        [2] = { mode = "Off", value = 2 , overlay = "Artifact Disabled", tip = "Artifact Will Not Be Used.", highlight = 0, icon = 6603 }
    };
    CreateButton("Artifact",6,0)
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
        -- Artifact
            br.ui:createDropdownWithout(section, "Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        -- AoE
            br.ui:createSpinnerWithout(section, "Units To AoE", 3, 1, 10, 1, "|cffFFFFFFSet to desired units to start AoE at.")
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
        -- Potion
            br.ui:createCheckbox(section,"Potion")
        -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Seventh Demon","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Aspect of the Eagle
            br.ui:createCheckbox(section,"Aspect of the Eagle")
        -- Snake Hunter
            br.ui:createCheckbox(section,"Snake Hunter")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Engineering: Shield-o-tronic
            br.ui:createSpinner(section, "Shield-o-tronic",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Aspect Of The Turtle
            br.ui:createSpinner(section, "Aspect Of The Turtle",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Exhilaration
            br.ui:createSpinner(section, "Exhilaration",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Feign Death
            br.ui:createSpinner(section, "Feign Death", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Freezing Trap
            br.ui:createCheckbox(section,"Freezing Trap")
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
        UpdateToggle("Artifact",0.25)
        br.player.mode.artifact = br.data.settings[br.selectedSpec].toggles["Artifact"]

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
        local power, powerMax, powerRegen, powerDeficit     = br.player.power.focus.amount(), br.player.power.focus.max(), br.player.power.focus.regen(), br.player.power.focus.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local solo                                          = #br.friend < 2
        local friendsInRange                                = friendsInRange
        local spell                                         = br.player.spell
        local t19_4pc                                       = TierScan("T19") >= 4
        local t20_2pc                                       = TierScan("T20") >= 2
        local t20_4pc                                       = TierScan("T20") >= 4
        local talent                                        = br.player.talent
        local trinketProc                                   = false
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.focus.ttm()
        local units                                         = units or {}
        local use                                           = br.player.use

        units.dyn5 = br.player.units(5)
        units.dyn40 = br.player.units(40)
        enemies.yards5 = br.player.enemies(5)
        enemies.yards5t = br.player.enemies(5,br.player.units(5,true))
        enemies.yards8 = br.player.enemies(8)
        enemies.yards40 = br.player.enemies(40)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        -- ChatOverlay(tostring(units.dyn5).." | "..tostring(units.dyn40))

        -- if UnitExists("target") then
        --     ChatOverlay(round2(getDistance("target","player","dist"),2)..", "..round2(getDistance("target","player","dist2"),2)..", "..round2(getDistance("target","player","dist3"),2)..", "..round2(getDistance("target","player","dist4"),2)..", "..round2(getDistance("target"),2))
        -- end
--------------------
--- Action Lists ---
--------------------
    -- Action List - Pet Management
        local function actionList_PetManagement()
            if IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player") then
                waitForPetToAppear = GetTime()
            elseif isChecked("Auto Summon") and not GetUnitExists("pet") and (not UnitIsDeadOrGhost("pet") or IsPetActive() == false) then
                if waitForPetToAppear ~= nil and GetTime() - waitForPetToAppear > 2 then
                    if deadPet then
                        if cast.revivePet() then return end
                    elseif not deadPet then
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
            if isChecked("Mend Pet") and GetUnitExists("pet") and not UnitIsDeadOrGhost("pet") and getHP("pet") < getValue("Mend Pet") and not UnitBuffID("pet",136) then
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
        -- Muzzle
                if isChecked("Muzzle") then
                    for i=1, #enemies.yards5 do
                        thisUnit = enemies.yards5[i]
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if cast.muzzle(thisUnit) then return end
                        end
                    end
                end
        -- Freezing Trap
                if isChecked("Freezing Trap") then
                    for i = 1, #enemies.yards40 do
                        thisUnit = enemies.yards40[i]
                        if getDistance(thisUnit) > 8 and getCastTimeRemain(thisUnit) > 3 then
                            if cast.freezingTrap(thisUnit,"ground") then return end
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
                -- arcane_torrent,if=focus<=30
                -- berserking,if=buff.aspect_of_the_eagle.up
                -- blood_fury,if=buff.aspect_of_the_eagle.up
                if isChecked("Racial") and getSpellCD(racial) == 0 then
                    if (((br.player.race == "Orc" or br.player.race == "Troll") and buff.aspectOfTheEagle.exists())
                        or (br.player.race == "BloodElf" and power <= 30))
                    then
                        if castSpell("player",racial,false,false,false) then return end
                    end
                end                
            -- Potion
                -- potion,if=buff.aspect_of_the_eagle.up
                if isChecked("Potion") and inRaid and canUse(142117) and buff.aspectOfTheEagle.exists() then
                    useItem(142117)
                end
            -- Snake Hunter
                -- snake_hunter,if=cooldown.mongoose_bite.charges=0&buff.mongoose_fury.remains>3*gcd&buff.aspect_of_the_eagle.down
                if isChecked("Snake Hunter") then
                    if charges.mongooseBite.count() == 0 and buff.mongooseFury.remain() > 3 * gcd and not buff.aspectOfTheEagle.exists() then
                        if cast.snakeHunter() then return end
                    end
                end
            -- Aspect of the Eagle
                if isChecked("Aspect of the Eagle") then
                    -- aspect_of_the_eagle,if=buff.mongoose_fury.stack>=2&buff.mongoose_fury.remains>3*gcd
                    if buff.mongooseFury.stack() >= 2 and buff.mongooseFury.remain() > 3 * gcd then
                        if cast.aspectOfTheEagle("player") then return end
                    end
                end
            end -- End useCooldowns check
        end -- End Action List - Cooldowns
    -- Action List - AOE
        local function actionList_AOE()
        -- Butchery
            -- butchery
            if talent.butchery then
                if cast.butchery("player") then return end
            end
        -- Caltrops
            -- caltrops,if=!dot.caltrops.ticking
            if talent.caltrops and not debuff.caltrops.exists(units.dyn5) then
                if cast.caltrops("best",nil,1,5) then return end
            end
        -- Explosive Trap
            -- explosive_trap
            if cast.explosiveTrap("best",nil,1,5) then return end
        -- Carve
            -- carve,if=(talent.serpent_sting.enabled&dot.serpent_sting.refreshable)|(active_enemies>5)
            if ((talent.serpentSting and not debuff.serpentSting.exists(units.dyn5)) or #enemies.yards5 > 5) and not talent.butchery then
                if cast.carve("player") then return end
            end
        end
    -- Action List - Bite Fill
        local function actionList_BiteFill()
        -- Spitting Cobra
            -- spitting_cobra
            if cast.spittingCobra() then return end
        -- Butchery
            -- butchery,if=equipped.frizzos_fingertrap&dot.lacerate.refreshable
            if talent.butchery and hasEquiped(137043) and debuff.lacerate.refresh(units.dyn5) then
                if cast.butchery("player") then return end
            end
        -- Carve
            -- carve,if=equipped.frizzos_fingertrap&dot.lacerate.refreshable
            if not talent.butchery and hasEquiped(137043) and debuff.lacerate.refresh(units.dyn5) then
                if cast.carve("player") then return end
            end
        -- Lacerate
            -- lacerate,if=refreshable
            if debuff.lacerate.refresh(units.dyn5) then
                if cast.lacerate(units.dyn5) then return end
            end
        -- Raptor Strike
            -- raptor_strike,if=active_enemies=1&talent.serpent_sting.enabled&dot.serpent_sting.refreshable
            if ((mode.rotation == 1 and #enemies.yards5 == 1) or mode.rotation == 3) and talent.serpentSting and debuff.serpentSting.refresh(units.dyn5) then
                if cast.raptorStrike() then return end
            end
        -- Steel Trap
            -- steel_trap
            if cast.steelTrap("best",nil,1,5) then return end
        -- A Murder of Crows
            -- a_murder_of_crows
            if cast.aMurderOfCrows() then return end
        -- Dragonsfire Grenade
            -- dragonsfire_grenade
            if cast.dragonsfireGrenade() then return end
        -- Explosive Trap
            -- explosive_trap
            if cast.explosiveTrap("best",nil,1,5) then return end
        -- Caltrops
            -- caltrops,if=!dot.caltrops.ticking
            if not debuff.caltrops.exists(units.dyn5) then
                if cast.caltrops("best",nil,1,5) then return end
            end
        end
    -- Action List - Bite Phase
        local function actionList_BitePhase()
        -- Fury of the Eagle
            -- fury_of_the_eagle,if=(!talent.way_of_the_moknathal.enabled|buff.moknathal_tactics.remains>(gcd*(8%3)))&buff.mongoose_fury.stack>3&cooldown.mongoose_bite.charges<1&!buff.aspect_of_the_eagle.up,interrupt_if=(talent.way_of_the_moknathal.enabled&buff.moknathal_tactics.remains<=tick_time)|(cooldown.mongoose_bite.charges=3)
            if mode.artifact == 1 and (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) then
                if (not talent.wayOfTheMokNathal or buff.mokNathalTactics.remain() > (gcd * (8 / 3))) and buff.mongooseFury.stack() > 3 and charges.mongooseBite.count() < 1 and not buff.aspectOfTheEagle.exists() then
                    if cast.furyOfTheEagle("player") then return end
                end
            end
        -- Lacerate
            -- lacerate,if=!dot.lacerate.ticking&set_bonus.tier20_4pc&buff.mongoose_fury.duration>cooldown.mongoose_bite.charges*gcd
            if not debuff.lacerate.exists(units.dyn5) and t20_4pc and buff.mongooseFury.duration() > charges.mongooseBite.count() * gcd then
                if cast.lacerate() then return end
            end
        -- Mongoose Bite
            -- mongoose_bite,if=charges>=2&cooldown.mongoose_bite.remains<gcd*2
            if charges.mongooseBite.count() >= 2 and cd.mongooseBite.remain() < gcd * 2 then
                if cast.mongooseBite() then return end
            end
        -- Flanking Strike
            -- flanking_strike,if=((buff.mongoose_fury.remains>(gcd*(cooldown.mongoose_bite.charges+2)))&cooldown.mongoose_bite.charges<=1)&(!set_bonus.tier19_4pc|(set_bonus.tier19_4pc&!buff.aspect_of_the_eagle.up))
            if ((buff.mongooseFury.remain() > (gcd * (charges.mongooseBite.count() + 2))) and charges.mongooseBite.count() <= 1) and (not t19_4pc or (t19_4pc and not buff.aspectOfTheEagle.exists())) then
                if cast.flankingStrike() then return end
            end
        -- Mongoose Bite
            -- mongoose_bite,if=buff.mongoose_fury.up
            if buff.mongooseFury.exists() then
                if cast.mongooseBite() then return end
            end
        -- Flanking Strike
            -- flanking_strike
            if cast.flankingStrike() then return end
        end
    -- Action List - Fillers
        local function actionList_Fillers()
        -- Carve
            -- carve,if=active_enemies>1&talent.serpent_sting.enabled&dot.serpent_sting.refreshable
            if not talent.butchery and ((mode.rotation == 1 and #enemies.yards5 > 1) or (mode.rotation == 2 and #enemies.yards5 > 0)) and talent.serpentSting and debuff.serpentSting.refresh(units.dyn5) then
                if cast.carve("player") then return end
            end
        -- Throwing Axes
            -- throwing_axes
            if cast.throwingAxes(units.dyn5) then return end
        -- Carve
            -- carve,if=active_enemies>2
            if not talent.butchery and ((mode.rotation == 1 and #enemies.yards5 > 2) or (mode.rotation == 2 and #enemies.yards5 > 0)) then
                if cast.carve("player") then return end
            end
        -- Raptor Strike
            -- raptor_strike,if=(talent.way_of_the_moknathal.enabled&buff.moknathal_tactics.remains<gcd*4)|(focus>((25-focus.regen*gcd)+55))
            if (talent.wayOfTheMokNathal and buff.mokNathalTactics.remain() < gcd * 4) or (power > ((25 - powerRegen * gcd) + 55)) or ((level < 20 and cd.flankingStrike.remain() > 0) or level < 12) then
                if cast.raptorStrike() then return end
            end
        end
    -- Action List - Mok'Maintain
        local function actionList_MokMaintain()
        -- Raptor Strike
            -- raptor_strike,if=(buff.moknathal_tactics.remains<gcd)|(buff.moknathal_tactics.stack<2)
            if (buff.mokNathalTactics.remain() < gcdMax) or (buff.mokNathalTactics.stack() < 2) then
                if cast.raptorStrike() then return end
            end
        end
    -- Action List - Pre-Bite Phase
        local function actionList_PreBitePhase()
        -- Flanking Strike
            -- flanking_strike,if=cooldown.mongoose_bite.charges<3
            if charges.mongooseBite.count() < 3 then
                if cast.flankingStrike() then return end
            end
        -- Spitting Cobra
            -- spitting_cobra
            if cast.spittingCobra() then return end
        -- Dragonsfire Grenade
            -- dragonsfire_grenade
            if cast.dragonsfireGrenade() then return end
        -- Raptor Strike
            -- raptor_strike,if=active_enemies=1&talent.serpent_sting.enabled&dot.serpent_sting.refreshable
            if ((mode.rotation == 1 and #enemies.yards5 == 1) or mode.rotation == 3) and talent.serpentSting and debuff.serpentSting.refresh(units.dyn5) then
                if cast.raptorStrike() then return end
            end
        -- Steel Trap
            -- steel_trap
            if cast.steelTrap("best",nil,1,5) then return end
        -- A Murder of Crows
            -- a_murder_of_crows
            if cast.aMurderOfCrows() then return end
        -- Explosive Trap
            -- explosive_trap
            if cast.explosiveTrap("best",nil,1,5) then return end
        -- Lacerate
            -- lacerate,if=refreshable
            if debuff.lacerate.refresh(units.dyn5) then
                if cast.lacerate() then return end
            end
        -- Butchery
            -- butchery,if=equipped.frizzos_fingertrap&dot.lacerate.refreshable
            if talent.butchery and hasEquiped(137043) and debuff.lacerate.refresh(units.dyn5) then
                if cast.butchery("player") then return end
            end
        -- Carve
            -- carve,if=equipped.frizzos_fingertrap&dot.lacerate.refreshable
            if not talent.butchery and hasEquiped(137043) and debuff.lacerate.refresh(units.dyn5) then
                if cast.carve("player") then return end
            end
        -- Mongoose Bite
            -- mongoose_bite,if=charges=3&cooldown.flanking_strike.remains>=gcd
            if charges.mongooseBite.count() == 3 and cd.flankingStrike.remain() >= gcd then
                if cast.mongooseBite() then return end
            end
        -- Caltrops
            -- caltrops,if=!dot.caltrops.ticking
            if not debuff.caltrops.exists(units.dyn5) then
                if cast.caltrops("best",nil,1,5) then return end
            end
        -- Flanking Strike
            -- flanking_strike
            if cast.flankingStrike() then return end
        -- Lacerate
            -- lacerate,if=remains<14&set_bonus.tier20_2pc
            if debuff.lacerate.remain(units.dyn5) < 14 and t20_2pc then
                if cast.lacerate(units.dyn5) then return end
            end 
        end
    -- Action List - Multi Target
        local function actionList_MultiTarget()    
            -- Dragonsfire Grenade
            if talent.dragonsfireGrenade then
                if cast.dragonsfireGrenade(units.dyn5) then return end
            end
            -- Explosive Trap
            if cast.explosiveTrap(units.dyn5) then return end
            -- Caltrops
            -- if DotCount(Caltrops) < TargetsInRadius(Caltrops)
            if talent.caltrops then
                if cast.caltrops("best",nil,1,5) then return end
            end
            -- Butchery / Carve
            if talent.butchery then
                if cast.butchery(units.dyn5) then return end
            else
                if cast.carve(units.dyn5) then return end
            end
        end -- End Action List - Multi Target
    -- Action List - Pre-Combat
        local function actionList_PreCombat()
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
                if mode.traps == 1 then  
        -- Explosive Trap
                    -- explosive_trap
                    if cast.explosiveTrap("best",nil,1,5) then return end
        -- Steel Trap
                    -- steel_trap
                    if cast.steelTrap("best",nil,1,5) then return end
        -- Caltrops
                    -- if cast.caltrops("best",nil,1,5) then return end
                end
        -- Dragonsfire Grenade
                -- dragonsfire_grenade 
                if cast.dragonsfireGrenade() then return end
        -- Start Attack
                StartAttack()
            end
        end -- End Action List - PreCombat
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
            if inCombat and isValidUnit(units.dyn40) and getDistance(units.dyn5) < 5 then
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
                    -- actions=auto_attack
                    if getDistance(units.dyn5) < 5 then
                        StartAttack()
                    end
            -- Call Action List - Mok'Maintain
                    -- call_action_list,name=mokMaintain,if=talent.way_of_the_moknathal.enabled
                    if talent.wayOfTheMokNathal then
                        if actionList_MokMaintain() then return end
                    end
            -- Cooldowns
                    -- call_action_list,name=CDs
                    if actionList_Cooldowns() then return end
            -- Call Action List - Pre-Bite Phase
                    -- call_action_list,name=preBitePhase,if=!buff.mongoose_fury.up
                    if not buff.mongooseFury.exists() then
                        if actionList_PreBitePhase() then return end
                    end
            -- Call Action List - AOE
                    -- call_action_list,name=aoe,if=active_enemies>=3
                    if ((mode.rotation == 1 and #enemies.yards5 >= getOptionValue("Units To AoE")) or (mode.rotation == 2 and #enemies.yards5 > 0)) 
                        and (not talent.butchery or (talent.butchery and charges.butchery.count() > 0)) and level >= 42
                    then
                        if actionList_AOE() then return end
                    end
                    if ((mode.rotation == 1 and (#enemies.yards5 < getOptionValue("Units To AoE") or (talent.butchery and charges.butchery.count() == 0))) or (mode.rotation == 3 and #enemies.yards5 > 0)) and level >= 20 then
            -- Call Action List - Bite Phase
                        -- call_action_list,name=bitePhase
                        if actionList_BitePhase() then return end
            -- Call Action List - Bite Filler
                        -- call_action_list,name=biteFill
                        if actionList_BiteFill() then return end
                    end
            -- Call Action List - Filler
                    -- call_action_list,name=fillers
                    if actionList_Fillers() then return end
                end -- End SimC APL
    ------------------------
    --- Ask Mr Robot APL ---
    ------------------------
                if getOptionValue("APL Mode") == 2 then
                    if getDistance(units.dyn5) < 5 then
                        StartAttack()
                    end
                    -- Harpoon
                    -- if not HasDot(OnTheTrail) and ArtifactTraitRank(EaglesBite) > 0
                    -- Cooldowns
                    -- if TargetsInRadius(Carve) > 2 or HasBuff(MongooseFury) or ChargesRemaining(MongooseBite) = SpellCharges(MongooseBite)
                    -- Use your cooldowns during or just before Mongoose Fury or an AoE phase.
                    if #enemies.yards5 > 2 or buff.mongooseFury.exists() or charges.mongooseBite.count() == charges.mongooseBite.max() then
                        if actionList_Cooldowns() then return end
                    end
                    -- MultiTarget
                    -- if TargetsInRadius(Carve) > 2
                    if (#enemies.yards5 > 2 and mode.rotation == 1) or mode.rotation == 2 then
                        if actionList_MultiTarget() then return end
                    end
                    -- Explosive Trap
                    if cast.explosiveTrap(units.dyn5) then return end
                    -- Dragonsfire Grenade
                    if talent.dragonsfireGrenade then
                        if cast.dragonsfireGrenade(units.dyn5) then return end
                    end
                    -- Raptor Strike
                    -- if HasTalent(WayOfTheMokNathal) and BuffRemainingSec(MokNathalTactics) <= GlobalCooldownSec
                    if talent.wayOfTheMokNathal and buff.mokNathalTactics.remain() <= gcd then
                        if cast.raptorStrike(units.dyn5) then return end
                    end
                    -- Snake Hunter
                    -- if ChargesRemaining(MongooseBite) = 0 and BuffRemainingSec(MongooseFury) > GlobalCooldownSec * 4
                    if talent.snakeHunter and charges.mongooseBite.count() == 0 and buff.mongooseFury.remain() > gcd * 4 then
                        if cast.snakeHunter(units.dyn5) then return end
                    end
                    -- Fury of the Eagle
                    -- if HasBuff(MongooseFury) and BuffRemainingSec(MongooseFury) <= GlobalCooldownSec * 2
                    -- You want to use this near the end of Mongoose Fury, but leave time to use one or two Mongoose Bite charges you might gain during the channel.
                    if buff.mongooseFury.exists() and buff.mongooseFury.remain() <= gcd * 2 then
                        if cast.furyOfTheEagle(units.dyn5) then return end
                    end
                    -- Mongoose Bite
                    -- if HasBuff(MongooseFury) or ChargesRemaining(MongooseBite) = SpellCharges(MongooseBite)
                    -- Once you hit max charges of Mongoose Bite, use it.
                    if buff.mongooseFury or charges.mongooseBite.count() == charges.mongooseBite.max() then
                        if cast.mongooseBite(units.dyn5) then return end
                    end
                    -- Steel Trap
                    if talent.steelTrap then
                        if cast.steelTrap(units.dyn5) then return end
                    end
                    -- Caltrops
                    -- if not HasDot(Caltrops) or DotCount(Caltrops) < TargetsInRadius(Caltrops)
                    if talent.caltrops and not not UnitDebuffID(units.dyn5,spell.debuffs.caltrops,"player") then
                        if cast.caltrops(units.dyn5) then return end
                    end
                    -- A Murder of Crows
                    if talent.aMurderOfCrows then
                        if cast.aMurderOfCrows(units.dyn5) then return end
                    end
                    -- Lacerate
                    -- if CanRefreshDot(Lacerate)
                    if debuff.lacerate.refresh(units.dyn5) then
                        if cast.lacerate(units.dyn5) then return end
                    end
                    -- Spitting Cobra
                    if cast.splittingCobra(units.dyn5) then return end
                    -- Raptor Strike
                    -- if (HasTalent(SerpentSting) and CanRefreshDot(SerpentSting))
                    if talent.serpentSting and not UnitDebuffID(units.dyn5,spell.debuffs.serpentSting,"player") then
                        if cast.raptorStrike(units.dyn5) then return end
                    end
                    -- Flanking Strike
                    if cast.flankingStrike(units.dyn5) then return end
                    -- Butchery
                    -- if TargetsInRadius(Butchery) > 1
                    if talent.butchery and #enemies.yards5 > 1 then
                        if cast.butchery(units.dyn5) then return end
                    end
                    -- Carve
                    -- if TargetsInRadius(Carve) > 1
                    if not talent.butchery and #enemies.yards5 > 1 then
                        if cast.carve(units.dyn5) then return end
                    end
                    -- Throwing Axes
                    if cast.throwingAxes(units.dyn5) then return end
                    -- Raptor Strike
                    -- if Power > 75 - CooldownSecRemaining(FlankingStrike) * PowerRegen and not HasTalent(ThrowingAxes)
                    -- If using Raptor Strike could possibly delay a Flanking Strike by using up your Focus, it is better to just wait for Flanking Strike to come off GCD. It is also not worth using if you have Throwing Axes talented.
                    if power > 75 - cd.flankingStrike.remain() * powerRegen and not talent.throwingAxes then
                        if cast.raptorStrike(units.dyn5) then return end
                    end
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

local rotationName = "Vilt"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.bloodBoil },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bloodBoil },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.heartStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.deathStrike}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.bonestorm },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.bonestorm },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.bonestorm }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.vampiricBlood },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.vampiricBlood }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.asphyxiate },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.asphyxiate }
    };
    CreateButton("Interrupt",4,0)
    --[[DnDModes = {
        [1] = { mode = "On", value = 1 , overlay = "Death and Decay Enabled", tip = "Use Death and Decay", highlight = 1, icon = br.player.spell.deathAndDecay },
        [2] = { mode = "Off", value = 2 , overlay = "Death and Decay Disabled", tip = "Don't use Death and Decay", highlight = 0, icon = br.player.spell.deathAndDecay }
    };
    CreateButton("DND",5,0)
    BoneStormModes = {
        [1] = { mode = "On", value = 1 , overlay = "Bonestorm Enabled", tip = "Use Bonestorm", highlight = 1, icon = br.player.spell.bonestorm },
        [2] = { mode = "Off", value = 2 , overlay = "Bonestorm Disabled", tip = "Don't use Bonestorm", highlight = 0, icon = br.player.spell.bonestorm }
    };
    CreateButton("BoneStorm",6,0)]]
    DNDModes = {
        [1] = { mode = "On", value = 1 , overlay = "Death and Decay Enabled", tip = "Use Death and Decay", highlight = 1, icon = br.player.spell.deathAndDecay},
        [2] = { mode = "Off", value = 2 , overlay = "Death and Decay Disabled", tip = "Don't use Death and Decay", highlight = 0, icon = br.player.spell.deathAndDecay}
    };
    CreateButton("DND",5,0)
    BoneStormModes = {
        [1] = { mode = "On", value = 1 , overlay = "BoneStorm Enabled", tip = "Use Bonestorm", highlight = 1, icon = br.player.spell.bonestorm},
        [2] = { mode = "Off", value = 2 , overlay = "BoneStorm Disabled", tip = "Don't use Bonestorm", highlight = 0, icon = br.player.spell.bonestorm}
    };
    CreateButton("BoneStorm",6,0)
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
            br.ui:createSpinnerWithout(section, "APL Mode", 2, 1, 2, 1, "|cffFFBB00APL Mode")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minutes. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Artifact
        --    br.ui:createDropdownWithout(section, "Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        -- Dark Command
            br.ui:createCheckbox(section,"Dark Command","|cffFFFFFFAuto Dark Command usage.")
            br.ui:createCheckbox(section,"Blooddrinker")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Agi Pot
            br.ui:createCheckbox(section, "Potion")
        -- Flask / Crystal
            br.ui:createCheckbox(section, "Flask / Crystal")
        -- Racial
            br.ui:createCheckbox(section, "Racial")
        -- Trinkets
            br.ui:createCheckbox(section, "Trinkets")
        -- Dancing Rune Weapon
            br.ui:createCheckbox(section, "Dancing Rune Weapon")
        br.ui:checkSectionState(section)
    -- Vilt Rotation Options
    section = br.ui:createSection(br.ui.window.profile, "Vilt Rotation Options")
        -- Death and Decay Target Amount
            br.ui:createSpinnerWithout(section, "Death and Decay", 3, 0, 10, 1, "|cffFFBB00Amount of Targets for DnD.")
        -- Use Bonestorm
            --br.ui:createCheckbox(section,"Use Bonestorm")
            --RP Hold Toggle
            br.ui:createDropdown(section,"Hold RP", br.dropOptions.Toggle, 6, "Hold Key to prevent RP spending")
        -- Bonestorm Target Amount
            br.ui:createSpinnerWithout(section, "Bonestorm Targets", 2, 0, 10, 1, "|cffFFBB00Amount of Targets for Bonestorm")
        -- Bonestorm RP Amount
            br.ui:createSpinnerWithout(section, "Bonestorm RP", 90, 0, 125, 5, "|cffFFBB00Amount of RP to use Bonestorm")
        -- DS High prio
            br.ui:createSpinnerWithout(section, "Death Strike High Prio", 35, 0, 100, 1, "|cffFFBB00Percent Hp to use High Prio Death Strike")
        -- DS Low prio
            br.ui:createSpinnerWithout(section, "Death Strike Low Prio", 75, 0, 100, 1, "|cffFFBB00Percent Hp to use Low Prio Death Strike")
        -- Consumption with Vampiric Blood up
            br.ui:createSpinner(section, "Consumption VB", 85, 0, 100, 1, "|cffFFBB00Percent Hp to use Consumption with Vampiric Blood as High Prio, when VB isn't active Consumption will be used as filler.")
        -- high prio blood boil for more dps
            br.ui:createCheckbox(section,"Blood Boil High Prio", "|cffFFBB00Lower Survivability, Higher DPS")
        br.ui:checkSectionState(section)
    -- Essence Options
        section = br.ui:createSection(br.ui.window.profile, "Essences")
        -- Lucid Dreams
            br.ui:createSpinner(section, "Lucid Dreams", 1.5, 0, 6, 0.1,"Runes left to use Lucid Dreams")
        --Concentrated flame
            br.ui:createDropdownWithout(section, "Use Concentrated Flame", {"DPS", "Heal", "Hybrid", "Never"}, 1)
            br.ui:createSpinnerWithout(section, "Concentrated Flame Heal", 70, 10, 90, 5)
        -- Anima of death
            br.ui:createSpinner(section,"Anima of Death", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
		br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Rune Tap
            br.ui:createSpinner(section, "Rune Tap",  40,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Anti-Magic Shell
            br.ui:createSpinner(section, "Anti-Magic Shell",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Blooddrinker
            --br.ui:createSpinner(section, "Blooddrinker",  75,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Vampiric Blood
            br.ui:createSpinner(section, "Vampiric Blood",  40,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Icebound Fortitude
            br.ui:createSpinner(section, "Icebound Fortitude",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        -- Raise Ally
            br.ui:createCheckbox(section,"Raise Ally")
            br.ui:createDropdownWithout(section, "Raise Ally - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Asphyxiate
            br.ui:createCheckbox(section,"Asphyxiate")
        -- Death Grip
            br.ui:createCheckbox(section,"Death Grip - Int")
        -- Mind Freeze
            br.ui:createCheckbox(section,"Mind Freeze")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupts",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
        -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
        -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
        -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugBlood", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("DND",0.25)
        br.player.ui.mode.DND = br.data.settings[br.selectedSpec].toggles["DND"]
        UpdateToggle("BoneStorm",0.25)
        br.player.ui.mode.BoneStorm = br.data.settings[br.selectedSpec].toggles["BoneStorm"]

--------------
--- Locals ---
--------------
        local addsExist                                     = false
        local addsIn                                        = 999
        local buff                                          = br.player.buff
        local canFlask                                      = canUseItem(br.player.flask.wod.staminaBig)
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local fatality                                      = false
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.staminaBig)
        local friendly                                      = friendly or GetUnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = GetObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.ui.mode
        local multidot                                      = (br.player.ui.mode.cleave == 1 or br.player.ui.mode.rotation == 2) and br.player.ui.mode.rotation ~= 3
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local potion                                        = br.player.potion
        local power, powmax, powgen                         = br.player.power.runicPower.amount(), br.player.power.runicPower.max(), br.player.power.runicPower.regen()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local runes                                         = br.player.power.runes.frac()
        local runicPower                                    = br.player.power.runicPower.amount()
        local runicPowerDeficit                             = br.player.power.runicPower.deficit()
        local solo                                          = #br.friend < 2
        local friendsInRange                                = friendsInRange
        local spell                                         = br.player.spell
        local stealth                                       = br.player.stealth
        local talent                                        = br.player.talent
        local trinketProc                                   = false
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.runicPower.ttm()
        local units                                         = br.player.units

        units.get(5)
        units.get(30,true)

        enemies.get(8)       -- Bonestorm
        enemies.get(10)     -- blood boil
        enemies.get(30)
        enemies.get(40)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if MRCastTime == nil then MRCastTime = GetTime() end
        if DSCastTime == nil then DSCastTime = GetTime() end

        UnitsWithoutBloodPlague = 0;
        for _, CycleUnit in pairs(enemies.yards10) do
            if not debuff.bloodPlague.exists(CycleUnit) then
                UnitsWithoutBloodPlague = UnitsWithoutBloodPlague + 1
            end
        end

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
                        Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end -- End Dummy Test
    -- Dark Command
            if isChecked("Dark Command") and inInstance then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
                        if cast.darkCommand(thisUnit) then return end
                    end
                end
            end
        end -- End Action List - Extras
    -- Action List - Defensive
        local function actionList_Defensive()
            if useDefensive() and not stealth and not flight then
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
        -- Rune Tap
                if isChecked("Rune Tap") and php <= getOptionValue("Rune Tap") and runes >= 3 and charges.runeTap.count() > 1 and not buff.runeTap.exists() then
                    if cast.runeTap() then return end
                end
        -- Anti-Magic Shell
                if isChecked("Anti-Magic Shell") and php <= getOptionValue("Anti-Magic Shell") then
                    if cast.antiMagicShell() then return end
                end
        -- Blooddrinker
                --[[if isChecked("Blooddrinker") and talent.blooddrinker and php <= getOptionValue("Blooddrinker") and not cast.blooddrinker.current() then
                    if cast.blooddrinker() then return end
                end]]
        -- Icebound Fortitude
                if isChecked("Icebound Fortitude") and php <= getOptionValue("Icebound Fortitude") then
                    if cast.iceboundFortitude() then return end
                end
        -- Vampiric Blood
                if isChecked("Vampiric Blood") and php <= getOptionValue("Vampiric Blood") then
                    if cast.vampiricBlood() then return end
                end
        -- Raise Ally
                if isChecked("Raise Ally") then
                    if getOptionValue("Raise Ally - Target")==1
                        and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player")
                    then
                        if cast.raiseAlly("target","dead") then return end
                    end
                    if getOptionValue("Raise Ally - Target")==2
                        and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player")
                    then
                        if cast.raiseAlly("mouseover","dead") then return end
                    end
                end
            end
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        -- Death Grip
                        if isChecked("Death Grip - Int") and getDistance(thisUnit) > 8 then
                            if cast.deathGrip(thisUnit) then return end
                        end
        -- Asphyxiate
                        if isChecked("Asphyxiate") and getDistance(thisUnit) < 20 and cd.mindFreeze.remain() > 0 then
                            if cast.asphyxiate(thisUnit) then return end
                        end
        -- Mind Freeze
                        if isChecked("Mind Freeze") and getDistance(thisUnit) < 15 then
                            if cast.mindFreeze(thisUnit) then return end
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
                    if canUseItem(13) then
                        useItem(13)
                    end
                    if canUseItem(14) then
                        useItem(14)
                    end
                end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury,buff.tigers_fury | berserking,buff.tigers_fury | arcane_torrent,buff.tigers_fury
                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Dancing Rune Weapon
                if isChecked("Dancing Rune Weapon") then
                    if cast.dancingRuneWeapon() then return end
                end
            end -- End useCooldowns check
        end -- End Action List - Cooldowns
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then
                if not stealth then
        -- Flask / Crystal
                    -- flask,type=flask_of_Ten_Thousand_Scars
                    if isChecked("Flask / Crystal") and not stealth then
                        if inRaid and canFlask and flaskBuff==0 and not (UnitBuffID("player",188035) or UnitBuffID("player",188034)) then
                            useItem(br.player.flask.wod.staminaBig)
                            return true
                        end
                        if flaskBuff==0 then
                            if not UnitBuffID("player",188033) and canUseItem(118922) then --Draenor Insanity Crystal
                                useItem(118922)
                                return true
                            end
                        end
                    end
        -- auto_attack
                    if canAttack() and not UnitIsDeadOrGhost("target") and getDistance("target") <= 5 then
                       StartAttack()
                    end
                end
            end -- End No Combat
        end -- End Action List - PreCombat
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 then
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
------------------------------
--- Out of Combat Rotation ---
------------------------------
            if actionList_PreCombat() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
        -- Cat is 4 fyte!
            if inCombat and profileStop==false and isValidUnit(units.dyn5) then
                -- auto_attack
                if getDistance("target") < 5 then
                    StartAttack()
                end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    -----------------------------
    --- In Combat - Cooldowns ---
    -----------------------------
                if actionList_Cooldowns() then return end
    ---------------------------
    --------- Vilt APL --------
    ---------------------------
                if getOptionValue("APL Mode") == 1 then
                    --[[if ((buff.crimsonScourge.exists() and talent.rapidDecomposition) or not moving and #enemies.yards8 >= getOptionValue("Death and Decay") and isChecked("Death and Decay") then
                        if cast.deathAndDecay("player","ground",getOptionValue("Death and Decay"),8) then return end
                    end]]
                    if mode.DND == 1 and not isMoving("player") and not isMoving("target") and ((#enemies.yards8 >= 1 and buff.crimsonScourge.exists() and talent.rapidDecomposition) or (#enemies.yards8 > 1 and buff.crimsonScourge.exists())) then
                        if cast.deathAndDecay("player") then return end
                    end
                    --#high prio heal
                    --I'll just use flat hp numbers defined by the user for simplicity and tends to work a little bit better anyway
                    if php < getOptionValue("Death Strike High Prio") then
                        if cast.deathStrike() then DSCastTime = GetTime(); return end
                    end
                    if talent.bonestorm and mode.BoneStorm == 1 and #enemies.yards8 >= getOptionValue("Bonestorm Targets") and runicPower >= getOptionValue("Bonestorm RP") then
                        if cast.bonestorm("player") then return end
                    end
                    if isChecked("Anima of Death") and cd.animaOfDeath.remain() <= gcd and inCombat and (#enemies.yards8 >= 3 or isBoss()) and php <= getOptionValue("Anima of Death") then
                        if cast.animaOfDeath("player") then return end
                    end    
                    --dump rp with deathstrike
                    if ((talent.bonestorm and cd.bonestorm.remain() > 3) or (talent.bonestorm and #enemies.yards8 < getOptionValue("Bonestorm Targets")) or (not talent.bonestorm or mode.BoneStorm == 2)) and runicPowerDeficit <= 20 and (isChecked("Hold RP") and not SpecificToggle("Hold RP")) then
                        if cast.deathStrike() then DSCastTime = GetTime(); return end
                    end
                    if (talent.ossuary and buff.boneShield.stack() <= 4) or (not talent.ossuary and buff.boneShield.stack() <= 2) or buff.boneShield.remain() < gcd*2 or not buff.boneShield.exists() then
                        if cast.marrowrend() then MRCastTime = GetTime(); return end
                    end
                    if isChecked("Lucid Dreams") and runes <= getOptionValue("Lucid Dreams") then
                        if cast.memoryOfLucidDreams("player") then return end
                    end
                    if getOptionValue("Use Concentrated Flame") ~= 1 and getOptionValue("Use Concentrated Flame") ~= 4 and php <= getValue("Concentrated Flame Heal") then
                        if cast.concentratedFlame("player") then
                            return
                        end
                    end
                    if not talent.soulgorge and #enemies.yards8 > 0 and UnitsWithoutBloodPlague >= 1 then                        
                        if cast.bloodBoil("player") then return end                        
                    end

                    if isChecked("Blooddrinker") and not buff.dancingRuneWeapon.exists("player") and buff.boneShield.exists("player") and runicPowerDeficit >= 15 then
                        if cast.blooddrinker("target") then return end
                    end

                    if isChecked("Blood Boil High Prio") and charges.bloodBoil.frac() >= 1.75 and #enemies.yards8 > 0 then
                        if cast.bloodBoil("player") then return end
                    end
                    if talent.bloodTap and runes < 3 then
                        if cast.bloodTap() then return end
                    end
                    if talent.consumption and useCDs() and isChecked("Consumption VB") then
                        if buff.vampiricBlood.exists() and php < getOptionValue("Consumption VB") and getEnemiesInCone(105,5) >= 1 then
                            if cast.consumption() then return end
                        end
                    end
                    --#low prio heal
                    if php < getOptionValue("Death Strike Low Prio") and (isChecked("Hold RP") and not SpecificToggle("Hold RP")) then
                        if cast.deathStrike() then DSCastTime = GetTime(); return end
                    end
                    if runeTimeTill(3) <= gcd and talent.ossuary and buff.boneShield.stack() <= 6 then
                        if cast.marrowrend() then MRCastTime = GetTime(); return end
                    end
                    if getOptionValue("Use Concentrated Flame") == 1 or (getOptionValue("Use Concentrated Flame") == 3 and php >= getValue("Concentrated Flame Heal")) then
                        if cast.concentratedFlame("target") then
                            return
                        end
                    end	
                    if mode.DND == 1 and not isMoving("target") and not isMoving("player") and runicPowerDeficit >= 10 and ((#enemies.yards8 == 1 and runes >= 3 and talent.rapidDecomposition) or #enemies.yards8 >= 3) then
                        if cast.deathAndDecay("player") then return end
                    end
                    if runeTimeTill(3) <= gcd and buff.boneShield.stack() >= 5 then
                        if cast.heartStrike() then return end
                    end
                    if mode.DND == 1 and not isMoving("player") and not isMoving("target") and #enemies.yards8 >= 1 and buff.crimsonScourge.exists() and not talent.rapidDecomposition then
                        if cast.deathAndDecay("player") then return end
                    end
                    if talent.consumption and useCDs() then
                        if getEnemiesInCone(105,5) >= 1 then
                            if cast.consumption() then return end
                        end
                    end
                    if getDistance("target") <= 8 and #enemies.yards8 > 0 then
                        if cast.bloodBoil("player") then return end
                    end
                --end -- End Vilt APL
    ---------------------------
    -------- Aethys APL -------
    ---------------------------
                elseif getOptionValue("APL Mode") == 2 then
                    -- Bone Shield
                    shouldMR = (buff.boneShield.remain("player") <= 6 or (ttd("target") < 5 and buff.boneShield.remain() < 10 and #enemies.yards8 == 1)) and true or false
                    if (buff.boneShield.remain("player") <= 6 or (ttd("target") < 5 and buff.boneShield.remain() < 10 and #enemies.yards8 == 1)) then
                        if cast.marrowrend() then MRCastTime = GetTime(); return end
                    end
                    -- Healing
                    if php <= 50 + (runicPower > 90 and 20 or 0) and not buff.bloodShield.exists() and (isChecked("Hold RP") and not SpecificToggle("Hold RP")) then
                        if cast.deathStrike() then DSCastTime = GetTime(); return end
                    end

                    -- APL
                    -- refresh blood plague
                    if #enemies.yards10 >= 1 and UnitsWithoutBloodPlague >= 1 then
                        if cast.bloodBoil() then return end
                    end
                    -- bonestorm
                    if talent.bonestorm and mode.DND == 1 and #enemies.yards8 >= getOptionValue("Bonestorm Targets") and runicPower >= getOptionValue("Bonestorm RP") then
                        if cast.bonestorm() then return end
                    end
                    -- DnD Crimson Scourge
                    if not isMoving("player") and not isMoving("target") and mode.DND == 1 and ((#enemies.yards8 == 1 and buff.crimsonScourge.exists() and talent.rapidDecomposition) or (#enemies.yards8 > 1 and buff.crimsonScourge.exists)) then
                        if cast.deathAndDecay("player") then return end
                    end
                    -- Blooddrinker
                    if isChecked("Blooddrinker") and not buff.dancingRuneWeapon.exists() and buff.boneShield.remain() > 3 and runicPowerDeficit >= 15 then
                        if cast.blooddrinker() then return end
                    end
                    -- Death Strike
                    if ((talent.blooddrinker or cd.blooddrinker.remain() <= gcd) and isChecked("Blooddrinker")) and not buff.dancingRuneWeapon.exists() and (runeTimeTill(1) <= gcd or runes >= 1) and (isChecked("Hold RP") and not SpecificToggle("Hold RP")) then
                        if cast.deathStrike() then DSCastTime = GetTime(); return end
                    end
                    -- Marrowrend
                    if buff.boneShield.stack() <= 6 and runicPowerDeficit >= 20 then
                        if cast.marrowrend() then MRCastTime = GetTime(); return end
                    end
                    -- Death Strike
                    if buff.boneShield.stack() <= 6 and runicPowerDeficit <= 20 and runes >= 2 and (isChecked("Hold RP") and not SpecificToggle("Hold RP")) then
                        if cast.deathStrike() then DSCastTime = GetTime(); return end
                    end
                    -- DND ST Rapid Decomp / AoE
                    if mode.DND == 1 and not isMoving("target") and not isMoving("player") and runicPowerDeficit >= 10 and ((#enemies.yards8 == 1 and runes >= 3 and talent.rapidDecomposition) or #enemies.yards8 >= 3) then
                        if cast.deathAndDecay("player") then return end
                    end
                    -- Heart Strike
                    if ((runeTimeTill(3) <= gcd or runes >= 3) and runicPowerDeficit >= 15) or (talent.heartbreaker and buff.deathAndDecay.exists() and runicPowerDeficit >= (15 + (math.min(#br.player.enemies(5), 5) * 2))) then
                        if cast.heartStrike() then return end
                    end
                    -- Death Strike RP Dump
                    if runeTimeTill(3) <= gcd or runes >= 3 or runicPowerDeficit <= 15 then
                        if cast.deathStrike() then DSCastTime = GetTime(); return end
                    end
                    -- DnD ST
                    if mode.DND == 1 and not isMoving("target") and not isMoving("player") and buff.crimsonScourge.exists() and not talent.rapidDecomposition then
                        if cast.deathAndDecay("player") then return end
                    end
                    -- Consumption
                    if talent.consumption and useCDs() then
                        if getEnemiesInCone(105,5) >= 1 then
                            if cast.consumption() then return end
                        end
                    end
                    -- Death's Caress
                    if getDistance("target") <= 30 and getDistance("target") > 10 and not debuff.bloodPlague.exists() then 
                        if cast.deathsCaress("target") then return end
                    end
                    -- Blood Boil filler
                    if #enemies.yards10 >= 1 then
                        if cast.bloodBoil() then return end
                    end


                end -- End Aethys APL
                --end
            end --End In Combat
        end --End Rotation Logic
    end -- End Timer
end -- End runRotation
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

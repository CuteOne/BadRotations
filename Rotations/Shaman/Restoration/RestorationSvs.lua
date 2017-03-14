local rotationName = "Svs" 

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.riptide},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.chainHeal},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.healingWave},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.giftOfTheQueen}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.healingTideTotem},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.healingTideTotem},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.healingTideTotem}
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.astralShift},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.astralShift}
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.windShear},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.windShear}
    };
    CreateButton("Interrupt",4,0)
-- Decurse Button
    DecurseModes = {
        [1] = { mode = "On", value = 1 , overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 1, icon = br.player.spell.purifySpirit },
        [2] = { mode = "Off", value = 2 , overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.purifySpirit }
    };
    CreateButton("Decurse",5,0)
-- DPS Button
    DPSModes = {
        [1] = { mode = "On", value = 1 , overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 1, icon = br.player.spell.lightningBolt },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.healingSurge }
    };
    CreateButton("DPS",6,0)
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
            br.ui:createCheckbox(section,"OOC Healing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Ghost Wolf
            br.ui:createCheckbox(section,"Ghost Wolf")
        -- Water Walking
            br.ui:createCheckbox(section,"Water Walking")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
         -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Cloudburst Totem
            br.ui:createSpinner(section, "Cloudburst Totem",  90,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Cloudburst Totem Targets",  3,  0,  40,  1,  "Minimum Cloudburst Totem Targets")
        -- Ancestral Guidance
            br.ui:createSpinner(section, "Ancestral Guidance",  60,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Ancestral Guidance Targets",  3,  0,  40,  1,  "Minimum Ancestral Guidance Targets")
        -- Ascendance
            br.ui:createSpinner(section,"Ascendance",  60,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Ascendance Targets",  3,  0,  40,  1,  "Minimum Ascendance Targets")
        -- Healing Tide Totem
            br.ui:createSpinner(section, "Healing Tide Totem",  50,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Healing Tide Totem Targets",  3,  0,  40,  1,  "Minimum Healing Tide Totem Targets")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
        -- Astral Shift
            br.ui:createSpinner(section, "Astral Shift",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Purge
            br.ui:createCheckbox(section,"Purge")
        -- Lightning Surge Totem
            br.ui:createSpinner(section, "Lightning Surge Totem - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Lightning Surge Totem - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Wind Shear
            br.ui:createCheckbox(section,"Wind Shear")
        -- Lightning Surge Totem
            br.ui:createCheckbox(section,"Lightning Surge Totem")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Healing Options
        section = br.ui:createSection(br.ui.window.profile, "Healing")
        -- Healing Rain
            br.ui:createSpinner(section, "Healing Rain",  80,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Healing Rain Targets",  2,  0,  40,  1,  "Minimum Healing Rain Targets")
        -- Riptide
            br.ui:createSpinner(section, "Riptide",  90,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Healing Stream Totem
            br.ui:createSpinner(section, "Healing Stream Totem",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Unleash Life
            br.ui:createSpinner(section, "Unleash Life",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Healing Wave
            br.ui:createSpinner(section, "Healing Wave",  70,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Healing Surge
            br.ui:createSpinner(section, "Healing Surge",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Chain Heal
            br.ui:createSpinner(section, "Chain Heal",  70,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Chain Heal Targets",  3,  0,  40,  1,  "Minimum Chain Heal Targets")  
        -- Gift of the Queen
            br.ui:createSpinner(section, "Gift of the Queen",  80,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Gift of the Queen Targets",  3,  0,  40,  1,  "Minimum Gift of the Queen Targets")
        -- Wellspring
            br.ui:createSpinner(section, "Wellspring",  80,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Wellspring Targets",  3,  0,  40,  1,  "Minimum Wellspring Targets")
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
    if br.timer:useTimer("debugRestoration", 0.1) then
        --print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Decurse",0.25)
        UpdateToggle("DPS",0.25)
        br.player.mode.decurse = br.data.settings[br.selectedSpec].toggles["Decurse"]
        br.player.mode.dps = br.data.settings[br.selectedSpec].toggles["DPS"]
--------------
--- Locals ---
--------------
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local enemies                                       = enemies or {}
        local gcd                                           = br.player.gcd
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local lowest                                        = br.friend[1].unit
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk        
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power.amount.mana, br.player.power.mana.max, br.player.power.regen
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local recharge                                      = br.player.recharge
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local wolf                                          = br.player.buff.ghostWolf.exists()
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.ttm
        local units                                         = units or {}
        local lowestTank                                    = {}    --Tank
        local tHp                                           = 95

        if CloudburstTotemTime == nil or cd.cloudburstTotem == 0 or not talent.cloudburstTotem then CloudburstTotemTime = 0 end

        if inCombat and not IsMounted() then
            if isChecked("Ancestral Guidance") and talent.ancestralGuidance and (not CloudburstTotemTime or GetTime() >= CloudburstTotemTime + 6) then
                if getLowAllies(getValue("Ancestral Guidance")) >= getValue("Ancestral Guidance Targets") then
                    if cast.ancestralGuidance() then return end
                end
            end
        end

        
        units.dyn8 = br.player.units(8)
        units.dyn40 = br.player.units(40)
        enemies.yards5 = br.player.enemies(5)
        enemies.yards8 = br.player.enemies(8)
        enemies.yards8t = br.player.enemies(8,br.player.units(8,true))
        enemies.yards10 = br.player.enemies(10)
        enemies.yards20 = br.player.enemies(20)
        enemies.yards30 = br.player.enemies(30)
        enemies.yards40 = br.player.enemies(40)

--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
        -- Dummy Test
            if isChecked("DPS Testing") then
                if ObjectExists("target") then
                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end -- End Dummy Test
        -- Ghost Wolf
            if isChecked("Ghost Wolf") then
                if ((#enemies.yards20 == 0 and not inCombat) or (#enemies.yards10 == 0 and inCombat)) and isMoving("player") and not buff.ghostWolf.exists() then
                    if cast.ghostWolf() then return end
                end
            end
        -- Purge
            if isChecked("Purge") and canDispel("target",spell.purge) and not isBoss() and ObjectExists("target") then
                if cast.purge() then return end
            end
        -- Water Walking
            if falling > 1.5 and buff.waterWalking.exists() then
                CancelUnitBuffID("player", spell.waterWalking)
            end
            if isChecked("Water Walking") and not inCombat and IsSwimming() then
                if cast.waterWalking() then return end
            end
        end -- End Action List - Extras
    -- Action List - Defensive
        local function actionList_Defensive()
            if useDefensive() then
            -- Healthstone
                if isChecked("Healthstone") and php <= getOptionValue("Healthstone")
                    and inCombat and  hasItem(5512)
                then
                    if canUse(5512) then
                        useItem(5512)
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
            -- Gift of the Naaru
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                    if castSpell("player",racial,false,false,false) then return end
                end
            -- Astral Shift
                if isChecked("Astral Shift") and php <= getOptionValue("Astral Shift") and inCombat then
                    if cast.astralShift() then return end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        -- Wind Shear
                        if isChecked("Wind Shear") then
                            if cast.windShear(thisUnit) then return end
                        end
        -- Lightning Surge Totem
                        if isChecked("Lightning Surge Totem") and cd.windShear > gcd then
                            if hasThreat(thisUnit) and not isMoving(thisUnit) and ttd(thisUnit) > 7 and lastSpell ~= spell.lightningSurgeTotem then
                                if cast.lightningSurgeTotem(thisUnit,"ground") then return end
                            end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
        -- Action List - Pre-Combat
        function actionList_PreCombat()
        -- Riptide
            if isChecked("Riptide") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Riptide") and buff.riptide.remain(br.friend[i].unit) <= 1 then
                        if cast.riptide(br.friend[i].unit) then return end     
                    end
                end
            end
        -- Healing Stream Totem
           if isChecked("Healing Stream Totem") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Healing Stream Totem") then
                        if cast.healingStreamTotem(br.friend[i].unit) then return end     
                    end
                end
            end
        -- Healing Surge
            if isChecked("Healing Surge") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Healing Surge") and (buff.tidalWaves.exists() or level < 34) then
                        if cast.healingSurge(br.friend[i].unit) then return end     
                    end
                end
            end
        -- Healing Wave
            if isChecked("Healing Wave") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Healing Wave") and (buff.tidalWaves.exists() or level < 34) then
                        if cast.healingWave(br.friend[i].unit) then return end     
                    end
                end
            end
        -- Chain Heal
            if isChecked("Chain Heal") and not moving and lastSpell ~= spell.chainHeal then
                if getLowAllies(getValue("Chain Heal")) >= getValue("Chain Heal Targets") then    
                    if cast.chainHeal() then return end    
                end
            end
        end  -- End Action List - Pre-Combat
        function actionList_Cooldowns()
            if useCDs() then
            -- Cloudburst Totem
                if isChecked("Cloudburst Totem") and talent.cloudburstTotem and not buff.cloudburstTotem.exists() then
                    if getLowAllies(getValue("Cloudburst Totem")) >= getValue("Cloudburst Totem Targets") then
                        if cast.cloudburstTotem() then 
                            CloudburstTotemTime = GetTime()
                            return
                        end
                    end
                end
            -- Ancestral Guidance
                if isChecked("Ancestral Guidance") and talent.ancestralGuidance and not talent.cloudburstTotem then
                    if getLowAllies(getValue("Ancestral Guidance")) >= getValue("Ancestral Guidance Targets") then
                        if cast.ancestralGuidance() then return end
                    end
                end
            -- Ascendance
                if isChecked("Ascendance") and talent.ascendance and not talent.cloudburstTotem then
                    if getLowAllies(getValue("Ascendance")) >= getValue("Ascendance Targets") then    
                        if cast.ascendance() then return end    
                    end
                end
            -- Healing Tide Totem
                if isChecked("Healing Tide Totem") and not talent.cloudburstTotem then
                    if getLowAllies(getValue("Healing Tide Totem")) >= getValue("Healing Tide Totem Targets") then    
                        if cast.healingTideTotem() then return end    
                    end
                end
            -- Trinkets
                if isChecked("Trinkets") then
                    if canUse(11) then
                        useItem(11)
                    end
                    if canUse(12) then
                        useItem(12)
                    end
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                    if castSpell("player",racial,false,false,false) then return end
                end
            end -- End useCooldowns check
        end -- End Action List - Cooldowns
        -- Cloudburst Totem
        function actionList_CBT()
        -- Ancestral Guidance
            if isChecked("Ancestral Guidance") and talent.ancestralGuidance and (not CloudburstTotemTime or GetTime() >= CloudburstTotemTime + 6) then
                if getLowAllies(getValue("Ancestral Guidance")) >= getValue("Ancestral Guidance Targets") then
                    if cast.ancestralGuidance() then return end
                end
            end
        -- Ascendance
            if isChecked("Ascendance") and talent.ascendance then
                if getLowAllies(getValue("Ascendance")) >= getValue("Ascendance Targets") then    
                    if cast.ascendance() then return end    
                end
            end
        -- Healing Tide Totem
            if isChecked("Healing Tide Totem") then
                if getLowAllies(getValue("Healing Tide Totem")) >= getValue("Healing Tide Totem Targets") then    
                    if cast.healingTideTotem() then return end    
                end
            end
        -- Healing Rain
            if isChecked("Healing Rain") and not moving and not buff.healingRain.exists() then
                if getLowAllies(getValue("Healing Rain")) >= getValue("Healing Rain Targets") then
                    if castGroundAtBestLocation(spell.healingRain, 20, 0, 40, 0, "heal") then return end    
                end
            end
        -- Riptide
            if isChecked("Riptide") then
                if not buff.tidalWaves.exists() and level >= 34 then
                    if cast.riptide(lowest) then return end
                end
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Riptide") and buff.riptide.remain(br.friend[i].unit) <= 1 then
                        if cast.riptide(br.friend[i].unit) then return end     
                    end
                end
            end
        -- Gift of the Queen
            if isChecked("Gift of the Queen") then
                if getLowAllies(getValue("Gift of the Queen")) >= getValue("Gift of the Queen Targets") then
                    if cast.giftOfTheQueen() then return end
                end
            end
        -- Healing Stream Totem
            if isChecked("Healing Stream Totem") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Healing Stream Totem") then
                        if cast.healingStreamTotem(br.friend[i].unit) then return end     
                    end
                end
            end
        -- Unleash Life
            if isChecked("Unleash Life") and talent.unleashLife then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Unleash Life") then
                        if cast.unleashLife() then return end     
                    end
                end
            end
        -- Healing Surge
            if isChecked("Healing Surge") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Healing Surge") and (buff.tidalWaves.exists() or level < 100) then
                        if cast.healingSurge(br.friend[i].unit) then return end     
                    end
                end
            end
        -- Healing Wave
            if isChecked("Healing Wave") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Healing Wave") and (buff.tidalWaves.exists() or level < 100) then
                        if cast.healingWave(br.friend[i].unit) then return end     
                    end
                end
            end
        end -- End Action List - Cloudburst Totem
        -- AOE Healing
        function actionList_AOEHealing()
        -- Chain Heal
            if isChecked("Chain Heal") and not moving and lastSpell ~= spell.chainHeal then
                if getLowAllies(getValue("Chain Heal")) >= getValue("Chain Heal Targets") then    
                    if cast.chainHeal() then return end    
                end
            end
        -- Gift of the Queen
            if isChecked("Gift of the Queen") and not talent.cloudburstTotem then
                if getLowAllies(getValue("Gift of the Queen")) >= getValue("Gift of the Queen Targets") then
                    if cast.giftOfTheQueen() then return end
                end
            end
        -- Wellspring
            if isChecked("Wellspring") then
                if getLowAllies(getValue("Wellspring")) >= getValue("Wellspring Targets") then
                    if talent.cloudburstTotem and buff.cloudburstTotem.exists() then
                        if cast.wellspring() then return end    
                    else
                        if cast.wellspring() then return end
                    end
                end
            end
        -- Healing Rain
            if isChecked("Healing Rain") and not moving and not buff.healingRain.exists() then
                if getLowAllies(getValue("Healing Rain")) >= getValue("Healing Rain Targets") then    
                    if castGroundAtBestLocation(spell.healingRain, 20, 0, 40, 0, "heal") then return end    
                end
            end
        end -- End Action List - AOEHealing
        -- Single Target
        function actionList_SingleTarget()
        -- Purify Spirit
            if br.player.mode.decurse == 1 then
                for i = 1, #br.friend do
                    for n = 1,40 do
                        local buff,_,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                        if buff then
                            if bufftype == "Curse" or bufftype == "Magic" then
                                if cast.purifySpirit(br.friend[i].unit) then return end
                            end
                        end
                    end
                end
            end
        -- Riptide
            if isChecked("Riptide") then
                if not buff.tidalWaves.exists() and level >= 34 then
                    if cast.riptide(lowest) then return end
                end
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Riptide") and buff.riptide.remain(br.friend[i].unit) <= 1 then
                        if cast.riptide(br.friend[i].unit) then return end     
                    end
                end
            end
        -- Earthen Shield Totem
            if talent.earthenShieldTotem and not moving then
                if cast.earthenShieldTotem() then return end
            end
        -- Healing Stream Totem
            if isChecked("Healing Stream Totem") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Healing Stream Totem") then
                        if cast.healingStreamTotem(br.friend[i].unit) then return end     
                    end
                end
            end
        -- Unleash Life
            if isChecked("Unleash Life") and talent.unleashLife then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Unleash Life") then
                        if cast.unleashLife() then return end     
                    end
                end
            end
        -- Healing Surge
            if isChecked("Healing Surge") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Healing Surge") and (buff.tidalWaves.exists() or level < 100) then
                        if cast.healingSurge(br.friend[i].unit) then return end     
                    end
                end
            end
        -- Healing Wave
            if isChecked("Healing Wave") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Healing Wave") and (buff.tidalWaves.exists() or level < 100) then
                        if cast.healingWave(br.friend[i].unit) then return end     
                    end
                end
            end
        -- Oh Shit! Healing Surge
            if isChecked("Healing Surge") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= 30 then
                        if cast.healingSurge(br.friend[i].unit) then return end     
                    end
                end
            end
        end -- End Action List Single Target
    -- Action List - DPS
        local function actionList_DPS()
        -- Lightning Surge Totem
            if isChecked("Lightning Surge Totem - HP") and php <= getOptionValue("Lightning Surge Totem - HP") and inCombat and #enemies.yards5 > 0 and lastSpell ~= spell.lightningSurgeTotem then
                if cast.lightningSurgeTotem("player","ground") then return end
            end
            if isChecked("Lightning Surge Totem - AoE") and #enemies.yards5 >= getOptionValue("Lightning Surge Totem - AoE") and inCombat and lastSpell ~= spell.lightningSurgeTotem then
                if cast.lightningSurgeTotem("best",nil,getOptionValue("Lightning Surge Totem - AoE"),8) then return end
            end
        -- Lava Burst - Lava Surge
            if buff.lavaSurge.exists() then
                if cast.lavaBurst() then return end
            end
        -- Flameshock
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards5[i]
                if not debuff.flameShock.exists(thisUnit) then
                    if cast.flameShock(thisUnit) then return end
                end
            end
        -- Lava Burst
            if debuff.flameShock.remain(units.dyn40) > getCastTime(spell.lavaBurst) or level < 20 then
                if cast.lavaBurst() then return end
            end
        -- Lightning Bolt
            if cast.lightningBolt() then return end
        end -- End Action List - DPS
-----------------
--- Rotations ---
-----------------
        -- Pause
        if pause() or mode.rotation == 4 then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and not IsMounted() and getBuffRemain("player", 192002 ) < 10 then
                actionList_Extras()
                if isChecked("OOC Healing") then
                    actionList_PreCombat()
                end
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat and not IsMounted() and getBuffRemain("player", 192002 ) < 10 then
                actionList_Defensive()
                actionList_Interrupts()
                actionList_Cooldowns()
                if talent.cloudburstTotem and buff.cloudburstTotem.exists() then
                    actionList_CBT()
                end
                actionList_AOEHealing()
                actionList_SingleTarget()
                if br.player.mode.dps == 1 then
                    actionList_DPS()
                end
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation 
local id = 264
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
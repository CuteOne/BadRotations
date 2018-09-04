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
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.chainLightning}
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

--------------
--- COLORS ---
--------------
    local colorBlue     = "|cff00CCFF"
    local colorGreen    = "|cff00FF00"
    local colorRed      = "|cffFF0000"
    local colorWhite    = "|cffFFFFFF"
    local colorGold     = "|cffFFDD11"

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
            br.ui:createDropdownWithout(section, "Trinkets", {"1st Only","2nd Only","Both","None"}, 4, "Select Trinket Usage.")
        -- The Deceiver's Grand Design
            if hasEquiped(147007) then
                br.ui:createCheckbox(section, "The Deceivers Grand Design")
            end
        -- Cloudburst Totem
            br.ui:createSpinner(section, "Cloudburst Totem",  90,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Cloudburst Totem Targets",  3,  0,  40,  1,  "Minimum Cloudburst Totem Targets")
        -- Ascendance
            br.ui:createSpinner(section,"Ascendance",  60,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Ascendance Targets",  3,  0,  40,  1,  "Minimum Ascendance Targets")
        -- Healing Tide Totem
            br.ui:createSpinner(section, "Healing Tide Totem",  50,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Healing Tide Totem Targets",  3,  0,  40,  1,  "Minimum Healing Tide Totem Targets")
        -- Ancestral Protection Totem
            br.ui:createSpinner(section, "Ancestral Protection Totem",  70,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Ancestral Protection Totem Targets",  3,  0,  40,  1,  "Minimum Ancestral Protection Totem Targets")
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
        -- Capacitor Totem
            br.ui:createSpinner(section, "Capacitor Totem - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Capacitor Totem - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
        -- Earthen Shield Totem
            br.ui:createSpinner(section, "Earthen Shield Totem",  95,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Earthen Shield Totem Targets",  1,  0,  40,  1,  "Minimum Earthen Shield Totem Targets")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Wind Shear
            br.ui:createCheckbox(section,"Wind Shear")
        -- Capacitor Totem
            br.ui:createCheckbox(section,"Capacitor Totem")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Healing Options
        section = br.ui:createSection(br.ui.window.profile, "Healing")
        -- Healing Rain
            br.ui:createSpinner(section, "Healing Rain",  80,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Healing Rain Targets",  2,  0,  40,  1,  "Minimum Healing Rain Targets")
            br.ui:createDropdown(section,"Healing Rain Key", br.dropOptions.Toggle, 6, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." Healing Rain manual usage.")
            br.ui:createCheckbox(section,"Healing Rain on Melee", "Cast on Melee only")
            br.ui:createCheckbox(section,"Healing Rain on CD")
        -- Spirit Link Totem
            br.ui:createSpinner(section, "Spirit Link Totem",  50,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Spirit Link Totem Targets",  3,  0,  40,  1,  "Minimum Spirit Link Totem Targets")
            br.ui:createDropdown(section,"Spirit Link Totem Key", br.dropOptions.Toggle, 6, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." Spirit Link Totem manual usage.")
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
        local drinking                                      = UnitBuff("player",192002) ~= nil or UnitBuff("player",167152) ~= nil
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
        local power, powmax, powgen                         = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local tanks                                         = getTanksTable()
        local wolf                                          = br.player.buff.ghostWolf.exists()
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units
        local lowestTank                                    = {}    --Tank
        local enemies                                       = br.player.enemies
        local friends                                       = friends or {}

        if CloudburstTotemTime == nil or cd.cloudburstTotem.remain() == 0 or not talent.cloudburstTotem then CloudburstTotemTime = 0 end

    -- Cloudburst Totem
        if isChecked("Cloudburst Totem") and talent.cloudburstTotem and not buff.cloudburstTotem.exists() then
            if getLowAllies(getValue("Cloudburst Totem")) >= getValue("Cloudburst Totem Targets") then
                if cast.cloudburstTotem() then
                    ChatOverlay(colorGreen.."Cloudburst Totem!")
                    CloudburstTotemTime = GetTime()
                    return
                end
            end
        end

        
        units.get(8)
        units.get(40)
        enemies.get(5)
        enemies.get(8)
        enemies.get(8,"target")
        enemies.get(10)
        enemies.get(20)
        enemies.get(30)
        enemies.get(40)
        friends.yards8 = getAllies("player",8)
        friends.yards25 = getAllies("player",25)
        friends.yards40 = getAllies("player",40)

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
        -- Ghost Wolf
            if isChecked("Ghost Wolf") then
                if ((#enemies.yards20 == 0 and not inCombat) or (#enemies.yards10 == 0 and inCombat)) and isMoving("player") and not buff.ghostWolf.exists() then
                    if cast.ghostWolf() then return end
                end
            end
        -- Purge
            if isChecked("Purge") and canDispel("target",spell.purge) and not isBoss() and GetObjectExists("target") then
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
            if isChecked("Chain Heal") then
                if castWiseAoEHeal(br.friend,spell.chainHeal,40,getValue("Chain Heal"),getValue("Chain Heal Targets"),5,false,true) then return end
            end
        -- Healing Rain
            if not moving then
                if (SpecificToggle("Healing Rain Key") and not GetCurrentKeyBoardFocus()) then
                    if CastSpellByName(GetSpellInfo(spell.healingRain),"cursor") then return end 
                end
            end
        -- Spirit Link Totem
            if not moving then
                if (SpecificToggle("Spirit Link Totem Key") and not GetCurrentKeyBoardFocus()) then
                    if CastSpellByName(GetSpellInfo(spell.spiritLinkTotem),"cursor") then return end 
                end
            end
        end  -- End Action List - Pre-Combat
        function actionList_Cooldowns()
            if useCDs() then
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
            -- Ancestral Protection Totem
                if castWiseAoEHeal(br.friend,spell.ancestralProtectionTotem,20,getValue("Ancestral Protection Totem"),getValue("Ancestral Protection Totem Targets"),10,false,false) then return end
            -- Trinkets
                if (getOptionValue("Trinkets") == 1 or getOptionValue("Trinkets") == 3) and canUse(13) then
                    useItem(13)
                end
                if (getOptionValue("Trinkets") == 2 or getOptionValue("Trinkets") == 3) and canUse(14) then
                    useItem(14)
                end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                    if castSpell("player",racial,false,false,false) then return end
                end
            end -- End useCooldowns check
        end -- End Action List - Cooldowns
        -- Cloudburst Totem
        function actionList_CBT()
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
            if not moving then
                if (SpecificToggle("Healing Rain Key") and not GetCurrentKeyBoardFocus()) then
                    if CastSpellByName(GetSpellInfo(spell.healingRain),"cursor") then return end 
                end
                if isChecked("Healing Rain") and not buff.healingRain.exists() then
                    -- get melee players
                    for i=1, #tanks do
                        -- get the tank's target
                        local tankTarget = UnitTarget(tanks[i].unit)
                        if tankTarget ~= nil then
                            -- get players in melee range of tank's target
                            local meleeFriends = getAllies(tankTarget,5)
                            -- get the best ground circle to encompass the most of them
                            local loc = nil
                            if isChecked("Healing Rain on CD") and #meleeFriends >= getValue("Healing Rain Targets") then
                                loc = getBestGroundCircleLocation(meleeFriends,getValue("Healing Rain Targets"),6,10)
                            else
                                local meleeHurt = {}
                                for j=1, #meleeFriends do
                                    if meleeFriends[i].hp < getValue("Healing Rain") then
                                        tinsert(meleeHurt,meleeFriends[i])
                                    end
                                end
                                if #meleeHurt >= getValue("Healing Rain Targets") then
                                    loc = getBestGroundCircleLocation(meleeHurt,getValue("Healing Rain Targets"),6,10)
                                end
                            end
                            if loc ~= nil then
                                if castGroundAtLocation(loc, spell.healingRain) then return true end
                            end
                        end
                    end
                    --if castWiseAoEHeal(br.friend,spell.healingRain,12,100,3,6,false,true) then return end
                    --castGroundAtBestLocation(spellID, radius, minUnits, maxRange, minRange, spellType)
                    --if castGroundAtBestLocation(spell.healingRain,10,getValue("Healing Rain Targets"),40,0,"heal") then return end
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
        -- Healing Stream Totem
            if isChecked("Healing Stream Totem") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Healing Stream Totem") then
                        if cast.healingStreamTotem(br.friend[i].unit) then return end     
                    end
                end
            end
        -- Unleash Life
            if isChecked("Unleash Life") and talent.unleashLife and not hasEquiped(137051) then
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
            if isChecked("Chain Heal") then
                if talent.unleashLife and talent.highTide then
                    if cast.unleashLife(lowest) then return end
                    if buff.unleashLife.remain() > 2 then
                        if castWiseAoEHeal(br.friend,spell.chainHeal,40,getValue("Chain Heal"),(getValue("Chain Heal Targets") + 1),5,false,true) then return end
                    end
                elseif talent.highTide then
                    if castWiseAoEHeal(br.friend,spell.chainHeal,40,getValue("Chain Heal"),(getValue("Chain Heal Targets") + 1),5,false,true) then return end
                else
                    if castWiseAoEHeal(br.friend,spell.chainHeal,40,getValue("Chain Heal"),getValue("Chain Heal Targets"),5,false,true) then return end
                end
            end
        -- Wellspring
            if isChecked("Wellspring") then
                if talent.cloudburstTotem and buff.cloudburstTotem.exists() then
                    if castWiseAoEHeal(br.friend,spell.wellspring,20,getValue("Wellspring"),getValue("Wellspring Targets"),6,true,true) then return end
                else
                    if castWiseAoEHeal(br.friend,spell.wellspring,20,getValue("Wellspring"),getValue("Wellspring Targets"),6,true,true) then return end
                end
            end
        -- Healing Rain
            if not moving then
                if (SpecificToggle("Healing Rain Key") and not GetCurrentKeyBoardFocus()) then
                    if CastSpellByName(GetSpellInfo(spell.healingRain),"cursor") then return end 
                end
                if isChecked("Healing Rain") and not buff.healingRain.exists() then
                    -- get melee players
                    for i=1, #tanks do
                        -- get the tank's target
                        local tankTarget = UnitTarget(tanks[i].unit)
                        if tankTarget ~= nil then
                            -- get players in melee range of tank's target
                            local meleeFriends = getAllies(tankTarget,5)
                            -- get the best ground circle to encompass the most of them
                            local loc = nil
                            if isChecked("Healing Rain on CD") and #meleeFriends >= getValue("Healing Rain Targets") then
                                loc = getBestGroundCircleLocation(meleeFriends,getValue("Healing Rain Targets"),6,10)
                            else
                                local meleeHurt = {}
                                for j=1, #meleeFriends do
                                    if meleeFriends[j].hp < getValue("Healing Rain") then
                                        tinsert(meleeHurt,meleeFriends[j])
                                    end
                                end
                                if #meleeHurt >= getValue("Healing Rain Targets") then
                                    loc = getBestGroundCircleLocation(meleeHurt,getValue("Healing Rain Targets"),6,10)
                                end
                            end
                            if loc ~= nil then
                                if castGroundAtLocation(loc, spell.healingRain) then return true end
                            end
                        end
                    end
                    --if castWiseAoEHeal(br.friend,spell.healingRain,12,100,3,6,false,true) then return end
                    --castGroundAtBestLocation(spellID, radius, minUnits, maxRange, minRange, spellType)
                    --if castGroundAtBestLocation(spell.healingRain,10,getValue("Healing Rain Targets"),40,0,"heal") then return end
                end
            end
        end -- End Action List - AOEHealing
        -- Single Target
        function actionList_SingleTarget()
        -- The Deceiver's Grand Design
            if hasEquiped(147007) and canUse(147007) then
                if isChecked("The Deceivers Grand Design") then
                    local localizedName = select(1,GetItemInfo(147007))
                    for i=1, #tanks do
                        thisTank = tanks[i]
                        if UnitInRange(thisTank.unit) and not buff.guidingHand.exists(thisTank.unit) then
                            UseItemByName(localizedName, thisTank.unit)
                        end
                    end
                    if #tanks == 0 then
                        for i = 1, #friends.yards40 do
                            if not buff.guidingHand.exists(friends.yards40[i].unit) then
                                if cast.purify(friends.yards40[i].unit) then return true end
                            end
                        end
                    end
                end
            end
        -- Purify Spirit
           if br.player.mode.decurse == 1 then
                for i = 1, #friends.yards40 do
                    if canDispel(br.friend[i].unit,spell.purifySpirit) then
                        if cast.purifySpirit(br.friend[i].unit) then return end
                    end
                end
            end
        -- Tidal Waves Proc Handling
            if buff.tidalWaves.stack() == 2 or level < 100 then
                if isChecked("Healing Surge") then
                    for i = 1, #br.friend do                           
                        if br.friend[i].hp <= getValue("Healing Surge") then
                            if cast.healingSurge(br.friend[i].unit) then return end     
                        end
                    end
                end
                if isChecked("Healing Wave") then
                    for i = 1, #br.friend do                           
                        if br.friend[i].hp <= getValue("Healing Wave") then
                            if cast.healingWave(br.friend[i].unit) then return end     
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
            if isChecked("Earthen Shield Totem") and talent.earthenShieldTotem then
                if castWiseAoEHeal(br.friend,spell.earthenShieldTotem,20,getValue("Earthen Shield Totem"),getValue("Earthen Shield Totem Targets"),6,false,true) then return end
            end
        -- Healing Stream Totem
            if isChecked("Healing Stream Totem") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Healing Stream Totem") then
                        if not talent.echoOfTheElements then
                            if cast.healingStreamTotem(br.friend[i].unit) then return end
                        elseif talent.echoOfTheElements and (not HSTime or GetTime() - HSTime > 15) then
                            if cast.healingStreamTotem(br.friend[i].unit) then
                            HSTime = GetTime()
                            return true end
                        end 
                    end
                end
            end
        -- Unleash Life
            if isChecked("Unleash Life") and talent.unleashLife and not hasEquiped(137051) then
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
        -- Healing Rain
            if not moving then
                if (SpecificToggle("Healing Rain Key") and not GetCurrentKeyBoardFocus()) then
                    if CastSpellByName(GetSpellInfo(spell.healingRain),"cursor") then return end 
                end
                if isChecked("Healing Rain") and not buff.healingRain.exists() then
                    -- castWiseAoEHeal(unitTable,spell,radius,health,minCount,maxCount,facingCheck,movementCheck)
                    if castWiseAoEHeal(br.friend,spell.healingRain,12,getValue("Healing Rain"),getValue("Healing Rain Targets"),6,false,true) then return end
                end
            end
        -- Spirit Link Totem
            if isChecked("Spirit Link Totem") and not moving then
                if (SpecificToggle("Spirit Link Totem Key") and not GetCurrentKeyBoardFocus()) then
                    if CastSpellByName(GetSpellInfo(spell.spiritLinkTotem),"cursor") then return end 
                end
                if castWiseAoEHeal(br.friend,spell.spiritLinkTotem,12,getValue("Spirit Link Totem"),getValue("Spirit Link Totem Targets"),40,false,true) then return end
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
                    if br.friend[i].hp <= 40 then
                        if cast.healingSurge(br.friend[i].unit) then return end     
                    end
                end
            end
            -- Ephemeral Paradox trinket
            if hasEquiped(140805) and getBuffRemain("player", 225771) > 2 then
                if cast.healingWave(lowest.unit) then return end
            end
        end -- End Action List Single Target
    -- Action List - DPS
        local function actionList_DPS()
        -- Capacitor Totem
            if isChecked("Capacitor Totem - HP") and php <= getOptionValue("Capacitor Totem - HP") and inCombat and #enemies.yards5 > 0 and lastSpell ~= spell.capacitorTotem then
                if cast.capacitorTotem("player","ground") then return end
            end
            if isChecked("Capacitor Totem - AoE") and #enemies.yards5 >= getOptionValue("Capacitor Totem - AoE") and inCombat and lastSpell ~= spell.capacitorTotem then
                if cast.capacitorTotem("best",nil,getOptionValue("Capacitor Totem - AoE"),8) then return end
            end
        -- Lava Burst - Lava Surge
            if buff.lavaSurge.exists() then
                for i = 1, #enemies.yards40 do        
                    local thisUnit = enemies.yards40[i]
                    if debuff.flameShock.exists(thisUnit) and isValidUnit(thisUnit) then
                        if cast.lavaBurst(thisUnit) then return end
                    end
                end
            end
        -- Flameshock
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.flameShock.exists(thisUnit) and isValidUnit(thisUnit) then
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
            if not inCombat and not IsMounted() and not drinking then
                actionList_Extras()
                if isChecked("OOC Healing") then
                    actionList_PreCombat()
                end
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat and not IsMounted() and not drinking then
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
--local id = 264
local id = 264
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
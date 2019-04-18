local rotationName = "Aura" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.lunarStrike },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.lunarStrike}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.celestialAlignment },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.celestialAlignment },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.celestialAlignment }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.barkskin },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.barkskin }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.solarBeam },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.solarBeam }
    };
    CreateButton("Interrupt",4,0)
    -- FoN Button
    ForceofNatureModes = {
        [1] = { mode = "On", value = 1 , overlay = "Force of Nature Enabled", tip = "Will Use Force of Nature", highlight = 1, icon = br.player.spell.forceOfNature },
        [2] = { mode = "Off", value = 2 , overlay = "Force of Nature Disabled", tip = "Will Not Use Force of Nature", highlight = 0, icon = br.player.spell.forceOfNature }
    };
    CreateButton("ForceofNature",5,0)
    -- Starfall Button
    StarfallModes = {
        [1] = { mode = "On", value = 1 , overlay = "Starfall Enabled", tip = "Will Use Starfall in AoE", highlight = 1, icon = br.player.spell.starfall },
        [2] = { mode = "Off", value = 2 , overlay = "Starfall Disabled", tip = "Will Not Use Starfall", highlight = 0, icon = br.player.spell.starfall }
    };
    CreateButton("Starfall",6,0)
    -- Movement Button
    MovementModes = {
        [1] = { mode = "On", value = 1 , overlay = "Movement Enabled", tip = "Will Use Starfall/Starsurge when moving", highlight = 1, icon = br.player.spell.dash },
        [2] = { mode = "Off", value = 2 , overlay = "Movement Disabled", tip = "Will Not Use Starfall/Starsurge when moving", highlight = 0, icon = br.player.spell.dash }
    };
    CreateButton("Movement",7,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
		    br.ui:createSpinner(section, "Pre-Pull Timer",  2.5,  0,  10,  0.5,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            br.ui:createCheckbox(section, "Revive")
            br.ui:createDropdownWithout(section, "Revive - Target", {"|cff00FF00Target","|cffFF0000Mouseover","|cffFFBB00Auto"}, 1, "|cffFFFFFFTarget to cast on")
            br.ui:createCheckbox(section, "Opener")
            br.ui:createDropdown(section, "Opener Reset Key", br.dropOptions.Toggle, 6)
            br.ui:createSpinner(section, "OOC Regrowth", 50, 1, 100, 5, "Set health to heal while out of combat. Min: 1 / Max: 100 / Interval: 5")
            br.ui:createSpinner(section, "OOC Wild Growth", 50, 1, 100, 5, "Set health to heal while out of combat. Min: 1 / Max: 100 / Interval: 5")
            br.ui:createCheckbox(section, "Auto Shapeshifts")
            br.ui:createCheckbox(section, "Auto Soothe")
            br.ui:createSpinnerWithout(section, "Starsurge/Starfall Dump", 40,40,100,5, "Set minimum AP value for Starsurge use. Min: 40 / Max: 100 / Interval: 5")
            br.ui:createCheckbox(section, "Auto Engage On Target", "Check this to cast moonfire on target OOC to engage combat")
            br.ui:createDropdown(section, "Rebirth", {"|cff00FF00Tanks","|cffFFFF00Healers","|cffFFFFFFTanks and Healers","|cffFF0000Mouseover Target","|cffFFFFFFAny"}, 3, "","|ccfFFFFFFTarget to Cast On")
            br.ui:createDropdown(section, "Remove Corruption", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFFFFFFPlayer and Target","|cffFF0000Mouseover Target","|cffFFFFFFAny"}, 3, "","|ccfFFFFFFTarget to Cast On")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            br.ui:createCheckbox(section, "Lively Spirit Innervate", "Use Innervate if you have Lively Spirit traits for DPS buff")
            br.ui:createCheckbox(section, "Int Pot", "Use Int Pot when Incarnation/Celestial Alignment is up")
            br.ui:createCheckbox(section, "Racial")
            br.ui:createCheckbox(section, "Trinkets")
            br.ui:createCheckbox(section, "Warrior Of Elune")
            br.ui:createCheckbox(section, "Fury Of Elune")
            br.ui:createCheckbox(section, "Incarnation/Celestial Alignment")
        br.ui:checkSectionState(section)
        -------------------------
        ---  TARGET OPTIONS   ---  -- Define Target Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Targets")
            br.ui:createSpinnerWithout(section, "Max Stellar Flare Targets", 2, 1, 10, 1, "|cff0070deSet to maximum number of targets to dot with Stellar Flare. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinnerWithout(section, "Max Moonfire Targets", 2, 1, 10, 1, "|cff0070deSet to maximum number of targets to dot with Moonfire. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinnerWithout(section, "Max Sunfire Targets", 2, 1, 10, 1, "|cff0070deSet to maximum number of targets to dot with Sunfire. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinnerWithout(section, "Lunar Strike Filler Targets", 2, 1, 10, 1, "|cff0070deSet to minimum number of targets to use Lunar Strike as filler spell. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinnerWithout(section, "Starfall Targets", 2, 1, 10, 1, "|cff0070deSet to minimum number of targets to use Starfall. Min: 1 / Max: 10 / Interval: 1" )
        --    br.ui:createSpinnerWithout(section, "Fury of Elune Targets", 2, 1, 10, 1, "|cff0070deSet to minimum number of targets to use Fury of Elune. Min: 1 / Max: 10 / Interval: 1" )
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            br.ui:createSpinner(section, "Potion/Healthstone",  20,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinner(section, "Renewal",  25,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinner(section, "Barkskin",  60,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinner(section, "Regrowth",  30,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinner(section, "Swiftmend",  15,  0,  100,  5,  "Health Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            br.ui:createCheckbox(section, "Solar Beam")
            br.ui:createCheckbox(section, "Mighty Bash")
            br.ui:createCheckbox(section, "Typhoon")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")    
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Define Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)   
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
    if br.timer:useTimer("debugFury", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("ForceofNature",0.25)
        UpdateToggle("Starfall",0.25)
        UpdateToggle("Movement",0.25)
        br.player.mode.forceOfNature = br.data.settings[br.selectedSpec].toggles["ForceofNature"]
        br.player.mode.starfall = br.data.settings[br.selectedSpec].toggles["Starfall"]
        br.player.mode.movement = br.data.settings[br.selectedSpec].toggles["Movement"]
--------------
--- Locals ---
--------------
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local chicken                                       = br.player.buff.moonkinForm.exists()
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadtar, playertar                            = UnitIsDeadOrGhost("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcdMax
        local hastar                                        = GetObjectExists("target")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mana                                          = br.player.power.mana.amount()
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk        
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power.astralPower.amount(), br.player.powerMax, br.player.powerRegen
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local ttm                                           = br.player.timeToMax
        local traits                                        = br.player.traits
        local travel, flight, cat                           = br.player.buff.travelForm.exists(), br.player.buff.flightForm.exists(), br.player.buff.catForm.exists()
        local units                                         = br.player.units
        
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        local starfallTargets = getOptionValue("Starfall Targets")
        if talent.twinMoons and talent.starLord then
            starfallTargets = starfallTargets + 1
        end
        if not talent.starLord and talent.stellarDrift then
            starfallTargets = starfallTargets - 1
        end

        local moon
        if cast.last.newMoon(1) then
            moon = 20
        elseif cast.last.halfMoon(1) then
            moon = 40
        elseif cast.last.fullMoon(1) then 
            moon = 10
        end

        ABOpener = ABOpener or false
        SW1 = SW1 or false
        SW2 = SW2 or false
        MF = MF or false
        SF = SF or false
        StF = StF or false
        CA = CA or false

        if (not inCombat and not GetObjectExists("target")) or (isChecked("Opener Reset Key") and SpecificToggle("Opener Reset Key")) then
          --  br.addonDebug("Opener Reset")
            ABOpener = false
            SW1 = false
            SW2 = false
            MF = false
            SF = false
            StF = false
            CA = false
        end

        enemies.get(8,"target")  --enemies.yards8t
        enemies.get(15,"target") --enemies.yards15t
        enemies.get(45)          --enemies.yards45

--------------------
--- Action Lists ---
--------------------
        local function actionList_PreCombat()
            -- Pre-Pull Timer
            if isChecked("Pre-Pull Timer") then
                if PullTimerRemain() <= getOptionValue("Pre-Pull Timer") then
                    if cast.solarWrath() then return true end
                end
            end
            if isChecked("Auto Engage On Target") then
                if cast.moonfire() then return true end
            end
        end
        local function actionList_Extras()
            --Resurrection
            if isChecked("Revive") and not inCombat and not isMoving("player") then
                if getOptionValue("Revive - Target") == 1
                    and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player")
                then
                    if cast.revive("target","dead") then return true end
                end
                if getOptionValue("Revive - Target") == 2
                    and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player")
                then
                    if cast.revive("mouseover","dead") then return true end
                end
                if getOptionValue("Revive - Target") == 3 then
                    for i =1, #br.friend do
                        if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and lastSpell ~= spell.revive then
                            if cast.revive(br.friend[i].unit) then return true end
                        end
                    end
                end
            end
            -- Wild Growth
            if isChecked("OOC Wild Growth") and not isMoving("player") and php <= getValue("OOC Wild Growth") then
                if cast.wildGrowth() then return true end
            end
            -- Regrowth
            if isChecked("OOC Regrowth") and not isMoving("player") and php <= getValue("OOC Regrowth") then
                if cast.regrowth("player") then return true end
            end
            -- Shapeshift Form Management
			if isChecked("Auto Shapeshifts") then --and br.timer:useTimer("debugShapeshift", 0.25) then
            -- Flight Form
                if not inCombat and canFly() and not swimming and br.fallDist > 90--[[falling > getOptionValue("Fall Timer")]] and level>=58 and not buff.prowl.exists() then
                    if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                        -- CancelShapeshiftForm()
                        RunMacroText("/CancelForm")
                        CastSpellByID(783,"player") return true 
                    else
                        CastSpellByID(783,"player") return true 
                    end
                end
            -- Aquatic Form
                if (not inCombat --[[or getDistance("target") >= 10--]]) and swimming and not travel and not buff.prowl.exists() and isMoving("player") then
                        if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                        -- CancelShapeshiftForm()
                        RunMacroText("/CancelForm")
                        CastSpellByID(783,"player") return true 
                    else
                        CastSpellByID(783,"player") return true 
                    end
                end
            -- Travel Form
                if not inCombat and not swimming and level >=58 and not buff.prowl.exists() and not travel and not IsIndoors() and IsMovingTime(1) then
                    if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                        RunMacroText("/CancelForm")
                        CastSpellByID(783,"player") return true 
                    else
                        CastSpellByID(783,"player") return true 
                    end
                end
            -- Cat Form
                if not cat and not IsMounted() and not flying and IsIndoors() then
                    -- Cat Form when not swimming or flying or stag and not in combat
                    if moving and not swimming and not flying and not travel then
                        if cast.catForm("player") then return true end
                    end
                    -- Cat Form - Less Fall Damage
                    if (not canFly() or inCombat or level < 58) and (not swimming or (not moving and swimming and #enemies.yards5 > 0)) and br.fallDist > 90 then --falling > getOptionValue("Fall Timer") then
                        if cast.catForm("player") then return true end
                    end
                end
            end -- End Shapeshift Form Management
        end

        local function actionList_Defensive()
            --Potion or Stone
            if isChecked("Potion/Healthstone") and php <= getValue("Potion/Healthstone") then
                if canUse(5512) then
                    useItem(5512)
                elseif canUse(getHealthPot()) then
                    useItem(getHealthPot())
                end
            end
            -- Renewal
            if isChecked("Renewal") and php <= getValue("Renewal") then
                if cast.renewal("player") then return end
            end
            -- Barkskin
            if isChecked("Barkskin") and php <= getValue("Barkskin") then
                if cast.barkskin() then return end
            end
             -- Swiftmend
             if talent.restorationAffinity and isChecked("Swiftmend") and php <= getValue("Swiftmend") and charges.swiftmend.count() >= 1 then
                if cast.swiftmend("player") then return true end
            end
            -- Regrowth
            if isChecked("Regrowth") and not moving and php <= getValue("Regrowth") then
                if cast.regrowth("player") then return true end
            end
            -- Rebirth
            if isChecked("Rebirth") and cd.rebirth.remains() <= gcd and not isMoving("player") then
                if getOptionValue("Rebirth") == 1 then
                    local tanks = getTanksTable()
                    for i = 1, #tanks do
                        local thisUnit = tanks[i].unit
                        if UnitIsDeadOrGhost(thisUnit) and UnitIsPlayer(thisUnit) then
                            if cast.rebirth(thisUnit,"dead") then return true end
                        end
                    end
                elseif getOptionValue("Rebirth") == 2 then
                    for i = 1, #br.friend do
                        local thisUnit = br.friend[i].unit
                        if UnitIsDeadOrGhost(thisUnit) and UnitGroupRolesAssigned(thisUnit) == "HEALER" and UnitIsPlayer(thisUnit) then
                            if cast.rebirth(thisUnit,"dead") then return true end
                        end
                    end
                elseif getOptionValue("Rebirth") == 3 then
                    for i = 1, #br.friend do
                        local thisUnit = br.friend[i].unit
                        if UnitIsDeadOrGhost(thisUnit) and (UnitGroupRolesAssigned(thisUnit) == "TANK" or UnitGroupRolesAssigned(thisUnit) == "HEALER") and UnitIsPlayer(thisUnit) then
                            if cast.rebirth(thisUnit,"dead") then return true end
                        end
                    end
                elseif getOptionValue("Rebirth") == 4 then
                    if GetUnitExists("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player") then
                        if cast.rebirth("mouseover","dead") then return true end
                    end
                elseif getOptionValue("Rebirth") == 5 then
                    for i = 1, #br.friend do
                        local thisUnit = br.friend[i].unit
                        if UnitIsDeadOrGhost(thisUnit) and UnitIsPlayer(thisUnit) then
                            if cast.rebirth(thisUnit,"dead") then return true end
                        end
                    end
                end
            end

            -- Remove Corruption
            if isChecked("Remove Corruption") then
                if getOptionValue("Remove Corruption")==1 then
                    if canDispel("player",spell.removeCorruption) then
                        if cast.removeCorruption("player") then return true end
                    end
                elseif getOptionValue("Remove Corruption")==2 then
                        if canDispel("target",spell.removeCorruption) then
                            if cast.removeCorruption("target") then return true end
                        end
                elseif getOptionValue("Remove Corruption")==3 then
                        if canDispel("player",spell.removeCorruption) then
                            if cast.removeCorruption("player") then return true end
                        elseif canDispel("target",spell.removeCorruption) then
                            if cast.removeCorruption("target") then return true end
                        end
                elseif getOptionValue("Remove Corruption")==4 then
                    if canDispel("mouseover",spell.removeCorruption) then
                        if cast.removeCorruption("mouseover") then return true end
                    end
                elseif getOptionValue("Remove Corruption")==5 then
                    for i = 1, #br.friend do
                        if canDispel(br.friend[i].unit,spell.removeCorruption) then
                            if cast.removeCorruption(br.friend[i].unit) then return true end
                        end
                    end
                end
            end
        end

        local function actionList_Interrupts()
            if useInterrupts() then
                for i = 1, #enemies.yards45 do
                    local thisUnit = enemies.yards45[i]
                    if canInterrupt(thisUnit,getValue("InterruptAt")) then
                        -- Solar Beam
                        if isChecked("Solar Beam") then
                            if cast.solarBeam(thisUnit) then return end
                        end
                        -- Typhoon
                        if isChecked("Typhoon") and talent.typhoon and getDistance(thisUnit) <= 15 then
                            if cast.typhoon() then return end
                        end
                        -- Mighty Bash
                        if isChecked("Mighty Bash") and talent.mightyBash and getDistance(thisUnit) <= 10 then
                            if cast.mightyBash(thisUnit) then return true end
                        end
                    end
                end
            end
        
            if isChecked("Auto Soothe") then
                for i=1, #enemies.yards45 do
                local thisUnit = enemies.yards45[i]
                    if canDispel(thisUnit, spell.soothe) then
                        if cast.soothe(thisUnit) then return true end
                    end
                end
            end
        end

        local function actionList_AMR()
            -- Innverate
            if useCDs() and isChecked("Lively Spirit Innervate") and traits.livelySpirit.active then
                if cast.innervate() then return true end
            end
            --Potion (To Do)
            if isChecked("Int Pot") and canUse(163222) and not solo and useCDs() and (buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) then
                useItem(163222)
            end
            -- Racial
            if useCDs() and isChecked("Racial") and (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") or (mana >= 30 and race == "BloodElf")
            then
                if race == "LightforgedDraenei" then
                    if cast.racial("target","ground") then return true end
                else
                    if cast.racial("player") then return true end
                end
            end
            -- Trinkets
            if useCDs() and isChecked("Trinkets") and (buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) then
                if canTrinket(13) then
                    useItem(13)
                end
                if canTrinket(14) then
                    useItem(14)
                end
            end
            -- Warrior of Elune
            if useCDs() and isChecked("Warrior Of Elune") and talent.warriorOfElune and not buff.warriorOfElune.exists() then
                if cast.warriorOfElune() then return true end
            end
            -- Stellar Flare
            if talent.stellarFlare and debuff.stellarFlare.count() < getOptionValue("Max Stellar Flare Targets") and not isMoving("player") then
                if GetUnitExists("target") and not debuff.stellarFlare.exists("target") or debuff.stellarFlare.remains("target") < 3 then
                    if cast.stellarFlare("target") then return true end
                end
                for i = 1, #enemies.yards45 do
                    local thisUnit = enemies.yards45[i]
                    if not debuff.stellarFlare.exists(thisUnit) or debuff.stellarFlare.remains(thisUnit) < 3 then
                        if cast.stellarFlare(thisUnit) then return true end
                    end
                end
            end
            -- Moonfire
            if debuff.moonfire.count() < getOptionValue("Max Moonfire Targets") then
                if GetUnitExists("target") and not debuff.moonfire.exists("target") or debuff.moonfire.remains("target") < 3 then
                    if cast.moonfire("target") then return true end
                end
                for i = 1, #enemies.yards45 do
                    local thisUnit = enemies.yards45[i]
                    if not debuff.moonfire.exists(thisUnit) or debuff.moonfire.remains(thisUnit) < 3 then
                        if cast.moonfire(thisUnit) then return true end
                    end
                end
            end
            -- Sunfire
            if debuff.sunfire.count() < getOptionValue("Max Sunfire Targets") then
                if GetUnitExists("target") and not debuff.sunfire.exists("target") or debuff.sunfire.remains("target") < 3 then
                    if cast.sunfire("target") then return true end
                end
                for i = 1, #enemies.yards45 do
                    local thisUnit = enemies.yards45[i]
                    if not debuff.sunfire.exists(thisUnit) or debuff.sunfire.remains(thisUnit) < 3 then
                        if cast.sunfire(thisUnit) then return true end
                    end
                end
            end
            -- Force Of Nature
            if talent.forceOfNature and br.player.power.astralPower.deficit() > 20 and mode.forceOfNature == 1 then
                if cast.forceOfNature("best",nil,1,15,true) then return true end
            end
            -- Fury of Elune
            if talent.furyOfElune and isChecked("Fury Of Elune") and (buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists() or cd.celestialAlignment.remain() > 30 or cd.incarnationChoseOfElune.remain() > 30) then
                if cast.furyOfElune() then return true end
            end
            -- Incarnation
            if talent.incarnationChoseOfElune and useCDs() and isChecked("Incarnation/Celestial Alignment") and power >= 40 and ttd("target") >= 30 then
                if cast.incarnationChoseOfElune("player") then return true end
            end
            -- Celestial Alignment
            if not talent.incarnationChoseOfElune and useCDs() and isChecked("Incarnation/Celestial Alignment")  and power >= 40 and ttd("target") >= 20 then
                if cast.celestialAlignment("player") then return true end
            end
            --Starfall
            if #enemies.yards15t >= starfallTargets and (power >= getOptionValue("Starsurge/Starfall Dump") or (isMoving("player") and mode.movement == 1)) then
                if mode.starfall == 1 then
                    if createCastFunction("best",false,1,15,spell.starfall,nil,true) then return true end
                elseif mode.starfall == 0 then
                    if cast.starsurge() then return true end
                end
            end
            -- Solar Wrath
            if traits.streakingStars.active and not isMoving("player") then
                if not cast.last.solarWrath(1) and (buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and br.player.power.astralPower.deficit() > 20 then
                    if cast.solarWrath() then return true end
                end
            end
            -- Starsurge
            if buff.lunarEmpowerment.stack() < 3 and buff.solarEmpowerment.stack() < 3 and #enemies.yards15t < starfallTargets and (power >= getOptionValue("Starsurge/Starfall Dump") or (isMoving("player") and mode.movement == 1)) then
                if talent.starLord then
                    if not buff.starLord.exists() or buff.starLord.remains > 3 then
                        if cast.starsurge() then return true end
                    end
                else
                    if cast.starsurge() then return true end
                end
            end
            -- Refresh Sunfire
            if debuff.sunfire.count() <= getOptionValue("Max Sunfire Targets") then
                if GetUnitExists("target") and not debuff.sunfire.exists("target") or debuff.sunfire.remains("target") < 7.2 then
                    if cast.sunfire("target") then return true end
                end
                for i = 1, #enemies.yards45 do
                    local thisUnit = enemies.yards45[i]
                    if debuff.sunfire.exists(thisUnit) and debuff.sunfire.remains(thisUnit) < 7.2 then
                        if cast.sunfire(thisUnit) then return true end
                    end
                end
            end
            -- Refresh Stellar Flare
            if debuff.stellarFlare.count() <= getOptionValue("Max Stellar Flare Targets") and not isMoving("player") then
                if GetUnitExists("target") and not debuff.stellarFlare.exists("target") or debuff.stellarFlare.remains("target") < 7.2 then
                    if cast.stellarFlare("target") then return true end
                end
                for i = 1, #enemies.yards45 do
                    local thisUnit = enemies.yards45[i]
                    if debuff.stellarFlare.exists(thisUnit) and debuff.stellarFlare.remains(thisUnit) < 7.2 then
                        if cast.stellarFlare(thisUnit) then return true end
                    end
                end   
            end
            -- Refresh Moonfire
            if debuff.moonfire.count() <= getOptionValue("Max Moonfire Targets") then
                if GetUnitExists("target") and not debuff.moonfire.exists("target") or debuff.moonfire.remains("target") < 7.2 then
                    if cast.moonfire("target") then return true end
                end
                for i = 1, #enemies.yards45 do
                    local thisUnit = enemies.yards45[i]
                    if debuff.moonfire.exists(thisUnit) and debuff.moonfire.remains(thisUnit) < 7.2 then
                        if cast.moonfire(thisUnit) then return true end
                    end
                end                    
            end
            -- New Moon
            if talent.newMoon and charges.newMoon.count() >= 1 then
                if moon == nil then moon = 10 end
                if br.player.power.astralPower.deficit() > moon then
                    if cast.newMoon() then return true end
                end
            end
            -- Solar Wrath
            if buff.solarEmpowerment.stack() == 3 and not isMoving("player") then
                if cast.solarWrath() then return true end
            end
            -- Lunar Strike
            if buff.lunarEmpowerment.exists() or buff.warriorOfElune.exists() then
                if cast.lunarStrike() then return true end
            end
            -- Solar Wrath
            if buff.solarEmpowerment.exists() and not isMoving("player") then
                if cast.solarWrath() then return true end
            end
            -- Lunar Strike (Filler)
            if #enemies.yards8t > getOptionValue("Lunar Strike Filler Targets") then
                if cast.lunarStrike() then return true end
            end
            -- Solar Wrath (Filler)
            if not isMoving("player") then
                if cast.solarWrath() then return true end
            end
            -- Moonfire
            if isMoving() then
                for i = 1, #enemies.yards45 do
                    local thisUnit = enemies.yards45[i]
                    local lowestDebuff, lowestTarget
                    if debuff.moonfire.exists(thisUnit) and (debuff.moonfire.remains(thisUnit) < lowestDebuff or lowestDebuff == nil) then
                        lowestDebuff = debuff.moonfire.remains(thisUnit)
                        lowestTarget = thisUnit
                    end
                end
                if lowestTarget then
                    if cast.moonfire(lowestTarget) then return true end
                else
                    if cast.moonfire() then return true end
                end   
            end
        end

        local function actionList_Opener()
            if ABOpener == false then 
                if not SW1 then
                    if cast.solarWrath() then 
                        SW1 = true
                        br.addonDebug("Opener: Solar Wrath 1 cast")
                        return
                    end
                elseif SW1 and not SW2 then
                    if cast.solarWrath() then
                        SW2 = true
                        br.addonDebug("Opener: Solar Wrath 2 cast")
                        return
                    end
                elseif SW2 and not MF then
                    if cast.moonfire() then
                        MF = true
                        br.addonDebug("Opener: Moonfire cast")
                        return
                    end
                elseif MF and not SF then
                    if cast.sunfire() then
                        SF = true
                        br.addonDebug("Opener: Sunfire cast")
                        return
                    end
                elseif SF and not StF then
                    if talent.stellarFlare then
                        if cast.stellarFlare() then 
                            StF = true
                            br.addonDebug("Opener: Stellar Flare cast")
                            return
                        end
                    else
                        StF = true
                        br.addonDebug("Opener: Stellar Flare not talented, bypassing")
                        return
                    end
                elseif StF and not CA and power < 40 then
                    if cast.solarWrath() then
                        br.addonDebug("Opener: Building Up AP") 
                        return 
                    end
                elseif StF and not CA and power >= 40 then
                    if talent.incarnationChoseOfElune and cd.incarnationChoseOfElune.remains() <= 3 then
                        if cast.incarnationChoseOfElune("player") then
                            br.addonDebug("Opener: Inc cast")
                            CA = true
                        end
                    elseif not talent.incarnationChoseOfElune and cd.celestialAlignment.remains() <= 3 then
                        if cast.celestialAlignment("player") then 
                            br.addonDebug("Opener: CA cast")
                            CA = true
                        end
                    else
                        br.addonDebug("Opener: CA/Inc On CD, Bypassing")
                        CA = true
                    end
                    return
                elseif CA then
                    ABOpener = true
                    br.addonDebug("Opener Complete")
                end
            end
        end
        

-----------------
--- Rotations ---
-----------------
        -- Pause
        if pause() or (UnitExists("target") and not UnitCanAttack("target", "player")) or mode.rotation == 2 then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat then
                actionList_Extras()
                if GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                    actionList_PreCombat()
                end
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat then
                if not chicken and not cast.last.moonkinForm(1) and not isMoving("player") then
                    if cast.moonkinForm() then return true end
                end
                actionList_Interrupts()
                if useDefensive() then
                    actionList_Defensive()
                end
                if ABOpener == false and isChecked("Opener") and (GetObjectExists("target") and isBoss("target")) then
                    actionList_Opener()
                end
                actionList_AMR()
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation 
local id = 102
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

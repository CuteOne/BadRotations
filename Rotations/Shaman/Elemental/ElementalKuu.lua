local rotationName = "Kuu"

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of enemies in range.", highlight = 1, icon = br.player.spell.liquidMagmaTotem },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight =1, icon = br.player.spell.chainLightning },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 1, icon = br.player.spell.lightningBolt },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.thunderstorm}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.ascendance },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.fireElemental },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.earthElemental}
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.astralShift },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.earthShield }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.windShear },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.hex }
    };
    CreateButton("Interrupt",4,0)
-- Ghost Wolf Button
    GhostWolfModes = {
        [1] = { mode = "Moving", value = 1, overlay = "Moving Enabled", tip = "Will Ghost Wolf when movement detected", highlight = 1, icon = br.player.spell.ghostWolf},
        [2] = { mode = "Hold", value = 1, overlay = "Hold Enabled", tip = "Will Ghost Wolf when key is held down", highlight = 0, icon = br.player.spell.ghostWolf},
    };
    CreateButton("GhostWolf",5,0)
-- StormKeeper Button
    StormKeeperModes = {
        [1] = { mode = "On", value = 1, overlay = "Storm Keeper Enabled", tip = "Will use Storm Keeper", highlight = 1, icon = br.player.spell.stormKeeper},
        [2] = { mode = "Off", value = 1, overlay = "Storm Keeper Disabled", tip = "Will not use Storm Keeper", highlight = 0, icon = br.player.spell.stormKeeper},
    };
    CreateButton("StormKeeper",6,0)
    -- Earth Shock Override Button
    EarthShockModes = {
        [2] = { mode = "On", value = 1, overlay = "ES Override Enabled", tip = "Will only use Earth Shock", highlight = 1, icon = br.player.spell.earthShock},
        [1] = { mode = "Off", value = 1, overlay = "ES Override Disabled", tip = "Will use Earthquake and Earth Shock", highlight = 0, icon = br.player.spell.earthquake},
    };
    CreateButton("EarthShock",7,0)
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
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cff0070deSimC","|cff0070deAMR"}, 1, "|cff0070deSet APL Mode to use.")
            -- Auto Engage
            br.ui:createCheckbox(section, "Auto Engage On Target", "|cff0070deCheck this to start combat upon clicking a target.",1)
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cff0070deSet to desired time for test in minutes. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cff0070deSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            br.ui:createCheckbox(section, "Auto Ghost Wolf", "|cff0070deCheck this to automatically control GW transformation based on toggle bar setting.")
            br.ui:createDropdownWithout(section, "Ghost Wolf Key",br.dropOptions.Toggle,6,"|cff0070deSet key to hold down for Ghost Wolf(Will break form for instant cast lava burst and flame shock.)")
            br.ui:createDropdownWithout(section, "Force GW Key",br.dropOptions.Toggle,6, "|cff0070deSet key to hold down for Ghost Wolf(Will not break form until key is released.)")
            -- Purge
            br.ui:createDropdown(section,"Purge", {"|cffFFFF00Selected Target","|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Water Walking
            br.ui:createCheckbox(section, "Water Walking")
            -- Frost Shock
            br.ui:createCheckbox(section, "Frost Shock")
            -- Cap Totem
            br.ui:createSpinner(section, "Capacitor Totem - Tank Stuns", 3 , 1 ,10, 1, "|cff0070deWill use capacitor totem on groups of mobs when in a party.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            br.ui:createCheckbox(section,"Racial", "|cff0070deCheck to use Racials")
            br.ui:createCheckbox(section,"Trinkets","|cff0070deCheck to use Trinkets when Fire/Storm Elemental is Out, during AoE or during Ascendance")
            br.ui:createCheckbox(section,"Storm Elemental/Fire Elemental", "|cff0070deCheck to use Storm/Fire Elemental")
            br.ui:createCheckbox(section,"Earth Elemental", "|cff0070deCheck to use Earth Elemental")
            br.ui:createCheckbox(section, "Ascendance", "|cff0070deCheck to use Ascendance")
        br.ui:checkSectionState(section)
        -------------------------
        ---  TARGET OPTIONS   ---  -- Define Target Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Targets")
            br.ui:createSpinnerWithout(section, "Maximum FlameShock Targets", 2, 1, 10, 1, "|cff0070deSet to maximum number of targets to use FlameShock in AoE. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinnerWithout(section, "Maximum LB Targets", 2, 1, 10, 1, "|cff0070deSet to maximum number of targets to use Lava Burst in AoE. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinnerWithout(section, "Maximum EB Targets", 2, 1, 10, 1, "|cff0070deSet to maximum number of targets to use Elemental Blast in AoE. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinnerWithout(section, "SK Targets", 3, 1, 10, 1, "|cff0070deSet to desired number of targets needed to use Storm Keeper. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinnerWithout(section, "LMT Targets", 3, 1, 10, 1, "|cff0070deSet to desired number of targets needed to use Liquid Magma Totem. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinnerWithout(section, "Earthquake Targets", 3, 1, 10, 1, "|cff0070deSet to desired number of targets needed to use Earthquake. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinnerWithout(section, "Lava Beam Targets", 3, 1, 10, 1, "|cff0070deSet to desired number of targets needed to use Lava Beam. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinnerWithout(section, "Meteor Targets", 2, 1, 10, 1, "|cff0070deSet to desired number of targets needed to use Meteor. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinnerWithout(section, "Earth Shock Maelstrom Dump", 90, 1, 100, 5, "|cff0070deSet to desired value to use Earth Shock as maelstrom dump. Min: 1 / Max: 100 / Interval: 5")
            br.ui:createSpinnerWithout(section, "Chain Lightning Stormkeeper", 3, 1, 10, 1, "|cff0070deSet to desired number of targets needed to use Chain Lightning during Stormkeeper. Min: 1 / Max: 10 / Interval: 1" )
        br.ui:checkSectionState(section)
        ------------------------
        --- COVENANT OPTIONS --- -- Define Covenants Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Covenants")
            br.ui:createCheckbox(section, "Chain Harvest")
            br.ui:createCheckbox(section, "Primordial Wave")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cff0070deHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cff0070deHealth Percent to Cast At")
            end
        -- Ancestral Spirit
            br.ui:createDropdown(section, "Ancestral Spirit", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccf0070deTarget to Cast On")
        -- Astral Shift
            br.ui:createSpinner(section, "Astral Shift",  50,  0,  100,  5,  "|cff0070deHealth Percent to Cast At")
        -- Cleanse Spirit
            br.ui:createDropdown(section, "Cleanse Spirit", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|cff0070deTarget to Cast On")
        -- Earth Shield
            br.ui:createCheckbox(section, "Earth Shield")
        -- Healing Surge
            br.ui:createSpinner(section, "Healing Surge",  80,  0,  100,  5,  "|cff0070deHealth Percent to Cast At")
        -- Capacitor Surge Totem
            br.ui:createSpinner(section, "Capacitor Totem - HP", 50, 0, 100, 5, "|cff0070deHealth Percent to Cast At")
            br.ui:createSpinner(section, "Capacitor Totem - AoE", 5, 0, 10, 1, "|cff0070deNumber of Units in 5 Yards to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Wind Shear
            br.ui:createCheckbox(section,"Wind Shear")
        -- Hex
            br.ui:createCheckbox(section,"Hex")
        -- Lightning Surge Totem
            br.ui:createCheckbox(section,"Capacitor Totem")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cff0070deCast Percent to Cast At")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
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
    --if br.timer:useTimer("debugElemental", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
        --Print("Running: "..rotationName)
--------------
--- Locals ---
--------------
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local covenant                                      = br.player.covenant
        local deadMouse, hasMouse, playerMouse              = UnitIsDeadOrGhost("mouseover"), GetObjectExists("mouseover"), UnitIsPlayer("mouseover")
        local deadtar, playertar                            = UnitIsDeadOrGhost("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local equiped                                       = br.player.equiped
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), isMoving("player")
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local hastar                                        = GetObjectExists("target")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mana                                          = br.player.power.mana.amount()
        local mode                                          = br.player.ui.mode
        local perk                                          = br.player.perk
        local pet                                           = br.player.pet.list     
        local php                                           = br.player.health
        local power                                         = br.player.power.maelstrom.amount()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local runeforge                                     = br.player.runeforge
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local traits                                        = br.player.traits
        local ttd                                           = getTTD
        local ttm                                           = br.player.timeToMax
        local ui                                            = br.player.ui
        local units                                         = br.player.units
        
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
		
		--if gcd > 0.1 then return end

        enemies.get(5)
        enemies.get(10)
        enemies.get(20) --enemies.yards20
        enemies.get(30) --enemies.yards30 = br.player.enemies(30)
        enemies.get(40,nil,nil,true) --enemies.yards40f 
        enemies.get(8,"target") -- enemies.yards8t
        enemies.get(10,"target") -- enemies.yards10t
		
	--TTD
		local function ttd(unit)
            local ttdSec = getTTD(unit)
            if getOptionCheck("Enhanced Time to Die") then
               return ttdSec
            end
            if ttdSec == -1 then
               return 999
            end
            return ttdSec
        end
	
        local fireEle = nil;
        local earthEle = nil;
        local stormEle = nil;
        local holdBreak = (buff.ghostWolf.exists() and mode.ghostWolf == 1) or not buff.ghostWolf.exists()

        if talent.primalElementalist then
            if pet ~= nil then
                for k, v in pairs(pet) do
                -- for i = 1, #br.player.pet do
                    local thisUnit = pet[k].id or 0
                    if thisUnit == 61029 then
                        fireEle = true          
                    elseif thisUnit == 77942 then
                        stormEle = true
                    elseif thisUnit == 61056 then
                        earthEle = true
                    end                        
                end
            end
        end

        local flameShockCount = 0
        for i=1, #enemies.yards40f do
            local flameShockRemain = getDebuffRemain(enemies.yards40f[i],spell.debuffs.flameShock,"player") or 0 -- 194384
            if flameShockRemain > 5.4  then
                flameShockCount = flameShockCount + 1
            end
        end

        local movingCheck = not isMoving("player") and not IsFalling() or (isMoving("player") and buff.spiritwalkersGrace.exists("player"))
       
--------------------
--- Action Lists ---
--------------------
        -- Action List - Extras
        local function actionList_Extra()
            -- Dummy Test
            if ui.checked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(ui.value("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end -- End Dummy Test
        -- Water Walking
            if falling > 1.5 and buff.waterWalking.exists() then
                CancelUnitBuffID("player", spell.waterWalking)
            end
            if ui.checked("Water Walking") and not inCombat and IsSwimming() and not buff.waterWalking.exists() then
                if cast.waterWalking() then br.addonDebug("Casting Waterwalking") return end
            end
            -- Healing Surge (OOC)
            if ui.checked("Healing Surge") and movingCheck and php <= ui.value("Healing Surge") then    
                if cast.healingSurge("player") then br.addonDebug("Casting Healing Surge") return end
            end
            -- Ancestral Spirit
            if ui.checked("Ancestral Spirit") and movingCheck then
                if ui.value("Ancestral Spirit")==1 and hastar and playertar and deadtar then
                    if cast.ancestralSpirit("target","dead") then br.addonDebug("Casting Ancestral Spirit") return end
                end
                if ui.value("Ancestral Spirit")==2 and hasMouse and playerMouse and deadMouse then
                    if cast.ancestralSpirit("mouseover","dead") then br.addonDebug("Casting Ancestral Spirit") return end
                end
            end
        end -- End Action List - Extras
        local function ghostWolf()
             -- Ghost Wolf
             if not (IsMounted() or IsFlying()) and ui.checked("Auto Ghost Wolf") then
                if mode.ghostWolf == 1 then
                    if moving and not buff.ghostWolf.exists("player") then                        
                        if cast.ghostWolf("player") then br.addonDebug("Casting Ghost Wolf") end
                    elseif movingCheck and buff.ghostWolf.exists("player") and br.timer:useTimer("Delay",0.5) then
                        RunMacroText("/cancelAura Ghost Wolf")
                    end
                elseif mode.ghostWolf == 2 then
                    if not buff.ghostWolf.exists("player") then 
                        if SpecificToggle("Ghost Wolf Key")  and not GetCurrentKeyBoardFocus() then
                            if cast.ghostWolf("player") then br.addonDebug("Casting Ghost Wolf") end
                        end
                    elseif buff.ghostWolf.exists("player") then
                        if SpecificToggle("Ghost Wolf Key") then
                            return
                        elseif not SpecificToggle("Force GW Key") then
                            if br.timer:useTimer("Delay",0.25) then
                                RunMacroText("/cancelAura Ghost Wolf")
                            end
                        end
                    end
                end        
            end
        end
        --Action List PreCombat
        local function actionList_PreCombat()
            if ui.checked("Pig Catcher") then
                bossHelper()
            end
            prepullOpener = inRaid and ui.checked("Pre-pull Opener") and pullTimer <= ui.value("Pre-pull Opener") 
            if prepullOpener and movingCheck then
                --actions.precombat+=/earth_elemental,if=!talent.primal_elementalist.enabled
                if useCDs() and ui.checked("Earth Elemental") and not talent.primalElementalist then
                    if cast.earthElemental() then br.addonDebug("Casting Earth Elemental") return end
                end
                --# Use Stormkeeper precombat unless some adds will spawn soon.
                --actions.precombat+=/stormkeeper,if=talent.stormkeeper.enabled&(raid_event.adds.count<3|raid_event.adds.in>50)
                if mode.stormKeeper == 1 and talent.stormKeeper then
                    if cast.stormKeeper() then br.addonDebug("Casting Stormkeeper") return end
                end
                --actions.precombat+=/elemental_blast,if=talent.elemental_blast.enabled
                if talent.elementalBlast then
                    if cast.elementalBlast() then br.addonDebug("Casting Elemental Blast") return end
                else
                --actions.precombat+=/lava_burst,if=!talent.elemental_blast.enabled
                    if cast.lavaBurst() then br.addonDebug("Casting Lavaburst") return end
                end
            end
            if ui.checked("Auto Engage On Target") then
                if cast.flameShock() then br.addonDebug("Casting Flameshock") return end
            end
        end
        -- Action List - Defensive
        local function actionList_Defensive()
            -- Purge
            if ui.checked("Purge") then
                if ui.value("Purge") == 1 then
                    if canDispel("target",spell.purge) and GetObjectExists("target") then
                        if cast.purge("target") then br.addonDebug("Casting Purge") return end
                    end
                elseif ui.value("Purge") == 2 then
                    for i = 1, #enemies.yards30 do
                        local thisUnit = enemies.yards30[i]
                        if canDispel(thisUnit,spell.purge) then
                            if cast.purge(thisUnit) then br.addonDebug("Casting Purge") return end
                        end
                    end
                end
            end
            if useDefensive() then
        -- Pot/Stoned
                if ui.checked("Pot/Stoned") and php <= ui.value("Pot/Stoned")
                and inCombat and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
                    if canUseItem(5512) then
                        br.addonDebug("Using Healthstone")
                        useItem(5512)
                    elseif canUseItem(healPot) then
                        br.addonDebug("Using Health Pot")
                        useItem(healPot)
                    elseif hasItem(166799) and canUseItem(166799) then
                        br.addonDebug("Using Emerald of Vigor")
                        useItem(166799)
                    end
                end
        -- Heirloom Neck
                if ui.checked("Heirloom Neck") and php <= ui.value("Heirloom Neck") then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                            br.addonDebug("Using Heirloom Neck")
                        end
                    end
                end
        -- Gift of the Naaru
                if ui.checked("Gift of the Naaru") and php <= ui.value("Gift of the Naaru") and php > 0 and race == "Draenei" then
                    if cast.giftOfTheNaaru() then br.addonDebug("Casting Gift of the Naaru") return end
                end
        -- Astral Shift
                if ui.checked("Astral Shift") and php <= ui.value("Astral Shift") and inCombat then
                    if cast.astralShift() then br.addonDebug("Casting Astral Shift") return end
                end
        -- Cleanse Spirit
                if ui.checked("Cleanse Spirit") then
                    if ui.value("Cleanse Spirit")==1 and canDispel("player",spell.cleanseSpirit) then
                        if cast.cleanseSpirit("player") then br.addonDebug("Casting Cleanse Spirit") return end
                    end
                    if ui.value("Cleanse Spirit")==2 and canDispel("target",spell.cleanseSpirit) then
                        if cast.cleanseSpirit("target") then br.addonDebug("Casting Cleanse Spirit") return end
                    end
                    if ui.value("Cleanse Spirit")==3 and canDispel("mouseover",spell.cleanseSpirit) then
                        if cast.cleanseSpirit("mouseover") then br.addonDebug("Casting Cleanse Spirit") return end
                    end
                end
        -- Earthen Shield
                if ui.checked("Earth Shield") and not buff.earthShield.exists() then
                    if cast.earthShield() then br.addonDebug("Casting Earth Shield") return end
                end
        -- Healing Surge
                if ui.checked("Healing Surge") and movingCheck and ((mana >= 90 and php <= ui.value("Healing Surge"))or (php <= ui.value("Healing Surge") / 2 and mana > 20))
                then
                    if cast.healingSurge("player") then br.addonDebug("Casting Healing Surge") return end
                end
        -- Capacitor Totem
                if ui.checked("Capacitor Totem - HP") and php <= ui.value("Capacitor Totem - HP") and inCombat and #enemies.yards5 > 0 then
                    if cast.capacitorTotem("player","ground") then br.addonDebug("Casting Capacitor Totem") return end
                end
                if ui.checked("Capacitor Totem - AoE") and #enemies.yards5 >= ui.value("Capacitor Totem - AoE") and inCombat then
                    if createCastFunction("best",false,1,8,spell.capacitorTotem,nil,true) then br.addonDebug("Casting Capacitor Totem") return end
                    --if cast.capacitorTotem("best",nil,ui.value("Capacitor Totem - AoE"),8) then return end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
        -- Action List - Interrupts
        local function actionList_Interrupt()
            if useInterrupts() then
                for i=1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if canInterrupt(thisUnit,ui.value("Interrupt At")) then
        -- Wind Shear
                        if ui.checked("Wind Shear") then
                            if cast.windShear(thisUnit) then br.addonDebug("Casting Wind Shear") return end
                        end
        -- Hex
                        if ui.checked("Hex") then
                            if cast.hex(thisUnit) then br.addonDebug("Casting Hex") return end
                        end
        -- Capacitor Totem
                        if ui.checked("Capacitor Totem") and cd.windShear.remain() > gcd then
                            if hasThreat(thisUnit) and not isMoving(thisUnit) and ttd(thisUnit) > 7 then
                                if cast.capacitorTotem(thisUnit,"ground") then br.addonDebug("Casting Capacitor Totem") return end
                            end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
		
        -- Action List Simc AoE
        local function actionList_AoE()
            -- Earthquake (Echoing Shock)
            if buff.echoingShock.exists() and #enemies.yards8t >= ui.value("Earthquake Targets") and holdBreak then
                local cc = false
                if getOptionCheck("Don't break CCs") then
                    for i = 1, #enemies.yards8t do 
                        local thisUnit = #enemies.yards8t[i]
                        if isLongTimeCCed(thisUnit) then
                            cc = true
                            break
                        end
                    end
                end
                if cc == false then
                    if createCastFunction("best",false,1,8,spell.earthquake,nil,true) then br.addonDebug("Casting Earthquake") return end
                end
            end
            --Chain Harvest
            if ui.checked("Chain Harvest") and covenant.venthyr.active then
                if cast.chainHarvest() then br.addonDebug("Casting Chain Harvest") return end
            end
            --Storm Keeper
            --actions.aoe=stormkeeper,if=talent.stormkeeper.enabled
            if movingCheck and talent.stormKeeper and #enemies.yards10t >= ui.value("SK Targets") and mode.stormKeeper == 1 and holdBreak then
                if cast.stormKeeper() then br.addonDebug("Casting Stormkeeper") return end
            end
            -- Flame Shock
            --actions.aoe+=/flame_shock,if=active_dot.flame_shock<3&active_enemies<=5|runeforge.skybreakers_fiery_demise.equipped,target_if=refreshable
            if flameShockCount < ui.value("Maximum FlameShock Targets") or runeforge.skybreakersFieryDemise.equiped then
                if not talent.stormElemental or not stormEle or (#enemies.yards40f == 3 and buff.windGust.stack() < 14) then
                    if debuff.flameShock.remain("target") < 5.4 then
                        if cast.flameShock("target") then br.addonDebug("Casting Flameshock") return end
                    end
                    for i=1, #enemies.yards40f do
                        if debuff.flameShock.remain(enemies.yards40f[i]) < 5.4 then
                            if cast.flameShock(enemies.yards40f[i]) then br.addonDebug("Casting Flameshock") return end
                        end
                    end
                end
            end
            --Echoing Shock
            --actions.aoe+=/echoing_shock,if=talent.echoing_shock.enabled&maelstrom>=60
            if talent.echoingShock and power >= 60 then
                if cast.echoingShock() then br.addonDebug("Casting Echoing Shock") return end
            end
            -- Ascendance
            --actions.aoe+=/ascendance,if=talent.ascendance.enabled&(!pet.storm_elemental.active)&(!talent.icefury.enabled|!buff.icefury.up&!cooldown.icefury.up)
            if ui.checked("Ascendance") and talent.ascendance and 
                ((talent.stormElemental and not stormEle) or not talent.stormElemental) 
                and (not talent.iceFury or (not buff.iceFury.exists() and cd.iceFury.remains > 0)) and useCDs() and holdBreak 
            then
                if cast.ascendance() then br.addonDebug("Casting Ascendance") return end
            end
            -- Liquid Magma Totem
            --actions.aoe+=/liquid_magma_totem,if=talent.liquid_magma_totem.enabled
            if talent.liquidMagmaTotem and useCDs() and #enemies.yards8t >= ui.value("LMT Targets") and holdBreak then
                local cc = false
                if getOptionCheck("Don't break CCs") then
                    for i = 1, #enemies.yards8t do 
                        local thisUnit = #enemies.yards8t[i]
                        if isLongTimeCCed(thisUnit) then
                            cc = true
                            break
                        end
                    end
                end
                if cc == false then
                    if cast.liquidMagmaTotem("target") then br.addonDebug("Casting Liquid Magma Totem") return end
                end
            end
            -- Earth Shock (Echoes of the Great Sundering)
            --actions.aoe+=/earth_shock,if=runeforge.echoes_of_great_sundering.equipped&!buff.echoes_of_great_sundering.up
            if runeforge.echoesOfGreatSundering.equiped and not buff.echoesOfGreatSundering.exists() then
                if cast.earthShock() then br.addonDebug("Casting Earth Shock (EotGS)") return end
            end
            --Earth Elemental
            --actions.aoe+=/earth_elemental,if=runeforge.deeptremor_stone.equipped&(!talent.primal_elementalist.enabled|(!pet.storm_elemental.active&!pet.fire_elemental.active))
            if useCDs() and ui.checked("Earth Elemental") and (runeforge.deeptremorStone.equiped and (not talent.primalElementalist or ((not fireEle and not talent.stormElemental) or (not stormEle and talent.stormElemental)))) then
                if cast.earthElemental() then br.addonDebug("Casting Earth Elemental (Deeptremor Stone)") return end
            end
            --Lava Burst
            --actions.aoe+=/lava_burst,target_if=dot.flame_shock.remains,if=spell_targets.chain_lightning<4|buff.lava_surge.up|(talent.master_of_the_elements.enabled&!buff.master_of_the_elements.up&maelstrom>=60)
            if (#enemies.yards10t < 4 or (talent.masterOfTheElements and not buff.masterOfTheElements.exists() and power >= 60) and movingCheck) or buff.lavaSurge.exists() then
                if debuff.flameShock.exists("target") then
                    if UnitCastingInfo("player") then
                        SpellStopCasting()
                    end
                    if cast.lavaBurst() then br.addonDebug("Casting Lava Burst") return end
                else
                    for i = 1, #enemies.yards10t do
                        local thisUnit = enemies.yards10t[i]
                        if debuff.flameShock.exists(thisUnit) then
                            if UnitCastingInfo("player") then
                                SpellStopCasting()
                            end
                            if cast.lavaBurst(thisUnit) then br.addonDebug("Casting Lava Burst") return end
                        end
                    end
                end
            end
            -- Earthquake
            --actions.aoe+=/earthquake
            if #enemies.yards8t >= ui.value("Earthquake Targets") 
                and (not talent.masterOfTheElements or buff.stormKeeper.exists() or power >= ui.value("Earth Shock Maelstrom Dump") or buff.masterOfTheElements.exists() or #enemies.yards10t > 3) 
                and holdBreak 
            then
                if mode.earthShock == 1 then
                    local cc = false
                    if getOptionCheck("Don't break CCs") then
                        for i = 1, #enemies.yards8t do 
                            local thisUnit = #enemies.yards8t[i]
                            if isLongTimeCCed(thisUnit) then
                                cc = true
                                break
                            end
                        end
                    end
                    if cc == false then
                        if createCastFunction("best",false,1,8,spell.earthquake,nil,true) then br.addonDebug("Casting Earthquake") return end
                    end
                elseif mode.earthShock == 2 then
                    if cast.earthShock() then br.addonDebug("Casting Earthshock") return end
                end
            end
            -- Moving Chain Lightning
            if buff.stormKeeper.exists() and (moving or buff.stormKeeper.remains() < 3*gcdMax*buff.stormKeeper.stack()) and holdBreak then
                local cc = false
                if getOptionCheck("Don't break CCs") then
                    for i = 1, #enemies.yards10t do 
                        local thisUnit = #enemies.yards10t[i]
                        if isLongTimeCCed(thisUnit) then
                            cc = true
                            break
                        end
                    end
                end
                if cc == false then
                    if cast.chainLightning() then br.addonDebug("Casting Chain Lightning") return end
                end
            end
            -- Lava Burst (Instant)
            --actions.aoe+=/lava_burst,if=(buff.lava_surge.up|buff.ascendance.up)&spell_targets.chain_lightning<4
            if cd.lavaBurst.remain() <= gcd and buff.lavaSurge.exists() and #enemies.yards10t <= ui.value("Maximum LB Targets") and (not talent.stormElemental or not stormEle) 
			then
                if debuff.flameShock.exists("target") then
                    if UnitCastingInfo("player") then
                        SpellStopCasting()
                    end
                    if cast.lavaBurst() then br.addonDebug("Casting Lava Burst") return end
                else
                    for i = 1, #enemies.yards10t do
                        local thisUnit = enemies.yards10t[i]
                        if debuff.flameShock.exists(thisUnit) then
                            if UnitCastingInfo("player") then
                                SpellStopCasting()
                            end
                            if cast.lavaBurst(thisUnit) then br.addonDebug("Casting Lava Burst") return end
                        end
                    end
                end
            end
            -- Elemental Blast
            --actions.aoe+=/elemental_blast,if=talent.elemental_blast.enabled&spell_targets.chain_lightning<4
            if movingCheck and talent.elementalBlast and #enemies.yards10t <= ui.value("Maximum EB Targets") and (not talent.stormElemental or not stormEle) and holdBreak then
                if cast.elementalBlast() then br.addonDebug("Casting Elemental Blast") return end
            end
            -- Lava Beam
            --actions.aoe+=/lava_beam,if=talent.ascendance.enabled
            if movingCheck and buff.ascendance.exists() and #enemies.yards10t >= ui.value("Lava Beam Targets") and holdBreak then
                local cc = false
                if getOptionCheck("Don't break CCs") then
                    for i = 1, #enemies.yards10t do 
                        local thisUnit = #enemies.yards10t[i]
                        if isLongTimeCCed(thisUnit) then
                            cc = true
                            break
                        end
                    end
                end
                if cc == false then
                    if cast.lavaBeam() then br.addonDebug("Casting Lava Beam") return end
                end
            end             
            -- Chain Lightning
            --actions.aoe+=/chain_lightning
            if movingCheck and #enemies.yards10t > 2 and holdBreak then
                local cc = false
                if getOptionCheck("Don't break CCs") then
                    for i = 1, #enemies.yards10t do 
                        local thisUnit = #enemies.yards10t[i]
                        if isLongTimeCCed(thisUnit) then
                            cc = true
                            break
                        end
                    end
                end
                if cc == false then
                    if cast.chainLightning() then br.addonDebug("Casting Chain Lightning") return end
                end
            end
            -- Lava Burst (Moving)
            --actions.aoe+=/lava_burst,moving=1,if=talent.ascendance.enabled
            if buff.lavaSurge.exists() and moving then
                if getFacing("player", "target") and debuff.flameShock.exists("target") then
                    if cast.lavaBurst() then br.addonDebug("Casting Lava Burst") return end
                else
                    for i = 1, #enemies.yards40f do
                        local thisUnit = enemies.yards40f[i]
                        if getFacing("player", thisUnit) and debuff.flameShock.exists(thisUnit) then
                            if cast.lavaBurst(thisUnit) then br.addonDebug("Casting Lava Burst") return end
                        end
                    end
                end
            end
            -- Flame Shock (Moving)
            --actions.aoe+=/flame_shock,moving=1,target_if=refreshable
            if moving then
                for i=1, #enemies.yards40f do
                    if getFacing("player", enemies.yards40f[i]) and debuff.flameShock.remain(enemies.yards40f[i]) < 5.4 or not debuff.flameShock.exists(enemies.yards40f[i]) then
                        if cast.flameShock(enemies.yards40f[i]) then br.addonDebug("Casting Flameshock") return end
                    end
                end
            end                                
            -- Frost Shock (Moving)
            --actions.aoe+=/frost_shock,moving=1
            if moving and ui.checked("Frost Shock") and holdBreak then
                if cast.frostShock() then br.addonDebug("Casting Frostshock") return end
            end
        end	

        local function actionList_StormEleST()
            --Flame Shock
            --actions.se_single_target=flame_shock,target_if=(remains<=gcd)&(buff.lava_surge.up|!buff.bloodlust.up)
            if flameShockCount < #enemies.yards40f then
                for i=1, #enemies.yards40f do
                    if getFacing("player", enemies.yards40f[i])and debuff.flameShock.remain(enemies.yards40f[i]) < 5.4 then
                        if cast.flameShock(enemies.yards40f[i]) then br.addonDebug("Casting Flameshock") return end
                    end
                end
            end
            if ui.checked("Ascendance") and talent.ascendance and 
                ((talent.stormElemental and not stormEle) or not talent.stormElemental) 
                and (not talent.iceFury or (not buff.iceFury.exists() and cd.iceFury.remains > 0)) and useCDs() and holdBreak 
            then
                if cast.ascendance() then br.addonDebug("Casting Ascendance") return end
            end
            -- Elemental Blast
            --actions.se_single_target+=/elemental_blast,if=talent.elemental_blast.enabled
            if talent.elementalBlast then
                if cast.elementalBlast() then br.addonDebug("Casting Elemental Blast)") return end
            end
            -- Stormkeeper
            --actions.se_single_target+=/stormkeeper,if=talent.stormkeeper.enabled&(maelstrom<44)
            if mode.stormKeeper == 1 and talent.stormKeeper and power < 44 then
                if cast.stormKeeper() then br.addonDebug("Casting Stormkeeper") return end
            end
            -- Echoing Shock
            --actions.se_single_target+=/echoing_shock,if=talent.echoing_shock.enabled
            if talent.echoingShock then
                if cast.echoingShock() then br.addonDebug("Casting Echoing Shock") return end
            end
            -- Lava Burst
            --actions.se_single_target+=/lava_burst,if=buff.wind_gust.stack<18|buff.lava_surge.up
            if (buff.windGust.stack() < 18 and movingCheck) or buff.lavaSurge.exists() then
                if cast.lavaBurst() then br.addonDebug("Casting Lava Burst") return end
            end
            --Lightning Bolt
            --actions.se_single_target+=/lightning_bolt,if=buff.stormkeeper.up
            if buff.stormKeeper.exists() then
                if cast.lightningBolt() then br.addonDebug("Casting Lightning Bolt") return end
            end
            -- Earthquake
            --actions.se_single_target+=/earthquake,if=buff.echoes_of_great_sundering.up
            if (runeforge.echoesOfGreatSundering.equiped and buff.echoesOfGreatSundering.exists()) 
                or (#enemies.yards8t >= ui.value("Earthquake Targets") and not debuff.flameShock.refresh("target")) and holdBreak
            then
                local cc = false
                if getOptionCheck("Don't break CCs") then
                    for i = 1, #enemies.yards8t do 
                        local thisUnit = #enemies.yards8t[i]
                        if isLongTimeCCed(thisUnit) then
                            cc = true
                            break
                        end
                    end
                end
                if cc == false then
                    if createCastFunction("best",false,1,8,spell.earthquake,nil,true) then br.addonDebug("Casting Earthquake") return end
                end
            end
            -- Earth Shock
            --actions.se_single_target+=/earth_shock,if=spell_targets.chain_lightning<2&maelstrom>=60&(buff.wind_gust.stack<20|maelstrom>90)
            if (#enemies.yards10t ==0 and power >= 60 and (buff.windGust.stack() < 20 or power > 90)) then
                if cast.earthShock() then br.addonDebug("Casting Earth Shock") return end
            end
            -- Lightning Bolt
            --actions.se_single_target+=/lightning_bolt,if=(buff.stormkeeper.remains<1.1*gcd*buff.stormkeeper.stack|buff.stormkeeper.up&buff.master_of_the_elements.up)
            if ((buff.stormKeeper.remains() < 1.1*gcdMax*buff.stormKeeper.stack()) or buff.stormKeeper.exists() and buff.masterOfTheElements.exists()) then
                if cast.lightningBolt() then br.addonDebug("Casting Lightning Bolt") return end
            end
            -- Frost Shock
            --actions.se_single_target+=/frost_shock,if=talent.icefury.enabled&talent.master_of_the_elements.enabled&buff.icefury.up&buff.master_of_the_elements.up
            if talent.iceFury and talent.masterOfTheElements and buff.iceFury.exists() and buff.masterOfTheElements.exists() and ui.checked("Frost Shock") then
                if cast.frostShock() then br.addonDebug("Casting Frostshock") return end
            end
            -- Lava Burst
            if movingCheck and buff.ascendance.exists() and not talent.masterOfTheElements and holdBreak then
                if debuff.flameShock.remain("target") > getCastTime(spell.lavaBurst) then
                    if cast.lavaBurst() then br.addonDebug("Casting Lava Burst") return end
                else
                    for i = 1, #enemies.yards40f do
                        local thisUnit = enemies.yards40f[i]
                        if debuff.flameShock.remain(thisUnit) > getCastTime(spell.lavaBurst) then
                            if cast.lavaBurst(thisUnit) then br.addonDebug("Casting Lava Burst") return end
                        end
                    end
                end
            end
            --Ice Fury
            --actions.se_single_target+=/icefury,if=talent.icefury.enabled&!(maelstrom>75&cooldown.lava_burst.remains<=0)
            if talent.iceFury and not (power > 75 and cd.lavaBurst.remain() <= gcd) then
                if cast.iceFury() then br.addonDebug("Casting Ice Fury") return end
            end
            -- Lava Burst (MotE)
            --actions.se_single_target+=/lava_burst,if=cooldown_react&charges>talent.echo_of_the_elements.enabled
            if movingCheck and cd.lavaBurst.remains() <= gcdMax and charges.lavaBurst.count() > 1 and talent.echoOfTheElements then
                if cast.lavaBurst() then br.addonDebug("Casting Lava Burst") return end
             end
            --Frost Shock
            --actions.se_single_target+=/frost_shock,if=talent.icefury.enabled&buff.icefury.up
            if talent.iceFury and buff.iceFury.exists() and ui.checked("Frost Shock") then
                if cast.frostShock() then br.addonDebug("Casting Frostshock") return end
            end
            --Chain Harvest
            --actions.se_single_target+=/chain_harvest
            if ui.checked("Chain Harvest") and covenant.venthyr.active then
                if cast.chainHarvest() then br.addonDebug("Casting Chain Harvest") return end
            end
            -- Static Discharge
            --actions.se_single_target+=/static_discharge,if=talent.static_discharge.enable
            if talent.staticDischarge then
                if cast.staticDischarge() then br.addonDebug("Casting Static Discharge") return end
            end
            -- Earth Elemental
            --actions.se_single_target+=/earth_elemental,if=!talent.primal_elementalist.enabled|talent.primal_elementalist.enabled&(!pet.storm_elemental.active)
            if useCDs() and ui.checked("Earth Elemental") and (not talent.primalElementalist or not stormEle) then
                if cast.earthElemental() then br.addonDebug("Casting Earth Elemental") return end
            end
            -- Lightning Bolt
            --actions.se_single_target+=/lightning_bolt
            if movingCheck then
                if cast.lightningBolt() then br.addonDebug("Casting Lightning Bolt") return end
            end
             -- Flame Shock (Moving)
            --actions.aoe+=/flame_shock,moving=1,target_if=refreshable
            if moving then
                for i=1, #enemies.yards40f do
                    if debuff.flameShock.remain(enemies.yards40f[i]) < 5.4 or not debuff.flameShock.exists(enemies.yards40f[i]) then
                        if cast.flameShock(enemies.yards40f[i]) then br.addonDebug("Casting Flameshock") return end
                    end
                end
            end                                
            -- Frost Shock (Moving)
            --actions.aoe+=/frost_shock,moving=1
            if moving and ui.checked("Frost Shock") and holdBreak then
                if cast.frostShock() then br.addonDebug("Casting Frostshock") return end
            end
        end
		
        -- Action List Simc ST
        local function actionList_ST()
            if talent.stormElemental then
                actionList_StormEleST()
            end
            --Flame Shock
            --actions.single_target=(|talent.storm_elemental.enabled&cooldown.storm_elemental.remains<2*gcd|dot.flame_shock.remains<=gcd|talent.ascendance.enabled&dot.flame_shock.remains<(cooldown.ascendance.remains+buff.ascendance.duration)&cooldown.ascendance.remains<4&(!talent.storm_elemental.enabled|talent.storm_elemental.enabled&cooldown.storm_elemental.remains<120))&buff.wind_gust.stack<14&!buff.surge_of_power.up
            if flameShockCount < #enemies.yards40f then
                for i = 1, #enemies.yards40f do
                    if debuff.flameShock.remains(enemies.yards40f[i]) <= 5.4 or (talent.ascendance and debuff.flameShock.remains(enemies.yards40f[i]) < (cd.ascendance.remains() + buff.ascendance.duration()) and cd.ascendance.remains() < 4) then
                        if cast.flameShock(enemies.yards40f[i]) then br.addonDebug("Casting Flameshock") return end
                    end
                end
            end
            --Ascendance
            --actions.single_target+=/ascendance,if=talent.ascendance.enabled&(time>=60|buff.bloodlust.up)&cooldown.lava_burst.remains>0&!talent.storm_elemental.enabled
            if ui.checked("Ascendance") and talent.ascendance and useCDs() and cd.lavaBurst.remain() > 0 and not buff.iceFury.exists() and holdBreak then
                if cast.ascendance() then br.addonDebug("Casting Ascendance") return end
            end
            -- Elemental Blast
            --# Don't use Elemental Blast if you could cast a Master of the Elements empowered Earth Shock instead.
            --actions.single_target+=/elemental_blast,if=talent.elemental_blast.enabled&(talent.master_of_the_elements.enabled&buff.master_of_the_elements.up&maelstrom<60|!talent.master_of_the_elements.enabled)
            --&(!(cooldown.storm_elemental.remains>120&talent.storm_elemental.enabled)|azerite.natural_harmony.rank=3&buff.wind_gust.stack<14)
            if movingCheck and talent.elementalBlast and ((talent.masterOfTheElements and buff.masterOfTheElements.exists() and power < 60) or not talent.masterOfTheElements)and holdBreak  then
                if cast.elementalBlast() then br.addonDebug("Casting Elemental Blast") return end
            end
            --Storm Keeper
            --# Keep SK for large or soon add waves.
            --actions.single_target+=/stormkeeper,if=talent.stormkeeper.enabled&(raid_event.adds.count<3|raid_event.adds.in>50)
            if movingCheck and useCDs() and talent.stormKeeper and (not talent.surgeOfPower or buff.surgeOfPower.exists() or power >= 44) and mode.stormKeeper == 1 and holdBreak then
                if cast.stormKeeper() then br.addonDebug("Casting Stormkeeper") return end
            end
            --Echoing Shock
            if talent.echoingShock and cd.lavaBurst.remain() <= gcd then
                if cast.echoingShock() then br.addonDebug("Casting Echoing Shock") return end
            end
            -- Lava Burst
            if movingCheck and talent.echoingShock and buff.echoingShock.exists() then
                if cast.lavaBurst() then br.addonDebug("Casting Lava Burst") return end
            end
            -- Liquid Magma Totem
            --actions.single_target+=/liquid_magma_totem,if=talent.liquid_magma_totem.enabled&(raid_event.adds.count<3|raid_event.adds.in>50)
            if useCDs() and #enemies.yards8t >= ui.value("LMT Targets") and talent.liquidMagmaTotem and holdBreak then
                local cc = false
                if getOptionCheck("Don't break CCs") then
                    for i = 1, #enemies.yards8t do 
                        local thisUnit = #enemies.yards8t[i]
                        if isLongTimeCCed(thisUnit) then
                            cc = true
                            break
                        end
                    end
                end
                if cc == false then
                    if cast.liquidMagmaTotem() then br.addonDebug("Casting Liquid Magma Totem") return end
                end
            end
            -- Lightning Bolt
            --actions.single_target+=/lightning_bolt,if=buff.stormkeeper.up&spell_targets.chain_lightning<2&(buff.master_of_the_elements.up&!talent.surge_of_power.enabled|buff.surge_of_power.up)
            if buff.stormKeeper.exists() and (moving or (#enemies.yards10t <= 2 and buff.masterOfTheElements.exists())) and holdBreak then
                if cast.lightningBolt() then br.addonDebug("Casting Lightning Bolt") return end
            end
             -- Earthquake
            --actions.single_target+=/earthquake,if=buff.echoes_of_great_sundering.up&(!talent.master_of_the_elements.enabled|buff.master_of_the_elements.up)
            if (runeforge.echoesOfGreatSundering.equiped and buff.echoesOfGreatSundering.exists()) 
                or (#enemies.yards8t >= ui.value("Earthquake Targets") and not debuff.flameShock.refresh("target")) and holdBreak
            then
                local cc = false
                if getOptionCheck("Don't break CCs") then
                    for i = 1, #enemies.yards8t do 
                        local thisUnit = #enemies.yards8t[i]
                        if isLongTimeCCed(thisUnit) then
                            cc = true
                            break
                        end
                    end
                end
                if cc == false then
                    if createCastFunction("best",false,1,8,spell.earthquake,nil,true) then br.addonDebug("Casting Earthquake") return end
                end
            end
            -- Earthquake
            --actions.single_target+=/earthquake,if=spell_targets.chain_lightning>1&!dot.flame_shock.refreshable&!runeforge.echoes_of_great_sundering.equipped
            --&(!talent.master_of_the_elements.enabled|buff.master_of_the_elements.up|cooldown.lava_burst.remains>0&maelstrom>=92)
            if #enemies.yards8t >= ui.value("Earthquake Targets") and not debuff.flameShock.exists() or debuff.flameShock.remain() < 5.4 and not runeforge.echoesOfGreatSundering.equiped
              and (not talent.masterOfTheElements or buff.masterOfTheElements.exists() or (cd.lavaBurst.remains() > gcd and power >= ui.value("Earth Shock Maelstrom Dump"))) 
              and holdBreak 
            then
                if mode.earthShock == 1 then
                    local cc = false
                    if getOptionCheck("Don't break CCs") then
                        for i = 1, #enemies.yards8t do 
                            local thisUnit = #enemies.yards8t[i]
                            if isLongTimeCCed(thisUnit) then
                                cc = true
                                break
                            end
                        end
                    end
                    if cc == false then
                        if createCastFunction("best",false,1,8,spell.earthquake,nil,true) then br.addonDebug("Casting Earthquake") return end
                    end
                elseif mode.earthShock == 2 then
                    if cast.earthShock() then br.addonDebug("Casting Earthshock") return end
                end
            end
            -- Earth Shock
            --actions.single_target+=/earth_shock,if=!buff.surge_of_power.up&talent.master_of_the_elements.enabled
            --&(buff.master_of_the_elements.up|maelstrom>=92+30*talent.call_the_thunder.enabled|buff.stormkeeper.up&active_enemies<2)|!talent.master_of_the_elements.enabled
            --&(buff.stormkeeper.up|maelstrom>=90+30*talent.call_the_thunder.enabled|!(cooldown.storm_elemental.remains>120&talent.storm_elemental.enabled)
            if not buff.surgeOfPower.exists() and (talent.masterOfTheElements and buff.masterOfTheElements.exists() or buff.stormKeeper.exists()) or ((not talent.masterOfTheElements and
            buff.stormKeeper.exists()) or power >= ui.value("Earth Shock Maelstrom Dump")) and holdBreak then
                if cast.earthShock() then br.addonDebug("Casting Earthshock") return end
            end
            --# Cast Lightning Bolt regardless of the previous condition if you'd lose a Stormkeeper stack or have Stormkeeper and Master of the Elements active.
            -- actions.single_target+=/lightning_bolt,if=(buff.stormkeeper.remains<1.1*gcd*buff.stormkeeper.stack|buff.stormkeeper.up&buff.master_of_the_elements.up)
            if ((buff.stormKeeper.remains() < 1.1*gcdMax*buff.stormKeeper.stack()) or buff.stormKeeper.exists() and buff.masterOfTheElements.exists()) then
                if cast.lightningBolt() then br.addonDebug("Casting Lightning Bolt") return end
            end
            -- Frost Shock
            --actions.single_target+=/frost_shock,if=talent.icefury.enabled&talent.master_of_the_elements.enabled&buff.icefury.up&buff.master_of_the_elements.up
            if talent.iceFury and talent.masterOfTheElements and buff.iceFury.exists() and buff.masterOfTheElements.exists() and ui.checked("Frost Shock") then
                if cast.frostShock() then br.addonDebug("Casting Frostshock") return end
            end
            --Lava Burst
            --actions.single_target+=/lava_burst,if=cooldown_react|buff.ascendance.up
            if movingCheck and buff.ascendance.exists() or (cd.lavaBurst.remain() <= gcd and not talent.masterOfTheElements) and holdBreak then
                if debuff.flameShock.remain("target") > getCastTime(spell.lavaBurst) then
                    if cast.lavaBurst() then br.addonDebug("Casting Lava Burst") return end
                else
                    for i = 1, #enemies.yards40f do
                        local thisUnit = enemies.yards40f[i]
                        if debuff.flameShock.remain(thisUnit) > getCastTime(spell.lavaBurst) then
                            if cast.lavaBurst(thisUnit) then br.addonDebug("Casting Lava Burst") return end
                        end
                    end
                end
            end
            --Ice Fury
            if talent.iceFury and not (power > 75 and cd.lavaBurst.remain() <= gcd) then
                if cast.iceFury() then br.addonDebug("Casting Ice Fury") return end
            end
            
            if movingCheck and cd.lavaBurst.remains() <= gcdMax and charges.lavaBurst.count() > 1 then
                if cast.lavaBurst() then br.addonDebug("Casting Lava Burst") return end
             end
            --# Slightly delay using Icefury empowered Frost Shocks to empower them with Master of the Elements too.
            --actions.single_target+=/frost_shock,if=talent.icefury.enabled&buff.icefury.up&buff.icefury.remains<1.1*gcd*buff.icefury.stack
            if talent.masterOfTheElements and talent.iceFury and buff.iceFury.exists() and (buff.iceFury.remains() < 1.5*gcdMax*buff.iceFury.stack()) and ui.checked("Frost Shock") then
               if cast.frostShock() then br.addonDebug("Casting Frostshock") return end
            end
            -- actions.single_target+=/lava_burst,if=cooldown_react
            if movingCheck and cd.lavaBurst.remains() <= gcdMax then
                if cast.lavaBurst() then br.addonDebug("Casting Lava Burst") return end
             end
            -- Flame Shock
            --actions.single_target+=/flame_shock,target_if=refreshable
            if debuff.flameShock.refresh("target") then
                if cast.flameShock("target") then br.addonDebug("Casting Flameshock") return end
            end
            -- Earthquake
            --actions.se_single_target+=/earthquake,if=buff.echoes_of_great_sundering.up
            if (runeforge.echoesOfGreatSundering.equiped and buff.echoesOfGreatSundering.exists()) or (#enemies.yards10t > 0 and not runeforge.echoesOfGreatSundering.equiped) then
                if #enemies.yards8t >= ui.value("Earthquake Targets") and holdBreak then
                    local cc = false
                    if getOptionCheck("Don't break CCs") then
                        for i = 1, #enemies.yards8t do 
                            local thisUnit = #enemies.yards8t[i]
                            if isLongTimeCCed(thisUnit) then
                                cc = true
                                break
                            end
                        end
                    end
                    if cc == false then
                        if createCastFunction("best",false,1,8,spell.earthquake,nil,true) then br.addonDebug("Casting Earthquake") return end
                    end
                end
            end
            -- Frost Shock
            --actions.single_target+=/frost_shock,if=talent.icefury.enabled&buff.icefury.up&(buff.icefury.remains<gcd*4*buff.icefury.stack|buff.stormkeeper.up|!talent.master_of_the_elements.enabled)
            if talent.iceFury and buff.iceFury.exists() and ((buff.iceFury.remains() < 4*gcdMax*buff.iceFury.stack()) or buff.stormKeeper.exists() or not talent.masterOfTheElements) and ui.checked("Frost Shock") and holdBreak then
                if cast.frostShock() then br.addonDebug("Casting Frostshock") return end
            end
            -- Frost Shock
            --actions.single_target+=/frost_shock,if=runeforge.elemental_equilibrium.equipped&!buff.elemental_equilibrium_debuff.up
            --&!talent.elemental_blast.enabled&!talent.echoing_shock.enabled
            if runeforge.elementalEquilibrium.equiped and not buff.elementalEquilibrium.exists() and not talent.elementalBlast and not talent.echoingShock then
                if cast.frostShock() then br.addonDebug("Casting Frostshock") return end
            end
             --Chain Harvest
            --actions.single_target+=/chain_harvest
            if ui.checked("Chain Harvest") and covenant.venthyr.active then
                if cast.chainHarvest() then br.addonDebug("Casting Chain Harvest") return end
            end
            -- Static Discharge
            --actions.single_target+=/static_discharge,if=talent.static_discharge.enable
            if talent.staticDischarge then
                if cast.staticDischarge() then br.addonDebug("Casting Static Discharge") return end
            end
            -- Earth Elemental
            --actions.single_target+=/earth_elemental,if=!talent.primal_elementalist.enabled|talent.primal_elementalist.enabled&(!pet.storm_elemental.active)
            if useCDs() and ui.checked("Earth Elemental") and (not talent.primalElementalist or not fireEle) then
                if cast.earthElemental() then br.addonDebug("Casting Earth Elemental (Fire Ele)") return end
            end
            -- Lightning Bolt
            --actions.single_target+=/lightning_bolt
            if movingCheck then
                if cast.lightningBolt() then br.addonDebug("Casting Lightning Bolt") return end
            end
             -- Flame Shock (Moving)
            --actions.aoe+=/flame_shock,moving=1,target_if=refreshable
            if moving then
                for i=1, #enemies.yards40f do
                    if debuff.flameShock.remain(enemies.yards40f[i]) < 5.4 or not debuff.flameShock.exists(enemies.yards40f[i]) then
                        if cast.flameShock(enemies.yards40f[i]) then br.addonDebug("Casting Flameshock") return end
                    end
                end
            end                                
            -- Frost Shock (Moving)
            --actions.aoe+=/frost_shock,moving=1
            if moving and ui.checked("Frost Shock") and holdBreak then
                if cast.frostShock() then br.addonDebug("Casting Frostshock") return end
            end
        end
        --ELEMENTALS		
		local eyeActive = nil;
        local function actionList_Elementals()
            if talent.primalElementalist then
                if pet ~= nil then
                    for k, v in pairs(pet) do
                    -- for i = 1, #br.player.pet do
                        local thisUnit = pet[k].id or 0
                        if fireEle then
                            --print("Fire Elemental Detected")
                            if #enemies.yards8t >= ui.value("Meteor Targets") then
                                --if cast.meteor("pettarget") then end
                                CastSpellByName(GetSpellInfo(spell.meteor))
                                --br.addonDebug("Casting Meteor (Pet)")
                            end        
                            if not cd.immolate.exists() then
                                CastSpellByName(GetSpellInfo(spell.immolate))
                                --br.addonDebug("Casting Immolate (Pet)")
                            end                
                        elseif stormEle then
                            if select(2,GetSpellCooldown(157348)) ~= 0 then
                                if eyeActive == nil or GetTime() - eyeActive > 8 then
                                --print("Storm Elemental Detected")
                                    if #enemies.yards8t >= 1 then
                                        eyeActive = GetTime()
                                        CastSpellByName(GetSpellInfo(spell.eyeOfTheStorm))
                                        --br.addonDebug("Casting Eye Of The Storm (Pet)")
                                    end
                                end
                            end
                        elseif earthEle then
                            --print("Earth Elemental Detected")
                            if not buff.hardenSkin.exists() then
                                CastSpellByName(GetSpellInfo(spell.hardenSkin))
                                --br.addonDebug("Casting Harden Skin (Pet)")
                            end 
                            CastSpellByName(GetSpellInfo(spell.pulverize))
                            --br.addonDebug("Casting Pulverize (Pet)")
                        end                        
                    end
                end
            end
        end
        
-----------------
--- Rotations ---
-----------------
        -- Pause
        ghostWolf()
        if SpecificToggle("Force GW Key") and not GetCurrentKeyBoardFocus() and ui.checked("Auto Ghost Wolf") then
            if buff.ghostWolf.exists("player") then
                return
            else
                if cast.ghostWolf("player") then br.addonDebug("Casting Ghost Wolf") return end
            end
        elseif pause() or cd.global.remains() > 0 or (UnitExists("target") and not UnitCanAttack("target", "player")) or mode.rotation == 4 or isCastingSpell(293491)then
            return
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat then
                --if (buff.ghostWolf.exists() and mode.ghostWolf ~= 1) then return end
                    actionList_PreCombat()
                    actionList_Extra()
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat then
                --if (buff.ghostWolf.exists() and mode.ghostWolf ~= 1) then return end
                    actionList_Interrupt()
                    actionList_Defensive()
                    actionList_Elementals()
                    if ui.checked("Capacitor Totem - Tank Stuns") and getDistance("target") <= 40 and (inInstance or inRaid) then
                        if #enemies.yards8t >= ui.value("Capacitor Totem - Tank Stuns") and inCombat then
                            if createCastFunction("best",false,1,8,spell.capacitorTotem,nil,true) then br.addonDebug("Casting Capacitor Totem") return end
                        end
                    end
                    --Simc
                    if ui.value("APL Mode") == 1 then
                        --Trinkets
                        if ui.checked("Trinkets") and useCDs() then
                            if equiped.shiverVenomRelic() and ui.checked("Shiver Venom") then
                                if debuff.shiverVenom.stack("target") == 5 then
                                    if UnitCastingInfo("player") then
                                        SpellStopCasting()
                                    end
                                    use.shiverVenomRelic()
                                    br.addonDebug("Using Shiver Venom Relic")
                                end
                            elseif (buff.ascendance.exists("player") or #enemies.yards10t >= 3 or cast.last.fireElemental() or cast.last.stormElemental()) and holdBreak then
                                if canUseItem(13) and not equiped.shiverVenomRelic(13) then
                                    if UnitCastingInfo("player") then
                                        SpellStopCasting()
                                    end
                                    useItem(13)
                                    br.addonDebug("Using Trinket 1")
                                end
                                if canUseItem(14) and not equiped.shiverVenomRelic(14) then
                                    if UnitCastingInfo("player") then
                                        SpellStopCasting()
                                    end
                                    useItem(14)
                                    br.addonDebug("Using Trinket 2")
                                end
                            end
                        end
                        --actions+=/fire_elemental,if=!talent.storm_elemental.enabled
                        if ui.checked("Storm Elemental/Fire Elemental") and useCDs() and holdBreak and not earthEle then
                            if not talent.stormElemental then
                                if cast.fireElemental() then br.addonDebug("Casting Fire Elemental") return end
                                --actions+=/storm_elemental,if=talent.storm_elemental.enabled&(!talent.icefury.enabled|!buff.icefury.up&!cooldown.icefury.up)&(!talent.ascendance.enabled|!cooldown.ascendance.up)
                            elseif talent.stormElemental and (not talent.iceFury or (not buff.iceFury.exists("player") and cd.iceFury.remain() > gcd)) 
                            and (not talent.ascendance or (cd.ascendance.remain() > gcd or not useCDs())) then
                                if cast.stormElemental() then br.addonDebug("Casting Storm Elemental") return end
                            end
                        end
                        --actions+=/earth_elemental,if=cooldown.fire_elemental.remains<120&!talent.storm_elemental.enabled|cooldown.storm_elemental.remains<120&talent.storm_elemental.enabled
                        --actions+=/earth_elemental,if=!talent.primal_elementalist.enabled|talent.primal_elementalist.enabled&(cooldown.fire_elemental.remains<120&!talent.storm_elemental.enabled|cooldown.storm_elemental.remains<120&talent.storm_elemental.enabled)
                        if useCDs() and ui.checked("Earth Elemental") and (not talent.primalElementalist or (talent.primalElementalist and ((not fireEle and not talent.stormElemental) or (not stormEle and talent.stormElemental)))) and holdBreak then
                            if cast.earthElemental() then br.addonDebug("Casting Earth Elemental (Main)") return end
                        end
                        -- Racial Buffs
                        if (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") and ui.checked("Racial") and useCDs() and (not talent.ascendance or buff.ascendance.exists("player") or cd.ascendance.remain() > 50) and holdBreak
                        then
                            if race == "LightforgedDraenei" then
                                if cast.racial("target","ground") then br.addonDebug("Casting Racial") return end
                            else
                                if cast.racial("player") then br.addonDebug("Casting Racial") return end
                            end
                        end
                        --actions+=/primordial_wave,target_if=min:dot.flame_shock.remains,cycle_targets=1,if=!buff.primordial_wave.up
                        if ui.checked("Primordial Wave") and covenant.necrolord.active and not buff.primordialWave.exists() then
                            for i = 1, #enemies.yards40f do
                                if getFacing("player", enemies.yards40f[i]) and debuff.flameShock.remain(enemies.yards40f[i]) < 5.4 then
                                    if cast.primordialWave(enemies.yards40f[i]) then br.addonDebug("Casting Primordial Wave") return end
                                end
                            end
                        end
                        -- actions+=/vesper_totem,if=covenant.kyrian
                        if covenant.kyrian.active then
                            if cast.vesperTotem() then br.addonDebug("Casting Vesper Totem") return end
                        end
                        --actions+=/fae_transfusion,if=covenant.night_fae
                        if covenant.nightFae.active then
                            if cast.faeTransfusion() then br.addonDebug("Casting Fae Transfusion") return end
                        end
                        if (#enemies.yards10t > 2 and (mode.rotation ~= 3 and mode.rotation ~= 2)) or mode.rotation == 2 then
                            if actionList_AoE() then return end
                        elseif (#enemies.yards10t <= 2 and (mode.rotation ~= 2 and mode.rotation ~= 3)) or mode.rotation == 3 then
                            if actionList_ST() then return end
                        end
                    end
				end
            end -- End In Combat Rotation
    --end -- End Timer
end -- End runRotation 
local id = 262 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

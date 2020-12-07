local rotationName = "Aura" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.crashLightning},
        [2] = { mode = "Off", value = 2 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.crashLightning}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.feralSpirit},
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.feralSpirit},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.feralSpirit}
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
    -- Ghost Wolf Button
    GhostWolfModes = {
        [1] = { mode = "Moving", value = 1, overlay = "Moving Enabled", tip = "Will Ghost Wolf when movement detected", highlight = 1, icon = br.player.spell.ghostWolf},
        [2] = { mode = "Hold", value = 1, overlay = "Hold Enabled", tip = "Will Ghost Wolf when key is held down", highlight = 0, icon = br.player.spell.ghostWolf},
    };
    CreateButton("GhostWolf",5,0)
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
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minutes. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Ghost Wolf
            br.ui:createCheckbox(section, "Auto Ghost Wolf", "|cff0070deCheck this to automatically control GW transformation based on toggle bar setting.")
            br.ui:createDropdownWithout(section, "Ghost Wolf Key",br.dropOptions.Toggle,6,"|cff0070deSet key to hold down for Ghost Wolf")
            -- Feral Lunge
            br.ui:createCheckbox(section,"Feral Lunge")
            -- Lightning Bolt OOC
            br.ui:createCheckbox(section,"Lightning Bolt Out of Combat")
            -- Spirit Walk
            br.ui:createCheckbox(section,"Spirit Walk")
            -- Water Walking
            br.ui:createCheckbox(section,"Water Walking")
            -- Cap Totem Stuns
            br.ui:createCheckbox(section,"Capacitor Totem - Tank Stuns", "Check this to use Capacitor Totem to stun packs on tank in dungeon/raid.")
        br.ui:checkSectionState(section)
        -----------------------
        ------- TARGETS ------- -- Define Target Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "Targets")
            -- Crash Lightning
            br.ui:createSpinner(section, "Crash Lightning Targets", 3, 1, 10, 1, "|cffFFFFFFSet to desired number of units to cast Crash Lightning. Min: 1 / Max: 10 / Interval: 1")
            -- Fury of Air
            br.ui:createSpinner(section, "Fury of Air Targets", 2, 1, 10, 1, "|cffFFFFFFSet to desired number of units to cast Fury of Air. Min: 1 / Max: 10 / Interval: 1")
            -- Sundering 
            br.ui:createSpinner(section, "Sundering Targets", 2, 1, 10, 1, "|cffFFFFFFSet to desired number of units to cast Sundering. Min: 1 / Max: 10 / Interval: 1")   
            -- Cap Totem Targets
            br.ui:createSpinner(section, "Capacitor Totem - Tank Stuns Targets", 2, 1, 10, 1, "|cffFFFFFFSet to desired number of units to stun using Capacitor Totem. Min: 1 / Max: 10 / Interval: 1")   
            -- Flameshock spread
            br.ui:createSpinnerWithout(section, "Maximum FlameShock Targets", 3, 1, 10, 1, "|cff0070deSet to maximum number of targets to use FlameShock in AoE. Min: 1 / Max: 10 / Interval: 1" )
            
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
        -- Agi Pot
        br.ui:createCheckbox(section,"Potion")
        -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Seventh Demon","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Ascendance
            br.ui:createCheckbox(section,"Ascendance")
        -- Earth Elemental Totem
            br.ui:createCheckbox(section,"Earth Elemental")
        -- Feral Spirit
            br.ui:createDropdownWithout(section,"Feral Spirit", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Feral Spirit.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
            -- Ancestral Spirit
            br.ui:createDropdown(section, "Ancestral Spirit", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Astral Shift
            br.ui:createSpinner(section, "Astral Shift",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Cleanse Spirit
            br.ui:createDropdown(section, "Clease Spirit", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Earth Shield
            br.ui:createCheckbox(section, "Earth Shield")
            -- Healing Surge
            br.ui:createSpinner(section, "Healing Surge",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Lightning Surge Totem
            br.ui:createSpinner(section, "Capacitor Totem - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Capacitor Totem - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
            -- Purge
            br.ui:createDropdown(section,"Purge", {"|cffFFFF00Selected Target","|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")
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
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")  
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
    if br.timer:useTimer("debugFury", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
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
        local deadMouse, hasMouse, playerMouse              = UnitIsDeadOrGhost("mouseover"), GetObjectExists("mouseover"), UnitIsPlayer("mouseover")
        local deadtar, playertar                            = UnitIsDeadOrGhost("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local healPot                                       = getHealthPot()
        local hastar                                        = GetObjectExists("target")
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mana                                          = br.player.power.mana.amount()
        local mode                                          = br.player.ui.mode
        local perk                                          = br.player.perk        
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power.maelstrom.amount(), br.player.powerMax, br.player.powerRegen
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local traits                                        = br.player.traits
        local ttd                                           = getTTD
        local ttm                                           = br.player.timeToMax
        local units                                         = br.player.units
        
        enemies.get(5)
        enemies.get(8) 
        enemies.get(10)
        enemies.get(20)
        enemies.get(30)
        enemies.get(40)
        enemies.get(8,"target") -- enemies.yards8t
        
        
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        
        -- variable,name=furyCheck45,value=(!talent.fury_of_air.enabled|(talent.fury_of_air.enabled&maelstrom>45))
        local furyCheck45 = not talent.furyOfAir or (talent.furyOfAir and power > 45)
        -- variable,name=furyCheck35,value=(!talent.fury_of_air.enabled|(talent.fury_of_air.enabled&maelstrom>35))
        local furyCheck35 = not talent.furyOfAir or (talent.furyOfAir and power > 35)
        -- variable,name=furyCheck25,value=(!talent.fury_of_air.enabled|(talent.fury_of_air.enabled&maelstrom>25))
        local furyCheck25 = not talent.furyOfAir or (talent.furyOfAir and power > 25)
        -- variable,name=OCPool80,value=(!talent.overcharge.enabled|active_enemies>1|(talent.overcharge.enabled&active_enemies=1&(cooldown.lightning_bolt.remains>=2*gcd|maelstrom>80)))
        local ocPool80 = (not talent.overcharge or #enemies.yards10 > 1 or (talent.overcharge and #enemies.yards10 >= 1 and (cd.lightningBolt.remain() >= 2 * gcdMax or power > 80)))
        -- variable,name=OCPool70,value=(!talent.overcharge.enabled|active_enemies>1|(talent.overcharge.enabled&active_enemies=1&(cooldown.lightning_bolt.remains>=2*gcd|maelstrom>70)))
        local ocPool70 = (not talent.overcharge or #enemies.yards10 > 1 or (talent.overcharge and #enemies.yards10 >= 1 and (cd.lightningBolt.remain() >= 2 * gcdMax or power > 70)))
        -- variable,name=OCPool60,value=(!talent.overcharge.enabled|active_enemies>1|(talent.overcharge.enabled&active_enemies=1&(cooldown.lightning_bolt.remains>=2*gcd|maelstrom>60)))
        local ocPool60 = (not talent.overcharge or #enemies.yards10 > 1 or (talent.overcharge and #enemies.yards10 >= 1 and (cd.lightningBolt.remain() >= 2 * gcdMax or power > 60)))

        -- Feral Spirit
        if feralSpiritCastTime == nil then feralSpiritCastTime = 0 end
        if feralSpiritRemain == nil then feralSpiritRemain = 0 end
        if cast.last.feralSpirit() then feralSpiritCastTime = GetTime() + 15 end
        if feralSpiritCastTime > GetTime() then feralSpiritRemain = feralSpiritCastTime - GetTime() else feralSpiritCastTime = 0; feralSpiritRemain = 0 end
		
	local flameShockCount = 0
        for i=1, #enemies.yards40 do
            local flameShockRemain = getDebuffRemain(enemies.yards40[i],spell.debuffs.flameShock,"player") or 0 -- 194384
            if flameShockRemain > 5.4  then
                flameShockCount = flameShockCount + 1
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
        -- Spirit Walk
            if isChecked("Spirit Walk") and hasNoControl(spell.spiritWalk) then
                if cast.spiritWalk() then return true end
            end
        -- Water Walking
            if falling > 1.5 and buff.waterWalking.exists() then
                CancelUnitBuffID("player", spell.waterWalking)
            end
            if isChecked("Water Walking") and not inCombat and IsSwimming() and not buff.waterWalking.exists() then
                if cast.waterWalking() then return true end
            end
        -- Healing Surge (OOC)
            if isChecked("Healing Surge") and not isMoving("player") and php <= getOptionValue("Healing Surge") then    
                if cast.healingSurge() then return true end
            end
            -- Ancestral Spirit
            if isChecked("Ancestral Spirit") then
                if getOptionValue("Ancestral Spirit")==1 and hastar and playertar and deadtar then
                    if cast.ancestralSpirit("target","dead") then return true end
                end
                if getOptionValue("Ancestral Spirit")==2 and hasMouse and playerMouse and deadMouse then
                    if cast.ancestralSpirit("mouseover","dead") then return true end
                end
            end
        end -- End Action List - Extras
    -- Action List - Defensive
        local function actionList_Defensive()
            if useDefensive() then
        -- Pot/Stoned
                if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned")
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
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                        end
                    end
                end
        -- Gift of the Naaru
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and race == "Draenei" then
                    if cast.giftOfTheNaaru() then return true end
                end
        -- Astral Shift
                if isChecked("Astral Shift") and php <= getOptionValue("Astral Shift") and inCombat then
                    if cast.astralShift() then return true end
                end
        -- Cleanse Spirit
                if isChecked("Cleanse Spirit") then
                    if getOptionValue("Cleanse Spirit")==1 and canDispel("player",spell.cleanseSpirit) then
                        if cast.cleanseSpirit("player") then return; end
                    end
                    if getOptionValue("Cleanse Spirit")==2 and canDispel("target",spell.cleanseSpirit) then
                        if cast.cleanseSpirit("target") then return true end
                    end
                    if getOptionValue("Cleanse Spirit")==3 and canDispel("mouseover",spell.cleanseSpirit) then
                        if cast.cleanseSpirit("mouseover") then return true end
                    end
                end
        -- Earthen Shield
                if isChecked("Earth Shield") and talent.earthShield and not buff.earthShield.exists() then
                    if cast.earthShield() then return true end
                end
        -- Healing Surge
                if isChecked("Healing Surge") and not isMoving("player") and ((php <= getOptionValue("Healing Surge") / 2 and mana > 20)
                or (mana >= 90 and php <= getOptionValue("Healing Surge")))
                then
                    if cast.healingSurge() then return true end
                end
        -- Capacitor Totem
                if isChecked("Capacitor Totem - HP") and php <= getOptionValue("Capacitor Totem - HP") and inCombat and #enemies.yards5 > 0 then
                    if cast.capacitorTotem("player","ground") then return true end
                end
                if isChecked("Capacitor Totem - AoE") and #enemies.yards5 >= getOptionValue("Capacitor Totem - AoE") and inCombat then
                    if createCastFunction("best",false,1,8,spell.capacitorTotem,nil,true) then return true end
                end
                -- Purge
                if isChecked("Purge") then
                    if getOptionValue("Purge") == 1 then
                        if canDispel("target",spell.purge) and GetObjectExists("target") then
                            if cast.purge("target") then br.addonDebug("Casting Purge") return true end
                        end
                    elseif getOptionValue("Purge") == 2 then
                        for i = 1, #enemies.yards30 do
                            local thisUnit = enemies.yards30[i]
                            if canDispel(thisUnit,spell.purge) then
                                if cast.purge(thisUnit) then br.addonDebug("Casting Purge") return true end
                            end
                        end
                    end
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
                        -- wind_shear
                        if isChecked("Wind Shear") then
                            if cast.windShear(thisUnit) then return true end
                        end
        -- Hex
                        if isChecked("Hex") then
                            if cast.hex(thisUnit) then return true end
                        end
        -- Capacitor Totem
                        if isChecked("Capacitor Totem") and cd.windShear.remain() > gcd then
                            if hasThreat(thisUnit) and not isMoving(thisUnit) and ttd(thisUnit) > 7 then
                                if cast.capacitorTotem(thisUnit,"ground") then return true end
                            end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
        local function ghostWolf()
            -- Ghost Wolf
            if not (IsMounted() or IsFlying()) and isChecked("Auto Ghost Wolf") then
                if mode.ghostWolf == 1 then
                    if ((#enemies.yards20 == 0 and not inCombat) or (#enemies.yards10 == 0 and inCombat)) and isMoving("player") and not buff.ghostWolf.exists() then
                       if cast.ghostWolf() then end
                    elseif isMoving("player") and buff.ghostWolf.exists() then
                        return true
                    elseif not isMoving("player") and buff.ghostWolf.exists() and br.timer:useTimer("Delay",0.5) then
                       RunMacroText("/cancelAura Ghost Wolf")
                    end
                elseif mode.ghostWolf == 2 then
                    if not buff.ghostWolf.exists() then 
                        if SpecificToggle("Ghost Wolf Key")  and not GetCurrentKeyBoardFocus() then
                           if cast.ghostWolf() then end
                        end
                    elseif buff.ghostWolf.exists() then
                        if SpecificToggle("Ghost Wolf Key") then
                           return true
                        else
                            if br.timer:useTimer("Delay",0.25) then
                               RunMacroText("/cancelAura Ghost Wolf")
                            end
                        end
                    end
                end        
            end
        end
        -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then
            -- Lightning Shield
                -- /lightning_shield
                if not buff.lightningShield.exists() then
                    if cast.lightningShield() then return true end
                end
                if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
                    if hasItem(166801) and canUseItem(166801) then
                        br.addonDebug("Using Sapphire of Brilliance")
                        useItem(166801)
                    end
                        -- Flask / Crystal
                    -- flask,type=flask_of_the_seventh_demon
                    if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheSeventhDemon.exists() and canUseItem(item.flaskOfTheSeventhDemon) then
                        if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                        if buff.felFocus.exists() then buff.felFocus.cancel() end
                        if use.flaskOfTheSeventhDemon() then return true end
                    end
                    if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and canUseItem(item.repurposedFelFocuser) then
                        if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                        if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                        if use.repurposedFelFocuser() then return true end
                    end
                    if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUseItem(item.oraliusWhisperingCrystal) then
                        if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                        if buff.felFocus.exists() then buff.felFocus.cancel() end
                        if use.oraliusWhisperingCrystal() then return true end
                    end
            -- Potion
                    -- potion,name=prolonged_power,if=feral_spirit.remain()s>5
                    if isChecked("Potion") and canUseItem(142117) and inRaid then
                        if feralSpiritRemain > 5 and not buff.prolongedPower.exists() then
                            useItem(142117)
                        end
                    end
                end -- End Pre-Pull
                if isValidUnit("target") then
            -- Feral Lunge
                    if isChecked("Feral Lunge") and getDistance("target") >= 8 and getDistance("target") <= 25 then
                        if cast.feralLunge("target") then return true end
                    end
            -- Lightning Bolt
                    if getDistance("target") >= 10 and isChecked("Lightning Bolt Out of Combat") and not talent.overcharge
                        and (not isChecked("Feral Lunge") or not talent.feralLunge or cd.feralLunge.remain() > gcd)
                    then
                        if cast.lightningBolt("target") then return true end
                    end
                end
            end -- End No Combat
        end -- End Action List - PreCombat
        local function actionList_Opener()

        end
        local function actionList_Ascendance()
            -- Crash Lightning
            if not buff.crashLightning.exists() and #enemies.yards10 > getOptionValue("Crash Lightning Targets") then
                if cast.crashLightning() then return true end
            end
            -- Wind Strike
            if cast.windstrike() then return true end
        end
        local function actionList_PriorityBuffs()
            --Crash Lightning
            if not buff.crashLightning.exists() and #enemies.yards10 >= getOptionValue("Crash Lightning Targets") then
                if cast.crashLightning() then return true end
            end
        end
        local function actionList_Maintenance()
            -- Flametongue
            if cast.able.flametongue() and select(8, GetWeaponEnchantInfo()) ~= 5400 then
                if cast.flametongue() then return true end
            end
            --Windfury
            if cast.able.windFuryWeapon() and select(4, GetWeaponEnchantInfo()) ~= 5401 then
                if cast.windFuryWeapon() then return true end
            end
        end
        local function actionList_CD()
            if hasItem(166801) and canUseItem(166801) then
                br.addonDebug("Using Sapphire of Brilliance")
                useItem(166801)
            end
            if isChecked("Racial") and race == "Troll" and ((talent.ascendance and buff.ascendance.exists())
            or (talent.elementalSpirits and feralSpiritRemain > 5) or (not talent.ascendance and not talent.elementalSpirits))
            then
                if cast.racial() then return true end
            end
            -- blood_fury,if=(talent.ascendance.enabled&(buff.ascendance.up|cooldown.ascendance.remains>50))|(!talent.ascendance.enabled&(feral_spirit.remains>5|cooldown.feral_spirit.remains>50))
            -- fireblood,if=(talent.ascendance.enabled&(buff.ascendance.up|cooldown.ascendance.remains>50))|(!talent.ascendance.enabled&(feral_spirit.remains>5|cooldown.feral_spirit.remains>50))
            -- ancestral_call,if=(talent.ascendance.enabled&(buff.ascendance.up|cooldown.ascendance.remains>50))|(!talent.ascendance.enabled&(feral_spirit.remains>5|cooldown.feral_spirit.remains>50))
            if isChecked("Racial") and (race == "Orc" or race == "DarkIronDwarf" or race == "MagharOrc")
            and ((talent.ascendance and (buff.ascendance.exists() or cd.ascendance.remain() > 50))
            or (not talent.ascendance and (feralSpiritRemain > 5 or cd.feralSpirit.remain() > 50)))
            then
                if cast.racial() then return true end
            end
            -- Potion
            -- potion,if=buff.ascendance.up|!talent.ascendance.enabled&feral_spirit.remains>5|target.time_to_die<=60
            if isChecked("Potion") and canUseItem(142117) and inRaid and not buff.prolongedPower.exists() then
                if (hasBloodLust() and (buff.ascendance.exists() or (not talent.ascendance and feralSpiritRemain > 5) or ttd(units.dyn5) <= 60)) then
                    useItem(142117)
                end
            end
            -- Feral Spirit
            if (getOptionValue("Feral Spirit") == 1 or (getOptionValue("Feral Spirit") == 2)) then
                if cast.feralSpirit() then return true end
            end
            -- Ascendance
            if talent.ascendance and cd.stormstrike.exists() and isChecked("Ascendance") then
                if cast.ascendance() then return true end
            end
            -- Earth Elemental
            if isChecked("Earth Elemental") then
                if cast.earthElemental() then return true end
            end
            -- Trinkets
            if isChecked("Trinkets") and (buff.ascendance.exists("player") or #enemies.yards8t >= 3 ) then
                if canUseItem(13) then
                    useItem(13)
                end
                if canUseItem(14) then
                    useItem(14)
                end
            end
        end
        local function actionList_Core()
            if buff.hailstorm.stack() <= 4 then 
                if flameShockCount < getValue("Maximum FlameShock Targets") then
                    if debuff.flameShock.remain("target") < 5.4 then
                        if cast.flameShock("target") then return true end
                    end
                    for i=1, #enemies.yards40 do
                        if debuff.flameShock.remain(enemies.yards40[i]) < 5.4 then
                            if cast.flameShock(enemies.yards40[i]) then br.addonDebug("Casting Flameshock") return true end
                        end
                    end
                end
            end
            -- Frostshock
            if talent.hailstorm then
                if buff.hailstorm.stack() == 5 then
                    if cast.frostShock(thisUnit) then return true end
                end
            end
            -- Windfury Totem
            if not buff.windFuryTotem.exists() and #enemies.yards10 >= 1 then
		if cast.windFuryTotem() then return true end
            end
            --Earthen Spike
            if talent.earthenSpike then
                if cast.earthenSpike() then return true end
            end
            -- Sundering
            if talent.sundering and getEnemiesInRect(5,10) >= getOptionValue("Sundering Targets") then
                if cast.sundering() then return true end
            end
            -- Stormstrike
            if traits.lightningConduit.active and #enemies.yards10 > 1 then
                for i = 1, #enemies.yards10 do
                    local thisUnit = enemies.yards10[i]
                    if not debuff.lightningConduit.exists(thisUnit) and buff.stormbringer.exists() then 
                        if cast.stormstrike() then return true end
                    end 
                end
            end
            -- Lava Lash
            if traits.primalPrimer.rank >= 2 and debuff.primalPrimer.stack("target") == 10 then
                if cast.lavaLash() then return true end
            end
            -- Stormstrike
            if buff.stormbringer.exists() or buff.gatheringStorms.exists() then
                if cast.stormstrike() then return true end
            end
            -- Crash Lightning
            if #enemies.yards10 >= getOptionValue("Crash Lightning Targets") then
                if cast.crashLightning() then return true end
            end
            -- Chain Lightning
            if buff.maelstrom.stack() >= 5 and #enemies.yards10 >= 2 then
                if cast.chainLightning() then return true end
            end
            -- Lightning Bolt
            if buff.maelstrom.stack() >= 8 and #enemies.yards10 == 1 then
                if cast.lightningBolt() then return true end
            end
            -- Lava Lash
            if traits.primalPrimer.rank >= 2 and debuff.primalPrimer.stack("target") > 7 then
                if cast.lavaLash() then return true end
            end
            --Stormstrike
            if cast.stormstrike() then return true end
            -- Lava Lash (Hot Hand)
            if talent.hotHand and buff.hotHand.exists() then
                if cast.lavaLash() then return true end
            end
        end
        local function actionList_Filler()
            -- Crash Lightning
            if talent.crashStorm and #enemies.yards10 >= getOptionValue("Crash Lightning Targets") then
                if cast.crashLightning() then return true end
            end
            -- Lava Lash
            if cast.lavaLash() then return true end
        end
        local function actionList_AMR()
            -- Totem Mastery
            if not cast.last.totemMastery(1) and talent.totemMastery and (not buff.resonanceTotem.exists() or buff.resonanceTotem.remain() < 6)  then
                if cast.totemMastery() then return true end
            end
            -- Racial
            if (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") and isChecked("Racial") and useCDs()
            then
                if race == "LightforgedDraenei" then
                    if cast.racial("target","ground") then return true end
                else
                    if cast.racial("player") then return true end
                end
            end
            -- Trinkets
            if isChecked("Trinkets") and useCDs() and (buff.ascendance.exists("player") or #enemies.yards8t >= 3 ) then
                if canTrinket(13) then
                    useItem(13)
                end
                if canTrinket(14) then
                    useItem(14)
                end
            end
            -- Potion
            if isChecked("Potion") and canUseItem(142117) and inRaid and not buff.prolongedPower.exists() then
                if (hasBloodLust() or (not talent.ascendance and feralSpiritRemain > 5) or ttd(units.dyn5) <= 60) then
                    useItem(142117)
                end
            end
            -- Rockbiter
            if charges.rockbiter.count() == 2 and power >= 30 then
                if cast.rockbiter() then return true end
            end
            -- Flametongue
            if not buff.flametongue.exists() then
                if cast.flametongue() then return true end
            end
            -- Frostbrand
            if talent.hailstorm and not buff.frostbrand.exists() then
                if cast.frostbrand() then return true end
            end
            -- Feral Spirit
            if (getOptionValue("Feral Spirit") == 1 or (getOptionValue("Feral Spirit") == 2 and useCDs())) then
                if cast.feralSpirit() then return true end
            end
            -- Sundering
            if talent.sundering and getEnemiesInRect(5,10) >= 2 then
                if cast.sundering() then return true end
            end
            -- Fury of Air On
            -- if not cast.last.furyOfAir(1) and talent.furyOfAir and #enemies.yards8 >= 2 and not buff.furyOfAir.exists() then
            --     if cast.furyOfAir() then return true end
            -- end 
            -- Crash Lightning
            if #enemies.yards8t >=3 then
                if cast.crashLightning() then return true end
            end
            -- Earthen Spike
            if talent.earthenSpike and power > 30 then
                if cast.earthenSpike() then return true end
            end
            -- Lightning Bolt
            if power >= 40 and talent.overcharge then
                if cast.lightningBolt() then return true end
            end
            -- Lava Lash
            if buff.hotHand.exists() then 
                if cast.lavaLash() then return true end
            end
            -- Ascendance
            if talent.ascendance and cd.stormstrike.exists() and useCDs() then
                if cast.ascendance() then return true end
            end
            -- Windstrike
            if buff.ascendance.exists() then
                if cast.windstrike() then return true end
            end
            -- Stormstrike
            if not buff.ascendance.exists() then
                if cast.stormstrike() then return true end
            end
            -- Sundering (2 Enemies)
            if talent.sundering and getEnemiesInRect(5,10) == 2 then
                if cast.sundering() then return true end
            end
            -- Crash Lighting
            if #enemies.yards8t >=2 then
                if cast.crashLightning() then return true end
            end
            -- Flametongue (Searing Assault)
            if talent.searingAssault then
                if cast.flametongue() then return true end
            end
            -- Totem Mastery
            if not cast.last.totemMastery(1) and talent.totemMastery and (not buff.resonanceTotem.exists() or buff.resonanceTotem.remain() < 36)  then
                if cast.totemMastery() then return true end
            end
            -- Flametongue Refresh
            if buff.flametongue.exists() and buff.flametongue.remain() < 0.3*buff.flametongue.duration() then
                if cast.flametongue() then return true end
            end
            -- Frostbrand Refresh
            if talent.hailstorm and buff.frostbrand.exists() and buff.frostbrand.remain() < 0.3*buff.frostbrand.duration() then
                if cast.frostbrand() then return true end
            end
            -- Lava Lash
            if cast.lavaLash() then return true end
            -- Rockbiter
            if charges.rockbiter.count() > 0 then
                if cast.rockbiter() then return true end
            end
            -- Flametongue
            if cast.flametongue() then return true end
        end
-----------------
--- Rotations ---
-----------------
        -- Pause
        if ghostWolf() then
            return true
        end
        if pause() or (UnitExists("target") and not UnitCanAttack("target", "player")) or mode.rotation == 2 then
            return true
        else    
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat then
                -- if buff.furyOfAir.exists() and not cast.last.furyOfAir(1) then
                --     if cast.furyOfAir() then return true end
                -- end
                actionList_Extras()
                if GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                    actionList_PreCombat()
                    if getDistance("target") <= 8 then
                        StartAttack()
                    end
                end
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat then
                actionList_Interrupts()
                actionList_Defensive()
                if isChecked("Capacitor Totem - Tank Stuns") and getDistance("target") <= 40 and (inInstance or inRaid) then
                    if #enemies.yards8t >= getOptionValue("Capacitor Totem - Tank Stuns Targets") and inCombat then
                        if createCastFunction("best",false,1,8,spell.capacitorTotem,nil,true) then return true end
                    end
                end
                if getOptionValue("APL Mode") == 1 or getOptionValue("APL Mode") == nil then
                    if getDistance("target") <= 8 then
                        StartAttack()
                    end
                    if actionList_Opener() then return true end
                    if buff.ascendance.exists() then
                        if actionList_Ascendance() then return true end
                    end
                    if actionList_PriorityBuffs() then return true end
                    if #enemies.yards8t < 3 then
                        if actionList_Maintenance() then return true end
                    end
                    if useCDs() then
                        if actionList_CD() then return true end
                    end
                    if actionList_Core() then return true end
                    if #enemies.yards8t >= 3 then
                        if actionList_Maintenance() then return true end
                    end
                    if actionList_Filler() then return true end
                elseif getOptionValue("APL Mode") == 2 then
                    actionList_AMR()
                end
            end -- End In Combat Rotation
        end -- Pause
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

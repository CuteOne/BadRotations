if select(2, UnitClass("player")) == "SHAMAN" then
    local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
    local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = bb.player.spell.crashLightning},
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.crashLightning},
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.rockbiter},
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.healingSurge}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.feralSpirit},
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.feralSpirit},
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.feralSpirit}
        };
        CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.astralShift},
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.astralShift}
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
            [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = bb.player.spell.windShear},
            [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = bb.player.spell.windShear}
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
            section = bb.ui:createSection(bb.ui.window.profile, "General")
            -- APL
                bb.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
                bb.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
                bb.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Ghost Wolf
                bb.ui:createCheckbox(section,"Ghost Wolf")
            -- Feral Lunge
                bb.ui:createCheckbox(section,"Feral Lunge")
            -- Spirit Walk
                bb.ui:createCheckbox(section,"Spirit Walk")
            -- Water Walking
                bb.ui:createCheckbox(section,"Water Walking")
            bb.ui:checkSectionState(section)
        -- Cooldown Options
            section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
            -- Agi Pot
                bb.ui:createCheckbox(section,"Agi-Pot")
            -- Flask / Crystal
                bb.ui:createCheckbox(section,"Flask / Crystal")
            -- Legendary Ring
                bb.ui:createCheckbox(section,"Legendary Ring")
            -- Racial
                bb.ui:createCheckbox(section,"Racial")
            -- Trinkets
                bb.ui:createCheckbox(section,"Trinkets")
            -- Ascendance
                bb.ui:createCheckbox(section,"Ascendance")
            -- Feral Spirit
                bb.ui:createCheckbox(section,"Feral Spirit")
            bb.ui:checkSectionState(section)
        -- Defensive Options
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
            -- Healthstone
                bb.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
                bb.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Gift of The Naaru
                if bb.player.race == "Draenei" then
                    bb.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                end
            -- Ancestral Spirit
                bb.ui:createDropdown(section, "Ancestral Spirit", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Astral Shift
                bb.ui:createSpinner(section, "Astral Shift",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")    
            -- Cleanse Spirit
                bb.ui:createDropdown(section, "Clease Spirit", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Healing Surge
                bb.ui:createSpinner(section, "Healing Surge",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Lightning Surge Totem
                bb.ui:createSpinner(section, "Lightning Surge Totem - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
                bb.ui:createSpinner(section, "Lightning Surge Totem - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
            -- Purge
                bb.ui:createCheckbox(section,"Purge")
            -- Rainfall
                bb.ui:createSpinner(section, "Rainfall",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            bb.ui:checkSectionState(section)
        -- Interrupt Options
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
            -- Wind Shear
                bb.ui:createCheckbox(section,"Wind Shear")
            -- Hex
                bb.ui:createCheckbox(section,"Hex")
            -- Lightning Surge Totem
                bb.ui:createCheckbox(section,"Lightning Surge Totem")
            -- Interrupt Percentage
                bb.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
            bb.ui:checkSectionState(section)
        -- Toggle Key Options
            section = bb.ui:createSection(bb.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
                bb.ui:createDropdown(section, "Rotation Mode", bb.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
                bb.ui:createDropdown(section, "Cooldown Mode", bb.dropOptions.Toggle,  3)
            -- Defensive Key Toggle
                bb.ui:createDropdown(section, "Defensive Mode", bb.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
                bb.ui:createDropdown(section, "Interrupt Mode", bb.dropOptions.Toggle,  6)
            -- Pause Toggle
                bb.ui:createDropdown(section, "Pause Mode", bb.dropOptions.Toggle,  6)
            bb.ui:checkSectionState(section)
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
        if bb.timer:useTimer("debugElemental", math.random(0.15,0.3)) then
            --print("Running: "..rotationName)

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
            local artifact                                      = bb.player.artifact
            local buff                                          = bb.player.buff
            local canFlask                                      = canUse(bb.player.flask.wod.agilityBig)
            local cast                                          = bb.player.cast
            local castable                                      = bb.player.cast.debug
            local combatTime                                    = getCombatTime()
            local cd                                            = bb.player.cd
            local charges                                       = bb.player.charges
            local deadMouse, hasMouse, playerMouse              = UnitIsDeadOrGhost("mouseover"), ObjectExists("mouseover"), UnitIsPlayer("mouseover")
            local deadtar, attacktar, hastar, playertar         = UnitIsDeadOrGhost("target"), UnitCanAttack("target", "player"), ObjectExists("target"), UnitIsPlayer("target")
            local debuff                                        = bb.player.debuff
            local enemies                                       = bb.player.enemies
            local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player") > 0
            local flaskBuff                                     = getBuffRemain("player",bb.player.flask.wod.buff.agilityBig)
            local friendly                                      = UnitIsFriend("target", "player")
            local gcd                                           = bb.player.gcd
            local healPot                                       = getHealthPot()
            local inCombat                                      = bb.player.inCombat
            local inInstance                                    = bb.player.instance=="party"
            local inRaid                                        = bb.player.instance=="raid"
            local lastSpell                                     = lastSpellCast
            local level                                         = bb.player.level
            local lootDelay                                     = getOptionValue("LootDelay")
            local lowestHP                                      = bb.friend[1].unit
            local mode                                          = bb.player.mode
            local moveIn                                        = 999
            -- local multidot                                      = (useCleave() or bb.player.mode.rotation ~= 3)
            local perk                                          = bb.player.perk        
            local php                                           = bb.player.health
            local power, powmax, powgen, powerDeficit           = bb.player.power, bb.player.powerMax, bb.player.powerRegen, bb.player.powerDeficit
            local pullTimer                                     = bb.DBM:getPulltimer()
            local racial                                        = bb.player.getRacial()
            local recharge                                      = bb.player.recharge
            local solo                                          = bb.player.instance=="none"
            local spell                                         = bb.player.spell
            local talent                                        = bb.player.talent
            local ttd                                           = getTTD
            local ttm                                           = bb.player.timeToMax
            local units                                         = bb.player.units
            
            if leftCombat == nil then leftCombat = GetTime() end
            if profileStop == nil then profileStop = false end
            if feralSpiritCastTime == nil then feralSpiritCastTime = 0 end
            if feralSpiritRemain == nil then feralSpiritRemain = 0 end
            if lastSpell == spell.feralSpirit then feralSpiritCastTime = GetTime() + 15 end
            if feralSpiritCastTime > GetTime() then feralSpiritRemain = feralSpiritCastTime - GetTime() else feralSpiritCastTime = 0; feralSpiritRemain = 0 end
            if crashLightningCastTime == nil then crashLightningCastTime = 0 end
            if crashingStormTimer == nil then crashingStormTimer = 0 end
            if lastSpell == spell.crashLightning then crashLightningCastTime = GetTime() + 6 end
            if crashLightningCastTime > GetTime() then crashingStormTimer = crashLightningCastTime - GetTime() else crashLightningCastTime = 0; crashingStormTimer = 0 end

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
                            print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                            profileStop = true
                        end
                    end
                end -- End Dummy Test
            -- Ghost Wolf
                if isChecked("Ghost Wolf") and not UnitBuffID("player",202477) then
                    if ((#enemies.yards20 == 0 and not inCombat) or (#enemies.yards10 == 0 and inCombat)) and isMoving("player") then
                        if cast.ghostWolf() then return end
                    end
                end
            -- Purge
                if isChecked("Purge") and canDispel("target",spell.purge) and not isBoss() and ObjectExists("target") then
                    if cast.purge() then return end
                end
            -- Spirit Walk
                if isChecked("Spirit Walk") and hasNoControl(spell.spiritWalk) then
                    if cast.spiritWalk() then return end
                end
            -- Water Walking
                if falling > 1.5 and buff.waterWalking then
                    CancelUnitBuffID("player", spell.waterWalking)
                end
                if isChecked("Water Walking") and not inCombat and IsSwimming() then
                    if cast.waterWalking() then return end
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
            -- Gift of the Naaru
                    if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and bb.player.race == "Draenei" then
                        if castSpell("player",racial,false,false,false) then return end
                    end
            -- Ancestral Spirit
                    if isChecked("Ancestral Spirit") then
                        if getOptionValue("Ancestral Spirit")==1 and hastar and playertar and deadtar then
                            if cast.ancestralSpirit("target") then return end
                        end
                        if getOptionValue("Ancestral Spirit")==2 and hasMouse and playerMouse and deadMouse then
                            if cast.ancestralSpirit("mouseover") then return end
                        end
                    end
            -- Astral Shift
                    if isChecked("Astral Shift") and php <= getOptionValue("Astral Shift") and inCombat then
                        if cast.astralShift() then return end
                    end
            -- Cleanse Spirit
                    if isChecked("Cleanse Spirit") then
                        if getOptionValue("Cleanse Spirit")==1 and canDispel("player",spell.cleanseSpirit) then
                            if cast.cleanseSpirit("player") then return; end
                        end
                        if getOptionValue("Cleanse Spirit")==2 and canDispel("target",spell.cleanseSpirit) then
                            if cast.cleanseSpirit("target") then return end
                        end
                        if getOptionValue("Cleanse Spirit")==3 and canDispel("mouseover",spell.cleanseSpirit) then
                            if cast.cleanseSpirit("mouseover") then return end
                        end
                    end
            -- Healing Surge
                    if isChecked("Healing Surge") 
                        and ((inCombat and ((php <= getOptionValue("Healing Surge") / 2 and power > 20) 
                            or (power >= 90 and php <= getOptionValue("Healing Surge")))) or (not inCombat and php <= getOptionValue("Healing Surge") and not moving)) 
                    then
                        if cast.healingSurge() then return end
                    end
            -- Lightning Surge Totem
                    if isChecked("Lightning Surge Totem - HP") and php <= getOptionValue("Lightning Surge Totem - HP") and inCombat and #enemies.yards5 > 0 then
                        if cast.lightningSurgeTotem() then return end
                    end
                    if isChecked("Lightning Surge Totem - AoE") and #enemies.yards5 >= getOptionValue("Lightning Surge Totem - AoE") and inCombat then
                        if cast.lightningSurgeTotem(getOptionValue("Lightning Surge Totem - AoE")) then return end
                    end
            -- Rainfall
                    if isChecked("Rainfall") and php <= getOptionValue("Rainfall") then
                        if cast.rainfall() then return end
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
                                if cast.windShear(thisUnit) then return end
                            end
            -- Hex
                            if isChecked("Hex") then
                                if cast.hex(thisUnit) then return end
                            end
            -- Lightning Surge Totem
                            if isChecked("Lightning Surge Totem") and cd.windShear > gcd then
                                if hasThreat(thisUnit) and not isMoving(thisUnit) and ttd(thisUnit) > 7 then
                                    if cast.lightningSurgeTotem(thisUnit) then return end
                                end
                            end
                        end
                    end
                end -- End useInterrupts check
            end -- End Action List - Interrupts
        -- Action List - Cooldowns
            local function actionList_Cooldowns()
                if useCDs() and getDistance("target") < 5 then
            -- Trinkets
                    if isChecked("Trinkets") then
                        if canUse(13) then
                            useItem(13)
                        end
                        if canUse(14) then
                            useItem(14)
                        end
                    end
            -- Legendary Ring
                    -- use_item,slot=finger1
                    if isChecked("Legendary Ring") then
                        if hasEquiped(124636) and canUse(124636) then
                            useItem(124636)
                        end
                    end
            -- Feral Spirit
                    -- feral_spirit
                    if isChecked("Feral Spirit") then
                        if cast.feralSpirit() then return end
                    end
            -- Crash Lightning
                    -- crash_lightning,if=artifact.alpha_wolf.rank&prev_gcd.feral_spirit
                    if artifact.alphaWolf and lastSpell == spell.feralSpirit then
                        if cast.crashLightning(units.dyn5) then return end
                    end
            -- Potion
                    -- potion,name=old_war,if=feral_spirit.remains>5|target.time_to_die<=30
                    if isChecked("Agi-Pot") and canUse(127844) and inRaid then
                        if feralSpiritRemain > 5 then
                            useItem(127844)
                        end
                    end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                    -- berserking,if=buff.ascendance.up|!talent.ascendance.enabled|level<100
                    -- blood_fury
                    if isChecked("Racial") and (bb.player.race == "Orc" or (bb.player.race == "Troll" and (buff.ascendance or not talent.ascendance or level < 100))) then
                        if castSpell("player",racial,false,false,false) then return end
                    end
                    if getOptionValue("APL Mode") == 1 then -- SimC

                    end
                    if getOptionValue("APL Mode") == 2 then -- AMR

                    end
                end -- End useCDs check
            end -- End Action List - Cooldowns
        -- Action List - PreCombat
            local function actionList_PreCombat()
                if not inCombat and not (IsFlying() or IsMounted()) then
                -- Flask / Crystal
                    -- flask,type=flask_of_the_seventh_demon
                    if isChecked("Flask / Crystal") then
                        if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",188033) then
                            useItem(bb.player.flask.wod.agilityBig)
                            return true
                        end
                        if flaskBuff==0 then
                            if not UnitBuffID("player",188033) and canUse(118922) then --Draenor Insanity Crystal
                                useItem(118922)
                                return true
                            end
                        end
                    end
                -- Lightning Shield
                    -- /lightning_shield
                    if cast.lightningShield() then return end
                    if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
                -- Potion
                        if isChecked("Agi-Pot") and canUse(127844) and inRaid then
                            useItem(127844)
                        end
                    end -- End Pre-Pull
                    if isValidUnit("target") then
                -- Feral Lunge
                        if isChecked("Feral Lunge") then
                            if cast.feralLunge("target") then return end
                        end
                -- Lightning Bolt
                        if getDistance("target") >= 10 and not talent.overcharge 
                            and (not isChecked("Feral Lunge") or not talent.feralLunge or cd.feralLunge > gcd or not castable.feralLunge) 
                        then
                            if cast.lightningBolt("target") then return end
                        end
                -- Start Attack
                        if getDistance("target") < 5 then
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
                if inCombat and profileStop==false and isValidUnit(units.dyn5) then
        ------------------------------
        --- In Combat - Interrupts ---
        ------------------------------
                    if actionList_Interrupts() then return end
        -----------------------------
        --- In Combat - Cooldowns ---
        -----------------------------
                    if actionList_Cooldowns() then return end
        ---------------------------
        --- SimulationCraft APL ---
        ---------------------------
                    if getOptionValue("APL Mode") == 1 then
                -- Fury of Air - Off
                        -- if TargetsInRadius(FuryOfAir) = 1
                        if buff.furyOfAir and #enemies.yards8 < 2 then
                            if cast.furyOfAir() then return end
                        end
                -- Feral Lunge
                        if isChecked("Feral Lunge") and hasThreat("target") then
                            if cast.feralLunge("target") then return end
                        end
                -- Start Attack
                        if getDistance("target") < 5 then
                            StartAttack()
                        end
                -- Crash Lightning
                        -- crash_lightning,if=talent.crashing_storm.enabled&active_enemies>=3
                        if talent.crashingStorm and ((mode.rotation == 1 and #enemies.yards5 >= 3) or mode.rotation == 2) and not moving then
                            if cast.crashLightning(units.dyn5) then return end
                        end
                -- Boulderfist
                        -- boulderfist,if=buff.boulderfist.remains<gcd&maelstrom>=50&active_enemies>=3
                        -- boulderfist,if=buff.boulderfist.remains<gcd|(charges_fractional>1.75&maelstrom<=100&active_enemies<=2)
                        if (buff.remain.boulderfist < gcd and power >= 50 and ((mode.rotation == 1 and #enemies.yards5 >= 3) or mode.rotation == 2)) 
                            or (buff.remain.boulderfist < gcd or (charges.frac.boulderfist > 1.75 and power <= 100 and ((mode.rotation == 1 and #enemies.yards5 <= 2) or mode.rotation == 1))) 
                        then
                            if cast.boulderfist() then return end
                        end
                -- Crash Lightning
                        -- crash_lightning,if=buff.crash_lightning.remains<gcd&active_enemies>=2
                        if buff.remain.crashLightning < gcd and ((mode.rotation == 1 and #enemies.yards5 >= 2) or mode.rotation == 2) then
                            if cast.crashLightning(units.dyn5) then return end
                        end
                -- Windstrike
                        -- windstrike,if=active_enemies>=3&!talent.hailstorm.enabled
                        if ((mode.rotation == 1 and #enemies.yards5 >= 3) or mode.rotation == 2) and not talent.hailstorm then
                            if cast.windstrike() then return end
                        end
                -- Stormstrike
                        -- stormstrike,if=active_enemies>=3&!talent.hailstorm.enabled
                        if ((mode.rotation == 1 and #enemies.yards5 >= 3) or mode.rotation == 2) and not talent.hailstorm then
                            if cast.stormstrike() then return end
                        end 
                -- Windstrike
                        -- windstrike,if=buff.stormbringer.react
                        if buff.stormbringer then
                            if cast.windstrike() then return end
                        end
                -- Stormstrike
                        -- stormstrike,if=buff.stormbringer.react
                        if buff.stormbringer then
                            if cast.stormstrike() then return end
                        end
                -- Frostbrand
                        -- frostbrand,if=talent.hailstorm.enabled&buff.frostbrand.remains<gcd
                        if talent.hailstorm and buff.remain.frostbrand < gcd then
                            if cast.frostbrand() then return end
                        end
                -- Flametongue
                        -- flametongue,if=buff.flametongue.remains<gcd
                        if buff.remain.flametongue < gcd then
                            if cast.flametongue() then return end
                        end
                -- Windsong
                        -- windsong
                        if cast.windsong() then return end
                -- Ascendance
                        -- ascendance
                        if useCDs() then
                            if cast.ascendance() then return end
                        end
                -- Fury of Air
                        -- fury_of_air,if=!ticking
                        if not buff.furyOfAir and #enemies.yards8 >= 2 then
                            if cast.furyOfAir() then return end
                        end
                -- Doom Winds
                        -- doom_winds
                        if cast.doomWinds() then return end
                -- Crash Lightning
                        -- crash_lightning,if=active_enemies>=3
                        if ((mode.rotation == 1 and #enemies.yards5 >= 3) or mode.rotation == 2) and not moving then
                            if cast.crashLightning(units.dyn5) then return end
                        end
                -- Windstrike
                        -- windstrike
                        if cast.windstrike() then return end
                -- Stormstrike
                        -- stormstrike
                        if cast.stormstrike() then return end
                -- Lightning Bolt
                        -- /lightning_bolt,if=talent.overcharge.enabled&maelstrom>=60
                        if talent.overcharge and power >= 60 then
                            if cast.lightningBolt() then return end
                        end
                -- Lava Lash
                        -- lava_lash,if=buff.hot_hand.react
                        if buff.hotHand then
                            if cast.lavaLash() then return end
                        end
                -- Earthen Spike
                        -- earthen_spike
                        if cast.earthenSpike() then return end
                -- Crash Lightning
                        -- crash_lightning,if=active_enemies>1|talent.crashing_storm.enabled|feral_spirit.remains>5
                        if ((mode.rotation == 1 and (#enemies.yards5 > 1 or talent.crashingStorm or feralSpiritRemain > 5)) or mode.rotation == 2) and mode.rotation ~= 3 and not moving then
                            if cast.crashLightning(units.dyn5) then return end
                        end
                -- Frostbrand
                        -- frostbrand,if=talent.hailstorm.enabled&buff.frostbrand.remains<4.8
                        if talent.hailstorm and buff.remain.frostbrand < 4.8 then
                            if cast.frostbrand() then return end
                        end
                -- Flametongue
                        -- flametongue,if=buff.flametongue.remains<4.8
                        if buff.remain.flametongue < 4.8 then
                            if cast.flametongue() then return end
                        end
                -- Sundering
                        -- sundering
                        if getDistance(units.dyn8) < 8 then
                            if cast.sundering() then return end
                        end
                -- Lava Lash
                        -- lava_lash,if=maelstrom>=90
                        if power >= 90 then
                            if cast.lavaLash() then return end
                        end
                -- Rockbiter
                        -- rockbiter
                        if cast.rockbiter() then return end
                -- Flametongue
                        -- flametongue
                        if cast.flametongue() then return end
                -- Boulderfist
                        -- boulderfist
                        if cast.boulderfist() then return end
                    end -- End SimC APL
        ----------------------
        --- AskMrRobot APL ---
        ----------------------
                    if getOptionValue("APL Mode") == 2 then
                -- Fury of Air - Off
                        -- if TargetsInRadius(FuryOfAir) = 1
                        if buff.furyOfAir and #enemies.yards8 < 2 then
                            if cast.furyOfAir() then return end
                        end
                -- Boulderfist
                        -- if BuffRemainingSec(BoulderfistEnhance) <= GlobalCooldownSec or ChargesRemaining(Boulderfist) = SpellCharges(Boulderfist)
                        if buff.remain.boulderfist <= gcd or charges.boulderfist == charges.max.boulderfist then
                            if cast.boulderfist() then return end
                        end
                -- Rockbiter
                        -- if BuffRemainingSec(Landslide) <= GlobalCooldownSec and HasTalent(Landslide)
                        if buff.remain.landslide <= gcd and talent.landslide then
                            if cast.rockbiter() then return end
                        end
                -- Frostbrand
                        -- if BuffRemainingSec(Frostbrand) <= GlobalCooldownSec and HasTalent(Hailstorm)
                        if buff.remain.frostbrand <= gcd and talent.hailstorm then
                            if cast.frostbrand() then return end
                        end
                -- Windsong
                        if cast.windsong() then return end
                -- Doom Winds
                        if cast.doomWinds() then return end
                -- Ascendance
                        if useCDs() and lastSpell == spell.doomWinds then
                            if cast.ascendance() then return end
                        end
                -- Earthen Spike
                        if cast.earthenSpike() then return end
                -- Frostbrand
                        -- if HasTalent(Hailstorm) and BuffRemainingSec(Frostbrand) <= 0.3 * BuffDurationSec(Frostbrand)
                        if talent.hailstorm and buff.remain.frostbrand <= 0.3 * buff.duration.frostbrand then
                            if cast.frostbrand() then return end
                        end
                -- Windstike
                        if cast.windstrike() then return end
                -- Stormstrike
                        if cast.stormstrike() then return end
                -- Crash Lightning
                        -- if (HasTalent(CrashingStorm) and TimerSecRemaining(CrashingStormTimer) = 0) or TargetsInRadius(CrashLightning) > 3 or (ArtifactTraitRank(GatheringStorms) > 0 and not HasBuff(GatheringStorms))
                        if (talent.crashingStorm and crashingStormTimer == 0) or #enemies.yards8 > 8 or (artifact.gatheringStorms and not buff.gatheringStorms) and getDistance(units.dyn5) < 5 then
                            if cast.crashLightning() then return end
                        end
                -- Flame Tongue
                        -- if BuffRemainingSec(Flametongue) <= 0.3 * BuffDurationSec(Flametongue)
                        if buff.remain.flametongue <= 0.3 * buff.duration.flametongue then
                            if cast.flametongue() then return end
                        end
                -- Sundering
                        if getDistance(units.dyn8) < 8 then
                            if cast.sundering() then return end
                        end
                -- Lightning Bolt
                        -- if HasTalent(Overcharge) and AlternatePower >= 45
                        if talent.overcharge and power >= 45 then
                            if cast.lightningBolt() then return end
                        end
                -- Fury of Air
                        -- if TargetsInRadius(FuryOfAir) > 1
                        if #enemies.yards8 > 1 then
                            if cast.furyOfAir() then return end
                        end
                -- Frostbrand
                        -- if HasItem(AkainusAbsoluteJustice) and not HasBuff(Frostbrand)
                -- Lava Lash
                        -- if HasBuff(HotHand) or AlternatePower > 40
                        if buff.hotHand or power > 40 then
                            if cast.lavaLash() then return end
                        end
                -- Boulderfist
                        if cast.boulderfist() then return end
                -- Rockbiter
                        if cast.rockbiter() then return end
                    end
                end --End In Combat
            end --End Rotation Logic
        end -- End Timer
    end -- End runRotation
    tinsert(cEnhancement.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end --End Class Check
local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.crashLightning},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.crashLightning},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.rockbiter},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.healingSurge}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.feralSpirit},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.feralSpirit},
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
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        -- Ghost Wolf
            br.ui:createCheckbox(section,"Ghost Wolf")
        -- Feral Lunge
            br.ui:createCheckbox(section,"Feral Lunge")
        -- Lightning Bolt OOC
            br.ui:createCheckbox(section,"Lightning Bolt Out of Combat")
        -- Spirit Walk
            br.ui:createCheckbox(section,"Spirit Walk")            
        -- Water Walking
            br.ui:createCheckbox(section,"Water Walking")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Agi Pot
            br.ui:createCheckbox(section,"Potion")
        -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Seventh Demon","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Ring of Collapsing Futures
            br.ui:createCheckbox(section,"Ring of Collapsing Futures")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Ascendance
            br.ui:createCheckbox(section,"Ascendance")
        -- Feral Spirit
            br.ui:createCheckbox(section,"Feral Spirit")
        br.ui:checkSectionState(section)
    -- Defensive Options
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
        -- Healing Surge
            br.ui:createSpinner(section, "Healing Surge",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Lightning Surge Totem
            br.ui:createSpinner(section, "Lightning Surge Totem - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Lightning Surge Totem - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
        -- Purge
            br.ui:createCheckbox(section,"Purge")
        -- Rainfall
            br.ui:createSpinner(section, "Rainfall",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Wind Shear
            br.ui:createCheckbox(section,"Wind Shear")
        -- Hex
            br.ui:createCheckbox(section,"Hex")
        -- Lightning Surge Totem
            br.ui:createCheckbox(section,"Lightning Surge Totem")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
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
    -- if br.timer:useTimer("Enhancement", br.debug.cpu.cBuilder.profile/10) then
        local startTime = debugprofilestop()
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
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local canFlask                                      = canUse(br.player.flask.wod.agilityBig)
        local cast                                          = br.player.cast
        local castable                                      = br.player.cast.debug
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse, hasMouse, playerMouse              = UnitIsDeadOrGhost("mouseover"), GetObjectExists("mouseover"), UnitIsPlayer("mouseover")
        local deadtar, attacktar, hastar, playertar         = UnitIsDeadOrGhost("target"), UnitCanAttack("target", "player"), GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = enemies or {}
        local equiped                                       = br.player.equiped  
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player") > 0
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hastar                                        = GetObjectExists("target")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local item                                          = br.player.spell.items
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local moveIn                                        = 999
        -- local multidot                                      = (useCleave() or br.player.mode.rotation ~= 3)
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local power, powmax, powgen, powerDeficit           = br.player.power.maelstrom.amount(), br.player.power.maelstrom.max(), br.player.power.maelstrom.regen(), br.player.power.maelstrom.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local t19pc4                                        = TierScan("T19") >= 4
        local t20pc2                                        = TierScan("T20") >= 2
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.maelstrom.ttm()
        local units                                         = units or {}
        local use                                           = br.player.use

        
        units.dyn8 = br.player.units(8)
        units.dyn10 = br.player.units(10)
        enemies.yards5 = br.player.enemies(5)
        enemies.yards8 = br.player.enemies(8)
        enemies.yards10 = br.player.enemies(10)
        enemies.yards20 = br.player.enemies(20)
        enemies.yards30 = br.player.enemies(30)

        if profileStop == nil then profileStop = false end
        if feralSpiritCastTime == nil then feralSpiritCastTime = 0 end
        if feralSpiritRemain == nil then feralSpiritRemain = 0 end
        if alphaWolfCastTime == nil then alphaWolfCastTime = 0 end
        if alphaWolfRemain == nil then alphaWolfRemain = 0 end
        if lastSpell == spell.feralSpirit then feralSpiritCastTime = GetTime() + 15 end
        if feralSpiritCastTime > GetTime() then feralSpiritRemain = feralSpiritCastTime - GetTime() else feralSpiritCastTime = 0; feralSpiritRemain = 0 end
        if lastSpell == spell.crashLightning and feralSpiritRemain > 0 then alphaWolfCastTime = GetTime() + 8 end
        if alphaWolfCastTime > GetTime() then alphaWolfRemain = alphaWolfCastTime - GetTime() else alphaWolfCastTime = 0; alphaWolfRemain = 0 end
        if crashLightningCastTime == nil then crashLightningCastTime = 0 end
        if crashingStormTimer == nil then crashingStormTimer = 0 end
        if lastSpell == spell.crashLightning then crashLightningCastTime = GetTime() + 6 end
        if crashLightningCastTime > GetTime() then crashingStormTimer = crashLightningCastTime - GetTime() else crashLightningCastTime = 0; crashingStormTimer = 0 end

        -- ChatOverlay(tostring(cd.doomWinds.remain()))

-----------------
--- Variables ---
-----------------
    -- Hailstorm
        -- variable,name=hailstormCheck,value=((talent.hailstorm.enabled&!buff.frostbrand.up)|!talent.hailstorm.enabled)
        local hailstormCheck = ((talent.hailstorm and not buff.frostbrand.exists()) or not talent.hailstorm)
    -- Fury of Air
        -- variable,name=furyCheck80,value=(!talent.fury_of_air.enabled|(talent.fury_of_air.enabled&maelstrom>80))
        local furyCheck80 = (not talent.furyOfAir or (talent.furyOfAir and power > 80))
        -- variable,name=furyCheck70,value=(!talent.fury_of_air.enabled|(talent.fury_of_air.enabled&maelstrom>70))
        local furyCheck70 = (not talent.furyOfAir or (talent.furyOfAir and power > 70))
        -- variable,name=furyCheck45,value=(!talent.fury_of_air.enabled|(talent.fury_of_air.enabled&maelstrom>45))
        local furyCheck45 = (not talent.furyOfAir or (talent.furyOfAir and power > 45))
        -- variable,name=furyCheck25,value=(!talent.fury_of_air.enabled|(talent.fury_of_air.enabled&maelstrom>25))
        local furyCheck25 = (not talent.furyOfAir or (talent.furyOfAir and power > 25))
    -- Overcharge
        -- variable,name=OCPool70,value=(!talent.overcharge.enabled|(talent.overcharge.enabled&maelstrom>70))
        local ocPool70 = (not talent.overcharge or (talent.overcharge and power > 70))
        -- variable,name=OCPool60,value=(!talent.overcharge.enabled|(talent.overcharge.enabled&maelstrom>60))
        local ocPool60 = (not talent.overcharge or (talent.overcharge and power > 60))
    -- Smoldering Heart
        -- variable,name=heartEquipped,value=(equipped.151819)
        local heartEquiped = hasEquiped(151819)
    -- Akainu's Absolute Justice
        -- variable,name=akainuEquipped,value=(equipped.137084)
        local akainuEquiped = hasEquiped(137084)
        -- variable,name=akainuAS,value=(variable.akainuEquipped&buff.hot_hand.react&!buff.frostbrand.up)
        local akainuAS = (akainuEquiped and buff.hotHand.exists() and not buff.frostbrand.exists())
    -- Lightning Crash
        -- variable,name=LightningCrashNotUp,value=(!buff.lightning_crash.up&set_bonus.tier20_2pc)
        local noLightningCrash = (not buff.lightningCrash.exists() and t20pc2)
    -- Alpha Wolf
        -- variable,name=alphaWolfCheck,value=((pet.frost_wolf.buff.alpha_wolf.remains<2&pet.fiery_wolf.buff.alpha_wolf.remains<2&pet.lightning_wolf.buff.alpha_wolf.remains<2)&feral_spirit.remains>4)
        local alphaWolfCheck = (alphaWolfRemain < 2 and feralSpiritRemain > 4)
    -- Crash Lightning
        local crashedEnemies = getEnemiesInCone(7,100)

        -- Fury of Air
        if buff.furyOfAir.exists() and (power < 12 or #enemies.yards8 == 0 or not inCombat) then
            if cast.furyOfAir() then return end
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
        -- Ghost Wolf
            if isChecked("Ghost Wolf") and not (IsMounted() or IsFlying()) then
                if ((#enemies.yards20 == 0 and not inCombat) or (#enemies.yards10 == 0 and inCombat)) and isMoving("player") and not buff.ghostWolf.exists() then
                    if cast.ghostWolf() then return end
                end
            end
        -- Purge
            if isChecked("Purge") and canDispel("target",spell.purge) and not isBoss() and GetObjectExists("target") then
                if cast.purge() then return end
            end
        -- Spirit Walk
            if isChecked("Spirit Walk") and hasNoControl(spell.spiritWalk) then
                if cast.spiritWalk() then return end
            end
        -- Water Walking
            if falling > 1.5 and buff.waterWalking.exists() then
                CancelUnitBuffID("player", spell.waterWalking)
            end
            if isChecked("Water Walking") and not inCombat and IsSwimming() and not buff.waterWalking.exists() then
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
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                    if cast.giftOfTheNaaru() then return end
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
                    if cast.lightningSurgeTotem("player","ground") then return end
                end
                if isChecked("Lightning Surge Totem - AoE") and #enemies.yards5 >= getOptionValue("Lightning Surge Totem - AoE") and inCombat then
                    if cast.lightningSurgeTotem("best",nil,getOptionValue("Lightning Surge Totem - AoE"),8) then return end
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
                        if isChecked("Lightning Surge Totem") and cd.windShear.remain() > gcd then
                            if hasThreat(thisUnit) and not isMoving(thisUnit) and ttd(thisUnit) > 7 then
                                if cast.lightningSurgeTotem(thisUnit,"ground") then return end
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
                -- berserking,if=buff.ascendance.up|(feral_spirit.remains>5)|level<100
                -- blood_fury,if=buff.ascendance.up|(feral_spirit.remains>5)|level<100
                if isChecked("Racial") and ((br.player.race == "Orc" or br.player.race == "Troll") and (buff.ascendance.exists() or feralSpiritRemain > 5 or level < 100)) and getSpellCD(racial) == 0 then
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Potion
                -- potion,if=buff.ascendance.up|!talent.ascendance.enabled&feral_spirit.remains>5|target.time_to_die<=60
                if isChecked("Potion") and canUse(142117) and inRaid then
                    if (hasBloodLust() or (not talent.ascendance and feralSpiritRemain > 5) or ttd(units.dyn5) <= 60) and not buff.prolongedPower.exists() then
                        useItem(142117)
                    end
                end
                if getOptionValue("APL Mode") == 1 then -- SimC

                end
                if getOptionValue("APL Mode") == 2 then -- AMR

                end
        -- Feral Spirit
                -- feral_spirit
                if isChecked("Feral Spirit") then
                    if cast.feralSpirit() then return end
                end
            end
        -- Doom Winds
            -- doom_winds,if=cooldown.ascendance.remains>6|talent.boulderfist.enabled|debuff.earthen_spike.up
            if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and getDistance("target") < 5 then
                if ((getOptionValue("Artifact") == 1 and not isBoss()) or not isChecked("Ascencance") or cd.ascendance.remain() > 6) or talent.boulderfist or debuff.earthenSpike.exists(units.dyn5) then
                    if cast.doomWinds() then return end
                end
            end
            if useCDs() and getDistance("target") < 5 then
        -- Ascendance
                -- ascendance,if=(cooldown.strike.remains>0)&buff.ascendance.down
                if isChecked("Ascendance") then
                    if cd.stormstrike.remain() > 0 and not buff.ascendance.exists() then
                        if cast.ascendance() then return end
                    end
                end
        -- Ring of Collapsing Futures
                -- use_item,slot=finger1,if=buff.temptation.down
                if isChecked("Ring of Collapsing Futures") then
                    if hasEquiped(142173) and canUse(142173) and not debuff.temptation.exists("player") then
                        useItem(142173)
                    end
                end
            end -- End useCDs check
        end -- End Action List - Cooldowns
    -- Action List - Ascendance
        local function actionList_Ascendance()
        -- Earthen Spike
            -- earthen_spike
            if cast.earthenSpike() then return end
        -- Doom Winds
            -- doom_winds,if=cooldown.windstrike.up
            if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and getDistance("target") < 5 then
                if cd.windstrike.remain() == 0 then
                    if cast.doomWinds() then return end
                end
            end
        -- Windstrike
            -- windstrike
            if cast.windstrike() then return end
        end -- End Action List - Ascendance
    -- Action List - Buffs
        local function actionList_Buffs()
        -- Rockbiter
            -- rockbiter,if=talent.landslide.enabled&!buff.landslide.up
            if talent.landslide and not buff.landslide.exists() then
                if cast.rockbiter() then return end
            end
        -- Fury of Air
            -- fury_of_air,if=!ticking&maelstrom>22
            if not buff.furyOfAir.exists() and power > 22 then
                if cast.furyOfAir() then return end
            end
        -- Crash Lightning
            -- crash_lightning,if=artifact.alpha_wolf.rank()&prev_gcd.1.feral_spirit
            if artifact.alphaWolf.enabled() and lastSpell == spell.feralSpirit then
                if cast.crashLightning() then return end
            end
        -- Flametongue
            -- flametongue,if=!buff.flametongue.up
            if not buff.flametongue.exists() then
                if cast.flametongue() then return end
            end
        -- Frostbrand
            -- frostbrand,if=talent.hailstorm.enabled&!buff.frostbrand.up&variable.furyCheck45
            if talent.hailstorm and not buff.frostbrand.exists() and furyCheck45 then
                if cast.frostbrand() then return end
            end
        -- Flametongue
            -- flametongue,if=buff.flametongue.remains<6+gcd&cooldown.doom_winds.remains<gcd*2
            if buff.flametongue.remain() < 6 + gcd and cd.doomWinds.remain() < gcd * 2 then
                if cast.flametongue() then return end
            end
        -- Frostbrand
            -- frostbrand,if=talent.hailstorm.enabled&buff.frostbrand.remains<6+gcd&cooldown.doom_winds.remains<gcd*2
            if talent.hailstorm and buff.frostbrand.remain() < 6 + gcd and cd.doomWinds.remain() < gcd * 2 then
                if cast.frostbrand() then return end
            end
        end -- End Action List - Buffs
    -- Action List - Core
        local function actionList_Core()
        -- Earthen Spike
            -- earthen_spike,if=variable.furyCheck25
            if furyCheck25 then
                if cast.earthenSpike() then return end
            end
        -- Crash Lightning
            -- crash_lightning,if=!buff.crash_lightning.up&active_enemies>=2
            if not buff.crashLightning.exists and ((mode.rotation == 1 and crashedEnemies >= 2) or mode.rotation == 2) then
                if cast.crashLightning() then return end
            end
        -- Windsong
            -- windsong
            if cast.windsong() then return end
        -- Crash Lightning
            -- crash_lightning,if=active_enemies>=8|(active_enemies>=6&talent.crashing_storm.enabled)
            if ((mode.rotation == 1 and (crashedEnemies >= 8 or (crashedEnemies >= 6 and talent.crashingStorm))) or mode.rotation == 2) then
                if cast.crashLightning() then return end
            end
        -- Windstrike
            -- windstrike
            if buff.ascendance.exists() then
                if cast.windstrike() then return end
            end
        -- Stormstrike
            -- stormstrike,if=buff.stormbringer.up&variable.furyCheck25
            if not buff.ascendance.exists and buff.stormbringer.exists() and furyCheck25 then
                if cast.stormstrike() then return end
            end
        -- Crash Lightning
            -- crash_lightning,if=active_enemies>=4|(active_enemies>=2&talent.crashing_storm.enabled)
            if ((mode.rotation == 1 and (crashedEnemies >= 4 or (crashedEnemies >= 2 and talent.crashingStorm))) or mode.rotation == 2) then
                if cast.crashLightning() then return end
            end
        -- Lightning Bolt
            -- lightning_bolt,if=talent.overcharge.enabled&variable.furyCheck45&maelstrom>=40
            if talent.overcharge and furyCheck45 and power >= 40 then
                if cast.lightningBolt() then return end
            end
        -- Stormstrike
            -- stormstrike,if=(!talent.overcharge.enabled&variable.furyCheck45)|(talent.overcharge.enabled&variable.furyCheck80)
            if not buff.ascendance.exists() and ((not talent.overcharge and furyCheck45) or (talent.overcharge and furyCheck80)) then
                if cast.stormstrike() then return end
            end
        -- Frostbrand
            -- frostbrand,if=variable.akainuAS
            if akainuAS then
                if cast.frostbrand() then return end
            end
        -- Lava Lash
            -- lava_lash,if=buff.hot_hand.react&((variable.akainuEquipped&buff.frostbrand.up)|!variable.akainuEquipped)
            if buff.hotHand.exists() and ((akainuEquiped and buff.frostbrand.exists()) or not akainuEquiped) then
                if cast.lavaLash() then return end
            end
        -- Sundering
            -- sundering,if=active_enemies>=3
            if ((mode.rotation == 1 and #enemies.yards8 >= 3) or mode.rotation == 2) and getDistance(units.dyn8) < 8 then
                if cast.sundering() then return end
            end
        -- Crash Lightning
            -- crash_lightning,if=active_enemies>=3|variable.LightningCrashNotUp|variable.alphaWolfCheck
            if ((mode.rotation == 1 and (crashedEnemies >= 3 or noLightningCrash or alphaWolfCheck)) or mode.rotation == 2) then
                if cast.crashLightning() then return end
            end
        end -- End Action List - Core
    -- Action List - Filler
        local function actionList_Filler()
        -- Rockbiter
            -- rockbiter,if=maelstrom<120
            if power < 120 then
                if cast.rockbiter() then return end
            end
        -- Flametongue
            -- flametongue,if=buff.flametongue.remains<4.8
            if buff.flametongue.remain() < 4.8 then
                if cast.flametongue() then return end
            end
        -- Crash Lightning
            -- crash_lightning,if=(talent.crashing_storm.enabled|active_enemies>=2)&debuff.earthen_spike.up&maelstrom>=40&variable.OCPool60
            if (talent.crashingStorm or ((mode.rotation == 1 and crashedEnemies >= 2) or mode.rotation == 2)) and debuff.earthenSpike.exists(units.dyn5) and power >= 40 and ocPool60 then
                if cast.crashLightning() then return end
            end
        -- Frostbrand
            -- frostbrand,if=talent.hailstorm.enabled&buff.frostbrand.remains<4.8&maelstrom>40
            if talent.hailstorm and buff.frostbrand.remain() < 4.8 and power > 40 then
                if cast.frostbrand() then return end
            end
            -- frostbrand,if=variable.akainuEquipped&!buff.frostbrand.up&maelstrom>=75
            if akainuEquiped and not buff.frostbrand.exists() and power >= 75 then
                if cast.frostbrand() then return end
            end
        -- Sundering
            -- sundering
            if cast.sundering() then return end
        -- Lava Lash
            -- lava_lash,if=maelstrom>=50&variable.OCPool70&variable.furyCheck80
            if power >= 50 and ocPool70 and furyCheck80 then
                if cast.lavaLash() then return end
            end
        -- Rockbiter
            -- rockbiter
            if cast.rockbiter() then return end
        -- Crash Lightning
            -- crash_lightning,if=(maelstrom>=65|talent.crashing_storm.enabled|active_enemies>=2)&variable.OCPool60&variable.furyCheck45
            if ((mode.rotation == 1 and (power >= 60 or talent.crashingStorm or crashedEnemies >= 2)) or mode.rotation == 2) and ocPool45 then
                if cast.crashLightning() then return end
            end
        -- Flametongue
            -- flametongue
            if cast.flametongue() then return end
        end -- End Action List - Filler
    -- Action List - Opener
        local function actionList_Opener()
        -- Rockbiter
            -- rockbiter,if=maelstrom<15&time<2
            if power < 15 and combatTime < 2 then
                if cast.rockbiter() then return end
            else
                StartAttack()
            end
        end -- End Action List - Opener
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then
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
            -- Lightning Shield
                -- /lightning_shield
                if cast.lightningShield() then return end
                if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
            -- Potion
                    -- potion,name=prolonged_power,if=feral_spirit.remain()s>5
                    if isChecked("Potion") and canUse(142117) and inRaid then
                        if feralSpiritRemain > 5 and not buff.prolongedPower.exists() then
                            useItem(142117)
                        end
                    end
                end -- End Pre-Pull
                if isValidUnit("target") then
            -- Feral Lunge
                    if isChecked("Feral Lunge") then
                        if cast.feralLunge("target") then return end
                    end
            -- Lightning Bolt
                    if getDistance("target") >= 10 and isChecked("Lightning Bolt Out of Combat") and not talent.overcharge
                        and (not isChecked("Feral Lunge") or not talent.feralLunge or cd.feralLunge.remain() > gcd or not castable.feralLunge)
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
        elseif (inCombat and profileStop==true) or pause() or IsMounted() or IsFlying() or mode.rotation==4 then
            if buff.furyOfAir.exists() then
                cast.furyOfAir()
            end
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
            if inCombat and isValidUnit(units.dyn10) and profileStop==false then
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                if getOptionValue("APL Mode") == 1 then
            -- Feral Lunge
                    if isChecked("Feral Lunge") and hasThreat("target") then
                        if cast.feralLunge("target") then return end
                    end
            -- Start Attack
                    if getDistance("target") <= 5 then
                        StartAttack()
                    end
            -- Call Action List - Opener
                    -- call_action_list,name=opener
                    if actionList_Opener() then return end
            -- Call Action List - Ascendance
                    -- call_action_list,name=asc,if=buff.ascendance.up
                    if buff.ascendance.exists() then
                        if actionList_Ascendance() then return end
                    end
            -- Call Action List - Buffs
                    -- call_action_list,name=buffs
                    if actionList_Buffs() then return end
            -- Call Action List - Cooldowns
                    -- call_action_list,name=CDs
                    if actionList_Cooldowns() then return end
            -- Call Action List - Core
                    -- call_action_list,name=core
                    if actionList_Core() then return end
            -- Call Action List - Filler
                    -- call_action_list,name=filler
                    if actionList_Filler() then return end
                end -- End SimC APL
    ----------------------
    --- AskMrRobot APL ---
    ----------------------
                if getOptionValue("APL Mode") == 2 then
            -- Fury of Air - Off
                    -- if TargetsInRadius(FuryOfAir) = 1
                    if buff.furyOfAir.exists() and #enemies.yards8 < 2 then
                        if cast.furyOfAir() then return end
                    end
            -- Boulderfist
                    -- if BuffRemainingSec(BoulderfistEnhance) <= GlobalCooldownSec or ChargesRemaining(Boulderfist) = SpellCharges(Boulderfist)
                    if buff.boulderfist.remain() <= gcd or charges.boulderfist.count() == charges.boulderfist.max() then
                        if cast.boulderfist() then return end
                    end
            -- Rockbiter
                    -- if BuffRemainingSec(Landslide) <= GlobalCooldownSec and HasTalent(Landslide)
                    if buff.landslide.remain() <= gcd and talent.landslide then
                        if cast.rockbiter() then return end
                    end
            -- Frostbrand
                    -- if BuffRemainingSec(Frostbrand) <= GlobalCooldownSec and HasTalent(Hailstorm)
                    if buff.frostbrand.remain() <= gcd and talent.hailstorm then
                        if cast.frostbrand() then return end
                    end
            -- Windsong
                    if cast.windsong() then return end
            -- Doom Winds
                    if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and getDistance("target") < 5 then
                        if cast.doomWinds() then return end
                    end
            -- Ascendance
                    if useCDs() and lastSpell == spell.doomWinds then
                        if cast.ascendance() then return end
                    end
            -- Earthen Spike
                    if cast.earthenSpike() then return end
            -- Frostbrand
                    -- if HasTalent(Hailstorm) and BuffRemainingSec(Frostbrand) <= 0.3 * BuffDurationSec(Frostbrand)
                    if talent.hailstorm and buff.frostbrand.refresh() then
                        if cast.frostbrand() then return end
                    end
            -- Windstike
                    if cast.windstrike() then return end
            -- Stormstrike
                    if cast.stormstrike() then return end
            -- Crash Lightning
                    -- if (HasTalent(CrashingStorm) and TimerSecRemaining(CrashingStormTimer) = 0) or TargetsInRadius(CrashLightning) > 3 or (ArtifactTraitRank(GatheringStorms) > 0 and not HasBuff(GatheringStorms))
                    if (talent.crashingStorm and crashingStormTimer == 0) or getEnemiesInCone(7,100) > 3 or (artifact.gatheringStorms.enabled() and not buff.gatheringStorms.exists()) then
                        if cast.crashLightning() then return end
                    end
            -- Flame Tongue
                    -- if BuffRemainingSec(Flametongue) <= 0.3 * BuffDurationSec(Flametongue)
                    if buff.flametongue.refresh() then
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
                    if buff.hotHand.exists() or power > 40 then
                        if cast.lavaLash() then return end
                    end
            -- Boulderfist
                    if cast.boulderfist() then return end
            -- Rockbiter
                    if cast.rockbiter() then return end
                end
            end --End In Combat
        end --End Rotation Logic
        -- br.debug.cpu.cBuilder.profile = debugprofilestop()-startTime or 0
    -- end -- End Timer
end -- End runRotation
local id = 263
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

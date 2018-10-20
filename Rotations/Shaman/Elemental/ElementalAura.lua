local rotationName = "Aura" -- Change to name of profile listed in options drop down

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
            --Ghost Wolf
            br.ui:createCheckbox(section,"Ghost Wolf")
            -- Purge
            br.ui:createCheckbox(section,"Purge")
            -- Water Walking
            br.ui:createCheckbox(section, "Water Walking")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            br.ui:createCheckbox(section,"Racial", "Check to use Racials")
            br.ui:createCheckbox(section,"Trinkets","Check to use Trinkets when Fire/Storm Elemental is Out, during AoE or during Ascendance")
            br.ui:createCheckbox(section,"Storm Elemental/Fire Elemental", "Check to use Storm/Fire Elemental")
            br.ui:createCheckbox(section,"Earth Elemental", "Check to use Earth Elemental")
            br.ui:createCheckbox(section, "Ascendance", "Check to use Ascendance")
        br.ui:checkSectionState(section)
        -------------------------
        ---  TARGET OPTIONS   ---  -- Define Target Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Targets")
            br.ui:createSpinner(section, "Maximum FlameShock Targets", 2, 1, 10, 1, "|cffFFFFFFSet to maximum number of targets to use FlameShock in AoE. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinner(section, "Maximum LB Targets", 2, 1, 10, 1, "|cffFFFFFFSet to maximum number of targets to use Lava Burst in AoE. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinner(section, "Maximum EB Targets", 2, 1, 10, 1, "|cffFFFFFFSet to maximum number of targets to use Elemental Blast in AoE. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinner(section, "SK Targets", 3, 1, 10, 1, "|cffFFFFFFSet to desired number of targets needed to use Storm Keeper. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinner(section, "LMT Targets", 3, 1, 10, 1, "|cffFFFFFFSet to desired number of targets needed to use Liquid Magma Totem. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinner(section, "Earthquake Targets", 3, 1, 10, 1, "|cffFFFFFFSet to desired number of targets needed to use Earthquake. Min: 1 / Max: 10 / Interval: 1" )
            br.ui:createSpinner(section, "Lava Beam Targets", 3, 1, 10, 1, "|cffFFFFFFSet to desired number of targets needed to use Lava Beam. Min: 1 / Max: 10 / Interval: 1" )
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
        -- Capacitor Surge Totem
            br.ui:createSpinner(section, "Capacitor Totem - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Capacitor Totem - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
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
    if br.timer:useTimer("debugElemental", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
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
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk        
        local php                                           = br.player.health
        local power                                         = br.player.power.maelstrom.amount()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttm                                           = br.player.timeToMax
        local units                                         = br.player.units
        
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        enemies.get(10)
        enemies.get(20) --enemies.yards20
        enemies.get(30) --enemies.yards30 = br.player.enemies(30)
        enemies.get(40) --enemies.yards40 
        enemies.get(8,"target") -- enemies.yards8t

--------------------
--- Action Lists ---
--------------------
        -- Action List - Extras
        local function actionList_Extra()
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
            if isChecked("Ghost Wolf") and cast.able.ghostWolf() and not (IsMounted() or IsFlying()) then
                if ((#enemies.yards20 == 0 and not inCombat) or (#enemies.yards10 == 0 and inCombat)) and isMoving("player") and not buff.ghostWolf.exists() then
                    if cast.ghostWolf() then return true end
                end
            end
        -- Water Walking
            if falling > 1.5 and buff.waterWalking.exists() then
                CancelUnitBuffID("player", spell.waterWalking)
            end
            if isChecked("Water Walking") and cast.able.waterWalking() and not inCombat and IsSwimming() and not buff.waterWalking.exists() then
                if cast.waterWalking() then return true end
            end
        end -- End Action List - Extras
        --Action List PreCombat
        local function actionList_PreCombat()
            prepullOpener = inRaid and isChecked("Pre-pull Opener") and pullTimer <= getOptionValue("Pre-pull Opener") 
            -- Totem Mastery
            if prepullOpener then
                if cast.totemMastery() then return true end
            end
        end
        -- Action List - Defensive
        local function actionList_Defensive()
            -- Purge
            if isChecked("Purge") and cast.able.purge() and canDispel("target",spell.purge) and not isBoss() and GetObjectExists("target") then
                if cast.purge() then return true end
            end
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
                if isChecked("Gift of the Naaru") and cast.able.giftOfTheNaaru() and php <= getOptionValue("Gift of the Naaru") and php > 0 and race == "Draenei" then
                    if cast.giftOfTheNaaru() then return true end
                end
        -- Ancestral Spirit
                if isChecked("Ancestral Spirit") then
                    if getOptionValue("Ancestral Spirit")==1 and cast.able.ancestralSpirit("target") and hastar and playertar and deadtar then
                        if cast.ancestralSpirit("target","dead") then return true end
                    end
                    if getOptionValue("Ancestral Spirit")==2 and cast.able.ancestralSpirit("mouseover") and hasMouse and playerMouse and deadMouse then
                        if cast.ancestralSpirit("mouseover","dead") then return true end
                    end
                end
        -- Astral Shift
                if isChecked("Astral Shift") and cast.able.astralShift() and php <= getOptionValue("Astral Shift") and inCombat then
                    if cast.astralShift() then return true end
                end
        -- Cleanse Spirit
                if isChecked("Cleanse Spirit") then
                    if getOptionValue("Cleanse Spirit")==1 and cast.able.cleanseSpirit("player") and canDispel("player",spell.cleanseSpirit) then
                        if cast.cleanseSpirit("player") then return; end
                    end
                    if getOptionValue("Cleanse Spirit")==2 and cast.able.cleanseSpirit("target") and canDispel("target",spell.cleanseSpirit) then
                        if cast.cleanseSpirit("target") then return true end
                    end
                    if getOptionValue("Cleanse Spirit")==3 and cast.able.cleanseSpirit("mouseover") and canDispel("mouseover",spell.cleanseSpirit) then
                        if cast.cleanseSpirit("mouseover") then return true end
                    end
                end
        -- Earthen Shield
                if isChecked("Earth Shield") and cast.able.earthShield() and not buff.earthShield.exists() then
                    if cast.earthShield() then return true end
                end
        -- Healing Surge
                if isChecked("Healing Surge") and cast.able.healingSurge()
                    and ((inCombat and ((php <= getOptionValue("Healing Surge") / 2 and power > 20)
                        or (power >= 90 and php <= getOptionValue("Healing Surge")))) or (not inCombat and php <= getOptionValue("Healing Surge") and not moving))
                then
                    if cast.healingSurge() then return true end
                end
        -- Capacitor Totem
                if isChecked("Capacitor Totem - HP") and cast.able.capacitorTotem() and php <= getOptionValue("Capacitor Totem - HP") and inCombat and #enemies.yards5 > 0 then
                    if cast.capacitorTotem("player","ground") then return true end
                end
                if isChecked("Capacitor Totem - AoE") and cast.able.capacitorTotem() and #enemies.yards5 >= getOptionValue("Capacitor Totem - AoE") and inCombat then
                    if cast.capacitorTotem("best",nil,getOptionValue("Capacitor Totem - AoE"),8) then return true end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
        -- Action List - Interrupts
        local function actionList_Interrupt()
            if useInterrupts() then
                for i=1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        -- Wind Shear
                        if isChecked("Wind Shear") and cast.able.windShear(thisUnit) then
                            if cast.windShear(thisUnit) then return true end
                        end
        -- Hex
                        if isChecked("Hex") and cast.able.hex(thisUnit) then
                            if cast.hex(thisUnit) then return true end
                        end
        -- Capacitor Totem
                        if isChecked("Capacitor Totem") and cast.able.capacitorTotem(thisUnit) and cd.windShear.remain() > gcd then
                            if hasThreat(thisUnit) and not isMoving(thisUnit) and ttd(thisUnit) > 7 then
                                if cast.capacitorTotem(thisUnit,"ground") then return true end
                            end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
        -- Action List Simc AoE
        local function actionList_AoE()
            --Storm Keeper
            --actions.aoe=stormkeeper,if=talent.stormkeeper.enabled
            if talent.stormKeeper and #enemies.yards40 >= getValue("SK Targets") then
                if cast.stormKeeper() then return true end
            end
            -- Ascendance
            --actions.aoe+=/ascendance,if=talent.ascendance.enabled&(talent.storm_elemental.enabled&cooldown.storm_elemental.remains<120&cooldown.storm_elemental.remains>15|!talent.storm_elemental.enabled)
            if isChecked("Ascendance") and talent.ascendance and ((talent.stormElemental and cd.stormElemental.remain()<120 and cd.stormElemental.remain()> 15) or not talent.stormElemental) and useCDs then
                if cast.ascendance() then return true end
            end
            -- Liquid Magma Totem
            --actions.aoe+=/liquid_magma_totem,if=talent.liquid_magma_totem.enabled
            if talent.liquidMagmaTotem and useCDs and #enemies.yards40 >= getValue("LMT Targets") then
                if cast.liquidMagmaTotem("target") then return true end
            end
            -- Flame Shock
            --actions.aoe+=/flame_shock,if=spell_targets.chain_lightning<4,target_if=refreshable
            if #enemies.yards40 <= getValue("Maximum FlameShock Targets") then
                for i=1, #enemies.yards40 do
                    if debuff.flameShock.remain(enemies.yards40[i].unit) < 5.4 then
                        if cast.flameShock() then return true end
                    end
                end
            end
            -- Earthquake
            --actions.aoe+=/earthquake
            if #enemies.yards8t >= getValue("Earthquake Targets") then
                if cast.earthquake("target","ground") then return true end
            end
            -- Lava Burst (Instant)
            --actions.aoe+=/lava_burst,if=(buff.lava_surge.up|buff.ascendance.up)&spell_targets.chain_lightning<4
            if buff.lavaSurge.exists()  and #enemies.yards40 <= getValue("Maximum LB Targets") then
                if cast.lavaBurst() then return true end
            end
            -- Elemental Blast
            --actions.aoe+=/elemental_blast,if=talent.elemental_blast.enabled&spell_targets.chain_lightning<4
            if talent.elementalBlast and #enemies.yards40 <= getValue("Maximum EB Targets") then
                if cast.elementalBlast() then return true end
            end
            -- Lava Beam
            --actions.aoe+=/lava_beam,if=talent.ascendance.enabled
            if buff.ascendance.exists() and #enemies.yards40 >= getValue("Lava Beam Targets") then
                if cast.lavaBeam() then return true end
            end             
            -- Chain Lightning
            --actions.aoe+=/chain_lightning
            if cast.chainLightning() then return end
            -- Lava Burst (Moving)
            --actions.aoe+=/lava_burst,moving=1,if=talent.ascendance.enabled
            if buff.lavaSurge.exists() and isMoving then
                if cast.lavaBurst() then return true end
            end
            -- Flame Shock (Moving)
            --actions.aoe+=/flame_shock,moving=1,target_if=refreshable
            if isMoving then
                for i=1, #enemies.yards40 do
                    if debuff.flameShock.remain(enemies.yards40[i].unit) < 5.4 then
                        if cast.flameShock() then return true end
                    end
                end
            end                                
            -- Frost Shock (Moving)
            --actions.aoe+=/frost_shock,moving=1
            if cast.frostShock() then return true end
        end

        -- Action List Simc ST
        local function actionList_ST()
            --Flame Shock
            --actions.single_target=flame_shock,if=!ticking|dot.flame_shock.remains<=gcd|talent.ascendance.enabled&dot.flame_shock.remains<(cooldown.ascendance.remains+buff.ascendance.duration)&cooldown.ascendance.remains<4&(!talent.storm_elemental.enabled|talent.storm_elemental.enabled&cooldown.storm_elemental.remains<120)
            if not debuff.flameShock.exists("target")  then
                    if cast.flameShock() then return true end
            end
            --Ascendance
            --actions.single_target+=/ascendance,if=talent.ascendance.enabled&(time>=60|buff.bloodlust.up)&cooldown.lava_burst.remains>0&!talent.storm_elemental.enabled
            if isChecked("Ascendance") and talent.ascendance and useCDs and cd.lavaBurst.remain() > 0 and (not talent.stormElemental or (talent.stormElemental and cd.stormElemental.remain()<= 120)) then
                if cast.ascendance() then return true end
            end
            -- Elemental Blast
            --# Don't use Elemental Blast if you could cast a Master of the Elements empowered Earth Shock instead.
            --actions.single_target+=/elemental_blast,if=talent.elemental_blast.enabled&(talent.master_of_the_elements.enabled&buff.master_of_the_elements.up&maelstrom<60|!talent.master_of_the_elements.enabled)
            if talent.elementalBlast and ((talent.masterOfTheElements and buff.masterOfTheElements.exists() and power < 60) or not talent.masterOfTheElements) then
                if cast.elementalBlast() then return true end
            end
            --Storm Keeper
            --# Keep SK for large or soon add waves.
            --actions.single_target+=/stormkeeper,if=talent.stormkeeper.enabled&(raid_event.adds.count<3|raid_event.adds.in>50)
            if useCDs and #enemies.yards8t >= getValue("SK Targets") and talent.stormKeeper then
                if cast.stormKeeper() then return true end
            end
            -- Liquid Magma Totem
            --actions.single_target+=/liquid_magma_totem,if=talent.liquid_magma_totem.enabled&(raid_event.adds.count<3|raid_event.adds.in>50)
            if useCDs and #enemies.yards8t >= getValue("LMT Targets") and talent.liquidMagmaTotem then
                if cast.liquidMagmaTotem() then return true end
            end
            
            -- Earthquake
            --actions.single_target+=/earthquake,if=active_enemies>1&spell_targets.chain_lightning>1&!talent.exposed_elements.enabled
            if not talent.exposedElements and #enemies.yards8t >= getValue("Earthquake Targets")  then
                if cast.earthquake("target","ground") then return true end
            end
            
            -- Lightning Bolt (Exposed Elements)
            --# Use the debuff before casting Earth Shock again.
            --actions.single_target+=/lightning_bolt,if=talent.exposed_elements.enabled&debuff.exposed_elements.up&maelstrom>=60&!buff.ascendance.up
            if talent.exposedElements and debuff.exposedElements.exists("target") and power >= 60 and not buff.ascendance.exists() then
                if cast.lightningBolt() then return true end
            end
            
            -- Earth Shock
            --# If possible, use Earth Shock with Master of the Elements.
            --actions.single_target+=/earth_shock,if=talent.master_of_the_elements.enabled&(buff.master_of_the_elements.up|maelstrom>=92)|!talent.master_of_the_elements.enabled
            if (talent.masterOfTheElements and (cast.last.lavaBurst() and power >= 92)) or not talent.masterOfTheElements then
                if cast.earthShock() then return true end
            end
            
            --Lava Burst
            --actions.single_target+=/lava_burst,if=cooldown_react|buff.ascendance.up
            if cd.lavaBurst.remain() <= gcdMax or buff.ascendance.exists() then
                if cast.lavaBurst() then return true end
            end
            --Flame Shock (Refresh)
            --actions.single_target+=/flame_shock,target_if=refreshable
            if debuff.flameShock.remain("target") < 5.4 then
                if cast.flameShock() then return true end
            end
            -- Totem Mastery            
            --actions.single_target+=/totem_mastery,if=talent.totem_mastery.enabled&(buff.resonance_totem.remains<6|(buff.resonance_totem.remains<(buff.ascendance.duration+cooldown.ascendance.remains)&cooldown.ascendance.remains<15))
            if talent.totemMastery and (not buff.resonanceTotem.exists() or buff.resonanceTotem.remain() < 6 or (buff.resonanceTotem.remain() < (buff.ascendance.duration() + cd.ascendance.remain()) and cd.ascendance.remain() < 15)) then
                if cast.totemMastery() then return true end
            end
            -- Frost Shock
            --actions.single_target+=/frost_shock,if=talent.icefury.enabled&buff.icefury.up
            if talent.iceFury and buff.iceFury.exists() then
                if cast.frostShock() then return true end
            end
            -- Ice Fury
            --actions.single_target+=/icefury,if=talent.icefury.enabled
            if talent.iceFury then
                if cast.iceFury() then return true end
            end
            -- Lava Beam
            --actions.single_target+=/lava_beam,if=talent.ascendance.enabled&active_enemies>1&spell_targets.lava_beam>1
            if talent.ascendance and buff.ascendance.exists() and #enemies.yards40 >= getValue("Lava Beam Targets") then
                if cast.lavaBeam() then return true end
            end
            -- Chain Lightning
            --actions.single_target+=/chain_lightning,if=active_enemies>1&spell_targets.chain_lightning>1
            if #enemies.yards40 > 1 then
                if cast.chainLightning() then return true end
            end
            -- Lightning Bolt            
            --actions.single_target+=/lightning_bolt
            if cast.lightningBolt() then return true end
            -- Moving Flame Shock
            --actions.single_target+=/flame_shock,moving=1,target_if=refreshable
            if isMoving and debuff.flameShock.remain("target") < 5.4 then
                if cast.flameShock() then return true end
            end
            -- Frost Shock
            --# Frost Shock is our movement filler.
            --actions.single_target+=/frost_shock,moving=1
            if isMoving then
                if cast.frostShock() then return true end
            end
        end

        -- Action List AMR()
        local function actionList_AMR()
            local fireEleTime = fireEleTime or nil;
            local stormEleTime = stormEleTime or nil;
            -- Use Potion(To do)
            -- Racial Buffs
            if (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") and isChecked("Racial") and useCDs
            then
                if race == "LightforgedDraenei" then
                    if cast.racial("target","ground") then return true end
                else
                    if cast.racial("player") then return true end
                end
            end
            --Trinkets
            if isChecked("Trinkets") and useCDs and (buff.ascendance.exists("player") or #enemies.yards40 >= 3 or cast.last.fireElemental() or cast.last.stormElemental() ) then
                if canUse(13) then
                    useItem(13)
                end
                if canUse(14) then
                    useItem(14)
                end
            end
            -- Storm Elemental
            if isChecked("Storm Elemental/Fire Elemental") and useCDs and talent.stormElemental then
                if cast.stormElemental() then
                    stormEleTime = GetTime()
                    return true 
                end
            end
            -- Fire Elemental
            if isChecked("Storm Elemental/Fire Elemental") and useCDs then
                if cast.fireElemental() then
                    fireEleTime = GetTime()
                    return true 
                end
            end
            --Earth Elemental
            if not talent.primalElementalist then
                if isChecked("Earth Elemental") and useCDs then
                    if cast.earthElemental() then return true end
                end
            else
                if useCDs and isChecked("Earth Elemental") and ((talent.stormElemental and (GetTime - stormEleTime >= 35)) or not talent.stormElemental) and (GetTime - fireEleTime >= 35) and (cd.fireElemental.remain > 60 and (not talent.stormElemental or (talent.stormElemental and cd.stormElemental.remain > 60))) then
                    if cast.earthElemental() then return true end
                end
            end
            -- Flame Shock
            if debuff.flameShock.remain("target") < 2 then
                if cast.flameShock("target") then return true end
            end
            -- Totem Mastery
            if buff.emberTotem.remain() < 0.3 * buff.emberTotem.duration() then
                if cast.totemMastery() then return true end
            end
            -- Earthquake
            if #enemies.yards8t >= getValue("Earthquake Targets") then
                if cast.earthquake("target","ground") then return true end
            end
            -- Earth Shock
            if (not talent.masterOfTheElements or buff.masterOfTheElements.exists()) then
                if cast.earthShock() then return true end
            end
            -- Liquid Magma Totem
            if useCDs and #enemies.yards8t >= getValue("LMT Targets") then
                if cast.liquidMagmaTotem("target") then return true end
            end
            -- Stormkeeper
            if useCDs and #enemies.yards8t >= getValue("SK Targets") and talent.stormKeeper then
                if cast.stormKeeper() then return true end
            end
            -- Elemental Blast
            if talent.elementalBlast then
                if cast.elementalBlast() then return true end
            end
            -- Lava Beam (3+ Targets)
            if #enemies.yards40 >= getValue("Lava Beam Targets") and buff.ascendance.exists() then
                if cast.lavaBeam() then return true end
            end
            -- Chain Lightning (3+ Targets)
            if #enemies.yards40 >= 3 and not buff.ascendance.exists() then
                if cast.chainLightning() then return true end
            end
            -- Lava Burst
            if debuff.flameShock.remain("target") > getCastTime(spell.lavaBurst) then
                if cast.lavaBurst() then return true end
            end
            -- Ice Fury
            if talent.iceFury then
                if cast.iceFury() then return true end
            end
            -- Frost Shock
            if buff.iceFury.exists() then
                if cast.frostShock() then return true end
            end
            -- Flame Shock (Dot Refresh)
            if debuff.flameShock.remain("target") < 5.4 then
                if cast.flameShock() then return true end
            end
            -- Ascendance
            if isChecked("Ascendance") and useCDs and cd.lavaBurst.remain() > 0 then
                if cast.ascendance() then return true end
            end
            -- Chain Lightning
            if #enemies.yards40 > 1 and not buff.ascendance.exists() then
                if cast.chainLightning() then return true end
            end
            -- Lightning Bolt
            if cast.lightningBolt() then return true end
            -- Frost Shock (Moving)
            if isMoving then
                if cast.frostShock() then return true end
            end
        end
-----------------
--- Rotations ---
-----------------
        -- Pause
        if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or mode.rotation == 4 then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat then
                actionList_PreCombat()
                actionList_Extra()
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat then
                actionList_Interrupt()
                actionList_Defensive()
                --Simc
                if getOptionValue("APL Mode") == 1 then
                            -- Racial Buffs
                    if (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") and isChecked("Racial") and useCDs
                    then
                        if race == "LightforgedDraenei" then
                            if cast.racial("target","ground") then return true end
                        else
                            if cast.racial("player") then return true end
                        end
                    end
                    --Trinkets
                    if isChecked("Trinkets") and useCDs and (buff.ascendance.exists("player") or #enemies.yards40 >= 3 or cast.last.fireElemental() or cast.last.stormElemental() ) then
                        if canUse(13) then
                            useItem(13)
                        end
                        if canUse(14) then
                            useItem(14)
                        end
                    end
                    --actions+=/totem_mastery,if=talent.totem_mastery.enabled&buff.resonance_totem.remains<2
                    if talent.totemMastery and (not buff.resonanceTotem.exists() or buff.resonanceTotem.remain()< 2) then
                        if cast.totemMastery() then return true end
                    end
                    --actions+=/fire_elemental,if=!talent.storm_elemental.enabled
                    if isChecked("Storm Elemental/Fire Elemental") and not talent.stormElemental and useCDs then
                        if cast.fireElemental() then return true end
                    else    
                        if isChecked("Storm Elemental/Fire Elemental") and useCDs then
                            if cast.stormElemental() then return true end
                        end
                    end
                    --actions+=/earth_elemental,if=cooldown.fire_elemental.remains<120&!talent.storm_elemental.enabled|cooldown.storm_elemental.remains<120&talent.storm_elemental.enabled
                    if useCDs and isChecked("Earth Elemental") and (cd.fireElemental.remain() < 120 and not talent.stormElemental) or (cd.stormElemental.remain() < 120 and talent.stormElemental) then
                        if cast.earthElemental() then return true end
                    end
                    if (#enemies.yards40 > 2 and (mode.rotation ~= 3 and mode.rotation ~= 2)) or mode.rotation == 2 then
                        if actionList_AoE() then return true end
                    else
                        if (#enemies.yards40 <= 2 and (mode.rotation ~= 2 and mode.rotation ~= 3)) or mode.rotation == 3 then
                            if actionList_ST() then return true end
                        end
                    end
                --AMR
                else 
                    if getOptionValue("APL Mode") == 2 then
                        if actionList_AMR() then return true end
                    end
                end
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation 
local id = 262 --Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

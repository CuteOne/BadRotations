local rotationName = "Kuukuu"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.blackoutStrike },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.breathOfFire },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.tigerPalm },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.effuse}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.fortifyingBrew },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.fortifyingBrew },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.fortifyingBrew }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dampenHarm },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dampenHarm }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.spearHandStrike },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.spearHandStrike }
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
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
        -- APL
        --    br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Provoke
            br.ui:createCheckbox(section, "Provoke","|cffFFFFFFAuto Provoke usage.")
        -- Opener
            br.ui:createCheckbox(section, "Opener","|cffFFFFFFBest Ironskin Uptime at Start.")            
        -- Pre-Pull Timer
        --    br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Purifying Brew
            br.ui:createDropdown(section, "Purifying Brew",  {"|cff00FF00Both","|cffFF0000Heavy Only"}, 1, "|cffFFFFFFStagger to cast on")
        -- Resuscitate
            br.ui:createDropdown(section, "Resuscitate", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
        -- Flask / Crystal
            br.ui:createCheckbox(section,"Flask / Crystal")
        -- Potion
            br.ui:createCheckbox(section,"Potion")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Touch of the Void
            br.ui:createCheckbox(section,"Touch of the Void")
        -- Chi Burst
        	br.ui:createSpinnerWithout(section, "Chi Burst Targets",  1,  1,  10,  1)
        -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        -- Exploding Keg Targets
        	br.ui:createSpinnerWithout(section, "Exploding Keg Targets",  2,  1,  10,  1,  "|cffFFFFFFAmount of Targets to cast Exploding Keg when enabled above.")        
        -- Breath of Fire
        	br.ui:createSpinnerWithout(section, "Breath of Fire Targets",  1,  1,  10,  1)
        -- Keg Smash
        	br.ui:createSpinnerWithout(section, "Keg Smash Targets",  1,  1,  10,  1)
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
         section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        -- Effuse
            br.ui:createSpinner(section, "Effuse",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Detox
            br.ui:createCheckbox(section,"Detox")
        -- Healing Elixir
            br.ui:createSpinner(section, "Healing Elixir", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Leg Sweep
            br.ui:createSpinner(section, "Leg Sweep - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Leg Sweep - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
        -- Fortifying Brew
            br.ui:createSpinner(section, "Fortifying Brew",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Dampen Harm
            br.ui:createSpinner(section, "Dampen Harm",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Expel Harm
            br.ui:createSpinner(section, "Expel Harm",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Expel Harm Orbs
        	br.ui:createSpinnerWithout(section, "Expel Harm Orbs",  3,  0,  15,  1,  "|cffFFFFFFMin amount of Gift of the Ox Orbs to cast.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        --Quaking Palm
            br.ui:createCheckbox(section, "Quaking Palm")
        -- Spear Hand Strike
            br.ui:createCheckbox(section, "Spear Hand Strike")
        -- Paralysis
            br.ui:createCheckbox(section, "Paralysis")
        -- Leg Sweep
            br.ui:createCheckbox(section, "Leg Sweep")
        -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
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
    if br.timer:useTimer("debugBrewmaster", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        BurstToggle("burstKey", 0.25)

--------------
--- Locals ---
--------------
        local agility           = UnitStat("player", 2)
        local artifact          = br.player.artifact
        local baseAgility       = 0
        local baseMultistrike   = 0
        local buff              = br.player.buff
        local canFlask          = canUse(br.player.flask.wod.agilityBig)
        local cast              = br.player.cast
        local castable          = br.player.cast.debug
        local cd                = br.player.cd
        local charges           = br.player.charges
        local combatTime        = getCombatTime()
        local debuff            = br.player.debuff
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
        local enemies           = enemies or {}
        local flaskBuff         = getBuffRemain("player",br.player.flask.wod.buff.agilityBig) or 0
        local gcd               = br.player.gcd
        local glyph             = br.player.glyph
        local healthPot         = getHealthPot() or 0
        local inCombat          = br.player.inCombat
        local inRaid            = select(2,IsInInstance())=="raid"
        local inInstance        = br.player.instance=="party"
        local level             = br.player.level
        local mode              = br.player.mode
        local php               = br.player.health
        local power             = br.player.power.amount.energy
        local powgen			= br.player.power.regen
        local powerMax          = br.player.power.energy.max
        local pullTimer         = br.DBM:getPulltimer()
        local queue             = br.player.queue
        local race              = br.player.race
        local racial            = br.player.getRacial()
        local recharge          = br.player.recharge
        local regen             = br.player.power.regen
        local solo              = select(2,IsInInstance())=="none"
        local spell             = br.player.spell
        local t17_2pc           = br.player.eq.t17_2pc
        local t18_2pc           = br.player.eq.t18_2pc
        local t18_4pc           = br.player.eq.t18_4pc
        local talent            = br.player.talent
        local thp               = getHP(br.player.units(5))
        local trinketProc       = false --br.player.hasTrinketProc()
        local ttd               = getTTD(br.player.units(5))
        local ttm               = br.player.power.ttm
        local units             = units or {}
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        units.dyn5 = br.player.units(5)
        enemies.yards5 = br.player.enemies(5)
        enemies.yards8 = br.player.enemies(8)
        enemies.yards8t = br.player.enemies(8,br.player.units(8,true))
        enemies.yards30 = br.player.enemies(30)


        if opener == nil then opener = false end

        if not inCombat and not ObjectExists("target") then
            iB1 = false
            KG = false
            iB2 = false
            iB3 = false
            bOB = false
            iB4 = false
            opener = false
        end

--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        function actionList_Extras()
        -- Tiger's Lust
            if hasNoControl() or (inCombat and getDistance("target") > 10 and isValidUnit("target")) then
                if cast.tigersLust() then return end
            end
        -- Resuscitate
            if isChecked("Resuscitate") then
                if getOptionValue("Resuscitate") == 1
                    and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                then
                    if cast.resuscitate("target") then return end
                end
                if getOptionValue("Resuscitate") == 2
                    and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                then
                    if cast.resuscitate("mouseover") then return end
                end
            end
        -- Roll
            if isChecked("Roll") and getDistance("target") > 10 and isValidUnit("target") and getFacingDistance() < 5 and getFacing("player","target",10) then
                if cast.roll() then return end
            end
        -- Dummy Test
            if isChecked("DPS Testing") then
                if ObjectExists("target") then
                    if combatTime >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                    end
                end
            end
        -- Touch of the Void
            if (useCDs() or useAoE()) and isChecked("Touch of the Void") and inCombat and getDistance(units.dyn5)<5 then
                if hasEquiped(128318) then
                    if GetItemCooldown(128318)==0 then
                        useItem(128318)
                    end
                end
            end
        end -- End Action List - Extras
    -- Action List - Defensive
        function actionList_Defensive()
            if useDefensive() then
        -- Purifying Brew
                if isChecked("Purifying Brew") then
                    if getOptionValue("Purifying Brew") == 1 then
                        if (debuff.moderateStagger.exists("player") or debuff.heavyStagger.exists("player")) then
                            if cast.purifyingBrew() then return end
                        end
                    end
                    if getOptionValue("Purifying Brew") == 2 then
                        if debuff.heavyStagger.exists("player") then
                            if cast.purifyingBrew() then return end
                        end
                    end
                end
        -- Pot/Stoned
                if isChecked("Pot/Stoned") and getHP("player") <= getValue("Pot/Stoned") and inCombat then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healthPot) then
                        useItem(healthPot)
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
        -- Dampen Harm
                if isChecked("Dampen Harm") and php <= getValue("Dampen Harm") and inCombat then
                    if cast.dampenHarm() then return end
                end
        -- Diffuse Magic
                --[[if isChecked("Diffuse/Dampen") and ((php <= getValue("Diffuse Magic") and inCombat) or canDispel("player",br.player.spell.diffuseMagic)) then
                    if cast.diffuseMagic() then return end
                end]]
        -- Detox
                if isChecked("Detox") then
                    if canDispel("player",spell.detox) then
                        if cast.detox("player") then return end
                    end
                    if UnitIsPlayer("mouseover") and not UnitIsDeadOrGhost("mouseover") then
                        if canDispel("mouseover",spell.detox) then
                            if cast.detox("mouseover") then return end
                        end
                    end
                end
        -- Effuse
                if isChecked("Effuse") and ((not inCombat and php <= getOptionValue("Effuse")) --[[or (inCombat and php <= getOptionValue("Effuse") / 2)]]) then
                    if cast.effuse() then return end
                end
        -- Healing Elixir
                if isChecked("Healing Elixir") and php <= getValue("Healing Elixir") and charges.healingElixir > 1 then
                    if cast.healingElixir() then return end
                end
        -- Leg Sweep
                if isChecked("Leg Sweep - HP") and php <= getValue("Leg Sweep - HP") and inCombat and #enemies.yards5 > 0 then
                    if cast.legSweep() then return end
                end
                if isChecked("Leg Sweep - AoE") and #enemies.yards5 >= getValue("Leg Sweep - AoE") then
                    if cast.legSweep() then return end
                end
        -- Fortifying Brew
                if isChecked("Fortifying Brew") and php <= getValue("Fortifying Brew") and inCombat then
                    if cast.fortifyingBrew() then return end
                end
        --Expel Harm
                if isChecked("Expel Harm") and php <= getValue("Expel Harm") and inCombat and GetSpellCount(115027) >= getOptionValue("Expel Harm Orbs") then
                    if cast.expelHarm() then return end
                end
            end -- End Defensive Check
        end -- End Action List - Defensive
    -- Action List - Interrupts
        function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #getEnemies("player",20) do
                    thisUnit = getEnemies("player",20)[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                        if distance <= 5 then
        -- Quaking Palm
                            if isChecked("Quaking Palm") then
                                if cast.quakingPalm(thisUnit) then return end
                            end
        -- Spear Hand Strike
                            if isChecked("Spear Hand Strike") then
                                if cast.spearHandStrike(thisUnit) then return end
                            end
        -- Leg Sweep
                            if isChecked("Leg Sweep") then
                                if cast.legSweep(thisUnit) then return end
                            end
                        end
        -- Paralysis
                        if isChecked("Paralysis") then
                            if cast.paralysis(thisUnit) then return end
                        end
                    end
                end
            end -- End Interrupt Check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        function actionList_Cooldown()
            if useCDs() and getDistance(units.dyn5) < 5 then
        -- Trinkets
                if isChecked("Trinkets") and getDistance(units.dyn5) < 5 then
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end
        -- Racial - Blood Fury / Berserking
                -- blood_fury
                -- berserking
                if isChecked("Racial") and (race == "Orc" or race == "Troll") then
                    if castSpell("player",racial,false,false,false) then return end
                end
       
            end
        end -- End Cooldown - Action List
    -- Action List - Opener
        function actionList_Opener()
            if opener == false then
                --Ironskin Brew
                if not iB1 == true then
                    if cast.ironskinBrew() then
                        iB1 = true 
                    end
                -- Keg Smash
                elseif iB1 == true and not KG and getDistance("target") < 5 then
                    if cast.kegSmash("target") then
                        KG = true
                    end
                -- Ironskin Brew
                elseif KG == true and not iB2 then
                    if cast.ironskinBrew() then 
                        iB2 = true
                    end
                -- Ironskin Brew
                elseif iB2 == true and not iB3 then
                    if cast.ironskinBrew() then 
                        iB3 = true
                    end
                -- Black Ox Brew
                elseif iB3 == true and not bOB then
                    if cast.blackoxBrew() then 
                        bOB = true
                    end
                --Iron Skin Brew
                elseif bOB == true and not iB4 then
                    if cast.ironskinBrew() then
                        iB4 = true
                        opener = true
                        print("Opener Complete")
                    end
                end
            end
        end
    -- Action List - Black Out Combo
        function actionList_BlackOutCombo()
        -- Racial - Arcane Torrent
            if ttm >= 0.5 and isChecked("Racial") and race == "BloodElf" and getDistance("target") < 5 then
                if castSpell("player",racial,false,false,false) then return end
            end
        -- Keg Smash
            if buff.blackoutCombo.exists() and #enemies.yards8t >= getOptionValue("Keg Smash Targets") then
                if cast.kegSmash() then return end
            end
        --[[ Breath of Fire
        	if buff.blackoutCombo.exists() and #getEnemies("player",12) >= getOptionValue("Breath of Fire Targets") then
        		if cast.breathOfFire() then return end
        	end]]        
        -- Breath of Fire
            if buff.blackoutCombo.exists() and not hasEquiped(137016) and #getEnemies("player",12) >= getOptionValue("Breath of Fire Targets") then
                if cast.breathOfFire() then return end
            end
        -- Breath of Fire (Legendary Chest)
            if not buff.blackoutCombo.exists() and hasEquiped(137016) and #getEnemies("player",12) >= getOptionValue("Breath of Fire Targets") then
                if cast.breathOfFire() then return end
            end
        -- Blackout Strike
            if cast.blackoutStrike() then return end
        --Exploding Keg
            if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) and #getEnemies("player",12) >= getOptionValue("Exploding Keg Targets") then
                if cast.explodingKeg() then return end
            end
        -- Tiger Palm
            if (power + (powgen*cd.kegSmash)) >= 40 then
                if cast.tigerPalm() then return end
            end
        --Chi Burst
            --Width/Range values from LyloLoq
            if talent.chiBurst and getEnemiesInRect(7,47) >= getOptionValue("Chi Burst Targets") then
            	if cast.chiBurst() then return end
            end
        -- Chi Wave
        	if talent.chiWave then
            	if cast.chiWave() then return end
            end
        -- Rushing Jade Wind
            if #enemies.yards8 >= 1 then
                if cast.rushingJadeWind() then return end
            end
        -- Breath of Fire
        	--[[if #getEnemies("player",12) >= getOptionValue("Breath of Fire Targets") then
        		if cast.breathOfFire() then return end
        	end]]        
        -- Expel Harm
            --[[if isChecked("Expel Harm") and php <= getValue("Expel Harm") and inCombat and GetSpellCount(115027) >= getOptionValue("Expel Harm Orbs") then
                if cast.expelHarm() then return end
            end]]
        end


    -- Action List - Single Target
        function actionList_SingleTarget()
        -- Action List - Cooldown
            -- call_action_list,name=cd
        -- Racial - Arcane Torrent
            if ttm >= 0.5 and isChecked("Racial") and race == "BloodElf" and getDistance("target") < 5 then
                if castSpell("player",racial,false,false,false) then return end
            end        
        -- Keg Smash
           -- actions.st=keg_smash
            if #enemies.yards8t >= getOptionValue("Keg Smash Targets") then
                if cast.kegSmash() then return end
            end
        --Breath of Fire
            --actions.st+=/breath_of_fire
            if #getEnemies("player",12) >= getOptionValue("Breath of Fire Targets") then
            	if cast.breathOfFire() then return end
            end
        -- Blackout Strike
            --actions.st+=/blackout_strike
            if cast.blackoutStrike() then return end
        --Tiger Palm
            --actions.st+=/tiger_palm
            if (power + (powgen*cd.kegSmash)) >= 40 then
                if cast.tigerPalm() then return end
            end
        --Exploding Keg
            --actions.st+=/exploding_keg
            if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) and #getEnemies("player",12) >= getOptionValue("Exploding Keg Targets") then
                if cast.explodingKeg() then return end
            end
        --Chi Burst
            --actions.st+=/chi_burst
            --Width/Range values from LyloLoq
            if talent.chiBurst and getEnemiesInRect(7,47) >= getOptionValue("Chi Burst Targets") then
                if cast.chiBurst() then return end
            end
        -- Chi Wave
            --actions.st+=/chi_wave
            if talent.chiWave then
            	if cast.chiWave() then return end
            end
        --  Rushing Jade Wind
            --actions.st+=/rushing_jade_wind
            if talent.rushingJadeWind and #enemies.yards8 >= 1 then
            	if cast.rushingJadeWind() then return end
            end
        -- Expel Harm
            --[[if isChecked("Expel Harm") and php <= getValue("Expel Harm") and inCombat and GetSpellCount(115027) >= getOptionValue("Expel Harm Orbs") then
                if cast.expelHarm() then return end
            end]]
        end -- End Action List - Single Target
    --Action List AoE
        function actionList_MultiTarget()
        -- Racial - Arcane Torrent
            -- arcane_torrent,if=chiMax-chi>=1&energy.time_to_max>=0.
            if ttm >= 0.5 and isChecked("Racial") and race == "BloodElf" and getDistance("target") < 5 then
                if castSpell("player",racial,false,false,false) then return end
            end        
        --Exploding Keg
            --actions.st+=/exploding_keg
            if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) and #getEnemies("player",12) >= getOptionValue("Exploding Keg Targets") then
                if cast.explodingKeg() then return end
            end
        -- Keg Smash
           -- actions.st=keg_smash
            if #enemies.yards8t >= getOptionValue("Keg Smash Targets") then
                if cast.kegSmash() then return end
            end
        --Chi Burst
            --actions.st+=/chi_burst
            --Width/Range values from LyloLoq
            if talent.chiBurst and getEnemiesInRect(7,47) >= getOptionValue("Chi Burst Targets") then
                if cast.chiBurst() then return end
            end
        -- Chi Wave
            --actions.st+=/chi_wave
            if talent.chiWave then
            	if cast.chiWave() then return end
            end
        --Breath of Fire
            --actions.st+=/breath_of_fire
            if #getEnemies("player",12) >= getOptionValue("Breath of Fire Targets") then
            	if cast.breathOfFire() then return end
            end
        --Rushing Jade Wind
            --actions.st+=/rushing_jade_wind
            if talent.rushingJadeWind and #enemies.yards8 >= 1 then
            	if cast.rushingJadeWind() then return end
            end        
        --Tiger Palm
            --actions.st+=/tiger_palm
            if cd.kegSmash >= gcd and (power+(powgen*cd.kegSmash)) >= 80 then
            	if cast.tigerPalm() then return end
            end
        -- Blackout Strike
            --actions.st+=/blackout_strike
            if cast.blackoutStrike() then return end
        end -- End Action List - Single Target
    -- Action List - Pre-Combat
        function actionList_PreCombat()
            if not inCombat then
        -- Flask / Crystal
                -- flask,type=flask_of_the_seventh_demon
                if isChecked("Flask / Crystal") then
                    if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",188033) then
                        useItem(br.player.flask.wod.agilityBig)
                        return true
                    end
                    if flaskBuff==0 then
                        if not UnitBuffID("player",188033) and canUse(118922) then --Draenor Insanity Crystal
                            useItem(118922)
                            return true
                        end
                    end
                end
                -- auto_attack
                if isValidUnit("target") and getDistance("target") < 5 then
                    StartAttack()
                end
            end -- End No Combat Check
        end --End Action List - Pre-Combat

---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or pause() or (IsMounted() or IsFlying()) or mode.rotation==4 then
            return true
        else
-----------------------
--- Extras Rotation ---
-----------------------
 --           if actionList_Extras() then return end
--------------------------
--- Defensive Rotation ---
--------------------------
            if actionList_Defensive() then return end
------------------------------
--- Pre-Combat Rotation ---
------------------------------
            if actionList_PreCombat() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
            if isChecked("Opener") then
                if opener == false and hastar and isBoss("target") and getDistance("target") < 10 and charges.purifyingBrew == 3 then
                    if actionList_Opener() then return end
                elseif opener == false and hastar and charges.purifyingBrew < 3 then
                    opener = true
                elseif opener == false and hastar and not isBoss("target") then
                    opener = true
                end
            else
                opener = true
            end
        -- FIGHT!
            if inCombat and not IsMounted() and profileStop==false and isValidUnit(units.dyn5) and opener == true then
    ------------------
    --- Interrupts ---
    ------------------
        -- Run Action List - Interrupts
                if actionList_Interrupts() then return end
    ----------------------
    --- Start Rotation ---
    ----------------------
        -- Auto Attack
                -- auto_attack
                if getDistance(units.dyn5) < 5 then
                    StartAttack()
                end
    ---------------------------------
    --- APL Mode: SimulationCraft ---
    ---------------------------------
        -- Potion
                    -- potion,name=old_war,if=buff.serenity.up|buff.storm_earth_and_fire.up|(!talent.serenity.enabled&trinket.proc.agility.react)|buff.bloodlust.react|target.time_to_die<=60
                    -- TODO: Agility Proc
                    if isChecked("Provoke") and (inRaid or inInstance) then
		                for i = 1, #enemies.yards30 do
		                   local thisUnit = enemies.yards30[i]
		                   local enemyTarget = UnitTarget(thisUnit)
		                   
		                   -- if not isAggroed(thisUnit) and hasThreat(thisUnit) then
		                   if enemyTarget ~= nil and UnitGroupRolesAssigned(enemyTarget) ~= "TANK" and UnitIsFriend(enemyTarget,"player") then
		                        if cast.provoke(thisUnit) then return end
		                    end
		                end
		            end
		        -- Black Ox Brew
		            if charges.purifyingBrew == 0 then
		                if cast.blackoxBrew() then return end
		            end
		        -- Ironskin Brew
		            if (charges.purifyingBrew > 1 and not buff.ironskinBrew.exists()) or charges.purifyingBrew == 3 and not buff.blackoutCombo.exists() then
		                if cast.ironskinBrew() then return end
		            end
                    if canUse(127844) and inRaid and isChecked("Potion") and getDistance("target") < 5 then
                        useItem(127844)
                    end
                    if ((mode.rotation == 1 and #enemies.yards8 >= 3) or mode.rotation == 2) then
                        if actionList_MultiTarget() then return end
                    end  
                    if talent.blackoutCombo then
                        if actionList_BlackOutCombo() then return end
                    end                                      
        -- Call Action List - Single Target
                    -- call_action_list,name=st
                    if not talent.blackoutCombo then
                        if actionList_SingleTarget() then return end
                    end
            end -- End Combat Check
        end -- End Pause
    end -- End Timer
end -- End runRotation
local id = 268
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

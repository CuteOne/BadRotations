local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.bladeDance},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladeDance},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.chaosStrike},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.spectralSight}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.metamorphosis},
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.metamorphosis},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.metamorphosis}
    };
   	CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.darkness},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.darkness}
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.consumeMagic},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.consumeMagic}
    };
    CreateButton("Interrupt",4,0)
-- Mover
    MoverModes = {
        [1] = { mode = "AC", value = 1 , overlay = "Movement Animation Cancel Enabled", tip = "Will Cancel Movement Animation.", highlight = 1, icon = br.player.spell.felRush},
        [2] = { mode = "On", value = 2 , overlay = "Auto Movement Enabled", tip = "Will Cast Movement Abilities.", highlight = 0, icon = br.player.spell.felRush},
        [3] = { mode = "Off", value = 3 , overlay = "Auto Movement Disabled", tip = "Will NOT Cast Movement Abilities", highlight = 0, icon = br.player.spell.felRush}
    };
    CreateButton("Mover",5,0)
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
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR","|cffFFFFFFWH"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Eye Beam Targets
            br.ui:createDropdownWithout(section,"Eye Beam Usage",{"|cff00FF00Per APL","|cffFFFF00AoE Only","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Eye Beam.")
            br.ui:createSpinnerWithout(section, "Units To AoE", 3, 1, 10, 1, "|cffFFBB00Number of Targets to use AoE spells on.")
        -- Fel Rush Charge Hold
            br.ui:createSpinnerWithout(section, "Hold Fel Rush Charge", 1, 0, 2, 1, "|cffFFBB00Number of Fel Rush charges the bot will hold for manual use.");
        -- Vengeful Retreat
            br.ui:createCheckbox(section, "Vengeful Retreat")
        -- Glide Fall Time
            br.ui:createSpinner(section, "Glide", 2, 0, 10, 1, "|cffFFBB00Seconds until Glide will be used while falling.")
        -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Potion
            br.ui:createCheckbox(section,"Potion")
        -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Seventh Demon","Repurposed Fel Focuser","Oralius' Whispering Crystal","Gaze of the Legion","None"}, 1, "|cffFFFFFFSet Elixir to use.")
        -- Legendary Ring
            br.ui:createCheckbox(section,"Legendary Ring")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF001st Only","|cff00FF002nd Only","|cffFFFF00Both","|cffFF0000None"}, 1, "|cffFFFFFFSelect Trinket Usage.")
        -- Metamorphosis
            br.ui:createCheckbox(section,"Metamorphosis")
        -- Draught of Souls
            br.ui:createCheckbox(section, "Draught of Souls")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Blur
            br.ui:createSpinner(section, "Blur", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Darkness
            br.ui:createSpinner(section, "Darkness", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Chaos Nova
            br.ui:createSpinner(section, "Chaos Nova - HP", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            br.ui:createSpinner(section, "Chaos Nova - AoE", 3, 1, 10, 1, "|cffFFBB00Number of Targets to use at.")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Consume Magic
            br.ui:createCheckbox(section, "Consume Magic")
        -- Chaos Nova
            br.ui:createCheckbox(section, "Chaos Nova")
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
        -- Mover Key Toggle
            br.ui:createDropdown(section, "Mover Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugHavoc", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Mover",0.25)
        br.player.mode.mover = br.data.settings[br.selectedSpec].toggles["Mover"]

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
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = enemies or {}
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = GetObjectExists("mouseover")
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
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powmax, powgen, powerDeficit           = br.player.power.fury.amount(), br.player.power.fury.max(), br.player.power.fury.regen(), br.player.power.fury.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local t19_4pc                                       = TierScan("T19") >= 4
        local t20_2pc                                       = TierScan("T20") >= 2
        local t20_4pc                                       = TierScan("T20") >= 4
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.fury.ttm()
        local units                                         = units or {}
        local use                                           = br.player.use

        units.dyn5 = br.player.units(5)
        units.dyn30 = br.player.units(30)
        enemies.yards5 = br.player.enemies(5)
        enemies.yards8 = br.player.enemies(8)
        enemies.yards8r = getEnemiesInRect(10,20,false) or 0
        enemies.yards10t = br.player.enemies(10,br.player.units(10,true))
        enemies.yards20 = br.player.enemies(20)
        enemies.yards30 = br.player.enemies(30)
        enemies.yards50 = br.player.enemies(50)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if talent.chaosCleave then chaleave = 1 else chaleave = 0 end
        if buff.prepared.exists() then prepared = 1 else prepared = 0 end
        if (hasEquiped(151639) or talent.firstBlood) then flood = 1 else flood = 0 end
        if lastSpell == spell.vengefulRetreat then vaulted = true else vaulted = false end
        if lastSpell == spell.eyeBeam and buff.metamorphosis.exists() then metaExtended = true elseif not buff.metamorphosis.exists() then metaExtended = false end

    -- Wait for Nemesis
        -- waiting_for_nemesis,value=!(!talent.nemesis.enabled|cooldown.nemesis.ready|cooldown.nemesis.remains>target.time_to_die|cooldown.nemesis.remains>60)
        local waitForNemesis = not (not talent.nemesis or cd.nemesis.remain() == 0 or cd.nemesis.remain() > ttd(units.dyn5) or cd.nemesis.remain() > 60)
    -- Wait for Chaos Blades
        -- waiting_for_chaos_blades,value=!(!talent.chaos_blades.enabled|cooldown.chaos_blades.ready|cooldown.chaos_blades.remains>target.time_to_die|cooldown.chaos_blades.remains>60)
        local waitForChaosBlades = not (not talent.chaosBlades or cd.chaosBlades.remain() == 0 or cd.chaosBlades.remain() > ttd(units.dyn5) or cd.chaosBlades.remain() > 60)
    -- Pool for Meta Variable
        -- pooling_for_meta,value=!talent.demonic.enabled&cooldown.metamorphosis.remains<6&fury.deficit>30&(!variable.waiting_for_nemesis|cooldown.nemesis.remains<10)&(!variable.waiting_for_chaos_blades|cooldown.chaos_blades.remains<6)
        if isChecked("Metamorphosis") and useCDs() 
            and not talent.demonic and cd.metamorphosis.remain() < 6 and powerDeficit > 30 and (not waitForNemesis or cd.nemesis.remain() < 10) and (not waitForChaosBlades or cd.chaosBlades.remain() < 6)
        then
            poolForMeta = true
        else
            poolForMeta = false
        end
    -- Blade Dance Variable
        -- blade_dance,value=talent.first_blood.enabled|set_bonus.tier20_4pc|spell_targets.blade_dance1>=3+(talent.chaos_cleave.enabled*3)
        if (hasEquiped(151639) or talent.firstBlood) or t20_4pc or ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Units To AoE")) or mode.rotation == 2) then
            bladeDanceVar = true
        else
            bladeDanceVar = false
        end
    -- Pool for Blade Dance Variable
        -- pooling_for_blade_dance,value=variable.blade_dance&(fury<75-talent.first_blood.enabled*20)
        if bladeDanceVar and power < 60 - flood * 20 then
            poolForBladeDance = true
        else
            poolForBladeDance = false
        end
    -- Pool for Chaos Strike Variable
        -- pooling_for_chaos_strike,value=talent.chaos_cleave.enabled&fury.deficit>40&!raid_event.adds.up&raid_event.adds.in<2*gcd
        if talent.chaosCleave and power < 40 then
            poolForChaosStrike = true
        else
            poolForChaosStrike = false
        end
    -- Check for Eye Beam During Metamorphosis
        if talent.demonic and buff.metamorphosis.duration() > 10 and lastSpell == spell.eyeBeam then metaEyeBeam = true end
        if metaEyeBeam == nil or (metaEyeBeam == true and not buff.metamorphosis.exists()) then metaEyeBeam = false end

    -- Custom Functions
        local function cancelRushAnimation()
            if castable.felRush and GetUnitSpeed("player") == 0 then
                MoveBackwardStart()
                JumpOrAscendStart()
                cast.felRush()
                MoveBackwardStop()
                AscendStop()
            end
            return
        end
        local function cancelRetreatAnimation()
            if castable.vengefulRetreat then
                -- C_Timer.After(.001, function() HackEnabled("NoKnockback", true) end)
                -- C_Timer.After(.35, function() cast.vengefulRetreat() end)
                -- C_Timer.After(.55, function() HackEnabled("NoKnockback", false) end)
                SetHackEnabled("NoKnockback", true)
                if cast.vengefulRetreat() then 
                    SetHackEnabled("NoKnockBack", false) 
                end
            end
            return
        end
        if IsHackEnabled("NoKnockback") then
            SetHackEnabled("NoKnockback", false)
        end

        -- ChatOverlay("Pools - Meta: "..tostring(poolForMeta)..", BD: "..tostring(poolForBladeDance)..", CS: "..tostring(poolForChaosStrike))

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
        -- Glide
            if isChecked("Glide") and not buff.glide.exists() then
                if falling >= getOptionValue("Glide") then
                    if cast.glide("player") then return end
                end
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
                    elseif canUse(129196) then --Legion Healthstone
                        useItem(129196)
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
        -- Blur
                if isChecked("Blur") and php <= getOptionValue("Blur") and inCombat then
                    if cast.blur() then return end
                end
        -- Darkness
                if isChecked("Darkness") and php <= getOptionValue("Darkness") and inCombat then
                    if cast.darkness() then return end
                end
        -- Chaos Nova
                if isChecked("Chaos Nova - HP") and php <= getValue("Chaos Nova - HP") and inCombat and #enemies.yards5 > 0 then
                    if cast.chaosNova() then return end
                end
                if isChecked("Chaos Nova - AoE") and #enemies.yards5 >= getValue("Chaos Nova - AoE") then
                    if cast.chaosNova() then return end
                end
    		end -- End Defensive Toggle
		end -- End Action List - Defensive
	-- Action List - Interrupts
		local function actionList_Interrupts()
			if useInterrupts() then
        -- Consume Magic
                if isChecked("Consume Magic") then
                    for i=1, #enemies.yards20 do
                        thisUnit = enemies.yards20[i]
                        if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                            if cast.consumeMagic(thisUnit) then return end
                        end
                    end
                end
        -- Chaos Nova
                if isChecked("Chaos Nova") then
                    for i=1, #enemies.yards5 do
                        thisUnit = enemies.yards5[i]
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if cast.chaosNova(thisUnit) then return end
                        end
                    end
                end
		 	end -- End useInterrupts check
		end -- End Action List - Interrupts
	-- Action List - Cooldowns
		local function actionList_Cooldowns()
			if useCDs() and getDistance(units.dyn5) < 5 then                
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                    if castSpell("player",racial,false,false,false) then return end
                end
                if getOptionValue("APL Mode") == 1 then -- SimC
        -- Metamorphosis
                    if isChecked("Metamorphosis") then
                        -- metamorphosis,if=!(talent.demonic.enabled|variable.pooling_for_meta|variable.waiting_for_nemesis|variable.waiting_for_chaos_blades)|target.time_to_die<25
                        if not (talent.demonic or poolForMeta or waitForNemesis or waitForChaosBlades) or ttd(units.dyn5) < 25 then
                            -- if cast.metamorphosis("best",false,1,8) then return end
                            if cast.metamorphosis("player") then return end
                        end
                        -- metamorphosis,if=talent.demonic.enabled&buff.metamorphosis.up&fury<40
                        if talent.demonic and buff.metamorphosis.exists() and power < 40 then
                            if cast.metamorphosis("player") then return end
                        end
                    end
        -- Nemesis
                    -- nemesis,target_if=min:target.time_to_die,if=raid_event.adds.exists&debuff.nemesis.down&(active_enemies>desired_targets|raid_event.adds.in>60)
                    -- nemesis,if=!raid_event.adds.exists&(buff.chaos_blades.up|buff.metamorphosis.up|cooldown.metamorphosis.adjusted_remains<20|target.time_to_die<=60)
                    if buff.chaosBlades.exists() or buff.metamorphosis.exists() or cd.metamorphosis.remain() < 20 or ttd(units.dyn5) <= 60 then
                        if isDummy("target") then 
                            lowestUnit = "target"
                        else 
                            for i = 1, #enemies.yards50 do
                                local thisUnit = enemies.yards50[i]
                                local lowestTTD = lowestTTD or 999
                                if ttd(thisUnit) < lowestTTD then 
                                    lowestTTD = ttd(thisUnit)
                                    lowestUnit = thisUnit
                                end
                            end
                        end
                        if cast.nemesis(lowestUnit) then return end
                    end
        -- Chaos Blades
                    -- chaos_blades,if=buff.metamorphosis.up|cooldown.metamorphosis.adjusted_remains>60|target.time_to_die<=12
                    if (buff.metamorphosis.exists() or cd.metamorphosis.remain() > 60 or ttd(units.dyn5) <= 12) and getDistance(units.dyn5) < 5 then
                        if cast.chaosBlades() then return end
                    end
        -- Trinkets
                    -- Draught of Souls
                    if isChecked("Draught of Souls") then
                        if hasEquiped(140808) and canUse(140808) then
                            if not buff.metamorphosis.exists() and (not talent.firstBlood or cd.bladeDance.remain() > 3) and (not talent.nemesis or cd.nemesis.remain() > 30 or ttd("target") < cd.nemesis.remain() + 3) then
                                useItem(140808)
                            end
                        end
                    end
                    -- use_item,slot=trinket2,if=!buff.metamorphosis.up&(!talent.first_blood.enabled|!cooldown.blade_dance.ready)&(!talent.nemesis.enabled|cooldown.nemesis.remains>30|target.time_to_die<cooldown.nemesis.remains+3)
                 --   if isChecked("Trinkets") then
                        if not buff.metamorphosis.exists() and (not talent.firstBlood or cd.bladeDance.remain() ~= 0) and (not talent.nemesis or cd.nemesis.remain() > 30 or ttd(units.dyn5) < cd.nemesis.remain() + 3) then
                            if (getOptionValue("Trinkets") == 1 or getOptionValue("Trinkets") == 3) and canUse(13) then
                                useItem(13)
                            end
                            if (getOptionValue("Trinkets") == 2 or getOptionValue("Trinkets") == 3) and canUse(14) then
                                useItem(14)
                            end
                        end
                  --  end
        -- Potion
                    -- potion,name=old_war,if=buff.metamorphosis.remains>25|target.time_to_die<30
                    if isChecked("Potion") and canUse(127844) and inRaid then
                        if buff.metamorphosis.remain() > 25 or ttd(units.dyn5) < 30 then
                            useItem(127844)
                        end
                    end
                end
                if getOptionValue("APL Mode") == 2 then -- AMR

                end
            end -- End useCDs check
        end -- End Action List - Cooldowns
    -- Action List - Demonic
        local function actionList_Demonic()
        -- Pick Up Fragments
            -- pick_up_fragment,if=fury.deficit>=35&(cooldown.eye_beam.remains>5|buff.metamorphosis.up)
            if talent.demonicAppetite and powerDeficit >= 35 and (cd.eyeBeam.remain() > 5 or buff.metamorphosis.exists()) then
                ChatOverlay("Low Fury - Collect Fragments!")
            end
        -- Vengeful Retreat
            -- vengeful_retreat,if=(talent.prepared.enabled|talent.momentum.enabled)&buff.prepared.down&buff.momentum.down
            if isChecked("Vengeful Retreat") and (talent.prepared or talent.momentum) and not buff.prepared.exists() and not buff.momentum.exists() and getDistance(units.dyn5) < 5 then
                if mode.mover == 1 then
                    cancelRetreatAnimation()
                elseif mode.mover == 2 then
                    if cast.vengefulRetreat() then return end
                end
            end
        -- Fel Rush
            -- fel_rush,if=(talent.momentum.enabled|talent.fel_mastery.enabled)&(!talent.momentum.enabled|(charges=2|cooldown.vengeful_retreat.remains>4)&buff.momentum.down)&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
            if getFacing("player","target",10) and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge")
                and (talent.momentum or talent.felMastery) and (not talent.momentum or ((charges.felRush.count() == 2 or cd.vengefulRetreat.remain() > 4) 
                and not buff.momentum.exists()) and (charges.felRush.count() == 2))
            then
                if mode.mover == 1 and getDistance("target") < 8 then
                    cancelRushAnimation()
                elseif mode.mover == 2 or (getDistance("target") >= 8 and mode.mover ~= 3) then
                    if cast.felRush() then return end
                end
            end
        -- Throw Glaive
            -- throw_glaive,if=talent.bloodlet.enabled&(!talent.momentum.enabled|buff.momentum.up)&charges=2
            if talent.bloodlet and (not talent.momentum or buff.momentum.exists()) and charges.throwGlaive.count() == 2 then
                if cast.throwGlaive() then return end
            end
        -- Death Sweep
            -- death_sweep,if=variable.blade_dance
            if buff.metamorphosis.exists() and bladeDanceVar then
                if cast.bladeDance() then return end
            end
        -- Fel Eruption
            -- fel_eruption
            if cast.felEruption() then return end
        -- Fury of the Illidari
            -- fury_of_the_illidari,if=(active_enemies>desired_targets|raid_event.adds.in>55)&(!talent.momentum.enabled|buff.momentum.up)
            if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and getDistance("target") < 5 then
                if ((mode.rotation == 1 and (#enemies.yards8 >= getOptionValue("Units To AoE") or (#enemies.yards8 > 0 and useCDs()))) or mode.rotation == 2 
                        or (mode.rotation == 3 and ((#enemies.yards8 > 0 and useCDs()) or #enemies.yards8 >= getOptionValue("Units To AoE"))))
                    and (not talent.momentum or buff.momentum.exists()) 
                then
                    if cast.furyOfTheIllidari() then return end
                end
            end
        -- Blade Dance
            -- blade_dance,if=variable.blade_dance&cooldown.eye_beam.remains>5&!cooldown.metamorphosis.ready
            if not buff.metamorphosis.exists() and bladeDanceVar and (cd.eyeBeam.remain() > 5 or getOptionValue("Eye Beam Usage") == 3 or (getOptionValue("Eye Beam Usage") == 2 and enemies.yards8r < getOptionValue("Units To AoE"))) 
                and (cd.metamorphosis.remain() ~= 0 or not isChecked("Metamorphosis") or not useCDs() or not isBoss()) 
            then
                if cast.bladeDance() then return end
            end
        -- Throw Glaive
            -- throw_glaive,if=talent.bloodlet.enabled&spell_targets>=2&(!talent.master_of_the_glaive.enabled|!talent.momentum.enabled|buff.momentum.up)&(spell_targets>=3|raid_event.adds.in>recharge_time+cooldown)
            if talent.bloodlet and ((mode.rotation == 1 and #enemies.yards10t >= 2) or mode.rotation == 2) and (not talent.masterOfTheGlaive or not talent.momentum or buff.momentum.exists()) then
                if cast.throwGlaive() then return end
            end
        -- Felblade
            -- felblade,if=fury.deficit>=30
            if powerDeficit >= 30 then
                if cast.felblade() then return end
            end
        -- Eye Beam
            -- eye_beam,if=spell_targets.eye_beam_tick>desired_targets|!buff.metamorphosis.extended_by_demonic
            if ((getOptionValue("Eye Beam Usage") == 1 and enemies.yards8r > 0 and (((mode.rotation == 1 and enemies.yards8r >= getOptionValue("Units To AoE")) or mode.rotation == 2) or not metaExtended))
                or (getOptionValue("Eye Beam Usage") == 2 and ((mode.rotation == 1 and enemies.yards8r >= getOptionValue("Units To AoE")) or (mode.rotation == 2 and enemies.yards8r > 0))))
                and not moving
            then
                -- if cast.eyeBeam(units.dyn5) then return end
                if cast.eyeBeam(nil,"rect",getOptionValue("Units To AoE"),8) then return end
            end
        -- Annihilation
            -- annihilation,if=(!talent.momentum.enabled|buff.momentum.up|fury.deficit<30+buff.prepared.up*8|buff.metamorphosis.remains<5)&!variable.pooling_for_blade_dance
            if buff.metamorphosis.exists() and (not talent.momentum or buff.momentum.exists() or powerDeficit < 30 + (prepared * 8) or buff.metamorphosis.remain() < 5) and not poolForBladeDance then
                if cast.chaosStrike() then return end
            end
        -- Throw Glaive
            -- throw_glaive,if=talent.bloodlet.enabled&(!talent.master_of_the_glaive.enabled|!talent.momentum.enabled|buff.momentum.up)&raid_event.adds.in>recharge_time+cooldown
            if talent.bloodlet and (not talent.masterOfTheGlaive or not talent.momentum or buff.momentum.exists()) then
                if cast.throwGlaive() then return end
            end
        -- Chaos Strike
            -- chaos_strike,if=(!talent.momentum.enabled|buff.momentum.up|fury.deficit<30+buff.prepared.up*8)&!variable.pooling_for_chaos_strike&!variable.pooling_for_meta&!variable.pooling_for_blade_dance
            if not buff.metamorphosis.exists() and (not talent.momentum or buff.momentum.exists() or powerDeficit < 30 + (prepared * 8))
                and not poolForChaosStrike and not poolForMeta and not poolForBladeDance 
            then
                if cast.chaosStrike() then return end
            end
        -- Fel Rush
            -- fel_rush,if=!talent.momentum.enabled&(buff.metamorphosis.down|talent.demon_blades.enabled)&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
            if getFacing("player","target",10) and not talent.momentum and (not buff.metamorphosis.exists() or talent.demonBlades) and charges.felRush.count() == 2 and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge") then
               if mode.mover == 1 and getDistance("target") < 8 then
                    cancelRushAnimation()
                elseif mode.mover == 2 or (getDistance("target") >= 8 and mode.mover ~= 3) then
                    if cast.felRush() then return end
                end
            end
        -- Demon's Bite
            -- demons_bite
            if not talent.demonBlades then
                if cast.demonsBite() then return end
            end
        -- Throw Glaive
            -- throw_glaive,if=buff.out_of_range.up
            if getDistance(units.dyn30) > 8 then
                if cast.throwGlaive() then return end
            end
        -- Fel Rush
            -- fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum.enabled)
            if mode.mover ~= 3 and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge") and (getDistance("target") > 15 or (getDistance("target") > 8 and not talent.momentum)) then
                if cast.felRush() then return end
            end
        -- -- Vengeful Retreat
        --     -- vengeful_retreat,if=movement.distance>15
        --     if isChecked("Vengeful Retreat") and mode.mover ~= 3 and not getFacing("player","target",170) and getDistance("target") > 15 then
        --         if cast.vengefulRetreat() then return end
        --     end
        end -- End Action List - Demonic
    -- Action List - Normal
        local function actionList_Normal()
        -- Pick Up Fragments
            -- pick_up_fragment,if=talent.demonic_appetite.enabled&fury.deficit>=35
            if talent.demonicAppetite and powerDeficit >= 35 then
                ChatOverlay("Low Fury - Collect Fragments!")
            end
        -- Vengeful Retreat
            -- vengeful_retreat,if=(talent.prepared.enabled|talent.momentum.enabled)&buff.prepared.down&buff.momentum.down
            if isChecked("Vengeful Retreat") and (talent.prepared or talent.momentum) and not buff.prepared.exists() and not buff.momentum.exists() and getDistance(units.dyn5) < 5 then
                if mode.mover == 1 then
                    cancelRetreatAnimation()
                elseif mode.mover == 2 then
                    if cast.vengefulRetreat() then return end
                end
            end
        -- Fel Rush
            -- fel_rush,if=(talent.momentum.enabled|talent.fel_mastery.enabled)&(!talent.momentum.enabled|(charges=2|cooldown.vengeful_retreat.remains>4)&buff.momentum.down)&(!talent.fel_mastery.enabled|fury.deficit>=25)&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
            if getFacing("player","target",10) and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge")
                and (talent.momentum or talent.felMastery) and (not talent.momentum or ((charges.felRush.count() == 2 or cd.vengefulRetreat.remain() > 4) 
                and not buff.momentum.exists()) and (not talent.felMastery or powerDeficit >= 25) and (charges.felRush.count() == 2))
            then
                if mode.mover == 1 and getDistance("target") < 8 then
                    cancelRushAnimation()
                elseif mode.mover == 2 or (getDistance("target") >= 8 and mode.mover ~= 3) then
                    if cast.felRush() then return end
                end
            end
        -- Fel Barrage
            -- fel_barrage,if=(buff.momentum.up|!talent.momentum.enabled)&(active_enemies>desired_targets|raid_event.adds.in>30)
            if (buff.momentum.exists() or not talent.momentum) and (((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Units To AoE")) or mode.rotation == 2)) then
                if cast.felBarrage() then return end
            end
        -- Throw Glaive
            -- throw_glaive,if=talent.bloodlet.enabled&(!talent.momentum.enabled|buff.momentum.up)&charges=2
            if talent.bloodlet and (not talent.momentum or buff.momentum.exists()) and charges.throwGlaive.count() == 2 then
                if cast.throwGlaive() then return end
            end
        -- Felblade
            -- felblade,if=fury<15&(cooldown.death_sweep.remains<2*gcd|cooldown.blade_dance.remains<2*gcd)
            if power < 15 and (cd.deathSweep.remain() < 2 * gcd or cd.bladeDance.remain() < 2 * gcd) then
                if cast.felblade() then return end
            end
        -- Death Sweep
            -- death_sweep,if=variable.blade_dance
            if buff.metamorphosis.exists() and bladeDanceVar then
                if cast.bladeDance() then return end
            end
        -- Fel Rush
            -- fel_rush,if=charges=2&!talent.momentum.enabled&!talent.fel_mastery.enabled&!buff.metamorphosis.up
            if getFacing("player","target",10) and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge") and charges.felRush.count() == 2 and not talent.momentum and not talent.felMastery and not buff.metamorphosis.exists() then
                if mode.mover == 1 and getDistance("target") < 8 then
                    cancelRushAnimation()
                elseif mode.mover == 2 or (getDistance("target") >= 8 and mode.mover ~= 3) then
                    if cast.felRush() then return end
                end
            end
        -- Fel Eruption
            -- fel_eruption
            if cast.felEruption() then return end
        -- Fury of the Illidari
            -- fury_of_the_illidari,if=(active_enemies>desired_targets|raid_event.adds.in>55)&(!talent.momentum.enabled|buff.momentum.up)&(!talent.chaos_blades.enabled|buff.chaos_blades.up|cooldown.chaos_blades.remains>30|target.time_to_die<cooldown.chaos_blades.remains)
            if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and getDistance("target") < 5 then
                if ((mode.rotation == 1 and (#enemies.yards8 >= getOptionValue("Units To AoE") or (#enemies.yards8 > 0 and useCDs()))) or mode.rotation == 2 or (mode.rotation == 3 and #enemies.yards8 > 0 and useCDs())) 
                    and (not talent.momentum or buff.momentum.exists()) 
                    and (not talent.chaosBlades or buff.chaosBlades.exists() or cd.chaosBlades.remain() > 30 or ttd(units.dyn5) < cd.chaosBlades.remain())
                then
                    if cast.furyOfTheIllidari() then return end
                end
            end
        -- Blade Dance
            -- blade_dance,if=variable.blade_dance
            if not buff.metamorphosis.exists() and bladeDanceVar then
                if cast.bladeDance() then return end
            end
        -- Throw Glaive
            -- throw_glaive,if=talent.bloodlet.enabled&spell_targets>=2&(!talent.master_of_the_glaive.enabled|!talent.momentum.enabled|buff.momentum.up)&(spell_targets>=3|raid_event.adds.in>recharge_time+cooldown)
            if talent.bloodlet and ((mode.rotation == 1 and #enemies.yards10t >= 2) or mode.rotation == 2) and (not talent.masterOfTheGlaive or not talent.momentum or buff.momentum.exists()) then
                if cast.throwGlaive() then return end
            end
        -- Felblade
            -- felblade,if=fury.deficit>=30+buff.prepared.up*8
            if powerDeficit >= 30 + prepared * 8 then
                if cast.felblade() then return end
            end
        -- Eye Beam
            -- eye_beam,if=spell_targets.eye_beam_tick>desired_targets|(spell_targets.eye_beam_tick>=3&raid_event.adds.in>cooldown)|(talent.blind_fury.enabled&fury.deficit>=35)
            if enemies.yards8r > 0 and not moving and 
                ((getOptionValue("Eye Beam Usage") == 1 and (((mode.rotation == 1 and enemies.yards8r >= getOptionValue("Units To AoE")) or mode.rotation == 2))) 
                or (getOptionValue("Eye Beam Usage") == 2 and ((mode.rotation == 1 and enemies.yards8r >= getOptionValue("Units To AoE")) or mode.rotation == 2))
                or (talent.blindFury and powerDeficit >= 35))
            then
                -- if cast.eyeBeam(units.dyn5) then return end
                if cast.eyeBeam(nil,"rect",getOptionValue("Units To AoE"),8) then return end
            end
        -- Annihilation
            -- annihilation,if=(talent.demon_blades.enabled|!talent.momentum.enabled|buff.momentum.up|fury.deficit<30+buff.prepared.up*8|buff.metamorphosis.remains<5)&!variable.pooling_for_blade_dance
            if buff.metamorphosis.exists() and (talent.demonBlades or not talent.momentum or buff.momentum.exists() or power >= 40 --[[(powerDeficit < 30 + prepared * 8)]] or buff.metamorphosis.remain() < 5) and not poolForBladeDance then
                if cast.chaosStrike() then return end
            end
        -- Throw Glaive
            -- throw_glaive,if=talent.bloodlet.enabled&(!talent.master_of_the_glaive.enabled|!talent.momentum.enabled|buff.momentum.up)&raid_event.adds.in>recharge_time+cooldown
            if talent.bloodlet and (not talent.masterOfTheGlaive or not talent.momentum or buff.momentum.exists()) then
                if cast.throwGlaive() then return end
            end
            -- throw_glaive,if=!talent.bloodlet.enabled&buff.metamorphosis.down&spell_targets>=3
            if not talent.bloodlet and not buff.metamorphosis.exists() and ((mode.rotation == 1 and #enemies.yards10t >= 3) or mode.rotation == 2) then
                if cast.throwGlaive() then return end
            end
        -- Chaos Strike
            -- chaos_strike,if=(talent.demon_blades.enabled|!talent.momentum.enabled|buff.momentum.up|fury.deficit<30+buff.prepared.up*8)&!variable.pooling_for_chaos_strike&!variable.pooling_for_meta&!variable.pooling_for_blade_dance
            if not buff.metamorphosis.exists() and (talent.demonBlades or not talent.momentum or buff.momentum.exists() or power >= 40) --powerDeficit < 30 + prepared * 8) 
                and not poolForChaosStrike and not poolForMeta and not poolForBladeDance 
            then
                if cast.chaosStrike() then return end
            end
        -- Fel Rush
            -- fel_rush,if=!talent.momentum.enabled&raid_event.movement.in>charges*10&(talent.demon_blades.enabled|buff.metamorphosis.down)
            if getFacing("player","target",10) and not talent.momentum and (talent.demonBlades or not buff.metamorphosis.exists()) and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge") then
                if mode.mover == 1 and getDistance("target") < 8 then
                    cancelRushAnimation()
                elseif mode.mover == 2 or (getDistance("target") >= 8 and mode.mover ~= 3) then
                    if cast.felRush() then return end
                end
            end
        -- Demon's Bite
            -- demons_bite
            if not talent.demonBlades then
                if cast.demonsBite() then return end
            end
        -- Throw Glaive
            -- throw_glaive,if=buff.out_of_range.up
            if getDistance(units.dyn30) > 8 then
                if cast.throwGlaive() then return end
            end
        -- Felblade
            -- felblade,if=movement.distance|buff.out_of_range.up
            if getDistance("target") > 8 then
                if cast.felblade("target") then return end
            end
        -- Fel Rush
            -- fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum.enabled)
            if mode.mover ~= 3 and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge") and (getDistance("target") > 15 or (getDistance("target") > 8 and not talent.momentum)) then
                if cast.felRush() then return end
            end
        -- -- Vengeful Retreat
        --     -- vengeful_retreat,if=movement.distance>15
        --     if isChecked("Vengeful Retreat") and mode.mover ~= 3 and not getFacing("player","target",170) and getDistance("target") > 15 then
        --         if cast.vengefulRetreat() then return end
        --     end
        -- Throw Glaive
            -- throw_glaive,if=!talent.bloodlet.enabled
            if not talent.bloodlet and ((talent.demonBlades and swingTimer > 0) or power < 20) then
                if cast.throwGlaive("target") then return end
            end
        end -- End Action List - Normal
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then
            -- Flask / Crystal
                -- flask,type=flask_of_the_seventh_demon
                if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheSeventhDemon.exists() and canUse(item.flaskOfTheSeventhDemon) then
                    if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                    if buff.felFocus.exists() then buff.felFocus.cancel() end
                    if buff.gazeOfTheLegion.exists() then buff.gazeOfTheLegion.cancel() end
                    if use.flaskOfTheSeventhDemon() then return end
                end
                if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and canUse(item.repurposedFelFocuser) then
                    if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                    if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                    if buff.gazeOfTheLegion.exists() then buff.gazeOfTheLegion.cancel() end
                    if use.repurposedFelFocuser() then return end
                end
                if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUse(item.oraliusWhisperingCrystal) then
                    if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                    if buff.felFocus.exists() then buff.felFocus.cancel() end
                    if buff.gazeOfTheLegion.exists() then buff.gazeOfTheLegion.cancel() end
                    if use.oraliusWhisperingCrystal() then return end
                end
                if getOptionValue("Elixir") == 4 and not buff.gazeOfTheLegion.exists() and canUse(item.inquisitorsMenacingEye) then
                    if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                    if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                    if buff.felFocus.exists() then buff.felFocus.cancel() end
                    if use.inquisitorsMenacingEye() then return end
                end
                if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

                end -- End Pre-Pull
            -- Start Attack
                -- auto_attack
                if isValidUnit("target") and getDistance("target") < 5 then
                    StartAttack()
                end
            end -- End No Combat
        end -- End Action List - PreCombat
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not IsMounted() and not hastar and profileStop then
            profileStop = false
        elseif (inCombat and profileStop) or (IsMounted() or IsFlying()) or pause() or mode.rotation==4 or isCastingSpell(spell.eyeBeam) == true then
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
            -- print(tostring(isCastingSpell(spell.eyeBeam)))
            if inCombat and not IsMounted() and not profileStop and isValidUnit(units.dyn5) then
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                if getOptionValue("APL Mode") == 1 then
            -- Start Attack
                    if getDistance(units.dyn5) < 5 then
                        StartAttack()
                    end
            -- Cooldowns
                    -- call_action_list,name=cooldown,if=gcd.remains=0
                    if cd.global.remain() == 0 then
                        if actionList_Cooldowns() then return end
                    end
            -- Call Action List - Demonic
                    -- run_action_list,name=demonic,if=talent.demonic.enabled
                    if talent.demonic then
                        if actionList_Demonic() then return end
                    else
            -- Call Action List - Normal
                        -- run_action_list,name=normal
                        if actionList_Normal() then return end
                    end
                end -- End SimC APL
    ----------------------
    --- AskMrRobot APL ---
    ----------------------
                if getOptionValue("APL Mode") == 2 then
            -- Vengeful Retreat
                    -- if HasTalent(Prepared) or HasTalent(Momentum) and not HasBuff(Momentum)
                    if isChecked("Vengeful Retreat") and castable.vengefulRetreat and (talent.prepared or talent.momentum) and not buff.momentum.exists() and getDistance(units.dyn5) < 5 then
                        if mode.mover == 1 then
                            cancelRetreatAnimation()
                        elseif mode.mover == 2 and charges.felRush.count() > 0 then
                            cast.vengefulRetreat()
                        end
                    end
            -- Fel Rush
                    -- if HasTalent(Momentum) and not HasBuff(Momentum) and CooldownSecRemaining(VengefulRetreat) > BuffDurationSec(Momentum)
                    if castable.felRush and talent.momentum and not buff.momentum.exists() and cd.vengefulRetreat.remain() > buff.momentum.duration() then
                        if mode.mover == 1 and getDistance("target") < 5 then
                            cancelRushAnimation()
                        elseif mode.mover == 2 or (getDistance("target") >= 5 and mode.mover ~= 3) then
                            cast.felRush()
                        end
                    end
            -- Fury of the Illidari
                    if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and castable.furyOfTheIllidari and getDistance("target") < 5 then
                        cast.furyOfTheIllidari()
                    end
            -- Begin AoE Rotation
                    if ((mode.rotation == 1 and #enemies.yards8 > 1) or mode.rotation == 2) then
            -- Death Sweep
                        if castable.deathSweep and buff.metamorphosis.exists() then
                            cast.bladeDance()
                        end
            -- Fel Barrage
                        -- if ChargesRemaining(FelBarrage) = SpellCharges(FelBarrage)
                        if castable.felBarrage and charges.felBarrage.count() == 5 then
                            cast.felBarrage()
                        end
            -- Eye Beam
                        if castable.eyeBeam and (((mode.rotation == 1 and enemies.yards8r >= getOptionValue("Eye Beam Targets") and getOptionValue("Eye Beam Usage") == 1) or mode.rotation == 2) and getOptionValue("Eye Beam Usage") ~= 3) then
                            cast.eyeBeam()
                        end
            -- Fel Rush
                        if castable.felRush then
                            cast.felRush()
                        end
            -- Blade Dance
                        -- if CooldownSecRemaining(EyeBeam) > 0
                        if castable.bladeDance and not buff.metamorphosis.exists() and cd.eyeBeam.remain() > 0 then
                            cast.bladeDance()
                        end
            -- Throw Glaive
                        if castable.throwGlaive then
                            cast.throwGlaive()
                        end 
            -- Annihilation
                        -- if HasTalent(ChaosCleave)
                        if castable.annihilation and talent.chaosCleave then
                            cast.chaosStrike()
                        end
            -- Chaos Strike
                        -- if HasTalent(ChaosCleave)
                        if castable.chaosStrike and talent.chaosCleave then
                            cast.chaosStrike()
                        end
            -- Chaos Nova
                        -- if CooldownSecRemaining(EyeBeam) > 0 or HasTalent(UnleashedPower)
                        if castable.chaosNova and (cd.eyeBeam.remain() > 0 or talent.unleashedPower) then
                            cast.chaosNova()
                        end
                    end
            -- Begin Single Rotation
            -- Fel Eruption
                    if castable.felEruption then
                        cast.felEruption()
                    end
            -- Death Sweep
                    -- if HasTalent(FirstBlood) 
                    if castable.deathSweep and (hasEquiped(151639) or talent.firstBlood) and buff.metamorphosis.exists() then
                        cast.bladeDance()
                    end
            -- Annihilation
                    -- if not HasTalent(Momentum) or (HasBuff(Momentum) or PowerToMax <= 30 + TimerSecRemaining(PreparedTimer) * 8)
                    if castable.annihilation and (not talent.momentum or (buff.momentum.exists() or ttm <= 30 + buff.prepared.remain() * 8)) then
                        cast.chaosStrike()
                    end
            -- Fel Barrage
                    -- if ChargesRemaining(FelBarrage) = SpellCharges(FelBarrage) and (not HasTalent(Momentum) or HasBuff(Momentum))
                    if ((mode.rotation == 1 and #enemies.yards8 >= 2) or mode.rotation == 2) and castable.felBarrage and charges.felBarrage.count() == 5 and (not talent.momentum or buff.momentum.exists()) then
                        cast.felBarrage()
                    end
            -- Throw Glaive
                    -- if HasTalent(Bloodlet)
                    if castable.throwGlaive and talent.bloodlet then
                        cast.throwGlaive()
                    end
            -- Eye Beam
                    -- if not HasBuff(Metamorphosis) and (not HasTalent(Momentum) or HasBuff(Momentum))
                    if (((mode.rotation == 1 and enemies.yards8r >= getOptionValue("Eye Beam Targets") and getOptionValue("Eye Beam Usage") == 1) or mode.rotation == 2) and getOptionValue("Eye Beam Usage") ~= 3) 
                        and castable.eyeBeam and not buff.metamorphosis.exists() and (not talent.momentum or buff.momentum.exists()) 
                    then
                        cast.eyeBeam()
                    end
            -- Blade Dance
                    -- if CooldownSecRemaining(EyeBeam) > 0 and HasTalent(FirstBlood)
                    if castable.bladeDance and cd.eyeBeam.remain() > 0 and (hasEquiped(151639) or talent.firstBlood) then
                        cast.bladeDance()
                    end
            -- Chaos Strike
                    -- if CooldownSecRemaining(EyeBeam) > 0 or (HasBuff(Momentum) or PowerToMax <= 30 + TimerSecRemaining(PreparedTimer) * 8)
                    if castable.chaosStrike and (cd.eyeBeam.remain() > 0 or (buff.momentum.exists() or ttm <= 30 + buff.prepared.remain() * 8)) then
                        cast.chaosStrike()
                    end
            -- Felblade
                    if castable.felBlade then
                        cast.felblade()
                    end
            -- Fel Rush
                    -- if not HasTalent(Momentum)
                    if castable.felRush and not talent.momentum then
                        if mode.mover == 1 and getDistance("target") < 5 then
                            cancelRushAnimation()
                        elseif mode.mover == 2 or (getDistance("target") >= 5 and mode.mover ~= 3) then
                            cast.felRush()
                        end
                    end
            -- Demon's Bite
                    if castable.demonsBite and not talent.demonBlades then
                        cast.demonsBite()
                    end
            -- Throw Glaive
                    if castable.throwGlaive then
                        cast.throwGlaive()
                    end    
                end
    -------------------
    --- WoWHead APL ---
    -------------------
                if getOptionValue("APL Mode") == 3 then
            -- Fel Rush
                    if charges.felRush.count() > getOptionValue("Hold Fel Rush Charge") and (not talent.felMastery or (talent.felMastery and powerDeficit > 30)) 
                        and (not talent.momentum or (talent.momentum and not buff.momentum.exists())) 
                    then
                        if mode.mover == 1 and getDistance("target") < 5 then
                            cancelRushAnimation()
                        elseif mode.mover == 2 or (getDistance("target") >= 5 and mode.mover ~= 3) then
                            if cast.felRush() then return end
                        end
                    end
            -- Vengeful Retreat
                    if isChecked("Vengeful Retreat") and (talent.prepared or (talent.momentum and not buff.momentum.exists())) and getDistance(units.dyn5) < 5 then
                       if mode.mover == 1 then
                            cancelRetreatAnimation()
                        elseif mode.mover == 2 and charges.felRush.count() > 0 then
                            if cast.vengefulRetreat() then return end
                        end
                    end
            -- Fel Barrage
                    if charges.felBarrage.count() >= 5 and (not talent.momentum or (talent.momentum and not buff.momentum.exists())) then
                        if cast.felBarrage() then return end
                    end
            -- Throw Glaive
                    if talent.bloodlet and talent.masterOfTheGlaive and (not talent.momentum or (talent.momentum and not buff.momentum.exists())) then
                        if cast.throwGlaive() then return end
                    end
            -- Fel Eruption
                    if cast.felEruption() then return end
            -- Fury of the Illidari
                    if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and getDistance("target") < 5 then
                        if not talent.momentum or (talent.momentum and buff.momentum.exists()) then
                            if cast.furyOfTheIllidari() then return end
                        end
                    end
            -- Eye Beam
                    if talent.demonic --and getDistance(units.dyn8) < 8 and getFacing("player",units.dyn5,45) 
                        and (((mode.rotation == 1 and enemies.yards8r >= getOptionValue("Eye Beam Targets") and getOptionValue("Eye Beam Usage") == 1) or mode.rotation == 2) and getOptionValue("Eye Beam Usage") ~= 3)
                    then
                        if cast.eyeBeam() then return end
                    end
            -- Blade Dance / Death Sweep
                    if (hasEquiped(151639) or talent.firstBlood) or (mode.rotation == 1 and #enemies.yards8 >= 3 + chaleave) or mode.rotation == 2 then
                        if buff.metamorphosis.exists() then
                            if cast.bladeDance() then return end
                        else
                            if cast.bladeDance() then return end
                        end
                    end
            -- Throw Glaive
                    if talent.bloodlet and ((mode.rotation == 1 and #enemies.yards8 >= 2) or mode.rotation == 2) and (not talent.momentum or (talent.momentum and buff.momentum.exists())) then
                        if cast.throwGlaive() then return end
                    end
            -- Felblade
                    if powerDeficit > 30 then
                        if cast.felblade() then return end
                    end
            -- Annihilation
                    if buff.metamorphosis.exists() and (powerDeficit < 40 or (talent.momentum and buff.momentum.exists())) then
                        -- print("Trying to Annihilate")
                        if cast.chaosStrike() then return end
                    end
            -- Throw Glaive
                    if talent.bloodlet and (not talent.momentum or (talent.momentum and buff.momentum.exists())) then
                        if cast.throwGlaive() then return end
                    end
            -- Eye Beam
                    if not buff.metamorphosis.exists() and not talent.blindFury and not talent.chaosCleave and not talent.demonic 
                        and (((mode.rotation == 1 and enemies.yards8r >= getOptionValue("Eye Beam Targets") and artifact.anguishOfTheDeceiver.enabled() and getOptionValue("Eye Beam Usage") == 1) or mode.rotation == 2) 
                        and getOptionValue("Eye Beam Usage") ~= 3) 
                    then
                        if cast.eyeBeam() then return end
                    end
            -- Throw Glaive
                    if not buff.metamorphosis.exists() and ((mode.rotation == 1 and #enemies.yards8 >= 2) or mode.rotation == 2) then
                        if cast.throwGlaive() then return end
                    end
            -- Chaos Strike
                    if not buff.metamorphosis.exists() and (powerDeficit < 40 or (talent.momentum and buff.momentum.exists())) then
                        if cast.chaosStrike() then return end
                    end
            -- Fel Barrage
                    if charges.felBarrage.count() >= 4 and (not talent.momentum or (talent.momentum and not buff.momentum.exists())) then
                        if cast.felBarrage() then return end
                    end
            -- Demon's Bite
                    if powerDeficit >= 40 and not talent.demonBlades then
                        if cast.demonsBite() then return end
                    end
            -- Throw Glaive
                    if not talent.bloodlet and talent.demonBlades then
                        if cast.throwGlaive() then return end
                    end
                end
			end --End In Combat
		end --End Rotation Logic
    end -- End Timer
end -- End runRotation
local id = 577
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

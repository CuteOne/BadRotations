if select(2, UnitClass("player")) == "DEMONHUNTER" then
	local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
	local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = bb.player.spell.bladeDance},
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.bladeDance},
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.chaosStrike},
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.spectralSight}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.metamorphosis},
            [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.metamorphosis},
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.metamorphosis}
        };
       	CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.darkness},
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.darkness}
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
            [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = bb.player.spell.consumeMagic},
            [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = bb.player.spell.consumeMagic}
        };
        CreateButton("Interrupt",4,0)
    -- Mover
        MoverModes = {
            [1] = { mode = "AC", value = 1 , overlay = "Movement Animation Cancel Enabled", tip = "Will Cancel Movement Animation.", highlight = 1, icon = bb.player.spell.felRush},
            [2] = { mode = "On", value = 2 , overlay = "Auto Movement Enabled", tip = "Will Cast Movement Abilities.", highlight = 0, icon = bb.player.spell.felRush},
            [3] = { mode = "Off", value = 3 , overlay = "Auto Movement Disabled", tip = "Will NOT Cast Movement Abilities", highlight = 0, icon = bb.player.spell.felRush}
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
            section = bb.ui:createSection(bb.ui.window.profile, "General")
            -- APL
                bb.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
                bb.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
                bb.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Eye Beam Targets
                bb.ui:createSpinner(section, "Eye Beam Targets", 3, 1, 10, 1, "|cffFFBB00Number of Targets to use at.")
            -- Glide Fall Time
                bb.ui:createSpinner(section, "Glide", 2, 0, 10, 1, "|cffFFBB00Seconds until Glide will be used while falling.")
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
            -- Metamorphosis
                bb.ui:createCheckbox(section,"Metamorphosis")
            bb.ui:checkSectionState(section)
        -- Defensive Options
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
            -- Healthstone
                bb.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
                bb.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Blur
                bb.ui:createSpinner(section, "Blur", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Darkness
                bb.ui:createSpinner(section, "Darkness", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Chaos Nova
                bb.ui:createSpinner(section, "Chaos Nova - HP", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
                bb.ui:createSpinner(section, "Chaos Nova - AoE", 3, 1, 10, 1, "|cffFFBB00Number of Targets to use at.")
            bb.ui:checkSectionState(section)
        -- Interrupt Options
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
            -- Consume Magic
                bb.ui:createCheckbox(section, "Consume Magic")
            -- Chaos Nova
                bb.ui:createCheckbox(section, "Chaos Nova")
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
            -- Mover Key Toggle
                bb.ui:createDropdown(section, "Mover Mode", bb.dropOptions.Toggle,  6)
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
        if bb.timer:useTimer("debugHavoc", math.random(0.15,0.3)) then
            --print("Running: "..rotationName)

    ---------------
	--- Toggles ---
	---------------
	        UpdateToggle("Rotation",0.25)
	        UpdateToggle("Cooldown",0.25)
	        UpdateToggle("Defensive",0.25)
	        UpdateToggle("Interrupt",0.25)
            UpdateToggle("Mover",0.25)

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
            local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
            local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
            local debuff                                        = bb.player.debuff
            local enemies                                       = bb.player.enemies
            local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
            local flaskBuff                                     = getBuffRemain("player",bb.player.flask.wod.buff.agilityBig)
            local friendly                                      = friendly or UnitIsFriend("target", "player")
            local gcd                                           = bb.player.gcd
            local hasMouse                                      = ObjectExists("mouseover")
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
            local playerMouse                                   = UnitIsPlayer("mouseover")
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
            if talent.chaosCleave then chaleave = 1 else chaleave = 0 end
            if talent.prepared then prepared = 1 else prepared = 0 end
            if talent.firstBlood then flood = 1 else flood = 0 end
            if lastSpell == spell.vengefulRetreat then vaulted = true else vaulted = false end
            if mode.mover == 1 then
                if IsHackEnabled("NoKnockback") ~= nil then SetHackEnabled("NoKnockback", false) end
            end

            -- Pool for Meta Variable
                        -- pooling_for_meta,value=cooldown.metamorphosis.ready&buff.metamorphosis.down&(!talent.demonic.enabled|!cooldown.eye_beam.ready)&(!talent.chaos_blades.enabled|cooldown.chaos_blades.ready)&(!talent.nemesis.enabled|debuff.nemesis.up|cooldown.nemesis.ready)
                        if useCDs() and cd.metamorphosis == 0 and not buff.metamorphosis and (not talent.demonic or cd.eyeBeam > 0) and (not talent.chaosBlades or cd.chaosBlades == 0) and (not talent.nemesis or debuff.nemesis or cd.nemesis == 0) then
                            poolForMeta = true
                        else
                            poolForMeta = false
                        end
                -- Blade Dance Variable
                        -- blade_dance,value=talent.first_blood.enabled|spell_targets.blade_dance1>=2+talent.chaos_cleave.enabled
                        if talent.firstBlood or ((mode.rotation == 1 and #enemies.yards8 >= 2 + chaleave) or mode.rotation == 2) then
                            bladeDanceVar = true
                        else
                            bladeDanceVar = false
                        end
                -- Pool for Blade Dance Var
                        -- pooling_for_blade_dance,value=variable.blade_dance&fury-40<35-talent.first_blood.enabled*20&spell_targets.blade_dance1>=2
                        if bladeDanceVar and power - 40 < 35 - flood * 20 and ((mode.rotation == 1 and #enemies.yards8 >= 2) or mode.rotation == 2) then
                            poolForBladeDance = true
                        else
                            poolForBladeDance = false
                        end

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
            -- Glide
                if isChecked("Glide") then
                    if falling >= getOptionValue("Glide") then
                        if cast.glide() then return end
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
        -- Action List - PostVengeful
            local function actionList_PostVengeful()
            -- Fel Rush
                if useMover() then
                    if mode.mover == 1 then
                        if getDistance("target") < 10 then 
                            if cast.felRush("target",false,true) then return end
                        end
                        if getDistance("target") >= 10 then
                            if cast.felRush() then return end
                        end
                    else
                        if cast.felRush() then return end
                    end
                end
            -- Fel Blade
                if cast.felblade() then return end
            end -- End Action lsit - Post Vengful Retreat
        -- Action List - Single Target
            local function actionList_SingleTarget()
            -- Fel Eruption
                if cast.felEruption() then return end
            -- Death Sweep
                -- if HasTalent(FirstBlood)
                if talent.firstBlood then
                    if cast.deathSweep() then return end
                end
            -- Annihilation
                if cast.annihilation() then return end
            -- Fel Barrage
                -- if ChargesRemaining(FelBarrage) = SpellCharges(FelBarrage)
                if charges.felBarrage == charges.max.felBarrage then
                    if cast.felBarrage(units.dyn5) then return end
                end
            -- Eye Beam
                if (not talent.demonic or not buff.metamorphosis) and getDistance(units.dyn8) < 8 and getFacing("player",units.dyn5,45) then
                    if cast.eyeBeam(units.dyn5) then return end
                end
            -- Blade Dance
                -- if CooldownSecRemaining(EyeBeam) > 0 and HasTalent(FirstBlood)
                if (cd.eyeBeam > 0 or not isKnown(spell.eyeBeam)) and not talent.firstBlood then
                    if cast.bladeDance() then return end
                end
            -- Chaos Strike
                -- if CooldownSecRemaining(EyeBeam) > 0
                if cd.eyeBeam > 0 or not isKnown(spell.eyeBeam) then
                    if cast.chaosStrike() then return end
                end
            -- Fel Rush
                -- if not HasTalent(Prepared) and not HasTalent(Momentum)
                if useMover() and getFacing("player","target",10) and not talent.prepared and not talent.momentum then
                    if mode.mover == 1 then
                        if getDistance("target") < 10 then 
                            if cast.felRush("target",false,true) then return end
                        end
                        if getDistance("target") >= 10 then
                            if cast.felRush() then return end
                        end
                    else
                        if cast.felRush() then return end
                    end
                end
                -- if (ChargesRemaining(FelRush) >= 2 or (ChargesRemaining(FelRush) >= 1 and ChargeSecRemaining(FelRush) <= CooldownSecRemaining(VengefulRetreat))) and not HasBuff(Momentum)
                if useMover() and getFacing("player","target",10) and (charges.felRush >= 2 or (charges.felRush >= 1 and recharge.felRush <= cd.vengefulRetreat)) and not buff.momentum then
                    if cast.felRush() then return end
                end
            -- Throw Glaive
                -- if HasTalent(Bloodlet)
                if talent.bloodlet then
                    if cast.throwGlaive() then return end
                end
            -- Felblade
                -- if not WasLastCast(VengefulRetreat)
                if lastSpell ~= spell.vengefulRetreat then
                    if cast.felblade("target") then return end
                end
            -- Demon's Bite
                if cast.demonsBite() then return end
            end -- End Action List - Single Target
        -- Action List - MultiTarget
            local function actionList_MultiTarget()
            -- Death Sweep
                if cast.deathSweep() then return end
            -- Fel Barrage
                -- if ChargesRemaining(FelBarrage) = SpellCharges(FelBarrage)
                if charges.felBarrage == charges.max.felBarrage then
                    if cast.felBarrage(units.dyn5) then return end
                end
            -- Eye Beam
                if getDistance(units.dyn5) < 5 and getFacing("player",units.dyn5,45) then
                    if cast.eyeBeam(units.dyn5) then return end
                end
            -- Fel Rush
                if useMover() and getFacing("player","target",10) then
                    if mode.mover == 1 then
                        if getDistance("target") < 10 then 
                            if cast.felRush("target",false,true) then return end
                        end
                        if getDistance("target") >= 10 then
                            if cast.felRush() then return end
                        end
                    else
                        if cast.felRush() then return end
                    end
                end
            -- Blade Dance
                -- if CooldownSecRemaining(EyeBeam) > 0
                if cd.eyeBeam > 0 or not isKnown(spell.eyeBeam) then
                    if cast.bladeDance() then return end
                end
            -- Throw Glaive
                if cast.throwGlaive() then return end
            -- Annihilation
                -- if HasTalent(ChaosCleave)
                if talent.chaosCleave then
                    if cast.annihilation() then return end
                end
            -- Chaos Strike
                -- if HasTalent(ChaosCleave)
                if talent.chaosCleave then
                    if cast.chaosStrike() then return end
                end
            -- Chaos Nova
                -- if CooldownSecRemaining(EyeBeam) > 0 or HasTalent(UnleashedPower)
                if (cd.eyeBeam > 0 or talent.unleashedPower) and #enemies.yards5 > 0 then
                    if cast.chaosNova() then return end
                end
            end -- End Action List - Multi Target
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if useCDs() and getDistance(units.dyn5) < 5 then
            -- Trinkets
                    -- use_item,slot=trinket2,if=buff.chaos_blades.up|!talent.chaos_blades.enabled 
                    if isChecked("Trinkets") then
                        if buff.chaosBlades or not talent.chaosBlades then 
                            if canUse(13) then
                                useItem(13)
                            end
                            if canUse(14) then
                                useItem(14)
                            end
                        end
                    end
            -- Legendary Ring
                    -- use_item,slot=finger1
                    if isChecked("Legendary Ring") then
                        if hasEquiped(124636) and canUse(124636) then
                            useItem(124636)
                        end
                    end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                    -- blood_fury,buff.tigers_fury | berserking,buff.tigers_fury | arcane_torrent,buff.tigers_fury
                    if isChecked("Racial") and (bb.player.race == "Orc" or bb.player.race == "Troll" or bb.player.race == "Blood Elf") then
                        if castSpell("player",racial,false,false,false) then return end
                    end
                    if getOptionValue("APL Mode") == 1 then -- SimC
            -- Nemesis
                        -- nemesis,target_if=min:target.time_to_die,if=raid_event.adds.exists&debuff.nemesis.down&(active_enemies>desired_targets|raid_event.adds.in>60)
                        -- nemesis,if=!raid_event.adds.exists&(cooldown.metamorphosis.remains>100|target.time_to_die<70)
                        -- nemesis,sync=metamorphosis,if=!raid_event.adds.exists
                        if (addsExist and not debuff.nemesis and (#enemies.yards5 > getOptionValue("Eye Beam Targets") or addsIn > 60))
                            or (not addsExist and (cd.metamorphosis > 100 or ttd(units.dyn5) < 70))
                            or (not addsExist and (not buff.metamorphosis and (not talent.demonic or cd.eyeBeam ~= 0) and (not talent.chaosBlades or cd.chaosBlades == 0) and (not talent.nemesis or debuff.nemesis or cd.nemesis == 0)))
                        then
                            if cast.nemesis(units.dyn5) then return end
                        end
            -- Chaos Blades
                        -- chaos_blades,if=buff.metamorphosis.up|cooldown.metamorphosis.remains>100|target.time_to_die<20
                        if (buff.metamorphosis or cd.metamorphosis > 100 or ttd(units.dyn5) < 20) and getDistance(units.dyn5) < 5 then
                            if cast.chaosBlades() then return end
                        end
            -- Metamorphosis
                        -- metamorphosis,if=variable.pooling_for_meta&fury.deficit<30&(talent.chaos_blades.enabled|!cooldown.fury_of_the_illidari.ready)
                        if isChecked("Metamorphosis") then
                            if poolForMeta and powerDeficit < 30 and (talent.chaosBlades or cd.furyOfTheIllidari ~= 0) then
                                if cast.metamorphosis() then return end
                            end
                        end
            -- Potion
                        -- potion,name=old_war,if=buff.metamorphosis.remains>25|target.time_to_die<30
                        -- TODO
                    end
                    if getOptionValue("APL Mode") == 2 then -- AMR
            -- Metamorphosis
                        -- if (not HasTalent(DemonReborn) or CooldownSecRemaining(EyeBeam) > 0) and not HasBuff(Metamorphosis)
                        if (not talent.demonReborn or cd.eyeBeam > 0) and not buff.metamorphosis then
                            if cast.metamorphosis() then return end
                        end
            -- Nemesis
                        if cast.nemesis(units.dyn5) then return end
            -- Chaos Blades
                        -- if CooldownSecRemaining(Metamorphosis) > SpellCooldownSec(ChaosBlades) - BuffDurationSec(ChaosBlades) or HasBuff(Metamorphosis)
                        if (cd.metamorphosis > cd.chaosBlades - buff.duration.chaosBlades or buff.metamorphosis) and getDistance(units.dyn5) < 5 then
                            if cast.chaosBlades() then return end
                        end 
                    end
            -- Agi-Pot
                    -- potion,name=deadly_grace,if=buff.metamorphosis.remains>25
                    if isChecked("Agi-Pot") and canUse(109217) and inRaid then
                        if buff.remain.metamorphosis > 25 then
                            useItem(109217)
                        end
                    end
                end -- End useCDs check
            end -- End Action List - Cooldowns
        -- Action List - PreCombat
            local function actionList_PreCombat()
                if not inCombat and not (IsFlying() or IsMounted()) then
                -- Flask / Crystal
                    -- flask,type=flask_of_the_seventh_demon
                    if isChecked("Flask / Crystal") then
                        if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",188033) and not UnitBuffID("player",156064) then
                            useItem(bb.player.flask.wod.agilityBig)
                            return true
                        end
                        if flaskBuff==0 then
                            if not UnitBuffID("player",188033) and not UnitBuffID("player",156064) and canUse(118922) then --Draenor Insanity Crystal
                                useItem(118922)
                                return true
                            end
                            if not UnitBuffID("player",193456) and not UnitBuffID("player",188033) and not UnitBuffID("player",156064) and canUse(129192) then -- Gaze of the Legion
                                useItem(129192)
                                return true
                            end
                        end
                    end
                    if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

                    end -- End Pre-Pull
                    if isValidUnit("target") then
                -- Throw Glaive
                        if getDistance("target") < 30 and getFacing("player","target") then
                            if cast.throwGlaive("target") then return end
                        end
                -- Fel Rush
                        if getOptionValue("APL Mode") == 1 and useMover() and getFacing("player","target",10) then
                            if mode.mover == 1 then
                                if getDistance("target") < 10 then 
                                    if cast.felRush("target",false,true) then return end
                                end
                                if getDistance("target") >= 10 then
                                    if cast.felRush() then return end
                                end
                            else
                                if cast.felRush() then return end
                            end
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
                if inCombat and profileStop==false and isValidUnit(units.dyn5) and not isCastingSpell(spell.eyeBeam) and getDistance(units.dyn5) < 5 then
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
                -- Blur
                        -- blur,if=artifact.demon_speed.enabled&cooldown.fel_rush.charges_fractional<0.5&cooldown.vengeful_retreat.remains-buff.momentum.remains>4
                        if artifact.demonSpeed and charges.frac.felRush < 0.5 and cd.vengefulRetreat - buff.remain.momentum > 4 then
                            if cast.blur() then return end
                        end
                -- Cooldowns
                        -- call_action_list,name=cooldown
                        if actionList_Cooldowns() then return end
                -- Fel Rush 
                        -- fel_rush,animation_cancel=1,if=time=0
                        if mode.mover == 1 and combatTime < 1 and getFacing("player","target",10) then
                            if getDistance("target") < 10 then 
                                if cast.felRush("target",false,true) then return end
                            end
                            if getDistance("target") >= 10 then
                                if cast.felRush() then return end
                            end
                        elseif combatTime < 1 and getFacing("player","target",10) then
                            if cast.felRush() then return end
                        end
                -- Pick Up Fragment Notification
                        -- pick_up_fragment,if=talent.demonic_appetite.enabled&fury.deficit>=30
                        if talent.demonicAppetite and powerDeficit >= 30 then
                            ChatOverlay("Low Fury - Collect Fragments!")
                        end 
                -- Vengeful Retreat
                        -- vengeful_retreat,if=(talent.prepared.enabled|talent.momentum.enabled)&buff.prepared.down&buff.momentum.down
                        if useMover() and (talent.prepared or talent.momentum) and not buff.prepared and not buff.momentum and getDistance("target") < 5 then
                            if mode.mover == 1 or (mode.mover == 2 and charges.felRush > 0) then
                                if cast.vengefulRetreat() then return end
                            end
                        end                
                -- Fel Rush
                        -- fel_rush,animation_cancel=1,if=(talent.momentum.enabled|talent.fel_mastery.enabled)&(!talent.momentum.enabled|(charges=2|cooldown.vengeful_retreat.remains>4)&buff.momentum.down)&(!talent.fel_mastery.enabled|fury.deficit>=25)&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
                        if useMover() and getFacing("player","target",10) 
                            and (talent.momentum or talent.felMastery) and (not talent.momentum or (charges.felRush == 2 or cd.vengefulRetreat > 4) and not buff.momentum) 
                            and (not talent.felMastery or powerDeficit >= 25) and (charges.felRush == 2 or (moveIn > charges.felRush * 10 and addsIn > 10)) 
                        then
                            if mode.mover == 1 then
                                if getDistance("target") < 10 then
                                    if cast.felRush("target",false,true) then return end
                                end
                                if getDistance("target") >= 10 then
                                    if cast.felRush() then return end
                                end
                            else
                                if cast.felRush() then return end
                            end
                        end
                -- Fel Barrage
                        -- fel_barrage,if=charges>=5&(buff.momentum.up|!talent.momentum.enabled)&(active_enemies>desired_targets|raid_event.adds.in>30)
                        if charges.felBarrage >= 5 and (buff.momentum or not talent.momentum) and (#enemies.yards20 > getOptionValue("Eye Beam Targets") or addsIn > 30) then
                            if cast.felBarrage(units.dyn5) then return end
                        end
                -- Throw Glaive
                        -- throw_glaive,if=talent.bloodlet.enabled&(!talent.momentum.enabled|buff.momentum.up)&charges=2
                        if talent.bloodlet and (not talent.momentum or buff.momentum) and charges.throwGlaive == 2 then
                            if cast.throwGlaive() then return end
                        end
                -- Fury of the Illidari
                        -- fury_of_the_illidari,if=active_enemies>desired_targets|raid_event.adds.in>55&(!talent.momentum.enabled|buff.momentum.up)
                        if #enemies.yards8 > getOptionValue("Eye Beam Targets") or addsIn > 55 and (not talent.momentum or buff.momentum) then
                            if cast.furyOfTheIllidari() then return end
                        end
                -- Eye Beam
                        -- eye_beam,if=talent.demonic.enabled&buff.metamorphosis.down&fury.deficit<30
                        if talent.demonic and not buff.metamorphosis and powerDeficit < 30 and getDistance(units.dyn8) < 8 and getFacing("player",units.dyn5,45) then
                            if cast.eyeBeam(units.dyn5) then return end
                        end
                -- Death Sweep
                        -- death_sweep,if=variable.blade_dance
                        if bladeDanceVar then
                            if cast.deathSweep() then return end
                        end
                -- Blade Dance
                        -- blade_dance,if=variable.blade_dance
                        if bladeDanceVar then
                            if cast.bladeDance() then return end
                        end
                -- Throw Glaive
                        -- throw_glaive,if=talent.bloodlet.enabled&spell_targets>=2+talent.chaos_cleave.enabled&(!talent.master_of_the_glaive.enabled|!talent.momentum.enabled|buff.momentum.up)&(spell_targets>=3|raid_event.adds.in>recharge_time+cooldown)
                        if talent.bloodlet and #enemies.yards30 >= 2 + chaleave and (not talent.masterOfTheGlaive or not talent.momentum or buff.momentum) and (#enemies.yards30 >= 3 or addsIn > recharge.throwGlaive + cd.throwGlaive) then
                            if cast.throwGlaive(units.dyn5) then return end
                        end
                -- Fel Eruption
                        -- fel_eruption
                        if cast.felEruption() then return end
                -- Fel Blade
                        -- felblade,if=fury.deficit>=30+buff.prepared.up*8
                        if powerDeficit >= 30 + (prepared * 8) then
                            if cast.felblade(units.dyn5) then return end
                        end
                -- Annihilation
                        -- annihilation,if=(talent.demon_blades.enabled|!talent.momentum.enabled|buff.momentum.up|fury.deficit<30+buff.prepared.up*8|buff.metamorphosis.remains<5)&!variable.pooling_for_blade_dance
                        if (talent.demonBlades or not talent.momentum or powerDeficit < 30 + prepared * 8 or buff.remain.metamorphosis < 5) and not poolForBladeDance then
                            if cast.annihilation() then return end
                        end
                -- Throw Glaive
                        -- throw_glaive,if=talent.bloodlet.enabled&(!talent.master_of_the_glaive.enabled|!talent.momentum.enabled|buff.momentum.up)&raid_event.adds.in>recharge_time+cooldown
                        if talent.bloodlet and (not talent.masterOfTheGlaive or not talent.momentum or buff.momentum) and addsIn > recharge.throwGlaive + cd.throwGlaive then
                            if cast.throwGlaive() then return end
                        end
                -- Eye Beam
                        -- eye_beam,if=!talent.demonic.enabled&((spell_targets.eye_beam_tick>desired_targets&active_enemies>1)|(raid_event.adds.in>45&!variable.pooling_for_meta&buff.metamorphosis.down&(artifact.anguish_of_the_deceiver.enabled|active_enemies>1)))
                        if not talent.demonic and ((#enemies.yards20 >= getOptionValue("Eye Beam Targets") and #enemies.yards8 > 1) or (addsIn > 45 and not poolForMeta and not buff.metamorphosis and (artifact.anguishOfTheDeceiver or #enemies.yards8 > 1))) and getDistance(units.dyn8) < 8 and getFacing("player",units.dyn5,45) then
                            if cast.eyeBeam(units.dyn8) then return end
                        end
                -- Demon's Bite
                        -- demons_bite,if=talent.demonic.enabled&buff.metamorphosis.down&cooldown.eye_beam.remains<gcd&fury.deficit>=20
                        if talent.demonic and not buff.metamorphosis and cd.eyeBeam < gcd and powerDeficit >= 20 then
                            if cast.demonsBite() then return end
                        end
                        -- demons_bite,if=talent.demonic.enabled&buff.metamorphosis.down&cooldown.eye_beam.remains<2*gcd&fury.deficit>=45
                        if talent.demonic and not buff.metamorphosis and cd.eyeBeam < 2 * gcd and powerDeficit >= 45 then
                            if cast.demonsBite() then return end
                        end
                -- Throw Glaive
                        -- throw_glaive,if=buff.metamorphosis.down&spell_targets>=2
                        if not buff.metamorphosis and #enemies.yards30 >= 2 then
                            if cast.throwGlaive("target") then return end
                        end
                -- Chaos Strike
                        -- chaos_strike,if=(talent.demon_blades.enabled|!talent.momentum.enabled|buff.momentum.up|fury.deficit<30+buff.prepared.up*8)&!variable.pooling_for_meta&!variable.pooling_for_blade_dance&(!talent.demonic.enabled|!cooldown.eye_beam.ready)
                        if (talent.demonBlades or not talent.momentum or buff.momentum or powerDeficit < 30 + prepared * 8) and not poolForMeta and not poolForBladeDance and (not talent.demonic or cd.eyeBeam > 0) then
                            if cast.chaosStrike() then return end
                        end
                -- Fel Barrage
                        -- fel_barrage,if=charges=4&buff.metamorphosis.down&(buff.momentum.up|!talent.momentum.enabled)&(active_enemies>desired_targets|raid_event.adds.in>30)
                        if charges.felBarrage == 4 and not buff.metamorphosis and (buff.momentum or not talent.momentum) and (#enemies.yards20 > getOptionValue("Eye Beam Targets") or addsIn > 30) then
                            if cast.felBarrage(units.dyn5) then return end
                        end
                -- Fel Rush
                        -- fel_rush,animation_cancel=1,if=!talent.momentum.enabled&raid_event.movement.in>charges*10
                        if useMover() and getFacing("player","target",10) and not talent.momentum and moveIn > charges.felRush * 10 then
                            if mode.mover == 1 then
                                if getDistance("target") < 10 then
                                    if cast.felRush("target",false,true) then return end
                                end
                                if getDistance("target") >= 10 then
                                    if cast.felRush() then return end
                                end
                            else
                                if cast.felRush() then return end
                            end
                        end
                -- Demon's Bite
                        -- demons_bite
                        if cast.demonsBite() then return end 
                -- Throw Glaive
                        -- throw_glaive,if=buff.out_of_range.up|buff.raid_movement.up
                        if getDistance("target") >= 15 then 
                            if cast.throwGlaive("target") then return end
                        end
                -- Felblade
                        -- felblade,if=movement.distance|buff.out_of_range.up
                        if getDistance("target") >= 15 then
                            if cast.felblade("target") then return end
                        end
                -- Fel Rush
                        --fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum.enabled)
                        if useMover() and getFacing("player","target",10) and getDistance("target") >= 15 then
                            if cast.felRush() then return end
                        end
                    end -- End SimC APL
        ----------------------
        --- AskMrRobot APL ---
        ----------------------
                    if getOptionValue("APL Mode") == 2 then
                -- Blur
                        -- if ChargesRemaining(FelRush) = 0
                        if charges.felRush == 0 then
                            if cast.blur() then return end
                        end
                -- PostVengeful
                        -- if IsSwitchOn(Vaulted) and not WasLastSpell(VengefulRetreat)
                        if actionList_PostVengeful() then return end
                -- Vengeful Retreat
                        -- if (HasTalent(Prepared) or HasTalent(Momentum)) and 
                        -- ((CooldownSecRemaining(FelRush) <= GlobalCooldownSec or (CanUse(EyeBeam) and CooldownSecRemaining(FelRush) < SpellChannelTimeSec(EyeBeam))) or 
                        -- (HasTalent(Felblade) and CooldownSecRemaining(Felblade) <= GlobalCooldownSec or (CanUse(EyeBeam) and CooldownSecRemaining(Felblade) < SpellChannelTimeSec(EyeBeam))))
                        if useMover() and (talent.prepared or talent.momentum) and ((cd.felRush <= gcd or (castable.eyeBeam and cd.felRush < eyeBeamCastRemain())) or (talent.felblade and cd.felblade <= gcd or (castable.eyeBeam and cd.felblade < eyeBeamCastRemain()))) and getDistance("target") < 5 then
                            if cast.vengefulRetreat() then return end
                        end
                -- Cooldowns
                        if actionList_Cooldowns() then return end
                -- Fury of the Illidari
                        if #enemies.yards8 > 0  and getDistance(units.yards8) < 8 then
                            if cast.furyOfTheIllidari() then return end
                        end
                -- MultiTarget
                        -- if TargetsInRadius(BladeDanceHitAoE) > 1
                        if (#enemies.yards8 > 1 and mode.rotation == 1) or mode.rotation == 2 then
                            if actionList_MultiTarget() then return end
                        end
                -- Single Target
                        if actionList_SingleTarget() then return end
                    end
				end --End In Combat
			end --End Rotation Logic
        end -- End Timer
    end -- End runRotation
    tinsert(cHavoc.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end --End Class Check
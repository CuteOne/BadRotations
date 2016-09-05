if select(2, UnitClass("player")) == "DEMONHUNTER" then
	local rotationName = "Dub"

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
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.metamorphosis},
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.metamorphosis}
        };
       	CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.demonSpikes},
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.demonSpikes}
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
            [1] = { mode = "On", value = 2 , overlay = "Auto Movement Enabled", tip = "Will Cast Movement Abilities.", highlight = 1, icon = bb.player.spell.infernalStrike},
            [2] = { mode = "Off", value = 1 , overlay = "Auto Movement Disabled", tip = "Will NOT Cast Movement Abilities", highlight = 0, icon = bb.player.spell.infernalStrike}
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
                bb.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
                bb.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
                bb.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Eye Beam Targets
                bb.ui:createSpinner(section, "Eye Beam Targets", 3, 1, 10, 1, "|cffFFBB00Number of Targets to use at.")
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
        if bb.timer:useTimer("debugVengeance", math.random(0.15,0.3)) then
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
            if lastSpell == spell.vengefulRetreat then vaulted = true else vaulted = false end
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
                    if isChecked("Consume Magic")  then
                        for i=1, #enemies.yards20 do
                            thisUnit = enemies.yards20[i]
                            if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                                if cast.consumeMagic(thisUnit) then return end
                            end
                        end
                    end
			 	end -- End useInterrupts check
			end -- End Action List - Interrupts
        -- Action List - Single Target
            local function actionList_SingleTarget()

            end -- End Action List - Single Target
        -- Action List - MultiTarget
            local function actionList_MultiTarget()

            end -- End Action List - Multi Target
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if useCDs() and getDistance(units.dyn5) < 5 then

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
                            if not UnitBuffID("player",193456) and not UnitBuffID("player",188033) and canUse(129192) then -- Gaze of the Legion
                                useItem(129192)
                                return true
                            end
                        end
                    end
                    if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

                    end -- End Pre-Pull
                    if ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") and getDistance("target") < 5 then
                -- Start Attack
                        StartAttack()
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
                if inCombat and profileStop==false and ObjectExists(units.dyn5) and not UnitIsDeadOrGhost(units.dyn5) and UnitCanAttack(units.dyn5, "player") then
        ------------------------------
        --- In Combat - Interrupts ---
        ------------------------------
                    if actionList_Interrupts() then return end
        ---------------------------
        --- SimulationCraft APL ---
        ---------------------------
                    -- print(cast.sigilofFlame())
                    -- if true then return end
            -- actions=auto_attack
                    if getDistance(units.dyn5) < 5 then
                        StartAttack()
                    end
                    if isChecked("Trinkets") and getDistance("target") < 5 then
                        if canUse(13) then
                            useItem(13)
                        end
                        if canUse(14) and getNumEnemies("player",12) >= 1 then
                            useItem(14)
                        end                            
                    end
            -- actions+=/fiery_brand,if=buff.demon_spikes.down&buff.metamorphosis.down
            --TODO
                    -- if power >= 30 and php <= 60 and soulAmount() >= 1 then
                    --     if cast.soulCleave() then return end
                    -- end
            -- actions+=/demon_spikes,if=charges=2|buff.demon_spikes.down&!dot.fiery_brand.ticking&buff.metamorphosis.down
                    if ( recharge.demonSpikes <= 6 and charges.demonSpikes >= 1) and hasThreat() and not buff.demonSpikes and not debuff.fieryBrand and not buff.metamorphosis then
                        if cast.demonSpikes() then return end
                    end
            -- actions+=/empower_wards,if=debuff.casting.up
            -- actions+=/infernal_strike,if=!sigil_placed&!in_flight&remains-travel_time-delay<0.3*duration&artifact.fiery_demise.enabled&dot.fiery_brand.ticking
            -- actions+=/infernal_strike,if=!sigil_placed&!in_flight&remains-travel_time-delay<0.3*duration&(!artifact.fiery_demise.enabled|(max_charges-charges_fractional)*recharge_time<cooldown.fiery_brand.remains+5)&(cooldown.sigil_of_flame.remains>7|charges=2)
                    if recharge.infernalStrike <= 2 and getDistance("target") < 5 then
                        if cast.infernalStrike("player") then return end
                    end
            -- actions+=/spirit_bomb,if=debuff.frailty.down
                    if not UnitDebuffID("target",224509) then
                        if cast.spiritBomb("target") then return end
                    end
            -- actions+=/soul_carver,if=dot.fiery_brand.ticking
                    if cast.soulCarver() then return end
                    -- if UnitDebuffID("target",207744) then
                    --     if cast.soulCarver() then return end
                    -- end
            -- actions+=/immolation_aura,if=pain<=80
                    if power <= 80 and getDistance("target") < 5 then
                        if cast.immolationAura() then return end
                    end
            -- actions+=/felblade,if=pain<=70
                    if power <= 70 then
                        if cast.felblade() then return end
                    end
            -- actions+=/soul_barrier
            -- actions+=/soul_cleave,if=soul_fragments=5
                    if soulAmount() == 5 and power >= 30 then
                        if cast.soulCleave() then return end
                    end
            -- actions+=/metamorphosis,if=buff.demon_spikes.down&!dot.fiery_brand.ticking&buff.metamorphosis.down&incoming_damage_5s>health.max*0.70
            -- actions+=/fel_devastation,if=incoming_damage_5s>health.max*0.70
                    if cast.felDevastation() then dub.felDevastation = false; return end
            -- actions+=/soul_cleave,if=incoming_damage_5s>=health.max*0.70
                    if power >= 30 and php <= 70 then
                        if cast.soulCleave() then return end
                    end
            -- actions+=/fel_eruption
            -- actions+=/sigil_of_flame,if=remains-delay<=0.3*duration
                    if not isMoving("target") and getTimeToDie() > 10 then
                        if cast.sigilofFlame("target") then return end
                    end
            -- actions+=/fracture,if=pain>=80&soul_fragments<4&incoming_damage_4s<=health.max*0.20
            -- actions+=/soul_cleave,if=pain>=80
                    if power >= 80 then
                        if cast.soulCleave() then return end
                    end
            -- actions+=/shear
                    if power < 80 then
                        if cast.shear() then return end
                    end
                    if getDistance("target") > 5 then
                        if cast.throwGlaive("target") then return end
                    end
				end --End In Combat
			end --End Rotation Logic
        end -- End Timer
    end -- End runRotation
    tinsert(cVengeance.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end --End Class Check
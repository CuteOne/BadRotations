if select(2, UnitClass("player")) == "ROGUE" then
    local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
    local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = bb.player.spell.bladeFlurry },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.bladeFlurry },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.saberSlash },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.crimsonVial }
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.adrenalineRush },
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.adrenalineRush },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.adrenalineRush }
        };
        CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.riposte },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.riposte }
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
            [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = bb.player.spell.kick },
            [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = bb.player.spell.kick }
        };
        CreateButton("Interrupt",4,0)
    -- Cleave Button
        CleaveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = bb.player.spell.bladeFlurry },
            [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = bb.player.spell.saberSlash }
        };
        CreateButton("Cleave",5,0)
    -- Pick Pocket Button
      	PickerModes = {
          [1] = { mode = "Auto", value = 2 , overlay = "Auto Pick Pocket Enabled", tip = "Profile will attempt to Pick Pocket prior to combat.", highlight = 1, icon = bb.player.spell.pickPocket},
          [2] = { mode = "Only", value = 1 , overlay = "Only Pick Pocket Enabled", tip = "Profile will attempt to Sap and only Pick Pocket, no combat.", highlight = 0, icon = bb.player.spell.pickPocket},
          [3] = { mode = "Off", value = 3, overlay = "Pick Pocket Disabled", tip = "Profile will not use Pick Pocket.", highlight = 0, icon = bb.player.spell.pickPocket}
        };
        CreateButton("Picker",6,0)
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
            section = bb.ui:createSection(bb.ui.window.profile,  "General")
            	-- Bribe
            	bb.ui:createCheckbox(section, "Bribe")
	            -- Dummy DPS Test
                bb.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
	            -- Grappling Hook
	            bb.ui:createCheckbox(section, "Grappling Hook")
	            -- Opening Attack
	            bb.ui:createDropdown(section, "Opener", {"Ambush", "Cheap Shot"},  1, "|cffFFFFFFSelect Attack to Break Stealth with")
	            -- Pre-Pull Timer
	            bb.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            	-- Stealth
	            bb.ui:createDropdown(section, "Stealth", {"|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards"},  1, "Stealth method.")
            bb.ui:checkSectionState(section)
            ------------------------
            --- COOLDOWN OPTIONS ---
            ------------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "Cooldowns")
                -- Agi Pot
	            bb.ui:createCheckbox(section, "Agi-Pot")
	            -- Legendary Ring
	            bb.ui:createCheckbox(section, "Legendary Ring")
	            -- Vanish
	            bb.ui:createCheckbox(section,  "Vanish")
            bb.ui:checkSectionState(section)
            -------------------------
            --- DEFENSIVE OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
            	-- Healthstone
	            bb.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
	            -- Heirloom Neck
	            bb.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
	            -- Cloak of Shadows
	            bb.ui:createCheckbox(section, "Cloak of Shadows")
	            -- Crimson Vial
	            bb.ui:createSpinner(section, "Crimson Vial",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
	            -- Feint
	            bb.ui:createSpinner(section, "Feint", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
	            -- Riposte
	            bb.ui:createSpinner(section, "Riposte",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            bb.ui:checkSectionState(section)
            -------------------------
            --- INTERRUPT OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
            	-- Kick
            	bb.ui:createCheckbox(section, "Kick")
            	-- Gouge
            	bb.ui:createCheckbox(section, "Gouge")
            	-- Blind
            	bb.ui:createCheckbox(section, "Blind")
            	-- Parley
            	bb.ui:createCheckbox(section, "Parley")
            	-- Between the Eyes
            	bb.ui:createCheckbox(section, "Between the Eyes")	
	            -- Interrupt Percentage
	            bb.ui:createSpinner(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")    
            bb.ui:checkSectionState(section)
            ----------------------
            --- TOGGLE OPTIONS ---
            ----------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "Toggle Keys")
            	-- Single/Multi Toggle
	            bb.ui:createDropdown(section,  "Rotation Mode", bb.dropOptions.Toggle,  4)
	            --Cooldown Key Toggle
	            bb.ui:createDropdown(section,  "Cooldown Mode", bb.dropOptions.Toggle,  3)
	            --Defensive Key Toggle
	            bb.ui:createDropdown(section,  "Defensive Mode", bb.dropOptions.Toggle,  6)
	            -- Interrupts Key Toggle
	            bb.ui:createDropdown(section,  "Interrupt Mode", bb.dropOptions.Toggle,  6)
	            -- Cleave Toggle
	            bb.ui:createDropdown(section,  "Cleave Mode", bb.dropOptions.Toggle,  6)
	            -- Pick Pocket Toggle
	            bb.ui:createDropdown(section,  "Pick Pocket Mode", bb.dropOptions.Toggle,  6)
	            -- Pause Toggle
	            bb.ui:createDropdown(section,  "Pause Mode", bb.dropOptions.Toggle,  6)   
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
        if bb.timer:useTimer("debugOutlaw", math.random(0.15,0.3)) then
            --print("Running: "..rotationName)

    ---------------
    --- Toggles ---
    ---------------
            UpdateToggle("Rotation",0.25)
            UpdateToggle("Cooldown",0.25)
            UpdateToggle("Defensive",0.25)
            UpdateToggle("Interrupt",0.25)
            UpdateToggle("Cleave",0.25)
            UpdateToggle("Picker",0.25)

	--------------
	--- Locals ---
	--------------
			if profileStop == nil then profileStop = false end
			local addsIn                                        = 999
			local artifact 										= bb.player.artifact
			local attacktar 									= UnitCanAttack("target","player")
			local buff, buffRemain								= bb.player.buff, bb.player.buff.remain
			local cast 											= bb.player.cast
			local castable 										= bb.player.cast.debug
			local cd 											= bb.player.cd
			local charge 										= bb.player.charges
			local combo, comboDeficit, comboMax					= bb.player.comboPoints, bb.player.comboPointsMax - bb.player.comboPoints, bb.player.comboPointsMax
			local cTime 										= getCombatTime()
			local deadtar										= UnitIsDeadOrGhost("target")
			local debuff 										= bb.player.debuff
			local dynTar5 										= bb.player.units.dyn5 --Melee
			local dynTar15 										= bb.player.units.dyn15 
			local dynTar20AoE 									= bb.player.units.dyn20AoE --Stealth
			local dynTar30AoE 									= bb.player.units.dyn30AoE
			local dynTable5										= (bb.data['Cleave']==1 and bb.enemy) or { [1] = {["unit"]=dynTar5, ["distance"] = getDistance(dynTar5)}}
			local dynTable15									= (bb.data['Cleave']==1 and bb.enemy) or { [1] = {["unit"]=dynTar15, ["distance"] = getDistance(dynTar15)}}
			local dynTable20AoE 								= (bb.data['Cleave']==1 and bb.enemy) or { [1] = {["unit"]=dynTar20AoE, ["distance"] = getDistance(dynTar20AoE)}}
			local enemies										= bb.player.enemies
			local flaskBuff, canFlask							= getBuffRemain("player",bb.player.flask.wod.buff.agilityBig), canUse(bb.player.flask.wod.agilityBig)	
			local gcd 											= bb.player.gcd
			local glyph				 							= bb.player.glyph
			local hastar 										= ObjectExists("target")
			local healPot 										= getHealthPot()
			local inCombat 										= bb.player.inCombat
			local lastSpell 									= lastSpellCast
			local level											= bb.player.level
			local mode 											= bb.player.mode
			local multidot 										= (useCleave() or bb.player.mode.rotation ~= 3)
			local perk											= bb.player.perk
			local php											= bb.player.health
			local power, powerDeficit, powerRegen				= bb.player.power, bb.player.powerDeficit, bb.player.powerRegen
			local pullTimer 									= bb.DBM:getPulltimer()
			local rtbCount 										= bb.rtbCount
			local solo											= GetNumGroupMembers() == 0	
			local spell 										= bb.player.spell
			local stealth 										= bb.player.buff.stealth
			local stealthing 									= bb.player.buff.stealth or bb.player.buff.vanish or bb.player.buff.shadowmeld
			local t18_4pc 										= bb.player.eq.t18_4pc
			local talent 										= bb.player.talent
			local time 											= getCombatTime()
			local ttd 											= getTTD
			local ttm 											= bb.player.powerTTM
			local units 										= bb.player.units

			if (not inCombat and UnitExists("target") and (UnitIsEnemy("target","player") or isDummy("target")) and not UnitIsDeadOrGhost("target") and getDistance("target") < 5) 
				or (inCombat and UnitExists(units.dyn5) and (UnitIsEnemy(units.dyn5,"player") or isDummy(units.dyn5)) and not UnitIsDeadOrGhost(units.dyn5) and getDistance(units.dyn5) < 5) 
			then 
				validMeleeUnit = true
			else
				validMeleeUnit = false
			end
			if talent.deeperStrategem then dStrat = 1 else dStrat = 0 end
			if talent.quickDraw then qDraw = 1 else qDraw = 0 end
			if talent.ghostlyStrike and not debuff.ghostlyStrike then gsBuff = 1 else gsBuff = 0 end
			if buff.broadsides then broadUp = 1 else broadUp = 0 end
			if buff.broadsides and buff.jollyRoger then broadRoger = 1 else broadRoger = 0 end
			if talent.alacrity and buff.stack.alacrity <= 4 then lowAlacrity = 1 else lowAlacrity = 0 end
			if talent.anticipation then antital = 1 else antital = 0 end
			if cd.deathFromAbove == 0 then dfaCooldown = 1 else dfaCooldown = 0 end
			if vanishTime == nil then vanishTime = GetTime() end
			if buff.broadsides or buff.buriedTreasure or buff.grandMelee or buff.jollyRoger or buff.sharkInfestedWaters then rtbBuff5 = true else rtbBuff5 = false end
			if buff.broadsides or buff.buriedTreasure or buff.grandMelee or buff.jollyRoger or buff.sharkInfestedWaters or buff.trueBearing then rtbBuff6 = true else rtbBuff6 = false end

			-- rtb_reroll,value=!talent.slice_and_dice.enabled&(rtb_buffs<=1&!rtb_list.any.6&((!buff.curse_of_the_dreadblades.up&!buff.adrenaline_rush.up)|!rtb_list.any.5))
			if not talent.sliceAndDice and (buff.count.rollTheBones <= 1 and not rtbBuff6 and ((not buff.curseOfTheDreadblades and not buff.adrenalineRush) or not rtbBuff5)) then
				rtbReroll = true
			else
				rtbReroll = false
			end			
			-- ss_useable_noreroll,value=(combo_points<5+talent.deeper_stratagem.enabled-(buff.broadsides.up|buff.jolly_roger.up)-(talent.alacrity.enabled&buff.alacrity.stack<=4))
			if combo < 5 + dStrat - broadRoger - lowAlacrity then
				ssUsableNoreroll = true
			else
				ssUsableNoreroll = false
			end 
			-- ss_useable,value=(talent.anticipation.enabled&combo_points<4)|(!talent.anticipation.enabled&((variable.rtb_reroll&combo_points<4+talent.deeper_stratagem.enabled)|(!variable.rtb_reroll&variable.ss_useable_noreroll)))
			if (talent.anticipation and combo < 4) or (not talent.anticipation and ((rtbReroll and combo < 4 + dStrat) or (not rtbReroll and ssUsableNoreroll))) then
				ssUsable = true
			else
				ssUsable = false
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
	                        ChatOverlay(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
	                        profileStop = true
	                    end
	                end
	            end
	    -- Pick Pocket
	        	if usePickPocket() then
        			if UnitCanAttack(units.dyn5,"player") and (UnitExists(units.dyn5) or mode.pickPocket == 2) and mode.pickPocket ~= 3 then
	        			if not isPicked(units.dyn5) and not isDummy(units.dyn5) then
	        				if debuff.remain.sap < 1 and mode.pickPocket ~= 1 then
	        					if cast.sap(units.dyn5) then return end
	        				end
	        				if cast.pickPocket() then return end
	        			end
	        		end
	        	end
	    -- Bribe
	    		if isChecked("Bribe") then
	    			if cast.bribe() then return end
	    		end
        -- Grappling Hook
                if isChecked("Grappling Hook") and (hasThreat("target") or (solo and UnitExists("target"))) then
                    if cast.grapplingHook("target") then return end 
                end
        -- Pistol Shot
        		if (hasThreat("target") or (solo and UnitExists("target"))) and power > 75 and (not inCombat or getDistance("target") > 5) and not stealthing then
        			if cast.pistolShot("target") then return end
        		end
			end -- End Action List - Extras
		-- Action List - Defensives
			local function actionList_Defensive()
				if useDefensive() and not stealth then
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
		    	-- Cloak of Shadows
		    		if isChecked("Cloak of Shaodws") and canDispel("player",spell.cloakOfShadows) then
		    			if cast.cloakOfShadows() then return end
		    		end
				-- Crimson Vial
					if isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") then
						if cast.crimsonVial() then return end
					end
				-- Feint
					if isChecked("Feint") and php <= getOptionValue("Feint") and inCombat then
						if cast.feint() then return end
					end
				-- Riposte
					if isChecked("Riposte") and php <= getOptionValue("Riposte") and inCombat then
						if cast.riposte() then return end
					end
	            end
			end -- End Action List - Defensive
		-- Action List - Interrupts
			local function actionList_Interrupts()
				if useInterrupts() and not stealth then
					for i = 1, #enemies.yards20 do
						local thisUnit = enemies.yards20[i]
						local distance = getDistance(thisUnit)
						if canInterrupt(thisUnit,getOptionValue("Interrupt At")) and hasThreat(thisUnit) then
							if distance < 5 then
			-- Kick
								-- kick
								if isChecked("Kick") then
									if cast.kick(thisUnit) then return end
								end
								if cd.kick ~= 0 then
			-- Gouge
									if isChecked("Gouge") and getFacing(thisUnit,"player") then
										if cast.gouge(thisUnit) then return end
									end
								end
							end
							if (cd.kick ~= 0 and cd.gouge ~= 0) or (distance >= 5 and distance < 15) then 
			-- Blind
								if isChecked("Blind") then
									if cast.blind(thisUnit) then return end
								end
								if isChecked("Parley") then
									if cast.parley(thisUnit) then return end
								end	 
							end
			-- Between the Eyes
							if ((cd.kick ~= 0 and cd.gouge ~= 0) or distance >= 5) and (cd.blind ~= 0 or level < 38 or distance >= 15) then
								if isChecked("Between the Eyes") then
									if cast.betweenTheEyes(thisUnit) then return end
								end
							end
						end
					end
				end -- End Interrupt and No Stealth Check
			end -- End Action List - Interrupts
		-- Action List - Blade Flurry
			local function actionList_BladeFlurry()
			-- Blade Flurry
				-- cancel_buff,name=blade_flurry,if=equipped.shivarran_symmetry&cooldown.blade_flurry.up&buff.blade_flurry.up&spell_targets.blade_flurry>=2|spell_targets.blade_flurry<2&buff.blade_flurry.up
				if not useAoE() and buff.bladeFlurry then
					if cast.bladeFlurry() then return end
				end
				-- blade_flurry,if=spell_targets.blade_flurry>=2&!buff.blade_flurry.up
				if useAoE() and not buff.bladeFlurry then
					if cast.bladeFlurry() then return end
				end
			end
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if useCDs() and getDistance(units.dyn5) < 5 then
			-- Cannonball Barrage
					-- cannonball_barrage,if=spell_targets.cannonball_barrage>=1
					if #enemies.yards35 >= 1 then
						if cast.cannonballBarrage() then return end
					end
			-- Adrenaline Rush
					-- adrenaline_rush,if=!buff.adrenaline_rush.up&energy.deficit>0
					if not buff.adrenalineRush and powerDeficit > 0 then
						if cast.adrenalineRush() then return end
					end
			-- Marked For Death
					-- marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit|((raid_event.adds.in>40|buff.true_bearing.remains>15)&combo_points.deficit>=4+talent.deeper_strategem.enabled+talent.anticipation.enabled)
					if (ttd(units.dyn5) < comboDeficit or ((addsIn > 40 or buff.remain.trueBearing > 15) and comboDeficit >= 4 + dStrat + antital)) and not stealthing then
						if cast.markedForDeath() then return end
					end
			-- Sprint
					-- sprint,if=equipped.thraxis_tricksy_treads&!variable.ss_useable
					if hasEquiped(137031) and not ssUsable then
						if cast.sprint() then return end
					end
			-- Curse of the Dreadblades
					-- curse_of_the_dreadblades,if=combo_points.deficit>=4&(!talent.ghostly_strike.enabled|debuff.ghostly_strike.up)
					if comboDeficit >= 4 and (not talent.ghostlyStrike or debuff.ghostlyStrike) then
						if cast.curseOfTheDreadblades() then return end
					end
				end -- End Cooldown Usage Check
			end -- End Action List - Cooldowns
		-- Action List - PreCombat
			local function actionList_PreCombat()
			-- Stealth
				-- stealth
				if isChecked("Stealth") and (not IsResting() or isDummy()) then
					if getOptionValue("Stealth") == 1 then
						if cast.stealth() then return end
					end
					if getOptionValue("Stealth") == 2 then
						for i=1, #enemies.yards20 do
                            local thisUnit = enemies.yards20
                            if getDistance(thisUnit) < 20 then
                                if ObjectExists(thisUnit) and UnitCanAttack(thisUnit,"player") and GetTime()-leftCombat > lootDelay then
                                    if cast.stealth() then return end
                                end
                            end
                        end
                    end
				end
			-- Marked for Death
				-- marked_for_death
				if getDistance("target") < 30 then
					if cast.markedForDeath("target") then return end
				end
			-- Roll The Bones
				-- roll_the_bones,if=!talent.slice_and_dice.enabled
				if not talent.sliceAndDice and not buff.count.rollTheBones == 0 and getDistance("target") < 5 then
					if cast.rollTheBones() then return end
				end
			end -- End Action List - PreCombat
		-- Action List - Finishers
			local function actionList_Finishers()
			-- Between the Eyes
				-- between_the_eyes,if=equipped.greenskins_waterlogged_wristcuffs&buff.shark_infested_waters.up
				if hasEquiped(137099) and buff.sharkInfestedWaters then
					if cast.betweenTheEyes() then return end
				end
			-- Run Through
				-- run_through,if=!talent.death_from_above.enabled|energy.time_to_max<cooldown.death_from_above.remains+3.5
				if not talent.deathFromAbove or ttm < cd.deathFromAbove + 3.5 then
					if cast.runThrough() then return end
				end
			end -- End Action List - Finishers
		-- Action List - Generators
			local function actionList_Generators()
			-- Ghostly Strike
				-- ghostly_strike,if=combo_points.deficit>=1+buff.broadsides.up&!buff.curse_of_the_dreadblades.up&(debuff.ghostly_strike.remains<debuff.ghostly_strike.duration*0.3|(cooldown.curse_of_the_dreadblades.remains<3&debuff.ghostly_strike.remains<14))&(combo_points>=3|(variable.rtb_reroll&time>=10))
				if comboDeficit >= 1 + broadUp and not buff.curseOfTheDreadblades and ((not debuff.ghostlyStrike or debuff.remain.ghostlyStrike < debuff.duration.ghostlyStrike * 0.3) 
					or (cd.curseOfTheDreadblades < 3 and debuff.remain.ghostlyStrike < 14)) and (combo >= 3 or (rtbReroll and cTime >= 10)) 
				then
					if cast.ghostlyStrike() then return end
				end
			-- Pistol Shot
				-- pistol_shot,if=combo_points.deficit>=1+buff.broadsides.up&buff.opportunity.up&energy.time_to_max>2-talent.quick_draw.enabled
				if comboDeficit >= 1 + broadUp and buff.opportunity and ttm > 2 - qDraw and not stealthing then
					if cast.pistolShot() then return end
				end
			-- Saber Slash
				-- saber_slash
				if ssUsable then
					if cast.saberSlash() then return end
				end
			end -- End Action List - Generators
		-- Action List - Stealth
			local function actionList_Stealth()
				-- stealth_condition,value=(combo_points.deficit>=2+2*(talent.ghostly_strike.enabled&!debuff.ghostly_strike.up)+buff.broadsides.up&energy>60&!buff.jolly_roger.up&!buff.hidden_blade.up&!buff.curse_of_the_dreadblades.up)
				if ((comboDeficit >= 2 + 2 * gsBuff + broadUp) and power > 60 and not buff.jollyRoger and not buff.hiddenBlade and not buff.curseOfTheDreadblades) and not buff.stealth then
					stealthable = true
				else
					stealthable = false
				end
			-- Ambush/Cheap Shot
				-- ambush
				if UnitExists("target") and (UnitIsEnemy("target","player") or isDummy("target")) and not UnitIsDeadOrGhost("target") and getDistance("target") < 5 and stealthing then
					if getOptionValue("Opener") == 1 then
						if power <= 60 then
							return true
						else
							if cast.ambush() then return end
						end
					else
						if power <= 40 then
							return true
						else
							if cast.cheapShot() then return end
						end
					end
				end
			-- Vanish
				-- vanish,if=variable.stealth_condition
				if useCDs() and isChecked("Vanish") and stealthable and inCombat and UnitExists(units.dyn5) and (UnitIsEnemy(units.dyn5,"player") or isDummy(units.dyn5)) 
					and not UnitIsDeadOrGhost(units.dyn5) and getDistance(units.dyn5) < 5 
				then
					if cast.vanish() then return end
				end
			-- Shadowmeld
				-- shadowmeld,if=variable.stealth_condition
				if useCDs() and isChecked("Use Racial") and bb.player.race == "NightElf" and stealthable and inCombat and UnitExists(units.dyn5) 
					and (UnitIsEnemy(units.dyn5,"player") or isDummy(units.dyn5)) and not UnitIsDeadOrGhost(units.dyn5) and getDistance(units.dyn5) < 5
					and not buff.vanish and cd.vanish ~= 0 and not moving
				then
					if cast.shadowmeld() then return end
				end
			end
	---------------------
	--- Begin Profile ---
	---------------------
		--Profile Stop | Pause
			if not inCombat and not hastar and profileStop == true then
				profileStop = false
			elseif (inCombat and profileStop == true) or pause() or mode.rotation == 4 then
				if inCombat and mode.rotation == 4 then StopAttack() end
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
				if (not inCombat or buff.stealth) then
					if actionList_PreCombat() then return end
				end
	--------------------------
	--- In Combat Rotation ---
	--------------------------
				if profileStop==false then
					if UnitIsDeadOrGhost("target") then ClearTarget(); end
	            	if not stealthing or level < 5 then          	
	------------------------------
	--- In Combat - Interrupts ---
	------------------------------
						if actionList_Interrupts() then return end
	--------------------------------
	--- In Combat - Blade Flurry ---
	--------------------------------
						if actionList_BladeFlurry() then return end
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
						if actionList_Cooldowns() then return end
					end
	---------------------------
	--- In Combat - Stealth ---
	---------------------------
					if getDistance(units.dyn5) < 5 and (hasThreat(units.dyn5) or isDummy(units.dyn5) or UnitExists("target")) then
						-- call_action_list,name=stealth,if=stealthed|cooldown.vanish.up|cooldown.shadowmeld.up
						if stealthing or cd.vanish == 0 or cd.shadowmeld == 0 then
							if actionList_Stealth() then return end
						end
	----------------------------------
	--- In Combat - Begin Rotation ---
	----------------------------------
						-- if not buff.stealth and not buff.vanish and not buff.shadowmeld and GetTime() > vanishTime + 2 and getDistance(units.dyn5) < 5 then			
						if not stealthing and inCombat then 
							StartAttack()
			-- Death from Above
							-- death_from_above,if=energy.time_to_max>2&!variable.ss_useable_noreroll
							if ttm > 2 and not ssUsableNoreroll then
								if cast.deathFromAbove() then return end
							end
			-- Slice and Dice
							-- slice_and_dice,if=!variable.ss_useable&buff.slice_and_dice.remains<target.time_to_die&buff.slice_and_dice.remains<(1+combo_points)*1.8
							if not ssUsable and buff.remain.sliceAndDice < ttd(units.dyn5) and buff.remain.sliceAndDice < (1 + combo) * 1.8 then
								if cast.sliceAndDice() then return end
							end
			-- Roll the Bones
							-- roll_the_bones,if=combo_points>=5&buff.roll_the_bones.remains<target.time_to_die&(buff.roll_the_bones.remains<=3|rtb_buffs<=1)
							-- roll_the_bones,if=!variable.ss_useable&buff.roll_the_bones.remains<target.time_to_die&(buff.roll_the_bones.remains<=3|variable.rtb_reroll)
							if not ssUsable and buff.remain.rollTheBones < ttd(units.dyn5) and (buff.remain.rollTheBones <= 3 or rtbReroll) then
								if cast.rollTheBones() then return end
							end
			-- Killing Spree
							-- killing_spree,if=energy.time_to_max>5|energy<15
							if useCDs() and (ttm > 5 or power < 15) then
								if cast.killingSpree() then return end
							end
			-- Generators
							-- call_action_list,name=build
							if actionList_Generators() then return end
			-- Finishers
							-- call_action_list,name=finish,if=!variable.ss_useable
							if not ssUsable then
								if actionList_Finishers() then return end
							end
			-- Gouge
							-- gouge,if=talent.dirty_tricks.enabled&combo_points.deficit>=1
							if talent.dirtyTricks and comboDeficit >= 1 and getFacing(thisUnit,"player") then
								if cast.gouge() then return end
							end
						end
					end
				end -- End In Combat
			end -- End Profile
	    end -- Timer
	end -- runRotation
	tinsert(cOutlaw.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end -- End Class Check
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
            	-- Stealth
	            bb.ui:createDropdown(section,  "Stealth", {"|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards"},  1, "Stealthing method.")
	            -- Grappling Hook
	            bb.ui:createCheckbox(section,  "Grappling Hook")
	            -- Opening Attack
	            bb.ui:createDropdown(section, "Opener", {"Ambush", "Cheap Shot"},  1, "|cffFFFFFFSelect Attack to Break Stealth with")
	            -- Pre-Pull Timer
	            bb.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
	            -- Dummy DPS Test
                bb.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
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
	            -- Crimson Vial
	            bb.ui:createSpinner(section, "Crimson Vial",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
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
			local artifact 										= bb.player.artifact
			local attacktar 									= UnitCanAttack("target","player")
			local buff, buffRemain								= bb.player.buff, bb.player.buff.remain
			local cast 											= bb.player.cast
			local castable 										= bb.player.cast.debug
			local cd 											= bb.player.cd
			local charge 										= bb.player.charges
			local combo, comboDeficit, comboMax					= bb.player.comboPoints, bb.player.comboPointsMax - bb.player.comboPoints, bb.player.comboPointsMax
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
			local stealth 										= bb.player.stealth
			local t18_4pc 										= bb.player.eq.t18_4pc
			local talent 										= bb.player.talent
			local time 											= getCombatTime()
			local ttd 											= getTTD
			local ttm 											= bb.player.powerTTM
			local units 										= bb.player.units

			if talent.deeperStrategem then dStrat = 1 else dStrat = 0 end
			if not debuff.ghostlyStrike then gsBuff = 1 else gsBuff = 0 end
			if buff.broadsides and buff.jollyRoger then broadRoger = 1 else broadRoger = 0 end
			if cd.deathFromAbove == 0 then dfaCooldown = 1 else dfaCooldown = 0 end
			if vanishTime == nil then vanishTime = GetTime() end

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
        			if not UnitIsUnit("target","player") and (UnitExists("target") or mode.pickPocket == 2) and mode.pickPocket ~= 3 then
	        			if not isPicked(units.dyn5) and not isDummy() then
	        				if debuff.remain.sap < 1 and mode.pickPocket ~= 1 then
	        					if cast.sap(units.dyn5) then return end
	        				end
	        				if cast.pickPocket() then return end
	        			end
	        		end
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
				-- Crimson Vial
					if isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") then
						if cast.crimsonVial() then return end
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
						if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
							if distance < 5 then
			-- Kick
								-- kick
								if isChecked("Kick") then
									if cast.kick(thisUnit) then return end
								end
								if cd.kick ~= 0 then
			-- Gouge
									if isChecked("Gouge") then
										if cast.gouge(thisUnit) then return end
									end
								end
							end
							if (cd.kick ~= 0 and cd.gouge ~= 0) or (distance >= 5 and distance < 15) then 
			-- Blind
								if isChecked("Blind") then
									if cast.blind(thisUnit) then return end
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
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if useCDs() and getDistance(units.dyn5) < 5 then
			-- Vanish/Shadowmeld
					-- pool_resource,for_next=1,extra_amount=60
					-- vanish,if=combo_points.deficit>=2&energy>60
					-- shadowmeld,if=combo_points.deficit>=2&energy>60
					if not buff.stealth and comboDeficit >= 2 + 2 * gsBuff and (cd.vanish == 0 or cd.shadowmeld == 0) and (not solo or isDummy()) then
						if power <= 60 then
							return true
						elseif power > 60 then
							if isChecked("Vanish") and not buff.stealth then
								if cast.vanish() then vanishTime = GetTime(); return end
							end
							if isChecked("Use Racial") and bb.player.race == "NightElf" and ((cd.vanish > 0 and cd.vanish < 170) or level < 32) then
								if cast.shadowmeld() then vanishTime = GetTime(); return end
							end
						end
					end
				end -- End Cooldown Usage Check
			end -- End Action List - Cooldowns
		-- Action List - PreCombat
			local function actionList_PreCombat()
			-- Stealth
				-- stealth
				if isChecked("Stealth") and (GetRestState() ~= 1 or isDummy()) then
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
			-- Blade Flurry
				-- blade_flurry,if=(spell_targets.blade_flurry>=2&!buff.blade_flurry.up)|(spell_targets.blade_flurry<2&buff.blade_flurry.up)
				if (useAoE() and not buff.bladeFlurry) or (not useAoE() and buff.bladeFlurry) then
					if cast.bladeFlurry() then return end
				end
			end -- End Action List - PreCombat
		-- Action List - Opener
			local function actionList_Opener()
				if (not inCombat and UnitExists("target") and UnitCanAttack("target","player") and not UnitIsDeadOrGhost("target")) or (inCombat and (hasThreat("target") or isDummy())) then
				-- Grappling Hook
	                if isChecked("Grappling Hook") and (hasThreat("target") or solo) then
	                    if cast.grapplingHook("target") then return end 
	                end
	            -- Ambush / Cheap Shot
					-- pool_resource,for_next=1
					-- ambush
					if buff.stealth then
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
	            -- Start Attack
	            	if (not buff.stealth and not buff.shadowmeld and not buff.vanish) or level < 5 then
	            		if mode.rotation ~= 4 then
	            			StartAttack()
	            		end
	            	end
	            end
			end -- End Action List - Opener
		-- Action List - Finishers
			local function actionList_Finishers()
			-- Between the Eyes
				-- between_the_eyes,if=equipped.greenskins_waterlogged_wristcuffs&buff.shark_infested_waters.up
				-- TODO
			-- Run Through
				-- run_through,if=!talent.death_from_above.enabled|energy.time_to_max<cooldown.death_from_above.remains+3.5
				if not talent.deathFromAbove or ttm < cd.deathFromAbove + 3.5 then
					if cast.runThrough() then return end
				end
			end -- End Action List - Finishers
		-- Action List - Generators
			local function actionList_Generators()
			-- Ghostly Strike
				-- ghostly_strike,if=talent.ghostly_strike.enabled&debuff.ghostly_strike.remains<4.5
				if talent.ghostlyStrike and debuff.remain.ghostlyStrike < 4.5 then
					if cast.ghostlyStrike() then return end
				end
			-- Pistol Shot
				-- pistol_shot,if=buff.opportunity.up&energy.time_to_max>2
				if buff.opportunity and ttm > 2 then
					if cast.pistolShot() then return end
				end
			-- Saber Slash
				-- saber_slash
				if cast.saberSlash() then return end
			end -- End Action List - Generators
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
				if actionList_PreCombat() then return end
	----------------------------
	--- Out of Combat Opener ---
	----------------------------
				if actionList_Opener() then return end
	--------------------------
	--- In Combat Rotation ---
	--------------------------
				if inCombat and profileStop==false then
					if UnitIsDeadOrGhost("target") then ClearTarget(); end
	------------------------------
	--- In Combat - Interrupts ---
	------------------------------
					if actionList_Interrupts() then return end
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
					if actionList_Cooldowns() then return end
	----------------------------------
	--- In Combat - Begin Rotation ---
	----------------------------------
					if not buff.stealth and not buff.vanish and not buff.shadowmeld and GetTime() > vanishTime + 2 and getDistance(units.dyn5) < 5 then
						ObjectInteract(units.dyn5)
			-- Ambush / Cheap Shot
						-- pool_resource,for_next=1
						-- ambush
						if buff.stealth then
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
			-- Vanish/Shadowmeld
						-- pool_resource,for_next=1,extra_amount=60
						-- vanish,if=combo_points.deficit>=2&energy>60
						-- shadowmeld,if=combo_points.deficit>=2&energy>60
						if useCDs() and getDistance(units.dyn5) < 5 and not buff.stealth and comboDeficit >= 2 + 2 * gsBuff and (cd.vanish == 0 or cd.shadowmeld == 0) and (not solo or isDummy()) then
							if power <= 60 then
								return true
							elseif power > 60 then
								if isChecked("Vanish") and not buff.stealth then
									if cast.vanish() then vanishTime = GetTime(); return end
								end
								if isChecked("Use Racial") and bb.player.race == "NightElf" and ((cd.vanish > 0 and cd.vanish < 170) or level < 32) then
									if cast.shadowmeld() then vanishTime = GetTime(); return end
								end
							end
						end				
			-- Death from Above
						-- death_from_above,if=combo_points>=action.run_through.cp_max_spend-(buff.broadsides.up&buff.jolly_roger.up)
			-- Slice and Dice
						-- slice_and_dice,if=combo_points>=5&buff.slice_and_dice.remains<target.time_to_die&buff.slice_and_dice.remains<(1+combo_points)*1.8
			-- Roll the Bones
						-- roll_the_bones,if=combo_points>=5&buff.roll_the_bones.remains<target.time_to_die&(buff.roll_the_bones.remains<=3|rtb_buffs<=1)
						if combo >= 5 and buff.remain.rollTheBones < ttd(units.dyn5) and (buff.remain.rollTheBones < 3 or buff.count.rollTheBones <= 1)	then
							if cast.rollTheBones() then return end
						end
			-- Killing Spree
						-- killing_spree,if=energy.time_to_max>5|energy<15
						if useCDs() and getDistance(units.dyn5) < 5 then

						end
			-- Cannonball Barrage
						-- cannonball_barrage,if=spell_targets.cannonball_barrage>=1
			-- Curse of the Dreadblades
						-- curse_of_the_dreadblades,if=combo_points.deficit>=4
			-- Marked for Death
						-- marked_for_death,target_if=min:target.time_to_die,if=combo_points.deficit>=4+talent.deeper_strategem.enabled+talent.anticipation.enabled 
			-- Finishers
						-- call_action_list,name=finish,if=combo_points>=action.run_through.cp_max_spend-1-(buff.broadsides.up&buff.jolly_roger.up)+cooldown.death_from_above.up
						if combo >= comboMax - 1 - broadRoger + dfaCooldown then
							if actionList_Finishers() then return end
						end
			-- Generators
						-- call_action_list,name=build,if=combo_points<action.run_through.cp_max_spend-1-(buff.broadsides.up&buff.jolly_roger.up)+cooldown.death_from_above.up
						if combo < comboMax - 1 - broadRoger + dfaCooldown then
							if actionList_Generators() then return end
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
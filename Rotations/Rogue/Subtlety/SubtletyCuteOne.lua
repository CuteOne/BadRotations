if select(2, UnitClass("player")) == "ROGUE" then
    local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
    local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.shurikenStorm },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.shurikenStorm },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.backstab },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.crimsonVial}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.shadowBlades },
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.shadowBlades },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.shadowBlades }
        };
        CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.evasion },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.evasion }
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
            [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.kick },
            [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.kick }
        };
        CreateButton("Interrupt",4,0)
    -- Cleave Button
        CleaveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = br.player.spell.shurikenStorm },
            [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = br.player.spell.backstab }
        };
        CreateButton("Cleave",5,0)
    -- Pick Pocket Button
      	PickerModes = {
          [1] = { mode = "Auto", value = 2 , overlay = "Auto Pick Pocket Enabled", tip = "Profile will attempt to Pick Pocket prior to combat.", highlight = 1, icon = br.player.spell.pickPocket},
          [2] = { mode = "Only", value = 1 , overlay = "Only Pick Pocket Enabled", tip = "Profile will attempt to Sap and only Pick Pocket, no combat.", highlight = 0, icon = br.player.spell.pickPocket},
          [3] = { mode = "Off", value = 3, overlay = "Pick Pocket Disabled", tip = "Profile will not use Pick Pocket.", highlight = 0, icon = br.player.spell.pickPocket}
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
            section = br.ui:createSection(br.ui.window.profile,  "General")
            	-- Stealth
	            br.ui:createDropdown(section,  "Stealth", {"|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards"},  1, "Stealthing method.")
	            -- Shadowstep
	            br.ui:createCheckbox(section,  "Shadowstep")
	            -- Pre-Pull Timer
	            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
	            -- Dummy DPS Test
                br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            br.ui:checkSectionState(section)
            ------------------------
            --- COOLDOWN OPTIONS ---
            ------------------------
            section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
                -- Agi Pot
	            br.ui:createCheckbox(section, "Agi-Pot")
	            -- Legendary Ring
	            br.ui:createCheckbox(section, "Legendary Ring")
	            -- Racial
                br.ui:createCheckbox(section,"Racial")
            	-- Trinkets
                br.ui:createCheckbox(section,"Trinkets")
                -- Marked For Death
	            br.ui:createSpinner(section, "Marked For Death",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
	            -- Shadow Dance
	            br.ui:createCheckbox(section, "Shadow Dance")
	            -- Vanish
	            br.ui:createCheckbox(section, "Vanish")
            br.ui:checkSectionState(section)
            -------------------------
            --- DEFENSIVE OPTIONS ---
            -------------------------
            section = br.ui:createSection(br.ui.window.profile, "Defensive")
            	-- Healthstone
	            br.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
	            -- Heirloom Neck
	            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
	           -- Cloak of Shadows
	            br.ui:createCheckbox(section, "Cloak of Shadows")
	            -- Crimson Vial
	            br.ui:createSpinner(section, "Crimson Vial",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
	            -- Evasion
	            br.ui:createSpinner(section, "Evasion",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
	            -- Feint
	            br.ui:createSpinner(section, "Feint", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            br.ui:checkSectionState(section)
            -------------------------
            --- INTERRUPT OPTIONS ---
            -------------------------
            section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            	-- Kick
	            br.ui:createCheckbox(section, "Kick")
	            -- Kidney Shot
	            br.ui:createCheckbox(section, "Kidney Shot")
	            -- Blind
            	br.ui:createCheckbox(section, "Blind")
	            -- Interrupt Percentage
	            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")    
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
	            -- Cleave Toggle
	            br.ui:createDropdown(section,  "Cleave Mode", br.dropOptions.Toggle,  6)
	            -- Pick Pocket Toggle
	            br.ui:createDropdown(section,  "Pick Pocket Mode", br.dropOptions.Toggle,  6)
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
        if br.timer:useTimer("debugSubtlety", math.random(0.15,0.3)) then
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
			if leftCombat == nil then leftCombat = GetTime() end
			if profileStop == nil then profileStop = false end
			local addsExist                                     = false 
            local addsIn                                        = 999
			local artifact 										= br.player.artifact
			local attacktar 									= UnitCanAttack("target","player")
			local buff, buffRemain								= br.player.buff, br.player.buff.remain
			local cast 											= br.player.cast
			local cd 											= br.player.cd
			local charges 										= br.player.charges
			local combatTime                                    = getCombatTime()
			local combo, comboDeficit, comboMax					= br.player.comboPoints, br.player.comboPointsMax - br.player.comboPoints, br.player.comboPointsMax
			local deadtar										= UnitIsDeadOrGhost("target")
			local debuff 										= br.player.debuff
			local dynTar5 										= br.player.units.dyn5 --Melee
			local dynTar15 										= br.player.units.dyn15 
			local dynTar20AoE 									= br.player.units.dyn20AoE --Stealth
			local dynTar30AoE 									= br.player.units.dyn30AoE
			local dynTable5										= (br.data['Cleave']==1 and br.enemy) or { [1] = {["unit"]=dynTar5, ["distance"] = getDistance(dynTar5)}}
			local dynTable15									= (br.data['Cleave']==1 and br.enemy) or { [1] = {["unit"]=dynTar15, ["distance"] = getDistance(dynTar15)}}
			local dynTable20AoE 								= (br.data['Cleave']==1 and br.enemy) or { [1] = {["unit"]=dynTar20AoE, ["distance"] = getDistance(dynTar20AoE)}}
			local enemies										= br.player.enemies
			local flaskBuff, canFlask							= getBuffRemain("player",br.player.flask.wod.buff.agilityBig), canUse(br.player.flask.wod.agilityBig)	
			local gcd 											= br.player.gcd
			local glyph				 							= br.player.glyph
			local hastar 										= ObjectExists("target")
			local healPot 										= getHealthPot()
			local inCombat 										= br.player.inCombat
			local lastSpell 									= lastSpellCast
			local level											= br.player.level
			local mode 											= br.player.mode
			local multidot 										= (useCleave() or br.player.mode.rotation ~= 3)
			local perk											= br.player.perk
			local php											= br.player.health
			local power, powerDeficit, powerRegen, powerTTM		= br.player.power, br.player.powerDeficit, br.player.powerRegen, br.player.powerTTM
			local pullTimer 									= br.DBM:getPulltimer()
			local race 											= br.player.race
			local racial                                        = br.player.getRacial()
			local solo											= #br.friend < 2	
			local spell 										= br.player.spell
			local stealth 										= br.player.stealth
			local stealthing 									= br.player.buff.stealth or br.player.buff.vanish or br.player.buff.shadowmeld or br.player.buff.shadowDance
			local t18_4pc 										= br.player.eq.t18_4pc
			local talent 										= br.player.talent
			local time 											= getCombatTime()
			local ttd 											= getTTD
			local ttm 											= br.player.timeToMax
			local units 										= br.player.units

			if talent.anticipation then antital = 1 else antital = 0 end
			if talent.deeperStrategem then dStrat = 1 else dStrat = 0 end
			if talent.masterOfShadows then mosTalent = 1 else mosTalent = 0	end
			if talent.premeditation then premed = 1 else premed = 0 end
			if talent.vigor then vigorous = 1 else vigorous = 0 end
			if combatTime < 10 then justStarted = 1 else justStarted = 0 end
			if vanishTime == nil then vanishTime = GetTime() end
			if hasEquiped(137032) then shadowWalker = 1 else shadowWalker = 0 end
			-- variable,name=ssw_er,value=equipped.shadow_satyrs_walk*(10-floor(target.distance*0.5))
			local sswVar = shadowWalker * (10 - math.floor(getDistance(units.dyn5)*0.5))
			-- variable,name=ed_threshold,value=energy.deficit<=(20+talent.vigor.enabled*35+talent.master_of_shadows.enabled*25+variable.ssw_er)
			local edThreshVar = (powerDeficit <= (20 + vigorous * 35 + mosTalent * 25 + sswVar))

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
	           	-- Heirloom Neck
		    		if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") and not inCombat then
		    			if hasEquiped(122668) then
		    				if GetItemCooldown(122668)==0 then
		    					useItem(122668)
		    				end
		    			end
		    		end
				-- Pot/Stoned
		            if isChecked("Healthstone") and php <= getOptionValue("Healthstone") and inCombat and hasHealthPot() then
	                    if canUse(5512) then
	                        useItem(5512)
	                    elseif canUse(healPot) then
	                        useItem(healPot)
	                    end
		            end
		        -- Cloak of Shadows
		    		if isChecked("Cloak of Shadows") and canDispel("player",spell.cloakOfShadows) then
		    			if cast.cloakOfShadows() then return end
		    		end
		        -- Crimson Vial
					if isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") then
						if cast.crimsonVial() then return end
					end
	            -- Evasion
	                if isChecked("Evasion") and php < getOptionValue("Evasion") and inCombat then
	                    if cast.evasion() then return end
	                end
	            -- Feint
					if isChecked("Feint") and php <= getOptionValue("Feint") and inCombat then
						if cast.feint() then return end
					end
	            end
			end -- End Action List - Defensive
		-- Action List - Interrupts
			local function actionList_Interrupts()
				if useInterrupts() and not stealth then
					for i=1, #enemies.yards20 do
						local thisUnit = enemies.yards20[i]
						local distance = getDistance(thisUnit)
						if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
				-- Kick
							-- kick
							if isChecked("Kick") and distance < 5 then
								if cast.kick(thisUnit) then return end
							end
				-- Kidney Shot
							if cd.kick ~= 0 and cd.blind == 0 then
								if isChecked("Kidney Shot") then
									if cast.kidneyShot(thisUnit) then return end
								end
							end
							if isChecked("Blind") and (cd.kick ~= 0 or distance >= 5) then
				-- Blind
								if cast.blind(thisUnit) then return end
							end
						end
					end	
				end -- End Interrupt and No Stealth Check
			end -- End Action List - Interrupts
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				-- print("Cooldowns")
				if useCDs() and getDistance(units.dyn5) < 5 then
			-- Trinkets
                    if isChecked("Trinkets") then
                        if canUse(13) then
                            useItem(13)
                        end
                        if canUse(14) then
                            useItem(14)
                        end
                    end
			-- Potion
					-- potion,name=old_war,if=buff.bloodlust.react|target.time_to_die<=25|buff.shadow_blades.up
					if isChecked("Agi-Pot") and canUse(127844) and inRaid then
						if ttd(units.dyn5) <= 25 or buff.shadowBlades then
                            useItem(127844)
                        end
                    end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                    -- blood_fury,if=stealthed
                    -- berserking,if=stealthed
                    -- arcane_torrent,if=stealthed&energy.deficit>70
                    if isChecked("Racial") and stealthing and (race == "Orc" or race == "Troll" or (race == "BloodElf" and powerDeficit > 70)) then
                        if castSpell("player",racial,false,false,false) then return end
                    end
            -- Shadow Blades
            		-- shadow_blades,if=!(stealthed|buff.shadowmeld.up)
            		if not stealthing then
            			if cast.shadowBlades() then return end
            		end
            -- Goremaws Bite
            		-- goremaws_bite,if=!buff.shadow_dance.up&((combo_points.deficit>=4-(time<10)*2&energy.deficit>50+talent.vigor.enabled*25-(time>=10)*15)|target.time_to_die<8)
            		if not buff.shadowDance and ((comboDeficit >= 4 - justStarted * 2 and powerDeficit > 50 + vigorous * 25 - justStarted * 15) or ttd(units.dyn5) < 8) then
            			if cast.goremawsBite() then return end
            		end
            -- Marked For Death
            		-- marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit|(raid_event.adds.in>40&combo_points.deficit>=4+talent.deeper_strategem.enabled+talent.anticipation.enabled)
            		if isChecked("Marked For Death") then
						for i = 1, #enemies.yards30 do
							local thisUnit = enemies.yards30[i]
							if getHP(thisUnit) < getOptionValue("Marked For Death") or ttd(thisUnit) < comboDeficit 
								or (addsIn > 40 and comboDeficit >= 4 + dStrat + antital) 
							then
								if cast.markedForDeath(thisUnit) then return end
							end
						end
					end
				end -- End Cooldown Usage Check
			end -- End Action List - Cooldowns
		-- Action List - Stealth Cooldowns
			local function actionList_StealthCooldowns()
				if getDistance(units.dyn5) < 5 then
				-- print("Stealth Cooldowns")
			-- Shadow Dance
					-- shadow_dance,if=charges_fractional>=2.65
					if charges.frac.shadowDance >= 2.65 then
						if cast.shadowDance() then return end
					end
			-- Vanish
					-- vanish
					if isChecked("Vanish") and not solo then
						if cast.vanish() then vanishTime = GetTime(); return end
					end
			-- Shadow Dance
					-- shadow_dance,if=charges>=2&combo_points<=1
					if charges.shadowDance >= 2 and combo <= 1 then
						if cast.shadowDance() then return end
					end
			-- Shadowmeld
					-- pool_resource,for_next=1,extra_amount=40-variable.ssw_er
					-- shadowmeld,if=energy>=40-variable.ssw_er&energy.deficit>10
					if isChecked("Racial") and not solo then
						if power < 40 - sswVar then
							return true
						elseif power >= 40 - sswVar and powerDeficit > 10 then
							if cast.shadowmeld() then return end
						end
					end
			-- Shadow Dance
					-- shadow_dance,if=combo_points<=1
					if combo <= 1 then
						if cast.shadowDance() then return end
					end
				end
			end
		-- Action List - Finishers
			local function actionList_Finishers()
				-- print("Finishers")
			-- Enveloping Shadows
				-- enveloping_shadows,if=buff.enveloping_shadows.remains<target.time_to_die&buff.enveloping_shadows.remains<=combo_points*1.8
				if buff.remain.envelopingShadows < ttd(units.dyn5) and buff.remain.envelopingShadows <= combo * 1.8 then
					if cast.envelopingShadows() then return end
				end
			-- Death from Above
				-- death_from_above,if=spell_targets.death_from_above>=6
				if #enemies.yards15 >= 6 then
					if cast.deathFromAbove() then return end
				end
			-- Night Blade
				-- nightblade,target_if=max:target.time_to_die,if=target.time_to_die>8&((refreshable&(!finality|buff.finality_nightblade.up))|remains<tick_time)
				if ttd(units.dyn5) > 8 and ((debuff.refresh.nightblade and (not artifact.finality or buff.finalityNightblade)) or debuff.remain.nightblade < 2) then
					if cast.nightblade() then return end
				end
			-- Death from Above
				-- death_from_above
				if cast.deathFromAbove() then return end
			-- Eviscerate
				-- eviscerate
				if cast.eviscerate() then return end
			end -- End Action List - Finishers
		-- Action List - Stealthed
			local function actionList_Stealthed()
				-- print("Stealth")
			-- Symbols of Death
				-- symbols_of_death,if=buff.shadowmeld.down&((buff.symbols_of_death.remains<target.time_to_die-4&buff.symbols_of_death.remains<=buff.symbols_of_death.duration*0.3)|(equipped.shadow_satyrs_walk&energy.time_to_max<0.25))
				if not buff.shadowmeld and ((buff.remain.symbolsOfDeath < ttd(units.dyn5) - 4 and buff.remain.symbolsOfDeath <= buff.duration.symbolsOfDeath * 0.3) 
					or (hasEquiped(137032) and powerTTM < 0.25)) 
				then
					if cast.symbolsOfDeath() then return end
				end
			-- Finisher
				-- call_action_list,name=finish,if=combo_points>=5
				if combo >= 5 then
					if actionList_Finishers() then return end
				end
			-- Shuriken Storm
				-- shuriken_storm,if=buff.shadowmeld.down&((combo_points.deficit>=3&spell_targets.shuriken_storm>=2+talent.premeditation.enabled+equipped.shadow_satyrs_walk)|buff.the_dreadlords_deceit.stack>=29)
				if not buff.shadowmeld and ((comboDeficit >= 3 and #enemies.yards10 >= 2 + premed + shadowWalker) or buff.stack.theDreadlordsDeceit >= 29) then
					if cast.shurikenStorm() then return end
				end
			-- Shadowstrike
				-- shadowstrike
				if cast.shadowstrike() then return end
			end
		-- Action List - Generators
			local function actionList_Generators()
				-- print("Generator")
			-- Shuriken Storm
				-- shuriken_storm,if=spell_targets.shuriken_storm>=2
				if #enemies.yards10 >= 2 then
					if cast.shurikenStorm() then return end
				end
			-- Backstab / Gloomblade
				-- gloomblade
				-- backstab
				if cast.backstab() then return end
			end -- End Action List - Generators
		-- Action List - PreCombat
			local function actionList_PreCombat()
				-- print("PreCombat")
			-- Stealth
				-- stealth
				if isChecked("Stealth") and (not IsResting() or isDummy("target")) then
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
				if isValidUnit("target") then 
			-- Marked For Death
					-- marked_for_death,if=raid_event.adds.in>40
					if addsIn > 40 then
						if cast.markedForDeath("target") then return end
					end
			-- Symbols of Death
					-- symbols_of_death
					if cast.symbolsOfDeath("target") then return end
				end
			end -- End Action List - PreCombat
		-- Action List - Opener
			local function actionList_Opener()
				if isValidUnit("target") then
			-- Shadowstep
	                if isChecked("Shadowstep") and (not stealthing or power < 40) then
	                    if cast.shadowstep("target") then return end 
	                end
            -- Shadowstrike
	            	if (not isChecked("Shadowstep") or stealthing) and mode.pickPocket ~= 2 then
	            		if cast.shadowstrike("target") then return end
	            	end
			-- Start Attack
                	if getDistance("target") < 5 and not stealthing and mode.pickPocket ~= 2 then		
                    	StartAttack()
                    end
                end
			end -- End Action List - Opener
	---------------------
	--- Begin Profile ---
	---------------------
		--Profile Stop | Pause
			if not inCombat and not hastar and profileStop==true then
				profileStop = false
			elseif (inCombat and profileStop == true) or pause() or (IsMounted() or IsFlying()) or mode.rotation==4 then
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
				if inCombat and mode.pickPocket ~= 2 and isValidUnit(units.dyn5) and getDistance(units.dyn5) < 5 then
	------------------------------
	--- In Combat - Interrupts ---
	------------------------------
					if actionList_Interrupts() then return end
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
					-- if actionList_Cooldowns() then return end
	----------------------------------
	--- In Combat - Begin Rotation ---
	----------------------------------
			-- Shadowstep
	                if isChecked("Shadowstep") then
	                    if cast.shadowstep("target") then return end 
	                end
			-- Cooldowns
					-- call_action_list,name=cds
					if actionList_Cooldowns() then return end
			-- Stealthed
					-- run_action_list,name=stealthed,if=stealthed|buff.shadowmeld.up
					if stealthing then
						if actionList_Stealthed() then return end
					else
			-- Shuriken Toss
						if getDistance(units.dyn30) > 5 and hasThreat(units.dyn30) then
							if cast.shurikenToss() then return end
						end
			-- Finishers
						-- call_action_list,name=finish,if=combo_points>=5|(combo_points>=4&spell_targets.shuriken_storm>=3&spell_targets.shuriken_storm<=4)
						if combo >= 5 or (combo >= 4 and #enemies.yards10 >= 3 and #enemies.yards10 <= 4) then
							if actionList_Finishers() then return end
						end
			-- Stealth Cooldowns
						-- call_action_list,name=stealth_cds,if=combo_points.deficit>=2+talent.premeditation.enabled&(variable.ed_threshold|(cooldown.shadowmeld.up&!cooldown.vanish.up&cooldown.shadow_dance.charges<=1)|target.time_to_die<12)
						if comboDeficit >= 2 + premed and (edThreshVar or ((cd.shadowmeld == 0 or not isChecked("Racial") or solo) and (cd.vanish ~= 0 or not isChecked("Vanish") or solo) and charges.shadowDance <= 1) or ttd("target") < 12 or #enemies.yards10 >=5) then
							if actionList_StealthCooldowns() then return end
						end
			-- Generators
						-- call_action_list,name=build,if=variable.ed_threshold
						if edThreshVar then
							if actionList_Generators() then return end
						end
					end
				end -- End In Combat
			end -- End Profile
	    end -- Timer
	end -- runRotation
	tinsert(cSubtlety.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end -- End Class Check

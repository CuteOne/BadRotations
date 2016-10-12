if select(2, UnitClass("player")) == "ROGUE" then
    local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
    local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = bb.player.spell.fanOfKnives },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.fanOfKnives },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.mutilate },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.crimsonVial}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.vendetta },
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.vendetta },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.vendetta }
        };
        CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.evasion },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.evasion }
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
            [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = bb.player.spell.fanOfKnives },
            [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = bb.player.spell.mutilate }
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
            	-- Opening Attack
	            bb.ui:createDropdown(section, "Opener", {"Garrote", "Cheap Shot"},  1, "|cffFFFFFFSelect Attack to Break Stealth with")
            	-- Poison
            	bb.ui:createDropdown(section, "Lethal Poison", {"Deadly","Wound","Agonizing"}, 1, "Lethal Poison to Apply")
            	bb.ui:createDropdown(section, "Non-Lethal Poison", {"Crippling","Leeching"}, 1, "Non-Lethal Poison to Apply")
            	-- Poisoned Knife
            	bb.ui:createCheckbox(section, "Poisoned Knife")
            	-- Stealth
	            bb.ui:createDropdown(section, "Stealth", {"|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards"},  1, "Stealthing method.")
	            -- Shadowstep
	            bb.ui:createCheckbox(section, "Shadowstep")
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
	            bb.ui:createCheckbox(section, "Vanish")
            bb.ui:checkSectionState(section)
            -------------------------
            --- DEFENSIVE OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
	            -- Healthstone
	            bb.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
	            -- Heirloom Neck
	            bb.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            	-- Evasion
                bb.ui:createSpinner(section, "Evasion",  40,  0,  100,  5, "Set health percent threshhold to cast at - In Combat Only!",  "|cffFFFFFFHealth Percent to Cast At")
                -- Cloak of Shadows
	            bb.ui:createCheckbox(section, "Cloak of Shadows")
	            -- Crimson Vial
	            bb.ui:createSpinner(section, "Crimson Vial",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            bb.ui:checkSectionState(section)
            -------------------------
            --- INTERRUPT OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
            	-- Kick
	            bb.ui:createCheckbox(section,"Kick")
	            -- Kidney Shot
	            bb.ui:createCheckbox(section,"Kidney Shot")
	            -- Interrupt Percentage
	            bb.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")    
            bb.ui:checkSectionState(section)
            ----------------------
            --- TOGGLE OPTIONS ---
            ----------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "Toggle Keys")
            	-- Single/Multi Toggle
	            bb.ui:createDropdown(section, "Rotation Mode", bb.dropOptions.Toggle,  4)
	            --Cooldown Key Toggle
	            bb.ui:createDropdown(section, "Cooldown Mode", bb.dropOptions.Toggle,  3)
	            --Defensive Key Toggle
	            bb.ui:createDropdown(section, "Defensive Mode", bb.dropOptions.Toggle,  6)
	            -- Interrupts Key Toggle
	            bb.ui:createDropdown(section, "Interrupt Mode", bb.dropOptions.Toggle,  6)
	            -- Cleave Toggle
	            bb.ui:createDropdown(section, "Cleave Mode", bb.dropOptions.Toggle,  6)
	            -- Pick Pocket Toggle
	            bb.ui:createDropdown(section, "Pick Pocket Mode", bb.dropOptions.Toggle,  6)
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
        if bb.timer:useTimer("debugAssassination", math.random(0.15,0.3)) then
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
			local addsIn                                        = 999
			local artifact 										= bb.player.artifact
			local attacktar 									= UnitCanAttack("target","player")
			local buff, buffRemain								= bb.player.buff, bb.player.buff.remain
			local cast 											= bb.player.cast
			local cd 											= bb.player.cd
			local charge 										= bb.player.charges
			local combo, comboDeficit, comboMax					= bb.player.comboPoints, bb.player.comboPointsMax - bb.player.comboPoints, bb.player.comboPointsMax
			local cTime 										= getCombatTime()
			local deadtar										= UnitIsDeadOrGhost("target")
			local debuff 										= bb.player.debuff
			local enemies										= bb.player.enemies
			local envenomHim 									= envenomHim
			local exsanguinated 								= exsanguinated									
			local flaskBuff, canFlask							= getBuffRemain("player",bb.player.flask.wod.buff.agilityBig), canUse(bb.player.flask.wod.agilityBig)	
			local gcd 											= bb.player.gcd
			local glyph				 							= bb.player.glyph
			local hastar 										= ObjectExists("target")
			local healPot 										= getHealthPot()
			local hemorrhageCount 								= ruptureCount
			local inCombat 										= bb.player.inCombat
			local lastSpell 									= lastSpellCast
			local level											= bb.player.level
			local mode 											= bb.player.mode
			local multidot 										= (useCleave() or bb.player.mode.rotation ~= 3)
			local perk											= bb.player.perk
			local php											= bb.player.health
			local power, powerDeficit, powerRegen				= bb.player.power, bb.player.powerDeficit, bb.player.powerRegen
			local pullTimer 									= bb.DBM:getPulltimer()
			local race 											= bb.player.race
			local racial 										= bb.player.racial
			local ruptureCount 									= ruptureCount
			local solo											= GetNumGroupMembers() == 0	
			local spell 										= bb.player.spell
			local stealth 										= bb.player.buff.stealth
			local stealthing 									= bb.player.buff.stealth or bb.player.buff.vanish or bb.player.buff.shadowmeld
			local t18_4pc 										= bb.player.eq.t18_4pc
			local talent 										= bb.player.talent
			local ttd 											= getTTD
			local ttm 											= bb.player.powerTTM --timeToMax
			local units 										= bb.player.units

			-- Exsanguinated Bleeds
			if not envenomHim then envenomHim = false end
			if not debuff.rupture then exRupture = false end
			if not debuff.garrote then exGarrote = false end
			if not debuff.internalBleeding then exInternalBleeding = false end
			if lastSpell == spell.exsanguinate then exsanguinateCast = true else exsanguinateCast = false end
			if exsanguinateCast and debuff.rupture then exRupture = true end
			if exsanguinateCast and debuff.garrote then exGarrote = true end
			if exsanguinateCast and debuff.internalBleeding then exInternalBleeding = true end
			if exRupture or exGarrote or exInternalBleeding then exsanguinated = true else exsanguinated = false end
			-- Hemorrhage Count
			hemorrhageCount = 0
			for i=1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                local hemorrhageRemain = getDebuffRemain(thisUnit,spell.hemorrhage,"player") or 0
                if hemorrhageRemain > 0 then
                	hemorrhageCount = hemorrhageCount + 1
                end
            end
            -- ruptureCount
            ruptureCount = 0
            for i=1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                local ruptureRemain = getDebuffRemain(thisUnit,spell.rupture,"player") or 0
                if ruptureRemain > 0 then
                	ruptureCount = ruptureCount + 1
                end
            end
            -- Numeric Returns
            if talent.deeperStrategem then dStrat = 1 else dStrat = 0 end
            if debuff.vendetta then vendy = 1 else vendy = 0 end
            if artifact.bagOfTricks then trickyBag = 1 else trickyBag = 0 end
            if talent.elaboratePlanning then ePlan = 1 else ePlan = 0 end

	--------------------
	--- Action Lists ---
	--------------------
		-- Action List - Extras
			local function actionList_Extras()
				-- TODO: Add Extra Features To Base Profile
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
	        -- Poisoned Knife
        		if isChecked("Poisoned Knife") and not buff.stealth then
        			for i = 1, #enemies.yards30 do
        				local thisUnit = enemies.yards30[i]
        				local distance = getDistance(thisUnit)
        				local deadlyPoisonRemain = getDebuffRemain(thisUnit,spell.deadlyPoison,"player")
        				if deadlyPoisonRemain == 0 and distance > 5 and (hasThreat(thisUnit) or isDummy()) then
        					if cast.poisonedKnife(thisUnit) then return end
        				end
        			end
        		end
			end -- End Action List - Extras
		-- Action List - Defensives
			local function actionList_Defensive()
				-- -- TODO: Add Defensive Abilities
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
		    		if isChecked("Cloak of Shaodws") and canDispel("player",spell.cloakOfShadows) then
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
	            end
			end -- End Action List - Defensive
		-- Action List - Interrupts
			local function actionList_Interrupts()
				if useInterrupts() and not stealth then
					for i=1, #enemies.yards20 do
						local thisUnit = enemies.yards20[i]
						local distance = getDistance(thisUnit)
						if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
							if distance < 5 then
				-- Kick
								-- kick
								if isChecked("Kick") then
									if cast.kick(thisUnit) then return end
								end
				-- Kidney Shot
								if cd.kick ~= 0 then
									if isChecked("Kidney Shot") then
										if cast.kidneyShot(thisUnit) then return end
									end
								end
							end
						end
					end
				end -- End Interrupt and No Stealth Check
			end -- End Action List - Interrupts
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if (useCDs() or burst) and getDistance(units.dyn5) < 5 then
			-- Racial
					-- blood_fury,if=debuff.vendetta.up
					-- berserking,if=debuff.vendetta.up
					-- arcane_torrent,if=debuff.vendetta.up&energy.deficit>50
					if debuff.vendetta and (race == "Orc" or race == "Troll" or (race == "BloodElf" and powerDeficit > 50)) then
						if castSpell("player",racial,false,false,false) then return end
					end
			-- Marked For Death
					-- marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit|combo_points.deficit>=5
					if ttd("target") < comboDeficit or comboDeficit >= 5 then
						if cast.markedForDeath() then return end
					end
			-- Vendetta
					-- /vendetta,if=target.time_to_die<20
					-- vendetta,if=artifact.urge_to_kill.enabled&dot.rupture.ticking&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains<5)&(energy<55|time<10|spell_targets.fan_of_knives>=2)
 					-- vendetta,if=!artifact.urge_to_kill.enabled&dot.rupture.ticking&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains<1)
 					if ttd("target") < 20 
 						or (artifact.urgeToKill and debuff.rupture and (not talent.exsanguinate or cd.exsanguinate < 5) and (power < 55 or cTime < 10 or #enemies.yards8 >= 2))
 						or (not artifact.urgeToKill and debuff.rupture and (not talent.exsanguinate or cd.exsanguinate < 1))
 					then
 						if cast.vendetta() then return end
 					end 
			-- Vanish
					-- vanish,if=talent.subterfuge.enabled&combo_points<=2&!dot.rupture.exsanguinated|talent.shadow_focus.enabled&!dot.rupture.exsanguinated&combo_points.deficit>=2
 					-- vanish,if=!talent.exsanguinate.enabled&talent.nightstalker.enabled&combo_points>=5+talent.deeper_stratagem.enabled&energy>=25&gcd.remains=0
					if isChecked("Vanish") then
						if ((talent.subterfuge and combo <= 2 and not exRupture) or (talent.shadowFocus and not exRupture and combo >= 2))
							or (not talent.exsanguinate and talent.nightstalker and combo >= 5 + dStrat and power >= 25)
 						then
							if cast.vanish() then return end
						end
					end
				end -- End Cooldown Usage Check
			end -- End Action List - Cooldowns
		-- Action List - Garrote
			local function actionList_Garrote()
				-- pool_resource,for_next=1
				-- garrote,cycle_targets=1,if=talent.subterfuge.enabled&!ticking&combo_points.deficit>=1&spell_targets.fan_of_knives>=2
				for i = 1, #enemies.yards5 do
					local thisUnit = enemies.yards5[i]
					local garroteRemain = getDebuffRemain(thisUnit,spell.garrote,"player") or 0
					if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
						if talent.subterfuge and garroteRemain == 0 and comboDeficit >= 1 and #enemies.yards10 >= 2 then
							if power < 45 then
								return true
							else
								if cast.garrote(thisUnit) then return end
							end
						end
					end
				end
				-- pool_resource,for_next=1
				-- garrote,if=combo_points.deficit>=1&!exsanguinated
				if (comboDeficit >= 1 and not exsanguinate) or stealthing then
					if power < 45 then
						return true
					else
						if cast.garrote(thisUnit) then return end
					end
				end
			end -- End Action List - Garrote
		-- Action List - Builders Exsanguinate
			local function actionList_BuildersExsanguinate()
			-- Hemorrhage
				-- hemorrhage,cycle_targets=1,if=combo_points.deficit>=1&refreshable&dot.rupture.remains>6&spell_targets.fan_of_knives>1&spell_targets.fan_of_knives<=4
				-- hemorrhage,cycle_targets=1,max_cycle_targets=3,if=combo_points.deficit>=1&refreshable&dot.rupture.remains>6&spell_targets.fan_of_knives>1&spell_targets.fan_of_knives=5
				for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local ruptureRemain = getDebuffRemain(thisUnit,spell.rupture,"player") or 0
                    local hemorrhageRemain = getDebuffRemain(thisUnit,spell.hemorrhage,"player") or 0
                    local hemorrhageDuration = getDebuffDuration(thisUnit,spell.hemorrhage,"player") or 0
                    local hemorrhageRefresh = hemorrhageRemain < hemorrhageDuration * 0.3
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    	if (comboDeficit >= 1 and hemorrhageRefreshable and ruptureRemain > 6 and ((mode.rotation == 1 and #enemies.yards10 > 1 and #enemies.yards10 <= 4) or mode.rotation == 2 or (mode.rotation == 3 and UnitIsUnit(thisUnit,units.dyn5)))) 
                    		or (hemorrhageCount <= 3 and comboDeficit >= 1 and hemorrhageRefresh and ruptureRemain > 6 and ((mode.rotation == 1 and #enemies.yards10 > 1 and #enemies.yards10 == 5) or mode.rotation == 2 or (mode.rotation == 3 and UnitIsUnit(thisUnit,units.dyn5))))
                    	then
                    		if cast.hemorrhage(thisUnit) then return end
                    	end
                    end
                end
            -- Fan of Knives
            	-- fan_of_knives,if=(spell_targets>=2+debuff.vendetta.up&(combo_points.deficit>=1|energy.deficit<=30))|(!artifact.bag_of_tricks.enabled&spell_targets>=7+2*debuff.vendetta.up)
            	-- fan_of_knives,if=equipped.the_dreadlords_deceit&((buff.the_dreadlords_deceit.stack>=29|buff.the_dreadlords_deceit.stack>=15&debuff.vendetta.remains<=3)&debuff.vendetta.up|buff.the_dreadlords_deceit.stack>=5&cooldown.vendetta.remains>60&cooldown.vendetta.remains<65)
            	-- if (((#enemies.yards10 >= 2 + vendy and (comboDeficit >= 1 or powerDeficit <= 30)) or (not artifact.bagOfTricks and ((mode.rotation == 1 and #enemies.yards10 >= 7 + 2 * vendy) or mode.rotation == 2)))
            	-- 	or (hasEquiped(137021) and ((buff.stack.theDreadlordsDeceit >= 15 and debuff.remain.vendetta <= 3) and debuff.vendetta or buff.stack.theDreadlordsDeceit >= 5 and cd.vendetta > 60 and cd.vendetta < 65 and (mode.rotation == 1 or mode.rotation == 2))))
            	-- 	and mode.rotation ~= 3
            	-- then
            	-- 	if cast.fanOfKnives() then return end
            	-- end
            	if ((mode.rotation == 1 and #enemies.yards8 >= 2 + vendy) or mode.rotation == 2) then
            		for i = 1, #enemies.yards8 do
            			local thisUnit = enemies.yards8[i]
            			local deadlyPoisoned = UnitDebuffID(thisUnit,spell.spec.debuffs.deadlyPoison,"player") ~= nil or false
            			if not deadlyPoisoned then
            				if cast.fanOfKnives() then return end
            			end
            		end
            	end 
            -- Hemorrhage
            	-- hemorrhage,if=(combo_points.deficit>=1&refreshable)|(combo_points.deficit=1&(dot.rupture.exsanguinated&dot.rupture.remains<=2|cooldown.exsanguinate.remains<=2))
            	if (comboDeficit >= 1 and debuff.refresh.hemorrhage) or (comboDeficit == 1 and (exRupture and debuff.remain.rupture <= 2 or cd.exsanguinate <= 2)) then
            		if cast.hemorrhage() then return end
            	end
            -- Mutilate
            	-- mutilate,if=combo_points.deficit<=1&energy.deficit<=30
            	-- mutilate,if=combo_points.deficit>=2&cooldown.garrote.remains>2
            	if (comboDeficit <= 1 and powerDeficit <= 30)
            		or (comboDeficit >= 2 and cd.garrote > 2) 
            	then
            		if cast.mutilate() then return end
            	end
			end -- End Action List - Builders Exsanguinate
		-- Action List - Exsanguinated Finishers
			local function actionList_ExsanguinatedFinishers()
			-- Rupture
				-- rupture,cycle_targets=1,max_cycle_targets=14-2*artifact.bag_of_tricks.enabled,if=!ticking&combo_points>=cp_max_spend-1&spell_targets.fan_of_knives>1&target.time_to_die-remains>6
				-- rupture,if=combo_points>=cp_max_spend&ticks_remain<2
				for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local ruptureRemain = getDebuffRemain(thisUnit,spell.rupture,"player") or 0
                    local ruptureDuration = getDebuffDuration(thisUnit,spell.rupture,"player") or 0
                    local ruptureTicks = ruptureRemain / 2
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    	if ruptureCount <= 14 - 2 * trickyBag and ruptureRemain == 0 and combo >= comboMax - 1 and ((mode.rotation == 1 and #enemies.yards10 > 1) or mode.rotation == 2) and ttd(thisUnit) - ruptureRemain > 6 then
                    		if cast.rupture(thisUnit) then return end
                    	end
                    elseif UnitIsUnit(thisUnit,units.dyn5) then
                    	if combo >= comboMax and ruptureTicks < 2 then
                    		if cast.rupture(thisUnit) then return end
                    	end
                    end
                end
			-- Death From Above
				-- death_from_above,if=combo_points>=cp_max_spend-1&(dot.rupture.remains>3|dot.rupture.remains>2&spell_targets.fan_of_knives>=3)&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6+2*debuff.vendetta.up)
				if combo >= comboMax - 1 and (debuff.remain.rupture > 3 or debuff.remain.rupture > 2 and ((mode.rotation == 1 and #enemies.yards10 >= 3) or mode.rotation == 2)) and (artifact.bagOfTricks or #enemies.yards10 <= 6 + 2 * vendy) then
					if cast.deathFromAbove() then return end
				end
			-- Envenom
				-- envenom,if=combo_points>=cp_max_spend-1&(dot.rupture.remains>3|dot.rupture.remains>2&spell_targets.fan_of_knives>=3)&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6+2*debuff.vendetta.up)
				if combo >= comboMax - 1 and (debuff.remain.rupture > 3 or debuff.remain.rupture > 2 and ((mode.rotation == 1 and #enemies.yards10 >= 3) or mode.rotation == 2)) and (artifact.bagOfTricks or #enemies.yards10 <= 6 + 2 * vendy) then
					if cast.envenom() then return end
				end
			end -- End Action List - Exsanguinated Finishers
		-- Action List - Exsanguinate Combo
			local function actionList_ExsanguinateCombo()
			-- Vanish
				-- vanish,if=talent.nightstalker.enabled&combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1&gcd.remains=0&energy>=25
				if isChecked("Vanish") and (not solo or isDummy("target")) and talent.nightstalker and combo >= comboMax and cd.exsanguinate < 1 and power >= 25 then
					if cast.vanish() then return end
				end
			-- Rupture
				-- rupture,if=combo_points>=cp_max_spend&(!talent.nightstalker.enabled|buff.vanish.up|cooldown.vanish.remains>15)&cooldown.exsanguinate.remains<1
				if combo >= comboMax and (not talent.nightstalker or buff.vanish or cd.vanish > 15 or not isChecked("Vanish") or (solo and isChecked("Vanish"))) and cd.exsanguinate < 1 then
					if cast.rupture() then return end
				end
			-- Exsanguinate
				-- exsanguinate,if=prev_gcd.rupture&dot.rupture.remains>22+4*talent.deeper_stratagem.enabled&cooldown.vanish.remains>10
				if lastSpell == spell.rupture and debuff.remain.rupture > 22 + 4 * dStrat and cd.vanish > 10 or not isChecked("Vanish") then
					if cast.exsanguinate() then return end
				end
			-- Call Action List: Garrote
				-- call_action_list,name=garrote,if=spell_targets.fan_of_knives<=8-artifact.bag_of_tricks.enabled
				if #enemies.yards10 <= 8 - trickyBag then
					if actionList_Garrote() then return end
				end
			-- Hemorrhage
				-- hemorrhage,if=spell_targets.fan_of_knives>=2&!ticking
				if #enemies.yards10 >= 2 and not debuff.hemorrhage then
					if cast.hemorrhage() then return end
				end
			-- Call Action List: Builder Exsanguinate
				-- call_action_list,name=build_ex
				if actionList_BuildersExsanguinate() then return end
			end -- End Action List - Exsanguinate Combo
		-- Action List - Finishers Exsanguinate
			local function actionList_FinishersExsanguinate()
			-- Rupture
				-- rupture,cycle_targets=1,max_cycle_targets=14-2*artifact.bag_of_tricks.enabled,if=!ticking&combo_points>=cp_max_spend-1&spell_targets.fan_of_knives>1&target.time_to_die-remains>6
				-- rupture,if=combo_points>=cp_max_spend-1&refreshable&!exsanguinated
				for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local ruptureRemain = getDebuffRemain(thisUnit,spell.rupture,"player") or 0
                    local ruptureDuration = getDebuffDuration(thisUnit,spell.rupture,"player") or 0
                    local ruptureRefreshable = ruptureRemain < ruptureDuration * 0.3
                    local ruptureTicks = ruptureRemain / 2
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    	if ruptureCount <= 14 - 2 * trickyBag and ruptureRemain == 0 and combo >= comboMax - 1 and ((mode.rotation == 1 and #enemies.yards10 > 1) or mode.rotation == 2) and ttd(thisUnit) - ruptureRemain > 6 then
                    		if cast.rupture(thisUnit) then return end
                    	end
                    elseif UnitIsUnit(thisUnit,units.dyn5) then
                    	if combo >= comboMax and ruptureRefreshable and not exsanguinated then
                    		if cast.rupture(thisUnit) then return end
                    	end
                    end
                end
			-- Death From Above
				-- death_from_above,if=combo_points>=cp_max_spend-1&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6)
				if combo >= comboMax - 1 and (artifact.bagOfTricks or #enemies.yards10 <= 6) then
					if cast.deathFromAbove() then return end
				end
			-- Envenom
				-- envenom,if=combo_points>=cp_max_spend-1&!dot.rupture.refreshable&buff.elaborate_planning.remains<2&energy.deficit<40&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6)
				-- envenom,if=combo_points>=cp_max_spend&!dot.rupture.refreshable&buff.elaborate_planning.remains<2&cooldown.garrote.remains<1&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6)
				if (combo >= comboMax - 1 and not debuff.refresh.rupture and buff.remain.elaboratePlanning < 2 and powerDeficit < 40 and (artifact.bagOfTricks or #enemies.yards10 <= 6))
					or (combo >= comboMax - 1 and not debuff.refresh.rupture and buff.remain.elaboratePlanning < 2 and cd.garrote < 1 and (artifact.bagOfTricks or #enemies.yards10 <= 6))
				then
					if cast.envenom() then return end
				end
			end -- End Action List - Finishers Exsanguinate
		-- Action List - Finishers
			local function actionList_Finishers()
			-- Envenom Condition
				-- variable,name=envenom_condition,value=!(dot.rupture.refreshable&dot.rupture.pmultiplier<1.5)&(!talent.nightstalker.enabled|cooldown.vanish.remains>=6)&dot.rupture.remains>=6&buff.elaborate_planning.remains<1.5&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6)
				if not debuff.refresh.rupture and (not talent.nightstalker or (cd.vanish >= 6 or not isChecked("Vanish"))) and debuff.remain.rupture >= 6 and buff.remain.elaboratePlanning < 1.5 and (artifact.bagOfTricks or #enemies.yards10 <= 6 or isDummy("target")) then
					envenomHim = true
				else
					envenomHim = false
				end 
			-- Rupture
				-- rupture,cycle_targets=1,max_cycle_targets=14-2*artifact.bag_of_tricks.enabled,if=!ticking&combo_points>=cp_max_spend&spell_targets.fan_of_knives>1&target.time_to_die-remains>6
				-- rupture,if=combo_points>=cp_max_spend&(((dot.rupture.refreshable)|dot.rupture.ticks_remain<=1)|(talent.nightstalker.enabled&buff.vanish.up))
				for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local ruptureRemain = getDebuffRemain(thisUnit,spell.rupture,"player") or 0
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if ruptureCount == 14 - 2 * trickyBag and ruptureRemain == 0 and combo >= comboMax and ((mode.rotation == 1 and #enemies.yards10 > 1) or mode.rotation == 2) and ttd(thisUnit) - ruptureRemain > 6 then 
                           if cast.rupture(thisUnit) then return end
                        end
                    end
                    if UnitIsUnit(thisUnit,units.dyn5) then
                        if combo >= comboMax and (((debuff.refresh.rupture) or debuff.remain.rupture / 2 <= 1) or (talent.nightstalker and buff.vanish)) then 
                            if cast.rupture(thisUnit) then return end
                        end
                    end
                end
            -- Death From Above
            	-- death_from_above,if=(combo_points>=5+talent.deeper_stratagem.enabled-2*talent.elaborate_planning.enabled)&variable.envenom_condition&(refreshable|talent.elaborate_planning.enabled&!buff.elaborate_planning.up|cooldown.garrote.remains<1)
				if (combo >= 5 + dStrat - (2 * ePlan)) and envenomHim and (buff.refresh.envenom or (talent.elaboratePlanning and not buff.elaboratePlanning) or cd.garrote < 1) then
					if cast.deathFromAbove() then return end
				end
			-- Envenom
				-- envenom,if=(combo_points>=5+talent.deeper_stratagem.enabled-2*talent.elaborate_planning.enabled)&variable.envenom_condition&(refreshable|talent.elaborate_planning.enabled&!buff.elaborate_planning.up|cooldown.garrote.remains<1)
				if (combo >= 5 + dStrat - (2 * ePlan)) and envenomHim and (buff.refresh.envenom or (talent.elaboratePlanning and not buff.elaboratePlanning) or cd.garrote < 1) then
					if cast.envenom() then return end
				end
			end -- End Action List - Finishers
		-- Action List - Generators
			local function actionList_Generators()
			-- Hemorrhage
				-- hemorrhage,cycle_targets=1,if=combo_points.deficit>=1&refreshable&dot.rupture.remains>6&spell_targets.fan_of_knives>1&spell_targets.fan_of_knives<=4
				-- hemorrhage,cycle_targets=1,max_cycle_targets=3,if=combo_points.deficit>=1&refreshable&dot.rupture.remains>6&spell_targets.fan_of_knives>1&spell_targets.fan_of_knives=5
				for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local ruptureRemain = getDebuffRemain(thisUnit,spell.rupture,"player") or 0
                    local hemorrhageRemain = getDebuffRemain(thisUnit,spell.hemorrhage,"player") or 0
                    local hemorrhageDuration = getDebuffDuration(thisUnit,spell.hemorrhage,"player") or 0
                    local hemorrhageRefresh = hemorrhageRemain < hemorrhageDuration * 0.3
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if (comboDeficit >= 1 and  hemorrhageRemain < hemorrhageDuration * 0.3 and ruptureRemain > 6 and #enemies.yards10 > 1 and #enemies.yards10 <= 4)
                        	or (hemorrhageCount <= 3 and comboDeficit >= 1 and hemorrhageRefresh and ruptureRemain > 6 and #enemies.yards10 > 1 and #enemies.yards10 == 5) 
                        then
                           if cast.hemorrhage(thisUnit) then return end
                        end
                    end
                end
            -- Fan of Knives
            	-- fan_of_knives,if=(spell_targets>=2+debuff.vendetta.up&(combo_points.deficit>=1|energy.deficit<=30))|(!artifact.bag_of_tricks.enabled&spell_targets>=7+2*debuff.vendetta.up)
            	-- fan_of_knives,if=equipped.the_dreadlords_deceit&((buff.the_dreadlords_deceit.stack>=29|buff.the_dreadlords_deceit.stack>=15&debuff.vendetta.remains<=3)&debuff.vendetta.up|buff.the_dreadlords_deceit.stack>=5&cooldown.vendetta.remains>60&cooldown.vendetta.remains<65)
            	-- if ((((mode.rotation == 1 and #enemies.yards8 >= 2 + vendy) or mode.rotation == 2) and (comboDeficit >= 1 or powerDeficit <= 30)) or (not artifact.bagOfTricks and ((mode.rotation == 1 and #enemies.yards10 >= 7 + 2 * vendy) or mode.rotation == 2)) 
            	-- 	or (hasEquiped(137021) and ((buff.stack.theDreadlordsDeceit >= 29 or buff.stack.theDreadlordsDeceit >= 15 and debuff.remain.vendetta <= 3) and debuff.vendetta or buff.stack.theDreadlordsDeceit >= 5 and cd.vendetta > 60 and cd.vendetta < 65)))
            	-- 	and mode.rotation ~= 3
            	-- then
            	-- 	if cast.fanOfKnives() then return end
            	-- end
            	if ((mode.rotation == 1 and #enemies.yards8 >= 2 + vendy) or mode.rotation == 2) then
            		for i = 1, #enemies.yards8 do
            			local thisUnit = enemies.yards8[i]
            			local deadlyPoisoned = UnitDebuffID(thisUnit,spell.spec.debuffs.deadlyPoison,"player") ~= nil or false
            			if not deadlyPoisoned then
            				if cast.fanOfKnives() then return end
            			end
            		end
            	end 
            -- Hemorrhage
            	-- hemorrhage,if=combo_points.deficit>=1&refreshable
            	if comboDeficit >= 1 and debuff.refresh.hemorrhage then
            		if cast.hemorrhage() then return end
            	end
			-- Mutilate
				-- mutilate,if=combo_points.deficit>=1&cooldown.garrote.remains>2
				if ((comboDeficit >= 1 or level < 3) and (cd.garrote > 2 or level < 48)) then
					if cast.mutilate() then return end
				end
			end -- End Action List - Generators
		-- Action List - PreCombat
			local function actionList_PreCombat()
			-- Apply Poison
				-- apply_poison 
					if isChecked("Lethal Poison") then
						if bb.timer:useTimer("Lethal Poison", 3.5) then
							if getOptionValue("Lethal Poison") == 1 and not buff.deadlyPoison then 
								if cast.deadlyPoison() then return end
							end
							if getOptionValue("Lethal Poison") == 2 and not buff.woundPoison then
								if cast.woundPoison() then return end
							end
							if getOptionValue("Lethal Poison") == 3 and not buff.agonizingPoison then
								if cast.agonizingPoison() then return end
							end
						end
					end
					if isChecked("Non-Lethal Poison") then
						if bb.timer:useTimer("Non-Lethal Poison", 3.5) then
							if (getOptionValue("Non-Lethal Poison") == 1 or not talent.leechingPoison) and not buff.cripplingPoison then
								if cast.cripplingPoison() then return end
							end
							if getOptionValue("Non-Lethal Poison") == 2 and not buff.leechingPoison then
								if cast.leechingPoison() then return end
							end
						end
					end
			-- Stealth
				-- stealth
				if isChecked("Stealth") then
					if getOptionValue("Stealth") == 1 then
						if cast.stealth() then return end
					end
				end
			-- Marked For Death
				-- marked_for_death,if=raid_event.adds.in>40
				if addsIn > 40 and isValidUnit("target") then
					if cast.markedForDeath() then return end
				end
			end -- End Action List - PreCombat
		-- Action List - Opener
			local function actionList_Opener()
			-- Shadowstep
                if isChecked("Shadowstep") and isValidUnit("target") then
                    if cast.shadowstep("target") then return end 
                end
			-- Start Attack
                -- auto_attack
                if isValidUnit("target") and getDistance("target") < 5 and mode.pickPocket ~= 2 then
                	if combo >= 2 and not debuff.rupture and cTime < 10 and not artifact.urgeToKill and getOptionValue("Opener") == 1 then
                		if cast.rupture("target") then StartAttack(); return end
                	elseif combo >= 4 and not debuff.rupture and getOptionValue("Opener") == 1 then
                		if cast.rupture("target") then StartAttack(); return end
                	elseif level >= 48 and not debuff.garrote and getOptionValue("Opener") == 1 then
                		if actionList_Garrote("target") then StartAttack(); return end
                	elseif level >= 29 and getOptionValue("Opener") == 2 then
                		if cast.cheapShot("target") then StartAttack(); return end
                	else
                		if cast.mutilate("target") then StartAttack(); return end
                	end
                end
			end -- End Action List - Opener
	---------------------
	--- Begin Profile ---
	---------------------
		--Profile Stop | Pause
			if not inCombat and not hastar and profileStop==true then
				profileStop = false
			elseif (inCombat and profileStop == true) or pause() or mode.rotation==4 then
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
				if actionList_Opener() then return end
	--------------------------
	--- In Combat Rotation ---
	--------------------------
			-- Assassination is 4 shank!
				if inCombat and mode.pickPocket ~= 2 and isValidUnit(units.dyn5) then
-- 					if hartar and deadtar then
-- 						ClearTarget()
-- 					end
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
					if actionList_Cooldowns() then return end
	----------------------------------
	--- In Combat - Begin Rotation ---
	----------------------------------
			-- Shadowstep
	                if isChecked("Shadowstep") then
	                    if cast.shadowstep("target") then return end 
	                end
	                if stealthing then
	                	if actionList_Opener() then return end
	                end
	                if not stealthing then
	       	-- Rupture
		       			-- rupture,if=combo_points>=2&!ticking&time<10&!artifact.urge_to_kill.enabled&talent.exsanguinate.enabled
						-- rupture,if=combo_points>=4&!ticking&talent.exsanguinate.enabled
						if (combo >= 2 and not debuff.rupture and cTime < 10 and not artifact.urgeToKill and talent.exsanguinate)
							or (combo >= 4 and not debuff.rupture and talent.exsanguinate)
						then
							if cast.rupture() then return end
						end
			-- Kingsbane
						-- pool_resource,for_next=1
						-- kingsbane,if=!talent.exsanguinate.enabled&(buff.vendetta.up|cooldown.vendetta.remains>10)|talent.exsanguinate.enabled&dot.rupture.exsanguinated
						if (not talent.exsanguinate and (buff.vendetta or cd.vendetta > 10)) or (talent.exsanguinate and exRupture) then
							if power <= 35 then
								return true
							else
								if cast.kingsbane() then return end
							end
						end
			-- Exsanguinate Combo
						-- run_action_list,name=exsang_combo,if=cooldown.exsanguinate.remains<3&talent.exsanguinate.enabled
						if cd.exsanguinate < 3 and talent.exsanguinate then
							if actionList_ExsanguinateCombo() then return end
						end
			-- Garrote
						-- call_action_list,name=garrote,if=spell_targets.fan_of_knives<=8-artifact.bag_of_tricks.enabled
						if #enemies.yards10 <= 8 - trickyBag then
							if actionList_Garrote() then return end
						end
			-- Exsanguinate Finishers
						-- call_action_list,name=exsang,if=dot.rupture.exsanguinated
						if exRupture then
							if actionList_ExsanguinatedFinishers() then return end
						end
			-- Rupture
						-- rupture,if=talent.exsanguinate.enabled&remains-cooldown.exsanguinate.remains<(4+cp_max_spend*4)*0.3&new_duration-cooldown.exsanguinate.remains>=(4+cp_max_spend*4)*0.3+3
						if talent.exsanguinate and debuff.remain.rupture - cd.exsanguinate < (4 + comboMax * 4) * 0.3 and debuff.duration.rupture - cd.exsanguinate >= (4 + comboMax * 4) * 0.3 + 3 then
							if cast.rupture() then return end
						end
			-- Finisher Exsanguinate
						-- call_action_list,name=finish_ex,if=talent.exsanguinate.enabled
						if talent.exsanguinate then
							if actionList_FinishersExsanguinate() then return end
						end
			-- Finishers
						-- call_action_list,name=finish_noex,if=!talent.exsanguinate.enabled
						if not talent.exsanguinate then
							if actionList_Finishers() then return end
						end
			-- Generator Exsanguinate
						-- call_action_list,name=build_ex,if=talent.exsanguinate.enabled
						if talent.exsanguinate then
							if actionList_BuildersExsanguinate() then return end
						end
			-- Generators
						-- call_action_list,name=build_noex,if=!talent.exsanguinate.enabled
						if not talent.exsanguinate then
							if actionList_Generators() then return end
						end
					end
				end -- End In Combat
			end -- End Profile
	    end -- Timer
	end -- runRotation
	tinsert(cAssassination.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end -- End Class Check
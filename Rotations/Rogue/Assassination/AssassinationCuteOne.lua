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
            	-- Poison
            	bb.ui:createDropdown(section, "Lethal Poison", {"Deadly","Wound"}, 1, "Lethal Poison to Apply")
            	bb.ui:createDropdown(section, "Non-Lethal Poison", {"Crippling"}, 1, "Non-Lethal Poison to Apply")
            	-- Poisoned Knife
            	bb.ui:createCheckbox(section, "Poisoned Knife")
            	-- Stealth
	            bb.ui:createDropdown(section,  "Stealth", {"|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards"},  1, "Stealthing method.")
	            -- Shadowstep
	            bb.ui:createCheckbox(section,  "Shadowstep")
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
	            bb.ui:createCheckbox(section,"Agi-Pot")
	            -- Legendary Ring
	            bb.ui:createCheckbox(section,  "Legendary Ring")
	            -- Vanish
	            bb.ui:createCheckbox(section,  "Vanish")
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
			local artifact 										= bb.player.artifact
			local attacktar 									= UnitCanAttack("target","player")
			local buff, buffRemain								= bb.player.buff, bb.player.buff.remain
			local cast 											= bb.player.cast
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
			local solo											= GetNumGroupMembers() == 0	
			local spell 										= bb.player.spell
			local stealth 										= bb.player.stealth
			local t18_4pc 										= bb.player.eq.t18_4pc
			local talent 										= bb.player.talent
			local cTime 										= getCombatTime()
			local ttd 											= getTTD
			local ttm 											= bb.player.timeToMax
			local units 										= bb.player.units

			if vanishTime == nil then vanishTime = GetTime() end

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
        			if (UnitExists("target") or mode.pickPocket == 2) and mode.pickPocket ~= 3 then
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
				if useCDs() and getDistance(units.dyn5) < 5 then
			-- Vanish
					-- vanish,if=talent.subterfuge.enabled&combo_points<=2&!dot.rupture.exsanguinated
 					-- vanish,if=talent.shadow_focus.enabled&!dot.rupture.exsanguinated&combo_points.deficit>=2
					if isChecked("Vanish") then
						if ((talent.subterfuge and combo <= 2) or (talent.shadowFocus and combo >= 2)) then -- and not debuff.exsanguinate.rupture
							if cast.vanish() then vanishTime = GetTime(); return end
						end
					end
				end -- End Cooldown Usage Check
			end -- End Action List - Cooldowns
		-- Action List - PreCombat
			local function actionList_PreCombat()
			-- Apply Poison
				-- apply_poison
				if isChecked("Lethal Poison") then
					if getOptionValue("Lethal Poison") == 1 and not buff.deadlyPoison then 
						if cast.deadlyPoison() then return end
					end
					if getOptionValue("Lethal Poison") == 2 and not buff.woundPoison then
						if cast.woundPoison() then return end
					end
				end
				if isChecked("Non-Lethal Poison") then
					if getOptionValue("Non-Lethal Poison") == 1 and not buff.cripplingPoison then
						ChatOverlay("Applying Non-Lethal") 
						if cast.cripplingPoison() then return end
					end
				end
			-- Stealth
				-- stealth
				if isChecked("Stealth") then
					if getOptionValue("Stealth") == 1 then
						if cast.stealth() then return end
					end
				end
			end -- End Action List - PreCombat
		-- Action List - Opener
			local function actionList_Opener()
			-- Shadowstep
                if isChecked("Shadowstep") and (hasThreat("target") or solo) then
                    if cast.shadowstep("target") then return end 
                end
			-- Start Attack
                -- auto_attack
                if ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") and getDistance("target") < 5 and mode.pickPocket ~= 2 then
                	if cast.mutilate() then StartAttack(); return end
                end
			end -- End Action List - Opener
		-- Action List - Finishers
			local function actionList_Finishers()
			-- Rupture
				-- rupture,cycle_targets=1,if=!ticking&combo_points>=cp_max_spend&spell_targets.fan_of_knives>1&target.time_to_die-remains>6
				-- rupture,if=combo_points>=cp_max_spend&refreshable&!exsanguinated
				for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local ruptureRemain = getDebuffRemain(thisUnit,spell.rupture,"player") or 0
                    if (multidot or (UnitIsUnit(thisUnit,dynTar5) and not multidot)) then
                        if ruptureRemain == 0 and combo >= comboMax and #enemies.yards5 > 1 and ttd(thisUnit) - ruptureRemain > 6 then 
                           if cast.rupture(thisUnit) then return end
                        end
                    end
                    if UnitIsUnit(thisUnit,dynTar5) then
                        if combo >= comboMax and debuff.refresh.rupture then -- and not exsanguinated 
                            if cast.rupture(thisUnit) then return end
                        end
                    end
                end
			-- Envenom
				-- envenom,if=combo_points>=cp_max_spend-1&!dot.rupture.refreshable&buff.elaborate_planning.remains<2&energy.deficit<40&spell_targets.fan_of_knives<=6
				-- envenom,if=combo_points>=cp_max_spend&!dot.rupture.refreshable&buff.elaborate_planning.remains<2&cooldown.garrote.remains<1&spell_targets.fan_of_knives<=6
				if ((combo >= comboMax - 1 and powerDeficit < 40) or (combo >= comboMax and cd.garrote < 1)) 
					and not debuff.refresh.rupture and buff.remain.elaboratePlanning < 2 and #enemies.yards8 <= 6 
				then
					if cast.envenom() then return end
				end
			end -- End Action List - Finishers
		-- Action List - Generators
			local function actionList_Generators()
			-- Hemorrhage
				-- hemorrhage,cycle_targets=1,if=combo_points.deficit>=1&refreshable&dot.rupture.remains>6&spell_targets.fan_of_knives>1&spell_targets.fan_of_knives<=4
				for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local ruptureRemain = getDebuffRemain(thisUnit,spell.rupture,"player") or 0
                    local hemorrhageRemain = getDebuffRemain(thisUnit,spell.hemorrhage,"player") or 0
                    local hemorrhageDuration = getDebuffDuration(thisUnit,spell.hemorrhage,"player") or 0
                    if (multidot or (UnitIsUnit(thisUnit,dynTar5) and not multidot)) then
                        if comboDeficit >= 1 and  hemorrhageRemain < hemorrhageDuration * 0.3 and ruptureRemain > 6 and #enemies.yards8 > 1 and #enemies.yards8 <= 4 then
                           if cast.hemorrhage(thisUnit) then return end
                        end
                    end
                end
            -- Fan of Knives
            	-- fan_of_knives,if=spell_targets>1&(combo_points.deficit>=1|spell_targets>=7)
            -- Hemorrhage
            	-- hemorrhage,if=(combo_points.deficit>=1&refreshable)|(combo_points.deficit=1&dot.rupture.refreshable)
            	if (comboDeficit >= 1 and debuff.refresh.hemorrhage) or (comboDeficit == 1 and debuff.refresh.rupture) then
            		if cast.hemorrhage() then return end
            	end
			-- Mutilate
				-- mutilate,if=combo_points.deficit>=2&cooldown.garrote.remains>2
				if (comboDeficit >= 2 or level < 3) and (cd.garrote > 2 or level < 48) then
					if cast.mutilate() then return end
				end
			end -- End Action List - Generators
	---------------------
	--- Begin Profile ---
	---------------------
		--Profile Stop | Pause
			if not inCombat and not hastar and profileStop==true then
				profileStop = false
			elseif (inCombat and profileStop == true) or pause() or mode.rotation==4 then
				return true
			else
-- 	-----------------------
-- 	--- Extras Rotation ---
-- 	-----------------------
				if actionList_Extras() then return end
-- 	--------------------------
-- 	--- Defensive Rotation ---
-- 	--------------------------
				if actionList_Defensive() then return end
-- 	------------------------------
-- 	--- Out of Combat Rotation ---
-- 	------------------------------
				if actionList_PreCombat() then return end
-- 	----------------------------
-- 	--- Out of Combat Opener ---
-- 	----------------------------
				if actionList_Opener() then return end
-- 	--------------------------
-- 	--- In Combat Rotation ---
-- 	--------------------------
			-- Assassination is 4 shank!
				if inCombat and mode.pickPocket ~= 2 then
-- 					if hartar and deadtar then
-- 						ClearTarget()
-- 					end
-- 	------------------------------
-- 	--- In Combat - Interrupts ---
-- 	------------------------------
-- 					if actionList_Interrupts() then return end
-- 	-----------------------------
-- 	--- In Combat - Cooldowns ---
-- 	-----------------------------
-- 					if actionList_Cooldowns() then return end
-- 	--------------------------
-- 	--- In Combat - Opener ---
-- 	--------------------------
-- 					if actionList_Opener() then return end
-- 	----------------------------------
-- 	--- In Combat - Begin Rotation ---
-- 	----------------------------------
			-- Shadowstep
	                if isChecked("Shadowstep") then
	                    if cast.shadowstep("target") then return end 
	                end
	                if not buff.steath and not buff.vanish and not buff.shadowmeld and GetTime() > vanishTime + 2 then
	       	-- Rupture
		       			-- rupture,if=combo_points>=2&!ticking&time<10&!artifact.urge_to_kill.enabled
						-- rupture,if=combo_points>=4&!ticking
						if not debuff.rupture and ((combo >= 2 and cTime < 10 and not artifact.urgeToKill) or combo >= 4) then
							if cast.rupture() then return end
						end
			-- Exsanguinate Combo
						-- run_action_list,name=exsang_combo,if=cooldown.exsanguinate.remains<3&talent.exsanguinate.enabled
			-- Garrote
						-- call_action_list,name=garrote,if=spell_targets.fan_of_knives<=7
			-- Exsanguinate
						-- call_action_list,name=exsang,if=dot.rupture.exsanguinated&spell_targets.fan_of_knives<=2
			-- Finishers
						-- call_action_list,name=finish
						if actionList_Finishers() then return end
			-- Generators
						-- call_action_list,name=build
						if actionList_Generators() then return end
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
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
            	-- Stealth
	            bb.ui:createDropdown(section,  "Stealth", {"|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards"},  1, "Stealthing method.")
	            -- Shadowstep
	            bb.ui:createCheckbox(section,  "Shadowstep")
	            -- Opening Attack
	            bb.ui:createDropdown(section, "Opener", {"Ambush", "Mutilate", "Cheap Shot"},  1, "|cffFFFFFFSelect Attack to Break Stealth with")
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
			local attacktar 									= UnitCanAttack("target","player")
			local buff, buffRemain								= bb.player.buff, bb.player.buff.remain
			local cd 											= bb.player.cd
			local charge 										= bb.player.charges
			local combo, comboDeficit, comboMax					= bb.player.comboPoints, bb.player.comboPointsMax - bb.player.comboPoints, bb.player.comboPointsMax
			local deadtar										= UnitIsDeadOrGhost("target")
			local debuff, debuffRemain							= bb.player.debuff, bb.player.debuff.remain
			local dynTar5 										= bb.player.units.dyn5 --Melee
			local dynTar15 										= bb.player.units.dyn15 
			local dynTar20AoE 									= bb.player.units.dyn20AoE --Stealth
			local dynTar30AoE 									= bb.player.units.dyn30AoE
			local dynTable5										= (bb.data['Cleave']==1 and bb.enemy) or { [1] = {["unit"]=dynTar5, ["distance"] = getDistance(dynTar5)}}
			local dynTable15									= (bb.data['Cleave']==1 and bb.enemy) or { [1] = {["unit"]=dynTar15, ["distance"] = getDistance(dynTar15)}}
			local dynTable20AoE 								= (bb.data['Cleave']==1 and bb.enemy) or { [1] = {["unit"]=dynTar20AoE, ["distance"] = getDistance(dynTar20AoE)}}
			local enemies										= bb.player.enemies
			local flaskBuff, canFlask							= getBuffRemain("player",bb.player.flask.wod.buff.agilityBig), canUse(bb.player.flask.wod.agilityBig)	
			local friendly 										= friendly or UnitIsFriend("target", "player")
			local gcd 											= bb.player.gcd
			local glyph				 							= bb.player.glyph
			local hastar 										= ObjectExists("target")
			local inCombat 										= bb.player.inCombat
			local level											= bb.player.level
			local mode 											= bb.player.mode
			local perk											= bb.player.perk
			local php											= bb.player.health
			local power, powerDeficit, powerRegen				= bb.player.power, bb.player.powerDeficit, bb.player.powerRegen
			local pullTimer 									= bb.DBM:getPulltimer()
			local spell 										= bb.player.spell
			local solo											= select(2,IsInInstance())=="none"	
			local stealth 										= bb.player.stealth
			local t18_4pc 										= bb.player.eq.t18_4pc
			local talent 										= bb.player.talent
			local targets										= bb.player.enemies
			local time 											= getCombatTime()
			local ttm 											= bb.player.timeToMax
			local units 										= bb.player.units

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
	        		if mode.pickPocket ~= 3 then
	        			if not isPicked(units.dyn5) then
	        				if debuff.remain.sap < 1 and mode.pickPocket ~= 1 then
	        					if bb.player.castSap(units.dyn5) then return end
	        				end
	        				if bb.player.castPickPocket() then return end
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
						if bb.player.castCrimsonVial() then return end
					end
	            -- Evasion
	                if isChecked("Evasion") and php < getOptionValue("Evasion") and inCombat then
	                    if bb.player.castEvasion() then return end
	                end
	            end
			end -- End Action List - Defensive
		-- Action List - Interrupts
			local function actionList_Interrupts()
				if useInterrupts() and not stealth then
				-- Kick
					-- kick
					if isChecked("Kick") then
						for i=1, #dynTable5 do
							local thisUnit = dynTable5[i].unit
							if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
								if bb.player.castKick(thisUnit) then return end
							end
						end
					end
				end -- End Interrupt and No Stealth Check
			end -- End Action List - Interrupts
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if useCDs() then
			-- -- Preparation
			-- 		-- if=!buff.vanish.up&cooldown.vanish.remains>60&time>10
			-- 		if isChecked("Preparation") and not buff.vanish and cd.vanish>60 and time>10 then
			-- 			if bb.player.castPreparation() then return end
			-- 		end
			-- -- Legendary Ring
			-- 		-- use_item,slot=finger1,if=spell_targets.fan_of_knives>1|(debuff.vendetta.up&spell_targets.fan_of_knives=1)
			-- -- Racials - Orc: Blood Fury | Troll: Berserking | Blood Elf: Arcane Torrent
			-- 		-- blood_fury | berserking | arcane_torrent,if=energy<60
			-- 		if isChecked("Racials") and bb.player.race == "Orc" or bb.player.race== "Troll" or (bb.player.race == "Blood Elf" and power<60) then
			-- 			if bb.player.castRacial() then return end
			-- 		end
			-- -- Vanish
			-- 		-- if=time>10&energy>13&!buff.stealth.up&buff.blindside.down&energy.time_to_max>gcd*2&((combo_points+anticipation_charges<8)|(!talent.anticipation.enabled&combo_points<=1))
			-- 		if isChecked("Vanish - Offensive") and not solo and time>10 and power>13 and not stealth and not buff.blindside and ttm>gcd*2 and ((combo + charge.anticipation<8) or (not talent.anticipation and combo<=1)) then
			-- 			if bb.player.castVanish() then return end
			-- 		end
			-- -- Potion
			-- 		-- draenic_agility,if=buff.bloodlust.react|target.time_to_die<40|debuff.vendetta.up
			-- 		if useCDs() and canUse(109217) and select(2,IsInInstance())=="raid" and isChecked("Agi-Pot") then
		 --            	if hasBloodLust() or getTimeToDie(dynTar5) or debuff.vendetta then
		 --                	useItem(109217)
		 --                end
		 --            end
				end -- End Cooldown Usage Check
			end -- End Action List - Cooldowns
		-- Action List - PreCombat
			local function actionList_PreCombat()
			-- Apply Poison
				-- apply_poison
				if isChecked("Lethal Poison") then
					if getOptionValue("Lethal Poison") == 1 and not buff.deadlyPoison then 
						if bb.player.castDeadlyPoison() then return end
					end
				end
				if isChecked("Non-Lethal Poison") then
					if getOptionValue("Non-Lethal Poison") == 1 and not buff.cripplingPoison then
						ChatOverlay("Applying Non-Lethal") 
						if bb.player.castCripplingPoison() then return end
					end
				end
			-- Stealth
				-- stealth
				if isChecked("Stealth") then
					if getOptionValue("Stealth") == 1 then
						if bb.player.castStealth() then return end
					end
				end
			end -- End Action List - PreCombat
		-- Action List - Opener
			local function actionList_Opener()
			-- Shadowstep
                if isChecked("Shadowstep") and solo and attacktar and not deadtar and not friendly then
                    if bb.player.castShadowstep("target") then return end 
                end
			-- Start Attack
                -- auto_attack
                if ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") and getDistance("target") < 5 and mode.pickPocket ~= 2 then
                    StartAttack()
                end
			end -- End Action List - Opener
		-- Action List - Finishers
			local function actionList_Finishers()
			-- Envenom
				-- envenom,if=combo_points>=cp_max_spend-1&!dot.rupture.refreshable&buff.elaborate_planning.remains<2&energy.deficit<40&spell_targets.fan_of_knives<=6
				-- envenom,if=combo_points>=cp_max_spend&!dot.rupture.refreshable&buff.elaborate_planning.remains<2&cooldown.garrote.remains<1&spell_targets.fan_of_knives<=6
				if ((combo >= comboMax - 1 and powerDeficit < 40) or (combo >= comboMax and cd.garrote < 1)) 
					and not debuff.refresh.rupture and buff.remain.elaboratePlanning < 2 and enemies.yards8 <= 6 
				then
					if bb.player.castEnvenom() then return end
				end
			end -- End Action List - Finishers
		-- Action List - Generators
			local function actionList_Generators()
			-- Hemorrhage
				if not talent.exsanguinate and debuff.remain.hemorrhage < 1 then
					if bb.player.castHemorrhage() then return end
				end
			-- Mutilate
				-- mutilate,if=combo_points.deficit>=2&cooldown.garrote.remains>2
				if (comboDeficit >= 2 or level < 3) and (cd.garrote > 2 or level < 48) then
					if bb.player.castMutilate() then return end
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
	                    if bb.player.castShadowstep("target") then return end 
	                end
	        -- Poisoned Knife
	        		if isChecked("Poisoned Knife") and getDistance(units.dyn30) > 5 and hasThreat(units.dyn30) then
	        			if bb.player.castPoisonedKnife() then return end
	        		end
-- 			-- Mutilate
-- 					-- if=buff.stealth.up|buff.vanish.up
-- 					if (stealth or buff.vanish) and (enemies10<6 or level<83 or not useCleave() or bb.data['AoE'] == 3) then
-- 						if bb.player.castMutilate2(dynTar5) then return end
-- 					end
-- 			-- Rupture
-- 					-- if=((combo_points>=4&!talent.anticipation.enabled)|combo_points=5)&ticks_remain<3
-- 					if ((combo>=4 and not talent.anticipation) or combo==5) and ruptureTick<3 and (enemies10<6 or level<83 or not useCleave() or bb.data['AoE'] == 3) then
-- 						if bb.player.castRupture(dynTar5) then return end
-- 					end
-- 					-- cycle_targets=1,if=spell_targets.fan_of_knives>1&!ticking&combo_points=5
-- 					for i=1, #dynTable5 do
-- 						thisUnit = dynTable5[i].unit
-- 						if targets10>1 and ruptureRemain(thisUnit)<2 and combo==5 then
-- 							if bb.player.castRupture(thisUnit) then return end
-- 						end
-- 					end
-- 			-- Marked For Death
-- 					-- if=combo_points=0
-- 					if combo==0 then
-- 						if bb.player.castMarkedForDeath() then return end
-- 					end
-- 			-- Shadow Reflection
-- 					-- if=combo_points>4|target.time_to_die<=20
-- 					if useCDs() and isChecked("Shadow Reflection") and (combo>4 or getTimeToDie(dynTar20AoE)<=20) then
-- 						if bb.player.castShadowReflection() then return end
-- 					end
-- 			-- Vendetta
-- 					-- if=buff.shadow_reflection.up|!talent.shadow_reflection.enabled|target.time_to_die<=20|(target.time_to_die<=30&glyph.vendetta.enabled)
-- 					if useCDs() and isChecked("Vendetta") and (buff.shadowReflection or not talent.shadowReflection or getTimeToDie(dynTar5)<=20 or (getTimeToDie(dynTar5)<=30 and glyph.vendetta)) then
-- 						if bb.player.castVendetta() then return end
-- 					end
-- 			-- Rupture
-- 					-- cycle_targets=1,if=combo_points=5&remains<=duration*0.3&spell_targets.fan_of_knives>1
-- 					if (enemies10<6 or level<83 or not useCleave() or bb.data['AoE'] == 3) then
-- 						for i=1, #dynTable5 do
-- 							local thisUnit = dynTable5[i].unit
-- 							if combo==5 and ruptureRemain(thisUnit)<=ruptureDuration(thisUnit)*0.3 and targets10>1 then
-- 								if bb.player.castRupture(thisUnit) then return end
-- 							end
-- 						end
-- 					end
-- 			-- Finishers
-- 					-- name=finishers,if=combo_points=5&((!cooldown.death_from_above.remains&talent.death_from_above.enabled)|buff.envenom.down|!talent.anticipation.enabled|anticipation_charges+combo_points>=6)
-- 					if combo==5 and ((cd.deathFromAbove==0 and talent.deathFromAbove) or not buff.envenom or not talent.anticipation or charge.anticipation+combo>=6) then
-- 						if actionList_Finishers() then return end
-- 					end
-- 					-- name=finishers,if=dot.rupture.remains<2
-- 					if debuffRemain.rupture<2 then
-- 						if actionList_Finishers() then return end
-- 					end
					if actionList_Finishers() then return end
			-- Generators
					if actionList_Generators() then return end
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
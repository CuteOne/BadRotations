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
	            bb.ui:createCheckbox(section, "Agi-Pot")
	            -- Legendary Ring
	            bb.ui:createCheckbox(section, "Legendary Ring")
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
            	bb.ui:createCheckbox(section,  "Kick")
            	-- Gouge
            	bb.ui:createCheckbox(section,  "Gouge")	
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
			local attacktar 									= UnitCanAttack("target","player")
			local buff, buffRemain								= bb.player.buff, bb.player.buff.remain
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
			local inCombat 										= bb.player.inCombat
			local level											= bb.player.level
			local mode 											= bb.player.mode
			local perk											= bb.player.perk
			local php											= bb.player.health
			local power, powerDeficit, powerRegen				= bb.player.power, bb.player.powerDeficit, bb.player.powerRegen
			local pullTimer 									= bb.DBM:getPulltimer()
			local solo											= GetNumGroupMembers() == 0	
			local spell 										= bb.player.spell
			local stealth 										= bb.player.stealth
			local t18_4pc 										= bb.player.eq.t18_4pc
			local talent 										= bb.player.talent
			local targets10										= bb.player.enemies.yards10
			local time 											= getCombatTime()
			local ttm 											= bb.player.timeToMax
			local units 										= bb.player.units

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
						if bb.player.castCrimsonVial() then return end
					end
				-- Riposte
					if isChecked("Riposte") and php < getOptionValue("Riposte") and inCombat then
						if bb.player.castRiposte() then return end
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
					if talent.dirtyTricks then
			-- Gouge
						if isChecked("Gouge") then
							for i=1, #dynTable5 do
								local thisUnit = dynTable5[i].unit
								if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
									if bb.player.castGouge(thisUnit) then return end
								end
							end
						end
			-- Blind
						-- if isChecked("Blind") then
						-- 	for i=1, #dynTable15 do
						-- 		local thisUnit = dynTable15[i].unit
						-- 		if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
						-- 			if bb.player.castBlind(thisUnit) then return end
						-- 		end 
						-- 	end
						-- end
					end -- End Dirty Tricks Talent Check
				end -- End Interrupt and No Stealth Check
			end -- End Action List - Interrupts
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if useCDs() then

				end -- End Cooldown Usage Check
			end -- End Action List - Cooldowns
		-- Action List - PreCombat
			local function actionList_PreCombat()
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
				if ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") and getDistance("target") < 5 then
				-- Ambush
					-- pool_resource,for_next=1
					-- ambush
					if buff.stealth then
						if power <= 60 then
							return true
						else
							if bb.player.castAmbush() then return end
						end
					end
			-- Start Attack
	                -- auto_attack
	                if (level < 14 or not buff.stealth) then
	                    StartAttack()
	                end
	            end
			end -- End Action List - Opener
		-- Action List - Finishers
			local function actionList_Finishers()
			-- Run Through
				-- run_through
				if bb.player.castRunThrough() then return end
			end -- End Action List - Finishers
		-- Action List - Generators
			local function actionList_Generators()
			-- Ghostly Strike
				-- ghostly_strike,if=talent.ghostly_strike.enabled&debuff.ghostly_strike.remains<duration*0.3
				if talent.ghostlyStrike and (debuff.remain.ghostlyStrike < debuff.duration.ghostlyStrike * 0.3 or not debuff.ghostlyStrike) then
					if bb.player.castGhostlyStrike() then return end
				end
			-- Pistol Shot
				-- pistol_shot,if=buff.opportunity.up&energy<60
				if buff.opportunity and power < 60 then
					if bb.player.castPistolShot() then return end
				end
			-- Saber Slash
				-- saber_slash
				if bb.player.castSaberSlash() then return end
			end -- End Action List - Generators
	---------------------
	--- Begin Profile ---
	---------------------
		--Profile Stop | Pause
			if not inCombat and not hastar and profileStop == true then
				profileStop = false
			elseif (inCombat and profileStop == true) or pause() or mode.rotation == 4 then
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
			-- Shadowmeld
					-- pool_resource,for_next=1,extra_amount=60
					-- shadowmeld,if=combo_points.deficit>=2&energy>60
					if isChecked("Use Racial") and bb.player.race == "NightElf" and comboDeficit >= 2 and cd.shadowmeld == 0 and (not solo or isDummy()) then 
						if power <= 60 then
							return true
						elseif power > 60 and not buff.stealth then
							if bb.player.castShadowmeld() then return end
						end
					end 
			-- Finishers
					-- call_action_list,name=finisher,if=combo_points>=5+talent.deeper_strategem.enabled
					if combo >= 5 then
						if actionList_Finishers() then return end
					end
			-- Generators
					-- call_action_list,name=generator,if=combo_points<5+talent.deeper_strategem.enabled
					if combo < 5 then
						if actionList_Generators() then return end
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
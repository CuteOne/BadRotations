if select(3, UnitClass("player")) == 2 then -- Change specID to ID of spec. IE: https://github.com/MrTheSoulz/NerdPack/wiki/Class-&-Spec-IDs
    local rotationName = "CuteOne" -- Appears in the dropdown of the rotation selector in the Profile Options window

---------------
--- Toggles ---
---------------
    local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = bb.player.spell.divineStorm },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.divineStorm },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.crusaderStrike },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.flashOfLight }
        }
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.avengingWrath },
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.avengingWrath },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.avengingWrath }
        };
        CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.flashOfLight },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.flashOfLight }
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
            [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = bb.player.spell.hammerOfJustice },
            [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = bb.player.spell.hammerOfJustice }
        };
        CreateButton("Interrupt",4,0)
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
            	-- APL
                bb.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
            	-- Dummy DPS Test
                bb.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")            	
	            -- Hand of Hindeance
	            bb.ui:createCheckbox(section, "Hand of Hinderance")
            bb.ui:checkSectionState(section)
            ------------------------
            --- COOLDOWN OPTIONS ---
            ------------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "Cooldowns")
            	-- Racial
                bb.ui:createCheckbox(section,"Racial")
                -- Holy Wrath
                bb.ui:createCheckbox(section,"Holy Wrath")
                -- Avenging Wrath
                bb.ui:createCheckbox(section,"Avenging Wrath")
                -- Shield of Vengeance
                bb.ui:createCheckbox(section,"Shield of Vengeance")
                -- Cruusade
                bb.ui:createCheckbox(section,"Crusade")                
            bb.ui:checkSectionState(section)
            -------------------------
            --- DEFENSIVE OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
            	-- Healthstone
                bb.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                -- Heirloom Neck
                bb.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
                -- Gift of The Naaru
                if bb.player.race == "Draenei" then
                    bb.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                end
                -- Blinding Light
                bb.ui:createSpinner(section, "Blinding Light - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
                bb.ui:createSpinner(section, "Blinding Light - AoE", 3, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
                -- Cleanse Toxin
                bb.ui:createDropdown(section, "Clease Toxin", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
                -- Divine Shield
                bb.ui:createSpinner(section, "Divine Shield",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.") 
            	-- Flash of Light
	            bb.ui:createSpinner(section, "Flash of Light",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
	            -- Hammer of Justice
	            bb.ui:createSpinner(section, "Hammer of Justice - HP",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
	            -- Redemption
                bb.ui:createDropdown(section, "Redemption", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")            	
            bb.ui:checkSectionState(section)
            -------------------------
            --- INTERRUPT OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
            	-- Blinding Light
            	bb.ui:createCheckbox(section, "Blinding Light")
            	-- Hammer of Justice
            	bb.ui:createCheckbox(section, "Hammer of Justice")
            	-- Rebuke
            	bb.ui:createCheckbox(section, "Rebuke")
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
        if bb.timer:useTimer("debugRetribution", math.random(0.15,0.3)) then -- Change debugSpec tp name of Spec IE: debugFeral or debugWindwalker
            --print("Running: "..rotationName)

    ---------------
    --- Toggles ---
    ---------------
            UpdateToggle("Rotation",0.25)
            UpdateToggle("Cooldown",0.25)
            UpdateToggle("Defensive",0.25)
            UpdateToggle("Interrupt",0.25)

    --- FELL FREE TO EDIT ANYTHING BELOW THIS AREA THIS IS JUST HOW I LIKE TO SETUP MY ROTATIONS ---

	--------------
	--- Locals ---
	--------------
			local artifact 		= bb.player.artifact
			local buff 			= bb.player.buff
			local cast 			= bb.player.cast
			local cd 			= bb.player.cd
			local charges 		= bb.player.charges
			local combatTime    = getCombatTime()
			local debuff 		= bb.player.debuff
			local enemies 		= bb.player.enemies
			local gcd 			= bb.player.gcd
			local hastar 		= ObjectExists("target")
			local healPot       = getHealthPot()
			local holyPower 	= bb.player.holyPower
			local holyPowerMax 	= bb.player.holyPowerMax
			local inCombat 		= bb.player.inCombat
			local level 		= bb.player.level
			local mode 			= bb.player.mode
			local php 			= bb.player.health
			local race 			= bb.player.race
			local racial        = bb.player.getRacial()
			local resable 		= UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
			local talent 		= bb.player.talent
			local units 		= bb.player.units			

			if profileStop == nil then profileStop = false end
			if debuff.judgment[units.dyn5].exists or level < 42 or (cd.judgment > 2 and not debuff.judgment[units.dyn5].exists) then
				judgmentVar = true
			else
				judgmentVar = false
			end 

	--------------------
	--- Action Lists ---
	--------------------
		-- Action List - Extras
			local function actionList_Extras()
			-- Hand of Hinderance
				if isMoving("target") and not getFacing("target","player") and getDistance("target") > 8 then
					if cast.handOfHinderance("target") then return end
				end
			end -- End Action List - Extras
		-- Action List - Defensives
			local function actionList_Defensive()
				if useDefensive() then
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
                        if hasEquiped(122667) then
                            if GetItemCooldown(122667)==0 then
                                useItem(122667)
                            end
                        end
                    end
            -- Gift of the Naaru
                    if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and race == "Draenei" then
                        if castSpell("player",racial,false,false,false) then return end
                    end
            -- Blinding Light
            		if isChecked("Blinding Light - HP") and php <= getOptionValue("Blinding Light - HP") and inCombat and #enemies.yards10 > 0 then
                        if cast.blindingLight() then return end
                    end
                    if isChecked("Blinding Light - AoE") and #enemies.yards5 >= getOptionValue("Blinding Light - AoE") and inCombat then
                        if cast.blindingLight() then return end
                    end
            -- Cleanse Toxins
            		if isChecked("Cleanse Toxins") then
            			if getOptionValue("Cleanse Toxins")==1 then
                            if cast.cleanseToxins("player") then return end
                        end
                        if getOptionValue("Cleanse Toxins")==2 then
                            if cast.cleanseToxins("target") then return end
                        end
                        if getOptionValue("Cleanse Toxins")==3 then
                            if cast.cleanseToxins("mouseover") then return end
                        end
                    end
            -- Divine Shield
            		if isChecked("Divine Shield") then
            			if php <= getOptionValue("Divine Shield") and inCombat then
            				if cast.divineShield() then return end
            			end
            		end
			-- Flash of Light
					if isChecked("Flash of Light") then
                        if (forceHeal or (inCombat and php <= getOptionValue("Flash of Light") / 2) or (not inCombat and php <= getOptionValue("Flash of Light"))) and not isMoving("player") then 
                    		if cast.flashOfLight() then return end
                    	end
                    end
            -- Hammer of Justice
            		if isChecked("Hammre of Justice - HP") and php <= getOptionValue("Hammer of Justice - HP") and inCombat then
            			if cast.hammerOfJustice() then return end
            		end
			-- Redemption
                    if isChecked("Redemption") then
                        if getOptionValue("Redemption")==1 and not isMoving("player") and resable then
                            if cast.redemption("target") then return end
                        end
                        if getOptionValue("Redemption")==2 and not isMoving("player") and resable then
                            if cast.redemption("mouseover") then return end
                        end
                    end				
	            end
			end -- End Action List - Defensive
		-- Action List - Interrupts
			local function actionList_Interrupts()
				if useInterrupts() then
					for i = 1, #enemies.yards10 do
						local thisUnit = enemies.yards10[i]
						local distance = getDistance(thisUnit)
						if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
			-- Hammer of Justice
							if isChecked("Hammer of Justice") and distance < 10 then
								if cast.hammerOfJustice(thisUnit) then return end
							end
			-- Rebuke
							if isChecked("Rebuke") and distance < 5 then
								if cast.rebuke(thisUnit) then return end
							end
			-- Blinding Light
							if isChecked("Blinding Light") and distance < 10 then
								if cast.blindingLight() then return end
							end
						end
					end
				end
			end -- End Action List - Interrupts
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if useCDs() or burst then
					if getOptionValue("APL Mode") == 1 then

					end
					if getOptionValue("APL Mode") == 2 then
				-- Crusade
						if isChecked("Crusade") then
							if cast.crusade() then return end
						end
				-- Avenging Wrath
						if isChecked("Avenging Wrath") then
							if cast.avengingWrath() then return end
						end
					end
				end -- End Cooldown Usage Check
			end -- End Action List - Cooldowns
		-- Action List - PreCombat
			local function actionList_PreCombat()
				-- PreCombat abilities listed here
			end -- End Action List - PreCombat
		-- Action List - Opener
			local function actionList_Opener()
				if isValidUnit("target") then
			-- Judgment
					if cast.judgment("target") then return end
			-- Start Attack
					if getDistance("target") < 5 then StartAttack() end
	            end
			end -- End Action List - Opener
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
					if getOptionValue("APL Mode") == 1 then
						if useCDs() then
				-- Holy Wrath
							-- holy_wrath
							if isChecked("Holy Wrath") then
								if cast.holyWrath() then return end
							end
				-- Avenging Wrath
							-- avenging_wrath
							if cast.avengingWrath() then return end
				-- Shield of Vengeance
							-- shield_of_vengeance
							if cast.shieldOfVengeance() then return end
				-- Crusade
							-- crusade,if=holy_power>=5
							if holyPower >= 5 then
								if cast.crusade() then return end
							end
				-- Wake of Ashes
							-- wake_of_ashes,if=holy_power>=0&time<2
							if holyPower >= 0 and combatTime < 2 then
								if cast.wakeOfAshes() then return end
							end
						end
				-- Execution Sentence
						-- execution_sentence,if=spell_targets.divine_storm<=3&(cooldown.judgment.remains<gcd*4.5|debuff.judgment.remains>gcd*4.67)&(!talent.crusade.enabled|cooldown.crusade.remains>gcd*2)
						if #enemies.yards8 <= 3 and (cd.judgment < gcd * 4.5 or debuff.judgment[units.dyn30].remain > gcd * 4.67) and (not talent.crusade or cd.crusade > gcd *2) then
							if cast.executionSentence() then return end
						end
				-- Racials
						-- blood_fury
						-- berserking
						-- arcane_torrent,if=holy_power<5
						if isChecked("Racial") and useCDs() then
							if race == "Orc" or race == "Troll" or (race == "BloodElf" and holyPower < 5) then
								if castSpell("player",racial,false,false,false) then return end
							end
						end
				-- Divine Storm
						-- divine_storm,if=debuff.judgment.up&spell_targets.divine_storm>=2&buff.divine_purpose.up&buff.divine_purpose.remains<gcd*2
						-- divine_storm,if=debuff.judgment.up&spell_targets.divine_storm>=2&holy_power>=5&buff.divine_purpose.react
						-- divine_storm,if=debuff.judgment.up&spell_targets.divine_storm>=2&holy_power>=5&(!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)
						if judgmentVar and #enemies.yards8 >= 2 and ((buff.divinePurpose and buff.remain.divinePurpose < gcd * 2)
							or (holyPower >= 5 and buff.divinePurpose)
							or (holyPower >= 5 and (not talent.crusade or cd.crusade > gcd * 3)))
						then
							if cast.divineStorm() then return end
						end
				-- Justicar's Vengeance
						-- justicars_vengeance,if=debuff.judgment.up&buff.divine_purpose.up&buff.divine_purpose.remains<gcd*2&!equipped.whisper_of_the_nathrezim
						-- justicars_vengeance,if=debuff.judgment.up&holy_power>=5&buff.divine_purpose.react&!equipped.whisper_of_the_nathrezim
						if judgmentVar and ((buff.divinePurpose and buff.remain.divinePurpose < gcd * 2 and not hasEquipped(137020)) 
							or (holyPower >= 5 and buff.divinePurpose and not hasEquipped(137020))) 
						then
							if cast.justicarsVengeance() then return end
						end
				-- Templar's Verdict
						-- templars_verdict,if=debuff.judgment.up&buff.divine_purpose.up&buff.divine_purpose.remains<gcd*2
						-- templars_verdict,if=debuff.judgment.up&holy_power>=5&buff.divine_purpose.react
						-- templars_verdict,if=debuff.judgment.up&holy_power>=5&(!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)
						if judgmentVar and ((buff.divinePurpose and buff.remain.divinePurpose < gcd * 2)
							or (holyPower >= 5 and buff.divinePurpose)
							or (holyPower >= 5 and (not talent.crusade or cd.crusade > gcd * 3)))
						then
							if cast.templarsVerdict() then return end
						end
				-- Divine Storm
						-- divine_storm,if=debuff.judgment.up&holy_power>=3&spell_targets.divine_storm>=2&(cooldown.wake_of_ashes.remains<gcd*2&artifact.wake_of_ashes.enabled|buff.whisper_of_the_nathrezim.up&buff.whisper_of_the_nathrezim.remains<gcd)&(!talent.crusade.enabled|cooldown.crusade.remains>gcd*4)
						if judgmentVar and holyPower >= 3 and #enemies.yards8 >= 2 
							and ((cd.wakeOfAshes < gcd * 2 and artifact.wakeOfAshes) or (buff.whisperOfTheNathrezim and buff.remain.whisperOfTheNathrezim < gcd) or not artifact.wakeOfAshes) 
							and (not talent.crusade or cd.crusade > gcd * 4) 
						then
							if cast.divineStorm() then return end
						end
				-- Justicar's Vengeance
						-- justicars_vengeance,if=debuff.judgment.up&holy_power>=3&buff.divine_purpose.up&cooldown.wake_of_ashes.remains<gcd*2&artifact.wake_of_ashes.enabled&!equipped.whisper_of_the_nathrezim
						if judgmentVar and holyPower >= 3 and buff.divinePurpose and ((cd.wakeOfAshes < gcd * 2 and artifact.wakeOfAshes) or not artifact.wakeOfAshes) and not hasEquipped(137020) then
							if cast.justicarsVengeance() then return end
						end
				-- Templar's Verdict
						-- templars_verdict,if=debuff.judgment.up&holy_power>=3&(cooldown.wake_of_ashes.remains<gcd*2&artifact.wake_of_ashes.enabled|buff.whisper_of_the_nathrezim.up&buff.whisper_of_the_nathrezim.remains<gcd)&(!talent.crusade.enabled|cooldown.crusade.remains>gcd*4)
						if judgmentVar and holyPower >= 3 
							and ((cd.wakeOfAshes < gcd * 2 and artifact.wakeOfAshes) or (buff.whisperOfTheNathrezim and buff.remain.whisperOfTheNathrezim < gcd) or not artifact.wakeOfAshes) 
							and (not talent.crusade or cd.crusade < gcd * 4) 
						then
							if cast.templarsVerdict() then return end
						end
				-- Wake of Ashes
						-- wake_of_ashes,if=holy_power=0|holy_power=1&(cooldown.blade_of_justice.remains>gcd|cooldown.divine_hammer.remains>gcd)|holy_power=2&(cooldown.zeal.charges_fractional<=0.65|cooldown.crusader_strike.charges_fractional<=0.65)
						if holyPower == 0 or (holyPower == 1 and (cd.bladeOfJustice > gcd or cd.divineHammer > gcd)) or (holyPower == 2 and (charges.frac.zeal <= 0.65 or charges.frac.crusaderStrike <= 0.65)) then
							if cast.wakeOfAshes() then return end
						end
				-- Zeal
						-- zeal,if=charges=2&holy_power<=4
						if charges.zeal == 2 and holyPower <= 4 then
							if cast.zeal() then return end
						end
				-- Crusader Strike
						-- crusader_strike,if=charges=2&holy_power<=4
						if charges.crusaderStrike == 2 and holyPower <= 4 then
							if cast.crusaderStrike() then return end
						end
				-- Blade of Justice
						-- blade_of_justice,if=holy_power<=2|(holy_power<=3&(cooldown.zeal.charges_fractional<=1.34|cooldown.crusader_strike.charges_fractional<=1.34))
						if holyPower <= 2 or (holyPower <= 3 and (charges.frac.zeal <= 1.34 or charges.frac.crusaderStrike <= 1.34)) then
							if cast.bladeOfJustice() then return end
						end
				-- Divine Hammer
						-- divine_hammer,if=holy_power<=2|(holy_power<=3&(cooldown.zeal.charges_fractional<=1.34|cooldown.crusader_strike.charges_fractional<=1.34))
						if holyPower <= 2 or (holyPower <= 3 and (charges.frac.zeal <= 1.34 or charges.frac.crusaderStrike <= 1.34)) then
							if cast.divineHammer() then return end
						end
				-- Judgement
						-- judgment,if=holy_power>=3|((cooldown.zeal.charges_fractional<=1.67|cooldown.crusader_strike.charges_fractional<=1.67)&(cooldown.divine_hammer.remains>gcd|cooldown.blade_of_justice.remains>gcd))|(talent.greater_judgment.enabled&target.health.pct>50)
						if holyPower >= 3 or ((charges.frac.zeal <= 1.67 or charges.frac.crusaderStrike <= 1.67) and (cd.divineHammer > gcd or cd.bladeOfJustice > gcd)) 
							or (talent.greaterJudgement and thp > 50) 
						then
							if cast.judgment("target") then return end
						end
				-- Consecration
						if cast.consecration() then return end
				-- Divine Storm
						-- divine_storm,if=debuff.judgment.up&spell_targets.divine_storm>=2&buff.divine_purpose.react
						-- divine_storm,if=debuff.judgment.up&spell_targets.divine_storm>=2&buff.the_fires_of_justice.react&(!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)
						-- divine_storm,if=debuff.judgment.up&spell_targets.divine_storm>=2&holy_power>=4&(!talent.crusade.enabled|cooldown.crusade.remains>gcd*4)
						if judgmentVar and #enemies.yards8 >= 2 and (buff.divinePurpose
							or (buff.theFiresOfJustice and (not talent.crusade or cd.crusade > gcd * 3))
							or (holyPower >= 4 and (not talent.crusade or cd.crusade > gcd * 4)))
						then
							if cast.divineStorm() then return end
						end
				-- Justicar's Vengeance
						-- justicars_vengeance,if=debuff.judgment.up&buff.divine_purpose.react&!equipped.whisper_of_the_nathrezim
						if judgmentVar and buff.divinePurpose and not hasEquipped(137020) then
							if cast.justicarsVengeance() then return end
						end
				-- Templar's Verdict
						-- templars_verdict,if=debuff.judgment.up&buff.divine_purpose.react
						-- templars_verdict,if=debuff.judgment.up&buff.the_fires_of_justice.react&(!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)
						-- templars_verdict,if=debuff.judgment.up&holy_power>=4&(!talent.crusade.enabled|cooldown.crusade.remains>gcd*4)
						if judgmentVar and (buff.divinePurpose
							or (buff.theFiresOfJustice and (not talent.crusade or cd.crusade > gcd * 3))
							or (holyPower >= 4 and (not talent.crusade or cd.crusade > gcd * 4)))
						then
							if cast.divineStorm() then return end
						end
				-- Zeal
						-- zeal,if=holy_power<=4
						if holyPower <= 4 then
							if cast.zeal() then return end
						end
				-- Crusader Strike
						-- crusader_strike,if=holy_power<=4
						if holyPower <= 4 then
							if cast.crusaderStrike() then return end
						end
				-- Divine Storm
						-- divine_storm,if=debuff.judgment.up&holy_power>=3&spell_targets.divine_storm>=2&(!talent.crusade.enabled|cooldown.crusade.remains>gcd*5)
						if judgmentVar and holyPower >= 3 and #enemies.yards8 >= 2 and (not talent.crusade or cd.crusade > gcd * 5) then
							if cast.divineStorm() then return end
						end
				-- Templar's Verdict
						-- templars_verdict,if=debuff.judgment.up&holy_power>=3&(!talent.crusade.enabled|cooldown.crusade.remains>gcd*5)
						if judgmentVar and holyPower >= 3 and (not talent.crusade or cd.crusade > gcd * 5) then
							if cast.templarsVerdict() then return end
						end
					end -- End SimC APL
					if getOptionValue("APL Mode") == 2 then
			-- Execution Sentence
						-- if CooldownSecRemaining(Judgment) <= GlobalCooldownSec * 3
						if cd.judgment <= gcd * 3 then
							if cast.executionSentence(units.dyn5) then return end
						end
			-- Judgment
						if cast.judgment("target") then return end
			-- Consecration
						-- if not HasBuff(Judgment)
						if not debuff.judgment[units.dyn30].exists and #enemies.yards8 >= 3 then
							if cast.consecration() then return end
						end
			-- Justicar's Vengeance
						-- if HasBuff(DivinePurpose) and TargetsInRadius(DivineStorm) <= 3
						if buff.divinePurpose and #enemies.yards8 <= 3 then
							if cast.justicarsVengeance(units.dyn5) then return end
						end
			-- Divine Storm
						-- if (AlternatePower >= 4 or HasBuff(DivinePurpose) or HasBuff(Judgment)) and TargetsInRadius(DivineStorm) > 2
						if (holyPower >= 3 or buff.divinePurpose or debuff.judgment[units.dyn30].exists) and #enemies.yards8 > 2 then
							if cast.divineStorm() then return end
						end
			-- Templar's Verdict
						-- if (AlternatePower >= 4 or HasBuff(DivinePurpose) or HasBuff(Judgment))
						if (holyPower >= 3 or buff.divinePurpose or debuff.judgment[units.dyn30].exists) then
							if cast.templarsVerdict(units.dyn5) then return end
						end
			-- Wake of Ashes
						-- if AlternatePowerToMax >= 4
						if holyPowerMax - holyPower >= 4 then
							if cast.wakeOfAshes(units.dyn5) then return end
						end
			-- Blade of Justice
						-- if AlternatePowerToMax >= 2
						if holyPowerMax - holyPower >= 2 then
							if cast.bladeOfJustice(units.dyn5) then return end
						end
			-- Blade of Wrath
						-- if AlternatePowerToMax >= 2
						if holyPowerMax - holyPower >= 2 then
							if cast.bladeOfWrath(units.dyn5) then return end
						end
			-- Divine Hammer
						-- if AlternatePowerToMax >= 2
						if holyPowerMax - holyPower >= 2 then
							if cast.divineHammer(units.dyn5) then return end
						end
			-- Hammer of Justice
						-- if HasItem(JusticeGaze) and TargetHealthPercent > 0.75 and not HasBuff(Judgment)
						-- TODO
			-- Crusader Strike
						if cast.crusaderStrike(units.dyn5) then return end
			-- Zeal
						if cast.zeal(units.dyn5) then return end
					end -- End AMR APL
				end -- End In Combat
			end -- End Profile
	    end -- Timer
	end -- runRotation
	tinsert(cRetribution.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end -- End Class Check
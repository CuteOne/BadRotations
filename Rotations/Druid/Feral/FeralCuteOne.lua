if select(2, UnitClass("player")) == "DRUID" then
	local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
	local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = bb.player.spell.swipe },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.swipe },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.shred },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.healingTouch}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.berserk },
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.berserk },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.berserk }
        };
       	CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.survivalInstincts },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.survivalInstincts }
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
            [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = bb.player.spell.skullBash },
            [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = bb.player.spell.skullBash }
        };
        CreateButton("Interrupt",4,0)       
    -- Cleave Button
		CleaveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = bb.player.spell.thrash },
            [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = bb.player.spell.thrash }
        };
        CreateButton("Cleave",5,0)
    -- Prowl Button
		ProwlModes = {
            [1] = { mode = "On", value = 1 , overlay = "Prowl Enabled", tip = "Rotation will use Prowl", highlight = 1, icon = bb.player.spell.prowl },
            [2] = { mode = "Off", value = 2 , overlay = "Prowl Disabled", tip = "Rotation will not use Prowl", highlight = 0, icon = bb.player.spell.prowl }
        };
        CreateButton("Prowl",6,0)
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
            -- Death Cat
                bb.ui:createCheckbox(section,"Death Cat Mode","|cff15FF00Enable|cffFFFFFF/|cffD60000Disable |cffFFFFFFthis mode when running through low level content where you 1 hit kill mobs.")
            -- Fire Cat
                bb.ui:createCheckbox(section,"Perma Fire Cat","|cff15FF00Enable|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic use of Fandrel's Seed Pouch or Burning Seeds.")
            -- Dummy DPS Test
                bb.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
                bb.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Travel Shapeshifts
                bb.ui:createCheckbox(section,"Auto Shapeshifts","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to best form for situation.|cffFFBB00.")
            -- Break Crowd Control
                bb.ui:createCheckbox(section,"Break Crowd Control","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to break crowd control.|cffFFBB00.")
            -- Wild Charge
                bb.ui:createCheckbox(section,"Displacer Beast / Wild Charge","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Charge usage.|cffFFBB00.")
            bb.ui:checkSectionState(section)
        -- Cooldown Options
            section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
            -- Agi Pot
                bb.ui:createCheckbox(section,"Agi-Pot")
            -- Flask / Crystal
                bb.ui:createCheckbox(section,"Flask / Crystal")
            -- Berserk
                bb.ui:createCheckbox(section,"Berserk")
            -- Legendary Ring
                bb.ui:createCheckbox(section,"Legendary Ring")
            -- Racial
                bb.ui:createCheckbox(section,"Racial")
            -- Tiger's Fury
                bb.ui:createCheckbox(section,"Tiger's Fury")
            -- Incarnation: King of the Jungle
                bb.ui:createCheckbox(section,"Incarnation")
            -- Trinkets
                bb.ui:createCheckbox(section,"Trinkets")
            bb.ui:checkSectionState(section)
        -- Defensive Options
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
            -- Rebirth
                bb.ui:createCheckbox(section,"Rebirth")
                bb.ui:createDropdownWithout(section, "Rebirth - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
            -- Revive
                bb.ui:createCheckbox(section,"Revive")
                bb.ui:createDropdownWithout(section, "Revive - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
            -- Remove Corruption
                bb.ui:createCheckbox(section,"Remove Corruption")
                bb.ui:createDropdownWithout(section, "Remove Corruption - Target", {"|cff00FF00Player","|cffFFFF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
            -- Renewal
                bb.ui:createSpinner(section, "Renewal",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Healthstone
                bb.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
                bb.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Engineering: Shield-o-tronic
                bb.ui:createSpinner(section, "Shield-o-tronic",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Survival Instincts
                bb.ui:createSpinner(section, "Survival Instincts",  40,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Healing Touch
                bb.ui:createSpinner(section, "Healing Touch",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Dream of Cenarius Auto-Heal
                bb.ui:createDropdown(section, "Auto Heal", { "|cffFFDD11LowestHP", "|cffFFDD11Player"},  1,  "|cffFFFFFFSelect Target to Auto-Heal")
            bb.ui:checkSectionState(section)
        -- Interrupt Options
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
            -- Skull Bash
                bb.ui:createCheckbox(section,"Skull Bash")
            -- Mighty Bash
                bb.ui:createCheckbox(section,"Mighty Bash")
            -- Maim
                bb.ui:createCheckbox(section,"Maim")
            -- Interrupt Percentage
                bb.ui:createSpinner(section, "Interrupts",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
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
            -- Cleave Toggle
                bb.ui:createDropdown(section, "Cleave Mode", bb.dropOptions.Toggle,  6)
            -- Prowl Toggle
                bb.ui:createDropdown(section, "Prowl Mode", bb.dropOptions.Toggle,  6)
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
        if bb.timer:useTimer("debugFeral", math.random(0.15,0.3)) then
            --print("Running: "..rotationName)

    ---------------
	--- Toggles ---
	---------------
	        UpdateToggle("Rotation",0.25)
	        UpdateToggle("Cooldown",0.25)
	        UpdateToggle("Defensive",0.25)
	        UpdateToggle("Interrupt",0.25)
	        UpdateToggle("Cleave",0.25)
	        UpdateToggle("Prowl",0.25)

	--------------
	--- Locals ---
	--------------
	   		if leftCombat == nil then leftCombat = GetTime() end
			if profileStop == nil then profileStop = false end
			if lastSpellCast == nil then lastSpellCast = bb.player.spell.catForm end
	   		-- General Player Variables
			local lootDelay 									= getOptionValue("LootDelay")
			local hasMouse 										= ObjectExists("mouseover")
			local deadMouse 									= UnitIsDeadOrGhost("mouseover")
			local playerMouse 									= UnitIsPlayer("mouseover")
			local inCombat 										= bb.player.inCombat
			local level 										= bb.player.level
			local php	 										= bb.player.health
			local power, powmax, powgen 						= bb.player.power, bb.player.powerMax, bb.player.powerRegen
			local ttm 											= bb.player.timeToMax
			local falling, swimming, flying, moving				= getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
			local gcd 											= bb.player.gcd
			local t17_2pc 										= TierScan("T17")>=2 --bb.player.eq.t17_2pc
			local t18_2pc 										= TierScan("T18")>=2 --bb.player.eq.t18_2pc 
			local t18_4pc 										= TierScan("T18")>=4 --bb.player.eq.t18_4pc
            local talent                                        = bb.player.talent 
			local racial 										= bb.player.getRacial()
            local mode                                          = bb.player.mode
			local healPot 										= getHealthPot()
			local lowestHP 										= bb.friend[1].unit
			local pullTimer 									= bb.DBM:getPulltimer()
            local combatTime                                    = getCombatTime()
            local spell                                         = bb.player.spell
			-- Specific Player Variables
            local artifact                                      = bb.player.artifact
			local combo 										= bb.player.comboPoints
			local clearcast 									= bb.player.buff.clearcasting
			local travel, flight, cat, noform    				= bb.player.buff.travelForm, bb.player.buff.flightForm, bb.player.buff.catForm, GetShapeshiftForm()==0
			local stealth 										= bb.player.stealth
			local buff 											= bb.player.buff
			local cd 											= bb.player.cd
			local charges 										= bb.player.charges
			local debuff 										= bb.player.debuff
			local recharge 										= bb.player.recharge
			local talent 										= bb.player.talent
			local trinketProc									= bb.player.hasTrinketProc()
		    local flaskBuff										= getBuffRemain("player",bb.player.flask.wod.buff.agilityBig)
			local canFlask										= canUse(bb.player.flask.wod.agilityBig)
			local inRaid 										= bb.player.instance=="raid"
			local inInstance 									= bb.player.instance=="party"
			local solo 											= bb.player.instance=="none"
			local perk 											= bb.player.perk		
			-- -- Target Variables
			local bleed 										= bb.player.bleed
			local enemies 										= bb.player.enemies
			local dynTar5 										= bb.player.units.dyn5 --Melee
			local dynTar8 										= bb.player.units.dyn8 --Swipe
			local dynTar8AoE 									= bb.player.units.dyn8AoE --Thrash
			local dynTar13 										= bb.player.units.dyn13 --Skull Bash
			local dynTar20AoE 									= bb.player.units.dyn20AoE --Prowl
			local dynTar40AoE 									= bb.player.units.dyn40AoE --Cat Form/Moonfire	
			local dynTable5 									= (bb.player.mode.cleave==1 and bb.enemy) or { [1] = {["unit"]=dynTar5, ["distance"] = getDistance(dynTar5)}}
			local dynTable8 									= (bb.player.mode.cleave==1 and bb.enemy) or { [1] = {["unit"]=dynTar8, ["distance"] = getDistance(dynTar8)}}
			local dynTable8AoE 									= (bb.player.mode.cleave==1 and bb.enemy) or { [1] = {["unit"]=dynTar8AoE, ["distance"] = getDistance(dynTar8AoE)}}
			local dynTable13 									= (bb.player.mode.cleave==1 and bb.enemy) or { [1] = {["unit"]=dynTar13, ["distance"] = getDistance(dynTar13)}}
			local dynTable20AoE 								= (bb.player.mode.cleave==1 and bb.enemy) or { [1] = {["unit"]=dynTar20AoE, ["distance"] = getDistance(dynTar20AoE)}}
			local dynTable40AoE 								= (bb.player.mode.cleave==1 and bb.enemy) or { [1] = {["unit"]=dynTar40AoE, ["distance"] = getDistance(dynTar40AoE)}}
			local deadtar, attacktar, hastar, playertar 		= deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
			local friendly 										= friendly or UnitIsFriend("target", "player")
		    local mfTick 										= 20.0/(1+UnitSpellHaste("player")/100)/10
            local rkTick                                        = 3
            local rpTick                                        = 2
		    local multidot 										= (useCleave() or bb.player.mode.rotation ~= 3)
		    local fbDamage 										= getFbDamage()
            local ttd                                           = getTTD
            if lastForm == nil then lastForm = 0 end
            if talent.jaggedWounds then
                if rkTick==3 then
                    rkTick = rkTick - (rkTick * 0.3)
                end
                if rpTick==2 then
                    rpTick = rpTick - (rpTick * 0.3)
                end
            end
            -- ChatOverlay(round2(getDistance2("target"),2)..", "..round2(getDistance3("target"),2)..", "..round2(getDistance4("target"),2)..", "..round2(getDistance5("target"),2))
	--------------------
	--- Action Lists ---
	--------------------
		-- Action List - Extras
			local function actionList_Extras()
			-- Shapeshift Form Management
				if isChecked("Auto Shapeshifts") then
				-- Flight Form
					if IsFlyableArea() and ((not isInDraenor()) or isKnown(191633)) and not swimming and falling > 1 and level>=58 then 
						-- if stag then
			   --          	if bb.player.castFlightForm() then return end
			   --          elseif not stag then
			                if bb.player.castTravelForm() then return end
			            -- end
			        end
				-- Aquatic Form
				    if swimming and not travel and not hastar and not deadtar then
					  	if bb.player.castTravelForm() then return end
					end
				-- Cat Form
					if not cat then
				    	-- Cat Form when not swimming or flying or stag and not in combat
				    	if not inCombat and moving and not swimming and not flying and not travel then
			        		if bb.player.castCatForm() then return end
			        	end
			        	-- Cat Form when not in combat and target selected and within 20yrds
			        	if not inCombat and hastar and attacktar and not deadtar and getDistance("target")<20 then
			        		if bb.player.castCatForm() then return end
			        	end
			        	--Cat Form when in combat and not flying
			        	if inCombat and not flying then
			        		if bb.player.castCatForm() then return end
			        	end
			        end
				end -- End Shapeshift Form Management 
			-- Perma Fire Cat
				-- check if its check and player out of combat an not stealthed
				if isChecked("Perma Fire Cat") and not inCombat and not stealth and cat then
					-- check if Burning Essence buff expired
					if getBuffRemain("player",138927)==0 then
						-- check if player has the Fandral's Seed Pouch
						if PlayerHasToy(122304) then
							-- check if item is off cooldown
							if GetItemCooldown(122304)==0 then
								-- Let's only use it once and not spam it
								if not spamToyDelay or GetTime() > spamToyDelay then
									useItem(122304)
									spamToyDelay = GetTime() + 1
								end
							end
						-- check if Burning Seeds exist and are useable if Fandral's Seed Pouch doesn't exist
						elseif GetItemCooldown(94604)==0 and GetItemCount(94604,false,false) > 0 then
							useItem(94604)
						end
					end -- End Burning Essence Check
				end -- End Perma Fire Cat
			-- Death Cat mode
				if isChecked("Death Cat Mode") and cat then
			        if hastar and getDistance(dynTar8AoE) > 8 then
			            ClearTarget()
			        end
		            if bb.player.enemies.yards20 > 0 then
		            -- Tiger's Fury - Low Energy
	                	if bb.player.castTigersFury() then return end
		            -- Savage Roar - Use Combo Points
		                if combo >= 5 then
		                	if bb.player.castSavageRoar() then return end
		                end
		            -- Shred - Single
		                if bb.player.enemies.yards5 == 1 then
		                	if bb.player.castShred() then swipeSoon = nil; return end
		                end
		            -- Swipe - AoE
		                if bb.player.enemies.yards8 > 1 then
		                    if swipeSoon == nil then
		                        swipeSoon = GetTime();
		                    end
		                    if swipeSoon ~= nil and swipeSoon < GetTime() - 1 then
		                    	if bb.player.castSwipe() then swipeSoon = nil; return end
		                    end
		                end
		            end -- End 20yrd Enemy Scan
				end -- End Death Cat Mode
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
				if useDefensive() and not stealth and not flight then
			--Revive/Rebirth
					if isChecked("Rebirth") then
						if buff.remain.predatorySwiftness>0 then
							if getOptionValue("Rebirth - Target")==1 then
								if bb.player.castRebirth("target") then return end
							end
							if getOptionValue("Rebirth - Target")==2 then
								if bb.player.castRebirth("mouseover") then return end
							end
						end
					end
					if isChecked("Revive") then
						if getOptionValue("Revive - Target")==1 then
							if bb.player.castRevive("target") then return end
						end
						if getOptionValue("Revive - Target")==2 then
							if bb.player.castRevive("mouseover") then return end
						end
					end
			-- Remove Corruption
					if isChecked("Remove Corruption") then
						if getOptionValue("Remove Corruption - Target")==1 then
							if bb.player.castRemoveCorruption("player") then return end
						end
						if getOptionValue("Remove Corruption - Target")==2 then
							if bb.player.castRemoveCorruption("target") then return end
						end
						if getOptionValue("Remove Corruption - Target")==3 then
							if bb.player.castRemoveCorruption("mouseover") then return end
						end
					end
            -- Renewal
                    if isChecked("Renewal") and php <= getOptionValue("Renewal") and inCombat then
                        if bb.player.castRenewal() then return end
                    end
			-- PowerShift - Breaks Crowd Control (R.I.P Powershifting)
				    if isChecked("Break Crowd Control") then
                        if not hasNoControl() and lastForm ~= 0 then
                            CastShapeshiftForm(lastForm)
                            if GetShapeshiftForm() == lastForm then
                                lastForm = 0
                            end
                        elseif hasNoControl() then
                            if GetShapeshiftForm() == 0 then
                                bb.player.castCatForm()
                            else
        				        for i=1, GetNumShapeshiftForms() do
        				            if i == GetShapeshiftForm() then
                                        lastForm = i
                                        CastShapeshiftForm(i)
                                        return true
        				            end
        				        end
                            end
                        end
				    end
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
			-- Engineering: Shield-o-tronic
					if isChecked("Shield-o-tronic") and php <= getOptionValue("Shield-o-tronic") 
						and inCombat and canUse(118006) 
					then
						useItem(118006)
					end
			-- Healing Touch
		            if isChecked("Healing Touch") and (buff.remain.predatorySwiftness > 0 or not inCombat) then
		            	if getOptionValue("Auto Heal")==1 
                            and ((getHP(bb.friend[1].unit) <= getOptionValue("Healing Touch")/2 and inCombat) 
                                or (getHP(bb.friend[1].unit) <= getOptionValue("Healing Touch") and not inCombat) 
                                or (buff.remain.predatorySwiftness < 1 and buff.predatorySwiftness)) 
                        then
                            if bb.player.castHealingTouch(bb.friend[1].unit) then return end
                        end
                        if getOptionValue("Auto Heal")==2 
                            and (php <= getOptionValue("Healing Touch") or (buff.remain.predatorySwiftness < 1 and buff.predatorySwiftness)) 
                        then
                            if bb.player.castHealingTouch("player") then return end
                        end
		            end
			-- Survival Instincts
		            if isChecked("Survival Instincts") and php <= getOptionValue("Survival Instincts") 
		            	and inCombat and not buff.survivalInstincts and charges.survivalInstincts>0 
		            then
		            	if bb.player.castSurvivalInstincts() then return end
		            end
	    		end -- End Defensive Toggle
			end -- End Action List - Defensive
		-- Action List - Interrupts
			local function actionList_Interrupts()
				if useInterrupts() then
			-- Skull Bash
					if isChecked("Skull Bash") then
						for i=1, #dynTable13 do
							thisUnit = dynTable13[i].unit
							if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
								if bb.player.castSkullBash(thisUnit) then return end
							end
						end
					end
			-- Mighty Bash
	    			if isChecked("Mighty Bash") then
	    				for i=1, #dynTable5 do
							thisUnit = dynTable5[i].unit
							if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
								if bb.player.castMightyBash(thisUnit) then return end
							end
						end
					end
			-- Maim (PvP)
	    			if isChecked("Maim") then 
	    				for i=1, #dynTable5 do
							thisUnit = dynTable5[i].unit
	    					if canInterrupt(thisUnit,getOptionValue("InterruptAt")) and isInPvP() then
	    						if bb.player.castMaim(thisUnit) then return end
			    			end
		            	end
		          	end
			 	end -- End useInterrupts check
			end -- End Action List - Interrupts
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if getDistance(dynTar5)<5 then
            -- Elunes Guidance
                    -- pool_resource,wait=0.1,for_next=1,extra_amount=50
                    -- if=combo_points=0
                    if combo == 0 then
                        if talent.elunesGuidance and cd.elunesGuidance==0 and power < 50 then
                            return true
                        else
                            if bb.player.castElunesGuidance() then return end
                        end
                    end
			-- Berserk
					--if=buff.tigers_fury.up
		            if useCDs() and isChecked("Berserk") then
		            	if buff.tigersFury then
		            		if bb.player.castBerserk() then return end
		            	end
		            end
			-- Incarnation - King of the Jungle
                    -- if=cooldown.tigers_fury.remains<gcd
		            if useCDs() and isChecked("Incarnation") then
		            	if cd.tigersFury < gcd then
		            		if bb.player.castIncarnationKingOfTheJungle() then return end
		            	end
		            end
			-- Trinkets
                    -- TODO: if=(prev.tigers_fury&(target.time_to_die>trinket.stat.any.cooldown|target.time_to_die<45))|prev.berserk|(buff.incarnation.up&time<10)
					if useCDs() and isChecked("Trinkets") and getDistance(dynTar5)<5 then
                        if (lastSpellCast == spell.tigersFury and ttd(dynTar5) < 45) or lastSpellCast == spell.berserk or (buff.incarnation and combatTime < 10) then 
    						if canUse(13) then
    							useItem(13)
    						end
    						if canUse(14) then
    							useItem(14)
    						end
                        end
					end
            -- Agi-Pot
                    -- if=((buff.berserk.remains>10|buff.incarnation.remains>20)&(target.time_to_die<180|(trinket.proc.all.react&target.health.pct<25)))|target.time_to_die<=40
                    if useCDs() and isChecked("Agi-Pot") and canUse(109217) and inRaid then
                        if ((buff.remain.berserk > 10 or buff.remain.incarnation > 20) and (ttd(dynTar5) < 180 or (trinketProc and thp(dynTar5)<25))) or ttd(dynTar5)<=40 then
                            useItem(109217)
                            return true
                        end
                    end
            -- Legendary Ring
                    -- use_item,slot=finger1
                    if useCDs() and isChecked("Legendary Ring") then
                        if hasEquiped(124636) and canUse(124636) then
                            useItem(124636)
                            return true
                        end
                    end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                    -- blood_fury,sync=tigers_fury | berserking,sync=tigers_fury | arcane_torrent,sync=tigers_fury
                    if useCDs() and isChecked("Racial") and (bb.player.race == "Orc" or bb.player.race == "Troll" or bb.player.race == "Blood Elf") then
                        if lastSpellCast == spell.tigersFury then
                            if castSpell("player",racial,false,false,false) then return end
                        end
                    end            
            -- Tiger's Fury
                    if isChecked("Tiger's Fury") then
                        -- if=(!buff.clearcasting.react&energy.deficit>=60)|energy.deficit>=80|(t18_class_trinket&buff.berserk.up&buff.tigers_fury.down)
                        if (not clearcast and bb.player.powerDeficit >= 60) or bb.player.powerDeficit >= 80 or (hasEquiped(124514) and buff.berserk and not buff.tigersFury) then
                            if bb.player.castTigersFury() then return end
                        end
                        -- if=talent.sabertooth.enabled&time<10&combo_points=5
                        if talent.sabertooth and combatTime < 10 and combo == 5 then
                            if bb.player.castTigersFury() then return end
                        end
                    end 
            -- Incarnation - King of the Jungle
                    -- if=energy.time_to_max>1&energy>=35
                    if useCDs() and isChecked("Incarnation") then
                        if ttm > 1 and power >= 35 then
                            if bb.player.castIncarnationKingOfTheJungle() then return end
                        end
                    end
                end -- End useCooldowns check
            end -- End Action List - Cooldowns
        -- Action List - PreCombat
            local function actionList_PreCombat()
                if not inCombat and not (IsFlying() or IsMounted()) then
                    if not stealth then
            -- Flask / Crystal
                        -- flask,type=flask_of_the_seventh_demon
                        if isChecked("Flask / Crystal") and not stealth then
                            if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",188033) then
                                useItem(bb.player.flask.wod.agilityBig)
                                return true
                            end
                            if flaskBuff==0 then
                                if not UnitBuffID("player",188033) and canUse(118922) then --Draenor Insanity Crystal
                                    useItem(118922)
                                    return true
                                end
                            end
                        end
            -- TODO: food,type=the_hungry_magister
            -- Prowl - Non-PrePull
                        if cat then --and (not friendly or isDummy()) 
                            for i=1, #dynTable20AoE do
                                local thisUnit = dynTable20AoE[i].unit
                                if dynTable20AoE[i].distance < 20 then
                                    if useProwl() and not inInstance and not inRaid and ((ObjectExists(thisUnit) and UnitCanAttack(thisUnit,"player")) or perk.enhancedProwl) and GetTime()-leftCombat > lootDelay then
                                        if bb.player.castProwl() then return end
                                    end
                                end
                            end
                        end
                    end -- End No Stealth
            -- Wild Charge
                    if isChecked("Displacer Beast / Wild Charge") and solo and attacktar and not deadtar and not friendly then
                        if bb.player.castWildCharge("target") then return end 
                    end
                    if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
            -- Healing Touch
                        -- healing_touch,if=talent.bloodtalons.enabled
                        if talent.bloodtalons and not buff.bloodtalons and (htTimer == nil or htTimer < GetTime() - 1) then
                            if bb.player.castHealingTouch("player") then htTimer = GetTime(); return end
                        end
            -- Prowl 
                        if buff.bloodtalons then
                            if bb.player.castProwl() then return end
                        end
                        if buff.prowl then
            -- Pre-Pot
                            -- potion,name=draenic_agility
                            if useCDs() and isChecked("Agi-Pot") and canUse(109217) then
                                useItem(109217)
                                return true
                            end
            -- Incarnation
                            -- incarnation
                            if useCDs() and isChecked("Incarnation") then
                                if bb.player.castIncarnationKingOfTheJungle() then return end
                            end
                        end -- End Prowl
                    end -- End Pre-Pull
            -- Rake/Shred
                    if hastar and attacktar then
                        if level < 6 then
                            if bb.player.castShred(dynTar5) then return end
                        else
                           if bb.player.castRake(dynTar5) then return end
                        end
                    end
                end -- End No Combat
            end -- End Action List - PreCombat 
        -- Action List - Finisher
            local function actionList_Finisher()
            -- Finisher: Rip
                -- cycle_targets=1,if=(!dot.rip.ticking|(remains<2&target.health.pct>25&!talent.sabertooth.enabled))&target.time_to_die-remains>tick_time*4
                -- cycle_targets=1,if=remains<=8&target.health.pct>25&!talent.sabertooth.enabled&target.time_to_die-remains>tick_time*4
                -- if=persistent_multiplier>dot.rip.pmultiplier&target.time_to_die-remains>tick_time*4
                for i=1, #bleed.rip do
                    local rip = bleed.rip[i]
                    local thisUnit = rip.unit
                    if (multidot or (UnitIsUnit(thisUnit,dynTar5) and not multidot)) then
                        if ((rip.remain == 0 or (rip.remain < 2 and thp(thisUnit) > 25 and not talent.sabertooth)) and ttd(thisUnit) - rip.remain > rpTick * 4)
                            or (rip.remain <= 8 and thp(thisUnit) > 25 and not talent.sabertooth and ttd(thisUnit) - rip.remain > rpTick * 4)
                        then
                           if bb.player.castRip(thisUnit) then return end
                        end
                    end
                    if UnitIsUnit(thisUnit,dynTar5) then
                        if rip.calc > rip.applied and ttd(thisUnit) - rip.remain > rpTick * 4 then
                            if bb.player.castRip(thisUnit) then return end
                        end
                    end
                end
             -- Finisher: Savage Roar
                -- if=buff.savage_roar.remains<=7.2
                if buff.remain.savageRoar <= 7.2 then
                    if bb.player.castSavageRoar() then return end
                end
            -- Finisher: Ferocious Bite
                -- max_energy=1,cycle_targets=1,if=target.health.pct<25|talent.sabertooth.enabled|buff.berserk.up|buff.incarnation.up|buff.elunes_guidance.up|(talent.moment_of_clarity.enabled&buff.clearcasting.react)|energy.time_to_max<1|cooldown.tigers_fury.remains<3|set_bonus.tier18_4pc
                for i=1, #bleed.rip do
                    local rip = bleed.rip[i]
                    local thisUnit = rip.unit
                    if (multidot or (UnitIsUnit(thisUnit,dynTar5) and not multidot)) then
                        if power>50 then
                            if thp(thisUnit) < 25 or talent.sabertooth or buff.berserk or buff.incarnation or buff.elunesGuidance 
                                or (talent.momentOfClarity and buff.clearcasting) or ttm < 1 or cd.tigersFury < 3 or t18_4pc 
                            then
                                if bb.player.castFerociousBite(thisUnit) then return end
                            end
                        end
                    end
                end
            end -- End Action List - Finisher
        -- Action List - Maintain
            local function actionList_Maintain()
            -- Maintain: Rake
                -- cycle_targets=1,if=(remains<2|(!talent.bloodtalons.enabled&remains<=duration*0.3))&target.time_to_die-remains>tick_time
                -- cycle_targets=1,if=talent.bloodtalons.enabled&buff.bloodtalons.up&(!talent.soul_of_the_forest.enabled&remains<=7|remains<=5)&persistent_multiplier>dot.rake.pmultiplier*0.80&target.time_to_die-remains>tick_time
                -- if=persistent_multiplier>dot.rake.pmultiplier&target.time_to_die-remains>tick_time
                for i=1, #bleed.rake do
                    local rake = bleed.rake[i]
                    local thisUnit = rake.unit
                    if multidot or (UnitIsUnit(thisUnit,dynTar5) and not multidot) then
                        if ((rake.remain < 2 or (not talent.bloodtalons and rake.remain <= rake.duration * 0.3)) and ttd(thisUnit) > rkTick)
                            or (talent.bloodtalons and buff.bloodtalons and (not talent.soulOfTheForest and rake.remain <= 7 or rake.remain <= 5) 
                                and rake.calc > rake.applied * 0.8 and ttd(thisUnit) - rake.remain > rkTick)
                        then 
                            if bb.player.castRake(thisUnit) then return end
                        end
                    end
                    if UnitIsUnit(thisUnit,dynTar5) then
                        if rake.calc > rake.applied and ttd(thisUnit) - rake.remain > rkTick then
                           if bb.player.castRake(thisUnit) then return end
                        end
                    end  
                end
            -- Maintain: Moonfire
                -- cycle_targets=1,if=remains<=4.2&target.time_to_die-remains>tick_time*2
                for i=1, #bleed.moonfire do
                    local moonfire = bleed.moonfire[i]
                    local thisUnit = moonfire.unit
                    if multidot or (UnitIsUnit(thisUnit,dynTar40AoE) and not multidot) then
                        if moonfire.remain <= 4.2 and ((ttd(thisUnit) - moonfire.remain > mfTick * 2) or isDummy()) then
                           if bb.player.castFeralMoonfire(thisUnit) then return end
                        end
                    end
                end     
            end -- End Action List - Maintain
        -- Action List - Generator
            local function actionList_Generator()
            -- Generator: Swipe
                -- if=spell_targets.swipe>=4
                if mode.rotation==2 or (mode.rotation==1 and enemies.yards8>=4) then
                    if level < 32 then
                        if bb.player.castShred(dynTar5) then return end
                    else
                        if bb.player.castSwipe(dynTar8) then return end
                    end
                end
            -- Generator: Shred
                -- if=spell_targets.swipe<=3|talent.brutalSlash
                if mode.rotation==3 or (mode.rotation==1 and (enemies.yards8<=3 or talent.brutalSlash)) then
                    if bb.player.castShred(dynTar5) then return end
                end
            end -- End Action List - Generator
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
            -- Cat is 4 fyte!
                if inCombat and not cat and not (flight or travel) then
                    if bb.player.castCatForm() then return end
                elseif inCombat and cat and profileStop==false and not isChecked("Death Cat Mode") then
            -- Wild Charge
                    if isChecked("Displacer Beast / Wild Charge") then
                        if bb.player.castWildCharge("target") then return end 
                    end
            -- TODO: Displacer Beast
            -- TODO: Dash/Worgen Racial
            -- Rake/Shred from Stealth
                    -- rake,if=buff.prowl.up|buff.shadowmeld.up
                    if buff.prowl or buff.shadowmeld then
                        if level < 6 then
                            if bb.player.castShred(dynTar5) then return end
                        else
                           if bb.player.castRake(dynTar5) then return end
                        end
                    elseif not stealth then
                        -- auto_attack
                        if getDistance(dynTar5)<5 then
                            StartAttack()
                        end
        ------------------------------
        --- In Combat - Interrupts ---
        ------------------------------
                        if actionList_Interrupts() then return end
        -----------------------------
        --- In Combat - Cooldowns ---
        -----------------------------
                        if actionList_Cooldowns() then return end
        ---------------------------
        --- SimulationCraft APL ---
        ---------------------------
                        if getOptionValue("APL Mode") == 1 then
            -- Ferocious Bite
                            -- for i=1, #getEnemies("player",5) do
                            --     local thisUnit = getEnemies("player",5)[i]
                            --     if fbDamage > UnitHealth(thisUnit) and not isDummy() then
                            --         if bb.player.castFerociousBite(thisUnit) then return end
                            --     end
                            -- end
            -- Ferocious Bite
                            -- cycle_targets=1,if=dot.rip.ticking&dot.rip.remains<3&target.time_to_die-dot.rip.remains>2&(target.health.pct<25|talent.sabertooth.enabled)
                            for i=1, #bleed.rip do
                                local rip = bleed.rip[i]
                                local thisUnit = rip.unit
                                if (multidot or (UnitIsUnit(thisUnit,dynTar5) and not multidot)) then
                                    if rip.remain > 0 and rip.remain < 3 and ttd(thisUnit) - rip.remain > 2 and (thp(thisUnit) < 25 or talent.sabertooth) then
                                        if bb.player.castFerociousBite(thisUnit) then return end
                                    end
                                end
                            end
            -- Healing Touch
                            -- if=talent.bloodtalons.enabled&buff.predatory_swiftness.up
                            -- if=combo_points>=5
                            -- if=buff.predatory_swiftness.remains<1.5
                            -- if=combo_points=2&buff.bloodtalons.down&cooldown.ashamanes_frenzy.remains<gcd
                            if talent.bloodtalons and buff.predatorySwiftness then
                                if combo >= 5
                                    or buff.remain.predatorySwiftness < 1.5
                                    or (combo == 5 and not buff.predatorySwiftness and cd.ashamanesFrenzy < gcd)
                                then
                                    if getOptionValue("Auto Heal")==1 then
                                        if bb.player.castHealingTouch(bb.friend[1].unit) then return end
                                    end
                                    if getOptionValue("Auto Heal")==2 then
                                        if bb.player.castHealingTouch("player") then return end
        			                end
                                end
    						end
			-- Savage Roar
    						-- if=buff.savage_roar.down
    						if not buff.savageRoar then
    							if bb.player.castSavageRoar() then return end
    			            end
			-- Thrash
                            -- pool_resource,for_next=1
                            -- cycle_targets=1,if=remains<=duration*0.3&spell_targets.thrash_cat>=5
    						for i=1, #bleed.thrash do
    							local thrash = bleed.thrash[i]
    							local thisUnit = thrash.unit
    							if (multidot or (UnitIsUnit(thisUnit,dynTar8AoE) and not multidot)) then 
                                    if thrash.remain <= thrash.duration * 0.3 and enemies.yards8 >= 5 and getDistance(thisUnit) < 8 then
                                        if power < 50 then
                                            return true
                                        else
    								        if bb.player.castThrash(thisUnit) then return end
                                        end
                                    end
    							end
    						end
			-- Finishers
    						-- if=combo_points=5
                            -- combo_points=5&(target.health.pct<25|dot.rip.remains<2|energy.time_to_max<1|talent.soul_of_the_forest.enabled|buff.berserk.up|buff.incarnation.up|dot.rake.remains<1.5|buff.elunes_guidance.up|cooldown.tigers_fury.remains<3|(talent.moment_of_clarity.enabled&buff.clearcasting.react)|set_bonus.tier18_4pc)
    						if combo==5 
                                and (thp(dynTar5) < 25 or debuff.remain.rip < 2 or ttm < 1 or talent.soulOfTheForest or buff.berserk or buff.incarnation 
                                    or debuff.remain.rake < 1.5 or buff.elunesGuidance or cd.tigersFury < 3 or (talent.momentOfClarity and buff.clearcast) or t18_4pc) 
                            then
    		  					if actionList_Finisher() then return end
    						end --End Finishers
            -- Ashamane's Frenzy
                            -- if=combo_points<=2&buff.elunes_guidance.down&(buff.bloodtalons.up|!talent.bloodtalons.enabled)
                            if combo <= 2 and not buff.elunesGuidance and (buff.bloodtalons or not talent.bloodtalons) then
                                if bb.player.castAshamanesFrenzy(dynTar5) then return end
                            end
            -- Savage Roar
                            -- if=buff.savage_roar.remains<gcd
                            if buff.remain.savageRoar<gcd then
                                if bb.player.castSavageRoar() then return end
                            end
            -- Brutal Slash
                            -- if=spell_targets.brutal_slash>=2&(charges_fractional>=2.8|dot.rip.ticking)
                            if (multidot or (UnitIsUnit(thisUnit,dynTar8AoE) and not multidot)) then
                                if enemies.yards8 >= 2 and (charges.frac.brutalSlash >= 2.8 or debuff.rip) then
                                    if bb.player.castBrutalSlash(dynTar5) then return end
                                end
                            end
            -- Thrash
                            -- pool_resource,for_next=1
                            -- if=talent.brutal_slash.enabled&spell_targets.thrash_cat>=9
                            if (multidot or (UnitIsUnit(thisUnit,dynTar8AoE) and not multidot)) then  
                                if talent.brutalSlash and enemies.yards8 >= 9 then
                                   if power < 50 then
                                        return true
                                    else
                                        if bb.player.castThrash(dynTar8) then return end
                                    end
                                end
                            end
			-- Maintain
    						-- if=combo_points<5&(spell_targets.swipe_cat<=5|talent.brutal_slash.enabled)
    						if combo < 5 and (enemies.yards8 <= 5 or talent.brutalSlash) then
    			    			if actionList_Maintain() then return end
    						end --End Maintain
			-- Thrash
                            -- pool_resource,for_next=1
                            -- cycle_targets=1,if=remains<=duration*0.3&spell_targets.thrash_cat>=2
    						for i = 1, #bleed.thrash do
    							local thrash = bleed.thrash[i]
    							local thisUnit = thrash.unit
    							if (multidot or (UnitIsUnit(thisUnit,dynTar8AoE) and not multidot)) then
                                    if thrash.remain <= thrash.duration * 0.3 and enemies.yards8 >= 2 and getDistance(thisUnit) < 8 then
                                        if power < 50 then
                                            return true
                                        else
    								        if bb.player.castThrash(thisUnit) then return end
                                        end
                                    end
    							end
    						end
			-- Generator
    						-- if=combo_points<5
    						if combo < 5 then
    			    			if actionList_Generator() then return end
    				    	end --End Generator
                        end -- End SimC APL
        ------------------------
        --- Ask Mr Robot APL ---
        ------------------------
                        if getOptionValue("APL Mode") == 2 then
            -- Healing Touch
                            -- if HasTalent(Bloodtalons) and HasBuff(PredatorySwiftness) and not HasBuff(Prowl)
                            if talent.bloodtalons and buff.predatorySwiftness and not buff.prowl then
                                if getOptionValue("Auto Heal")==1 then
                                    if bb.player.castHealingTouch(bb.friend[1].unit) then return end
                                end
                                if getOptionValue("Auto Heal")==2 then
                                    if bb.player.castHealingTouch("player") then return end
                                end
                            end
            -- Savage Roar
                            -- if AlternatePower >= 5 and BuffRemainingSec(SavageRoar) < 6 and not CanRefreshDot(Rip)
                            if combo >= 5 and buff.remain.savageRoar < 6 and debuff.remain.rip > (debuff.duration.rip * 0.3) then
                                if bb.player.castSavageRoar() then return end
                            end  
            -- Rake
                            -- multi-DoT = 3
                            if #bleed.rake < 3 then
                                for i=1, #bleed.rake do
                                    local rake = bleed.rake[i]
                                    local thisUnit = rake.unit
                                    if multidot or (UnitIsUnit(thisUnit,dynTar5) and not multidot) then
                                        if rake.remain <= (rake.duration * 0.3) then
                                            if bb.player.castRake(thisUnit) then return end
                                        end
                                    end
                                end
                            end
            -- Moonfire
                            -- multi-Dot = 3
                            if #bleed.moonfire < 3 then
                                for i=1, #bleed.moonfire do
                                    local moonfire = bleed.moonfire[i]
                                    local thisUnit = moonfire.unit
                                    if multidot or (UnitIsUnit(thisUnit,dynTar40AoE) and not multidot) then
                                        if oonfire.remain <= 4.2 and enemies.yards8 <= 8 then
                                           if bb.player.castFeralMoonfire(thisUnit) then return end
                                        end
                                    end
                                end 
                            end
            -- Elune's Guidance
                            -- if AlternatePower = 0
                            if combo == 0 then
                                if bb.player.castElunesGuidance() then return end
                            end
            -- Cooldowns
                            -- if AlternatePower >= 5
                            if combo >= 5 then
                                if actionList_Cooldowns() then return end
                            end
            -- Ferocious Bite
                            -- if AlternatePower >= 5 and (CanExecuteTarget or not CanRefreshDot(Rip))
                            if combo >= 5 and (thp(dynTar5) < 25 or debuff.remain.rip > (debuff.duration.rip * 0.3)) then
                                if bb.player.castFerociousBite(dynTar5) then return end
                            end
            -- Rip
                            -- if AlternatePower >= 5
                            if combo >= 5 then
                                if bb.player.castRip(dynTar5) then return end
                            end
            -- Thrash
                            -- if TargetsInRadius(Thrash) >= 3 and CanRefreshDot(ThrashBleedFeral)
                            if useAoE() and debuff.remain.thrash <= (debuff.duration.thrash * 0.3) then
                                if bb.player.castThrash(dynTar8) then return end
                            end
            -- Swipe
                            -- if TargetsInRadius(Swipe) >= 3
                            if useAoE() then
                                if bb.player.castSwipe(dynTar8) then return end
                            end
            -- Shred
                            if bb.player.castShred(dynTar5) then return end
                        end
				    end -- End No Stealth | Rotation Off Check
				end --End In Combat
			end --End Rotation Logic
        end -- End Timer
    end -- End runRotation
    tinsert(cFeral.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end --End Class Check
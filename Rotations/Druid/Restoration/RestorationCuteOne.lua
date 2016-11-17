if select(2, UnitClass("player")) == "DRUID" then
	local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
	local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.swipe },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.swipe },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.shred },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.regrowth}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.berserk },
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.berserk },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.berserk }
        };
       	CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.survivalInstincts },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.survivalInstincts }
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
            [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.skullBash },
            [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.skullBash }
        };
        CreateButton("Interrupt",4,0)
    end

---------------
--- OPTIONS ---
---------------
	local function createOptions()
        local optionTable

        local function rotationOptions()
            local section
        -- General Options
            section = br.ui:createSection(br.ui.window.profile, "General")
            -- APL
                br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
                br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
                br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Travel Shapeshifts
                br.ui:createCheckbox(section,"Auto Shapeshifts","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to best form for situation.|cffFFBB00.")
            -- Break Crowd Control
                br.ui:createCheckbox(section,"Break Crowd Control","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to break crowd control.|cffFFBB00.")
            br.ui:checkSectionState(section)
        -- Cooldown Options
            section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Potion
                br.ui:createCheckbox(section,"Potion")
            -- Flask / Crystal
                br.ui:createCheckbox(section,"Flask / Crystal")
             -- Racial
                br.ui:createCheckbox(section,"Racial")
            -- Trinkets
                br.ui:createCheckbox(section,"Trinkets")
            br.ui:checkSectionState(section)
        -- Defensive Options
            section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Rebirth
                br.ui:createCheckbox(section,"Rebirth")
                br.ui:createDropdownWithout(section, "Rebirth - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
            -- Revive
                br.ui:createCheckbox(section,"Revive")
                br.ui:createDropdownWithout(section, "Revive - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
            -- Remove Corruption
                br.ui:createCheckbox(section,"Remove Corruption")
                br.ui:createDropdownWithout(section, "Remove Corruption - Target", {"|cff00FF00Player","|cffFFFF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
            -- Healthstone
                br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
                br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            br.ui:checkSectionState(section)
        -- Interrupt Options
            section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Interrupt Percentage
                br.ui:createSpinner(section, "Interrupts",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
            br.ui:checkSectionState(section)
        -- Toggle Key Options
            section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
                br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
                br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            -- Defensive Key Toggle
                br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
                br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
                br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
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
        if br.timer:useTimer("debugRestoration", math.random(0.15,0.3)) then
            --print("Running: "..rotationName)

    ---------------
	--- Toggles ---
	---------------
	        UpdateToggle("Rotation",0.25)
	        UpdateToggle("Cooldown",0.25)
	        UpdateToggle("Defensive",0.25)
	        UpdateToggle("Interrupt",0.25)

	--------------
	--- Locals ---
    --------------
            local addsExist                                     = false 
            local addsIn                                        = 999
            local animality                                     = false
            local artifact                                      = br.player.artifact
            -- local bleed                                         = br.player.bleed
            local buff                                          = br.player.buff
            local canFlask                                      = canUse(br.player.flask.wod.agilityBig)
            local cast                                          = br.player.cast
            local clearcast                                     = br.player.buff.clearcasting
            local combatTime                                    = getCombatTime()
            local combo                                         = br.player.comboPoints
            local cd                                            = br.player.cd
            local charges                                       = br.player.charges
            local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
            local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
            local debuff                                        = br.player.debuff
            local enemies                                       = br.player.enemies
            local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
            local fatality                                      = false
            local fbDamage                                      = getFbDamage()
            local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
            local friendly                                      = friendly or UnitIsFriend("target", "player")
            local gcd                                           = br.player.gcd
            local hasMouse                                      = ObjectExists("mouseover")
            local healPot                                       = getHealthPot()
            local inCombat                                      = br.player.inCombat
            local inInstance                                    = br.player.instance=="party"
            local inRaid                                        = br.player.instance=="raid"
            local level                                         = br.player.level
            local lootDelay                                     = getOptionValue("LootDelay")
            local lowestHP                                      = br.friend[1].unit
            local mfTick                                        = 20.0/(1+UnitSpellHaste("player")/100)/10
            local mode                                          = br.player.mode
            local multidot                                      = (br.player.mode.cleave == 1 or br.player.mode.rotation == 2) and br.player.mode.rotation ~= 3
            local perk                                          = br.player.perk        
            local php                                           = br.player.health
            local playerMouse                                   = UnitIsPlayer("mouseover")
            local potion                                        = br.player.potion
            local power, powmax, powgen                         = br.player.energy, br.player.powerMax, br.player.powerRegen
            local pullTimer                                     = br.DBM:getPulltimer()
            local racial                                        = br.player.getRacial()
            local recharge                                      = br.player.recharge
            local rkTick                                        = 3
            local rpTick                                        = 2
            local solo                                          = #br.friend < 2
            local friendsInRange                                = friendsInRange
            local spell                                         = br.player.spell
            local stealth                                       = br.player.stealth
            local t17_2pc                                       = TierScan("T17")>=2 --br.player.eq.t17_2pc
            local t18_2pc                                       = TierScan("T18")>=2 --br.player.eq.t18_2pc 
            local t18_4pc                                       = TierScan("T18")>=4 --br.player.eq.t18_4pc
            local talent                                        = br.player.talent
            local travel, flight, cat, noform                   = br.player.buff.travelForm, br.player.buff.flightForm, br.player.buff.catForm, GetShapeshiftForm()==0
            local trinketProc                                   = false
            local ttd                                           = getTTD
            local ttm                                           = br.player.timeToMax
            local units                                         = br.player.units
            
	   		if leftCombat == nil then leftCombat = GetTime() end
			if profileStop == nil then profileStop = false end
			if lastSpellCast == nil then lastSpellCast = spell.catForm end
            if lastForm == nil then lastForm = 0 end
            if talent.jaggedWounds then
                if rkTick == 3 then rkTick = rkTick - (rkTick * 0.3) end
                if rpTick == 2 then rpTick = rpTick - (rpTick * 0.3) end
            end
            if br.player.potion.agility[1] ~= nil then
                agiPot = br.player.potion.agility[1].itemID 
            else
                agiPot = 0
            end
            friendsInRange = 0
            if not solo then
                for i = 1, #br.friend do
                    if getDistance(br.friend[i].unit) < 15 then
                        friendsInRange = friendsInRange + 1
                    end
                end
            end
            -- ChatOverlay(round2(getDistance("target","player","dist"),2)..", "..round2(getDistance("target","player","dist2"),2)..", "..round2(getDistance("target","player","dist3"),2)..", "..round2(getDistance("target","player","dist4"),2))
            
	--------------------
	--- Action Lists ---
	--------------------
		-- Action List - Extras
			local function actionList_Extras()
			-- Shapeshift Form Management
				if isChecked("Auto Shapeshifts") then
				-- Flight Form
					if IsFlyableArea() and ((not (isInDraenor() or isInLegion())) or isKnown(191633)) and not swimming and falling > 1 and level>=58 then 
		                if cast.travelForm() then return end
			        end
				-- Aquatic Form
				    if swimming and not travel and not hastar and not deadtar and not buff.prowl then
					  	if cast.travelForm() then return end
					end
				-- Cat Form
					if not cat then
				    	-- Cat Form when not swimming or flying or stag and not in combat
				    	if not inCombat and moving and not swimming and not flying and not travel and not IsMounted() and not isValidUnit("target") then
			        		if cast.catForm() then return end
			        	end
			        	-- Cat Form when not in combat and target selected and within 20yrds
			        	if not inCombat and isValidUnit("target") and getDistance("target") < 30 then
			        		if cast.catForm() then return end
			        	end
			        	--Cat Form when in combat and not flying
			        	if inCombat and not flying then
			        		if cast.catForm() then return end
			        	end
			        end
				end -- End Shapeshift Form Management 
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
				if useDefensive() and not stealth and not flight and not buff.prowl then
			--Revive/Rebirth
					if isChecked("Rebirth") then
						if buff.remain.predatorySwiftness>0 then
							if getOptionValue("Rebirth - Target")==1 
                                and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                            then
								if cast.rebirth("target","dead") then return end
							end
							if getOptionValue("Rebirth - Target")==2 
                                and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                            then
								if cast.rebirth("mouseover","dead") then return end
							end
						end
					end
					if isChecked("Revive") then
						if getOptionValue("Revive - Target")==1 
                            and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                        then
							if cast.revive("target","dead") then return end
						end
						if getOptionValue("Revive - Target")==2 
                            and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                        then
							if cast.revive("mouseover","dead") then return end
						end
					end
			-- Remove Corruption
					if isChecked("Remove Corruption") then
						if getOptionValue("Remove Corruption - Target")==1 and canDispel("player",spell.removeCorruption) then
							if cast.removeCorruption("player") then return end
						end
						if getOptionValue("Remove Corruption - Target")==2 and canDispel("target",spell.removeCorruption) then
							if cast.removeCorruption("target") then return end
						end
						if getOptionValue("Remove Corruption - Target")==3 and canDispel("mouseover",spell.removeCorruption) then
							if cast.removeCorruption("mouseover") then return end
						end
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
                                cast.catForm()
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
	    		end -- End Defensive Toggle
			end -- End Action List - Defensive
		-- Action List - Interrupts
			local function actionList_Interrupts()
				if useInterrupts() then

			 	end -- End useInterrupts check
			end -- End Action List - Interrupts
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if getDistance("target") < 5 then
			-- Trinkets
                    -- TODO: if=(buff.tigers_fury.up&(target.time_to_die>trinket.stat.any.cooldown|target.time_to_die<45))|buff.incarnation.remains>20
					if useCDs() and isChecked("Trinkets") and getDistance(units.dyn5) < 5 then
						if canUse(13) then
							useItem(13)
						end
						if canUse(14) then
							useItem(14)
						end
					end
            -- Potion
                    -- if=((buff.berserk.remains>10|buff.incarnation.remains>20)&(target.time_to_die<180|(trinket.proc.all.react&target.health.pct<25)))|target.time_to_die<=40
                    if useCDs() and isChecked("Agi-Pot") and canUse(agiPot) and inRaid then
                        useItem(agiPot);
                        return true
                    end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                    -- blood_fury,buff.tigers_fury | berserking,buff.tigers_fury | arcane_torrent,buff.tigers_fury
                    if useCDs() and isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                        if castSpell("player",racial,false,false,false) then return end
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
                                useItem(br.player.flask.wod.agilityBig)
                                return true
                            end
                            if flaskBuff==0 then
                                if not UnitBuffID("player",188033) and canUse(118922) then --Draenor Insanity Crystal
                                    useItem(118922)
                                    return true
                                end
                            end
                        end
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
            -- Cat is 4 fyte!
                if inCombat and not cat and not (flight or travel or IsMounted() or IsFlying()) and isChecked("Auto Shapeshifts") then
                    -- if cast.catForm() then return end
                elseif inCombat and cat and profileStop==false and not isChecked("Death Cat Mode") and isValidUnit(units.dyn5) and getDistance(units.dyn5) < 5 then
            -- Rake/Shred from Stealth
                    -- rake,if=buff.prowl.up|buff.shadowmeld.up
                    if buff.prowl or buff.shadowmeld then

                    elseif not stealth then
                        -- auto_attack
                        if getDistance("target") < 5 then
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
           
                        end -- End SimC APL
        ------------------------
        --- Ask Mr Robot APL ---
        ------------------------
                        if getOptionValue("APL Mode") == 2 then
            
                        end
				    end -- End No Stealth | Rotation Off Check
				end --End In Combat
			end --End Rotation Logic
        end -- End Timer
    end -- End runRotation
    tinsert(cRestoration.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end --End Class Check
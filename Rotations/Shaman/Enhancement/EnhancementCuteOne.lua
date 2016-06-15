if select(2, UnitClass("player")) == "SHAMAN" then
    local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
	local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = bb.player.spell.chainLightning },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.chainLightning },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.lightningBolt },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.healingSurge}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.ascendance },
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.ascendance },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.ascendance }
        };
       	CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.shamanisticRage },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.shamanisticRage }
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
            [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = bb.player.spell.windShear },
            [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = bb.player.spell.windShear }
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
                -- Dummy DPS Test
                bb.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
                -- Earthbind/Earthgrab Totem
                bb.ui:createCheckbox(section,"Earthbind/grab Totem")
                -- Ghost Wolf
                bb.ui:createCheckbox(section,"Ghost Wolf")
                -- Spirit Walk
                bb.ui:createCheckbox(section,"Spirit Walk")
                -- Tremor Totem
                bb.ui:createCheckbox(section,"Tremor Totem")
                -- Water Walking
                bb.ui:createCheckbox(section,"Water Walking")
                 -- Pre-Pull Timer
                bb.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            bb.ui:checkSectionState(section)
            ------------------------
            --- COOLDOWN OPTIONS ---
            ------------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "Cooldowns")
                -- Agi Pot
                bb.ui:createCheckbox(section,"Agi-Pot")
                -- Legendary Ring
                bb.ui:createCheckbox(section, "Legendary Ring", "Enable or Disable usage of Legendary Ring.")
                -- Flask / Crystal
                bb.ui:createCheckbox(section,"Flask / Crystal")
                -- Trinkets
                bb.ui:createCheckbox(section,"Trinkets")
                -- Touch of the Void
                bb.ui:createCheckbox(section,"Touch of the Void")
                -- Heroism/Bloodlust
                bb.ui:createCheckbox(section,"HeroLust")
                -- Elemental Mastery
                bb.ui:createCheckbox(section,"Elemental Mastery")
                -- Storm Elemental Totem
                bb.ui:createCheckbox(section,"Storm Elemental Totem")
                -- Fire Elemental Totem
                bb.ui:createCheckbox(section,"Fire Elemental Totem")
                -- Feral Spirit
                bb.ui:createCheckbox(section,"Feral Spirit")
                -- Liquid Magma
                bb.ui:createCheckbox(section,"Liquid Magma")
                -- Ancestral Swiftness
                bb.ui:createCheckbox(section,"Ancestral Swiftness")
                -- Ascendance
                bb.ui:createCheckbox(section,"Ascendance")
            bb.ui:checkSectionState(section)
            -------------------------
            --- DEFENSIVE OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
                -- Healthstone
                bb.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Heirloom Neck
                bb.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Gift of The Naaru
                if bb.player.race == "Draenei" then
                    bb.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                end
                -- Ancestral Guidance
                bb.ui:createSpinner(section, "Ancestral Guidance",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                -- Ancestral Spirit
                bb.ui:createDropdown(section, "Ancestral Spirit", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
                -- Astral Shift
                bb.ui:createSpinner(section, "Astral Shift",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                -- Capacitor Totem
                bb.ui:createSpinner(section, "Capacitor Totem - Defensive",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                -- Earth Elemental Totem
                bb.ui:createSpinner(section, "Earth Elemental Totem",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                -- Healing Rain
                bb.ui:createSpinner(section, "Healing Rain",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                bb.ui:createSpinner(section, "Healing Rain Targets",  3,  1,  10,  1,  "|cffFFFFFFNumber of targets to consider before casting")
                -- Healing Stream Totem
                bb.ui:createSpinner(section, "Healing Stream Totem",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                -- Healing Surge
                bb.ui:createCheckbox(section,"Healing Surge")
                bb.ui:createSpinner(section, "Healing Surge - Level",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                bb.ui:createDropdown(section, "Healing Surge - Target", {"|cff00FF00Player Only","|cffFFFF00Lowest Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
                -- Shamanistic Rage
                bb.ui:createSpinner(section, "Shamanistic Rage",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                -- Cleanse Spirit
                bb.ui:createDropdown(section, "Clease Spirit", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
                -- Purge
                bb.ui:createCheckbox(section,"Purge")
            bb.ui:checkSectionState(section)
            -------------------------
            --- INTERRUPT OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
                -- Capacitor Totem
                bb.ui:createCheckbox(section,"Capacitor Totem - Interrupt")
                -- Grounding Totem
                bb.ui:createCheckbox(section,"Grounding Totem")
                -- Wind Shear
                bb.ui:createCheckbox(section,"Wind Shear")
                -- Interrupt Percentage
                bb.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
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
        if bb.timer:useTimer("debugEnhancement", 0.1) then
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
	        local buff              = bb.player.buff
	        local dyn5 				= bb.player.units.dyn5
	        local canFlask          = canUse(bb.player.flask.wod.agilityBig)
	        local cd                = bb.player.cd
	        local charges           = bb.player.charges
	        local combatTime        = getCombatTime()
	        local debuff            = bb.player.debuff
            local distance          = getDistance("target")
	        local enemies           = bb.player.enemies
	        local flaskBuff         = getBuffRemain("player",bb.player.flask.wod.buff.agilityBig) or 0
	        local frac 				= bb.player.frac
	        local glyph             = bb.player.glyph
	        local healthPot         = getHealthPot() or 0
	        local inCombat          = bb.player.inCombat
	        local inRaid            = select(2,IsInInstance())=="raid"
	        local level             = bb.player.level
	        local needsHealing 		= needsHealing or 0
	        local php               = bb.player.health
	        local power             = bb.player.power
	        local pullTimer 		= bb.DBM:getPulltimer()
	        local race              = bb.player.race
	        local racial 			= bb.player.getRacial()
	        local recharge          = bb.player.recharge
	        local regen             = bb.player.powerRegen
	        local solo              = select(2,IsInInstance())=="none"
	        local t17_2pc           = bb.player.eq.t17_2pc
	        local t18_2pc           = bb.player.eq.t18_2pc 
	        local t18_4pc           = bb.player.eq.t18_4pc
	        local talent            = bb.player.talent
	        local thp               = getHP(bb.player.units.dyn5)
	        local totem 			= bb.player.totem
	        local ttd               = getTimeToDie(bb.player.units.dyn5)
	        local ttm               = bb.player.timeToMax
	        if t18_4pc then t18_4pcBonus = 1 else t18_4pcBonus = 0 end

    --------------------
    --- Action Lists ---
    --------------------
	    -- Action list - Extras
	    	function actionList_Extra()
	    	-- Earthbind/grab Totem
	    		if isChecked("Earthbind/grab Totem") and not isBoss() then
	                for i=1, #getEnemies("player",10) do
	                    thisUnit = getEnemies("player",10)[i]
	                    if isMoving(thisUnit) and getFacing(thisUnit,"player") == false then
                            if talent.earthgrabTotem then
                                if bb.player.castEarthgrabTotem() then return end
                            else
	                    	    if bb.player.castEarthbindTotem() then return end
                            end
	                    end
	               	end
	            end
	        -- Ghost Wolf
	        	if isChecked("Ghost Wolf") then
	        		if ((bb.player.enemies.yards20==0 and not inCombat) or (bb.player.enemies.yards10==0 and inCombat)) and isMoving("player") then
						if bb.player.castGhostWolf() then return end
	    			end
	        	end
	        -- Purge
	        	if isChecked("Purge") and canDispel("target",bb.player.spell.purge) and not isBoss() and ObjectExists("target") then
	        		if bb.player.castPurge() then return end
	        	end
	        -- Spirit Walk
	        	if isChecked("Spirit Walk") and hasNoControl(bb.player.spell.spiritWalk) then
	        		if bb.player.castSpiritWalk() then return end
	        	end
	        -- Totemic Recall
	        	if not inCombat and totem.exist and not (totem.healingStreamTotem or totem.fireElementalTotem or totem.earthElementalTotem or totem.stormElementalTotem) and not UnitExists("target") then
	        		if bb.player.castTotemicRecall() then return end
	        	end
	        -- Tremor Totem
	        	if isChecked("Tremor Totem") and inCombat then
	        		for i=1,#nNova do
	        			local thisUnit=nNova[i].unit
	        			local thisUnitDist=getDistance(thisUnit)
	        			if thisUnitDist<30 and hasNoControl(bb.player.spell.tremorTotem,thisUnit) then
	        				if bb.player.castTremorTotem() then return end
	        			end
	        		end
	        	end
	        -- Water Walking
	        	if isChecked("Water Walking") and not inCombat and IsSwimming() then
	        		if bb.player.castWaterWalking() then return end
	        	end
	    	end -- End Action List - Extra
	    -- Action List - Defensive
	    	function actionList_Defensive()
	    		if useDefensive() and getHP("player")>0 then	 
			-- Ancestral Guidance
					if isChecked("Ancestral Guidance") then
						if not inCombat and needsHealing>0 then needsHealing=0 end
						for i=1,#nNova do
							local thisUnit = nNova[i].unit
							local thisUnitHP = getHP(thisUnit)
							if thisUnitHP < getOptionValue("Ancestral Guidance") then
								needsHealing = needsHealing+1
							end
						end
						if inCombat and (needsHealing >= 3 or needsHealing==#nNova) then
							if bb.player.castAncestralGuidance() then return end
						end
					end
			-- Ancestral Spirit
					if isChecked("Ancestral Spirit") then
						if getOptionValue("Ancestral Spirit")==1 then
							if bb.player.castAncestralSpirit("target") then return end
						end
						if getOptionValue("Ancestral Spirit")==2 then
							if bb.player.castAncestralSpirit("mouseover") then return end
						end
					end
	        -- Astral Shift
			        if isChecked("Astral Shift") and inCombat and not castingUnit("player") and php<=getOptionValue("Astral Shift") then
			          	if bb.player.castAstralShift() then return end
			        end
			-- Capacitor Totem
					if isChecked("Capacitor Totem - Defensive") and inCombat and php<=getOptionValue("Capacitor Totem - Defensive") and ttd>5 then
						if bb.player.castCapacitorTotem() then return end
					end
			-- Cleanse Spirit
	        		if isChecked("Cleanse Spirit") then
				        if getOptionValue("Cleanse Spirit")==1 and canDispel("player",bb.player.spell.cleanseSpirit) then
				          	if bb.player.castCleanseSpirit("player") then return; end
				        end
				        if getOptionValue("Cleanse Spirit")==2 and canDispel("target",bb.player.spell.cleanseSpirit) then
				        	if bb.player.castCleanseSpirit("target") then return end
				        end
				        if getOptionValue("Cleanse Spirit")==3 and canDispel("mouseover",bb.player.spell.cleanseSpirit) then
				          	if bb.player.castCleanseSpirit("mouseover") then return end
				        end
				    end
			-- Earth Elemental Totem
					if isChecked("Earth Elemental Totem") and inCombat and php <= getOptionValue("Earth Elemental Totem") then
						if bb.player.castEarthElementalTotem() then return end
					end
			-- Gift of the Naaru
			        if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and bb.player.race=="Draenei" then
			          	if castSpell("player",racial,false,false,false) then return end
			        end
			-- Healing Rain
					if isChecked("Healing Rain") and (not inCombat or getCastTime(bb.player.spell.healingRain)<1) then
						if bb.player.castHealingRain(getOptionValue("Healing Rain"),getOptionValue("Healing Rain Targets")) then return end
					end
			-- Healing Stream Totem
				    if isChecked("Healing Stream Totem") and php < getOptionValue("Healing Stream Totem") and not totem.healingStreamTotem then
				      	if bb.player.castHealingStreamTotem() then return end
				    end
			-- Healing Surge
					if isChecked("Healing Surge") and not isMoving("player") then
						if ((getOptionValue("Healing Surge - Target")==1 and charges.maelstromWeapon>3) or not inCombat) and php < getOptionValue("Healing Surge - Level") then
							if bb.player.castHealingSurge("player") then return end
						end
						if getOptionValue("Healing Surge - Target")==3 and charges.maelstromWeapon>3 and ObjectExists("mouseover") and getHP("mouseover") < getOptionValue("Healing Surge - Level") then
							if bb.player.castHealingSurge("mouseover") then return end
						end
						if getOptionValue("Healing Surge - Target")==2 and charges.maelstromWeapon>3 then
							for i=1,#nNova do
								local thisUnit = nNova[i].unit
								local thisUnitHP = getHP(thisUnit)
								local thisUnitDist = getDistance(thisUnit)
								if thisUnitDist<40 and thisUnitHP < getOptionValue("Healing Surge - Level") then
									if bb.player.castHealingSurge(thisUnit) then return end
								end
							end
						end
					end
			-- Heirloom Neck
		    		if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
		    			if hasEquiped(122668) then
		    				if canUse(122668) then
		    					useItem(122668)
		    				end
		    			end
		    		end
			-- lightning Shield
					if not buff.lightningShield then
						if bb.player.castLightningShield() then return end
					end
			-- Shamanistic Rage
			        if isChecked("Shamanistic Rage") and inCombat and php <= getOptionValue("Shamanistic Rage") then
			          	if bb.player.castShamanisticRage() then return end
			        end
	    		end -- End Defensive Check
	    	end -- End Action List - Defensive
	    -- Action List - Interrupts
	    	function actionList_Interrupts()
			    if useInterrupts() then
	        -- Wind Shear
	        		-- wind_shear
		            if isChecked("Wind Shear") then
		                for i=1, #getEnemies("player",25) do
		                    thisUnit = getEnemies("player",25)[i]
		                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
		                        if bb.player.castWindShear(thisUnit) then return end
		                    end
		                end
		            end
		    -- Grounding Totem
		    		-- Grounding Totem
		    		if isChecked("Gounding Totem") then
		    			for i=1, #getEnemies("player",25) do
		    				thisUnit = getEnemies("player",25)[i]
		                    if UnitCastingInfo(thisUnit) ~= nil and canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
		                        if bb.player.castGroundingTotem() then return end
		                    end
		                end
		            end
		    -- Capacitor Totem
					if isChecked("Capacitor Totem - Interrupt") and ttd>5 then
						for i=1, #getEnemies("player",8) do
		    				thisUnit = getEnemies("player",8)[i]
		                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
								if bb.player.castCapacitorTotem() then return end
							end
						end
					end
	    		end
	    	end -- End Action List - Interrupts
	    -- Action List - Cooldowns
	    	function actionList_Cooldowns()
	    		if getDistance(dyn5)<5 then
	    	-- Heroism/Bloodlust
		    		-- bloodlust,if=target.health.pct<25|time>0.500
		    		if useCDs() and isChecked("HeroLust") and not raid and (thp<25 or combatTime>0.500) then
		    			if bb.player.castHeroLust() then return end
		    		end
		    -- Legendary Ring
		    		-- use_item,name=maalus_the_blood_drinker
		    		if useCDs() and isChecked("Legendary Ring") then
						if hasEquiped(124636) and canUse(124636) then
							useItem(124636)
							return true
						end
					end
		    -- Potion
		    		-- potion,name=draenic_agility,if=(talent.storm_elemental_totem.enabled&(pet.storm_elemental_totem.remains>=25|(cooldown.storm_elemental_totem.remains>target.time_to_die&pet.fire_elemental_totem.remains>=25)))|(!talent.storm_elemental_totem.enabled&pet.fire_elemental_totem.remains>=25)|target.time_to_die<=30
		    		if useCDs() and canUse(109217) and inRaid and isChecked("Agi-Pot") then
		    			if (talent.stormElementalTotem and (totem.remain.stormElementalTotem>=25 or (cd.stormElementalTotem>ttd and totem.remain.fireElementalTotem>=25))) or (not talent.stormElementalTotem and totem.remain.fireElementalTotem>=25) or ttd<=30 then
		    				useItem(109217)
		    			end
		    		end
		    -- Racials
		    		-- blood_fury
		    		-- arcane_torrent
		    		-- berserking
		    		if useCDs() and (bb.player.race == "Orc" or bb.player.race == "Troll" or bb.player.race == "Blood Elf") then
		    			if bb.player.castRacial() then return end
		    		end
		    -- Elemental Mastery
		    		-- elemental_mastery
		    		if useCDs() and isChecked("Elemental Mastery") then
		    			if bb.player.castElementalMastery() then return end
		    		end
		    -- Storm Elemental Totem
		    		-- storm_elemental_totem
		    		if useCDs() and isChecked("Storm Elemental Totem") then
		    			if bb.player.castStormElementalTotem() then return end
		    		end
		    -- Fire Elemental Totem
		    		-- fire_elemental_totem
		    		if useCDs() and isChecked("Fire Elemental Totem") then
		    			if bb.player.castFireElementalTotem() then return end
		    			if bb.player.castEarthElementalTotem() then return end
		    		end
		    -- Feral Spirit
		    		-- feral_spirit
		    		if useCDs() and isChecked("Feral Spirit") then
		    			if bb.player.castFeralSpirit() then return end
		    		end
		    -- Liquid Magma
		    		-- liquid_magma,if=pet.searing_totem.remains>10|pet.magma_totem.remains>10|pet.fire_elemental_totem.remains>10
		    		if isChecked("Liquid Magma") and totem.remain.searingTotem>10 or totem.remain.magmaTotem>10 or totem.remain.fireElementalTotem>10 then
		    			if bb.player.castLiquidMagma() then return end
		    		end
		    -- Ancestral Swiftness
		    		-- ancestral_swiftness
		    		if useCDs() and isChecked("Ancestral Swiftness") then
		    			if bb.player.castAncestralSwiftness() then return end
		    		end
		    -- Ascendance
		    		-- ascendance
		    		if useCDs() and isChecked("Ascendance") then
		    			if bb.player.castAscendance() then return end
		    		end
		    -- Touch of the Void
		            if useCDs() and isChecked("Touch of the Void") and getDistance(bb.player.units.dyn5)<5 then
		                if hasEquiped(128318) then
		                    if GetItemCooldown(128318)==0 then
		                        useItem(128318)
		                    end
		                end
		            end
		    -- Trinkets
					if useCDs() and isChecked("Trinkets") then
						if canUse(13) then
							useItem(13)
						end
						if canUse(14) then
							useItem(14)
						end
					end		
		    	end
	    	end -- End Action List - Cooldowns
	    -- Action List - Pre-Combat
		    function actionList_PreCombat()
		   	-- Flask
		   		-- flask,type=greater_draenic_agility_flask
		   		if isChecked("Agi-Pot") then
	                if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",176151) then
	                    useItem(bb.player.flask.wod.agilityBig)
	                    return true
	                end
	                if flaskBuff==0 then
	                    if bb.player.useCrystal() then return end
	                end
	            end
	        -- Food
	        	-- food,type=buttered_sturgeon
	        -- Lightning Shield
	        	-- lightning_shield,if=!buff.lightning_shield.up
	        	if not buff.lightningShield then
	        		if bb.player.castLightningShield() then return end
			    end
			-- Snapshot Stats
				-- snapshot_stats
			-- Potion
				-- potion,name=draenic_agility
				if useCDs() and canUse(109217) and inRaid and isChecked("Agi-Pot") and isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
	            	useItem(109217)
	            end
	        -- Totems
	        	if enemies.yards10==1 then
	        		if bb.player.castSearingTotem() then return end
	        	end
	        	if enemies.yards10>1 then
	        		if bb.player.castMagmaTotem() then return end
	        	end
		    end  -- End Action List - Pre-Combat
		-- Action List - Single
			function actionList_Single()
			-- Searing Totem
				-- searing_totem,if=!totem.fire.active
				if (not totem.searingTotem and not totem.fireElementalTotem) or totem.magmaTotem then 
					if bb.player.castSearingTotem() then return end
				end
			-- Unleash Elements
				-- unleash_elements,if=talent.unleashed_fury.enabled
				if talent.unleashedFury then
					if bb.player.castUnleashElements() then return end
				end
			-- Elemental Blast
				-- elemental_blast,if=buff.maelstrom_weapon.react>=5+3*set_bonus.tier18_4pc
				if charges.maelstromWeapon>=5+3*t18_4pcBonus then
					if bb.player.castElementalBlast() then return end
				end
			-- Windstrike
				-- windstrike,if=!talent.echo_of_the_elements.enabled|(talent.echo_of_the_elements.enabled&(charges=2|(action.windstrike.charges_fractional>1.75)|(charges=1&buff.ascendance.remains<1.5)))
				if not talent.echoOfTheElements or (talent.echoOfTheElements and (charges.windstrike==2 or (frac.windstrike>1.75) or (charges.windstrike==1 and buff.remain.ascendance<1.5))) then
					if bb.player.castWindstrike(bb.player.units.dyn5) then return end
				end
			-- Lightning Bolt
				-- lightning_bolt,if=buff.maelstrom_weapon.react>=5+3*set_bonus.tier18_4pc
				if charges.maelstromWeapon>=5+3*t18_4pcBonus then
					if bb.player.castLightningBolt() then return end
				end
			-- Stormstrike
				-- stormstrike,if=!talent.echo_of_the_elements.enabled|(talent.echo_of_the_elements.enabled&(charges=2|(action.stormstrike.charges_fractional>1.75)|target.time_to_die<6))
				if not talent.echoOfTheElements or (talent.echoOfTheElements and (charges.stormstrike==2 or (frac.stormstrike>1.75) or ttd<6)) then
					if bb.player.castStormstrike(bb.player.units.dyn5) then return end
				end
			-- Lava Lash
				-- lava_lash,if=!talent.echo_of_the_elements.enabled|(talent.echo_of_the_elements.enabled&(charges=2|(action.lava_lash.charges_fractional>1.8)|target.time_to_die<8))
				if not talent.echoOfTheElements or (talent.echoOfTheElements and (charges.lavaLash==2 or (frac.lavaLash>1.8) or ttd<8)) then
					if bb.player.castLavaLash() then return end
				end
			-- Flame Shock
				-- flame_shock,if=(talent.elemental_fusion.enabled&buff.elemental_fusion.stack=2&buff.unleash_flame.up&dot.flame_shock.remains<16)|(!talent.elemental_fusion.enabled&buff.unleash_flame.up&dot.flame_shock.remains<=9)|!ticking
				if (talent.elementalFusion and charges.elementalFusion==2 and buff.unleashFlame and debuff.remain.flameShock<16) or (not talent.elementalFusion and buff.unleashFlame and debuff.remain.flameShock<=9) or not debuff.flameShock then
					if bb.player.castFlameShock() then return end
				end
			-- Unleash Elements
				-- unleash_elements
				if bb.player.castUnleashElements() then return end
			-- Windstrike
				-- windstrike,if=talent.echo_of_the_elements.enabled
				if talent.echoOfTheElements then
					if bb.player.castWindstrike(bb.player.units.dyn5) then return end
				end
			-- Elemental Blast
				-- elemental_blast,if=(!set_bonus.tier18_4pc&buff.maelstrom_weapon.react>=3)|buff.ancestral_swiftness.up
				if (not t18_4pc and charges.maelstromWeapon>=3) or buff.ancestralSwiftness then
					if bb.player.castElementalBlast() then return end
				end
			-- Lightning Bolt
				-- lightning_bolt,if=(!set_bonus.tier18_4pc&(buff.maelstrom_weapon.react>=3&!buff.ascendance.up))|buff.ancestral_swiftness.up
				if (not t18_4pc and (charges.maelstromWeapon>=3 and not buff.ascendance)) or buff.ancestralSwiftness then
					if bb.player.castLightningBolt() then return end
				end
			-- Lava Lash
				-- lava_lash,if=talent.echo_of_the_elements.enabled
				if talent.echoOfTheElements then
					if bb.player.castLavaLash() then return end
				end
			-- Frost Shock
				-- frost_shock,if=(talent.elemental_fusion.enabled&dot.flame_shock.remains>=16)|!talent.elemental_fusion.enabled
				if (talent.elementalFusion and debuff.remain.flameShock>=16) or not talent.elementalFusion then
					if bb.player.castFrostShock() then return end
				end
			-- Elemental Blast
				-- elemental_blast,if=buff.maelstrom_weapon.react>=1+2*set_bonus.tier18_4pc
				if charges.maelstromWeapon>=1+2*t18_4pcBonus then
					if bb.player.castElementalBlast() then return end
				end
			-- Lightning Bolt
				-- lightning_bolt,if=talent.echo_of_the_elements.enabled&((!set_bonus.tier18_4pc&(buff.maelstrom_weapon.react>=2&!buff.ascendance.up))|buff.ancestral_swiftness.up)
				if talent.echoOfTheElements and ((not t18_4pc and (charges.maelstromWeapon>=2 and not buff.ascendance)) or buff.ancestralSwiftness) then
					if bb.player.castLightningBolt() then return end
				end
			-- Stormstrike
				-- stormstrike,if=talent.echo_of_the_elements.enabled
				if talent.echoOfTheElements then
					if bb.player.castStormstrike(bb.player.units.dyn5) then return end
				end
			-- Lightning Bolt
				-- lightning_bolt,if=(!set_bonus.tier18_4pc&(buff.maelstrom_weapon.react>=1&!buff.ascendance.up))|(set_bonus.tier18_4pc&((talent.unleashed_fury.enabled&buff.unleashed_fury.up)|!talent.unleashed_fury.enabled)&(buff.maelstrom_weapon.react>=5|(buff.maelstrom_weapon.react>=3&!buff.ascendance.up)))|buff.ancestral_swiftness.up
				if (not t18_4pc and (charges.maelstromWeapon>=1 and not buff.ascendance)) or (t18_4pc and ((talent.unleashedFury and buff.unleashedFury) or not talent.unleashedFury) and (charges.maelstromWeapon>=5 or (charges.maelstromWeapon>=3 and not buff.ascendance))) or buff.ancestralSwiftness then
					if bb.player.castLightningBolt() then return end
				end
			-- Searing Totem
				-- searing_totem,if=pet.searing_totem.remains<=20&!pet.fire_elemental_totem.active&!buff.liquid_magma.up
				if totem.remain.searingTotem<=20 and not totem.fireElementalTotem and not buff.liquidMagma then
					if bb.player.castSearingTotem() then return end
				end
			-- Lightning Bolt
				if not isMoving("player") and getDistance(bb.player.units.dyn5)>=5 then
					if bb.player.castLightningBolt() then return end
				end  
			end -- End Action List - Single
		-- Action List - MultiTarget
			function actionList_MultiTarget()
			-- Touch of the Void
	            if isChecked("Touch of the Void") and getDistance(bb.player.units.dyn5)<5 then
	                if hasEquiped(128318) then
	                    if GetItemCooldown(128318)==0 then
	                        useItem(128318)
	                    end
	                end
	            end	
			-- Unleash Elements
				-- unleash_elements,if=spell_targets.fire_nova_explosion>=4&dot.flame_shock.ticking&(cooldown.shock.remains>cooldown.fire_nova.remains|cooldown.fire_nova.remains=0)
				if enemies.yards10>=4 and debuff.flameShock and (cd.flameShock>cd.fireNova or cd.fireNova==0) then
					if bb.player.castUnleashElements() then return end
				end
			-- Fire Nova
				-- fire_nova,if=active_dot.flame_shock>=3&spell_targets.fire_nova_explosion>=3
				if debuff.count.flameShock>=3 and enemies.yards10>=3 then
					if bb.player.castFireNova() then return end
				end
				-- wait,sec=cooldown.fire_nova.remains,if=!talent.echo_of_the_elements.enabled&active_dot.flame_shock>=4&cooldown.fire_nova.remains<=action.fire_nova.gcd%2
				if not talent.echoOfTheElements and debuff.count.flameShock>=4 and cd.fireNova<=bb.player.gcd/2 then
					pause()
				end
			-- Magma Totem
				-- magma_totem,if=!totem.fire.active
				if (not totem.magmaTotem and not totem.fireElementalTotem) or totem.searingTotem then
					if bb.player.castMagmaTotem() then return end
				end
			-- Lava Lash
				-- lava_lash,if=dot.flame_shock.ticking&active_dot.flame_shock<spell_targets.fire_nova_explosion
				-- if debuff.flameShock and debuff.count.flameShock<enemies.yards10 then
				for i=1, #enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local fsDebuff = UnitDebuffID(thisUnit,bb.player.spell.flameShock,"player")~=nil or false
					if fsDebuff and debuff.count.flameShock<enemies.yards10 then
						if bb.player.castLavaLash(thisUnit) then return end
					end
				end
				-- end
			-- Elemental Blast
				-- elemental_blast,if=!buff.unleash_flame.up&(buff.maelstrom_weapon.react>=4|buff.ancestral_swiftness.up)
				if not buff.unleashFlame and (charges.maelstromWeapon>=4 or buff.ancestralSwiftness) then
					if bb.player.castElementalBlast() then return end
				end
			-- Chain Lightning
				-- chain_lightning,if=buff.maelstrom_weapon.react=5&((glyph.chain_lightning.enabled&spell_targets.chain_lightning>=3)|(!glyph.chain_lightning.enabled&spell_targets.chain_lightning>=2))
				if charges.maelstromWeapon==5 and ((glyph.chainLightning and #getEnemies(bb.player.units.dyn10AoE,10)>=3) or (not glyph.chainLightning and #getEnemies(bb.player.units.dyn10AoE,10)>=2)) then
					if bb.player.castChainLightning() then return end
				end
			-- Unleash Elements
				-- unleash_elements,if=spell_targets.fire_nova_explosion<4
				if enemies.yards10 < 4 then
					if bb.player.castUnleashElements() then return end
				end
			-- Flame Shock
				-- flame_shock,if=dot.flame_shock.remains<=9|!ticking
				if debuff.remain.flameShock<=9 or not debuff.flameShock then
					if bb.player.castFlameShock() then return end
				end
			-- Windstrike
				-- windstrike,target=1,if=!debuff.stormstrike.up
				-- windstrike,target=2,if=!debuff.stormstrike.up
				-- windstrike,target=2,if=!debuff.stormstrike.up
				if debuff.count.windstrike<3 then
					for i=1, #getEnemies("player",5) do
						thisUnit = getEnemies("player",5)[i]
						if getDebuffRemain(thisUnit,bb.player.spell.windstrike,"player")==0 then
							if bb.player.castWindstrike(thisUnit) then return end
						end
					end
				end
			-- Windstrike
				-- windstrike
				if bb.player.castWindstrike() then return end
			-- Elemental Blast
				-- elemental_blast,if=!buff.unleash_flame.up&buff.maelstrom_weapon.react>=3
				if not buff.unleashFlame and charges.maelstromWeapon>=3 then
					if bb.player.castElementalBlast() then return end
				end
			-- Chain Lightning
				-- chain_lightning,if=(buff.maelstrom_weapon.react>=3|buff.ancestral_swiftness.up)&((glyph.chain_lightning.enabled&spell_targets.chain_lightning>=4)|(!glyph.chain_lightning.enabled&spell_targets.chain_lightning>=3))
				if (charges.maelstromWeapon>=3 or buff.ancestralSwiftness) and ((glyph.chainLightning and #getEnemies(bb.player.units.dyn10AoE,10)>=4) or (not glyph.chainLightning and #getEnemies(bb.player.units.dyn10AoE,10)>=3)) then
					if bb.player.castChainLightning() then return end
				end
			-- Magma Totem
				-- magma_totem,if=pet.magma_totem.remains<=20&!pet.fire_elemental_totem.active&!buff.liquid_magma.up
				if totem.remain.magmaTotem<=20 and not totem.fireElementalTotem and not buff.liquidMagma then
					if bb.player.castMagmaTotem() then return end
				end
			-- Lightning Bolt
				-- lightning_bolt,if=buff.maelstrom_weapon.react=5&glyph.chain_lightning.enabled&spell_targets.chain_lightning<3
				if charges.maelstromWeapon==5 and glyph.chainLightning and #getEnemies(bb.player.units.dyn10AoE,10)<3 then
					if bb.player.castLightningBolt() then return end
				end
			-- Stormstrike
				-- stormstrike,target=1,if=!debuff.stormstrike.up
				-- stormstrike,target=2,if=!debuff.stormstrike.up
				-- stormstrike,target=3,if=!debuff.stormstrike.up
				if debuff.count.stormstrike<3 then
					for i=1, #getEnemies("player",5) do
						thisUnit = getEnemies("player",5)[i]
						if getDebuffRemain(thisUnit,bb.player.spell.stormstrike,"player")==0 then
							if bb.player.castStormstrike(thisUnit) then return end
						end
					end
				end
			-- Stormstrike
				-- stormstrike
				if bb.player.castStormstrike() then return end
			-- Lava Lash
				-- lava_lash
				if bb.player.castLavaLash() then return end
			-- Fire Nova
				-- fire_nova,if=active_dot.flame_shock>=2&spell_targets.fire_nova_explosion>=2
				if debuff.count.flameShock>=2 and enemies.yards10>=2 then
					if bb.player.castFireNova() then return end
				end
			-- Elemental Blast
				-- elemental_blast,if=!buff.unleash_flame.up&buff.maelstrom_weapon.react>=1
				if not buff.unleashFlame and charges.maelstromWeapon>=1 then
					if bb.player.castElementalBlast() then return end
				end
			-- Chain Lightning
				-- chain_lightning,if=(buff.maelstrom_weapon.react>=1|buff.ancestral_swiftness.up)&((glyph.chain_lightning.enabled&spell_targets.chain_lightning>=3)|(!glyph.chain_lightning.enabled&spell_targets.chain_lightning>=2))
				if (charges.maelstromWeapon>=1 or buff.ancestralSwiftness) and ((glyph.chainLightning and #getEnemies(bb.player.units.dyn10AoE,10)>=3) or (not glyph.chainLightning and #getEnemies(bb.player.units.dyn10AoE,10)>=2)) then
					if bb.player.castChainLightning() then return end
				end
			-- Lightning Bolt
				-- lightning_bolt,if=(buff.maelstrom_weapon.react>=1|buff.ancestral_swiftness.up)&glyph.chain_lightning.enabled&spell_targets.chain_lightning<3
				if (charges.maelstromWeapon>=1 or buff.ancestralSwiftness) and glyph.chainLightning and #getEnemies(bb.player.units.dyn10AoE,10)<3 then
					if bb.player.castLightningBolt() then return end
				end
			-- Fire Nova
				-- fire_nova,if=active_dot.flame_shock>=1&spell_targets.fire_nova_explosion>=1
				if debuff.count.flameShock>=1 and enemies.yards10>=1 then
					if bb.player.castFireNova() then return end
				end
			-- Chain Lightning 
				if not isMoving("player") and getDistance(bb.player.units.dyn5)>=5 then
					if bb.player.castChainLightning() then return end
				end 
			end -- End Action List - MultiTarget
	-----------------
	--- Rotations ---
	-----------------
			if actionList_Extra() then return end
			if actionList_Defensive() then return end
	---------------------------------
	--- Out Of Combat - Rotations ---
	---------------------------------
			if not inCombat and ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
				if actionList_PreCombat() then return end
				if getDistance("target")<5 then
					StartAttack()
				end
			end
	-----------------------------
	--- In Combat - Rotations --- 
	-----------------------------
			if inCombat then
				if actionList_Interrupts() then return end
				if actionList_Cooldowns() then return end
		-- Run Action List - MultiTarget
				-- call_action_list,name=aoe,if=spell_targets.chain_lightning>1
				if (enemies.yards10>1 and useAuto()) or useAoE() then
					if actionList_MultiTarget() then return end
				end
		-- Run Action List - Single Target
				-- call_action_list,name=single
				if (enemies.yards10==1 and useAuto()) or useSingle() then
					if actionList_Single() then return end
				end
        -- StartAttack
                if distance<5 then
                    StartAttack()
                end
			end -- End Combat Rotation
	    end -- End Timer
	end -- Run Rotation
	tinsert(cEnhancement.rotations, {
	    name = rotationName,
	    toggles = createToggles,
	    options = createOptions,
	    run = runRotation,
	})
end -- End Select Shaman
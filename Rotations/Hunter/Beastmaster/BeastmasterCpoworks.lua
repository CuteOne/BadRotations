if select(2, UnitClass("player")) == "HUNTER" then
	local rotationName = "Cpoworks"

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
            -- Death Cat
                br.ui:createCheckbox(section,"Death Cat Mode","|cff15FF00Enable|cffFFFFFF/|cffD60000Disable |cffFFFFFFthis mode when running through low level content where you 1 hit kill mobs.")
            -- Fire Cat
                br.ui:createCheckbox(section,"Perma Fire Cat","|cff15FF00Enable|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic use of Fandrel's Seed Pouch or Burning Seeds.")
            -- Dummy DPS Test
                br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            br.ui:checkSectionState(section)
        -- Cooldown Options
            section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Agi Pot
                br.ui:createCheckbox(section,"Agi-Pot")
            -- Flask / Crystal
                br.ui:createCheckbox(section,"Flask / Crystal")
            -- Racial
                br.ui:createCheckbox(section,"Racial")
            -- Trinkets
                br.ui:createCheckbox(section,"Trinkets")
            br.ui:checkSectionState(section)
        -- Defensive Options
            section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
                br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
                br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Engineering: Shield-o-tronic
                br.ui:createSpinner(section, "Shield-o-tronic",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            br.ui:checkSectionState(section)
        -- Interrupt Options
            section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Interrupt Percentage
                br.ui:createSpinner(section, "Interrupts",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
            br.ui:checkSectionState(section)
        -- Toggle Key Options
            section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
                br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  6)
            -- Cooldown Key Toggle
                br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  6)
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
        if br.timer:useTimer("debugBeastmaster", math.random(0.15,0.3)) then
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
            local buff                                          = br.player.buff
            local canFlask                                      = canUse(br.player.flask.wod.agilityBig)
            local cast                                          = br.player.cast
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
            local solo                                          = #br.friend < 2
            local friendsInRange                                = friendsInRange
            local spell                                         = br.player.spell
            local talent                                        = br.player.talent
            local travel, flight, cat, noform                   = br.player.buff.travelForm.exists, br.player.buff.flightForm.exists, br.player.buff.catForm.exists, GetShapeshiftForm()==0
            local trinketProc                                   = false
            local ttd                                           = getTTD
            local ttm                                           = br.player.timeToMax
            local units                                         = br.player.units
            
	   		if leftCombat == nil then leftCombat = GetTime() end
			if profileStop == nil then profileStop = false end

	--------------------
	--- Action Lists ---
	--------------------
		-- Action List - Extras
			local function actionList_Extras()
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
	    		end -- End Defensive Toggle
			end -- End Action List - Defensive
		-- Action List - Interrupts
			local function actionList_Interrupts()
				if useInterrupts() then

			 	end -- End useInterrupts check
			end -- End Action List - Interrupts
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if useCDs() then
			-- Trinkets
					if useCDs() and isChecked("Trinkets") and getDistance(units.dyn5) < 5 then
                        if canUse(13) then
    						useItem(13)
    					end
    					if canUse(14) then
    						useItem(14)
    					end
					end
            -- Agi-Pot
                    if useCDs() and isChecked("Agi-Pot") and canUse(agiPot) and inRaid then
                        useItem(agiPot);
                        return true
                        
                    end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                    if useCDs() and isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                         if castSpell("player",racial,false,false,false) then return end
                    end   
                end -- End useCooldowns check
            end -- End Action List - Cooldowns 
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
                if inCombat and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 and not isCastingSpell(spell.voidTorrent) then
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
				end --End In Combat
			end --End Rotation Logic
        end -- End Timer
    end -- End runRotation
    tinsert(cBeastmaster.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end --End Class Check
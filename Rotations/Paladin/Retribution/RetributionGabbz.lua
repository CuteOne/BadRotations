if select(2,GetSpecializationInfo(GetSpecialization())) == specID then -- Change specID to ID of spec. IE: https://github.com/MrTheSoulz/NerdPack/wiki/Class-&-Spec-IDs
    local rotationName = "Gabbz" -- Appears in the dropdown of the rotation selector in the Profile Options window

---------------
--- Toggles ---
---------------
    local function createToggles()
    -- Sample Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = bb.player.spell.bladeFlurry },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.bladeFlurry },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.saberSlash },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.crimsonVial }
        };
        CreateButton("Rotation",1,0)
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
            	
            bb.ui:checkSectionState(section)
            ------------------------
            --- COOLDOWN OPTIONS ---
            ------------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "Cooldowns")
                
            bb.ui:checkSectionState(section)
            -------------------------
            --- DEFENSIVE OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
            	
            bb.ui:checkSectionState(section)
            -------------------------
            --- INTERRUPT OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
            	    
            bb.ui:checkSectionState(section)
            ----------------------
            --- TOGGLE OPTIONS ---
            ----------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "Toggle Keys")
            	   
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
        if bb.timer:useTimer("debugSpec", math.random(0.15,0.3)) then -- Change debugSpec tp name of Spec IE: debugFeral or debugWindwalker
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
			

	--------------------
	--- Action Lists ---
	--------------------
		-- Action List - Extras
			local function actionList_Extras()
				-- Abilities not part of the standard "optimal rotation" here IE: Fire cat on Feral			
			end -- End Action List - Extras
		-- Action List - Defensives
			local function actionList_Defensive()
				if useDefensive() then
					-- Defensive abilities listed here
	            end
			end -- End Action List - Defensive
		-- Action List - Interrupts
			local function actionList_Interrupts()
				if useInterrupts() then
					-- Interrupt abilities listed here
				end -- End Interrupt and No Stealth Check
			end -- End Action List - Interrupts
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if useCDs() then
					-- Cooldown abilities listed here
				end -- End Cooldown Usage Check
			end -- End Action List - Cooldowns
		-- Action List - PreCombat
			local function actionList_PreCombat()
				-- PreCombat abilities listed here
			end -- End Action List - PreCombat
		-- Action List - Opener
			local function actionList_Opener()
				if (not inCombat and UnitExists("target") and UnitCanAttack("target","player") and not UnitIsDeadOrGhost("target")) or (inCombat and hasThreat("target")) then
					-- Opening Attack rotation listed here
	            end
			end -- End Action List - Opener
		-- Action List - Multiple
			local function actionList_Multiple()
				-- AoE Rotation listed here
			end -- End Action List - Multiple
		-- Action List - Generators
			local function actionList_Single()
				-- Single Target Rotation listed here
			end -- End Action List - Single
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
					-- Non ActionList specific abilities here
			-- AoE
					if actionList_Multiple() then return end
			-- Single Target
					if actionList_Single() then return end
				end -- End In Combat
			end -- End Profile
	    end -- Timer
	end -- runRotation
	tinsert(cSpec.rotations, { --Change cSpec to name of spec IE: cFeral or cWindwalker
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end -- End Class Check
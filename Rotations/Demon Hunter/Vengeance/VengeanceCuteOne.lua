local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.soulCleave},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.soulCleave},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.shear},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.spectralSight}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.metamorphosis},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.metamorphosis},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.metamorphosis}
    };
   	CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.demonSpikes},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.demonSpikes}
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.consumeMagic},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.consumeMagic}
    };
    CreateButton("Interrupt",4,0)
-- Mover
    MoverModes = {
        [1] = { mode = "On", value = 2 , overlay = "Auto Movement Enabled", tip = "Will Cast Movement Abilities.", highlight = 1, icon = br.player.spell.infernalStrike},
        [2] = { mode = "Off", value = 1 , overlay = "Auto Movement Disabled", tip = "Will NOT Cast Movement Abilities", highlight = 0, icon = br.player.spell.infernalStrike}
    };
    CreateButton("Mover",5,0)
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
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Immolation Aura
            br.ui:createCheckbox(section,"Immolation Aura")
        -- Sigil of Flame
            br.ui:createCheckbox(section,"Sigil of Flame")
        -- Torment
            br.ui:createCheckbox(section,"Torment")
		-- Consume Magic
            br.ui:createCheckbox(section,"Consume Magic")
		-- Consume Magic
            br.ui:createCheckbox(section,"Fel Devastation")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Agi Pot
            br.ui:createCheckbox(section,"Agi-Pot")
        -- Flask / Crystal
            br.ui:createCheckbox(section,"Flask / Crystal")
        -- Legendary Ring
            br.ui:createCheckbox(section,"Legendary Ring")
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
		-- Fiery Brand
            br.ui:createSpinner(section, "Fiery Brand",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Demon Spikes
            br.ui:createSpinner(section, "Demon Spikes",  90,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            br.ui:createSpinnerWithout(section, "Hold Demon Spikes", 1, 0, 2, 1, "|cffFFBB00Number of Demon Spikes the bot will hold for manual use.");
        -- Metamorphosis
            br.ui:createSpinner(section, "Metamorphosis",  40,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Sigil of Misery
            br.ui:createSpinner(section, "Sigil of Misery - HP",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            br.ui:createSpinner(section, "Sigil of Misery - AoE", 3, 0, 10, 1, "|cffFFFFFFNumber of Units in 8 Yards to Cast At")
        -- Soul Barrier
            br.ui:createSpinner(section, "Soul Barrier",  70,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Consume Magic
            br.ui:createCheckbox(section, "Disrupt")
        -- Sigil of Silence
            br.ui:createCheckbox(section, "Sigil of Silence")
        -- Sigil of Misery
            br.ui:createCheckbox(section, "Sigil of Misery")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
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
        -- Mover Key Toggle
            br.ui:createDropdown(section, "Mover Mode", br.dropOptions.Toggle,  6)
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
    -- if br.timer:useTimer("debugVengeance", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Mover",0.25)
        br.player.mode.mover = br.data.settings[br.selectedSpec].toggles["Mover"]

--------------
--- Locals ---
--------------
        local buff                                          = br.player.buff
        local canFlask                                      = canUse(br.player.flask.wod.agilityBig)
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local hastar                                        = GetObjectExists("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local flying, moving                                = IsFlying(), GetUnitSpeed("player")>0
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inRaid                                        = br.player.instance=="raid"
        local mode                                          = br.player.mode
        local pain                                          = br.player.power.pain.amount()
        local php                                           = br.player.health
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local units                                         = br.player.units

        units.get(5)
        units.get(8,true)
        units.get(20)
        enemies.get(5)
        enemies.get(8)
        enemies.get(30)

	    if profileStop == nil then profileStop = false end

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
						Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
						profileStop = true
					end
				end
			end -- End Dummy Test
        -- Torment
            if isChecked("Torment") and cast.able.torment() then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if not isTanking(thisUnit) and hasThreat(thisUnit) then
                        if cast.torment(thisUnit) then return end
                    end
                end
            end
		end -- End Action List - Extras
	-- Action List - Defensive
		local function actionList_Defensive()
			if useDefensive() then
        -- Soul Barrier
                if isChecked("Soul Barrier") and cast.able.soulBarrier() and php < getOptionValue("Soul Barrier") then
                    if cast.soulBarrier() then return end
                end
        -- Demon Spikes
                -- demon_spikes
                if isChecked("Demon Spikes") and inCombat and cast.able.demonSpikes() and charges.demonSpikes.count() > getOptionValue("Hold Demon Spikes") and php <= getOptionValue("Demon Spikes") then
                    if (charges.demonSpikes.count() == 2 or not buff.demonSpikes.exists()) and not debuff.fieryBrand.exists(units.dyn5) and not buff.metamorphosis.exists() then
                        if cast.demonSpikes() then return end
                    end
                end
        -- Metamorphosis
				-- metamorphosis
				if isChecked("Metamorphosis") and cast.able.metamorphosis() and not buff.demonSpikes.exists()
                    and not debuff.fieryBrand.exists(units.dyn5) and not buff.metamorphosis.exists() and php <= getOptionValue("Metamorphosis")
                then
					if cast.metamorphosis() then return end
				end
        -- Fiery Brand
                -- fiery_brand
                if isChecked("Fiery Brand") and php <= getOptionValue("Fiery Brand") then
                    if not buff.demonSpikes.exists() and not buff.metamorphosis.exists() then
                        if cast.fieryBrand() then return end
                    end
                end
		-- Pot/Stoned
	            if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned")
	            	and inCombat and (hasHealthPot() or hasItem(5512))
	            then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(129196) then --Legion Healthstone
                        useItem(129196)
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
        -- Sigil of Misery
                if isChecked("Sigil of Misery - HP") and cast.able.sigilOfMisery()
                    and php <= getOptionValue("Sigil of Misery - HP") and inCombat and #enemies.yards8 > 0
                then
                    if cast.sigilOfMisery("player","ground") then return end
                end
                if isChecked("Sigil of Misery - AoE") and cast.able.sigilOfMisery()
                    and #enemies.yards8 >= getOptionValue("Sigil of Misery - AoE") and inCombat
                then
                    if cast.sigilOfMisery("best",false,getOptionValue("Sigil of Misery - AoE"),8) then return end
                end
    		end -- End Defensive Toggle
		end -- End Action List - Defensive
	-- Action List - Interrupts
		local function actionList_Interrupts()
			if useInterrupts() then
                for i=1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                     -- Disrupt
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                        if isChecked("Disrupt") and cast.able.disrupt(thisUnit) and getDistance(thisUnit) < 20 then
                            if cast.disrupt(thisUnit) then return end
                        end
                        -- Sigil of Silence
                        if isChecked("Sigil of Silence") and cast.able.sigilOfSilence(thisUnit) and cd.disrupt.remain() > 0 then
                            if cast.sigilOfSilence(thisUnit,"ground",1,8) then return end
                        end
                        -- Sigil of Misery
                        if isChecked("Sigil of Misery") and cast.able.sigilOfMisery(thisUnit)
                            and cd.disrupt.remain() > 0 and cd.sigilOfSilence.remain() > 0 and cd.sigilOfSilence.remain() < 45
                        then
                            if cast.sigilOfMisery(thisUnit,"ground",1,8) then return end
                        end
                    end
                end
		 	end -- End useInterrupts check
		end -- End Action List - Interrupts
	-- Action List - Cooldowns
		local function actionList_Cooldowns()
			if useCDs() and getDistance(units.dyn5) < 5 then
            -- Trinkets
                if isChecked("Trinkets") and getDistance("target") < 5 then
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) and getNumEnemies("player",12) >= 1 then
                        useItem(14)
                    end
                end
            end -- End useCDs check
        end -- End Action List - Cooldowns
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat then
            -- Flask / Crystal
                -- flask,type=flask_of_the_seventh_demon
                if isChecked("Flask / Crystal") then
                    if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",188033) then
                        useItem(br.player.flask.wod.agilityBig)
                        return true
                    end
                    if flaskBuff==0 then
                        if not UnitBuffID("player",188033) and canUse(118922) then --Draenor Insanity Crystal
                            useItem(118922)
                            return true
                        end
                        if not UnitBuffID("player",193456) and not UnitBuffID("player",188033) and canUse(129192) then -- Gaze of the Legion
                            useItem(129192)
                            return true
                        end
                    end
                end
                if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

                end -- End Pre-Pull
                if GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") and getDistance("target") < 5 then
            -- Start Attack
                    StartAttack()
                end
            end -- End No Combat
        end -- End Action List - PreCombat
    -- Action List - FieryBrand
        local function actionList_FieryBrand()
            -- actions.brand=sigil_of_flame,if=cooldown.fiery_brand.remains<2
            if isChecked("Sigil of Flame") and cast.able.sigilOfFlame() and not isMoving(units.dyn5)
                and getDistance(units.dyn5) < 5 and #enemies.yards5 > 0 and cd.fieryBrand.remain() < 2
            then
                if cast.sigilOfFlame("best",false,1,8) then return end
			end
			-- actions.brand+=/infernal_strike,if=cooldown.fiery_brand.remains=0
			if cast.able.infernalStrike() and charges.infernalStrike.count() == 2 and not cd.fieryBrand.exists() and #enemies.yards5 > 0 then
                if cast.infernalStrike("player","ground",1,6) then return end
            end
			-- actions.brand+=/fiery_brand (ignore if checked for defensive use)
            if cast.able.fieryBrand() then
	             if cast.fieryBrand() then return end
            end
			if debuff.fieryBrand.exists(units.dyn5) then
				-- actions.brand+=/immolation_aura,if=dot.fiery_brand.ticking
				if isChecked("Immolation Aura") and cast.able.immolationAura() and #enemies.yards5 > 0 then
                    if cast.immolationAura() then return end
                end
				-- actions.brand+=/fel_devastation,if=dot.fiery_brand.ticking
				if cast.able.felDevastation() and getDistance(units.dyn20) < 20 then
					if cast.felDevastation() then return end
				end
				-- actions.brand+=/infernal_strike,if=dot.fiery_brand.ticking
				if cast.able.infernalStrike() and charges.infernalStrike.count() == 2 and #enemies.yards5 > 0 then
					if cast.infernalStrike("player","ground",1,6) then return end
				end
				-- actions.brand+=/sigil_of_flame,if=dot.fiery_brand.ticking
				if isChecked("Sigil of Flame") and cast.able.sigilOfFlame() and not isMoving(units.dyn5) and getDistance(units.dyn5) < 5 and #enemies.yards5 > 0 then
					if cast.sigilOfFlame("best",false,1,8) then return end
				end
            end
        end -- End Action List - PreCombat
---------------------
--- Begin Profile ---
---------------------
-- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or IsMounted() or IsFlying() or pause() or mode.rotation==4 then
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
            if inCombat and profileStop==false and isValidUnit("target") then
                ChatOverlay("In-Combat!")
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
    -- Start Attack
                -- auto_attack
                if getDistance(units.dyn5) < 5 then
                    StartAttack()
                end
				-- Consume Magic
				if isChecked("Consume Magic") and cast.able.consumeMagic("target") and canDispel("target",spell.consumeMagic) and not isBoss() and GetObjectExists("target") then
					if cast.consumeMagic("target") then return end
				end
				-- actions+=/call_action_list,name=brand,if=talent.charred_flesh.enabled
                if talent.charredFlesh then
	                if actionList_FieryBrand() then return end
                end
				-- actions.normal=infernal_strike
				if cast.able.infernalStrike() and charges.infernalStrike.count() == 2 and #enemies.yards5 > 0 then
                    if cast.infernalStrike("player","ground",1,6) then return end
                end
				-- actions.normal+=/spirit_bomb,if=soul_fragments>=4
				if cast.able.spiritBomb() and buff.soulFragments.stack() >= 4 then
                    if cast.spiritBomb() then return end
                end
                -- actions.normal+=/soul_cleave,if=!talent.spirit_bomb.enabled
                if cast.able.soulCleave() and not talent.spiritBomb then
                    if cast.soulCleave() then return end
                end
                -- actions.normal+=/soul_cleave,if=talent.spirit_bomb.enabled&soul_fragments=0
                if cast.able.soulCleave() and talent.spiritBomb and buff.soulFragments.stack() == 0 then
                    if cast.soulCleave() then return end
                end
				-- actions.normal+=/immolation_aura,if=pain<=90
				if isChecked("Immolation Aura") and cast.able.immolationAura("player") and pain <= 90 and #enemies.yards5 > 0 then
                    if cast.immolationAura("player") then return end
                end
				-- actions.normal+=/felblade,if=pain<=70
				if cast.able.felblade() and pain <= 70 then
                    if cast.felblade() then return end
                end
				-- actions.normal+=/fracture,if=soul_fragments<=3
				if cast.able.fracture() and buff.soulFragments.stack() <= 3 and talent.fracture then
                    if cast.fracture() then return end
                end
				-- fel_devastation
                if cast.able.felDevastation() and getDistance(units.dyn20) < 20 then
					if cast.felDevastation() then return end
				end
				-- actions.normal+=/sigil_of_flame
				if isChecked("Sigil of Flame") and cast.able.sigilOfFlame() and not isMoving(units.dyn5) and #enemies.yards5 > 0 then
                    if cast.sigilOfFlame("best",false,1,8) then return end
				end
				-- actions.normal+=/shear
                if cast.able.shear() and not talent.fracture then
	                if cast.shear() then return end
                end
				-- actions.normal+=/throw_glaive
                if cast.able.throwGlaive() then
                    if cast.throwGlaive() then return end
                end
			end --End In Combat
		end --End Rotation Logic
    -- end -- End Timer
end -- End runRotation
local id = 581
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

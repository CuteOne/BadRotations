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
        -- Fiery Brand
            br.ui:createCheckbox(section,"Fiery Brand")
        -- Immolation Aura
            br.ui:createCheckbox(section,"Immolation Aura")
        -- Sigil of Flames
            br.ui:createCheckbox(section,"Sigil of Flames")
        -- Torment
            br.ui:createCheckbox(section,"Torment")
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
        -- Demon Spikes
            br.ui:createSpinner(section, "Demon Spikes",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            br.ui:createSpinnerWithout(section, "Hold Demon Spikes", 1, 0, 2, 1, "|cffFFBB00Number of Demon Spikes the bot will hold for manual use.");
        -- Empower Wards
            br.ui:createCheckbox(section, "Empower Wards")
        -- Fel Devastation
            br.ui:createSpinner(section, "Fel Devastation",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Metamorphosis
            br.ui:createSpinner(section, "Metamorphosis",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Sigil of Misery
            br.ui:createSpinner(section, "Sigil of Misery - HP",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            br.ui:createSpinner(section, "Sigil of Misery - AoE", 3, 0, 10, 1, "|cffFFFFFFNumber of Units in 8 Yards to Cast At")
        -- Soul Barrier
            br.ui:createSpinner(section, "Soul Barrier",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Soul Cleave
            br.ui:createSpinner(section, "Soul Cleave",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Consume Magic
            br.ui:createCheckbox(section, "Consume Magic")
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
    if br.timer:useTimer("debugVengeance", math.random(0.15,0.3)) then
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
        local addsExist                                     = false
        local addsIn                                        = 999
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local canFlask                                      = canUse(br.player.flask.wod.agilityBig)
        local cast                                          = br.player.cast
        local castable                                      = br.player.cast.debug
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = enemies or {}
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = GetObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local healthMax                                     = UnitHealthMax("player")
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local moveIn                                        = 999
        -- local multidot                                      = (useCleave() or br.player.mode.rotation ~= 3)
        local pain                                          = br.player.power.pain.amount()
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powmax, powgen, powerDeficit           = br.player.power.pain.amount(), br.player.power.pain.max(), br.player.power.pain.regen(), br.player.power.pain.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.pain.ttm()
        local units                                         = units or {}

        units.dyn5 = br.player.units(5)
        units.dyn8AoE = br.player.units(8,true)
        units.dyn20 = br.player.units(20)
        enemies.yards8 = br.player.enemies(8)
        enemies.yards30 = br.player.enemies(30)


   		if leftCombat == nil then leftCombat = GetTime() end
		if profileStop == nil then profileStop = false end
        if talent.chaosCleave then chaleave = 1 else chaleave = 0 end
        if talent.prepared then prepared = 1 else prepared = 0 end
        if lastSpell == spell.vengefulRetreat then vaulted = true else vaulted = false end

        ChatOverlay(addedEnemies)
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
            if isChecked("Torment") then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if not isAggroed(thisUnit) and hasThreat(thisUnit) then
                        if cast.torment(thisUnit) then return end
                    end
                end
            end
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
        -- Demon Spikes
                if isChecked("Demon Spikes") and php <= getOptionValue("Demon Spikes") and charges.demonSpikes.count() > getOptionValue("Hold Demon Spikes") and inCombat then
                    if cast.demonSpikes() then return end
                end
        -- Sigil of Misery
                if isChecked("Sigil of Misery - HP") and php <= getOptionValue("Sigil of Misery - HP") and inCombat and #enemies.yards8 > 0 then
                    if cast.sigilOfMisery("player","ground") then return end
                end
                if isChecked("Sigil of Misery - AoE") and #enemies.yards8 >= getOptionValue("Sigil of Misery - AoE") and inCombat then
                    if cast.sigilOfMisery("best",false,getOptionValue("Sigil of Misery - AoE"),8) then return end
                end
    		end -- End Defensive Toggle
		end -- End Action List - Defensive
	-- Action List - Interrupts
		local function actionList_Interrupts()
			if useInterrupts() then
                for i=1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        -- Consume Magic
                        if isChecked("Consume Magic") and getDistance(thisUnit) < 20 then
                            if cast.consumeMagic(thisUnit) then return end
                        end
        -- Sigil of Silence
                        if isChecked("Sigil of Silence") and cd.consumeMagic.remain() > 0 then
                            if cast.sigilOfSilence(thisUnit,"ground") then return end
                        end
        -- Sigil of Misery
                        if isChecked("Sigil of Misery") and cd.consumeMagic.remain() > 0 and cd.sigilOfSilence.remain() > 0 and cd.sigilOfSilence.remain() < 45 then
                            if cast.sigilOfMisery(thisUnit,"ground") then return end
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
            if not inCombat and not (IsFlying() or IsMounted()) then
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
            if inCombat and profileStop==false and isValidUnit(units.dyn5) and not (IsMounted() or IsFlying()) then
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
    -- Fiery Brand
                -- fiery_brand,if=buff.demon_spikes.down&buff.metamorphosis.down
                if isChecked("Fiery Brand") then
                    if not buff.demonSpikes.exists() and not buff.metamorphosis.exists() then
                        if cast.fieryBrand() then return end
                    end
                end
    -- Demon Spikes
                -- demon_spikes,if=charges=2|buff.demon_spikes.down&!dot.fiery_brand.ticking&buff.metamorphosis.down
                if isChecked("Demon Spikes") and charges.demonSpikes.count() > getOptionValue("Hold Demon Spikes") then
                    if (charges.demonSpikes.count() == 2 or not buff.demonSpikes.exists()) and not debuff.fieryBrand.exists(units.dyn5) and not buff.metamorphosis.exists() then
                        if cast.demonSpikes() then return end
                    end
                end
    -- Empower Wards
                -- empower_wards,if=debuff.casting.up
                if useDefensive() and isChecked("Empower Wards") then
                    for i=1, #enemies.yards30 do
                        thisUnit = enemies.yards30[i]
                        if cd.consumeMagic.remain() > 0 and castingUnit(thisUnit) then
                            if cast.empowerWards() then return end
                        end
                    end
                end
    -- Infernal Strike
                -- infernal_strike,if=!sigil_placed&!in_flight&remains-travel_time-delay<0.3*duration&artifact.fiery_demise.enabled().enabled&dot.fiery_brand.ticking
                -- infernal_strike,if=!sigil_placed&!in_flight&remains-travel_time-delay<0.3*duration&(!artifact.fiery_demise.enabled().enabled|(max_charges-charges_fractional)*recharge_time<cooldown.fiery_brand.remains+5)&(cooldown.sigil_of_flame.remains>7|charges=2)
                if mode.mover == 1 and getDistance(units.dyn5) < 5 and charges.infernalStrike.count() > 1 then
                    if (artifact.fieryDemise.enabled() and debuff.fieryBrand.exists(units.dyn5))
                        or (not artifact.fieryDemise.enabled() or (charges.infernalStrike.max() - charges.infernalStrike.frac()) * charges.infernalStrike.recharge() < cd.fieryBrand.remain() + 5)
                        and (cd.sigilOfFlame.remain() > 7 or charges.infernalStrike.count() == 2)
                    then
                        -- if cast.infernalStrike("best",false,1,6) then return end
                        if cast.infernalStrike("player","ground") then return end
                    end
                end
    -- Spirit Bomb
                -- spirit_bomb,if=debuff.frailty.down
                if not debuff.frailty.exists(units.dyn5) then
                    if cast.spiritBomb() then return end
                end
    -- Soul Carver 
                -- soul_carver,if=dot.fiery_brand.ticking
                if debuff.fieryBrand.exists(units.dyn5) then
                    if cast.soulCarver() then return end
                end
    -- Immolation Aura
                -- immolation_aura,if=pain<=80
                if isChecked("Immolation Aura") then
                    if pain <= 80 and getDistance(units.dyn8AoE) < 8 then
                        if cast.immolationAura() then return end
                    end
                end
    -- Felblade
                -- felblade,if=pain<=70
                if pain <= 70 then
                    if cast.felblade() then return end
                end
                if useDefensive() then
    -- Soul Barrier
                    -- soul_barrier
                    if isChecked("Soul Barrier") and php < getOptionValue("Soul Barrier") then
                        if cast.soulBarrier() then return end
                    end
    -- Soul Cleave
                    -- soul_cleave,if=soul_fragments=5
                    if isChecked("Soul Cleave") and buff.soulFragments.stack() == 5 then
                        if cast.soulCleave() then return end
                    end
    -- Metamorphosis
                    -- metamorphosis,if=buff.demon_spikes.down&!dot.fiery_brand.ticking&buff.metamorphosis.down&incoming_damage_5s>health.max*0.70
                    if isChecked("Metamorphosis") and not buff.demonSpikes.exists() and not debuff.fieryBrand.exists(units.dyn5)
                        and not buff.metamorphosis.exists() and getHPLossPercent("player",5) >= 70
                    then
                        if cast.metamorphosis() then return end
                    end
    -- Fel Devastation
                    -- fel_devastation,if=incoming_damage_5s>health.max*0.70
                    if isChecked("Fel Devastation") and getHPLossPercent("player",5) >= 70 and getDistance(units.dyn20) < 20 then
                        if cast.felDevastation() then return end
                    end
    -- Soul Cleave
                    -- soul_cleave,if=incoming_damage_5s>=health.max*0.70
                    if isChecked("Soul Cleave") and getHPLossPercent("player",5) >= 70 then
                        if cast.soulCleave() then return end
                    end
                end
    -- Fel Eruption
                -- fel_eruption
                if cast.felEruption() then return end
    -- Sigil of Flame
                -- sigil_of_flame,if=remains-delay<=0.3*duration
                if isChecked("Sigil of Flames") and not isMoving(units.dyn5) and getDistance(units.dyn5) < 5 and debuff.sigilOfFlame.refresh(units.dyn5) then
                    if cast.sigilOfFlame("best",false,1,8) then return end
                end
    -- Fracture
                -- fracture,if=pain>=80&soul_fragments<4&incoming_damage_4s<=health.max*0.20
                if pain >= 80 and buff.soulFragments.stack() < 4 and getHPLossPercent("player",4) <= healthMax * 0.20 then
                    if cast.fracture() then return end
                end
    -- Soul Cleave
                -- soul_cleave,if=pain>=80
                if useDefensive() and isChecked("Soul Cleave") and pain >= 80 then
                    if cast.soulCleave() then return end
                end
    -- Shear
                -- shear
                if pain < 60 or not useDefensive() or (useDefensive() and not isChecked("Soul Cleave")) then
                    if cast.shear() then return end
                end
    -- Throw Glaive
                if getDistance(units.dyn5) > 5 then
                    if cast.throwGlaive() then return end
                end
			end --End In Combat
		end --End Rotation Logic
    end -- End Timer
end -- End runRotation
local id = 581
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

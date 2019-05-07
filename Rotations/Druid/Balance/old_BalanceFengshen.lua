﻿local rotationName = "Fengshen"

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.solarWrath },
        [2] = { mode = "Sing", value = 2 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 1, icon = br.player.spell.starsurge }
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.celestialAlignment },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.celestialAlignment },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.celestialAlignment }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.barkskin },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.barkskin }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.solarBeam },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.solarBeam }
    };
    CreateButton("Interrupt",4,0)
-- Starsurge AstralPower Button
    StarsurgeAstralPowerModes = {
        [1] = { mode = "40", value = 1 , overlay = "Astral Power to 40 Cast Starsurge", tip = "Astral Power to 40 Cast Starsurge", highlight = 1, icon = br.player.spell.starsurge },
        [2] = { mode = "90", value = 2 , overlay = "Astral Power to 90 Cast Starsurge", tip = "Astral Power to 90 Cast Starsurge", highlight = 1, icon = br.player.spell.starfall }
    };
    CreateButton("StarsurgeAstralPower",5,0)
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
		-- Farm Mode
		br.ui:createCheckbox(section, "Farm Mode")
		-- Pre-Pull Timer
		br.ui:createSpinner(section, "Pre-Pull Timer",  2.5,  0,  10,  0.5,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
		-- Travel Shapeshifts
		br.ui:createCheckbox(section,"Auto Shapeshifts","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to

		 form for situation|cffFFBB00.")
		-- Auto Soothe
		br.ui:createCheckbox(section, "Auto Soothe")
		-- Revive
		br.ui:createCheckbox(section, "Revive")
		-- Starfall priority
		br.ui:createSpinner(section, "Starfall priority",  5,  0,  10,  1,  "","|cffFFFFFFMinimum Starfall priority Targets")
		-- Starfall
		br.ui:createSpinner(section, "Starfall",  3,  0,  10,  1,  "","|cffFFFFFFMinimum Starfall Targets")
		-- Innervate
		br.ui:createDropdown(section, "Innervate",br.dropOptions.Toggle,1, "","Set hotkey to use Innervate on Mouseover")
	br.ui:checkSectionState(section)
	-- Defensive Options
	section = br.ui:createSection(br.ui.window.profile, "Defensive")
		br.ui:createSpinner(section, "Potion/Healthstone",  20,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "Renewal",  25,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "Barkskin",  60,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "inCombat Regrowth",  30,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "OOC Regrowth",  80,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createDropdown(section, "Rebirth", {"|cff00FF00Target","|cffFF0000Mouseover","|cffFFBB00Any"}, 1, "|cffFFFFFFTarget to cast on")
		br.ui:createDropdown(section, "Remove Corruption", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFFFFFFPlayer and Target","|cffFF0000Mouseover Target","|cffFFFFFFAny"}, 3, "","|ccfFFFFFFTarget to Cast On")
	br.ui:checkSectionState(section)
	-- Interrupts Options
	section = br.ui:createSection(br.ui.window.profile, "Interrupts")
		br.ui:createCheckbox(section, "Solar Beam")
		br.ui:createCheckbox(section, "Mighty Bash")
		br.ui:createSpinner(section,  "InterruptAt",  50,  0,  100,  5,  "","|cffFFBB00Cast Percentage to use at.")
	br.ui:checkSectionState(section)
    -- Cooldown Options
    section = br.ui:createSection(br.ui.window.profile, "Cooldown")
		br.ui:createDropdown(section,"Trinkets 1", {"|cffFFFFFFNormal","|cffFFFFFFGround"}, 1, "","|cffFFFFFFSelect Trinkets mode.")
		br.ui:createDropdown(section,"Trinkets 2", {"|cffFFFFFFNormal","|cffFFFFFFGround"}, 1, "","|cffFFFFFFSelect Trinkets mode.")
		br.ui:createCheckbox(section,"Racial")
		br.ui:createCheckbox(section,"Warrior of Elune")
		br.ui:createCheckbox(section,"Incarnation")
		br.ui:createCheckbox(section,"Celestial Alignment")
		br.ui:createCheckbox(section,"Fury of Elune")
		br.ui:createCheckbox(section,"Force of Nature")
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
    -- if br.timer:useTimer("debugBalance", 0.1) then
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
		UpdateToggle("Rotation",0.25)
		UpdateToggle("Cooldown",0.25)
		UpdateToggle("Defensive",0.25)
		UpdateToggle("Interrupt",0.25)
		UpdateToggle("StarsurgeAstralPower",0.25)
		br.player.mode.rotation = br.data.settings[br.selectedSpec].toggles["Rotation"]
		br.player.mode.starsurgeAstralPower = br.data.settings[br.selectedSpec].toggles["StarsurgeAstralPower"]
--------------
--- Locals ---
--------------
		local buff                                          = br.player.buff
		local cast                                          = br.player.cast
		local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
		local resable                                       = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player") and UnitInRange("target")
		local debuff                                        = br.player.debuff
		local enemies                                       = br.player.enemies
		local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), isMoving("player") ~= false or br.player.moving
		local gcd                                           = br.player.gcd
		local inCombat                                      = isInCombat("player")
		local inInstance                                    = br.player.instance=="party"
		local inRaid                                        = br.player.instance=="raid"
		local level                                         = br.player.level
		local lowestHP                                      = br.friend[1].unit
		local mode                                          = br.player.mode
		local php                                           = br.player.health
		local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount, br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
		local pullTimer                                     = br.DBM:getPulltimer()
		local racial                                        = br.player.getRacial()
		local spell                                         = br.player.spell
		local talent                                        = br.player.talent
		local ttd                                           = getTTD
		local units                                         = br.player.units
		local trait                                         = br.player.traits
		local race                                          = br.player.race
		-- Balance Locals
		local astralPower                                   = br.player.power.astralPower.amount()
		local astralPowerDeficit                            = br.player.power.astralPower.deficit()
		local travel                                        = br.player.buff.travelForm.exists()
		local flight                                        = br.player.buff.flightForm.exists()
		local chicken                                       = br.player.buff.moonkinForm.exists()
		local cat                                           = br.player.buff.catForm.exists()
		local bear                                          = br.player.buff.bearForm.exists()
		local noform                                        = GetShapeshiftForm()==0
		local hasteAmount                                   = 1/(1+(GetHaste()/100))
		local latency                                       = getLatency()
		local starfallPlacement                             = "playerGround"
		local starfallAstralPower                           = 50
		local starfallRadius                                = 12

		units.get(40)
		enemies.get(8,"target")
		enemies.get(12,"target")
		enemies.get(15,"target")
		enemies.get(45, "player", true)
		enemies.get(45)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

	local function FutureAstralPower()
		if isCastingSpell() then
			return astralPower
		else
			if isCastingSpell(spell.newMoon) then
			return astralPower + 10
			elseif isCastingSpell(spell.halfMoon) then
			return astralPower + 20
			elseif isCastingSpell(spell.fullMoon) then
			return astralPower + 40
			elseif isCastingSpell(spell.stellarFlare) then
			return astralPower + 8
			elseif isCastingSpell(spell.solarWrath) then
			return astralPower + 8
			elseif isCastingSpell(spell.lunarStrike) then
			return astralPower + 12
			else
			return astralPower
			end
		end
	end
	if talent.stellarDrift then
		starfallRadius = 15
	end
	if talent.soulOfTheForest then
		starfallAstralPower = 40
	end
	if mode.starsurgeAstralPower == 1 then
		starsurgeAstralPower = 40
	elseif mode.starsurgeAstralPower == 2 then
		starsurgeAstralPower = starfallAstralPower + 40
	end
	if isChecked("Farm Mode") and not travel then
		for i = 1, #enemies.yards45nc do
		local thisUnit = enemies.yards45nc[i]
			if not UnitExists("target") or not getFacing("player","target") or UnitIsDeadOrGhost("target") then
				if getFacing("player",thisUnit) then
					TargetUnit(thisUnit)
				end
				if not inCombat then
					if castSpell(thisUnit,spell.moonfire,true,false,false,true,false,true,true,false) then return true end
				end
			end
		end
	end
--------------------
--- Action Lists ---
--------------------
local function actionList_OOC()
	-- Pre-Pull Timer
	if isChecked("Pre-Pull Timer") then
		if PullTimerRemain() <= getOptionValue("Pre-Pull Timer") then
			if cast.solarWrath() then return true end
		end
	end
	-- Revive
	if isChecked("Revive") and not moving and resable then
		if cast.revive("target","dead") then return true end
	end
	-- Regrowth
	if isChecked("OOC Regrowth") and not moving and php <= getValue("OOC Regrowth") then
		if cast.regrowth("player") then return true end
	end
	if isChecked("Auto Shapeshifts") then
		-- Flight Form
		if IsFlyableArea() and ((not (isInDraenor() or isInLegion())) or isKnown(191633)) and not swimming and falling > 1 and level>=58 then
			if cast.travelForm("player") then return true end
		end
		-- Travel Form
		if not inCombat and swimming and not travel and not hastar and not deadtar and not buff.prowl.exists() then
			if cast.travelForm("player") then return true end
		end
		if not inCombat and moving and not travel and not IsMounted() and not IsIndoors() then
			if cast.travelForm("player") then return true end
		end
		-- Cat Form
		if cast.able.travelForm() and not cat and not IsMounted() then
			-- Cat Form when not swimming or flying or stag and not in combat
			if not inCombat and moving and not swimming and not flying and not travel and not isValidUnit("target") then
				if cast.catForm("player") then return true end
			end
		end
	end
end

local function actionList_main()
	-- Innervate
	if isChecked("Innervate") and SpecificToggle("Innervate") and not GetCurrentKeyBoardFocus() then
		if cast.innervate("mouseover") then return true end
	end
	-- Rebirth
	if isChecked("Rebirth") and not moving then
		if getOptionValue("Rebirth") == 1
			and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player") then
			if cast.rebirth("target","dead") then return true end
		end
		if getOptionValue("Rebirth") == 2
			and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player") then
			if cast.rebirth("mouseover","dead") then return true end
		end
		if getOptionValue("Rebirth") == 3 then
			for i =1, #br.friend do
				if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit,"player") then
					if cast.rebirth(br.friend[i].unit,"dead") then return true end
				end
			end
		end
	end
    -- Make sure we're in moonkin form if we're not in another form
    if not chicken then
        if cast.moonkinForm() then return true end
    end
	-- Defensive
	if useDefensive() then
		--Potion or Stone
		if isChecked("Potion/Healthstone") and php <= getValue("Potion/Healthstone") then
			if canUse(5512) then
				useItem(5512)
			elseif canUse(getHealthPot()) then
				useItem(getHealthPot())
			end
		end
		-- Renewal
		if isChecked("Renewal") and cast.able.renewal() and php <= getValue("Renewal") then
			if cast.renewal("player") then return end
		end
		-- Barkskin
		if isChecked("Barkskin") and cast.able.barkskin() and php <= getValue("Barkskin") then
			if cast.barkskin() then return end
		end
		-- Regrowth
		if isChecked("inCombat Regrowth") and not moving and php <= getValue("inCombat Regrowth") then
			if cast.regrowth("player") then return true end
		end
		-- Remove Corruption
		if isChecked("Remove Corruption") and cast.able.removeCorruption() then
			if getOptionValue("Remove Corruption")==1 then
				if canDispel("player",spell.removeCorruption) then
					if cast.removeCorruption("player") then return true end
				end
			elseif getOptionValue("Remove Corruption")==2 then
					if canDispel("target",spell.removeCorruption) then
						if cast.removeCorruption("target") then return true end
					end
			elseif getOptionValue("Remove Corruption")==3 then
					if canDispel("player",spell.removeCorruption) or canDispel("target",spell.removeCorruption) then
						if cast.removeCorruption("target") then return true end
					end
			elseif getOptionValue("Remove Corruption")==4 then
				if canDispel("mouseover",spell.removeCorruption) then
					if cast.removeCorruption("mouseover") then return true end
				end
			elseif getOptionValue("Remove Corruption")==5 then
				for i = 1, #br.friend do
					if canDispel(br.friend[i].unit,spell.removeCorruption) then
						if cast.removeCorruption(br.friend[i].unit) then return true end
					end
				end
			end
		end
	end

	-- Interrupts
	if useInterrupts() then
		for i = 1, #enemies.yards45 do
			local thisUnit = enemies.yards45[i]
			if canInterrupt(thisUnit,getValue("InterruptAt")) then
				-- Solar Beam
				if isChecked("Solar Beam") and cast.able.solarBeam() then
					if cast.solarBeam(thisUnit) then return end
				end
				-- Mighty Bash
				if isChecked("Mighty Bash") and talent.mightyBash and cast.able.mightyBash() and getDistance(thisUnit) <= 10 then
					if cast.mightyBash(thisUnit) then return true end
				end
			end
		end
	end

	if isChecked("Auto Soothe") and cast.able.soothe() then
		for i=1, #enemies.yards45 do
		local thisUnit = enemies.yards45[i]
			if canDispel(thisUnit, spell.soothe) then
				if cast.soothe(thisUnit) then return true end
			end
		end
	end

	-- Cooldowns
	if useCDs() then
		-- Trinkets
		if isChecked("Trinkets 1") and canUse(13) then
			if getOptionValue("Trinkets 1") == 1 then
				if useItem(13) then return true end
			elseif getOptionValue("Trinkets 1") == 2 then
				if useItemGround("target",13,40,0,nil) then return true end
			end
		end
		if isChecked("Trinkets 2") and canUse(14) then
			if getOptionValue("Trinkets 2") == 1 then
				if useItem(14) then return true end
			elseif getOptionValue("Trinkets 2") == 2 then
				if useItemGround("target",14,40,0,nil) then return true end
			end
		end
		-- Racial
		if isChecked("Racial") and cast.able.racial() and (buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists() and (race == "Orc" or race == "Troll" or race == "LightforgedDraenei")) then
			if cast.racial() then return end
		end
		-- Warrior of Elune
		if isChecked("Warrior of Elune") and cast.able.warriorOfElune() and talent.warriorOfElune then
			if cast.warriorOfElune("player") then return true end
		end
        -- Incarnation
        if isChecked("Incarnation") and cast.able.incarnationChoseOfElune() and talent.incarnationChoseOfElune and (FutureAstralPower() >= 40) then
            if cast.incarnationChoseOfElune("player") then return true end
        end
        -- Celestial Alignment
        if isChecked("Celestial Alignment") and not talent.incarnationChoseOfElune and cast.able.celestialAlignment() and (FutureAstralPower() >= 40) then
            if cast.celestialAlignment("player") then return true end
        end
        -- Fury of Elune
        if isChecked("Fury of Elune") and talent.furyOfElune and cast.able.furyOfElune() then
            if cast.furyOfElune("target") then return true end
        end
        -- Force of Nature
        if isChecked("Force of Nature") and not moving and talent.forceOfNature and cast.able.forceOfNature() then
            if cast.forceOfNature("best") then return true end
        end
	end

	if mode.rotation ~= 2 and isChecked("Starfall priority") and not moving and (not buff.starlord.exists() or buff.starlord.remain() >= 4) and FutureAstralPower() >= starfallAstralPower then
		if cast.starfall("best", false, getValue("Starfall priority"), starfallRadius) then return true end
	end
	if FutureAstralPower() >= 95 and getFacing("player", "target") then
		if cast.starsurge() then return true end
	end
    -- Apply Moonfire and Sunfire to all targets that will live longer than six seconds
	if mode.rotation ~= 2 then
		for i = 1, #enemies.yards45 do
			local thisUnit = enemies.yards45[i]
			if astralPowerDeficit >= 7 and debuff.sunfire.remain(thisUnit) < 5.4 and ttd(thisUnit) > 5.4 and (not buff.celestialAlignment.exists() and not buff.incarnationChoseOfElune.exists() or not cast.last.sunfire()) then
				if castSpell(thisUnit,spell.sunfire,true,false,false,true,false,true,true,false) then return true end
			elseif astralPowerDeficit >= 7 and debuff.moonfire.remain(thisUnit) < 6.6 and ttd(thisUnit) > 6.6 and (not buff.celestialAlignment.exists() and not buff.incarnationChoseOfElune.exists() or not cast.last.moonfire()) then
				if castSpell(thisUnit,spell.moonfire,true,false,false,true,false,true,true,false) then return true end
			elseif talent.stellarFlare and astralPowerDeficit >= 12 and debuff.stellarFlare.remain(thisUnit) < 7.2 and ttd(thisUnit) > 7.2 and (not buff.celestialAlignment.exists() and not buff.incarnationChoseOfElune.exists() or not cast.last.stellarFlare()) then
				if castSpell(thisUnit,spell.stellarFlare,true,false,false,true,false,true,true,false) then return true end
			end
		end
	end
	if mode.rotation == 2 then
		if astralPowerDeficit >= 7 and debuff.sunfire.remain("target") < 5.4 and ttd("target") > 5.4 and (not buff.celestialAlignment.exists() and not buff.incarnationChoseOfElune.exists() or not cast.last.sunfire()) then
			if cast.sunfire("target") then return true end
		elseif astralPowerDeficit >= 7 and debuff.moonfire.remain("target") < 6.6 and ttd("target") > 6.6 and (not buff.celestialAlignment.exists() and not buff.incarnationChoseOfElune.exists() or not cast.last.moonfire()) then
			if cast.moonfire("target") then return true end
		elseif astralPowerDeficit >= 12 and debuff.stellarFlare.remain("target") < 7.2 and ttd("target") > 7.2 and (not buff.celestialAlignment.exists() and not buff.incarnationChoseOfElune.exists() or not cast.last.stellarFlare()) then
			if cast.stellarFlare("target") then return true end
		end
	end
	-- Rotations
	if not moving and not isChecked("Farm Mode") then
		if astralPowerDeficit >= 16 and (buff.lunarEmpowerment.stack() == 3 or (#enemies.yards8t < 3 and astralPower >= 40 and buff.lunarEmpowerment.stack() == 2 and buff.solarEmpowerment.stack() == 2)) then
			if cast.lunarStrike() then return true end
		end
		if astralPowerDeficit >= 12 and buff.solarEmpowerment.stack() == 3 then
			if cast.solarWrath() then return true end
		end
	end
	if mode.rotation ~= 2 and isChecked("Starfall") and not moving and (not buff.starlord.exists() or buff.starlord.remain() >= 4) and FutureAstralPower() >= starfallAstralPower then
		if cast.starfall("best", false, getValue("Starfall"), starfallRadius) then return true end
	end
	if getFacing("player", "target") and (#enemies.yards45 < getValue("Starfall") or mode.rotation == 2) and (not buff.starlord.exists() or buff.starlord.remain() >= 4 or (gcd * (FutureAstralPower() / starsurgeAstralPower)) > ttd()) and FutureAstralPower() >= starsurgeAstralPower then
		if cast.starsurge() then return true end
	end
	if not isChecked("Farm Mode") then
		if talent.newMoon and not moving then
			if astralPowerDeficit > 10 + (getCastTime(spell.newMoon) / 1.5) then
				if cast.newMoon() then return true end
			end
			if astralPowerDeficit > 20 + (getCastTime(spell.halfMoon) / 1.5) then
				if cast.halfMoon() then return true end
			end
			if astralPowerDeficit > 40 + (getCastTime(spell.fullMoon) / 1.5) then
				if cast.fullMoon() then return true end
			end
		end
		if buff.warriorOfElune.exists() or buff.owlkinFrenzy.exists() then
			if cast.lunarStrike() then return true end
		end
		if not moving and #enemies.yards8t >= 2 then
			-- Cleave situation: prioritize lunar strike empower > solar wrath empower > lunar strike
			if buff.lunarEmpowerment.exists() and not (buff.lunarEmpowerment.stack() == 1 and isCastingSpell(spell.lunarStrike)) then
				if cast.lunarStrike() then return true end
			end
			if buff.solarEmpowerment.exists() and not (buff.solarEmpowerment.stack() == 1 and isCastingSpell(spell.solarWrath)) then
				if cast.solarWrath() then return true end
			end
			if cast.able.solarWrath() then
				if cast.lunarStrike() then return true end
			end
		elseif not moving then
			-- ST situation: prioritize solar wrath empower > lunar strike empower > solar wrath
			if buff.solarEmpowerment.exists() and not (buff.solarEmpowerment.stack() == 1 and isCastingSpell(spell.solarWrath)) then
				if cast.solarWrath() then return true end
			end
			if buff.lunarEmpowerment.exists() and not (buff.lunarEmpowerment.stack() == 1 and isCastingSpell(spell.lunarStrike)) then
				if cast.lunarStrike() then return true end
			end
			if cast.able.solarWrath() then
				if cast.solarWrath() then return true end
			end
		end
	end
	if moving or not getFacing("player", "target") then
		if castSpell("target",spell.moonfire,true,false,false,true,false,true,true,false) then return true end
	end
end
-----------------
--- Rotations ---
-----------------
        -- Pause
        if pause() or mode.rotation == 4 or buff.shadowmeld.exists() or buff.prowl.exists() then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat then
				if actionList_OOC() then return end
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations ---
-----------------------------
			if inCombat and not travel then
				if actionList_main() then return end
            end -- End In Combat Rotation
        end -- Pause
    -- end -- End Timer
end -- End runRotation


--local id = 102
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

local rotationName = "Fengshen"

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "This is the only mode for this rotation.", highlight = 1, icon = br.player.spell.solarWrath }
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
-- Starfall Placement Button
    StarfallPlacementModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Auto placement of Starfall", tip = "Auto placement of Starfall", highlight = 1, icon = br.player.spell.starfall },
        [2] = { mode = "Target", value = 2 , overlay = "Place Starfall on center of target", tip = "Place Starfall on center of target", highlight = 1, icon = br.player.spell.starfall },
        [3] = { mode = "Player", value = 2 , overlay = "Place Starfall on center of player", tip = "Place Starfall on center of player", highlight = 1, icon = br.player.spell.starfall }
    };
    CreateButton("StarfallPlacement",5,0)
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
		-- Pre-Pull Timer
		-- br.ui:createSpinner(section, "Pre-Pull Timer",  5,  0,  20,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
		-- Travel Shapeshifts
		br.ui:createCheckbox(section,"Auto Shapeshifts","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to best form for situation|cffFFBB00.")
		-- Auto Soothe
		br.ui:createCheckbox(section, "Auto Soothe")
	br.ui:checkSectionState(section)
	-- Defensive Options
	section = br.ui:createSection(br.ui.window.profile, "Defensive")
		br.ui:createSpinner(section, "Potion/Healthstone",  20,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "Renewal",  25,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "Barkskin",  60,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "inCombat Regrowth",  30,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "OOC Regrowth",  80,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createDropdown(section, "Rebirth", {"|cff00FF00Target","|cffFF0000Mouseover","|cffFFBB00Any"}, 1, "|cffFFFFFFTarget to cast on")
	br.ui:checkSectionState(section)
	-- Interrupts Options
	section = br.ui:createSection(br.ui.window.profile, "Interrupts")
		br.ui:createCheckbox(section, "Solar Beam")
		br.ui:createCheckbox(section, "Mighty Bash")
		br.ui:createSpinner(section,  "InterruptAt",  50,  0,  100,  5,  "","|cffFFBB00Cast Percentage to use at.")
	br.ui:checkSectionState(section)	
    -- Cooldown Options
    section = br.ui:createSection(br.ui.window.profile, "Cooldown")
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
    if br.timer:useTimer("debugBalance", 0.1) then
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
		UpdateToggle("Rotation",0.25)
		UpdateToggle("Cooldown",0.25)
		UpdateToggle("Defensive",0.25)
		UpdateToggle("Interrupt",0.25)
		UpdateToggle("StarfallPlacement",0.25)
		br.player.mode.starfallPlacement = br.data.settings[br.selectedSpec].toggles["StarfallPlacement"]
--------------
--- Locals ---
--------------
		local buff                                          = br.player.buff
		local cast                                          = br.player.cast
		local combatTime                                    = getCombatTime()
		local cd                                            = br.player.cd
		local charges                                       = br.player.charges
		local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
		local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
		local debuff                                        = br.player.debuff
		local enemies                                       = br.player.enemies
		local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
		local friendly                                      = friendly or GetUnitIsFriend("target", "player")
		local gcd                                           = br.player.gcd
		local hasMouse                                      = GetObjectExists("mouseover")
		local inCombat                                      = br.player.inCombat
		local inInstance                                    = br.player.instance=="party"
		local inRaid                                        = br.player.instance=="raid"
		local level                                         = br.player.level
		local lowestHP                                      = br.friend[1].unit
		local mode                                          = br.player.mode
		local perk                                          = br.player.perk
		local petInfo                                       = br.player.petInfo
		local php                                           = br.player.health
		local playerMouse                                   = UnitIsPlayer("mouseover")
		local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount, br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
		local pullTimer                                     = br.DBM:getPulltimer()
		local racial                                        = br.player.getRacial()
		local spell                                         = br.player.spell
		local talent                                        = br.player.talent
		local ttd                                           = getTTD
		local ttm                                           = br.player.power.mana.ttm()
		local units                                         = br.player.units
		local dt                                            = date("%H:%M:%S")
		local trait                                         = br.player.traits
		local race                                          = br.player.race
		-- Balance Locals
		local astralPower                                   = br.player.power.astralPower.amount()
		local astralPowerDeficit                            = br.player.power.astralPower.deficit()
		local travel                                        = br.player.buff.travelForm.exists()
		local flight                                        = br.player.buff.flightForm.exists()
		local chicken                                       = br.player.buff.balanceForm.exists()
		local cat                                           = br.player.buff.catForm.exists()
		local bear                                          = br.player.buff.bearForm.exists()
		local noform                                        = GetShapeshiftForm()==0
		local hasteAmount                                   = 1/(1+(GetHaste()/100))
		local latency                                       = getLatency()
		local starfallRadius                                = 15
		local starfallPlacement                             = "playerGround"

		units.get(40)
		enemies.get(15,"target")
		enemies.get(8,"target")
		enemies.get(40)

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

    if talent.stellarDrift then starfallRadius = 15*1.2 end
    if mode.starfallPlacement == 1 then
        starfallPlacement = "best"
    elseif mode.starfallPlacement == 2 then
        starfallPlacement = "targetGround"
    end
--------------------
--- Action Lists ---
--------------------
local function actionList_OOC()
	-- Regrowth
	if isChecked("OOC Regrowth") and php <= getValue("OOC Regrowth") then
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
		if not cat and not IsMounted() then
			-- Cat Form when not swimming or flying or stag and not in combat
			if not inCombat and moving and not swimming and not flying and not travel and not isValidUnit("target") then
				if cast.catForm("player") then return true end
			end
		end
	end
end

local function actionList_main()
    -- Make sure we're in moonkin form if we're not in another form
    if noform then
        if cast.balanceForm() then return true end
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
		if isChecked("inCombat Regrowth") and php <= getValue("inCombat Regrowth") then
			if cast.regrowth("player") then return true end
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
	end

	-- Interrupts
	if useInterrupts() then
		for i = 1, #enemies.yards40 do
			local thisUnit = enemies.yards40[i]
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
		for i=1, #enemies.yards40 do
		local thisUnit = enemies.yards40[i]
			if canDispel(thisUnit, spell.soothe) then
				if cast.soothe(thisUnit) then return true end
			end
		end
	end

	-- Cooldowns
	if useCDs() then
		-- Racial
		if isChecked("Racial") and cast.able.racial() and (buff.celestialAlignment.exists() or buff.incarnation.exists() and (race == "Orc" or race == "Troll" or race == "LightforgedDraenei")) then
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
            if cast.furyOfElune("best") then return true end
        end
        -- Force of Nature
        if isChecked("Force of Nature") and talent.forceOfNature and cast.able.forceOfNature() then
            if cast.forceOfNature("best") then return true end
        end
	end

    -- Apply Moonfire and Sunfire to all targets that will live longer than six seconds
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
		if getFacing(thisUnit) then
			if astralPowerDeficit >= 7 and debuff.sunfire.remain(thisUnit) < 5.4 and ttd(thisUnit) > 5.4 and (not buff.celestialAlignment.exists() and not buff.incarnationChoseOfElune.exists() or not cast.last.sunfire()) then
				if cast.sunfire(thisUnit,"aoe") then return true end
			elseif astralPowerDeficit >= 7 and debuff.moonfire.remain(thisUnit) < 6.6 and ttd(thisUnit) > 6.6 and (not buff.celestialAlignment.exists() and not buff.incarnationChoseOfElune.exists() or not cast.last.moonfire()) then
				if cast.moonfire(thisUnit,"aoe") then return true end
			elseif astralPowerDeficit >= 12 and debuff.stellarFlare.remain(thisUnit) < 7.2 and ttd(thisUnit) > 7.2 and (not buff.celestialAlignment.exists() and not buff.incarnationChoseOfElune.exists() or not cast.last.stellarFlare()) then
				if cast.stellarFlare(thisUnit,"aoe") then return true end
			end
		end
    end

	-- Rotations
	if cast.able.lunarStrike() and astralPowerDeficit >= 16 and (buff.lunarEmpowerment.stack() == 3 or (#enemies.yards8t < 3 and astralPower >= 40 and buff.lunarEmpowerment.stack() == 2 and buff.solarEmpowerment.stack() == 2)) then
		if cast.lunarStrike() then return true end
	end
	if cast.able.solarWrath() and astralPowerDeficit >= 12 and buff.solarEmpowerment.stack() == 3 then
		if cast.solarWrath() then return true end
	end

	if cast.able.starsurge() and #enemies.yards40 < 3 and (not buff.starlord.exists() or buff.starlord.remain() >= 4 or (gcd * (FutureAstralPower() / 40)) > ttd()) and FutureAstralPower() >= 40 then
		if cast.starsurge() then return true end
	end
	if cast.able.starfall() and #enemies.yards40 >= 3 and (not buff.starlord.exists() or buff.starlord.remain() >= 4) and ((talent.soulOfTheForest and FutureAstralPower() >= 40)or FutureAstralPower() >= 50) then
		if cast.starfall(starfallPlacement, nil, 3, starfallRadius) then return true end
	end
	if cast.able.newMoon() and (astralPowerDeficit > 10 + (getCastTime(spell.newMoon) / 1.5)) then
		if cast.newMoon() then return true end
	end
	if cast.able.halfMoon() and (astralPowerDeficit > 20 + (getCastTime(spell.halfMoon) / 1.5)) then
		if cast.halfMoon() then return true end
	end
	if cast.able.fullMoon() and (astralPowerDeficit > 40 + (getCastTime(spell.fullMoon) / 1.5)) then
		if cast.fullMoon() then return true end
	end
	if cast.able.lunarStrike() and (buff.warriorOfElune.exists() or buff.owlkinFrenzy.exists()) then
		if cast.lunarStrike() then return true end
	end
	if (#enemies.yards8t >= 2) then
		-- Cleave situation: prioritize lunar strike empower > solar wrath empower > lunar strike
		if cast.able.lunarStrike() and buff.lunarEmpowerment.exists() and not (buff.lunarEmpowerment.stack() == 1 and isCastingSpell(spell.lunarStrike)) then
			if cast.lunarStrike() then return true end
		end
		if cast.able.solarWrath() and buff.solarEmpowerment.exists() and not (buff.solarEmpowerment.stack() == 1 and isCastingSpell(spell.solarWrath)) then
			if cast.solarWrath() then return true end
		end
		if cast.able.lunarStrike() and (true) then
			if cast.lunarStrike() then return true end
		end
	else
		-- ST situation: prioritize solar wrath empower > lunar strike empower > solar wrath
		if cast.able.solarWrath() and buff.solarEmpowerment.exists() and not (buff.solarEmpowerment.stack() == 1 and isCastingSpell(spell.solarWrath)) then
			if cast.solarWrath() then return true end
		end
		if cast.able.lunarStrike() and buff.lunarEmpowerment.exists() and not (buff.lunarEmpowerment.stack() == 1 and isCastingSpell(spell.lunarStrike)) then
			if cast.lunarStrike() then return true end
		end
		if cast.able.solarWrath() and (true) then
			if cast.solarWrath() then return true end
		end
	end
	if cast.able.moonfire() and (true) then
		if cast.moonfire() then return true end
	end
end
-----------------
--- Rotations ---
-----------------
        -- Pause
        if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or buff.shadowmeld.exists() or buff.prowl.exists() then
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
    end -- End Timer
end -- End runRotation


local id = 102
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

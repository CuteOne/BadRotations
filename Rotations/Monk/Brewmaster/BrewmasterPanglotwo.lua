local rotationName = "Panglo2.0"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
	RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "DPS Enabled", tip = "Enables DPS rotation", highlight = 1, icon = br.player.spell.blackoutStrike },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.vivify }
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.fortifyingBrew },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.fortifyingBrew },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.fortifyingBrew }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dampenHarm },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dampenHarm }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.spearHandStrike },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.spearHandStrike }
    };
    CreateButton("Interrupt",4,0)
    BrewsModes = {
        [1] = { mode = "On", value = 1 , overlay = "Brews Enabled", tip = "Brews will be used.", highlight = 1, icon = br.player.spell.ironskinBrew },
        [2] = { mode = "Off", value = 2 , overlay = "Brews Disabled", tip = "No Brews will be used.", highlight = 0, icon = br.player.spell.legSweep }
    };
    CreateButton("Brews",5,0)
end

local function createOptions()
    local optionTable

    local function rotationOptions()
        ------------------------
        --- Blackout OPTIONS ---
        ------------------------
--        section = br.ui:createSection(br.ui.window.profile,  "BoC Priority")
        -- When Using BoC, Select Priority, or leave on Auto
--            br.ui:createDropdownWithout(section, "Select Priority", {"|cff1ED761Auto Mode","|cff20FF00Tiger Palm","|cffFFCC00Keg Smash","|cffFF0000Breath of Fire"},1, "Select the BoC Priority, Recommended Auto")
--        br.ui:checkSectionState(section)
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
		-- Let Rotation Deal with Purifying (SIMC)
			br.ui:createCheckbox(section,"Purify at High Stagger")
        -- Stagger dmg % to purify
            br.ui:createSpinner(section, "Stagger dmg % to purify",  150,  0,  300,  10,  "Stagger dmg % to purify")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinket 1")
            br.ui:createCheckbox(section,"Trinket 2")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- BoB usage
            br.ui:createCheckbox(section, "Black Ox Brew")
		-- Taunt
			br.ui:createCheckbox(section,"Taunt","|cffFFFFFFAuto Taunt usage.")
		br.ui:checkSectionState(section)
        -------------------------
		---  COOLDOWN OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
		--Invoke Niuzao
			br.ui:createCheckbox(section,"Invoke Niuzao")
		br.ui:checkSectionState(section)
        -------------------------
		--- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        -- Healing Elixir
            br.ui:createSpinner(section, "Healing Elixir", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Fortifying Brew
            br.ui:createSpinner(section, "Fortifying Brew",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Dampen Harm
            br.ui:createSpinner(section, "Dampen Harm",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Detox
            br.ui:createCheckbox(section,"Detox Me")
        -- Detox
            br.ui:createCheckbox(section,"Detox Mouseover")
        -- Expel Harm
            br.ui:createSpinner(section, "Expel Harm",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
		-- Guard
			br.ui:createCheckbox(section,"Use Guard")
		-- Expel Harm Orbs
            br.ui:createSpinnerWithout(section, "Expel Harm Orbs",  3,  0,  15,  1,  "|cffFFFFFFMin amount of Gift of the Ox Orbs to cast.")
        -- Vivify
            br.ui:createSpinner(section, "Vivify",  50,  0,  100,  5,  "|cffFFFFFFCast Vivify")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        --Quaking Palm
            br.ui:createCheckbox(section, "Quaking Palm")
        -- Spear Hand Strike
            br.ui:createCheckbox(section, "Spear Hand Strike")
        -- Paralysis
            br.ui:createCheckbox(section, "Paralysis")
        -- Leg Sweep
            br.ui:createCheckbox(section, "Leg Sweep")
        -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
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
    if br.timer:useTimer("debugBrewmaster", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
		UpdateToggle("Cooldown",0.25) 
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Brews",0.25)
        br.player.mode.brews = br.data.settings[br.selectedSpec].toggles["Brews"]

--------------
--- Locals ---
--------------
        local agility           = UnitStat("player", 2)
        local artifact          = br.player.artifact
        local baseAgility       = 0
        local baseMultistrike   = 0
        local buff              = br.player.buff
        local canFlask          = canUse(br.player.flask.wod.agilityBig)
        local cast              = br.player.cast
        local castable          = br.player.cast.debug
        local cd                = br.player.cd
        local charges           = br.player.charges
        local combatTime        = getCombatTime()
        local debuff            = br.player.debuff
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local enemies           = br.player.enemies
        local flaskBuff         = getBuffRemain("player",br.player.flask.wod.buff.agilityBig) or 0
        local gcd               = br.player.gcd
        local glyph             = br.player.glyph
        local healthPot         = getHealthPot() or 0
        local inCombat          = br.player.inCombat
        local inRaid            = select(2,IsInInstance())=="raid"
        local inInstance        = br.player.instance=="party"
        local lastSpell         = lastSpellCast
        local level             = br.player.level
        local mode              = br.player.mode
        local php               = br.player.health
        local power             = br.player.power.energy.amount()
        local powgen            = br.player.power.energy.regen()
        local powerDeficit		= br.player.power.energy.deficit()
		local powerMax          = br.player.power.energy.max()
        local pullTimer         = br.DBM:getPulltimer()
        local queue             = br.player.queue
        local race              = br.player.race
        local racial            = br.player.getRacial()
        local regen             = br.player.power.energy.regen()
        local solo              = select(2,IsInInstance())=="none"
        local spell             = br.player.spell
        local talent            = br.player.talent
        local thp               = getHP("target")
        local trinketProc       = false --br.player.hasTrinketProc()
        local ttd               = getTTD
        local ttm               = br.player.power.energy.ttm()
        local units             = br.player.units
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        units.get(5)
        units.get(8)
        enemies.get(5)
        enemies.get(8) 
        enemies.get(8,"target")
        enemies.get(20)
        enemies.get(30)

--------------------
--- Action Lists ---
--------------------
	-- Action List - Extras
	local function actionList_Extras()
		-- Taunt
		if isChecked("Taunt") and inInstance then
			for i = 1, #enemies.yards30 do
				local thisUnit = enemies.yards30[i]
				if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
					if cast.provoke(thisUnit) then return end
				end
			end
		end -- End Taunt
	end -- End Action List - Extras
	-- Action List - Defensive
    local function actionList_Defensive()
        if useDefensive() then
        -- Vivify
                if isChecked("Vivify") and (not inCombat and php <= getOptionValue("Vivify")) then
                    if cast.vivify() then return end
                end
        -- Guard
                if talent.guard and isChecked("Use Guard") and debuff.heavyStagger.exists("player") then
                    if cast.guard() then return end
                end
        --Expel Harm
                if isChecked("Expel Harm") and php <= getValue("Expel Harm") and inCombat and GetSpellCount(115072) >= getOptionValue("Expel Harm Orbs") then
                    if cast.expelHarm() then return end
                end
        -- Pot/Stoned
                if isChecked("Pot/Stoned") and getHP("player") <= getValue("Pot/Stoned") and inCombat then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healthPot) then
                        useItem(healthPot)
                    end
                end
        -- Dampen Harm
                if isChecked("Dampen Harm") and php <= getValue("Dampen Harm") and inCombat then
                    if cast.dampenHarm() then return end
                end
        -- Detox
                if isChecked("Detox Me") then
                    if canDispel("player",spell.detox) then
                       if cast.detox("player") then return end
                    end
                end
        -- Detox Mouseover
                if isChecked("Detox Mouseover") then
                    if UnitIsPlayer("mouseover") and not UnitIsDeadOrGhost("mouseover") then
                         if canDispel("mouseover",spell.detox) then
                            if cast.detox("mouseover") then return end
                        end
                    end
                end
        -- Healing Elixir
                if isChecked("Healing Elixir") and php <= getValue("Healing Elixir") and charges.healingElixir.count() > 1 then
                    if cast.healingElixir() then return end
                end
        -- Fortifying Brew
                if isChecked("Fortifying Brew") and php <= getValue("Fortifying Brew") and inCombat then
                    if cast.fortifyingBrew() then return end
                end
            end
		end
	-- Action List - Cooldowns
        local function actionList_Cooldowns()
            if useCDs() then
    			if isChecked("Invoke Niuzao") then
	    			if cast.invokeNiuzao() then return end
                end
            end
            -- Trinkets    
			if isChecked("Trinket 1") then
                    useItem(13)
            end
            if isChecked("Trinket 2") then
                    useItem(14)
            end

        end    
	-- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts()
                for i=1, #enemies.yards20 do
                    thisUnit = enemies.yards20[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                        if distance <= 5 then
        -- Quaking Palm
                            if isChecked("Quaking Palm") then
                                if cast.quakingPalm(thisUnit) then return end
                            end
        -- Spear Hand Strike
                            if isChecked("Spear Hand Strike") then
                                if cast.spearHandStrike(thisUnit) then return end
                            end
        -- Leg Sweep
                            if isChecked("Leg Sweep") then
                                if cast.legSweep(thisUnit) then return end
                            end
                        end
        -- Paralysis
                        if isChecked("Paralysis") then
                            if cast.paralysis(thisUnit) then return end
                        end
                    end
                end
            end
        end -- End Action List - Interrupts
    -- Action List - Pre-Combat
        local function actionList_PreCombat()
               -- auto_attack
                if isValidUnit("target") and getDistance("target") < 5 then
                    StartAttack()
                end
            end --End Action List - Pre-Combat
		
---------------------
--- Rotations Code---
---------------------
		
	-- Single Target Rotation
    local function actionList_Single()
       -- Print("Single")
		-- Black Out Strike
			if cast.blackoutStrike() then return end
		-- Keg Smash
			if cast.kegSmash() then return end
		-- Breath of Fire
			if debuff.kegSmash.exists() then
				if cast.breathOfFire() then return end
			end
		-- High Energy TP
			if (power > 55) and buff.rushingJadeWind.exists() and not (cast.able.kegSmash() or cast.able.breathOfFire()) then
				if cast.tigerPalm() then return end
			end
		-- Rushing Jade Wind
			if not buff.rushingJadeWind.exists() or (buff.rushingJadeWind.remain() < 2 and not (cast.able.kegSmash() or cast.able.breathOfFire())) then
				if cast.rushingJadeWind() then return end
			end
		-- Chi Wave 
			if not (cast.able.kegSmash() or cast.able.breathOfFire()) then
				if cast.chiWave() then return end
			end
		-- Chi Burst 
			if not (cast.able.kegSmash() or cast.able.breathOfFire()) then
				if cast.chiBurst() then return end
			end
	end -- End Single Target
	
	-- Multi Target Rotation
    local function actionList_Multi()
       -- Print("Multi")
		-- Keg Smash
			if cast.kegSmash() then return end
		-- Breath of Fire
			if debuff.kegSmash.exists() then
				if cast.breathOfFire() then return end
			end
		-- Rushing Jade Wind
			if not buff.rushingJadeWind.exists() or (buff.rushingJadeWind.remain() < 2 and not (cast.able.kegSmash() or cast.able.breathOfFire())) then
				if cast.rushingJadeWind() then return end
			end
		-- Chi Burst 
			if not (cast.able.kegSmash() or cast.able.breathOfFire()) then
				if cast.chiBurst() then return end
			end
		-- Black Out Strike
			if cast.blackoutStrike() then return end
		-- Chi Wave
			if not (cast.able.kegSmash() or cast.able.breathOfFire()) then
				if cast.chiWave() then return end
			end
		-- Tiger Palm
			if power > 55 and buff.rushingJadeWind.exists() and not (cast.able.kegSmash() or cast.able.breathOfFire()) then
				if cast.tigerPalm() then return end
			end
	end
	
	-- Blackout Combo Rotation
    local function actionList_AutoBlackout()
        if buff.blackoutCombo.exists() then
            if cast.kegSmash() then return end
            if not ((cast.able.breathOfFire() and debuff.kegSmash.exists()) or cast.able.kegSmash()) and power > 45 then
				if cast.tigerPalm() then return end
            end
            if not cast.able.kegSmash() and debuff.kegSmash.exists() then
                if cast.breathOfFire() then return end
            end
        else
            if cast.blackoutStrike() then return end
            if buff.rushingJadeWind.exists() and not cast.able.breathOfFire() and power > 45 then
                if cast.tigerPalm() then return end
            end
            if cast.breathOfFire() then return end
            if not buff.rushingJadeWind.exists() or (buff.rushingJadeWind.remain() < 2 and not (cast.able.kegSmash() or cast.able.breathOfFire())) then
				if cast.rushingJadeWind() then return end
            end
        end
 

        --Print("BoC")
		-- Keg Smash
--			if buff.blackoutCombo.exists() then
--				if cast.kegSmash() then return end
--			end
		-- Black out Strike
--			if cast.blackoutStrike() then return end
		-- Tiger Palm
--			if not cast.able.kegSmash() and (power > 55) then
--				if cast.tigerPalm() then return end
--			end
		-- Breath of Fire
--			if not cast.able.kegSmash() and debuff.kegSmash.exists() then 
--				if cast.breathOfFire() then return end
--			end
		-- Rushing Jade Wind
--			if not buff.rushingJadeWind.exists() or (buff.rushingJadeWind.remain() < 2 and not (cast.able.kegSmash() or cast.able.breathOfFire())) then
--				if cast.rushingJadeWind() then return end
--			end
		-- Chi Wave 
--			if not (cast.able.kegSmash() or cast.able.breathOfFire()) then
--				if cast.chiWave() then return end
--			end
		-- Chi Burst 
--			if not (cast.able.kegSmash() or cast.able.breathOfFire()) then
--				if cast.chiBurst() then return end
--			end
	end
	
	-- Brews Rotations
	local function actionList_Brews()
		--Black Ox Brew
            if isChecked("Black Ox Brew") and (charges.purifyingBrew.frac() < 0.75) and charges.purifyingBrew.count() == 0 and talent.blackoxBrew then
                if cast.blackoxBrew() then return end
            end
        -- Auto Purify
			if isChecked("Auto Purify") then
                if debuff.heavyStagger.exists("player") or 
                (((UnitStagger("player") / UnitHealthMax("player")*100) < 66) and (charges.purifyingBrew.frac() > (charges.purifyingBrew.max() - 0.5))) then
					if cast.purifyingBrew() then return end
				end
            end
		-- Percentage Purify
			if isChecked("Stagger dmg % to purify") then
                if ((UnitStagger("player") / UnitHealthMax("player")*100) >= getValue("Stagger dmg % to purify") and (charges.purifyingBrew.frac() > 0.5)) then
                    if cast.purifyingBrew() then return end
                end
            end	
		-- Iron Skin Brew
            if not buff.blackoutCombo.exists() and (not buff.ironskinBrew.exists() or (buff.ironskinBrew.remain() <= 2 and buff.ironskinBrew.remain() <=14)) then
                if cast.ironskinBrew() then return end
            end
	end
	
	
----------------------
--- Begin Rotation ---
----------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop==true then
        profileStop = false
    elseif (inCombat and profileStop==true) or pause() or buff.zenMeditation.exists() or (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) and getBuffRemain("player", 192002 ) < 10 or mode.rotation==2 then
        return true
    else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
			-- Extras
			if actionList_Extras() then return end
			-- Defensives
			if actionList_Defensive() then return end
			-- Precombat
			if actionList_PreCombat() then return end
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
  if inCombat and profileStop==false and not (IsMounted() or IsFlying()) and #enemies.yards8 >=1 then
    if getDistance(units.dyn5) < 5 then
        StartAttack()
    end        
            -- Brews
			if br.player.mode.brews == 1 then
				if actionList_Brews() then return end
			end
			-- Cooldowns
			if actionList_Cooldowns() then return end
			-- Interrupts
			if actionList_Interrupts() then return end
			-- Blackout Combo
			if talent.blackoutCombo then
				if actionList_AutoBlackout() then return end
			end
			-- Multi Target Rotations
			if #enemies.yards8 >= 3 and not talent.blackoutCombo then
				if actionList_Multi() then return end
			end
			-- Single target Rotations
            if #enemies.yards8 <3 and not talent.blackoutCombo then
                if actionList_Single() then return end
            end
		end -- end combat check
	  end -- Pause
   end -- End Timer
end -- End runRotation 

local id = 268
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

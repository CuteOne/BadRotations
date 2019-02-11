local rotationName = "Panglo"

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
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dampenHarm },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dampenHarm }
    };
    CreateButton("Defensive",2,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.spearHandStrike },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.spearHandStrike }
    };
    CreateButton("Interrupt",3,0)
    BrewsModes = {
        [1] = { mode = "On", value = 1 , overlay = "Brews Enabled", tip = "Brews will be used.", highlight = 1, icon = br.player.spell.ironskinBrew },
        [2] = { mode = "Off", value = 2 , overlay = "Brews Disabled", tip = "No Brews will be used.", highlight = 0, icon = br.player.spell.legSweep }
    };
    CreateButton("Brews",4,0)
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
        section = br.ui:createSection(br.ui.window.profile,  "General")
		-- Let Rotation Deal with Purifying (SIMC)
			br.ui:createCheckbox(section,"Auto Purify")
        -- Stagger dmg % to purify
            br.ui:createSpinner(section, "Stagger dmg % to purify",  150,  0,  300,  10,  "Stagger dmg % to purify")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinket 1")
            br.ui:createCheckbox(section,"Trinket 2")
        -- Blackout Switch
            br.ui:createDropdown(section, "Black Out Combo Priority", {"|cff00FF00Tiger Palm","|cffFF0000Keg Smash"}, 1, "|cffFFFFFFBoC Priority")			
		-- Taunt
			br.ui:createCheckbox(section,"Taunt","|cffFFFFFFAuto Taunt usage.")
		br.ui:checkSectionState(section)
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
        -- Expel Harm
            br.ui:createSpinner(section, "Expel Harm",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
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
        enemies.get(5)
        enemies.get(8) 
        enemies.get(8,"target")
        enemies.get(30)


        if opener == nil then opener = false end

        if not inCombat and not GetObjectExists("target") then
            iB1 = false
            KG = false
            iB2 = false
            iB3 = false
            bOB = false
            iB4 = false
            opener = false
            openerStarted = false
        end
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
		end
	end -- End Action List - Extras
    -- Action List - Defensive
        function actionList_Defensive()
            if useDefensive() then
        -- Vivify
                  if isChecked("Vivify") and (not inCombat and php <= getOptionValue("Vivify")) then
                    if cast.vivify() then return end
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
        -- Healing Elixir
                if isChecked("Healing Elixir") and php <= getValue("Healing Elixir") and charges.healingElixir.count() > 1 then
                    if cast.healingElixir() then return end
                end
        -- Fortifying Brew
                if isChecked("Fortifying Brew") and php <= getValue("Fortifying Brew") and inCombat then
                    if cast.fortifyingBrew() then return end
                end
        --Expel Harm
                if isChecked("Expel Harm") and php <= getValue("Expel Harm") and GetSpellCount(115072) >= getOptionValue("Expel Harm Orbs") then
                    if cast.expelHarm() then return end
                end
            end -- End Defensive Check
        end -- End Action List - Defensive
    -- Action List - Interrupts
        function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #getEnemies("player",20) do
                    thisUnit = getEnemies("player",20)[i]
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
            end -- End Interrupt Check
        end -- End Action List - Interrupts
    -- Action List - Pre-Combat
        function actionList_PreCombat()
            if not inCombat then
                -- auto_attack
                if isValidUnit("target") and getDistance("target") < 5 then
                    StartAttack()
                end
            end -- End No Combat Check
        end --End Action List - Pre-Combat

---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or pause() or (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) and getBuffRemain("player", 192002 ) < 10 or mode.rotation==2 then
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
--- Pre-Combat Rotation ---
------------------------------
            if actionList_PreCombat() then return end
            if inCombat and not IsMounted() and profileStop==false and isValidUnit(units.dyn5)  then
    ------------------
    --- Interrupts ---
    ------------------
        -- Run Action List - Interrupts
                if actionList_Interrupts() then return end

    ----------------------
    --- Start Rotation ---
    ----------------------
        -- Auto Attack
                -- auto_attack
                if getDistance(units.dyn5) < 5 then
                    StartAttack()
                end
			--------------------------------
			--- Black out Combo Rotation ---
			--------------------------------
			if talent.blackoutCombo then 
    -- Purifying Brew actions+=/purifying_brew,if=stagger.heavy|(stagger.moderate&cooldown.brews.charges_fractional>=cooldown.brews.max_charges-0.5&buff.ironskin_brew.remains>=buff.ironskin_brew.duration*2.5)
            if br.player.mode.brews == 1 then    
                if isChecked("Auto Purify") then
					if debuff.heavyStagger.exists("player") or (((UnitStagger("player") / UnitHealthMax("player")*100) < 66) and (charges.purifyingBrew.frac() > (charges.purifyingBrew.max() - 0.5)) and
						(buff.ironskinBrew.remain() > (buff.ironskinBrew.duration() * 2.5))) then
							if cast.purifyingBrew() then return end
						end
                end
                if isChecked("Stagger dmg % to purify") then
                    if ((UnitStagger("player") / UnitHealthMax("player")*100) >= getValue("Stagger dmg % to purify") and (charges.purifyingBrew.count() > 1)) or charges.purifyingBrew.count() == charges.purifyingBrew.max() then
                        if cast.purifyingBrew() then return end
                    end
                end
            end
            -- Black Ox Brew
                if (charges.purifyingBrew.frac() < 0.5) and charges.purifyingBrew.count() == 0 and talent.blackoxBrew then
                    if cast.blackoxBrew() then return end
                end
-- ironskin_brew,&cooldown.brews.charges_fractional>=cooldown.brews.max_charges-1.0-(1+buff.ironskin_brew.remains<=buff.ironskin_brew.duration*0.5)
				
                -- Ironskin Brew
--				local ironskinBrewDuration = 7
--                if (charges.purifyingBrew.frac() >= charges.purifyingBrew.max() - 1 - ((1 + (buff.ironskinBrew.remain() <= ironskinBrewDuration and 0.5 or 0))))
--				and not buff.blackoutCombo.exists() and (buff.ironskinBrew.remain() <= 14) then
--                    if cast.ironskinBrew() then return end
--                end
            -- Ironskin Bandage
            if br.player.mode.brews == 1 then
                if not buff.blackoutCombo.exists() and (charges.purifyingBrew.count() > 1) and (not buff.ironskinBrew.exists() or (buff.ironskinBrew.remain() <= 5 and buff.ironskinBrew.remain() <=14)) then
                    if cast.ironskinBrew() then return end
                end
            end
			-- Chi Wave 
				if not (cast.able.kegSmash() or cast.able.breathOfFire()) then
					if cast.chiWave() then return end
				end
			    if isChecked("Trinket 1") then
                        useItem(13)
                end
                if isChecked("Trinket 2") then
                        useItem(14)
                end
            -- Rushing Jade Wind
                if (not buff.rushingJadeWind.exists() or buff.rushingJadeWind.remain() < 3) and not (cast.able.kegSmash() or cast.able.breathOfFire()) then
                    if cast.rushingJadeWind() then return end
                end
			-- Keg Smash
                if (getOptionValue("Black Out Combo Priority") == 2 and buff.blackoutCombo.exists()) or
					(getOptionValue("Black Out Combo Priority") == 1 and not buff.blackoutCombo.exists()) then
                    if cast.kegSmash() then return end
                end
            -- Blackout Strike
				if cast.blackoutStrike() then return end
            -- Tiger Palm 
                if ((getOptionValue("Black Out Combo Priority") == 1 and buff.blackoutCombo.exists()) or (not cast.able.breathOfFire() and power > 70)) or 
				(getOptionValue("Black Out Combo Priority") == 2 and not (cast.able.kegSmash() or cast.able.breathOfFire()) and power >= 50) then
                    if cast.tigerPalm() then return end
                end
                -- Breath of Fire
                if (not buff.blackoutCombo.exists() and debuff.kegSmash.exists()) or (not cast.able.kegSmash()) then
                    if cast.breathOfFire() then return end
                end
				
			end -- End Black out Combo Rotation
			
			-------------------------------------
			-- High Tolerance / Guard Rotation --
			-------------------------------------
			if not talent.blackoutCombo then
-- Purifying Brew actions+=/purifying_brew,if=stagger.heavy|(stagger.moderate&cooldown.brews.charges_fractional>=cooldown.brews.max_charges-0.5&buff.ironskin_brew.remains>=buff.ironskin_brew.duration*2.5)
            if br.player.mode.brews == 1 then
                if isChecked("Auto Purify") then
					if debuff.heavyStagger.exists() or ((UnitStagger("player") / UnitHealthMax("player")*100) < 66) and (charges.purifyingBrew.frac() > (charges.purifyingBrew.max() - 0.5)) and
						(buff.ironskinBrew.remain() > (buff.ironskinBrew.duration() * 2.5)) then
							if cast.purifyingBrew() then return end
						end
                end

                if isChecked("Stagger dmg % to purify") then
                    if ((UnitStagger("player") / UnitHealthMax("player")*100) >= getValue("Stagger dmg % to purify") and (charges.purifyingBrew.count() > 1)) or charges.purifyingBrew.count() == charges.purifyingBrew.max() then
                        if cast.purifyingBrew() then return end
                    end
                end
            end
            -- Black Ox Brew
                if (charges.purifyingBrew.frac() < 0.5) and charges.purifyingBrew.count() == 0 and talent.blackoxBrew then
                    if cast.blackoxBrew() then return end
                end
            -- Ironskin Brew
--				local ironskinBrewDuration = 7
--                if (charges.purifyingBrew.frac() >= charges.purifyingBrew.max()) and not buff.blackoutCombo.exists() and (buff.ironskinBrew.remain() <= 14) or (buff.ironskinBrew.remain() <= 5)	then
--                    if cast.ironskinBrew() then return end
--                end
            -- Ironskin Bandage
            if br.player.mode.brews == 1 then
                if charges.purifyingBrew.count() > 1 and (not buff.ironskinBrew.exists() or (buff.ironskinBrew.remain() <= 5 and buff.ironskinBrew.remain() <=14)) then
                    if cast.ironskinBrew() then return end
                end
            end
			-- Chi Wave 
				if not (cast.able.kegSmash() or cast.able.breathOfFire()) then
					if cast.chiWave() then return end
				end
			-- Trinkets    
				if isChecked("Trinket 1") then
                        useItem(13)
                end
                if isChecked("Trinket 2") then
                        useItem(14)
                end
            -- Rushing Jade Wind
                if (not buff.rushingJadeWind.exists() or buff.rushingJadeWind.remain() < 3) and not (cast.able.kegSmash() or cast.able.breathOfFire()) then
                    if cast.rushingJadeWind() then return end
                end
			-- Keg Smash
                    if cast.kegSmash() then return end
            -- Blackout Strike
					if cast.blackoutStrike() then return 
					end
            -- Tiger Palm 
                if not (cast.able.kegSmash() or cast.able.breathOfFire()) and power >= 50 then
                    if cast.tigerPalm() then return end
                end
            -- Breath of Fire
                if debuff.kegSmash.exists() then
                    if cast.breathOfFire() then return end
                end		
			end --End HT / Guard Rotation		
			end -- End Combat Check
		end -- End Pause
    end -- End Timer
end -- End runRotation

local id = 0 --268
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

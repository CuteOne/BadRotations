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
-- Cleave Button
	CleaveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = br.player.spell.thrash },
        [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = br.player.spell.thrash }
    };
    CreateButton("Cleave",5,0)
-- Prowl Button
	ProwlModes = {
        [1] = { mode = "On", value = 1 , overlay = "Prowl Enabled", tip = "Rotation will use Prowl", highlight = 1, icon = br.player.spell.prowl },
        [2] = { mode = "Off", value = 2 , overlay = "Prowl Disabled", tip = "Rotation will not use Prowl", highlight = 0, icon = br.player.spell.prowl }
    };
    CreateButton("Prowl",6,0)
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
        -- Opener
            br.ui:createCheckbox(section, "Opener")
            br.ui:createDropdownWithout(section, "Brutal Slash in Opener", {"|cff00FF00Enabled","|cffFF0000Disabled"}, 1, "|cff15FF00Enable|cffFFFFFF/|cffD60000Disable |cffFFFFFFuse of Brutal Slash in Opener")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Travel Shapeshifts
            br.ui:createCheckbox(section,"Auto Shapeshifts","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to best form for situation.|cffFFBB00.")
        -- Fall Timer
            br.ui:createSpinnerWithout(section,"Fall Timer", 2, 1, 5, 0.25, "|cffFFFFFFSet to desired time to wait until shifting to flight form when falling (in secs).")
        -- Break Crowd Control
            br.ui:createCheckbox(section,"Break Crowd Control","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to break crowd control.|cffFFBB00.")
        -- Wild Charge
            br.ui:createCheckbox(section,"Displacer Beast / Wild Charge","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Charge usage.|cffFFBB00.")
        -- Brutal Slash Targets
            br.ui:createSpinnerWithout(section,"Brutal Slash Targets", 3, 1, 10, 1, "|cffFFFFFFSet to desired targets to use Brutal Slash on. Min: 1 / Max: 10 / Interval: 1")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Augment Rune
            br.ui:createCheckbox(section,"Augment Rune")
        -- Potion
            br.ui:createDropdown(section,"Potion", {"Old War","Prolonged Power"}, 1, "|cffFFFFFFSet Potion to use.")
        -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Seventh Demon","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Tiger's Fury
            br.ui:createCheckbox(section,"Tiger's Fury")
            br.ui:createDropdownWithout(section,"Snipe Tiger's Fury", {"|cff00FF00Enabled","|cffFF0000Disabled"}, 1, "|cff15FF00Enable|cffFFFFFF/|cffD60000Disable |cffFFFFFFuse of Tiger's Fury to take adavantage of Predator talent.")
        -- Berserk / Incarnation: King of the Jungle
            br.ui:createCheckbox(section,"Berserk/Incarnation")
        -- Trinkets
            br.ui:createDropdownWithout(section,"Trinkets", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Specter of Betrayal.")
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
        -- Renewal
            br.ui:createSpinner(section, "Renewal",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Survival Instincts
            br.ui:createSpinner(section, "Survival Instincts",  40,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Regrowth
            br.ui:createSpinner(section, "Regrowth",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createDropdownWithout(section, "Regrowth - OoC", {"|cff00FF00Break Form","|cffFF0000Keep Form"}, 1, "|cffFFFFFFSelect if Regrowth is allowed to break shapeshift to heal out of combat.")
            br.ui:createDropdownWithout(section, "Regrowth - InC", {"|cff00FF00Immediately","|cffFF0000Save For BT"}, 1, "|cffFFFFFFSelect if Predatory Swiftness is used when available or saved for Bloodtalons.")
        -- Dream of Cenarius Auto-Heal
            br.ui:createDropdown(section, "Auto Heal", { "|cffFFDD11LowestHP", "|cffFFDD11Player"},  1,  "|cffFFFFFFSelect Target to Auto-Heal")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Skull Bash
            br.ui:createCheckbox(section,"Skull Bash")
        -- Mighty Bash
            br.ui:createCheckbox(section,"Mighty Bash")
        -- Maim
            br.ui:createCheckbox(section,"Maim")
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
        -- Cleave Toggle
            br.ui:createDropdown(section, "Cleave Mode", br.dropOptions.Toggle,  6)
        -- Prowl Toggle
            br.ui:createDropdown(section, "Prowl Mode", br.dropOptions.Toggle,  6)
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
    local profile = br.debug.cpu.rotation.profile
    local startTime = debugprofilestop()
    -- if br.timer:useTimer("debugFeral", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Cleave",0.25)
        br.player.mode.cleave = br.data.settings[br.selectedSpec].toggles["Cleave"]
        UpdateToggle("Prowl",0.25)
        br.player.mode.prowl = br.data.settings[br.selectedSpec].toggles["Prowl"]

--------------
--- Locals ---
--------------
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local comboPoints                                   = br.player.power.comboPoints.amount()
        local comboPointsDeficit                            = br.player.power.comboPoints.deficit()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local energy, energyRegen, energyDeficit            = br.player.power.energy.amount(), br.player.power.energy.regen(), br.player.power.energy.deficit()
        local equiped                                       = br.player.equiped
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local has                                           = br.player.has
        local hastar                                        = hastar or GetObjectExists("target")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inRaid                                        = br.player.instance=="raid"
        local item                                          = br.player.spell.items
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local multidot                                      = (br.player.mode.cleave == 1 or br.player.mode.rotation == 2) and br.player.mode.rotation ~= 3
        local php                                           = br.player.health
        local potion                                        = br.player.potion
        local pullTimer                                     = PullTimerRemain() --br.DBM:getPulltimer()
        local race                                          = br.player.race
        local solo                                          = #br.friend < 2
        local spell                                         = br.player.spell
        local stealth                                       = br.player.buff.prowl.exists() or br.player.buff.shadowmeld.exists()
        local talent                                        = br.player.talent
        local thp                                           = getHP
        local trait                                         = br.player.traits
        local travel, flight, cat                           = br.player.buff.travelForm.exists(), br.player.buff.flightForm.exists(), br.player.buff.catForm.exists()
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.energy.ttm()
        local units                                         = br.player.units
        local use                                           = br.player.use

        -- Get Best Unit for Range
        -- units.get(range, aoe)
        units.get(40)
        units.get(20)
        units.get(8,true)
        units.get(8)
        units.get(5)

        -- Get List of Enemies for Range
        -- enemies.get(range, from unit, no combat, variable)
        enemies.get(40) -- makes enemies.yards40
        enemies.get(20,"player",true) -- makes enemies.yards40nc
        enemies.get(13)
        enemies.get(8)
        enemies.get(5)

        if leftCombat == nil then leftCombat = GetTime() end
		if profileStop == nil then profileStop = false end
        if opener == nil then opener = false end
        if lastForm == nil then lastForm = 0 end
		if not inCombat and not hastar and profileStop==true then
            profileStop = false
		end

        local function autoProwl()
            if #enemies.yards20nc > 0 then
                for i = 1, #enemies.yards20nc do
                    local thisUnit = enemies.yards20nc[i]
                    -- local react = GetUnitReaction(thisUnit,"player") or 10
                    if UnitIsEnemy(thisUnit,"player") and UnitCanAttack(thisUnit,"player") then return true end
                end
            end
            return false
        end
        if freeProwl == nil or (not buff.incarnationKingOfTheJungle.exists() and freeProwl == false) then freeProwl = true end

        if equiped.t20 ~= nil and equiped.t20 >= 4 then
            ripDuration = 24 + 4
        elseif talent.jaggedWounds then
            rakeDuration = 12
            ripDuration = 1.6 * (24 / 2)
        else
            rakeDuration = 15
            ripDuration = 24
        end

        local friendsInRange = false
        while not solo and not friendsInRange do
            for i = 1, #br.friend do
                if getDistance(br.friend[i].unit) < 15 then
                    friendsInRange = true
                end
            end
        end

        if energy > 50 then
            fbMaxEnergy = true
        else
            fbMaxEnergy = false
        end
        -- Opener Reset
        if not inCombat and not GetObjectExists("target") then
			openerCount = 0
            OPN1 = false
            RK1 = false
            MF1 = false
            SR1 = false
            BER1 = false
            TF1 = false
            REG1 = false
            MF1 = false
            RIP1 = false
            THR1 = false
            SHR1 = false
            REG2 = false
            RIP2 = false
            opener = false
        end

        -- Variables
        -- variable,name=use_thrash,value=2
        -- variable,name=use_thrash,value=1,if=azerite.power_of_the_moon.enabled
        -- if trait.powerOfTheMoon.active() then
        --     useThrash = 1
        -- else
            useThrash = 2
        -- end

        -- TF Predator Snipe
        local function snipeTF()
            if getOptionValue("Snipe Tiger's Fury") == 1 and talent.predator and not cd.tigersFury.exists() --[[and buff.tigersFury.remain() < gcd and #enemies.yards40 > 1--]] then
                lowestUnit = units.dyn5
                lowestHP = 100
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    local thisHP = getHP(thisUnit)
                    if thisHP < lowestHP then
                        lowestHP = thisHP
                        lowestUnit = thisUnit
                    end
                end
                longestBleed = math.max(debuff.rake.remain(lowestUnit), debuff.rip.remain(lowestUnit), debuff.thrash.remain(lowestUnit), debuff.feralFrenzy.remain(lowestUnit))
                if ttd(lowestUnit) > 0 then timeTillDeath = ttd(lowestUnit) else timeTillDeath = 99 end
                if lowestUnit ~= nil and timeTillDeath < longestBleed then return true end
            end
            return false
        end

        function ferociousBiteFinish()
            local desc = GetSpellDescription(spell.ferociousBite)
            for i = 1, 5 do
                local comboStart = desc:find(" "..i.." ",1,true)+2
                local damageList = desc:sub(comboStart,desc:len())
                comboStart = damageList:find(": ",1,true)+2
                damageList = damageList:sub(comboStart,desc:len())
                local comboEnd = damageList:find(" ",1,true)-1
                damageList = damageList:sub(1,comboEnd)
                local damage = damageList:gsub(",","")
                if comboPoints == i and tonumber(damage) >= UnitHealth(units.dyn5) then return true end
            end
            return false
        end

        -- ChatOverlay("5yrds: "..tostring(units.dyn5).." | 40yrds: "..tostring(units.dyn40))
        -- ChatOverlay(round2(getDistance("target","player","dist"),2)..", "..round2(getDistance("target","player","dist2"),2)..", "..round2(getDistance("target","player","dist3"),2)..", "..round2(getDistance("target","player","dist4"),2)..", "..round2(getDistance("target"),2))
--------------------
--- Action Lists ---
--------------------
	-- Action List - Extras
		local function actionList_Extras()
            local startTime = debugprofilestop()
		-- Shapeshift Form Management
			if isChecked("Auto Shapeshifts") then --and br.timer:useTimer("debugShapeshift", 0.25) then
			-- Flight Form
				if cast.able.travelForm("player") and not inCombat and canFly() and not swimming and br.fallDist > 90--[[falling > getOptionValue("Fall Timer")]] and level>=58 and not buff.prowl.exists() then
                    if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                        -- CancelShapeshiftForm()
                        RunMacroText("/CancelForm")
                        if cast.travelForm("player") then return true end
                    else
	                   if cast.travelForm("player") then return true end
                    end
		        end
			-- Aquatic Form
			    if cast.able.travelForm("player") and (not inCombat --[[or getDistance("target") >= 10--]]) and swimming and not travel and not buff.prowl.exists() and moving then
				  	if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                        -- CancelShapeshiftForm()
                        RunMacroText("/CancelForm")
                        if cast.travelForm("player") then return true end
                    else
                        if cast.travelForm("player") then return true end
                    end
				end
			-- Cat Form
				if cast.able.catForm() and not cat and not IsMounted() and not flying then
			    	-- Cat Form when not swimming or flying or stag and not in combat
			    	if moving and not swimming and not flying and not travel then
		        		if cast.catForm("player") then return true end
		        	end
		        	-- Cat Form when not in combat and target selected and within 20yrds
		        	if not inCombat and isValidUnit("target") and ((getDistance("target") < 30 and not swimming) or (getDistance("target") < 10 and swimming)) then
		        		if cast.catForm("player") then return true end
		        	end
		        	--Cat Form when in combat and not flying
		        	-- if inCombat and not flying and not travel and not swimming then
		        	-- 	if cast.catForm("player") then return true end
		        	-- end
                    -- Cat Form - Less Fall Damage
                    if (not canFly() or inCombat or level < 58 or not IsOutdoors()) and (not swimming or (not moving and swimming and #enemies.yards5 > 0)) and br.fallDist > 90 then --falling > getOptionValue("Fall Timer") then
                        if cast.catForm("player") then return true end
                    end
		        end
			end -- End Shapeshift Form Management
		-- Perma Fire Cat
			if isChecked("Perma Fire Cat") and (use.able.fandralsSeedPouch() or use.able.burningSeeds()) and not inCombat and not buff.prowl.exists() and cat then
				if not buff.burningEssence.exists() then
					-- Fandral's Seed Pouch
                    if use.able.fandralsSeedPouch() and equiped.fandralsSeedPouch() then
                        if use.fandralsSeedPouch() then return true end
					-- Burning Seeds
                    elseif use.able.burningSeeds() then
						if use.burningSeeds() then return true end
					end
				end
			end -- End Perma Fire Cat
		-- Death Cat mode
			if isChecked("Death Cat Mode") and cat then
		        if hastar and getDistance(units.dyn8AOE) > 8 then
		            ClearTarget()
		        end
	            if autoProwl() then
	            -- Tiger's Fury - Low Energy
                    if cast.able.tigersFury() and energyDeficit > 60 then
                	   if cast.tigersFury() then return true end
                    end
	            -- Savage Roar - Use Combo Points
	                if cast.able.savageRoar() and comboPoints >= 5 then
	                	if cast.savageRoar() then return true end
	                end
	            -- Shred - Single
	                if cast.able.shred() and #enemies.yards5 == 1 then
	                	if cast.shred() then swipeSoon = nil; return true end
	                end
	            -- Swipe - AoE
	                if cast.able.swipe() and #enemies.yards8 > 1 then
	                    if swipeSoon == nil then
	                        swipeSoon = GetTime();
	                    end
	                    if swipeSoon ~= nil and swipeSoon < GetTime() - 1 then
	                    	if cast.swipe(nil,"aoe") then swipeSoon = nil; return true end
	                    end
	                end
	            end -- End 20yrd Enemy Scan
			end -- End Death Cat Mode
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
            if isChecked("Debug Timers") then
                if profile.extra == nil then profile.extra = {} end
                local section = profile.extra
                if section.totalIterations == nil then section.totalIterations = 0 end
                if section.elapsedTime == nil then section.elapsedTime = 0 end
                section.currentTime = debugprofilestop()-startTime
                section.totalIterations = section.totalIterations + 1
                section.elapsedTime = section.elapsedTime + debugprofilestop()-startTime
                section.averageTime = section.elapsedTime / section.totalIterations
            end
		end -- End Action List - Extras
	-- Action List - Defensive
		local function actionList_Defensive()
            local startTime = debugprofilestop()
            if useDefensive() and not IsMounted() and not stealth and not flight and not buff.prowl.exists() then
		--Revive/Rebirth
				if isChecked("Rebirth") and inCombat and cast.able.rebirth() then
					if getOptionValue("Rebirth - Target")==1
                        and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                    then
						if cast.rebirth("target","dead") then return true end
					end
					if getOptionValue("Rebirth - Target")==2
                        and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                    then
						if cast.rebirth("mouseover","dead") then return true end
					end
				end
				if isChecked("Revive") and not inCombat and cast.able.revive() then
					if getOptionValue("Revive - Target")==1
                        and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                    then
						if cast.revive("target","dead") then return true end
					end
					if getOptionValue("Revive - Target")==2
                        and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                    then
						if cast.revive("mouseover","dead") then return true end
					end
				end
		-- Remove Corruption
				if isChecked("Remove Corruption") and cast.able.removeCorruption() then
					if getOptionValue("Remove Corruption - Target")==1 and canDispel("player",spell.removeCorruption) then
						if cast.removeCorruption("player") then return true end
					end
					if getOptionValue("Remove Corruption - Target")==2 and canDispel("target",spell.removeCorruption) then
						if cast.removeCorruption("target") then return true end
					end
					if getOptionValue("Remove Corruption - Target")==3 and UnitIsFriend("mouseover") and canDispel("mouseover",spell.removeCorruption) then
						if cast.removeCorruption("mouseover") then return true end
					end
				end
        -- Renewal
                if isChecked("Renewal") and inCombat and cast.able.renewal() and php <= getOptionValue("Renewal") then
                    if cast.renewal() then return true end
                end
		-- PowerShift - Breaks Crowd Control (R.I.P Powershifting)
			    if isChecked("Break Crowd Control") and cast.able.catForm() then
                    if not hasNoControl() and lastForm ~= 0 then
                        CastShapeshiftForm(lastForm)
                        if GetShapeshiftForm() == lastForm then
                            lastForm = 0
                        end
                    elseif hasNoControl() then
                        if GetShapeshiftForm() == 0 then
                            cast.catForm("player")
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
	            if isChecked("Pot/Stoned") and inCombat and (use.able.healthstone() or canUse(healPot))
                    and (hasHealthPot() or has.healthstone()) and php <= getOptionValue("Pot/Stoned")
	            then
                    if use.able.healthstone() then
                        if use.healthstone() then return true end
                    elseif canUse(healPot) then
                        useItem(healPot)
                    end
	            end
	    -- Heirloom Neck
	    		if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
	    			if use.able.heirloomNeck() and item.heirloomNeck ~= 0 and item.heirloomNeck ~= item.manariTrainingAmulet then
    					if use.heirloomNeck() then return true end
	    			end
	    		end
		-- Regrowth
        		if isChecked("Regrowth") and cast.able.regrowth() and not (IsMounted() or IsFlying())
                    and (getOptionValue("Auto Heal") ~= 1 or (getOptionValue("Auto Heal") == 1 and getDistance(br.friend[1].unit) < 40))
                then
                    local thisHP = php
                    local thisUnit = "player"
                    local lowestUnit = br.friend[1].unit
                    local fhp = getHP(lowestUnit)
                    if getOptionValue("Auto Heal") == 1 then thisHP = fhp; thisUnit = lowestUnit end
                    if not inCombat then
                        -- Don't Break Form
                        if getOptionValue("Regrowth - OoC") == 2 then
                            -- Lowest Party/Raid or Player
                            if (thisHP <= getOptionValue("Regrowth") and GetShapeshiftForm() == 0) or buff.predatorySwiftness.exists() then
                                if cast.regrowth(thisUnit) then return true end
                            end
                        end
                        -- Break Form
                        if getOptionValue("Regrowth - OoC") == 1 and php <= getOptionValue("Regrowth") then
                            if GetShapeshiftForm() ~= 0 and not buff.predatorySwiftness.exists() and not moving then
                                -- CancelShapeshiftForm()
                                RunMacroText("/CancelForm")
                            else
                               if cast.regrowth("player") then return true end
                            end
                        end
                    elseif inCombat and buff.predatorySwiftness.exists() then
                        -- Always Use Predatory Swiftness when available
                        if getOptionValue("Regrowth - InC") == 1 or not talent.bloodtalons then
                            -- Lowest Party/Raid or Player
                            if thisHP <= getOptionValue("Regrowth") then
                                if cast.regrowth(thisUnit) then return true end
                            end
                        end
                        -- Hold Predatory Swiftness for Bloodtalons unless Health is Below Half of Threshold or Predatory Swiftness is about to Expire.
                        if getOptionValue("Regrowth - InC") == 2 and talent.bloodtalons then
                            -- Lowest Party/Raid or Player
                            if (thisHP <= getOptionValue("Regrowth") / 2) or buff.predatorySwiftness.remain() < 1 then
                                if cast.regrowth(thisUnit) then return true end
                            end
                        end
                    end
	            end
		-- Survival Instincts
	            if isChecked("Survival Instincts") and inCombat and cast.able.survivalInstincts() and php <= getOptionValue("Survival Instincts")
	            	and not buff.survivalInstincts.exists() and charges.survivalInstincts.count() > 0
	            then
	            	if cast.survivalInstincts() then return true end
	            end
    		end -- End Defensive Toggle
            if isChecked("Debug Timers") then
                if profile.defensive == nil then profile.defensive = {} end
                local section = profile.defensive
                if section.totalIterations == nil then section.totalIterations = 0 end
                if section.elapsedTime == nil then section.elapsedTime = 0 end
                section.currentTime = debugprofilestop()-startTime
                section.totalIterations = section.totalIterations + 1
                section.elapsedTime = section.elapsedTime + debugprofilestop()-startTime
                section.averageTime = section.elapsedTime / section.totalIterations
            end
		end -- End Action List - Defensive
	-- Action List - Interrupts
		local function actionList_Interrupts()
            local startTime = debugprofilestop()
			if useInterrupts() then
		-- Skull Bash
				if isChecked("Skull Bash") and cast.able.skullBash() then
					for i=1, #enemies.yards13 do
						thisUnit = enemies.yards13[i]
						if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
							if cast.skullBash(thisUnit) then return true end
						end
					end
				end
		-- Mighty Bash
    			if isChecked("Mighty Bash") and cast.able.mightyBash() then
    				for i=1, #enemies.yards5 do
                        thisUnit = enemies.yards5[i]
						if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
							if cast.mightyBash(thisUnit) then return true end
						end
					end
				end
		-- Maim (PvP)
    			if isChecked("Maim") and cast.able.maim() then
    				for i=1, #enemies.yards5 do
                        thisUnit = enemies.yards5[i]
    					if canInterrupt(thisUnit,getOptionValue("InterruptAt")) and comboPoints > 0 and not buff.fieryRedMaimers.exists() then --and isInPvP() then
    						if cast.maim(thisUnit) then return true end
		    			end
	            	end
	          	end
		 	end -- End useInterrupts check
            if isChecked("Debug Timers") then
                if profile.interrupts == nil then profile.interrupts = {} end
                local section = profile.interrupts
                if section.totalIterations == nil then section.totalIterations = 0 end
                if section.elapsedTime == nil then section.elapsedTime = 0 end
                section.currentTime = debugprofilestop()-startTime
                section.totalIterations = section.totalIterations + 1
                section.elapsedTime = section.elapsedTime + debugprofilestop()-startTime
                section.averageTime = section.elapsedTime / section.totalIterations
            end
		end -- End Action List - Interrupts
	-- Action List - Cooldowns
		local function actionList_SimC_Cooldowns()
            local startTime = debugprofilestop()
			if getDistance("target") < 5 then
        -- Prowl
                -- prowl,if=buff.incarnation.remains<0.5&buff.jungle_stalker.up
                if cast.able.prowl() and useCDs() and not buff.prowl.exists() and getDistance(units.dyn5) < 5 and not solo and friendsInRange then --findFriends() > 0 then
                    if cast.able.prowl() and (buff.incarnationKingOfTheJungle.remain() < 0.5 and buff.jungleStalker.exists()) then
                        if cast.prowl() then return true end
                    end
                end
		-- Berserk
				-- berserk,if=energy>=30&(cooldown.tigers_fury.remains>5|buff.tigers_fury.up)
	            if isChecked("Berserk/Incarnation") and cast.able.berserk() and useCDs() and not talent.incarnationKingOfTheJungle then
                    if cast.able.berserk() and (energy >= 30 and (cd.tigersFury.remain() > 5 or buff.tigersFury.exists())) then
                        if cast.berserk() then return true end
                    end
	            end
        -- Tiger's Fury
                -- tigers_fury,if=energy.deficit>=60
                if isChecked("Tiger's Fury") and cast.able.tigersFury() then
                    if cast.able.tigersFury() and (energyDeficit >= 60 or snipeTF()) then
                        if cast.tigersFury() then return true end
                    end
                end
        -- Racial: Berserking (Troll)
                -- berserking
                if isChecked("Racial") and cast.able.racial() and useCDs() and race == "Troll" then
                    if cast.racial() then return true end
                end
        -- Feral Frenzy
                -- feral_frenzy,if=combo_points=0
                if cast.able.feralFrenzy() and (comboPoints == 0) then
                    if cast.feralFrenzy() then return true end
                end
        -- Incarnation - King of the Jungle
                -- incarnation,if=energy>=30&(cooldown.tigers_fury.remains>15|buff.tigers_fury.up)
                if isChecked("Berserk/Incarnation") and cast.able.incarnationKingOfTheJungle() and useCDs() and talent.incarnationKingOfTheJungle then
                    if (energy >= 30 and (cd.tigersFury.remain() > 15 or buff.tigersFury.exists())) then
                        if cast.incarnationKingOfTheJungle() then return true end
                    end
                end
        -- Prowl
                -- if useCDs() and talent.incarnationKingOfTheJungle and buff.incarnationKingOfTheJungle.exists() and freeProwl and not buff.prowl.exists() and not solo and friendsInRange > 0 then
                --     if cast.prowl() then freeProwl = false; return true end
                -- end
        -- Potion
                -- potion,name=prolonged_power,if=target.time_to_die<65|(time_to_die<180&(buff.berserk.up|buff.incarnation.up))
                if isChecked("Potion") and (use.able.potionOfTheOldWar() or use.able.potionOfProlongedPower()) and useCDs() and inRaid then
                    if (ttd(units.dyn5) < 65 or (ttd(units.dyn5) < 180 and (buff.berserk.exists() or buff.incarnationKingOfTheJungle.exists()))) then
                        if getOptionValue("Potion") == 1 and use.able.potionOfTheOldWar() then
                            use.potionOfTheOldWar()
                        elseif getOptionValue("Potion") == 2 and use.able.potionOfProlongedPower() then
                            use.potionOfProlongedPower()
                        end
                    end
                end
        -- Shadowmeld
                -- shadowmeld,if=combo_points<5&energy>=action.rake.cost&dot.rake.pmultiplier<2.1&buff.tigers_fury.up&(buff.bloodtalons.up|!talent.bloodtalons.enabled)&(!talent.incarnation.enabled|cooldown.incarnation.remains>18)&!buff.incarnation.up
                if isChecked("Racial") and cast.able.shadowmeld() and useCDs() and race == "NightElf" and getDistance(units.dyn5) < 5 and not solo and friendsInRange then --findFriends() > 0 then
                    if (comboPoints < 5 and energy >= cast.cost.rake() and debuff.rake.applied(units.dyn5) < 2.1 and buff.tigersFury.exists() and (buff.bloodtalons.exists() or not talent.bloodtalons)
                        and (not talent.incarnationKingOfTheJungle or cd.incarnationKingOfTheJungle.remain() > 18) and not buff.incarnationKingOfTheJungle.exists())
                    then
                        if cast.shadowmeld() then return true end
                    end
                end
        -- Trinkets
                -- if=buff.tigers_fury.up&energy.time_to_max>3&(!talent.savage_roar.enabled|buff.savage_roar.up)
                if (use.able.slot(13) or use.able.slot(14)) and (buff.tigersFury.exists() or ttd(units.dyn5) <= cd.tigersFury.remain()) and (not talent.savageRoar or buff.savageRoar.exists()) then
                    if (getOptionValue("Trinkets") == 1 or (getOptionValue("Trinkets") == 2 and useCDs())) and getDistance(units.dyn5) < 5 then
                        for i = 13, 14 do
                            if use.able.slot(i) and not (equiped.vialOfCeaselessToxins(i) or equiped.umbralMoonglaives(i) or equiped.draughtOfSouls(i) or equiped.specterOfBetrayal(i)) then
                                use.slot(i)
                            end
                        end
                    end
                end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury,buff.tigers_fury | arcane_torrent,buff.tigers_fury
                if isChecked("Racial") and cast.able.racial() and useCDs() and (br.player.race == "Orc" or br.player.race == "BloodElf") then
                    if buff.tigersFury.exists() then
                        if cast.racial("player") then return true end
                    end
                end
            end -- End useCooldowns check
            if isChecked("Debug Timers") then
                if profile.cooldownsSimC == nil then profile.cooldownsSimC = {} end
                local section = profile.cooldownsSimC
                if section.totalIterations == nil then section.totalIterations = 0 end
                if section.elapsedTime == nil then section.elapsedTime = 0 end
                section.currentTime = debugprofilestop()-startTime
                section.totalIterations = section.totalIterations + 1
                section.elapsedTime = section.elapsedTime + debugprofilestop()-startTime
                section.averageTime = section.elapsedTime / section.totalIterations
            end
        end -- End Action List - Cooldowns
        local function actionList_AMR_Cooldowns()
            local startTime = debugprofilestop()
            if getDistance("target") < 5 then
        -- Tiger's Fury
                -- if (not HasBuff(Clearcasting) and PowerToMax >= 60) or PowerToMax >= 80
                if isChecked("Tiger's Fury") and cast.able.tigersFury() then
                    if (not buff.clearcasting.exists() and energyDeficit >= 60) or energyDeficit >= 80 or snipeTF() then
                        if cast.tigersFury() then return true end
                    end
                end
        -- Incarnation - King of the Jungle
                -- if HasBuff(TigersFury)
                if useCDs() and isChecked("Berserk/Incarnation") and cast.able.incarnationKingOfTheJungle() then
                    if buff.tigersFury.exists() and talent.incarnationKingOfTheJungle then
                        if cast.incarnationKingOfTheJungle() then return true end
                    end
                end
        -- Berserk
                -- if HasBuff(TigersFury)
                if useCDs() and isChecked("Berserk/Incarnation") and cast.able.berserk() then
                    if buff.tigersFury.exists() and not talent.incarnationKingOfTheJungle then
                        if cast.berserk() then return true end
                    end
                end
                if buff.tigersFury.exists() or buff.incarnationKingOfTheJungle.remain() > 20 or ttd(units.dyn5) < 30 then
        -- Potion
                    -- if HasBuff(Berserk) or FightSecRemaining < BuffDurationSec(PotionOfProlongedPower) + 5
                    -- if HasBuff(Berserk) or FightSecRemaining < BuffDurationSec(PotionOfTheOldWar) + 5
                    if useCDs() and isChecked("Potion") and inRaid and (use.able.potionOfTheOldWar() or use.able.potionOfProlongedPower()) then
                        if ttd(units.dyn5) < 65 or buff.berserk.exists() or buff.incarnationKingOfTheJungle.exists() then
                            if getOptionValue("Potion") == 1 and use.able.potionOfTheOldWar() then
                                use.potionOfTheOldWar()
                            elseif getOptionValue("Potion") == 2 and use.able.potionOfProlongedPower() then
                                use.potionOfProlongedPower()
                            end
                        end
                    end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                    -- blood_fury,buff.tigers_fury | berserking,buff.tigers_fury | arcane_torrent,buff.tigers_fury
                    if useCDs() and isChecked("Racial") and cast.able.racial() and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                        if buff.tigersFury.exists() then
                            if cast.racial("player") then return true end
                        end
                    end
        -- Trinkets
                    if useCDs() and isChecked("Trinkets") and getDistance(units.dyn5) < 5 and (use.able.slot(13) or use.able.slot(14)) then
                        for i = 13, 14 do
                            if use.able.slot(i) and not (equiped.vialOfCeaselessToxins(i) or equiped.umbralMoonglaives(i) or equiped.draughtOfSouls(i) or equiped.specterOfBetrayal(i)) then
                                use.slot(i)
                            end
                        end
                    end
        -- Draught of Souls
                    -- if (HasBuff(SavageRoar) or not HasTalent(SavageRoar)) and PowerSecToMax > 3 and AlternatePowerToMax >= 1
                    if isChecked("Draught of Souls") and useCDs() and use.able.draughtOfSouls() then
                        if (buff.savageRoar.exists() or not talent.savageRoar) and ttm > 3 and comboPointsDeficit >= 1 then
                            use.draughtOfSouls()
                        end
                    end
        -- Umbral Moonglaives
                    -- is a cooldown saved for AoE - AoE count = 2 - AoE radius = 8
                    if isChecked("Umbral Moonglaives") and useCDs() and use.able.umbralMoonglaives() then
                        if (mode.rotation == 1 and #enemies.yards8 >= 2) or mode.rotation == 2 then
                            use.umbralMoonglaives()
                        end
                    end
        -- Vial of Ceaseless Toxins
                    -- if TargetsInRange = 1 or TargetSecUntilDeath < 20
                    if isChecked("Vial of Ceaseless Toxins") and use.able.vialOfCeaselessToxins() then
                        if (mode.rotation == 1 and #enemies.yards5 == 1) or mode.rotation == 3 or ttd(units.dyn5) < 20 then
                            use.vialOfCeaselessToxins()
                        end
                    end
        -- Ring of Collapsing Futures
                    -- use_item,slot=finger1
                    if isChecked("Ring of Collapsing Futures") and use.able.ringOfCollapsingFutures() then
                        if debuff.temptation.stack("player") < getOptionValue("Ring of Collapsing Futures") and not isInPvP() then
                            use.ringOfCollapsingFutures()
                        end
                    end
        -- Specter of Betrayal
                    if (getOptionValue("Specter of Betrayal") == 1 or (getOptionValue("Specter of Betrayal") == 2 and useCDs())) and use.able.specterOfBetrayal() then
                        use.specterOfBetrayal()
                    end
                end
        -- Prowl
                if useCDs() and cast.able.prowl() and talent.incarnationKingOfTheJungle and buff.incarnationKingOfTheJungle.exists() and freeProwl and not buff.prowl.exists() and not solo and friendsInRange then --findFriends() > 0 then
                    if cast.prowl() then freeProwl = false; return true end
                end
            end -- End useCooldowns check
            if isChecked("Debug Timers") then
                if profile.cooldownsAMR == nil then profile.cooldownsAMR = {} end
                local section = profile.cooldownsAMR
                if section.totalIterations == nil then section.totalIterations = 0 end
                if section.elapsedTime == nil then section.elapsedTime = 0 end
                section.currentTime = debugprofilestop()-startTime
                section.totalIterations = section.totalIterations + 1
                section.elapsedTime = section.elapsedTime + debugprofilestop()-startTime
                section.averageTime = section.elapsedTime / section.totalIterations
            end
        end -- End Action List - Cooldowns
    -- Action List - Opener
        function actionList_Opener()
            local startTime = debugprofilestop()
        -- Wild Charge
            if isChecked("Wild Charge") and cast.able.wildCharge("target") and isValidUnit("target") and getDistance("target") >= 8 and getDistance("target") < 30 then
                if cast.wildCharge("target") then return true end
            end
		-- Start Attack
            -- auto_attack
            if isChecked("Opener") and isBoss("target") and not opener then
                if isValidUnit("target") and getDistance("target") < 5 then
            -- Begin
					if not OPN1 then
                        Print("Starting Opener")
                        openerCount = openerCount + 1
                        OPN1 = true
                    elseif OPN1 and (not RK1 or not debuff.rake.exists("target")) then
            -- Rake
                        -- rake,if=!ticking|buff.prowl.up
                        if not debuff.rake.exists() or buff.prowl.exists() then
       					    if castOpener("rake","RK1",openerCount) then openerCount = openerCount + 1; return true end
                        else
                            Print(openerCount..": Rake (Uncastable)")
                            openerCount = openerCount + 1
                            RK1 = true
                        end
                    elseif RK1 and not MF1 then
            -- Moonfire
                        -- moonfire_cat,if=talent.lunar_inspiration.enabled&!ticking
                        if talent.lunarInspiration and not debuff.moonfireFeral.exists("target") then
                            if castOpener("moonfireFeral","MF1",openerCount) then openerCount = openerCount + 1; return true end
                        else
                            Print(openerCount..": Moonfire (Uncastable)")
                            openerCount = openerCount + 1
                            MF1 = true
                        end
                    elseif MF1 and not SR1 then
       		-- Savage Roar
                        -- savage_roar,if=!buff.savage_roar.up
                        if talent.savageRoar and buff.savageRoar.refresh() and comboPoints > 0 then
       					    if castOpener("savageRoar","SR1",openerCount) then openerCount = openerCount + 1; return true end
                        else
                            Print(openerCount..": Savage Roar (Uncastable)")
                            openerCount = openerCount + 1
                            SR1 = true
                        end
       				elseif SR1 and not BER1 then
          	-- Berserk
                        -- berserk
                        -- incarnation
						if useCDs() and isChecked("Berserk/Incarnation") then
                            if talent.incarnationKingOfTheJungle then
                                if castOpener("incarnationKingOfTheJungle","BER1",openerCount) then openerCount = openerCount + 1; return true end
                            else
                                if castOpener("berserk","BER1",openerCount) then openerCount = openerCount + 1; return true end
                            end
						else
							Print(openerCount..": Berserk/Incarnation (Uncastable)")
                            openerCount = openerCount + 1
							BER1 = true
						end
                    elseif BER1 and not TF1 then
            -- Tiger's Fury
                        -- tigers_fury
                        if isChecked("Tiger's Fury") then
                            if castOpener("tigersFury","TF1",openerCount) then openerCount = openerCount + 1; return true end
                        else
                            Print(openerCount..": Tiger's Fury (Uncastable)")
                            openerCount = openerCount + 1
                            TF1 = true
                        end
					elseif TF1 and not REG1 then
            -- Regrowth
                        -- regrowth,if=(talent.sabertooth.enabled|buff.predatory_swiftness.up)&talent.bloodtalons.enabled&buff.bloodtalons.down&combo_points=5
                        if (talent.sabertooth or buff.predatorySwiftness.exists()) and talent.bloodtalons and not buff.bloodtalons.exists() and comboPoints == 5 then
                            if castOpener("regrowth","REG1",openerCount) then openerCount = openerCount + 1; return true end
                        else
                            Print(openerCount..": Regrowth (Uncastable)")
                            openerCount = openerCount + 1;
                            REG1 = true
                        end
					elseif REG1 and not RIP1 then
       		-- Rip
                        -- rip,if=combo_points=5
                        if comboPoints == 5 then
					        if castOpener("rip","RIP1",openerCount) then openerCount = openerCount + 1; return true end
                        else
                            Print(openerCount..": Rip (Uncastable)")
                            openerCount = openerCount + 1;
                            RIP1 = true
                        end
                    elseif RIP1 and not THR1 then
            -- Thrash
                        -- thrash_cat,if=!ticking&variable.use_thrash>0
                        if not debuff.thrash.exists("target") and useThrash > 0 then
                            if castOpener("thrash","THR1",openerCount) then openerCount = openerCount + 1; return true end
                        else
                            Print(openerCount..": Thrash (Uncastable)")
                            openerCount = openerCount + 1;
                            THR1 = true
                        end
                    elseif THR1 and (not SHR1 or comboPoints < 5) then
            -- Brutal Slash / Shred
                        if talent.brutalSlash and charges.brutalSlash.exists() and getOptionValue("Brutal Slash in Opener") == 1 then
                            if castOpener("brutalSlash","SHR1",openerCount) then openerCount = openerCount + 1; return true end
                        else
                            if castOpener("shred","SHR1",openerCount) then openerCount = openerCount + 1; return true end
                        end
            -- Finish (rip exists)
                    elseif SHR1 and comboPoints == 5 then
                        Print("Opener Complete")
                        openerCount = 0
                        opener = true
                        return
       				end
                end
			elseif (UnitExists("target") and not isBoss("target")) or not isChecked("Opener") then
				opener = true
			end
            if isChecked("Debug Timers") then
                if profile.opener == nil then profile.opener = {} end
                local section = profile.opener
                if section.totalIterations == nil then section.totalIterations = 0 end
                if section.elapsedTime == nil then section.elapsedTime = 0 end
                section.currentTime = debugprofilestop()-startTime
                section.totalIterations = section.totalIterations + 1
                section.elapsedTime = section.elapsedTime + debugprofilestop()-startTime
                section.averageTime = section.elapsedTime / section.totalIterations
            end
        end -- End Action List - Opener
    -- Action List - Finisher
        local function actionList_SimC_Finisher()
            local startTime = debugprofilestop()
        -- Savage Roar
            -- pool_resource,for_next=1
            -- savage_roar,if=!buff.savage_roar.up
            if (cast.pool.savageRoar() or cast.able.savageRoar()) and not buff.savageRoar.exists() then
                if cast.pool.savageRoar() then ChatOverlay("Pooling For Savage Roar") return true end
                if cast.able.savageRoar() then
                    if cast.savageRoar("player") then return true end
                end
            end
        -- Rip
            -- pool_resource,for_next=1
            -- rip,target_if=!ticking|(remains<=duration*0.3)&(target.health.pct>25&!talent.sabertooth.enabled)|(remains<=duration*0.8&persistent_multiplier>dot.rip.pmultiplier)&target.time_to_die>8
            if (cast.pool.rip() or cast.able.rip()) and (buff.savageRoar.exists() or not talent.savageRoar) and debuff.rip.count() < 5 then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if getDistance(thisUnit) < 5 then
                            if (not debuff.rip.exists(thisUnit) or debuff.rip.refresh(thisUnit) and (thp(thisUnit) > 25 and not talent.sabertooth)
                                or (debuff.rip.remain(thisUnit) <= ripDuration * 0.8 and debuff.rip.calc() > debuff.rip.applied(thisUnit))) and (ttd(thisUnit) > 8 or isDummy(thisUnit))
                            then
                                if cast.pool.rip() then ChatOverlay("Pooling For Rip") return true end
                                if cast.able.rip(thisUnit) then
                                    if cast.rip(thisUnit) then return true end
                                end
                            end
                        end
                    end
                end
            end
        -- Savage Roar
            -- pool_resource,for_next=1
            -- savage_roar,if=buff.savage_roar.remains<12
            if (cast.pool.savageRoar() or cast.able.savageRoar()) and buff.savageRoar.remain() < 12 then
                if cast.pool.savageRoar() then ChatOverlay("Pooling For Savage Roar") return true end
                if cast.able.savageRoar() then
                    if cast.savageRoar("player") then return true end
                end
            end
        -- Maim
            -- pool_resource,for_next=1
            -- maim,if=buff.iron_jaws.up
            if (cast.pool.maim() or cast.able.maim()) and (buff.ironJaws.exists()) then
                if cast.pool.main() then ChatOverlay("Pooling For Maim") return true end
                if cast.able.maim() then 
                    if cast.maim() then return true end
                end
            end
        -- Ferocious Bite
            -- ferocious_bite,max_energy=1
            if cast.able.ferociousBite() and fbMaxEnergy and (buff.savageRoar.remain() >= 12 or not talent.savageRoar)
                and (not debuff.rip.refresh(units.dyn5) or thp(units.dyn5) <= 25 or ferociousBiteFinish() or level < 20 or (ttd(units.dyn5) <= 8 and debuff.rip.refresh(units.dyn5)))
            then
                if cast.ferociousBite() then return true end
            end
            if isChecked("Debug Timers") then
                if profile.finisherSimC == nil then profile.finisherSimC = {} end
                local section = profile.finisherSimC
                if section.totalIterations == nil then section.totalIterations = 0 end
                if section.elapsedTime == nil then section.elapsedTime = 0 end
                section.currentTime = debugprofilestop()-startTime
                section.totalIterations = section.totalIterations + 1
                section.elapsedTime = section.elapsedTime + debugprofilestop()-startTime
                section.averageTime = section.elapsedTime / section.totalIterations
            end
        end
    -- Action List - Finisher
        local function actionList_AMR_Finisher()
            local startTime = debugprofilestop()
        -- Rip
            -- if (AlternatePower * FeralBleedSnapshot) > PeekSavedValue(RipBuffs) and (HasBuff(SavageRoar) or not HasTalent(SavageRoar)) and TargetSecRemaining > DotIntervalSec(Rip) * 4
            if cast.able.rip() and debuff.rip.calc() > debuff.rip.applied(units.dyn5) and (buff.savageRoar.exists() or not talent.savageRoar) and ttd(units.dyn5) > 2 * 4 then
                if cast.rip() then return true end
            end
        -- Ferocious Bite
            -- if HasDot(Rip) and (HasTalent(Sabertooth) or TargetHealthPercent < 0.25) and (HasBuff(SavageRoar) or not HasTalent(SavageRoar))
            if cast.able.ferociousBite() and (debuff.rip.exists(units.dyn5) or level < 20)
                and (talent.sabertooth or thp(units.dyn5) < 25 or ttd(units.dyn5) < ttm)
                and (buff.savageRoar.exists() or not talent.savageRoar)
            then
                if cast.ferociousBite() then return true end
            end
        -- Rip
            -- if CanRefreshDot(Rip) and (HasBuff(SavageRoar) or not HasTalent(SavageRoar)) and not HasTalent(Sabertooth) and
            -- TargetSecRemaining - DotRemainingSec(Rip) > DotIntervalSec(Rip) * 2
            -- multi-DoT = 5
            if cast.able.rip() and debuff.rip.count() < 5 then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if debuff.rip.refresh(thisUnit) and (buff.savageRoar.exists() or not talent.savageRoar) and not talent.sabertooth
                            and ttd(thisUnit) - debuff.rip.remain(thisUnit) > 2 * 2
                        then
                            if cast.rip(thisUnit) then return true end
                        end
                    end
                end
            end
        -- Savage Roar
            -- if BuffRemainingSec(SavageRoar) <= 12
            if cast.able.savageRoar() and buff.savageRoar.remain() <= 12 then
                if cast.savageRoar("player") then return true end
            end
        -- Maim
            -- if HasBuff(FieryRedMaimers)
            if cast.able.maim() and buff.fieryRedMaimers.exists() then
                if cast.maim() then return true end
            end
        -- Ferocious Bite
            -- if Power >= FerociousBiteMaxEnergy or HasBuff(ApexPredator)
            if cast.able.ferociousBite() and (fbMaxEnergy or buff.apexPredator.exists()) then
                if cast.ferociousBite() then return true end
            end
            if isChecked("Debug Timers") then
                if profile.finisherAMR == nil then profile.finisherAMR = {} end
                local section = profile.finisherAMR
                if section.totalIterations == nil then section.totalIterations = 0 end
                if section.elapsedTime == nil then section.elapsedTime = 0 end
                section.currentTime = debugprofilestop()-startTime
                section.totalIterations = section.totalIterations + 1
                section.elapsedTime = section.elapsedTime + debugprofilestop()-startTime
                section.averageTime = section.elapsedTime / section.totalIterations
            end
        end -- End Action List - Finisher
    -- Action List - AOE
        local function actionList_AMR_AOE()
            local startTime = debugprofilestop()
        -- Thrash
            -- if CanRefreshDot(ThrashBleedFeral) and HasSetBonus(19,2)
            if cast.able.thrash() and debuff.thrash.refresh() and equiped.t19 >= 2 then
                if cast.thrash("player","aoe") then return true end
            end
        -- Brutal Slash
            -- if not CanRefreshDot(ThrashBleedFeral) or not HasSetBonus(19,2)
            if cast.able.brutalSlash() and (not debuff.thrash.refresh() or not equiped.t19 >= 2) and talent.brutalSlash then
                if cast.brutalSlash("player","aoe") then return true end
            end
        -- Thrash
            -- if HasItem(LuffaWrappings)
            if cast.able.thrash() and equiped.luffaWrappings() then
                if cast.thrash("player","aoe") then return true end
            end
        -- Swipe
            -- if not CanRefreshDot(ThrashBleedFeral) or not HasSetBonus(19,2)
            if cast.able.swipe() and (not debuff.thrash.refresh() or not equiped.t19 >= 2) and not talent.brutalSlash then
                if cast.swipe("player","aoe") then return true end
            end
            if isChecked("Debug Timers") then
                if profile.aoeAMR == nil then profile.aoeAMR = {} end
                local section = profile.aoeAMR
                if section.totalIterations == nil then section.totalIterations = 0 end
                if section.elapsedTime == nil then section.elapsedTime = 0 end
                section.currentTime = debugprofilestop()-startTime
                section.totalIterations = section.totalIterations + 1
                section.elapsedTime = section.elapsedTime + debugprofilestop()-startTime
                section.averageTime = section.elapsedTime / section.totalIterations
            end
        end -- End Action List - AOE
    -- Action List - Generator
        local function actionList_SimC_Generator()
            local startTime = debugprofilestop()
    -- Regrowth
            -- regrowth,if=talent.bloodtalons.enabled&buff.bloodtalons.down&buff.predatory_swiftness.up&combo_points=4&dot.rake.remains<4
            -- regrowth,if=talent.bloodtalons.enabled&buff.bloodtalons.down&buff.predatory_swiftness.up&talent.lunar_inspiration.enabled&dot.rake.remains<1
            if cast.able.regrowth() and talent.bloodtalons and not buff.bloodtalons.exists() and buff.predatorySwiftness.exists() then
                if (comboPoints == 4 and debuff.rake.remain(units.dyn5) < 4) or (talent.lunarInspiration and debuff.rake.remain(units.dyn5) < 1) then
                    if getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40 then
                        if cast.regrowth(br.friend[1].unit) then return true end
                    end
                    if getOptionValue("Auto Heal")==2 then
                        if cast.regrowth("player") then return true end
                    end
                end
            end
        -- Brutal Slash
            -- brutal_slash,if=spell_targets.brutal_slash>desired_targets
            if cast.able.brutalSlash() and talent.brutalSlash and ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Brutal Slash Targets")) or mode.rotation == 2) then
                if cast.brutalSlash("player","aoe",getOptionValue("Brutal Slash Targets")) then return true end
            end
        -- Thrash
            -- pool_resource,for_next=1
            -- thrash_cat,if=refreshable&(spell_targets.thrash_cat>2)
            if (cast.pool.thrash() or cast.able.thrash()) then --and multidot then
                if (not debuff.thrash.exists(units.dyn8AOE) or debuff.thrash.refresh(units.dyn8AOE)) and ((mode.rotation == 1 and #enemies.yards8 > 2) or mode.rotation == 2) then
                    if cast.pool.thrash() then ChatOverlay("Pooling For Thrash: "..#enemies.yards8.." targets") return true end
                    if cast.able.thrash() then
                        if cast.thrash("player","aoe") then return true end
                    end
                end
            end
        -- Rake
            -- pool_resource,for_next=1
            -- rake,target_if=!ticking|(!talent.bloodtalons.enabled&remains<duration*0.3)&target.time_to_die>4
            -- rake,target_if=talent.bloodtalons.enabled&buff.bloodtalons.up&((remains<=7)&persistent_multiplier>dot.rake.pmultiplier*0.85)&target.time_to_die>4
            if (cast.pool.rake() or cast.able.rake()) and debuff.rake.count() < 3 then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot)) and (ttd(thisUnit) > 4 or isDummy(thisUnit)) then
                        if (not debuff.rake.exists(thisUnit) or (not talent.bloodtalons and debuff.rake.refresh(thisUnit)))
                            or (talent.bloodtalons and buff.bloodtalons.exists() and debuff.rake.remain(thisUnit) <= 7 and debuff.rake.calc() > debuff.rake.applied(thisUnit) * 0.85)
                        then
                            if cast.pool.rake() then ChatOverlay("Pooling For Rake") return true end
                            if cast.able.rake(thisUnit) then
                                if cast.rake(thisUnit) then return true end
                            end
                        end
                    end
                end
            end
        -- Moonfire
            -- moonfire_cat,if=buff.bloodtalons.up&buff.predatory_swiftness.down&combo_points<5
            if cast.able.moonfireFeral() and talent.lunarInspiration and debuff.moonfireFeral.count() < 5 then
                if buff.bloodtalons.exists() and not buff.predatorySwiftness.exists() and comboPoints < 5 then
                    if cast.moonfireFeral() then return end
                end
            end
        -- Brutal Slash
            -- brutal_slash,if=(buff.tigers_fury.up&(raid_event.adds.in>(1+max_charges-charges_fractional)*recharge_time))
            --if talent.brutalSlash and ((buff.tigersFury.exists() and charges.brutalSlash.timeTillFull() < gcdMax)
            --    or (charges.brutalSlash.recharge(true) < cd.tigersFury.remain()))
            if cast.able.brutalSlash() and talent.brutalSlash and ((buff.tigersFury.exists() and getOptionValue("Brutal Slash Targets") == 1)
                or ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Brutal Slash Targets")) or mode.rotation == 2)
                or charges.brutalSlash.timeTillFull() < gcdMax)
            then
                if cast.able.regrowth() and talent.bloodtalons and not buff.bloodtalons.exists() and equiped.ailuroPouncers() and buff.predatorySwiftness.stack() > 0 then
                    if getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40 then
                        cast.regrowth(br.friend[1].unit)
                    end
                    if getOptionValue("Auto Heal")==2 then
                        cast.regrowth("player")
                    end
                end
                if cast.brutalSlash("player","aoe") then return true end
            end
        -- Moonfire
            -- moonfire_cat,target_if=refreshable
            if cast.able.moonfireFeral() and talent.lunarInspiration and debuff.moonfireFeral.count() < 5 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                        if debuff.moonfireFeral.refresh(thisUnit) then --or (isDummy(thisUnit) and getDistance(thisUnit) < 8) then
                           if cast.moonfireFeral(thisUnit) then return true end
                        end
                    end
                end
            end
        -- Thrash
            -- pool_resource,for_next=1
            -- thrash_cat,if=refreshable&((variable.use_thrash=2&(!buff.incarnation.up|azerite.wild_fleshrending.enabled))|spell_targets.thrash_cat>1)
            -- thrash_cat,if=refreshable&variable.use_thrash=1&buff.clearcasting.react&(!buff.incarnation.up|azerite.wild_fleshrending.enabled)
            if (cast.pool.thrash() or cast.able.thrash()) --[[and multidot]] and debuff.thrash.refresh(units.dyn8AOE) then
                if (useThrash == 2 and (not buff.incarnationKingOfTheJungle.exists() or trait.wildFleshrending.active())) or ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0)) 
                    or (useThrash == 1 and buff.clearcasting.exists() and (not buff.incarnationKingOfTheJungle.exists() or trait.wildFleshrending.active())) 
                then
                    if cast.pool.thrash() and not buff.clearcasting.exists() then ChatOverlay("Pooling For Thrash") return true end
                    if cast.able.thrash() or buff.clearcasting.exists() then
                        if cast.thrash("player","aoe") then return true end
                    end
                end
            end
        -- Swipe
            -- pool_resource,for_next=1
            -- swipe_cat,if=spell_targets.swipe_cat>1
            if (cast.pool.swipe() or cast.able.swipe()) and not talent.brutalSlash --and multidot
                and ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0))
            then
                if cast.pool.swipe() then ChatOverlay("Pooling For Swipe") return true end
                if cast.able.swipe() then
                    if cast.swipe("player","aoe") then return true end
                end
            end
        -- Shred
            -- shred,if=buff.clearcasting.react
            if cast.able.shred() and buff.clearcasting.exists() then
                if cast.shred() then return end
            end
        -- Moonfire
            -- moonfire_cat,if=azerite.power_of_the_moon.enabled&!buff.incarnation.up
            -- if cast.able.moonfire() and talent.lunarInspiration and trait.powerOfTheMoon.active() and not buff.incarnationKingOfTheJungle.exists() then
            --     if cast.moonfire() then return end
            -- end
        -- Shred
            -- shred,if=dot.rake.remains>(action.shred.cost+action.rake.cost-energy)%energy.regen|buff.clearcasting.react
            if cast.able.shred() and debuff.rake.exists(units.dyn5) and (debuff.rake.remain(units.dyn5) > ((cast.cost.shred() + cast.cost.rake() - energy) / energyRegen) or buff.clearcasting.exists() or level < 12) then
                if cast.shred() then return true end
            end
            -- shred
            -- if cast.able.shred() and (not debuff.rake.refresh(units.dyn5) or level < 12)
            --     and ((talent.brutalSlash and (not charges.brutalSlash.exists() or not cast.safe.brutalSlash("player",8,getOptionValue("Brutal Slash Targets"))
            --         or (charges.brutalSlash.timeTillFull() >= gcdMax and not buff.tigersFury.exists() and #enemies.yards8 < getOptionValue("Brutal Slash Targets"))
            --         or (mode.rotation == 1 and #enemies.yards8 < getOptionValue("Brutal Slash Targets")) or mode.rotation == 3))
            --         or (not talent.brutalSlash and ((mode.rotation == 1 and #enemies.yards8 == 1) or mode.rotation == 3 or not cast.safe.swipe("player",8,2) or level < 32))
            --         or buff.clearcasting.exists())
            -- then
            --     if cast.shred() then return true end
            -- end
            if isChecked("Debug Timers") then
                if profile.generatorSimC == nil then profile.generatorSimC = {} end
                local section = profile.generatorSimC
                if section.maxTime == nil then section.maxTime = 0 end
                if section.totalIterations == nil then section.totalIterations = 0 end
                if section.elapsedTime == nil then section.elapsedTime = 0 end
                section.currentTime = debugprofilestop()-startTime
                section.maxTime = math.max(section.currentTime,section.maxTime)
                section.totalIterations = section.totalIterations + 1
                section.elapsedTime = section.elapsedTime + debugprofilestop()-startTime
                section.averageTime = section.elapsedTime / section.totalIterations
            end
            return false
        end
    -- Action List - Generator
        local function actionList_AMR_Generator()
            local startTime = debugprofilestop()
        -- Regrowth
            -- if CanRefreshDot(RakeBleed) and HasBuff(PredatorySwiftness) and not HasBuff(Bloodtalons) and HasTalent(Bloodtalons) and AlternatePower >= 4
            if cast.able.rake() and debuff.rake.refresh(units.dyn5) and buff.predatorySwiftness.exists() and not buff.bloodtalons.exists() and talent.bloodtalons and comboPoints >= 4 then
                if getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40 then
                    if cast.regrowth(br.friend[1].unit) then return true end
                end
                if getOptionValue("Auto Heal")==2 then
                    if cast.regrowth("player") then return true end
                end
            end
        -- Shadowmeld
            -- if HasBuff(TigersFury) and (HasBuff(SavageRoar) or not HasTalent(SavageRoar)) and (HasBuff(Bloodtalons) or not HasTalent(Bloodtalons)) and CanUse(Rake) and not HasBuff(IncarnationKingOfTheJungle)
            if isChecked("Racial") and cast.able.shadowmeld() and br.player.race == "NightElf" and getDistance(units.dyn5) < 5 and not solo and friendsInRange then --findFriends() > 0 then
                if buff.tigersFury.exists() and (buff.savageRoar.exists() or not talent.savageRoar)
                    and (buff.bloodtalons.exists() or not talent.bloodtalons)
                    and cast.able.rake() and not buff.incarnationKingOfTheJungle.exists()
                then
                    if cast.shadowmeld() then return true end
                end
            end
        -- Rake
            -- if not HasDot(RakeBleed)
            if cast.able.rake() and not debuff.rake.exists(units.dyn5) then
                if cast.rake() then return true end
            end
            -- if not HasTalent(Bloodtalons) and CanRefreshDot(RakeBleed)
            -- multi-DoT = 3
            if cast.able.rake() and debuff.rake.count() < 3 then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if not talent.bloodtalons and debuff.rake.refresh(thisUnit) then
                            if cast.rake(thisUnit) then return true end
                        end
                    end
                end
            end
            -- if HasBuff(Bloodtalons) and CanRefreshDot(RakeBleed)
            if cast.able.rake() and buff.bloodtalons.exists() and debuff.rake.refresh(units.dyn5) then
                if cast.rake() then return true end
            end
        -- Brutal Slash
            -- if (not CanAoe(2,8) and (HasBuff(TigersFury) or HasBuff(Bloodtalons))) or
            -- (ChargesRemaining(BrutalSlash) >= 2 and ChargeSecRemaining(BrutalSlash) <= GlobalCooldownSec) or
            -- TargetsInRadius(BrutalSlash) > 1 or FightSecRemaining < ChargesRemaining(BrutalSlash) * SpellCooldownSec(BrutalSlash)
            if cast.able.brutalSlash() and talent.brutalSlash and ((#enemies.yards8 == 1 and (buff.tigersFury.exists() or buff.bloodtalons.exists()))
                or (charges.brutalSlash.count() >= 2 and charges.brutalSlash.recharge(true) <= gcdMax)
                or (#enemies.yards8 > 1 or ttd(units.dyn8) < charges.brutalSlash.count() * cd.brutalSlash))
            then
                if cast.brutalSlash(units.dyn8AOE,"aoe") then return true end
            end
        -- Moonfire
            -- if CanRefreshDot(MoonfireDoT) and HasDot(RakeBleed) and TargetSecUntilDeath > 10
            -- multi-DoT = 5
            if cast.able.moonfireFeral() and talent.lunarInspiration and debuff.moonfireFeral.count() < 5 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                        if (debuff.moonfireFeral.refresh(thisUnit) --[[or (isDummy(thisUnit) and getDistance(thisUnit) < 8)]]) and debuff.rake.exists(thisUnit) and (ttd(thisUnit) > 10 or (isDummy(thisUnit) and getDistance(thisUnit) < 8)) then
                           if cast.moonfireFeral(thisUnit) then return true end
                        end
                    end
                end
            end
        -- Thrash
            -- if TargetsInRadius(Thrash) >= 3 and CanRefreshDot(ThrashBleedFeral)
            if cast.able.thrash() then --and multidot then
                if ((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0)) and debuff.thrash.refresh(units.dyn8AOE) then
                    if cast.thrash("player","aoe") then return true end
                end
            end
        -- Swipe
            -- if TargetsInRadius(Swipe) >= 3 and not CanRefreshDot(ThrashBleedFeral)
            if cast.able.swipe() and not talent.brutalSlash --[[and multidot]] and not debuff.thrash.refresh(units.dyn8)
                and ((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0))
            then
                if cast.swipe("player","aoe") then return true end
            end
        -- Thrash
            -- if ArtifactTraitRank(ThrashingClaws) >= 4 and CanRefreshDot(ThrashBleedFeral) and HasItem(LuffaWrappings)
            if cast.able.thrash() and debuff.thrash.refresh(units.dyn8) and equiped.luffaWrappings() then
                if cast.thrash("player","aoe") then return true end
            end
            -- if HasSetBonus(19,4) and CanRefreshDot(ThrashBleedFeral) and HasBuff(Clearcasting) and not HasBuff(Bloodtalons)
            if cast.able.thrash() and equiped.t19 >= 4 and debuff.thrash.refresh(units.dyn8) and buff.clearcasting.exists() and not buff.bloodtalons.exists() then
                if cast.thrash("player","aoe") then return true end
            end
        -- Shred
            -- if TargetsInRadius(Swipe) < 3 and
            -- (DotRemainingSec(RakeBleed) > DotIntervalSec(RakeBleed) or PowerToMax < 1 or HasBuff(Clearcasting) or
            -- Power > SpellPowerCost(Shred) + SpellPowerCost(Rake) or HasTalent(Bloodtalons))
            if cast.able.shred() and (mode.rotation == 3 or #enemies.yards8 < 3 or level < 32)
                and ((debuff.rake.remain(units.dyn5) > 3 or level < 12) or ttm < 1 or buff.clearcasting.exists() or energy > cast.cost.shred() + cast.cost.rake() or talent.bloodtalons)
            then
                if cast.shred() then return true end
            end
            if isChecked("Debug Timers") then
                if profile.generatorAMR == nil then profile.generatorAMR = {} end
                local section = profile.generatorAMR
                if section.totalIterations == nil then section.totalIterations = 0 end
                if section.elapsedTime == nil then section.elapsedTime = 0 end
                section.currentTime = debugprofilestop()-startTime
                section.totalIterations = section.totalIterations + 1
                section.elapsedTime = section.elapsedTime + debugprofilestop()-startTime
                section.averageTime = section.elapsedTime / section.totalIterations
            end
        end
    -- Action List - PreCombat
        local function actionList_PreCombat()
            local startTime = debugprofilestop()
            if not inCombat and not (IsFlying() or IsMounted()) then
                if not stealth then
        -- Flask / Crystal
                    -- flask,type=flask_of_the_seventh_demon
                    if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheSeventhDemon.exists() and use.able.flaskOfTheSeventhDemon() then
                        if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                        if buff.felFocus.exists() then buff.felFocus.cancel() end
                        if use.flaskOfTheSeventhDemon() then return true end
                    end
                    if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and use.able.repurposedFelFocuser() and not buff.flaskOfTheSeventhDemon.exists() then
                        -- if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                        if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                        if use.repurposedFelFocuser() then return true end
                    end
                    if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and use.able.oraliusWhisperingCrystal() then
                        if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                        if buff.felFocus.exists() then buff.felFocus.cancel() end
                        if use.oraliusWhisperingCrystal() then return true end
                    end
        -- food,type=nightborne_delicacy_platte
        -- Lightforged/Defiled Augment Rune
                    -- augmentation,type=defiled
                    if isChecked("Augment Rune") and not buff.defiledAugmentation.exists() and (use.able.lightforgedAugmentRune() or use.able.defiledAugmentRune()) then
                        if use.able.lightforgedAugmentRune() then
                            if use.lightforgedAugmentRune() then return true end
                        end
                        if use.able.defiledAugmentRune() then
                            if use.defiledAugmentRune() then return true end
                        end
                    end
        -- Prowl - Non-PrePull
                    if cast.able.prowl("player") and cat and autoProwl() and mode.prowl == 1 and not buff.prowl.exists() and not IsResting() and GetTime()-leftCombat > lootDelay then
                        if cast.prowl("player") then return true end
                    end
                end -- End No Stealth
        -- Wild Charge
                if isChecked("Displacer Beast / Wild Charge") and cast.able.wildCharge("target") and isValidUnit("target") then
                    if cast.wildCharge("target") then return true end
                end
                if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
        -- Regrowth
                    -- regrowth,if=talent.bloodtalons.enabled
                    if cast.able.regrowth("player") and talent.bloodtalons and not buff.bloodtalons.exists() and (htTimer == nil or htTimer < GetTime() - 1) then
                        if GetShapeshiftForm() ~= 0 then
                            -- CancelShapeshiftForm()
                            RunMacroText("/CancelForm")
                            if cast.regrowth("player") then htTimer = GetTime(); return true end
                        else
                            if cast.regrowth("player") then htTimer = GetTime(); return true end
                        end
                    end
        -- Prowl
                    if cast.able.prowl("player") and buff.bloodtalons.exists() and mode.prowl == 1 and not buff.prowl.exists() then
                        if cast.prowl("player") then return true end
                    end
                    if buff.prowl.exists() then
        -- Pre-pot
                        -- potion,name=old_war
                        if useCDs() and isChecked("Potion") and inRaid and (use.able.potionOfTheOldWar() or use.able.potionOfProlongedPower()) then
                            if getOptionValue("Potion") == 1 and use.able.potionOfTheOldWar() then
                                use.potionOfTheOldWar()
                            elseif getOptionValue("Potion") == 2 and use.able.potionOfProlongedPower() then
                                use.potionOfProlongedPower()
                            end
                        end
                    end -- End Prowl
                end -- End Pre-Pull
        -- Rake/Shred
                -- buff.prowl.up|buff.shadowmeld.up
                if isValidUnit("target") and opener and getDistance("target") < 5 then
                    if cast.able.shred() and level < 12 then
                        if cast.shred("target") then return true end
                    elseif cast.able.rake() then
                       if cast.rake("target") then return true end
                    end
                end
            end -- End No Combat
        -- Opener
            if actionList_Opener() then return true end
            if isChecked("Debug Timers") then
                if profile.preCombat == nil then profile.preCombat = {} end
                local section = profile.preCombat
                if section.totalIterations == nil then section.totalIterations = 0 end
                if section.elapsedTime == nil then section.elapsedTime = 0 end
                section.currentTime = debugprofilestop()-startTime
                section.totalIterations = section.totalIterations + 1
                section.elapsedTime = section.elapsedTime + debugprofilestop()-startTime
                section.averageTime = section.elapsedTime / section.totalIterations
            end
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
            if actionList_Extras() then return true end
--------------------------
--- Defensive Rotation ---
--------------------------
            if actionList_Defensive() then return true end
------------------------------
--- Out of Combat Rotation ---
------------------------------
            if actionList_PreCombat() then return true end
			-- if actionList_Opener() then return true end
--------------------------
--- In Combat Rotation ---
--------------------------
        -- Cat is 4 fyte!
            if inCombat and cast.able.catForm("player") and not cat and #enemies.yards5 > 0 and not moving and isChecked("Auto Shapeshifts") then
                if cast.catForm("player") then return true end
            elseif inCombat and cat and profileStop==false and not isChecked("Death Cat Mode") and isValidUnit(units.dyn5) and opener then
		-- Opener
				-- if actionList_Opener() then return true end
        -- Wild Charge
                -- wild_charge
                if isChecked("Displacer Beast / Wild Charge") and cast.able.wildCharge("player") and isValidUnit("target") then
                    if cast.wildCharge("target") then return true end
                end
        -- Displacer Beast
                -- displacer_beast,if=movement.distance>10
        -- Dash/Worgen Racial
                -- dash,if=movement.distance&buff.displacer_beast.down&buff.wild_charge_movement.down
        -- Rake/Shred from Stealth
                -- rake,if=buff.prowl.up|buff.shadowmeld.up
                if (buff.prowl.exists() or buff.shadowmeld.exists()) and getDistance("target") < 5 then
                    -- if debuff.rake.exists(units.dyn5) or level < 12 then
                    if cast.able.rake() and debuff.rake.calc() > debuff.rake.applied(units.dyn5) * 0.85 and level >= 12 then
                        if cast.rake(units.dyn5) then return true end
                    elseif cast.able.shred() then
                        if cast.shred(units.dyn5) then return true end
                    end
                elseif not (buff.prowl.exists() or buff.shadowmeld.exists()) and getDistance("target") < 5 then
                    -- auto_attack
                    if not IsAutoRepeatSpell(GetSpellInfo(6603)) and getDistance(units.dyn5) < 5 then
                        StartAttack(units.dyn5)
                    end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                    if actionList_Interrupts() then return true end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                    if getOptionValue("APL Mode") == 1 then
                        local startTimeSimC = debugprofilestop()
        -- Call Action List - Cooldowns
                        if actionList_SimC_Cooldowns() then return true end
        -- Ferocious Bite
                        -- ferocious_bite,target_if=dot.rip.ticking&dot.rip.remains<3&target.time_to_die>10&(target.health.pct<25|talent.sabertooth.enabled)
                        if cast.able.ferociousBite() and (debuff.rip.exists(units.dyn5) and debuff.rip.remain(units.dyn5) < 3
                            and ttd(units.dyn5) > 10 and (thp(units.dyn5) < 25 or talent.sabertooth))
                        then
                            if cast.ferociousBite() then return true end
                        end
        -- Regrowth
                        -- regrowth,if=combo_points=5&buff.predatory_swiftness.up&talent.bloodtalons.enabled&buff.bloodtalons.down&(!buff.incarnation.up|dot.rip.remains<8)
                        if cast.able.regrowth() and (comboPoints == 5 and buff.predatorySwiftness.exists() and talent.bloodtalons
                            and not buff.bloodtalons.exists() and (not buff.incarnationKingOfTheJungle.exists() or debuff.rip.remain(units.dyn5) < 8))
                        then
                            if getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40 then
                                if cast.regrowth(br.friend[1].unit) then return true end
                            end
                            if getOptionValue("Auto Heal")==2 then
                                if cast.regrowth("player") then return true end
                            end
                        end
        -- Call Action List - Finisher
                        -- call_action_list,name=finisher
                        if comboPoints > 4 then
                            if actionList_SimC_Finisher() then return true end
                        end
        -- Call Action List - Generator
                        -- call_action_list,name=generator
                        if comboPoints <= 4 then
                            if actionList_SimC_Generator() then return true end
                        end
                        if isChecked("Debug Timers") then
                            if profile.combatSimC == nil then profile.combatSimC = {} end
                            local section = profile.combatSimC
                            if section.totalIterations == nil then section.totalIterations = 0 end
                            if section.elapsedTime == nil then section.elapsedTime = 0 end
                            section.currentTime = debugprofilestop()-startTimeSimC
                            section.totalIterations = section.totalIterations + 1
                            section.elapsedTime = section.elapsedTime + debugprofilestop()-startTimeSimC
                            section.averageTime = section.elapsedTime / section.totalIterations
                        end
                    end -- End SimC APL
    ------------------------
    --- Ask Mr Robot APL ---
    ------------------------
                    if getOptionValue("APL Mode") == 2 then
                        local startTimeAMR = debugprofilestop()

    -----------------------------
    --- In Combat - Cooldowns ---
    -----------------------------
        -- Tiger's Fury
                        -- if (not HasBuff(Clearcasting) and PowerToMax >= 60) or PowerToMax >= 80
                        if cast.able.tigersFury() and (not buff.clearcasting.exists() and energyDeficit >= 60) or energyDeficit >= 80 then
                            if cast.tigersFury() then return true end
                        end
        -- Incarnation
                        -- if HasBuff(TigersFury)
                        if cast.able.incarnationKingOfTheJungle() and talent.incarnationKingOfTheJungle and useCDs() and buff.tigersFury.exists() then
                            if cast.incarnationKingOfTheJungle() then return true end
                        end
        -- Berserk
                        -- if HasBuff(TigersFury)
                        if cast.able.berserk() and not talent.incarnationKingOfTheJungle and useCDs() and buff.tigersFury.exists() then
                            if cast.berserk() then return true end
                        end
        -- Cooldowns
                        -- if HasBuff(TigersFury) or BuffRemainingSec(IncarnationKingOfTheJungle) > 20 or FightSecRemaining < 30
                        if useCDs() and (buff.tigersFury.exists() or buff.incarnationKingOfTheJungle.remain() > 20 or ttd(units.dyn5) < 30) then
                            if actionList_AMR_Cooldowns() then return true end
                        end
        -- Elune's Guidance
                        -- if AlternatePower <= 1 and Power >= FerociousBiteMaxEnergy
                        if cast.able.elunesGuidance() and comboPoints <= 1 and fbMaxEnergy then
                            if cast.elunesGuidance() then return true end
                        end
        -- Ferocious Bite
                        -- if HasDot(Rip) and DotRemainingSec(Rip) < DotIntervalSec(Rip) and TargetSecUntilDeath > 3 and (TargetHealthPercent < 0.25 or HasTalent(Sabertooth))
                        if cast.able.ferociousBite() and debuff.rip.exists(units.dyn5) and debuff.rip.remain(units.dyn5) < 2 and ttd(units.dyn5) > 3 and (thp(units.dyn5) < 25 or talent.sabertooth) then
                            if cast.ferociousBite() then return true end
                        end
        -- Regrowth
                        -- if HasTalent(Bloodtalons) and HasBuff(PredatorySwiftness) and not HasBuff(Bloodtalons) and
                        -- (AlternatePower >= 5 or BuffRemainingSec(PredatorySwiftness) <= GlobalCooldownSec)
                        if cast.able.regrowth() and talent.bloodtalons and buff.predatorySwiftness.exists() and not buff.bloodtalons.exists()
                            and (comboPoints >= 5 or buff.predatorySwiftness.remain() <= gcdMax)
                        then
                            if getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40 then
                                if cast.regrowth(br.friend[1].unit) then return true end
                            end
                            if getOptionValue("Auto Heal")==2 then
                                if cast.regrowth("player") then return true end
                            end
                        end
                        -- if HasItem(AiluroPouncers) and HasTalent(Bloodtalons) and not HasBuff(Bloodtalons) and BuffStack(PredatorySwiftness) > 1
                        if cast.able.regrowth() and equiped.ailuroPouncers() and talent.bloodtalons and not buff.bloodtalons.exists() and buff.predatorySwiftness.stack() > 1 then
                           if getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40 then
                                if cast.regrowth(br.friend[1].unit) then return true end
                            end
                            if getOptionValue("Auto Heal")==2 then
                                if cast.regrowth("player") then return true end
                            end
                        end
        -- Call Action List - Finisher
                        -- call_action_list,name=finisher
                        if comboPoints >= 5 then
                            if actionList_AMR_Finisher() then return true end
                        end
        -- Regrowth
                        -- if HasTalent(Bloodtalons) and HasBuff(PredatorySwiftness) and not HasBuff(Bloodtalons) and HasBuff(ApexPredator) and CanUse(FerociousBite)
                        if cast.able.regrowth() and talent.bloodtalons and buff.predatorySwiftness.exists() and not buff.bloodtalons.exists() and buff.apexPredator.exists() and cast.able.ferociousBite() then
                            if getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40 then
                                 if cast.regrowth(br.friend[1].unit) then return true end
                             end
                             if getOptionValue("Auto Heal")==2 then
                                 if cast.regrowth("player") then return true end
                             end
                         end
        -- Ferocious Bite
                        -- if HasBuff(ApexPredator)
                        if cast.able.ferociousBite() and buff.apexPredator.exists() then
                            if cast.ferociousBite() then return true end
                        end
        -- Call Action List - AOE
                        -- if TargetsInRadius(Swipe) >= 5 and AlternatePower <= 4
                        if ((mode.rotation == 1 and #enemies.yards8 >= 5) or mode.rotation == 2) and comboPoints <= 4 then
                            if actionList_AMR_AOE() then return true end
                        end
        -- Call Action List - Generator
                        -- if AlternatePower <= 4 and TargetsInRadius(Swipe) < 5
                        if comboPoints <= 4 and (#enemies.yards8 < 5 or mode.rotation == 3) then
                            if actionList_AMR_Generator() then return true end
                        end
                        if isChecked("Debug Timers") then
                            if profile.combatAMR == nil then profile.combatAMR = {} end
                            local section = profile.combatAMR
                            if section.totalIterations == nil then section.totalIterations = 0 end
                            if section.elapsedTime == nil then section.elapsedTime = 0 end
                            section.currentTime = debugprofilestop()-startTimeAMR
                            section.totalIterations = section.totalIterations + 1
                            section.elapsedTime = section.elapsedTime + debugprofilestop()-startTimeAMR
                            section.averageTime = section.elapsedTime / section.totalIterations
                        end
                    end
			    end -- End No Stealth | Rotation Off Check
			end --End In Combat
		end --End Rotation Logic
    -- end -- End Timer
    if isChecked("Debug Timers") then
        if profile.totalIterations == nil then profile.totalIterations = 0 end
        if profile.elapsedTime == nil then profile.elapsedTime = 0 end
        profile.currentTime = debugprofilestop()-startTime
        profile.totalIterations = profile.totalIterations + 1
        profile.elapsedTime = profile.elapsedTime + debugprofilestop()-startTime
        profile.averageTime = profile.elapsedTime / profile.totalIterations
    end
    -- ChatOverlay(averageTime)
end -- End runRotation
local id = 103
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

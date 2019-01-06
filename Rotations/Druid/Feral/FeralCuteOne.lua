local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.swipeCat },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.swipeCat },
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
        [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = br.player.spell.rake },
        [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = br.player.spell.rake }
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
        -- Ferocious Bite Execute
            br.ui:createDropdownWithout(section, "Ferocious Bite Execute",{"|cffFFFF00Enabled Notify","|cff00FF00Enabled","|cffFF0000Disabled"}, 2,"Options for using Ferocious Bite when the damage from it will kill the unit.")
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
        -- Soothe
            br.ui:createCheckbox(section,"Soothe")
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
        -- Auto-Heal
            br.ui:createDropdownWithout(section, "Auto Heal", { "|cffFFDD11LowestHP", "|cffFFDD11Player"},  1,  "|cffFFFFFFSelect Target to Auto-Heal")
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
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At (0 is random)")
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
        local multidot                                      = br.player.mode.cleave == 1 and br.player.mode.rotation < 3
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
        enemies.get(20,"player",true) -- makes enemies.yards20nc
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
            if not inCombat and not buff.prowl.exists() then
                if #enemies.yards20nc > 0 then
                    for i = 1, #enemies.yards20nc do
                        local thisUnit = enemies.yards20nc[i]
                        local react = GetUnitReaction(thisUnit,"player") or 10
                        if react < 4 and UnitIsEnemy("player",thisUnit) and UnitCanAttack("player",thisUnit) then return true end
                    end
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
            TF1 = false
            RK1 = false
            MF1 = false
            THR1  = false
            SHR1 = false
            REG1  = false
            TF2 = false
            RIP1 = false
            opener = false
        end

        -- Variables
        -- variable,name=use_thrash,value=0
        -- variable,name=use_thrash,value=2,if=azerite.wild_fleshrending.enabled
        if trait.wildFleshrending.active then
            useThrash = 2
        else
            useThrash = 0
        end     
        
        -- Multi-Dot HP Limit Set
        local function canDoT(unit)
            local unitHealthMax = UnitHealthMax(unit)
            if not isBoss() then return ((unitHealthMax > UnitHealthMax("player") * 3) or (UnitHealth(unit) < unitHealthMax and getTTD(unit) > 10)) end            
            local maxHealth = 0
            for i = 1, #enemies.yards5 do
                local thisMaxHealth = UnitHealthMax(enemies.yards5[i])
                if thisMaxHealth > maxHealth then 
                    maxHealth = thisMaxHealth 
                end 
            end 
            return unitHealthMax > maxHealth / 10
        end
        
        -- TF Predator Snipe
        local function snipeTF()
            if getOptionValue("Snipe Tiger's Fury") == 1 and talent.predator and not cd.tigersFury.exists() 
                and (#enemies.yards40 == 1 and ttd(units.dyn40) > ttm) or #enemies.yards40 > 1 
            then
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
                longestBleed = math.max(debuff.rake.remain(lowestUnit), debuff.rip.remain(lowestUnit), debuff.thrashCat.remain(lowestUnit), debuff.feralFrenzy.remain(lowestUnit))
                if ttd(lowestUnit) > 0 then timeTillDeath = ttd(lowestUnit) else timeTillDeath = 99 end
                if lowestUnit ~= nil and timeTillDeath < longestBleed then return true end
            end
            return false
        end

        local function ferociousBiteFinish(thisUnit)
            local desc = GetSpellDescription(spell.ferociousBite)
            local damage = 0
            local finishHim = false
            if getOptionValue("Ferocious Bite Execute") ~= 3 and comboPoints > 0 and not isDummy(thisUnit) then
                local comboStart = desc:find(" "..comboPoints.." ",1,true)+2
                local damageList = desc:sub(comboStart,desc:len())
                comboStart = damageList:find(": ",1,true)+2
                damageList = damageList:sub(comboStart,desc:len())
                local comboEnd = damageList:find(" ",1,true)-1
                damageList = damageList:sub(1,comboEnd)
                damage = damageList:gsub(",","")
                finishHim = tonumber(damage) >= UnitHealth(thisUnit)
            end
            return finishHim
        end

        local function usePrimalWrath()
            local ripCount = 0
            for i = 1, #enemies.yards8 do
                local thisUnit = enemies.yards8[i]
                if debuff.rip.remain(thisUnit) <= 3.6 and (ttd(thisUnit) > 8 or isDummy(thisUnit)) then ripCount = ripCount + 1 end
            end
            return ripCount > 1
        end

        -- ChatOverlay("5yrds: "..tostring(units.dyn5).." | 40yrds: "..tostring(units.dyn40))
        -- ubr = 0
        -- ucr = 0
        -- if UnitExists("target") then 
            -- ubr = UnitBoundingRadius("target")
            -- ucr = UnitCombatReach("target")
        -- end 
        -- ChatOverlay(round2(getDistance("target","player","dist"),2)..", "..round2(getDistance("target"),2)..", UCR: "..ucr..", UBR: "..ubr)
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
	                if cast.able.swipeCat() and #enemies.yards8 > 1 then
	                    if swipeSoon == nil then
	                        swipeSoon = GetTime();
	                    end
	                    if swipeSoon ~= nil and swipeSoon < GetTime() - 1 then
	                    	if cast.swipeCat(nil,"aoe") then swipeSoon = nil; return true end
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
				if isChecked("Rebirth") and inCombat then
					if getOptionValue("Rebirth - Target")==1 and cast.able.rebirth("target","dead")
                        and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player")
                    then
						if cast.rebirth("target","dead") then return true end
					end
					if getOptionValue("Rebirth - Target")==2 and cast.able.rebirth("mouseover","dead")
                        and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player")
                    then
						if cast.rebirth("mouseover","dead") then return true end
					end
				end
				if isChecked("Revive") and not inCombat then
					if getOptionValue("Revive - Target")==1 and cast.able.revive("target","dead")
                        and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player")
                    then
						if cast.revive("target","dead") then return true end
					end
					if getOptionValue("Revive - Target")==2 and cast.able.revive("mouseover","dead")
                        and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player")
                    then
						if cast.revive("mouseover","dead") then return true end
					end
				end
		-- Remove Corruption
				if isChecked("Remove Corruption") then
					if getOptionValue("Remove Corruption - Target")==1 and cast.able.removeCorruption("player") and canDispel("player",spell.removeCorruption) then
						if cast.removeCorruption("player") then return true end
					end
					if getOptionValue("Remove Corruption - Target")==2 and cast.able.removeCorruption("target") and canDispel("target",spell.removeCorruption) then
						if cast.removeCorruption("target") then return true end
					end
					if getOptionValue("Remove Corruption - Target")==3 and cast.able.removeCorruption("mouseover") and GetUnitIsFriend("mouseover") and canDispel("mouseover",spell.removeCorruption) then
						if cast.removeCorruption("mouseover") then return true end
					end
                end
        -- Soothe 
                if isChecked("Soothe") and cast.able.soothe() then
                    for i=1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if canDispel(thisUnit, spell.soothe) then
                            if cast.soothe(thisUnit) then return true end
                        end
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
                            if (thisHP <= getOptionValue("Regrowth") / 2) or buff.predatorySwiftness.remain() < gcdMax * 2 then
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
						if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
							if cast.skullBash(thisUnit) then return true end
						end
					end
				end
		-- Mighty Bash
    			if isChecked("Mighty Bash") and cast.able.mightyBash() then
    				for i=1, #enemies.yards5 do
                        thisUnit = enemies.yards5[i]
						if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
							if cast.mightyBash(thisUnit) then return true end
						end
					end
				end
		-- Maim (PvP)
    			if isChecked("Maim") and cast.able.maim() then
    				for i=1, #enemies.yards5 do
                        thisUnit = enemies.yards5[i]
    					if canInterrupt(thisUnit,getOptionValue("Interrupt At")) and comboPoints > 0 and not buff.fieryRedMaimers.exists() then --and isInPvP() then
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
			if getDistance(units.dyn5) < 5 then
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
                    end
                    if OPN1 and not TF1 then
            -- Tiger's Fury 
                        -- tigers_fury
                        if castOpener("tigersFury","TF1",openerCount) then openerCount = openerCount + 1; end 
                    end 
                    if TF1 and not RK1 then 
            -- Rake
                        -- rake,if=!ticking|buff.prowl.up
                        if not debuff.rake.exists("target") or buff.prowl.exists() then
                            if castOpener("rake","RK1",openerCount) then openerCount = openerCount + 1; end
                        else
                            Print(openerCount..": Rake (Uncastable)")
                            openerCount = openerCount + 1
                            RK1 = true
                        end
                    end
                    if RK1 and not MF1 then
            -- Moonfire
                        -- moonfire_cat,if=!ticking
                        if talent.lunarInspiration and not debuff.moonfireFeral.exists("target") then
                            if castOpener("moonfireFeral","MF1",openerCount) then openerCount = openerCount + 1; end
                        else
                            Print(openerCount..": Moonfire (Uncastable)")
                            openerCount = openerCount + 1
                            MF1 = true
                        end
                    end
					if MF1 and not RIP1 then
       		-- Rip
                        -- rip,if=!ticking
					    if castOpener("rip","RIP1",openerCount) then openerCount = openerCount + 1; end
                    end
            -- Finish (rip exists)
                    if RIP1 or debuff.rip.exists("target") then
                        Print("Opener Complete")
                        openerCount = 0
                        opener = true
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
            -- savage_roar,if=buff.savage_roar.down
            if (cast.pool.savageRoar() or cast.able.savageRoar()) and not buff.savageRoar.exists() then
                if cast.pool.savageRoar() then ChatOverlay("Pooling For Savage Roar") return true end
                if cast.able.savageRoar() then
                    if cast.savageRoar("player") then return true end
                end
            end
        -- Primal Wrath
            -- pool_resource,for_next=1
            -- primal_wrath,target_if=spell_targets.primal_wrath>1&dot.rip.remains<4
            if cast.able.primalWrath("player","aoe",1,8) and (usePrimalWrath()
                and ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0)))
            then 
                if cast.primalWrath("player","aoe",1,8) then return true end
            end
        -- Rip
            -- pool_resource,for_next=1
            -- rip,target_if=!ticking|(remains<=duration*0.3)&!talent.sabertooth.enabled|(remains<=duration*0.8&persistent_multiplier>dot.rip.pmultiplier)&target.time_to_die>8
            if (cast.pool.rip() or cast.able.rip()) and (not talent.primalWrath or #enemies.yards8 == 1 
                or mode.rotation == 3 or (talent.primalWrath and not usePrimalWrath())) 
                and (buff.savageRoar.exists() or not talent.savageRoar) and debuff.rip.count() < 5 
            then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot)) 
                        and not UnitIsCharmed(thisUnit) and canDoT(thisUnit) and getFacing("player",thisUnit)
                    then
                        if (not debuff.rip.exists(thisUnit) or (debuff.rip.refresh(thisUnit) and not talent.sabertooth)
                            or (debuff.rip.remain(thisUnit) <= ripDuration * 0.8 and debuff.rip.calc() > debuff.rip.applied(thisUnit))) 
                            and (ttd(thisUnit) > 8 or isDummy(thisUnit))
                        then
                            if cast.pool.rip() then ChatOverlay("Pooling For Rip") return true end
                            if cast.able.rip(thisUnit) then
                                if cast.rip(thisUnit) then return true end
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
                if cast.pool.maim() then ChatOverlay("Pooling For Maim") return true end
                if cast.able.maim() then 
                    if cast.maim() then return true end
                end
            end
        -- Ferocious Bite
            -- ferocious_bite,max_energy=1
            if cast.able.ferociousBite() and fbMaxEnergy and (buff.savageRoar.remain() >= 12 or not talent.savageRoar)
                and (not debuff.rip.refresh(units.dyn5) or thp(units.dyn5) <= 25 
                    or (ferociousBiteFinish(units.dyn5) and (not talent.primalWrath or not usePrimalWrath()))
                    or level < 20 or ttd(units.dyn5) <= 8 or UnitIsCharmed(units.dyn5) or not canDoT(units.dyn5) or isDummy(units.dyn5)) 
            then
                if getOptionValue("Ferocious Bite Execute") == 1 and ferociousBiteFinish(thisUnit) then 
                    Print("Ferocious Bite Finished! "..UnitName(thisUnit).." with "..round2(thp(thisUnit),0).."% health remaining.") 
                end
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
        -- Regrowth
            -- if not HasBuff(Bloodtalons) and HasBuff(Berserk) and HasBuff(TigersFury) --requires talents Bloodtalons,Sabertooth
            if cast.able.regrowth() and talent.bloodtalons and talent.sabertooth and buff.bloodtalons.exists() and buff.berserk.exists() and buff.tigersFury.exists() then
                if getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40 then
                    if cast.regrowth(br.friend[1].unit) then return true end
                end
                if getOptionValue("Auto Heal")==2 then
                    if cast.regrowth("player") then return true end
                end
            end
            -- if HasBuff(PredatorySwiftness) and not HasBuff(Bloodtalons) --requires talents Bloodtalons
            if cast.able.regrowth() and talent.bloodtalons and buff.predatorySwiftness.exists() and not buff.bloodtalons.exists() then 
                if getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40 then
                    if cast.regrowth(br.friend[1].unit) then return true end
                end
                if getOptionValue("Auto Heal")==2 then
                    if cast.regrowth("player") then return true end
                end
            end
        -- Savage Roar
            -- if BuffRemainingSec(SavageRoar) < 12 --require talents Savage Roar
            if cast.able.savageRoar() and talent.savageRoar and buff.savageRoar.remain() < 12 then 
                if cast.savageRoar() then return end 
            end 
        -- Primal Wrath
            -- if TargetsInRadius(PrimalWrath) >= 3 and DotRemainingSec(Rip) <= 3.6 --requires talents Primal Wrath
            if cast.able.primalWrath() and talent.primalWrath and debuff.rip.count() < 10 
                and ((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0)) 
            then 
                for i = 1, #enemies.yards8 do
                    local thisUnit = enemies.yards8[i]
                    if debuff.rip.remain(thisUnit) <= 3.6 then 
                        if cast.primalWrath(thisUnit) then return end 
                    end 
                end 
            end 
        -- Rip
            -- if not HasDot(Rip)
            if cast.able.rip() and not debuff.rip.exists(units.dyn5) then 
                if cast.rip() then return end 
            end 
            -- if FeralBleedSnapshot > PeekSavedValue(RipBuffs) and TargetsInRadius(PrimalWrath) < 3 --requires talents Sabertooth
            if cast.able.rip() and talent.sabertooth and debuff.rip.calc() > debuff.rip.applied(units.dyn5) 
                and ((mode.rotation == 1 and #enemies.yards8 < 3) or (mode.rotation == 3 and #enemies.yards8 > 0) or not talent.primalWrath) 
            then
                if cast.rip() then return end 
            end 
            -- if FeralBleedSnapshot > PeekSavedValue(RipBuffs) and TargetSecUntilDeath > 10 and TargetsInRadius(PrimalWrath) < 3
            if cast.able.rip() and not talent.sabertooth and debuff.rip.calc() > debuff.rip.applied(units.dyn5) and ttd(units.dyn5) > 10
                and ((mode.rotation == 1 and #enemies.yards8 < 3) or (mode.rotation == 3 and #enemies.yards8 > 0) or not talent.primalWrath) 
            then
                if cast.rip() then return end 
            end 
        -- Ferocious Bite
            -- if HasDot(Rip) and DotRemainingSec(Rip) < 3 --requires talents Sabertooth
            if cast.able.ferociousBite() and talent.sabertooth and debuff.rip.exists(units.dyn5) and debuff.rip.remain(units.dyn5) < 3 then
                if cast.ferociousBite() then return true end
            end
        -- Rip
            -- if not HasDot(Rip) --requires talents Sabertooth
            if cast.able.rip() and talent.sabertooth and debuff.rip.count() < 5 then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if not debuff.rip.exists(thisUnit) then
                            if cast.rip(thisUnit) then return true end
                        end
                    end
                end
            end
        -- Maim
            -- if AzeriteTraitRank(AzeriteIronJaws) > 0 and HasBuff(AzeriteIronJaws)
            if cast.able.maim() and trait.ironJaws.active and buff.ironJaws.exists() then
                if cast.maim() then return true end
            end
        -- Ferocious Bite
            -- if HasDot(Rip) and DotRemainingSec(Rip) < 3 --requires talents Sabertooth
            if cast.able.ferociousBite() and talent.sabertooth then 
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if not UnitIsUnit(thisUnit,"target") and debuff.rip.exists(thisUnit) and debuff.rip.remain(thisUnit) < 3 then 
                        if cast.ferociousBite(thisUnit) then return end 
                    end 
                end
            end
            -- if HasDot(Rip) and Power >= FerociousBiteMaxEnergy --requires talents Sabertooth
            if cast.able.ferociousBite() and talent.sabertooth and debuff.rip.exists(units.dyn5) and fbMaxEnergy then 
                if cast.ferociousBite() then return end 
            end
        -- Rip 
            -- if CanRefreshDot(Rip) and TargetsInRadius(PrimalWrath) < 3
            if cast.able.rip() and not talent.sabertooth 
                and ((mode.rotation == 1 and #enemies.yards8 < 3) or (mode.rotation == 3 and #enemies.yards8 > 0) or not talent.primalWrath) 
            then 
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if debuff.rip.refresh(thisUnit) then 
                        if cast.rip(thisUnit) then return end 
                    end
                end
            end
        -- Ferocious Bite     
            -- if Power >= FerociousBiteMaxEnergy
            if cast.able.ferociousBite() and fbMaxEnergy then
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
    -- Action List - Generator
        local function actionList_SimC_Generator()
            local startTime = debugprofilestop()
    -- Regrowth
            -- regrowth,if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&buff.bloodtalons.down&combo_points=4&dot.rake.remains<4
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
            if cast.able.brutalSlash() and talent.brutalSlash and mode.rotation < 3
                and ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Brutal Slash Targets")) or (mode.rotation == 2 and #enemies.yards8 > 0)) 
            then
                if cast.brutalSlash("player","aoe",1,8) then return true end
            end
        -- Thrash
            -- pool_resource,for_next=1
            -- thrash_cat,if=(refreshable)&(spell_targets.thrash_cat>2)
            if (cast.pool.thrashCat() or cast.able.thrashCat()) and ttd(units.dyn8AOE) > 4 then
                if (not debuff.thrashCat.exists(units.dyn8AOE) or debuff.thrashCat.refresh(units.dyn8AOE)) 
                    and ((mode.rotation == 1 and #enemies.yards8 > 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) 
                then
                    if cast.pool.thrashCat() then ChatOverlay("Pooling For Thrash: "..#enemies.yards8.." targets") return true end
                    if cast.able.thrashCat() then
                        if cast.thrashCat("player","aoe",1,8) then return true end
                    end
                end
            end
            -- pool_resource,for_next=1
            -- thrash_cat,if=(talent.scent_of_blood.enabled&buff.scent_of_blood.down)&spell_targets.thrash_cat>3 
            if (cast.pool.thrashCat() or cast.able.thrashCat()) and (talent.scentOfBlood and not buff.scentOfBlood.exists() 
                and ((mode.rotation == 1 and #enemies.yards8 > 3) or (mode.rotation == 2 and #enemies.yards8 > 0))) and ttd(units.dyn8AOE) > 4
            then
                if cast.pool.thrashCat() then ChatOverlay("Pooling For Thrash: Scent of Blood") return true end
                if cast.able.thrashCat() then
                    if cast.thrashCat("player","aoe",1,8) then return true end
                end
            end
        -- Swipe
            -- pool_resource,for_next=1
            -- swipe_cat,if=buff.scent_of_blood.up
            if (cast.pool.swipeCat() or cast.able.swipeCat()) and not talent.brutalSlash and buff.scentOfBlood.exists() then
                if cast.pool.swipeCat() then ChatOverlay("Pooling For Swipe - Scent of Blood") return true end
                if cast.able.swipeCat() then
                    if cast.swipeCat("player","aoe",1,8) then return true end
                end
            end
        -- Rake
            -- pool_resource,for_next=1
            -- rake,target_if=!ticking|(!talent.bloodtalons.enabled&remains<duration*0.3)&target.time_to_die>4
            -- rake,target_if=talent.bloodtalons.enabled&buff.bloodtalons.up&((remains<=7)&persistent_multiplier>dot.rake.pmultiplier*0.85)&target.time_to_die>4
            if (cast.pool.rake() or cast.able.rake()) then --and #enemies.yards5 < 4 then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot)) and (ttd(thisUnit) > 4 or isDummy(thisUnit)) 
                        and not UnitIsCharmed(thisUnit) and canDoT(thisUnit) and getFacing("player",thisUnit)
                    then
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
            if cast.able.moonfireFeral() and talent.lunarInspiration and canDoT(units.dyn40) then --and #enemies.yards8 < 5 then
                if buff.bloodtalons.exists() and not buff.predatorySwiftness.exists() and comboPoints < 5 then
                    if cast.moonfireFeral() then return end
                end
            end
        -- Brutal Slash
            -- brutal_slash,if=(buff.tigers_fury.up&(raid_event.adds.in>(1+max_charges-charges_fractional)*recharge_time))
            --if talent.brutalSlash and ((buff.tigersFury.exists() and charges.brutalSlash.timeTillFull() < gcdMax)
            --    or (charges.brutalSlash.recharge(true) < cd.tigersFury.remain()))
            if cast.able.brutalSlash() and talent.brutalSlash and mode.rotation < 3 and ((buff.tigersFury.exists() and getOptionValue("Brutal Slash Targets") == 1)
                or ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Brutal Slash Targets")) or (mode.rotation == 2 and #enemies.yards8 > 0)) 
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
                if cast.brutalSlash("player","aoe",1,8) then return true end
            end
        -- Moonfire
            -- moonfire_cat,target_if=refreshable
            if cast.able.moonfireFeral() and talent.lunarInspiration then --and #enemies.yards8 < 5 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if canDoT(thisUnit) and debuff.moonfireFeral.refresh(thisUnit) then --or (isDummy(thisUnit) and getDistance(thisUnit) < 8) then
                           if cast.moonfireFeral(thisUnit) then return true end
                        end
                    end
                end
            end
        -- Thrash
            -- pool_resource,for_next=1
            -- thrash_cat,if=refreshable&((variable.use_thrash=2&(!buff.incarnation.up|azerite.wild_fleshrending.enabled))|spell_targets.thrash_cat>1)
            -- thrash_cat,if=refreshable&variable.use_thrash=1&buff.clearcasting.react&(!buff.incarnation.up|azerite.wild_fleshrending.enabled)
            if (cast.pool.thrashCat() or cast.able.thrashCat()) and ttd(units.dyn8AOE) > 4 and debuff.thrashCat.refresh(units.dyn8AOE) and mode.rotation < 3 then
                if (useThrash == 2 and (not buff.incarnationKingOfTheJungle.exists() or trait.wildFleshrending.active)) 
                    or ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0)) 
                    or (useThrash == 1 and buff.clearcasting.exists() and (not buff.incarnationKingOfTheJungle.exists() or trait.wildFleshrending.active)) 
                then
                    if cast.pool.thrashCat() and not buff.clearcasting.exists() then ChatOverlay("Pooling For Thrash") return true end
                    if cast.able.thrashCat() or buff.clearcasting.exists() then
                        if cast.thrashCat("player","aoe",1,8) then return true end
                    end
                end
            end
        -- Swipe
            -- pool_resource,for_next=1
            -- swipe_cat,if=spell_targets.swipe_cat>1
            if (cast.pool.swipeCat() or cast.able.swipeCat()) and not talent.brutalSlash --and multidot
                and ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0))
            then
                if cast.pool.swipeCat() then ChatOverlay("Pooling For Swipe") return true end
                if cast.able.swipeCat() then
                    if cast.swipeCat("player","aoe",1,8) then return true end
                end
            end
        -- Shred
            -- shred,if=dot.rake.remains>(action.shred.cost+action.rake.cost-energy)%energy.regen|buff.clearcasting.react
            if cast.able.shred() 
                and ((debuff.rake.exists(units.dyn5) and (debuff.rake.remain(units.dyn5) > ((cast.cost.shred() + cast.cost.rake() - energy) / energyRegen))) 
                    or ttd(units.dyn5) <= 4 or not canDoT(units.dyn5) or buff.clearcasting.exists() or level < 12) 
            then
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
        -- Feral Frenzy 
            -- if AlternatePower = 0 --requires talents Feral Frenzy 
            if cast.able.feralFrenzy() and talent.feralFrenzy and comboPoints == 0 then 
                if cast.feralFrenzy() then return end 
            end 
        -- Rake
            -- if CanRefreshDot(RakeBleed)
            if cast.able.rake() and debuff.rake.count() < 5 then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if debuff.rake.refresh(thisUnit) then
                            if cast.rake(thisUnit) then return true end
                        end
                    end
                end
            end
        -- Brutal Slash
            -- TargetsInRadius(BrutalSlash) >= 3 --requires talents Brutal Slash
            if cast.able.brutalSlash() and talent.brutalSlash and #enemies.yards8 >= 3 then
                if cast.brutalSlash("player","aoe",1,8) then return true end
            end
        -- Shred 
            -- if HasBuff(Clearcasting) and ChargesRemaining(BrutalSlash) < SpellCharges(BrutalSlash) and TargetsInRadius(BrutalSlash) < 2 --requires talents Brutal Slash
            if cast.able.shred() and talent.brutalSlash and buff.clearcasting.exists() and charges.brutalSlash.count() < 3 and #enemies.yards8 < 2 then 
                if cast.shred() then return end 
            end 
        -- Brutal Slash 
            -- if not CanAoe(2,8) or TargetsInRadius(BrutalSlash) > 1 or ChargesRemaining(BrutalSlash) = SpellCharges(BrutalSlash) --requires talents Brutal Slash / not Wild Fleshrending Azerite
            if cast.able.brutalSlash() and talent.brutalSlash and not trait.wildFleshrending.active and (#enemies.yards8 > 1 or charges.brutalSlash.count() == 3) then 
                if cast.brutalSlash("player","aoe",1,8) then return end 
            end 
            -- if TargetsInRadius(BrutalSlash) > 1 or (AzeriteTraitRank(AzeriteWildFleshrending) < 2 and (not CanAoe(2,8) or ChargesRemaining(BrutalSlash) = SpellCharges(BrutalSlash))) --requires talents Brutal Slash / Wild Fleshrending Azerite
            if cast.able.brutalSlash() and talent.brutalSlash and trait.wildFleshrending.active 
                and (#enemies.yards8 > 1 or (trait.wildFleshrending.rank < 2 and (#enemies.yards8 > 1 or charges.brutalSlash.count() == 3))) 
            then
                if cast.brutalSlash("player","aoe",1,8) then return end 
            end 
        -- Thrash 
            -- if TargetsInRadius(Thrash) >= 3 and CanRefreshDot(ThrashBleedFeral)
            if cast.able.thrashCat() and debuff.thrashCat.refresh(units.dyn8AOE) 
                and ((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0)) 
            then
                if cast.thrashCat("player","aoe") then return true end
            end
        -- Moonfire
            -- if CanRefreshDot(MoonfireDoT)
            -- multi-DoT = 5
            if cast.able.moonfireFeral() and talent.lunarInspiration and debuff.moonfireFeral.count() < 5 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                        if debuff.moonfireFeral.refresh(thisUnit) and (not isDummy(thisUnit) or (isDummy(thisUnit) and getDistance(thisUnit) < 8)) then
                           if cast.moonfireFeral(thisUnit) then return true end
                        end
                    end
                end
            end
        -- Swipe
            -- if TargetsInRadius(Swipe) >= 3
            if cast.able.swipeCat() and not talent.brutalSlash
                and ((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0))
            then
                if cast.swipeCat("player","aoe") then return true end
            end
        -- Thrash
            -- if CanRefreshDot(ThrashBleedFeral) and (AzeriteTraitRank(AzeriteWildFleshrending) > 0 or AzeriteTraitRank(AzeriteTwistedClaws) > 0)
            if cast.able.thrashCat() and debuff.thrashCat.refresh(units.dyn8) and (trait.wildFleshrending.active or trait.twistedClaws.active) then
                if cast.thrashCat("player","aoe") then return true end
            end
        -- Shred
            if cast.able.shred() then
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
                if isValidUnit("target") and opener and getDistance(units.dyn5) < 5 then
                    if cast.able.shred() and level < 12 then
                        if cast.shred() then return true end
                    elseif cast.able.rake() then
                       if cast.rake() then return true end
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
            elseif inCombat and cat and profileStop==false and not isChecked("Death Cat Mode") and hastar and opener then
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
                if (buff.prowl.exists() or buff.shadowmeld.exists()) and getDistance(units.dyn5) < 5 then
                    -- if debuff.rake.exists(units.dyn5) or level < 12 then
                    if cast.able.rake() and debuff.rake.calc() > debuff.rake.applied(units.dyn5) * 0.85 and level >= 12 then
                        if cast.rake(units.dyn5) then return true end
                    elseif cast.able.shred() then
                        if cast.shred(units.dyn5) then return true end
                    end
                elseif not (buff.prowl.exists() or buff.shadowmeld.exists()) then --and getDistance("target") < 5 then
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
                        if cast.able.ferociousBite() then
                            for i = 1, #enemies.yards5 do
                                local thisUnit = enemies.yards5[i]
                                if getFacing("player",thisUnit) and ((debuff.rip.exists(thisUnit) and debuff.rip.remain(thisUnit) < 3
                                    and ttd(thisUnit) > 10 and (thp(thisUnit) < 25 or talent.sabertooth)) 
                                        or (ferociousBiteFinish(thisUnit) and (not talent.primalWrath or not usePrimalWrath())))
                                then
                                    if getOptionValue("Ferocious Bite Execute") == 1 and ferociousBiteFinish(thisUnit) then 
                                        Print("Ferocious Bite Finished! "..UnitName(thisUnit).." with "..round2(thp(thisUnit),0).."% health remaining.") 
                                    end
                                    if cast.ferociousBite(thisUnit) then return true end
                                end
                            end
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
        -- Potion
                        -- if HasBuff(Berserk) or HasBuff(IncarnationKingOfTheJungle)
                        if useCDs() and isChecked("Potion") and inRaid and (use.able.potionOfTheOldWar() or use.able.potionOfProlongedPower()) then
                            if buff.berserk.exists() or buff.incarnationKingOfTheJungle.exists() then
                                if getOptionValue("Potion") == 1 and use.able.potionOfTheOldWar() then
                                    use.potionOfTheOldWar()
                                elseif getOptionValue("Potion") == 2 and use.able.potionOfProlongedPower() then
                                    use.potionOfProlongedPower()
                                end
                            end
                        end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                        -- if HasBuff(Berserk) or HasBuff(IncarnationKingOfTheJungle)
                        if useCDs() and isChecked("Racial") and cast.able.racial() and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                            if buff.berserk.exists() or buff.incarnationKingOfTheJungle.exists() then
                                if cast.racial("player") then return true end
                            end
                        end
        -- Trinkets
                        -- if HasBuff(TigersFury)
                        if useCDs() and isChecked("Trinkets") and buff.tigersFury.exists() and (use.able.slot(13) or use.able.slot(14)) then
                            for i = 13, 14 do
                                if use.able.slot(i) then
                                    use.slot(i)
                                end
                            end
                        end
        -- Regrowth
                        -- if HasTalent(Bloodtalons) and HasBuff(PredatorySwiftness) and BuffRemainingSec(PredatorySwiftness) < 2
                        if cast.able.regrowth() and talent.bloodtalons and buff.predatorySwiftness.exists() and buff.predatorySwiftness.remain() < 2 then
                            if getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40 then
                                if cast.regrowth(br.friend[1].unit) then return true end
                            end
                            if getOptionValue("Auto Heal")==2 then
                                if cast.regrowth("player") then return true end
                            end
                        end
        -- Incarnation - King of the Jungle
                        if useCDs() and isChecked("Berserk/Incarnation") and cast.able.incarnationKingOfTheJungle() then
                            if talent.incarnationKingOfTheJungle then
                                if cast.incarnationKingOfTheJungle() then return true end
                            end
                        end
        -- Berserk
                        if useCDs() and isChecked("Berserk/Incarnation") and cast.able.berserk() then
                            if not talent.incarnationKingOfTheJungle then
                                if cast.berserk() then return true end
                            end
                        end
        -- Tiger's Fury
                        -- if PowerToMax >= 50
                        if isChecked("Tiger's Fury") and cast.able.tigersFury() then
                            if energyDeficit >= 50 or snipeTF() then
                                if cast.tigersFury() then return true end
                            end
                        end
                        -- if HasBuff(Bloodtalons)
                        if isChecked("Tiger's Fury") and cast.able.tigersFury() then
                            if buff.bloodtalons.exists() then
                                if cast.tigersFury() then return true end
                            end
                        end        
        -- Call Action List - Finisher
                        -- if AlternatePower = 5
                        if comboPoints >= 5 then
                            if actionList_AMR_Finisher() then return true end
                        end
        -- Ferocious Bite
                        -- if DotRemainingSec(Rip) < 3 and HasDot(Rip) --requires talents Sabertooth--
                        if cast.able.ferociousBite() and talent.sabertooth and debuff.rip.exists(units.dyn5) and debuff.rip.remain(units.dyn5) < 3 then
                            if cast.ferociousBite() then return true end
                        end
        -- Call Action List - Generator
                        -- if AlternatePower < 5
                        if comboPoints < 5 then
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

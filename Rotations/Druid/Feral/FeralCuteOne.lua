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
            br.ui:createSpinner(section,"Brutal Slash Targets", 3, 1, 10, 1, "|cffFFFFFFSet to desired targets to use Brutal Slash on. Min: 1 / Max: 10 / Interval: 1")
        -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Potion
            br.ui:createCheckbox(section,"Potion")
        -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Seventh Demon","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Tiger's Fury
            br.ui:createCheckbox(section,"Tiger's Fury")
        -- Berserk / Incarnation: King of the Jungle
            br.ui:createCheckbox(section,"Berserk/Incarnation")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Draught of Souls
            br.ui:createCheckbox(section,"Draught of Souls")
        -- Ring of Collapsing Futures
            br.ui:createSpinner(section, "Ring of Collapsing Futures",  1,  1,  5,  1,  "|cffFFFFFFSet to desired number of Temptation stacks before letting fall off. Min: 1 / Max: 5 / Interval: 1")
        -- Specter of Betrayal
            br.ui:createDropdownWithout(section,"Specter of Betrayal", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Specter of Betrayal.")
        -- Vial of Ceaseless Toxins
            br.ui:createCheckbox(section,"Vial of Ceaseless Toxins")
        -- Umbral Moonglaives
            br.ui:createCheckbox(section,"Umbral Moonglaives")
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
        -- Engineering: Shield-o-tronic
            br.ui:createSpinner(section, "Shield-o-tronic",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
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
        local addsExist                                     = false
        local addsIn                                        = 999
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local canFlask                                      = canUse(br.player.flask.wod.agilityBig)
        local cast                                          = br.player.cast
		local castable          							= br.player.cast.debug
        local clearcast                                     = br.player.buff.clearcasting.exists()
        local combatTime                                    = getCombatTime()
        local combo                                         = br.player.power.comboPoints.amount()
        local comboDeficit                                  = br.player.power.comboPoints.deficit()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = enemies or {}
        local equiped                                       = br.player.equiped
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = GetObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local item                                          = br.player.spell.items
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
        local power, powmax, powgen, powerDeficit           = br.player.power.energy.amount(), br.player.power.energy.max(), br.player.power.energy.regen(), br.player.power.energy.deficit()
        local pullTimer                                     = PullTimerRemain() --br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local rkTick                                        = 3
        local rpTick                                        = 2
        local solo                                          = #br.friend < 2
        local friendsInRange                                = friendsInRange
        local spell                                         = br.player.spell
        local stealth                                       = br.player.buff.prowl.exists() or br.player.buff.shadowmeld.exists()
        local t18_2pc                                       = TierScan("T18")>=2 --br.player.eq.t18_2pc
        local t18_4pc                                       = TierScan("T18")>=4 --br.player.eq.t18_4pc
        local t19_2pc                                       = TierScan("T19")>=2
        local t19_4pc                                       = TierScan("T19")>=4
        local talent                                        = br.player.talent
        local travel, flight, cat, noform                   = br.player.buff.travelForm.exists(), br.player.buff.flightForm.exists(), br.player.buff.catForm.exists(), GetShapeshiftForm()==0
        local trinketProc                                   = false
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.energy.ttm()
        local units                                         = units or {}
        local use                                           = br.player.use

        -- Get Best Unit for Range
        units.dyn40   = br.player.units(40)
        units.dyn20   = br.player.units(20)
        units.dyn8AoE = br.player.units(8,true)
        units.dyn8    = br.player.units(8)
        units.dyn5    = br.player.units(5)

        -- Get List of Enemies for Range
        enemies.yards40 = br.player.enemies(40)
        enemies.yards20 = br.player.enemies(20)
        enemies.yards13 = br.player.enemies(13)
        enemies.yards8  = br.player.enemies(8)
        enemies.yards5  = br.player.enemies(5)

   		if leftCombat == nil then leftCombat = GetTime() end
		if profileStop == nil then profileStop = false end
		if lastSpellCast == nil then lastSpellCast = spell.catForm end
        if opener == nil then opener = false end
        if lastForm == nil then lastForm = 0 end
		if not inCombat and not hastar and profileStop==true then
            profileStop = false
		end
        if freeProwl == nil or (not buff.incarnationKingOfTheJungle.exists() and freeProwl == false) then freeProwl = true end
        if talent.jaggedWounds then
            --if rkTick == 3 then rkTick = rkTick - (rkTick * 0.3) end
            -- if rpTick == 2 then rpTick = rpTick - (rpTick * 0.3) end
            rkTick = 2
            rpTick = 1.34
        end
        if br.player.potion.agility ~= nil then
            if br.player.potion.agility[1] ~= nil then
                agiPot = br.player.potion.agility[1].itemID
            else
                agiPot = 0
            end
        else
            agiPot = 0
        end
        friendsInRange = 0
        if not solo then
            for i = 1, #br.friend do
                if getDistance(br.friend[i].unit) < 15 then
                    friendsInRange = friendsInRange + 1
                end
            end
        end
        if power > 50 then
            fbMaxEnergy = true
        else
            fbMaxEnergy = false
        end
        if not inCombat and not GetObjectExists("target") then
			shredCount = 10
            OPN1 = false
            RK1 = false
            MF1 = false
            SR1 = false
            BER1 = false
            TF1 = false
            AF1 = false
            REG1 = false
            MF1 = false
            RIP1 = false
            THR1 = false
            SHR1 = false
            opener = false
        end

        -- Variables
        -- variable,name=use_thrash,value=0
        -- variable,name=use_thrash,value=1,if=equipped.luffa_wrappings
        if hasEquiped(137056) then 
            useThrash = 2
        elseif t19_2pc then
            useThrash = 1 
        else 
            useThrash = 0 
        end
        -- actions.precombat+=/variable,name=pooling,op=set,value=3
        -- actions.precombat+=/variable,name=pooling,op=set,value=10,if=equipped.chatoyant_signet
        -- actions.precombat+=/variable,name=pooling,op=set,value=3,if=equipped.the_wildshapers_clutch&!equipped.chatoyant_signet
        if hasEquiped(137040) then
            poolVar = 10
        elseif hasEquiped(137094) and not hasEquiped(137040) then
            poolVar = 3
        else
            poolVar = 3
        end

        -- Challenge Mode Stuff
        -- Umbral Exists
        if umbralExists == nil then umbralExists = false end
        for i = 1, #enemies.yards20 do
            thisUnit = enemies.yards20[i]
            if ObjectID(thisUnit) == 115642 then umbralExists = true; break end
            umbralExists = false
        end 

        if isChecked("Skull Bash") then
            for i=1, #enemies.yards13 do
                thisUnit = enemies.yards13[i]
                if ObjectID(thisUnit) == 115638 and not umbralExists and not UnitBuffID(thisUnit,243113) and isCastingSpell(243114,thisUnit) then
                    if cast.skullBash(thisUnit) then return end
                end
            end
        end
        -- ChatOverlay("5yrds: "..tostring(units.dyn5).." | 40yrds: "..tostring(units.dyn40))
        -- ChatOverlay(round2(getDistance("target","player","dist"),2)..", "..round2(getDistance("target","player","dist2"),2)..", "..round2(getDistance("target","player","dist3"),2)..", "..round2(getDistance("target","player","dist4"),2)..", "..round2(getDistance("target"),2))
--------------------
--- Action Lists ---
--------------------
	-- Action List - Extras
		local function actionList_Extras()
		-- Shapeshift Form Management
			if isChecked("Auto Shapeshifts") then --and br.timer:useTimer("debugShapeshift", 0.25) then
			-- Flight Form
				if not inCombat and canFly() and not swimming and falling > getOptionValue("Fall Timer") and level>=58 and not buff.prowl.exists() then
                    if GetShapeshiftForm() ~= 0 and lastCast ~= spell.travelForm then
                        -- CancelShapeshiftForm()
                        RunMacroText("/CancelForm")
                        if cast.travelForm("player") then return end
                    else
	                   if cast.travelForm("player") then return end
                    end
		        end
			-- Aquatic Form
			    if (not inCombat or getDistance("target") > 10) and swimming and not travel and not buff.prowl.exists() then
				  	if GetShapeshiftForm() ~= 0 and lastCast ~= spell.travelForm then
                        -- CancelShapeshiftForm()
                        RunMacroText("/CancelForm")
                        if cast.travelForm("player") then return end
                    else
                       if cast.travelForm("player") then return end
                    end
				end
			-- Cat Form
				if not cat and not IsMounted() and not flying then
			    	-- Cat Form when not swimming or flying or stag and not in combat
			    	if not inCombat and moving and not swimming and not flying and not travel and not isValidUnit("target") then
		        		if cast.catForm("player") then return end
		        	end
		        	-- Cat Form when not in combat and target selected and within 20yrds
		        	if not inCombat and isValidUnit("target") and getDistance("target") < 30 then
		        		if cast.catForm("player") then return end
		        	end
		        	--Cat Form when in combat and not flying
		        	if inCombat and not flying then
		        		if cast.catForm("player") then return end
		        	end
                    -- Cat Form - Less Fall Damage
                    if (not canFly() or inCombat or level < 58 or not IsOutdoors()) and not swimming and falling > getOptionValue("Fall Timer") then
                        if cast.catForm("player") then return end
                    end
		        end
			end -- End Shapeshift Form Management
		-- Perma Fire Cat
			if isChecked("Perma Fire Cat") and not inCombat and not buff.prowl.exists() and cat then
				if not buff.burningEssence.exists() then
					-- Fandral's Seed Pouch
                    if equiped.fandralsSeedPouch then
                        if use.fandralsSeedPouch() then return end
					-- Burning Seeds
					else
						if use.burningSeeds() then return end
					end
				end
			end -- End Perma Fire Cat
		-- Death Cat mode
			if isChecked("Death Cat Mode") and cat then
		        if hastar and getDistance(units.dyn8AoE) > 8 then
		            ClearTarget()
		        end
	            if #enemies.yards20 > 0 then
	            -- Tiger's Fury - Low Energy
                	if cast.tigersFury() then return end
	            -- Savage Roar - Use Combo Points
	                if combo >= 5 then
	                	if cast.savageRoar() then return end
	                end
	            -- Shred - Single
	                if #enemies.yards5 == 1 then
	                	if cast.shred() then swipeSoon = nil; return end
	                end
	            -- Swipe - AoE
	                if #enemies.yards8 > 1 then
	                    if swipeSoon == nil then
	                        swipeSoon = GetTime();
	                    end
	                    if swipeSoon ~= nil and swipeSoon < GetTime() - 1 then
	                    	if cast.swipe() then swipeSoon = nil; return end
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
		end -- End Action List - Extras
	-- Action List - Defensive
		local function actionList_Defensive()
			if useDefensive() and not IsMounted() and not stealth and not flight and not buff.prowl.exists() then
		--Revive/Rebirth
				if isChecked("Rebirth") and inCombat then
					-- if buff.predatorySwiftness.exists() then
						if getOptionValue("Rebirth - Target")==1
                            and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                        then
							if cast.rebirth("target","dead") then return end
						end
						if getOptionValue("Rebirth - Target")==2
                            and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                        then
							if cast.rebirth("mouseover","dead") then return end
						end
					-- end
				end
				if isChecked("Revive") and not inCombat then
					if getOptionValue("Revive - Target")==1
                        and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                    then
						if cast.revive("target","dead") then return end
					end
					if getOptionValue("Revive - Target")==2
                        and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                    then
						if cast.revive("mouseover","dead") then return end
					end
				end
		-- Remove Corruption
				if isChecked("Remove Corruption") then
					if getOptionValue("Remove Corruption - Target")==1 and canDispel("player",spell.removeCorruption) then
						if cast.removeCorruption("player") then return end
					end
					if getOptionValue("Remove Corruption - Target")==2 and canDispel("target",spell.removeCorruption) then
						if cast.removeCorruption("target") then return end
					end
					if getOptionValue("Remove Corruption - Target")==3 and canDispel("mouseover",spell.removeCorruption) then
						if cast.removeCorruption("mouseover") then return end
					end
				end
        -- Renewal
                if isChecked("Renewal") and php <= getOptionValue("Renewal") and inCombat then
                    if cast.renewal() then return end
                end
		-- PowerShift - Breaks Crowd Control (R.I.P Powershifting)
			    if isChecked("Break Crowd Control") then
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
	            if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned")
	            	and inCombat and (hasHealthPot() or hasItem(5512))
	            then
                    if equiped.healthstone then
                        if use.healthstone() then return end
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
		-- Regrowth
        		if isChecked("Regrowth") and not (IsMounted() or IsFlying()) and getDistance(br.friend[1].unit) < 40 then
                    if not inCombat then
                        -- Don't Break Form
                        if getOptionValue("Regrowth - OoC") == 2 then
                            -- Lowest Party/Raid
                            if getOptionValue("Auto Heal") == 1 and ((getHP(br.friend[1].unit) <= getOptionValue("Regrowth") and GetShapeshiftForm() == 0) or buff.predatorySwiftness.exists()) then 
                                if cast.regrowth(br.friend[1].unit) then return end
                            -- Player
                            elseif (getHP("player") <= getOptionValue("Regrowth") and GetShapeshiftForm() == 0) or buff.predatorySwiftness.exists() then
                                if cast.regrowth("player") then return end
                            end
                        end
                        -- Break Form
                        if getOptionValue("Regrowth - OoC") == 1 and getHP("player") <= getOptionValue("Regrowth") then
                            if GetShapeshiftForm() ~= 0 and not buff.predatorySwiftness.exists() and not moving then
                                -- CancelShapeshiftForm()
                                RunMacroText("/CancelForm")
                            else
                               if cast.regrowth("player") then return end
                            end
                        end
                    elseif inCombat and buff.predatorySwiftness.exists() then
                        -- Always Use Predatory Swiftness when available
                        if getOptionValue("Regrowth - InC") == 1 or not talent.bloodtalons then
                            -- Lowest Party/Raid
                            if getOptionValue("Auto Heal")==1 and getHP(br.friend[1].unit) <= getOptionValue("Regrowth") then 
                                if cast.regrowth(br.friend[1].unit) then return end
                            -- Player
                            elseif getHP("player") <= getOptionValue("Regrowth") then
                                if cast.regrowth("player") then return end
                            end
                        end
                        -- Hold Predatory Swiftness for Bloodtalons unless Health is Below Half of Threshold or Predatory Swiftness is about to Expire.
                        if getOptionValue("Regrowth - InC") == 2 and talent.bloodtalons then
                            -- Lowest Party/Raid
                            if getOptionValue("Auto Heal")==1 and ((getHP(br.friend[1].unit) <= getOptionValue("Regrowth") / 2) or buff.predatorySwiftness.remain() < 1) then 
                                if cast.regrowth(br.friend[1].unit) then return end
                            -- Player
                            elseif (getHP("player") <= getOptionValue("Regrowth") / 2) or buff.predatorySwiftness.remain() < 1 then
                                if cast.regrowth("player") then return end
                            end
                        end
                    end

	            	-- if inCombat and getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40
	             --        and ((getHP(br.friend[1].unit) <= getOptionValue("Regrowth")/2 and inCombat)
	             --            or (getHP(br.friend[1].unit) <= getOptionValue("Regrowth") and not inCombat)
	             --            or (((talent.bloodtalons and buff.predatorySwiftness.remain() < 1) or not talent.bloodtalons) and buff.predatorySwiftness.exists()))
	             --    then
	             --        if cast.regrowth(br.friend[1].unit) then return end
	             --    end
	             --    if (getOptionValue("Auto Heal")==2 or not inCombat)
	             --        and (php <= getOptionValue("Regrowth") or (((talent.bloodtalons and buff.predatorySwiftness.remain() < 1) or not talent.bloodtalons) and buff.predatorySwiftness.exists()))
	             --    then
              --           if GetShapeshiftForm() ~= 0 and not buff.predatorySwiftness.exists() and not moving then
              --               -- CancelShapeshiftForm()
              --               RunMacroText("/CancelForm")
              --           else
	             --           if cast.regrowth("player") then return end
              --           end
	             --    end
	            end
		-- Survival Instincts
	            if isChecked("Survival Instincts") and php <= getOptionValue("Survival Instincts")
	            	and inCombat and not buff.survivalInstincts.exists() and charges.survivalInstincts.count() > 0
	            then
	            	if cast.survivalInstincts() then return end
	            end
    		end -- End Defensive Toggle
		end -- End Action List - Defensive
	-- Action List - Interrupts
		local function actionList_Interrupts()
			if useInterrupts() then
		-- Skull Bash
				if isChecked("Skull Bash") then
					for i=1, #enemies.yards13 do
						thisUnit = enemies.yards13[i]
						if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
							if cast.skullBash(thisUnit) then return end
						end
					end
				end
		-- Mighty Bash
    			if isChecked("Mighty Bash") then
    				for i=1, #enemies.yards5 do
                        thisUnit = enemies.yards5[i]
						if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
							if cast.mightyBash(thisUnit) then return end
						end
					end
				end
		-- Maim (PvP)
    			if isChecked("Maim") then
    				for i=1, #enemies.yards5 do
                        thisUnit = enemies.yards5[i]
    					if canInterrupt(thisUnit,getOptionValue("InterruptAt")) and combo > 0 then --and isInPvP() then
    						if cast.maim(thisUnit) then return end
		    			end
	            	end
	          	end
		 	end -- End useInterrupts check
		end -- End Action List - Interrupts
	-- Action List - Cooldowns
		local function actionList_SimC_Cooldowns()
			if getDistance("target") < 5 then
		-- Berserk
				-- berserk,if=energy>=30&(cooldown.tigers_fury.remains>5|buff.tigers_fury.up)
	            if useCDs() and isChecked("Berserk/Incarnation") then
	            	if power >= 30 and (cd.tigersFury.remain() > 5 or buff.tigersFury.exists()) and not talent.incarnationKingOfTheJungle then
	            		if cast.berserk() then return end
	            	end
	            end
        -- Tiger's Fury
                -- tigers_fury,if=energy.deficit>=60
                if isChecked("Tiger's Fury") then
                    if powerDeficit >= 60 then
                        if cast.tigersFury() then return end
                    end
                end
        -- Elune's Guidance
                -- elunes_guidance,if=combo_points=0&energy>=50
                if combo == 0 and power >= 50 then
                    if cast.elunesGuidance() then return end
                end
        -- Incarnation - King of the Jungle
                -- incarnation,if=energy>=30&(cooldown.tigers_fury.remains>15|buff.tigers_fury.up)
                if useCDs() and isChecked("Berserk/Incarnation") then
                    if power >= 30 and (cd.tigersFury.remain() > 15 or buff.tigersFury.exists()) and talent.incarnationKingOfTheJungle then
                        if cast.incarnationKingOfTheJungle() then return end
                    end
                end
        -- Prowl
                if useCDs() and talent.incarnationKingOfTheJungle and buff.incarnationKingOfTheJungle.exists() and freeProwl and not buff.prowl.exists() and not solo and friendsInRange > 0 then
                    if cast.prowl() then freeProwl = false; return end
                end
        -- Potion
                -- potion,name=prolonged_power,if=target.time_to_die<65|(time_to_die<180&(buff.berserk.up|buff.incarnation.up))
                if useCDs() and isChecked("Potion") and inRaid then
                    if ttd(units.dyn5) < 65 or (ttd(units.dyn5) < 180 and (buff.berserk.exists() or buff.incarnationKingOfTheJungle.exists())) then
                        if canUse(127844) then
                            useItem(127844)
                        elseif canUse(142117) then
                            useItem(142117)
                        end
                    end
                end
        -- Ashamane's Frenzy
                -- ashamanes_frenzy,if=combo_points>=2&(!talent.bloodtalons.enabled|buff.bloodtalons.up)
                if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) then
                    if combo >= 2 and (not talent.bloodtalons or buff.bloodtalons.exists()) then
                        if cast.ashamanesFrenzy(units.dyn5) then return end
                    end
                end
        -- Shadowmeld
                -- shadowmeld,if=combo_points<5&energy>=action.rake.cost&dot.rake.pmultiplier<2.1&buff.tigers_fury.up&(buff.bloodtalons.up|!talent.bloodtalons.enabled)&(!talent.incarnation.enabled|cooldown.incarnation.remains>18)&!buff.incarnation.up
                if useCDs() and isChecked("Racial") and br.player.race == "NightElf" and getSpellCD(racial) == 0 and getDistance(units.dyn5) < 5 and not solo and friendsInRange > 0 then
                    if combo < 5 and power >= select(1, getSpellCost(spell.rake)) and debuff.rake.applied(units.dyn5) < 2.1 and buff.tigersFury.exists()
                        and (buff.bloodtalons.exists() or not talent.bloodtalons) and (not talent.incarnationKingOfTheJungle or cd.incarnationKingOfTheJungle.remain() > 18)
                        and not buff.incarnationKingOfTheJungle.exists()
                    then
                        if cast.shadowmeld() then return end
                    end
                end
        -- Trinkets
                -- if=buff.tigers_fury.up&energy.time_to_max>3&(!talent.savage_roar.enabled|buff.savage_roar.up)
                if useCDs() and isChecked("Trinkets") and getDistance(units.dyn5) < 5 then
                    if buff.tigersFury.exists() and (not talent.savageRoar or buff.savageRoar.exists()) then
                        if canUse(13) and not (hasEquiped(147011,13) or hasEquiped(147012,13) or hasEquiped(140808,13) or hasEquiped(151190,13)) then
                            useItem(13)
                        end
                        if canUse(14) and not (hasEquiped(147011,14) or hasEquiped(147012,14) or hasEquiped(140808,14) or hasEquiped(151190,14)) then
                            useItem(14)
                        end
                    end
                end
        -- Draught of Souls
                if isChecked("Draught of Souls") and hasEquiped(140808) and canUse(140808) and useCDs() then
                    if (buff.savageRaor.exists() or not talent.savageRoar) and ttm > 3 and comboDeficit >= 1 then
                        useItem(140808)
                    end
                end
        -- Ring of Collapsing Futures
                -- use_item,slot=finger1
                if isChecked("Ring of Collapsing Futures") then
                    if hasEquiped(142173) and canUse(142173) and getDebuffStacks("player",234143) < getOptionValue("Ring of Collapsing Futures") and select(2,IsInInstance()) ~= "pvp" then
                        useItem(142173)
                        return true
                    end
                end
        -- Specter of Betrayal
                if (getOptionValue("Specter of Betrayal") == 1 or (getOptionValue("Specter of Betrayal") == 2 and useCDs())) then
                    if hasEquiped(151190) and canUse(151190) then
                        useItem(151190)
                    end
                end
        -- Umbral Moonglaives
                if isChecked("Umbral Moonglaives") and hasEquiped(147012) and canUse(147012) and useCDs() then
                    if (mode.rotation == 1 and #enemies.yards8 >= 2) or mode.rotation == 2 then
                        useItem(147012)
                    end
                end
        -- Vial of Ceaseless Toxins
                if isChecked("Vial of Ceaseless Toxins") and hasEquiped(147011) and canUse(147011) then
                    if buff.tigersFury.exists() or ttd(units.dyn5) <= cd.tigersFury.remain() then
                        useItem(147011)
                    end
                end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury,buff.tigers_fury | berserking,buff.tigers_fury | arcane_torrent,buff.tigers_fury
                if useCDs() and isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                    if buff.tigersFury.exists() and getSpellCD(racial) == 0 then
                        if castSpell("player",racial,false,false,false) then return end
                    end
                end
            end -- End useCooldowns check
        end -- End Action List - Cooldowns
        local function actionList_AMR_Cooldowns()
            if getDistance("target") < 5 then
        -- Tiger's Fury
                -- if (not HasBuff(Clearcasting) and PowerToMax >= 60) or PowerToMax >= 80
                if isChecked("Tiger's Fury") then
                    if (not buff.clearcasting.exists() and powerDeficit >= 60) or powerDeficit >= 80 then
                        if cast.tigersFury() then return end
                    end
                end
        -- Incarnation - King of the Jungle
                -- if HasBuff(TigersFury)
                if useCDs() and isChecked("Berserk/Incarnation") then
                    if buff.tigersFury.exists() and talent.incarnationKingOfTheJungle then
                        if cast.incarnationKingOfTheJungle() then return end
                    end
                end
        -- Berserk
                -- if HasBuff(TigersFury)
                if useCDs() and isChecked("Berserk/Incarnation") then
                    if buff.tigersFury.exists() and not talent.incarnationKingOfTheJungle then
                        if cast.berserk() then return end
                    end
                end
                if buff.tigersFury.exists() or buff.incarnationKingOfTheJungle.remain() > 20 or ttd(units.dyn5) < 30 then
        -- Potion
                    -- if HasBuff(Berserk) or FightSecRemaining < BuffDurationSec(PotionOfProlongedPower) + 5
                    -- if HasBuff(Berserk) or FightSecRemaining < BuffDurationSec(PotionOfTheOldWar) + 5
                    if useCDs() and isChecked("Potion") and inRaid then
                        if ttd(units.dyn5) < 65 or buff.berserk.exists() or buff.incarnationKingOfTheJungle.exists() then
                            if canUse(127844) then
                                useItem(127844)
                            elseif canUse(142117) then
                                useItem(142117)
                            end
                        end
                    end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                    -- blood_fury,buff.tigers_fury | berserking,buff.tigers_fury | arcane_torrent,buff.tigers_fury
                    if useCDs() and isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                        if buff.tigersFury.exists() and getSpellCD(racial) == 0 then
                            if castSpell("player",racial,false,false,false) then return end
                        end
                    end
        -- Trinkets
                    if useCDs() and isChecked("Trinkets") and getDistance(units.dyn5) < 5 then
                        if canUse(13) and not (hasEquiped(147011,13) or hasEquiped(147012,13) or hasEquiped(140808,13) or hasEquiped(151190,13)) then
                            useItem(13)
                        end
                        if canUse(14) and not (hasEquiped(147011,14) or hasEquiped(147012,14) or hasEquiped(140808,14) or hasEquiped(151190,14)) then
                            useItem(14)
                        end
                    end
        -- Draught of Souls
                    -- if (HasBuff(SavageRoar) or not HasTalent(SavageRoar)) and PowerSecToMax > 3 and AlternatePowerToMax >= 1
                    if isChecked("Draught of Souls") and hasEquiped(140808) and canUse(140808) and useCDs() then
                        if (buff.savageRaor.exists() or not talent.savageRoar) and ttm > 3 and comboDeficit >= 1 then
                            useItem(140808)
                        end
                    end
        -- Umbral Moonglaives
                    -- is a cooldown saved for AoE - AoE count = 2 - AoE radius = 8
                    if isChecked("Umbral Moonglaives") and hasEquiped(147012) and canUse(147012) and useCDs() then
                        if (mode.rotation == 1 and #enemies.yards8 >= 2) or mode.rotation == 2 then
                            useItem(147012)
                        end
                    end
        -- Vial of Ceaseless Toxins
                    -- if TargetsInRange = 1 or TargetSecUntilDeath < 20
                    if isChecked("Vial of Ceaseless Toxins") and hasEquiped(147011) and canUse(147011) then
                        if (mode.rotation == 1 and #enemies.yards5 == 1) or mode.rotation == 3 or ttd(units.dyn5) < 20 then
                            useItem(147011)
                        end
                    end
        -- Ring of Collapsing Futures
                    -- use_item,slot=finger1
                    if isChecked("Ring of Collapsing Futures") then
                        if hasEquiped(142173) and canUse(142173) and getDebuffStacks("player",234143) < getOptionValue("Ring of Collapsing Futures") and select(2,IsInInstance()) ~= "pvp" then
                            useItem(142173)
                            return true
                        end
                    end
        -- Specter of Betrayal
                    if (getOptionValue("Specter of Betrayal") == 1 or (getOptionValue("Specter of Betrayal") == 2 and useCDs())) then
                        if hasEquiped(151190) and canUse(151190) then
                            useItem(151190)
                        end
                    end
                end     
        -- Prowl
                if useCDs() and talent.incarnationKingOfTheJungle and buff.incarnationKingOfTheJungle.exists() and freeProwl and not buff.prowl.exists() and not solo and friendsInRange > 0 then
                    if cast.prowl() then freeProwl = false; return end
                end      
            end -- End useCooldowns check
        end -- End Action List - Cooldowns
    -- Action List - Opener
        function actionList_Opener()
        -- Wild Charge
            if isChecked("Wild Charge") and isValidUnit("target") and getDistance("target") >= 8 and getDistance("target") < 30 then
                if cast.wildCharge("target") then return end
            end
		-- Start Attack
            -- auto_attack
            if isChecked("Opener") and isBoss("target") and opener == false then
                if isValidUnit("target") and getDistance("target") < 5 then
					if not OPN1 then 
                        Print("Starting Opener")
                        OPN1 = true
                    elseif (not RK1 or not debuff.rake.exists("target")) then
                        Print("Rake")
            -- Rake
                        -- rake,if=!ticking|buff.prowl.up
                        if not debuff.rake.exists() or buff.prowl.exists() then
       					    if castOpener("rake","RK1",1) then return end
                        else
                            Print("1: Rake (Uncastable)")
                            RK1 = true
                        end
                    elseif RK1 and not MF1 then
            -- Moonfire
                        -- moonfire_cat,if=talent.lunar_inspiration.enabled&!ticking  
                        if talent.lunarInspiration and not debuff.moonfire.exists("target") then
                            if castOpener("moonfire","MF1",2) then return end
                        else
                            Print("2: Moonfire (Uncastable)")
                            MF1 = true
                        end
                    elseif MF1 and not SR1 then
       		-- Savage Roar
                        -- savage_roar,if=!buff.savage_roar.up
                        if talent.savageRoar and buff.savageRoar.refresh() then
       					    if castOpener("savageRoar","SR1",3) then return end
                        else
                            Print("3: Savage Roar (Uncastable)")
                            SR1 = true
                        end
       				elseif SR1 and not BER1 then
          	-- Berserk
                        -- berserk
                        -- incarnation
						if useCDs() and isChecked("Berserk/Incarnation") then
                            if talent.incarnationKingOfTheJungle then
                                if castOpener("incarnationKingOfTheJungle","BER1",4) then return end
                            else
                                if castOpener("berserk","BER1",4) then return end
                            end
						else
							Print("4: Berserk/Incarnation (Uncastable)")
							BER1 = true
						end
                    elseif BER1 and not TF1 then
            -- Tiger's Fury
                        -- tigers_fury
                        if isChecked("Tiger's Fury") then
                            if castOpener("tigersFury","TF1",5) then return end
                        else
                            Print("5: Tiger's Fury (Uncastable)")
                            TF1 = true
                        end
					elseif TF1 and not AF1 then
          	-- Ashamane's Frenzy
                        -- ashamanes_frenzy
						if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) then
                			if castOpener("ashamanesFrenzy","AF1",6) then return end
						else
							Print("6: Ashamane's Frenzy (Uncastable)")
							AF1 = true
						end
			  		elseif AF1 and not REG1 then
            -- Regrowth
                        -- regrowth,if=(talent.sabertooth.enabled|buff.predatory_swiftness.up)&talent.bloodtalons.enabled&buff.bloodtalons.down&combo_points=5
                        if (talent.sabertooth or buff.predatorySwiftness.exists()) and talent.bloodtalons and not buff.bloodtalons.exists() and combo == 5 then
                            if castOpener("regrowth","REG1",7) then return end
                        else
                            Print("7: Regrowth (Uncastable)")
                            REG1 = true
                        end
					elseif REG1 and not RIP1 then
       		-- Rip
                        -- rip,if=combo_points=5
                        if combo == 5 then
					        if castOpener("rip","RIP1",8) then return end
                        else
                            Print("8: Rip (Uncastable)")
                            RIP1 = true
                        end
                    elseif RIP1 and not THR1 then
            -- Thrash
                        -- thrash_cat,if=!ticking&variable.use_thrash>0
                        if not debuff.thrash.exists("target") and useThrash > 0 then
                            if castOpener("thrash","THR1",9) then return end
                        else
                            Print("9: Thrash (Uncastable)")
                            THR1 = true
                        end
                    elseif THR1 and (not SHR1 or (combo < 5 and (buff.savageRoar.exists() or not talent.savageRoar))) then
            -- Shred
                        if shredCount == nil then shredCount = 10 end
                        if castOpener("shred","SHR1",shredCount) then shredCount = shredCount + 1 return end
                    elseif SHR1 and (RIP1 and (not buff.savageRoar.exists() or combo == 5)) then
       					opener = true;
						Print("Opener Complete")
       					return
       				end
                end
			elseif (UnitExists("target") and not isBoss("target")) or not isChecked("Opener") then
				opener = true
			end
        end -- End Action List - Opener
    -- Action List - Finisher
        local function actionList_SimC_Finisher()
        -- Savage Roar
            -- pool_resource,for_next=1
            -- savage_roar,if=!buff.savage_roar.up
            if not buff.savageRoar.exists() then
                if power <= select(1, getSpellCost(spell.savageRoar)) then
                    return true
                elseif power > select(1, getSpellCost(spell.savageRoar)) then
                    if cast.savageRoar("player") then return end
                end
            end
        -- Rip
            -- pool_resource,for_next=1
            -- rip,target_if=!ticking|(remains<=duration*0.3)&(target.health.pct>25&!talent.sabertooth.enabled)|(remains<=duration*0.8&persistent_multiplier>dot.rip.pmultiplier)&target.time_to_die>8
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    if getDistance(thisUnit) < 5 then
                        if (not debuff.rip.exists(thisUnit) or (debuff.rip.refresh(thisUnit) and getHP(thisUnit) > 25 and not talent.sabertooth) 
                            or (debuff.rip.remain(thisUnit) <= debuff.rip.duration(thisUnit) * 0.8 and debuff.rip.calc() > debuff.rip.applied(thisUnit))) and (ttd(thisUnit) > 8 or isDummy(thisUnit))
                        then
                            if power <= select(1, getSpellCost(spell.rip)) then
                                return true
                            elseif power > select(1, getSpellCost(spell.rip)) then
                                if cast.rip(thisUnit) then return end
                            end
                        end
                    end
                end
            end
        -- Savage Roar
            -- pool_resource,for_next=1
            -- savage_roar,if=buff.savage_roar.remains<12
            if buff.savageRoar.remain() < 12 then
                if power <= select(1, getSpellCost(spell.savageRoar)) then
                    return true
                elseif power > select(1, getSpellCost(spell.savageRoar)) then
                    if cast.savageRoar("player") then return end
                end
            end
        -- Maim
            -- maim,if=buff.fiery_red_maimers.up
            if buff.fieryRedMaimers.exists() then 
                if cast.maim(units.dyn5) then return end
            end
        -- Ferocious Bite
            -- ferocious_bite,max_energy=1
            if fbMaxEnergy then
                if cast.ferociousBite() then return end
            end
        end
    -- Action List - Finisher
        local function actionList_AMR_Finisher()
        -- Rip
            -- if (AlternatePower * FeralBleedSnapshot) > PeekSavedValue(RipBuffs) and (HasBuff(SavageRoar) or not HasTalent(SavageRoar))
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    if debuff.rip.calc() > debuff.rip.applied(thisUnit) 
                        and (buff.savageRoar.exists() or not talent.savageRoar) 
                    then
                        if cast.rip(thisUnit) then return end
                    end
                end
            end
        -- Ferocious Bite
            -- if HasDot(Rip) and (HasTalent(Sabertooth) or TargetHealthPercent < 0.25) and (HasBuff(SavageRoar) or not HasTalent(SavageRoar))
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    if debuff.rip.exists(thisUnit) and (talent.sabertooth or getHP(units.dyn5) < 25) 
                        and (buff.savageRoar.exists() or not talent.savageRoar)
                    then
                        if cast.ferociousBite(thisUnit) then return end
                    end
                end
            end
        -- Rip
            -- if CanRefreshDot(Rip) and (HasBuff(SavageRoar) or not HasTalent(SavageRoar)) and not HasTalent(Sabertooth) - multi-DoT = 5
            if debuff.rip.count() < 5 then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if debuff.rip.refresh(thisUnit) and (buff.savageRoar.exists() or not talent.savageRoar) and not talent.sabertooth then
                            if cast.rip(thisUnit) then return end
                        end
                    end
                end
            end
        -- Savage Roar
            -- if BuffRemainingSec(SavageRoar) <= 12
            if buff.savageRoar.remain() <= 12 then
                if cast.savageRoar("player") then return end
            end
        -- Maim
            -- if HasBuff(FieryRedMaimers)
            if buff.fieryRedMaimers.exists() then 
                if cast.maim(units.dyn5) then return end
            end
        -- Ferocious Bite
            -- if Power >= FerociousBiteMaxEnergy and (DotRemainingSec(Rip) >= 8 or not HasTalent(SavageRoar))
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    if fbMaxEnergy and (debuff.rip.remain(thisUnit) >= 8 or not talent.savageRoar) then
                        if cast.ferociousBite(thisUnit) then return end
                    end
                end
            end
        -- Rip
            -- if Power >= FerociousBiteMaxEnergy
            if fbMaxEnergy then
                if cast.rip() then return end
            end
        end -- End Action List - Finisher
    -- Action List - AOE
        local function actionList_AMR_AOE()
        -- Thrash
            -- if CanRefreshDot(ThrashBleedFeral) and HasSetBonus(19,2)
            if debuff.thrash.refresh() and t19_2pc then
                if cast.thrash() then return end
            end
        -- Brutal Slash
            -- if not CanRefreshDot(ThrashBleedFeral) or not HasSetBonus(19,2)
            if (not debuff.thrash.refresh() or not t19_2pc) and talent.brutalSlash then
                if cast.brutalSlash() then return end
            end
        -- Thrash
            -- if HasItem(LuffaWrappings)
            if hasEquiped(137056) then
                if cast.thrash() then return end
            end
        -- Swipe 
            -- if not CanRefreshDot(ThrashBleedFeral) or not HasSetBonus(19,2)
            if (not debuff.thrash.refresh() or not t19_2pc) and not talent.brutalSlash then
                if cast.swipe() then return end
            end
        end -- End Action List - AOE
    -- Action List - Generator
        local function actionList_SimC_Generator()
    -- Regrowth
            -- regrowth,if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&buff.bloodtalons.down&combo_points>=2&cooldown.ashamanes_frenzy.remains<gcd
            -- regrowth,if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&buff.bloodtalons.down&combo_points=4&dot.rake.remains<4
            -- regrowth,if=equipped.ailuro_pouncers&talent.bloodtalons.enabled&(buff.predatory_swiftness.stack>2|(buff.predatory_swiftness.stack>1&dot.rake.remains<3))&buff.bloodtalons.down
            if talent.bloodtalons and not buff.bloodtalons.exists() then
                if (buff.predatorySwiftness.exists() and ((combo >= 2 and cd.ashamanesFrenzy.remain() < gcd) or (combo == 4 and debuff.rake.remain(units.dyn5) < 4))) 
                    or (hasEquiped(137024) and (buff.predatorySwiftness.stack() > 2 or (buff.predatorySwiftness.stack() > 1 and debuff.rake.remain(units.dyn5) < 3)))
                then
                    if getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40 then
                        if cast.regrowth(br.friend[1].unit) then return end
                    end
                    if getOptionValue("Auto Heal")==2 then
                        if cast.regrowth("player") then return end
                    end
                end                
            end
        -- Brutal Slash
            -- brutal_slash,if=spell_targets.brutal_slash>desired_targets
            if talent.brutalSlash and ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Brutal Slash Targets")) or mode.rotation == 2) then
                if cast.brutalSlash(units.dyn8) then return end
            end
        -- Thrash
            -- pool_resource,for_next=1
            -- thrash_cat,if=(!ticking|remains<duration*0.3)&(spell_targets.thrash_cat>2)
            if multidot then
                if (not debuff.thrash.exists(units.dyn8AoE) or debuff.thrash.refresh(units.dyn8AoE)) and ((mode.rotation == 1 and #enemies.yards8 >= 2) or mode.rotation == 2) then
                   if power <= select(1, getSpellCost(spell.thrash)) and not buff.clearcasting.exists() then
                        return true
                    elseif power > select(1, getSpellCost(spell.thrash)) or buff.clearcasting.exists() then
                        if cast.thrash("player") then return end
                    end
                end
            end
        -- Rake
            -- pool_resource,for_next=1
            -- rake,target_if=!ticking|(!talent.bloodtalons.enabled&remains<duration*0.3)&target.time_to_die>4
            -- rake,target_if=talent.bloodtalons.enabled&buff.bloodtalons.up&((remains<=7)&persistent_multiplier>dot.rake.pmultiplier*0.85)&target.time_to_die>4
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) and getDistance(thisUnit) < 5 then
                    if ((not debuff.rake.exists(thisUnit) or (not talent.bloodtalons and debuff.rake.refresh(thisUnit)))
                            or (talent.bloodtalons and buff.bloodtalons.exists() and debuff.rake.remain(thisUnit) <= 7 and debuff.rake.calc() > debuff.rake.applied(thisUnit) * 0.85))
                        and (ttd(thisUnit) > 4 or isDummy(thisUnit))
                    then
                        if power <= select(1, getSpellCost(spell.rake)) then
                            return true
                        elseif power > select(1, getSpellCost(spell.rake)) then
                            if cast.rake(thisUnit) then return end
                        end
                    end
                end
            end
        -- Brutal Slash
            -- brutal_slash,if=(buff.tigers_fury.up&(raid_event.adds.in>(1+max_charges-charges_fractional)*recharge_time))
            if talent.brutalSlash and buff.tigersFury.exists() and charges.brutalSlash.frac() > 2.66 then
                if cast.brutalSlash(units.dyn8) then return end
            end
        -- Moonfire
            -- moonfire_cat,target_if=remains<=duration*0.3
            if talent.lunarInspiration then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                        if debuff.moonfire.refresh(thisUnit) or (isDummy(thisUnit) and getDistance(thisUnit) < 8) then
                           if cast.moonfire(thisUnit) then return end
                        end
                    end
                end
            end
        -- Thrash
            -- pool_resource,for_next=1
            -- thrash_cat,if=(!ticking|remains<duration*0.3)&(variable.use_thrash=2|spell_targets.thrash_cat>1)
            -- thrash_cat,if=(!ticking|remains<duration*0.3)&variable.use_thrash=1&buff.clearcasting.react
            if multidot and (not debuff.thrash.exists(units.dyn8AoE) or debuff.thrash.refresh(units.dyn8AoE)) 
                and ((useThrash == 2 or ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0)))
                    or (useThrash == 1 and buff.clearcasting.exists()))
            then
                if power <= select(1, getSpellCost(spell.thrash)) and not buff.clearcasting.exists() then
                    return true
                elseif power > select(1, getSpellCost(spell.thrash)) or buff.clearcasting.exists() then
                    if cast.thrash("player") then return end
                end
            end
        -- Swipe
            -- pool_resource,for_next=1
            -- swipe_cat,if=spell_targets.swipe_cat>1
            if not talent.brutalSlash and multidot and ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                if power <= select(1, getSpellCost(spell.swipe)) and not buff.clearcasting.exists() then
                    return true
                elseif power > select(1, getSpellCost(spell.swipe)) or buff.clearcasting.exists() then
                    if cast.swipe("player") then return end
                end
            end
        -- Shred
            -- shred
            if (debuff.rake.exists(units.dyn5) or level < 12 or ttm < 1 or buff.clearcasting.exists()) 
                --and ((mode.rotation == 1 and (#enemies.yards8 < 2 or level < 32 or (talent.brutalSlash and charges.brutalSlash.count() == 0))) or mode.rotation == 3) 
            then
                if cast.shred() then return end
            end
        end
    -- Action List - Generator
        local function actionList_AMR_Generator()
        -- Shadowmeld
            -- if HasBuff(TigersFury) and (HasBuff(SavageRoar) or not HasTalent(SavageRoar)) and (HasBuff(Bloodtalons) or not HasTalent(Bloodtalons)) and CanUse(Rake)
            if isChecked("Racial") and br.player.race == "NightElf" and getSpellCD(racial) == 0 and getDistance(units.dyn5) < 5 and not solo and friendsInRange > 0 then
                if buff.tigersFury.exists() and (buff.savageRoar.exists() or not talent.savageRoar) and (buff.bloodtalons.exists() or not talent.bloodtalons) then
                    if cast.shadowmeld() then return end
                end
            end
        -- Rake
            -- if not HasDot(RakeBleed)
            if not debuff.rake.exists(units.dyn5) then
                if cast.rake() then return end
            end
            -- if not HasTalent(Bloodtalons) and CanRefreshDot(RakeBleed)
            if debuff.rake.count() < 3 then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if not talent.bloodtalons and debuff.rake.refresh(thisUnit) then
                            if cast.rake(thisUnit) then return end
                        end
                    end
                end
            end
            -- if HasTalent(Bloodtalons) and HasBuff(Bloodtalons) and DotRemainingSec(RakeBleed) <= 5 and 
            -- TargetSecUntilDeath > DotDurationSec(RakeBleed) / 2 and 
            -- (FeralBleedSnapshot > PeekSavedValue(RakeBuffs) * 0.8 or 
            -- (FeralBleedSnapshot * 2 > PeekSavedValue(RakeBuffs) * 0.8 and HasBuff(IncarnationKingOfTheJungle)))
            if talent.bloodtalons and buff.bloodtalons.exists() and debuff.rake.remain(units.dyn5) <= 5 and ttd(units.dyn5) > debuff.rake.duration(units.dyn5) / 2 
                and (debuff.rake.calc() > debuff.rake.applied(units.dyn5) * 0.8 or (debuff.rake.calc() * 2 > debuff.rake.applied(units.dyn5) * 0.8 and buff.incarnationKingOfTheJungle.exists()))
            then
                if cast.rake() then return end
            end
            -- if HasTalent(Bloodtalons) and HasBuff(Bloodtalons) and DotRemainingSec(RakeBleed) <= 5 and TargetsInRadius(Swipe) > 1 and 
            -- TargetSecUntilDeath > DotDurationSec(RakeBleed) / 2 and 
            -- (FeralBleedSnapshot > PeekSavedValue(RakeBuffs) * 0.8 or 
            -- (FeralBleedSnapshot * 2 > PeekSavedValue(RakeBuffs) * 0.8 and HasBuff(IncarnationKingOfTheJungle)))
            -- multi-DoT = 3
            if debuff.rake.count() < 3 then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if talent.bloodtalons and buff.bloodtalons.exists() and debuff.rake.remain(thisUnit) <= 5 and ttd(thisUnit) > debuff.rake.duration(thisUnit) / 2 
                            and (debuff.rake.calc() > debuff.rake.applied(thisUnit) * 0.8 or (debuff.rake.calc() * 2 > debuff.rake.applied(thisUnit) * 0.8 and buff.incarnationKingOfTheJungle.exists()))
                        then
                            if cast.rake(thisUnit) then return end
                        end
                    end
                end
            end
        -- Brutal Slash
            -- if Power >= SpellPowerCost(Rake) and ((ChargesRemaining(BrutalSlash) >= 2 and ChargeSecRemaining(BrutalSlash) <= GlobalCooldownSec) or 
            -- TargetsInRadius(BrutalSlash) > 1 or FightSecRemaining < ChargesRemaining(BrutalSlash) * SpellCooldownSec(BrutalSlash))
            if talent.brutalSlash and power >= select(1, getSpellCost(spell.rake)) and ((charges.brutalSlash.frac() >= 2 + gcd) 
                or ((mode.rotation == 1 and (#enemies.yards8 >= getOptionValue("Brutal Slash Targets") or ttd(units.dyn8) < charges.brutalSlash.count() * cd.brutalSlash.remain())) or mode.rotation == 2)) 
            then
                if cast.brutalSlash(units.dyn8) then return end
            end
        -- Moonfire
            -- if CanRefreshDot(MoonfireDoT) and HasDot(RakeBleed) and TargetSecUntilDeath > 10
            if talent.lunarInspiration and debuff.moonfire.count() < 5 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                        if (debuff.moonfire.refresh(thisUnit) or (isDummy(thisUnit) and getDistance(thisUnit) < 8)) and debuff.rake.exists(thisUnit) and ttd(thisUnit) > 10 then
                           if cast.moonfire(thisUnit) then return end
                        end
                    end
                end
            end
        -- Thrash
            -- if TargetsInRadius(Thrash) >= 3 and CanRefreshDot(ThrashBleedFeral)
            if multidot then
                if ((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0)) and debuff.thrash.refresh(units.dyn8AoE) then
                    if cast.thrash("player") then return end
                end
            end
        -- Swipe
            -- if TargetsInRadius(Swipe) >= 3 and not CanRefreshDot(ThrashBleedFeral)
            if not talent.brutalSlash and multidot and not debuff.thrash.refresh(units.dyn8) and ((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                if cast.swipe("player") then return end
            end
        -- Thrash
            -- if ArtifactTraitRank(ThrashingClaws) >= 4 and CanRefreshDot(ThrashBleedFeral) and HasItem(LuffaWrappings)
            if artifact.thrashingClaws.rank() >= 4 and debuff.thrash.refresh(units.dyn8) and hasEquiped(137056) then
                if cast.thrash("player") then return end
            end
            -- if HasSetBonus(19,4) and CanRefreshDot(ThrashBleedFeral) and HasBuff(Clearcasting) and not HasBuff(Bloodtalons)
            if t19_4pc and debuff.thrash.refresh(units.dyn8) and buff.clearcasting.exists() and not buff.bloodtalons.exists() then
                if cast.thrash("player") then return end
            end
        -- Shred
            -- if TargetsInRadius(Swipe) < 3 and (DotRemainingSec(RakeBleed) > DotIntervalSec(RakeBleed) or PowerToMax < 1)
            if (((mode.rotation == 1 and (#enemies.yards8 < 3 or (talent.brutalSlash and charges.brutalSlash.count() == 0))) or mode.rotation == 3) or level < 32 or ttm < 1)
                and (debuff.rake.remain(units.dyn5) > 2 or ttm < 1 or level < 12) 
            then
                if cast.shred() then return end
            end
        end
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then
                if not stealth then
        -- Flask / Crystal
                -- flask,type=flask_of_the_seventh_demon
                if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheSeventhDemon.exists() and canUse(item.flaskOfTheSeventhDemon) then
                    if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                    if buff.felFocus.exists() then buff.felFocus.cancel() end
                    if use.flaskOfTheSeventhDemon() then return end
                end
                if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and canUse(item.repurposedFelFocuser) then
                    if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                    if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                    if use.repurposedFelFocuser() then return end
                end
                if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUse(item.oraliusWhisperingCrystal) then
                    if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                    if buff.felFocus.exists() then buff.felFocus.cancel() end
                    if use.oraliusWhisperingCrystal() then return end
                end
        -- TODO: food,type=nightborne_delicacy_platte
        -- TOOD: augmentation,type=defiled
        -- Prowl - Non-PrePull
                    if cat and #enemies.yards20 > 0 and mode.prowl == 1 and not buff.prowl.exists() and not IsResting() and GetTime()-leftCombat > lootDelay then
                        for i = 1, #enemies.yards20 do
                            local thisUnit = enemies.yards20[i]
                            if UnitIsEnemy(thisUnit,"player") or isDummy("target") then
                                if cast.prowl("player") then return end
                            end
                        end
                    end
                end -- End No Stealth
        -- Wild Charge
                if isChecked("Displacer Beast / Wild Charge") and isValidUnit("target") then
                    if cast.wildCharge("target") then return end
                end
                if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
        -- Regrowth
                    -- regrowth,if=talent.bloodtalons.enabled
                    if talent.bloodtalons and not buff.bloodtalons.exists() and (htTimer == nil or htTimer < GetTime() - 1) then
                        if GetShapeshiftForm() ~= 0 then
                            -- CancelShapeshiftForm()
                            RunMacroText("/CancelForm")
                            if cast.regrowth("player") then htTimer = GetTime(); return end
                        else
                            if cast.regrowth("player") then htTimer = GetTime(); return end
                        end
                    end
		-- Incarnation - King of the Jungle
					if cast.incarnationKingOfTheJungle() then return end
        -- Prowl
                    if buff.bloodtalons.exists() and mode.prowl == 1 and not buff.prowl.exists() then
                        if cast.prowl("player") then return end
                    end
                    if buff.prowl.exists() then
        -- Pre-pot
                        -- potion,name=old_war
                        if useCDs() and isChecked("Potion") and inRaid then
                            if canUse(127844) then
                                useItem(127844)
                            elseif canUse(142117) then
                                useItem(142117)
                            end
                        end
                    end -- End Prowl
                end -- End Pre-Pull
        -- Rake/Shred
                -- buff.prowl.up|buff.shadowmeld.up
                if isValidUnit("target") and (not isBoss("target") or not isChecked("Opener")) then
                    if level < 12 then
                        if cast.shred("target") then return end
                    else
                       if cast.rake("target") then return end
                    end
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
			if actionList_Opener() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
        -- Cat is 4 fyte!
            -- if inCombat and not cat and not (flight or travel or IsMounted() or IsFlying() or falling) and isChecked("Auto Shapeshifts") then
            --     if cast.catForm("player") then return end
            -- else
            if inCombat and cat and profileStop==false and not isChecked("Death Cat Mode") and isValidUnit(units.dyn5) then
		-- Opener
				if actionList_Opener() then return end
        -- Wild Charge
                -- wild_charge
                if isChecked("Displacer Beast / Wild Charge") and isValidUnit("target") then
                    if cast.wildCharge("target") then return end
                end
        -- TODO: Displacer Beast
                -- displacer_beast,if=movement.distance>10
        -- TODO: Dash/Worgen Racial
                -- dash,if=movement.distance&buff.displacer_beast.down&buff.wild_charge_movement.down
        -- Rake/Shred from Stealth
                -- rake,if=buff.prowl.up|buff.shadowmeld.up
                if (buff.prowl.exists() or buff.shadowmeld.exists()) and opener == true then
                    -- if debuff.rake.exists(units.dyn5) or level < 12 then
                    if debuff.rake.calc() > debuff.rake.applied(thisUnit) * 0.85 and level >= 12 then
                        if cast.rake(units.dyn5) then return end
                    else
                        if cast.shred(units.dyn5) then return end
                    end
                elseif not (buff.prowl.exists() or buff.shadowmeld.exists()) and opener == true then
                    -- auto_attack
                    if getDistance("target") < 5 then
                        StartAttack()
                    end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                    if actionList_Interrupts() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                    if getOptionValue("APL Mode") == 1 then
    -----------------------------
    --- In Combat - Cooldowns ---
    -----------------------------
                        if actionList_SimC_Cooldowns() then return end
        -- Regrowth
                        -- regrowth,if=combo_points=5&talent.bloodtalons.enabled&buff.bloodtalons.down&(!buff.incarnation.up|dot.rip.remains<8|dot.rake.remains<5)
                        if combo == 5 and talent.bloodtalons and not buff.bloodtalons.exists() 
                            and (not buff.incarnationKingOfTheJungle.exists() or debuff.rip.remain(units.dyn5) < 8 or debuff.rake.remain(units.dyn5) < 5) 
                            and buff.predatorySwiftness.exists() 
                        then
                            if getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40 then
                                if cast.regrowth(br.friend[1].unit) then return end
                            end
                            if getOptionValue("Auto Heal")==2 then
                                if cast.regrowth("player") then return end
                            end
                        end
        -- Call Action List - Finisher
                        -- call_action_list,name=finisher
                        if combo > 4 then
                            if actionList_SimC_Finisher() then return end
                        end
        -- Call Action List - Generator
                        -- call_action_list,name=generator
                        if combo <= 4 then
                            if actionList_SimC_Generator() then return end
                        end
                    end -- End SimC APL
    ------------------------
    --- Ask Mr Robot APL ---
    ------------------------
                    if getOptionValue("APL Mode") == 2 then
    -----------------------------
    --- In Combat - Cooldowns ---
    -----------------------------
                        if actionList_AMR_Cooldowns() then return end
        -- Regrowth
                        -- if HasTalent(Bloodtalons) and HasBuff(PredatorySwiftness) and not HasBuff(Bloodtalons) and 
                        -- (AlternatePower >= 5 or BuffRemainingSec(PredatorySwiftness) <= GlobalCooldownSec or 
                        -- (AlternatePower = 2 and CooldownSecRemaining(AshamanesFrenzy) <= GlobalCooldownSec))
                        if talent.bloodtalons and buff.predatorySwiftness.exists() and not buff.bloodtalons.exists() 
                            and (combo >= 5 or buff.predatorySwiftness.remain() <= gcd or (combo == 2 and cd.ashamanesFrenzy.remain() <= gcd 
                            and artifact.ashamanesFrenzy.enabled() and (getOptionValue("Artifact") == 1 or (useCDs() and getOptionValue("Artifact") == 2))))
                        then
                            if getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40 then
                                if cast.regrowth(br.friend[1].unit) then return end
                            end
                            if getOptionValue("Auto Heal")==2 then
                                if cast.regrowth("player") then return end
                            end
                        end
                        -- if HasItem(AiluroPouncers) and HasTalent(Bloodtalons) and not HasBuff(Bloodtalons) and BuffStack(PredatorySwiftness) > 1
                        if hasEquiped(137024) and talent.bloodtalons and not buff.bloodtalons.exists() and buff.predatorySwiftness.stack() > 1 then
                           if getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40 then
                                if cast.regrowth(br.friend[1].unit) then return end
                            end
                            if getOptionValue("Auto Heal")==2 then
                                if cast.regrowth("player") then return end
                            end
                        end 
        -- Call Action List - Finisher
                        -- call_action_list,name=finisher
                        if combo >= 5 then
                            if actionList_AMR_Finisher() then return end
                        end
        -- Ashamane's Frenzy
                        -- if AlternatePowerToMax >= 3 and TimerSecRemaining(ElunesGuidanceTimer) = 0 and (HasBuff(Bloodtalons) or not HasTalent(Bloodtalons)) and (HasBuff(SavageRoar) or not HasTalent(SavageRoar))
                        if (getOptionValue("Artifact") == 1 or (useCDs() and getOptionValue("Artifact") == 2)) and comboDeficit >= 3 
                            and (buff.bloodtalons.exists or not talent.bloodtalons) and (buff.savageRoar.exists() or not talent.savageRoar)
                        then
                            if cast.ashamanesFrenzy() then return end
                        end
        -- Call Action List - AOE
                        -- if TargetsInRadius(Swipe) >= 5 and AlternatePower <= 4
                        if #enemies.yards8 >= 5 and mode.rotation ~= 3 and combo <= 4 then
                            if actionList_AMR_AOE() then return end
                        end
        -- Call Action List - Generator
                        -- if AlternatePower <= 4 and TargetsInRadius(Swipe) < 5
                        if combo <= 4 and (#enemies.yards8 < 5 or mode.rotation == 3) then
                            if actionList_AMR_Generator() then return end
                        end
                    end
			    end -- End No Stealth | Rotation Off Check
			end --End In Combat
		end --End Rotation Logic
    -- end -- End Timer
end -- End runRotation
local id = 103
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

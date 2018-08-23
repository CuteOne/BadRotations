local rotationName = "Panglo"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Automatic Rotation", tip = "Enables DPS Rotation", highlight = 1, icon = br.player.spell.swipe },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.regrowth}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.incarnationGuardianOfUrsoc },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.incarnationGuardianOfUrsoc },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.incarnationGuardianOfUrsoc }
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
        -- Travel Shapeshifts
            br.ui:createCheckbox(section,"Auto Shapeshifts","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to best form for situation.|cffFFBB00.")
        -- Displacer Beast / Wild Charge
            br.ui:createCheckbox(section,"Displacer Beast / Wild Charge","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Charge usage.|cffFFBB00.")
		-- Auto Maul
			br.ui:createCheckbox(section,"Auto Maul (SIMC)")
		-- Maul At
            br.ui:createSpinnerWithout(section, "Maul At",  90,  5,  100,  5,  "|cffFFFFFFSet to desired rage to cast Maul. Min: 5 / Max: 100 / Interval: 5")
		-- Auto Maul
			br.ui:createCheckbox(section,"Taunt")			
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Agi Pot
            br.ui:createCheckbox(section,"Agi-Pot")
        -- Flask / Crystal
            br.ui:createCheckbox(section,"Flask / Crystal")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Incarnation: King of the Jungle
            br.ui:createCheckbox(section,"Incarnation")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Barkskin
            br.ui:createSpinner(section, "Barkskin", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Frenzied Regeneration
            br.ui:createDropdown(section, "Frenzied Regeneration", {"|cff00FF00By HP Loss Percent","|cffFF0000By HP Interval"}, 1, "|cffFFFFFFSelect FR's use behavior.")
            br.ui:createSpinnerWithout(section, "FR - HP Loss Percent", 50, 0, 100, 5, "|cffFFBB00Health Loss Percentage to use at.")
            br.ui:createSpinnerWithout(section, "FR - HP Interval (2 Charge)", 65, 0, 100, 5, "|cffFFBB00Health Interval to use at with 2 charges.")
            br.ui:createSpinnerWithout(section, "FR - HP Interval (1 Charge)", 40, 0, 100, 5, "|cffFFBB00Health Interval to use at with 1 charge.")
        -- Ironfur
            br.ui:createCheckbox(section, "Ironfur")
        -- Rebirth
            br.ui:createCheckbox(section,"Rebirth")
            br.ui:createDropdownWithout(section, "Rebirth - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        -- Regrowth
            br.ui:createSpinner(section, "Regrowth",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Revive
            br.ui:createCheckbox(section,"Revive")
            br.ui:createDropdownWithout(section, "Revive - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        -- Survival Instincts
            br.ui:createSpinner(section, "Survival Instincts",  40,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Skull Bash
            br.ui:createCheckbox(section,"Skull Bash")
        -- Mighty Bash
            br.ui:createCheckbox(section,"Mighty Bash")
        -- Incapacitating Roar
            br.ui:createCheckbox(section,"Incapacitating Roar")
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
    if br.timer:useTimer("debugGuardian", math.random(0.15,0.3)) then
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
        local combatTime                                    = getCombatTime()
	    local combo                                         = br.player.power.comboPoints.amount()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = enemies or {}
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = GetObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lossPercent                                   = getHPLossPercent("player",5)
        local lowestHP                                      = br.friend[1].unit
        local mfTick                                        = 20.0/(1+UnitSpellHaste("player")/100)/10
        local mode                                          = br.player.mode
        local multidot                                      = br.player.mode.cleave
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local potion                                        = br.player.potion
        local power, powmax, powgen, powerDeficit           = br.player.power.rage.amount(), br.player.power.rage.max(), br.player.power.rage.regen(), br.player.power.rage.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local solo                                          = br.player.instance=="none"
        local snapLossHP                                    = 0
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local travel, flight, bear, cat, noform             = br.player.buff.travelForm.exists(), br.player.buff.flightForm.exists(), br.player.buff.bearForm.exists(), buff.catForm.exists(), GetShapeshiftForm()==0
        local trinketProc                                   = false
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.rage.ttm
        local units                                         = units or {}

        units.dyn5 = br.player.units(5)
	    units.dyn8 = br.player.units(8)
        units.dyn40 = br.player.units(40)
        enemies.yards5 = br.player.enemies(5)
        enemies.yards8 = br.player.enemies(8)
        enemies.yards10 = br.player.enemies(10)
        enemies.yards13 = br.player.enemies(13)
        enemies.yards20 = br.player.enemies(20)
        enemies.yards30 = br.player.enemies(30)
        enemies.yards40 = br.player.enemies(40)

   		if leftCombat == nil then leftCombat = GetTime() end
		if profileStop == nil then profileStop = false end
		if lastSpellCast == nil then lastSpellCast = spell.bearForm end
        if lastForm == nil then lastForm = 0 end
        if lossPercent > snapLossHP or php > snapLossHP then snapLossHP = lossPercent end

--------------------
--- Action Lists ---
--------------------
	-- Action List - Extras
		local function actionList_Extras()
		-- Shapeshift Form Management
			if isChecked("Auto Shapeshifts") and not UnitBuffID("player",202477) then
			-- Flight Form
				if IsFlyableArea() and ((not (isInDraenor() or isInLegion())) or isKnown(191633)) and not swimming and falling > 1 and level>=58 then
	                if cast.travelForm() then return end
		        end
			-- Aquatic Form
			    if swimming and not travel and not hastar and not deadtar then
				  	if cast.travelForm() then return end
				end
            -- Bear Form
                if not bear then
                    -- Cat Form when not in combat and target selected and within 20yrds
                    if not inCombat and isValidTarget("target") and (UnitIsEnemy("target","player") or isDummy("target")) then
                        if cast.bearForm() then return end
                    end
                    --Cat Form when in combat and not flying
                    if inCombat and not flying then
                        if cast.bearForm() then return end
                    end
                end
            end -- End Shapeshift Form Management
			        -- Torment
            if isChecked("Taunt") then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if not isAggroed(thisUnit) and hasThreat(thisUnit) then
                        if cast.growl(thisUnit) then return end
                    end
                end

            end

		end -- End Action List - Extras
    -- Action List - Defensive
        local function actionList_Defensive()
            if useDefensive() and not buff.prowl.exists() and not flight then
        -- Pot/Stoned
                if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned")
                    and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healPot) then
                        useItem(healPot)
                    end
                end
        -- Barkskin
                if isChecked("Barkskin") then
                    if php <= getOptionValue("Barkskin") and inCombat then
                        if cast.barkskin() then return end
                    end
                end
        -- Frenzied Regeneration
                if isChecked("Frenzied Regeneration") and cast.able.frenziedRegeneration() and not buff.frenziedRegeneration.exists() then
                    if getOptionValue("Frenzied Regeneration") == 1 and (snapLossHP >= getOptionValue("FR - HP Loss Percent") or (snapLossHP > php and snapLossHP > 5)) then
                        if cast.frenziedRegeneration() then snapLossHP = 0; return end
                    end
                    if getOptionValue("Frenzied Regeneration") == 2
                        and ((charges.frenziedRegeneration.count() >= 2 and php < getOptionValue("FR - HP Interval (2 Charge)"))
                        or (charges.frenziedRegeneration.count() >= 1 and php < getOptionValue("FR - HP Interval (1 Charge)")))
                    then
                        if cast.frenziedRegeneration() then return end
                    end
                end
        -- Regrowth
                if isChecked("Regrowth") then
                    if php <= getOptionValue("Regrowth") and not inCombat then
                        if cast.regrowth("player") then return end
                    end
                end
        --Revive/Rebirth
                if isChecked("Rebirth") then
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
                end
                if isChecked("Revive") then
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
        -- Survival Instincts
                if isChecked("Survival Instincts") then
                    if php <= getOptionValue("Survival Instincts") and inCombat and not buff.survivalInstincts.exists() then
                        if cast.survivalInstincts() then return end
                    end
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
        -- Incapacitating Roar
                if isChecked("Incapacitating Roar") then
                    for i=1, #enemies.yards10 do
                        thisUnit = enemies.yards10[i]
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if cast.incapacitatingRoar("player") then return end
                        end
                    end
                end
		 	end -- End useInterrupts check
		end -- End Action List - Interrupts
	-- Action List - Cooldowns
		local function actionList_Cooldowns()
			if useCDs() and getDistance(units.dyn5) < 5 then
		-- Trinkets
                -- TODO: if=(buff.tigers_fury.up&(target.time_to_die>trinket.stat.any.cooldown|target.time_to_die<45))|buff.incarnation.remain()s>20
				if isChecked("Trinkets") then
                    -- if (buff.tigersFury and (ttd(units.dyn5) > 60 or ttd(units.dyn5) < 45)) or buff.remain().incarnationKingOfTheJungle > 20 then
						if canUse(13) then
							useItem(13)
						end
						if canUse(14) then
							useItem(14)
						end
                    -- end
				end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury,buff.tigers_fury | berserking,buff.tigers_fury | arcane_torrent,buff.tigers_fury
                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Incarnation: Guardian of Ursoc
                if isChecked("Incarnation") then
                    if cast.incarnationGuardianOfUrsoc() then return end
                end
            end -- End useCooldowns check
        end -- End Action List - Cooldowns
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then
                if not buff.prowl.exists() then
        -- Flask / Crystal
                    -- flask,type=flask_of_the_seventh_demon
                    if isChecked("Flask / Crystal") and not stealth then
                        if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",188033) then
                            useItem(br.player.flask.wod.agilityBig)
                            return true
                        end
                        if flaskBuff==0 then
                            if not UnitBuffID("player",188033) and canUse(118922) then --Draenor Insanity Crystal
                                useItem(118922)
                                return true
                            end
                        end
                    end
                end -- End No Stealth
                if getDistance("target") < 5 and isValidUnit("target") then
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
        elseif (inCombat and profileStop==true) or pause() or mode.rotation==2 then
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
		if inCombat and bear and profileStop==false and isValidUnit("target") then

    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    -----------------------------
    --- In Combat - Cooldowns ---
    -----------------------------
                if actionList_Cooldowns() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
        -- Ironfur
                    -- ironfur,if=(buff.ironfur.up=0)|(buff.gory_fur.up=1)|(rage>=80)
                    if isChecked("Ironfur") and (not buff.ironfur.exists() or buff.goryFur.exists() or power >= 80 or buff.ironfur.remain() <1.5) then
                        if cast.ironfur() then return end
                    end
        -- Bristling Fur
                    -- bristling_fur,if=buff.ironfur.stack=1|buff.ironfur.down
                    if bearForm and power < 40 then
                        if cast.bristlingFur() then return end
                    end
        -- Lunar Beam
                    -- lunar_beam
                    if cast.lunarBeam() then return end
        -- Mangle
                    -- mangle
                    if cast.mangle() then return end
        -- Pulverize
                    if talent.pulverize then
                        for i = 1, #enemies.yards5 do
                            local thisUnit = enemies.yards5[i]
                            if debuff.thrash.stack(thisUnit) >= 3 then
                                if not buff.pulverize.exists() or (buff.pulverize.exists() and not (cast.able.mangle() or cast.able.thrash())) then
									if cast.pulverize(thisUnit) then return end
								end
							end
                        end
                    end
        -- Moonfire
                    -- moonfire,if=buff.incarnation.up=1&dot.moonfire.remains<=4.8
                    if #enemies.yards40 < 6 then
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if isValidUnit(thisUnit) then
                                -- moonfire,if=buff.galactic_guardian.up=1&(!ticking|dot.moonfire.remains<=4.8)
                                if buff.galacticGuardian.exists() and (not debuff.moonfire.exists(thisUnit) or debuff.moonfire.refresh(thisUnit)) then
                                    if cast.moonfire(thisUnit) then return end
                                end
                                -- moonfire,if=buff.galactic_guardian.up=1
                                if buff.galacticGuardian.exists() then
                                    if cast.moonfire(thisUnit) then return end
                                end
                            end
                        end
                    end
        -- Thrash
                    -- thrash_bear
                    if getDistance("target") < 8 and not buff.incarnationGuardianOfUrsoc.exists() or (buff.incarnationGuardianOfUrsoc.exists() and #enemies.yards8 > 6) then
                        if cast.thrash() then return end
                    end
        -- Moonfire
                    if #enemies.yards40 < 6 then
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if isValidUnit(thisUnit) then
                                -- moonfire,if=dot.moonfire.remains<=4.8
                                if debuff.moonfire.refresh(thisUnit) then
                                    if cast.moonfire(thisUnit) then return end
                                end
                            end
                        end
                    end
		-- Auto Maul
					if isChecked("Auto Maul (SIMC)") and powerDeficit < 10 and #enemies.yards8 < 4 then
						if cast.maul() then return end
					end

		-- Maul
                    if power >= getOptionValue("Maul At") then
                        if cast.maul() then return end
                    end
        -- Swipe
                    -- swipe_bear
                    if getDistance("target") < 8 and not (cast.able.thrash() or cast.able.mangle()) then
                        if cast.swipe() then return end
                    end
                end--End In Combat
			end --End Rotation Logic
		end -- End Timer
	end
   
local id = 104
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

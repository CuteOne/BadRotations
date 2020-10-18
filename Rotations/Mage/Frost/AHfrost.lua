
local rotationName = "AHfrost"

local colorPurple   = "|cffC942FD"
local colorBlue     = "|cff00CCFF"
local colorGreen    = "|cff00FF00"
local colorRed      = "|cffFF0000"
local colorWhite    = "|cffFFFFFF"
local colorGold     = "|cffFFDD11"
local colorLegendary= "|cffff8000"
local colorBlueMage = "|cff68ccef"


-----------
-- Toggles
-----------

local function createToggles()
	-- Rotation Button
	RotationModes = {
		[1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multi target automaticly.", highlight = 1, icon = br.player.spell.blizzard},
		[2] = { mode = "Multi", value = 2 , overlay = "Multi Target Rotation", tip = "Strictly Multitarget Rotation", highlight = 0, icon = br.player.spell.blizzard},
		[3] = { mode = "Single", value = 3 , overlay = "Single Target Rotation", tip = "Strictly Single Target", highlight = 0, icon = br.player.spell.blizzard},
		[4] = { mode = "Off", value = 4 , overlay = "Turned Off", tip = "Rotation Turned Off", highlight = 0, icon = br.player.spell.iceBlock }
    };
    CreateButton("Rotation",1,0)

        -- Cooldowns Button
        CooldownModes = { 
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic CDs", tip = "Automaticly uses Cooldowns on Bosses", highlight = 1, icon = br.player.spell.icyVeins},
            [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Uses CDs on everything", highlight = 0, icon = br.player.spell.icyVeins},
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "Never use CDs", highlight = 0, icon = br.player.spell.icyVeins}
    };
    CreateButton("Cooldown",2,0)

    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.iceBarrier },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.iceBarrier }
    };
    CreateButton("Defensive",3,0)

        -- Frozen Orb Modes
        FrozenOrbModes = {
            [1] = { mode = "On", value = 1 , overlay = "Automaticly uses Orb", tip = "Automatic use of Orb on everything", highlight = 1, icon = br.player.spell.frozenOrb},
            [2] = { mode = "Boss", value = 2 , overlay = "Orb on Bosses only", tip = "Only uses Orb on Boss Targets", highlight = 0, icon = br.player.spell.frozenOrb}
    };
    CreateButton("FrozenOrb",4,0)

    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterspell },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "Disabled Interrupts", highlight = 0, icon = br.player.spell.counterspell }
    };
    CreateButton("Interrupt",5,0)

end


----------
-- Options
----------
local function createOptions()
	local optionTable

	local function rotationOptions()


		-----------------------
		--- GENERAL OPTIONS --- -- Define General Options
		-----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
        br.ui:createCheckbox(section, "Dynamic Targetting")
        br.ui:createDropdownWithout(section, "Opener Mode", {colorWhite.."SimC", colorWhite.."Icy-Veins", colorWhite.."Ray of Frost"}, 1, colorWhite.."Set APL Mode to use.")
        br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  colorWhite.."Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        br.ui:createCheckbox(section, "Opener")
        br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  colorWhite.."Set to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        br.ui:createDropdownWithout(section, "Artifact", {colorWhite.."Everything",colorWhite.."Cooldowns",colorWhite.."Never"}, 1, colorWhite.."When to use Artifact Ability.")
        br.ui:createSpinnerWithout(section, "AOE targets",  3,  1,  100,  1,  "Minimum AOE targets. Min: 1 / Max: 100")
        br.ui:createCheckbox(section, "No Blizzard on STR")
        br.ui:checkSectionState(section)


        ------------------------
        --- ITEM OPTIONS --- -- Define Item Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Items")
        br.ui:createCheckbox(section, "Potion")
        br.ui:createCheckbox(section,"Flask / Crystal")
        br.ui:createDropdownWithout(section, "Trinket 1 Condition", {colorWhite.."On Cooldown",colorWhite.."On Boss Health",colorWhite.."On Self Health"}, 1, colorWhite.."On Cooldown = Use Trinket whenever available, value doesn't matter; On Boss Health = Use Trinket when boss health is below value; On Self Health = Use Trinket when your health is below value;")
        br.ui:createSpinner(section, "Trinket 1",  80,  0,  100,  5,  colorRed.."When to use Trinket 1")
        br.ui:createDropdownWithout(section, "Trinket 2 Condition", {colorWhite.."On Cooldown",colorWhite.."On Boss Health",colorWhite.."On Self Health"}, 1, colorWhite.."On Cooldown = Use Trinket whenever available, value doesn't matter; On Boss Health = Use Trinket when boss health is below value; On Self Health = Use Trinket when your health is below value;")
        br.ui:createSpinner(section, "Trinket 2",  60,  0,  100,  5,  colorRed.."When to use Trinket 2")
        br.ui:checkSectionState(section)

		------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
        br.ui:createCheckbox(section, "Use Racial")
        br.ui:createCheckbox(section, "Use Pet Spells")
        br.ui:createCheckbox(section, colorBlueMage.."Rune of Power")
        br.ui:createCheckbox(section, colorBlueMage.."Mirror Image")
        br.ui:createCheckbox(section, colorBlueMage.."Icy Veins")
        br.ui:createCheckbox(section, colorBlueMage.."Ray of Frost")
        br.ui:createCheckbox(section, colorBlueMage.."Frozen Orb")
        br.ui:createCheckbox(section, colorBlueMage.."Comet Storm")
        br.ui:createCheckbox(section, colorBlueMage.."Cone of Cold")
        br.ui:checkSectionState(section)

        ------------------------
        --- Pet OPTIONS --- -- 
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Pet")
            -- Auto Summon
            br.ui:createCheckbox(section,"Auto Summon")
            --Auto Attack
            br.ui:createCheckbox(section,"Pet Attack")
        br.ui:checkSectionState(section)

        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Pot/Stoned",  50,  0,  100,  5,  colorRed.."Health Percent to Cast At")
        br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  colorRed.."Health Percentage to use at.")
        br.ui:createSpinner(section, colorBlueMage.."Ice Barrier",  80,  0,  100,  5,  colorRed.."Health Percent to Cast At")
        br.ui:createSpinner(section, colorBlueMage.."Ice Block",  20,  0,  100,  5,  colorRed.."Health Percent to Cast At")
        br.ui:createCheckbox(section, colorBlueMage.."Cold Snap", colorWhite.."Use Cold Snap to reset Ice Block")
        br.ui:checkSectionState(section)

        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Couterspell
        br.ui:createCheckbox(section, "Counterspell")

        -- Interrupt Percentage
        br.ui:createSpinner(section,  "Interrupt at",  0,  0,  100,  1,  colorWhite.."Cast Percentage to use at.")

        br.ui:checkSectionState(section)

    end
        optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end


---------------------


---------------------

-----------
-- Rotation
-----------
local function runRotation()

	---------------
    --- Toggles --- -- List toggles here in order to update when pressed
    ---------------

    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Defensives",0.25)
    UpdateToggle("Frozen Orb",0.25)
    br.player.mode.frozenorb = br.data.settings[br.selectedSpec].toggles["FrozenOrb"]
    UpdateToggle("Interrupts",0.25)

    		---------
    		-- Locals
    		---------
    local artifact                                      = br.player.artifact
    local buff                                          = br.player.buff
    local cast                                          = br.player.cast
    local cd                                            = br.player.cd
    local charges                                       = br.player.charges
    local debuff                                        = br.player.debuff
    local spell                                         = br.player.spell
    local talent                                        = br.player.talent
    local mode                                          = br.player.mode
    local race                                          = br.player.race
    local gcd                                           = br.player.gcd
    local inCombat                                      = br.player.inCombat
    local pullTimer                                     = PullTimerRemain() --br.DBM:getPulltimer()
    local inInstance                                    = br.player.instance=="party"
    local inRaid                                        = br.player.instance=="raid"
    local health                                        = br.player.health
    local mode                                          = br.player.mode
    local debug                                         = false 
    local lastCast                                     = lastCast
    local ttd                                           = getTTD
    local enemies                                       = br.player.enemies
    local units                                         = br.player.units
    local t20_2pc                                       = TierScan("T20") >= 2
    local execute_time                                  = br.player.gcd
    local attacktar                                     = UnitCanAttack("target", "player")

    units.get(40)
    enemies.get(40)
    enemies.get(8,"target")

    if waitForPetToAppear == nil then waitForPetToAppear = 0 end

    if isChecked("Dynamic Targetting") then
        units.dyn40 = units.get(40)
        ttdUnit = ttd(units.dyn40)
        target = units.dyn40
    else
        ttdUnit = ttd("target")
        target = "target"
    end


    if not inCombat and not IsMounted() and isChecked("Auto Summon") and not GetUnitExists("pet") and (UnitIsDead("pet") ~= nil or UnitIsDead("pet") == false) then
        if waitForPetToAppear ~= nil and waitForPetToAppear < GetTime() - 2 and onlyOneTry ~= nil and not onlyOneTry then
            onlyOneTry = true
            if cast.summonWaterElemental("player") then return end
    end

   	if waitForPetToAppear == nil then
            waitForPetToAppear = GetTime()
    end
    else
        onlyOneTry = false
    end

    if lastCast == nil then lastCast = 61304 end

    if seq == nil then seq = 0 end

    local function actionList_INTERRUPT()
    	if useInterrupts() then
    		--actions=counterspell,if=target.debuff.casting.react
    		if isChecked("Counterspell") and cd.counterspell.remains() == 0 then
    			for i = 1, #enemies.yards40 do
    				local thisUnit = enemies.yards40[i]
    				if canInterrupt(thisUnit,getValue("Interrupt at")) then
    					if cast.counterspell(thisUnit) then return true end
    				end
    			end
    		end
    		--actions.cooldowns+=/arcane_torrent
    	end
    	return false
    end

    local function actionList_Pet()
    	if getHP("pet") < 20 
    		and GetUnitExists("pet")
    		then
    		print("Pet Dismiss - Low Health")
    		PetDismiss()
    	end

    	if isChecked("Auto Summon") and not GetUnitExists("pet") and (UnitIsDead("pet") ~= nil or UnitIsDead("pet") == false) then
    		if waitForPetToAppear < GetTime() - 2 then
    			if cast.summonWaterElemental("player") then waitForPetToAppear = GetTime(); return end
    		end
    	end

    	if isChecked("Pet Attack") then
    		if inCombat and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 then
    			if not GetUnitIsUnit(target,"pettarget") and attacktar and not IsPetAttackActive() then
    				PetAttack()
    				PetAssistMode()
    			end
    		end
    	end
    	return false
    end

    local function actionList_DEFENSIVE()
    	if useDefensive() then
    		-- Pot / Stoned
    		if isChecked("Pot/Stoned") and health <= getValue("Pot/Stoned") and inCombat and (hasHealthPot() or hasItem(5512)) then
    			if canUse(5512) then
    				useItem(5512) 
    				elseif canUse(getHealthPot()) then
    					useItem(getHeatlhPot())
    				end
    			end

    			-- Heirloom Neck
    			if isChecked("Heirloom Neck") and health <= getvalue("Heirloom Neck") then
    				if hasEquiped(122668) then
    					if GetItemCooldown(122668) == 0 then 
    						useItem(122668)
    					end
    				end
    			end

    			-- Ice Baerrier
    			if isChecked(colorBlueMage.."Ice Barrier") and health <= getValue(colorBlueMage.."Ice Barrier") and inCombat and not buff.iceBarrier.exists() then
    				if cast.iceBarrier("player") then return true end
    			end

    			-- IceBlock
    			if isChecked(colorBlueMage.."Ice Block") and health <= getValue(colorBlueMage.."Ice Block") and inCombat then
    				if isChecked(colorBlueMage.."Cold Snap") and cd.iceBlock.remain() > 0 then
    					if cast.coldSnap("player") then return true end
    				end
    				if cast.iceBlock("player") then return true end
    			end
    		end
    		return false
    	end


    	local function actionList_OPENER()

    		local function actionList_OPENER_SIMC()
    			if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") or inCombat then
    				--actions.precombat+=/mirror_image
    				if not MI then
    					if talent.mirrorImage and cd.mirrorImage.remain() and useCDs() and isChecked(colorBlueMage.."Mirror Image") then
    						seq = seq + 1 
    						if castOpener("mirrorImage","MI",seq, false) then return true end
    					else
    						MI = true
    					end
    					-- actions.precombat+=/potion
    					elseif POT then
    						if isChecked("Potion") then 
    							--potion
    							if canUse(163222) then
    								seq = seq + 1 
    								useItem(163222)
    								Print(seq..": Battle Potion Used!")
    							elseif canUse(152559) then
    								seq = seq + 1
    								useItem(152559)
    								Print(seq..": Rising Death Used!")
    							else 
    								seq = seq + 1
    								Print(seq..": Potion (Can't Use)")
    							end
    							POT = true
    						else
    							POT = true
    						end
    						--actions.precombat+=/frostbolt
    						elseif not FB then
    							seq = seq + 1
    							if castOpener("frostbolt","FB",seq) then return true end
    						else
    							opener = true
    							Print("--Opener Complete--")
    						end
    					end

    					return true
    				end

    				local function actionList_OPENER_ICYV()
    					if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") or inCombat then
    						if isChecked("Potion") then
    							if not POT then
    								--potion
    								if canUse(163222) then
    								seq = seq + 1 
    								useItem(163222)
    								Print(seq..": Battle Potion Used!")
    							elseif canUse(152559) then
    								seq = seq + 1
    								useItem(152559)
    								Print(seq..": Rising Death Used!")
    							else 
    								seq = seq + 1
    								Print(seq..": Potion (Can't Use)")
    							end
    							POT = true
    							return true
    						end
    					end

    					--mirror image
    					if not MI then
    						if talent.mirrorImage and cd.mirrorImage.remain() and useCDs() and isChecked(colorBlueMage.."Mirror Image") then
    							seq = seq + 1
    							if castOpener("mirrorImage","MI",seq, false) then return true end
    						else
                                MI = true
                            end
    							elseif not FB then
    								--ebonbolt
    								seq = seq + 1
    								if castOpener("frosbolt","FB",seq) then return true end
    							end
    						end

    					if inCombat then
    						--rune of power
    						if not ROP then
    							if talent.runeOfPower and charges.runeOfPower.count() > 0 and useCDs() and isChecked(colorBlueMage.."Rune of Power") and not buff.runeOfPower.exists() then
    								seq = seq + 1
    								if castOpener("runeOfPower","ROP",seq) then return true end
    							else
    								ROP = true
    							end

    							--icy veins
    							elseif not IV then
    								if cd.icyVeins.remain() == 0 and useCDs() and isChecked(colorBlueMage.."Icy Veins") then
    									seq = seq + 1
    									if castOpener("icyVeins","IV",seq,false) then return true end
    								else
    									IV = true
    								end
    								-- flurry
    								elseif not FLR then
    									if buff.brainFreeze.exists() then
    										seq = seq + 1
    										if castOpener("flurry","FLR",seq) then return true end
    									else 
    										FLR = true
    									end
    									--ice lance 
    									elseif not IL then
    										seq = seq + 1
    										if castOpener("iceLance","IL",seq) then return true end
    										--frozenorb
    									elseif not FRO then
    										if cd.frozenOrb.remain() == 0 and useCDs() and isChecked(colorBlueMage.."Frozen Orb") then
    											seq = seq + 1
    											if castOpener("frozenOrb","FRO",seq) then return true end
    										else
    											FRO = true
    										end
    									--frostfingers
    									elseif buff.fingersOfFrost.exists() then
    										if cast.iceLance(target) then
    											seq = seq + 1 
    											Print(seq..":Ice Lance")
    											return true 
    										else
    											seq = seq + 1
    											Print(seq..": Ice Lance (Uncastable")
    											return true
    										end
    										--glacial spike
    										elseif not GLP then
    											if buff.icicles.stack() == 5 then
    												seq = seq + 1
    												if castOpener("glacialSpike","GLP",seq) then return true end
    											else
    												GLP = true
    											end
    									--frostbolt
    									elseif not FB then
    										seq = seq + 1
    										if castOpener("frostbolt","FB",seq) then return true end
    									else
    										opener = true
    										Print("--Opener Complete--")
    									end
    									end
    									return true
    								end



		if not opener and isChecked("Opener") and isBoss(target) then
            if getOptionValue("Opener Mode") == 1 then--SimC
                if actionList_OPENER_SIMC() then return true end
            elseif getOptionValue("Opener Mode") == 2 then -- Icy Veins
                if actionList_OPENER_ICYV() then return true end
                end
        end

        return false

    end

    local function actionList_PRECOMBAT()
    	--actions.precombat=flask
    	if isChecked("Flask / Crystal") then
    		if inRaid and canUse(br.player.flask.wod.intellectBig) and not UnitBuffID("player",br.player.flask.wod.intellectBig) then
    			useItem(br.player.flask.wod.intellectBig)
    			return true
    		end
            if not UnitBuffID("player",br.player.flask.wod.intellectBig) and canUse(118922) then --Draenor Insanity Crystal
                useItem(118922)
                return true
            end
        end

        --actions.precombat+=/food
        --actions.precombat+=/augmentation,type=defiled
        --actions.precombat+=/water_elemental
        if not IsPetActive() and not talent.lonelyWinter then
            if cast.summonWaterElemental("player") then return true end
        end

        return false
    end

    local function SimCAPLMode()

    	        local function actionList_CD()
            if useCDs() then
                if isChecked(colorBlueMage.."Rune of Power") and talent.runeOfPower then
                    --actions.cooldowns=rune_of_power,if=cooldown.icy_veins.remains<cast_time|charges_fractional>1.9&cooldown.icy_veins.remains>10|buff.icy_veins.up|target.time_to_die.remains+5<charges_fractional*10
                    if cd.icyVeins.remain() <= getCastTime(spell.runeOfPower) or charges.runeOfPower.frac() > 1.9 and cd.icyVeins.remain() > 10 or buff.icyVeins.exists() or ttdUnit+5 < charges.runeOfPower.frac()*10 then
                        if debug == true then Print("Casting Rune Of Power") end
                        if cast.runeOfPower("player") then
                            if debug == true then Print("Casted Rune Of Power") end
                            return true
                        end
                    end
                end
                if isChecked("Potion") then
                    --actions.cooldowns+=/potion,if=cooldown.icy_veins.remains<1
                    if cd.icyVeins.remain() < 1 then
                        if canUse(163222) then
                            if useItem(163222) then return true end
                        elseif canUse(152559) then
                            if useItem(152559) then return true end
                        end
                    end
                end

                                --actions.cooldowns+=/icy_veins,if=buff.icy_veins.down
                if useCDs() and isChecked(colorBlueMage.."Icy Veins") and cd.icyVeins.remain() == 0 then
                    if not buff.icyVeins.exists() then
                        if debug == true then Print("Casting Icy Veins") end
                        if cast.icyVeins() then
                            if debug == true then Print("Casted Icy Veins") end
                            return true
                        end
                    end
                end


                if useCDs() and isChecked(colorBlueMage.."Mirror Image") and cd.mirrorImage.remain() == 0 then
                    --actions.cooldowns+=/mirror_image
                    if debug == true then Print("Casting Mirror Image") end
                    if cast.mirrorImage() then
                        if debug == true then Print("Casted Mirror Image") end
                        return true
                    end
                end

--actions.cooldowns+=/use_item
                
                if getOptionValue("Trinket 1 Condition") == 1 then 
                    if isChecked("Trinket 1") and inCombat and canUse(13) then
                        if useItem(13) then return true end
                    end
                end


                if getOptionValue("Trinket 1 Condition") == 2 then
                    if isChecked("Trinket 1") and inCombat then 
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if isBoss(thisUnit) and getHP(thisUnit) <= getValue("Trinket 1") and canUse(13) then
                                if useItem(13) then return true end
                            end
                        end
                    end
                end

                if getOptionValue("Trinket 1 Condition") == 3 then
                    if isChecked("Trinket 1") and inCombat and health <= getValue("Trinket 1") and canUse(13) then
                        if useItem(13) then return true end
                    end
                end
                
                if getOptionValue("Trinket 2 Condition") == 1 then 
                    if isChecked("Trinket 2") and inCombat and canUse(14) then
                        if useItem(14) then return true end
                    end
                end

                if getOptionValue("Trinket 1 Condition") == 2 then
                    if isChecked("Trinket 1") and inCombat then 
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if isBoss(thisUnit) and getHP(thisUnit) <= getValue("Trinket 1") and canUse(14) then
                                if useItem(14) then return true end
                            end
                        end
                    end
                end

                if getOptionValue("Trinket 2 Condition") == 3 then
                    if isChecked("Trinket 2") and inCombat and health <= getValue("Trinket 2") and canUse(14) then
                        if useItem(14) then return true end
                    end
                end

                
                --actions.cooldowns+=/berserking|actions.cooldowns+=/blood_fury
                if isChecked("Use Racial") then
                    if getSpellCD(br.player.getRacial()) == 0 and (race == "Orc" or race == "Troll") then
                        if debug == true then Print("Casting Racial") end
                        if br.player.castRacial() then
                            if debug == true then Print("Casted Racial") end
                            return true
                        end
                    end
                end
            end
            return false
        end

        local function actionList_AOE()

            --actions.aoe+=/frozen_orb
            if cd.frozenOrb.remain() == 0 and ((mode.frozenorb == 2 and isBoss(target)) or mode.frozenorb == 1) then
                if isChecked(colorBlueMage.."Frozen Orb") and getEnemiesInRect(15,55,false) > 0 then
                    if cast.frozenOrb() then return true end
                end
            end

            --actions.aoe+=/blizzard
            if  cd.blizzard.remain() == 0 then
                if #enemies.yards8t > 2 or #enemies.yards8t > 1 then
                    if cast.blizzard("targetGround", "ground", 1, blizzardRadius) then return true end
                end
            end
    	
            --actions.aoe+=/comet_storm
            if talent.cometStorm then
                if cd.cometStorm.remain() == 0 then
                    if isChecked(colorBlueMage.."Comet Storm")  and (IsStandingTime(2,target) or GetUnitSpeed(target) <= 3) then
                        if cast.cometStorm(target) then return true end
                    end
                end
            end

            --action.aoe+=/flurry+glacialspike_combo
            if lastCast == spell.glacialSpike and buff.brainFreeze.exists() then
            	if cast.flurry(target) then return true end
            end

            --action.aoe+=/icelance_frostfinger_frostboltcombo
            if buff.fingersOfFrost.stack() < 2 and lastCast == spell.frostbolt and not buff.brainFreeze.exists() then
            	if cast.iceLance(target) then return true end
            end

            --action.aoe+=/icelance_flurry_combo
            if lastCast == spell.flurry then
            	if cast.iceLance(target) then return true end
            end


            --action.aoe+=/flurry_lowicicles
            if buff.icicles.stack() < 3 and buff.brainFreeze.exists() and lastCast == spell.frostbolt then
            	if cast.flurry(target) then return true end
            end


            --action.aoe+=/ebonbolt
            if talent.ebonbolt then
            	if not buff.brainFreeze and buff.icicles.stack() == 5 then
            		if cast.ebonbolt(target) then return true end
            	end
            end


            --actions.aoe+=/glacialspike
            if talent.glacialSpike then
            	if buff.icicles.stack() == 5 and buff.brainFreeze then
            		if cast.glacialSpike(target) then return true end
            	end
            end
            --actions.aoe+=/frostbolt
            if cast.frostbolt(target) then return true end

            if cast.iceLance(target) then return true end
            return false
        end

        local function actionList_SINGLE()

        	--actions.single+=/flurry
        	if buff.icicles.stack() < 3 and buff.brainFreeze.exists() and lastCast == spell.frostbolt then
        		if cast.flurry(target) then return true end
        	end

        	--actions.single+=/flurry+glacial
        	if buff.brainFreeze.exists() and lastCast == spell.glacialSpike then
        		if cast.flurry(target) then return true end
        	end


        	--actions.single+=/flurry+ebonbolt
        	if buff.brainFreeze.exists() and lastCast == spell.ebonbolt then
        		if cast.flurry(target) then return true end 
        	end

        	--actions.single+=/icelance
        	if buff.fingersOfFrost.stack() < 2 and lastCast == spell.frostbolt then
        		if cast.iceLance(target) then return true end
        	end

        	--actions.single+=/icelance+flurry
        	if lastCast == spell.flurry then
        		if cast.iceLance(target) then return true end
        	end

        	--actions.single+=/frozenorb
        	if cd.frozenOrb.remain() == 0 and ((mode.frozenorb == 2 and isBoss(target)) or mode.frozenorb == 1) then
        		if isChecked(colorBlueMage.."Frozen Orb") and getEnemiesInRect(15,55,false) > 0 then
        			if cast.frozenOrb() then return true end
        		end
        	end

        	--actions.single+=/comet_storm
            if talent.cometStorm then
                if cd.cometStorm.remain() == 0 then
                    if isChecked(colorBlueMage.."Comet Storm") and ( IsStandingTime(2,target) or GetUnitSpeed(target) <= 3) then
                        if cast.cometStorm(target) then return true end
                    end
                end
            end

            --actions.single+=/glacialspike
            if talent.glacialSpike then
            	if buff.brainFreeze.exists() and buff.icicles.stack() == 5  then
            		if cast.glacialSpike(target) then return true end 
            	end
            end


            if cast.frostbolt(taget) then return true end

            return false
        end

        local function actionList_COMBAT()
        	if cd.icyVeins.remain() == 0 and not buff.icyVeins.exists() then
        		if debuf == true then Print("iv_start Changed: "..iv_start) end
        		iv_start = getCombatTime()
        	end

        	--actions+=/variable,name=time_until_fof,value=10-(time-variable.iv_start-floor((time-variable.iv_start)%10)*10)
            time_until_fof = 10-(getCombatTime() - iv_start - math.floor(math.fmod((getCombatTime() - iv_start),10))*10)
            if debug == true then Print("time_until_fof Changed: "..time_until_fof) end
            --actions+=/variable,name=fof_react,value=buff.fingers_of_frost.react
            if buff.fingersOfFrost.exists() then
                fof_react = 1
                if debug == true then Print("fof_react Changed: "..fof_react) end
            else
                fof_react = 0
                if debug == true then Print("fof_react Changed: "..fof_react) end
            end


            --actions+=/variable,name=fof_react,value=buff.fingers_of_frost.stack,&buff.icy_veins.up&variable.time_until_fof>9|prev_off_gcd.freeze|ground_aoe.frozen_orb.remains>9
            if buff.icyVeins.exists() and time_until_fof > 9 or lastCast == spell.flurry then
                fof_react = buff.fingersOfFrost.stack()
                if debug == true then Print("fof_react Changed: "..fof_react) end
            end

            --actions+=/ice_lance,if=variable.fof_react=0&prev_gcd.1.flurry
            if fof_react == 0 and lastCast == spell.flurry then
                if debug == true then Print("Casting Ice Lance") end
                if cast.iceLance(target) then
                    if debug == true then Print("Casted Ice Lance") end
                    return true
                end
            end
            --actions+=/call_action_list,name=cooldowns
            if actionList_CD() then return true end
            --actions+=/call_action_list,name=aoe,if=active_enemies>=4
            if #enemies.yards40 >= getValue("AOE targets") and (mode.rotation == 1 or mode.rotation == 2) then
                if actionList_AOE() then return true end
            end
            --actions+=/call_action_list,name=single
            if actionList_SINGLE() then return true end
            return false
        end
        
		if actionList_COMBAT() then return true end
        return false
    end


       -- Pause
        if pause(true) or (GetUnitExists(target) and (UnitIsDeadOrGhost(target) or not UnitCanAttack(target, "player"))) or mode.rotation == 4 then
          return true
        else
            ---------------------------------
            --- Out Of Combat - Rotations ---
            ---------------------------------
            if not inCombat and GetObjectExists(target) and not UnitIsDeadOrGhost(target) and UnitCanAttack(target, "player") then
                StopAttack()
                opener = false
                if actionList_PRECOMBAT() then return true end
            end -- End Out of Combat Rotation

            -----------------------------
            --- In Combat - Rotations ---
            -----------------------------
            if actionList_OPENER() then return true end
            if inCombat then
                if actionList_Pet() then return true end
                if actionList_INTERRUPT() then return true end
                if actionList_DEFENSIVE() then return true end
                if not isMoving("player") or (IsHackEnabled("MovingCast") and isMoving("player")) then
                    if SimCAPLMode() then return true end
                else
                    if MovingMode() then return true end
                end
                
            end -- End In Combat Rotation
        end -- Pause
    end

-- local id = 64
local id = 64
if br.rotations[id] == nil then br.rotations[id] = {} end

tinsert(br.rotations[id],{
	name = rotationName,
	toggles = createToggles,
	options = createOptions,
	run = runRotation,
	})





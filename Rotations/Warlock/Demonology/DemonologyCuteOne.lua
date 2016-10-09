if select(2, UnitClass("player")) == "WARLOCK" then
	local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
	local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = bb.player.spell.demonwrath},
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.demonwrath},
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.shadowbolt},
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.drainLife}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.summonDoomguard},
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.summonDoomguard},
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.summonDoomguard}
        };
       	CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.unendingResolve},
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.unendingResolve}
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
            [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = bb.player.spell.fear},
            [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = bb.player.spell.fear}
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
            section = bb.ui:createSection(bb.ui.window.profile, "General")
            -- APL
                bb.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
                bb.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
                bb.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Artifact 
                bb.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
            -- Summon Pet
                bb.ui:createDropdownWithout(section, "Summon Pet", {"Imp","Voidwalker","Felhunter","Succubus","Felguard"}, 1, "|cffFFFFFFSelect default pet to summon.")
            -- Grimoire of Service
                bb.ui:createDropdownWithout(section, "Grimoire of Service", {"Imp","Voidwalker","Felhunter","Succubus","Felguard"}, 1, "|cffFFFFFFSelect pet to Grimoire.") 
            bb.ui:checkSectionState(section)
        -- Cooldown Options
            section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
            -- Racial
                bb.ui:createCheckbox(section,"Racial")
            -- Trinkets
                bb.ui:createCheckbox(section,"Trinkets")
            -- Soul Harvest
                bb.ui:createCheckbox(section,"Soul Harvest")
            -- Summon Doomguard
                bb.ui:createCheckbox(section,"Summon Doomguard")
            -- Summon Infernal
                bb.ui:createCheckbox(section,"Summon Infernal")
            bb.ui:checkSectionState(section)
        -- Defensive Options
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
            -- Healthstone
                bb.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
                bb.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Gift of The Naaru
                if bb.player.race == "Draenei" then
                    bb.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                end
            -- Dark Pact
                bb.ui:createSpinner(section, "Dark Pact", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Drain Life
                bb.ui:createSpinner(section, "Drain Life", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            bb.ui:checkSectionState(section)
        -- Interrupt Options
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
            -- Couterspell
                bb.ui:createCheckbox(section, "Counterspell")
            -- Interrupt Percentage
                bb.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
            bb.ui:checkSectionState(section)
        -- Toggle Key Options
            section = bb.ui:createSection(bb.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
                bb.ui:createDropdown(section, "Rotation Mode", bb.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
                bb.ui:createDropdown(section, "Cooldown Mode", bb.dropOptions.Toggle,  3)
            -- Defensive Key Toggle
                bb.ui:createDropdown(section, "Defensive Mode", bb.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
                bb.ui:createDropdown(section, "Interrupt Mode", bb.dropOptions.Toggle,  6)
            -- Pause Toggle
                bb.ui:createDropdown(section, "Pause Mode", bb.dropOptions.Toggle,  6)
            bb.ui:checkSectionState(section)
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
        if bb.timer:useTimer("debugDemonology", math.random(0.15,0.3)) then
            --print("Running: "..rotationName)

    ---------------
	--- Toggles ---
	---------------
	        UpdateToggle("Rotation",0.25)
	        UpdateToggle("Cooldown",0.25)
	        UpdateToggle("Defensive",0.25)
	        UpdateToggle("Interrupt",0.25)

	--------------
	--- Locals ---
    --------------
            local addsExist                                     = false 
            local addsIn                                        = 999
            local activePet                                     = bb.player.pet
            local activePetId                                   = bb.player.petId
            local artifact                                      = bb.player.artifact
            local buff                                          = bb.player.buff
            local cast                                          = bb.player.cast
            local castable                                      = bb.player.cast.debug
            local combatTime                                    = getCombatTime()
            local cd                                            = bb.player.cd
            local charges                                       = bb.player.charges
            local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
            local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
            local debuff                                        = bb.player.debuff
            local enemies                                       = bb.player.enemies
            local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
            local flaskBuff                                     = getBuffRemain("player",bb.player.flask.wod.buff.agilityBig)
            local friendly                                      = friendly or UnitIsFriend("target", "player")
            local gcd                                           = bb.player.gcd
            local grimoirePet                                   = getOptionValue("Grimoire of Service")
            local hasMouse                                      = ObjectExists("mouseover")
            local hasteAmount                                   = GetHaste()/100
            local hasPet                                        = IsPetActive()
            local healPot                                       = getHealthPot()
            local heirloomNeck                                  = 122663 or 122664
            local inCombat                                      = bb.player.inCombat
            local inInstance                                    = bb.player.instance=="party"
            local inRaid                                        = bb.player.instance=="raid"
            local lastSpell                                     = lastSpellCast
            local level                                         = bb.player.level
            local lootDelay                                     = getOptionValue("LootDelay")
            local lowestHP                                      = bb.friend[1].unit
            local manaPercent                                   = bb.player.powerPercentMana
            local mode                                          = bb.player.mode
            local moveIn                                        = 999
            local moving                                        = isMoving("player")
            local perk                                          = bb.player.perk        
            local php                                           = bb.player.health
            local playerMouse                                   = UnitIsPlayer("mouseover")
            local power, powmax, powgen, powerDeficit           = bb.player.power, bb.player.powerMax, bb.player.powerRegen, bb.player.powerDeficit
            local pullTimer                                     = bb.DBM:getPulltimer()
            local racial                                        = bb.player.getRacial()
            local recharge                                      = bb.player.recharge
            local shards                                        = bb.player.shards
            local summonPet                                     = getOptionValue("Summon Pet")
            local solo                                          = bb.player.instance=="none"
            local spell                                         = bb.player.spell
            local talent                                        = bb.player.talent
            local travelTime                                    = getDistance("target")/16
            local ttd                                           = getTTD
            local ttm                                           = bb.player.timeToMax
            local units                                         = bb.player.units
            
	   		if leftCombat == nil then leftCombat = GetTime() end
			if profileStop == nil then profileStop = false end

            if summonPet == 1 then summonId = 416 end
            if summonPet == 2 then summonId = 1860 end
            if summonPet == 3 then summonId = 417 end
            if summonPet == 4 then summonId = 1863 end
            if summonPet == 5 then summonId = 17252 end
            if cd.grimoireOfService == 0 or prevService == nil then prevService = "None" end
            
            local wildImpCount = 0
            local wildImpDE = false
            local wildImpNoDEcount = 0
            local dreadStalkers = false
            local dreadStalkersDE = false
            local darkglare = false
            local darkglareDE = false
            local doomguard = false
            local doomguardDE = false
            local infernal = false
            local infernalDE = false
            local felguard = false
            local petDE = buff.pet.demonicEmpowerment
            local demonwrathPet = false
            if bb.player.petInfo ~= nil then
                for i = 1, #bb.player.petInfo do
                    local thisUnit = bb.player.petInfo[i].id
                    local hasDEbuff = bb.player.petInfo[i].deBuff
                    if thisUnit == 55659 then
                        wildImpCount = wildImpCount + 1
                        wildImpDE = hasDEbuff
                        if not hasDEbuff then wildImpNoDEcount = wildImpNoDEcount + 1 end 
                    end
                    if thisUnit == 98035 then dreadStalkers = true; dreadStalkersDE = hasDEbuff end
                    if thisUnit == 103673 then darkglare = true; darkglareDE = hasDEbuff end
                    if thisUnit == 11859 then doomguard = true; doomguardDE = hasDEbuff end
                    if thisUnit == 89 then infernal = true; infernalDE = hasDEbuff end
                    if thisUnit == 17252 then felguard = true end
                end
                for i = 1, #bb.player.petInfo do
                    local enemyCount = bb.player.petInfo[i].numEnemies
                    if enemyCount >= 3 then
                        demonwrathPet = true;
                        break
                    else
                        demonwrathPet = false
                    end
                end
            end
            if wildImpCount > 0 and wildImpDuration == 0 then wildImpDuration = GetTime() + 12 end
            if wildImpCount > 0 and wildImpDuration ~= 0 then wildImpRemain = wildImpDuration - GetTime() end
            if wildImpCount == 0 then wildImpDuration = 0; wildImpRemain = 0 end
            if dreadStalkers and dreadStalkersDuration == 0 then dreadStalkersDuration = GetTime() + 12 end
            if dreadStalkers and dreadStalkersDuration ~= 0 then dreadStalkersRemain = dreadStalkersDuration - GetTime() end
            if not dreadStalkers then dreadStalkersDuration = 0; dreadStalkersRemain = 0 end 

	--------------------
	--- Action Lists ---
	--------------------
		-- Action List - Extras
			local function actionList_Extras()
			-- Dummy Test
				if isChecked("DPS Testing") then
					if ObjectExists("target") then
						if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
							StopAttack()
							ClearTarget()
							print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
							profileStop = true
						end
					end
				end -- End Dummy Test

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
                        elseif canUse(healPot) then
                            useItem(healPot)
                        end
                    end
            -- Heirloom Neck
                    if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                        if hasEquiped(heirloomNeck) then
                            if GetItemCooldown(heirloomNeck)==0 then
                                useItem(heirloomNeck)
                            end
                        end
                    end
            -- Gift of the Naaru
                    if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and bb.player.race == "Draenei" then
                        if castSpell("player",racial,false,false,false) then return end
                    end
            -- Dark Pact
                    if isChecked("Dark Pact") and php <= getOptionValue("Dark Pact") then
                        if cast.darkPact() then return end
                    end
            -- Drain Life
                    if isChecked("Drain Life") and php <= getOptionValue("Drain Life") and isValid("target") then
                        if cast.drainLife() then return end
                    end
	    		end -- End Defensive Toggle
			end -- End Action List - Defensive
		-- Action List - Interrupts
			local function actionList_Interrupts()
				if useInterrupts() then
                    for i=1, #enemies.yards30 do
                        thisUnit = enemies.yards30[i]
                        if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then

                        end
                    end
                end -- End useInterrupts check
			end -- End Action List - Interrupts
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if useCDs() and getDistance(units.dyn40) < 40 then
            -- Trinkets
                    -- use_item,slot=trinket2,if=buff.chaos_blades.up|!talent.chaos_blades.enabled 
                    if isChecked("Trinkets") then
                        -- if buff.chaosBlades or not talent.chaosBlades then 
                            if canUse(13) then
                                useItem(13)
                            end
                            if canUse(14) then
                                useItem(14)
                            end
                        -- end
                    end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                    -- blood_fury | berserking | arcane_torrent
                    if isChecked("Racial") and (bb.player.race == "Orc" or bb.player.race == "Troll" or bb.player.race == "Blood Elf") then
                        if castSpell("player",racial,false,false,false) then return end
                    end
            -- Soul Harvest
                    -- soul_harvest
                    if isChecked("Soul Harvest") then
                        if cast.soulHarvest() then return end
                    end
            -- Potion
                    -- potion,name=deadly_grace,if=buff.soul_harvest.remains|target.time_to_die<=45|trinket.proc.any.react
                    -- TODO
                end -- End useCDs check
            end -- End Action List - Cooldowns
        -- Action List - PreCombat
            local function actionList_PreCombat()
                if not inCombat and not (IsFlying() or IsMounted()) then
                -- Flask
                    -- flask,type=whispered_pact
                    -- TODO
                -- Food
                    -- food,type=azshari_salad
                    -- TODO
                -- Summon Pet
                    -- summon_pet,if=!talent.grimoire_of_supremacy.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.demonic_power.down)
                    if not talent.grimoireOfSupremacy and (not talent.grimoireOfSacrifice or not buff.demonicPower) then
                        if not hasPet or activePetId ~= summonId then
                            if summonPet == 1 then
                                if cast.summonImp() then return end
                            end
                            if summonPet == 2 then
                                if cast.summonVoidwalker() then return end
                            end
                            if summonPet == 3 then
                                if cast.summonFelhunter() then return end
                            end
                            if summonPet == 4 then
                                if cast.summonSuccubus() then return end
                            end
                            if summonPet == 5 then
                                if cast.summonFelguard() then return end
                            end
                        end
                    end
                -- Summon Infernal
                    -- summon_infernal,if=talent.grimoire_of_supremacy.enabled&active_enemies>=3
                    if useCDs() and isChecked("Summon Infernal") then
                        if talent.grimoireOfSupremacy and #enemies.yards8 >= 3 then
                            if cast.summonInfernal() then return end
                        end
                    end
                -- Summon Doomguard
                    -- summon_doomguard,if=talent.grimoire_of_supremacy.enabled&active_enemies<3
                    if useCDs() and isChecked("Summon Doomguard") then
                        if talent.grimoireOfSupremacy and #enemies.yards8 < 3 then
                            if cast.summonDoomguard() then return end
                        end
                    end
                    if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

                    end -- End Pre-Pull
                    if ObjectExists("target") and not UnitIsDeadOrGhost("target") and (UnitCanAttack("target", "player") or isDummy("target")) and getDistance("target") < 40 then
                -- Augmentation
                        -- augmentation,type=defiled
                        -- TODO
                -- Potion
                        -- potion,name=deadly_grace
                        -- TODO
                -- Demonic Empowerment
                        -- demonic_empowerment
                        if lastSpell ~= spell.demonbolt and lastSpell ~= spell.shadowbolt then
                            if cast.demonicEmpowerment() then return end
                        end
                -- Demonbolt
                        -- demonbolt,if=talent.demonbolt.enabled
                        if talent.demonbolt then 
                            if cast.demonbolt() then return end
                        end
                -- Shadowbolt
                        -- shadow_bolt,if=!talent.demonbolt.enabled
                        if not talent.demonbolt and bb.timer:useTimer("travelTime", travelTime) then
                            if cast.shadowbolt() then return end
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
    --------------------------
    --- In Combat Rotation ---
    --------------------------
                if inCombat and profileStop==false and (hasThreat("target") or isDummy("target")) and getDistance("target") < 40 then
        ------------------------------
        --- In Combat - Interrupts ---
        ------------------------------
                    if actionList_Interrupts() then return end
        ---------------------------
        --- SimulationCraft APL ---
        ---------------------------
                    if getOptionValue("APL Mode") == 1 then
            -- Implosion
                        -- implosion,if=wild_imp_remaining_duration<=action.shadow_bolt.execute_time&buff.demonic_synergy.remains
                        -- implosion,if=prev_gcd.hand_of_guldan&wild_imp_remaining_duration<=3&buff.demonic_synergy.remains
                        -- implosion,if=wild_imp_count<=4&wild_imp_remaining_duration<=action.shadow_bolt.execute_time&spell_targets.implosion>1
                        -- implosion,if=prev_gcd.hand_of_guldan&wild_imp_remaining_duration<=4&spell_targets.implosion>2
                        if wildImpCount > 0 and ((wildImpRemain <= getCastTime(spell.shadowbolt) and buff.demonicSynergy) 
                            or (lastSpell == spell.handOfGuldan and wildImpRemain <= 3 and buff.demonicSynergy)
                            or (wildImpCount <= 4 and wildImpRemain <= getCastTime(spell.shadowbolt) and #enemies.yards8 > 1)
                            or (lastSpell == spell.handOfGuldan and wildImpRemain <= 4 and #enemies.yards8 > 2))
                        then
                            if cast.implosion() then return end
                        end
            -- Shadowflame
                        -- shadowflame,if=debuff.shadowflame.stack>0&remains<action.shadow_bolt.cast_time+travel_time
                        if debuff.stack.shadowflame > 0 and debuff.remain.shadowflame < getCastTime(spell.shadowbolt) + travelTime then
                            if cast.shadowflame() then return end
                        end
            -- Service Pet
                        -- if=cooldown.summon_doomguard.remains<=gcd&soul_shard>=2
                        -- if=cooldown.summon_doomguard.remains>25
                        if ((cd.summonDoomguard <= gcd and shards >= 2) or cd.summonDoomguard > 25) and bb.timer:useTimer("castGrim", gcd) then
                            if grimoirePet == 1 then
                                if cast.grimoireImp() then prevService = "Imp"; return end
                            end
                            if grimoirePet == 2 then
                                if cast.grimoireVoidwalker() then prevService = "Voidwalker"; return end
                            end
                            if grimoirePet == 3 then
                                if cast.grimoireFelhunter() then prevService = "Felhunter"; return end
                            end
                            if grimoirePet == 4 then
                                if cast.grimoireSuccubus() then prevService = "Succubus"; return end
                            end
                            if grimoirePet == 5 then
                                if cast.grimoireFelguard() then prevService = "Felguard"; return end
                            end
                        end
            -- Summon Doomguard
                        -- summon_doomguard,if=talent.grimoire_of_service.enabled&prev.service_felguard&spell_targets.infernal_awakening<3
                        -- summon_doomguard,if=talent.grimoire_of_synergy.enabled&spell_targets.infernal_awakening<3
                        if useCDs() and isChecked("Summon Doomguard") then
                            if (talent.grimoireOfService and prevService == "Felguard" and #enemies.yards10 < 3)
                                or (talent.grimoireOfSynergy and #enemies.yards10 < 3)
                            then
                                if cast.summonDoomguard() then return end
                            end
                        end
            -- Summon Infernal
                        -- summon_infernal,if=talent.grimoire_of_service.enabled&prev.service_felguard&spell_targets.infernal_awakening>=3
                        -- summon_infernal,if=talent.grimoire_of_synergy.enabled&spell_targets.infernal_awakening>=3
                        if useCDs() and isChecked("Summon Infernal") then
                            if (talent.grimoireOfService and prevService == "Felguard" and #enemies.yards10 >= 3)
                                or (talent.grimoireOfSynergy and #enemies.yards10 >=3)
                            then
                                if cast.summonInfernal() then return end
                            end
                        end
            -- Call Dreadstalkers
                        -- call_dreadstalkers,if=!talent.summon_darkglare.enabled&(spell_targets.implosion<3|!talent.implosion.enabled)
                        if not talent.summonDarkglare and (#enemies.yards8 < 3 or not talent.implosion) then
                            if cast.callDreadstalkers() then return end
                        end
            -- Hand of Guldan
                        -- hand_of_guldan,if=soul_shard>=4&!talent.summon_darkglare.enabled
                        if shards >= 4 and not talent.summonDarkglare then
                            if cast.handOfGuldan() then return end
                        end
            -- Summon Darkglare
                        -- summon_darkglare,if=prev_gcd.hand_of_guldan
                        -- summon_darkglare,if=prev_gcd.call_dreadstalkers
                        -- summon_darkglare,if=cooldown.call_dreadstalkers.remains>5&soul_shard<3
                        -- summon_darkglare,if=cooldown.call_dreadstalkers.remains<=action.summon_darkglare.cast_time&soul_shard>=3
                        -- summon_darkglare,if=cooldown.call_dreadstalkers.remains<=action.summon_darkglare.cast_time&soul_shard>=1&buff.demonic_calling.react
                        if lastSpell == spell.handOfGuldan or lastSpell == spell.callDreadstalkers or (cd.callDreadstalkers > 5 and shards < 3)
                            or (cd.callDreadstalkers <= getCastTime(spell.summonDarkglare) and shards >= 3)
                            or (cd.callDreadstalkers <= getCastTime(spell.summonDarkglare) and shards >= 1 and buff.demonicCalling)
                        then
                            if cast.summonDarkglare() then return end
                        end
            -- Call Dreadstalkers
                        -- call_dreadstalkers,if=talent.summon_darkglare.enabled&(spell_targets.implosion<3|!talent.implosion.enabled)&cooldown.summon_darkglare.remains>2
                        -- call_dreadstalkers,if=talent.summon_darkglare.enabled&(spell_targets.implosion<3|!talent.implosion.enabled)&prev_gcd.summon_darkglare
                        -- call_dreadstalkers,if=talent.summon_darkglare.enabled&(spell_targets.implosion<3|!talent.implosion.enabled)&cooldown.summon_darkglare.remains<=action.call_dreadstalkers.cast_time&soul_shard>=3
                        -- call_dreadstalkers,if=talent.summon_darkglare.enabled&(spell_targets.implosion<3|!talent.implosion.enabled)&cooldown.summon_darkglare.remains<=action.call_dreadstalkers.cast_time&soul_shard>=1&buff.demonic_calling.react
                        if talent.summonDarkglare and (#enemies.yards8 < 3 or not talent.implosion) 
                            and (cd.summonDarkglare > 2 or lastSpell == spell.summonDarkglare 
                                or (cd.summonDarkglare <= getCastTime(spell.callDreadstalkers) and shards >= 3)
                                or (cd.summonDarkglare <= getCastTime(spell.callDreadstalkers) and shards >= 1 and buff.demonicCalling))
                        then
                            if cast.callDreadstalkers() then return end
                        end
            -- Hand of Guldan
                        -- hand_of_guldan,if=soul_shard>=3&prev_gcd.call_dreadstalkers
                        -- hand_of_guldan,if=soul_shard>=5&cooldown.summon_darkglare.remains<=action.hand_of_guldan.cast_time
                        -- hand_of_guldan,if=soul_shard>=4&cooldown.summon_darkglare.remains>2
                        if (shards >= 3 and lastSpell == spell.callDreadstalkers)
                            or (shards >= 5 and cd.summonDarkglare <= getCastTime(spell.handOfGuldan))
                            or (shards >= 4 and cd.summonDarkglare > 2)
                        then 
                            if cast.handOfGuldan() then return end
                        end
            -- Demonic Empowerment
                        -- demonic_empowerment,if=wild_imp_no_de>3|prev_gcd.hand_of_guldan
                        -- demonic_empowerment,if=dreadstalker_no_de>0|darkglare_no_de>0|doomguard_no_de>0|infernal_no_de>0|service_no_de>0
                        if ((wildImpNoDEcount > 3 and wildImpCount > 3) or lastSpell == spell.handOfGuldan) 
                            or ((not dreadStalkersDE and dreadStalkers) or (not darkglareDE and darkglare) or (not doomguardDE and doomguard) or (not infernalDE and infernal) or not petDE) then
                            if cast.demonicEmpowerment() then return end
                        end
            -- Felstorm
                        -- felguard:felstorm
                        if felguard then
                            if cast.commandDemon() then return end
                        end
            -- Doom
                        -- doom,cycle_targets=1,if=!talent.hand_of_doom.enabled&target.time_to_die>duration&(!ticking|remains<duration*0.3)
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            local hasDoom = UnitDebuffID(thisUnit,spell.doom,"player")
                            local doomDuration = getDebuffDuration(thisUnit,spell.doom,"player") or 0
                            local doomRemain = getDebuffRemain(thisUnit,spell.doom,"player") or 0
                            if UnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                                if not talent.handOfDoom and ttd(thisUnit) > doomDuration and (not hasDoom or doomRemain < doomDuration * 0.3) then
                                    if cast.doom(thisUnit) then return end
                                end
                            end
                        end
            -- Cooldowns
                        if actionList_Cooldowns() then return end
            -- Shadowflame
                        -- shadowflame,if=charges=2
                        if charges.shadowflame == 2 then 
                            if cast.shadowflame() then return end
                        end
            -- Thal'kiel's Consumption
                        -- thalkiels_consumption,if=(dreadstalker_remaining_duration>execute_time|talent.implosion.enabled&spell_targets.implosion>=3)&wild_imp_count>3&wild_imp_remaining_duration>execute_time
                        if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) then
                            if (dreadStalkersRemain > getCastTime(spell.thalkielsConsumption) or talent.implosion and #enemies.yards8 >= 3) and wildImpCount > 3 and wildImpRemain > getCastTime(spell.thalkielsConsumption) then
                                if cast.thalkielsConsumption() then return end
                            end
                        end
            -- Life Tap
                        -- life_tap,if=mana.pct<=30
                        if manaPercent <= 30 then
                            if cast.lifeTap() then return end
                        end
            -- Demonwrath
                        -- demonwrath,chain=1,interrupt=1,if=spell_targets.demonwrath>=3 
                        -- demonwrath,moving=1,chain=1,interrupt=1
                        if demonwrathPet or moving or manaPercent > 60 then
                            if cast.demonwrath() then return end
                        end
            -- Demonbolt
                        -- demonbolt
                        if cast.demonbolt() then return end
            -- Shadow Bolt
                        -- shadow_bolt
                        if cast.shadowbolt() then return end
            -- Life Tap
                        --life_tap
                        if cast.lifeTap() then return end
                    end -- End SimC APL
        ----------------------
        --- AskMrRobot APL ---
        ----------------------
                    if getOptionValue("APL Mode") == 2 then

                    end
				end --End In Combat
			end --End Rotation Logic
        end -- End Timer
    end -- End runRotation
    tinsert(cDemonology.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end --End Class Check
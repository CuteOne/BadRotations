local rotationName = "Chem - 8.0.1"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.demonwrath},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.demonwrath},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.shadowBolt},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.drainLife}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.summonDoomguard},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.summonDoomguard},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.summonDoomguard}
    };
   	CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.unendingResolve},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.unendingResolve}
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.fear},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.fear}
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
        -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Opener
            br.ui:createCheckbox(section,"Opener")
        -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        -- Summon Pet
            br.ui:createDropdownWithout(section, "Summon Pet", {"Imp","Voidwalker","Felhunter","Succubus","Felguard", "Wrathguard", "None"}, 1, "|cffFFFFFFSelect default pet to summon.")
        -- Grimoire of Service
            br.ui:createDropdownWithout(section, "Grimoire of Service - Pet", {"Imp","Voidwalker","Felhunter","Succubus","Felguard","None"}, 1, "|cffFFFFFFSelect pet to Grimoire.")
            br.ui:createDropdownWithout(section,"Grimoire of Service - Use", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Grimoire Ability.")
        -- Demonwrath
            br.ui:createDropdownWithout(section, "Demonwrath", {"Both","AoE","Moving","None"}, 1, "|cffFFFFFF Select Demonwrath usage.")
        -- Felstorm
            br.ui:createSpinner(section, "Felstorm", 3, 1, 10, 1, "|cffFFFFFFMinimal number of units Felguard's Felstorm will be used at.")
        -- Mana Tap
            br.ui:createSpinner(section, "Life Tap HP Limit", 30, 0, 100, 5, "|cffFFFFFFHP Limit that Life Tap will not cast below.")
        -- Multi-Dot Limit
            br.ui:createSpinnerWithout(section, "Multi-Dot Limit", 5, 0, 10, 1, "|cffFFFFFFUnit Count Limit that DoTs will be cast on.")
            br.ui:createSpinnerWithout(section, "Multi-Dot HP Limit", 5, 0, 10, 1, "|cffFFFFFFHP Limit that DoTs will be cast/refreshed on.")
            br.ui:createSpinnerWithout(section, "Doom Boss HP Limit", 10, 1, 20, 1, "|cffFFFFFFHP Limit that Doom will be cast/refreshed on in relation to Boss HP.")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Soul Harvest
            br.ui:createSpinner(section,"Soul Harvest", 2, 1, 5, 1, "|cffFFFFFF Minimal Doom DoTs to cast Soul Harvest")
        -- Summon Doomguard
            br.ui:createCheckbox(section,"Summon Doomguard")
        -- Summon Infernal
            br.ui:createCheckbox(section,"Summon Infernal")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
        -- Dark Pact
            br.ui:createSpinner(section, "Dark Pact", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Drain Life
            br.ui:createSpinner(section, "Drain Life", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Health Funnel
            br.ui:createSpinner(section, "Health Funnel", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Unending Resolve
            br.ui:createSpinner(section, "Unending Resolve", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
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
    if br.timer:useTimer("debugDemonology", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)

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
        local activePet                                     = br.player.pet
        local activePetId                                   = br.player.petId
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local castable                                      = br.player.cast.debug
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or GetUnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local grimoirePet                                   = getOptionValue("Grimoire of Service - Pet")
        local hasMouse                                      = GetObjectExists("mouseover")
        local hasteAmount                                   = GetHaste()/100
        local hasPet                                        = IsPetActive()
        local healPot                                       = getHealthPot()
        local heirloomNeck                                  = 122663 or 122664
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local lastSpell                                     = lastSpellCastSuccess
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local manaPercent                                   = br.player.power.mana.percent()
        local mode                                          = br.player.mode
        local moveIn                                        = 999
        local moving                                        = isMoving("player")
        local perk                                          = br.player.perk
        local pet                                           = br.player.pet.list
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local shards                                        = br.player.power.soulShards.amount()
        local summonPet                                     = getOptionValue("Summon Pet")
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local travelTime                                    = getDistance("target")/16
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units 

        units.get(40)
        enemies.get(8,"target")
        enemies.get(30)
        enemies.get(40)

   		if leftCombat == nil then leftCombat = GetTime() end
		if profileStop == nil or not inCombat then profileStop = false end
        if castSummonId == nil then castSummonId = 0 end
        if handTimer == nil then handTimer = GetTime() end
        if isBoss() then dotHPLimit = getOptionValue("Multi-Dot HP Limit")/10 else dotHPLimit = getOptionValue("Multi-Dot HP Limit") end
        if sindoreiSpiteOffCD == nil then sindoreiSpiteOffCD = true end
        if buff.sindoreiSpite.exits and sindoreiSpiteOffCD then
            sindoreiSpiteOffCD = false
            C_Timer.After(180, function()
                sindoreiSpiteOffCD = true
            end)
        end

        -- Opener Variables
        if not inCombat and not GetObjectExists("target") then
            DE1 = false
            DSB1 = false
            DOOM = false
            SDG = false
            FSDG = false
            GRF = false
            FGRF = false
            DE2 = false
            DSB2 = false
            DGL = false
            FDGL = false
            DE3 = false
            DSB3 = false
            DSB4 = false
            DSB5 = false
            HVST = false
            FHVST = false
            DRS = false
            HOG = false
            DE5 = false
            TKC = false
            opener = false
        end

        -- Pet Data
        if summonPet == 1 then summonId = 416 end
        if summonPet == 2 then summonId = 1860 end
        if summonPet == 3 then summonId = 417 end
        if summonPet == 4 then summonId = 1863 end
        if summonPet == 5 then summonId = 17252 end
        if summonPet == 6 then summonId = 58965 end
        if cd.grimoireOfService.remain() == 0 or prevService == nil then prevService = "None" end

        local wildImpCount = 0
        local wildImpDE = false
        local wildImpNoDEcount = 0
        local dreadStalkers = false
        local dreadStalkersCount = 0
        local dreadStalkersDE = false
        local dreadStalkersNoDEcount = 0
        local darkglare = false
        local darkglareDE = false
        local darkglareCount = 0
        local doomguard = false
        local doomguardDE = false
        local doomguardCount = 0
        local demonicTyrantCount = br.player.pet.demonicTyrant.count() + 0
        local infernal = false
        local infernalDE = false
        local infernalCount = 0
        local felguard = false
        local felguardEnemies = 0
        local felguardCount = 0
        local petDE = buff.demonicEmpowerment.exists("pet") --UnitBuffID("pet",spell.buffs.demonicEmpowerment,"player") ~= nil --buff.pet.demonicEmpowerment
        local demonwrathPet = false
        local missingDE = 0
        local impsNearDeath = 0

        if pet ~= nil then
            for k, v in pairs(pet) do
            -- for i = 1, #br.player.pet do
                local thisUnit = pet[k].id or 0
                local hasDEbuff = pet[k].deBuff or false
                local enemyCount = pet[k].numEnemies or 0
                if enemyCount >= 3 then
                    demonwrathPet = true;
                    break
                else
                    demonwrathPet = false
                end
                if thisUnit == 55659 then
                    wildImpCount = wildImpCount + 1
                    wildImpDE = hasDEbuff
                    if not hasDEbuff then wildImpNoDEcount = wildImpNoDEcount + 1 end

                    local imp = pet[k]
                    if not imp.summonTime then
                      imp.summonTime = GetTime() + 12
                    end
                    imp.remainingDuration = imp.summonTime - GetTime()
                    
                    if imp.remainingDuration <= 3 then
                      impsNearDeath = impsNearDeath + 1
                    end
                end
                if thisUnit == 98035 then
                    dreadStalkers = true
                    dreadStalkersCount = dreadStalkersCount + 1
                    dreadStalkersDE = hasDEbuff
                    if not hasDEbuff then dreadStalkersNoDEcount = dreadStalkersNoDEcount + 1 end
                end
                if thisUnit == 103673 then darkglare = true; darkglareDE = hasDEbuff; darkglareCount = darkglareCount + 1 end
                if thisUnit == 11859 then doomguard = true; doomguardDE = hasDEbuff; doomguardCount = doomguardCount + 1 end
                if thisUnit == 89 then infernal = true; infernalDE = hasDEbuff; infernalCount = infernalCount + 1 end
                if (thisUnit == 17252 or thisUnit == 58965) then felguard = true; felguardEnemies = pet[k].numEnemies; felguardCount = felguardCount + 1 end
                if not pet[k].deBuff then
                    missingDE = missingDE + 1
                end
            end
        end

        if wildImpCount > 0 and wildImpDuration == 0 then wildImpDuration = GetTime() + 12 end
        if wildImpCount > 0 and wildImpDuration ~= 0 then wildImpRemain = wildImpDuration - GetTime() end
        if wildImpCount == 0 then wildImpDuration = 0; wildImpRemain = 0 end
        if dreadStalkers and dreadStalkersDuration == 0 then dreadStalkersDuration = GetTime() + 12 end
        if dreadStalkers and dreadStalkersDuration ~= 0 then dreadStalkersRemain = dreadStalkersDuration - GetTime() end
        if not dreadStalkers then dreadStalkersDuration = 0; dreadStalkersRemain = 0 end
        local petCount = wildImpCount + dreadStalkersCount + darkglareCount + doomguardCount + infernalCount + felguardCount

        local halfOrMoreImpsAboutToExpire = impsNearDeath >= (wildImpCount ~= 0 and wildImpCount/2 or 1)


        -- SimC Variable
        -- variable,name=3min,value=doomguard_no_de>0|infernal_no_de>0
        local min3 = not doomguardDE or not infernalDE
        -- variable,name=no_de1,value=dreadstalker_no_de>0|darkglare_no_de>0|doomguard_no_de>0|infernal_no_de>0|service_no_de>0
        local noDE1 = dreadStalkersNoDEcount > 0 or not darkglareDE or not doomguardDE or not infernalDE or missingDE > 0
        -- variable,name=no_de2,value=(variable.3min&service_no_de>0)|(variable.3min&wild_imp_no_de>0)|(variable.3min&dreadstalker_no_de>0)|(service_no_de>0&dreadstalker_no_de>0)|(service_no_de>0&wild_imp_no_de>0)|(dreadstalker_no_de>0&wild_imp_no_de>0)|(prev_gcd.1.hand_of_guldan&variable.no_de1)
        local noDE2 = ((min3 and missingDE > 0) or (min3 and wildImpNoDEcount > 0) or (min3 and dreadStalkersNoDEcount > 0) or (missingDE < 0 and dreadStalkersNoDEcount > 0) 
                    or (missingDE > 0 and wildImpNoDEcount > 0) or (dreadStalkersNoDEcount > 0 and wildImpNoDEcount > 0) or (cast.last.handOfGuldan() and noDE1))

--------------------
--- Action Lists ---
--------------------
	-- Action List - Extras
		local function actionList_Extras()
		-- Dummy Test
			if isChecked("DPS Testing") then
				if GetObjectExists("target") then
					if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        PetStopAttack()
                        PetFollow()
						Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
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
                    if canUseItem(5512) then
                        useItem(5512)
                    elseif canUseItem(healPot) then
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
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Dark Pact
                if isChecked("Dark Pact") and php <= getOptionValue("Dark Pact") then
                    if cast.darkPact() then return end
                end
        -- Drain Life
                if isChecked("Drain Life") and php <= getOptionValue("Drain Life") and isValidTarget("target") then
                    if cast.drainLife() then return end
                end
        -- Health Funnel
                if isChecked("Health Funnel") and getHP("pet") <= getOptionValue("Health Funnel") and GetObjectExists("pet") == true and not UnitIsDeadOrGhost("pet") then
                    if cast.healthFunnel("pet") then return end
                end
        -- Unending gResolve
                if isChecked("Unending Resolve") and php <= getOptionValue("Unending Resolve") and inCombat then
                    if cast.unendingResolve() then return end
                end
    		end -- End Defensive Toggle
		end -- End Action List - Defensive
	-- Action List - Interrupts
		local function actionList_Interrupts()
			if useInterrupts() and activePetId ~= nil and (activePetId == 417 or activePetId == 78158) then
                for i=1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                        if activePetId == 417 then
                            if cast.spellLock(thisUnit) then return end
                        elseif activePetId == 78158 then
                            if cast.shadowLock(thisUnit) then return end
                        end
                    end
                end
            end -- End useInterrupts check
		end -- End Action List - Interrupts
	-- Action List - Cooldowns
		local function actionList_Cooldowns()
			if useCDs() and getDistance(units.dyn40) < 40 then
        -- Trinkets
                -- use_items
                if isChecked("Trinkets") then
                    if canUseItem(13) then
                        useItem(13)
                    end
                    if canUseItem(14) then
                        useItem(14)
                    end
                end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury | berserking | arcane_torrent
                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                    if cast.racial() then return end
                end
        -- Soul Harvest
                -- soul_harvest,if=!buff.soul_harvest.remains
                if isChecked("Soul Harvest") and getOptionValue("Soul Harvest") >= debuff.doom.count() and not buff.soulHarvest.exists() then
                    if cast.soulHarvest() then return end
                end
        -- Potion
                -- potion,name=prolonged_power,if=buff.soul_harvest.remains|target.time_to_die<=70|trinket.proc.any.react
            end -- End useCDs check
        end -- End Action List - Cooldowns
    -- Action List - PreCombat
        local function actionList_PreCombat()
        -- Flask
            -- flask,type=whispered_pact
        -- Food
            -- food,type=azshari_salad
        -- Augmentation
            -- augmentation,type=defiled
        -- Summon Pet
            -- summon_pet,if=!talent.grimoire_of_supremacy.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.demonic_power.down)
            if not (IsFlying() or IsMounted()) and not talent.grimoireOfSupremacy and (not talent.grimoireOfSacrifice or not buff.demonicPower.exists()) 
                and br.timer:useTimer("summonPet", cast.time.summonVoidwalker() + gcd) 
            then
                if (activePetId == 0 or activePetId ~= summonId) and (lastSpell ~= castSummonId or activePetId ~= summonId or activePetId == 0) then
                    if summonPet == 1 then
                        if isKnown(spell.summonFelImp) and (lastSpell ~= spell.summonFelImp or activePetId == 0) then
                            if cast.summonFelImp("player") then castSummonId = spell.summonFelImp; return end
                        elseif lastSpell ~= spell.summonImp then
                            if cast.summonImp("player") then castSummonId = spell.summonImp; return end
                        end
                    end
                    if summonPet == 2 and (lastSpell ~= spell.summonVoidwalker or activePetId == 0) then
                        if cast.summonVoidwalker("player") then castSummonId = spell.summonVoidwalker; return end
                    end
                    if summonPet == 3 and (lastSpell ~= spell.summonFelhunter or activePetId == 0) then
                        if cast.summonFelhunter("player") then castSummonId = spell.summonFelhunter; return end
                    end
                    if summonPet == 4 and (lastSpell ~= spell.summonSuccubus or activePetId == 0) then
                        if cast.summonSuccubus("player") then castSummonId = spell.summonSuccubus; return end
                    end
                    if summonPet == 5 and (lastSpell ~= spell.summonFelguard or activePetId == 0) then
                      if cast.summonFelguard("player") then castSummonId = spell.summonFelguard; return end
                    end
                    if summonPet == 6 and (lastSpell ~= spell.summonWrathguard or activePetId == 0) then
                      if cast.summonWrathguard("player") then castSummonId = spell.summonWrathguard; return end
                    end
                    if summonPet == 7 then return end
                end
            end
            if not inCombat and not (IsFlying() or IsMounted()) then
                if not isChecked("Opener") or not isBoss("target") then
        -- Summon Infernal
                    -- summon_infernal,if=talent.grimoire_of_supremacy.enabled&active_enemies>1
                    if useCDs() and isChecked("Summon Infernal") then
                        if talent.grimoireOfSupremacy and ((mode.rotation == 1 and #enemies.yards8t > 1) or (mode.rotation == 2 and #enemies.yards8t > 0)) then
                            if cast.summonInfernal() then return end
                        end
                    end
        -- Summon Doomguard
                    -- summon_doomguard,if=talent.grimoire_of_supremacy.enabled&active_enemies=1
                    if useCDs() and isChecked("Summon Doomguard") then
                        if talent.grimoireOfSupremacy and ((mode.rotation == 1 and #enemies.yards8t == 1) or (mode.rotation == 3 and #enemies.yards8t > 0)) then
                            if cast.summonDoomguard("player") then return end
                        end
                    end
                    if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") and pullTimer ~= 999 then
                        return true
                    end -- End Pre-Pull
                    if isValidUnit("target") and getDistance("target") < 40 then
        -- Potion
                        -- potion,name=prolonged_power
        -- Demonic Empowerment
                        -- demonic_empowerment
                        if activePet ~= "None" and not petDE and not cast.last.demonicEmpowerment() then
                            if cast.demonicEmpowerment() then return end
                        end
        -- Pet Attack/Follow
                        if GetUnitExists("target") and not UnitAffectingCombat("pet") then
                            PetAssistMode()
                            PetAttack("target")
                        end
        -- Shadowbolt
                        -- shadow_bolt
                        if cast.shadowBolt("target") then return end
                    end
                end
            end -- End No Combat
        end -- End Action List - PreCombat
        local function actionList_Opener()
            if isBoss("target") and isValidUnit("target") and opener == false then
                if (isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer")) or not isChecked("Pre-Pull Timer") or pullTimer == 999 then
                -- Demonic Empowerment
                    if not DE1 and not isMoving("player") then
                        castOpener("demonicEmpowerment","DE1",1)
                -- Potion
                    -- potion
                    elseif useCDs() and canUseItem(142117) and isChecked("Potion") and getDistance("target") < 15 then
                        Print("Potion Used!");
                        useItem(142117)
                -- Demonbolt/Shadowbolt
                    elseif DE1 and not DSB1 and not isMoving("player") then
                        if shards < 5 then
                            if talent.demonbolt then
                                castOpener("demonbolt","DSB1",2)
                            else
                                castOpener("shadowBolt","DSB1",2)
                            end
                        else
                            DSB1 = true
                        end
                -- Pet Attack
                        if not GetUnitIsUnit("pettarget","target") then
                            PetAttack()
                        end
                -- Doom
                    elseif DSB1 and not DOOM then
                        castOpener("doom","DOOM",3)
                -- Summon Doomguard
                    elseif DOOM and not (SDG or FSDG) then
                        if cd.summonDoomguard.remain() == 0  then
                            castOpener("summonDoomguard","SDG",4)
                        elseif cd.summonDoomguard.remain() > br.player.gcd then
                            Print("4. Summon Doom Guard: Not Cast (Cooldown)")
                            FSDG = true
                        end
                -- Grimoire: Felguard
                    elseif (SDG or DOOM) and not (GRF or FGRF) then
                        if cd.grimoireFelguard.remain() == 0 then
                            castOpener("grimoireFelguard","GRF",5)
                        elseif cd.grimoireFelguard.remain() > br.player.gcd then
                            Print("5. Grimore Felguard: Not Cast(Cooldown)")
                            FGRF = true
                        end
                -- Demonic Empowerment
                    elseif (GRF or SDG) and not DE2 and not isMoving("player") then
                        castOpener("demonicEmpowerment","DE2",6)
                -- Demonbolt/Shadowbolt
                    elseif (DE2 or DOOM) and not DSB2 and not isMoving("player") then
                        if shards < 5 then
                            if talent.demonbolt then
                                castOpener("demonbolt","DSB2",7)
                            else
                                castOpener("shadowBolt","DSB2",7)
                            end
                        else
                            DSB2 = true
                        end
                -- Summon Darkglare
                    elseif DSB2 and not (DGL or FDGL) then
                        if talent.summonDarkglare then
                            if cd.summonDarkglare.remain() == 0 then
                                castOpener("summonDarkglare","DGL",8)
                            elseif cd.summonDarkglare.remain() > br.player.gcd then
                                Print("8. Summon Darkglare: Not Cast(Cooldown)")
                                FDGL = true
                            end
                        else
                            Print("8. Summon Darkglare: Not Cast(Not Talented)")
                            FDGL = true
                        end
                -- Demonic Empowerment
                    elseif DGL and not DE3 and not isMoving("player") then
                        castOpener("demonicEmpowerment","DE3",9)
                -- Demonbolt/Shadowbolt
                    elseif (DE3 or DSB2) and not DSB3 and not isMoving("player") then
                        if shards < 5 then
                            if talent.demonbolt then
                                castOpener("demonbolt","DSB3",10)
                            else
                                castOpener("shadowBolt","DSB3",10)
                            end
                        else
                            DSB3 = true
                        end
                -- Demonbolt/Shadowbolt
                    elseif DSB3 and not DSB4 and not isMoving("player") then
                        if shards < 5 then
                            if talent.demonbolt then
                                castOpener("demonbolt","DSB4",11)
                            else
                                castOpener("shadowBolt","DSB4",11)
                            end
                        else
                            DSB4 = true
                        end
                -- Demonbolt/Shadowbolt
                    elseif DSB4 and not DSB5 and not isMoving("player") then
                        if shards < 5 then
                            if talent.demonbolt then
                                castOpener("demonbolt","DSB5",12)
                            else
                                castOpener("shadowBolt","DSB5",12)
                            end
                        else
                            DSB5 = true
                        end
                -- Soul Harvest
                    elseif DSB5 and not (HVST or FHVST) then
                        if talent.soulHarvest then
                            if cd.soulHarvest.remain() == 0 then
                                castOpener("soulHarvest","HVST",13)
                            elseif cd.soulHarvest.remain() > br.player.gcd then
                                Print("13. Soul Harvest: Not Cast(Cooldown)")
                                FHVST = true
                            end
                        else
                            Print("13. Soul Harvest: Not Cast(Not Talented)")
                            FHVST = true
                        end
                -- Call Dreadstalkers
                    elseif (HVST or DSB5) and not DRS and not isMoving("player") then
                        castOpener("callDreadstalkers","DRS",14)
                -- Hand of Guldan
                    elseif DRS and not HOG and not isMoving("player") then
                        castOpener("handOfGuldan","HOG",15)
                -- Demonic Empowerment
                    elseif HOG and not DE5 then
                        castOpener("demonicEmpowerment","DE5",16)
                -- Thal'kiel's Consumption
                    elseif DE5 and not TKC then
                        castOpener("thalkielsConsumption","TKC",17)
                    elseif TKC then
                        Print("Opener Complete")
                        opener = true
                    end
                end
            end
        end

        -- local function actionListPrecombat()
        --   if cast.able.flask() then
        --       if cast.flask() then return end
        --   end
        --   if cast.able.food() then
        --       if cast.food() then return end
        --   end
        --   if cast.able.augmentation() then
        --       if cast.augmentation() then return end
        --   end
        --   if cast.able.summonPet() then
        --       if cast.summonPet() then return end
        --   end
        --   if cast.able.innerDemons() and (talent.innerDemons) then
        --       if cast.innerDemons() then return end
        --   end
        --   if cast.able.snapshotStats() then
        --       if cast.snapshotStats() then return end
        --   end
        --   if cast.able.potion() then
        --       if cast.potion() then return end
        --   end
        --   if cast.able.demonbolt() then
        --       if cast.demonbolt() then return end
        --   end
        -- end

        local function actionListBuildAShard()
          if cast.able.demonbolt() and (buff.forbiddenKnowledge.exists() and not buff.demonicCore.exists() and cd.summonDemonicTyrant.remain() > 20) then
              if cast.demonbolt() then return end
          end
          if cast.able.soulStrike() then
              if cast.soulStrike() then return end
          end
          if cast.able.shadowBolt() and shards < 5 then
              if cast.shadowBolt() then return end
          else
            return
          end
        end

        local function actionListNetherPortalActive()
          if cast.able.grimoireFelguard() and (cd.summonDemonicTyrant.remain() < 13 or not hasEquiped(132369)) then
              if cast.grimoireFelguard() then return end
          end
          if cast.able.summonVilefiend() and (cd.summonDemonicTyrant.remain() > 40 or cd.summonDemonicTyrant.remain() < 12) then
              if cast.summonVilefiend() then return end
          end
          if cast.able.callDreadstalkers() and ((cd.summonDemonicTyrant.remain() < 9 and buff.demonicCalling.remain()) or (cd.summonDemonicTyrant.remain() < 11 and not buff.demonicCalling.remain()) or cd.summonDemonicTyrant.remain() > 14) then
              if cast.callDreadstalkers() then return end
          end
          if shards == 1 and (cd.callDreadstalkers.remain() < cast.time.shadowBolt() or (talent.bilescourgeBombers and cd.bilescourgeBombers.remain() < cast.time.shadowBolt())) then
              if actionListBuildAShard() then return end
          end
          if cast.able.handOfGuldan() and (((cd.callDreadstalkers.remain() >cast.time.demonbolt()) and (cd.callDreadstalkers.remain() > cast.time.shadowBolt())) and cd.netherPortal.remain() > (160 + cast.time.handOfGuldan())) then
              if cast.handOfGuldan() then return end
          end
          if cast.able.summonDemonicTyrant() and (buff.netherPortal.remain() < 10 and shards == 0) then
              if cast.summonDemonicTyrant() then return end
          end
          if cast.able.summonDemonicTyrant() and (buff.netherPortal.remain() < cast.time.summonDemonicTyrant() + 5.5) then
              if cast.summonDemonicTyrant() then return end
          end
          if cast.able.demonbolt() and (buff.demonicCore.exists()) then
              if cast.demonbolt() then return end
          end
          if actionListBuildAShard() then return end
        end

        local function actionListNetherPortalBuilding()
          if cast.able.netherPortal() and (shards >= 5 and (not talent.powerSiphon or buff.demonicCore.exists())) then
              if cast.netherPortal() then return end
          end
          if cast.able.callDreadstalkers() then
              if cast.callDreadstalkers() then return end
          end
          if cast.able.handOfGuldan() and (cd.callDreadstalkers.remain() > 18 and shards >= 3) then
              if cast.handOfGuldan() then return end
          end
          if cast.able.powerSiphon() and (wildImpCount >= 2 and buff.demonicCore.stack() <= 2 and not buff.demonicPower.exists() and shards >= 3) then
              if cast.powerSiphon() then return end
          end
          if cast.able.handOfGuldan() and (shards >= 5) then
              if cast.handOfGuldan() then return end
          end
          if actionListBuildAShard() then return end
        end
        
        local function actionListNetherPortal()
          if cd.netherPortal.remain() < 20 then
              if actionListNetherPortalBuilding() then return end
          end
          if cd.netherPortal.remain() > 160 then
              if actionListNetherPortalActive() then return end
          end
        end

        local function actionListImplosion()
          if cast.able.implosion() and ttd("target") <= 3 or (#enemies.yards8t > 1 and wildImpCount >= 6) then
              if cast.implosion() then return end
          end
          if cast.able.grimoireFelguard() and (cd.summonDemonicTyrant.remain() < 13 or not hasEquiped(132369)) then
              if cast.grimoireFelguard() then return end
          end
          if cast.able.callDreadstalkers() and ((cd.summonDemonicTyrant.remain() < 9 and buff.demonicCalling.remain()) or (cd.summonDemonicTyrant.remain() < 11 and not buff.demonicCalling.remain()) or cd.summonDemonicTyrant.remain() > 14) then
              if cast.callDreadstalkers() then return end
          end
          if cast.able.summonDemonicTyrant() then
              if cast.summonDemonicTyrant() then return end
          end
          if cast.able.handOfGuldan() and (shards >= 5) then
              if cast.handOfGuldan() then return end
          end
          if cast.able.handOfGuldan() and (shards >= 3 and (((cast.last.handOfGuldan(2) or wildImpCount >= 3) and wildImpCount < 9) or cd.summonDemonicTyrant.remain() <= gcd * 2 or buff.demonicPower.remain() > gcd * 2)) then
              if cast.handOfGuldan() then return end
          end
          if cast.able.demonbolt() and (cast.last.handOfGuldan(1) and shards >= 1 and (wildImpCount <= 3 or cast.last.handOfGuldan(3)) and shards < 4 and buff.demonicCore.exists()) then
              if cast.demonbolt() then return end
          end
          if cast.able.summonVilefiend() and ((cd.summonDemonicTyrant.remain() > 40 and #enemies.yards8t <= 2) or cd.summonDemonicTyrant.remain() < 12) then
              if cast.summonVilefiend() then return end
          end
          if cast.able.bilescourgeBombers() and (cd.summonDemonicTyrant.remain() > 9) then
              if cast.bilescourgeBombers() then return end
          end
          if cast.able.soulStrike() and (shards < 5 and buff.demonicCore.stack() <= 2) then
              if cast.soulStrike() then return end
          end
          if cast.able.demonbolt() and (shards <= 3 and buff.demonicCore.exists() and (buff.demonicCore.stack() >= 3 or buff.demonicCore.remain() <= gcd * 5.7)) then
              if cast.demonbolt() then return end
          end
          if cast.able.doom() and (debuff.doom.refresh()) then
              if cast.doom() then return end
          end
          if actionListBuildAShard() then return end
        end

        local function actionListRotation()
        --   if cast.able.potion() and (demonicTyrantCount == 1 or ttd("target") < 30) then
        --       if cast.potion() then return end
        --   end
          --TODO: parsing use_items

        --   if cast.able.racial() and (demonicTyrantCount == 1 or ttd("target") <= 15) then
        --       if cast.racial() then return end
        --   end
        --   if cast.able.fireblood() and (demonicTyrantCount == 1 or ttd("target") <= 15) then
        --       if cast.fireblood() then return end
        --   end
          if cast.able.doom() and (not debuff.doom.exists() and ttd("target") > 30 and #enemies.yards8t < 2) then
              if cast.doom() then return end
          end
          if cast.able.demonicStrength() and ((wildImpCount < 6 or buff.demonicPower.exists()) or #enemies.yards8t < 2) then
              if cast.demonicStrength() then return end
          end
          if talent.netherPortal and #enemies.yards8t <= 2 then
              if actionListNetherPortal() then return end
          end

          if actionListImplosion() then return end

          if cast.able.grimoireFelguard() and (cd.summonDemonicTyrant.remain() < 13 or not hasEquiped(132369)) then
              if cast.grimoireFelguard() then return end
          end
          if cast.able.summonVilefiend() and (hasEquiped(132369) or cd.summonDemonicTyrant.remain() > 40 or cd.summonDemonicTyrant.remain() < 12) then
              if cast.summonVilefiend() then return end
          end
          if cast.able.callDreadstalkers() and (hasEquiped(132369) or (cd.summonDemonicTyrant.remain() < 9 and buff.demonicCalling.remain()) or (cd.summonDemonicTyrant.remain() < 11 and not buff.demonicCalling.remain()) or cd.summonDemonicTyrant.remain() > 14) then
              if cast.callDreadstalkers() then return end
          end

          -- This is the original, I took out buff.grimoireFelguard.remain() from conditions. Still need to figure that one out.
          -- if cast.able.summonDemonicTyrant() and (hasEquiped(132369) or (dreadStalkersRemain > cast.time.summonDemonicTyrant() and (wildImpCount >= 3 or cast.last.handOfGuldan(1)) and (shards < 3 or dreadStalkersRemain < gcd * 2.7 or buff.grimoireFelguard.remain() < gcd * 2.7))) then
          if cast.able.summonDemonicTyrant() and (hasEquiped(132369) or (dreadStalkersRemain > cast.time.summonDemonicTyrant() and (wildImpCount >= 3 or cast.last.handOfGuldan(1)) and (shards < 3 or dreadStalkersRemain < gcd * 2.7))) then
              if cast.summonDemonicTyrant() then return end
          end
          if cast.able.powerSiphon() and (wildImpCount >= 2 and buff.demonicCore.stack() <= 2 and not buff.demonicPower.exists() and #enemies.yards8t < 2) then
              if cast.powerSiphon() then return end
          end
          if cast.able.doom() and (talent.doom and debuff.doom.refresh() and ttd("target") > (debuff.doom.remain() + 30)) then
              if cast.doom() then return end
          end
          if cast.able.handOfGuldan() and (shards >= 5 or (shards >= 3 and cd.callDreadstalkers.remain() > 4 and (not talent.summonVilefiend or cd.summonVilefiend.remain() > 3))) then
              if cast.handOfGuldan() then return end
          end
          if cast.able.soulStrike() and (shards < 5 and buff.demonicCore.stack() <= 2) then
              if cast.soulStrike() then return end
          end
          if cast.able.demonbolt() and (shards <= 3 and buff.demonicCore.exists() and ((cd.summonDemonicTyrant.remain() < 10 or cd.summonDemonicTyrant.remain() > 22) or buff.demonicCore.stack() >= 3 or buff.demonicCore.remain() < 5 or ttd("target") < 25)) then
              if cast.demonbolt() then return end
          end
          if actionListBuildAShard() then return end
        end


---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or IsMounted() or IsFlying() or pause() or mode.rotation==4 then
            if not pause() and IsPetAttackActive() then
                PetStopAttack()
                PetFollow()
            end
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
-----------------------
--- Opener Rotation ---
-----------------------
            if opener == false and isChecked("Opener") and isBoss("target") then
                if actionList_Opener() then return end
            end
--------------------------
--- In Combat Rotation ---
--------------------------
            if inCombat and not IsMounted() and profileStop==false and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40
                and (opener == true or not isChecked("Opener") or not isBoss("target"))
            then
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                if getOptionValue("APL Mode") == 1 then
        -- Pet Attack
                    if not GetUnitIsUnit("pettarget","target") then
                        PetAttack()
                    end

                    if actionListRotation() then return end
                end
    ----------------------
    --- AskMrRobot APL ---
    ----------------------
                    if getOptionValue("APL Mode") == 2 then

                    end
			end --End In Combat
		end --End Rotation Logic
    end -- End Timer
end -- End runRotation
--local id = 266
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

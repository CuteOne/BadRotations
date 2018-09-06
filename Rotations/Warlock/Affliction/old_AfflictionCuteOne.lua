local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.agony},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.corruption},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.drainSoul},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.healthFunnel}
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
-- Multi-Dot Button
    MultiDotModes = {
        [1] = { mode = "On", value = 1 , overlay = "Multi-Dot Only Disabled", tip = "Will use UA, Drain, and Reap.", highlight = 1, icon = br.player.spell.unstableAffliction},
        [2] = { mode = "Off", value = 2 , overlay = "Multi-Dot Only Enabled", tip = "Does not use UA, Drain, and Reap.", highlight = 0, icon = br.player.spell.corruption}
    };
    CreateButton("MultiDot",5,0)
-- SoC Button
    SeedofCorruptionModes = {
      [1] = { mode = "On", value = 1 , overlay = "Seed of Corruption Toggle Enabled", tip = "Will Use SoC ", highlight = 1, icon = br.player.spell.seedOfCorruption},
      [2] = { mode = "Off", value = 2 , overlay = "Seed of Corruption Toggle Disabled", tip = "Will Not Use Soc", highlight = 0, icon = br.player.spell.seedOfCorruption}
    };
    CreateButton("SeedofCorruption",6,0)

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
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  2,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Opener
            br.ui:createCheckbox(section,"Opener")
        -- Pet Management
            br.ui:createCheckbox(section, "Pet Management", "|cffFFFFFF Select to enable/disable auto pet management")
        -- Summon Pet
            br.ui:createDropdownWithout(section, "Summon Pet", {"Imp","Voidwalker","Felhunter","Succubus","Felguard", "Doomguard", "Infernal", "None"}, 1, "|cffFFFFFFSelect default pet to summon.")
        -- Grimoire of Service
            br.ui:createDropdownWithout(section, "Grimoire of Service - Pet", {"Imp","Voidwalker","Felhunter","Succubus","Felguard","None"}, 1, "|cffFFFFFFSelect pet to Grimoire.")
            br.ui:createDropdownWithout(section,"Grimoire of Service - Use", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Grimoire Ability.")
        -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        -- Mana Tap
            br.ui:createSpinner(section, "Life Tap HP Limit", 30, 0, 100, 5, "|cffFFFFFFHP Limit that Life Tap will not cast below.")
        -- Multi-Dot Limit
            br.ui:createSpinnerWithout(section, "Multi-Dot Limit", 5, 0, 10, 1, "|cffFFFFFFUnit Count Limit that DoTs will be cast on.")
            br.ui:createSpinnerWithout(section, "Multi-Dot HP Limit", 5, 0, 10, 1, "|cffFFFFFFHP Limit that DoTs will be cast/refreshed on.")
            br.ui:createSpinnerWithout(section, "Agony Boss HP Limit", 10, 1, 20, 1, "|cffFFFFFFHP Limit that Agony will be cast/refreshed on in relation to Boss HP.")
        -- Seed of Corruption units
            br.ui:createSpinnerWithout(section, "Seed Units", 4, 3, 10, 1, "|cffFFFFFFNumber of Units Seed of Corruption will be cast on.")
		-- Phantom Singularity
			br.ui:createSpinnerWithout(section, "PS Units", 4, 1, 10, 1, "|cffFFFFFFNumber of Units Phantom Singularity will be cast on.")
		-- Wrath of Consumption
			br.ui:createCheckbox(section, "Wrath of Consumption", "|cffFFFFFF Select to enable/disable Wrath of Consumption Stacking")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Soul Harvest
            br.ui:createSpinner(section,"Soul Harvest", 2, 1, 5, 1, "|cffFFFFFF Minimal Agony DoTs to cast Soul Harvest")
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
        -- Drain Soul
            br.ui:createSpinner(section, "Drain Soul", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
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
        -- Multi-Dot Key Toggle
            br.ui:createDropdown(section, "MultiDot Mode", br.dropOptions.Toggle,  6)
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
    -- if br.timer:useTimer("debugAffliction", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("MultiDot",0.25)
        br.player.mode.multidot = br.data.settings[br.selectedSpec].toggles["MultiDot"]
        br.player.mode.soc = br.data.settings[br.selectedSpec].toggles["SeedofCorruption"]

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
        local equiped                                       = br.player.equiped
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or UnitIsFriend("target", "player")
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
        local lastSpell                                     = lastSpellCast
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
        local t19_4pc                                       = br.player.equiped.t19 >= 4
        local travelTime                                    = getDistance("target")/16
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units

        units.get(40)

        enemies.get(8,"target")
        enemies.get(10,"target")
        enemies.get(30)
        enemies.get(40)

        if t19_4pc then hasT19 = 1 else hasT19 = 0 end
		if leftCombat == nil then leftCombat = GetTime() end
	    if profileStop == nil or not inCombat then profileStop = false end
        if castSummonId == nil then castSummonId = 0 end
        if summonTime == nil then summonTime = 0 end
        if effigied == nil then effigied = false; effigyCount = 0 end
        if effigyCount == nil then effigyCount = 0 end
        if hasEquiped(144364) then reapAndSow = 1 else reapAndSow = 0 end
        if buff.tormentedSouls.stack() > 0 then tormented = 1 else tormented = 0 end
        if isBoss() then dotHPLimit = getOptionValue("Multi-Dot HP Limit")/10 else dotHPLimit = getOptionValue("Multi-Dot HP Limit") end

        if hasEquiped(132394) then agonyTick = 2 * 0.9 else agonyTick = 2 / (1 + (GetHaste()/100)) end
        local corruptionTick = 2 / (1 + (GetHaste()/100))
        local siphonTick = 3 / (1 + (GetHaste()/100))

        if debuff.unstableAffliction == nil then debuff.unstableAffliction = {} end
        function debuff.unstableAffliction.stack(unit)
            local uaStack = 0
            if unit == nil then unit = units.dyn40 end
            if debuff.unstableAffliction1.exists(unit,"exact") then uaStack = 1 end
            if debuff.unstableAffliction2.exists(unit,"exact") then uaStack = 2 end
            if debuff.unstableAffliction3.exists(unit,"exact") then uaStack = 3 end
            if debuff.unstableAffliction4.exists(unit,"exact") then uaStack = 4 end
            if debuff.unstableAffliction5.exists(unit,"exact") then uaStack = 5 end
            return uaStack
        end

        function debuff.unstableAffliction.remain(stack,unit)
            if unit == nil then unit = units.dyn40 end
            return debuff["unstableAffliction"..stack].remain(unit,"exact")
        end

        function debuff.unstableAffliction.duration(stack,unit)
            if unit == nil then unit = units.dyn40 end
            if duration == nil then duration = 0 end
            if stack == nil then
                for i = 1, 5 do
                    if debuff.unstableAffliction.remain(i,unit) > 0 then
                        duration = debuff["unstableAffliction"..i].duration(unit,"exact")
                    end
                end
            else
                duration = debuff["unstableAffliction"..stack].duration(unit,"exact")
            end
            return duration
        end
        if sindoreiSpiteOffCD == nil then sindoreiSpiteOffCD = true end
        if buff.sindoreiSpite.exists() and sindoreiSpiteOffCD then
            sindoreiSpiteOffCD = false
            C_Timer.After(180, function()
                sindoreiSpiteOffCD = true
            end)
        end

        -- Opener Variables
        if not inCombat and not GetObjectExists("target") then
            openerCount = 0
            OPN1 = false
            AGN1 = false
            COR1 = false
            SIL1 = false
            PHS1 = false
            UAF1 = false
            UAF2 = false
            RES1 = false
            UAF3 = false
            SOH1 = false
            DRN1 = false
            opener = false
        end

        -- Pet Data
        if summonPet == 1 then summonId = 416 end
        if summonPet == 2 then summonId = 1860 end
        if summonPet == 3 then summonId = 417 end
        if summonPet == 4 then summonId = 1863 end
        if summonPet == 5 then summonId = 17252 end
        if summonPet == 6 then summonId = 78158 end
        if summonPet == 7 then summonId = 78217 end
        if cd.grimoireOfService.remain() == 0 or prevService == nil then prevService = "None" end

        local doomguard = false
        local infernal = false
        if br.player.pet ~= nil then
            for i = 1, #br.player.pet do
                local thisUnit = br.player.pet[i].id
                if thisUnit == 11859 then doomguard = true end
                if thisUnit == 89 then infernal = true end
            end
        end

        local lowestAgony = lowestAgony or "target"
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if debuff.agony.exists(thisUnit) then
                if debuff.agony.exists(lowestAgony) then
                    agonyRemaining = debuff.agony.remain(lowestAgony)
                else
                    agonyRemaining = 40
                end
                if debuff.agony.remain(thisUnit) < agonyRemaining then
                    lowestAgony = thisUnit
                end
            end
        end
        -- -- Agony - Drain Soul Break
        -- -- agony,cycle_targets=1,if=remains<=tick_time+gcd
        -- if mode.rotation ~= 4 and inCombat and not (IsMounted() or IsFlying()) then
        --     if debuff.agony.exists(lowestAgony) and debuff.agony.remain(lowestAgony) <= 2 + gcd then
        --         if cast.agony(lowestAgony,"aoe") then return end
        --     end
        --     if effigied and debuff.agony.remain(effigyUnit) < 3 + gcd then
        --         if cast.agony(effigyUnit,"aoe") then return end
        --     end
        --     for i = 1, #enemies.yards40 do
        --         local thisUnit = enemies.yards40[i]
        --     --     if effigied and ObjectID(thisUnit) == 103679 then
        --     --         if debuff.agony.remain(thisUnit) < 4 + gcd then
        --     --             if cast.agony(thisUnit,"aoe") then return end
        --     --         end
        --     --     end
        --         if (debuff.agony.count() < getOptionValue("Multi-Dot Limit") + effigyCount or debuff.agony.exists(thisUnit)) and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and debuff.agony.remain(thisUnit) <= 3 + gcd
        --             and isValidUnit(thisUnit) and bossHPLimit(thisUnit,getOptionValue("Agony Boss HP Limit")) --(not inBossFight or (inBossFight and UnitHealthMax(thisUnit) > bossHPMax * (getOptionValue("Agony Boss HP Limit") / 100)))
        --         then
        --             if cast.agony(thisUnit,"aoe") then return end
        --         end
        --     end
        -- end

        -- if GetUnitExists("target") then ChatOverlay(lowestAgony) end

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
                        if isChecked("Pet Management") then
                            PetStopAttack()
                            PetFollow()
                        end
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
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Dark Pact
                if isChecked("Dark Pact") and php <= getOptionValue("Dark Pact") then
                    if cast.darkPact() then return end
                end
        -- Drain Soul
                if isChecked("Drain Soul") and php <= getOptionValue("Drain Soul") and isValidTarget("target") then
                    if cast.drainSoul() then return end
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
			if getDistance(units.dyn40) < 40 then
                if useCDs() then
                    if isChecked("Pet Management") then
        -- Summon Doomguard
                        -- summon_doomguard,if=!talent.grimoire_of_supremacy.enabled&spell_targets.summon_infernal<=2&(target.time_to_die>180|target.health.pct<=20|target.time_to_die<30)
                        if isChecked("Summon Doomguard") and not cast.last.summonDoomguard() then
                            if not talent.grimoireOfSupremacy and #enemies.yards8t <= 2
                                and (ttd(units.dyn40) > 180 or getHP(units.dyn40) <= 20 or ttd(units.dyn40) < 30 or isDummy())
                            then
                                if cast.summonDoomguard() then summonTime = GetTime(); return end
                            end
                        end
        -- Summon Infernal
                        -- summon_infernal,if=!talent.grimoire_of_supremacy.enabled&spell_targets.summon_infernal>2
                        if isChecked("Summon Infernal") and not cast.last.summonInfernal() then
                            if not talent.grimoireOfSupremacy and #enemies.yards8t > 2 then
                                if cast.summonInfernal() then summonTime = GetTime(); return end
                            end
                        end
        -- Summon Doomguard
                        -- summon_doomguard,if=talent.grimoire_of_supremacy.enabled&spell_targets.summon_infernal=1&equipped.132379&!cooldown.sindorei_spite_icd.remains
                        if isChecked("Summon Doomguard") and not cast.last.summonDoomguard() then
                            if talent.grimoireOfSupremacy and #enemies.yards8t == 1 and hasEquiped(132379) and sindoreiSpiteOffCD and GetTime() > summonTime + 275 then
                                if cast.summonDoomguard() then summonTime = GetTime(); return end
                            end
                        end
        -- Summon Infernal
                        -- summon_infernal,if=talent.grimoire_of_supremacy.enabled&spell_targets.summon_infernal>1&equipped.132379&!cooldown.sindorei_spite_icd.remains
                        if isChecked("Summon Infernal") and cast.last.summonInfernal() then
                            if talent.grimoireOfSupremacy and #enemies.yards8t > 1 and hasEquiped(132379) and sindoreiSpiteOffCD and GetTime() > summonTime + 275 then
                                if cast.summonInfernal() then summonTime = GetTime(); return end
                            end
                        end
                    end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                    -- berserking,if=prev_gcd.1.unstable_affliction|buff.soul_harvest.remains>=10
                    -- blood_fury
                    if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "BloodElf"
                        or (br.player.race == "Troll" and (cast.last.unstableAffliction() or buff.soulHarvest.remain() >= 10)))
                    then
                        if cast.racial() then return end
                    end
                end
                if talent.maleficGrasp then
        -- Siphon Life
                    -- siphon_life,cycle_targets=1,if=remains<=(tick_time+gcd)&target.time_to_die>tick_time*3
                    if ((mode.rotation == 1 and #enemies.yards40 >= 1) or (mode.rotation == 2 and #enemies.yards40 > 0)) then
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if debuff.siphonLife.count() < getOptionValue("Multi-Dot Limit") + effigyCount and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and isValidUnit(thisUnit) then
                                if debuff.siphonLife.remain(thisUnit) <= siphonTick + gcd and (ttd(thisUnit) > siphonTick * 3 or isDummy(thisUnit)) then
                                    if cast.siphonLife(thisUnit,"aoe") then return end
                                end
                            end
                        end
                    end
        -- Corruption
                    -- corruption,cycle_targets=1,if=(!talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<3)&spell_targets.seed_of_corruption<5&remains<=(tick_time+gcd)&target.time_to_die>tick_time*3
                    if ((mode.rotation == 1 and #enemies.yards40 >= 1) or (mode.rotation == 2 and #enemies.yards40 > 0)) then
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if debuff.corruption.count() < getOptionValue("Multi-Dot Limit") + effigyCount
                                and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and isValidUnit(thisUnit)
                            then
                                if (not talent.sowTheSeeds or #enemies.yards10t < 3) and #enemies.yards10t < 5 and debuff.corruption.remain(thisUnit) <= corruptionTick + gcd
                                    and (ttd(thisUnit) > corruptionTick * 3 or isDummy(thisUnit))
                                then
                                    if cast.corruption(thisUnit,"aoe") then return end
                                end
                            end
                        end
                    end
        -- Phantom Singularity
                    -- phantom_singularity
                    if cast.phantomSingularity() then return end
                end
        -- Soul Harvest
                if isChecked("Soul Harvest") and getOptionValue("Soul Harvest") >= debuff.agony.count() then
                    -- soul_harvest,if=buff.soul_harvest.remains<=8&buff.active_uas.stack>=1
                    if talent.haunt and buff.soulHarvest.remain() <= 8 and debuff.unstableAffliction.stack(units.dyn40) >= 1 then
                        if cast.soulHarvest() then return end
                    end
                    -- soul_harvest,if=buff.active_uas.stack>1&buff.soul_harvest.remains<=8&sim.target=target&(!talent.deaths_embrace.enabled|target.time_to_die>=136|target.time_to_die<=40)
                    if talent.maleficGrasp and debuff.unstableAffliction.stack(units.dyn40) > 1 and buff.soulHarvest.remain() <= 8
                        and (not talent.deathsEmbrace or ttd(units.dyn40) >= 136 or ttd(unit.dyn40) <= 40 or isDummy(thisUnit))
                    then
                        if cast.soulHarvest() then return end
                    end
                    -- soul_harvest,if=sim.target=target&buff.soul_harvest.remains<=8&(buff.active_uas.stack>=2|active_enemies>3)&(!talent.deaths_embrace.enabled|time_to_die>120|time_to_die<30)
                    if not (talent.haunt or talent.maleficGrasp) and buff.soulHarvest.remain() <= 8 and (debuff.unstableAffliction.stack(units.dyn40) >= 2 or #enemies.yards40 > 3)
                        and (not talent.deathsEmbrace or ttd(units.dyn40) > 120 or ttd(units.dyn40) < 30 or isDummy(thisUnit))
                    then
                        if cast.soulHarvest() then return end
                    end
                end
        -- Trinkets
                -- use_item,slot=trinket1
                -- use_item,slot=trinket2
                if isChecked("Trinkets") then
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end
        -- Potion
                if isChecked("Potion") and inRaid then
                    if talent.haunt then
                        -- potion,if=!talent.soul_harvest.enabled&(trinket.proc.any.react|trinket.stack_proc.any.react|target.time_to_die<=70|buff.active_uas.stack>2)
                        if not talent.soulHarvest and (ttd(units.dyn40) <= 70 or debuff.unstableAffliction.stack(units.dyn40) > 2) then
                            if canUse(142117) then
                                useItem(142117)
                            end
                        end
                        -- potion,if=talent.soul_harvest.enabled&buff.soul_harvest.remains&(trinket.proc.any.react|trinket.stack_proc.any.react|target.time_to_die<=70|!cooldown.haunt.remains|buff.active_uas.stack>2)
                        if talent.soulHarvest and buff.soulHarvest.exists() and (ttd(units.dyn40) <= 70 or not cd.haunt.exists() or debuff.unstableAffliction.stack(units.dyn40) > 2) then
                            if canUse(142117) then
                                useItem(142117)
                            end
                        end
                    end
                    if not talent.haunt then
                        -- potion,if=target.time_to_die<=70
                        if ttd(units.dyn40) <= 70 then
                            if canUse(142117) then
                                useItem(142117)
                            end
                        end
                        -- potion,if=(!talent.soul_harvest.enabled|buff.soul_harvest.remains>12)&buff.active_uas.stack>=2
                        if (not talent.soulHarvest or buff.soulHarvest.remain() > 12) and debuff.unstableAffliction.stack(units.dyn40) >= 2 then
                            if canUse(142117) then
                                useItem(142117)
                            end
                        end
                    end
                end
            end -- End useCDs check
        end -- End Action List - Cooldowns
    -- Action List - Service Pet
        local function actionList_ServicePet()
            if isChecked("Pet Management") and GetObjectExists("target") and (getOptionValue("Grimoire of Service - Use") == 1 or (getOptionValue("Grimoire of Service - Use") == 2 and useCDs())) then
                if br.timer:useTimer("summonPet", cast.time.summonVoidwalker()+gcd) then
                    if grimoirePet == 1 and not cast.last.grimoireImp() then
                        if cast.grimoireImp("target") then prevService = "Imp"; return end
                    end
                    if grimoirePet == 2 and not cast.last.grimoireVoidwalker() then
                        if cast.grimoireVoidwalker("target") then prevService = "Voidwalker"; return end
                    end
                    if grimoirePet == 3 and not cast.last.grimoireFelhunter() then
                        if cast.grimoireFelhunter("target") then prevService = "Felhunter"; return end
                    end
                    if grimoirePet == 4 and not cast.last.summonSuccubus() then
                        if cast.grimoireSuccubus("target") then prevService = "Succubus"; return end
                    end
                    if grimoirePet == 5 and not cast.last.summonFelguard() then
                        if cast.grimoireFelguard("target") then prevService = "Felguard"; return end
                    end
                    if summonPet == 6 and not cast.last.summonDoomguard() then
                       if talent.grimoireOfSupremacy and not hasEquiped(132379) then
                            if cast.summonDoomguard("target") then castSummonId = spell.summonDoomguard; return end
                        end
                    end
                    if summonPet == 7 and not cast.last.summonInfernal() then
                        if talent.grimoireOfSupremacy and not hasEquiped(132379) then
                            if cast.summonInfernal("target") then castSummonId = spell.summonInfernal; return end
                        end
                    end
                    if summonPet == 8 then return end
                end
            end
        end -- ENd Action List - Service Pet
    -- Action List - Haunt
        local function actionList_Haunt()
            if not moving then
            -- Reap Souls
                if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and mode.multidot == 1 and buff.tormentedSouls.stack() > 0 then
                    -- reap_souls,if=!buff.deadwind_harvester.remains&time>5&(buff.tormented_souls.react>=5|target.time_to_die<=buff.tormented_souls.react*(5+1.5*equipped.144364)+(buff.deadwind_harvester.remains*(5+1.5*equipped.144364)%12*(5+1.5*equipped.144364)))
                    if not buff.deadwindHarvester.exists() and combatTime > 5 and (buff.tormentedSouls.stack() >= 5
                        or ttd(units.dyn40) <= buff.tormentedSouls.stack() * (5 + 1.5 * reapAndSow) + (buff.deadwindHarvester.remain() * (5 + 1.5 * reapAndSow) / 12 * (5 + 1.5 * reapAndSow)))
                    then
                        if cast.reapSouls() then return end
                    end
                    -- reap_souls,if=debuff.haunt.remains&!buff.deadwind_harvester.remains
                    if debuff.haunt.exists(units.dyn40) and not buff.deadwindHarvester.exists() then
                        if cast.reapSouls() then return end
                    end
                    -- reap_souls,if=active_enemies>1&!buff.deadwind_harvester.remains&time>5&soul_shard>0&((talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption>=3)|spell_targets.seed_of_corruption>=5)
                    if ((mode.rotation == 1 and #enemies.yards40 > 1) or (mode.rotation == 2 and #enemies.yards40 > 0)) and not buff.deadwindHarvester.exists and combatTime > 5 and shards > 0
                        and ((talent.sowTheSeeds and #enemies.yards10t >= getOptionValue("Seed Units")) or #enemies.yards10t >= getOptionValue("Seed Units"))
                    then
                        if cast.reapSouls() then return end
                    end
                end
            -- Agony
                -- agony,cycle_targets=1,if=remains<=tick_time+gcd
                if debuff.agony.exists(lowestAgony) and debuff.agony.remain(lowestAgony) <= agonyTick + gcd and isValidUnit(lowestAgony) then
                    if cast.agony(lowestAgony,"aoe") then return end
                end
                -- agony,cycle_targets=1,if=remains<=tick_time+gcd
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (debuff.agony.count() < getOptionValue("Multi-Dot Limit") + effigyCount or debuff.agony.exists(thisUnit))
                        and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and debuff.agony.remain(thisUnit) <= agonyTick + gcd
                        and isValidUnit(thisUnit) and bossHPLimit(thisUnit,getOptionValue("Agony Boss HP Limit"))
                    then
                        if cast.agony(thisUnit,"aoe") then return end
                    end
                end
            -- Drain Soul
                -- drain_soul,cycle_targets=1,if=target.time_to_die<=gcd*2&soul_shard<5
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not cast.current.drainSoul() and mode.multidot == 1 and not moving and ttd(thisUnit) <= gcd * 2 and shards < 5 and isValidUnit(thisUnit) then
                        if cast.drainSoul(thisUnit) then return end
                    end
                end
            -- Service Pet
                -- service_pet,if=dot.corruption.remains&dot.agony.remains
                if debuff.corruption.exists(units.dyn40) and debuff.agony.exists(units.dyn40) then
                    if actionList_ServicePet() then return end
                end
            -- Cooldowns
                if actionList_Cooldowns() then return end
            -- Siphon Life
                -- siphon_life,cycle_targets=1,if=remains<=tick_time+gcd
                if ((mode.rotation == 1 and #enemies.yards40 >= 1) or (mode.rotation == 2 and #enemies.yards40 > 0)) then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if debuff.siphonLife.count() < getOptionValue("Multi-Dot Limit") + effigyCount and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and isValidUnit(thisUnit) then
                            if debuff.siphonLife.remain(thisUnit) <= siphonTick + gcd then
                                if cast.siphonLife(thisUnit,"aoe") then return end
                            end
                        end
                    end
                end
            -- Corruption
                -- corruption,cycle_targets=1,if=remains<=tick_time+gcd&(spell_targets.seed_of_corruption<3&talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<5)
                if ((mode.rotation == 1 and #enemies.yards40 >= 1) or (mode.rotation == 2 and #enemies.yards40 > 0)) then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if debuff.corruption.count() < getOptionValue("Multi-Dot Limit") + effigyCount and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and isValidUnit(thisUnit) then
                            if debuff.corruption.remain(thisUnit) <= corruptionTick + gcd
                                and ((#enemies.yards10t < getOptionValue("Seed Units") and talent.sowTheSeeds) or #enemies.yards10t < getOptionValue("Seed Units"))
                            then
                                if cast.corruption(thisUnit,"aoe") then return end
                            end
                        end
                    end
                end
            -- Reap Souls
                -- reap_souls,if=(buff.deadwind_harvester.remains+buff.tormented_souls.react*(5+equipped.144364))>=(12*(5+1.5*equipped.144364))
                if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and mode.multidot == 1 and buff.tormentedSouls.stack() > 0 then
                    if (buff.deadwindHarvester.remain() + tormented * (5 + reapAndSow)) >= (12 * (5 + 1.5 * reapAndSow)) then
                        if cast.reapSouls() then return end
                    end
                end
            -- Life Tap
                -- life_tap,if=talent.empowered_life_tap.enabled&buff.empowered_life_tap.remains<=gcd
                if talent.empoweredLifeTap and buff.empoweredLifeTap.remain() <= gcd then
                    if cast.lifeTap() then return end
                end
            -- Phantom Singularity
                -- phantom_singularity
                if ((mode.rotation == 1 and #enemies.yards40 > 1) or (mode.rotation == 2 and #enemies.yards40 > 0)) then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if #enemies.yards10t >= getOptionValue("PS Units") and isValidUnit(thisUnit) then
                            if cast.phantomSingularity() then return end
                        end
                    end
                end
            -- Haunt
                -- haunt
                if cast.haunt() then return end
            -- Agony
                -- agony,cycle_targets=1,if=remains<=duration*0.3&target.time_to_die>=remains
                if debuff.agony.exists(lowestAgony) and debuff.agony.refresh(lowestAgony) and ttd(lowestAgony) >= debuff.agony.remain(lowestUnit) then
                    if cast.agony(lowestAgony,"aoe") then return end
                end
                -- agony,cycle_targets=1,if=remains<=duration*0.3&target.time_to_die>=remains
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (debuff.agony.count() < getOptionValue("Multi-Dot Limit") + effigyCount or (debuff.agony.exists(thisUnit) and debuff.agony.refresh(thisUnit)))
                        and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and bossHPLimit(thisUnit,getOptionValue("Agony Boss HP Limit"))
                        and debuff.agony.refresh(thisUnit) and (ttd(thisUnit) >= debuff.agony.remain(thisUnit) or isDummy(thisUnit)) and isValidUnit(thisUnit)
                    then
                        if cast.agony(thisUnit,"aoe") then return end
                    end
                end
            -- Life Tap
                -- life_tap,if=talent.empowered_life_tap.enabled&buff.empowered_life_tap.remains<duration*0.3|talent.malefic_grasp.enabled&target.time_to_die>15&mana.pct<10
                if talent.empoweredLifeTap and (buff.empoweredLifeTap.refresh() or (talent.maleficGrasp and (ttd(units.dyn40) > 15 or isDummy(units.dyn40)) and manaPercent < 10)) then
                    if cast.lifeTap() then return end
                end
            -- Siphon Life
                if ((mode.rotation == 1 and #enemies.yards40 >= 1) or (mode.rotation == 2 and #enemies.yards40 > 0)) then
                    -- siphon_life,if=remains<=duration*0.3&target.time_to_die>=remains
                    if debuff.siphonLife.count() < getOptionValue("Multi-Dot Limit") + effigyCount and (getHP(units.dyn40) > dotHPLimit or isDummy(units.dyn40)) then
                        if debuff.siphonLife.refresh(units.dyn40) and (ttd(units.dyn40) >= debuff.siphonLife.remain(units.dyn40) or isDummy(units.dyn40)) then
                            if cast.siphonLife() then return end
                        end
                    end
                    -- siphon_life,cycle_targets=1,if=remains<=duration*0.3&target.time_to_die>=remains&debuff.haunt.remains>=action.unstable_affliction_1.tick_time*6&debuff.haunt.remains>=action.unstable_affliction_1.tick_time*4
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if debuff.siphonLife.count() < getOptionValue("Multi-Dot Limit") + effigyCount and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and isValidUnit(thisUnit) then
                            if debuff.siphonLife.refresh(thisUnit) and (ttd(thisUnit) > debuff.siphonLife.remain(thisUnit) or isDummy(thisUnit))
                                and debuff.haunt.remain(thisUnit) >= siphonTick * 6 and debuff.haunt.remain(thisUnit) >= siphonTick * 4
                            then
                                if cast.siphonLife(thisUnit) then return end
                            end
                        end
                    end
                end
            -- Seed of Corruption
                -- seed_of_corruption,if=talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption>=3|spell_targets.seed_of_corruption>=5|spell_targets.seed_of_corruption>=3&dot.corruption.remains<=cast_time+travel_time
                if mode.soc == 1 and ((mode.rotation == 1 and #enemies.yards40 >= getOptionValue("Seed Units")) or (mode.rotation == 2 and #enemies.yards40 > 0)) then
                    if (talent.sowTheSeeds and #enemies.yards10t >= getOptionValue("Seed Units")) or #enemies.yards10t >= getOptionValue("Seed Units")
                        or (#enemies.yards10t >= getOptionValue("Seed Units") and debuff.corruption.remain(units.dyn40) <= cast.time.seedOfCorruption())
                    then
                        if cast.seedOfCorruption() then return end
                    end
                end
            -- Corruption
                if ((mode.rotation == 1 and #enemies.yards40 >= 1) or (mode.rotation == 2 and #enemies.yards40 > 0)) then
                    -- corruption,if=remains<=duration*0.3&target.time_to_die>=remains
                    if debuff.corruption.count() < getOptionValue("Multi-Dot Limit") + effigyCount and (getHP(units.dyn40) > dotHPLimit or isDummy(units.dyn40)) then
                        if debuff.corruption.refresh(units.dyn40) and (ttd(units.dyn40) >= debuff.corruption.remain(units.dyn40) or isDummy(units.dyn40)) then
                            if cast.corruption() then return end
                        end
                    end
                    -- corruption,cycle_targets=1,if=remains<=duration*0.3&target.time_to_die>=remains&debuff.haunt.remains>=action.unstable_affliction_1.tick_time*6&debuff.haunt.remains>=action.unstable_affliction_1.tick_time*4
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if debuff.corruption.count() < getOptionValue("Multi-Dot Limit") + effigyCount and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and isValidUnit(thisUnit) then
                            if debuff.corruption.refresh(thisUnit) and (ttd(thisUnit) > debuff.corruption.remain(thisUnit) or isDummy(thisUnit))
                                and debuff.haunt.remain(thisUnit) >= corruptionTick * 6 and debuff.haunt.remain(thisUnit) >= corruptionTick * 4
                            then
                                if cast.corruption(thisUnit) then return end
                            end
                        end
                    end
                end
            -- Unstable Affliction
                -- unstable_affliction,if=(!talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<3)&spell_targets.seed_of_corruption<5&((soul_shard>=4&!talent.contagion.enabled)|soul_shard>=5|target.time_to_die<30)
                if (not talent.sowTheSeeds or #enemies.yards10t >= getOptionValue("Seed Units")) and #enemies.yards10t < getOptionValue("Seed Units")
                    and ((shards >= 4 and not talent.contagion) or shards >= 5 or ttd(units.dyn40) < 30)
                then
                    if cast.unstableAffliction() then return end
                end
                -- unstable_affliction,cycle_targets=1,if=active_enemies>1&(!talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<3)&soul_shard>=4&talent.contagion.enabled&cooldown.haunt.remains<15&dot.unstable_affliction_1.remains<cast_time&dot.unstable_affliction_2.remains<cast_time&dot.unstable_affliction_3.remains<cast_time&dot.unstable_affliction_4.remains<cast_time&dot.unstable_affliction_5.remains<cast_time
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if ((mode.rotation == 1 and #enemies.yards40 > 1) or (mode.rotation == 2 and #enemies.yards40 > 0)) and (not talent.sowTheSeeds or #enemies.yards10t >= getOptionValue("Seed Units"))
                        and shards >= 4 and talent.contagion and cd.haunt.remain() < 15 and debuff.unstableAffliction.remain(1,thisUnit) < cast.time.unstableAffliction()
                        and debuff.unstableAffliction.remain(2,thisUnit) < cast.time.unstableAffliction() and debuff.unstableAffliction.remain(3,thisUnit) < cast.time.unstableAffliction()
                        and debuff.unstableAffliction.remain(4,thisUnit) < cast.time.unstableAffliction() and debuff.unstableAffliction.remain(5,thisUnit) < cast.time.unstableAffliction()
                        and isValidUnit(thisUnit)
                    then
                        if cast.unstableAffliction(thisUnit) then return end
                    end
                end
                -- unstable_affliction,cycle_targets=1,if=active_enemies>1&(!talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<3)&(equipped.132381|equipped.132457)&cooldown.haunt.remains<15&dot.unstable_affliction_1.remains<cast_time&dot.unstable_affliction_2.remains<cast_time&dot.unstable_affliction_3.remains<cast_time&dot.unstable_affliction_4.remains<cast_time&dot.unstable_affliction_5.remains<cast_time
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if ((mode.rotation == 1 and #enemies.yards40 > 1) or (mode.rotation == 2 and #enemies.yards40 > 0)) and (not talent.sowTheSeeds or #enemies.yards10t >= getOptionValue("Seed Units"))
                        and (hasEquiped(132381) or hasEquiped(132457)) and cd.haunt.remain() < 15 and debuff.unstableAffliction.remain(1,thisUnit) < cast.time.unstableAffliction()
                        and debuff.unstableAffliction.remain(2,thisUnit) < cast.time.unstableAffliction() and debuff.unstableAffliction.remain(3,thisUnit) < cast.time.unstableAffliction()
                        and debuff.unstableAffliction.remain(4,thisUnit) < cast.time.unstableAffliction() and debuff.unstableAffliction.remain(5,thisUnit) < cast.time.unstableAffliction()
                        and isValidUnit(thisUnit)
                    then
                        if cast.unstableAffliction(thisUnit) then return end
                    end
                end
                -- unstable_affliction,if=(!talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<3)&spell_targets.seed_of_corruption<5&talent.contagion.enabled&soul_shard>=4&dot.unstable_affliction_1.remains<cast_time&dot.unstable_affliction_2.remains<cast_time&dot.unstable_affliction_3.remains<cast_time&dot.unstable_affliction_4.remains<cast_time&dot.unstable_affliction_5.remains<cast_time
                if (not talent.sowTheSeeds or #enemies.yards10t >= getOptionValue("Seed Units")) and #enemies.yards10t >= getOptionValue("Seed Units")
                    and talent.contagion and shards >= 4 and debuff.unstableAffliction.remain(1,units.dyn40) < cast.time.unstableAffliction()
                    and debuff.unstableAffliction.remain(2,units.dyn40) < cast.time.unstableAffliction() and debuff.unstableAffliction.remain(3,units.dyn40) < cast.time.unstableAffliction()
                    and debuff.unstableAffliction.remain(4,units.dyn40) < cast.time.unstableAffliction() and debuff.unstableAffliction.remain(5,units.dyn40) < cast.time.unstableAffliction()
                    and isValidUnit(thisUnit)
                then
                    if cast.unstableAffliction() then return end
                end
                -- unstable_affliction,if=(!talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<3)&spell_targets.seed_of_corruption<5&debuff.haunt.remains>=action.unstable_affliction_1.tick_time*2
                if (not talent.sowTheSeeds or #enemies.yards10t >= getOptionValue("Seed Units")) and #enemies.yards10t >= getOptionValue("Seed Units") and debuff.haunt.remain(units.dyn40) >= 4 * 2 then
                    if cast.unstableAffliction() then return end
                end
            -- Reap Souls
                -- reap_souls,if=!buff.deadwind_harvester.remains&(buff.active_uas.stack>1|(prev_gcd.1.unstable_affliction&buff.tormented_souls.react>1))
                if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and mode.multidot == 1 and buff.tormentedSouls.stack() > 0 then
                    if not buff.deadwindHarvester.exists() and (debuff.unstableAffliction.stack(units.dyn40) > 1 or (cast.last.unstableAffliction() and buff.tormentedSouls.stack() > 1)) then
                        if cast.reapSouls() then return end
                    end
                end
            -- Life Tap
                -- life_tap,if=mana.pct<=10
                if manaPercent <= 10 and php > getOptionValue("Life Tap HP Limit") then
                    if cast.lifeTap() then return end
                end
                -- life_tap,if=prev_gcd.1.life_tap&buff.active_uas.stack=0&mana.pct<50
                if cast.last.lifeTap() and debuff.unstableAffliction.stack(units.dyn40) == 0 and manaPercent < 50 and php > getOptionValue("Life Tap HP Limit") then
                    if cast.lifeTap() then return end
                end
            -- Drain Soul
                -- drain_soul,chain=1,interrupt=1
                if not cast.current.drainSoul() and not moving then
                    if cast.drainSoul("target") then return end
                end
            end
            if moving then
        -- Life Tap
                -- life_tap,moving=1,if=mana.pct<80
                if manaPercent < 80 and php > getOptionValue("Life Tap HP Limit") then
                    if cast.lifeTap() then return end
                end
        -- Agony
                -- agony,moving=1,cycle_targets=1,if=remains<=duration-(3*tick_time)
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.agony.remain(thisUnit) <= debuff.agony.duration(thisUnit) - (3 * agonyTick) and isValidUnit(thisUnit) then
                        if cast.agony(thisUnit) then return end
                    end
                end
        -- Siphon Life
                -- siphon_life,moving=1,cycle_targets=1,if=remains<=duration-(3*tick_time)
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.siphonLife.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(units.dyn40) > dotHPLimit and isValidUnit(thisUnit) then
                        if debuff.siphonLife.remain(thisUnit) <= debuff.siphonLife.duration(thisUnit) - (3 * siphonTick) then
                            if cast.siphonLife(thisUnit) then return end
                        end
                    end
                end
        -- Corruption
                -- corruption,moving=1,cycle_targets=1,if=remains<=duration-(3*tick_time)
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.corruption.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(units.dyn40) > dotHPLimit and isValidUnit(thisUnit) then
                        if debuff.corruption.remain(thisUnit) <= debuff.corruption.duration(thisUnit) - (3 * corruptionTick) then
                            if cast.corruption(thisUnit) then return end
                        end
                    end
                end
            end
        -- Shadow Bolt
            if level < 13 then
                if cast.shadowBolt() then return end
            end
        -- Life Tap
            -- life_tap,moving=0
            if not moving and manaPercent < 90 and php > getOptionValue("Life Tap HP Limit") and not cast.current.drainSoul() then
                if cast.lifeTap() then return end
            end
        end -- End Action List - Haunt
    -- Action List - Malefic Grasp
        local function actionList_MG()
            if not moving then
        -- Reap Souls
            -- reap_souls,if=!buff.deadwind_harvester.remains&time>5&((buff.tormented_souls.react>=4+active_enemies|buff.tormented_souls.react>=9)|target.time_to_die<=buff.tormented_souls.react*(5+1.5*equipped.144364)+(buff.deadwind_harvester.remains*(5+1.5*equipped.144364)%12*(5+1.5*equipped.144364)))
            if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and mode.multidot == 1 and buff.tormentedSouls.stack() > 0 then
                if not buff.deadwindHarvester.exists() and combatTime > 5 and ((buff.tormentedSouls.stack() >= 4 + #enemies.yards40 or buff.tormentedSouls.stack() >= 9)
                    or ttd(units.dyn40) <= buff.tormentedSouls.stack() * (5 + 1.5 * reapAndSow) + (buff.deadwindHarvester.remain() * (5 + 1.5 * reapAndSow) / 12 * (5 + 1.5 * reapAndSow)))
                then
                    if cast.reapSouls() then return end
                end
            end
        -- Agony
            -- agony,cycle_targets=1,max_cycle_targets=5,target_if=sim.target!=target&talent.soul_harvest.enabled&cooldown.soul_harvest.remains<cast_time*6&remains<=duration*0.3&target.time_to_die>=remains&time_to_die>tick_time*3
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (debuff.agony.count() < getOptionValue("Multi-Dot Limit") + effigyCount or (debuff.agony.exists(thisUnit) and debuff.agony.refresh(thisUnit)))
                    and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and bossHPLimit(thisUnit,getOptionValue("Agony Boss HP Limit"))
                then
                    if talent.soulHarvest and cd.soulHarvest.remain() < cast.time.soulHarvest() * 6 and debuff.agony.refresh(thisUnit)
                        and ((ttd(thisUnit) >= debuff.agony.remain(thisUnit) and ttd(thisUnit) > agonyTick * 3) or isDummy(thisUnit)) and isValidUnit(thisUnit)
                    then
                        if cast.agony(thisUnit) then return end
                    end
                end
            end
            -- agony,cycle_targets=1,max_cycle_targets=4,if=remains<=(tick_time+gcd)
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (debuff.agony.count() < getOptionValue("Multi-Dot Limit") + effigyCount or (debuff.agony.exists(thisUnit) and debuff.agony.refresh(thisUnit)))
                    and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and bossHPLimit(thisUnit,getOptionValue("Agony Boss HP Limit")) and isValidUnit(thisUnit)
                then
                    if debuff.agony.remain(thisUnit) <= (agonyTick + gcd) then
                        if cast.agony(thisUnit) then return end
                    end
                end
            end
        -- Seed of Corruption
            -- seed_of_corruption,if=talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption>=3&soul_shard=5
            if mode.soc == 1 and ((mode.rotation == 1 and #enemies.yards40 >= getOptionValue("Seed Units")) or (mode.rotation == 2 and #enemies.yards40 > 0)) then
                if (talent.sowTheSeeds and #enemies.yards10t >= getOptionValue("Seed Units")) and shards == 5 then
                    if cast.seedOfCorruption() then return end
                end
            end
        -- Unstable Affliction
            -- unstable_affliction,if=target=sim.target&soul_shard=5
            if UnitIsUnit(units.dyn40,"target") and shards == 5 then
                if cast.unstableAffliction() then return end
            end
        -- Drain Soul
            -- drain_soul,cycle_targets=1,if=target.time_to_die<gcd*2&soul_shard<5
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not cast.current.drainSoul() and mode.multidot == 1 and not moving and ttd(thisUnit) < gcd * 2 and shards < 5 and isValidUnit(thisUnit) then
                    if cast.drainSoul(thisUnit) then return end
                end
            end
        -- Life Tap
            -- life_tap,if=talent.empowered_life_tap.enabled&buff.empowered_life_tap.remains<=gcd
            if talent.empoweredLifeTap and buff.empoweredLifeTap.remain() <= gcd then
                if cast.lifeTap() then return end
            end
        -- Service Pet
            -- service_pet,if=dot.corruption.remains&dot.agony.remains
            if debuff.corruption.exists(units.dyn40) and debuff.agony.exists(units.dyn40) then
                if actionList_ServicePet() then return end
            end
        -- Cooldowns
            if actionList_Cooldowns() then return end
        -- Agony
            -- agony,cycle_targets=1,if=remains<=(duration*0.3)&target.time_to_die>=remains&(buff.active_uas.stack=0|prev_gcd.1.agony)
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (debuff.agony.count() < getOptionValue("Multi-Dot Limit") + effigyCount or (debuff.agony.exists(thisUnit) and debuff.agony.refresh(thisUnit)))
                    and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and bossHPLimit(thisUnit,getOptionValue("Agony Boss HP Limit")) and isValidUnit(thisUnit)
                then
                    if debuff.agony.refresh(thisUnit) and (ttd(thisUnit) >= debuff.agony.remain(thisUnit) or isDummy(thisUnit))
                        and (debuff.unstableAffliction.stack(thisUnit) == 0 or cast.last.agony())
                    then
                        if cast.agony(thisUnit) then return end
                    end
                end
            end
        -- Siphon Life
            -- siphon_life,cycle_targets=1,if=remains<=(duration*0.3)&target.time_to_die>=remains&(buff.active_uas.stack=0|prev_gcd.1.siphon_life)
            if talent.siphonLife and ((mode.rotation == 1 and #enemies.yards40 >= 1) or (mode.rotation == 2 and #enemies.yards40 > 0)) then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.siphonLife.count() < getOptionValue("Multi-Dot Limit") + effigyCount and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and isValidUnit(thisUnit) then
                        if debuff.siphonLife.refresh(thisUnit) and (ttd(thisUnit) >= debuff.siphonLife.remain(thisUnit) or isDummy(thisUnit))
                            and (debuff.unstableAffliction.stack(thisUnit) == 0 or cast.last.siphonLife())
                        then
                            if cast.siphonLife(thisUnit,"aoe") then return end
                        end
                    end
                end
            end
        -- Corruption
            -- corruption,cycle_targets=1,if=(!talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<3)&spell_targets.seed_of_corruption<5&remains<=(duration*0.3)&target.time_to_die>=remains&(buff.active_uas.stack=0|prev_gcd.1.corruption)
            if ((mode.rotation == 1 and #enemies.yards40 >= 1) or (mode.rotation == 2 and #enemies.yards40 > 0)) then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.corruption.count() < getOptionValue("Multi-Dot Limit") + effigyCount and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and isValidUnit(thisUnit) then
                        if (not talent.sowTheSeeds or #enemies.yards10t < getOptionValue("Seed Units")) and #enemies.yards10t < getOptionValue("Seed Units") and debuff.corruption.refresh(thisUnit)
                            and (ttd(thisUnit) >= debuff.corruption.remain(thisUnit) or isDummy(thisUnit)) and (debuff.unstableAffliction.stack(thisUnit) == 0 or cast.last.corruption())
                        then
                            if cast.corruption(thisUnit,"aoe") then return end
                        end
                    end
                end
            end
        -- Life Tap
            -- life_tap,if=talent.empowered_life_tap.enabled&buff.empowered_life_tap.remains<duration*0.3|talent.malefic_grasp.enabled&target.time_to_die>15&mana.pct<10
            if talent.empoweredLifeTap and (buff.empoweredLifeTap.refresh() or (talent.maleficGrasp and (ttd(units.dyn40) > 15 or isDummy(units.dyn40)) and manaPercent < 10)) then
                if cast.lifeTap() then return end
            end
        -- Seed of Corruption
            -- seed_of_corruption,if=(talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption>=3)|(spell_targets.seed_of_corruption>=5&dot.corruption.remains<=cast_time+travel_time)
            if mode.soc == 1 and ((mode.rotation == 1 and #enemies.yards40 >= getOptionValue("Seed Units")) or (mode.rotation == 2 and #enemies.yards40 > 0)) then
                if (talent.sowTheSeeds and #enemies.yards10t >= getOptionValue("Seed Units"))
                    or (#enemies.yards10t >= getOptionValue("Seed Units") and debuff.corruption.remain(units.dyn40) <= cast.time.seedOfCorruption())
                then
                    if cast.seedOfCorruption() then return end
                end
            end
        -- Unstable Affliction
            -- unstable_affliction,if=target=sim.target&target.time_to_die<30
            if talent.contagion and #enemies.yards40 == 3 and debuff.corruption.count() == 3 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (ttd(thisUnit) >= 30 or isDummy(thisUnit)) and debuff.corruption.remain(thisUnit)
                        and debuff.unstableAffliction.remain(1,thisUnit) < cast.time.unstableAffliction()
                    then
                        if cast.unstableAffliction(thisUnit) then return end
                    end
                end
            end
            if UnitIsUnit(units.dyn40,"target") then
                if ttd(units.dyn40) < 30 then
                    if cast.unstableAffliction() then return end
                end
                -- unstable_affliction,if=target=sim.target&active_enemies>1&soul_shard>=4
                if ((mode.rotation == 1 and #enemies.yards40 > 1) or (mode.rotation == 2 and #enemies.yards40 > 0)) and shards >= 4 then
                    if cast.unstableAffliction() then return end
                end
                -- unstable_affliction,if=target=sim.target&(buff.active_uas.stack=0|(!prev_gcd.3.unstable_affliction&prev_gcd.1.unstable_affliction))&dot.agony.remains>cast_time+(6.5*spell_haste)
                if (debuff.unstableAffliction.stack(units.dyn40) < 5 or cast.last.unstableAffliction()) and debuff.agony.remain(units.dyn40) > cast.time.unstableAffliction() + (6.5 * (GetHaste()/100)) then
                    if cast.unstableAffliction() then return end
                end
            end
        -- Reap Souls
            -- reap_souls,if=buff.deadwind_harvester.remains<dot.unstable_affliction_1.remains|buff.deadwind_harvester.remains<dot.unstable_affliction_2.remains|buff.deadwind_harvester.remains<dot.unstable_affliction_3.remains|buff.deadwind_harvester.remains<dot.unstable_affliction_4.remains|buff.deadwind_harvester.remains<dot.unstable_affliction_5.remains&buff.active_uas.stack>1
            if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and mode.multidot == 1 and buff.tormentedSouls.stack() > 0 then
                if (buff.deadwindHarvester.remain() < debuff.unstableAffliction.remain(1,units.dyn40) or buff.deadwindHarvester.remain() < debuff.unstableAffliction.remain(2,units.dyn40)
                    or buff.deadwindHarvester.remain() < debuff.unstableAffliction.remain(3,units.dyn40) or buff.deadwindHarvester.remain() < debuff.unstableAffliction.remain(4,units.dyn40)
                    or buff.deadwindHarvester.remain() < debuff.unstableAffliction.remain(5,units.dyn40)) and debuff.unstableAffliction.stack(units.dyn40) > 1
                then
                    if cast.reapSouls() then return end
                end
            end
        -- Life Tap
            -- life_tap,if=mana.pct<=10
            if manaPercent <= 10 and php > getOptionValue("Life Tap HP Limit") then
                if cast.lifeTap() then return end
            end
            -- life_tap,if=prev_gcd.1.life_tap&buff.active_uas.stack=0&mana.pct<50
            if cast.last.lifeTap() and debuff.unstableAffliction.stack(units.dyn40) == 0 and manaPercent < 50 and php > getOptionValue("Life Tap HP Limit") then
                if cast.lifeTap() then return end
            end
        -- Drain Soul
            -- drain_soul,chain=1,interrupt=1
            if not cast.current.drainSoul() and not moving then
                if cast.drainSoul("target") then return end
            end
        end -- end not moving
            if moving then
        -- Life Tap
                -- life_tap,moving=1,if=mana.pct<80
                if manaPercent < 80 and php > getOptionValue("Life Tap HP Limit") then
                    if cast.lifeTap() then return end
                end
        -- Agony
                -- agony,moving=1,cycle_targets=1,if=remains<=duration-(3*tick_time)
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not debuff.agony.exists(thisUnit) or debuff.agony.remain(thisUnit) <= debuff.agony.duration(thisUnit) - (3 * agonyTick) then
                        if cast.agony(thisUnit) then return end
                    end
                end
        -- Siphon Life
                -- siphon_life,moving=1,cycle_targets=1,if=remains<=duration-(3*tick_time)
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.siphonLife.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(units.dyn40) > dotHPLimit and isValidUnit(thisUnit) then
                        if debuff.siphonLife.remain(thisUnit) <= debuff.siphonLife.duration(thisUnit) - (3 * siphonTick) then
                            if cast.siphonLife(thisUnit) then return end
                        end
                    end
                end
        -- Corruption
                -- corruption,moving=1,cycle_targets=1,if=remains<=duration-(3*tick_time)
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.corruption.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(units.dyn40) > dotHPLimit and isValidUnit(thisUnit) then
                        if debuff.corruption.remain(thisUnit) <= debuff.corruption.duration(thisUnit) - (3 * corruptionTick) then
                            if cast.corruption(thisUnit) then return end
                        end
                    end
                end
            end
        -- Life Tap
            -- life_tap,moving=0
            if not moving and manaPercent < 90 and php > getOptionValue("Life Tap HP Limit") and not cast.current.drainSoul() then
                if cast.lifeTap() then return end
            end
        end -- End Action List - Malefic Grasp
    -- Action List - Writhe In Agony
        local function actionList_Writhe()
            if not moving then
            -- Reap Souls
                if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and mode.multidot == 1 and buff.tormentedSouls.stack() > 0 then
                    -- reap_souls,if=!buff.deadwind_harvester.remains&time>5&(buff.tormented_souls.react>=5|target.time_to_die<=buff.tormented_souls.react*(5+1.5*equipped.144364)+(buff.deadwind_harvester.remains*(5+1.5*equipped.144364)%12*(5+1.5*equipped.144364)))
                    if not buff.deadwindHarvester.exists() and combatTime > 5 and (buff.tormentedSouls.stack() >= 5
                        or ttd(units.dyn40) <= buff.tormentedSouls.stack() * (5 + 1.5 * reapAndSow) + (buff.deadwindHarvester.remain() * (5 + 1.5 * reapAndSow) / 12 * (5 + 1.5 * reapAndSow)))
                    then
                        if cast.reapSouls() then return end
                    end
                    -- reap_souls,if=!buff.deadwind_harvester.remains&time>5&(buff.soul_harvest.remains>=(5+1.5*equipped.144364)&buff.active_uas.stack>1|buff.concordance_of_the_legionfall.react|trinket.proc.intellect.react|trinket.stacking_proc.intellect.react|trinket.proc.mastery.react|trinket.stacking_proc.mastery.react|trinket.proc.crit.react|trinket.stacking_proc.crit.react|trinket.proc.versatility.react|trinket.stacking_proc.versatility.react|trinket.proc.spell_power.react|trinket.stacking_proc.spell_power.react)
                    if not buff.deadwindHarvester.exists() and combatTime > 5 and (buff.soulHarvest.remain() >= (5 + 1.5 * reapAndSow)
                        and (debuff.unstableAffliction.stack(units.dyn40) > 1 or buff.concordanceOfTheLegionfall.exists()))
                    then
                        if cast.reapSouls() then return end
                    end
                end
            -- Agony
                -- agony,if=remains<=tick_time+gcd
                if debuff.agony.remain(units.dyn40) <= agonyTick + gcd then
                    if cast.agony(units.dyn40) then return end
                end
                -- agony,cycle_targets=1,max_cycle_targets=5,target_if=sim.target!=target&talent.soul_harvest.enabled&cooldown.soul_harvest.remains<cast_time*6&remains<=duration*0.3&target.time_to_die>=remains&time_to_die>tick_time*3
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (debuff.agony.count() < getOptionValue("Multi-Dot Limit") + effigyCount or (debuff.agony.exists(thisUnit) and debuff.agony.refresh(thisUnit)))
                        and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and bossHPLimit(thisUnit,getOptionValue("Agony Boss HP Limit")) and isValidUnit(thisUnit)
                    then
                        if talent.soulHarvest and cd.soulHarvest.remain() < cast.time.soulHarvest() * 6 and debuff.agony.refresh(thisUnit)
                            and ((ttd(thisUnit) >= debuff.agony.remain(thisUnit) and ttd(thisUnit) > agonyTick * 3) or isDummy(thisUnit))
                        then
                            if cast.agony(thisUnit) then return end
                        end
                    end
                end
                -- agony,cycle_targets=1,max_cycle_targets=3,target_if=sim.target!=target&remains<=tick_time+gcd&time_to_die>tick_time*3
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (debuff.agony.count() < getOptionValue("Multi-Dot Limit") + effigyCount or (debuff.agony.exists(thisUnit) and debuff.agony.refresh(thisUnit)))
                        and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and bossHPLimit(thisUnit,getOptionValue("Agony Boss HP Limit")) and isValidUnit(thisUnit)
                    then
                        if debuff.agony.remain(thisUnit) <= (agonyTick + gcd) and (ttd(thisUnit) > agonyTick * 3 or isDummy(thisUnit)) then
                            if cast.agony(thisUnit) then return end
                        end
                    end
                end
            -- Seed of Corruption
                -- seed_of_corruption,if=talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption>=3&soul_shard=5
                if mode.soc == 1 and ((mode.rotation == 1 and #enemies.yards40 >= getOptionValue("Seed Units")) or (mode.rotation == 2 and #enemies.yards40 > 0)) then
                    if (talent.sowTheSeeds and #enemies.yards10t >= getOptionValue("Seed Units")) and shards == 5 then
                        if cast.seedOfCorruption() then return end
                    end
                end
            -- Unstable Affliction
                -- unstable_affliction,if=soul_shard=5|(time_to_die<=((duration+cast_time)*soul_shard))
                if shards == 5 or (ttd(units.dyn40) <= ((debuff.unstableAffliction.duration(nil,units.dyn40) + cast.time.unstableAffliction()) * shards)) then
                    if cast.unstableAffliction() then return end
                end
            -- Drain Soul
                -- drain_soul,cycle_targets=1,if=target.time_to_die<=gcd*2&soul_shard<5
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not cast.current.drainSoul() and mode.multidot == 1 and not moving and ttd(thisUnit) < gcd * 2 and shards < 5 and isValidUnit(thisUnit) then
                        if cast.drainSoul(thisUnit) then return end
                    end
                end
            -- Life Tap
                -- life_tap,if=talent.empowered_life_tap.enabled&buff.empowered_life_tap.remains<=gcd
                if talent.empoweredLifeTap and buff.empoweredLifeTap.remain() <= gcd then
                    if cast.lifeTap() then return end
                end
            -- Service Pet
                -- service_pet,if=dot.corruption.remains&dot.agony.remains
                if debuff.corruption.remain(units.dyn40) and debuff.agony.remain(units.dyn40) then
                    if actionList_ServicePet() then return end
                end
            -- Cooldowns
                if actionList_Cooldowns() then return end
            -- Siphon Life
                -- siphon_life,cycle_targets=1,if=remains<=tick_time+gcd&time_to_die>tick_time*2
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.siphonLife.count() < getOptionValue("Multi-Dot Limit") + effigyCount and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and isValidUnit(thisUnit) then
                        if debuff.siphonLife.remain(thisUnit) <= siphonTick + gcd and (ttd(thisUnit) > siphonTick * 2 or isDummy(thisUnit)) then
                            if cast.siphonLife(thisUnit) then return end
                        end
                    end
                end
            -- Corruption
                -- corruption,cycle_targets=1,if=remains<=tick_time+gcd&((spell_targets.seed_of_corruption<3&talent.sow_the_seeds.enabled)|spell_targets.seed_of_corruption<5)&time_to_die>tick_time*2
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.corruption.count() < getOptionValue("Multi-Dot Limit") + effigyCount and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and isValidUnit(thisUnit) then
                        if debuff.corruption.remain(thisUnit) <= corruptionTick + gcd
                            and ((#enemies.yards10t < getOptionValue("Seed Units") and talent.sowTheSeeds) or #enemies.yards10t < getOptionValue("Seed Units"))
                            and (ttd(thisUnit) > corruptionTick * 2 or isDummy(thisUnit))
                        then
                            if cast.corruption(thisUnit) then return end
                        end
                    end
                end
            -- Life Tap
                -- life_tap,if=mana.pct<40&(buff.active_uas.stack<1|!buff.deadwind_harvester.remains)
                if manaPercent < 40 and (debuff.unstableAffliction.stack(units.dyn40) < 1 or not buff.deadwindHarvester.exists()) and php > getOptionValue("Life Tap HP Limit") then
                    if cast.lifeTap() then return end
                end
            -- Reap Souls
                -- reap_souls,if=(buff.deadwind_harvester.remains+buff.tormented_souls.react*(5+equipped.144364))>=(12*(5+1.5*equipped.144364))
                if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and mode.multidot == 1 and buff.tormentedSouls.stack() > 0 then
                    if (buff.deadwindHarvester.remain() + tormented * (5 + reapAndSow)) >= (12 * (5 + 1.5 * reapAndSow)) then
                        if cast.reapSouls() then return end
                    end
                end
            -- Phantom Singularity
                -- phantom_singularity
                if cast.phantomSingularity() then return end
            -- Seed of Corruption
                -- seed_of_corruption,if=(talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption>=3)|(spell_targets.seed_of_corruption>3&dot.corruption.refreshable)
                if mode.soc == 1 and ((mode.rotation == 1 and #enemies.yards40 >= getOptionValue("Seed Units")) or (mode.rotation == 2 and #enemies.yards40 > 0)) then
                    if (talent.sowTheSeeds and #enemies.yards10t < getOptionValue("Seed Units")) or (#enemies.yards10t < getOptionValue("Seed Units") and debuff.corruption.refresh(units.dyn40)) then
                        if cast.seedOfCorruption() then return end
                    end
                end
            -- Unstable Affliction
                -- unstable_affliction,if=talent.contagion.enabled&dot.unstable_affliction_1.remains<cast_time&dot.unstable_affliction_2.remains<cast_time&dot.unstable_affliction_3.remains<cast_time&dot.unstable_affliction_4.remains<cast_time&dot.unstable_affliction_5.remains<cast_time
                if talent.contagion and debuff.unstableAffliction.remain(1,units.dyn40) < cast.time.unstableAffliction()
                    and debuff.unstableAffliction.remain(2,units.dyn40) < cast.time.unstableAffliction() and debuff.unstableAffliction.remain(3,units.dyn40) < cast.time.unstableAffliction()
                    and debuff.unstableAffliction.remain(4,units.dyn40) < cast.time.unstableAffliction() and debuff.unstableAffliction.remain(5,units.dyn40) < cast.time.unstableAffliction()
                then
                    if cast.unstableAffliction() then return end
                end
                -- unstable_affliction,cycle_targets=1,target_if=buff.deadwind_harvester.remains>=duration+cast_time&dot.unstable_affliction_1.remains<cast_time&dot.unstable_affliction_2.remains<cast_time&dot.unstable_affliction_3.remains<cast_time&dot.unstable_affliction_4.remains<cast_time&dot.unstable_affliction_5.remains<cast_time
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if buff.deadwindHarvester.remain() >= debuff.unstableAffliction.duration(nil,thisUnit) + cast.time.unstableAffliction()
                        and debuff.unstableAffliction.remain(1,thisUnit) < cast.time.unstableAffliction() and debuff.unstableAffliction.remain(2,thisUnit) < cast.time.unstableAffliction()
                        and debuff.unstableAffliction.remain(3,thisUnit) < cast.time.unstableAffliction() and debuff.unstableAffliction.remain(4,thisUnit) < cast.time.unstableAffliction()
                        and debuff.unstableAffliction.remain(5,thisUnit) < cast.time.unstableAffliction()
                        and isValidUnit(thisUnit)
                    then
                        if cast.unstableAffliction(thisUnit) then return end
                    end
                end
                -- unstable_affliction,if=buff.deadwind_harvester.remains>tick_time*2&(!talent.contagion.enabled|soul_shard>1|buff.soul_harvest.remains)&(dot.unstable_affliction_1.ticking+dot.unstable_affliction_2.ticking+dot.unstable_affliction_3.ticking+dot.unstable_affliction_4.ticking+dot.unstable_affliction_5.ticking<5)
                if buff.deadwindHarvester.remain() > 2 * 2 and (not talent.contagion or shards > 1 or buff.soulHarvest.remain()) and debuff.unstableAffliction.stack(units.dyn40) < 5 then
                    if cast.unstableAffliction() then return end
                end
            -- Reap Souls
                if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and mode.multidot == 1 and buff.tormentedSouls.stack() > 0 then
                    -- reap_souls,if=!buff.deadwind_harvester.remains&buff.active_uas.stack>1
                    if not buff.deadwindHarvester.exists() and debuff.unstableAffliction.stack(units.dyn40) > 1 then
                        if cast.reapSouls() then return end
                    end
                    -- reap_souls,if=!buff.deadwind_harvester.remains&prev_gcd.1.unstable_affliction&buff.tormented_souls.react>1
                    if not buff.deadwindHarvester.exists() and cast.last.unstableAffliction() and buff.tormentedSouls.stack() > 1 then
                        if cast.reapSouls() then return end
                    end
                end
            -- Life Tap
                -- life_tap,if=talent.empowered_life_tap.enabled&buff.empowered_life_tap.remains<duration*0.3&(!buff.deadwind_harvester.remains|buff.active_uas.stack<1)
                if talent.empoweredLifeTap and buff.empoweredLifeTap.refresh() and (not buff.deadwindHarvester.exists() or debuff.unstableAffliction.stack(units.dyn40) < 1) then
                    if cast.lifeTap() then return end
                end
            -- Agony
                -- agony,if=refreshable&time_to_die>=remains
                if debuff.agony.refresh(units.dyn40) and (ttd(units.dyn40) >= debuff.agony.remain(units.dyn40) or isDummy(units.dyn40)) then
                    if cast.agony() then return end
                end
            -- Siphon Life
                -- siphon_life,if=refreshable&time_to_die>=remains
                if debuff.siphonLife.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(units.dyn40) > dotHPLimit then
                    if debuff.siphonLife.refresh(units.dyn40) and (ttd(units.dyn40) >= debuff.siphonLife.remain(units.dyn40) or isDummy(units.dyn40)) then
                        if cast.siphonLife() then return end
                    end
                end
            -- Corruption
                -- corruption,if=refreshable&time_to_die>=remains
                if debuff.corruption.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(units.dyn40) > dotHPLimit then
                    if debuff.corruption.refresh(units.dyn40) and (ttd(units.dyn40) >= debuff.corruption.remain(units.dyn40) or isDummy(units.dyn40)) then
                        if cast.corruption() then return end
                    end
                end
            -- Agony
                -- agony,cycle_targets=1,target_if=sim.target!=target&time_to_die>tick_time*3&!buff.deadwind_harvester.remains&refreshable&time_to_die>tick_time*3
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.agony.count() < getOptionValue("Multi-Dot Limit") + effigyCount and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and isValidUnit(thisUnit) then
                        if (ttd(thisUnit) > agonyTick * 3 or isDummy(thisUnit)) and not buff.deadwindHarvester.exists() and debuff.agony.refresh(thisUnit)
                            and (ttd(thisUnit) > agonyTick * 3 or isDummy(thisUnit))
                        then
                            if cast.agony(thisUnit) then return end
                        end
                    end
                end
            -- Siphon Life
                -- siphon_life,cycle_targets=1,target_if=sim.target!=target&time_to_die>tick_time*3&!buff.deadwind_harvester.remains&refreshable&time_to_die>tick_time*3
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.siphonLife.count() < getOptionValue("Multi-Dot Limit") + effigyCount and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and isValidUnit(thisUnit) then
                        if (ttd(thisUnit) > siphonTick * 3 or isDummy(thisUnit)) and not buff.deadwindHarvester.exists() and debuff.siphonLife.refresh(thisUnit)
                            and (ttd(thisUnit) > siphonTick * 3 or isDummy(thisUnit))
                        then
                            if cast.siphonLife(thisUnit) then return end
                        end
                    end
                end
            -- Corruption
                -- corruption,cycle_targets=1,target_if=sim.target!=target&time_to_die>tick_time*3&!buff.deadwind_harvester.remains&refreshable&time_to_die>tick_time*3
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.corruption.count() < getOptionValue("Multi-Dot Limit") + effigyCount and (getHP(thisUnit) > dotHPLimit or isDummy(thisUnit)) and isValidUnit(thisUnit) then
                        if (ttd(thisUnit) > corruptionTick * 3 or isDummy(thisUnit)) and not buff.deadwindHarvester.exists() and debuff.corruption.refresh(thisUnit)
                            and (ttd(thisUnit) > corruptionTick * 3 or isDummy(thisUnit))
                        then
                            if cast.corruption(thisUnit) then return end
                        end
                    end
                end
            -- Life Tap
                -- life_tap,if=mana.pct<=10
                if manaPercent <= 10 and php > getOptionValue("Life Tap HP Limit") then
                    if cast.lifeTap() then return end
                end
                -- life_tap,if=prev_gcd.1.life_tap&buff.active_uas.stack=0&mana.pct<50
                if cast.last.lifeTap() and debuff.unstableAffliction.stack(units.dyn40) == 0 and manaPercent < 50 and php > getOptionValue("Life Tap HP Limit") then
                    if cast.lifeTap() then return end
                end
            -- Drain Soul
                -- drain_soul,chain=1,interrupt=1
                if not cast.current.drainSoul() and mode.multidot == 1 and not moving then
                    if cast.drainSoul("target") then return end
                end
            end
            if moving then
        -- Life Tap
                -- life_tap,moving=1,if=mana.pct<80
                if manaPercent < 80 and php > getOptionValue("Life Tap HP Limit") then
                    if cast.lifeTap() then return end
                end
        -- Agony
                -- agony,moving=1,cycle_targets=1,if=remains<=duration-(3*tick_time)
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.agony.remain(thisUnit) <= debuff.agony.duration(thisUnit) - (3 * agonyTick) and isValidUnit(thisUnit) then
                        if cast.agony(thisUnit) then return end
                    end
                end
        -- Siphon Life
                -- siphon_life,moving=1,cycle_targets=1,if=remains<=duration-(3*tick_time)
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.siphonLife.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(units.dyn40) > dotHPLimit and isValidUnit(thisUnit) then
                        if debuff.siphonLife.remain(thisUnit) <= debuff.siphonLife.duration(thisUnit) - (3 * siphonTick) then
                            if cast.siphonLife(thisUnit) then return end
                        end
                    end
                end
        -- Corruption
                -- corruption,moving=1,cycle_targets=1,if=remains<=duration-(3*tick_time)
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.corruption.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(units.dyn40) > dotHPLimit and isValidUnit(thisUnit) then
                        if debuff.corruption.remain(thisUnit) <= debuff.corruption.duration(thisUnit) - (3 * corruptionTick) then
                            if cast.corruption(thisUnit) then return end
                        end
                    end
                end
            end
        -- Life Tap
            -- life_tap,moving=0
            if not moving and manaPercent < 90 and php > getOptionValue("Life Tap HP Limit") and not cast.current.drainSoul() then
                if cast.lifeTap() then return end
            end
        end -- End Action List - Writhe In Agony
    -- Action List - Low Level
        local function actionList_LowLevel()
            -- Shadow Bolt (Level 1)
            -- Corruption (Levevl 3)
            -- Life Tap (Level 8)
            -- Agony (Level 10)
            -- Drain Soul (Level 13)
            -- Unstable Affliction (Level 14)
        end -- End Action List - Low level
    -- Action List - Opener
        local function actionList_Opener()
            -- Start Attack
            -- auto_attack
            if isChecked("Opener") and isBoss("target") and opener == false then
                if isValidUnit("target") and getDistance("target") < 40 and not isUnitCasting("player") then
                    if not OPN1 then
                        Print("Starting Opener")
                        openerCount = openerCount + 1
                        OPN1 = true
                    elseif OPN1 and not AGN1 then
            -- Agony
                        if castOpener("agony","AGN1",openerCount) then openerCount = openerCount + 1; return end
                    elseif AGN1 and not COR1 then
            -- Corruption
                        if castOpener("corruption","COR1",openerCount) then openerCount = openerCount + 1; return end
                    elseif COR1 and not SIL1 then
            -- Siphon Life
                        if talent.siphonLife then
                            if castOpener("siphonLife","SIL1",openerCount) then openerCount = openerCount + 1; return end
                        else
                            Print(openerCount..": Siphon Life (Uncastable)")
                            openerCount = openerCount + 1
                            SIL1 = true
                        end
                    elseif SIL1 and not PHS1 then
            -- Phantom Singularity
                        if talent.phantomSingularity then
                            if castOpener("phantomSingularity","PHS1",openerCount) then openerCount = openerCount + 1; return end
                        else
                            Print(openerCount..": Phantom Singularity (Uncastable)")
                            openerCount = openerCount + 1
                            PHS1 = true
                        end
                    elseif PHS1 and not UAF1 then
            -- Unstable Affliction
                        if castOpener("unstableAffliction","UAF1",openerCount) then openerCount = openerCount + 1; return end
                    elseif UAF1 and not UAF2 then
            -- Unstable Affliction
                        if castOpener("unstableAffliction","UAF2",openerCount) then openerCount = openerCount + 1; return end
                    elseif UAF2 and not RES1 then
            -- Reap Souls
                        if artifact.reapSouls.enabled() then
                            if castOpener("reapSouls","RES1",openerCount) then openerCount = openerCount + 1; return end
                        else
                            Print(openerCount..": Reap Souls (Uncastable)")
                            openerCount = openerCount + 1
                            RES1 = true
                        end
                    elseif RES1 and not UAF3 then
            -- Unstable Affliction
                        if castOpener("unstableAffliction","UAF3",openerCount) then openerCount = openerCount + 1; return end
                    elseif UAF3 and not SOH1 then
            -- Soul Harvest
                        if talent.soulHarvest then
                            -- if castOpener("soulHarvest","SOH1",openerCount) then openerCount = openerCount + 1; return end
                            if cast.soulHarvest() then Print(openerCount..": Soul Harvest"); SOH1 = true; openerCount = openerCount + 1; return end
                        else
                            Print(openerCount..": Soul Harvest (Uncastable)")
                            openerCount = openerCount + 1;
                            SOH1 = true
                        end
                    elseif SOH1 and not DRN1 then
            -- Drain Soul
                        if castOpener("drainSoul","DRN1",openerCount) then openerCount = openerCount + 1; return end
                    elseif DRN1 then
                        Print("Opener Complete")
                        openerCount = 0
                        opener = true
                        return
                    end
                end
            elseif (UnitExists("target") and not isBoss("target")) or not isChecked("Opener") then
                opener = true
            end
        end
    -- Action List - PreCombat
        local function actionList_PreCombat()
        -- Summon Pet
            -- summon_pet,if=!talent.grimoire_of_supremacy.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.demonic_power.down)
            if isChecked("Pet Management") and not (IsFlying() or IsMounted()) and (not talent.grimoireOfSacrifice or not buff.demonicPower.exists()) and level >= 5 and br.timer:useTimer("summonPet", cast.time.summonVoidwalker() + gcd) then
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
                    if summonPet == 6 and (lastSpell ~= spell.summonDoomguard or activePetId == 0) then
                        if talent.grimoireOfSupremacy then
                            if cast.summonDoomguard("player") then castSummonId = spell.summonDoomguard; return end
                        end
                    end
                    if summonPet == 7 and (lastSpell ~= spell.summonInfernal or activePetId == 0) then
                        if talent.grimoireOfSupremacy then
                            if cast.summonInfernal("player") then castSummonId = spell.summonInfernal; return end
                        end
                    end
                    if summonPet == 8 then return end
                end
            end
            if not inCombat and not (IsFlying() or IsMounted()) then
            -- Flask
                -- flask,type=whispered_pact
            -- Food
                -- food,type=azshari_salad
                if (not isChecked("Opener") or opener == true) then
                -- Augmentation
                    -- augmentation,type=defiled
                -- Grimoire of Sacrifice
                    -- grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
                    if talent.grimoireOfSacrifice and GetObjectExists("pet") and not UnitIsDeadOrGhost("pet") then
                        if cast.grimoireOfSacrifice() then return end
                    end
                    if useCDs() and isChecked("Pre-Pull Timer") then --and pullTimer <= getOptionValue("Pre-Pull Timer") then
                        if pullTimer <= getOptionValue("Pre-Pull Timer") - 0.5 then
                            if canUse(142117) and not buff.prolongedPower.exists() then
                                useItem(142117);
                                return true
                            end
                        end
                        if pullTimer <= getOptionValue("Pre-Pull Timer") - 0.5 then
                            if talent.soulEffigy and not effigied then
                                if not GetObjectExists("target") then
                                    TargetUnit(units.dyn40)
                                end
                                if GetObjectExists("target") then
                                    if cast.soulEffigy("target") then return end
                                end
                            end
                        end
                    end -- End Pre-Pull
                    if isValidUnit("target") and getDistance("target") < 40 and (not isChecked("Opener") or opener == true) then
                -- Life Tap
                        -- life_tap,if=talent.empowered_life_tap.enabled&!buff.empowered_life_tap.remains
                        if talent.empoweredLifeTap and not buff.empoweredLifeTap.exists() then
                            if cast.lifeTap() then return end
                        end
                -- Potion
                        -- potion,name=prolonged_power
                -- Pet Attack/Follow
                        if isChecked("Pet Management") and GetUnitExists("target") and not UnitAffectingCombat("pet") then
                            PetAssistMode()
                            PetAttack("target")
                        end
                -- Opening Ability
                        if cast.agony("target","aoe") then return end
                        if level < 10 then
                            if cast.shadowBolt() then return end
                        end
                    end
                end
            end -- End No Combat
            if actionList_Opener() then return end
        end -- End Action List - PreCombat
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or IsMounted() or IsFlying() or (pause() and not cast.current.drainSoul()) or mode.rotation==4 then
            if not pause() and IsPetAttackActive() and isChecked("Pet Management") then
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
-----------------------
--- Opener Rotation ---
-----------------------
            if opener == false and isChecked("Opener") and isBoss("target") then
                if actionList_Opener() then return end
            end
---------------------------
--- Pre-Combat Rotation ---
---------------------------
			if actionList_PreCombat() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
            if inCombat and profileStop==false and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40
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
                    if isChecked("Pet Management") and UnitIsUnit("target",units.dyn40) and not UnitIsUnit("pettarget",units.dyn40) then
                        PetAttack()
                    end
        -- Call Action List - MG
                    -- call_action_list,name=mg,if=talent.malefic_grasp.enabled
                    if talent.maleficGrasp then
                        if actionList_MG() then return end
                    end
        -- Call Action List - Writhe In Agony
                    -- call_action_list,name=writhe,if=talent.writhe_in_agony.enabled
                    if talent.writheInAgony then
                        if actionList_Writhe() then return end
                    end
		-- Call Action List - Haunt
                    -- call_action_list,name=haunt,if=talent.haunt.enabled
                    if talent.haunt or (not talent.maleficGrasp and not talent.writheInAgony) then
                        if actionList_Haunt() then return end
                    end
        -- Call Action List - Low level
                    if not talent.haunt and not talent.maleficGrasp and not talent.writheInAgony then
                        if actionList_LowLevel() then return end
                    end
                end -- End SimC APL
			end --End In Combat
		end --End Rotation Logic
    end -- End Timer
-- end -- End runRotation
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

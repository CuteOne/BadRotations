local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.agony},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.corruption},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.drainLife},
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
        [1] = { mode = "Off", value = 1 , overlay = "Multi-Dot Only Disabled", tip = "Will use UA, Drain, and Reap.", highlight = 1, icon = br.player.spell.unstableAffliction},
        [2] = { mode = "Only", value = 2 , overlay = "Multi-Dot Only Enabled", tip = "Does not use UA, Drain, and Reap.", highlight = 0, icon = br.player.spell.corruption}
    };
    CreateButton("MultiDot",5,0)
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
            br.ui:createSpinner(section, "Pre-Pull Timer",  2,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Opener
            br.ui:createCheckbox(section,"Opener")
        -- Pet Management
            br.ui:createCheckbox(section, "Pet Management", "|cffFFFFFF Select to enable/disable auto pet management")
        -- Summon Pet
            br.ui:createDropdownWithout(section, "Summon Pet", {"Imp","Voidwalker","Felhunter","Succubus","Felguard", "Doomguard", "Infernal", "None"}, 1, "|cffFFFFFFSelect default pet to summon.")
        -- Grimoire of Service
            br.ui:createDropdownWithout(section, "Grimoire of Service", {"Imp","Voidwalker","Felhunter","Succubus","Felguard","None"}, 1, "|cffFFFFFFSelect pet to Grimoire.")
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
        -- Couterspell
            br.ui:createCheckbox(section, "Counterspell")
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
    if br.timer:useTimer("debugAffliction", math.random(0.15,0.3)) then
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
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = enemies or {}
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local grimoirePet                                   = getOptionValue("Grimoire of Service")
        local hasMouse                                      = ObjectExists("mouseover")
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
        local manaPercent                                   = br.player.power.mana.percent
        local mode                                          = br.player.mode
        local moveIn                                        = 999
        local moving                                        = isMoving("player")
        local perk                                          = br.player.perk
        local petInfo                                       = br.player.petInfo
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powmax, powgen, powerDeficit           = br.player.power.amount.mana, br.player.power.mana.max, br.player.power.regen, br.player.power.mana.deficit
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local recharge                                      = br.player.recharge
        local shards                                        = br.player.power.amount.soulShards
        local summonPet                                     = getOptionValue("Summon Pet")
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local t19_4pc                                       = TierScan("T19") >= 4
        local travelTime                                    = getDistance("target")/16
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.ttm
        local units                                         = units or {}

        units.dyn40 = br.player.units(40)
        enemies.yards8t = br.player.enemies(8,br.player.units(8,true))
        enemies.yards10t = br.player.enemies(10,br.player.units(10,true))
        enemies.yards30 = br.player.enemies(30)
        enemies.yards40 = br.player.enemies(40)

        if t19_4pc then hasT19 = 1 else hasT19 = 0 end
		if leftCombat == nil then leftCombat = GetTime() end
	    if profileStop == nil or not inCombat then profileStop = false end
        if castSummonId == nil then castSummonId = 0 end
        if summonTime == nil then summonTime = 0 end
        if effigied == nil then effigied = false; effigyCount = 0 end
        if hasEquiped(144364) then reapAndSow = 1 else reapAndSow = 0 end
        if isBoss() then dotHPLimit = getOptionValue("Multi-Dot HP Limit")/10 else dotHPLimit = getOptionValue("Multi-Dot HP Limit") end

        -- if debuff.unstableAffliction1.exists(units.dyn40) then UA1 = 1; UA1remain = debuff.unstableAffliction1.remain(units.dyn40) else UA1 = 0; UA1remain = 0 end
        -- if debuff.unstableAffliction2.exists(units.dyn40) then UA2 = 1; UA2remain = debuff.unstableAffliction2.remain(units.dyn40) else UA2 = 0; UA2remain = 0 end
        -- if debuff.unstableAffliction3.exists(units.dyn40) then UA3 = 1; UA3remain = debuff.unstableAffliction3.remain(units.dyn40) else UA3 = 0; UA3remain = 0 end
        -- if debuff.unstableAffliction4.exists(units.dyn40) then UA4 = 1; UA4remain = debuff.unstableAffliction4.remain(units.dyn40) else UA4 = 0; UA4remain = 0 end
        -- if debuff.unstableAffliction5.exists(units.dyn40) then UA5 = 1; UA5remain = debuff.unstableAffliction5.remain(units.dyn40) else UA5 = 0; UA5remain = 0 end
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

        if sindoreiSpiteOffCD == nil then sindoreiSpiteOffCD = true end
        if buff.sindoreiSpite.exists() and sindoreiSpiteOffCD then
            sindoreiSpiteOffCD = false
            C_Timer.After(180, function()
                sindoreiSpiteOffCD = true
            end)
        end

        -- Opener Variables
        if not inCombat and not ObjectExists("target") then
            -- DE1 = false
            -- DSB1 = false
            -- DOOM = false
            -- SDG = false
            -- GRF = false
            -- DE2 = false
            -- DSB2 = false
            -- DGL = false
            -- DE3 = false
            -- DSB3 = false
            -- DSB4 = false
            -- DSB5 = false
            -- HVST = false
            -- DRS = false
            -- HOG = false
            -- DE5 = false
            -- TKC = false
            opener = false
        end

        -- Effigy Info
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if ObjectID(thisUnit) == 103679 then
                effigyUnit = thisUnit;
                effigied = true;
                effigyCount = 1;
                break
            end
            effigyUnit = "player";
            effigyCount = 0;
            effigied = false
        end
        if UnitExists(effigyUnit) and UnitIsUnit("target",effigyUnit) and not UnitIsUnit("target","player") then FocusUnit(effigyUnit); ClearTarget(); TargetUnit(units.dyn40); return end

        -- Pet Data
        if summonPet == 1 then summonId = 416 end
        if summonPet == 2 then summonId = 1860 end
        if summonPet == 3 then summonId = 417 end
        if summonPet == 4 then summonId = 1863 end
        if summonPet == 5 then summonId = 17252 end
        if summonPet == 6 then summonId = 78158 end
        if summonPet == 7 then summonId = 78217 end
        if cd.grimoireOfService == 0 or prevService == nil then prevService = "None" end

        local doomguard = false
        local infernal = false
        if br.player.petInfo ~= nil then
            for i = 1, #br.player.petInfo do
                local thisUnit = br.player.petInfo[i].id
                if thisUnit == 11859 then doomguard = true end
                if thisUnit == 89 then infernal = true end
            end
        end

        local lowestAgony = lowestAgony or "player"
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
        -- Agony - Drain Soul Break
        -- agony,cycle_targets=1,if=remains<=tick_time+gcd
        if mode.rotation ~= 4 and inCombat and not (IsMounted() or IsFlying()) then
            if debuff.agony.exists(lowestAgony) and debuff.agony.remain(lowestAgony) <= 3 + gcd then
                if cast.agony(lowestAgony,"aoe") then return end
            end
            if effigied and debuff.agony.remain(effigyUnit) < 4 + gcd then
                if cast.agony(effigyUnit,"aoe") then return end
            end
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
            --     if effigied and ObjectID(thisUnit) == 103679 then
            --         if debuff.agony.remain(thisUnit) < 4 + gcd then
            --             if cast.agony(thisUnit,"aoe") then return end
            --         end
            --     end
                if (debuff.agony.count() < getOptionValue("Multi-Dot Limit") + effigyCount or debuff.agony.exists(thisUnit)) and getHP(thisUnit) > dotHPLimit and debuff.agony.remain(thisUnit) <= 3 + gcd
                    and isValidUnit(thisUnit) and bossHPLimit(thisUnit,getOptionValue("Agony Boss HP Limit")) --(not inBossFight or (inBossFight and UnitHealthMax(thisUnit) > bossHPMax * (getOptionValue("Agony Boss HP Limit") / 100)))
                then
                    if cast.agony(thisUnit,"aoe") then return end
                end
            end
        end

        -- if UnitExists("target") then ChatOverlay(lowestAgony) end

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
                if isChecked("Health Funnel") and getHP("pet") <= getOptionValue("Health Funnel") and ObjectExists("pet") == true and not UnitIsDeadOrGhost("pet") then
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
                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Soul Harvest
                -- soul_harvest
                if isChecked("Soul Harvest") and getOptionValue("Soul Harvest") >= debuff.agony.count() then
                    if cast.soulHarvest() then return end
                end
        -- Potion
                -- potion,name=deadly_grace,if=buff.soul_harvest.remain()s|target.time_to_die<=45|trinket.proc.any.react
                -- TODO
            end -- End useCDs check
        end -- End Action List - Cooldowns
    -- Action List - PreCombat
        local function actionList_PreCombat()
            -- Summon Pet
            -- summon_pet,if=!talent.grimoire_of_supremacy.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.demonic_power.down)
            if isChecked("Pet Management") and not (IsFlying() or IsMounted()) and (not talent.grimoireOfSacrifice or not buff.demonicPower.exists()) and level >= 5 and br.timer:useTimer("summonPet", getCastTime(spell.summonVoidwalker) + gcd) then
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
                -- TODO
            -- Food
                -- food,type=azshari_salad
                -- TODO
                if (not isChecked("Opener") or opener == true) then
                -- Augmentation
                    -- augmentation,type=defiled
                    -- TODO
                -- Grimoire of Sacrifice
                    -- grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
                    if talent.grimoireOfSacrifice and ObjectExists("pet") and not UnitIsDeadOrGhost("pet") then
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
                                if not ObjectExists("target") then
                                    TargetUnit(units.dyn40)
                                end
                                if ObjectExists("target") then
                                    if cast.soulEffigy("target") then return end
                                end
                            end
                        end  
                    end -- End Pre-Pull
                    if isValidUnit("target") and getDistance("target") < 40 and (not isChecked("Opener") or opener == true) then
                -- Life Tap
                        -- life_tap,if=talent.empowered_life_tap.enabled&!buff.empowered_life_tap.remain()s
                        if talent.empoweredLifeTap and not buff.empoweredLifeTap.exists() then
                            if cast.lifeTap() then return end
                        end
                -- Potion
                        -- potion,name=prolonged_power
                        -- TODO
                -- Pet Attack/Follow
                        if isChecked("Pet Management") and UnitExists("target") and not UnitAffectingCombat("pet") then
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
        end -- End Action List - PreCombat
        local function actionList_Opener()
            if isBoss("target") and isValidUnit("target") and opener == false then
                if (isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer")) or not isChecked("Pre-Pull Timer") then
                        opener = true
                end
            end
        end
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or IsMounted() or IsFlying() or pause() or mode.rotation==4 then
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
        -- Reap Souls
                    -- reap_souls,if=!buff.deadwind_harvester.remains&(buff.soul_harvest.remains>5+equipped.144364*1.5&!talent.malefic_grasp.enabled&buff.active_uas.stack>1|buff.tormented_souls.react>=8|target.time_to_die<=buff.tormented_souls.react*5+equipped.144364*1.5|!talent.malefic_grasp.enabled&(trinket.proc.any.react|trinket.stacking_proc.any.react))
                    --if not buff.deadwindHarvester.exists() and (buff.soulHarvest.exists() or buff.tormentedSouls.stack() >= 8 or ttd(units.dyn40) <= buff.tormentedSouls.stack() * 5) then
                    if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and mode.multidot == 1
                        and (buff.tormentedSouls.stack() >= 8 or (hasEquiped(144364) and buff.tormentedSouls.stack() >= 6))
                        and debuff.unstableAffliction.stack() >= 3
                    then
                        if cast.reapSouls() then return end
                    end
        -- Agony
                    -- agony,cycle_targets=1,if=remains<=tick_time+gcd
                    if debuff.agony.exists(lowestAgony) and debuff.agony.remain(lowestAgony) <= 2 + gcd then
                        if cast.agony(lowestAgony,"aoe") then return end
                    end
        -- Soul Effigy
                    -- soul_effigy,if=!pet.soul_effigy.active
                    if not effigied then
                        if cast.soulEffigy("target") then return end
                    end
                    if effigied then
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if ObjectID(thisUnit) == 103679 then
                                -- Agony
                                if debuff.agony.remain(thisUnit) < 3 + gcd then
                                    if cast.agony(thisUnit,"aoe") then return end
                                end
                                -- Corruption
                                if debuff.corruption.remain(thisUnit) < 2 + gcd then
                                    if cast.corruption(thisUnit,"aoe") then return end
                                end
                                -- Siphon Life
                                if debuff.siphonLife.remain(thisUnit) < 2 + gcd then
                                    if cast.siphonLife(thisUnit,"aoe") then return end
                                end
                            end
                        end
                    end
        -- Agony
                    -- agony,cycle_targets=1,if=remains<=tick_time+gcd
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if (debuff.agony.count() < getOptionValue("Multi-Dot Limit") + effigyCount or debuff.agony.exists(thisUnit)) and getHP(thisUnit) > dotHPLimit and debuff.agony.remain(thisUnit) <= 3 + gcd
                            and isValidUnit(thisUnit) and bossHPLimit(thisUnit,getOptionValue("Agony Boss HP Limit")) --(not inBossFight or (inBossFight and UnitHealthMax(thisUnit) > bossHPMax * (getOptionValue("Agony Boss HP Limit") / 100)))
                        then
                            if cast.agony(thisUnit,"aoe") then return end
                        end
                    end
        -- Service Pet
                    -- service_pet,if=dot.corruption.remain()s&dot.agony.remain()s
                    if isChecked("Pet Management") and ObjectExists("target") then
                        if debuff.corruption.exists() and debuff.agony.exists() and br.timer:useTimer("summonPet", getCastTime(spell.summonVoidwalker)+gcd) then
                            if grimoirePet == 1 and lastSpell ~= spell.grimoireImp then
                                if cast.grimoireImp("target") then prevService = "Imp"; return end
                            end
                            if grimoirePet == 2 and lastSpell ~= spell.grimoireVoidwalker then
                                if cast.grimoireVoidwalker("target") then prevService = "Voidwalker"; return end
                            end
                            if grimoirePet == 3 and lastSpell ~= spell.grimoireFelhunter then
                                if cast.grimoireFelhunter("target") then prevService = "Felhunter"; return end
                            end
                            if grimoirePet == 4 and lastSpell ~= spell.summonSuccubus then
                                if cast.grimoireSuccubus("target") then prevService = "Succubus"; return end
                            end
                            if grimoirePet == 5 and lastSpell ~= spell.summonFelguard then
                                if cast.grimoireFelguard("target") then prevService = "Felguard"; return end
                            end
                            if summonPet == 6 and lastSpell ~= spell.summonDoomguard then
                               if talent.grimoireOfSupremacy and not hasEquiped(132379) then
                                    if cast.summonDoomguard("target") then castSummonId = spell.summonDoomguard; return end
                                end
                            end
                            if summonPet == 7 and lastSpell ~= spell.summonInfernal then
                                if talent.grimoireOfSupremacy and not hasEquiped(132379) then
                                    if cast.summonInfernal("target") then castSummonId = spell.summonInfernal; return end
                                end
                            end
                            if summonPet == 8 then return end
                        end
                    end
        -- Summon Doomguard
                    -- summon_doomguard,if=!talent.grimoire_of_supremacy.enabled&spell_targets.summon_infernal<=2&(target.time_to_die>180|target.health.pct<=20|target.time_to_die<30)
                    if isChecked("Pet Management") and useCDs() and isChecked("Summon Doomguard") and lastSpell ~= spell.summonDoomguard then
                        if not talent.grimoireOfSupremacy and #enemies.yards8t <= 2
                            and (ttd(units.dyn40) > 180 or getHP(units.dyn40) <= 20 or ttd(units.dyn40) < 30 or isDummy())
                        then
                            if cast.summonDoomguard() then summonTime = GetTime(); return end
                        end
                    end
        -- Summon Infernal
                    -- summon_infernal,if=!talent.grimoire_of_supremacy.enabled&spell_targets.summon_infernal>2
                    if isChecked("Pet Management") and useCDs() and isChecked("Summon Infernal") and lastSpell ~= spell.summonInfernal then
                        if not talent.grimoireOfSupremacy and #enemies.yards8t > 2 then
                            if cast.summonInfernal() then summonTime = GetTime(); return end
                        end
                    end
        -- Summon Doomguard
                    -- summon_doomguard,if=talent.grimoire_of_supremacy.enabled&spell_targets.summon_infernal=1&equipped.132379&!cooldown.sindorei_spite_icd.remain()s
                    if isChecked("Pet Management") and useCDs() and isChecked("Summon Doomguard") and lastSpell ~= spell.summonDoomguard then
                        if talent.grimoireOfSupremacy and #enemies.yards8t == 1 and hasEquiped(132379) and sindoreiSpiteOffCD and GetTime() > summonTime + 275 then

                            if cast.summonDoomguard() then summonTime = GetTime(); return end
                        end
                    end
        -- Summon Infernal
                    -- summon_infernal,if=talent.grimoire_of_supremacy.enabled&spell_targets.summon_infernal>1&equipped.132379&!cooldown.sindorei_spite_icd.remain()s
                    if isChecked("Pet Management") and useCDs() and isChecked("Summon Infernal") and lastSpell ~= spell.summonInfernal then
                        if talent.grimoireOfSupremacy and #enemies.yards8t > 1 and hasEquiped(132379) and sindoreiSpiteOffCD and GetTime() > summonTime + 275 then

                            if cast.summonInfernal() then summonTime = GetTime(); return end
                        end
                    end
        -- Cooldowns
                    if actionList_Cooldowns() then return end
        -- Corruption
                    -- corruption,if=remains<=tick_time+gcd&(spell_targets.seed_of_corruption<3&talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<4)
                    if debuff.corruption.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(units.dyn40) > dotHPLimit then
                        if debuff.corruption.remain(units.dyn40) <= 2 + gcd and ((#enemies.yards10t < 10 and talent.sowTheSeeds) or #enemies.yards10t < 4) then
                            if cast.corruption(units.dyn40,"aoe") then return end
                        end
                    end
                    -- corruption,cycle_targets=1,if=(talent.absolute_corruption.enabled|!talent.malefic_grasp.enabled|!talent.soul_effigy.enabled)&remains<=tick_time+gcd&(spell_targets.seed_of_corruption<3&talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<4)
                    if ((mode.rotation == 1 and #enemies.yards40 > 1) or mode.rotation == 2) then
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if debuff.corruption.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(thisUnit) > dotHPLimit and isValidUnit(thisUnit) then
                                if (talent.absoluteCorruption or not talent.maleficGrasp or not talent.soulEffigy) and debuff.corruption.remain(thisUnit) <= 3 + gcd
                                    and ((#enemies.yards10t < 10 and talent.sowTheSeeds) or #enemies.yards10t < 4)
                                then
                                    if cast.corruption(thisUnit,"aoe") then return end
                                end
                            end
                        end
                    end
        -- Siphon Life
                    -- siphon_life,if=remains<=tick_time+gcd
                    -- siphon_life,if=remains<=tick_time+gcd&(dot.unstable_affliction_1.ticking+dot.unstable_affliction_2.ticking+dot.unstable_affliction_3.ticking+dot.unstable_affliction_4.ticking+dot.unstable_affliction_5.ticking)<2
                    if debuff.siphonLife.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(units.dyn40) > dotHPLimit then
                        if debuff.siphonLife.remain(units.dyn40) <= 2 + gcd and debuff.unstableAffliction.stack() < 2 then --(UA1 + UA2 + UA3 + UA4 + UA5) < 2 then
                            if cast.siphonLife(units.dyn40,"aoe") then return end
                        end
                    end
                    -- siphon_life,cycle_targets=1,if=(!talent.malefic_grasp.enabled||!talent.soul_effigy.enabled)&remains<=tick_time+gcd
                    if ((mode.rotation == 1 and #enemies.yards40 > 1) or mode.rotation == 2) then
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if debuff.siphonLife.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(thisUnit) > dotHPLimit and isValidUnit(thisUnit) then
                                if (not talent.maleficGrasp or not talent.soulEffigy) and debuff.siphonLife.remain(thisUnit) <= 2 + gcd then
                                    if cast.siphonLife(thisUnit,"aoe") then return end
                                end
                            end
                        end
                    end
        -- Life Tap
                    -- life_tap,if=talent.empowered_life_tap.enabled&buff.empowered_life_tap.remain()s<=gcd
                    if talent.empoweredLifeTap and buff.empoweredLifeTap.remain() <= gcd then
                        if cast.lifeTap() then return end
                    end
        -- Phantom Singularity
                    -- phantom_singularity
                    if castable.phantomSingularity then
                        if cast.phantomSingularity() then return end
                    end
        -- Haunt
                    -- haunt
                    if castable.haunt then
                        if cast.haunt() then return end
                    end
        -- Agony
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        -- local ua1 = debuff.unstableAffliction1
                        -- local ua2 = debuff.unstableAffliction2
                        -- local ua3 = debuff.unstableAffliction3
                        -- local ua4 = debuff.unstableAffliction4
                        -- local ua5 = debuff.unstableAffliction5
                        -- if ua1 ~= nil and ua1.exists(thisUnit) then ua1count = 1 else ua1count = 0 end
                        -- if ua2 ~= nil and ua2.exists(thisUnit) then ua2count = 1 else ua2count = 0 end
                        -- if ua3 ~= nil and ua3.exists(thisUnit) then ua3count = 1 else ua3count = 0 end
                        -- if ua4 ~= nil and ua4.exists(thisUnit) then ua4count = 1 else ua4count = 0 end
                        -- if ua5 ~= nil and ua5.exists(thisUnit) then ua5count = 1 else ua5count = 0 end
                        if debuff.agony.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(thisUnit) > dotHPLimit and isValidUnit(thisUnit)
                            and bossHPLimit(thisUnit,getOptionValue("Agony Boss HP Limit")) --(not inBossFight or (inBossFight and UnitHealthMax(thisUnit) > bossHPMax * (getOptionValue("Agony Boss HP Limit") / 100)))
                        then
                            -- agony,cycle_targets=1,if=!talent.malefic_grasp.enabled&remains<=duration*0.3&target.time_to_die>=remains
                            if not talent.maleficGrasp and debuff.agony.refresh(thisUnit) and ttd(thisUnit) >= debuff.agony.remain(thisUnit) then
                                if cast.agony(thisUnit,"aoe") then return end
                            end
                            -- agony,cycle_targets=1,if=remains<=duration*0.3&target.time_to_die>=remains&(dot.unstable_affliction_1.ticking+dot.unstable_affliction_2.ticking+dot.unstable_affliction_3.ticking+dot.unstable_affliction_4.ticking+dot.unstable_affliction_5.ticking)=0
                            if debuff.agony.refresh() and ttd(thisUnit) >= debuff.agony.remain() and debuff.unstableAffliction.stack() == 0 then --(ua1count + ua2count + ua3count + ua4count + ua5count) == 0 then
                                if cast.agony(thisUnit,"aoe") then return end
                            end
                        end
                    end
        -- Life Tap
                    -- life_tap,if=talent.empowered_life_tap.enabled&buff.empowered_life_tap.remain()s<duration*0.3|talent.malefic_grasp.enabled&target.time_to_die>15&mana.pct<10
                    if talent.empoweredLifeTap and buff.empoweredLifeTap.refresh() or (talent.maleficGrasp and ttd(units.dyn40) > 15 and manaPercent < 10) then
                        if cast.lifeTap() then return end
                    end
        -- Seed of Corruption
                    -- seed_of_corruption,if=talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption>=3|spell_targets.seed_of_corruption>=4|spell_targets.seed_of_corruption=3&dot.corruption.remain()s<=cast_time+travel_time
                    -- if (talent.sowTheSeeds and #enemies.yards10t >= 3) or #enemies.yards10t >= 4
                    --     or (#enemies.yards10t == 3 and debuff.corruption[units.dyn40] ~= nil and debuff.corruption[units.dyn40].remain() <= getCastTime(spell.seedOfCorruption))
                    -- then
                    if (mode.rotation == 1 and #enemies.yards10t >= getOptionValue("Seed Units")) or mode.rotation == 2 then
                        if cast.seedOfCorruption() then return end
                    end
        -- Corruption
                    if debuff.corruption.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(units.dyn40) > dotHPLimit then
                        -- corruption,if=!talent.malefic_grasp.enabled&remains<=duration*0.3&target.time_to_die>=remains
                        if not talent.maleficGrasp and debuff.corruption.refresh(units.dyn40) and ttd(units.dyn40) >= debuff.corruption.remain(units.dyn40) then
                            if cast.corruption(units.dyn40,"aoe") then return end
                        end
                        -- corruption,if=remains<=duration*0.3&target.time_to_die>=remains&(dot.unstable_affliction_1.ticking+dot.unstable_affliction_2.ticking+dot.unstable_affliction_3.ticking+dot.unstable_affliction_4.ticking+dot.unstable_affliction_5.ticking)=0
                        if debuff.corruption.refresh(units.dyn40) and debuff.unstableAffliction.stack() == 0 then --(UA1 + UA2 + UA3 + UA4 + UA5) == 0 then
                            if cast.corruption(units.dyn40,"aoe") then return end
                        end
                    end
                    -- corruption,cycle_targets=1,if=(talent.absolute_corruption.enabled|!talent.malefic_grasp.enabled|!talent.soul_effigy.enabled)&remains<=duration*0.3&target.time_to_die>=remains
                    if ((mode.rotation == 1 and #enemies.yards40 > 1) or mode.rotation == 2) then
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if debuff.corruption.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(thisUnit) > dotHPLimit and isValidUnit(thisUnit) then
                                if (talent.absoluteCorruption or not talent.maleficGrasp or not talent.soulEffigy) and debuff.corruption.refresh(thisUnit) and ttd(thisUnit) >= debuff.corruption.remain(thisUnit) then
                                    if cast.corruption(thisUnit,"aoe") then return end
                                end
                            end
                        end
                    end
        -- Siphon Life
                    if debuff.siphonLife.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(units.dyn40) > dotHPLimit then
                        -- siphon_life,if=!talent.malefic_grasp.enabled&remains<=duration*0.3&target.time_to_die>=remains
                        if not talent.maleficGrasp and debuff.siphonLife.refresh(units.dyn40) and ttd(units.dyn40) >= debuff.siphonLife.remain(units.dyn40) then
                            if cast.siphonLife(units.dyn40,"aoe") then return end
                        end
                    end
                    -- siphon_life,cycle_targets=1,if=(!talent.malefic_grasp.enabled|!talent.soul_effigy.enabled)&remains<=duration*0.3&target.time_to_die>=remains
                    if ((mode.rotation == 1 and #enemies.yards40 > 1) or mode.rotation == 2) then
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if debuff.siphonLife.count() < getOptionValue("Multi-Dot Limit") + effigyCount and getHP(thisUnit) > dotHPLimit and isValidUnit(thisUnit) then
                                if isValidUnit(thisUnit) and (not talent.maleficGrasp or not talent.soulEffigy) and debuff.siphonLife.refresh(thisUnit) and ttd(thisUnit) >= debuff.siphonLife.remain(thisUnit) then
                                    if cast.siphonLife(thisUnit,"aoe") then return end
                                end
                            end
                        end
                    end
        -- Unsable Affliction
                    if ((mode.rotation == 1 and #enemies.yards10t < getOptionValue("Seed Units")) or mode.rotation == 3) and mode.multidot == 1 
                        and (debuff.unstableAffliction.stack() == 0 or (debuff.unstableAffliction.stack() >= 1 and br.timer:useTimer("unstableRecast", getCastTime(spell.unstableAffliction) + gcd)))
                    then
                        -- unstable_affliction,if=(!talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<3)&spell_targets.seed_of_corruption<4&talent.writhe_in_agony.enabled&talent.contagion.enabled&dot.unstable_affliction_1.remain()s<cast_time&dot.unstable_affliction_2.remain()s<cast_time&dot.unstable_affliction_3.remain()s<cast_time&dot.unstable_affliction_4.remain()s<cast_time&dot.unstable_affliction_5.remain()s<cast_time
                        if talent.writheInAgony and talent.contagion and debuff.unstableAffliction.remain(1) < getCastTime(spell.unstableAffliction) then --UA1remain < getCastTime(spell.unstableAffliction) then
                            if cast.unstableAffliction(units.dyn40,"aoe") then return end
                        end
                        -- unstable_affliction,if=(!talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<3)&spell_targets.seed_of_corruption<4&talent.writhe_in_agony.enabled&(soul_shard>=4|trinket.proc.intellect.react|trinket.stack()ing_proc.mastery.react|trinket.proc.mastery.react|trinket.proc.crit.react|trinket.proc.versatility.react|buff.soul_harvest.remain()s|buff.deadwind_harvester.remain()s|buff.compounding_horror.react=5|target.time_to_die<=20)
                        if talent.writheInAgony and (shards >= 4 - hasT19 or buff.soulHarvest.exists() or buff.deadwindHarvester.exists() or buff.compoundingHorror.stack() == 5
                            or (ttd(units.dyn40) <= 20 and debuff.unstableAffliction.stack() < 1))
                        then
                            if cast.unstableAffliction(units.dyn40,"aoe") then return end
                        end
                        -- unstable_affliction,if=(!talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<3)&spell_targets.seed_of_corruption<4&talent.malefic_grasp.enabled&target.time_to_die<30
                        if talent.maleficGrasp and (ttd(units.dyn40) < 30 and debuff.unstableAffliction.stack() <= 2) then
                            if cast.unstableAffliction(units.dyn40,"aoe") then return end
                        end
                        -- unstable_affliction,if=(!talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<3)&spell_targets.seed_of_corruption<4&talent.malefic_grasp.enabled&(soul_shard=5|talent.contagion.enabled&soul_shard>=4)
                        if talent.maleficGrasp and (shards > 4 - hasT19 or (talent.contagion and shards > 4 - hasT19)) then
                            if cast.unstableAffliction(units.dyn40,"aoe") then return end
                        end
                        -- unstable_affliction,if=(!talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<3)&spell_targets.seed_of_corruption<4&talent.malefic_grasp.enabled&!prev_gcd.3.unstable_affliction&dot.agony.remain()s>cast_time*3+6.5&(!talent.soul_effigy.enabled|pet.soul_effigy.dot.agony.remain()s>cast_time*3+6.5)&(dot.corruption.remain()s>cast_time+6.5|talent.absolute_corruption.enabled)&(dot.siphon_life.remain()s>cast_time+6.5|!talent.siphon_life.enabled)
                        if talent.maleficGrasp and debuff.unstableAffliction.stack() < 3 --(lastSpell ~= spell.unstableAffliction and not UA3)
                            and debuff.agony.remain(units.dyn40) > getCastTime(spell.unstableAffliction) * 2 + 6.5
                            and (not talent.soulEffigy or debuff.agony.remain("Soul Effigy") > getCastTime(spell.unstableAffliction) * 3 + 6.5)
                            -- and (debuff.corruption.remain(units.dyn40) > getCastTime(spell.unstableAffliction) + 3 or talent.absoluteCorruption)
                            -- and (debuff.siphonLife.remain(units.dyn40) > getCastTime(spell.unstableAffliction) + 3 or not talent.siphonLife)
                        then
                            if cast.unstableAffliction(units.dyn40,"aoe") then return end
                        end
						-- With Reap
						 if talent.maleficGrasp and buff.deadwindHarvester.exists and debuff.unstableAffliction.stack() < 4 
                            and debuff.agony.remain(units.dyn40) > getCastTime(spell.unstableAffliction) * 2 + 6.5
                            and (not talent.soulEffigy or debuff.agony.remain("Soul Effigy") > getCastTime(spell.unstableAffliction) * 3 + 6.5)
                            -- and (debuff.corruption.remain(units.dyn40) > getCastTime(spell.unstableAffliction) + 3 or talent.absoluteCorruption)
                            -- and (debuff.siphonLife.remain(units.dyn40) > getCastTime(spell.unstableAffliction) + 3 or not talent.siphonLife)
                        then
                            if cast.unstableAffliction(units.dyn40,"aoe") then return end
                        end
                        -- unstable_affliction,if=(!talent.sow_the_seeds.enabled|spell_targets.seed_of_corruption<3)&talent.haunt.enabled&(soul_shard>=4|debuff.haunt.remain()s>6.5|target.time_to_die<30)
                        if talent.haunt
                            and (shards >= 4 - hasT19 or (debuff.haunt.exists(units.dyn40)) or (ttd(units.dyn40) < 30 and debuff.unstableAffliction.stack() < 1))
                        then
                            if cast.unstableAffliction(units.dyn40,"aoe") then return end
                        end
                        -- reap soul UA loadup
                        if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()))
                            and (buff.tormentedSouls.stack() >= 8 or (hasEquiped(144364) and buff.tormentedSouls.stack() >= 6))
                            and debuff.unstableAffliction.stack() < 1
                        then
                            if cast.unstableAffliction(units.dyn40,"aoe") then return end
                        end
                        -- legendary UA multi-dot
                        if hasEquiped(132381) and debuff.unstableAffliction1.count() < 2 and ((mode.rotation == 1 and #enemies.yards40 > 2) or mode.rotation == 2) then
                            for i = 1, #enemies.yards40 do
                                local thisUnit = enemies.yards40[i]
                                if not UnitIsUnit(thisUnit,effigyUnit) and debuff.unstableAffliction.stack(thisUnit) < 1 then
                                    if cast.unstableAffliction(thisUnit,"aoe") then return end
                                end
                            end
                        end
                    end
        -- Reap Soul
                    -- reap_souls,if=!buff.deadwind_harvester.remain()s&(dot.unstable_affliction_1.ticking+dot.unstable_affliction_2.ticking+dot.unstable_affliction_3.ticking+dot.unstable_affliction_4.ticking+dot.unstable_affliction_5.ticking)>1&((!trinket.has_stacking_stat.any&!trinket.has_stat.any)|talent.malefic_grasp.enabled)
                    if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and mode.multidot == 1 then
                        if not buff.deadwindHarvester.exists() and debuff.unstableAffliction.stack() > 1 and talent.maleGrasp then
                            if cast.reapSouls() then return end
                        end
                    end
                    -- reap_souls,if=!buff.deadwind_harvester.remain()s&prev_gcd.1.unstable_affliction&((!trinket.has_stacking_stat.any&!trinket.has_stat.any)|talent.malefic_grasp.enabled)&buff.tormented_souls.react>1
                    -- if not buff.deadwindHarvester.exists() and (lastSpell == spell.unstableAffliction and UA1) and talent.maleGrasp and buff.tormentedSouls.stack() > 1 then
                    --     if cast.reapSouls() then return end
                    -- end
        -- Life Tap
                    -- life_tap,if=mana.pct<=10
                    if manaPercent <= 10 and php > getOptionValue("Life Tap HP Limit") then
                        if cast.lifeTap() then return end
                    end
        -- Drain Soul
                    -- drain_soul,chain=1,interrupt=1
                    if not isCastingSpell(spell.drainSoul,"player") and mode.multidot == 1 then
                        if not ObjectExists("target") then TargetUnit("target") end
                        if (not talent.maleGrasp and shards <= 2) or (talent.maleficGrasp and (not buff.deadwindHarvester.exists() and debuff.unstableAffliction.stack() >= 2 
                            or (buff.deadwindHarvester.exists() and debuff.unstableAffliction.stack() >= 3) 
                            or (shards <= 3))) 
                        then
                            if cast.drainSoul("target") then return end
                        end
                    end
        -- Life Tap
                    --life_tap
                    if manaPercent < 70 and php > getOptionValue("Life Tap HP Limit") then
                        if cast.lifeTap() then return end
                    end
        -- Shadow Bolt
                    if level < 13 then
                        if cast.shadowBolt() then return end
                    end
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
local id = 265
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

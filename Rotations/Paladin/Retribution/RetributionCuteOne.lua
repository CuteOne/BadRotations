local rotationName = "CuteOne"
---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.divineStorm },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.divineStorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.crusaderStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.flashOfLight }
    }
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.avengingWrath },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.avengingWrath },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.avengingWrath }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.flashOfLight },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.flashOfLight }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.hammerOfJustice },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.hammerOfJustice }
    };
    CreateButton("Interrupt",4,0)
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
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Opener
            br.ui:createCheckbox(section, "Opener")
            -- Greater Blessing of Might
            -- br.ui:createCheckbox(section, "Greater Blessing of Might
			-- Greater Blessing of Kings
			br.ui:createCheckbox(section, "Greater Blessing of Kings")
			-- Greater Blessing of Wisdom
			br.ui:createCheckbox(section, "Greater Blessing of Wisdom")
            -- Hand of Freedom
            br.ui:createCheckbox(section, "Hand of Freedom")
            -- Hand of Hindeance
            br.ui:createCheckbox(section, "Hand of Hinderance")
            -- Divine Storm Units
            br.ui:createSpinner(section, "Divine Storm Units",  2,  2,  3,  1,  "|cffFFBB00Units to use Divine Storm. Leave at 2 if you have Divine Tempest and Righteous Blade Artifact Traits. Set to 3 if you don't have these traits.")
            -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- Avenging Wrath
            br.ui:createCheckbox(section,"Avenging Wrath")
            -- Cruusade
            br.ui:createCheckbox(section,"Crusade")
            -- Holy Wrath
            br.ui:createCheckbox(section,"Holy Wrath")
            -- Shield of Vengeance
            br.ui:createCheckbox(section,"Shield of Vengeance - CD")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
			-- Engineering: Gunpowder Charge
            br.ui:createSpinner(section, "Gunpowder Charge",  30,  0,  200,  5,  "|cffFFFFFFEnemy TTD")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
            -- Blessing of Protection
            br.ui:createSpinner(section, "Blessing of Protection",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Blinding Light
            br.ui:createSpinner(section, "Blinding Light - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Blinding Light - AoE", 3, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
            -- Cleanse Toxin
            br.ui:createDropdown(section, "Clease Toxin", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|cffFFFFFFTarget to Cast On")
            -- Divine Shield
            br.ui:createSpinner(section, "Divine Shield",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Eye for an Eye
            br.ui:createSpinner(section, "Eye for an Eye", 50, 0 , 100, 5, "|cffFFBB00Health Percentage to use at.")
			-- Shield of Vengeance
            br.ui:createSpinner(section,"Shield of Vengeance", 90, 0 , 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Flash of Light
            br.ui:createSpinner(section, "Flash of Light",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Hammer of Justice
            br.ui:createSpinner(section, "Hammer of Justice - HP",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
			br.ui:createCheckbox(section, "Hammer of Justice - Legendary")
            -- Justicar's Vengeance
            br.ui:createSpinner(section, "Justicar's Vengeance",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Lay On Hands
            br.ui:createSpinner(section, "Lay On Hands", 20, 0, 100, 5, "","Health Percentage to use at")
            br.ui:createDropdownWithout(section, "Lay on Hands Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 8, "|cffFFFFFFTarget for Lay On Hands")
            -- Redemption
            br.ui:createDropdown(section, "Redemption", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|cffFFFFFFTarget to Cast On")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Blinding Light
            br.ui:createCheckbox(section, "Blinding Light")
            -- Hammer of Justice
            br.ui:createCheckbox(section, "Hammer of Justice")
            -- Rebuke
            br.ui:createCheckbox(section, "Rebuke")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugRetribution", math.random(0.15,0.3)) then -- Change debugSpec tp name of Spec IE: debugFeral or debugWindwalker
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
        local artifact      = br.player.artifact
        local buff          = br.player.buff
        local cast          = br.player.cast
        local cd            = br.player.cd
        local charges       = br.player.charges
        local combatTime    = getCombatTime()
        local debuff        = br.player.debuff
        local enemies       = enemies or {}
        local gcd           = br.player.gcd
        local hastar        = GetObjectExists("target")
        local healPot       = getHealthPot()
        local holyPower     = br.player.power.amount.holyPower
        local holyPowerMax  = br.player.power.holyPower.max
        local inCombat      = br.player.inCombat
        local level         = br.player.level
        local mode          = br.player.mode
        local php           = br.player.health
        local race          = br.player.race
        local racial        = br.player.getRacial()
        local resable       = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
        local solo          = GetNumGroupMembers() == 0
        local spell         = br.player.spell
        local t20_4pc       = TierScan("T20")
        local talent        = br.player.talent
        local thp           = getHP(br.player.units(5))
        local ttd           = getTTD(br.player.units(5))
        local units         = units or {}

        units.dyn5 = br.player.units(5)
        enemies.yards5 = br.player.enemies(5)
        enemies.yards8 = br.player.enemies(8)
        enemies.yards10 = br.player.enemies(10)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if opener == nil then opener = false end
        if t20_4pc then t20pc4 = 1 else t20pc4 = 0 end
        if talent.theFiresOfJustice then firesOfJustice = 1 else firesOfJustice = 0 end
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        end
        if not inCombat and not GetObjectExists("target") then
            opener = false
            OPN1 = false
            RAC1 = false
            JUD1 = false
            BOJ1 = false
            CRU1 = false
            EXE1 = false
            TMV1 = false
            WOA1 = false
            TMV2 = false
            ARC1 = false
            TMV3 = false
            CRS1 = false
            TMV4 = false
        end
        judgmentExists = debuff.judgment.exists(units.dyn5)
        judgmentRemain = debuff.judgment.remain(units.dyn5)
        if debuff.judgment.exists(units.dyn5) or level < 42 or (cd.judgment > 2 and not debuff.judgment.exists(units.dyn5)) then
            judgmentVar = true
        else
            judgmentVar = false
        end
        -- variable,name=ds_castable,value=spell_targets.divine_storm>=2|(buff.scarlet_inquisitors_expurgation.stack>=29&(buff.avenging_wrath.up|(buff.crusade.up&buff.crusade.stack>=15)|(cooldown.crusade.remains>15&!buff.crusade.up)|cooldown.avenging_wrath.remains>15))
        local dsCastable = (mode.rotation == 1 and (#enemies.yards8 >= getOptionValue("Divine Storm Units") or (buff.scarletInquisitorsExpurgation.stack() >= 29 and (buff.avengingWrath.exists() or (buff.crusade.exists() and buff.crusade.stack >= 15) or (cd.crusade > 15 and not buff.crusade.exists()) or cd.avengingWrath > 15)))) or mode.rotation == 2
        local greaterBuff
        greaterBuff = 0
        local lowestUnit
        lowestUnit = "player"
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            local thisHP = getHP(thisUnit)
            local lowestHP = getHP(lowestUnit)
            if thisHP < lowestHP then
                lowestUnit = thisUnit
            end
            -- if UnitBuffID(thisUnit,spell.buffs.greaterBlessingOfMight) ~= nil then
            --     greaterBuff = greaterBuff + 1
            -- end
        end

--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
        -- Hand of Freedom
            if isChecked("Hand of Freedom") and hasNoControl() then
                if cast.handOfFreedom() then return end
            end
        -- Hand of Hinderance
            if isChecked("Hand of Hinderance") and isMoving("target") and not getFacing("target","player") and getDistance("target") > 8 then
                if cast.handOfHinderance("target") then return end
            end
        -- Greater Blessing of Might
            -- if isChecked("Greater Blessing of Might") and greaterBuff < 3 then
            --     for i = 1, #br.friend do
            --         local thisUnit = br.friend[i].unit
            --         local unitRole = UnitGroupRolesAssigned(thisUnit)
            --         if UnitBuffID(thisUnit,spell.buffs.greaterBlessingOfMight) == nil and (unitRole == "DAMAGER" or solo) then
            --             if cast.greaterBlessingOfMight(thisUnit) then return end
            --         end
            --     end
            -- end
		-- Greater Blessing of Kings
			if isChecked("Greater Blessing of Kings") and getBuffRemain("player",203538) < 600 and not IsMounted() then
				cast.greaterBlessingOfKings()
			end
		-- Greater Blessing of Wisdom
			if isChecked("Greater Blessing of Wisdom") and getBuffRemain("player",203539) < 600 and not IsMounted() then
				cast.greaterBlessingOfWisdom()
			end
        end -- End Action List - Extras
    -- Action List - Defensives
        local function actionList_Defensive()
            if useDefensive() then
				-- Lay On Hands
					if isChecked("Lay On Hands") and inCombat then
					-- Player
						if getOptionValue("Lay on Hands Target") == 1 then
							if php <= getValue("Lay On Hands") then
								if cast.layOnHands("player") then return true end
							end
					-- Target
						elseif getOptionValue("Lay on Hands Target") == 2 then
							if getHP("target") <= getValue("Lay On Hands") then
								if cast.layOnHands("target") then return true end
							end
					-- Mouseover
						elseif getOptionValue("Lay on Hands Target") == 3 then
							if getHP("mouseover") <= getValue("Lay On Hands") then
								if cast.layOnHands("mouseover") then return true end
							end
					-- LowestUnit
						elseif getHP(lowestUnit) <= getValue("Lay On Hands") then
							-- Tank
								if getOptionValue("Lay on Hands Target") == 4 then
									if UnitGroupRolesAssigned(lowestUnit) == "TANK" then
										if cast.layOnHands(lowestUnit) then return true end
									end
							-- Healer
								elseif getOptionValue("Lay on Hands Target") == 5 then
									if UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
										if cast.layOnHands(lowestUnit) then return true end
									end
							-- Healer/Tank
								elseif getOptionValue("Lay on Hands Target") == 6 then
									if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "TANK" then
										if cast.layOnHands(lowestUnit) then return true end
									end
							-- Healer/Damager
								elseif getOptionValue("Lay on Hands Target") == 7 then
									if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "DAMAGER" then
										if cast.layOnHands(lowestUnit) then return true end
									end						
							-- Any
								elseif  getOptionValue("Lay on Hands Target") == 8 then
									if cast.layOnHands(lowestUnit) then return true end
								end
						end
					end
				-- Divine Shield
					if isChecked("Divine Shield") then
						if php <= getOptionValue("Divine Shield") and inCombat then
							if cast.divineShield() then return end
						end
					end
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
						if hasEquiped(122667) then
							if GetItemCooldown(122667)==0 then
								useItem(122667)
							end
						end
					end
				-- Gift of the Naaru
					if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and race == "Draenei" then
						if castSpell("player",racial,false,false,false) then return end
					end
				-- Blessing of Protection
					if isChecked("Blessing of Protection") then
						if getHP(lowestUnit) < getOptionValue("Blessing of Protection") and inCombat then
							if cast.blessingOfProtection(lowestUnit) then return end
						end
					end
				-- Blinding Light
					if isChecked("Blinding Light - HP") and php <= getOptionValue("Blinding Light - HP") and inCombat and #enemies.yards10 > 0 then
						if cast.blindingLight() then return end
					end
					if isChecked("Blinding Light - AoE") and #enemies.yards5 >= getOptionValue("Blinding Light - AoE") and inCombat then
						if cast.blindingLight() then return end
					end
				-- Cleanse Toxins
					if isChecked("Cleanse Toxins") then
						if getOptionValue("Cleanse Toxins")==1 then
							if cast.cleanseToxins("player") then return end
						end
						if getOptionValue("Cleanse Toxins")==2 then
							if cast.cleanseToxins("target") then return end
						end
						if getOptionValue("Cleanse Toxins")==3 then
							if cast.cleanseToxins("mouseover") then return end
						end
					end
				-- Eye for an Eye
					if isChecked("Eye for an Eye") then
						if php <= getOptionValue("Eye for an Eye") and inCombat then
							if cast.eyeForAnEye() then return end
						end
					end
				-- Shield of Vengeance
					if isChecked("Shield of Vengeance") then
						if php <= getOptionValue("Shield of Vengeance") and inCombat then
							if cast.shieldOfVengeance() then return end
						end
					end
				-- Hammer of Justice
					if isChecked("Hammer of Justice - HP") and php <= getOptionValue("Hammer of Justice - HP") and inCombat then
						if cast.hammerOfJustice() then return end
					end
					if isChecked("Hammer of Justice - Legendary") and getHP("target") >= 75 and inCombat then
						if cast.hammerOfJustice() then return end
					end
				-- Redemption
					if isChecked("Redemption") then
						if getOptionValue("Redemption")==1 and not isMoving("player") and resable then
							if cast.redemption("target","dead") then return end
						end
						if getOptionValue("Redemption")==2 and not isMoving("player") and resable then
							if cast.redemption("mouseover","dead") then return end
						end
					end
				-- Flash of Light
					if isChecked("Flash of Light") then
						if (forceHeal or (inCombat and php <= getOptionValue("Flash of Light") / 2) or (not inCombat and php <= getOptionValue("Flash of Light"))) and not isMoving("player") then
							if cast.flashOfLight() then return end
						end
					end
				-- Engineering: Gunpowder Charge
					if isChecked("Gunpowder Charge") and (getOptionValue("Gunpowder Charge") <= ttd ) and inCombat and canUse(132510) then
						useItem(132510)
					end
            end
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                for i = 1, #enemies.yards10 do
                    local thisUnit = enemies.yards10[i]
                    local distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        -- Hammer of Justice
                        if isChecked("Hammer of Justice") and distance < 10 then
                            if cast.hammerOfJustice(thisUnit) then return end
                        end
        -- Rebuke
                        if isChecked("Rebuke") and distance < 5 then
                            if cast.rebuke(thisUnit) then return end
                        end
        -- Blinding Light
                        if isChecked("Blinding Light") and distance < 10 then
                            if cast.blindingLight() then return end
                        end
                    end
                end
            end
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            if (useCDs() or burst) and getDistance(units.dyn5) < 5 then
            -- Trinkets
                if isChecked("Trinkets") then
                    if canUse(13) and not hasEquiped(151190, 13) then
                        useItem(13)
                    end
                    if canUse(14) and not hasEquiped(151190, 14) then
                        useItem(14)
                    end
                end
            -- Specter of Betrayal
                -- use_item,name=specter_of_betrayal,if=(buff.crusade.up&buff.crusade.stack>=15|cooldown.crusade.remains>gcd*2)|(buff.avenging_wrath.up|cooldown.avenging_wrath.remains>gcd*2)
                if isChecked("Trinkets") and hasEquiped(151190) and canUse(151190) then
                    if ((buff.crusade.exists() and buff.crusade.stack() >= 15) or cd.crusade > gcd * 2) or (buff.avengingWrath.exists() or cd.avengingWrath > gcd * 2) then
                        useItem(151190)
                    end
                end
            -- Potion
                -- potion,name=old_war,if=(buff.bloodlust.react|buff.avenging_wrath.up|buff.crusade.up&buff.crusade.remains<25|target.time_to_die<=40)
                if isChecked("Potion") and canUse(127844) and inRaid then
                    if (hasBloodlust() or buff.avengingWrath.exists() or (buff.crusade.exists() and buff.crusade.remain() < 25) or ttd(units.dyn5) <= 40) then
                        useItem(127844)
                    end
                end
            -- Racial
                -- blood_fury
                -- berserking
                -- arcane_torrent,if=holy_power<=4
                if isChecked("Racial") and (race == "Orc" or race == "Troll" or (race == "BloodElf" and holyPower <= 4)) and getSpellCD(racial) == 0 then
                    if castSpell("player",racial,false,false,false) then return end
                end
            -- Holy Wrath
                -- holy_wrath
                if isChecked("Holy Wrath") then
                    if cast.holyWrath() then return end
                end
            -- Shield of Vengenace
                -- shield_of_vengeance
                if isChecked("Shield of Vengenace - CD") then
                    if cast.shieldOfVengeance() then return end
                end
            -- Avenging Wrath
                -- avenging_wrath
                if isChecked("Avenging Wrath") and not talent.crusade then
                    if cast.avengingWrath() then return end
                end
            -- Crusade
                -- crusade,if=holy_power>=3|((equipped.137048|race.blood_elf)&holy_power>=2)
                if isChecked("Crusade") and talent.crusade and (holyPower >= 3 or ((hasEquiped(137048) or race == "BloodElf") and holyPower >= 2)) then
                    if cast.avengingWrath() then return end
                end
            end -- End Cooldown Usage Check
        end -- End Action List - Cooldowns
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if isValidUnit("target") and (opener == true or not isChecked("Opener")) then
        -- Flask
                -- flask,type=flask_of_the_countless_armies
        -- Food
                -- food,type=azshari_salad
        -- Augmenation
                -- augmentation,type=defiled
        -- Potion
                -- potion,name=old_war
                -- if isChecked("Potion") and canUse(127844) and inRaid then
                --     useItem(127844)
                -- end
        -- Divine Hammer
                if #enemies.yards8 >= getOptionValue("Divine Storm Units") then
                    if cast.divineHammer() then return end
                end
        -- Judgment
                if cast.judgment("target") then return end
        -- Start Attack
                if getDistance("target") < 5 then StartAttack() end
            end
        end -- End Action List - PreCombat
    -- Action List - Opener
        local function actionList_Opener()
            if isChecked("Opener") and isBoss("target") and opener == false then
                if isValidUnit("target") and getDistance("target") < 5 then
                    if not OPN1 then 
                        Print("Starting Opener")
                        OPN1 = true
                    elseif not RAC1 then
        -- Racial
                        if isChecked("Racial") and (race == "Orc" or race == "Troll" or (race == "BloodElf" and holyPower <= 4)) and getSpellCD(racial) == 0 then
                            -- if castSpell("player",racial,false,false,false) then return end
                            if castOpener("racial","RAC1",1) then return end
                        else
                            Print("1: Racial - Orc/Troll/BloodElf (Uncastable)")
                            RAC1 = true
                        end
                    elseif RAC1 and not JUD1 then
        -- Judgment
                        if castOpener("judgment","JUD1",2) then return end
                    elseif JUD1 and not BOJ1 then
        -- Blade of Justice/Divine Hammer
                        -- if=equipped.137048|race.blood_elf|!cooldown.wake_of_ashes.up
                        if hasEquiped(137048) or race == "BloodEld" or (cd.wakeOfAshes ~= 0 or not artifact.wakeOfAshes) then
                            if talent.bladeOfWrath then
                                if castOpener("bladeOfJustice","BOJ1",3) then return end
                            else
                                if castOpener("divineHammer","BOJ1",3) then return end
                            end
                        else
                            Print("3: Blade of Justice / Divine Hammer (Uncastable)")
                            BOJ1 = true
                        end
                    elseif BOJ1 and not WOA1 then
        -- Wake of Ashes
                        if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) then
                            if castOpener("wakeOfAshes","WOA1",4) then return end
                        else
                            Print("4: Wake of Ashes (Uncastable)")
                        end
                    elseif WOA1 then
                        opener = true;
                        Print("Opener Complete")
                        return
                    end
                end
            elseif (UnitExists("target") and not isBoss("target")) or not isChecked("Opener") then
                opener = true
            end
        end -- End Action List - Opener
    -- Action List - Priority
        local function actionList_Priority()
        -- Execution Sentence
            -- execution_sentence,if=spell_targets.divine_storm<=3&(cooldown.judgment.remains<gcd*4.5|debuff.judgment.remains>gcd*4.5)
            if ((mode.rotation == 1 and #enemies.yards8 <= getOptionValue("Divine Storm Units")) or mode.rotation == 3) and (cd.judgment < gcd * 4.5 or debuff.judgment.remain(units.dyn5) > gcd * 4.5) then
                if cast.executionSentence() then return end
            end
        -- Divine Storm
            -- divine_storm,if=debuff.judgment.up&variable.ds_castable&buff.divine_purpose.up&buff.divine_purpose.remains<gcd*2
            if judgmentVar and dsCastable and buff.divinePurpose.exists() and buff.divinePurpose.remain() < gcd * 2 then
                if cast.divineStorm() then return end
            end
            -- divine_storm,if=debuff.judgment.up&variable.ds_castable&holy_power>=5&buff.divine_purpose.react
            if judgmentVar and dsCastable and holyPower >= 5 and buff.divinePurpose.exists() then
                if cast.divineStorm() then return end
            end
            -- divine_storm,if=debuff.judgment.up&spell_targets.divine_storm>=2&holy_power>=3&(buff.crusade.up&buff.crusade.stack<15|buff.liadrins_fury_unleashed.up)
            if judgmentVar and ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Divine Storm Units")) or mode.rotation == 2) and holyPower >= 3 
                and (buff.crusade.exists() and buff.crusade.stack() < 15 or buff.liadrinsFuryUnleashed.exists())
            then 
                if cast.divineStorm() then return end
            end
            -- divine_storm,if=debuff.judgment.up&variable.ds_castable&holy_power>=5
            if judgmentVar and dsCastable and holyPower >= 5 then
                if cast.divineStorm() then return end
            end 
        -- Justicar's Vengeance
            -- justicars_vengeance,if=debuff.judgment.up&buff.divine_purpose.up&buff.divine_purpose.remains<gcd*2&!equipped.137020
            if judgmentVar and buff.divinePurpose.exists() and buff.divinePurpose.remain() < gcd * 2 and not hasEquiped(137020) then
                if cast.justicarsVengeance() then return end
            end
            -- justicars_vengeance,if=debuff.judgment.up&holy_power>=5&buff.divine_purpose.react&!equipped.137020
            if judgmentVar and holyPower >= 5 and buff.divinePurpose.exists() and not hasEquiped(137020) then
                if cast.justicarsVengeance() then return end
            end
        -- Templar's Verdict
            -- templars_verdict,if=debuff.judgment.up&buff.divine_purpose.up&buff.divine_purpose.remains<gcd*2
            if judgmentVar and buff.divinePurpose.exists() and buff.divinePurpose.remain() < gcd * 2 then
                if cast.templarsVerdict() then return end
            end
            -- templars_verdict,if=debuff.judgment.up&holy_power>=5&buff.divine_purpose.react
            if judgmentVar and holyPower >= 5 and buff.divinePurpose.exists() then
                if cast.templarsVerdict() then return end
            end
            -- templars_verdict,if=debuff.judgment.up&holy_power>=3&(buff.crusade.up&buff.crusade.stack<15|buff.liadrins_fury_unleashed.up)
            if judgmentVar and holyPower >= 5 and (buff.crusade.exists() and buff.crusade.stack() < 15 or buff.liadrinsFuryUnleashed.exists()) then
                if cast.templarsVerdict() then return end
            end
            -- templars_verdict,if=debuff.judgment.up&holy_power>=5
            if judgmentVar and holyPower >= 5 then
                if cast.templarsVerdict() then return end
            end
        -- Divine Storm
            -- divine_storm,if=debuff.judgment.up&variable.ds_castable&artifact.wake_of_ashes.enabled&cooldown.wake_of_ashes.remains<gcd*2
            if judgmentVar and dsCastable and artifact.wakeOfAshes and cd.wakeOfAshes < gcd * 2 then
                if cast.divineStorm() then return end
            end
            -- divine_storm,if=debuff.judgment.up&variable.ds_castable&buff.whisper_of_the_nathrezim.up&buff.whisper_of_the_nathrezim.remains<gcd*1.5
            if judgmentVar and dsCastable and buff.whisperOfTheNathrezim.exists() and buff.whisperOfTheNathrezim.remain() < gcd * 1.5 then
                if cast.divineStorm() then return end
            end
        -- Templar's Verdict
            -- templars_verdict,if=(equipped.137020|debuff.judgment.up)&artifact.wake_of_ashes.enabled&cooldown.wake_of_ashes.remains<gcd*2
            if (hasEquiped(137020) or judgmentVar) and artifact.wakeOfAshes and cd.wakeOfAshes < gcd * 2 then
                if cast.templarsVerdict() then return end
            end
            -- templars_verdict,if=debuff.judgment.up&buff.whisper_of_the_nathrezim.up&buff.whisper_of_the_nathrezim.remains<gcd*1.5
            if judgmentVar and buff.whisperOfTheNathrezim.exists() and buff.whisperOfTheNathrezim.remain() < gcd * 1.5 then
                if cast.divineStorm() then return end
            end
        -- Judgment
            -- judgment,if=dot.execution_sentence.ticking&dot.execution_sentence.remains<gcd*2&debuff.judgment.remains<gcd*2
            if debuff.executionSentence.exists(units.dyn5) and debuff.executionSentence.remain(units.dyn5) < gcd * 2 and debuff.judgment.remain(units.dyn5) < gcd * 2 then
                if cast.judgment() then return end
            end
        -- Consecration
            -- consecration,if=(cooldown.blade_of_justice.remains>gcd*2|cooldown.divine_hammer.remains>gcd*2)
            if (cd.bladeOfJustice > gcd * 2 or cd.divineHammer > gcd * 2) then
                if cast.consecration() then return end
            end
        -- Wake of Ashes
            -- wake_of_ashes,if=(!raid_event.adds.exists|raid_event.adds.in>15)&(holy_power<=0|holy_power=1&(cooldown.blade_of_justice.remains>gcd|cooldown.divine_hammer.remains>gcd)|holy_power=2&((cooldown.zeal.charges_fractional<=0.65|cooldown.crusader_strike.charges_fractional<=0.65)))
            if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) and getDistance(units.dyn5) < 5 then
                if (holyPower <= 0 or (holyPower == 1 and (cd.bladeOfJustice > gcd or cd.divineHammer > gcd)) or (holyPower == 2 and ((charges.frac.zeal <= 0.65 or charges.frac.crusaderStrike <= 0.65)))) then
                    if cast.wakeOfAshes() then return end
                end
            end
        -- Blade of Justice
            -- blade_of_justice,if=holy_power<=3-set_bonus.tier20_4pc
            if holyPower <= 3 - t20pc4 then
                if cast.bladeOfJustice() then return end
            end
        -- Divine Hammer
            -- divine_hammer,if=holy_power<=3-set_bonus.tier20_4pc
            if holyPower <= 3 - t20pc4 then
                if cast.divineHammer() then return end
            end
        -- Judgment
            -- judgment
            if cast.judgment() then return end
        -- Zeal
            -- zeal,if=cooldown.zeal.charges_fractional>=1.65&holy_power<=4&(cooldown.blade_of_justice.remains>gcd*2|cooldown.divine_hammer.remains>gcd*2)&debuff.judgment.remains>gcd
            if charges.frac.zeal >= 1.65 and holyPower <= 4 and (cd.bladeOfJustice > gcd * 2 or cd.divineHammer > gcd * 2) and debuff.judgment.remain(units.dyn5) > gcd then
                if cast.zeal() then return end
            end
        -- Crusader Strike
            -- crusader_strike,if=cooldown.crusader_strike.charges_fractional>=1.65-talent.the_fires_of_justice.enabled*0.25&holy_power<=4&(cooldown.blade_of_justice.remains>gcd*2|cooldown.divine_hammer.remains>gcd*2)&debuff.judgment.remains>gcd
            if charges.frac.crusaderStrike >= 1.65 - firesOfJustice * 0.25 and holyPower <= 4 and (cd.bladeOfJustice > gcd * 2 or cd.divineHammer > gcd * 2) and debuff.judgment.remain(units.dyn5) > gcd then
                if cast.crusaderStrike() then return end
            end
        -- Consecration
            -- consecration
            if cast.consecration() then return end
        -- Divine Storm
            -- divine_storm,if=debuff.judgment.up&variable.ds_castable&buff.divine_purpose.react
            if judgmentVar and dsCastable and buff.divinePurpose.exists() then
                if cast.divineStorm() then return end
            end
            -- divine_storm,if=debuff.judgment.up&variable.ds_castable&buff.the_fires_of_justice.react
            if judgmentVar and dsCastable and buff.theFiresOfJustice.exists() then
                if cast.divineStorm() then return end
            end
            -- divine_storm,if=debuff.judgment.up&variable.ds_castable
            if judgmentVar and dsCastable then
                if cast.divineStorm() then return end
            end
        -- Justicar's Vengeance
            -- justicars_vengeance,if=debuff.judgment.up&buff.divine_purpose.react&!equipped.137020
            if judgmentVar and buff.divinePurpose.exists() and not hasEquiped(137020) then
                if cast.justicarsVengeance() then return end
            end
        -- Templar's Verdict
            -- templars_verdict,if=debuff.judgment.up&buff.divine_purpose.react
            if judgmentVar and buff.divinePurpose.exists() then
                if cast.templarsVerdict() then return end
            end
            -- templars_verdict,if=debuff.judgment.up&buff.the_fires_of_justice.react
            if judgmentVar and buff.theFiresOfJustice.exists() then
                if cast.templarsVerdict() then return end
            end
            -- templars_verdict,if=debuff.judgment.up&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*2)
            if judgmentVar and (not talent.executionSentence or cd.executionSentence > gcd * 2) then
                if cast.templarsVerdict() then return end
            end
        -- Hammer of Justice
            -- hammer_of_justice,if=equipped.137065&target.health.pct>=75&holy_power<=4
            if hasEquiped(13705) and thp >= 75 and holyPower <= 4 then
                if cast.hammerOfJustice() then return end
            end
        -- Zeal
            -- zeal,if=holy_power<=4
            if holyPower <= 4 then
                if cast.zeal() then return end
            end
        -- Crusader Strike
            -- crusader_strike,if=holy_power<=4
            if holyPower <= 4 then
                if cast.crusaderStrike() then return end
            end
        end
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
            if inCombat and profileStop==false then
------------------------------
--- In Combat - Interrupts ---
------------------------------
----------------------------------
--- In Combat - Begin Rotation ---
----------------------------------
--------------------------------
--- In Combat - SimCraft APL ---
--------------------------------
                if getOptionValue("APL Mode") == 1 then
            -- Start Attack
                    -- auto_attack
                    if getDistance(units.dyn5) < 5 and opener == true then
                        if not IsCurrentSpell(6603) then
                            StartAttack(units.dyn5)
                        end
                    end
            -- Action List - Interrupts
                    -- rebuke
                    if actionList_Interrupts() then return end
            -- Action List - Opener
                    -- call_action_list,name=opener,if=time<2
                    if combatTime < 2 then
                        if actionList_Opener() then return end
                    end
                    if opener == true then
            -- Action List - Cooldowns
                        -- call_action_list,name=cooldowns 
                        if actionList_Cooldowns() then return end
            -- Action List - Priority
                        -- call_action_list,name=priority
                        if actionList_Priority() then return end
                    end
                end
    --         -- Racials
				-- -- blood_fury
				-- -- berserking
				-- -- arcane_torrent,if=holy_power<5
				-- if isChecked("Racial") and useCDs() then
				-- 	if race == "Orc" or race == "Troll" or (race == "BloodElf" and holyPower < 5 and (buff.crusade.exists() or buff.avengingWrath.exists() or combatTime < 2)) and getSpellCD(racial) == 0 then
				-- 		if castSpell("player",racial,false,false,false) then return end
				-- 	end
				-- end
    --         -- Combat Time less than 2 secs
    --                 if combatTime < 2 then
			 
    --         -- Judgement
    --                     -- judgment,if=time<2
    --                     if cast.judgment() then return end
    --         -- Blade of Justice
    --                     -- blade_of_justice,if=time<2&(equipped.137048|race.blood_elf)
    --                     if not talent.divineHammer and (hasEquiped(137048) or race == "BloodElf") then
    --                         if cast.bladeOfJustice() then return end
    --                     end
    --         -- Divine Hammer
    --                     -- divine_hammer,if=time<2&(equipped.137048|race.blood_elf)
    --                     if talent.divineHammer and (hasEquiped(137048) or race == "BloodElf") then
    --                         if cast.divineHammer() then return end
    --                     end
    --         -- Wake of Ashes
    --                     -- wake_of_ashes,if=holy_power<=1&time<2
    --                     if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) then
    --                         if getDistance(units.dyn5) < 5 and holyPower <= 1 then
    --                             if cast.wakeOfAshes() then return end
    --                         end
    --                     end
    --                 end
    --                 if useCDs() then
    --         -- Holy Wrath
    --                     -- holy_wrath
    --                     if isChecked("Holy Wrath") then
    --                         if cast.holyWrath() then return end
    --                     end
    --         -- Avenging Wrath
    --                     -- avenging_wrath
    --                     if isChecked("Avenging Wrath") and not talent.crusade and getDistance(units.dyn5) < 5 then
    --                         if cast.avengingWrath() then return end
    --                     end
    --         -- Crusade
    --                     -- crusade,if=holy_power>=5&!equipped.137048|((equipped.137048|race.blood_elf)&time<2|time>2&holy_power>=4)
    --                     if isChecked("Crusade") and talent.crusade and getDistance(units.dyn5) < 5 then
    --                         if (holyPower >= 5 and not hasEquiped(137048)) or ((hasEquiped(137048) or race == "BloodElf") and combatTime < 2 or combatTime > 2 and holyPower >= 4) then
    --                             if cast.avengingWrath() then return end
    --                         end
    --                     end
    --                 end
    --         -- Execution Sentence
    --                 -- execution_sentence,if=spell_targets.divine_storm<=3&(cooldown.judgment.remain()s<gcd*4.5|debuff.judgment.remain()s>gcd*4.67)&(!talent.crusade.enabled|cooldown.crusade.remain()s>gcd*2)
    --                 if #enemies.yards8 <= 3 and (cd.judgment < gcd * 4.5 or judgmentRemain > gcd * 4.67) and (not talent.crusade or cd.crusade > gcd *2 or not isChecked("Crusade") or not useCDs()) and ttd > 6 then
    --                     if cast.executionSentence() then return end
    --                 end
    --         -- Divine Storm
    --                 -- divine_storm,if=debuff.judgment.up&spell_targets.divine_storm>=2&buff.divine_purpose.up&buff.divine_purpose.remain()s<gcd*2
    --                 -- divine_storm,if=debuff.judgment.up&spell_targets.divine_storm>=2&holy_power>=5&buff.divine_purpose.react
    --                 -- divine_storm,if=debuff.judgment.up&spell_targets.divine_storm>=2&holy_power>=3&buff.crusade.up&(buff.crusade.stack()<15|buff.bloodlust.up)
    --                 -- divine_storm,if=debuff.judgment.up&spell_targets.divine_storm>=2&holy_power>=5&(!talent.crusade.enabled|cooldown.crusade.remain()s>gcd*3)
    --                 if not isChecked("Justicar's Vengeance") or (isChecked("Justicar's Vengeance") and php >= getOptionValue("Justicar's Vengeance")) then
    --                     if judgmentVar and ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Divine Storm Units")) or mode.rotation == 2) 
    --                         and ((buff.divinePurpose.exists() and buff.divinePurpose.remain() < gcd * 2)
    --                         or (holyPower >= 5 and buff.divinePurpose.exists())
    --                         or (holyPower >= 3 and buff.crusade.exists() and (buff.crusade.stack() < 15 or hasBloodLust()))
    --                         or (holyPower >= 5 and (not talent.crusade or cd.crusade > gcd * 3 or not isChecked("Crusade") or not useCDs())))
    --                     then
    --                         if cast.divineStorm() then return end
    --                     end
    --                 end
    --         -- Justicar's Vengeance
    --                 -- justicars_vengeance,if=debuff.judgment.up&buff.divine_purpose.up&buff.divine_purpose.remain()s<gcd*2&!equipped.whisper_of_the_nathrezim
    --                 -- justicars_vengeance,if=debuff.judgment.up&holy_power>=5&buff.divine_purpose.react&!equipped.whisper_of_the_nathrezim
    --                 if isChecked("Justicar's Vengeance") and php < getOptionValue("Justicar's Vengeance") then
    --                     if judgmentVar and ((buff.divinePurpose.exists() and buff.divinePurpose.remain() < gcd * 2 and not hasEquiped(137020))
    --                         or (holyPower >= 5 and buff.divinePurpose.exists() and not hasEquiped(137020)))
    --                     then
    --                         if cast.justicarsVengeance() then return end
    --                     end
    --                 end
    --         -- Templar's Verdict
    --                 -- templars_verdict,if=debuff.judgment.up&buff.divine_purpose.up&buff.divine_purpose.remain()s<gcd*2
    --                 -- templars_verdict,if=debuff.judgment.up&holy_power>=5&buff.divine_purpose.react
    --                 -- templars_verdict,if=debuff.judgment.up&holy_power>=3&buff.crusade.up&(buff.crusade.stack()<15|buff.bloodlust.up)
    --                 -- templars_verdict,if=debuff.judgment.up&holy_power>=5&(!talent.crusade.enabled|cooldown.crusade.remain()s>gcd*3)
    --                 if not isChecked("Justicar's Vengeance") or (isChecked("Justicar's Vengeance") and php >= getOptionValue("Justicar's Vengeance")) then
    --                     if judgmentVar and ((mode.rotation == 1 and #enemies.yards8 < getOptionValue("Divine Storm Units")) or mode.rotation == 3)
    --                         and ((buff.divinePurpose.exists() and buff.divinePurpose.remain() < gcd * 2)
    --                         or (holyPower >= 5 and buff.divinePurpose.exists())
    --                         or (holyPower >= 3 and buff.crusade.exists() and (buff.crusade.stack() < 15 or hasBloodLust()))
    --                         or (holyPower >= 5 and (not talent.crusade or cd.crusade > gcd * 3 or not isChecked("Crusade") or not useCDs())))
    --                     then
    --                         if cast.templarsVerdict() then return end
    --                     end
    --                 end
    --         -- Divine Storm
    --                 -- divine_storm,if=debuff.judgment.up&holy_power>=3&spell_targets.divine_storm>=2&(cooldown.wake_of_ashes.remain()s<gcd*2&artifact.wake_of_ashes.enabled|buff.whisper_of_the_nathrezim.up&buff.whisper_of_the_nathrezim.remain()s<gcd)&(!talent.crusade.enabled|cooldown.crusade.remain()s>gcd*4)
    --                 if not isChecked("Justicar's Vengeance") or (isChecked("Justicar's Vengeance") and php >= getOptionValue("Justicar's Vengeance")) then
    --                     if judgmentVar and holyPower >= 3 and ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Divine Storm Units")) or mode.rotation == 2)
    --                         and ((cd.wakeOfAshes < gcd * 2 and artifact.wakeOfAshes) or (buff.whisperOfTheNathrezim.exists() and buff.whisperOfTheNathrezim.remain() < gcd) or not artifact.wakeOfAshes)
    --                         and (not talent.crusade or cd.crusade > gcd * 4 or not isChecked("Crusade") or not useCDs())
    --                     then
    --                         if cast.divineStorm() then return end
    --                     end
    --                 end
    --         -- Justicar's Vengeance
    --                 -- justicars_vengeance,if=debuff.judgment.up&holy_power>=3&buff.divine_purpose.up&cooldown.wake_of_ashes.remain()s<gcd*2&artifact.wake_of_ashes.enabled&!equipped.whisper_of_the_nathrezim
    --                 if isChecked("Justicar's Vengeance") and php < getOptionValue("Justicar's Vengeance") then
    --                     if judgmentVar and holyPower >= 3 and buff.divinePurpose.exists() and ((cd.wakeOfAshes < gcd * 2 and artifact.wakeOfAshes) or not artifact.wakeOfAshes) and not hasEquiped(137020) then
    --                         if cast.justicarsVengeance() then return end
    --                     end
    --                 end
    --         -- Templar's Verdict
    --                 -- templars_verdict,if=debuff.judgment.up&holy_power>=3&(cooldown.wake_of_ashes.remain()s<gcd*2&artifact.wake_of_ashes.enabled|buff.whisper_of_the_nathrezim.up&buff.whisper_of_the_nathrezim.remain()s<gcd)&(!talent.crusade.enabled|cooldown.crusade.remain()s>gcd*4)
    --                 if not isChecked("Justicar's Vengeance") or (isChecked("Justicar's Vengeance") and php >= getOptionValue("Justicar's Vengeance")) then
    --                     if judgmentVar and holyPower >= 3 and ((mode.rotation == 1 and #enemies.yards8 < getOptionValue("Divine Storm Units")) or mode.rotation == 3)
    --                         and ((cd.wakeOfAshes < gcd * 2 and artifact.wakeOfAshes) or (buff.whisperOfTheNathrezim.exists() and buff.whisperOfTheNathrezim.remain() < gcd) or not artifact.wakeOfAshes)
    --                         and (not talent.crusade or cd.crusade < gcd * 4 or not isChecked("Crusade") or not useCDs())
    --                     then
    --                         if cast.templarsVerdict() then return end
    --                     end
    --                 end
    --         -- Wake of Ashes
    --                 -- wake_of_ashes,if=holy_power=0|holy_power=1&(cooldown.blade_of_justice.remain()s>gcd|cooldown.divine_hammer.remain()s>gcd)|holy_power=2&(cooldown.zeal.charges_fractional<=0.65|cooldown.crusader_strike.charges_fractional<=0.65)
    --                 if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) then
    --                     if holyPower == 0 or (holyPower == 1 and (cd.bladeOfJustice > gcd or cd.divineHammer > gcd)) or (holyPower == 2 and (charges.frac.zeal <= 0.65 or charges.frac.crusaderStrike <= 0.65)) and getDistance(units.dyn5) < 5 then
    --                         if cast.wakeOfAshes() then return end
    --                     end
    --                 end
    --         -- Blade of Justice
    --                 -- blade_of_justice,if=holy_power<=3&buff.whisper_of_the_nathrezim.up&buff.whisper_of_the_nathrezim.remain()s>gcd&buff.whisper_of_the_nathrezim.remain()s<gcd*3&debuff.judgment.up&debuff.judgment.remain()s>gcd*2
    --                 if not talent.divineHammer and holyPower <= 3 and buff.whisperOfTheNathrezim.exists() and buff.whisperOfTheNathrezim.remain() > gcd and buff.whisperOfTheNathrezim.remain() < gcd * 3 and judgmentVar and debuff.judgment.remain(units.dyn5) > gcd * 2 then
    --                     if cast.bladeOfJustice() then return end
    --                 end
    --         -- Divine Hammer
    --                 -- divine_hammer,if=holy_power<=3&buff.whisper_of_the_nathrezim.up&buff.whisper_of_the_nathrezim.remain()s>gcd&buff.whisper_of_the_nathrezim.remain()s<gcd*3&debuff.judgment.up&debuff.judgment.remain()s>gcd*2
    --                 -- if ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Divine Storm Units")) or mode.rotation == 2) then
    --                     if talent.divineHammer and holyPower <= 3 and buff.whisperOfTheNathrezim.exists() and buff.whisperOfTheNathrezim.remain() > gcd and buff.whisperOfTheNathrezim.remain() < gcd * 3 and judgmentVar and debuff.judgment.remain(units.dyn5) > gcd * 2 then
    --                         if cast.divineHammer() then return end
    --                     end
    --                 -- end
    --         -- Blade of Justice
    --                 -- blade_of_justice,if=talent.blade_of_wrath.enabled&holy_power<=3
    --                 if talent.bladeOfWrath and holyPower <= 3 then
    --                     if cast.bladeOfJustice() then return end
    --                 end
    --         -- Zeal
    --                 -- zeal,if=charges=2&holy_power<=4
    --                 if talent.zeal and charges.zeal == 2 and holyPower <= 4 then
    --                     if cast.zeal() then return end
    --                 end
    --         -- Crusader Strike
    --                 -- crusader_strike,if=charges=2&holy_power<=4
    --                 if not talent.zeal and charges.crusaderStrike == 2 and holyPower <= 4 then
    --                     if cast.crusaderStrike() then return end
    --                 end
    --         -- Blade of Justice
    --                 -- blade_of_justice,if=holy_power<=2|(holy_power<=3&(cooldown.zeal.charges_fractional<=1.34|cooldown.crusader_strike.charges_fractional<=1.34))
    --                 if not talent.divineHammer and (holyPower <= 2 or (holyPower <= 3 and (charges.frac.zeal <= 1.34 or charges.frac.crusaderStrike <= 1.34))) then
    --                     if cast.bladeOfJustice() then return end
    --                 end
    --         -- Divine Hammer
    --                 -- divine_hammer,if=holy_power<=2|(holy_power<=3&(cooldown.zeal.charges_fractional<=1.34|cooldown.crusader_strike.charges_fractional<=1.34))
    --                 -- if ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Divine Storm Units")) or mode.rotation == 2) then
    --                     if talent.divineHammer and holyPower <= 2 or (holyPower <= 3 and (charges.frac.zeal <= 1.34 or charges.frac.crusaderStrike <= 1.34)) then
    --                         if cast.divineHammer() then return end
    --                     end
    --                 -- end
    --         -- Judgement
    --                 -- judgment,if=holy_power>=3|((cooldown.zeal.charges_fractional<=1.67|cooldown.crusader_strike.charges_fractional<=1.67)&(cooldown.divine_hammer.remain()s>gcd|cooldown.blade_of_justice.remain()s>gcd))|(talent.greater_judgment.enabled&target.health.pct>50)
    --                 if holyPower >= 3 or ((charges.frac.zeal <= 1.67 or charges.frac.crusaderStrike <= 1.67) and (cd.divineHammer > gcd or cd.bladeOfJustice > gcd))
    --                     or (talent.greaterJudgement and thp > 50)
    --                 then
    --                     if cast.judgment() then return end
    --                 end
    --         -- Consecration
    --                 -- consecration
    --                 if #enemies.yards8 >= 1 then
    --                     if cast.consecration() then return end
    --                 end
    --         -- Divine Storm
    --                 -- divine_storm,if=debuff.judgment.up&spell_targets.divine_storm>=2&buff.divine_purpose.react
    --                 -- divine_storm,if=debuff.judgment.up&spell_targets.divine_storm>=2&buff.the_fires_of_justice.react&(!talent.crusade.enabled|cooldown.crusade.remain()s>gcd*3)
    --                 -- divine_storm,if=debuff.judgment.up&spell_targets.divine_storm>=2&(holy_power>=4|((cooldown.zeal.charges_fractional<=1.34|cooldown.crusader_strike.charges_fractional<=1.34)&(cooldown.divine_hammer.remain()s>gcd|cooldown.blade_of_justice.remain()s>gcd)))&(!talent.crusade.enabled|cooldown.crusade.remain()s>gcd*4)
    --                 if not isChecked("Justicar's Vengeance") or (isChecked("Justicar's Vengeance") and php >= getOptionValue("Justicar's Vengeance")) then
    --                     if judgmentVar and ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Divine Storm Units")) or mode.rotation == 2)
    --                         and (buff.divinePurpose.exists()
    --                         or (buff.theFiresOfJustice.exists() and (not talent.crusade or cd.crusade > gcd * 3 or not isChecked("Crusade") or not useCDs()))
    --                         or (holyPower >= 4 or ((charges.frac.zeal <= 1.34 or charges.frac.crusaderStrike <= 1.34) and (cd.divineHammer > gcd or cd.bladeOfJustice > gcd)) and (not talent.crusade or cd.crusade > gcd * 4 or not isChecked("Crusade") or not useCDs())))
    --                     then
    --                         if cast.divineStorm() then return end
    --                     end
    --                 end
    --         -- Justicar's Vengeance
    --                 -- justicars_vengeance,if=debuff.judgment.up&buff.divine_purpose.react&!equipped.whisper_of_the_nathrezim
    --                 if isChecked("Justicar's Vengeance") and php < getOptionValue("Justicar's Vengeance") then
    --                     if judgmentVar and buff.divinePurpose.exists() and not hasEquiped(137020) then
    --                         if cast.justicarsVengeance() then return end
    --                     end
    --                 end
    --         -- Templar's Verdict
    --                 -- templars_verdict,if=debuff.judgment.up&buff.divine_purpose.react
    --                 -- templars_verdict,if=debuff.judgment.up&buff.the_fires_of_justice.react&(!talent.crusade.enabled|cooldown.crusade.remain()s>gcd*3)
    --                 -- templars_verdict,if=debuff.judgment.up&(holy_power>=4|((cooldown.zeal.charges_fractional<=1.34|cooldown.crusader_strike.charges_fractional<=1.34)&(cooldown.divine_hammer.remain()s>gcd|cooldown.blade_of_justice.remain()s>gcd)))&(!talent.crusade.enabled|cooldown.crusade.remain()s>gcd*4)
    --                 if not isChecked("Justicar's Vengeance") or (isChecked("Justicar's Vengeance") and php >= getOptionValue("Justicar's Vengeance")) then
    --                     if judgmentVar
    --                         and ((mode.rotation == 1 and #enemies.yards8 < getOptionValue("Divine Storm Units")) or mode.rotation == 3)
    --                         and (buff.divinePurpose.exists()
    --                         or (buff.theFiresOfJustice.exists() and (not talent.crusade or cd.crusade > gcd * 3 or not isChecked("Crusade") or not useCDs()))
    --                         or (holyPower >= 4 or ((charges.frac.zeal <= 1.34 or charges.frac.crusaderStrike <= 1.34) and (cd.divineHammer > gcd or cd.bladeOfJustice > gcd)) and (not talent.crusade or cd.crusade > gcd * 4 or not isChecked("Crusade") or not useCDs())))
    --                     then
    --                         if cast.templarsVerdict() then return end
    --                     end
    --                 end
    --         -- Zeal
    --                 -- zeal,if=holy_power<=4
    --                 if talent.zeal and holyPower <= 4 then
    --                     if cast.zeal() then return end
    --                 end
    --         -- Crusader Strike
    --                 -- crusader_strike,if=holy_power<=4
    --                 if not talent.zeal and holyPower <= 4 then
    --                     if cast.crusaderStrike() then return end
    --                 end
    --         -- Divine Storm
    --                 -- divine_storm,if=debuff.judgment.up&holy_power>=3&spell_targets.divine_storm>=2&(!talent.crusade.enabled|cooldown.crusade.remain()s>gcd*5)
    --                 if judgmentVar and holyPower >= 3 and ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Divine Storm Units")) or mode.rotation == 2) and (not talent.crusade or cd.crusade > gcd * 5 or not isChecked("Crusade") or not useCDs()) then
    --                     if cast.divineStorm() then return end
    --                 end
    --         -- Templar's Verdict
    --                 -- templars_verdict,if=debuff.judgment.up&holy_power>=3&(!talent.crusade.enabled|cooldown.crusade.remain()s>gcd*5)
    --                 if judgmentVar and holyPower >= 3 and ((mode.rotation == 1 and #enemies.yards8 < getOptionValue("Divine Storm Units")) or mode.rotation == 3) and (not talent.crusade or cd.crusade > gcd * 5 or not isChecked("Crusade") or not useCDs()) then
    --                     if cast.templarsVerdict() then return end
    --                 end
    --             end -- End SimC APL
----------------------------------
--- In Combat - AskMrRobot APL ---
----------------------------------
                if getOptionValue("APL Mode") == 2 then
        -- Execution Sentence
                    -- if CooldownSecRemaining(Judgment) <= GlobalCooldownSec * 3
                    if cd.judgment <= gcd * 3 then
                        if cast.executionSentence(units.dyn5) then return end
                    end
        -- Judgment
                    if cast.judgment("target") then return end
        -- Consecration
                    -- if not HasBuff(Judgment)
                    if not judgmentExists and #enemies.yards8 >= 3 then
                        if cast.consecration() then return end
                    end
        -- Justicar's Vengeance
                    -- if HasBuff(DivinePurpose) and TargetsInRadius(DivineStorm) <= 3
                    if isChecked("Justicar's Vengeance") and php < getOptionValue("Justicar's Vengeance") then
                        if buff.divinePurpose.exists() and #enemies.yards8 <= 3 then
                            if cast.justicarsVengeance(units.dyn5) then return end
                        end
                    end
        -- Divine Storm
                    -- if (AlternatePower >= 4 or HasBuff(DivinePurpose) or HasBuff(Judgment)) and TargetsInRadius(DivineStorm) > 2
                    if not isChecked("Justicar's Vengeance") or php >= getOptionValue("Justicar's Vengeance") then
                        if (holyPower >= 3 or buff.divinePurpose.exists() or judgmentExists) and #enemies.yards8 > 2 then
                            if cast.divineStorm() then return end
                        end
                    end
        -- Templar's Verdict
                    -- if (AlternatePower >= 4 or HasBuff(DivinePurpose) or HasBuff(Judgment))
                    if not isChecked("Justicar's Vengeance") or php >= getOptionValue("Justicar's Vengeance") then
                        if (holyPower >= 3 or buff.divinePurpose.exists() or judgmentExists) then
                            if cast.templarsVerdict(units.dyn5) then return end
                        end
                    end
        -- Wake of Ashes
                    -- if AlternatePowerToMax >= 4
                    if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) then
                        if holyPowerMax - holyPower >= 4 and getDistance(units.dyn5) < 5 then
                            if cast.wakeOfAshes(units.dyn5) then return end
                        end
                    end
        -- Blade of Justice
                    -- if AlternatePowerToMax >= 2
                    if holyPowerMax - holyPower >= 2 then
                        if cast.bladeOfJustice(units.dyn5) then return end
                    end
        -- Blade of Wrath
                    -- if AlternatePowerToMax >= 2
                    if holyPowerMax - holyPower >= 2 then
                        if cast.bladeOfWrath(units.dyn5) then return end
                    end
        -- Divine Hammer
                    -- if AlternatePowerToMax >= 2
                    if holyPowerMax - holyPower >= 2 then
                        if cast.divineHammer(units.dyn5) then return end
                    end
        -- Hammer of Justice
                    -- if HasItem(JusticeGaze) and TargetHealthPercent > 0.75 and not HasBuff(Judgment)
                    -- TODO
        -- Crusader Strike
                    if cast.crusaderStrike(units.dyn5) then return end
        -- Zeal
                    if cast.zeal(units.dyn5) then return end
                end -- End AMR APL
            end -- End In Combat
        end -- End Profile
    end -- Timer
end -- runRotation
local id = 70
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
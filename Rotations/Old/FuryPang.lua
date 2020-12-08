--Version 1.0.0
local rotationName = "PangloFury"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Automatic Rotation",
            tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.",
            highlight = 1,
            icon = br.player.spell.execute
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "DPS Rotation Disabled",
            tip = "Disable DPS Rotation",
            highlight = 0,
            icon = br.player.spell.execute
        }
    }
    CreateButton("Rotation", 1, 0)
    -- Cooldown Button
    CooldownModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Cooldowns Automated",
            tip = "Automatic Cooldowns - Boss Detection.",
            highlight = 1,
            icon = br.player.spell.recklessness
        },
        [2] = {
            mode = "On",
            value = 2,
            overlay = "Cooldowns Enabled",
            tip = "Cooldowns used regardless of target.",
            highlight = 0,
            icon = br.player.spell.recklessness
        },
        [3] = {
            mode = "Off",
            value = 3,
            overlay = "Cooldowns Disabled",
            tip = "No Cooldowns will be used.",
            highlight = 0,
            icon = br.player.spell.piercingHowl
        }
    }
    CreateButton("Cooldown", 2, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Defensive Enabled",
            tip = "Includes Defensive Cooldowns.",
            highlight = 1,
            icon = br.player.spell.enragedRegeneration
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Defensive Disabled",
            tip = "No Defensives will be used.",
            highlight = 0,
            icon = br.player.spell.enragedRegeneration
        }
    }
    CreateButton("Defensive", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Interrupts Enabled",
            tip = "Includes Basic Interrupts.",
            highlight = 1,
            icon = br.player.spell.pummel
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Interrupts Disabled",
            tip = "No Interrupts will be used.",
            highlight = 0,
            icon = br.player.spell.pummel
        }
    }
    CreateButton("Interrupt", 4, 0)
    -- Movement Button
    MoverModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Mover Enabled",
            tip = "Will use Charge/Heroic Leap.",
            highlight = 1,
            icon = br.player.spell.charge
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Mover Disabled",
            tip = "Will NOT use Charge/Heroic Leap.",
            highlight = 0,
            icon = br.player.spell.charge
        }
    }
    CreateButton("Mover", 5, 0)
    -- HoldcdModes = {
    --     [1] = {
    --         mode = "ON",
    --         value = 1,
    --         overlay = "CDs will not be held",
    --         tip = "CDs will not be held",
    --         highlight = 1,
    --         icon = br.player.spell.recklessness
    --     },
    --     [2] = {
    --         mode = "OFF",
    --         value = 2,
    --         overlay = "CDs will be held",
    --         tip = "CDs will be held",
    --         highlight = 0,
    --         icon = br.player.spell.recklessness
    --     }
    -- }
    -- CreateButton("Holdcd", 6, 0)
    -- LazyassModes = {
    --     [1] = {
    --         mode = "ON",
    --         value = 1,
    --         overlay = "Lazymode",
    --         tip = "fuckoff",
    --         highlight = 1,
    --         icon = br.player.spell.rallyingCry
    --     },
    --     [2] = {
    --         mode = "OFF",
    --         value = 2,
    --         overlay = "Not Lazy",
    --         tip = "Still fuckoff",
    --         highlight = 0,
    --         icon = br.player.spell.rallyingCry
    --     }
    -- }
    -- CreateButton("Lazyass", 0, -1)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local rotationKeys = {"None", GetBindingKey("Rotation Function 1"), GetBindingKey("Rotation Function 2"), GetBindingKey("Rotation Function 3"), GetBindingKey("Rotation Function 4"), GetBindingKey("Rotation Function 5")}
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.000")
        -- Battle Shout
        br.ui:createCheckbox(section, "Battle Shout", "Automatic Battle Shout for Party Memebers")
        -- Berserker Rage
        br.ui:createCheckbox(section, "Berserker Rage", "Check to use Berserker Rage")
        br.ui:checkSectionState(section)
        --------------------
        -- Essences --------
        --------------------
        section = br.ui:createSection(br.ui.window.profile, "Essences")
        -- Guardian of Azeroth
        br.ui:createCheckbox(section, "GuardianofAzeroth", "Use Guardian of Azeroth")
        br.ui:createDropdownWithout(section, "GuardianOfAzeroth - Usage", {"Always", "Only Boss"}, 1)
        -- Focussing Iris
        br.ui:createDropdown(section, "Meme-Beam", {"Always", "AoE Only"}, 1)
        -- Crucible of Flame
        br.ui:createDropdownWithout(section, "Use Concentrated Flame", {"DPS", "Heal", "Hybrid", "Never"}, 1)
        br.ui:createSpinnerWithout(section, "Concentrated Flame Heal", 70, 10, 90, 5)
        -- Lucid Dreams
        br.ui:createDropdown(section, "Lucid Dreams", {"Always", "CDS"}, 1)
        --Blood of the Enemy
        br.ui:createDropdownWithout(section, "Blood of the Enemy", {"Always", "With Reck", "CDS", "Never"}, 1)
        -- Purifying Blast
        br.ui:createDropdown(section, "Purifying Blast", {"Always", "AoE only"}, 1)
        -- Reaping Flames
        br.ui:createDropdown(section, "Reaping Flames", {"Always", "Snipe only", "20% Rule"}, 1)
        br.ui:createSpinnerWithout(section, "Reaping Flame Damage", 30, 10, 100, 1)
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Trinkets
        br.ui:createDropdown(section, "Trinkets", {"Always", "Cooldown", "With Recklessness"}, 1, "Use Trinkets always or with CDs")
        -- Racials
        br.ui:createCheckbox(section, "Racials")
        -- Bladestorm Units
        br.ui:createSpinner(section, "Bladestorm Units", 3, 1, 10, 1, "Number of units to Bladestorm on")
        -- Dragons Roar
        br.ui:createCheckbox(section, "Dragon Roar")
        -- Bloodrage
        -- br.ui:createCheckbox(section, "Bloodrage")
        -- Recklessness
        br.ui:createDropdownWithout(section, "Recklessness", {"Always", "Cooldown"}, 1, "Desired usage of spell.")
        br.ui:checkSectionState(section)
        -------------------------
        --- MOVEMENT  OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Movement")
        -- charge
        br.ui:createCheckbox(section, "Charge OoC")
        br.ui:createCheckbox(section, "Charge In Combat")
        -- Heroic Leap
        br.ui:createDropdownWithout(section, "Heroic Leap Hotkey", rotationKeys, 1, "Set desired hotkey to use Heroic Leap.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
        br.ui:createSpinner(section, "Healthstone/Potion", 60, 0, 100, 5, "Health Percentage to use at.")
        -- Enraged Regeneration
        br.ui:createSpinner(section, "Enraged Regeneration", 60, 0, 100, 5, "Health Percentage to use at.")
        -- Intimidating Shout
        br.ui:createSpinner(section, "Intimidating Shout", 60, 0, 100, 5, "Health Percentage to use at.")
        -- Rallying Cry
        br.ui:createSpinner(section, "Rallying Cry Units", 5, 0, 40, 1, "Number of Units below HP Value")
        br.ui:createSpinnerWithout(section, "Rallying Cry HP", 60, 0, 100, 5, "HP of Teammates to use RC")
        -- Storm Bolt
        br.ui:createSpinner(section, "Storm Bolt", 60, 0, 100, 5, "Health Percentage to use at.")
        -- Victory Rush
        br.ui:createSpinner(section, "Victory Rush", 60, 0, 100, 5, "Health Percentage to use at.")
        -- Ignore Pain
        br.ui:createSpinner(section, "Ignore Pain", 30, 0, 100, 5, "Health Percentage to use at.")
        br.ui:createSpinner(section, "Piercing Howl", 20, 0, 100, 5, "Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createCheckbox(section, "Storm Bolt Logic", "Stun specific Spells and Mobs")
        -- Pummel
        br.ui:createCheckbox(section, "Pummel")
        -- Intimidating Shout
        br.ui:createCheckbox(section, "Intimidating Shout - Int")
        -- Storm Bolt
        br.ui:createCheckbox(section, "Storm Bolt - Int")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "Cast Percentage to use at.")
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        }
    }
    return optionTable
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    --Toggles
    UpdateToggle("Rotation", 0.25)
    UpdateToggle("Cooldown", 0.25)
    UpdateToggle("Defensive", 0.25)
    UpdateToggle("Interrupt", 0.25)
    UpdateToggle("Mover", 0.25)
    UpdateToggle("Holdcd", 0.25)
    UpdateToggle("Lazyass", 0.25)
    br.player.ui.mode.mover = br.data.settings[br.selectedSpec].toggles["Mover"]
    br.player.ui.mode.holdcd = br.data.settings[br.selectedSpec].toggles["Holdcd"]
    br.player.ui.mode.lazyass = br.data.settings[br.selectedSpec].toggles["Lazyass"]

    local buff = br.player.buff
    local cast = br.player.cast
    local combatTime = getCombatTime()
    local cd = br.player.cd
    local charges = br.player.charges
    local hastar = hastar or GetObjectExists("target")
    local debuff = br.player.debuff
    local enemies = br.player.enemies
    local equiped = br.player.equiped
    local gcd = br.player.gcdMax
    local gcdMax = br.player.gcdMax
	local healPot = getHealthPot()
    local heirloomNeck = 122667 or 122668
    local inCombat = br.player.inCombat
    local inRaid = br.player.instance == "raid"
    local level = br.player.level
    local mode = br.player.ui.mode
    local moving = GetUnitSpeed("player") > 0
    local php = br.player.health
    local pullTimer = br.DBM:getPulltimer()
    local race = br.player.race
    local rage = br.player.power.rage.amount()
    local racial = br.player.getRacial()
    local spell = br.player.spell
    local talent = br.player.talent
    local thp = getHP("target")
    local traits = br.player.traits
    local units = br.player.units
	local ttd = getTTD
    local reapingDamage = getOptionValue("Reaping Flame Damage") * 1000



    --wipe timers table
    if timersTable then
        wipe(timersTable)
    end

    units.get(5)
    units.get(8)
    enemies.get(5)
    enemies.get(8)
    enemies.get(15)
    enemies.get(20)

	local Storm_unitList = {
            [131009] = "Spirit of Gold",
            [134388] = "A Knot of Snakes",
            [129758] = "Irontide Grenadier",
    }
    --Keybindings
    local leapKey = false
    if getOptionValue("Heroic Leap Hotkey") ~= 1 then
        leapKey = _G["rotationFunction" .. (getOptionValue("Heroic Leap Hotkey") - 1)]
        if leapKey == nil then
            leapKey = false
        end
    end

    if profileStop == nil then
        profileStop = false
    end

    if cd.bloodthirst.remain() > (gcdMax / 2) and cd.ragingBlow.remain() > (gcdMax / 2) then
        filler = true
    else
        filler = false
    end
    local function extralist()
        -- Battle Shout
        if isChecked("Battle Shout") and cast.able.battleShout() then
            for i = 1, #br.friend do
                local thisUnit = br.friend[i].unit
                if not UnitIsDeadOrGhost(thisUnit) and getDistance(thisUnit) < 100 and getBuffRemain(thisUnit, spell.battleShout) < 60 then
                    if cast.battleShout() then
                        return
                    end
                end
            end
        end

        -- Berserker Rage
        if isChecked("Berserker Rage") and cast.able.berserkerRage() and hasNoControl(spell.berserkerRage) then
            if cast.berserkerRage() then
                return
            end
        end

       --[[  if php >= getOptionValue("Min HP deathwish") and isChecked("Min HP deathwish") and (buff.deathWish.stack("player") < getOptionValue("Deathwish Stacks") or (buff.deathWish.stack("player") == 10 and buff.deathWish.remain() < 3)) then
            if cast.deathWish() then return end
        end ]]
    end


    local function defensivelist()
        if useDefensive() then
            -- Healthstone/Health Potion
            if isChecked("Healthstone/Potion") and php <= getOptionValue("Healthstone/Potion") and inCombat and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
                if canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(healPot) then
                    useItem(healPot)
                elseif hasItem(166799) and canUseItem(166799) then
                    useItem(166799)
                end
            end

            if getOptionValue("Use Concentrated Flame") ~= 1 and php <= getValue("Concentrated Flame Heal") then
                if cast.concentratedFlame("player") then
                    return
                end
            end

            -- Enraged Regeneration
            if isChecked("Enraged Regeneration") and cast.able.enragedRegeneration() and php <= getOptionValue("Enraged Regeneration") then
                if cast.enragedRegeneration() then
                    return
                end
            end

            -- Intimidating Shout
            if isChecked("Intimidating Shout") and cast.able.intimidatingShout() and php <= getOptionValue("Intimidating Shout") then
                if cast.intimidatingShout() then
                    return
                end
            end

            -- Rallying Cry
            if isChecked("Rallying Cry Units") and cast.able.rallyingCry() and getLowAllies(getValue("Rallying Cry HP")) >= getValue("Rallying Cry Units") then
                if cast.rallyingCry() then
                    return
                end
            end

            -- Storm Bolt
            if isChecked("Storm Bolt") and cast.able.stormBolt() and php <= getOptionValue("Storm Bolt") then
                if cast.stormBolt() then
                    return
                end
            end

            -- Ignore Pain
            if isChecked("Ignore Pain") and cast.able.ignorePain() and rage > 60 and php <= getOptionValue("Ignore Pain") and not buff.ignorePain.exists("player") then
                if cast.ignorePain("player") then
                    return
                end
            end

            -- Piercing Howl
            if isChecked("Piercing Howl") and php <= getOptionValue("Piercing Howl") and inCombat then
                if cast.piercingHowl("player") then
                    return
                end
            end

            -- Victory Rush
            if isChecked("Victory Rush") and (cast.able.victoryRush() or cast.able.impendingVictory()) and php <= getOptionValue("Victory Rush") and buff.victorious.exists("player") then
                if talent.impendingVictory then
                    if cast.impendingVictory() then
                        return
                    end
                else
                    if cast.victoryRush() then
                        return
                    end
                end
            end
        end
    end

    local function interruptlist()
        if useInterrupts() then
			if isChecked("Storm Bolt Logic") then
                    if cast.able.stormBolt() then
                        local Storm_list = {
                            274400,
                            274383,
                            257756,
                            276292,
                            268273,
                            256897,
                            272542,
                            272888,
                            269266,
                            258317,
                            258864,
                            259711,
                            258917,
                            264038,
                            253239,
                            269931,
                            270084,
                            270482,
                            270506,
                            270507,
                            267433,
                            267354,
                            268702,
                            268846,
                            268865,
                            258908,
                            264574,
                            272659,
                            272655,
                            267237,
                            265568,
                            277567,
                            265540,
                            268202,
                            258058,
                            257739
                        }
                        for i = 1, #enemies.yards20 do
                            local thisUnit = enemies.yards20[i]
                            local distance = getDistance(thisUnit)
                            for k, v in pairs(Storm_list) do
                                if (Storm_unitList[GetObjectID(thisUnit)] ~= nil or UnitCastingInfo(thisUnit) == GetSpellInfo(v) or UnitChannelInfo(thisUnit) == GetSpellInfo(v)) and getBuffRemain(thisUnit, 226510) == 0 and distance <= 20 then
                                    if cast.stormBolt(thisUnit) then
                                        return
                                    end
                                end
                            end
                        end
					end
            end
            for i = 1, #enemies.yards20 do
                thisUnit = enemies.yards20[i]
                distance = getDistance(thisUnit)
                if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                    -- Pummel
                    if isChecked("Pummel") and cast.able.pummel(thisUnit) and distance < 5 then
                        if cast.pummel(thisUnit) then
                            return
                        end
                    end
                    -- Intimidating Shout
                    if isChecked("Intimidating Shout - Int") and cast.able.intimidatingShout() and distance < 8 then
                        if cast.intimidatingShout() then
                            return
                        end
                    end
                    -- Storm Bolt
                    if isChecked("Storm Bolt - Int") and cast.able.stormBolt(thisUnit) and distance < 20 then
                        if cast.stormBolt(thisUnit) then
                            return
                        end
                    end
                end
            end
        end
    end

    local function moverlist()
        if br.player.ui.mode.mover == 1 then
            if leapKey and not GetCurrentKeyBoardFocus() then
                CastSpellByName(GetSpellInfo(spell.heroicLeap), "cursor")
            end
            if isChecked("Charge In Combat") then
                if inCombat and cast.able.charge("target") and getDistance("player", "target") >= 8 and getDistance("player", "target") <= 25 then
                    if cast.charge("target") then
                        return
                    end
                end
            end
            if isChecked("Charge OoC") then
                if not inCombat and cast.able.charge("target") and getDistance("player", "target") >= 8 and getDistance("player", "target") <= 25 then
                    if cast.charge("target") then
                        return
                    end
                end
            end
        end
    end

    local function singlelist()
        -- Onslaught
        if (rage <= 85) and buff.enrage.exists("player") then
            if cast.onslaught() then
                return
            end
        end

		-- Focussing Iris
		-- actions+=/focused_azerite_beam,if=!buff.recklessness.up&!buff.siegebreaker.up
		if isChecked("Meme-Beam") and getSpellCD(295258) <=gcd and not buff.recklessness.exists("player") and (getOptionValue("Meme-Beam") == 1 or (getOptionValue("Meme-Beam") == 2 and #enemies.yards8 >= 3)) then
			if cast.focusedAzeriteBeam() then
				return
			end
		end
		-- Purifying Blast
		-- actions+=/purifying_blast,if=!buff.recklessness.up&!buff.siegebreaker.up
		if isChecked("Purifying Blast") and getSpellCD(295337) <=gcd and not buff.recklessness.exists("player") and (getOptionValue("Purifying Blast") == 1 or (getOptionValue("Purifying Blast") == 2 and #enemies.yards8 >= 3)) then
			if cast.purifyingBlast() then
				return
			end
		end

		-- GuardianOfAzeroth
		-- actions+=/guardian_of_azeroth,if=!buff.recklessness.up
        if getSpellCD(295840) <=gcd and not buff.recklessness.exists("player") and isChecked("GuardianofAzeroth")then
            if getOptionValue("GuardianOfAzeroth - Usage")==1 then
                if cast.guardianOfAzeroth() then
                    return
                end
            end
            if getOptionValue("GuardianOfAzeroth - Usage")==2 and isBoss("target") then
                if cast.guardianOfAzeroth() then
                    return
                end
            end
		end

        -- Rampage
        if buff.recklessness.exists("player") or (rage >= 75) or not buff.enrage.exists("player") then
            if cast.rampage() then
                return
            end
        end

        -- Recklessness
		-- actions+=/recklessness,if=!essence.condensed_lifeforce.major&!essence.blood_of_the_enemy.major|cooldown.guardian_of_azeroth.remains>20|buff.guardian_of_azeroth.up|cooldown.blood_of_the_enemy.remains<gcd
        if not buff.recklessness.exists("player") and not buff.memoryOfLucidDreams.exists("player") and (getOptionValue("Recklessness") == 1 or (getOptionValue("Recklessness") == 2 and useCDs())) and br.player.ui.mode.cooldown ~= 3 and (cd.siegebreaker.remain() > 10 or cd.siegebreaker.remain() < gcdMax) then
            if cast.recklessness() then
                return
            end
        end

		-- Lucid Dreams
		-- actions+=/memory_of_lucid_dreams,if=!buff.recklessness.up
        if br.player.ui.mode.cooldown ~= 3 and isChecked("Lucid Dreams") and getSpellCD(298357) <= gcd and not buff.recklessness.exists("player") and (getOptionValue("Lucid Dreams") == 1 or (getOptionValue("Lucid Dreams") == 2 and useCDs())) then
            if cast.memoryOfLucidDreams("player") then
                return
            end
        end

        -- Siegebreaker
        if br.player.ui.mode.cooldown ~= 3 and (getBuffRemain("player", spell.recklessness) > 4.5 or cd.recklessness.remain() > 25 or (getOptionValue("Recklessness") == 2 and not useCDs())) then
            if cast.siegebreaker() then
                return
            end
        end

        if traits.coldSteelHotBlood.rank == 3 or not buff.enrage.exists("player") then
            if cast.bloodthirst() then
                return
            end
        end
        -- Execute
        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if getFacing("player",thisUnit) and cast.able.execute() and (getHP(thisUnit) <= 20 or (talent.massacre and getHP(thisUnit) <= 35) or buff.suddenDeath.exists("player")) and (buff.enrage.exists("player") or rage <= 70) then
                if cast.execute(thisUnit) then
                    return
                end
            end
        end
        --if cast.able.execute() and (thp <= 20 or (talent.massacre and thp <= 35) or buff.suddenDeath.exists()) and (buff.enrage.exists() or rage <= 60) then
        --   if cast.execute() then return end
        -- end

        -- High Prio Bloodthirst
        if traits.coldSteelHotBlood.rank > 1 or not buff.enrage.exists("player") then
            if cast.bloodthirst() then
                return
            end
        end

        -- Raging Blow
        if charges.ragingBlow.count() == 2 then
            if cast.ragingBlow() then
                return
            end
        end

        if getOptionValue("Use Concentrated Flame") == 1 or (getOptionValue("Use Concentrated Flame") == 3 and php > getValue("Concentrated Flame Heal")) then
            if cast.concentratedFlame("target") then
                return
            end
        end

        -- Low Prio Bloodthirst
        if cast.bloodthirst() then
            return
        end

        -- Dragon Roar
        if buff.enrage.exists("player") and isChecked("Dragon Roar") then
            if cast.dragonRoar() then
                return
            end
        end

        -- Raging Blow Dump
        if cast.ragingBlow() then
            return
        end

        -- Bladestorm Single target
        if buff.enrage.exists("player") and isChecked("Bladestorm Units") and br.player.ui.mode.cooldown ~= 3 and isBoss("target") then
            if cast.bladestorm() then
                return
            end
        end

        -- whirlwind filler
        if filler then
            if cast.whirlwind("player", nil, 1, 5) then
                return
            end
        end
    end --  end single target

    local function explosivelist()
        if buff.recklessness.exists("player") or (rage >= 75) or not buff.enrage.exists("player") then
            if cast.rampage() then
                return
            end
        end
        if cast.able.execute() and (getHP("target") <= 20 or (talent.massacre and getHP("target") <= 35) or buff.suddenDeath.exists("player")) and (buff.enrage.exists("player") or rage <= 70) then
            if cast.execute("target") then
                return
            end
        end
        if traits.coldSteelHotBlood.rank > 1 or not buff.enrage.exists("player") then
            if cast.bloodthirst() then
                return
            end
        end
        if charges.ragingBlow.count() == 2 then
            if cast.ragingBlow() then
                return
            end
        end
        if cast.bloodthirst() then
            return
        end
        if cast.ragingBlow() then
            return
        end
    end

    local function multilist()
        -- Maintain Whirlwind buff
        if not buff.whirlwind.exists("player") then
            if cast.whirlwind("player", nil, 1, 5) then
                return
            end
        end

        -- Onslaught
        if (rage <= 85) and buff.enrage.exists("player") then
            if cast.onslaught() then
                return
            end
        end

        if br.player.ui.mode.cooldown ~= 3 and isChecked("Lucid Dreams") and getSpellCD(298357) <= gcd and not buff.recklessness.exists("player") and (getOptionValue("Lucid Dreams") == 1 or (getOptionValue("Lucid Dreams") == 2 and useCDs())) then
            if cast.memoryOfLucidDreams("player") then
                return
            end
        end

		-- Purifying Blast
		-- actions+=/purifying_blast,if=!buff.recklessness.up&!buff.siegebreaker.up
		if isChecked("Purifying Blast") and getSpellCD(295337) <=gcd and not buff.recklessness.exists("player") and (getOptionValue("Purifying Blast") == 1 or (getOptionValue("Purifying Blast") == 2 and #enemies.yards8 >= 3)) then
			if cast.purifyingBlast() then
				return
			end
		end

		-- Focussing Iris
		-- actions+=/focused_azerite_beam,if=!buff.recklessness.up&!buff.siegebreaker.up
		if isChecked("Meme-Beam") and getSpellCD(295258) <=gcd and not buff.recklessness.exists("player") and (getOptionValue("Meme-Beam") == 1 or (getOptionValue("Meme-Beam") == 2 and #enemies.yards8 >= 3)) then
			if cast.focusedAzeriteBeam() then
				return
			end
        end

        if buff.recklessness.exists("player") and isChecked("GuardianofAzeroth")then
            if getOptionValue("GuardianOfAzeroth - Usage")==1 then
                if cast.guardianOfAzeroth() then
                    return true
                end
            end
            if getOptionValue("GuardianOfAzeroth - Usage")==2 and isBoss("target") then
                if cast.guardianOfAzeroth() then
                    return true
                end
            end
		end
        -- Recklessness
        if not buff.recklessness.exists() and not buff.memoryOfLucidDreams.exists("player") and (getOptionValue("Recklessness") == 1 or (getOptionValue("Recklessness") == 2 and useCDs())) and br.player.ui.mode.cooldown ~= 3 and (cd.siegebreaker.remain() > 10 or cd.siegebreaker.remain() < gcdMax) then
            if cast.recklessness() then
                return
            end
        end

        -- Siegebreaker
        if buff.whirlwind.exists("player") and (br.player.ui.mode.cooldown ~= 3 and (getBuffRemain("player", spell.recklessness) > 4.5 or cd.recklessness.remain() > 25 or (getOptionValue("Recklessness") == 2 and not useCDs()))) then
            if cast.siegebreaker() then
                return
            end
        end

        -- Dragon Roar
        if buff.enrage.exists("player") and isChecked("Dragon Roar") then
            if cast.dragonRoar() then
                return
            end
        end

        -- Rampage
        if buff.whirlwind.exists("player") and (buff.recklessness.exists("player") or (not buff.enrage.exists("player") or (talent.carnage and rage >= 75) or (rage >= 85))) then
            if cast.rampage() then
                return
            end
        end
        -- Bladestorm
        if isChecked("Bladestorm Units") and #enemies.yards8 >= getOptionValue("Bladestorm Units") and buff.enrage.exists("player") and br.player.ui.mode.cooldown ~= 3 then
            if cast.bladestorm() then
                return
            end
        end

        -- Execute
        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if buff.whirlwind.exists("player") and getFacing("player",thisUnit) and cast.able.execute() and (getHP(thisUnit) <= 20 or (talent.massacre and getHP(thisUnit) <= 35) or buff.suddenDeath.exists("player")) and (buff.enrage.exists("player") or rage <= 70) then
                if cast.execute(thisUnit) then
                    return
                end
            end
        end
        --if buff.whirlwind.exists() and cast.able.execute() and (thp <= 20 or (talent.massacre and thp <= 35) or buff.suddenDeath.exists()) and (buff.enrage.exists() or rage <= 60) then
        --    if cast.execute() then return end
        --end

        -- High Prio Bloodthirst
        if buff.whirlwind.exists("player") and (traits.coldSteelHotBlood.rank > 1 or not buff.enrage.exists("player")) then
            if cast.bloodthirst() then
                return
            end
        end

        -- Raging Blow
        if buff.whirlwind.exists("player") and charges.ragingBlow.count() == 2 then
            if cast.ragingBlow() then
                return
            end
        end

        if getOptionValue("Use Concentrated Flame") == 1 or (getOptionValue("Use Concentrated Flame") == 3 and php > getValue("Concentrated Flame Heal")) then
            if cast.concentratedFlame("target") then
                return
            end
        end

        -- Low Prio Bloodthirst
        if buff.whirlwind.exists("player") then
            if cast.bloodthirst() then
                return
            end
        end

        -- Raging Blow Dump
        if buff.whirlwind.exists("player") then
            if cast.ragingBlow() then
                return
            end
        end
    end -- end multi target

    local function cooldownlist()

        -- Bloodrage
        --if isChecked("Bloodrage") and inCombat and IsSpellKnown(329038) and cast.able.bloodrage()then
        --    if cast.bloodrage("player") then
        --        return
        --    end
        --end
        --racials
        if isChecked("Racials") and br.player.ui.mode.cooldown ~= 3 then
            if race == "Orc" or race == "Troll" or race == "LightforgedDraenei" then
                if cast.racial("player") then
                    return
                end
            end
        end

        --BOTE
        if getOptionValue("Blood of the Enemy") == 1 or (getOptionValue("Blood of the Enemy") == 2 and buff.recklessness.remain() > 4) or (getOptionValue("Blood of the Enemy") == 3 and useCDs()) then
            if cast.bloodOfTheEnemy("player") then return end
        end
		-- Reaping Flames
		-- actions+=/reaping_flames,if=!buff.recklessness.up&!buff.siegebreaker.up
		for i = 1, #enemies.yards20 do
            local thisUnit = enemies.yards20[i]
            local distance = getDistance(thisUnit)
		--	local enemyUnit.hpabs = UnitHealth(thisUnit)
            if isChecked("Reaping Flames") and cast.able.reapingFlames(thisUnit) and (getOptionValue("Reaping Flames") == 1 and not buff.recklessness.exists("player") and not debuff.siegebreaker.exists(thisUnit)) then
                if CastSpellByName("Reaping Flames",thisUnit) then
                    br.addonDebug("Reaping 1")
                    return
                end
            elseif isChecked("Reaping Flames") and cast.able.reapingFlames(thisUnit) and getOptionValue("Reaping Flames") == 2 and ((buff.reapingFlames.exists("player") and (UnitHealth(thisUnit) <= (reapingDamage * 2))) or (not buff.reapingFlames.exists("player") and (UnitHealth(thisUnit) <= reapingDamage))) then
                if CastSpellByName("Reaping Flames",thisUnit) then
                    br.addonDebug("Reaping Snipe")
                    return
                end
            elseif isChecked("Reaping Flames") and cast.able.reapingFlames(thisUnit) and getOptionValue("Reaping Flames") == 3 and (getHP(thisUnit) <= 20 or UnitHealth(thisUnit) <= reapingDamage or getHP(thisUnit) >= 80)then
                if CastSpellByName("Reaping Flames",thisUnit) then
                    return
                end
            end
        end
    end
    if br.player.ui.mode.lazyass == 1 and hastar and getDistance("target") > 5 then
        RunMacroText("/follow")
    end

    if isCastingSpell(295258) then
        return true
    end
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if pause(true) or (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) or mode.rotation == 2 then
        return true
    else
        if moverlist() then
            return
        end
        if extralist() then
            return
        end
        if inCombat and profileStop == false and not (IsMounted() or IsFlying()) and #enemies.yards5 >= 1 then
            if getDistance(units.dyn5) < 6 then
                StartAttack()
            end
            if isExplosive("target") then
                if explosivelist() then
                    return
                end
            end
            if interruptlist() then
                return
            end
            if defensivelist() then
                return
            end
            if cooldownlist() then
                return
            end
            if #enemies.yards8 > 1 and level >= 40 --[[ and (not isChecked("Dont kill your friends with bursting") or getDebuffStacks("player", 240443) >= getOptionValue("Dont kill your friends with bursting")) ]] then
                --Print("Multi")
                if multilist() then
                    return
                end
            else
                --Print("Single")
                if singlelist() --[[ and (not isChecked("Dont kill your friends with bursting") or getDebuffStacks("player", 240443) >= getOptionValue("Dont kill your friends with bursting")) ]] then
                    return
                end
            end
        end
    end
end

local id = 0 --72
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
tinsert(
    br.rotations[id],
    {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation
    }
)

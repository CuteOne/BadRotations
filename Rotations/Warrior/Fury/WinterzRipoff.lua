--Version 1.0.0
local rotationName = "WinterzRipOff"

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
        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.0")
        -- Battle Shout
        br.ui:createCheckbox(section, "Battle Shout", "Automatic Battle Shout for Party Memebers")
        -- Berserker Rage
        br.ui:createCheckbox(section, "Berserker Rage", "Check to use Berserker Rage")
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
    local massacreTalent = talent.massacre and 1.5 or 0
    local condemnCDdur = (6 - massacreTalent) - ((6 - massacreTalent) * (GetHaste() / 100))



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
    end


    local function defensivelist()
        if useDefensive() then
            -- Healthstone/Health Potion
            if isChecked("Healthstone/Potion") and php <= getOptionValue("Healthstone/Potion") and inCombat and (hasHealthPot() or hasItem(5512) or hasItem(177278) or hasItem(166799)) then
                if canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(healPot) then
                    useItem(healPot)
                elseif hasItem(166799) and canUseItem(166799) then
                    useItem(166799)
                elseif canUseItem(177278) then
                    useItem(177278)
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

    local function singlelist()

        -- Rampage
        if buff.recklessness.exists("player") or (rage >= 90) or not buff.enrage.exists("player") then
            if cast.rampage() then
                return
            end
        end

        -- Recklessness
		-- actions+=/recklessness,if=!essence.condensed_lifeforce.major&!essence.blood_of_the_enemy.major|cooldown.guardian_of_azeroth.remains>20|buff.guardian_of_azeroth.up|cooldown.blood_of_the_enemy.remains<gcd
        if not buff.recklessness.exists("player") and (getOptionValue("Recklessness") == 1 or (getOptionValue("Recklessness") == 2 and useCDs())) and br.player.ui.mode.cooldown ~= 3 and (cd.siegebreaker.remain() > 10 or cd.siegebreaker.remain() < gcdMax) then
            if cast.recklessness() then
                return
            end
        end

        -- Siegebreaker
        if br.player.ui.mode.cooldown ~= 3 and (getBuffRemain("player", spell.recklessness) > 4.5 or cd.recklessness.remain() > 25 or (getOptionValue("Recklessness") == 2 and not useCDs())) then
            if cast.siegebreaker() then
                return
            end
        end

        -- condemn test
        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if (getHP(thisUnit) >80 or buff.suddenDeath.exists("player") or (getHP(thisUnit) <= 20 or (talent.massacre and getHP(thisUnit) <= 35)))
                and cast.able.condemn() and cd.condemn.remains() == 0 and br.timer:useTimer("condemnCD",condemnCDdur)
            then
                if cast.condemn(thisUnit) then
                    return
                end
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

                -- Onslaught
        if (rage <= 85) and buff.enrage.exists("player") then
            if cast.onslaught() then
                return
            end
        end

                -- Raging Blow
        if charges.ragingBlow.count() == 2 and buff.enrage.exists("player") then
            if cast.ragingBlow() then
                return
            end
        end

        -- High Prio Bloodthirst
        if traits.coldSteelHotBlood.rank > 1 or not buff.enrage.exists("player") then
            if cast.bloodthirst() then
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
            if cast.whirlwind(units.dyn5, "aoe", 1, 5) then
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

        -- BT if Fresh Meat and not Enraged   test later

        -- Maintain Whirlwind buff
        if not buff.whirlwind.exists("player") then
            if cast.whirlwind(units.dyn5, "aoe", 1, 5) then
                return
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

                -- condemn test
        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if (getHP(thisUnit) >80 or buff.suddenDeath.exists("player") or (getHP(thisUnit) <= 20 or (talent.massacre and getHP(thisUnit) <= 35)))
                and cast.able.condemn() and cd.condemn.remains() == 0 and br.timer:useTimer("condemnCD",condemnCDdur)
            then
                if cast.condemn(thisUnit) then
                    return
                end
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

                -- Onslaught
        if (rage <= 85) and buff.enrage.exists("player") then
            if cast.onslaught() then
                return
            end
        end

        -- Raging Blow
        if buff.whirlwind.exists("player") and charges.ragingBlow.count() == 2 and buff.enrage.exists("player") then
            if cast.ragingBlow() then
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
            if race == "Orc" or race == "Troll" or race == "LightforgedDraenei" or race=="MagharOrc" then
                if cast.racial("player") then
                    return
                end
            end
        end
    end
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if pause(true) or (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) or mode.rotation == 2 then
        return true
    else
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

local id = 72
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

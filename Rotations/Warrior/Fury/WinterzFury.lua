--Version 1.1.0
local rotationName = "WinterzFury"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.whirlwind },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladestorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.ragingBlow },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
    }
    br.ui:createToggle(RotationModes,"Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
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
    br.ui:createToggle(CooldownModes,"Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
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
    br.ui:createToggle(DefensiveModes,"Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
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
    br.ui:createToggle(InterruptModes,"Interrupt", 4, 0)

end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local rotationKeys = {"None", GetBindingKey("Rotation Function 1"), GetBindingKey("Rotation Function 2"), GetBindingKey("Rotation Function 3"), GetBindingKey("Rotation Function 4"), GetBindingKey("Rotation Function 5")}
    local optionTable
    local section
    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.1.1")
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
        br.ui:createDropdown(section, "Trinkets", {"Always", "With Reck"}, 1, "How to use Trinkets")
        -- Racials
        br.ui:createCheckbox(section, "Racials")
        -- Bladestorm Units
        br.ui:createSpinner(section, "Bladestorm Units", 3, 1, 10, 1, "Number of units to Bladestorm on")
        -- Ancient Aftershock Units
        br.ui:createSpinner(section, "Ancient Aftershock Units", 3, 1, 10, 1, "Number of units to use NF Ability on")
        -- Aftershock SingleTarget
        br.ui:createCheckbox(section, "Use Aftershock in ST")
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
        -- Healing Module
        br.player.module.BasicHealing(section)
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
    br.UpdateToggle("Rotation", 0.25)
    br.UpdateToggle("Cooldown", 0.25)
    br.UpdateToggle("Defensive", 0.25)
    br.UpdateToggle("Interrupt", 0.25)

    local buff                                              = br.player.buff
    local cast                                              = br.player.cast
    local combatTime                                        = br.getCombatTime()
    local cd                                                = br.player.cd
    local charges                                           = br.player.charges
    local hastar                                            = hastar or br.GetObjectExists("target")
    local debuff                                            = br.player.debuff
    local enemies                                           = br.player.enemies
    local equiped                                           = br.player.equiped
    local gcd                                               = br.player.gcdMax
    local gcdMax                                            = br.player.gcdMax
	local healPot                                           = br.getHealthPot()
    local heirloomNeck                                      = 122667 or 122668
    local inCombat                                          = br.player.inCombat
    local item                                              = br.player.items
    local inRaid                                            = br.player.instance == "raid"
    local level                                             = br.player.level
    local mode                                              = br.player.ui.mode
    local moving                                            = br._G.GetUnitSpeed("player") > 0
    local php                                               = br.player.health
    local pullTimer                                         = br.DBM:getPulltimer()
    local race                                              = br.player.race
    local rage                                              = br.player.power.rage.amount()
    local runeforge                                         = br.player.runeforge
    local racial                                            = br.player.getRacial()
    local spell                                             = br.player.spell
    local talent                                            = br.player.talent
    local thp                                               = br.getHP("target")
    local traits                                            = br.player.traits
    local units                                             = br.player.units
	local ttd                                               = br.getTTD
    local use                                               = br.player.use
    local ui                                                = br.player.ui
    local module 										    = br.player.module
    local debug                                             = br.addonDebug
    local massacreTalent                                    = talent.massacre and 1.5 or 0
    local condemnCDdur                                      = (6 - massacreTalent) - ((6 - massacreTalent) * (GetHaste() / 100))



    --wipe timers table
    if br.timersTable then
        wipe(br.timersTable)
    end

    units.get(5)
    units.get(8)
    enemies.get(5)
    enemies.get(8)
    enemies.get(15)
    enemies.get(20)
    enemies.cone.get(45, 12, false, false)

	local Storm_unitList = {
            [131009] = "Spirit of Gold",
            [134388] = "A Knot of Snakes",
            [129758] = "Irontide Grenadier",
    }

    if br.profileStop == nil then
        br.profileStop = false
    end

    if cd.bloodthirst.remain() > (gcdMax / 2) and cd.ragingBlow.remain() > (gcdMax / 2) then
        filler = true
    else
        filler = false
    end
    local function extralist()
        -- Battle Shout
        if br.isChecked("Battle Shout") and cast.able.battleShout() then
            for i = 1, #br.friend do
                local thisUnit = br.friend[i].unit
                if not br.GetUnitIsDeadOrGhost(thisUnit) and br.getDistance(thisUnit) < 100 and br.getBuffRemain(thisUnit, spell.battleShout) < 60 then
                    if cast.battleShout() then
                        return
                    end
                end
            end
        end

        -- Berserker Rage
        if br.isChecked("Berserker Rage") and cast.able.berserkerRage() and br.hasNoControl(spell.berserkerRage) then
            if cast.berserkerRage() then
                return
            end
        end
    end
    local function already_stunned(Unit)
        if Unit == nil then
            return false
        end
        local already_stunned_list = {
            [47481] = "Gnaw",
            [5211] = "Mighty Bash",
            [22570] = "Maim",
            [19577] = "Intimidation",
            [119381] = "Leg Sweep",
            [853] = "Hammer of Justice",
            [408] = "Kidney Shot",
            [1833] = "Cheap Shot",
            [199804] = "Between the eyes",
            [107570] = "Storm Bolt",
            [46968] = "Shockwave",
            [221562] = "Asphyxiate",
            [91797] = "Monstrous Blow",
            [179057] = "Chaos Nova",
            [211881] = "Fel Eruption",
            [1822] = "Rake",
            [192058] = "Capacitor Totem",
            [118345] = "Pulverize",
            [89766] = "Axe Toss",
            [30283] = "Shadowfury",
            [1122] = "Summon Infernal",
        }
        for i = 1, #already_stunned_list do
            --  Print(select(10, UnitDebuff(Unit, i)))
            local debuffSpellID = select(10, br._G.UnitDebuff(Unit, i))
            if debuffSpellID == nil then
                return false
            end
            --    Print(tostring(already_stunned_list[tonumber(debuffSpellID)]))
            if already_stunned_list[tonumber(debuffSpellID)] ~= nil then
                return true
            end
        end
        return false
    end

    local function defensivelist()
        if br.useDefensive() then
            -- Healthstone/Health Potion
            module.BasicHealing()
            -- Enraged Regeneration
            if br.isChecked("Enraged Regeneration") and cast.able.enragedRegeneration() and php <= br.getOptionValue("Enraged Regeneration") then
                if cast.enragedRegeneration() then
                    return
                end
            end

            -- Intimidating Shout
            if br.isChecked("Intimidating Shout") and cast.able.intimidatingShout() and php <= br.getOptionValue("Intimidating Shout") then
                if cast.intimidatingShout() then
                    return
                end
            end

            -- Rallying Cry
            if br.isChecked("Rallying Cry Units") and cast.able.rallyingCry() and br.getLowAllies(br.getValue("Rallying Cry HP")) >= br.getValue("Rallying Cry Units") then
                if cast.rallyingCry() then
                    return
                end
            end

            -- Storm Bolt
            if br.isChecked("Storm Bolt") and cast.able.stormBolt() and php <= br.getOptionValue("Storm Bolt") then
                if cast.stormBolt() then
                    return
                end
            end

            -- Ignore Pain
            if br.isChecked("Ignore Pain") and cast.able.ignorePain() and rage > 60 and php <= br.getOptionValue("Ignore Pain") and not buff.ignorePain.exists("player") then
                if cast.ignorePain("player") then
                    return
                end
            end

            -- Piercing Howl
            if br.isChecked("Piercing Howl") and php <= br.getOptionValue("Piercing Howl") and inCombat then
                if cast.piercingHowl("player") then
                    return
                end
            end

            -- Victory Rush
            if br.isChecked("Victory Rush") and (cast.able.victoryRush() or cast.able.impendingVictory()) and php <= br.getOptionValue("Victory Rush") and buff.victorious.exists("player") then
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
        if br.useInterrupts() then
			if br.isChecked("Storm Bolt Logic") then
                    if cast.able.stormBolt() then
                        local Storm_list = {
                        }
                        for i = 1, #enemies.yards20 do
                            local thisUnit = enemies.yards20[i]
                            local distance = br.getDistance(thisUnit)
                            for k, v in pairs(Storm_list) do
                                if (Storm_unitList[br.GetObjectID(thisUnit)] ~= nil or br._G.UnitCastingInfo(thisUnit) == GetSpellInfo(v) or br._G.UnitChannelInfo(thisUnit) == GetSpellInfo(v)) and br.getBuffRemain(thisUnit, 226510) == 0 and distance <= 20 then
                                    if cast.stormBolt(thisUnit) then
                                        return
                                    end
                                end
                            end
                        end
					end
            end
            for i = 1, #enemies.yards20 do
                local thisUnit = enemies.yards20[i]
                local distance = br.getDistance(thisUnit)
                if br.canInterrupt(thisUnit, br.getOptionValue("Interrupt At")) then
                    -- Pummel
                    if br.isChecked("Pummel") and cast.able.pummel(thisUnit) and distance < 5 then
                        if cast.pummel(thisUnit) then
                            return
                        end
                    end
                    -- Intimidating Shout
                    if br.isChecked("Intimidating Shout - Int") and cast.able.intimidatingShout() and distance < 8 then
                        if cast.intimidatingShout() then
                            return
                        end
                    end
                    -- Storm Bolt
                    if br.isChecked("Storm Bolt - Int") and cast.able.stormBolt(thisUnit) and distance < 20 then
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
		--
        if not buff.recklessness.exists("player") and (br.getOptionValue("Recklessness") == 1 or (br.getOptionValue("Recklessness") == 2 and br.useCDs())) and br.player.ui.mode.cooldown ~= 3 and (cd.siegebreaker.remain() > 10 or cd.siegebreaker.remain() < gcdMax) then
            if cast.recklessness() then
                return
            end
        end

        -- Siegebreaker
        if br.player.ui.mode.cooldown ~= 3 and (br.getBuffRemain("player", spell.recklessness) > 4.5 or cd.recklessness.remain() > 25 or (br.getOptionValue("Recklessness") == 2 and not br.useCDs())) then
            if cast.siegebreaker() then
                return
            end
        end

        -- condemn MASSACRE test
        if ((C_Covenants.GetActiveCovenantID()) == 2) then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if br.getHP(thisUnit) >80 or (talent.massacre and br.getHP(thisUnit) <= 35) or buff.suddenDeath.exists("player") then
                    if br._G.CastSpellByName(GetSpellInfo(330325)) then debug("Condemn MASSACRE ST")
                        return
                    end
                end
            end
        end
        -- condemn NON-massacre
        if ((C_Covenants.GetActiveCovenantID()) == 2) then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if br.getHP(thisUnit) >80 or buff.suddenDeath.exists("player") or br.getHP(thisUnit) <= 20 then
                    if br._G.CastSpellByName(GetSpellInfo(317485)) then debug("Condemn Non-Massacre ST")
                        return
                    end
                end
            end
        end
        -- EXECUTE MASSACRE
        if not ((C_Covenants.GetActiveCovenantID()) == 2) then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if br.getFacing("player",thisUnit) and talent.massacre and br.getHP(thisUnit) <= 35 or buff.suddenDeath.exists("player") or rage <= 70 then
                    if cast.executeMassacre(thisUnit) then debug("Execute Massacre")
                        return
                    end
                end
            end
        end
        -- Execute non-MASSACRE
        if not ((C_Covenants.GetActiveCovenantID()) == 2) then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if br.getFacing("player",thisUnit) and br.getHP(thisUnit) <= 20 or rage <= 70 then
                    if cast.execute(thisUnit) then debug("Execute NON Massacre")
                        return
                    end
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

        -- Low Prio Bloodthirst
        if cast.bloodthirst() then
            return
        end

        -- Dragon Roar
        if buff.enrage.exists("player") and br.isChecked("Dragon Roar") then
            if cast.dragonRoar() then
                return
            end
        end
        -- Ancient Aftershock ST
        if (br.isChecked("Use Aftershock in ST") and br.isBoss("target")) and cast.able.ancientAftershock(units.dyn12, "cone", 1, 12) and buff.enrage.exists("player") then
            if cast.ancientAftershock(units.dyn12, "cone", 1, 12) then debug("Aftershock SINGLETARGET!!")
                return
            end
        end
        -- Cancel BS SingleTarget
        -- br.CancelUnitBuffID("player",spell.blessingOfProtection)

        -- Bladestorm Single target
        if buff.enrage.exists("player") and br.isChecked("Bladestorm Units") and br.player.ui.mode.cooldown ~= 3 and br.isBoss("target") then
            if cast.bladestorm() then
                return
            end
        end

        -- Raging Blow Dump
        if cast.ragingBlow() then
            return
        end

        -- whirlwind filler
        if filler then
            if cast.whirlwind(units.dyn5, "aoe", 1, 5) then debug("WW ST Filler")
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
        if cast.able.execute() and (br.getHP("target") <= 20 or (talent.massacre and br.getHP("target") <= 35) or buff.suddenDeath.exists("player")) and (buff.enrage.exists("player") or rage <= 70) then
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
        -- Ancient Aftershock
        if br.isChecked("Ancient Aftershock Units") and cast.able.ancientAftershock(units.dyn12, "cone", 1, 12) and #enemies.yards12c >= br.getOptionValue("Ancient Aftershock Units") and buff.enrage.exists("player") and (buff.recklessness.exists("player") or cd.recklessness.remain() > 5) then
            if cast.ancientAftershock(units.dyn12, "cone", 1, 12) then debug("Aftershock!!")
                return
            end
        end
        -- Maintain Whirlwind buff
        if not buff.whirlwind.exists("player") then
            if cast.whirlwind(units.dyn5, "aoe", 1, 5) then debug("WW MT Maintain")
                return
            end
        end

        -- Recklessness
        if not buff.recklessness.exists() and (br.getOptionValue("Recklessness") == 1 or (br.getOptionValue("Recklessness") == 2 and br.useCDs())) and br.player.ui.mode.cooldown ~= 3 and (cd.siegebreaker.remain() > 10 or cd.siegebreaker.remain() < gcdMax) then
            if cast.recklessness() then
                return
            end
        end

        -- Siegebreaker
        if buff.whirlwind.exists("player") and (br.player.ui.mode.cooldown ~= 3 and (br.getBuffRemain("player", spell.recklessness) > 4.5 or cd.recklessness.remain() > 25 or (br.getOptionValue("Recklessness") == 2 and not br.useCDs()))) then
            if cast.siegebreaker() then
                return
            end
        end

        -- Dragon Roar
        if buff.enrage.exists("player") and br.isChecked("Dragon Roar") then
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
        if br.isChecked("Bladestorm Units") and #enemies.yards8 >= br.getOptionValue("Bladestorm Units") and buff.enrage.exists("player") and br.player.ui.mode.cooldown ~= 3 then
            if cast.bladestorm() then
                return
            end
        end

                -- condemn MASSACRE test
        if ((C_Covenants.GetActiveCovenantID()) == 2) then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if buff.whirlwind.exists("player") and br.getHP(thisUnit) >80 or (talent.massacre and br.getHP(thisUnit) <= 35) or buff.suddenDeath.exists("player") then
                    if cast.condemnMassacre(thisUnit) then debug("Condemn MASSACRE Multitarget")
                        return
                    end
                end
            end
        end
        -- condemn NON-massacre
        if ((C_Covenants.GetActiveCovenantID()) == 2) then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if buff.whirlwind.exists("player") and br.getHP(thisUnit) >80 or buff.suddenDeath.exists("player") or br.getHP(thisUnit) <= 20 then
                    if cast.condemn(thisUnit) then debug("Condemn Non-Massacre Multitarget")
                        return
                    end
                end
            end
        end


        -- EXECUTE MASSACRE
        if not ((C_Covenants.GetActiveCovenantID()) == 2) then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if buff.whirlwind.exists("player") and br.getFacing("player",thisUnit) and cast.able.executeMassacre() and talent.massacre and br.getHP(thisUnit) <= 35 or buff.suddenDeath.exists("player") or rage <= 70) then
                    if cast.executeMassacre(thisUnit) then debug("Execute Massacre Multitarget")
                        return
                    end
                end
            end
        end
        -- Execute non-MASSACRE
        if not ((C_Covenants.GetActiveCovenantID()) == 2) then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if buff.whirlwind.exists("player") and br.getFacing("player",thisUnit) and cast.able.execute() and br.getHP(thisUnit) <= 20 or rage <= 70) then
                    if cast.execute(thisUnit) then debug("Execute non-Massacre Multitarget")
                        return
                    end
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
            if cast.ragingBlow() then debug("RB @ 2 stacks MT")
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
        --if br.isChecked("Bloodrage") and inCombat and IsSpellKnown(329038) and cast.able.bloodrage()then
        --    if cast.bloodrage("player") then
        --        return
        --    end
        --end
        --racials
        --Trinkets
        --local Trinket13 = br._G.GetInventoryItemID("player", 13)
        --local Trinket14 = br._G.GetInventoryItemID("player", 14)

       -- if (br._G.GetInventoryItemID("player", 13) == 178825 or br._G.GetInventoryItemID("player", 14) == 178825) and br.canUseItem(178825) and #enemies.yards8 > 0 then
        --    br.useItem(178825)
       -- end
        if br.getOptionValue("Trinkets") == 1 or (br.getOptionValue("Trinkets") == 2 and buff.recklessness.exists("player")) and inCombat and br.canUseItem(13) then
            if br.useItem(13) then debug("Using Trinket 1")
                return
            end
        end
        if br.getOptionValue("Trinkets") == 1 or (br.getOptionValue("Trinkets") == 2 and buff.recklessness.exists("player")) and inCombat and br.canUseItem(14) then
            if br.useItem(14) then debug("Using Trinket 2")
                return
            end
        end
        if br.isChecked("Racials") and br.player.ui.mode.cooldown ~= 4 then
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
    if br.pause(true) or (IsMounted() or IsFlying() or br._G.UnitOnTaxi("player") or br._G.UnitInVehicle("player")) or mode.rotation == 4 then
        return true
    else
        if extralist() then
            return
        end
        if inCombat and br.profileStop == false and not (IsMounted() or IsFlying()) and #enemies.yards5 >= 1 then
            if br.getDistance(units.dyn5) < 6 then
                br._G.StartAttack()
            end
            if br.isExplosive("target") then
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
            if ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) and level >= 40 then
                --print("multi")
                if multilist() then return end
            end
            if ((mode.rotation == 1 and #enemies.yards8 < 2) or (mode.rotation == 3 and #enemies.yards8 > 0)) then
                --print("single")
                if singlelist() then return end
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

-------------------------------------------------------
-- Author = CuteOne
-- Patch = 11.0.2
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 100%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Limited
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Basic
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --
-------------------------------------------------------

local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spells.cleave },
        [2] = { mode = "Mult", value = 2, overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spells.whirlwind },
        [3] = { mode = "Sing", value = 3, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spells.mortalStrike },
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.victoryRush }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.avatar },
        [2] = { mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spells.avatar },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.avatar }
    };
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.dieByTheSword },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.dieByTheSword }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spells.pummel },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.pummel }
    };
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
    -- Movement Button
    local MoverModes = {
        [1] = { mode = "On", value = 1, overlay = "Mover Enabled", tip = "Will use Charge/Heroic Leap.", highlight = 1, icon = br.player.spells.charge },
        [2] = { mode = "Off", value = 2, overlay = "Mover Disabled", tip = "Will NOT use Charge/Heroic Leap.", highlight = 0, icon = br.player.spells.charge }
    };
    br.ui:createToggle(MoverModes, "Mover", 5, 0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5,
            "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
        br.ui:createSpinner(section, "Pre-Pull Timer", 5, 1, 10, 1,
            "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Battle Cry
        br.ui:createCheckbox(section, "Battle Shout")
        -- Berserker Rage
        br.ui:createCheckbox(section, "Berserker Rage", "Check to use Berserker Rage")
        -- Charge
        br.ui:createCheckbox(section, "Charge", "Check to use Charge")
        -- Heroic Throw
        br.ui:createCheckbox(section, "Heroic Throw", "Check to use Heroic Throw out of range")
        -- Taunt
        br.ui:createCheckbox(section, "Solo Taunt", "Only uses Taunt when not in a group.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        local alwaysCdAoENever = { "Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never" }
        -- Racial
        br.ui:createDropdownWithout(section, "Racial", alwaysCdAoENever, 4, "|cffFFFFFFWhen to use Racial.")
        -- Avatar
        br.ui:createDropdownWithout(section, "Avatar", alwaysCdAoENever, 4, "|cffFFFFFFWhen to use Avatar.")
        -- Bladestorm
        br.ui:createDropdownWithout(section, "Bladestorm", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Bladestorm.")
        -- Champions Spear
        br.ui:createDropdownWithout(section, "Champion's Spear", alwaysCdAoENever, 3,
            "|cffFFFFFFWhen to use Champion's Spear.")
        -- Colossus Smash / Warbreaker
        br.ui:createDropdownWithout(section, "Colossus Smash / Warbreaker", alwaysCdAoENever, 4,
            "|cffFFFFFFWhen to use Colossus Smash / Warbreaker.")
        -- Demolish
        br.ui:createDropdownWithout(section, "Demolish", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Demolish.")
        -- Ravager
        br.ui:createDropdownWithout(section, "Ravager", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Ravager.")
        -- Thunderous Roar
        br.ui:createDropdownWithout(section, "Thunderous Roar", alwaysCdAoENever, 3,
            "|cffFFFFFFWhen to use Thunderous Roar.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        local defTooltip = "|cffFFBB00Health Percentage to use at."
        -- Defensive Stance
        br.ui:createSpinner(section, "Defensive Stance", 60, 0, 100, 5, defTooltip)
        -- Die By The Sword
        br.ui:createSpinner(section, "Die By The Sword", 60, 0, 100, 5, defTooltip)
        -- Ignore Pain
        br.ui:createSpinner(section, "Ignore Pain", 60, 0, 100, 5, defTooltip)
        -- Intimidating Shout
        br.ui:createSpinner(section, "Intimidating Shout", 60, 0, 100, 5, defTooltip)
        -- Rallying Cry
        br.ui:createSpinner(section, "Rallying Cry", 60, 0, 100, 5, defTooltip)
        -- Victory Rush
        br.ui:createSpinner(section, "Victory Rush", 60, 0, 100, 5, defTooltip)
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Pummel
        br.ui:createCheckbox(section, "Pummel")
        -- Intimidating Shout
        br.ui:createCheckbox(section, "Intimidating Shout - Int")
        -- Storm Bolt Logic
        br.ui:createCheckbox(section, "Storm Bolt Logic", "Stun specific Spells and Mobs")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "Interrupt At", 70, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.ui.dropOptions.Toggle, 4)
        --Cooldown Key Toggle
        br.ui:createDropdownWithout(section, "Cooldown Mode", br.ui.dropOptions.Toggle, 3)
        --Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.ui.dropOptions.Toggle, 6)
        -- Interrupts Key Toggle
        br.ui:createDropdownWithout(section, "Interrupt Mode", br.ui.dropOptions.Toggle, 6)
        -- Mover Toggle
        br.ui:createDropdownWithout(section, "Mover Mode", br.ui.dropOptions.Toggle, 6)
        -- Pause Toggle
        br.ui:createDropdown(section, "Pause Mode", br.ui.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions,
        } }
    return optionTable
end

--------------
--- Locals ---
--------------
-- BR API Locals
local buff
local cast
local cd
local charges
local debuff
local enemies
local equiped
local module
local race
local rage
local talent
local ui
local unit
local units
local var

--------------------
--- Action Lists ---
--------------------
local actionList = {}
-- Action List - Extras
actionList.Extras = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing")) * 60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Battle Shout
    if ui.checked("Battle Shout") and cast.able.battleShout() then
        for i = 1, #br.engines.healingEngine.friend do
            local thisUnit = br.engines.healingEngine.friend[i].unit
            if not unit.deadOrGhost(thisUnit) and unit.distance(thisUnit) < 100 and buff.battleShout.remain(thisUnit) < 600 then
                if cast.battleShout() then
                    ui.debug("Casting Battle Shout")
                    return true
                end
            end
        end
    end
    -- Berserker Rage
    if ui.checked("Berserker Rage") and cast.able.berserkerRage() and cast.noControl.berserkerRage() then
        if cast.berserkerRage() then
            ui.debug("Casting Berserker Rage")
            return true
        end
    end
    -- Piercing Howl
    if ui.checked("Piercing Howl") then
        for i = 1, #enemies.yards15 do
            local thisUnit = enemies.yards15[i]
            if cast.able.piercingHowl(thisUnit) and unit.moving(thisUnit) and not unit.facing(thisUnit, "player") and unit.distance(thisUnit) >= 5 then
                if cast.piercingHowl(thisUnit) then
                    ui.debug("Casting Piercing Howl")
                    return true
                end
            end
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        local useDefensive = function(op)
            return unit.inCombat() and unit.hp() <= ui.value(op)
        end
        -- Basic Healing Module
        module.BasicHealing()
        -- Defensive Stance
        if ui.checked("Defensive Stance") and cast.able.defensiveStance() then
            if useDefensive("Defensive Stance") and not buff.defensiveStance.exists() then
                if cast.defensiveStance() then
                    ui.debug("Casting Defensive Stance")
                    return
                end
            elseif buff.defensiveStance.exists() and unit.hp() > ui.value("Defensive Stance") then
                if cast.defensiveStance() then
                    ui.debug("Casting Defensive Stance")
                    return
                end
            end
        end
        -- Die By The Sword
        if ui.checked("Die By The Sword") and cast.able.dieByTheSword() and useDefensive("Die By The Sword") then
            if cast.dieByTheSword() then
                ui.debug("Casting Die By The Sword")
                return
            end
        end
        -- Ignore Pain
        if ui.checked("Ignore Pain") and cast.able.ignorePain() and useDefensive("Ignore Pain") and rage() >= 40 then
            if cast.ignorePain() then
                ui.debug("Casting Ignore Pain")
                return true
            end
        end
        -- Intimidating Shout
        if ui.checked("Intimidating Shout") and cast.able.intimidatingShout() and useDefensive("Intimidating Shout") then
            if cast.intimidatingShout() then
                ui.debug("Casting Intimidating Shout")
                return true
            end
        end
        -- Rallying Cry
        if ui.checked("Rallying Cry") and cast.able.rallyingCry() and useDefensive("Rallying Cry") then
            if cast.rallyingCry() then
                ui.debug("Casting Rallying Cry")
                return true
            end
        end
        -- Spell Reflection
        if ui.checked("Spell Reflection") and cast.able.spellReflection() and useDefensive("Spell Relection") then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (cast.timeRemain(thisUnit) < 5 or cast.inFlight.spellReflection(thisUnit)) then
                    if cast.spellReflection() then
                        ui.debug("Casting Spell Reflection")
                        return true
                    end
                end
            end
        end
        -- Storm Bolt
        if ui.checked("Storm Bolt") and cast.able.stormBolt() and useDefensive("Storm Bolt") then
            if cast.stormBolt() then
                ui.debug("Casting Storm Bolt")
                return true
            end
        end
        -- Victory Rush
        if ui.checked("Victory Rush") and (cast.able.victoryRush() or cast.able.impendingVictory())
            and unit.inCombat() and buff.victorious.exists()
        then
            for i = 1, #enemies.yards5f do
                local thisUnit = enemies.yards5f[i]
                if unit.hp() <= ui.value("Victory Rush") or buff.victorious.remain() < unit.gcd(true) or unit.ttd(thisUnit) < unit.gcd(true) then
                    if talent.impendingVictory then
                        if cast.impendingVictory(thisUnit) then
                            ui.debug("Casting Impending Victory")
                            return true
                        end
                    else
                        if cast.victoryRush(thisUnit) then
                            ui.debug("Casting Victory Rush")
                            return true
                        end
                    end
                end
            end
        end
    end -- End Defensive Check
end     -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards20 do
            local thisUnit = enemies.yards20[i]
            local distance = unit.distance(thisUnit)
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                -- Pummel
                if ui.checked("Pummel") and cast.able.pummel(thisUnit) and distance < 5 then
                    if cast.pummel(thisUnit) then
                        ui.debug("Casting Pummel")
                        return true
                    end
                end
                -- Intimidating Shout
                if ui.checked("Intimidating Shout - Int") and cast.able.intimidatingShout() and distance < 8 then
                    if cast.intimidatingShout() then
                        ui.debug("Casting Intimidating Shout [Int]")
                        return true
                    end
                end
                -- Storm Bolt
                if ui.checked("Storm Bolt - Int") and cast.able.stormBolt(thisUnit) and distance < 20 then
                    if cast.stormBolt(thisUnit) then
                        ui.debug("Casting Storm Bolt [Int]")
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - Interrupts

-- Action List - ColossusAoe
actionList.ColossusAoe = function()
    -- Cleave
    -- cleave,if=buff.collateral_damage.up&buff.merciless_bonegrinder.up
    if cast.able.cleave("player", "cone", 1, 8) and buff.collateralDamage.exists() and buff.mercilessBonegrinder.exists() then
        if cast.cleave("player", "cone", 1, 8) then
            ui.debug("Casting Cleave - Collateral Damage [Colossus Aoe]")
            return true
        end
    end
    -- Thunder Clap
    -- thunder_clap,if=!dot.rend.remains
    if cast.able.thunderClap("player", "aoe", 1, 8) and not debuff.rend.exists(units.dyn5) then
        if cast.thunderClap("player", "aoe", 1, 8) then
            ui.debug("Casting Thunder Clap - No Rend [Colossus Aoe]")
            return true
        end
    end
    -- Thunderous Roar
    -- thunderous_roar
    if ui.alwaysCdAoENever("Thunderous Roar") and cast.able.thunderousRoar("player", "aoe", 1, 12) then
        if cast.thunderousRoar() then
            ui.debug("Casting Thunderous Roar [Colossus Aoe]")
            return true
        end
    end
    -- Avatar
    -- avatar
    if ui.alwaysCdAoENever("Avatar") and cast.able.avatar() then
        if cast.avatar() then
            ui.debug("Casting Avatar [Colossus Aoe]")
            return true
        end
    end
    -- Ravager
    -- ravager
    if ui.alwaysCdAoENever("Ravager", 1, 8) and cast.able.ravager("target", "ground", 1, 8) then
        if cast.ravager("target", "ground") then
            ui.debug("Casting Ravager [Colossus Aoe]")
            return true
        end
    end
    -- Sweeping Strikes
    -- sweeping_strikes
    if cast.able.sweepingStrikes() then
        if cast.sweepingStrikes() then
            ui.debug("Casting Sweeping Strikes [Colossus Aoe]")
            return true
        end
    end
    -- Skullsplitter
    -- skullsplitter,if=buff.sweeping_strikes.up
    if cast.able.skullsplitter() and buff.sweepingStrikes.exists() then
        if cast.skullsplitter() then
            ui.debug("Casting Skullsplitter [Colossus Aoe]")
            return true
        end
    end
    -- Warbreaker
    -- warbreaker
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 8) and cast.able.warbreaker("player", "aoe", 1, 8) then
        if cast.warbreaker("player", "aoe", 1, 8) then
            ui.debug("Casting Warbreaker [Colossus Aoe]")
            return true
        end
    end
    -- Bladestorm
    -- bladestorm,if=talent.unhinged|talent.merciless_bonegrinder
    if ui.alwaysCdAoENever("Bladestorm", 3, 8) and cast.able.bladestorm("player", "aoe", 1, 8) and ((talent.unhinged or talent.mercilessBonegrinder)) then
        if cast.bladestorm("player", "aoe", 1, 8) then
            ui.debug("Casting Bladestorm - Unhinged/Merciless Bonegrinder [Colossus Aoe]")
            return true
        end
    end
    -- Champions Spear
    -- champions_spear
    if ui.alwaysCdAoENever("Champion's Spear", 3, 8) and cast.able.championsSpear("target", "ground", 1, 8) then
        if cast.championsSpear("target", "ground", 1, 8) then
            ui.debug("Casting Champions Spear [Colossus Aoe]")
            return true
        end
    end
    -- Colossus Smash
    -- colossus_smash
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 5) and cast.able.colossusSmash() then
        if cast.colossusSmash() then
            ui.debug("Casting Colossus Smash [Colossus Aoe]")
            return true
        end
    end
    -- Cleave
    -- cleave
    if cast.able.cleave("player", "cone", 1, 8) then
        if cast.cleave("player", "cone", 1, 8) then
            ui.debug("Casting Cleave [Colossus Aoe]")
            return true
        end
    end
    -- Demolish
    -- demolish,if=buff.sweeping_strikes.up
    if ui.alwaysCdAoENever("Demolish", 3, 8) and cast.able.demolish("player", "aoe", 1, 8) and buff.sweepingStrikes.exists() then
        if cast.demolish("player", "aoe", 1, 8) then
            ui.debug("Casting Demolish [Colossus Aoe]")
            return true
        end
    end
    -- Bladestorm
    -- bladestorm,if=talent.unhinged
    if ui.alwaysCdAoENever("Bladestorm", 3, 8) and cast.able.bladestorm("player", "aoe", 1, 8) and talent.unhinged then
        if cast.bladestorm("player", "aoe", 1, 8) then
            ui.debug("Casting Bladestorm - Unhinged [Colossus Aoe]")
            return true
        end
    end
    -- Overpower
    -- overpower
    if cast.able.overpower() then
        if cast.overpower() then
            ui.debug("Casting Overpower [Colossus Aoe]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike,if=buff.sweeping_strikes.up
    if cast.able.mortalStrike() and buff.sweepingStrikes.exists() then
        if cast.mortalStrike() then
            ui.debug("Casting Mortal Strike - Sweeping Strikes [Colossus Aoe]")
            return true
        end
    end
    -- Overpower
    -- overpower,if=buff.sweeping_strikes.up
    if cast.able.overpower() and buff.sweepingStrikes.exists() then
        if cast.overpower() then
            ui.debug("Casting Overpower - Sweeping Strikes [Colossus Aoe]")
            return true
        end
    end
    -- Execute
    -- execute,if=buff.sweeping_strikes.up
    if cast.able.execute() and buff.sweepingStrikes.exists() then
        if cast.execute() then
            ui.debug("Casting Execute - Sweeping Strikes [Colossus Aoe]")
            return true
        end
    end
    -- Thunder Clap
    -- thunder_clap
    if cast.able.thunderClap("player", "aoe", 1, 8) then
        if cast.thunderClap("player", "aoe", 1, 8) then
            ui.debug("Casting Thunder Clap [Colossus Aoe]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike
    if cast.able.mortalStrike() then
        if cast.mortalStrike() then
            ui.debug("Casting Mortal Strike [Colossus Aoe]")
            return true
        end
    end
    -- Execute
    -- execute
    if cast.able.execute() then
        if cast.execute() then
            ui.debug("Casting Execute [Colossus Aoe]")
            return true
        end
    end
    -- Bladestorm
    -- bladestorm
    if ui.alwaysCdAoENever("Bladestorm", 3, 8) and cast.able.bladestorm("player", "aoe", 1, 8) then
        if cast.bladestorm("player", "aoe", 1, 8) then
            ui.debug("Casting Bladestorm [Colossus Aoe]")
            return true
        end
    end
    -- Whirlwind
    -- whirlwind
    if cast.able.whirlwind("player", "aoe", 1, 8) then
        if cast.whirlwind("player", "aoe", 1, 8) then
            ui.debug("Casting Whirlwind [Colossus Aoe]")
            return true
        end
    end
end -- End Action List - ColossusAoe

-- Action List - ColossusExecute
actionList.ColossusExecute = function()
    -- Sweeping Strikes
    -- sweeping_strikes,if=active_enemies=2
    if cast.able.sweepingStrikes() and #enemies.yards5f == 2 then
        if cast.sweepingStrikes() then
            ui.debug("Casting Sweeping Strikes [Colossus Execute]")
            return true
        end
    end
    -- Rend
    -- rend,if=dot.rend.remains<=gcd&!talent.bloodletting
    if cast.able.rend(var.minHpUnit) and debuff.rend.remains(units.dyn5) <= unit.gcd(true) and not talent.bloodletting then
        if cast.rend(var.minHpUnit) then
            ui.debug("Casting Rend [Colossus Execute]")
            return true
        end
    end
    -- Thunderous Roar
    -- thunderous_roar
    if ui.alwaysCdAoENever("Thunderous Roar") and cast.able.thunderousRoar("player", "aoe", 1, 12) then
        if cast.thunderousRoar("player", "aoe", 1, 12) then
            ui.debug("Casting Thunderous Roar [Colossus Execute]")
            return true
        end
    end
    -- Champions Spear
    -- champions_spear
    if ui.alwaysCdAoENever("Champion's Spear", 3, 8) and cast.able.championsSpear(var.minHpUnit, "ground", 1, 8) then
        if cast.championsSpear(var.minHpUnit, "ground", 1, 8) then
            ui.debug("Casting Champions Spear [Colossus Execute]")
            return true
        end
    end
    -- Ravager
    -- ravager,if=cooldown.colossus_smash.remains<=gcd
    if ui.alwaysCdAoENever("Ravager", 1, 8) and cast.able.ravager(var.minHpUnit, "ground", 1, 8) and cd.colossusSmash.remains() <= unit.gcd(true) then
        if cast.ravager(var.minHpUnit, "ground", 1, 8) then
            ui.debug("Casting Ravager [Colossus Execute]")
            return true
        end
    end
    -- Avatar
    -- avatar
    if ui.alwaysCdAoENever("Avatar") and cast.able.avatar() then
        if cast.avatar() then
            ui.debug("Casting Avatar [Colossus Execute]")
            return true
        end
    end
    -- Colossus Smash
    -- colossus_smash
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 5) and cast.able.colossusSmash(var.minHpUnit) then
        if cast.colossusSmash(var.minHpUnit) then
            ui.debug("Casting Colossus Smash [Colossus Execute]")
            return true
        end
    end
    -- Warbreaker
    -- warbreaker
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 8) and cast.able.warbreaker("player", "aoe", 1, 8) then
        if cast.warbreaker("player", "aoe", 1, 8) then
            ui.debug("Casting Warbreaker [Colossus Execute]")
            return true
        end
    end
    -- Demolish
    -- demolish,if=debuff.colossus_smash.up
    if ui.alwaysCdAoENever("Demolish", 3, 8) and cast.able.demolish("player", "aoe", 1, 8) and debuff.colossusSmash.exists(var.minHpUnit) then
        if cast.demolish("player", "aoe", 1, 8) then
            ui.debug("Casting Demolish [Colossus Execute]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike,if=debuff.executioners_precision.stack=2&!dot.ravager.remains&(buff.lethal_blows.stack=2|!set_bonus.tww1_4pc)
    if cast.able.mortalStrike(var.minHpUnit) and ((debuff.executionersPrecision.count(var.minHpUnit) == 2 and not debuff.ravager.remains(units.dyn5)
            and (buff.lethalBlows.stack() == 2 or not equiped.tier("TWW1", 4))))
    then
        if cast.mortalStrike(var.minHpUnit) then
            ui.debug("Casting Mortal Strike - Executioner's Precision [Colossus Execute]")
            return true
        end
    end
    -- Execute
    -- execute,if=rage>=40
    if cast.able.execute(var.minHpUnit) and rage() >= 40 then
        if cast.execute(var.minHpUnit) then
            ui.debug("Casting Execute - High Rage [Colossus Execute]")
            return true
        end
    end
    -- Skullsplitter
    -- skullsplitter
    if cast.able.skullsplitter(var.minHpUnit) then
        if cast.skullsplitter(var.minHpUnit) then
            ui.debug("Casting Skullsplitter [Colossus Execute]")
            return true
        end
    end
    -- Overpower
    -- overpower
    if cast.able.overpower(var.minHpUnit) then
        if cast.overpower(var.minHpUnit) then
            ui.debug("Casting Overpower [Colossus Execute]")
            return true
        end
    end
    -- Bladestorm
    -- bladestorm
    if ui.alwaysCdAoENever("Bladestorm", 3, 8) and cast.able.bladestorm("player", "aoe", 1, 8) then
        if cast.bladestorm("player", "aoe", 1, 8) then
            ui.debug("Casting Bladestorm [Colossus Execute]")
            return true
        end
    end
    -- Execute
    -- execute
    if cast.able.execute(var.minHpUnit) then
        if cast.execute(var.minHpUnit) then
            ui.debug("Casting Execute [Colossus Execute]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike
    if cast.able.mortalStrike(var.minHpUnit) then
        if cast.mortalStrike(var.minHpUnit) then
            ui.debug("Casting Mortal Strike [Colossus Execute]")
            return true
        end
    end
end -- End Action List - ColossusExecute

-- Action List - ColossusSt
actionList.ColossusSt = function()
    -- Rend
    -- rend,if=dot.rend.remains<=gcd
    if cast.able.rend() and debuff.rend.remains(units.dyn5) <= unit.gcd(true) then
        if cast.rend() then
            ui.debug("Casting Rend - Reapply Now [Colossus St]")
            return true
        end
    end
    -- Thunderous Roar
    -- thunderous_roar
    if ui.alwaysCdAoENever("Thunderous Roar") and cast.able.thunderousRoar("player", "aoe", 1, 12) then
        if cast.thunderousRoar("player", "aoe", 1, 12) then
            ui.debug("Casting Thunderous Roar [Colossus St]")
            return true
        end
    end
    -- Champions Spear
    -- champions_spear
    if ui.alwaysCdAoENever("Champion's Spear", 3, 8) and cast.able.championsSpear("target", "ground", 1, 8) then
        if cast.championsSpear("target", "ground", 1, 8) then
            ui.debug("Casting Champions Spear [Colossus St]")
            return true
        end
    end
    -- Ravager
    -- ravager,if=cooldown.colossus_smash.remains<=gcd
    if ui.alwaysCdAoENever("Ravager", 1, 8) and cast.able.ravager("target", "ground", 1, 8) and cd.colossusSmash.remains() <= unit.gcd(true) then
        if cast.ravager("target", "ground", 1, 8) then
            ui.debug("Casting Ravager [Colossus St]")
            return true
        end
    end
    -- Avatar
    -- avatar,if=raid_event.adds.in>15
    if ui.alwaysCdAoENever("Avatar") and cast.able.avatar() then
        if cast.avatar() then
            ui.debug("Casting Avatar [Colossus St]")
            return true
        end
    end
    -- Colossus Smash
    -- colossus_smash
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 5) and cast.able.colossusSmash() then
        if cast.colossusSmash() then
            ui.debug("Casting Colossus Smash [Colossus St]")
            return true
        end
    end
    -- Warbreaker
    -- warbreaker
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 8) and cast.able.warbreaker("player", "aoe", 1, 8) then
        if cast.warbreaker("player", "aoe", 1, 8) then
            ui.debug("Casting Warbreaker [Colossus St]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike
    if cast.able.mortalStrike() then
        if cast.mortalStrike() then
            ui.debug("Casting Mortal Strike [Colossus St]")
            return true
        end
    end
    -- Demolish
    -- demolish
    if ui.alwaysCdAoENever("Demolish", 3, 8) and cast.able.demolish("player", "aoe", 1, 8) then
        if cast.demolish("player", "aoe", 1, 8) then
            ui.debug("Casting Demolish [Colossus St]")
            return true
        end
    end
    -- Skullsplitter
    -- skullsplitter
    if cast.able.skullsplitter() then
        if cast.skullsplitter() then
            ui.debug("Casting Skullsplitter [Colossus St]")
            return true
        end
    end
    -- Overpower
    -- overpower,if=charges=2
    if cast.able.overpower() and charges == 2 then
        if cast.overpower() then
            ui.debug("Casting Overpower - Max Charges [Colossus St]")
            return true
        end
    end
    -- Execute
    -- execute
    if cast.able.execute() then
        if cast.execute() then
            ui.debug("Casting Execute [Colossus St]")
            return true
        end
    end
    -- Overpower
    -- overpower
    if cast.able.overpower() then
        if cast.overpower() then
            ui.debug("Casting Overpower [Colossus St]")
            return true
        end
    end
    -- Rend
    -- rend,if=dot.rend.remains<=gcd*5
    if cast.able.rend() and debuff.rend.remains(units.dyn5) <= unit.gcd() * 5 then
        if cast.rend() then
            ui.debug("Casting Rend [Colossus St]")
            return true
        end
    end
    -- Slam
    -- slam
    if cast.able.slam() then
        if cast.slam() then
            ui.debug("Casting Slam [Colossus St]")
            return true
        end
    end
end -- End Action List - ColossusSt

-- Action List - ColossusSweep
actionList.ColossusSweep = function()
    -- Sweeping Strikes
    -- sweeping_strikes
    if cast.able.sweepingStrikes() then
        if cast.sweepingStrikes() then
            ui.debug("Casting Sweeping Strikes [Colossus Sweep]")
            return true
        end
    end
    -- Rend
    -- rend,if=dot.rend.remains<=gcd&buff.sweeping_strikes.up
    if cast.able.rend() and debuff.rend.remains(units.dyn5) <= unit.gcd(true) and buff.sweepingStrikes.exists() then
        if cast.rend() then
            ui.debug("Casting Rend - Sweeping Strikes [Colossus Sweep]")
            return true
        end
    end
    -- Thunderous Roar
    -- thunderous_roar
    if ui.alwaysCdAoENever("Thunderous Roar") and cast.able.thunderousRoar("player", "aoe", 1, 12) then
        if cast.thunderousRoar("player", "aoe", 1, 12) then
            ui.debug("Casting Thunderous Roar [Colossus Sweep]")
            return true
        end
    end
    -- Champions Spear
    -- champions_spear
    if ui.alwaysCdAoENever("Champion's Spear", 3, 8) and cast.able.championsSpear("target", "ground", 1, 8) then
        if cast.championsSpear("target", "ground", 1, 8) then
            ui.debug("Casting Champions Spear [Colossus Sweep]")
            return true
        end
    end
    -- Ravager
    -- ravager,if=cooldown.colossus_smash.ready
    if ui.alwaysCdAoENever("Ravager", 1, 8) and cast.able.ravager("target", "ground", 1, 8) and not cd.colossusSmash.exists() then
        if cast.ravager("target", "ground", 1, 8) then
            ui.debug("Casting Ravager [Colossus Sweep]")
            return true
        end
    end
    -- Avatar
    -- avatar
    if ui.alwaysCdAoENever("Avatar") and cast.able.avatar() then
        if cast.avatar() then
            ui.debug("Casting Avatar [Colossus Sweep]")
            return true
        end
    end
    -- Colossus Smash
    -- colossus_smash
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 5) and cast.able.colossusSmash() then
        if cast.colossusSmash() then
            ui.debug("Casting Colossus Smash [Colossus Sweep]")
            return true
        end
    end
    -- Warbreaker
    -- warbreaker
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 8) and cast.able.warbreaker("player", "aoe", 1, 8) then
        if cast.warbreaker("player", "aoe", 1, 8) then
            ui.debug("Casting Warbreaker [Colossus Sweep]")
            return true
        end
    end
    -- Overpower
    -- overpower,if=action.overpower.charges=2&talent.dreadnaught|buff.sweeping_strikes.up
    if cast.able.overpower() and ((charges.overpower.count() == 2 and talent.dreadnaught or buff.sweepingStrikes.exists())) then
        if cast.overpower() then
            ui.debug("Casting Overpower - Max Charges Dreadnaught / Sweeping Strikes [Colossus Sweep]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike,if=buff.sweeping_strikes.up
    if cast.able.mortalStrike() and buff.sweepingStrikes.exists() then
        if cast.mortalStrike() then
            ui.debug("Casting Mortal Strike - Sweeping Strikes [Colossus Sweep]")
            return true
        end
    end
    -- Skullsplitter
    -- skullsplitter,if=buff.sweeping_strikes.up
    if cast.able.skullsplitter() and buff.sweepingStrikes.exists() then
        if cast.skullsplitter() then
            ui.debug("Casting Skullsplitter [Colossus Sweep]")
            return true
        end
    end
    -- Demolish
    -- demolish,if=buff.sweeping_strikes.up&debuff.colossus_smash.up
    if ui.alwaysCdAoENever("Demolish", 3, 8) and cast.able.demolish("player", "aoe", 1, 8) and buff.sweepingStrikes.exists() and debuff.colossusSmash.exists(units.dyn5) then
        if cast.demolish("player", "aoe", 1, 8) then
            ui.debug("Casting Demolish - Sweeping Strikes [Colossus Sweep]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike,if=buff.sweeping_strikes.down
    if cast.able.mortalStrike() and not buff.sweepingStrikes.exists() then
        if cast.mortalStrike() then
            ui.debug("Casting Mortal Strike [Colossus Sweep]")
            return true
        end
    end
    -- Demolish
    -- demolish,if=buff.avatar.up|debuff.colossus_smash.up&cooldown.avatar.remains>=35
    if ui.alwaysCdAoENever("Demolish", 3, 8) and cast.able.demolish("player", "aoe", 1, 8) and ((buff.avatar.exists() or debuff.colossusSmash.exists(units.dyn5) and cd.avatar.remains() >= 35)) then
        if cast.demolish("player", "aoe", 1, 8) then
            ui.debug("Casting Demolish [Colossus Sweep]")
            return true
        end
    end
    -- Execute
    -- execute,if=buff.recklessness_warlords_torment.up|buff.sweeping_strikes.up
    if cast.able.execute() and ((buff.recklessness.exists() or buff.sweepingStrikes.exists())) then
        if cast.execute() then
            ui.debug("Casting Execute - Recklessness/Sweeping Strikes [Colossus Sweep]")
            return true
        end
    end
    -- Overpower
    -- overpower,if=charges=2|buff.sweeping_strikes.up
    if cast.able.overpower() and ((charges == 2 or buff.sweepingStrikes.exists())) then
        if cast.overpower() then
            ui.debug("Casting Overpower [Colossus Sweep]")
            return true
        end
    end
    -- Execute
    -- execute
    if cast.able.execute() then
        if cast.execute() then
            ui.debug("Casting Execute [Colossus Sweep]")
            return true
        end
    end
    -- Thunder Clap
    -- thunder_clap,if=dot.rend.remains<=8&buff.sweeping_strikes.down
    if cast.able.thunderClap("player", "aoe", 1, 8) and debuff.rend.remains(units.dyn5) <= 8 and not buff.sweepingStrikes.exists() then
        if cast.thunderClap("player", "aoe", 1, 8) then
            ui.debug("Casting Thunder Clap [Colossus Sweep]")
            return true
        end
    end
    -- Rend
    -- rend,if=dot.rend.remains<=5
    if cast.able.rend() and debuff.rend.remains(units.dyn5) <= 5 then
        if cast.rend() then
            ui.debug("Casting Rend [Colossus Sweep]")
            return true
        end
    end
    -- Cleave
    -- cleave,if=talent.fervor_of_battle
    if cast.able.cleave("player", "cone", 1, 8) and talent.fervorOfBattle then
        if cast.cleave("player", "cone", 1, 8) then
            ui.debug("Casting Cleave [Colossus Sweep]")
            return true
        end
    end
    -- Whirlwind
    -- whirlwind,if=talent.fervor_of_battle
    if cast.able.whirlwind("player", "aoe", 1, 8) and talent.fervorOfBattle then
        if cast.whirlwind("player", "aoe", 1, 8) then
            ui.debug("Casting Whirlwind [Colossus Sweep]")
            return true
        end
    end
    -- Slam
    -- slam
    if cast.able.slam() then
        if cast.slam() then
            ui.debug("Casting Slam [Colossus Sweep]")
            return true
        end
    end
end -- End Action List - ColossusSweep

-- Action List - SlayerAoe
actionList.SlayerAoe = function()
    -- Thunder Clap
    -- thunder_clap,if=!dot.rend.remains
    if cast.able.thunderClap("player", "aoe", 1, 8) and not debuff.rend.exists(units.dyn5) then
        if cast.thunderClap("player", "aoe", 1, 8) then
            ui.debug("Casting Thunder Clap - No Rend [Slayer Aoe]")
            return true
        end
    end
    -- Sweeping Strikes
    -- sweeping_strikes
    if cast.able.sweepingStrikes() then
        if cast.sweepingStrikes() then
            ui.debug("Casting Sweeping Strikes [Slayer Aoe]")
            return true
        end
    end
    -- Thunderous Roar
    -- thunderous_roar
    if ui.alwaysCdAoENever("Thunderous Roar") and cast.able.thunderousRoar("player", "aoe", 1, 12) then
        if cast.thunderousRoar("player", "aoe", 1, 12) then
            ui.debug("Casting Thunderous Roar [Slayer Aoe]")
            return true
        end
    end
    -- Avatar
    -- avatar
    if ui.alwaysCdAoENever("Avatar") and cast.able.avatar() then
        if cast.avatar() then
            ui.debug("Casting Avatar [Slayer Aoe]")
            return true
        end
    end
    -- Champions Spear
    -- champions_spear
    if ui.alwaysCdAoENever("Champion's Spear", 3, 8) and cast.able.championsSpear("target", "ground", 1, 8) then
        if cast.championsSpear("target", "ground", 1, 8) then
            ui.debug("Casting Champions Spear [Slayer Aoe]")
            return true
        end
    end
    -- Warbreaker
    -- warbreaker
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 8) and cast.able.warbreaker("player", "aoe", 1, 8) then
        if cast.warbreaker("player", "aoe", 1, 8) then
            ui.debug("Casting Warbreaker [Slayer Aoe]")
            return true
        end
    end
    -- Colossus Smash
    -- colossus_smash
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 5) and cast.able.colossusSmash() then
        if cast.colossusSmash() then
            ui.debug("Casting Colossus Smash [Slayer Aoe]")
            return true
        end
    end
    -- Cleave
    -- cleave
    if cast.able.cleave("player", "cone", 1, 8) then
        if cast.cleave("player", "cone", 1, 8) then
            ui.debug("Casting Cleave [Slayer Aoe]")
            return true
        end
    end
    -- Overpower
    -- overpower,if=buff.sweeping_strikes.up
    if cast.able.overpower() and buff.sweepingStrikes.exists() then
        if cast.overpower() then
            ui.debug("Casting Overpower - Sweeping Strikes [Slayer Aoe]")
            return true
        end
    end
    -- Execute
    -- execute,if=buff.sudden_death.up&buff.imminent_demise.stack<3
    if cast.able.execute() and buff.suddenDeath.exists() and buff.imminentDemise.stack() < 3 then
        if cast.execute() then
            ui.debug("Casting Execute - Sudden Death [Slayer Aoe]")
            return true
        end
    end
    -- Bladestorm
    -- bladestorm
    if ui.alwaysCdAoENever("Bladestorm", 3, 8) and cast.able.bladestorm("player", "aoe", 1, 8) then
        if cast.bladestorm("player", "aoe", 1, 8) then
            ui.debug("Casting Bladestorm [Slayer Aoe]")
            return true
        end
    end
    -- Skullsplitter
    -- skullsplitter,if=buff.sweeping_strikes.up
    if cast.able.skullsplitter() and buff.sweepingStrikes.exists() then
        if cast.skullsplitter() then
            ui.debug("Casting Skullsplitter [Slayer Aoe]")
            return true
        end
    end
    -- Execute
    -- execute,if=buff.sweeping_strikes.up&debuff.executioners_precision.stack<2
    if cast.able.execute() and buff.sweepingStrikes.exists() and debuff.executionersPrecision.count(units.dyn5) < 2 then
        if cast.execute() then
            ui.debug("Casting Execute - Sweeping Strikes [Slayer Aoe]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike,if=buff.sweeping_strikes.up&debuff.executioners_precision.stack=2
    if cast.able.mortalStrike() and buff.sweepingStrikes.exists() and debuff.executionersPrecision.count(units.dyn5) == 2 then
        if cast.mortalStrike() then
            ui.debug("Casting Mortal Strike - Executioner's Precision [Slayer Aoe]")
            return true
        end
    end
    -- Execute
    -- execute,if=debuff.marked_for_execution.up
    if cast.able.execute() and debuff.markedForExecution.exists(units.dyn5) then
        if cast.execute() then
            ui.debug("Casting Execute - Marked for Execution [Slayer Aoe]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike,if=buff.sweeping_strikes.up
    if cast.able.mortalStrike() and buff.sweepingStrikes.exists() then
        if cast.mortalStrike() then
            ui.debug("Casting Mortal Strike - Sweeping Strikes [Slayer Aoe]")
            return true
        end
    end
    -- Overpower
    -- overpower,if=talent.dreadnaught
    if cast.able.overpower() and talent.dreadnaught then
        if cast.overpower() then
            ui.debug("Casting Overpower - Dreadnaught [Slayer Aoe]")
            return true
        end
    end
    -- Thunder Clap
    -- thunder_clap
    if cast.able.thunderClap("player", "aoe", 1, 8) then
        if cast.thunderClap("player", "aoe", 1, 8) then
            ui.debug("Casting Thunder Clap [Slayer Aoe]")
            return true
        end
    end
    -- Overpower
    -- overpower
    if cast.able.overpower() then
        if cast.overpower() then
            ui.debug("Casting Overpower [Slayer Aoe]")
            return true
        end
    end
    -- Execute
    -- execute
    if cast.able.execute() then
        if cast.execute() then
            ui.debug("Casting Execute [Slayer Aoe]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike
    if cast.able.mortalStrike() then
        if cast.mortalStrike() then
            ui.debug("Casting Mortal Strike [Slayer Aoe]")
            return true
        end
    end
    -- Whirlwind
    -- whirlwind
    if cast.able.whirlwind("player", "aoe", 1, 8) then
        if cast.whirlwind("player", "aoe", 1, 8) then
            ui.debug("Casting Whirlwind [Slayer Aoe]")
            return true
        end
    end
    -- Skullsplitter
    -- skullsplitter
    if cast.able.skullsplitter() then
        if cast.skullsplitter() then
            ui.debug("Casting Skullsplitter [Slayer Aoe]")
            return true
        end
    end
    -- Slam
    -- slam
    if cast.able.slam() then
        if cast.slam() then
            ui.debug("Casting Slam [Slayer Aoe]")
            return true
        end
    end
    -- Storm Bolt
    -- storm_bolt,if=buff.bladestorm.up
    if cast.able.stormBolt() and buff.bladestorm.exists() then
        if cast.stormBolt() then
            ui.debug("Casting Storm Bolt [Slayer Aoe]")
            return true
        end
    end
end -- End Action List - SlayerAoe

-- Action List - SlayerSt
actionList.SlayerSt = function()
    -- Rend
    -- rend,if=dot.rend.remains<=gcd
    if cast.able.rend() and debuff.rend.remains(units.dyn5) <= unit.gcd(true) then
        if cast.rend() then
            ui.debug("Casting Rend - Reapply Now [Slayer St]")
            return true
        end
    end
    -- Thunderous Roar
    -- thunderous_roar
    if ui.alwaysCdAoENever("Thunderous Roar") and cast.able.thunderousRoar("player", "aoe", 1, 12) then
        if cast.thunderousRoar("player", "aoe", 1, 8) then
            ui.debug("Casting Thunderous Roar [Slayer St]")
            return true
        end
    end
    -- Champions Spear
    -- champions_spear
    if ui.alwaysCdAoENever("Champion's Spear", 3, 8) and cast.able.championsSpear("target", "ground", 1, 8) then
        if cast.championsSpear("target", "ground", 1, 8) then
            ui.debug("Casting Champions Spear [Slayer St]")
            return true
        end
    end
    -- Avatar
    -- avatar,if=cooldown.colossus_smash.remains<=5|debuff.colossus_smash.up
    if ui.alwaysCdAoENever("Avatar") and cast.able.avatar() and ((cd.colossusSmash.remains() <= 5 or debuff.colossusSmash.exists(units.dyn5))) then
        if cast.avatar() then
            ui.debug("Casting Avatar [Slayer St]")
            return true
        end
    end
    -- Colossus Smash
    -- colossus_smash
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 5) and cast.able.colossusSmash() then
        if cast.colossusSmash() then
            ui.debug("Casting Colossus Smash [Slayer St]")
            return true
        end
    end
    -- Warbreaker
    -- warbreaker
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 8) and cast.able.warbreaker("player", "aoe", 1, 8) then
        if cast.warbreaker("player", "aoe", 1, 8) then
            ui.debug("Casting Warbreaker [Slayer St]")
            return true
        end
    end
    -- Execute
    -- execute,if=debuff.marked_for_execution.stack=3|buff.juggernaut.remains<=gcd*3|buff.sudden_death.stack=2
    if cast.able.execute() and ((debuff.markedForExecution.count(units.dyn5) == 3 or (buff.juggernaut.exists() and buff.juggernaut.remains() <= unit.gcd(true) * 3) or buff.suddenDeath.stack() == 2)) then
        if cast.execute() then
            ui.debug("Casting Execute [Slayer St]")
            return true
        end
    end
    -- Bladestorm
    -- bladestorm,if=cooldown.colossus_smash.remains>=gcd*4|buff.colossus_smash.remains>=gcd*4
    if ui.alwaysCdAoENever("Bladestorm", 3, 8) and cast.able.bladestorm("player", "aoe", 1, 8) and ((cd.colossusSmash.remains() >= unit.gcd(true) * 4 or debuff.colossusSmash.remains(units.dyn5) >= unit.gcd(true) * 4)) then
        if cast.bladestorm("player", "aoe", 1, 8) then
            ui.debug("Casting Bladestorm [Slayer St]")
            return true
        end
    end
    -- Overpower
    -- overpower,if=buff.opportunist.up
    if cast.able.overpower() and buff.opportunist.exists() then
        if cast.overpower() then
            ui.debug("Casting Overpower - Opportunist [Slayer St]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike
    if cast.able.mortalStrike() then
        if cast.mortalStrike() then
            ui.debug("Casting Mortal Strike [Slayer St]")
            return true
        end
    end
    -- Skullsplitter
    -- skullsplitter
    if cast.able.skullsplitter() then
        if cast.skullsplitter() then
            ui.debug("Casting Skullsplitter [Slayer St]")
            return true
        end
    end
    -- Overpower
    -- overpower
    if cast.able.overpower() then
        if cast.overpower() then
            ui.debug("Casting Overpower [Slayer St]")
            return true
        end
    end
    -- Rend
    -- rend,if=dot.rend.remains<=gcd*5
    if cast.able.rend() and debuff.rend.remains(units.dyn5) <= unit.gcd(true) * 5 then
        if cast.rend() then
            ui.debug("Casting Rend [Slayer St]")
            return true
        end
    end
    -- Cleave
    -- cleave,if=buff.martial_prowess.down
    if cast.able.cleave("player", "cone", 1, 8) and not buff.overpower.exists() then
        if cast.cleave("player", "cone", 1, 8) then
            ui.debug("Casting Cleave [Slayer St]")
            return true
        end
    end
    -- Slam
    -- slam
    if cast.able.slam() then
        if cast.slam() then
            ui.debug("Casting Slam [Slayer St]")
            return true
        end
    end
    -- Storm Bolt
    -- storm_bolt,if=buff.bladestorm.up
    if cast.able.stormBolt() and buff.bladestorm.exists() then
        if cast.stormBolt() then
            ui.debug("Casting Storm Bolt [Slayer St]")
            return true
        end
    end
end -- End Action List - SlayerSt

-- Action List - SlayerExecute
actionList.SlayerExecute = function()
    -- Sweeping Strikes
    -- sweeping_strikes,if=active_enemies=2
    if cast.able.sweepingStrikes() and #enemies.yards5f == 2 then
        if cast.sweepingStrikes() then
            ui.debug("Casting Sweeping Strikes [Slayer Execute]")
            return true
        end
    end
    -- Rend
    -- rend,if=dot.rend.remains<=gcd&!talent.bloodletting
    if cast.able.rend(var.minHpUnit) and debuff.rend.remains(var.minHpUnit) <= unit.gcd(true) and not talent.bloodletting then
        if cast.rend(var.minHpUnit) then
            ui.debug("Casting Rend [Slayer Execute]")
            return true
        end
    end
    -- Thunderous Roar
    -- thunderous_roar
    if ui.alwaysCdAoENever("Thunderous Roar") and cast.able.thunderousRoar("player", "aoe", 1, 12) then
        if cast.thunderousRoar("player", "aoe", 1, 12) then
            ui.debug("Casting Thunderous Roar [Slayer Execute]")
            return true
        end
    end
    -- Champions Spear
    -- champions_spear
    if ui.alwaysCdAoENever("Champion's Spear", 3, 8) and cast.able.championsSpear(var.minHpUnit, "ground", 1, 8) then
        if cast.championsSpear(var.minHpUnit, "ground", 1, 8) then
            ui.debug("Casting Champions Spear [Slayer Execute]")
            return true
        end
    end
    -- Avatar
    -- avatar,if=cooldown.colossus_smash.remains<=5|debuff.colossus_smash.up
    if ui.alwaysCdAoENever("Avatar") and cast.able.avatar() and ((cd.colossusSmash.remains() <= 5 or debuff.colossusSmash.exists(var.minHpUnit))) then
        if cast.avatar() then
            ui.debug("Casting Avatar [Slayer Execute]")
            return true
        end
    end
    -- Warbreaker
    -- warbreaker
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 8) and cast.able.warbreaker("player", "aoe", 1, 8) then
        if cast.warbreaker("player", "aoe", 1, 8) then
            ui.debug("Casting Warbreaker [Slayer Execute]")
            return true
        end
    end
    -- Colossus Smash
    -- colossus_smash
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 5) and cast.able.colossusSmash(var.minHpUnit) then
        if cast.colossusSmash(var.minHpUnit) then
            ui.debug("Casting Colossus Smash [Slayer Execute]")
            return true
        end
    end
    -- Execute
    -- execute,if=buff.juggernaut.remains<=gcd
    if cast.able.execute(var.minHpUnit) and buff.juggernaut.remains() <= unit.gcd(true) then
        if cast.execute(var.minHpUnit) then
            ui.debug("Casting Execute - Juggernaut [Slayer Execute]")
            return true
        end
    end
    -- Bladestorm
    -- bladestorm,if=debuff.executioners_precision.stack=2&debuff.colossus_smash.remains>4|debuff.executioners_precision.stack=2&cooldown.colossus_smash.remains>15|!talent.executioners_precision
    if ui.alwaysCdAoENever("Bladestorm", 3, 8) and cast.able.bladestorm("player", "aoe", 1, 8) and ((debuff.executionersPrecision.count(units.dyn5) == 2
            and debuff.colossusSmash.remains(units.dyn5) > 4 or debuff.executionersPrecision.count(units.dyn5) == 2
            and cd.colossusSmash.remains() > 15 or not talent.executionersPrecision))
    then
        if cast.bladestorm("player", "aoe", 1, 8) then
            ui.debug("Casting Bladestorm [Slayer Execute]")
            return true
        end
    end
    -- Skullsplitter
    -- skullsplitter,if=rage<85
    if cast.able.skullsplitter(var.minHpUnit) and rage() < 85 then
        if cast.skullsplitter(var.minHpUnit) then
            ui.debug("Casting Skullsplitter [Slayer Execute]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike,if=dot.rend.remains<2|(debuff.executioners_precision.stack=2&buff.lethal_blows.stack=2)
    if cast.able.mortalStrike(var.minHpUnit) and ((debuff.rend.remains(var.minHpUnit) < 2 or (debuff.executionersPrecision.count(var.minHpUnit) == 2
            and buff.lethalBlows.stack() == 2)))
    then
        if cast.mortalStrike(var.minHpUnit) then
            ui.debug("Casting Mortal Strike - No Rend Soon / Lethal Blows [Slayer Execute]")
            return true
        end
    end
    -- Overpower
    -- overpower,if=buff.opportunist.up&rage<80&buff.martial_prowess.stack<2
    if cast.able.overpower(var.minHpUnit) and buff.opportunist.exists() and rage() < 80 and buff.overpower.stack() < 2 then
        if cast.overpower(var.minHpUnit) then
            ui.debug("Casting Overpower - Opportunist [Slayer Execute]")
            return true
        end
    end
    -- Execute
    -- execute
    if cast.able.execute(var.minHpUnit) then
        if cast.execute(var.minHpUnit) then
            ui.debug("Casting Execute [Slayer Execute]")
            return true
        end
    end
    -- Overpower
    -- overpower
    if cast.able.overpower(var.minHpUnit) then
        if cast.overpower(var.minHpUnit) then
            ui.debug("Casting Overpower [Slayer Execute]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike,if=!talent.executioners_precision
    if cast.able.mortalStrike(var.minHpUnit) and not talent.executionersPrecision then
        if cast.mortalStrike(var.minHpUnit) then
            ui.debug("Casting Mortal Strike [Slayer Execute]")
            return true
        end
    end
    -- Storm Bolt
    -- storm_bolt,if=buff.bladestorm.up
    if cast.able.stormBolt(var.minHpUnit) and buff.bladestorm.exists() then
        if cast.stormBolt(var.minHpUnit) then
            ui.debug("Casting Storm Bolt [Slayer Execute]")
            return true
        end
    end
end -- End Action List - SlayerExecute

-- Action List - SlayerSweep
actionList.SlayerSweep = function()
    -- Thunderous Roar
    -- thunderous_roar
    if ui.alwaysCdAoENever("Thunderous Roar") and cast.able.thunderousRoar("player", "aoe", 1, 12) then
        if cast.thunderousRoar("player", "aoe", 1, 12) then
            ui.debug("Casting Thunderous Roar [Slayer Sweep]")
            return true
        end
    end
    -- Sweeping Strikes
    -- sweeping_strikes
    if cast.able.sweepingStrikes() then
        if cast.sweepingStrikes() then
            ui.debug("Casting Sweeping Strikes [Slayer Sweep]")
            return true
        end
    end
    -- Rend
    -- rend,if=dot.rend.remains<=gcd
    if cast.able.rend() and debuff.rend.remains(units.dyn5) <= unit.gcd() then
        if cast.rend() then
            ui.debug("Casting Rend - Reapply Now [Slayer Sweep]")
            return true
        end
    end
    -- Champions Spear
    -- champions_spear
    if ui.alwaysCdAoENever("Champion's Spear", 3, 8) and cast.able.championsSpear("target", "ground", 1, 8) then
        if cast.championsSpear("target", "ground", 1, 8) then
            ui.debug("Casting Champions Spear [Slayer Sweep]")
            return true
        end
    end
    -- Avatar
    -- avatar
    if ui.alwaysCdAoENever("Avatar") and cast.able.avatar() then
        if cast.avatar() then
            ui.debug("Casting Avatar [Slayer Sweep]")
            return true
        end
    end
    -- Colossus Smash
    -- colossus_smash
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 5) and cast.able.colossusSmash() then
        if cast.colossusSmash() then
            ui.debug("Casting Colossus Smash [Slayer Sweep]")
            return true
        end
    end
    -- Warbreaker
    -- warbreaker
    if ui.alwaysCdAoENever("Colossus Smash / Warbreaker", 1, 8) and cast.able.warbreaker("player", "aoe", 1, 8) then
        if cast.warbreaker("player", "aoe", 1, 8) then
            ui.debug("Casting Warbreaker [Slayer Sweep]")
            return true
        end
    end
    -- Skullsplitter
    -- skullsplitter,if=buff.sweeping_strikes.up
    if cast.able.skullsplitter() and buff.sweepingStrikes.exists() then
        if cast.skullsplitter() then
            ui.debug("Casting Skullsplitter [Slayer Sweep]")
            return true
        end
    end
    -- Execute
    -- execute,if=debuff.marked_for_execution.stack=3
    if cast.able.execute() and debuff.markedForExecution.count(units.dyn5) == 3 then
        if cast.execute() then
            ui.debug("Casting Execute - Marked For Execution [Slayer Sweep]")
            return true
        end
    end
    -- Bladestorm
    -- bladestorm
    if ui.alwaysCdAoENever("Bladestorm", 3, 8) and cast.able.bladestorm("player", "aoe", 1, 8) then
        if cast.bladestorm("player", "aoe", 1, 8) then
            ui.debug("Casting Bladestorm [Slayer Sweep]")
            return true
        end
    end
    -- Overpower
    -- overpower,if=talent.dreadnaught|buff.opportunist.up
    if cast.able.overpower() and ((talent.dreadnaught or buff.opportunist.exists())) then
        if cast.overpower() then
            ui.debug("Casting Overpower - Dreadnaught / Opportunist [Slayer Sweep]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike
    if cast.able.mortalStrike() then
        if cast.mortalStrike() then
            ui.debug("Casting Mortal Strike [Slayer Sweep]")
            return true
        end
    end
    -- Cleave
    -- cleave,if=talent.fervor_of_battle
    if cast.able.cleave("player", "cone", 1, 8) and talent.fervorOfBattle then
        if cast.cleave("player", "cone", 1, 8) then
            ui.debug("Casting Cleave [Slayer Sweep]")
            return true
        end
    end
    -- Execute
    -- execute
    if cast.able.execute() then
        if cast.execute() then
            ui.debug("Casting Execute [Slayer Sweep]")
            return true
        end
    end
    -- Overpower
    -- overpower
    if cast.able.overpower() then
        if cast.overpower() then
            ui.debug("Casting Overpower [Slayer Sweep]")
            return true
        end
    end
    -- Thunder Clap
    -- thunder_clap,if=dot.rend.remains<=8&buff.sweeping_strikes.down
    if cast.able.thunderClap("player", "aoe", 1, 8) and debuff.rend.remains(units.dyn5) <= 8 and not buff.sweepingStrikes.exists() then
        if cast.thunderClap("player", "aoe", 1, 8) then
            ui.debug("Casting Thunder Clap [Slayer Sweep]")
            return true
        end
    end
    -- Rend
    -- rend,if=dot.rend.remains<=5
    if cast.able.rend() and debuff.rend.remains(units.dyn5) <= 5 then
        if cast.rend() then
            ui.debug("Casting Rend [Slayer Sweep]")
            return true
        end
    end
    -- Whirlwind
    -- whirlwind,if=talent.fervor_of_battle
    if cast.able.whirlwind("player", "aoe", 1, 8) and talent.fervorOfBattle then
        if cast.whirlwind("player", "aoe", 1, 8) then
            ui.debug("Casting Whirlwind [Slayer Sweep]")
            return true
        end
    end
    -- Slam
    -- slam
    if cast.able.slam() then
        if cast.slam() then
            ui.debug("Casting Slam [Slayer Sweep]")
            return true
        end
    end
    -- Storm Bolt
    -- storm_bolt,if=buff.bladestorm.up
    if cast.able.stormBolt() and buff.bladestorm.exists() then
        if cast.stormBolt() then
            ui.debug("Casting Storm Bolt [Slayer Sweep]")
            return true
        end
    end
end -- End Action List - SlayerSweep

-- Action List - Trinkets
actionList.Trinkets = function()
    -- -- Do Treacherous Transmitter Task
    -- -- do_treacherous_transmitter_task
    -- if cast.able.doTreacherousTransmitterTask() then
    --     if cast.doTreacherousTransmitterTask() then ui.debug("Casting Do Treacherous Transmitter Task [Trinkets]") return true end
    -- end

    -- -- Use Item - Treacherous Transmitter
    -- -- use_item,name=treacherous_transmitter,if=(variable.adds_remain|variable.st_planning)&cooldown.avatar.remains<3
    -- if use.able.treacherousTransmitter() and (((var.addsRemain or var.stPlanning) and cd.avatar.remains()<3)) then
    --     if use.treacherousTransmitter() then ui.debug("Using Treacherous Transmitter [Trinkets]") return true end
    -- end

    -- -- Use Item - Slot1
    -- -- use_item,slot=trinket1,if=variable.trinket_1_buffs&!variable.trinket_1_manual&(!buff.avatar.up&trinket.1.cast_time>0|!trinket.1.cast_time>0)&buff.avatar.up&(variable.trinket_2_exclude|!trinket.2.has_cooldown|trinket.2.cooldown.remains|variable.trinket_priority=1)|trinket.1.proc.any_dps.duration>=fight_remains
    -- -- TODO: The following conditions were not converted:
    -- -- trinket.1.cast_time
    -- -- trinket.1.cast_time
    -- -- trinket.2.has_cooldown
    -- -- trinket.1.proc.any_dps.duration
    -- if use.able.slot1() and ((var.trinket1Buffs and not var.trinket1Manual and (not buff.avatar.exists() and >0 or not >0) and buff.avatar.exists() and (var.trinket2Exclude or not  or cd.slot.remains(14) or var.trinketPriority==1) or >=unit.ttdGroup(40))) then
    --     if use.slot1() then ui.debug("Using Slot1 [Trinkets]") return true end
    -- end

    -- -- Use Item - Slot2
    -- -- use_item,slot=trinket2,if=variable.trinket_2_buffs&!variable.trinket_2_manual&(!buff.avatar.up&trinket.2.cast_time>0|!trinket.2.cast_time>0)&buff.avatar.up&(variable.trinket_1_exclude|!trinket.1.has_cooldown|trinket.1.cooldown.remains|variable.trinket_priority=2)|trinket.2.proc.any_dps.duration>=fight_remains
    -- -- TODO: The following conditions were not converted:
    -- -- trinket.2.cast_time
    -- -- trinket.2.cast_time
    -- -- trinket.1.has_cooldown
    -- -- trinket.2.proc.any_dps.duration
    -- if use.able.slot2() and ((var.trinket2Buffs and not var.trinket2Manual and (not buff.avatar.exists() and >0 or not >0) and buff.avatar.exists() and (var.trinket1Exclude or not  or cd.slot.remains(13) or var.trinketPriority==2) or >=unit.ttdGroup(40))) then
    --     if use.slot2() then ui.debug("Using Slot2 [Trinkets]") return true end
    -- end

    -- -- Use Item - Slot1
    -- -- use_item,slot=trinket1,if=!variable.trinket_1_buffs&(trinket.1.cast_time>0&!buff.avatar.up|!trinket.1.cast_time>0)&!variable.trinket_1_manual&(!variable.trinket_1_buffs&(trinket.2.cooldown.remains|!variable.trinket_2_buffs)|(trinket.1.cast_time>0&!buff.avatar.up|!trinket.1.cast_time>0)|cooldown.avatar.remains_expected>20)
    -- -- TODO: The following conditions were not converted:
    -- -- trinket.1.cast_time
    -- -- trinket.1.cast_time
    -- -- trinket.1.cast_time
    -- -- trinket.1.cast_time
    -- -- cooldown.avatar.remains_expected
    -- if use.able.slot1() and ((not var.trinket1Buffs and (>0 and not buff.avatar.exists() or not >0) and not var.trinket1Manual and (not var.trinket1Buffs and (cd.slot.remains(14) or not var.trinket2Buffs) or (>0 and not buff.avatar.exists() or not >0) or >20))) then
    --     if use.slot1() then ui.debug("Using Slot1 [Trinkets]") return true end
    -- end

    -- -- Use Item - Slot2
    -- -- use_item,slot=trinket2,if=!variable.trinket_2_buffs&(trinket.2.cast_time>0&!buff.avatar.up|!trinket.2.cast_time>0)&!variable.trinket_2_manual&(!variable.trinket_2_buffs&(trinket.1.cooldown.remains|!variable.trinket_1_buffs)|(trinket.2.cast_time>0&!buff.avatar.up|!trinket.2.cast_time>0)|cooldown.avatar.remains_expected>20)
    -- -- TODO: The following conditions were not converted:
    -- -- trinket.2.cast_time
    -- -- trinket.2.cast_time
    -- -- trinket.2.cast_time
    -- -- trinket.2.cast_time
    -- -- cooldown.avatar.remains_expected
    -- if use.able.slot2() and ((not var.trinket2Buffs and (>0 and not buff.avatar.exists() or not >0) and not var.trinket2Manual and (not var.trinket2Buffs and (cd.slot.remains(13) or not var.trinket1Buffs) or (>0 and not buff.avatar.exists() or not >0) or >20))) then
    --     if use.slot2() then ui.debug("Using Slot2 [Trinkets]") return true end
    -- end

    -- -- Use Item - Slot=Main Hand
    -- -- use_item,slot=main_hand,if=!equipped.fyralath_the_dreamrender&(!variable.trinket_1_buffs|trinket.1.cooldown.remains)&(!variable.trinket_2_buffs|trinket.2.cooldown.remains)
    -- if use.able.slot=mainHand() and ((not equiped.fyralathTheDreamrender() and (not var.trinket1Buffs or cd.slot.remains(13)) and (not var.trinket2Buffs or cd.slot.remains(14)))) then
    --     if use.slot=mainHand() then ui.debug("Using Slot=Main Hand [Trinkets]") return true end
    -- end
    module.BasicTrinkets()
end -- End Action List - Trinkets

-- Action List - Variables
actionList.Variables = function()
    -- Variable - St Planning
    -- variable,name=st_planning,value=active_enemies=1&(raid_event.adds.in>15|!raid_event.adds.exists)
    var.stPlanning = (#enemies.yards5f == 1)

    -- Variable - Adds Remain
    -- variable,name=adds_remain,value=active_enemies>=2&(!raid_event.adds.exists|raid_event.adds.exists&raid_event.adds.remains>5)
    var.addsRemain = (#enemies.yards5f >= 2)

    -- Variable - Execute Phase
    -- variable,name=execute_phase,value=(talent.massacre.enabled&target.health.pct<35)|target.health.pct<20
    var.executePhase = ((talent.massacre and unit.hp(units.dyn5) < 35) or unit.hp(units.dyn5) < 20)
end -- End Action List - Variables

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then
        -- Module - Phial Up
        -- flask
        module.PhialUp()
        -- Module - Imbue Up
        -- augmentation
        module.ImbueUp()
        -- Variable - Trinket 1 Exclude
        -- variable,name=trinket_1_exclude,value=trinket.1.is.treacherous_transmitter
        var.trinket1Exclude = false -- TODO: Optional replace with UI option, review SimC for detailed notes
        -- Variable - Trinket 2 Exclude
        -- variable,name=trinket_2_exclude,value=trinket.2.is.treacherous_transmitter
        var.trinket2Exclude = false -- TODO: Optional replace with UI option, review SimC for detailed notes
        -- Variable - Trinket 1 Sync,Op=Setif,Value=1,Value Else=0.5,Condition=Trinket.1.Has Use Buff&(Trinket.1.Cooldown.Duration%%Cooldown.Avatar.Duration=0)
        -- variable,name=trinket_1_sync,op=setif,value=1,value_else=0.5,condition=trinket.1.has_use_buff&(trinket.1.cooldown.duration%%cooldown.avatar.duration=0)
        var.trinket1Sync = false
        -- Variable - Trinket 2 Sync,Op=Setif,Value=1,Value Else=0.5,Condition=Trinket.2.Has Use Buff&(Trinket.2.Cooldown.Duration%%Cooldown.Avatar.Duration=0)
        -- variable,name=trinket_2_sync,op=setif,value=1,value_else=0.5,condition=trinket.2.has_use_buff&(trinket.2.cooldown.duration%%cooldown.avatar.duration=0)
        var.trinket2Sync = false
        -- Variable - Trinket 1 Buffs
        -- variable,name=trinket_1_buffs,value=trinket.1.has_use_buff|(trinket.1.has_stat.any_dps&!variable.trinket_1_exclude)
        var.trinket1Buffs = false
        -- Variable - Trinket 2 Buffs
        -- variable,name=trinket_2_buffs,value=trinket.2.has_use_buff|(trinket.2.has_stat.any_dps&!variable.trinket_2_exclude)
        var.trinket2Buffs = false
        -- Variable - Trinket Priority,Op=Setif,Value=2,Value Else=1,Condition=!Variable.Trinket 1 Buffs&Variable.Trinket 2 Buffs|Variable.Trinket 2 Buffs&((Trinket.2.Cooldown.Duration%Trinket.2.Proc.Any Dps.Duration)*(1.5+Trinket.2.Has Buff.Strength)*(Variable.Trinket 2 Sync))>((Trinket.1.Cooldown.Duration%Trinket.1.Proc.Any Dps.Duration)*(1.5+Trinket.1.Has Buff.Strength)*(Variable.Trinket 1 Sync))
        -- variable,name=trinket_priority,op=setif,value=2,value_else=1,condition=!variable.trinket_1_buffs&variable.trinket_2_buffs|variable.trinket_2_buffs&((trinket.2.cooldown.duration%trinket.2.proc.any_dps.duration)*(1.5+trinket.2.has_buff.strength)*(variable.trinket_2_sync))>((trinket.1.cooldown.duration%trinket.1.proc.any_dps.duration)*(1.5+trinket.1.has_buff.strength)*(variable.trinket_1_sync))
        var.trinketPriority = 1
        -- Variable - Trinket 1 Manual
        -- variable,name=trinket_1_manual,value=trinket.1.is.algethar_puzzle_box
        var.trinket1Manual = false -- TODO: Optional replace with UI option, review SimC for detailed notes
        -- Variable - Trinket 2 Manual
        -- variable,name=trinket_2_manual,value=trinket.2.is.algethar_puzzle_box
        var.trinket2Manual = false -- TODO: Optional replace with UI option, review SimC for detailed notes
        -- Pre-Pull
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then

        end -- End Pre-Pull
        if unit.valid("target") then
            -- Battle Stance
            -- battle_stance,toggle=on
            if cast.able.battleStance() and not buff.battleStance.exists() then
                if cast.battleStance() then
                    ui.debug("Casting Battle Stance [Precombat]")
                    return true
                end
            end
            -- Charge
            -- charge
            if ui.mode.mover == 1 and ui.checked("Charge") and cast.able.charge("target") then
                if cast.charge("target") then
                    ui.debug("Casting Charge [Precombat]")
                    return true
                end
            end
            -- Taunt
            if ui.checked("Solo Taunt") and cast.able.taunt("target") and unit.solo()
                and (not cast.able.charge("target") or unit.distance("target") < 8) and unit.distance("target") < 25
            then
                if cast.taunt("target") then
                    ui.debug("Casting Taunt [Precombat]")
                    return true
                end
            end
            -- Start Attack
            if unit.distance("target") < 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then
                        ui.debug("Casting Auto Attack [Precombat]")
                        return true
                    end
                end
            end
        end
    end -- End No Combat
end     -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    if unit.inCombat() and unit.valid("target") and not var.profileStop then
        ------------------------------
        --- In Combat - Interrupts ---
        ------------------------------
        if actionList.Interrupts() then return true end
        ------------------------
        --- In Combat - Main ---
        ------------------------
        -- Start Attack
        if unit.distance("target") <= 5 then
            if cast.able.autoAttack("target") then
                if cast.autoAttack("target") then
                    ui.debug("Casting Auto Attack")
                    return true
                end
            end
        end
        -- Charge
        -- charge
        if ui.mode.mover == 1 and ui.checked("Charge") and cast.able.charge(units.dyn5) then
            if cast.charge(units.dyn5) then
                ui.debug("Casting Charge")
                return true
            end
        end
        -- Module - Combatpotion Up
        -- potion,if=gcd.remains=0&debuff.colossus_smash.remains>8|target.time_to_die<25
        if unit.gcd() == 0 and debuff.colossusSmash.remain() > 8 or unit.ttd(units.dyn5) < 25 then
            module.CombatPotionUp()
        end
        -- Action List - Interrupts
        if actionList.Interrupts() then return true end
        -- Call Action List - Variables
        -- call_action_list,name=variables
        if actionList.Variables() then return true end
        -- Call Action List - Trinkets
        -- call_action_list,name=trinkets
        if actionList.Trinkets() then return true end
        -- Racials
        if ui.alwaysCdNever("Racial") and cast.able.racial() then
            -- Arcane Torrent (Blood Elf)
            -- arcane_torrent,if=cooldown.mortal_strike.remains>1.5&rage<50
            if race == "BloodElf" and cast.able.arcaneTorrent() and cd.mortalStrike.remains() > 1.5 and rage() < 50 then
                if cast.arcaneTorrent() then
                    ui.debug("Casting Arcane Torrent")
                    return true
                end
            end
            -- Light's Judgment (Lightforged Draenei)
            -- lights_judgment,if=debuff.colossus_smash.down&cooldown.mortal_strike.remains
            if race == "LightforgedDraenei" and cast.able.lightsJudgment() and not debuff.colossusSmash.exists(units.dyn5) and cd.mortalStrike.exists() then
                if cast.lightsJudgment() then
                    ui.debug("Casting Light's Judgement")
                    return true
                end
            end
            -- Bag Of Tricks
            -- bag_of_tricks,if=debuff.colossus_smash.down&cooldown.mortal_strike.remains
            if race == "Vulpera" and cast.able.bagOfTricks() and not debuff.colossusSmash.exists(units.dyn5) and cd.mortalStrike.remains() then
                if cast.bagOfTricks() then
                    ui.debug("Casting Bag Of Tricks [Combat]")
                    return true
                end
            end
            -- Berserking (Troll)
            -- berserking,if=debuff.colossus_smash.remains>6
            if race == "Troll" and cast.able.berserking() and debuff.colossusSmash.remain(units.dyn5) > 6 then
                if cast.berserking() then
                    ui.debug("Casting Berserking")
                    return true
                end
            end
            -- Blood Fury (Orc)
            -- blood_fury,if=debuff.colossus_smash.up
            if race == "Orc" and cast.able.bloodFury() and debuff.colossusSmash.exists(units.dyn5) then
                if cast.bloodFury() then
                    ui.debug("Casting Blood Fury")
                    return true
                end
            end
            -- Fireblood (Dark Iron Dwarf)
            -- fireblood,if=debuff.colossus_smash.up
            if race == "DarkIronDwarf" and cast.able.fireblood() and debuff.colossusSmash.exists(units.dyn5) then
                if cast.fireblood() then
                    ui.debug("Casting Fireblood")
                    return true
                end
            end
            -- Ancestral Call (Maghar Orc)
            -- ancestral_call,if=debuff.colossus_smash.up
            if race == "MagharOrc" and cast.able.ancestralCall() and debuff.colossusSmash.exists(units.dyn5) then
                if cast.ancestralCall() then
                    ui.debug("Casting Ancestral Call")
                    return true
                end
            end
        end
        -- Call Action List - Colossus Aoe
        -- run_action_list,name=colossus_aoe,if=talent.demolish&active_enemies>2
        if talent.demolish and ui.useAOE(8, 3) then
            if actionList.ColossusAoe() then return true end
        end
        -- Call Action List - Colossus Execute,Target If=Min:Target.Health.Pct
        -- run_action_list,name=colossus_execute,target_if=min:target.health.pct,if=talent.demolish&variable.execute_phase
        if talent.demolish and var.executePhase then
            if actionList.ColossusExecute() then return true end
        end
        -- Call Action List - Colossus Sweep
        -- run_action_list,name=colossus_sweep,if=talent.demolish&active_enemies=2&!variable.execute_phase
        if talent.demolish and ui.useAOE(8, 2) and ui.useST(8, 3) and not var.executePhase then
            if actionList.ColossusSweep() then return true end
        end
        -- Call Action List - Colossus St
        -- run_action_list,name=colossus_st,if=talent.demolish
        if talent.demolish then
            if actionList.ColossusSt() then return true end
        end
        -- Call Action List - Slayer Aoe
        -- run_action_list,name=slayer_aoe,if=talent.slayers_dominance&active_enemies>2
        if (talent.slayersDominance or not (talent.demolish and talent.slayersDominance)) and ui.useAOE(8, 3) then
            if actionList.SlayerAoe() then return true end
        end
        -- Call Action List - Slayer Execute,Target If=Min:Target.Health.Pct
        -- run_action_list,name=slayer_execute,target_if=min:target.health.pct,if=talent.slayers_dominance&variable.execute_phase
        if (talent.slayersDominance or not (talent.demolish and talent.slayersDominance)) and var.executePhase then
            if actionList.SlayerExecute() then return true end
        end
        -- Call Action List - Slayer Sweep
        -- run_action_list,name=slayer_sweep,if=talent.slayers_dominance&active_enemies=2&!variable.execute_phase
        if (talent.slayersDominance or not (talent.demolish and talent.slayersDominance)) and ui.useAOE(8, 2) and ui.useST(8, 3) and not var.executePhase then
            if actionList.SlayerSweep() then return true end
        end
        -- Call Action List - Slayer St
        -- run_action_list,name=slayer_st,if=talent.slayers_dominance
        if talent.slayersDominance or not (talent.demolish and talent.slayersDominance) then
            if actionList.SlayerSt() then return true end
        end
    end -- End Combat Rotation
end     -- End Action List - Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------
    --- Locals ---
    --------------
    buff    = br.player.buff
    cast    = br.player.cast
    cd      = br.player.cd
    charges = br.player.charges
    debuff  = br.player.debuff
    enemies = br.player.enemies
    equiped = br.player.equiped
    module  = br.player.module
    race    = br.player.race
    rage    = br.player.power.rage
    talent  = br.player.talent
    ui      = br.player.ui
    unit    = br.player.unit
    units   = br.player.units
    var     = br.player.variables

    units.get(5)
    units.get(8)
    units.get(8, true)
    enemies.get(5)
    enemies.get(5, "player", false, true) -- makes enemies.yards5f
    enemies.get(8)
    enemies.get(8, "target")
    enemies.get(8, "player", false, true) -- makes enemies.yards8f
    enemies.get(20)

    ------------------------
    --- Custom Variables ---
    ------------------------
    if var.cancelBladestorm == nil or (var.cancelBladestorm and not cast.current.bladestorm()) then var.cancelBladestorm = false end
    if var.profileStop == nil then var.profileStop = false end

    if var.cancelBladestorm and cast.current.bladestorm() then
        if cast.cancel.bladestorm() then
            ui.debug("|cffFF0000Canceling Bladestorm")
            var.cancelBladestorm = false
            return true
        end
    end

    -- name=colossus_execute,target_if=min:target.health.pct
    var.minHp = 99999
    var.minHpUnit = "target"
    for i = 1, #enemies.yards5f do
        local thisUnit = enemies.yards5f[i]
        local thisHP = unit.hp(thisUnit)
        if thisHP < var.minHp then
            var.minHp = thisHP
            var.minHpUnit = thisUnit
        end
    end

    -----------------
    --- Rotations ---
    -----------------
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop == true) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then
        return true
    else
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extras() then return true end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.Defensive() then return true end
        ---------------------------
        --- Pre-Combat Rotation ---
        ---------------------------
        if actionList.PreCombat() then return true end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if actionList.Combat() then return true end
    end -- Pause
end     -- runRotation
local id = 71
if br.loader.rotations[id] == nil then br.loader.rotations[id] = {} end
br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

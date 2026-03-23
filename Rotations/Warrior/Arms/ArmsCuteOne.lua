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
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disarm DPS Rotation", highlight = 0, icon = br.player.spells.victoryRush }
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
        -- Heroic Leap
        br.ui:createCheckbox(section, "Heroic Leap", "Check to use Heroic Leap")
        -- Heroic Throw
        br.ui:createCheckbox(section, "Heroic Throw", "Check to use Heroic Throw out of range")
        -- Piercing Howl
        br.ui:createCheckbox(section, "Piercing Howl", "Use Piercing Howl on moving enemies not facing you.")
        -- Taunt
        br.ui:createCheckbox(section, "Solo Taunt", "Only uses Taunt when not in a group.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        local alwaysCdNever = { "Always", "|cff0000ffCD", "|cffff0000Never" }
        local alwaysCdAoENever = { "Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never" }
        -- Avatar
        br.ui:createDropdownWithout(section, "Avatar", alwaysCdNever, 2, "|cffFFFFFFWhen to use Avatar.")
        -- Bladestorm
        br.ui:createDropdownWithout(section, "Bladestorm", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Bladestorm.")
        -- Bloodbath
        br.ui:createDropdownWithout(section, "Bloodbath", alwaysCdNever, 2,
            "|cffFFFFFFWhen to use Bloodbath.")
        -- Colossus Smash
        br.ui:createDropdownWithout(section, "Colossus Smash", alwaysCdNever, 1,
            "|cffFFFFFFWhen to use Colossus Smash.")
        -- Dragon Roar
        br.ui:createDropdownWithout(section, "Dragon Roar", alwaysCdAoENever, 3,
            "|cffFFFFFFWhen to use Dragon Roar.")
        -- Recklessness
        br.ui:createDropdownWithout(section, "Recklessness", alwaysCdAoENever, 3,
            "|cffFFFFFFWhen to use Recklessness.")
        -- Skull Banner
        br.ui:createDropdownWithout(section, "Skull Banner", alwaysCdNever, 2,
            "|cffFFFFFFWhen to use Skull Banner.")
        -- Shattering Throw
        br.ui:createDropdownWithout(section, "Shattering Throw", alwaysCdNever, 2,
            "|cffFFFFFFWhen to use Shattering Throw.")
        -- Storm Bolt
        br.ui:createDropdownWithout(section, "Storm Bolt", alwaysCdNever, 2,
            "|cffFFFFFFWhen to use Storm Bolt.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        local defTooltip = "|cffFFBB00Health Percentage to use at."
        -- Defensive Stance
        br.ui:createSpinner(section, "Defensive Stance", 60, 0, 100, 5, defTooltip)
        -- Disarm (CC fleeing enemies)
        br.ui:createCheckbox(section, "Disarm", "Use Disarm on fleeing enemies")
        -- Die By The Sword
        br.ui:createSpinner(section, "Die By The Sword", 60, 0, 100, 5, defTooltip)
        -- Intimidating Shout
        br.ui:createSpinner(section, "Intimidating Shout", 60, 0, 100, 5, defTooltip)
        -- Rallying Cry
        br.ui:createSpinner(section, "Rallying Cry", 60, 0, 100, 5, defTooltip)
        -- Shield Wall
        br.ui:createSpinner(section, "Shield Wall", 30, 0, 100, 5, defTooltip)
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
        br.ui:createCheckbox(section, "Storm Bolt - Int", "Stun specific Spells and Mobs")
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
        -- br.ui:createDropdown(section, "Pause Mode", br.ui.dropOptions.Toggle, 6)
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
local spell
local talent
local ui
local unit
local units
local use
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
    -- Battle Stance
    if cast.able.battleStance() then
        if unit.form() ~= 1 and (not ui.checked("Defensive Stance") or (unit.hp("player") > ui.value("Defensive Stance"))) then
            if cast.battleStance() then
                ui.debug("Casting Battle Stance [Extra]")
                return true
            end
        end
    end
    -- Berserker Rage
    if ui.checked("Berserker Rage") and cast.able.berserkerRage() and cast.noControl.berserkerRage() then
        if cast.berserkerRage() then
            ui.debug("Casting Berserker Rage [Extra]")
            return true
        end
    end
    -- Disarm: mirror Grapple Weapon logic (with blacklist on error)
    if ui.checked("Disarm") and unit.inCombat() and #enemies.yards5f > 0 then
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5f[i]
            if cast.able.disarm(thisUnit) and unit.exists(thisUnit) and unit.distance(thisUnit) <= 5
                and (not debuff.disarm.exists(thisUnit))
            then
                -- Get NPC ID to check blacklist
                local npcID = br.functions.unit:GetObjectID(thisUnit)
                if not var.disarmBlacklist[npcID] then
                    var.lastDisarmTarget = thisUnit
                    if cast.disarm(thisUnit) then
                        ui.debug("Casting Disarm on " .. unit.name(thisUnit) .. " [Extra]")
                        return true
                    end
                end
            end
        end
    end
    -- Piercing Howl
    if ui.checked("Piercing Howl") then
        for i = 1, #enemies.yards15 do
            local thisUnit = enemies.yards15[i]
            if cast.able.piercingHowl(thisUnit) and unit.moving(thisUnit) and not unit.facing(thisUnit, "player") and unit.distance(thisUnit) >= 5 then
                if cast.piercingHowl(thisUnit) then
                    ui.debug("Casting Piercing Howl [Extra]")
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
            return unit.inCombat() and unit.hp("player") <= ui.value(op)
        end
        -- Basic Healing Module
        module.BasicHealing()
        -- Defensive Stance
        if ui.checked("Defensive Stance") and cast.able.defensiveStance() then
            if unit.form() ~= 2 and unit.hp("player") <= ui.value("Defensive Stance") then
                if cast.defensiveStance() then
                    ui.debug("Casting Defensive Stance [Defensive]")
                    return
                end
            end
        end
        -- Die By The Sword
        if ui.checked("Die By The Sword") and cast.able.dieByTheSword() and useDefensive("Die By The Sword") then
            if cast.dieByTheSword() then
                ui.debug("Casting Die By The Sword [Defensive]")
                return
            end
        end
        -- Intimidating Shout
        if ui.checked("Intimidating Shout") and cast.able.intimidatingShout() and useDefensive("Intimidating Shout") then
            if cast.intimidatingShout() then
                ui.debug("Casting Intimidating Shout [Defensive]")
                return true
            end
        end
        -- Rallying Cry
        if ui.checked("Rallying Cry") and cast.able.rallyingCry() and useDefensive("Rallying Cry") then
            if cast.rallyingCry() then
                ui.debug("Casting Rallying Cry [Defensive]")
                return true
            end
        end
        -- Shield Wall
        if ui.checked("Shield Wall") and cast.able.shieldWall() and useDefensive("Shield Wall") then
            if cast.shieldWall() then
                ui.debug("Casting Shield Wall [Defensive]")
                return true
            end
        end
        -- Spell Reflection
        if ui.checked("Spell Reflection") and cast.able.spellReflection() and useDefensive("Spell Relection") then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (cast.timeRemain(thisUnit) < 5 or cast.inFlight.spellReflection(thisUnit)) then
                    if cast.spellReflection() then
                        ui.debug("Casting Spell Reflection [Defensive]")
                        return true
                    end
                end
            end
        end
        -- Storm Bolt
        if ui.checked("Storm Bolt") and cast.able.stormBolt() and useDefensive("Storm Bolt") then
            if cast.stormBolt() then
                ui.debug("Casting Storm Bolt [Defensive]")
                return true
            end
        end
        -- Victory Rush / Impending Victory (defensive heal)
        if ui.checked("Victory Rush") and unit.inCombat() and (buff.victorious.exists() or talent.impendingVictory) then
            for i = 1, #enemies.yards5f do
                local thisUnit = enemies.yards5f[i]
                if unit.hp("player") <= ui.value("Victory Rush") or (buff.victorious.exists()
                    and (buff.victorious.remain() < unit.gcd(true) or unit.ttd(thisUnit) < unit.gcd(true)))
                then
                    if talent.impendingVictory then
                        -- Replacement: use Impending Victory (does not require victorious)
                        if cast.able.impendingVictory(thisUnit) then
                            if cast.impendingVictory(thisUnit) then
                                ui.debug("Casting Impending Victory [Defensive]")
                                return true
                            end
                        end
                    else
                        -- No talent: use Victory Rush only when buff exists
                        if buff.victorious.exists() and cast.able.victoryRush(thisUnit) then
                            if cast.victoryRush(thisUnit) then
                                ui.debug("Casting Victory Rush [Defensive]")
                                return true
                            end
                        end
                    end
                end
            end
        end
    end -- End Defensive Check
end -- End Action List - Defensive

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
                        ui.debug("Casting Pummel [Interrupt]")
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

-- Action List - AOE
actionList.AOE = function()
    -- Sweeping Strikes
    -- sweeping_strikes
    if cast.able.sweepingStrikes() and not buff.sweepingStrikes.exists() then
        if cast.sweepingStrikes() then
            ui.debug("Casting Sweeping Strikes [AOE]")
            return true
        end
    end
    -- Cleave
    -- cleave,if=rage>110&active_enemies<=4
    if cast.able.cleave(units.dyn5,"cone",1,8) and (rage() > 110 or (rage.max() == 100 and rage() > 90)) and #enemies.yards5f <= 4 then
        if cast.cleave("player","cone",1,8) then
            ui.debug("Casting Cleave [AOE]")
            return true
        end
    end
    -- Bladestorm
    -- bladestorm,if=enabled&(buff.bloodbath.up|!talent.bloodbath.enabled)
    if ui.alwaysCdAoENever("Bladestorm",3,#enemies.yards8) and cast.able.bladestorm("player","aoe",1,8)
        and (buff.bloodbath.exists() or not talent.bloodbath)
    then
        if cast.bladestorm("player","aoe",1,8) then
            ui.debug("Casting Bladestorm [Single]")
            return true
        end
    end
    -- Dragon Roar
    -- dragon_roar,if=enabled&debuff.colossus_smash.down
    if ui.alwaysCdAoENever("Dragon Roar",3,#enemies.yards8) and cast.able.dragonRoar("player","aoe",1,8)
        and not debuff.colossusSmash.exists(units.dyn5)
    then
        if cast.dragonRoar("player","aoe",1,8) then
            ui.debug("Casting Dragon Roar [Single]")
            return true
        end
    end
    -- Colossus Smash
    -- colossus_smash,if=debuff.colossus_smash.remains<1
    if ui.alwaysCdNever("Colossus Smash") and cast.able.colossusSmash()
        and debuff.colossusSmash.remains(units.dyn5) < 1
    then
        if cast.colossusSmash() then
            ui.debug("Casting Colossus Smash [Single]")
            return true
        end
    end
    -- Thunder Clap
    -- thunder_clap,target=2,if=dot.deep_wounds.attack_power*1.1<stat.attack_power
    if cast.able.thunderClap("player","aoe",1,8) and #enemies.yards8 >= 2 then
        if cast.thunderClap("player","aoe",1,8) then
            ui.debug("Casting Thunder Clap [AOE]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike,if=active_enemies=2|rage<50
    if cast.able.mortalStrike() and (#enemies.yards5f == 2 or rage() < 50) then
        if cast.mortalStrike() then
            ui.debug("Casting Mortal Strike [AOE]")
            return true
        end
    end
    -- Execute
    -- execute,if=buff.sudden_execute.down&active_enemies=2
    if cast.able.execute() and not buff.suddenExecute.exists()
        and #enemies.yards5f == 2 and unit.hp(units.dyn5) < 20
    then
        if cast.execute() then
            ui.debug("Casting Execute [AOE]")
            return true
        end
    end
    -- Slam
    -- slam,if=buff.sweeping_strikes.up&debuff.colossus_smash.up
    if cast.able.slam() and buff.sweepingStrikes.exists()
        and debuff.colossusSmash.exists(units.dyn5)
    then
        if cast.slam() then
            ui.debug("Casting Slam [AOE]")
            return true
        end
    end
    -- Overpower
    -- overpower,if=active_enemies=2
    if cast.able.overpower() and #enemies.yards5f == 2 then
        if cast.overpower() then
            ui.debug("Casting Overpower [AOE]")
            return true
        end
    end
    -- Whirlwind
    if cast.able.whirlwind("player","aoe",1,8) and not spell.sweepingStrikes.known()
        and rage() > 40
    then
        if cast.whirlwind("player","aoe",1,8) then
            ui.debug("Casting Whirlwind [AOE]")
            return true
        end
    end
    -- Slam
    -- slam,if=buff.sweeping_strikes.up
    if cast.able.slam() and (buff.sweepingStrikes.exists() or not spell.sweepingStrikes.known()) then
        if cast.slam() then
            ui.debug("Casting Slam [AOE]")
            return true
        end
    end
    -- Battle Shout
    -- battle_shout
    if cast.able.battleShout() and not buff.battleShout.exists() and rage.max() - rage() > 20 then
        if cast.battleShout() then
            ui.debug("Casting Battle Shout [AOE]")
            return true
        end
    end
end -- End Action List - AOE

-- Action List - Single
actionList.Single = function()
    -- Heroic Strike
    -- heroic_strike,if=rage>115|(debuff.colossus_smash.up&rage>60&set_bonus.tier16_2pc_melee)
    if cast.able.heroicStrike()
        and ((rage() > 115 or (rage.max() == 100 and rage() > 95)) or (debuff.colossusSmash.exists(units.dyn5)
        and rage() > 60 and equiped.tier(16,2)))
    then
        if cast.heroicStrike() then
            ui.debug("Casting Heroic Strike [Single]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike,if=dot.deep_wounds.remains<1.0|buff.enrage.down|rage<10
    if cast.able.mortalStrike()
        and (debuff.deepWounds.remains(units.dyn5) < 1.0
        or not buff.enrage.exists() or rage() < 10)
    then
        if cast.mortalStrike() then
            ui.debug("Casting Mortal Strike [Single]")
            return true
        end
    end
    -- Colossus Smash
    -- colossus_smash,if=debuff.colossus_smash.remains<1.0
    if ui.alwaysCdNever("Colossus Smash") and cast.able.colossusSmash()
        and debuff.colossusSmash.remains(units.dyn5) < 1.0
    then
        if cast.colossusSmash() then
            ui.debug("Casting Colossus Smash [Single]")
            return true
        end
    end
    -- Bladestorm
    --# Use cancelaura (in-game) to stop bladestorm if CS comes off cooldown during it for any reason.
    -- bladestorm,if=enabled,interrupt_if=!cooldown.colossus_smash.remains
    if ui.alwaysCdAoENever("Bladestorm",3,#enemies.yards8) and cast.able.bladestorm("player","aoe",1,8) and (not var.knownCS or cd.colossusSmash.remains(units.dyn5) > 10) then
        if cast.bladestorm("player","aoe",1,8) then
            ui.debug("Casting Bladestorm [Single]")
            return true
        end
    end
    -- Mortal Strike
    -- mortal_strike
    if cast.able.mortalStrike() then
        if cast.mortalStrike() then
            ui.debug("Casting Mortal Strike [Single]")
            return true
        end
    end
    -- Storm Bolt
    -- storm_bolt,if=enabled&debuff.colossus_smash.up
    if ui.alwaysCdNever("Storm Bolt") and cast.able.stormBolt()
        and debuff.colossusSmash.exists(units.dyn5)
    then
        if cast.stormBolt() then
            ui.debug("Casting Storm Bolt [Single]")
            return true
        end
    end
    -- Dragon Roar
    -- dragon_roar,if=enabled&debuff.colossus_smash.down
    if ui.alwaysCdAoENever("Dragon Roar",3,#enemies.yards8) and cast.able.dragonRoar("player","aoe",1,8)
        and not debuff.colossusSmash.exists(units.dyn5)
    then
        if cast.dragonRoar("player","aoe",1,8) then
            ui.debug("Casting Dragon Roar [Single]")
            return true
        end
    end
    -- Execute
    -- execute,if=buff.sudden_execute.down|buff.taste_for_blood.down|rage>90|target.time_to_die<12
    if cast.able.execute()
        and (not buff.suddenExecute.exists() or not buff.tasteForBlood.exists()
        or rage() > 90 or unit.ttd(units.dyn5) < 12) and unit.hp(units.dyn5) < 20
    then
        if cast.execute() then
            ui.debug("Casting Execute [Single]")
            return true
        end
    end
    -- Slam
    --# Slam is preferable to overpower with crit procs/recklessness.
    -- slam,if=target.health.pct>=20&(trinket.stacking_stat.crit.stack>=10|buff.recklessness.up)
    if cast.able.slam() and unit.hp(units.dyn5) >= 20 and buff.recklessness.exists() then
        if cast.slam() then
            ui.debug("Casting Slam [Single]")
            return true
        end
    end
    -- Overpower
    -- overpower,if=target.health.pct>=20&rage<100|buff.sudden_execute.up
    if cast.able.overpower() and unit.hp(units.dyn5) >= 20
        and (rage() < 100 or buff.suddenExecute.exists())
    then
        if cast.overpower() then
            ui.debug("Casting Overpower [Single]")
            return true
        end
    end
    -- Execute
    -- execute
    if cast.able.execute() and unit.hp(units.dyn5) < 20 then
        if cast.execute() then
            ui.debug("Casting Execute [Single]")
            return true
        end
    end
    -- Slam
    -- slam,if=target.health.pct>=20
    if cast.able.slam() and unit.hp(units.dyn5) >= 20 then
        if cast.slam() then
            ui.debug("Casting Slam [Single]")
            return true
        end
    end
    -- Heroic Throw
    -- heroic_throw
    if ui.checked("Heroic Throw") and cast.able.heroicThrow(units.dyn5) then
        if cast.heroicThrow(units.dyn5) then
            ui.debug("Casting Heroic Throw [Single]")
            return true
        end
    end
    -- Battle Shout
    -- battle_shout
    if cast.able.battleShout() and not buff.battleShout.exists() and rage.max() - rage() > 20 then
        if cast.battleShout() then
            ui.debug("Casting Battle Shout [Single]")
            return true
        end
    end
end -- End Action List - Single

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then
        -- Module - Phial Up
        -- flask
        module.PhialUp()
        -- Module - Imbue Up
        -- augmentation
        module.ImbueUp()
        -- Pre-Pull
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then

        end -- End Pre-Pull
        -- -- Battle Stance
        -- -- battle_stance,toggle=on
        -- if cast.able.battleStance() and unit.form() ~= 1 then
        --     if cast.battleStance() then
        --         ui.debug("Casting Battle Stance [Precombat]")
        --         return true
        --     end
        -- end
        if unit.valid("target") then
            -- Charge
            -- charge
            if ui.mode.mover == 1 and ui.checked("Charge") and cast.able.charge("target") and unit.distance("target") > 8 then
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
            -- Shattering Throw
            -- shattering_throw
            if ui.alwaysCdNever("Shattering Throw") and cast.able.shatteringThrow("target") then
                if cast.shatteringThrow("target") then
                    ui.debug("Casting Shattering Throw [Precombat]")
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
                    ui.debug("Casting Auto Attack [Combat]")
                    return true
                end
            end
        end
        -- Charge
        -- charge
        if ui.mode.mover == 1 and ui.checked("Charge") and cast.able.charge(units.dyn5) and unit.distance(units.dyn5) > 8 then
            if cast.charge(units.dyn5) then
                ui.debug("Casting Charge [Combat]")
                return true
            end
        end
        -- Module - Combatpotion Up
        -- mogu_power_potion,if=(target.health.pct<20&buff.recklessness.up)|buff.bloodlust.react|target.time_to_die<=25
        if (unit.hp(units.dyn5) < 20 and buff.recklessness.exists()) or buff.bloodLust.exists() or unit.ttd(units.dyn5) < 25 then
            module.CombatPotionUp()
        end
        -- Shattering Throw
        -- shattering_throw
        if ui.alwaysCdNever("Shattering Throw") and cast.able.shatteringThrow(units.dyn5) then
            if cast.shatteringThrow(units.dyn5) then
                ui.debug("Casting Shattering Throw [Combat]")
                return true
            end
        end
        -- Action List - Interrupts
        if actionList.Interrupts() then return true end
        -- Recklessness
        -- recklessness,if=!talent.bloodbath.enabled&((cooldown.colossus_smash.remains<2|debuff.colossus_smash.remains>=5)&(target.time_to_die>(192*buff.cooldown_reduction.value)|target.health.pct<20))|buff.bloodbath.up&(target.time_to_die>(192*buff.cooldown_reduction.value)|target.health.pct<20)|target.time_to_die<=12
        if ui.alwaysCdAoENever("Recklessness",3,#enemies.yards8) and cast.able.recklessness() and (not talent.bloodbath and ((cd.colossusSmash.remains() < 2 or debuff.colossusSmash.remains(units.dyn5) >= 5 or not var.knownCS)
            and (unit.ttd(units.dyn5) > (192 * 1--[[buff.cooldownReduction.value()]]) or unit.hp(units.dyn5) < 20)) or buff.bloodbath.exists()
            and (unit.ttd(units.dyn5) > (192 * 1--[[buff.cooldownReduction.value()]]) or unit.hp(units.dyn5) < 20) or unit.ttd(units.dyn5) <= 12)
        then
            if cast.recklessness() then
                ui.debug("Casting Recklessness [Combat]")
                return true
            end
        end
        -- Avatar
        -- avatar,if=enabled&(buff.recklessness.up|target.time_to_die<=25)
        if ui.alwaysCdNever("Avatar") and cast.able.avatar() and (buff.recklessness.exists() or unit.ttd(units.dyn5) <= 25) then
            if cast.avatar() then
                ui.debug("Casting Avatar [Combat]")
                return true
            end
        end
        -- Skull Banner
        -- skull_banner,if=buff.skull_banner.down&(((cooldown.colossus_smash.remains<2|debuff.colossus_smash.remains>=5)&target.time_to_die>192&buff.cooldown_reduction.up)|buff.recklessness.up)
        if ui.alwaysCdNever("Skull Banner") and cast.able.skullBanner() and not buff.skullBanner.exists()
            and (((cd.colossusSmash.remains() < 2 or debuff.colossusSmash.remains(units.dyn5) >= 5)
            and unit.ttd(units.dyn5) > 192 --[[and buff.cooldownReduction.exists()]]) or buff.recklessness.exists())
        then
            if cast.skullBanner() then
                ui.debug("Casting Skull Banner [Combat]")
                return true
            end
        end
        -- Use Item: Hands
        -- use_item,slot=hands,if=!talent.bloodbath.enabled&debuff.colossus_smash.up|buff.bloodbath.up
        -- if use.able.item.slot(9) and ((not talent.bloodbath and debuff.colossusSmash.exists(units.dyn5)) or buff.bloodbath.exists()) then
        --     if use.item.slot(9) then
        --         ui.debug("Using Item: Hands")
        --         return true
        --     end
        -- end
        -- Racials
        if ui.alwaysCdNever("Racial") and cast.able.racial() then
            -- Blood Fury (Orc)
            -- blood_fury,if=buff.cooldown_reduction.down&(buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up))|buff.cooldown_reduction.up&buff.recklessness.up
            if race == "Orc" and cast.able.bloodFury() and (--[[not buff.cooldownReduction.exists()
                and]] (buff.bloodbath.exists() or (not talent.bloodbath and debuff.colossusSmash.exists(units.dyn5)))
                    or --[[buff.cooldownReduction.exists() and]] buff.recklessness.exists())
            then
                if cast.bloodFury() then
                    ui.debug("Casting Blood Fury [Combat]")
                    return true
                end
            end
            -- Berserking (Troll)
            -- /berserking,if=buff.cooldown_reduction.down&(buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up))|buff.cooldown_reduction.up&buff.recklessness.up
            if race == "Troll" and cast.able.berserking() and (--[[not buff.cooldownReduction.exists()
                and]] (buff.bloodbath.exists() or (not talent.bloodbath and debuff.colossusSmash.exists(units.dyn5)))
                    or --[[buff.cooldownReduction.exists() and]] buff.recklessness.exists())
            then
                if cast.berserking() then
                    ui.debug("Casting Berserking [Combat]")
                    return true
                end
            end
            -- Arcane Torrent (Blood Elf)
            -- arcane_torrent,if=buff.cooldown_reduction.down&(buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up))|buff.cooldown_reduction.up&buff.recklessness.up
            if race == "BloodElf" and cast.able.arcaneTorrent() and (--[[not buff.cooldownReduction.exists()
                and]] (buff.bloodbath.exists() or (not talent.bloodbath and debuff.colossusSmash.exists(units.dyn5)))
                    or --[[buff.cooldownReduction.exists() and]] buff.recklessness.exists())
            then
                if cast.arcaneTorrent() then
                    ui.debug("Casting Arcane Torrent [Combat]")
                    return true
                end
            end
        end
        -- Bloodbath
        -- bloodbath,if=enabled&(debuff.colossus_smash.remains>0.1|cooldown.colossus_smash.remains<5|target.time_to_die<=20)
        if ui.alwaysCdNever("Bloodbath") and cast.able.bloodbath() and (debuff.colossusSmash.remains(units.dyn5) > 0.1
            or cd.colossusSmash.remains() < 5 or unit.ttd(units.dyn5) <= 20)
        then
            if cast.bloodbath() then
                ui.debug("Casting Bloodbath [Combat]")
                return true
            end
        end
        -- Berserker Rage
        -- berserker_rage,if=buff.enrage.remains<0./berserker_rage,if=buff.enrage.remains<0.5
        if ui.checked("Berserker Rage") and cast.able.berserkerRage() and buff.enrage.remains() < 0.5 then
            if cast.berserkerRage() then
                ui.debug("Casting Berserker Rage [Combat]")
                return true
            end
        end
        -- Heroic Leap
        -- heroic_leap,if=debuff.colossus_smash.up
        if ui.mode.mover == 1 and ui.checked("Heroic Leap") and cast.able.heroicLeap(units.dyn5) and (not var.knownCS or debuff.colossusSmash.exists(units.dyn5)) then
            if cast.heroicLeap(units.dyn5) then
                ui.debug("Casting Heroic Leap [Combat]")
                return true
            end
        end
        -- Action List - AOE
        -- run_action_list,name=aoe,if=active_enemies>=2
        if ui.useAOE(8,2) then
            if actionList.AOE() then return true end
        end
        -- Action List - Single
        -- run_action_list,name=single_target,if=active_enemies<2
        if ui.useST(8,2) then
            if actionList.Single() then return true end
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
    spell   = br.player.spell
    talent  = br.player.talent
    ui      = br.player.ui
    unit    = br.player.unit
    units   = br.player.units
    use     = br.player.use
    var     = br.player.variables

    var.knownCS = spell.colossusSmash.known()

    -- Ensure blacklist and error-frame for Disarm exist (persist across runs)
    if var.disarmBlacklist == nil then var.disarmBlacklist = {} end
    var.lastDisarmTarget = var.lastDisarmTarget or nil
    var.disarmErrorFrame = var.disarmErrorFrame or CreateFrame("Frame")
    var.disarmErrorFrame:RegisterEvent("UI_ERROR_MESSAGE")
    var.disarmErrorFrame:SetScript("OnEvent", function(self, event, errorType, message)
        if message and var.lastDisarmTarget and var.disarmBlacklist then
            local err = tostring(message):lower()
            local disarmError = err:find("disarm") or err:find("invalid target")
            if disarmError then
                local npcID = br.functions.unit:GetObjectID(var.lastDisarmTarget)
                if npcID and not var.disarmBlacklist[npcID] then
                    var.disarmBlacklist[npcID] = true
                    print("|cff8000FFBadRotations|r: Blacklisted " .. (UnitName(var.lastDisarmTarget) or "Unknown") .. " (ID: " .. npcID .. ") - Cannot Disarm")
                end
            end
            var.lastDisarmTarget = nil
        end
    end)

    units.get(5)
    units.get(8)
    units.get(8, true)
    enemies.get(5)
    enemies.get(5, "player", false, true) -- makes enemies.yards5f
    enemies.get(8)
    enemies.get(8, "target")
    enemies.get(8, "player", false, true) -- makes enemies.yards8f
    enemies.get(15)
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

    -- ui.chatOverlay("AOE: " .. tostring(ui.useAOE(8,2)) .. " | ST: " .. tostring(ui.useST(8,2)) .. " | Count: " .. #enemies.yards8)

    -----------------
    --- Rotations ---
    -----------------
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop == true) or ui.pause() or unit.mounted() or unit.flying() then
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
        if ui.mode.rotation == 4 then return true end
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
local expansion = br.isMOP
if br.loader.rotations[id] == nil then br.loader.rotations[id] = {} end
br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

-- Editor types: the keys of Retail Warrior Fury's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.Retail.Warrior.Fury.buff]]
local cast = cast --[[@as BR.Retail.Warrior.Fury.cast]]
local cd = cd --[[@as BR.Retail.Warrior.Fury.cd]]
local debuff = debuff --[[@as BR.Retail.Warrior.Fury.debuff]]
local equiped = equiped --[[@as BR.Retail.Warrior.Fury.equiped]]
local talent = talent --[[@as BR.Retail.Warrior.Fury.talent]]
local use = use --[[@as BR.Retail.Warrior.Fury.use]]

local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = "whirlwind", overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range." },
        { name = "Mult", icon = "bladestorm", overlay = "Multiple Target Rotation", tip = "Multiple target rotation used." },
        { name = "Sing", icon = "ragingBlow", overlay = "Single Target Rotation", tip = "Single target rotation used." },
        { name = "Off", icon = "enragedRegeneration", overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation" },
    } })
    ui.toggle("Cooldown", { key = "RightCtrl", modes = {
        { name = "Auto", icon = "recklessness", overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection." },
        { name = "On", icon = "recklessness", overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target." },
        { name = "Off", icon = "recklessness", overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used." },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "enragedRegeneration", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "enragedRegeneration", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "pummel", overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts." },
        { name = "Off", icon = "pummel", overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
    } })
    ui.toggle("Mover", { modes = {
        { name = "On", icon = "charge", overlay = "Mover Enabled", tip = "Will use Charge/Heroic Leap." },
        { name = "Off", icon = "charge", overlay = "Mover Disabled", tip = "Will NOT use Charge/Heroic Leap." },
    } })
end

---------------
--- OPTIONS ---
---------------
local function options()
    local section
    -----------------------
    --- GENERAL OPTIONS ---
    -----------------------
    section = ui.section("General")
    -- Dummy DPS Test
    ui.spinner(section, "DPS Testing", { value = 5, min = 5, max = 60,
        tip = "Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5" })
    -- Pre-Pull Timer
    ui.spinner(section, "Pre-Pull Timer", { value = 5, min = 1, max = 10, step = 1,
        tip = "Set to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1" })
    -- Battle Shout
    ui.checkbox(section, "Battle Shout")
    -- Bladestorm Units
    ui.spinner(section, "Bladestorm Units", { value = 3, min = 1, max = 10, step = 1, checkbox = false,
        tip = "Set to desired minimal number of units required to use Bladestorm." })
    -- Berserker Rage
    ui.checkbox(section, "Berserker Rage", { tip = "Check to use Berserker Rage" })
    -- Charge
    ui.checkbox(section, "Charge", { tip = "Check to use Charge" })
    -- Heroic Leap
    ui.checkbox(section, "Heroic Leap", { tip = "Check to use Heroic Leap" })
    -- Heroic Throw
    ui.checkbox(section, "Heroic Throw")
    -- Piercing Howl
    ui.checkbox(section, "Piercing Howl", { tip = "Check to use Piercing Howl" })
    ------------------------
    --- COOLDOWN OPTIONS ---
    ------------------------
    section = ui.section("Cooldowns")
    local alwaysCdNever = { "Always", "|cff0000ffCD", "|cffff0000Never" }
    local alwaysCdAoENever = { "Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never" }
    -- Racial
    ui.dropdown(section, "Racial", { choices = alwaysCdAoENever, value = 3, checkbox = false, tip = "When to use Racial." })
    -- Avatar
    ui.dropdown(section, "Avatar", { choices = alwaysCdNever, value = 2, checkbox = false, tip = "When to use Avatar." })
    -- Bladestorm
    ui.dropdown(section, "Bladestorm", { choices = alwaysCdAoENever, value = 3, checkbox = false, tip = "When to use Bladestorm." })
    -- Champion's Spear
    ui.dropdown(section, "Champion's Spear", { choices = alwaysCdAoENever, value = 3, checkbox = false,
        tip = "When to use Champion's Spear." })
    -- Odyn's Fury
    ui.dropdown(section, "Odyn's Fury", { choices = alwaysCdAoENever, value = 3, checkbox = false, tip = "cffFFFFFFWhen to use Odyn's Fury." })
    -- Ravager
    ui.dropdown(section, "Ravager", { choices = alwaysCdAoENever, value = 3, checkbox = false, tip = "cffFFFFFFWhen to use Ravager." })
    -- Recklessness
    ui.dropdown(section, "Recklessness", { choices = alwaysCdNever, value = 2, checkbox = false, tip = "When to use Recklessness." })
    -- Thunderous Roar
    ui.dropdown(section, "Thunderous Roar", { choices = alwaysCdAoENever, value = 3, checkbox = false, tip = "When to use Thunderous Roar." })
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = ui.section("Defensive")
    local defTooltip = "|cffFFBB00Health Percentage to use at."
    -- Enraged Regeneration
    ui.spinner(section, "Enraged Regeneration", { value = 60, tip = defTooltip })
    -- Intimidating Shout
    ui.spinner(section, "Intimidating Shout", { value = 60, tip = defTooltip })
    -- Rallying Cry
    ui.spinner(section, "Rallying Cry", { value = 60, tip = defTooltip })
    -- Spell Reflection
    ui.spinner(section, "Spell Reflection", { value = 60, tip = defTooltip })
    -- Storm Bolt
    ui.spinner(section, "Storm Bolt", { value = 60, tip = defTooltip })
    -- Victory Rush
    ui.spinner(section, "Victory Rush", { value = 60, tip = defTooltip })
    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = ui.section("Interrupts")
    -- Pummel
    ui.checkbox(section, "Pummel")
    -- Intimidating Shout
    ui.checkbox(section, "Intimidating Shout - Int")
    -- Storm Bolt
    ui.checkbox(section, "Storm Bolt - Int")
    -- Interrupt Percentage
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, tip = "|cffFFBB00Cast Percentage to use at." })
end

--------------
--- Locals ---
--------------
-- BR API Locals
local race
local rage


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
        for i = 1, #units.friends do
            local thisUnit = units.friends[i].unit
            if not unit.deadOrGhost(thisUnit) and unit.distance(thisUnit) < 100 and buff.battleShout.remain(thisUnit) < 600 then
                if cast.battleShout() then
                    ui.debug("Casting Battle Shout [Extras]")
                    return true
                end
            end
        end
    end
    -- Berserker Rage
    if ui.checked("Berserker Rage") and cast.able.berserkerRage() and cast.noControl.berserkerRage() then
        if cast.berserkerRage() then
            ui.debug("Casting Berserker Rage [Extras]")
            return true
        end
    end
    -- Piercing Howl
    if ui.checked("Piercing Howl") then
        for i = 1, #enemies.yards15 do
            local thisUnit = enemies.yards15[i]
            if cast.able.piercingHowl(thisUnit) and unit.moving(thisUnit) and not unit.facing(thisUnit, "player") and unit.distance(thisUnit) >= 5 then
                if cast.piercingHowl(thisUnit) then
                    ui.debug("Casting Piercing Howl [Extras]")
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
        -- Enraged Regeneration
        if ui.checked("Enraged Regeneration") and cast.able.enragedRegeneration() and useDefensive("Enraged Regeneration") then
            if cast.enragedRegeneration() then
                ui.debug("Casting Enraged Regeneration [Defensive]")
                return true
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
        -- Spell Reflection
        if ui.checked("Spell Reflection") and cast.able.spellReflection() and useDefensive("Spell Reflection") then
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
        -- Victory Rush
        if ui.checked("Victory Rush") and (cast.able.victoryRush() or cast.able.impendingVictory())
            and unit.inCombat() and buff.victorious.exists()
        then
            for i = 1, #enemies.yards5f do
                local thisUnit = enemies.yards5f[i]
                if unit.hp() <= ui.value("Victory Rush") or buff.victorious.remain() < unit.gcd(true) or unit.ttd(thisUnit) < unit.gcd(true) then
                    if talent.impendingVictory then
                        if cast.impendingVictory(thisUnit) then
                            ui.debug("Casting Impending Victory [Defensive]")
                            return true
                        end
                    else
                        if cast.victoryRush(thisUnit) then
                            ui.debug("Casting Victory Rush [Defensive]")
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
                        ui.debug("Casting Pummel [Interrupt]")
                        return true
                    end
                end
                -- Intimidating Shout
                if ui.checked("Intimidating Shout - Int") and cast.able.intimidatingShout() and distance < 8 then
                    if cast.intimidatingShout() then
                        ui.debug("Casting Intimidating Shout [Interrupt]")
                        return true
                    end
                end
                -- Storm Bolt
                if ui.checked("Storm Bolt - Int") and cast.able.stormBolt(thisUnit) and distance < 20 then
                    if cast.stormBolt(thisUnit) then
                        ui.debug("Casting Storm Bolt [Interrupt]")
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - Interrupts

-- Action List - Movement
actionList.Movement = function()
    if ui.mode.mover == 1 and unit.valid("target") and not var.profileStop then
        -- Charge
        -- charge,if=time<=0.5|movement.distance>5
        if ui.checked("Charge") and cast.able.charge(units.dyn5) and ((unit.combatTime() <= 0.5 or unit.distance() > 5)) then
            if cast.charge(units.dyn5) then
                ui.debug("Casting Charge [Movement]")
                return true
            end
        end
        -- Heroic Leap
        -- heroic_leap
        if ui.checked("Heroic Leap") and cast.able.heroicLeap()
            and cd.charge.remain() > unit.gcd(true) and cd.charge.remain() < cd.charge.duration() - unit.gcd(true)
        then
            if cast.heroicLeap() then
                ui.debug("Casting Heroic Leap [Movement]")
                return true
            end
        end
        -- Heroic Throw
        if ui.checked("Heroic Throw") and cast.able.heroicThrow() and (cast.last.charge() or cast.last.heroicLeap()) then
            if cast.heroicThrow() then
                ui.debug("Casting Heroic Throw [Movement]")
                return true
            end
        end
    end
end -- End Action List - Movement

-- Action List - SlayerMt
actionList.SlayerMt = function()
    -- Recklessness
    -- recklessness,if=(!talent.anger_management&cooldown.avatar.remains<1&talent.titans_torment)|talent.anger_management|!talent.titans_torment
    if ui.alwaysCdNever("Recklessness") and cast.able.recklessness() and (((not talent.angerManagement and cd.avatar.remains() < 1 and talent.titansTorment)
            or talent.angerManagement or not talent.titansTorment))
    then
        if cast.recklessness() then
            ui.debug("Casting Recklessness [Slayer Mt]")
            return true
        end
    end
    -- Avatar
    -- avatar,if=(talent.titans_torment&(buff.enrage.up|talent.titanic_rage)&(debuff.champions_might.up|!talent.champions_might))|!talent.titans_torment
    if ui.alwaysCdNever("Avatar") and cast.able.avatar() and (((talent.titansTorment and (buff.enrage.exists() or talent.titanicRage)
            and (debuff.championsMight.exists(units.dyn5) or not talent.championsMight)) or not talent.titansTorment))
    then
        if cast.avatar() then
            ui.debug("Casting Avatar [Slayer Mt]")
            return true
        end
    end
    -- Thunderous Roar
    -- thunderous_roar,if=buff.enrage.up
    if ui.alwaysCdAoENever("Thunderous Roar", 1, 12) and cast.able.thunderousRoar("player", "aoe", 1, 12) and buff.enrage.exists() then
        if cast.thunderousRoar("player", "aoe", 1, 12) then
            ui.debug("Casting Thunderous Roar [Slayer Mt]")
            return true
        end
    end
    -- Champion's Spear
    -- champions_spear,if=(buff.enrage.up&talent.titans_torment&cooldown.avatar.remains<gcd)|(buff.enrage.up&!talent.titans_torment)
    if ui.alwaysCdAoENever("Champion's Spear", 1, 5) and cast.able.championsSpear(units.dyn25, "ground", 1, 5) and (((buff.enrage.exists() and talent.titansTorment
            and cd.avatar.remains() < unit.gcd(true)) or (buff.enrage.exists() and not talent.titansTorment)))
    then
        if cast.championsSpear(units.dyn25, "ground", 1, 5) then
            ui.debug("Casting Champions Spear [Slayer Mt]")
            return true
        end
    end
    -- Odyn's Fury
    -- odyns_fury,if=dot.odyns_fury_torment_mh.remains<1&(buff.enrage.up|talent.titanic_rage)&cooldown.avatar.remains
    if ui.alwaysCdAoENever("Odyn's Fury", 1, 12) and cast.able.odynsFury("player", "aoe", 1, 12) and ((debuff.odynsFuryTormentMh.remains(units.dyn12AOE) < 1
            and (buff.enrage.exists() or talent.titanicRage) and cd.avatar.remains()))
    then
        if cast.odynsFury("player", "aoe", 1, 12) then
            ui.debug("Casting Odyns Fury [Slayer Mt]")
            return true
        end
    end
    -- Whirlwind
    -- whirlwind,if=buff.meat_cleaver.stack=0&talent.meat_cleaver
    if cast.able.whirlwind("player", "aoe", 1, 8) and buff.meatCleaver.stack() == 0 and talent.meatCleaver then
        if cast.whirlwind("player", "aoe", 1, 8) then
            ui.debug("Casting Whirlwind - Meat Cleaver [Slayer Mt]")
            return true
        end
    end
    -- Execute
    -- execute,if=talent.ashen_juggernaut&buff.ashen_juggernaut.remains<=gcd&buff.enrage.up
    if cast.able.execute() and talent.ashenJuggernaut and buff.ashenJuggernaut.remains() <= unit.gcd(true) and buff.enrage.exists() then
        if cast.execute() then
            ui.debug("Casting Execute - Ashen Juggernaut [Slayer Mt]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=talent.bladestorm&cooldown.bladestorm.remains<=gcd&!debuff.champions_might.up
    if cast.able.rampage() and talent.bladestorm and cd.bladestorm.remains() <= unit.gcd(true) and not debuff.championsMight.exists(units.dyn5) then
        if cast.rampage() then
            ui.debug("Casting Rampage - Bladestorm [Slayer Mt]")
            return true
        end
    end
    -- Bladestorm
    -- bladestorm,if=buff.enrage.up&cooldown.avatar.remains>=9
    if ui.alwaysCdAoENever("Bladestorm", 1, 8) and cast.able.bladestorm("player", "aoe", 1, 8) and buff.enrage.exists() and cd.avatar.remains() >= 9 then
        if cast.bladestorm("player", "aoe", 1, 8) then
            ui.debug("Casting Bladestorm [Slayer Mt]")
            return true
        end
    end
    -- Onslaught
    -- onslaught,if=talent.tenderize&buff.brutal_finish.up
    if cast.able.onslaught() and talent.tenderize and buff.brutalFinish.exists() then
        if cast.onslaught() then
            ui.debug("Casting Onslaught - Brutal Finish [Slayer Mt]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=talent.anger_management
    if cast.able.rampage() and talent.angerManagement then
        if cast.rampage() then
            ui.debug("Casting Rampage - Anger Management [Slayer Mt]")
            return true
        end
    end
    -- Crushing Blow
    -- crushing_blow
    if talent.recklessAbandon and cast.able.crushingBlow() then
        if cast.crushingBlow() then
            ui.debug("Casting Crushing Blow [Slayer Mt]")
            return true
        end
    end
    -- Onslaught
    -- onslaught,if=talent.tenderize
    if cast.able.onslaught() and talent.tenderize then
        if cast.onslaught() then
            ui.debug("Casting Onslaught - Tenderize [Slayer Mt]")
            return true
        end
    end
    -- Bloodbath
    -- bloodbath,if=buff.enrage.up
    if talent.recklessAbandon and cast.able.bloodbath() and buff.enrage.exists() then
        if cast.bloodbath() then
            ui.debug("Casting Bloodbath - Enrage [Slayer Mt]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=talent.reckless_abandon
    if cast.able.rampage() and talent.recklessAbandon then
        if cast.rampage() then
            ui.debug("Casting Rampage - Reckless Abandon [Slayer Mt]")
            return true
        end
    end
    -- Execute
    -- execute,if=buff.enrage.up&debuff.marked_for_execution.up
    if cast.able.execute() and buff.enrage.exists() and debuff.markedForExecution.exists(units.dyn5) then
        if cast.execute() then
            ui.debug("Casting Execute - Enrage [Slayer Mt]")
            return true
        end
    end
    -- Bloodbath
    -- bloodbath
    if talent.recklessAbandon and cast.able.bloodbath() then
        if cast.bloodbath() then
            ui.debug("Casting Bloodbath [Slayer Mt]")
            return true
        end
    end
    -- Raging Blow
    -- raging_blow,if=talent.slaughtering_strikes
    if not talent.recklessAbandon and cast.able.ragingBlow() and talent.slaughteringStrikes then
        if cast.ragingBlow() then
            ui.debug("Casting Raging Blow - Slautering Strikes [Slayer Mt]")
            return true
        end
    end
    -- Onslaught
    -- onslaught
    if cast.able.onslaught() then
        if cast.onslaught() then
            ui.debug("Casting Onslaught [Slayer Mt]")
            return true
        end
    end
    -- Execute
    -- execute
    if var.executePhase and cast.able.execute() then
        if cast.execute() then
            ui.debug("Casting Execute [Slayer Mt]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=!talent.reckless_abandon&!talent.angerManagement&!talent.bladestorm
    if cast.able.rampage() and not talent.recklessAbandon and not talent.angerManagement and not talent.bladestorm then
        if cast.rampage() then
            ui.debug("Casting Rampage [Slayer St]")
            return true
        end
    end
    -- Bloodthirst
    -- bloodthirst
    if not talent.recklessAbandon and cast.able.bloodthirst() then
        if cast.bloodthirst() then
            ui.debug("Casting Bloodthirst [Slayer Mt]")
            return true
        end
    end
    -- Raging Blow
    -- raging_blow
    if not talent.recklessAbandon and cast.able.ragingBlow() then
        if cast.ragingBlow() then
            ui.debug("Casting Raging Blow [Slayer Mt]")
            return true
        end
    end
    -- Whirlwind
    -- whirlwind
    if cast.able.whirlwind("player", "aoe", 1, 8) then
        if cast.whirlwind("player", "aoe", 1, 8) then
            ui.debug("Casting Whirlwind [Slayer Mt]")
            return true
        end
    end
    -- Storm Bolt
    -- storm_bolt,if=buff.bladestorm.up
    if cast.able.stormBolt() and buff.bladestorm.exists() then
        if cast.stormBolt() then
            ui.debug("Casting Storm Bolt [Slayer Mt]")
            return true
        end
    end
end -- End Action list - SlayerMt

-- Action List - SlayerSt
actionList.SlayerSt = function()
    -- Recklessness
    -- recklessness,if=(!talent.anger_management&cooldown.avatar.remains<1&talent.titans_torment)|talent.anger_management|!talent.titans_torment
    if ui.alwaysCdNever("Recklessness") and cast.able.recklessness() and (((not talent.angerManagement and cd.avatar.remains() < 1 and talent.titansTorment)
            or talent.angerManagement or not talent.titansTorment))
    then
        if cast.recklessness() then
            ui.debug("Casting Recklessness [Slayer St]")
            return true
        end
    end
    -- Avatar
    -- avatar,if=(talent.titans_torment&(buff.enrage.up|talent.titanic_rage)&(debuff.champions_might.up|!talent.champions_might))|!talent.titans_torment
    if ui.alwaysCdNever("Avatar") and cast.able.avatar() and (((talent.titansTorment and (buff.enrage.exists() or talent.titanicRage)
            and (debuff.championsMight.exists(units.dyn5) or not talent.championsMight)) or not talent.titansTorment))
    then
        if cast.avatar() then
            ui.debug("Casting Avatar [Slayer St]")
            return true
        end
    end
    -- Thunderous Roar
    -- thunderous_roar,if=buff.enrage.up
    if ui.alwaysCdAoENever("Thunderous Roar", 1, 12) and cast.able.thunderousRoar("player", "aoe", 1, 12) and buff.enrage.exists() then
        if cast.thunderousRoar("player", "aoe", 1, 12) then
            ui.debug("Casting Thunderous Roar [Slayer St]")
            return true
        end
    end
    -- Champion's Spear
    -- champions_spear,if=(buff.enrage.up&talent.titans_torment&cooldown.avatar.remains<gcd)|(buff.enrage.up&!talent.titans_torment)
    if ui.alwaysCdAoENever("Champion's Spear", 1, 5) and cast.able.championsSpear(units.dyn25, "ground", 1, 5)
        and (((buff.enrage.exists() and talent.titansTorment and cd.avatar.remains() < unit.gcd(true))
            or (buff.enrage.exists() and not talent.titansTorment)))
    then
        if cast.championsSpear(units.dyn25, "ground", 1, 5) then
            ui.debug("Casting Champions Spear [Slayer St]")
            return true
        end
    end
    -- Odyn's Fury
    -- odyns_fury,if=dot.odyns_fury_torment_mh.remains<1&(buff.enrage.up|talent.titanic_rage)&cooldown.avatar.remains
    if ui.alwaysCdAoENever("Odyn's Fury", 1, 12) and cast.able.odynsFury("player", "aoe", 1, 12)
        and ((debuff.odynsFuryTormentMh.remains(units.dyn12AOE) < 1 and (buff.enrage.exists() or talent.titanicRage) and cd.avatar.remains()))
    then
        if cast.odynsFury("player", "aoe", 1, 12) then
            ui.debug("Casting Odyns Fury [Slayer St]")
            return true
        end
    end
    -- Execute
    -- execute,if=debuff.marked_for_execution.stack=3|(talent.ashen_juggernaut&buff.ashen_juggernaut.remains<=gcd&buff.enrage.up)
    if cast.able.execute() and ((debuff.markedForExecution.stack(units.dyn5) == 3
            or (talent.ashenJuggernaut and buff.ashenJuggernaut.remains() <= unit.gcd(true) and buff.enrage.exists())))
    then
        if cast.execute() then
            ui.debug("Casting Execute - Marked For Execution / Ashen Juggernaut [Slayer St]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=talent.bladestorm&cooldown.bladestorm.remains<=gcd&!debuff.champions_might.up
    if cast.able.rampage() and talent.bladestorm and cd.bladestorm.remains() <= unit.gcd(true) and not debuff.championsMight.exists(units.dyn5) then
        if cast.rampage() then
            ui.debug("Casting Rampage - Bladestorm Soon [Slayer St]")
            return true
        end
    end
    -- Bladestorm
    -- bladestorm,if=buff.enrage.up&cooldown.avatar.remains>=9
    if ui.alwaysCdAoENever("Bladestorm", 1, 8) and cast.able.bladestorm("player", "aoe", 1, 8) and buff.enrage.exists() and cd.avatar.remains() >= 9 then
        if cast.bladestorm("player", "aoe", 1, 8) then
            ui.debug("Casting Bladestorm [Slayer St]")
            return true
        end
    end
    -- Onslaught
    -- onslaught,if=talent.tenderize&buff.brutal_finish.up
    if cast.able.onslaught() and talent.tenderize and buff.brutalFinish.exists() then
        if cast.onslaught() then
            ui.debug("Casting Onslaught - Brutal Finish [Slayer St]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=talent.anger_management
    if cast.able.rampage() and talent.angerManagement then
        if cast.rampage() then
            ui.debug("Casting Rampage - Anger Management [Slayer St]")
            return true
        end
    end
    -- Crushing Blow
    -- crushing_blow
    if talent.recklessAbandon and cast.able.crushingBlow() then
        if cast.crushingBlow() then
            ui.debug("Casting Crushing Blow [Slayer St]")
            return true
        end
    end
    -- Onslaught
    -- onslaught,if=talent.tenderize
    if cast.able.onslaught() and talent.tenderize then
        if cast.onslaught() then
            ui.debug("Casting Onslaught - Tenderize [Slayer St]")
            return true
        end
    end
    -- Bloodbath
    -- bloodbath,if=rage<100|target.health.pct<35&talent.vicious_contempt
    if talent.recklessAbandon and cast.able.bloodbath() and ((rage() < 100 or unit.hp(units.dyn5) < 35 and talent.viciousContempt)) then
        if cast.bloodbath() then
            ui.debug("Casting Bloodbath [Slayer St]")
            return true
        end
    end
    -- Raging Blow
    -- raging_blow,if=rage<100&!buff.opportunist.up
    if not talent.recklessAbandon and cast.able.ragingBlow() and rage() < 100 and not buff.opportunist.exists() then
        if cast.ragingBlow() then
            ui.debug("Casting Raging Blow - No Opportunist [Slayer St]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=talent.reckless_abandon
    if cast.able.rampage() and talent.recklessAbandon then
        if cast.rampage() then
            ui.debug("Casting Rampage - Reckless Abandon [Slayer St]")
            return true
        end
    end
    -- Execute
    -- execute,if=buff.enrage.up&debuff.marked_for_execution.up
    if cast.able.execute() and buff.enrage.exists() and debuff.markedForExecution.exists(units.dyn5) then
        if cast.execute() then
            ui.debug("Casting Execute - Enrage [Slayer St]")
            return true
        end
    end
    -- Bloodthirst
    -- bloodthirst,if=!talent.reckless_abandon&buff.enrage.up
    if not talent.recklessAbandon and cast.able.bloodthirst() and not talent.recklessAbandon and buff.enrage.exists() then
        if cast.bloodthirst() then
            ui.debug("Casting Bloodthirst - Enrage [Slayer St]")
            return true
        end
    end
    -- Raging Blow
    -- raging_blow
    if not talent.recklessAbandon and cast.able.ragingBlow() then
        if cast.ragingBlow() then
            ui.debug("Casting Raging Blow [Slayer St]")
            return true
        end
    end
    -- Onslaught
    -- onslaught
    if cast.able.onslaught() then
        if cast.onslaught() then
            ui.debug("Casting Onslaught [Slayer St]")
            return true
        end
    end
    -- Execute
    -- execute
    if var.executePhase and cast.able.execute() then
        if cast.execute() then
            ui.debug("Casting Execute [Slayer St]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=!talent.reckless_abandon&!talent.angerManagement&!talent.bladestorm
    if cast.able.rampage() and not talent.recklessAbandon and not talent.angerManagement and not talent.bladestorm then
        if cast.rampage() then
            ui.debug("Casting Rampage [Slayer St]")
            return true
        end
    end
    -- Bloodthirst
    -- bloodthirst
    if not talent.recklessAbandon and cast.able.bloodthirst() then
        if cast.bloodthirst() then
            ui.debug("Casting Bloodthirst [Slayer St]")
            return true
        end
    end
    -- Whirlwind
    -- whirlwind,if=talent.meat_cleaver
    if cast.able.whirlwind("player", "aoe", 1, 8) and talent.meatCleaver then
        if cast.whirlwind("player", "aoe", 1, 8) then
            ui.debug("Casting Whirlwind [Slayer St]")
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
end -- End Action List - SlayeSt

-- Action List - ThaneMt
actionList.ThaneMt = function()
    -- Recklessness
    -- recklessness,if=(!talent.anger_management&cooldown.avatar.remains<1&talent.titans_torment)|talent.anger_management|!talent.titans_torment
    if ui.alwaysCdNever("Recklessness") and cast.able.recklessness() and (((not talent.angerManagement and cd.avatar.remains() < 1 and talent.titansTorment)
            or talent.angerManagement or not talent.titansTorment))
    then
        if cast.recklessness() then
            ui.debug("Casting Recklessness [Thane Mt]")
            return true
        end
    end
    -- Thunder Blast
    -- thunder_blast,if=buff.enrage.up
    if cast.able.thunderBlast("player", "aoe", 1, 8) and buff.enrage.exists() then
        if cast.thunderBlast("player", "aoe", 1, 8) then
            ui.debug("Casting Thunder Blast [Thane Mt]")
            return true
        end
    end
    -- Avatar
    -- avatar,if=(talent.titans_torment&(buff.enrage.up|talent.titanic_rage)&(debuff.champions_might.up|!talent.champions_might))|!talent.titans_torment
    if ui.alwaysCdNever("Avatar") and cast.able.avatar() and (((talent.titansTorment and (buff.enrage.exists() or talent.titanicRage)
            and (debuff.championsMight.exists(units.dyn5) or not talent.championsMight)) or not talent.titansTorment))
    then
        if cast.avatar() then
            ui.debug("Casting Avatar [Thane Mt]")
            return true
        end
    end
    -- Thunder Clap
    -- thunder_clap,if=buff.meat_cleaver.stack=0&talent.meat_cleaver
    if cast.able.thunderClap("player", "aoe", 1, 8) and buff.meatCleaver.stack() == 0 and talent.meatCleaver then
        if cast.thunderClap("player", "aoe", 1, 8) then
            ui.debug("Casting Thunder Clap - Meat Cleaver [Thane Mt]")
            return true
        end
    end
    -- Thunderous Roar
    -- thunderous_roar,if=buff.enrage.up
    if ui.alwaysCdAoENever("Thunderous Roar", 1, 12) and cast.able.thunderousRoar("player", "aoe", 1, 12) and buff.enrage.exists() then
        if cast.thunderousRoar("player", "aoe", 1, 12) then
            ui.debug("Casting Thunderous Roar [Thane Mt]")
            return true
        end
    end
    -- Ravager
    -- ravager
    if ui.alwaysCdAoENever("Ravager", 1, 8) and cast.able.ravager(units.dyn40, "ground", 1, 8) then
        if cast.ravager(units.dyn40, "ground", 1, 8) then
            ui.debug("Casting Ravager [Thane Mt]")
            return true
        end
    end
    -- Champion's Spear
    -- champions_spear,if=buff.enrage.up
    if ui.alwaysCdAoENever("Champion's Spear", 1, 5) and cast.able.championsSpear(units.dyn25, "ground", 1, 5) and buff.enrage.exists() then
        if cast.championsSpear(units.dyn25, "ground", 1, 5) then
            ui.debug("Casting Champions Spear [Thane Mt]")
            return true
        end
    end
    -- Odyn's Fury
    -- odyns_fury,if=dot.odyns_fury_torment_mh.remains<1&(buff.enrage.up|talent.titanic_rage)&cooldown.avatar.remains
    if ui.alwaysCdAoENever("Odyn's Fury", 1, 12) and cast.able.odynsFury("player", "aoe", 1, 12)
        and ((debuff.odynsFuryTormentMh.remains(units.dyn12AOE) < 1 and (buff.enrage.exists() or talent.titanicRage) and cd.avatar.remains()))
    then
        if cast.odynsFury("player", "aoe", 1, 12) then
            ui.debug("Casting Odyns Fury [Thane Mt]")
            return true
        end
    end
    -- Execute
    -- execute,if=talent.ashen_juggernaut&buff.ashen_juggernaut.remains<=gcd&buff.enrage.up
    if cast.able.execute() and talent.ashenJuggernaut and buff.ashenJuggernaut.remains() <= unit.gcd(true) and buff.enrage.exists() then
        if cast.execute() then
            ui.debug("Casting Execute - Ashen Juggernaut [Thane Mt]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=talent.bladestorm&cooldown.bladestorm.remains<=gcd&!debuff.champions_might.up
    if cast.able.rampage() and talent.bladestorm and cd.bladestorm.remains() <= unit.gcd(true) and not debuff.championsMight.exists(units.dyn5) then
        if cast.rampage() then
            ui.debug("Casting Rampage - Bladestorm [Thane Mt]")
            return true
        end
    end
    -- Bladestorm
    -- bladestorm,if=buff.enrage.up
    if ui.alwaysCdAoENever("Bladestorm", 1, 8) and cast.able.bladestorm("player", "aoe", 1, 8) and buff.enrage.exists() then
        if cast.bladestorm("player", "aoe", 1, 8) then
            ui.debug("Casting Bladestorm [Thane Mt]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=talent.anger_management
    if cast.able.rampage() and talent.angerManagement then
        if cast.rampage() then
            ui.debug("Casting Rampage - Anger Management [Thane Mt]")
            return true
        end
    end
    -- Crushing Blow
    -- crushing_blow,if=buff.enrage.up
    if talent.recklessAbandon and cast.able.crushingBlow() and buff.enrage.exists() then
        if cast.crushingBlow() then
            ui.debug("Casting Crushing Blow [Thane Mt]")
            return true
        end
    end
    -- Onslaught
    -- onslaught,if=talent.tenderize
    if cast.able.onslaught() and talent.tenderize then
        if cast.onslaught() then
            ui.debug("Casting Onslaught - Tenderize [Thane Mt]")
            return true
        end
    end
    -- Bloodbath
    -- bloodbath
    if talent.recklessAbandon and cast.able.bloodbath() then
        if cast.bloodbath() then
            ui.debug("Casting Bloodbath [Thane Mt]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=talent.reckless_abandon
    if cast.able.rampage() and talent.recklessAbandon then
        if cast.rampage() then
            ui.debug("Casting Rampage - Reckless Abandon [Thane Mt]")
            return true
        end
    end
    -- Bloodthirst
    -- bloodthirst
    if not talent.recklessAbandon and cast.able.bloodthirst() then
        if cast.bloodthirst() then
            ui.debug("Casting Bloodthirst [Thane Mt]")
            return true
        end
    end
    -- Thunder Clap
    -- thunder_clap
    if cast.able.thunderClap("player", "aoe", 1, 8) then
        if cast.thunderClap("player", "aoe", 1, 8) then
            ui.debug("Casting Thunder Clap [Thane Mt]")
            return true
        end
    end
    -- Onslaught
    -- onslaught
    if cast.able.onslaught() then
        if cast.onslaught() then
            ui.debug("Casting Onslaught [Thane Mt]")
            return true
        end
    end
    -- Execute
    -- execute
    if cast.able.execute() then
        if cast.execute() then
            ui.debug("Casting Execute [Thane Mt]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=!talent.reckless_abandon&!talent.angerManagement&!talent.bladestorm
    if cast.able.rampage() and not talent.recklessAbandon and not talent.angerManagement and not talent.bladestorm then
        if cast.rampage() then
            ui.debug("Casting Rampage [Thane Mt]")
            return true
        end
    end
    -- Raging Blow
    -- raging_blow
    if not talent.recklessAbandon and cast.able.ragingBlow() then
        if cast.ragingBlow() then
            ui.debug("Casting Raging Blow [Thane Mt]")
            return true
        end
    end
    -- Whirlwind
    -- whirlwind
    if cast.able.whirlwind("player", "aoe", 1, 8) then
        if cast.whirlwind("player", "aoe", 1, 8) then
            ui.debug("Casting Whirlwind [Thane Mt]")
            return true
        end
    end
end -- End Action List - ThaneMt

-- Action List - ThaneSt
actionList.ThaneSt = function()
    -- Recklessness
    -- recklessness,if=(!talent.anger_management&cooldown.avatar.remains<1&talent.titans_torment)|talent.anger_management|!talent.titans_torment
    if ui.alwaysCdNever("Recklessness") and cast.able.recklessness() and (((not talent.angerManagement and cd.avatar.remains() < 1 and talent.titansTorment)
            or talent.angerManagement or not talent.titansTorment))
    then
        if cast.recklessness() then
            ui.debug("Casting Recklessness [Thane St]")
            return true
        end
    end
    -- Thunder Blast
    -- thunder_blast,if=buff.enrage.up
    if cast.able.thunderBlast("player", "aoe", 1, 8) and buff.enrage.exists() then
        if cast.thunderBlast("player", "aoe", 1, 8) then
            ui.debug("Casting Thunder Blast [Thane St]")
            return true
        end
    end
    -- Avatar
    -- avatar,if=(talent.titans_torment&(buff.enrage.up|talent.titanic_rage)&(debuff.champions_might.up|!talent.champions_might))|!talent.titans_torment
    if ui.alwaysCdNever("Avatar") and cast.able.avatar() and (((talent.titansTorment and (buff.enrage.exists() or talent.titanicRage)
            and (debuff.championsMight.exists(units.dyn5) or not talent.championsMight)) or not talent.titansTorment))
    then
        if cast.avatar() then
            ui.debug("Casting Avatar [Thane St]")
            return true
        end
    end
    -- Ravager
    -- ravager
    if ui.alwaysCdAoENever("Ravager", 1, 8) and cast.able.ravager(units.dyn40, "ground", 1, 8) then
        if cast.ravager(units.dyn40, "ground", 1, 8) then
            ui.debug("Casting Ravager [Thane St]")
            return true
        end
    end
    -- Thunderous Roar
    -- thunderous_roar,if=buff.enrage.up
    if ui.alwaysCdAoENever("Thunderous Roar", 1, 12) and cast.able.thunderousRoar("player", "aoe", 1, 12) and buff.enrage.exists() then
        if cast.thunderousRoar("player", "aoe", 1, 12) then
            ui.debug("Casting Thunderous Roar [Thane St]")
            return true
        end
    end
    -- Champion's Spear
    -- champions_spear,if=buff.enrage.up&(cooldown.avatar.remains<gcd|!talent.titans_torment)
    if ui.alwaysCdAoENever("Champion's Spear", 1, 5) and cast.able.championsSpear(units.dyn25, "ground", 1, 5)
        and ((buff.enrage.exists() and (cd.avatar.remains() < unit.gcd(true) or not talent.titansTorment)))
    then
        if cast.championsSpear(units.dyn25, "ground", 1, 5) then
            ui.debug("Casting Champions Spear [Thane St]")
            return true
        end
    end
    -- Odyn's Fury
    -- odyns_fury,if=dot.odyns_fury_torment_mh.remains<1&(buff.enrage.up|talent.titanic_rage)&cooldown.avatar.remains
    if ui.alwaysCdAoENever("Odyn's Fury", 1, 12) and cast.able.odynsFury("player", "aoe", 1, 12)
        and ((debuff.odynsFuryTormentMh.remains(units.dyn12AOE) < 1 and (buff.enrage.exists() or talent.titanicRage) and cd.avatar.remains()))
    then
        if cast.odynsFury("player", "aoe", 1, 12) then
            ui.debug("Casting Odyns Fury [Thane St]")
            return true
        end
    end
    -- Execute
    -- execute,if=talent.ashen_juggernaut&buff.ashen_juggernaut.remains<=gcd&buff.enrage.up
    if cast.able.execute() and talent.ashenJuggernaut and buff.ashenJuggernaut.remains() <= unit.gcd(true) and buff.enrage.exists() then
        if cast.execute() then
            ui.debug("Casting Execute - Ashen Juggernaut [Thane St]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=talent.bladestorm&cooldown.bladestorm.remains<=gcd&!debuff.champions_might.up
    if cast.able.rampage() and talent.bladestorm and cd.bladestorm.remains() <= unit.gcd(true) and not debuff.championsMight.exists(units.dyn5) then
        if cast.rampage() then
            ui.debug("Casting Rampage - Bladestorm [Thane St]")
            return true
        end
    end
    -- Bladestorm
    -- bladestorm,if=buff.enrage.up&talent.unhinged
    if ui.alwaysCdAoENever("Bladestorm", 1, 8) and cast.able.bladestorm("player", "aoe", 1, 8) and buff.enrage.exists() and talent.unhinged then
        if cast.bladestorm("player", "aoe", 1, 8) then
            ui.debug("Casting Bladestorm [Thane St]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=talent.anger_management
    if cast.able.rampage() and talent.angerManagement then
        if cast.rampage() then
            ui.debug("Casting Rampage - Anger Management [Thane St]")
            return true
        end
    end
    -- Crushing Blow
    -- crushing_blow
    if talent.recklessAbandon and cast.able.crushingBlow() then
        if cast.crushingBlow() then
            ui.debug("Casting Crushing Blow [Thane St]")
            return true
        end
    end
    -- Onslaught
    -- onslaught,if=talent.tenderize
    if cast.able.onslaught() and talent.tenderize then
        if cast.onslaught() then
            ui.debug("Casting Onslaught - Tenderize [Thane St]")
            return true
        end
    end
    -- Bloodbath
    -- bloodbath
    if talent.recklessAbandon and cast.able.bloodbath() then
        if cast.bloodbath() then
            ui.debug("Casting Bloodbath [Thane St]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=talent.reckless_abandon
    if cast.able.rampage() and talent.recklessAbandon then
        if cast.rampage() then
            ui.debug("Casting Rampage - Reckless Abandon [Thane St]")
            return true
        end
    end
    -- Raging Blow
    -- raging_blow
    if not talent.recklessAbandon and cast.able.ragingBlow() then
        if cast.ragingBlow() then
            ui.debug("Casting Raging Blow [Thane St]")
            return true
        end
    end
    -- Execute
    -- execute
    if cast.able.execute() then
        if cast.execute() then
            ui.debug("Casting Execute [Thane St]")
            return true
        end
    end
    -- Bloodthirst
    -- bloodthirst,if=buff.enrage.up&(!buff.burst_of_power.up|!talent.reckless_abandon)
    if cast.able.bloodthirst() and ((buff.enrage.exists() and (not buff.burstOfPower.exists() or not talent.recklessAbandon))) then
        if cast.bloodthirst() then
            ui.debug("Casting Bloodthirst - Enrage [Thane St]")
            return true
        end
    end
    -- Onslaught
    -- onslaught
    if cast.able.onslaught() then
        if cast.onslaught() then
            ui.debug("Casting Onslaught [Thane St]")
            return true
        end
    end
    -- Rampage
    -- rampage,if=!talent.reckless_abandon&!talent.angerManagement&!talent.bladestorm
    if cast.able.rampage() and not talent.recklessAbandon and not talent.angerManagement and not talent.bladestorm then
        if cast.rampage() then
            ui.debug("Casting Rampage [Thane St]")
            return true
        end
    end
    -- Bloodthirst
    -- bloodthirst
    if not talent.recklessAbandon and cast.able.bloodthirst() then
        if cast.bloodthirst() then
            ui.debug("Casting Bloodthirst [Thane St]")
            return true
        end
    end
    -- Thunder Clap
    -- thunder_clap
    if cast.able.thunderClap("player", "aoe", 1, 8) then
        if cast.thunderClap("player", "aoe", 1, 8) then
            ui.debug("Casting Thunder Clap [Thane St]")
            return true
        end
    end
    -- Whirlwind
    -- whirlwind,if=talent.meat_cleaver
    if cast.able.whirlwind("player", "aoe", 1, 8) and talent.meatCleaver then
        if cast.whirlwind("player", "aoe", 1, 8) then
            ui.debug("Casting Whirlwind [Thane St]")
            return true
        end
    end
    -- Slam
    -- slam
    if cast.able.slam() then
        if cast.slam() then
            ui.debug("Casting Slam [Thane St]")
            return true
        end
    end
end -- End Action List - ThaneSt

-- Action List - Trinkets
actionList.Trinkets = function()
    -- -- Do Treacherous Transmitter Task
    -- -- do_treacherous_transmitter_task
    -- if cast.able.doTreacherousTransmitterTask() then
    --     if cast.doTreacherousTransmitterTask() then
    --         ui.debug("Casting Do Treacherous Transmitter Task [Trinkets]")
    --         return true
    --     end
    -- end

    -- Use Item - Treacherous Transmitter
    -- use_item,name=treacherous_transmitter,if=variable.adds_remain|variable.st_planning
    if use.able.treacherousTransmitter() and ((var.addsRemain or var.stPlanning)) then
        if use.treacherousTransmitter() then
            ui.debug("Using Treacherous Transmitter [Trinkets]")
            return true
        end
    end

    -- Use Item - Slot1
    -- use_item,slot=trinket1,if=variable.trinket_1_buffs&!variable.trinket_1_manual&(!buff.avatar.up&trinket.1.cast_time>0|!trinket.1.cast_time>0)&((talent.titans_torment&cooldown.avatar.ready)|(buff.avatar.up&!talent.titans_torment))&(variable.trinket_2_exclude|!trinket.2.has_cooldown|trinket.2.cooldown.remains|variable.trinket_priority=1)|trinket.1.proc.any_dps.duration>=fight_remains
    -- if use.able.slot1() and ((var.trinket1Buffs and not var.trinket1Manual and (not buff.avatar.exists() and >0 or not >0) and ((talent.titansTorment and not cd.avatar.exists()) or (buff.avatar.exists() and not talent.titansTorment)) and (var.trinket2Exclude or not  or cd.slot.remains(14) or var.trinketPriority==1) or >=unit.ttdGroup(40))) then
    --     if use.slot1() then ui.debug("Using Slot1 [Trinkets]") return true end
    -- end

    -- Use Item - Slot2
    -- use_item,slot=trinket2,if=variable.trinket_2_buffs&!variable.trinket_2_manual&(!buff.avatar.up&trinket.2.cast_time>0|!trinket.2.cast_time>0)&((talent.titans_torment&cooldown.avatar.ready)|(buff.avatar.up&!talent.titans_torment))&(variable.trinket_1_exclude|!trinket.1.has_cooldown|trinket.1.cooldown.remains|variable.trinket_priority=2)|trinket.2.proc.any_dps.duration>=fight_remains
    -- if use.able.slot2() and ((var.trinket2Buffs and not var.trinket2Manual and (not buff.avatar.exists() and >0 or not >0) and ((talent.titansTorment and not cd.avatar.exists()) or (buff.avatar.exists() and not talent.titansTorment)) and (var.trinket1Exclude or not  or cd.slot.remains(13) or var.trinketPriority==2) or >=unit.ttdGroup(40))) then
    --     if use.slot2() then ui.debug("Using Slot2 [Trinkets]") return true end
    -- end

    -- Use Item - Slot1
    -- use_item,slot=trinket1,if=!variable.trinket_1_buffs&(trinket.1.cast_time>0&!buff.avatar.up|!trinket.1.cast_time>0)&!variable.trinket_1_manual&(!variable.trinket_1_buffs&(trinket.2.cooldown.remains|!variable.trinket_2_buffs)|(trinket.1.cast_time>0&!buff.avatar.up|!trinket.1.cast_time>0)|cooldown.avatar.remains_expected>20)
    -- if use.able.slot1() and ((not var.trinket1Buffs and (>0 and not buff.avatar.exists() or not >0) and not var.trinket1Manual and (not var.trinket1Buffs and (cd.slot.remains(14) or not var.trinket2Buffs) or (>0 and not buff.avatar.exists() or not >0) or >20))) then
    --     if use.slot1() then ui.debug("Using Slot1 [Trinkets]") return true end
    -- end

    -- Use Item - Slot2
    -- use_item,slot=trinket2,if=!variable.trinket_2_buffs&(trinket.2.cast_time>0&!buff.avatar.up|!trinket.2.cast_time>0)&!variable.trinket_2_manual&(!variable.trinket_2_buffs&(trinket.1.cooldown.remains|!variable.trinket_1_buffs)|(trinket.2.cast_time>0&!buff.avatar.up|!trinket.2.cast_time>0)|cooldown.avatar.remains_expected>20)
    -- if use.able.slot2() and ((not var.trinket2Buffs and (>0 and not buff.avatar.exists() or not >0) and not var.trinket2Manual and (not var.trinket2Buffs and (cd.slot.remains(13) or not var.trinket1Buffs) or (>0 and not buff.avatar.exists() or not >0) or >20))) then
    --     if use.slot2() then ui.debug("Using Slot2 [Trinkets]") return true end
    -- end

    -- Use Item - Slot=Main Hand
    -- use_item,slot=main_hand,if=!equipped.fyralath_the_dreamrender&(!variable.trinket_1_buffs|trinket.1.cooldown.remains)&(!variable.trinket_2_buffs|trinket.2.cooldown.remains)
    if use.able.slot(16) and ((not equiped.fyralathTheDreamrender() and (not var.trinket1Buffs or cd.slot.remains(13)) and (not var.trinket2Buffs or cd.slot.remains(14)))) then
        if use.slot(16) then
            ui.debug("Using Slot Main Hand [Trinkets]")
            return true
        end
    end
end -- End Action List - Trinkets

-- Action List - Variables
actionList.Variables = function()
    -- Variable - St Planning
    -- variable,name=st_planning,value=active_enemies=1&(raid_event.adds.in>15|!raid_event.adds.exists)
    var.stPlanning = (ui.useST(8, 2))
    -- Variable - Adds Remain
    -- variable,name=adds_remain,value=active_enemies>=2&(!raid_event.adds.exists|raid_event.adds.exists&raid_event.adds.remains>5)
    var.addsRemain = (ui.useAOE(8, 2))
    -- Variable - Execute Phase
    -- variable,name=execute_phase,value=(talent.massacre.enabled&target.health.pct<35)|target.health.pct<20
    var.executePhase = ((talent.massacre and unit.hp(units.dyn5) < 35) or unit.hp(units.dyn5) < 20)
    -- Variable - On Gcd Racials
    -- variable,name=on_gcd_racials,value=buff.recklessness.down&buff.avatar.down&rage<80&buff.bloodbath.down&buff.crushing_blow.down&buff.sudden_death.down&!cooldown.bladestorm.ready&(!cooldown.execute.ready|!variable.execute_phase)
    var.onGcdRacials = (not buff.recklessness.exists() and not buff.avatar.exists() and rage() < 80 and not buff.bloodbath.exists()
        and not buff.crushingBlow.exists() and not buff.suddenDeath.exists() and not not cd.bladestorm.exists() and (not not cd.execute.exists() or not var.executePhase))
end -- End Action List - Variables

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then
        -- Variable - Trinket 1 Exclude
        -- variable,name=trinket_1_exclude,value=trinket.1.is.treacherous_transmitter
        var.trinket1Exclude = false -- TODO: Optional replace with UI option, review SimC for detailed notes

        -- Variable - Trinket 2 Exclude
        -- variable,name=trinket_2_exclude,value=trinket.2.is.treacherous_transmitter
        var.trinket2Exclude = false -- TODO: Optional replace with UI option, review SimC for detailed notes

        -- Variable - Trinket 1 Sync,Op=Setif,Value=1,Value Else=0.5,Condition=Trinket.1.Has Use Buff&(Trinket.1.Cooldown.Duration%%Cooldown.Avatar.Duration=0|Trinket.1.Cooldown.Duration%%Cooldown.Odyns Fury.Duration=0)
        -- variable,name=trinket_1_sync,op=setif,value=1,value_else=0.5,condition=trinket.1.has_use_buff&(trinket.1.cooldown.duration%%cooldown.avatar.duration=0|trinket.1.cooldown.duration%%cooldown.odyns_fury.duration=0)
        var.trinket1Sync = false -- TODO: Optional replace with UI option, review SimC for detailed notes

        -- Variable - Trinket 2 Sync,Op=Setif,Value=1,Value Else=0.5,Condition=Trinket.2.Has Use Buff&(Trinket.2.Cooldown.Duration%%Cooldown.Avatar.Duration=0|Trinket.2.Cooldown.Duration%%Cooldown.Odyns Fury.Duration=0)
        -- variable,name=trinket_2_sync,op=setif,value=1,value_else=0.5,condition=trinket.2.has_use_buff&(trinket.2.cooldown.duration%%cooldown.avatar.duration=0|trinket.2.cooldown.duration%%cooldown.odyns_fury.duration=0)
        var.trinket2Sync = false -- TODO: Optional replace with UI option, review SimC for detailed notes

        -- Variable - Trinket 1 Buffs
        -- variable,name=trinket_1_buffs,value=trinket.1.has_use_buff|(trinket.1.has_stat.any_dps&!variable.trinket_1_exclude)
        var.trinket1Buffs = false

        -- Variable - Trinket 2 Buffs
        -- variable,name=trinket_2_buffs,value=trinket.2.has_use_buff|(trinket.2.has_stat.any_dps&!variable.trinket_2_exclude)
        var.trinket2Buffs = false

        -- Variable - Trinket Priority,Op=Setif,Value=2,Value Else=1,Condition=!Variable.Trinket 1 Buffs&Variable.Trinket 2 Buffs|Variable.Trinket 2 Buffs&((Trinket.2.Cooldown.Duration%Trinket.2.Proc.Any Dps.Duration)*(1.5+Trinket.2.Has Buff.Strength)*(Variable.Trinket 2 Sync))>((Trinket.1.Cooldown.Duration%Trinket.1.Proc.Any Dps.Duration)*(1.5+Trinket.1.Has Buff.Strength)*(Variable.Trinket 1 Sync))
        -- variable,name=trinket_priority,op=setif,value=2,value_else=1,condition=!variable.trinket_1_buffs&variable.trinket_2_buffs|variable.trinket_2_buffs&((trinket.2.cooldown.duration%trinket.2.proc.any_dps.duration)*(1.5+trinket.2.has_buff.strength)*(variable.trinket_2_sync))>((trinket.1.cooldown.duration%trinket.1.proc.any_dps.duration)*(1.5+trinket.1.has_buff.strength)*(variable.trinket_1_sync))
        var.trinketPriority = false -- TODO: Optional replace with UI option, review SimC for detailed notes

        -- Variable - Trinket 1 Manual
        -- variable,name=trinket_1_manual,value=trinket.1.is.algethar_puzzle_box
        var.trinket1Manual = false -- TODO: Optional replace with UI option, review SimC for detailed notes

        -- Variable - Trinket 2 Manual
        -- variable,name=trinket_2_manual,value=trinket.2.is.algethar_puzzle_box
        var.trinket2Manual = false -- TODO: Optional replace with UI option, review SimC for detailed notes

        -- Variable - Treacherous Transmitter Precombat Cast
        -- variable,name=treacherous_transmitter_precombat_cast,value=2
        var.treacherousTransmitterPrecombatCast = 2

        -- Pre-Pull
        if ui.checked("Pre-Pull Timer") and unit.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Use Item - Treacherous Transmitter
            -- use_item,name=treacherous_transmitter
            if use.able.treacherousTransmitter() then
                if use.treacherousTransmitter() then
                    ui.debug("Using Treacherous Transmitter [Precombat]")
                    return true
                end
            end
            -- Potion
            -- potion
            -- if ui.checked("Potion") and br.functions.item:canUseItem(142117) and unit.instance("raid") then
            --     if feralSpiritRemain > 5 and not buff.prolongedPower.exists() then
            --         br.functions.item:useItem(142117)
            --     end
            -- end
        end -- End Pre-Pull
        if unit.valid("target") then
            -- Berserker Stance
            -- berserker_stance,toggle=on
            if cast.able.berserkerStance() and not buff.berserkerStance.exists() then
                if cast.berserkerStance() then
                    ui.debug("Casting Berserker Stance [Precombat]")
                    return true
                end
            end
            -- Recklessness
            -- recklessness,if=!equipped.fyralath_the_dreamrender
            if ui.alwaysCdNever("Recklessness") and cast.able.recklessness() and not equiped.fyralathTheDreamrender() then
                if cast.recklessness() then
                    ui.debug("Casting Recklessness [Precombat]")
                    return true
                end
            end
            -- Avatar
            -- avatar,if=!talent.titans_torment
            if ui.alwaysCdNever("Avatar") and cast.able.avatar() and not talent.titansTorment then
                if cast.avatar() then
                    ui.debug("Casting Avatar [Precombat]")
                    return true
                end
            end
            -- Call Action List - Movement
            if actionList.Movement() then return true end
            -- -- Charge
            -- -- charge
            -- if ui.mode.mover == 1 and ui.checked("Charge") and cast.able.charge("target") then
            --     if cast.charge("target") then
            --         ui.debug("Casting Charge")
            --         return true
            --     end
            -- end
            -- -- Taunt
            -- if cast.able.taunt("target") and unit.solo() and not cast.able.charge("target") then
            --     if cast.taunt("target") then
            --         ui.debug("Casting Taunt")
            --         return true
            --     end
            -- end
            -- Start Attack
            if cast.able.autoAttack("target") and unit.distance("target") < 5 then
                if cast.autoAttack("target") then
                    ui.debug("Casting Auto Attack [Pre-Combat]")
                    return true
                end
            end
        end
    end -- End No Combat
end     -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    if unit.inCombat() and unit.valid("target") and not var.profileStop then
        -- Call Action List - Movement
        if actionList.Movement() then return true end
        -- Auto Attack
        -- auto_attack
        if cast.able.autoAttack("target") and unit.distance("target") < 5 then
            if cast.autoAttack("target") then
                ui.debug("Casting Auto Attack [Combat]")
                return true
            end
        end
        -- Module - Combatpotion Up
        -- potion
        module.CombatPotionUp()
        -- Call Action List - Interrupts
        -- call_action_list,name=interrupts
        if actionList.Interrupts() then return true end
        -- Call Action List - Trinkets
        -- call_action_list,name=trinkets
        if actionList.Trinkets() then return true end
        -- Call Action List - Variables
        -- call_action_list,name=variables
        if actionList.Variables() then return true end
        -- Racials
        if ui.alwaysCdAoENeverRange("Racial") and cast.able.racial() then
            -- Lights Judgment
            -- lights_judgment,if=variable.on_gcd_racials
            if race == "LightforgedDraenei" and cast.able.lightsJudgment() and var.onGcdRacials then
                if cast.lightsJudgment() then
                    ui.debug("Casting Lights Judgment [Combat]")
                    return true
                end
            end
            -- Bag Of Tricks
            -- bag_of_tricks,if=variable.on_gcd_racials
            if race == "Vulpera" and cast.able.bagOfTricks() and var.onGcdRacials then
                if cast.bagOfTricks() then
                    ui.debug("Casting Bag Of Tricks [Combat]")
                    return true
                end
            end
            -- Berserking
            -- berserking,if=buff.recklessness.up
            if race == "Troll" and cast.able.racial() and buff.recklessness.exists() then
                if cast.racial() then
                    ui.debug("Casting Berserking [Combat]")
                    return true
                end
            end
            -- Blood Fury
            -- blood_fury
            if race == "Orc" and cast.able.racial() then
                if cast.racial() then
                    ui.debug("Casting Blood Fury [Combat]")
                    return true
                end
            end
            -- Fireblood
            -- fireblood
            if race == "DarkIronDwarf" and cast.able.fireblood() then
                if cast.fireblood() then
                    ui.debug("Casting Fireblood [Combat]")
                    return true
                end
            end
            -- Ancestral Call
            -- ancestral_call
            if race == "MagharOrc" and cast.able.ancestralCall() then
                if cast.ancestralCall() then
                    ui.debug("Casting Ancestral Call [Combat]")
                    return true
                end
            end
        end
        -- Call Action List - Slayer St
        -- run_action_list,name=slayer_st,if=talent.slayers_dominance&active_enemies=1
        if (talent.slayersDominance or (not talent.slayersDominance and not talent.lightningStrikes)) and ui.useST(8, 2) then
            if actionList.SlayerSt() then return true end
        end
        -- Call Action List - Slayer Mt
        -- run_action_list,name=slayer_mt,if=talent.slayers_dominance&active_enemies>1
        if (talent.slayersDominance or (not talent.slayersDominance and not talent.lightningStrikes)) and ui.useAOE(8, 2) then
            if actionList.SlayerMt() then return true end
        end
        -- Call Action List - Thane St
        -- run_action_list,name=thane_st,if=talent.lightning_strikes&active_enemies=1
        if talent.lightningStrikes and ui.useST(8, 2) then
            if actionList.ThaneSt() then return true end
        end
        -- Call Action List - Thane Mt
        -- run_action_list,name=thane_mt,if=talent.lightning_strikes&active_enemies>1
        if talent.lightningStrikes and ui.useAOE(8, 2) then
            if actionList.ThaneMt() then return true end
        end
    end
end -- End Action List - Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------
    --- Locals ---
    --------------
    race    = unit.race()
    rage    = power.rage

    units.get(5)
    units.get(8)
    units.get(12, true)
    units.get(25)
    units.get(40)
    enemies.get(5, "player", false, true)
    enemies.get(15)
    enemies.get(20)

    ------------------------
    --- Custom Variables ---
    ------------------------

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
end     -- End runRotation
registerRotation({
    name      = rotationName,
    specID    = 72,
    expansion = "Retail",
    author    = "CuteOne",
    patch     = "11.0.2",
    coverage  = "100%",
    status    = "Limited",
    readiness = "Basic",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

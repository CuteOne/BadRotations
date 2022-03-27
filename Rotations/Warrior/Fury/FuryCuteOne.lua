local rotationName = "CuteOne"

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
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.recklessness },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.recklessness },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.recklessness }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.enragedRegeneration },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.enragedRegeneration }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.pummel },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
    -- Movement Button
    local MoverModes = {
        [1] = { mode = "On", value = 1 , overlay = "Mover Enabled", tip = "Will use Charge/Heroic Leap.", highlight = 1, icon = br.player.spell.charge },
        [2] = { mode = "Off", value = 2 , overlay = "Mover Disabled", tip = "Will NOT use Charge/Heroic Leap.", highlight = 0, icon = br.player.spell.charge }
    };
    br.ui:createToggle(MoverModes,"Mover",5,0)
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
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Battle Shout
            br.ui:createCheckbox(section,"Battle Shout")
            -- Bladestorm Units
            br.ui:createSpinnerWithout(section, "Bladestorm Units", 3, 1, 10, 1, "|cffFFFFFFSet to desired minimal number of units required to use Bladestorm.")
            -- Berserker Rage
            br.ui:createCheckbox(section,"Berserker Rage", "Check to use Berserker Rage")
            -- Charge
            br.ui:createCheckbox(section,"Charge", "Check to use Charge")
			-- Heroic Throw
            br.ui:createCheckbox(section, "Heroic Throw")
            -- Heroic Leap
            br.ui:createDropdown(section,"Heroic Leap", br.dropOptions.Toggle, 6, "Set auto usage (No Hotkey) or desired hotkey to use Heroic Leap.")
            br.ui:createDropdownWithout(section,"Heroic Leap - Target",{"Best","Target"},1,"Desired Target of Heroic Leap")
            -- Piercing Howl
            br.ui:createCheckbox(section,"Piercing Howl", "Check to use Piercing Howl")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            local alwaysCdAoENever = {"Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never"}
            -- Flask Up Module
            br.player.module.FlaskUp("Agility", section)
            -- Racial
            br.ui:createDropdownWithout(section, "Racial", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Racial.")
            -- Basic Trinkets Module
            br.player.module.BasicTrinkets(nil, section)
            -- Bladestorm
            br.ui:createDropdownWithout(section, "Bladestorm", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Bladestorm.")
            -- Dragon Roar
            br.ui:createDropdownWithout(section, "Dragon Roar", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Dragon Roar.")
            -- Recklessness
            br.ui:createDropdownWithout(section, "Recklessness", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Recklessness.")
            -- Siegebreaker
            br.ui:createDropdownWithout(section, "Siegebreaker", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Siegebreaker.")
            -- Covenant
            br.ui:createDropdownWithout(section, "Covenant", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Covenant Ability.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            local defTooltip = "|cffFFBB00Health Percentage to use at."
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Enraged Regeneration
            br.ui:createSpinner(section, "Enraged Regeneration", 60, 0, 100, 5, defTooltip)
            -- Ignore Pain
            br.ui:createSpinner(section, "Ignore Pain", 60, 0, 100, 5, defTooltip)
            -- Intimidating Shout
            br.ui:createSpinner(section, "Intimidating Shout",  60,  0,  100,  5, defTooltip)
            -- Rallying Cry
            br.ui:createSpinner(section, "Rallying Cry", 60, 0, 100, 5, defTooltip)
            -- Spell Reflection
            br.ui:createSpinner(section, "Spell Reflection", 60, 0, 100, 5, defTooltip)
            -- Storm Bolt
            br.ui:createSpinner(section, "Storm Bolt", 60, 0, 100, 5, defTooltip)
            -- Victory Rush
            br.ui:createSpinner(section, "Victory Rush", 60, 0, 100, 5, defTooltip)
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Pummel
            br.ui:createCheckbox(section,"Pummel")
            -- Intimidating Shout
            br.ui:createCheckbox(section,"Intimidating Shout - Int")
            -- Storm Bolt
            br.ui:createCheckbox(section,"Storm Bolt - Int")
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
            -- Mover Toggle
            br.ui:createDropdown(section,  "Mover Mode", br.dropOptions.Toggle,  6)
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

--------------
--- Locals ---
--------------
-- BR API Locals
local buff
local cast
local cd
local charges
local conduit
local covenant
local debuff
local enemies
local equiped
local module
local race
local rage
local runeforge
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
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Battle Shout
    if ui.checked("Battle Shout") and cast.able.battleShout() then
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            if not unit.deadOrGhost(thisUnit) and unit.distance(thisUnit) < 100 and buff.battleShout.remain(thisUnit) < 600 then
                if cast.battleShout() then ui.debug("Casting Battle Shout") return true end
            end
        end
    end
    -- Berserker Rage
    if ui.checked("Berserker Rage") and cast.able.berserkerRage() and cast.noControl.berserkerRage() then
        if cast.berserkerRage() then ui.debug("Casting Berserker Rage") return true end
    end
    -- Piercing Howl
    if ui.checked("Piercing Howl") then
        for i=1, #enemies.yards15 do
            local thisUnit = enemies.yards15[i]
            if cast.able.piercingHowl(thisUnit) and unit.moving(thisUnit) and not unit.facing(thisUnit,"player") and unit.distance(thisUnit) >= 5 then
                if cast.piercingHowl(thisUnit) then ui.debug("Casting Piercing Howl") return true end
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
            if cast.enragedRegeneration() then ui.debug("Casting Enraged Regeneration") return true end
        end
        -- Ignore Pain
        if ui.checked("Ignore Pain") and cast.able.ignorePain() and useDefensive("Ignore Pain") and rage >= 60 then
            if cast.ignorePain() then ui.debug("Casting Ignore Pain") return true end
        end
        -- Intimidating Shout
        if ui.checked("Intimidating Shout") and cast.able.intimidatingShout() and useDefensive("Intimidating Shout") then
            if cast.intimidatingShout() then ui.debug("Casting Intimidating Shout") return true end
        end
        -- Rallying Cry
        if ui.checked("Rallying Cry") and cast.able.rallyingCry() and useDefensive("Rallying Cry") then
            if cast.rallyingCry() then ui.debug("Casting Rallying Cry") return true end
        end
        -- Spell Reflection
        if ui.checked("Spell Reflection") and cast.able.spellReflection() and useDefensive("Spell Relection") then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (cast.timeRemain(thisUnit) < 5 or cast.inFlight.spellReflection(thisUnit)) then
                    if cast.spellReflection() then ui.debug("Casting Spell Reflection") return true end
                end
            end
        end
        -- Storm Bolt
        if ui.checked("Storm Bolt") and cast.able.stormBolt() and useDefensive("Storm Bolt") then
            if cast.stormBolt() then ui.debug("Casting Storm Bolt") return true end
        end
        -- Victory Rush
        if ui.checked("Victory Rush") and (cast.able.victoryRush() or cast.able.impendingVictory())
            and unit.inCombat() and buff.victorious.exists()
        then
            for i = 1, #enemies.yards5f do
                local thisUnit = enemies.yards5f[i]
                if unit.hp() <= ui.value("Victory Rush") or buff.victorious.remain() < unit.gcd(true) or unit.ttd(thisUnit) < unit.gcd(true) then
                    if talent.impendingVictory then
                        if cast.impendingVictory(thisUnit) then ui.debug("Casting Impending Victory") return true end
                    else
                        if cast.victoryRush(thisUnit) then ui.debug("Casting Victory Rush") return true end
                    end
                end
            end
        end
    end -- End Defensive Check
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        for i=1, #enemies.yards20 do
            local thisUnit = enemies.yards20[i]
            local distance = unit.distance(thisUnit)
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                -- Pummel
                if ui.checked("Pummel") and cast.able.pummel(thisUnit) and distance < 5 then
                    if cast.pummel(thisUnit) then ui.debug("Casting Pummel") return true end
                end
                -- Intimidating Shout
                if ui.checked("Intimidating Shout - Int") and cast.able.intimidatingShout() and distance < 8 then
                    if cast.intimidatingShout() then ui.debug("Casting Intimidating Shout [Int]") return true end
                end
                -- Storm Bolt
                if ui.checked("Storm Bolt - Int") and cast.able.stormBolt(thisUnit) and distance < 20 then
                    if cast.stormBolt(thisUnit) then ui.debug("Casting Storm Bolt [Int]") return true end
                end
            end
        end
    end
end -- End Action List - Interrupts

-- Action List - Movement
actionList.Movement = function()
    -- Heroic Leap
    -- heroic_leap
    if cast.able.heroicLeap("player","ground",1,8) then
        if cast.heroicLeap("player","ground",1,8) then ui.debug("Casting Heroic Leap") return true end
    end
end -- End Action List - Movement

-- Action List - AOE
actionList.AOE = function()
    -- Cancel Buff - Bladestorm
    -- cancel_buff,name=bladestorm,if=spell_targets.whirlwind>1&gcd.remains=0&soulbind.first_strike&buff.first_strike.remains&buff.enrage.remains<gcd
    if cast.current.bladestorm() and #enemies.yards8 > 1 and unit.gcd() == 0 and buff.firstStrike.remain() > 0 and buff.enrage.remain() < unit.gcd(true) then
        var.cancelBladestorm = true
        return true
    end
    -- Spear of Bastion
    -- spear_of_bastion,if=buff.enrage.up&rage<40&spell_targets.whirlwind>1
    if covenant.kyrian.active and ui.alwaysCdAoENever("Covenant",2,5) and cast.able.spearOfBastion("best",nil,2,5)
        and buff.enrage.exists() and rage < 40
    then
        if cast.spearOfBastion("best",nil,2,5) then ui.debug("Casting Spear of Bastion [Low Rage]") return true end
    end
    -- Bladestorm
    -- bladestorm,if=buff.enrage.up&spell_targets.whirlwind>2
    if ui.alwaysCdAoENever("Bladestorm",3,8) and cast.able.bladestorm("player","aoe",3,8)
        and (buff.enrage.remain() and #enemies.yards8 > 2)
    then
        if cast.bladestorm("player","aoe",3,8) then ui.debug("Casting Bladestorm [AOE - High Targets]") return true end
    end
    -- Condemn
    -- condemn,if=spell_targets.whirlwind>1&(buff.enrage.up|buff.recklessness.up&runeforge.sinful_surge)&variable.execute_phase
    if covenant.venthyr.active and ui.alwaysCdAoENever("Covenant",2,8) and #enemies.yards8 > 1 then
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5f[i]
            if (var.condemnable(thisUnit) or ((var.condemnable(thisUnit) and buff.enrage.exists()) or (buff.recklessness.exists() and runeforge.sinfulSurge.equiped))) and var.executePhase(thisUnit) then
                if talent.massacre and cast.able.condemnMassacre(thisUnit) then
                    if cast.condemnMassacre(thisUnit) then ui.debug("Casting Condemn [AOE - Execute Phase]") return true end
                elseif not talent.massacre and cast.able.condemn(thisUnit) then
                    if cast.condemn(thisUnit) then ui.debug("Casting Condemn [AOE - Execute Phase]") return true end
                end
            end
        end
    end
    -- Siegebreaker
    -- siegebreaker,if=spell_targets.whirlwind>1
    if ui.alwaysCdAoENever("Siegebreaker",2,8) and cast.able.siegebreaker("player","aoe",2,8) and #enemies.yards8 > 1 then
        if cast.siegebreaker("player","aoe",2,8) then ui.debug("Casting Siegebreaker [AOE]") return true end
    end
    -- Rampage
    -- rampage,if=spell_targets.whirlwind>1
    if cast.able.rampage() and #enemies.yards8 > 1 then
        if cast.rampage() then ui.debug("Casting Rampage [AOE]") return true end
    end
    -- Spear of Bastion
    -- spear_of_bastion,if=buff.enrage.up&cooldown.recklessness.remains>5&spell_targets.whirlwind>1
    if covenant.kyrian.active and ui.alwaysCdAoENever("Covenant",2,5) and cast.able.spearOfBastion("best",nil,2,5)
        and buff.enrage.exists() and cd.recklessness.remain() > 5
    then
        if cast.spearOfBastion("best",nil,2,5) then ui.debug("Casting Spear of Bastion [No Recklessness]") return true end
    end
    -- Bladestorm
    -- bladestorm,if=buff.enrage.remains>gcd*2.5&spell_targets.whirlwind>1
    if ui.alwaysCdAoENever("Bladestorm",2,8) and cast.able.bladestorm("player","aoe",2,8)
        and (buff.enrage.remain() > unit.gcd() * 2.5 and #enemies.yards8 > 1)
    then
        if cast.bladestorm("player","aoe",2,8) then ui.debug("Casting Bladestorm [AOE]") return true end
    end
end -- End Action List - AOE

-- Action List - Single Target
actionList.SingleTarget = function()
    -- Raging Blow
    -- raging_blow,if=runeforge.will_of_the_berserker.equipped&buff.will_of_the_berserker.remains<gcd
    if not var.reckless and cast.able.ragingBlow() and (runeforge.willOfTheBerserker.equiped and buff.willOfTheBerserker.remain() < unit.gcd(true)) then
        if cast.ragingBlow() then ui.debug("Casting Raging Blow [ST - Will of the Berserker]") return true end
    end
    -- Crushing Blow
    -- crushing_blow,if=runeforge.will_of_the_berserker.equipped&buff.will_of_the_berserker.remains<gcd
    if var.reckless and cast.able.crushingBlow() and (runeforge.willOfTheBerserker.equiped and buff.willOfTheBerserker.remain() < unit.gcd(true)) then
        if cast.crushingBlow() then ui.debug("Casting Crushing Blow [ST - Will of the Berserker]") return true end
    end
    -- Cancel Bladestorm
    -- cancel_buff,name=bladestorm,if=spell_targets.whirlwind=1&gcd.remains=0&(talent.massacre.enabled|covenant.venthyr.enabled)&variable.execute_phase&(rage>90|!cooldown.condemn.remains)
    if cast.current.bladestorm() and #enemies.yards8 == 1 and unit.gcd() == 0
        and (talent.massacre or covenant.venthyr.enabled) and var.executePhase and (rage > 90 or not cd.condemn.exists())
    then
        var.cancelBladestorm = true
        return true
    end
    -- Condemn
    -- condemn,if=(buff.enrage.up|buff.recklessness.up&runeforge.sinful_surge)&variable.execute_phase
    if covenant.venthyr.active and ui.alwaysCdAoENever("Covenant",1,5) then
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5f[i]
            if (var.condemnable(thisUnit) or (buff.recklessness.exists() and runeforge.sinfulSurge.equiped)) and var.executePhase(thisUnit) then
                if talent.massacre and cast.able.condemnMassacre(thisUnit) then
                    if cast.condemnMassacre(thisUnit) then ui.debug("Casting Condemn [ST - Execute Phase] on "..unit.name(thisUnit).." which is your target: "..tostring(unit.isUnit(thisUnit,"target"))) return true end
                elseif not talent.massacre and cast.able.condemn(thisUnit) then
                    if cast.condemn(thisUnit) then ui.debug("Casting Condemn [ST - Execute Phase] on "..unit.name(thisUnit).." which is your target: "..tostring(unit.isUnit(thisUnit,"target"))) return true end
                end
            end
        end
    end
    -- Siegebreaker
    -- siegebreaker,if=spell_targets.whirlwind>1|raid_event.adds.in>15
    if ui.alwaysCdAoENever("Siegebreaker",2,8) and cast.able.siegebreaker("player","aoe",2,8) and (#enemies.yards8 > 1) then
        if cast.siegebreaker("player","aoe",2,8) then ui.debug("Casting Siegebreaker [ST]") return true end
    end
    -- Rampage
    -- rampage,if=buff.recklessness.up|(buff.enrage.remains<gcd|rage>90)|buff.frenzy.remains<1.5
    if cast.able.rampage() and (buff.recklessness.exists() or (buff.enrage.remain() < unit.gcd(true) or rage > 90) or buff.frenzy.remain() < 1.5) then
        if cast.rampage() then ui.debug("Casting Rampage [ST]") return true end
    end
    -- Condemn
    -- condemn
    if covenant.venthyr.active and ui.alwaysCdAoENever("Covenant",1,5) then
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5f[i]
            if var.condemnable(thisUnit) then
                if talent.massacre and cast.able.condemnMassacre(thisUnit) then
                    if cast.condemnMassacre(thisUnit) then ui.debug("Casting Condemn [ST] on "..unit.name(thisUnit).." which is your target: "..tostring(unit.isUnit(thisUnit,"target"))) return true end
                elseif not talent.massacre and cast.able.condemn(thisUnit) then
                    if cast.condemn(thisUnit) then ui.debug("Casting Condemn [ST] on "..unit.name(thisUnit).." which is your target: "..tostring(unit.isUnit(thisUnit,"target"))) return true end
                end
            end
        end
    end
    -- Crushing Blow
    -- crushing_blow,if=set_bonus.tier28_2pc|charges=2|(buff.recklessness.up&variable.execute_phase&talent.massacre.enabled)
    if var.reckless and cast.able.crushingBlow() and (equiped.tier(28) >= 2 or charges.crushingBlow.count() == 2
        or (buff.recklessness.exists() and var.executePhase and talent.massacre))
    then
        if cast.crushingBlow() then ui.debug("Casting Crushing Blow [ST - 2 Charges]") return true end
    end
    -- Execute
    -- execute
    for i = 1, #enemies.yards5f do
        local thisUnit = enemies.yards5f[i]
        if var.executable(thisUnit) and cast.able.execute(thisUnit) then
            if cast.execute(thisUnit) then ui.debug("Casting Execute [ST]") return true end
        end
    end
    -- Spear of Bastion
    -- spear_of_bastion,if=runeforge.elysian_might&buff.enrage.up&cooldown.recklessness.remains>5&(buff.recklessness.up|target.time_to_die<20|debuff.siegebreaker.up|!talent.siegebreaker&target.time_to_die>68)&raid_event.adds.in>55
    if covenant.kyrian.active and ui.alwaysCdAoENever("Covenant",1,5) and cast.able.spearOfBastion("best",nil,1,5)
        and runeforge.elysianMight.equiped and buff.enrage.exists() and cd.recklessness.remain() > 5
        and (buff.recklessness.exists() or unit.ttd(units.dyn5) < 20 or debuff.siegebreaker.exists() or (not talent.siegebreaker and unit.ttd(units.dyn5) > 68))
        and #enemies.yards25 == 1
    then
        if cast.spearOfBastion("best",nil, 1, 5) then ui.debug("Casting Spear of Bastion [ST - Elysian Might]") return true end
    end
    -- Bladestorm
    -- bladestorm,if=buff.enrage.up&(!buff.recklessness.remains|rage<50)&(spell_targets.whirlwind=1&raid_event.adds.in>45|spell_targets.whirlwind=2)
    if ui.alwaysCdAoENever("Bladestorm",1,8) and cast.able.bladestorm("player","aoe",1,8)
        and (buff.enrage.exists() and (not buff.recklessness.exists() or rage < 50) and (#enemies.yards8 == 1 or #enemies.yards8 == 2))
    then
        if cast.bladestorm("player","aoe",1,8) then ui.debug("Casting Bladestorm [ST]") return true end
    end
    -- Spear of Bastion
    -- spear_of_bastion,if=buff.enrage.up&cooldown.recklessness.remains>5&(buff.recklessness.up|target.time_to_die<20|debuff.siegebreaker.up|!talent.siegebreaker&target.time_to_die>68)&raid_event.adds.in>55
    if covenant.kyrian.active and ui.alwaysCdAoENever("Covenant",1,5) and cast.able.spearOfBastion("best",nil,1,5) and (buff.enrage.exists() and cd.recklessness.remains() > 5
        and (buff.recklessness.exists() or unit.ttd(units.dyn5) < 20 or debuff.siegebreaker.exists(units.dyn5) or (not talent.siegebreaker and unit.ttd(units.dyn5) > 68)))
    then
        if cast.spearOfBastion("best",nil, 1, 5) then ui.debug("Casting Spear of Bastion [ST]") return true end
    end
    -- Raging Blow
    -- raging_blow,if=set_bonus.tier28_2pc|charges=2|(buff.recklessness.up&variable.execute_phase&talent.massacre.enabled)
    if not var.reckless and cast.able.ragingBlow() and (equiped.tier(28) > 2 or charges.ragingBlow.count() == 2
        or (buff.recklessness.exists() and var.executePhase and talent.massacre))
    then
        if cast.ragingBlow() then ui.debug("Casting Raging Blow [ST - 2 Charges / Execute Phase]") return true end
    end
    -- Bloodthirst
    -- bloodthirst,if=buff.enrage.down|conduit.vicious_contempt.rank>5&target.health.pct<35
    if not var.reckless and cast.able.bloodthirst() and (not buff.enrage.exists() or conduit.viciousContempt.rank > 5 and unit.hp(units.dyn5) < 35) then
        if cast.bloodthirst() then ui.debug("Casting Bloodthirst [ST - No Enrage / Vicious Contempt]") return true end
    end
    -- Bloodbath
    -- bloodbath,if=buff.enrage.down|conduit.vicious_contempt.rank>5&target.health.pct<35&!talent.cruelty.enabled
    if var.reckless and cast.able.bloodbath() and (not buff.enrage.exists() or conduit.viciousContempt.rank > 5 and unit.hp(units.dyn5) < 35 and not talent.cruelty) then
        if cast.bloodbath() then ui.debug("Casting Bloodbath [ST - No Enrage / Vicious Contempt]") return true end
    end
    -- Dragon Roar
    -- dragon_roar,if=buff.enrage.up&(spell_targets.whirlwind>1|raid_event.adds.in>15)
    if ui.alwaysCdAoENever("Dragon Roar",1,8) and cast.able.dragonRoar("player","aoe",1,8) and (buff.enrage.exists() and (#enemies.yards8 > 1)) then
        if cast.dragonRoar("player","aoe",1,8) then ui.debug("Casting Dragon Roar [ST]") return true end
    end
    -- Whirlwind
    -- whirlwind,if=buff.merciless_bonegrinder.up&spell_targets.whirlwind>3
    if cast.able.whirlwind("player","aoe",1,8) and (buff.mercilessBonegrinder.exists() and #enemies.yards8 > 3) then
        if cast.whirlwind("player","aoe",1,8) then ui.debug("Casting Whirlwind [ST - Merciless Bonegrinder]") return true end
    end
    -- Onslaught
    -- onslaught,if=buff.enrage.up
    if cast.able.onslaught() and buff.enrage.exists() then
        if cast.onslaught() then ui.debug('Casting Onslaught [ST]') return true end
    end
    -- Bloodthirst
    -- bloodthirst
    if not var.reckless and cast.able.bloodthirst() then
        if cast.bloodthirst() then ui.debug("Casting Bloodthirst [ST]") return true end
    end
    -- Bloodbath
    -- bloodbath
    if var.reckless and cast.able.bloodbath() then
        if cast.bloodbath() then ui.debug("Casting Bloodbath [ST]") return true end
    end
    -- Raging Blow
    -- raging_blow
    if not var.reckless and cast.able.ragingBlow() then
        if cast.ragingBlow() then ui.debug("Casting Raging Blow [ST]") return true end
    end
    -- Crushing Blow
    -- crushing_blow
    if var.reckless and cast.able.crushingBlow() then
        if cast.crushingBlow() then ui.debug("Casting Crushing Blow [ST]") return true end
    end
    -- Whirlwind
    -- whirlwind
    if cast.able.whirlwind("player","aoe",1,8) then --and cast.timeSinceLast.whirlwind() > unit.gcd(true) then
        if cast.whirlwind("player","aoe",1,8) then ui.debug("Casting Whirlwind [ST]") return true end
    end
end -- End Action List - Single Target

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then
        -- Flask Up Module
        -- flask
        module.FlaskUp("Agility")
        -- Augmentation
        -- augmentation
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Potion
            -- potion
            -- if ui.checked("Potion") and br.canUseItem(142117) and unit.instance("raid") then
            --     if feralSpiritRemain > 5 and not buff.prolongedPower.exists() then
            --         br.useItem(142117)
            --     end
            -- end
        end -- End Pre-Pull
        if unit.valid("target") then
            -- Charge
            -- charge
            if ui.mode.mover == 1 and ui.checked("Charge") and cast.able.charge("target") then
                if cast.charge("target") then ui.debug("Casting Charge") return true end
            end
            -- Taunt
            if cast.able.taunt("target") and unit.solo() and not cast.able.charge("target") then
                if cast.taunt("target") then ui.debug("Casting Taunt") return true end
            end
            -- Start Attack
            if unit.distance("target") < 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                end
            end
        end
    end -- End No Combat
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()

--------------
--- Locals ---
--------------
    buff        = br.player.buff
    cast        = br.player.cast
    cd          = br.player.cd
    charges     = br.player.charges
    conduit     = br.player.conduit
    covenant    = br.player.covenant
    debuff      = br.player.debuff
    enemies     = br.player.enemies
    equiped     = br.player.equiped
    module      = br.player.module
    race        = br.player.race
    rage        = br.player.power.rage.amount()
    runeforge   = br.player.runeforge
    talent      = br.player.talent
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    var         = br.player.variables

    units.get(5)
    units.get(8)
    enemies.get(5)
    enemies.get(5,"player",false,true)
    enemies.get(8)
    enemies.get(15)
    enemies.get(20)
    enemies.get(25)

    ------------------------
    --- Custom Variables ---
    ------------------------

    if var.cancelBladestorm == nil or (var.cancelBladestorm and not cast.current.bladestorm()) then var.cancelBladestorm = false end
    if var.profileStop == nil then var.profileStop = false end

    if var.cancelBladestorm and cast.current.bladestorm() then
        if cast.cancel.bladestorm() then ui.debug("|cffFF0000Canceling Bladestorm") var.cancelBladestorm = false return true end
    end

    var.executeConditions = function(thisUnit)
        if thisUnit == nil then thisUnit = units.dyn5 end
        return unit.hp(thisUnit) < 20 or (talent.massacre and unit.hp(thisUnit) < 35) or buff.suddenDeath.exists()
    end
    var.condemnable = function(thisUnit)
        if thisUnit == nil then thisUnit = units.dyn5 end
        return covenant.venthyr.active and (var.executeConditions(thisUnit) or unit.hp(thisUnit) > 80)
    end
    var.executable = function(thisUnit)
        if thisUnit == nil then thisUnit = units.dyn5 end
        return not covenant.venthyr.active and var.executeConditions(thisUnit)
    end
    var.reckless = talent.recklessAbandon and buff.recklessness.exists()

    -------------------------
    --- Profile Variables ---
    -------------------------

    -- variable,name=execute_phase,value=talent.massacre&target.health.pct<35|target.health.pct<20|target.health.pct>80&covenant.venthyr
    var.executePhase = function(thisUnit)
        if thisUnit == nil then thisUnit = units.dyn5 end
        return (talent.massacre and unit.hp(thisUnit) < 35) or unit.hp(thisUnit) < 20 or (unit.hp(thisUnit) > 80 and covenant.venthyr.active)
    end

    -- variable,name=unique_legendaries,value=runeforge.signet_of_tormented_kings|runeforge.sinful_surge|runeforge.elysian_might
    var.uniqueLegendaries = runeforge.signetOfTormentedKings.equiped or runeforge.sinfulSurge.equiped or runeforge.elysianMight.equiped

-----------------
--- Rotations ---
-----------------
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop==true) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then
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
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack") return true end
                end
            end
            -- Charge
            -- charge
            if ui.mode.mover == 1 and ui.checked("Charge") and cast.able.charge(units.dyn5) then
                if cast.charge(units.dyn5) then ui.debug("Casting Charge") return true end
            end
            -- Action List - Interrupts
            if actionList.Interrupts() then return true end
            -- Spear of Bastion
            -- spear_of_bastion,if=buff.enrage.up&rage<70
            if ui.alwaysCdAoENever("Covenant",3,5) and covenant.kyrian.active and buff.enrage.exists() and rage < 70 then
                if ui.useAOE(5,3) and cast.able.spearOfBastion("best",nil,3,5) then
                    if cast.spearOfBastion("best",nil, 3, 5) then ui.debug("Casting Spear of Bastion [Enraged w/ Low Rage]") return true end
                end
                if ui.useCDs() and cast.able.spearOfBastion("best",nil,1,5) then
                    if cast.spearOfBastion("best",nil, 1, 5) then ui.debug("Casting Spear of Bastion [Enraged w/ Low Rage]") return true end
                end
            end
            -- Rampage
            -- rampage,if=cooldown.recklessness.remains<3&talent.reckless_abandon.enabled
            if cast.able.rampage() and (cd.recklessness.remain() < 3 and talent.recklessAbandon) then
                if cast.rampage() then ui.debug("Casting Rampage [Reckless Abandon]") return true end
            end
            -- Recklessness
            if ui.alwaysCdNever("Recklessness") and cast.able.recklessness() and (#enemies.yards8== 1 or buff.meatCleaver.exists()) then
                -- recklessness,if=runeforge.sinful_surge&gcd.remains=0&(variable.execute_phase|(target.time_to_pct_35>40&talent.anger_management|target.time_to_pct_35>70&!talent.anger_management))&(spell_targets.whirlwind=1|buff.meat_cleaver.up)
                if runeforge.sinfulSurge.equiped and unit.gcd() == 0
                    and (var.executePhase() or ((unit.ttd(units.dyn5,35) > 40 and talent.angerManagement) or (unit.ttd(units.dyn5,35) > 70 and not talent.angerManagement)))
                then
                    if cast.recklessness() then ui.debug("Casting Recklessness [Sinful Surge]") return true end
                end
                -- recklessness,if=runeforge.elysian_might&gcd.remains=0&(cooldown.spear_of_bastion.remains<5|cooldown.spear_of_bastion.remains>20)&((buff.bloodlust.up|talent.anger_management.enabled|raid_event.adds.in>10)|target.time_to_die>100|variable.execute_phase|target.time_to_die<15&raid_event.adds.in>10)&(spell_targets.whirlwind=1|buff.meat_cleaver.up)
                if runeforge.elysianMight.equiped and unit.gcd() == 0 and (cd.spearOfBastion.remain() < 5 or cd.spearOfBastion.remain() > 20)
                    and ((buff.bloodLust.exists() or talent.angerManagement) or unit.ttd(units.dyn5) > 100 or var.executePhase())
                then
                    if cast.recklessness() then ui.debug("Casting Recklessness [Elysian Might]") return true end
                end
                -- recklessness,if=!variable.unique_legendaries&gcd.remains=0&((buff.bloodlust.up|talent.anger_management.enabled|raid_event.adds.in>10)|target.time_to_die>100|variable.execute_phase|target.time_to_die<15&raid_event.adds.in>10)&(spell_targets.whirlwind=1|buff.meat_cleaver.up)
                if not var.uniqueLegendaries and unit.gcd() == 0
                    and ((buff.bloodLust.exists() or talent.angerManagement or #enemies.yards8 == 1) or unit.ttd(units.dyn5) > 100 or var.executePhase
                        or unit.ttd(units.dyn5) < 15 and #enemies.yards8 == 1)
                then
                    if cast.recklessness() then ui.debug("Casting Recklessness") return true end
                end
                -- recklessness,use_off_gcd=1,if=runeforge.signet_of_tormented_kings.equipped&gcd.remains&prev_gcd.1.rampage&((buff.bloodlust.up|talent.anger_management.enabled|raid_event.adds.in>10)|target.time_to_die>100|variable.execute_phase|target.time_to_die<15&raid_event.adds.in>10)&(spell_targets.whirlwind=1|buff.meat_cleaver.up)
                if runeforge.signetOfTormentedKings.equiped and unit.gcd() > 0 and cast.last.rampage(1)
                    and ((buff.bloodLust.exists() or talent.angerManagement or #enemies.yards8 == 1) or unit.ttd(units.dyn5) > 100
                        or var.executePhase or unit.ttd(units.dyn5) < 15 and #enemies.yards8 == 1)
                then
                    if cast.recklessness() then ui.debug("Casting Recklessness [Signet of Tormented Kings]") return true end
                end
            end
            -- Whirlwind
            -- whirlwind,if=spell_targets.whirlwind>1&!buff.meat_cleaver.up|raid_event.adds.in<gcd&!buff.meat_cleaver.up
            if cast.able.whirlwind("player","aoe",1,8) and talent.meatCleaver and (#enemies.yards8 > 1 and not buff.meatCleaver.exists()) then
                if cast.whirlwind("player","aoe",1,8) then ui.debug("Casting Whirlwind [No Meat Cleaver]") return true end
            end
            -- Trinkets
            if #enemies.yards5 > 0 and unit.standingTime() >= 2 then
                module.BasicTrinkets()
            end
            -- Racials
            if ui.alwaysCdNever("Racial") and cast.able.racial() then
                -- Blood Fury (Orc)
                -- blood_fury
                if race == "Orc" then
                    if cast.racial() then ui.debug("Casting Blood Fury") return true end
                end
                -- Berserking (Troll)
                -- berserking,if=buff.recklessness.up
                if race == "Troll" and buff.recklessness.exists() then
                    if cast.racial() then ui.debug("Casting Berserking") return true end
                end
                -- Light's Judgment (Lightforged Draenei)
                -- lights_judgment,if=buff.recklessness.down&debuff.siegebreaker.down
                if race == "LightforgedDraenei" and not buff.recklessness.exists() and not debuff.siegebreaker.exists(units.dyn5) then
                    if cast.racial() then ui.debug("Casting Light's Judgement") return true end
                end
                -- Fireblood (Dark Iron Dwarf)
                -- fireblood
                if race == "DarkIronDwarf" then
                    if cast.racial("player") then ui.debug("Casting Fireblood") return true end
                end
                -- Ancestral Call (Maghar Orcs)
                -- ancestral_call
                if race == "MagharOrc" then
                    if cast.racial() then ui.debug("Casting Ancestral Call") return true end
                end
            end
            -- Call Action List - AOE
            -- call_action_list,name=aoe
            if actionList.AOE() then return true end
            -- Call Action List - Single
            -- call_action_list,name=single_target
            if actionList.SingleTarget() then return true end
            -- Slam
            if unit.level() < 28 or rage >= 100 then
                if cast.slam() then ui.debug("Casting Slam") return true end
            end
            -- Heroic Throw
            if cast.able.heroicThrow() then
                if cast.heroicThrow() then ui.debug("Casting Heroic Throw") return true end
            end
        end -- End Combat Rotation
    end -- Pause
end -- End runRotation
local id = 72
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

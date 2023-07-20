-------------------------------------------------------
-- Author = CuteOne
-- Patch = 9.2.5
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
local createToggles = function()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.shurikenStorm },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.shurikenStorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.backstab },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.crimsonVial}
    }
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.shadowBlades },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.shadowBlades },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.shadowBlades }
    }
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.evasion },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.evasion }
    }
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.kick },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.kick }
    }
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
    -- Shadow Dance Button
    ShadowDanceModes = {
        [1] = { mode = "On", value = 1 , overlay = "Shadow Dance Enabled", tip = "Rotation will use Shadow Dance.", highlight = 1, icon = br.player.spell.shadowDance },
        [2] = { mode = "Off", value = 2 , overlay = "Shadow Dance Disabled", tip = "Rotation will not use Shadow Dance. Useful for pooling SD charges as you near dungeon bosses.", highlight = 0, icon = br.player.spell.shadowDance },
    }
    br.ui:createToggle(ShadowDanceModes,"ShadowDance",5,0)
    -- Pick Pocket Button
    PickPocketModes = {
      [1] = { mode = "Auto", value = 1 , overlay = "Auto Pick Pocket Enabled", tip = "Profile will attempt to Pick Pocket prior to combat.", highlight = 1, icon = br.player.spell.pickPocket},
      [2] = { mode = "Only", value = 2 , overlay = "Only Pick Pocket Enabled", tip = "Profile will attempt to Sap and only Pick Pocket, no combat.", highlight = 0, icon = br.player.spell.pickPocket},
      [3] = { mode = "Off", value = 3, overlay = "Pick Pocket Disabled", tip = "Profile will not use Pick Pocket.", highlight = 0, icon = br.player.spell.pickPocket}
    }
    br.ui:createToggle(PickPocketModes,"PickPocket",6,0)
end

---------------
--- OPTIONS ---
---------------
local createOptions = function()
    local optionTable

    local rotationOptions = function()
        local section
        local alwaysCdAoENever = {"Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never"}
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- Max Spend Combo Points
            br.ui:createSpinnerWithout(section, "Max Combo Spend", 5, 1, 6, 1, "|cffFFFFFFSet to desired max combo points to spend.")
            -- Poison
            br.ui:createDropdownWithout(section, "Lethal Poison", {"Instant","Wound","None"}, 1, "Lethal Poison to Apply")
            br.ui:createDropdownWithout(section, "Non-Lethal Poison", {"Crippling","Numbing","None"}, 1, "Non-Lethal Poison to Apply")
            -- Priority Rotation
            br.ui:createCheckbox(section, "Priority Rotation")
            -- Stealth
            br.ui:createDropdown(section,  "Stealth", {"|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards"},  1, "Stealthing method.")
            -- Stealth Breaker
            br.ui:createDropdownWithout(section, "Stealth Breaker", {"|cff00FF00Shadowstrike","|cffFFFF00Cheapshot","|cffFF0000Sinister Strike"}, 3, "|cffFFFFFFSet what to break Stealth with.")
            -- Shadowstep
            br.ui:createCheckbox(section,  "Shadowstep")
            -- Shadowstrike
            br.ui:createSpinnerWithout(section, "SS Range",  5,  5,  25,  5,  "|cffFFBB00Shadow Strike range, 5 = Melee")
            -- Shuriken Toss OOR
            br.ui:createSpinner(section, "Shuriken Toss OOR",  85,  5,  100,  5,  "|cffFFBB00Check to use Shuriken Toss out of range and energy to use at.")
            -- Tricks of the Trade
            br.ui:createCheckbox(section, "Tricks of the Trade on Focus")
            -- Pre-Pull
            br.ui:createCheckbox(section, "Pre-Pull", "|cffFFFFFFSet to use Pre-Pull (DBM Required).")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- FlaskUp Module
            br.player.module.FlaskUp("Agility",section)
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.player.module.BasicTrinkets(nil,section)
            -- Marked For Death
            br.ui:createDropdown(section, "Marked For Death", {"|cff00FF00Target", "|cffFFDD00Lowest"}, 1, "|cffFFBB00Health Percentage to use at.")
            -- Shadow Blades
            br.ui:createDropdownWithout(section, "Shadow Blades",alwaysCdAoENever,2,"|cffFFFFFFWhen to use Shadow Blades.")
            -- Shadow Dance
            br.ui:createDropdownWithout(section, "Shadow Dance",alwaysCdAoENever,1,"|cffFFFFFFWhen to use Shadow Dance.")
            -- Shuriken Tornado
            br.ui:createDropdownWithout(section, "Shuriken Tornado",alwaysCdAoENever,1,"|cffFFFFFFWhen to use Shuriken Tornado.")
            -- Symbols of Death
            br.ui:createCheckbox(section, "Symbols of Death")
            -- Vanish
            br.ui:createCheckbox(section, "Vanish")
            -- Covenant
            br.ui:createDropdownWithout(section, "Covenant",alwaysCdAoENever,1,"|cffFFFFFFWhen to use Covenant Ability.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Cloak of Shadows
            br.ui:createCheckbox(section, "Cloak of Shadows")
            -- Crimson Vial
            br.ui:createSpinner(section, "Crimson Vial",  80,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Evasion
            br.ui:createSpinner(section, "Evasion",  40,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Feint
            br.ui:createSpinner(section, "Feint", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Kidney Shot
            br.ui:createSpinner(section, "Kidney Shot Defensive",  30,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Kick
            br.ui:createCheckbox(section, "Kick")
            -- Kidney Shot
            br.ui:createCheckbox(section, "Kidney Shot")
            -- Cheap Shot
            br.ui:createCheckbox(section, "Cheap Shot")
            -- Blind
            br.ui:createCheckbox(section, "Blind")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Shadow Dance Toggle
            br.ui:createDropdownWithout(section,  "ShadowDance Mode", br.dropOptions.Toggle,  6)
            -- Pick Pocket Toggle
            br.ui:createDropdownWithout(section,  "PickPocket Mode", br.dropOptions.Toggle,  6)
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
local power
local race
local runeforge
local talent
local unit
local units
local ui
local var = {}

-- General Locals
local comboPoints
local comboPointsDeficit
local energy
local energyRegen
local energyDeficit
local energyTTM
var.profileStop = false

-- Variables
var.stealth = false
var.pickPocketUnit = "player"

-----------------
--- Functions ---
-----------------

var.isPicked = function(thisUnit)   --  Pick Pocket Testing
    if thisUnit == nil then thisUnit = "target" end
    if (br.unpickable or unit.level() < 24
        or ui.mode.pickPocket == 3 or unit.isDummy(thisUnit) or (br._G.LootFrame:IsShown() and br._G.GetNumLootItems() == 0))
    then
        var.pickPocketUnit = thisUnit
        return true
    end
    return false
end

var.lowestTTD = function()
    local lowestUnit = "target"
    local lowestTTD = 999
    for i = 1, #enemies.yards30 do
        local thisUnit = enemies.yards30[i]
        local thisTTD = unit.ttd(thisUnit) or 999
        if thisTTD > -1 and thisTTD < lowestTTD then
            lowestUnit = thisUnit
            lowestTTD = thisTTD
        end
    end
    return lowestUnit
end

var.autoStealth = function()
    for i = 1, #enemies.yards20nc do
        local thisUnit = enemies.yards20nc[i]
        if unit.reaction(thisUnit) < 4 then return true end
    end
    return false
end

--------------------
--- Action Lists ---
--------------------
local actionList = {}
-- Action List - Extras
actionList.Extras = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy("target") then
                unit.stopAttack()
                unit.clearTarget()
                ui.chatOverlay(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end
    -- Tricks of the Trade
    if ui.checked("Tricks of the Trade on Focus") and cast.able.tricksOfTheTrade("focus") and unit.inCombat() and unit.exists("focus") and unit.friend("focus") then
        if cast.tricksOfTheTrade("focus") then ui.debug("Casting Tricks of the Trade") return true end
    end
end -- End Action List - Extras

-- Action List - Defensives
actionList.Defensive = function()
    if ui.useDefensive() and not var.stealth then
        -- Basic Healing Module
        module.BasicHealing()
        -- Cloak of Shadows
        if ui.checked("Cloak of Shadows") and cast.able.cloakOfShadows() and cast.dispel.cloakOfShadows("player") then
            if cast.cloakOfShadows() then ui.debug("Casting Cloak of Shadows") return true end
        end
        -- Crimson Vial
        if ui.checked("Crimson Vial") and cast.able.crimsonVial() and unit.hp() < ui.value("Crimson Vial") and not buff.shadowDance.exists() then
            if cast.crimsonVial() then ui.debug("Casting Crimson Vial") return true end
        end
        -- Evasion
        if ui.checked("Evasion") and cast.able.evasion() and unit.hp() < ui.value("Evasion") and unit.inCombat() then
            if cast.evasion() then ui.debug("Casting Evasion") return true end
        end
        -- Feint
        if ui.checked("Feint") and unit.hp() <= ui.value("Feint") and unit.inCombat() and not buff.feint.exists() and not buff.shadowDance.exists() then
            if cast.feint() then ui.debug("Casting Feint") return true end
        end
        -- Kidney Shot
        if ui.checked("Kidney Shot Defensive") and unit.hp() <= ui.value("Kidney Shot Defensive") and unit.inCombat() and not buff.shadowDance.exists() then
            if cast.kidneyShot() then ui.debug("Casting Kidney Shot [Defensive]") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() and not var.stealth then
        for i=1, #enemies.yards20 do
            local thisUnit = enemies.yards20[i]
            local distance = unit.distance(thisUnit)
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                -- Kick
                -- kick
                if ui.checked("Kick") and cast.able.kick(thisUnit) and distance < 5 then
                    if cast.kick(thisUnit) then ui.debug("Kick") return true end
                end
                -- Kidney Shot
                if ui.checked("Kidney Shot") and cast.able.kidneyShot(thisUnit) and cd.kick.remain() ~= 0 and cd.blind.remain() == 0 then
                    if cast.kidneyShot(thisUnit) then ui.debug("Kidney Shot") return true end
                end
                -- Blind
                if ui.checked("Blind") and cast.able.blind(thisUnit) and not buff.shadowDance.exists()
                    and (cd.kick.remain() ~= 0 or distance >= 5) and not buff.shadowDance.exists()
                then
                    if cast.blind(thisUnit) then ui.debug("Blind") return true end
                end
                -- Cheap Shot
                if ui.checked("Cheap Shot") and cast.able.cheapShot(thisUnit) and buff.shadowDance.exists() and distance < 5
                    and cd.kick.remain() ~= 0 and cd.kidneyShot.remain() == 0 and cd.blind.remain() == 0
                then
                    if cast.cheapShot(thisUnit) then ui.debug("Cheap Shot") return true end
                end
            end
        end
    end -- End Interrupt and No Stealth Check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
        -- Shadow Dance
        -- shadow_dance,use_off_gcd=1,if=!buff.shadow_dance.up&buff.shuriken_tornado.up&buff.shuriken_tornado.remains<=3.5
        if ui.mode.shadowDance == 1 and ui.alwaysCdAoENever("Shadow Dance",3,#enemies.yards5) and cast.able.shadowDance()
            and (not buff.shadowDance.exists() and buff.shurikenTornado.exists() and buff.shurikenTornado.remain() <= 3.5)
        then
            if cast.shadowDance() then ui.debug("Casting Shadow Dance [Cooldowns - Shuriken Tornado]") return true end
        end
        -- Symbols of Death
        -- symbols_of_death,use_off_gcd=1,if=buff.shuriken_tornado.up&buff.shuriken_tornado.remains<=3.5
        if ui.checked("Symbols of Death") and cast.able.symbolsOfDeath() and not cast.last.symbolsOfDeath()
            and (buff.shurikenTornado.exists() and buff.shurikenTornado.remain() <= 3.5)
        then
            if cast.symbolsOfDeath() then ui.debug("Casting Symbols of Death [Cooldowns - Shuriken Tornado]") return true end
        end
        -- Flagellation
        -- flagellation,target_if=max:target.time_to_die,if=variable.snd_condition&!stealthed.mantle&(spell_targets.shuriken_storm<=1&cooldown.symbols_of_death.up&!talent.shadow_focus.enabled|buff.symbols_of_death.up)&combo_points>=5&target.time_to_die>10
        if ui.alwaysCdAoENever("Covenant",3,5) and cast.able.flagellation() and (var.sndCondition and not var.stealthedMantle and (ui.useST(10,2) and not cd.symbolsOfDeath.exists()
            and not talent.shadowFocus or buff.symbolsOfDeath.exists()) and comboPoints >= 5 and unit.ttd(units.dyn5) > 10)
        then
            if cast.flagellation() then ui.debug("Casting Flagellation [Cooldowns]") return true end
        end
        -- Vanish
        -- vanish,if=(runeforge.mark_of_the_master_assassin&combo_points.deficit<=1-talent.deeper_strategem.enabled|runeforge.deathly_shadows&combo_points<1)&buff.symbols_of_death.up&buff.shadow_dance.up&master_assassin_remains=0&buff.deathly_shadows.down
        if ui.checked("Vanish") and ui.useCDs() and cast.able.vanish()
            and (((runeforge.markOfTheMasterAssassin.equiped and comboPointsDeficit <= 1 - var.deepStrat) or (runeforge.deathlyShadows.equiped and comboPoints < 1))
            and buff.symbolsOfDeath.exists() and buff.shadowDance.exists() and 0 == 0 and not buff.deathlyShadows.exists())
        then
            if cast.vanish() then ui.debug("Casting Vanish [Cooldowns - Legendary Equiped]") return true end
        end
        -- pool_resource,for_next=1,if=talent.shuriken_tornado.enabled&!talent.shadow_focus.enabled
        if cast.able.shurikenTornado() and talent.shurikenTornado and not talent.shadowFocus and energy < 60 then
            if cast.pool.shurikenTornado() then ui.debug("Casting Pool for Shuriken Tornado [Cooldowns - Shuriken Tornado]") return true end
        end
        -- Shuriken Tornado
        -- shuriken_tornado,if=spell_targets.shuriken_storm<=1&energy>=60&variable.snd_condition&cooldown.symbols_of_death.up&cooldown.shadow_dance.charges>=1&(!runeforge.obedience|buff.flagellation_buff.up|spell_targets.shuriken_storm>=(1+4*(!talent.nightstalker.enabled&!talent.dark_shadow.enabled)))&combo_points<=2&!buff.premeditation.up&(!covenant.venthyr|!cooldown.flagellation.up)
        if cast.able.shurikenTornado() and (ui.useST(10,2) and energy >= 60 and var.sndCondition and not cd.symbolsOfDeath.exists()
            and charges.shadowDance.count() >= 1 and (not runeforge.obedience.equiped or debuff.flagellation.exists(units.dyn5) or ui.useAOE(10,(1 + 4 * var.noNightShadow))
            and comboPoints <= 2 and not buff.premeditation.exists() and (not covenant.venthyr.active or cd.flagellation.exists())))
        then
            if cast.shurikenTornado() then ui.debug("Casting Shuriken Tornado [Cooldowns]") return true end
        end
        -- Serrated Bone Spike
        -- serrated_bone_spike,cycle_targets=1,if=variable.snd_condition&!dot.serrated_bone_spike_dot.ticking&target.time_to_die>=21&(combo_points.deficit>=(cp_gain>?4))&!buff.shuriken_tornado.up&(!buff.premeditation.up|spell_targets.shuriken_storm>4)|fight_remains<=5&spell_targets.shuriken_storm<3
        if ui.alwaysCdAoENever("Covenant",3,5) then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if cast.able.serratedBoneSpike(thisUnit) and (var.sndCondition and not debuff.serratedBoneSpikeDot.exists(thisUnit)
                    and unit.ttd(thisUnit) >= 21 and (comboPointsDeficit >= var.spikesOr4)) and not buff.shurikenTornado.exists()
                    and (not buff.premeditation.exists() or ui.useAOE(10,5)) or unit.ttdGroup(5) <= 5 and ui.useST(10,3)
                then
                    if cast.serratedBoneSpike(thisUnit) then ui.debug("Casting Serrated Bone Spike [Cooldowns]") return true end
                end
            end
        end
        -- Spesis
        -- sepsis,if=variable.snd_condition&combo_points.deficit>=1&target.time_to_die>=16
        if ui.alwaysCdAoENever("Covenant",3,5) and cast.able.sepsis() and (var.sndCondition and comboPointsDeficit >= 1 and unit.ttd(units.dyn5) >= 16) then
            if cast.sepsis() then ui.debug("Casting Sepsis [Cooldowns]") return true end
        end
        -- Symbols of Death
        -- symbols_of_death,if=variable.snd_condition&(!stealthed.all|buff.perforated_veins.stack<4|spell_targets.shuriken_storm>4&!variable.use_priority_rotation)&(!talent.shuriken_tornado.enabled|talent.shadow_focus.enabled|spell_targets.shuriken_storm>=2|cooldown.shuriken_tornado.remains>2)&(!covenant.venthyr|cooldown.flagellation.remains>10|cooldown.flagellation.up&combo_points>=5)
        if ui.checked("Symbols of Death") and cast.able.symbolsOfDeath()
            and (var.sndCondition and (not var.stealthAll or buff.perforatedVeins.stack() < 4 or (ui.useAOE(10,5) and not var.usePriorityRotation))
            and (not talent.shurikenTornado or talent.shadowFocus or ui.useAOE(10,2) or cd.shurikenTornado.remain() > 2)
            and (not covenant.venthyr.active or cd.flagellation.remain() > 10 or (not cd.flagellation.exists() and comboPoints >= 5)))
        then
            if cast.symbolsOfDeath() then ui.debug("Casting Symbols of Death [Cooldowns]") return true end
        end
        -- Marked For Death
        -- marked_for_death,line_cd=1.5,target_if=min:target.time_to_die,if=raid_event.adds.up&(target.time_to_die<combo_points.deficit|!stealthed.all&combo_points.deficit>=cp_max_spend)
        if ui.checked("Marked For Death") and cast.able.markedForDeath(var.markedTarget) and ui.timer("Marked For Death AOE",1.5)
            and (ui.useAOE(10,2) and (unit.ttd(var.markedTarget) < comboPointsDeficit or not var.stealthAll and ui.value("Max Combo Spend")))
        then
            if cast.markedForDeath(var.markedTarget) then ui.debug("Casting Marked For Death [Cooldowns - AOE]") return true end
        end
        -- marked_for_death,if=raid_event.adds.in>30-raid_event.adds.duration&combo_points.deficit>=cp_max_spend
        if ui.checked("Marked For Death") and cast.able.markedForDeath(var.markedTarget) and ui.timer("Marked For Death AOE",1)
            and (ui.useST(10,2) and comboPointsDeficit >= ui.value("Max Combo Spend"))
        then
            if cast.markedForDeath(var.markedTarget) then ui.debug("Casting Marked For Death [Cooldowns - ST]") return true end
        end
        -- Shadow Blades
        -- shadow_blades,if=variable.snd_condition&combo_points.deficit>=2&(buff.symbols_of_death.up|fight_remains<=20|!buff.shadow_blades.up&set_bonus.tier28_2pc)
        if ui.alwaysCdAoENever("Shadow Blades", 3, 5) and cast.able.shadowBlades()
            and (var.sndCondition and comboPointsDeficit >= 2 and (buff.symbolsOfDeath.exists() or unit.ttdGroup(5) <= 20
                or (not buff.shadowBlades.exists() and equiped.tier(28) >= 2)))
        then
            if cast.shadowBlades() then ui.debug("Casting Shadow Blades [Cooldowns]") return true end
        end
        -- Echoing Reprimand
        -- echoing_reprimand,if=(!talent.shadow_focus.enabled|!stealthed.all|spell_targets.shuriken_storm>=4)&variable.snd_condition&combo_points.deficit>=2&(variable.use_priority_rotation|spell_targets.shuriken_storm<=4|runeforge.resounding_clarity)
        if ui.alwaysCdAoENever("Covenant",3,5) and cast.able.echoingReprimand() and ((not talent.shadowFocus or not var.stealthAll or ui.useAOE(10,4)) and
            var.sndCondition and comboPointsDeficit >= 2 and (var.usePriorityRotation or ui.useST(10,5) or runeforge.resoundingClarity.equiped))
        then
            if cast.echoingReprimand() then ui.debug("Casting Echoing Reprimand [Cooldowns]") return true end
        end
        -- Shuriken Tornado
        -- shuriken_tornado,if=(talent.shadow_focus.enabled|spell_targets.shuriken_storm>=2)&variable.snd_condition&buff.symbols_of_death.up&combo_points<=2&(!buff.premeditation.up|spell_targets.shuriken_storm>4)
        if cast.able.shurikenTornado() and ((talent.shadowFocus or ui.useAOE(10,2)) and var.sndCondition
            and buff.symbolsOfDeath.exists() and comboPoints <= 2 and (not buff.premeditation.exists() or ui.useAOE(10,5)))
        then
            if cast.shurikenTornado() then ui.debug("Casting Shuriken Tornado [Cooldowns - Snd Condition]") return true end
        end
        -- Shadow Dance
        -- shadow_dance,if=!buff.shadow_dance.up&fight_remains<=8+talent.subterfuge.enabled
        if ui.mode.shadowDance == 1 and ui.alwaysCdAoENever("Shadow Dance",3,#enemies.yards5) and cast.able.shadowDance()
            and (not buff.shadowDance.exists() and unit.ttdGroup(5) <= 8 + var.subtle)
        then
            if cast.shadowDance() then ui.debug("Casting Shadow Dance [Cooldowns - Fight Over Soon]") return true end
        end
        -- Fleshcraft
        -- fleshcraft,if=(soulbind.pustule_eruption|soulbind.volatile_solvent)&energy.deficit>=30&!stealthed.all&buff.symbols_of_death.down
        if ui.alwaysCdAoENever("Covenant",3,5) and cast.able.fleshcraft() and ((conduit.pustuleEruption.active or conduit.volatileSolvent.active) and energyDeficit >= 30 and not var.stealthAll and not buff.symbolsOfDeath.exists()) then
            if cast.fleshcraft() then ui.debug("Casting Fleshcraft [Cooldowns]") return true end
        end
        -- Potion
        -- potion,if=buff.bloodlust.react|fight_remains<30|buff.symbols_of_death.up&(buff.shadow_blades.up|cooldown.shadow_blades.remains<=10)
        -- if cast.able.potion() and (buff.bloodlust.exists() or fight_remains < 30 or buff.symbolsOfDeath.exists() and (buff.shadowBlades.exists() or cd.shadowBlades.remain() <= 10)) then
        --     if cast.potion() then return end
        -- end
        -- Racial
        -- blood_fury,if=buff.symbols_of_death.up
        -- berserking,if=buff.symbols_of_death.up
        -- fireblood,if=buff.symbols_of_death.up
        -- ancestral_call,if=buff.symbols_of_death.up
        if ui.checked("Racial") and ui.useCDs() and cast.able.racial() and (buff.symbolsOfDeath.exists()
            and (unit.race() == "Orc" or unit.race() == "Troll" or unit.race() == "DarkIronDwarf" or unit.race() == "MagharOrc"))
        then
            if cast.racial() then ui.debug("Casting Racial [Cooldowns]") return true end
        end
        -- Trinkets
        -- use_item,name=cache_of_acquired_treasures,if=(covenant.venthyr&buff.acquired_axe.up|!covenant.venthyr&buff.acquired_wand.up)&(spell_targets.shuriken_storm=1&raid_event.adds.in>60|fight_remains<25|variable.use_priority_rotation)|buff.acquired_axe.up&spell_targets.shuriken_storm>1
        --TODO: parsing use_item
        -- use_item,name=scars_of_fraternal_strife,if=!buff.scars_of_fraternal_strife_4.up|fight_remains<30
        --TODO: parsing use_item
        -- use_items,if=buff.symbols_of_death.up|fight_remains<20
        if buff.symbolsOfDeath.exists() then
            module.BasicTrinkets()
        end
    end
end -- End Action List - Cooldowns

-- Action List - Stealth Cooldowns
actionList.StealthCooldowns = function()
    -- Vanish
    -- vanish,if=(!variable.shd_threshold|!talent.nightstalker.enabled&talent.dark_shadow.enabled)&combo_points.deficit>1&!runeforge.mark_of_the_master_assassin
    if ui.checked("Vanish") and ui.useCDs() and cast.able.vanish() and ((not var.shdThreshold or not talent.nightstalker and talent.darkShadow)
        and comboPointsDeficit > 1 and not runeforge.markOfTheMasterAssassin.equiped)
    then
        if cast.vanish() then ui.debug("Casting Vanish [Stealth Cooldowns]") return true end
    end
    -- Shadowmeld
    -- pool_resource,for_next=1,extra_amount=40,if=race.night_elf
    if ui.checked("Racial") and ui.useCDs() and energy < 40 and unit.race() == "NightElf" then return true end
    -- shadowmeld,if=energy>=40&energy.deficit>=10&!variable.shd_threshold&combo_points.deficit>1
    if ui.checked("Racial") and ui.useCDs() and cast.able.racial() and (energy >= 40 and energyDeficit >= 10 and not var.shdThreshold and comboPointsDeficit > 1 and unit.race() == "NightElf") then
        if cast.racial() then ui.debug("Casting Shadowmeld [Stealth Cooldowns]") return true end
    end
    -- Shadow Dance
    -- shadow_dance,if=(runeforge.the_rotten&cooldown.symbols_of_death.remains<=8|variable.shd_combo_points&(buff.symbols_of_death.remains>=1.2|variable.shd_threshold)|buff.chaos_bane.up|spell_targets.shuriken_storm>=4&cooldown.symbols_of_death.remains>10)&(buff.perforated_veins.stack<4|spell_targets.shuriken_storm>3)
    if ui.mode.shadowDance == 1 and ui.alwaysCdAoENever("Shadow Dance",3,#enemies.yards5) and cast.able.shadowDance()
        and ((runeforge.theRotten.equiped and cd.symbolsOfDeath.remain() <= 8
            or var.shdComboPoints and (buff.symbolsOfDeath.remain() >= 1.2 or var.shdThreshold) or buff.chaosBane.exists()
            or ui.useAOE(10,4) and cd.symbolsOfDeath.remain() > 10) and (buff.perforatedVeins.stack() < 4 or ui.useAOE(10,4)))
    then
        if cast.shadowDance() then ui.debug("Casting Shadow Dance [Stealth Cooldowns]") return true end
    end
    -- shadow_dance,if=variable.shd_combo_points&fight_remains<cooldown.symbols_of_death.remains|!talent.enveloping_shadows.enabled
    if ui.alwaysCdAoENever("Shadow Dance",3,#enemies.yards5) and cast.able.shadowDance()
        and (var.shdComboPoints and unit.ttdGroup(5) < cd.symbolsOfDeath.remain() or not talent.envelopingShadows)
    then
        if cast.shadowDance() then ui.debug("Casting Shadow Dance [Stealth Cooldowns - Shd Combo Points]") return true end
    end
end -- End Action List - Stealth Cooldowns

-- Action List - Stealthed
actionList.Stealthed = function()
    -- Shadowstrike
    -- shadowstrike,if=(buff.stealth.up|buff.vanish.up)&(spell_targets.shuriken_storm<4|variable.use_priority_rotation)&master_assassin_remains=0
    if cast.able.shadowstrike() and ((buff.stealth.exists() or buff.vanish.exists()) and (ui.useST(10, 4) or var.usePriorityRotation) and 0 == 0) then
        if cast.shadowstrike() then ui.debug("Casting Shadowstrike [Stealth - Stealth/Vanish]") return true end
    end
    -- Action List - Finish
    -- call_action_list,name=finish,if=variable.effective_combo_points>=cp_max_spend
    if var.effectiveComboPoints >= var.cpMaxSpend then
        if actionList.Finish() then return true end
    end
    -- call_action_list,name=finish,if=buff.shuriken_tornado.up&combo_points.deficit<=2
    if buff.shurikenTornado.exists() and comboPointsDeficit <= 2 then
        if actionList.Finish() then return true end
    end
    -- call_action_list,name=finish,if=spell_targets.shuriken_storm>=4&variable.effective_combo_points>=4
    if ui.useAOE(10,4) and var.effectiveComboPoints >= 4 then
        if actionList.Finish() then return true end
    end
    -- call_action_list,name=finish,if=combo_points.deficit<=1-(talent.deeper_stratagem.enabled&buff.vanish.up)
    if comboPointsDeficit <= 1 - var.deepVanish then
        if actionList.Finish() then return true end
    end
    -- Shadowstrike
    -- shadowstrike,if=stealthed.sepsis&spell_targets.shuriken_storm<4
    if cast.able.shadowstrike() and (buff.stealthSepsis.exists() and ui.useST(10, 4)) then
        if cast.shadowstrike() then ui.debug("Casting Shadowstrike [Stealth - Sepsis]") return true end
    end
    -- Backstab
    -- backstab,if=conduit.perforated_veins.rank>=8&buff.perforated_veins.stack>=5&buff.shadow_dance.remains>=3&buff.shadow_blades.up&(spell_targets.shuriken_storm<=3|variable.use_priority_rotation)&(buff.shadow_blades.remains<=buff.shadow_dance.remains+2|!covenant.venthyr)
    if cast.able.backstab() and (conduit.perforatedVeins.rank >= 8 and buff.perforatedVeins.stack() >= 5 and buff.shadowDance.remain() >= 3 and buff.shadowBlades.exists()
        and (ui.useST(10, 4) or var.usePriorityRotation) and (buff.shadowBlades.remain() <= buff.shadowDance.remain() + 2 or not covenant.venthyr.active))
    then
        if cast.backstab() then ui.debug("Casting Backstab [Stealth]") return true end
    end
    -- Shiv
    -- shiv,if=talent.nightstalker.enabled&runeforge.tiny_toxic_blade&spell_targets.shuriken_storm<5
    if cast.able.shiv() and (talent.nightstalker and runeforge.tinyToxicBlade.equiped and ui.useST(10, 5)) then
        if cast.shiv() then ui.debug("Casting Shiv [Stealth]") return true end
    end
    -- Shadowstrike
    -- shadowstrike,cycle_targets=1,if=!variable.use_priority_rotation&debuff.find_weakness.remains<1&spell_targets.shuriken_storm<=3&target.time_to_die-remains>6
    for i = 1, #enemies.yards5 do
        local thisUnit = enemies.yards5[i]
        if cast.able.shadowstrike(thisUnit) and (not var.usePriorityRotation and debuff.findWeakness.remain(thisUnit) < 1 and ui.useST(10, 4) and unit.ttd(thisUnit) > 6) then
            if cast.shadowstrike() then ui.debug("Casting Shadowstrike [Stealth - Find Weakness]") return true end
        end
    end
    -- shadowstrike,if=variable.use_priority_rotation&(debuff.find_weakness.remains<1|talent.weaponmaster.enabled&spell_targets.shuriken_storm<=4)
    if cast.able.shadowstrike() and (var.usePriorityRotation and (debuff.findWeakness.remain(units.dyn5) < 1 or talent.weaponmaster and ui.useST(10, 5))) then
        if cast.shadowstrike() then ui.debug("Casting Shadowstrike [Stealth - Weaponmaster]") return true end
    end
    -- Shuriken Storm
    -- shuriken_storm,if=spell_targets>=3+(buff.the_rotten.up|runeforge.akaaris_soul_fragment|set_bonus.tier28_2pc&talent.shadow_focus.enabled)&(buff.symbols_of_death_autocrit.up|!buff.premeditation.up|spell_targets>=5)
    if cast.able.shurikenStorm("player","aoe",1,8) and (ui.useAOE(10,3 + var.shurikenStormNumeric)
        and (buff.symbolsOfDeathCrit.exists() or not buff.premeditation.exists() or ui.useAOE(10,5)))
    then
        if cast.shurikenStorm("player","aoe",1,8) then ui.debug("Casting Shuriken Storm [Stealth]") return true end
    end
    -- Shadowstrike
    -- shadowstrike,if=debuff.find_weakness.remains<=1|cooldown.symbols_of_death.remains<18&debuff.find_weakness.remains<cooldown.symbols_of_death.remains
    if cast.able.shadowstrike() and (debuff.findWeakness.remain(units.dyn5) <= 1 or cd.symbolsOfDeath.remain() < 18 and debuff.findWeakness.remain(units.dyn5) < cd.symbolsOfDeath.remain()) then
        if cast.shadowstrike() then ui.debug("Casting Shadowstrike [Stealth - Symbols on CD]") return true end
    end
    -- Gloomblade
    -- gloomblade,if=buff.perforated_veins.stack>=5&conduit.perforated_veins.rank>=13
    if cast.able.gloomblade() and (buff.perforatedVeins.stack() >= 5 and conduit.perforatedVeins.rank >= 13) then
        if cast.gloomblade() then ui.debug("Casting Gloomblade [Stealth]") return true end
    end
    -- Shadowstrike
    -- shadowstrike
    if cast.able.shadowstrike() then
        if cast.shadowstrike() then ui.debug("Casting Shadowstrike [Stealth]") return true end
    end
    -- Cheap Shot
    -- cheap_shot,if=!target.is_boss&combo_points.deficit>=1&buff.shot_in_the_dark.up&energy.time_to_40>gcd.max
    if cast.able.cheapShot() and (not unit.isBoss(unit.dyn5) and comboPointsDeficit >= 1 and buff.shotInTheDark.exists() and energyTTM(40) > unit.gcd(true)) then
        if cast.cheapShot() then ui.debug("Casting Cheap Shot [Shot in the Dark]") return true end
    end
end -- End Action List - Stealthed

-- Action List - Finish
actionList.Finish = function()
    -- Slice and Dice
    -- slice_and_dice,if=!variable.premed_snd_condition&spell_targets.shuriken_storm<6&!buff.shadow_dance.up&buff.slice_and_dice.remains<fight_remains&refreshable
    if cast.able.sliceAndDice() and (not var.premedSndCondition and ui.useST(10,6) and not buff.shadowDance.exists() and buff.sliceAndDice.remain() < unit.ttdGroup(5) and buff.sliceAndDice.refresh()) then
        if cast.sliceAndDice() then ui.debug("Casting Slice and Dice [Finish]") return true end
    end
    -- slice_and_dice,if=variable.premed_snd_condition&cooldown.shadow_dance.charges_fractional<1.75&buff.slice_and_dice.remains<cooldown.symbols_of_death.remains&(cooldown.shadow_dance.ready&buff.symbols_of_death.remains-buff.shadow_dance.remains<1.2)
    if cast.able.sliceAndDice() and (var.premedSndCondition and charges.shadowDance.frac() < 1.75 and buff.sliceAndDice.remain() < cd.symbolsOfDeath.remain() and (not cd.shadowDance.exists() and buff.symbolsOfDeath.remain() - buff.shadowDance.remain() < 1.2)) then
        if cast.sliceAndDice() then ui.debug("Casting Slice and Dice [Finish - Premed]") return true end
    end
    -- Rupture
    -- rupture,if=!stealthed.all&(!variable.skip_rupture|variable.use_priority_rotation)&target.time_to_die-remains>6&refreshable
    if cast.able.rupture() and (not var.stealthAll and (not var.skipRupture or var.usePriorityRotation) and unit.ttd(units.dyn5) - debuff.rupture.remain(units.dyn5) > 6 and debuff.rupture.refresh(units.dyn5)) then
        if cast.rupture() then ui.debug("Casting Rupture [Finish - No Stealth]") return true end
    end
    -- Secret Technique
    -- secret_technique
    if cast.able.secretTechnique() then
        if cast.secretTechnique() then ui.debug("Casting Secret Technique [Finish]") return true end
    end
    -- Rupture
    -- rupture,cycle_targets=1,if=!variable.skip_rupture&!variable.use_priority_rotation&spell_targets.shuriken_storm>=2&target.time_to_die>=(5+(2*combo_points))&refreshable
    for i = 1, #enemies.yards5 do
        local thisUnit = enemies.yards5[i]
        if cast.able.rupture(thisUnit) and (not var.skipRupture and not var.usePriorityRotation and ui.useAOE(10,2)
            and unit.ttd(thisUnit) >= (5 + (2 * comboPoints)) and debuff.rupture.refresh(thisUnit))
        then
            if cast.rupture(thisUnit) then ui.debug("Casting Rupture [Finish - Cycle]") return true end
        end
    end
    -- rupture,if=!variable.skip_rupture&remains<cooldown.symbols_of_death.remains+10&cooldown.symbols_of_death.remains<=5&target.time_to_die-remains>cooldown.symbols_of_death.remains+5
    if cast.able.rupture() and (not var.skipRupture and debuff.rupture.remain(units.dyn5) < cd.symbolsOfDeath.remain() + 10
        and cd.symbolsOfDeath.remain() <= 5 and unit.ttd(units.dyn5) - debuff.rupture.remain(units.dyn5) > cd.symbolsOfDeath.remain() + 5)
    then
        if cast.rupture() then ui.debug("Casting Rupture [Finish]") return true end
    end
    -- Black Powder
    -- black_powder,if=!variable.use_priority_rotation&spell_targets>=3
    if cast.able.blackPowder("player","aoe",1,10) and (not var.usePriorityRotation and ui.useAOE(10,3)) then
        if cast.blackPowder("player","aoe",1,10) then ui.debug("Casting Black Powder [Finish]") return true end
    end
    -- Eviscerate
    -- eviscerate
    if cast.able.eviscerate() then
        if cast.eviscerate() then ui.debug("Casting Eviscerate [Finish]") return true end
    end
end -- End Action List - Finish

-- Action List - Build
actionList.Build = function()
    -- Shiv
    -- shiv,if=!talent.nightstalker.enabled&runeforge.tiny_toxic_blade&spell_targets.shuriken_storm<5
    if cast.able.shiv() and (not talent.nightstalker and runeforge.tinyToxicBlade.equiped and ui.useST(10,5)) then
        if cast.shiv() then ui.debug("Casting Shiv [Build]") return true end
    end
    -- Shuriken Storm
    -- shuriken_storm,if=spell_targets>=2&(!covenant.necrolord|cooldown.serrated_bone_spike.max_charges-charges_fractional>=0.25|spell_targets.shuriken_storm>4)&(buff.perforated_veins.stack<=4|spell_targets.shuriken_storm>4&!variable.use_priority_rotation)
    if cast.able.shurikenStorm("player","aoe",1,8) and (ui.useAOE(10,2)
        and (not covenant.necrolord.active or charges.serratedBoneSpike.timeTillFull(true) >= 0.25 or ui.useAOE(10,5))
        and (buff.perforatedVeins.stack() <= 4 or ui.useAOE(10,5) and not var.usePriorityRotation))
    then
        if cast.shurikenStorm("player","aoe",1,8) then ui.debug("Casting Shuriken Storm [Build]") return true end
    end
    -- Serrated Bone Spike
    -- serrated_bone_spike,if=buff.perforated_veins.stack<=2&(cooldown.serrated_bone_spike.max_charges-charges_fractional<=0.25|soulbind.lead_by_example.enabled&!buff.lead_by_example.up|soulbind.kevins_oozeling.enabled&!debuff.kevins_wrath.up)
    if cast.able.serratedBoneSpike() and (buff.perforatedVeins.stack() <= 2 and (charges.serratedBoneSpike.timeTillFull(true) <= 0.25
        or (conduit.leadByExample.enabled and not buff.leadByExample.exists()) or (conduit.kevinsOozeling.enabled and not debuff.kevinsWrath.exists())))
    then
        if cast.serratedBoneSpike() then ui.debug("Casting Serrated Bone Spike [Build]") return true end
    end
    -- Gloomblade
    -- gloomblade
    if cast.able.gloomblade() then
        if cast.gloomblade() then ui.debug("Casting Gloomblade [Build]") return true end
    end
    -- Backstab
    -- backstab,if=!covenant.kyrian|!(variable.is_next_cp_animacharged&(time_to_sht.3.plus<0.5|time_to_sht.4.plus<1)&energy<60)
    if cast.able.backstab() and (not covenant.kyrian.active or not (var.isNextCpAnimacharged --[[and (var.timeToSht3plus < 0.5 or var.timeToSht4plus < 1) ]]and energy < 60)) then
        if cast.backstab() then ui.debug("Casting Backstab [Build]") return true end
    end
    -- Sinister Strike
    if unit.level() < 14 and cast.able.sinisterStrike() and cast.timeSinceLast.sinisterStrike() > unit.gcd(true) then
        if cast.sinisterStrike() then ui.debug("Casting Sinister Strike [Build]") return true end
    end
end -- End Action List - Build

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        -- Poisons
        -- apply_poison
        if not unit.moving() then
            if ui.value("Lethal Poison") == 1 and buff.instantPoison.remain() < 300 and not cast.last.instantPoison() and ui.timer("Leathal Poison",1) then
                if cast.instantPoison("player") then ui.debug("Casting Instant Poison") return true end
            end
            if ui.value("Lethal Poison") == 2 and buff.woundPoison.remain() < 300 and not cast.last.woundPoison() and ui.timer("Leathal Poison",1) then
                if cast.woundPoison("player") then ui.debug("Casting Wound Poison") return true end
            end
            if ui.value("Non-Lethal Poison") == 1 and buff.cripplingPoison.remain() < 300 and not cast.last.cripplingPoison() and ui.timer("Non-Leathal Poison",1) then
                if cast.cripplingPoison("player") then ui.debug("Casting Crippling Poison") return true end
            end
            if ui.value("Non-Lethal Poison") == 2 and buff.numbingPoison.remain() < 300 and not cast.last.numbingPoison() and ui.timer("Non-Leathal Poison",1) then
                if cast.numbingPoison("player") then ui.debug("Casting Numbing Poison") return true end
            end
        end
        -- FlaskUp Module
        -- flask
        module.FlaskUp("Agility")
        -- Stealth
        -- stealth
        if ui.checked("Stealth") and cast.able.stealth() and (not unit.resting() or unit.isDummy("target")) and not var.stealth then
            if ui.value("Stealth") == 1 then
                if cast.stealth() then ui.debug("Casting Stealth [Pre-Combat]") return true end
            end
            if var.autoStealth() and ui.value("Stealth") == 3 then
                if cast.stealth() then ui.debug("Casting Stealth [Pre-Combat - Detected Enemy Nearby]") return true end
            end
        end
        if unit.valid("target") then
            if ui.checked("Pre-Pull") and ui.useCDs() and ui.mode.pickPocket ~= 2 and not cast.last.vanish() and not buff.vanish.exists() then
                -- Marked For Death
                -- marked_for_death,precombat_seconds=15
                if cast.able.markedForDeath("target") and comboPoints <= 1 and ui.pullTimer() <= 15 then
                    if cast.markedForDeath("target") then ui.debug("Casting Marked for Death [Pre-Pull]") return true end
                end
                -- Slice and Dice
                -- slice_and_dice,precombat_seconds=1
                if cast.able.sliceAndDice() and comboPoints > 0 and ui.pullTimer() <= 1 then
                    if cast.sliceAndDice() then ui.debug("Casting Slice and Dice [Pre-Pull]") return true end
                end
                -- Shadow Blades
                -- shadow_blades,if=runeforge.mark_of_the_master_assassin
                if cast.able.shadowBlades() and runeforge.markOfTheAssassin.equiped and ui.pullTimer() <= 1 then
                    if cast.shadowBlades() then ui.debug("Casting Shadow Blades [Pre-Pull]") return true end
                end
            end
            -- Shadowstep
            if ui.checked("Shadowstep") and cast.able.shadowstep("target")
                and (not var.isPicked("target") or not var.stealth or energy < 40 or (ui.value("SS Range") < 25 and unit.distance("target") > ui.value("SS Range")))
                and unit.distance("target") > 10 and cast.timeSinceLast.shadowstrike() > unit.gcd(true)
            then
                if cast.shadowstep("target") then ui.debug("Casting Shadowstep [Pre-Combat]") return true end
            end
            if var.stealth then
                -- Pickpocket
                for i = 1, #enemies.yards10nc do
                    local thisUnit = enemies.yards10nc[i]
                    if not var.isPicked(thisUnit) and (unit.isUnit(thisUnit,"target") or ui.mode.pickPocket == 2) then
                        if ui.mode.pickPocket == 2 and debuff.sap.remain(thisUnit) < 1 then
                            if cast.sap(thisUnit) then ui.debug("Casting Sap [Pre-Combat - Pickpocket]") return true end
                        end
                        if cast.pickPocket(thisUnit) then br.pickPocketing= true ui.debug("Casting Pickpocket [Pre-Combat]") return true end
                    end
                end
                --Ambush / Shadowstrike
                if ui.value("Stealth Breaker") == 1 then
                    -- Shadowstrike
                    if cast.able.shadowstrike("target",nil,1,ui.value("SS Range")-1) and var.isPicked() then
                        if cast.shadowstrike("target",nil,1,ui.value("SS Range")-1) then ui.debug("Casting Shadowstrike [Pre-Combat]") return true end
                    end
                    -- Ambush
                    if unit.level() < 12 and cast.able.ambush("target") and cast.timeSinceLast.ambush() > unit.gcd(true) then
                        if cast.ambush("target") then ui.debug("Casting Ambush [Pre-Combat]") return true end
                    end
                end
                -- Cheap Shot
                if (ui.value("Stealth Breaker") == 2 or (ui.value("Stealth Breaker") == 1 and unit.level() < 7))
                    and cast.able.cheapShot("target") and cast.timeSinceLast.cheapShot() > unit.gcd(true)
                then
                    if cast.cheapShot("target") then ui.debug("Casting Cheap Shot [Pre-Combat]") return true end
                end
            end
            -- Sinister Strike / Backstab
            if ui.value("Stealth Breaker") == 3 then
                -- Backstab
                if cast.able.backstab("target") and cast.timeSinceLast.backstab() > unit.gcd(true) then
                    if cast.backstab("target") then ui.debug("Casting Backstab [Pre-Combat]") return true end
                end
                -- Sinister Strike
                if unit.level() < 14 and cast.able.sinisterStrike("target") and cast.timeSinceLast.sinisterStrike() > unit.gcd(true) then
                    if cast.sinisterStrike("target") then ui.debug("Casting Sinister Strike [Pre-Combat]") return true end
                end
            end
            -- Start Attack
            if cast.able.autoAttack("target") and energy < 45 and unit.distance("target") < 5
                and not cast.last.vanish() and not (buff.vanish.exists() or buff.shadowmeld.exists()) then
                if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
            end
        end
    end
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------
    --- Locals ---
    --------------
    -- BR API
    if comboPoints == nil then
        buff            = br.player.buff
        cast            = br.player.cast
        cd              = br.player.cd
        charges         = br.player.charges
        conduit         = br.player.conduit
        covenant        = br.player.covenant
        debuff          = br.player.debuff
        enemies         = br.player.enemies
        equiped         = br.player.equiped
        module          = br.player.module
        race            = br.player.race
        runeforge       = br.player.runeforge
        power           = br.player.power
        talent          = br.player.talent
        ui              = br.player.ui
        unit            = br.player.unit
        units           = br.player.units
    end
    comboPoints         = power.comboPoints.amount()
    comboPointsDeficit  = power.comboPoints.deficit()
    energy              = power.energy.amount()
    energyRegen         = power.energy.regen()
    energyDeficit       = power.energy.deficit()
    energyTTM           = power.energy.ttm()
    var.getTime         = ui.time()

    -- Get Best Unit for Range
    -- units.get(range, aoe)
    units.get(5)
    units.get(30)

    -- Get List of Enemies for Range
    -- enemies.get(range, from unit, no combat, variable)
    enemies.get(5)
    enemies.get(10)
    enemies.get(10,"player",true)
    enemies.get(20)
    enemies.get(20,"player",true)
    enemies.get(30)

    -- General Vars
    var.stealth = buff.stealth.exists() or buff.vanish.exists() or buff.shadowDance.exists()
    var.stealthAll = buff.stealth.exists() or buff.vanish.exists() or buff.shadowmeld.exists() or buff.shadowDance.exists() or buff.stealthSepsis.exists()
    var.cpMaxSpend = ui.value("Max Combo Spend")
    var.markedTarget = ui.value("Marked For Death") == 1 and units.dyn5 or var.lowestTTD()
    var.spikesOr4 =  debuff.serratedBoneSpikeDot.count() > 4 and debuff.serratedBoneSpikeDot.count() or 4

    -- Numeric Returns
    if (not talent.nightstalker and not talent.darkShadow) then var.noNightShadow = 1 else var.noNightShadow = 0 end
    if talent.deeperStratagem then var.deepStrat = 1 else var.deepStrat = 0 end
    if talent.deeperStratagem and buff.vanish.exists() then var.deepVanish = 1 else var.deepVanish = 0 end
    if talent.masterOfShadows then var.masterShadow = 1 else var.masterShadow = 0 end
    if var.stealthAll then var.stealthedAll = 1 else var.stealthedAll = 0 end
    if talent.subterfuge then var.subtle = 1 else var.subtle = 2 end
    if talent.vigor then var.vigorous = 1 else var.vigorous = 0 end
    if talent.shadowFocus then var.focused = 1 else var.focused = 0 end
    if talent.alacrity then var.alacrity = 1 else var.alacrity = 0 end
    if ui.useAOE(10,4) then var.manyTargets = 1 else var.manyTargets = 0 end
    if buff.shadowBlades.exists() then var.shadowed = 1 else var.shadowed = 0 end
    if covenant.necrolord.active then var.necro = 1 else var.necro = 0 end
    if covenant.kyrian.active and equiped.tier(28) >= 2 and cd.symbolsOfDeath.remain() >=8 then var.kyrian2T28Symbols = 1 else var.kyrian2T28Symbols = 0 end
    if unit.combatTime() < 10 then var.combatStart = 1 else var.combatStart = 0 end
    if (buff.theRotten.exists() or runeforge.akaarisSoulFragment.equiped or (equiped.tier(28) >= 2 and talent.shadowFocus)) then var.shurikenStormNumeric = 1 else var.shurikenStormNumeric = 0 end


    -- SimC Specific Variables
    -- variable,name=snd_condition,value=buff.slice_and_dice.up|spell_targets.shuriken_storm>=6
    var.sndCondition = buff.sliceAndDice.exists() or ui.useAOE(10,6)
    -- variable,name=is_next_cp_animacharged,if=covenant.kyrian,value=combo_points=1&buff.echoing_reprimand_2.up|combo_points=2&buff.echoing_reprimand_3.up|combo_points=3&buff.echoing_reprimand_4.up|combo_points=4&buff.echoing_reprimand_5.up
    var.isNextCpAnimaCharged = covenant.kyrian.active
        and ((comboPoints == 1 and buff.echoingReprimand.stack() == 2)
        or (comboPoints == 2 and buff.echoingReprimand.stack() == 3)
        or (comboPoints == 3 and buff.echoingReprimand.stack() == 4)
        or (comboPoints == 4 and buff.echoingReprimand.stack() == 5))
    -- variable,name=effective_combo_points,value=effective_combo_points
    var.effectiveComboPoints = var.effectiveComboPoints or 0
    -- variable,name=effective_combo_points,if=covenant.kyrian&effective_combo_points>combo_points&combo_points.deficit>2&time_to_sht.4.plus<0.5&!variable.is_next_cp_animacharged,value=combo_points
    if (covenant.kyrian.active and var.effectiveComboPoints > comboPoints and comboPointsDeficit > 2 and var.timeToSht4Plus < 0.5 and not var.isNextCpAnimaCharged) then
        var.effectiveComboPoints = comboPoints
    end
    -- variable,name=use_priority_rotation,value=priority_rotation&spell_targets.shuriken_storm>=2
    var.usePriorityRotation = ui.checked("Priority Rotation") and ui.useAOE(10,2)
    -- variable,name=stealth_threshold,value=25+talent.vigor.enabled*20+talent.master_of_shadows.enabled*20+talent.shadow_focus.enabled*25+talent.alacrity.enabled*20+25*(spell_targets.shuriken_storm>=4)
    var.stealthThreshold = 25 + var.vigorous * 20 + var.masterShadow * 20 + var.focused * 25 + var.alacrity * 20 + 25 * var.manyTargets
    -- variable,name=premed_snd_condition,value=talent.premeditation.enabled&spell_targets.shuriken_storm<(5-covenant.necrolord)&!covenant.kyrian
    var.premedSndCondition = talent.premeditation and ui.useST(10,(5 - var.necro)) and not covenant.kyrian.active
    -- variable,name=skip_rupture,value=master_assassin_remains>0|!talent.nightstalker.enabled&talent.dark_shadow.enabled&buff.shadow_dance.up|spell_targets.shuriken_storm>=(4-stealthed.all*talent.shadow_focus.enabled)
    var.skipRupture = false or not talent.nightstalker and talent.darkShadow and buff.shadowDance.exists() or ui.useAOE(10,(4 - var.stealthedAll * var.focused))
    -- Shd Threshold
    -- variable,name=shd_threshold,value=cooldown.shadow_dance.charges_fractional>=(1.75-0.75*(covenant.kyrian&set_bonus.tier28_2pc&cooldown.symbols_of_death.remains>=8))
    var.shdThreshold = charges.shadowDance.frac() >= (1.75 - 0.75 * var.kyrian2T28Symbols)
    -- variable,name=shd_threshold,if=runeforge.the_rotten,value=cooldown.shadow_dance.charges_fractional>=1.75|cooldown.symbols_of_death.remains>=16
    var.shdThreshold = runeforge.theRotten.equiped and (charges.shadowDance.frac() >= 1.75 or cd.symbolsOfDeath.remain() >= 16)
    -- Shd Combo Points
    -- variable,name=shd_combo_points,value=combo_points.deficit>=2+buff.shadow_blades.up
    var.shdComboPoints = comboPointsDeficit >= 2 + var.shadowed
    -- variable,name=shd_combo_points,value=combo_points.deficit>=3,if=covenant.kyrian
    if covenant.kyrian.active then var.shdComboPoints = comboPointsDeficit >= 3 end
    -- variable,name=shd_combo_points,value=combo_points.deficit<=1,if=variable.use_priority_rotation&spell_targets.shuriken_storm>=4
    if var.usePriorityRotation and ui.useAOE(10,4) then var.shdComboPoints = comboPointsDeficit <= 1 end
    -- variable,name=shd_combo_points,value=combo_points.deficit<=1,if=spell_targets.shuriken_storm=4
    if #enemies.yards10 == 4 then var.shdComboPoints = comboPointsDeficit <= 1 end

    if not (not unit.exists("target") or not unit.isUnit("target",var.pickPocketUnit)) then
        br.unpickable = false
        var.pickPocketUnit = "player"
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or ui.mode.rotation==4 then
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
        ------------------------------
        --- Out of Combat Rotation ---
        ------------------------------
        if actionList.PreCombat() then return true end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if unit.inCombat() and not var.profileStop and unit.exists("target") then
            -- Stealth
            -- stealth
            if ui.checked("Stealth") and cast.able.stealth() and (not unit.resting() or unit.isDummy("target")) and not var.stealth then
                if ui.value("Stealth") == 1 and cast.able.stealth() then
                    if cast.stealth() then ui.debug("Casting Stealth") return true end
                end
                if var.autoStealth() and ui.value("Stealth") == 3 then
                    if cast.stealth() then ui.debug("Casting Stealth [Detected Enemy Nearby]") return true end
                end
            end
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return true end
            ----------------------------------
            --- In Combat - Begin Rotation ---
            ----------------------------------
            -- Shadowstep
            if ui.checked("Shadowstep") and cast.able.shadowstep("target") and cast.able.shadowstep()
                and unit.distance("target") >= 8 and cast.timeSinceLast.shadowstrike() > unit.gcd(true)
            then
                if cast.shadowstep("target") then ui.debug("Casting Shadowstep") return true end
            end
            -- Auto Attack
            -- auto_attack
            if cast.able.autoAttack() and unit.distance("target") < 5 and not (cast.last.vanish() or cast.last.vanish() or cast.last.shadowmeld())
                and (not buff.stealth.exists() or not buff.vanish.exists() or not buff.shadowmeld.exists())
            then
                if cast.autoAttack("target") then ui.debug("Casting Auto Attack") return true end
            end
            -- Action List - Cooldowns
            -- call_action_list,name=cds
            if actionList.Cooldowns() then return true end
            -- Slice and Dice
            -- slice_and_dice,if=spell_targets.shuriken_storm<6&fight_remains>6&buff.slice_and_dice.remains<gcd.max&combo_points>=4-(time<10)*2
            if cast.able.sliceAndDice() and ui.useST(10, 6) and unit.ttdGroup(5) > 6
                and buff.sliceAndDice.remain() < unit.gcd(true) and comboPoints >= 4 - (var.combatStart) * 2
            then
                if cast.sliceAndDice() then ui.debug("Casting Slice and Dice") return true end
            end
            -- Action List - Stealthed
            -- run_action_list,name=stealthed,if=stealthed.all
            if var.stealthAll then
                if actionList.Stealthed() then return true end
            end
            -- Action List - Stealth Cooldowns
            -- call_action_list,name=stealth_cds,if=variable.use_priority_rotation
            if var.usePriorityRotation then
                if actionList.StealthCooldowns() then return true end
            end
            -- call_action_list,name=stealth_cds,if=energy.deficit<=variable.stealth_threshold
            if energyDeficit <= var.stealthThreshold then
                if actionList.StealthCooldowns() then return true end
            end
            -- Action List - Finish
            -- call_action_list,name=finish,if=variable.effective_combo_points>=cp_max_spend
            if var.effectiveComboPoints >= var.cpMaxSpend then
                if actionList.Finish() then return true end
            end
            -- call_action_list,name=finish,if=combo_points.deficit<=1|fight_remains<=1&variable.effective_combo_points>=3|buff.symbols_of_death_autocrit.up&variable.effective_combo_points>=4
            if comboPointsDeficit <= 1 or (unit.ttdGroup(5) <= 1 and var.effectiveComboPoints >= 3) or (buff.symbolsOfDeathCrit.exists() and var.effectiveComboPoints >= 4) then
                if actionList.Finish() then return true end
            end
            -- call_action_list,name=finish,if=spell_targets.shuriken_storm>=4&variable.effective_combo_points>=4
            if ui.useAOE(10,4) and var.effectiveComboPoints >= 4 then
                if actionList.Finish() then return true end
            end
            -- Action List - Build
            -- call_action_list,name=build,if=energy.deficit<=variable.stealth_threshold
            if energyDeficit <= var.stealthThreshold then
                if actionList.Build() then return true end
            end
            -- Racials
            -- arcane_torrent,if=energy.deficit>=15+energy.regen
            -- arcane_pulse
            -- lights_judgment
            if ui.useCDs() and ui.checked("Racial") and cast.able.racial() and not buff.shadowDance.exists()
                and ((race == "BloodElf" and energyDeficit >= 15 + energyRegen) or race == "Nightborne" or race == "LightforgedDraenei")
            then
                if race == "LightforgedDraenei" then
                    if cast.racial("target","ground") then ui.debug("Casting Racial") return true end
                else
                    if cast.racial("player") then ui.debug("Casting Racial") return true end
                end
            end
            -- Shuriken Toss
            if ui.checked("Shuriken Toss OOR") and energy >= ui.value("Shuriken Toss OOR") and cast.able.shurikenToss()
                and (charges.shadowstep.count() == 0 or not ui.checked("Shadowstep")) and unit.distance(units.dyn30) > 5 and not var.stealthAll
            then
                if cast.shurikenToss() then ui.debug("Casting Shuriken Toss [Out of Melee]") return true end
            end
        end -- End In Combat
    end -- End Profile
end -- runRotation
local id = 261
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

-------------------------------------------------------
-- Author = CuteOne
-- Patch = 10.2
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
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spells.shurikenStorm },
        [2] = { mode = "Mult", value = 2, overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spells.shurikenStorm },
        [3] = { mode = "Sing", value = 3, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spells.backstab },
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.crimsonVial }
    }
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.shadowBlades },
        [2] = { mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spells.shadowBlades },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.shadowBlades }
    }
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.evasion },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.evasion }
    }
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spells.kick },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.kick }
    }
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
    -- Shadow Dance Button
    ShadowDanceModes = {
        [1] = { mode = "On", value = 1, overlay = "Shadow Dance Enabled", tip = "Rotation will use Shadow Dance.", highlight = 1, icon = br.player.spells.shadowDance },
        [2] = { mode = "Off", value = 2, overlay = "Shadow Dance Disabled", tip = "Rotation will not use Shadow Dance. Useful for pooling SD charges as you near dungeon bosses.", highlight = 0, icon = br.player.spells.shadowDance },
    }
    br.ui:createToggle(ShadowDanceModes, "ShadowDance", 5, 0)
    -- Pick Pocket Button
    PickPocketModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Auto Pick Pocket Enabled", tip = "Profile will attempt to Pick Pocket prior to combat.", highlight = 1, icon = br.player.spells.pickPocket },
        [2] = { mode = "Only", value = 2, overlay = "Only Pick Pocket Enabled", tip = "Profile will attempt to Sap and only Pick Pocket, no combat.", highlight = 0, icon = br.player.spells.pickPocket },
        [3] = { mode = "Off", value = 3, overlay = "Pick Pocket Disabled", tip = "Profile will not use Pick Pocket.", highlight = 0, icon = br.player.spells.pickPocket }
    }
    br.ui:createToggle(PickPocketModes, "PickPocket", 6, 0)
end

---------------
--- OPTIONS ---
---------------
local createOptions = function()
    local optionTable

    local rotationOptions = function()
        local section
        local alwaysCdNever = { "Always", "|cff0000ffCD", "|cffff0000Never" }
        local alwaysCdAoENever = { "Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never" }
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- Poison
        br.ui:createDropdownWithout(section, "Lethal Poison", { "Instant", "Wound", "None" }, 1, "Lethal Poison to Apply")
        br.ui:createDropdownWithout(section, "Non-Lethal Poison", { "Crippling", "Numbing", "None" }, 1,
            "Non-Lethal Poison to Apply")
        -- Priority Rotation
        br.ui:createCheckbox(section, "Priority Rotation")
        -- Stealth
        br.ui:createDropdown(section, "Stealth", { "|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards" }, 1,
            "Stealthing method.")
        -- Stealth Breaker
        br.ui:createDropdownWithout(section, "Stealth Breaker",
            { "|cff00FF00Shadowstrike", "|cffFFFF00Cheapshot", "|cffFF0000Sinister Strike" }, 3,
            "|cffFFFFFFSet what to break Stealth with.")
        -- Shadowstep
        br.ui:createCheckbox(section, "Shadowstep")
        -- Shadowstrike
        br.ui:createSpinnerWithout(section, "SS Range", 5, 5, 25, 5, "|cffFFBB00Shadow Strike range, 5 = Melee")
        -- Shuriken Toss OOR
        br.ui:createSpinner(section, "Shuriken Toss OOR", 85, 5, 100, 5,
            "|cffFFBB00Check to use Shuriken Toss out of range and energy to use at.")
        -- Tricks of the Trade
        br.ui:createCheckbox(section, "Tricks of the Trade on Focus")
        -- Pre-Pull
        br.ui:createCheckbox(section, "Pre-Pull", "|cffFFFFFFSet to use Pre-Pull (DBM Required).")
        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5,
            "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Cold Blood
        br.ui:createDropdownWithout(section, "Cold Blood", alwaysCdNever, 2, "|cffFFFFFFWhen to use Cold Blood.")
        -- Echoing Reprimand
        br.ui:createDropdownWithout(section, "Echoing Reprimand", alwaysCdNever, 2,
            "|cffFFFFFFWhen to use Echoing Reprimand")
        -- Flagellation
        br.ui:createDropdownWithout(section, "Flagellation", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Flagellation")
        -- Racial
        br.ui:createCheckbox(section, "Racial")
        -- Secret Technique
        br.ui:createDropdownWithout(section, "Secret Technique", alwaysCdAoENever, 3,
            "|cffFFFFFFWhen to use Secret Technique.")
        -- Sepsis
        br.ui:createDropdownWithout(section, "Sepsis", alwaysCdNever, 2, "|cffFFFFFFWhen to use Sepsis.")
        -- Shadow Blades
        br.ui:createDropdownWithout(section, "Shadow Blades", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Shadow Blades.")
        -- Shadow Dance
        br.ui:createDropdownWithout(section, "Shadow Dance", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Shadow Dance.")
        -- Shuriken Tornado
        br.ui:createDropdownWithout(section, "Shuriken Tornado", alwaysCdAoENever, 3,
            "|cffFFFFFFWhen to use Shuriken Tornado.")
        -- Symbols of Death
        br.ui:createDropdownWithout(section, "Symbols of Death", alwaysCdNever, 2,
            "|cffFFFFFFWhen to use Symbols of Death")
        -- Thistle Tea
        br.ui:createDropdownWithout(section, "Thistle Tea", alwaysCdNever, 2, "|cffFFFFFFWhen to use Thistle Tea")
        -- Trinkets
        br.player.module.BasicTrinkets(section)
        -- Vanish
        br.ui:createCheckbox(section, "Vanish")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Cloak of Shadows
        br.ui:createCheckbox(section, "Cloak of Shadows")
        -- Crimson Vial
        br.ui:createSpinner(section, "Crimson Vial", 80, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Evasion
        br.ui:createSpinner(section, "Evasion", 40, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Feint
        br.ui:createSpinner(section, "Feint", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Kidney Shot
        br.ui:createSpinner(section, "Kidney Shot Defensive", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
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
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle, 4)
        --Cooldown Key Toggle
        br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle, 3)
        --Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle, 6)
        -- Interrupts Key Toggle
        br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
        -- Shadow Dance Toggle
        br.ui:createDropdownWithout(section, "ShadowDance Mode", br.dropOptions.Toggle, 6)
        -- Pick Pocket Toggle
        br.ui:createDropdownWithout(section, "PickPocket Mode", br.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)
    end
    optionTable = { {
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
local comboPoints
local debuff
local enemies
local energy
local equiped
local items
local module
local talent
local unit
local units
local ui
local use
local var = {}

-- General Locals
var.profileStop = false

-- Variables
var.pickPocketUnit = "player"
var.danseBackstab = false
var.danseBlackPowder = false
var.danseEviscerate = false
var.danseGloomblade = false
var.danseRupture = false
var.danseShadowstrike = false
var.danseShurikenStorm = false

-----------------
--- Functions ---
-----------------

var.isPicked = function(thisUnit) --  Pick Pocket Testing
    if thisUnit == nil then thisUnit = "target" end
    if (br.unpickable or unit.level() < 24
            or ui.mode.pickPocket == 3 or unit.isDummy(thisUnit) or (br._G.LootFrame:IsShown() and br._G.GetNumLootItems() == 0))
    then
        var.pickPocketUnit = thisUnit
        return true
    end
    return false
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
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing")) * 60) and unit.isDummy("target") then
                unit.stopAttack()
                unit.clearTarget()
                ui.chatOverlay(tonumber(ui.value("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end
    -- Tricks of the Trade
    if ui.checked("Tricks of the Trade on Focus") and cast.able.tricksOfTheTrade("focus") and unit.inCombat() and unit.exists("focus") and unit.friend("focus") then
        if cast.tricksOfTheTrade("focus") then
            ui.debug("Casting Tricks of the Trade")
            return true
        end
    end
end -- End Action List - Extras

-- Action List - Defensives
actionList.Defensive = function()
    if ui.useDefensive() and not var.stealthAll then
        -- Cloak of Shadows
        if ui.checked("Cloak of Shadows") and cast.able.cloakOfShadows() and cast.dispel.cloakOfShadows("player") then
            if cast.cloakOfShadows() then
                ui.debug("Casting Cloak of Shadows")
                return true
            end
        end
        -- Crimson Vial
        if ui.checked("Crimson Vial") and cast.able.crimsonVial() and unit.hp() < ui.value("Crimson Vial") and not buff.shadowDance.exists() then
            if cast.crimsonVial() then
                ui.debug("Casting Crimson Vial")
                return true
            end
        end
        -- Evasion
        if ui.checked("Evasion") and cast.able.evasion() and unit.hp() < ui.value("Evasion") and unit.inCombat() then
            if cast.evasion() then
                ui.debug("Casting Evasion")
                return true
            end
        end
        -- Feint
        if ui.checked("Feint") and unit.hp() <= ui.value("Feint") and unit.inCombat() and not buff.feint.exists() and not buff.shadowDance.exists() then
            if cast.feint() then
                ui.debug("Casting Feint")
                return true
            end
        end
        -- Kidney Shot
        if ui.checked("Kidney Shot Defensive") and unit.hp() <= ui.value("Kidney Shot Defensive") and unit.inCombat() and not buff.shadowDance.exists() then
            if cast.kidneyShot() then
                ui.debug("Casting Kidney Shot [Defensive]")
                return true
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() and not var.stealthAll then
        for i = 1, #enemies.yards20 do
            local thisUnit = enemies.yards20[i]
            local distance = unit.distance(thisUnit)
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                -- Kick
                -- kick
                if ui.checked("Kick") and cast.able.kick(thisUnit) and distance < 5 then
                    if cast.kick(thisUnit) then
                        ui.debug("Kick")
                        return true
                    end
                end
                -- Kidney Shot
                if ui.checked("Kidney Shot") and cast.able.kidneyShot(thisUnit) and cd.kick.remain() ~= 0 and cd.blind.remain() == 0 then
                    if cast.kidneyShot(thisUnit) then
                        ui.debug("Kidney Shot")
                        return true
                    end
                end
                -- Blind
                if ui.checked("Blind") and cast.able.blind(thisUnit) and not buff.shadowDance.exists()
                    and (cd.kick.remain() ~= 0 or distance >= 5) and not buff.shadowDance.exists()
                then
                    if cast.blind(thisUnit) then
                        ui.debug("Blind")
                        return true
                    end
                end
                -- Cheap Shot
                if ui.checked("Cheap Shot") and cast.able.cheapShot(thisUnit) and buff.shadowDance.exists() and distance < 5
                    and cd.kick.remain() ~= 0 and cd.kidneyShot.remain() == 0 and cd.blind.remain() == 0
                then
                    if cast.cheapShot(thisUnit) then
                        ui.debug("Cheap Shot")
                        return true
                    end
                end
            end
        end
    end -- End Interrupt and No Stealth Check
end     -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
        -- Remix - Oblivion Sphere
        if ui.useCDs() and cast.able.id(435313, "target", "ground", 1, 15) and not unit.moving("target") and not var.stealthAll then
            if cast.id(435313, "target", "ground", 1, 15) then
                ui.debug("Casting Oblivion Sphere [Cds]")
                return true
            end
        end
        -- Variable - Trinket Conditions
        -- variable,name=trinket_conditions,value=(!equipped.witherbarks_branch|equipped.witherbarks_branch&cooldown.witherbarks_branch.remains<=8|equipped.bandolier_of_twisted_blades|talent.invigorating_shadowdust)
        var.trinketConditions = ((not equiped.witherbarksBranch() or equiped.witherbarksBranch() and cd.witherbarksBranch.remains() <= 8
            or equiped.bandolierOfTwistedBlades() or talent.invigoratingShadowdust))
        -- Cold Blood
        -- cold_blood,if=!talent.secret_technique&combo_points>=5
        if ui.alwaysCdNever("Cold Blood") and cast.able.coldBlood() and not talent.secretTechnique and comboPoints() >= 5 then
            if cast.coldBlood() then
                ui.debug("Casting Cold Blood [Cds]")
                return true
            end
        end
        -- Sepsis
        -- sepsis,if=variable.snd_condition&target.time_to_die>=16&(buff.perforated_veins.up|!talent.perforated_veins)
        if ui.alwaysCdNever("Sepsis") and cast.able.sepsis()
            and ((var.sndCondition and unit.ttd(units.dyn5) >= 16 and (buff.perforatedVeins.exists() or not talent.perforatedVeins)))
        then
            if cast.sepsis() then
                ui.debug("Casting Sepsis [Cds]")
                return true
            end
        end
        -- Flagellation
        -- flagellation,target_if=max:target.time_to_die,if=variable.snd_condition&combo_points>=5&target.time_to_die>10&(variable.trinket_conditions&cooldown.shadow_blades.remains<=3|fight_remains<=28|cooldown.shadow_blades.remains>=14&talent.invigorating_shadowdust&talent.shadow_dance)&(!talent.invigorating_shadowdust|talent.sepsis|!talent.shadow_dance|talent.invigorating_shadowdust.rank=2&spell_targets.shuriken_storm>=2|cooldown.symbols_of_death.remains<=3|buff.symbols_of_death.remains>3)
        if ui.alwaysCdAoENever("Flagellation", 2, #enemies.yards10) and cast.able.flagellation(var.maxTTDUnit) and ((var.sndCondition and comboPoints() >= 5 and unit.ttd(units.dyn5) > 10
                and (var.trinketConditions and cd.shadowBlades.remains() <= 3 or unit.ttdGroup(40) <= 28 or cd.shadowBlades.remains() >= 14
                    and talent.invigoratingShadowdust and talent.shadowDance) and (not talent.invigoratingShadowdust
                    or talent.sepsis or not talent.shadowDance or talent.rank.invigoratingShadowdust == 2
                    and ui.useAOE(10, 2) or cd.symbolsOfDeath.remains() <= 3 or buff.symbolsOfDeath.remains() > 3)))
        then
            if cast.flagellation(var.maxTTDUnit) then
                ui.debug("Casting Flagellation [Cds]")
                return true
            end
        end
        -- Symbols of Death
        -- symbols_of_death,if=variable.snd_condition&(!buff.the_rotten.up|!set_bonus.tier30_2pc)&buff.symbols_of_death.remains<=3&(!talent.flagellation|cooldown.flagellation.remains>10|buff.shadow_dance.remains>=2&talent.invigorating_shadowdust|cooldown.flagellation.up&combo_points>=5&!talent.invigorating_shadowdust)
        if ui.alwaysCdNever("Symbols of Death") and cast.able.symbolsOfDeath("player") and ((var.sndCondition and (not buff.theRotten.exists() or not equiped.tier(30, 2))
                and buff.symbolsOfDeath.remains() <= 3 and (not talent.flagellation or cd.flagellation.remains() > 10 or buff.shadowDance.remains() >= 2
                    and talent.invigoratingShadowdust or not cd.flagellation.exists() and comboPoints() >= 5 and not talent.invigoratingShadowdust)))
        then
            if cast.symbolsOfDeath("player") then
                ui.debug("Casting Symbols Of Death [Cds]")
                return true
            end
        end
        -- Shadow Blades
        -- shadow_blades,if=variable.snd_condition&(combo_points<=1|set_bonus.tier31_4pc)&(buff.flagellation_buff.up|buff.flagellation_persist.up|!talent.flagellation)
        if ui.alwaysCdAoENever("Shadow Blades", 3, #enemies.yards10) and cast.able.shadowBlades() and ((var.sndCondition and (comboPoints() <= 1 or equiped.tier(31, 4))
                and (buff.flagellation.exists() or buff.flagellationPersist.exists() or not talent.flagellation)))
        then
            if cast.shadowBlades() then
                ui.debug("Casting Shadow Blades [Cds]")
                return true
            end
        end
        -- Echoing Reprimand
        -- echoing_reprimand,if=variable.snd_condition&combo_points.deficit>=3
        if ui.alwaysCdNever("Echoing Reprimand") and cast.able.echoingReprimand() and var.sndCondition and comboPoints.deficit() >= 3 then
            if cast.echoingReprimand() then
                ui.debug("Casting Echoing Reprimand [Cds]")
                return true
            end
        end
        -- Shuriken Tornado
        -- shuriken_tornado,if=variable.snd_condition&buff.symbols_of_death.up&combo_points<=2&!buff.premeditation.up&(!talent.flagellation|cooldown.flagellation.remains>20)&spell_targets.shuriken_storm>=3
        if ui.alwaysCdAoENever("Shuriken Tornado", 3, #enemies.yards10) and cast.able.shurikenTornado("player", "aoe", 1, 10)
            and ((var.sndCondition and buff.symbolsOfDeath.exists() and comboPoints() <= 2 and not buff.premeditation.exists()
                and (not talent.flagellation or cd.flagellation.remains() > 20) and ui.useAOE(10, 3)))
        then
            if cast.shurikenTornado("player", "aoe", 1, 10) then
                ui.debug("Casting Shuriken Tornado - Low Combo [Cds]")
                return true
            end
        end
        -- shuriken_tornado,if=variable.snd_condition&!buff.shadow_dance.up&!buff.flagellation_buff.up&!buff.flagellation_persist.up&!buff.shadow_blades.up&spell_targets.shuriken_storm<=2&!raid_event.adds.up
        if ui.alwaysCdAoENever("Shuriken Tornado", 3, #enemies.yards10) and cast.able.shurikenTornado("player", "aoe", 1, 10) and var.sndCondition and not buff.shadowDance.exists()
            and not buff.flagellation.exists() and not buff.flagellationPersist.exists() and not buff.shadowBlades.exists() and ui.useST(10, 3)
        then
            if cast.shurikenTornado("player", "aoe", 1, 10) then
                ui.debug("Casting Shuriken Tornado [Cds]")
                return true
            end
        end
        -- Shadow Dance
        -- shadow_dance,if=!buff.shadow_dance.up&fight_remains<=8+talent.subterfuge.enabled
        if ui.mode.shadowDance == 1 and ui.alwaysCdAoENever("Shadow Dance", 3, #enemies.yards10) and cast.able.shadowDance()
            and not buff.shadowDance.exists() and unit.ttdGroup(40) <= 8 + var.subterfuge
        then
            if cast.shadowDance() then
                ui.debug("Casting Shadow Dance [Cds]")
                return true
            end
        end
        -- Goremaws Bite
        -- goremaws_bite,if=variable.snd_condition&combo_points.deficit>=3&(!cooldown.shadow_dance.up|talent.shadow_dance&buff.shadow_dance.up&!talent.invigorating_shadowdust|spell_targets.shuriken_storm<4&!talent.invigorating_shadowdust|talent.the_rotten|raid_event.adds.up)
        if ui.alwaysCdNever("Echoing Reprimand") and cast.able.goremawsBite() and ((var.sndCondition and comboPoints.deficit() >= 3
                and (not not cd.shadowDance.exists() or talent.shadowDance and buff.shadowDance.exists() and not talent.invigoratingShadowdust or ui.useST(10, 4)
                    and not talent.invigoratingShadowdust or talent.theRotten)))
        then
            if cast.goremawsBite() then
                ui.debug("Casting Goremaws Bite [Cds]")
                return true
            end
        end
        -- Thistle Tea
        -- thistle_tea,if=!buff.thistle_tea.up&cooldown.thistle_tea.charges_fractional>=2.5&buff.shadow_dance.remains>=4
        if ui.alwaysCdNever("Thistle Tea") and cast.able.thistleTea() and not buff.thistleTea.exists()
            and charges.thistleTea.frac() >= 2.5 and buff.shadowDance.remains() >= 4
        then
            if cast.thistleTea() then
                ui.debug("Casting Thistle Tea - Near Cap [Cds]")
                return true
            end
        end
        -- Thistle Tea
        -- thistle_tea,if=!buff.thistle_tea.up&buff.shadow_dance.remains>=4&cooldown.secret_technique.remains<=10
        if ui.alwaysCdNever("Thistle Tea") and cast.able.thistleTea() and not buff.thistleTea.exists() and buff.shadowDance.remains() >= 4 and talent.secretTechnique and cd.secretTechnique.remains() <= 10 then
            if cast.thistleTea() then
                ui.debug("Casting Thistle Tea - Secret Technique Ends Soon [Cds]")
                return true
            end
        end
        -- Thistle Tea
        -- thistle_tea,if=!buff.thistle_tea.up&(energy.deficit>=(100)|!buff.thistle_tea.up&fight_remains<=(6*cooldown.thistle_tea.charges))&(cooldown.symbols_of_death.remains>=3|buff.symbols_of_death.up)&combo_points.deficit>=2
        if ui.alwaysCdNever("Thistle Tea") and cast.able.thistleTea() and ((not buff.thistleTea.exists() and (energy.deficit() >= (100) or not buff.thistleTea.exists()
                and unit.ttdGroup(40) <= (6 * charges.thistleTea.count())) and (cd.symbolsOfDeath.remains() >= 3
                or buff.symbolsOfDeath.exists()) and comboPoints.deficit() >= 2))
        then
            if cast.thistleTea() then
                ui.debug("Casting Thistle Tea [Cds]")
                return true
            end
        end
        -- Module - Combatpotion Up
        -- potion,if=buff.bloodlust.react|fight_remains<30|buff.symbols_of_death.up&(buff.shadow_blades.up|cooldown.shadow_blades.remains<=10)
        if buff.bloodLust.exists() or unit.ttdGroup(40) < 30 or buff.symbolsOfDeath.exists() and (buff.shadowBlades.exists() or cd.shadowBlades.remains() <= 10) then
            module.CombatPotionUp()
        end
        -- Variable - Racial Sync
        -- variable,name=racial_sync,value=buff.shadow_blades.up|!talent.shadow_blades&buff.symbols_of_death.up|fight_remains<20
        var.racialSync = (buff.shadowBlades.exists() or not talent.shadowBlades and buff.symbolsOfDeath.exists() or unit.ttdGroup(40) < 20)
        -- Racial
        -- blood_fury,if=variable.racial_sync
        -- berserking,if=variable.racial_sync
        -- fireblood,if=variable.racial_sync
        -- ancestral_call,if=variable.racial_sync
        if ui.checked("Racial") and ui.useCDs() and cast.able.racial() and (var.racialSync
                and (unit.race() == "Orc" or unit.race() == "Troll" or unit.race() == "DarkIronDwarf" or unit.race() == "MagharOrc"))
        then
            if cast.racial() then
                ui.debug("Casting Racial [Cds]")
                return true
            end
        end
        -- Use Item - Irideus Fragment
        -- use_item,name=irideus_fragment,if=(buff.cold_blood.up|(!talent.danse_macabre&buff.shadow_dance.up|buff.danse_macabre.stack>=3)&!talent.cold_blood)|fight_remains<10
        if ui.useTrinkets(items.irideusFragment) and use.able.irideusFragment() and (((buff.coldBlood.exists()
                or (not talent.danseMacabre and buff.shadowDance.exists() or buff.danseMacabre.stack() >= 3)
                and not talent.coldBlood) or unit.ttdGroup(40) < 10))
        then
            if use.irideusFragment() then
                ui.debug("Using Irideus Fragment [Cds]")
                return true
            end
        end

        -- Use Item - Ashes Of The Embersoul
        -- use_item,name=ashes_of_the_embersoul,if=(buff.cold_blood.up|(!talent.danse_macabre&buff.shadow_dance.up|buff.danse_macabre.stack>=3)&!talent.cold_blood)|fight_remains<10
        if ui.useTrinkets(items.ashesOfTheEmbersoul) and use.able.ashesOfTheEmbersoul() and (((buff.coldBlood.exists()
                or (not talent.danseMacabre and buff.shadowDance.exists() or buff.danseMacabre.stack() >= 3)
                and not talent.coldBlood) or unit.ttdGroup(40) < 10))
        then
            if use.ashesOfTheEmbersoul() then
                ui.debug("Using Ashes Of The Embersoul [Cds]")
                return true
            end
        end

        -- Use Item - Witherbarks Branch
        -- use_item,name=witherbarks_branch,if=buff.flagellation_buff.up&talent.invigorating_shadowdust|buff.shadow_blades.up|equipped.bandolier_of_twisted_blades&raid_event.adds.up
        if ui.useTrinkets(items.witherbarksBranch) and use.able.witherbarksBranch() and ((buff.flagellation.exists()
                and talent.invigoratingShadowdust or buff.shadowBlades.exists() or equiped.bandolierOfTwistedBlades()))
        then
            if use.witherbarksBranch() then
                ui.debug("Using Witherbarks Branch [Cds]")
                return true
            end
        end

        -- Use Item - Mirror Of Fractured Tomorrows
        -- use_item,name=mirror_of_fractured_tomorrows,if=buff.shadow_dance.up&(target.time_to_die>=15|equipped.ashes_of_the_embersoul)
        if ui.useTrinkets(items.mirrorOfFracturedTomorrows) and use.able.mirrorOfFracturedTomorrows() and ((buff.shadowDance.exists()
                and (unit.ttd(units.dyn5) >= 15 or equiped.ashesOfTheEmbersoul())))
        then
            if use.mirrorOfFracturedTomorrows() then
                ui.debug("Using Mirror Of Fractured Tomorrows [Cds]")
                return true
            end
        end

        -- Use Item - Beacon To The Beyond
        -- use_item,name=beacon_to_the_beyond,if=!stealthed.all&(buff.deeper_daggers.up|!talent.deeper_daggers)&(!raid_event.adds.up|!equipped.stormeaters_boon|cooldown.stormeaters_boon.remains>20)
        if ui.useTrinkets(items.beaconToTheBeyond) and use.able.beaconToTheBeyond() and ((not var.stealthAll
                and (buff.deeperDaggers.exists() or not talent.deeperDaggers) and (not equiped.stormeatersBoon() or cd.stormeatersBoon.remains() > 20)))
        then
            if use.beaconToTheBeyond() then
                ui.debug("Using Beacon To The Beyond [Cds]")
                return true
            end
        end

        -- Use Item - Manic Grieftorch
        -- use_item,name=manic_grieftorch,if=!buff.shadow_blades.up&!buff.shadow_dance.up&(!cooldown.mirror_of_fractured_tomorrows.ready|!equipped.mirror_of_fractured_tomorrows)&(!cooldown.ashes_of_the_embersoul.ready|!equipped.ashes_of_the_embersoul)&(!cooldown.irideus_fragment.ready|!equipped.irideus_fragment)|fight_remains<10
        if ui.useTrinkets(items.manicGrieftorch) and use.able.manicGrieftorch() and ((not buff.shadowBlades.exists()
                and not buff.shadowDance.exists() and (not not cd.mirrorOfFracturedTomorrows.exists() or not equiped.mirrorOfFracturedTomorrows())
                and (not not cd.ashesOfTheEmbersoul.exists() or not equiped.ashesOfTheEmbersoul()) and (not not cd.irideusFragment.exists()
                    or not equiped.irideusFragment()) or unit.ttdGroup(40) < 10))
        then
            if use.manicGrieftorch() then
                ui.debug("Using Manic Grieftorch [Cds]")
                return true
            end
        end


        -- Use Item - Use Items
        -- use_items,if=!stealthed.all&(!cooldown.mirror_of_fractured_tomorrows.ready|!equipped.mirror_of_fractured_tomorrows)&(!cooldown.ashes_of_the_embersoul.ready|!equipped.ashes_of_the_embersoul)|fight_remains<10
        if ((not var.stealthAll and (not not cd.mirrorOfFracturedTomorrows.exists() or not equiped.mirrorOfFracturedTomorrows())
                and (not not cd.ashesOfTheEmbersoul.exists() or not equiped.ashesOfTheEmbersoul()) or unit.ttdGroup(40) < 10))
        then
            module.BasicTrinkets()
        end
    end
end -- End Action List - Cooldowns

-- Action List - Stealth Cooldowns
actionList.StealthCooldowns = function()
    -- Variable - Shd Threshold
    -- variable,name=shd_threshold,value=cooldown.shadow_dance.charges_fractional>=0.75+talent.shadow_dance
    var.shdThreshold = charges.shadowDance.frac() >= 0.75 + var.shadowDance
    -- Variable - Rotten Cb
    -- variable,name=rotten_cb,value=(!buff.the_rotten.up|!set_bonus.tier30_2pc)&(!talent.cold_blood|cooldown.cold_blood.remains<4|cooldown.cold_blood.remains>10)
    var.rottenCb = ((not buff.theRotten.exists() or not equiped.tier(30, 2)) and (not talent.coldBlood or cd.coldBlood.remains() < 4 or cd.coldBlood.remains() > 10))
    if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
        -- Vanish
        -- vanish,if=(combo_points.deficit>1|buff.shadow_blades.up&talent.invigorating_shadowdust)&!variable.shd_threshold&(cooldown.flagellation.remains>=60|!talent.flagellation|fight_remains<=(30*cooldown.vanish.charges))&(cooldown.symbols_of_death.remains>3|!set_bonus.tier30_2pc)&(cooldown.secret_technique.remains>=10|!talent.secret_technique|cooldown.vanish.charges>=2&talent.invigorating_shadowdust&(buff.the_rotten.up|!talent.the_rotten)&!raid_event.adds.up)
        if ui.checked("Vanish") and ui.useCDs() and cast.able.vanish() and (((comboPoints.deficit() > 1 or buff.shadowBlades.exists()
                    and talent.invigoratingShadowdust) and not var.shdThreshold and (cd.flagellation.remains() >= 60 or not talent.flagellation
                    or unit.ttdGroup(40) <= (30 * charges.vanish.count())) and (cd.symbolsOfDeath.remains() > 3 or not equiped.tier(30, 2))
                and (cd.secretTechnique.remains() >= 10 or not talent.secretTechnique or charges.vanish.count() >= 2 and talent.invigoratingShadowdust
                    and (buff.theRotten.exists() or not talent.theRotten))))
        then
            if cast.vanish() then
                ui.debug("Casting Vanish [Stealth Cds]")
                return true
            end
        end
        -- Shadowmeld
        -- shadowmeld,if=energy>=40&energy.deficit>=10&!variable.shd_threshold&combo_points.deficit>4
        if ui.checked("Racial") and ui.useCDs() and cast.able.racial() and unit.race() == "NightElf"
            and energy() >= 40 and energy.deficit() >= 10 and not var.shdThreshold and comboPoints.deficit() > 4
        then
            if cast.racial() then
                ui.debug("Casting Shadowmeld [Stealth Cds]")
                return true
            end
        end
    end
    -- Variable - Shd Combo Points
    -- variable,name=shd_combo_points,value=combo_points.deficit>=3
    var.shdComboPoints = comboPoints.deficit() >= 3
    if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
        -- Shadow Dance
        -- shadow_dance,if=(dot.rupture.ticking|talent.invigorating_shadowdust)&variable.rotten_cb&(!talent.the_first_dance|combo_points.deficit>=4|buff.shadow_blades.up)&(variable.shd_combo_points&variable.shd_threshold|(buff.shadow_blades.up|cooldown.symbols_of_death.up&!talent.sepsis|buff.symbols_of_death.remains>=4&!set_bonus.tier30_2pc|!buff.symbols_of_death.remains&set_bonus.tier30_2pc)&cooldown.secret_technique.remains<10+12*(!talent.invigorating_shadowdust|set_bonus.tier30_2pc))
        if ui.mode.shadowDance == 1 and ui.alwaysCdAoENever("Shadow Dance", 3, #enemies.yards10) and cast.able.shadowDance()
            and (((debuff.rupture.exists(units.dyn5) or talent.invigoratingShadowdust) and var.rottenCb
                and (not talent.theFirstDance or comboPoints.deficit() >= 4 or buff.shadowBlades.exists())
                and (var.shdComboPoints and var.shdThreshold or (buff.shadowBlades.exists() or not cd.symbolsOfDeath.exists()
                    and not talent.sepsis or buff.symbolsOfDeath.remains() >= 4 and not equiped.tier(30, 2) or not buff.symbolsOfDeath.remains()
                    and equiped.tier(30, 2)) and cd.secretTechnique.remains() < 10 + 12 * var.invigoratingTier)))
        then
            if cast.shadowDance() then
                ui.debug("Casting Shadow Dance [Stealth Cds]")
                return true
            end
        end
    end
end -- End Action List - Stealth Cooldowns

-- Action List - Stealthed
actionList.Stealthed = function()
    -- Shadowstrike
    -- shadowstrike,if=buff.stealth.up&(spell_targets.shuriken_storm<4|variable.priority_rotation)
    if cast.able.shadowstrike("target", nil, 1, ui.value("SS Range")) and ((buff.stealth.exists() and (ui.useST(10, 4) or var.priorityRotation))) then
        if cast.shadowstrike("target", nil, 1, ui.value("SS Range")) then
            ui.debug("Casting Shadowstrike [Stealthed]")
            return true
        end
    end
    -- Call Action List - Finish
    -- call_action_list,name=finish,if=effective_combo_points>=var.cpMaxSpend
    if var.effectiveComboPoints >= var.cpMaxSpend then
        if actionList.Finish() then return true end
    end
    -- Call Action List - Finish
    -- call_action_list,name=finish,if=buff.shuriken_tornado.up&combo_points.deficit<=2
    if buff.shurikenTornado.exists() and comboPoints.deficit() <= 2 then
        if actionList.Finish() then return true end
    end
    -- Call Action List - Finish
    -- call_action_list,name=finish,if=combo_points.deficit<=1+(talent.deeper_stratagem|talent.secret_stratagem)
    if (comboPoints.deficit() <= 1 + var.deepSecrets) then
        if actionList.Finish() then return true end
    end
    -- Backstab
    -- backstab,if=!buff.premeditation.up&buff.shadow_dance.remains>=3&buff.shadow_blades.up&!used_for_danse&talent.danse_macabre&spell_targets.shuriken_storm<=3&!buff.the_rotten.up
    if cast.able.backstab() and not buff.premeditation.exists() and buff.shadowDance.remains() >= 3
        and buff.shadowBlades.exists() and not var.danseBackstab and talent.danseMacabre and ui.useST(10, 4) and not buff.theRotten.exists()
    then
        if cast.backstab() then
            ui.debug("Casting Backstab [Stealthed]")
            return true
        end
    end
    -- Gloomblade
    -- gloomblade,if=!buff.premeditation.up&buff.shadow_dance.remains>=3&buff.shadow_blades.up&!used_for_danse&talent.danse_macabre&spell_targets.shuriken_storm<=4
    if cast.able.gloomblade() and not buff.premeditation.exists() and buff.shadowDance.remains() >= 3 and buff.shadowBlades.exists()
        and not var.danseGloomblade and talent.danseMacabre and ui.useST(10, 5)
    then
        if cast.gloomblade() then
            ui.debug("Casting Gloomblade [Stealthed]")
            return true
        end
    end
    -- Shadowstrike
    -- shadowstrike,if=!used_for_danse&buff.shadow_blades.up
    if cast.able.shadowstrike("target", nil, 1, ui.value("SS Range")) and not var.danseShadowstrike and buff.shadowBlades.exists() then
        if cast.shadowstrike("target", nil, 1, ui.value("SS Range")) then
            ui.debug("Casting Shadowstrike - Shadow Blades [Stealthed]")
            return true
        end
    end
    -- Shuriken Storm
    -- shuriken_storm,if=!buff.premeditation.up&spell_targets>=4
    if cast.able.shurikenStorm("player", "aoe", 1, 8) and cast.able.shurikenStorm() and not buff.premeditation.exists() and ui.useAOE(10, 4) then
        if cast.shurikenStorm() then
            ui.debug("Casting Shuriken Storm [Stealthed]")
            return true
        end
    end
    -- Shadowstrike
    -- shadowstrike
    if cast.able.shadowstrike("target", nil, 1, ui.value("SS Range")) then
        if cast.shadowstrike("target", nil, 1, ui.value("SS Range")) then
            ui.debug("Casting Shadowstrike - Just Strike [Stealthed]")
            return true
        end
    end
end -- End Action List - Stealthed

-- Action List - Finish
actionList.Finish = function()
    -- Rupture
    -- rupture,if=!dot.rupture.ticking&target.time_to_die-remains>6
    if cast.able.rupture() and not debuff.rupture.exists(units.dyn5) and unit.ttd(units.dyn5) - debuff.rupture.remain(units.dyn5) > 6 then
        if cast.rupture() then
            ui.debug("Casting Rupture [Finish]")
            return true
        end
    end
    -- Variable - Premed Snd Condition
    -- variable,name=premed_snd_condition,value=talent.premeditation.enabled&spell_targets.shuriken_storm<5
    var.premedSndCondition = talent.premeditation and ui.useST(10, 5)
    -- Slice And Dice
    -- slice_and_dice,if=!stealthed.all&!variable.premed_snd_condition&spell_targets.shuriken_storm<6&!buff.shadow_dance.up&buff.slice_and_dice.remains<fight_remains&refreshable
    if cast.able.sliceAndDice() and not var.stealthAll and not var.premedSndCondition and ui.useST(10, 6)
        and not buff.shadowDance.exists() and buff.sliceAndDice.remains() < unit.ttdGroup(40) and buff.sliceAndDice.refresh()
    then
        if cast.sliceAndDice() then
            ui.debug("Casting Slice And Dice [Finish]")
            return true
        end
    end
    -- Variable - Skip Rupture
    -- variable,name=skip_rupture,value=buff.thistle_tea.up&spell_targets.shuriken_storm=1|buff.shadow_dance.up&(spell_targets.shuriken_storm=1|dot.rupture.ticking&spell_targets.shuriken_storm>=2)
    var.skipRupture = (buff.thistleTea.exists() and ui.useST(10, 2) or buff.shadowDance.exists() and (ui.useST(10, 2) or debuff.rupture.exists(units.dyn5) and ui.useAOE(10, 2)))
    -- Rupture
    -- rupture,if=(!variable.skip_rupture|variable.priority_rotation)&target.time_to_die-remains>6&refreshable
    if cast.able.rupture() and (((not var.skipRupture or var.priorityRotation)
            and unit.ttd(units.dyn5) - debuff.rupture.remain(units.dyn5) > 6 and debuff.rupture.refresh(units.dyn5)))
    then
        if cast.rupture() then
            ui.debug("Casting Rupture - Refresh [Finish]")
            return true
        end
    end
    -- Rupture
    -- rupture,if=buff.finality_rupture.up&buff.shadow_dance.up&spell_targets.shuriken_storm<=4&!action.rupture.used_for_danse
    if cast.able.rupture() and buff.finalityRupture.exists() and buff.shadowDance.exists() and ui.useST(10, 4) and not var.danseRupture then
        if cast.rupture() then
            ui.debug("Casting Rupture - Finality [Finish]")
            return true
        end
    end
    -- Cold Blood
    -- cold_blood,if=variable.secret_condition&cooldown.secret_technique.ready
    if ui.alwaysCdNever("Cold Blood") and cast.able.coldBlood() and (var.secretCondition or not ui.alwaysCdAoENever("Shadow Dance", 3, #enemies.yards10))
        and not cd.secretTechnique.exists()
    then
        if cast.coldBlood() then
            ui.debug("Casting Cold Blood [Finish]")
            return true
        end
    end
    -- Secret Technique
    -- secret_technique,if=variable.secret_condition&(!talent.cold_blood|cooldown.cold_blood.remains>buff.shadow_dance.remains-2|!talent.improved_shadow_dance)
    if ui.alwaysCdAoENever("Secret Technique", 3, #enemies.yards10) and cast.able.secretTechnique()
        and (((var.secretCondition or not ui.alwaysCdAoENever("Shadow Dance", 3, #enemies.yards10)) and (not talent.coldBlood
            or cd.coldBlood.remains() > buff.shadowDance.remains() - 2 or not talent.improvedShadowDance)))
    then
        if cast.secretTechnique() then
            ui.debug("Casting Secret Technique [Finish]")
            return true
        end
    end
    -- Rupture
    -- rupture,cycle_targets=1,if=!variable.skip_rupture&!variable.priority_rotation&spell_targets.shuriken_storm>=2&target.time_to_die>=(2*combo_points)&refreshable
    if cast.able.rupture() and not var.skipRupture and not var.priorityRotation and ui.useAOE(10, 2)
        and unit.ttd(units.dyn5) >= (2 * comboPoints()) and debuff.rupture.refresh(units.dyn5)
    then
        if cast.rupture() then
            ui.debug("Casting Rupture - AOE [Finish]")
            return true
        end
    end
    -- Rupture
    -- rupture,if=!variable.skip_rupture&remains<cooldown.symbols_of_death.remains+10&cooldown.symbols_of_death.remains<=5&target.time_to_die-remains>cooldown.symbols_of_death.remains+5
    if cast.able.rupture() and not var.skipRupture and debuff.rupture.remain(units.dyn5) < cd.symbolsOfDeath.remains() + 10
        and cd.symbolsOfDeath.remains() <= 5 and unit.ttd(units.dyn5) - debuff.rupture.remain(units.dyn5) > cd.symbolsOfDeath.remains() + 5
    then
        if cast.rupture() then
            ui.debug("Casting Rupture - Symbols of Death Soon [Finish]")
            return true
        end
    end
    -- Black Powder
    -- black_powder,if=!variable.priority_rotation&spell_targets>=3
    if cast.able.blackPowder() and not var.priorityRotation and ui.useAOE(10, 3) then
        if cast.blackPowder() then
            ui.debug("Casting Black Powder [Finish]")
            return true
        end
    end
    -- Eviscerate
    -- eviscerate
    if cast.able.eviscerate() then
        if cast.eviscerate() then
            ui.debug("Casting Eviscerate [Finish]")
            return true
        end
    end
end -- End Action List - Finish

-- Action List - Build
actionList.Build = function()
    -- Shuriken Storm
    -- shuriken_storm,if=spell_targets>=2+(talent.gloomblade&buff.lingering_shadow.remains>=6|buff.perforated_veins.up)
    if cast.able.shurikenStorm("player", "aoe", 1, 10) and (ui.useAOE(10, 2 + var.gloomShadowVeins)) then
        if cast.shurikenStorm("player", "aoe", 1, 10) then
            ui.debug("Casting Shuriken Storm [Build]")
            return true
        end
    end
    -- Gloomblade
    -- gloomblade
    if cast.able.gloomblade() then
        if cast.gloomblade() then
            ui.debug("Casting Gloomblade [Build]")
            return true
        end
    end
    -- Backstab
    -- backstab
    if cast.able.backstab() then
        if cast.backstab() then
            ui.debug("Casting Backstab [Build]")
            return true
        end
    end
    -- Sinister Strike
    if unit.level() < 14 and cast.able.sinisterStrike() then
        if cast.sinisterStrike() then
            ui.debug("Casting Sinister Strike [Build]")
            return true
        end
    end
end -- End Action List - Build

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        -- Poisons
        -- apply_poison
        if not unit.moving() then
            if ui.value("Lethal Poison") == 1 and buff.instantPoison.remain() < 300 and not cast.last.instantPoison() and ui.timer("Leathal Poison", 1) then
                if cast.instantPoison("player") then
                    ui.debug("Casting Instant Poison")
                    return true
                end
            end
            if ui.value("Lethal Poison") == 2 and buff.woundPoison.remain() < 300 and not cast.last.woundPoison() and ui.timer("Leathal Poison", 1) then
                if cast.woundPoison("player") then
                    ui.debug("Casting Wound Poison")
                    return true
                end
            end
            if ui.value("Non-Lethal Poison") == 1 and buff.cripplingPoison.remain() < 300 and not cast.last.cripplingPoison() and ui.timer("Non-Leathal Poison", 1) then
                if cast.cripplingPoison("player") then
                    ui.debug("Casting Crippling Poison")
                    return true
                end
            end
            if ui.value("Non-Lethal Poison") == 2 and buff.numbingPoison.remain() < 300 and not cast.last.numbingPoison() and ui.timer("Non-Leathal Poison", 1) then
                if cast.numbingPoison("player") then
                    ui.debug("Casting Numbing Poison")
                    return true
                end
            end
        end
        -- Stealth
        -- stealth
        if ui.checked("Stealth") and cast.able.stealth() and (not unit.resting() or unit.isDummy("target")) and not var.stealthAll then
            if ui.value("Stealth") == 1 then
                if cast.stealth() then
                    ui.debug("Casting Stealth [Pre-Combat]")
                    return true
                end
            end
            if var.autoStealth() and ui.value("Stealth") == 3 then
                if cast.stealth() then
                    ui.debug("Casting Stealth - Detected Enemy Nearby [Pre-Combat]")
                    return true
                end
            end
        end
        -- Variable - Algethar Puzzle Box Precombat Cast
        -- variable,name=algethar_puzzle_box_precombat_cast,value=3
        var.algetharPuzzleBoxPrecombatCast = 3
        if unit.valid("target") then
            if --[[ui.checked("Pre-Pull") and ui.useCDs() and]] ui.mode.pickPocket ~= 2
                and (not unit.inCombat() or (unit.inCombat() and not cast.last.vanish())) and not buff.vanish.exists()
            then
                -- Slice and Dice
                -- slice_and_dice,precombat_seconds=1
                if cast.able.sliceAndDice() and comboPoints() > 0 and ui.pullTimer() <= 1 then
                    if cast.sliceAndDice() then
                        ui.debug("Casting Slice and Dice [Pre-Combat]")
                        return true
                    end
                end
                -- Shadowstep
                if ui.checked("Shadowstep") and cast.able.shadowstep("target")
                    and (not var.isPicked("target") or not var.stealth or energy() < 40 or (ui.value("SS Range") < 25 and unit.distance("target") > ui.value("SS Range")))
                    and unit.distance("target") > 10 and cast.timeSinceLast.shadowstrike() > unit.gcd(true)
                then
                    if cast.shadowstep("target") then
                        ui.debug("Casting Shadowstep [Pre-Combat]")
                        return true
                    end
                end
                if var.stealthAll then
                    -- Pickpocket
                    for i = 1, #enemies.yards10nc do
                        local thisUnit = enemies.yards10nc[i]
                        if not var.isPicked(thisUnit) and (unit.isUnit(thisUnit, "target") or ui.mode.pickPocket == 2) then
                            if ui.mode.pickPocket == 2 and debuff.sap.remain(thisUnit) < 1 then
                                if cast.sap(thisUnit) then
                                    ui.debug("Casting Sap - Pickpocket [Pre-Combat]")
                                    return true
                                end
                            end
                            if cast.pickPocket(thisUnit) then
                                br.pickPocketing = true
                                ui.debug("Casting Pickpocket [Pre-Combat]")
                                return true
                            end
                        end
                    end
                    -- Shadowstrike
                    if ui.value("Stealth Breaker") == 1 then
                        if cast.able.shadowstrike("target", nil, 1, ui.value("SS Range")) and (var.isPicked() or unit.distance("target") > 10) then
                            if cast.shadowstrike("target", nil, 1, ui.value("SS Range")) then
                                ui.debug("Casting Shadowstrike [Pre-Combat]")
                                return true
                            end
                        end
                    end
                    -- Cheap Shot
                    if (ui.value("Stealth Breaker") == 2 or (ui.value("Stealth Breaker") == 1 and unit.level() < 7))
                        and cast.able.cheapShot("target") and cast.timeSinceLast.cheapShot() > unit.gcd(true)
                    then
                        if cast.cheapShot("target") then
                            ui.debug("Casting Cheap Shot [Pre-Combat]")
                            return true
                        end
                    end
                end
                -- Sinister Strike / Backstab
                if ui.value("Stealth Breaker") == 3 then
                    -- Backstab
                    if cast.able.backstab("target") and cast.timeSinceLast.backstab() > unit.gcd(true) then
                        if cast.backstab("target") then
                            ui.debug("Casting Backstab [Pre-Combat]")
                            return true
                        end
                    end
                    -- Sinister Strike
                    if unit.level() < 14 and cast.able.sinisterStrike("target") and cast.timeSinceLast.sinisterStrike() > unit.gcd(true) then
                        if cast.sinisterStrike("target") then
                            ui.debug("Casting Sinister Strike [Pre-Combat]")
                            return true
                        end
                    end
                end
                -- Start Attack
                if not var.stealthAll and cast.able.autoAttack("target") and energy() < 45 and unit.distance("target") < 5 then
                    if cast.autoAttack("target") then
                        ui.debug("Casting Auto Attack [Pre-Combat]")
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    if unit.inCombat() and not var.profileStop and unit.valid("target") then
        -- Stealth
        -- stealth
        -- if ui.checked("Stealth") and cast.able.stealth() and (not unit.resting() or unit.isDummy("target")) and not var.stealthAll then
        --     if ui.value("Stealth") == 1 then
        --         if cast.stealth() then
        --             ui.debug("Casting Stealth [Combat]")
        --             return true
        --         end
        --     end
        --     if var.autoStealth() and ui.value("Stealth") == 3 then
        --         if cast.stealth() then
        --             ui.debug("Casting Stealth - Detected Enemy Nearby [Combat]")
        --             return true
        --         end
        --     end
        -- end
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
            if cast.shadowstep("target") then
                ui.debug("Casting Shadowstep [Combat]")
                return true
            end
        end
        -- Auto Attack
        -- auto_attack
        if not var.stealthAll and cast.able.autoAttack("target") and unit.distance("target") < 5 then
            if cast.autoAttack("target") then
                ui.debug("Casting Auto Attack [Combat]")
                return true
            end
        end
        -- Variable - Snd Condition
        -- variable,name=snd_condition,value=buff.slice_and_dice.up|spell_targets.shuriken_storm>=cp_max_spend
        var.sndCondition = (buff.sliceAndDice.exists() or ui.useAOE(10, var.cpMaxSpend))
        -- Action List - Cooldowns
        -- call_action_list,name=cds
        if actionList.Cooldowns() then return true end
        -- Slice and Dice
        -- slice_and_dice,if=spell_targets.shuriken_storm<var.cpMaxSpend&buff.slice_and_dice.remains<gcd.max&fight_remains>6&combo_points>=4
        if cast.able.sliceAndDice() and ui.useST(10, var.cpMaxSpend)
            and buff.sliceAndDice.remain() < unit.gcd(true) and unit.ttdGroup(40) > 6 and comboPoints() >= 4
        then
            if cast.sliceAndDice() then
                ui.debug("Casting Slice and Dice [Combat]")
                return true
            end
        end
        -- Action List - Stealthed
        -- run_action_list,name=stealthed,if=stealthed.all
        if var.stealthAll then
            if actionList.Stealthed() then return true end
        end
        -- Variable - Priority Rotation
        -- variable,name=priority_rotation,value=priority_rotation
        var.priorityRotation = ui.checked("Priority Rotation") and ui.useAOE(10, 2)
        -- Variable - Stealth Threshold
        -- variable,name=stealth_threshold,value=20+talent.vigor.rank*25+talent.thistle_tea*20+talent.shadowcraft*20
        var.stealthThreshold = 20 + var.vigor * 25 + var.thistleTea * 20 + var.shadowcraft * 20
        -- Variable - Stealth Helper
        -- variable,name=stealth_helper,value=energy>=variable.stealth_threshold
        var.stealthHelper = energy() >= var.stealthThreshold
        -- Variable - Stealth Helper
        -- variable,name=stealth_helper,value=energy.deficit<=variable.stealth_threshold,if=!talent.vigor|talent.shadowcraft
        var.stealthHelper = (not talent.vigor or talent.shadowcraft) and energy.deficit() <= var.stealthThreshold or
            false
        -- Call Action List - Stealth Cds
        -- call_action_list,name=stealth_cds,if=variable.stealth_helper|talent.invigorating_shadowdust
        if (var.stealthHelper or talent.invigoratingShadowdust) then
            if actionList.StealthCooldowns() then return true end
        end
        -- Action List - Finish
        -- call_action_list,name=finish,if=variable.effective_combo_points>=cp_max_spend
        if var.effectiveComboPoints >= var.cpMaxSpend then
            if actionList.Finish() then return true end
        end
        -- call_action_list,name=finish,if=combo_points.deficit<=1|fight_remains<=1&effective_combo_points>=3
        if (comboPoints.deficit() <= 1 or unit.ttdGroup(40) <= 1 and var.effectiveComboPoints >= 3) then
            if actionList.Finish() then return true end
        end
        -- call_action_list,name=finish,if=spell_targets.shuriken_storm>=4&variable.effective_combo_points>=4
        if ui.useAOE(10, 4) and var.effectiveComboPoints >= 4 then
            if actionList.Finish() then return true end
        end
        -- Action List - Build
        -- call_action_list,name=build,if=energy.deficit<=variable.stealth_threshold
        if energy.deficit() <= var.stealthThreshold then
            if actionList.Build() then return true end
        end
        -- Racials
        -- arcane_torrent,if=energy.deficit>=15+energy.regen
        -- arcane_pulse
        -- lights_judgment
        if ui.useCDs() and ui.checked("Racial") and cast.able.racial() and not var.stealthAll then
            if unit.race() == "LightforgedDraenei" then
                if cast.racial("target") then
                    ui.debug("Casting Racial [Combat]")
                    return true
                end
            end
            if (unit.race() == "BloodElf" and energy.deficit() >= 15 + energy.regen()) or unit.race() == "Nightborne" then
                if cast.racial("player") then
                    ui.debug("Casting Racial [Combat]")
                    return true
                end
            end
        end
        -- Shuriken Toss
        if ui.checked("Shuriken Toss OOR") and energy() >= ui.value("Shuriken Toss OOR") and cast.able.shurikenToss()
            and (charges.shadowstep.count() == 0 or not ui.checked("Shadowstep")) and unit.distance(units.dyn30) > 5 and not var.stealthAll
        then
            if cast.shurikenToss() then
                ui.debug("Casting Shuriken Toss - Out of Melee [Combat]")
                return true
            end
        end
    end -- End In Combat
end     -- End Action List - Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------
    --- Locals ---
    --------------
    -- BR API
    if comboPoints == nil then
        buff        = br.player.buff
        cast        = br.player.cast
        cd          = br.player.cd
        charges     = br.player.charges
        comboPoints = br.player.power.comboPoints
        debuff      = br.player.debuff
        enemies     = br.player.enemies
        energy      = br.player.power.energy
        equiped     = br.player.equiped
        items       = br.player.items
        module      = br.player.module
        talent      = br.player.talent
        ui          = br.player.ui
        unit        = br.player.unit
        units       = br.player.units
        use         = br.player.use
    end

    -- Get Best Unit for Range
    -- units.get(range, aoe)
    units.get(5)
    units.get(30)

    -- Get List of Enemies for Range
    -- enemies.get(range, from unit, no combat, variable)
    enemies.get(5)
    enemies.get(10)
    enemies.get(10, "player", true)
    enemies.get(20)
    enemies.get(20, "player", true)
    enemies.get(30)

    -- General Vars
    var.stealth = buff.stealth.exists() or buff.vanish.exists() or buff.shadowDance.exists()
    var.stealthAll = buff.stealth.exists() or buff.vanish.exists() or buff.shadowmeld.exists() or
        buff.shadowDance.exists() or buff.stealthSepsis.exists() or buff.subterfuge.exists()

    -- Numeric Returns
    var.gloomShadowVeins = (talent.gloomblade and buff.lingeringShadow.remains() >= 6 or buff.perforatedVeins.exists()) and
        1 or 0
    var.deepSecrets = (talent.deeperStratagem or talent.secretStratagem) and 1 or 0
    var.deepStrat = talent.deeperStratagem and 1 or 0
    var.secretStrat = talent.secretStratagem and 1 or 0
    var.shadowcraft = talent.shadowcraft and 1 or 0
    var.shadowDance = talent.shadowDance and 1 or 0
    var.subterfuge = talent.subterfuge and 3 or 0
    var.thistleTea = talent.thistleTea and 1 or 0
    var.vigor = talent.vigor and 1 or 0
    var.invigoratingTier = (not talent.invigoratingShadowdust or equiped.tier(30, 2)) and 1 or 0

    -- SimC Specific Variables
    -- variable,name=secret_condition,value=(action.gloomblade.used_for_danse|action.shadowstrike.used_for_danse|action.backstab.used_for_danse|action.shuriken_storm.used_for_danse)&(action.eviscerate.used_for_danse|action.black_powder.used_for_danse|action.rupture.used_for_danse)|!talent.danse_macabre
    var.secretCondition = ((var.danseGloomblade or var.danseShadowstrike or var.danseBackstab or var.danseShurikenStorm) and (var.danseEviscerate or var.danseBlackPowder or var.danseRupture) or not talent.danseMacabre)
    -- cp_max_spend
    var.cpMaxSpend = 5 + var.deepStrat + var.secretStrat
    -- effective_combo_points
    var.animaCharged = buff.echoingReprimand.exists() and 2 or 0
    var.effectiveComboPoints = (var.animaCharged > 0 and comboPoints() == var.animaCharged) and 7 or comboPoints()
    if talent.danseMacabre and buff.shadowDance.exists() then
        -- action.backstab.used_for_danse
        if cast.last.backstab() then
            var.danseBackstab = true
        end
        -- action.black_powder.used_for_danse
        if cast.last.blackPowder() then
            var.danseBlackPowder = true
        end
        -- action.eviscerate.used_for_danse
        if cast.last.eviscerate() then
            var.danseEviscerate = true
        end
        -- action.gloomblade.used_for_danse
        if cast.last.gloomblade() then
            var.danseGloomblade = true
        end
        -- action.rupture.used_for_danse
        if cast.last.rupture() then
            var.danseRupture = true
        end
        -- action.shadowstrike.used_for_danse
        if cast.last.shadowstrike() then
            var.danseShadowstrike = true
        end
        -- action.shuriken_storm.used_for_danse
        if cast.last.shurikenStorm() then
            var.danseShurikenStorm = true
        end
    else
        var.danseBackstab = false
        var.danseBlackPowder = false
        var.danseEviscerate = false
        var.danseGloomblade = false
        var.danseRupture = false
        var.danseShadowstrike = false
        var.danseShurikenStorm = false
    end

    if not (not unit.exists("target") or not unit.isUnit("target", var.pickPocketUnit)) then
        br.unpickable = false
        var.pickPocketUnit = "player"
    end

    var.maxTTD = 0
    var.maxTTDUnit = "target"
    for i = 1, #enemies.yards5 do
        local thisUnit = enemies.yards5[i]
        local thisCondition = unit.ttd(thisUnit)
        if thisCondition > var.maxTTD then
            var.maxTTD = thisCondition
            var.maxTTDUnit = thisUnit
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or ui.mode.rotation == 4 then
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
        if actionList.Combat() then return true end
    end -- End Profile
end     -- runRotation
local id = 261
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

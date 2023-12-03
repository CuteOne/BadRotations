local rotationName = "ForsoothOutlaw"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.sinisterStrike},
        [2] = { mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.sinisterStrike}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.crimsonVial},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.crimsonVial}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
    -- Interrupts Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Use Interrupt Abilities", highlight = 1, icon = br.player.spell.kick},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "Do Not Use Interrupt Abilities", highlight = 0, icon = br.player.spell.kick}
    };
    br.ui:createToggle(InterruptModes,"Interrupt",3,0)
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
            -- Eviscerate Execute
            br.ui:createDropdownWithout(section, "Eviscerate Execute",{"|cffFFFF00Enabled Notify","|cff00FF00Enabled","|cffFF0000Disabled"}, 2,"Options for using Eviscerate when the damage from it will kill the unit.")
            -- Sprint
            br.ui:createCheckbox(section, "Auto Sprint", "Will use sprint automatically.")
            -- Stealth
            br.ui:createCheckbox(section, "Always Stealth", "Will use stealth at all times.")
            -- Stealth Breaker
            br.ui:createDropdownWithout(section, "Stealth Breaker", {"|cff00FF00Ambush","|cffFFFF00Cheapshot","|cffFF0000Sinister Strike"}, 3, "|cffFFFFFFSet what to break Stealth with.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Crimson Vial
            br.ui:createSpinner(section, "Crimson Vial", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupt")
            -- Kick
            br.ui:createCheckbox(section, "Kick", "|cffFFFFFFUse Kick")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At (0 is random)")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  6)
            -- Defensive Key Toggle
            br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
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
local combo
local comboDeficit
local comboMax
local debuff
local enemies
local energy
local energyDeficit
local energyRegen
local energyTTM
local equiped
local gcd
local mode
local ui
local spell
local unit
local units
local talent
local var
-- General Locals
local haltProfile
local profileStop
local eviscerateDamage
local finishHim
-- Profile Specific Locals
local actionList = {}

-----------------
--- Functions ---
-----------------
-- Eviscerate Finish
local function eviscerateFinish(thisUnit)
    local GetSpellDescription = br._G["GetSpellDescription"]
    local desc = GetSpellDescription(spell.eviscerate)
    local damage = 0
    local finishHim = false
    if ui.value("Eviscerate Execute") ~= 3 and combo > 0 and not unit.isDummy(thisUnit) then
        local comboStart = desc:find(" "..combo.." ",1,true)
        if comboStart ~= nil then
            comboStart = comboStart + 2
            local damageList = desc:sub(comboStart,desc:len())
            comboStart = damageList:find(": ",1,true)+2
            damageList = damageList:sub(comboStart,desc:len())
            local comboEnd = damageList:find(" ",1,true)-1
            damageList = damageList:sub(1,comboEnd)
            damage = damageList:gsub(",","")
        end
        eviscerateDamage = tonumber(damage)
        finishHim = tonumber(damage) >= unit.health(thisUnit) and unit.health(thisUnit) > 0
    end
    return finishHim
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
actionList.Extras = function()
    -- Instant Poison
    if cast.able.instantPoison() and not buff.instantPoison.exists() then
        if cast.instantPoison() then ui.debug("Casting Instant Poison") return true end
    end
    -- Stealth
    if ui.checked("Always Stealth") and cast.able.stealth() and not buff.stealth.exists()
        and not unit.casting() and cast.timeSinceLast.stealth() > unit.gcd(true)
    then
        if cast.stealth() then ui.debug("Casting Stealth") return true end
    end
    -- Sprint
    if ui.checked("Auto Sprint") and cast.able.sprint() then
        if cast.sprint() then ui.debug("Casting Sprint") return true end
    end
end
-- Action List - Defensive
actionList.Defensive = function()
    --Crimson Vial
    if unit.level() >= 8 and ui.checked("Crimson Vial") then
        if cast.able.crimsonVial() and unit.inCombat() and unit.hp() <= ui.value("Crimson Vial") then
            if cast.crimsonVial() then ui.debug("Casting Crimson Vial") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        -- Kick
        if ui.checked("Kick") then
            for i=1, #enemies.yards5f do
                local thisUnit = enemies.yards5f[i]
                if cast.able.kick(thisUnit) and unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.kick(thisUnit) then ui.debug("Casting Kick on "..unit.name(thisUnit)) return true end
                end
            end
        end
    end
end -- End Action List - Interrupt

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if unit.valid("target") then
        --Stealth
        if cast.able.stealth() and unit.level() >= 3 and unit.distance("target") <= 20 and not buff.stealth.exists() and cast.timeSinceLast.stealth() > unit.gcd(true) then
            if cast.stealth() then ui.debug("Casting Stealth [Pre-Combat]") return true end
        end
        if buff.stealth.exists() or unit.level() < 3 then
            --Ambush
            if ui.value("Stealth Breaker") == 1 and cast.able.ambush("target") and cast.timeSinceLast.ambush() > unit.gcd(true) then
                if cast.ambush("target") then ui.debug("Casting Ambush [Pre-Combat]") return true end
            end
            -- Cheap Shot
            if (ui.value("Stealth Breaker") == 2 or (ui.value("Stealth Breaker") == 1 and unit.level() < 7))
                and cast.able.cheapShot("target") and cast.timeSinceLast.cheapShot() > unit.gcd(true)
            then
                if cast.cheapShot("target") then ui.debug("Casting Cheap Shot [Pre-Combat]") return true end
            end
            -- Sinister Strike
            if ui.value("Stealth Breaker") == 3 and cast.able.sinisterStrike("target")
                and (combo < 5 or unit.level() < 2) and cast.timeSinceLast.sinisterStrike() > unit.gcd(true)
            then
                if cast.sinisterStrike("target") then ui.debug("Casting Sinister Strike [Pre-Combat]") return true end
            end
        end
        -- Start Attack
        if cast.able.autoAttack("target") and energy < 45 then
            if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
        end
    end
end -- End Action List - PreCombat

actionList.stealth = function()
    -- blade_flurry,if=talent.subterfuge&talent.hidden_opportunity&spell_targets>=2&!buff.blade_flurry.up
    if cast.able.bladeFlurry() and talent.subterfuge and talent.hiddenOpportunity and #enemies.yards5 >=2 and not buff.bladeFlurry.exists() then
        cast.bladeFlurry()
    end
    -- cold_blood,if=variable.finish_condition
    if cast.able.coldBlood() and var.finishCondition then
        cast.coldBlood()
    end
    -- dispatch,if=variable.finish_condition
    if cast.able.dispatch() and var.finishCondition then
        cast.dispatch()
    end
    -- 	ambush,if=variable.stealthed_cto|stealthed.basic&talent.find_weakness&!debuff.find_weakness.up|talent.hidden_opportunity
    if cast.able.ambush() and (var.stealtedCto or buff.stealth.exists() and talent.findWeakness and not debuff.findWeakness.exists() or talent.hiddenOpportunity) then
        cast.ambush()
    end
end

actionList.cds = function()
    -- 	adrenaline_rush,if=!buff.adrenaline_rush.up&(!talent.improved_adrenaline_rush|combo_points<=2)
    if br.isBoss() and unit.ttd() >= 20 and not buff.adrenalineRush.exists() and (not talent.improvedAdrenalineRush or combo <= 2) then
        cast.adrenalineRush()
    end
    -- blade_flurry,if=(spell_targets>=2|((buff.grand_melee.up&talent.hidden_opportunity)|(buff.grand_melee.remains>10))&!stealthed.rogue&!buff.dreadblades.up)&buff.blade_flurry.remains<gcd
    if cast.able.bladeFlurry() and ((#enemies.yards5 >=2 or ((buff.grandMelee.exists() and talent.hiddenOpportunity) or (buff.grandMelee.remains() > 10)) and not buff.stealth.exists() and not buff.dreadblades.exists()) and buff.bladeFlurry.remains() < gcd or not buff.bladeFlurry.exists()) then
        cast.bladeFlurry()
    end
    -- roll_the_bones,if=buff.dreadblades.down&(rtb_buffs.total=0|variable.rtb_reroll)
    if cast.able.rollTheBones() and not buff.dreadblades.exists() and (rtbBuffs() == 0 or var.rtbReroll) then
        cast.rollTheBones()
    end
    -- keep_it_rolling,if=!variable.rtb_reroll&(buff.broadside.up+buff.true_bearing.up+buff.skull_and_crossbones.up+buff.ruthless_precision.up+buff.grand_melee.up)>2&(buff.shadow_dance.down|rtb_buffs>=6)
    if cast.able.keepItRolling() and not var.rtbReroll and ((buff.broadside.exists() and 1 or 0)+(buff.trueBearing.exists() and 1 or 0)(buff.skullAndCrossbones.exists() and 1 or 0)(buff.ruthlessPrecision.exists() and 1 or 0)(buff.grandMelee.exists() and 1 or 0)) > 2 and (not buff.shadowDance.exists() or rtbBuffs() >= 6) then
        cast.keepItRolling()
    end
    -- blade_rush,if=variable.blade_flurry_sync&!buff.dreadblades.up&(energy.base_time_to_max>4+stealthed.rogue-spell_targets%3)
    if cast.able.bladeRush() and var.bladeFlurrySync and not buff.dreadblades.exists() and (energyTTM > 4 + (buff.stealth.exists() and 1 or 0)-#enemies.yards5%3) then
        cast.bladeRush()
    end
    -- call_action_list,name=stealth_cds,if=!stealthed.all|talent.count_the_odds&!talent.hidden_opportunity&!variable.stealthed_cto
    if buff.stealth.exists() or talent.countTheOdds and not talent.hiddenOpportunity and not var.stealtedCto then
        actionList.stealthcds()
    end
    -- dreadblades,if=!(variable.stealthed_cto|stealthed.basic|talent.hidden_opportunity&stealthed.rogue)&combo_points<=2&(!talent.marked_for_death|!cooldown.marked_for_death.ready)&target.time_to_die>=10
    if cast.able.dreadblades() and not(var.stealtedCto or buff.stealth.exists() or talent.hiddenOpportunity and buff.stealth.exists()) and combo <= 2 and (not talent.markedForDeath or not cd.markedForDeath.ready()) and unit.ttd() >= 10 then
        cast.dreadblades()
    end
    -- 	marked_for_death,line_cd=1.5,target_if=min:target.time_to_die,if=raid_event.adds.up&(target.time_to_die<combo_points.deficit|combo_points.deficit>=cp_max_spend-1)&!buff.dreadblades.up
    if cast.able.markedForDeath() and (unit.ttd() < comboDeficit or comboDeficit >= comboMax-1) and not buff.dreadblades.exists() then
        cast.markedForDeath()
    end
    -- thistle_tea,if=!buff.thistle_tea.up&(energy.base_deficit>=100|fight_remains<charges*6)
    if cast.able.thistleTea() and not buff.thistleTea.exists() and (energyDeficit>= 100 or unit.ttd() < charges.thistleTea.count() * 6) then
        cast.thistleTea()
    end
    -- 	killing_spree,if=variable.blade_flurry_sync&!stealthed.rogue&debuff.between_the_eyes.up&energy.base_time_to_max>4
    if cast.able.killingSpree() and var.bladeFlurrySync and not buff.stealth.exists() and debuff.betweenTheEyes.exists() and energyTTM > 4 then
        cast.killingSpree()
    end
    -- 	shadowmeld,if=!stealthed.all&(talent.count_the_odds&variable.finish_condition|!talent.weaponmaster.enabled&variable.ambush_condition)
    
end

actionList.finish = function()
    -- between_the_eyes,if=target.time_to_die>3&(debuff.between_the_eyes.remains<4|talent.greenskins_wickers&!buff.greenskins_wickers.up|!talent.greenskins_wickers&talent.improved_between_the_eyes&buff.ruthless_precision.up|!talent.greenskins_wickers&set_bonus.tier30_4pc)
    if cast.able.betweenTheEyes() and unit.ttd() > 3 and (debuff.betweenTheEyes.remains() < 4 or talent.greenskinsWickers and not buff.greenskinsWickers.exists() or not talent.greenskinsWickers and talent.improvedBetweenTheEyes and buff.ruthlessPrecision.exists() or not talent.greenskinsWickers and equiped.tier(30) >= 4) then
        cast.betweenTheEyes()
    end
    -- 	slice_and_dice,if=buff.slice_and_dice.remains<fight_remains&refreshable&(!talent.swift_slasher|combo_points>=cp_max_spend)
    if cast.able.sliceAndDice() and buff.sliceAndDice.remains() < unit.ttd() and buff.sliceAndDice.refreshable and (not talent.swiftSlasher or combo>=comboMax) then
        cast.sliceAndDice()
    end
    -- cold_blood
    if cast.able.coldBlood() then
        cast.coldBlood()
    end
    -- dispatch
    if cast.able.dispatch() then
        cast.dispatch()
    end
end

actionList.build = function()
    -- sepsis,target_if=max:target.time_to_die*debuff.between_the_eyes.up,if=target.time_to_die>11&debuff.between_the_eyes.up|fight_remains<11
    if cast.able.sepsis() and unit.ttd() > 11 and debuff.betweenTheEyes.exists() or unit.ttd() < 11 then
        cast.sepsis()
    end
    -- 	ghostly_strike,if=debuff.ghostly_strike.remains<=3&(spell_targets.blade_flurry<=2|buff.dreadblades.up)&!buff.subterfuge.up&target.time_to_die>=5
    if cast.able.ghostlyStrike() and debuff.ghostlyStrike.remains() <= 3 and (#enemies.yards5<=2 or buff.dreadblades.exists()) and not buff.subterfuge and unit.ttd() >= 5 then
        cast.ghostlyStrike()
    end
    -- ambush,if=talent.keep_it_rolling&((buff.audacity.up|buff.sepsis_buff.up)&talent.find_weakness&debuff.find_weakness.remains<2|buff.subterfuge.up&cooldown.keep_it_rolling.ready)
    if cast.able.ambush() and talent.keepItRolling and ((buff.audacity.exists() or buff.sepsis.exists()) and talent.findWeakness and debuff.findWeakness.remains() <2 or buff.subterfuge.exists() and cd.keepItRolling.ready()) then
        cast.ambush()
    end
    -- ambush,if=talent.hidden_opportunity&(buff.audacity.up|buff.sepsis_buff.up)
    if cast.able.ambush() and talent.hiddenOpportunity and (buff.audacity.exists() or buff.sepsis.exists) then
        cast.ambush()
    end
    -- 	pistol_shot,if=talent.fan_the_hammer&talent.audacity&talent.hidden_opportunity&buff.opportunity.up&!buff.audacity.up&!buff.subterfuge.up&!buff.shadow_dance.up
    if cast.able.pistolShot and talent.fanTheHammer and talent.audacity and talent.hiddenOpportunity and buff.opportunity.exists() and not buff.audacity.exists() and not buff.subterfuge.exists() and not buff.shadowDance.exists() then
        cast.pistolShot()
    end
    -- pistol_shot,if=buff.greenskins_wickers.up&(!talent.fan_the_hammer&buff.opportunity.up|buff.greenskins_wickers.remains<1.5)
    if cast.able.pistolShot() and buff.greenskinsWickers.exists() and (not talent.fanTheHammer and buff.opportunity.exists() or buff.greenskinsWickers.remains() < 1.5) then
        cast.pistolShot()
    end
    -- 	pistol_shot,if=talent.fan_the_hammer&buff.opportunity.up&(buff.opportunity.stack>=buff.opportunity.max_stack|buff.opportunity.remains<2)
    if cast.able.pistolShot() and talent.fanTheHammer and buff.opportunity.exists() and (buff.opportunity.stack() >= var.opportunityMaxStacks or buff.opportunity.remains() < 2) then
        cast.pistolShot()
    end
    -- pistol_shot,if=talent.fan_the_hammer&buff.opportunity.up&combo_points.deficit>((1+talent.quick_draw)*talent.fan_the_hammer.rank)&!buff.dreadblades.up&(!talent.hidden_opportunity|!buff.subterfuge.up&!buff.shadow_dance.up)
    if cast.able.pistolShot() and talent.fanTheHammer and buff.opportunity.exists() and comboDeficit > ((1+(talent.quickDraw and 1 or 0)*talent.rank.fanTheHammer)) and not buff.dreadblades.exists() and (not talent.hiddenOpportunity or not buff.subterfuge.exists() and not buff.shadowDance.exists()) then
        cast.pistolShot()
    end
    -- echoing_reprimand
    if cast.able.echoingReprimand() then
        cast.echoingReprimand()
    end
    -- 	ambush,if=talent.hidden_opportunity|talent.find_weakness&debuff.find_weakness.down
    if cast.able.ambush() and talent.hiddenOpportunity or talent.findWeakness and not debuff.findWeakness.exists() then
        cast.ambush()
    end
    -- pistol_shot,if=!talent.fan_the_hammer&buff.opportunity.up&(energy.base_deficit>energy.regen*1.5|!talent.weaponmaster&combo_points.deficit<=1+buff.broadside.up|talent.quick_draw.enabled|talent.audacity.enabled&!buff.audacity.up)
    if cast.able.pistolShot and not talent.fanTheHammer and buff.opportunity.exists() and (energyDeficit>energyRegen*1.5 or not talent.weaponmaster and comboDeficit<=1+((buff.broadside.up or talent.quickDraw or talent.audacity and not buff.audacity.exists()) and 1 or 0)) then
        cast.pistolShot()
    end
    -- sinister_strike
    if cast.able.sinisterStrike() then
        cast.sinisterStrike()
    end
end

actionList.stealthcds = function()
    -- variable,name=vanish_condition,value=talent.hidden_opportunity|!talent.shadow_dance|!cooldown.shadow_dance.ready
    var.vanishCondition = talent.hiddenOpportunity or not talent.shadowDance or not cd.shadowDance.ready()
    -- variable,name=vanish_opportunity_condition,value=!talent.shadow_dance&talent.fan_the_hammer.rank+talent.quick_draw+talent.audacity<talent.count_the_odds+talent.keep_it_rolling
    var.vanishOpportunityCondition = not talent.shadowDance and talent.rank.fanTheHammer+((talent.quickDraw and 1 or 0) + (talent.audacity and 1 or 0)) < (talent.countTheOdds and 1 or 0) + (talent.keepItRolling and 1 or 0)
    -- 	vanish,if=talent.find_weakness&!talent.audacity&debuff.find_weakness.down&variable.ambush_condition&variable.vanish_condition
    if cast.able.vanish() and talent.findKindredSpirit and not talent.audacity and not debuff.findWeakness.exists() and var.ambushCondition and var.vanishCondition then
        cast.vanish()
    end
    -- vanish,if=talent.hidden_opportunity&!buff.audacity.up&(variable.vanish_opportunity_condition|buff.opportunity.stack<buff.opportunity.max_stack)&variable.ambush_condition&variable.vanish_condition
    if cast.able.vanish() and talent.hiddenOpportunity and not buff.audacity.exists() and (var.vanishOpportunityCondition or buff.opportunity.stack() < var.opportunityMaxStacks) and var.ambushCondition and var.vanishCondition then
        cast.vanish()
    end
    -- vanish,if=(!talent.find_weakness|talent.audacity)&!talent.hidden_opportunity&variable.finish_condition&variable.vanish_condition
    if cast.able.vanish() and (not talent.findWeakness or talent.audacity) and not talent.hiddenOpportunity and var.finishCondition and var.vanishCondition then
        cast.vanish()
    end
    -- 	variable,name=shadow_dance_condition,value=talent.shadow_dance&debuff.between_the_eyes.up&(!talent.ghostly_strike|debuff.ghostly_strike.up)&(!talent.dreadblades|!cooldown.dreadblades.ready)&(!talent.hidden_opportunity|!buff.audacity.up&(talent.fan_the_hammer.rank<2|!buff.opportunity.up))
    var.shadowDanceCondition = talent.shadowDance and debuff.betweenTheEyes.exists() and (not talent.ghostlyStrike or debuff.ghostlyStrike.exists()) and (not talent.dreadblades or not cd.dreadblades.ready()) and (not talent.hiddenOpportunity or not buff.audacity.exists() and (talent.fanTheHammer.rank <2 or not buff.opportunity.exists))
    -- shadow_dance,if=!talent.keep_it_rolling&variable.shadow_dance_condition&buff.slice_and_dice.up&(variable.finish_condition|talent.hidden_opportunity)&(!talent.hidden_opportunity|!cooldown.vanish.ready)
    if cast.able.shadowDance() and not talent.keepItRolling and var.shadowDanceCondition and buff.sliceAndDice.exists() and (var.finishCondition or talent.hiddenOpportunity) and (not talent.hiddenOpportunity or not cd.vanish.ready()) then
        cast.shadowDance()
    end
    -- shadow_dance,if=talent.keep_it_rolling&variable.shadow_dance_condition&(cooldown.keep_it_rolling.remains<=30|cooldown.keep_it_rolling.remains>120&(variable.finish_condition|talent.hidden_opportunity))
    if cast.able.shadowDance() and talent.keepItRolling and var.shadowDanceCondition and (cd.keepItRolling.remains()<=30 or cd.keepItRolling.remains()>120 and (var.finishCondition or talent.hiddenOpportunity)) then
        cast.shadowDance()
    end
end

function rtbBuffs()
    local buff_count = 0
    if buff.broadside.exists() then
        buff_count = buff_count + 1
    end
    if buff.buriedTreasure.exists() then
        buff_count = buff_count + 1
    end
    if buff.grandMelee.exists() then
        buff_count = buff_count + 1
    end
    if buff.ruthlessPrecision.exists() then
        buff_count = buff_count + 1
    end
    if buff.skullAndCrossbones.exists() then
        buff_count = buff_count + 1
    end
    if buff.trueBearing.exists() then
        buff_count = buff_count + 1
    end
    return (buff_count)
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    charges                                       = br.player.charges
    cd = br.player.cd
    combo                                         = br.player.power.comboPoints.amount()
    comboDeficit                                  = br.player.power.comboPoints.deficit()
    comboMax                                      = br.player.power.comboPoints.max()
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    energy                                        = br.player.power.energy.amount()
    energyTTM                                     = br.player.power.energy.ttm()
    energyDeficit                                 = br.player.power.energy.deficit()
    energyRegen                                   = br.player.power.energy.regen()
    equiped                                       = br.player.equiped
    gcd                                           = br.player.gcd
    mode                                          = br.player.ui.mode
    ui                                            = br.player.ui
    spell                                         = br.player.spell
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    talent = br.player.talent
    var = br.player.variables
    -- General Locals
    profileStop                                   = profileStop or false
    haltProfile                                   = (unit.inCombat() and profileStop) or unit.mounted() or br.pause() or mode.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40,true)
    -- Enemies
    enemies.get(5,"player",false,true) -- makes enemies.yards5f
    enemies.get(5)

    if eviscerateDamage == nil then eviscerateDamage = 0 end
    finishHim = eviscerateFinish(units.dyn5)
    var.opportunityMaxStacks = talent.fanTheHammer and 6 or 4
    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = ui.time() end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        br.pauseTime = ui.time()
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        if actionList.Extras() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        -- Check for combat
        if unit.inCombat() and not profileStop and unit.exists(units.dyn5) then
            if ui.value("Eviscerate Execute") == 1 then
                ui.chatOverlay("Eviscerate Damage: "..eviscerateDamage..", Unit HP: "..unit.health(units.dyn5))
            end
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupt() then return true end
            -- variable,name=stealthed_cto,value=talent.count_the_odds&(stealthed.basic|buff.shadowmeld.up|buff.shadow_dance.up)
            var.stealtedCto = talent.countTheOdds and (buff.stealth.exists() or buff.shadowmeld.exists() or buff.shadowDance.exists())
            -- variable,name=rtb_reroll,if=!talent.hidden_opportunity,value=rtb_buffs<2&(!buff.broadside.up&(!talent.fan_the_hammer|!buff.skull_and_crossbones.up)&!buff.true_bearing.up|buff.loaded_dice.up)|rtb_buffs=2&(buff.buried_treasure.up&buff.grand_melee.up|!buff.broadside.up&!buff.true_bearing.up&buff.loaded_dice.up)
            if talent.hiddenOpportunity then
                var.rtbReroll = not talent.hiddenOpportunity and (rtbBuffs() < 2 and ( not buff.broadside.exists() and (not talent.fanTheHammer or not buff.skullAndCrossbones.exists()) and not buff.trueBearing.exists() or buff.loadedDice.exists()) or rtbBuffs == 2 and (buff.buriedTreasure.exists() and buff.grandMelee.exists() or not buff.broadside.exists() and not buff.trueBearing.exists() and buff.loadedDice.exists()))
            end
            -- 	variable,name=rtb_reroll,if=talent.hidden_opportunity,value=!rtb_buffs.will_lose.skull_and_crossbones&rtb_buffs.will_lose<2&buff.shadow_dance.down&buff.subterfuge.down
            if talent.hiddenOpportunity then
                var.rtbReroll = not buff.skullAndCrossbones.exists() and rtbBuffs() < 2 and not buff.shadowDance.exists() and not buff.subterfuge.exists()
            end
            -- variable,name=rtb_reroll,op=reset,if=!(raid_event.adds.remains>12|raid_event.adds.up&(raid_event.adds.in-raid_event.adds.remains)<6|target.time_to_die>12)|fight_remains<12
            if unit.ttd(true) <= 12 then
                var.rtbReroll = false
            end
            -- variable,name=ambush_condition,value=(talent.hidden_opportunity|combo_points.deficit>=2+talent.improved_ambush+buff.broadside.up|buff.vicious_followup.up)&energy>=50
            var.ambushCondition = (talent.hiddenOpportunity or comboDeficit >= 2 + ((talent.improvedAmbush or buff.broadside.exists() or buff.viciousFollowup.exists()) and 1 or 0)) and energy >= 50
            -- variable,name=finish_condition,value=combo_points>=((cp_max_spend-1)<?(6-talent.summarily_dispatched))|effective_combo_points>=cp_max_spend
            var.finishCondition = combo >= (((comboMax-1)<(6-(talent.summarilyDispatched and 1 or 0))) and 1 or 0) or combo >= comboMax
            -- variable,name=blade_flurry_sync,value=spell_targets.blade_flurry<2&raid_event.adds.in>20|buff.blade_flurry.remains>1+talent.killing_spree.enabled
            var.bladeFlurrySync = #enemies.yards5 < 2 and buff.bladeFlurry.remains() > 1 + (talent.killingSpree and 1 or 0)
            -- call_action_list,name=stealth,if=stealthed.basic|buff.shadowmeld.up
            if(buff.stealth.exists() or buff.shadowmeld.exists()) then
                actionList.stealth()
            end
            -- call_action_list,name=cds
            actionList.cds()
            -- call_action_list,name=stealth,if=variable.stealthed_cto
            if var.stealtedCto then
                actionList.stealth()
            end
            -- 	run_action_list,name=finish,if=variable.finish_condition
            if var.finishCondition then
                actionList.finish()
            end
            -- call_action_list,name=build
            actionList.build()

            -- Start Attack
            if cast.able.autoAttack(units.dyn5) then
                if cast.autoAttack(units.dyn5) then ui.debug("Casting Auto Attack") return true end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 260 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

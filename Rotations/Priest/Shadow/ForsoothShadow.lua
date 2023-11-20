local rotationName = "ForsoothShadow"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.smite },
        [2] = {  mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.smite }
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.powerWordShield},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.powerWordShield}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
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

        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            br.ui:createSpinner(section, "Flash Heal", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Pyschic Scream", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Desperate Prayer", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Fade", 25, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
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
local debuff
local enemies
local has
local mode
local ui
local pet
local spell
local talent
local insanityDeficit
local insanity
local unit
local units
local equiped
local use
local var
-- General Locals
local haltProfile
local profileStop
-- Profile Specific Locals
local actionList = {}

function IsMindbenderActive()
    local cdRemaining = cd.mindbender.remains()
    if cdRemaining <= 45 then
      return false
    else
      return true
    end
  end

  function IsShadowfiendActive()
    local cdRemaining = cd.shadowFiend.remains()
    if cdRemaining <= 45 then
        return false
    else
        return true
    end
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Defensive
actionList.Defensive = function()
--Flash Heal
    if unit.level() >= 2 and ui.checked("Flash Heal") then
        if cast.able.flashHeal() and unit.inCombat() and unit.hp() <= ui.value("Flash Heal") then
            if cast.flashHeal() then ui.debug("Casting Flash Heal") return true end
        end
    end
    --Pyschic Scream
    if unit.level() >= 7 and ui.checked("Pyschic Scream") then
        if cast.able.pyschicScream() and unit.inCombat() and unit.hp() <= ui.value("Pyschic Scream") then
            if cast.pyschicScream() then ui.debug("Casting Pyschic Scream") return true end
        end
    end
    --Desperate Prayer
    if unit.level() >= 8 and ui.checked("Flash Heal") then
        if cast.able.desperatePrayer() and unit.inCombat() and unit.hp() <= ui.value("Desperate Prayer") then
            if cast.desperatePrayer() then ui.debug("Casting Desperate Prayer") return true end
        end
    end
    --Fade
    if unit.level() >= 9 and ui.checked("Fade") then
        if cast.able.fade() and unit.inCombat() and unit.hp() <= ui.value("Fade") then
            if cast.fade() then ui.debug("Casting Flash Heal") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()
    --Power Word Fortitude
    if unit.level() >= 6 and cast.able.powerWordFortitude() and not buff.powerWordFortitude.exists("player") then
        if cast.powerWordFortitude() then ui.debug("Casting Power Word Fortitude") return true end
    end
    -- shadowform,if=!buff.shadowform.up
    if not buff.shadowform.exists() then
        cast.shadowform()
    end
    -- shadow_crash,if=raid_event.adds.in>=25&spell_targets.shadow_crash<=8&!fight_style.dungeonslice
    if talent.shadowCrash and cd.shadowCrash.ready() and unit.ttd("target") > 3 and not br.isMoving("target") then
        cast.shadowCrash("best",nil,1,8)
    end
    -- vampiric_touch,if=!talent.shadow_crash.enabled|raid_event.adds.in<25|spell_targets.shadow_crash>8|fight_style.dungeonslice
    if not talent.shadowCrash and cast.able.vampiricTouch() then
        cast.vampiricTouch()
    end
end -- End Action List - PreCombat

actionList.aoe_variables = function()
    -- actions.aoe_variables=variable,name=max_vts,op=set,default=12,value=spell_targets.vampiric_touch>?12
    var.max_vtw = #enemies.yards40 > 12 and #enemies.yards40 or 12
    -- actions.aoe_variables+=/variable,name=is_vt_possible,op=set,value=0,default=1
    var.is_vt_possible = 1
    -- actions.aoe_variables+=/variable,name=is_vt_possible,op=set,value=1,target_if=max:(target.time_to_die*dot.vampiric_touch.refreshable),if=target.time_to_die>=18
    var.is_vt_possible = unit.ttd() > 18
    -- # TODO: Revamp to fix undesired behaviour with unstacked fights
    -- actions.aoe_variables+=/variable,name=vts_applied,op=set,value=(active_dot.vampiric_touch+8*(action.shadow_crash.in_flight&talent.whispering_shadows))>=variable.max_vts|!variable.is_vt_possible
    var.vts_applied = (br.player.buff.vampiricTouch.count()+8*(cast.inFlight.shadowCrash() and talent.whispersShadows and 1 or 0)) >= var.max_vts or not var.is_vt_possible
    -- actions.aoe_variables+=/variable,name=holding_crash,op=set,value=(variable.max_vts-active_dot.vampiric_touch)<4|raid_event.adds.in<10&raid_event.adds.count>(variable.max_vts-active_dot.vampiric_touch),if=variable.holding_crash&talent.whispering_shadows
    var.holdingCrash = false
    -- actions.aoe_variables+=/variable,name=manual_vts_applied,op=set,value=(active_dot.vampiric_touch+8*!variable.holding_crash)>=variable.max_vts|!variable.is_vt_possible
    var.manual_vts_applied = (br.player.buff.vampiricTouch.count()+8* (not var.holdingCrash and 0 or 0) >= var.max_vts or not var.is_vt_possible)
end

actionList.cds = function()
    -- # TODO: Check VE/DA enter conditions based on dots
    -- actions.cds=potion,if=buff.voidform.up|buff.power_infusion.up|buff.dark_ascension.up&(fight_remains<=cooldown.power_infusion.remains+15)|fight_remains<=30
    -- actions.cds+=/fireblood,if=buff.power_infusion.up|fight_remains<=8
    -- actions.cds+=/berserking,if=buff.power_infusion.up|fight_remains<=12
    -- actions.cds+=/blood_fury,if=buff.power_infusion.up|fight_remains<=15
    -- actions.cds+=/ancestral_call,if=buff.power_infusion.up|fight_remains<=15
    -- # Sync Power Infusion with Voidform or Dark Ascension
    -- actions.cds+=/power_infusion,if=(buff.voidform.up|buff.dark_ascension.up)
    if cast.able.powerInfusion() and (buff.voidForm.exists() or buff.darkAscension.exists()) then
        cast.powerInfusion()
    end
    -- # Use <a href='https://www.wowhead.com/spell=10060/power-infusion'>Power Infusion</a> while <a href='https://www.wowhead.com/spell=194249/voidform'>Voidform</a> or <a href='https://www.wowhead.com/spell=391109/dark-ascension'>Dark Ascension</a> is active. Chain directly after your own <a href='https://www.wowhead.com/spell=10060/power-infusion'>Power Infusion</a>.
    -- actions.cds+=/invoke_external_buff,name=power_infusion,if=(buff.voidform.up|buff.dark_ascension.up)&!buff.power_infusion.up
    -- # Make sure Mindbender is active before popping Void Eruption and dump charges of Mind Blast before casting
    -- actions.cds+=/void_eruption,if=!cooldown.fiend.up&(pet.fiend.active&cooldown.fiend.remains>=4|!talent.mindbender|active_enemies>2&!talent.inescapable_torment.rank)&(cooldown.mind_blast.charges=0|time>15)
    if cast.able.voidEruption() and not cd.mindbender.ready() and (IsMindbenderActive() and cd.mindbender.remains() >=4 or not talent.mindbender or #enemies.yards40 > 2 and not talent.inescapableTorment) and (charges.mindBlast.count() == 0) then
        cast.voidEruption()
    end
    -- # Make sure Mindbender is active before popping Dark Ascension unless you have insignificant talent points or too many targets
    -- actions.cds+=/dark_ascension,if=pet.fiend.active&cooldown.fiend.remains>=4|!talent.mindbender&!cooldown.fiend.up|active_enemies>2&!talent.inescapable_torment
    if cast.able.darkAscension() and IsMindbenderActive() and cd.mindbender.remains() >= 4 or not talent.mindbender and not cd.mindbender.ready() or #enemies.yards40 > 2 and not talent.inescapableTorment then
        cast.darkAscension()
    end
    -- actions.cds+=/call_action_list,name=trinkets
    -- # Use Desperate Prayer to heal up should Shadow Word: Death or other damage bring you below 75%
    -- actions.cds+=/desperate_prayer,if=health.pct<=75
    if cast.able.desperatePrayer() and unit.hp("player") <= 75 then
        cast.desperatePrayer("player")
    end
end

actionList.filler = function()
    -- actions.filler=vampiric_touch,target_if=min:remains,if=buff.unfurling_darkness.up
    if cast.able.vampiricTouch() and debuff.vampiricTouch.exists() and buff.unfurlingDarkness.exists() then
        cast.vampiricTouch()
    end
    -- actions.filler+=/shadow_word_death,target_if=target.health.pct<20|buff.deathspeaker.up|set_bonus.tier31_2pc
    if cast.able.shadowWordDeath() and unit.hp("target").hp < 20 or buff.deathspeaker.exists() or equiped.tier(31) >= 2 then
        cast.shadowWordDeath()
    end
    -- actions.filler+=/mind_spike_insanity
    if cast.able.mindSpikeInsanity() then
        cast.mindSpikeInsanity()
    end
    -- actions.filler+=/mind_flay,if=buff.mind_flay_insanity.up
    if cast.able.mindFlay() and buff.mindFlayInsanity.exists() then
        cast.mindFlay()
    end
    -- actions.filler+=/mindgames
    if cast.able.mindgames() then
        cast.mindgames()
    end
    -- actions.filler+=/shadow_word_death,target_if=min:target.time_to_die,if=talent.inescapable_torment&pet.fiend.active
    if cast.able.shadowWordDeath() and talent.inescapableTorment and IsMindbenderActive() then
        cast.shadowWordDeath()
    end
    -- actions.filler+=/halo,if=spell_targets>1
    if cast.able.halo() and #enemies.yards30 > 1 then
        cast.halo()
    end
    -- actions.filler+=/mind_spike
    if cast.able.mindSpike() then
        cast.mindSpike()
    end
    -- actions.filler+=/mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2
    if cast.able.mindFlay() then
        cast.mindFlay()
    end
    -- actions.filler+=/divine_star
    if cast.able.divineStar() then
        cast.divineStar()
    end
    -- actions.filler+=/shadow_crash,if=raid_event.adds.in>20
    if cast.able.shadowCrash("best",nil,1,8) then
        cast.shadowCrash("best",nil,1,8)
    end
    -- actions.filler+=/shadow_word_death,target_if=target.health.pct<20
    if cast.able.shadowWordDeath() and unit.hp("target") < 20 then
        cast.shadowWordDeath()
    end
    -- actions.filler+=/divine_star
    if cast.able.divineStar() then
        cast.divineStar()
    end
    -- actions.filler+=/shadow_word_death
    if cast.able.shadowWordDeath() then
        cast.shadowWordDeath()
    end
    -- actions.filler+=/power_word_shield,if=set_bonus.tier31_4pc
    if cast.able.powerWordShield() and equiped.tier(31) >= 4 then
        cast.powerWordShield()
    end
    -- actions.filler+=/shadow_word_pain,target_if=min:remains
    if cast.able.shadowWordPain() and debuff.shadowWordPain.refresh() then
        cast.shadowWordPain()
    end
end

actionList.aoe = function()
    -- actions.aoe=call_action_list,name=aoe_variables
    actionList.aoe_variables()
    -- # High Priority action to put out Vampiric Touch on enemies that will live at least 18 seconds, up to 12 targets manually while prepping AoE
    -- actions.aoe+=/vampiric_touch,target_if=refreshable&target.time_to_die>=18&(dot.vampiric_touch.ticking|!variable.vts_applied),if=variable.max_vts>0&!variable.manual_vts_applied&!action.shadow_crash.in_flight|!talent.whispering_shadows
    if cast.able.vampiricTouch() and debuff.vampiricTouch.refresh() and unit.ttd() >= 18 and (debuff.vampiricTouch.exists() or not var.vts_applied) and var.max_vts > 0 and not var.manual_vts_applied and not cast.inFlight.shadowCrash() or not talent.whispersShadows then
        cast.vampiricTouch()
    end
    -- # Use Shadow Crash to apply Vampiric Touch to as many adds as possible while being efficient with Vampiric Touch refresh windows
    -- actions.aoe+=/shadow_crash,if=!variable.holding_crash,target_if=dot.vampiric_touch.refreshable|dot.vampiric_touch.remains<=target.time_to_die&!buff.voidform.up&(raid_event.adds.in-dot.vampiric_touch.remains)<15
    if cast.able.shadowCrash() and not var.holding_crash and debuff.vampiricTouch.refresh() or debuff.vampiricTouch.remains() <= unit.ttd() and not buff.voidForm.exists() then
        cast.shadowCrash("best",nil,3,8)
    end
    -- actions.aoe+=/call_action_list,name=cds,if=fight_remains<30|target.time_to_die>15&(!variable.holding_crash|active_enemies>2)
    if unit.ttd() > 15 and (not var.holding_crash or #enemies.yards40 > 2) then
        actionList.cds()
    end
    -- # Use Shadowfiend or Mindbender on cooldown if DoTs are active and sync with Dark Ascension
    -- actions.aoe+=/mindbender,if=(dot.shadow_word_pain.ticking&variable.vts_applied|action.shadow_crash.in_flight&talent.whispering_shadows)&(fight_remains<30|target.time_to_die>15)&(!talent.dark_ascension|cooldown.dark_ascension.remains<gcd.max|fight_remains<15)
    if (cast.able.mindbender() or cast.able.shadowfiend()) and (debuff.shadowWordPain.exists() and var.vts_applied or cast.inFlight.shadowCrash() and talent.whispersShadows()) and (unit.ttd() > 15) and (not talent.darkAscension or cd.darkAscension.remains() < unit.gcd(true)) then
        if cast.able.mindbender() then
            cast.mindbender()
        else
            cast.shadowfiend()
        end
    end
    -- # Use Mind Blast when capped on charges and talented into Mind Devourer to fish for the buff or if Inescapable Torment is talented with Mindbender active. Only use when facing 3-7 targets.
    -- actions.aoe+=/mind_blast,if=(cooldown.mind_blast.full_recharge_time<=gcd.max+cast_time|pet.fiend.remains<=cast_time+gcd.max)&pet.fiend.active&talent.inescapable_torment&pet.fiend.remains>cast_time&active_enemies<=7&!buff.mind_devourer.up
    if cast.able.mindBlast() and (charges.mindBlast.timeTillFull() <= unit.gcd()+cast.time.mindBlast() or pet.active.exists) and not cd.mindbender.ready() and talent.inescapableTorment() and not cd.mindbender.ready() and #enemies.yards40 <= 7 and not buff.mindDevourer.exists() then
        cast.mindBlast()
    end
    -- # High Priority Shadow Word: Death is Mindbender is expiring in less than 2 seconds
    -- actions.aoe+=/shadow_word_death,if=pet.fiend.remains<=2&pet.fiend.active&talent.inescapable_torment&active_enemies<=7
    if cast.able.shadowWordDeath() and IsMindbenderActive() and talent.inescapableTorment and #enemies.yards40 <= 7 then
        cast.shadowWordDeath()
    end
    -- actions.aoe+=/void_bolt
    if cast.able.voidBolt() then
        cast.voidBolt()
    end
    -- # Use Devouring Plague to maximize uptime. Short circuit if you are capping on Insanity within 20 or to get out an extra Void Bolt by extending Voidform. With Distorted Reality can maintain more than one at a time in multi-target.
    -- actions.aoe+=/devouring_plague,target_if=remains<=gcd.max|!talent.distorted_reality,if=remains<=gcd.max&!variable.pool_for_cds|insanity.deficit<=20|buff.voidform.up&cooldown.void_bolt.remains>buff.voidform.remains&cooldown.void_bolt.remains<=buff.voidform.remains+2
    if cast.able.devouringPlague() and debuff.devouringPlague.remains() <= unit.gcd(true) or talent.distortedReality and var.pool_for_cds or insanityDeficit <= 20 or buff.voidForm.exists() and cd.voidBolt.remains() > buff.voidForm.remains() and cd.voidBolt.remains() <= buff.voidForm.remains()+2 then
        cast.devouringPlague()
    end
    -- actions.aoe+=/vampiric_touch,target_if=refreshable&target.time_to_die>=18&(dot.vampiric_touch.ticking|!variable.vts_applied),if=variable.max_vts>0&(cooldown.shadow_crash.remains>=dot.vampiric_touch.remains|variable.holding_crash)&!action.shadow_crash.in_flight|!talent.whispering_shadows
    if cast.able.vampiricTouch() and debuff.vampiricTouch.refresh() and unit.ttd() >= 18 and (debuff.vampiricTouch.exists() or not var.vts_applied) and var.max_vts > 0 and (cd.shadowCrash.remains() >= dot.vampiricTouch.remains() or var.holding_crash) and not cast.inFlight.shadowCrash() or not talent.whispersShadows then
        cast.vampiricTouch()
    end
    -- # Use Shadow Word: Death with Inescapable Torment and Mindbender active and not talented into Insidious Ire and Yogg or Deathspeaker is active
    -- actions.aoe+=/shadow_word_death,if=variable.vts_applied&talent.inescapable_torment&pet.fiend.active&((!talent.insidious_ire&!talent.idol_of_yoggsaron)|buff.deathspeaker.up)
    if cast.able.shadowWordDeath() and var.vts_applied and talent.inescapableTorment and IsMindbenderActive() and ((not talent.insidiousIre and not talent.idolOfYoggsaron) or buff.deathspeaker.exists()) then
        cast.shadowWordDeath()
    end
    -- # High Priority Mind Spike: Insanity to fish for C'Thun procs when Mind Blast is not capped and Void Torrent is not available and Mindbender is not active
    -- actions.aoe+=/mind_spike_insanity,if=variable.dots_up&cooldown.mind_blast.full_recharge_time>=gcd*3&talent.idol_of_cthun&(!cooldown.void_torrent.up|!talent.void_torrent)
    if cast.able.mindSpikeInsanity() and var.dots_up and charges.mindBlast.timeTillFull() >= unit.gcd()*3 and talent.idolOfCthun and (not cd.voidTorrent.exists() or not talent.voidTorrent) then
        cast.mindSpikeInsanity()
    end
    -- # High Priority Mind Flay: Insanity to fish for C'Thun procs when Mind Blast is not capped and Void Torrent is not available and Mindbender is not active
    -- actions.aoe+=/mind_flay,if=buff.mind_flay_insanity.up&variable.dots_up&cooldown.mind_blast.full_recharge_time>=gcd*3&talent.idol_of_cthun&(!cooldown.void_torrent.up|!talent.void_torrent)
    if cast.able.mindFlay() and buff.mindFlayInsanity.exists() and var.dots_up and charges.mindBlast.timeTillFull() >= unit.gcd()*3 and talent.idolOfCthun and (not cd.voidTorrent.exists() or not talent.voidTorrent) then
        cast.mindFlay()
    end
    -- # # Use all charges of Mind Blast if Vampiric Touch and Shadow Word: Pain are active and Mind Devourer is not active or you are prepping Void Eruption
    -- actions.aoe+=/mind_blast,if=variable.vts_applied&(!buff.mind_devourer.up|cooldown.void_eruption.up&talent.void_eruption)
    if cast.able.mindBlast() and var.vts_applied and (not buff.mindDevourer.exists() or cd.voidEruption.ready() and talent.voidEruption) then
        cast.mindBlast()
    end
    -- # Void Torrent action list for AoE
    -- actions.aoe+=/call_action_list,name=pl_torrent,target_if=talent.void_torrent&talent.psychic_link&cooldown.void_torrent.remains<=3&(!variable.holding_crash|raid_event.adds.count%(active_dot.vampiric_touch+raid_event.adds.count)<1.5)&((insanity>=50|dot.devouring_plague.ticking|buff.dark_reveries.up)|buff.voidform.up|buff.dark_ascension.up)
    if talent.voidTorrent and talent.psychicLink and cd.voidTorrent.remains() <= 3 and (not var.holding_crash) and ((insanity >= 50 or debuff.devouringPlague.exists() or buff.darkReveries) or buff.voidForm.exists() or buff.darkAscension.exists()) then
        actionList.pl_torrent()
    end
    -- actions.aoe+=/void_torrent,if=!talent.psychic_link,target_if=variable.dots_up
    if cast.able.voidTorrent() and not talent.psychicLink and var.dots_up then
        cast.voidTorrent()
    end
    -- # High priority action for Mind Flay: Insanity to fish for Idol of C'Thun procs, cancel as soon as something else is more important and most of the channel has completed
    -- actions.aoe+=/mind_flay,if=buff.mind_flay_insanity.up&talent.idol_of_cthun,interrupt_if=ticks>=2,interrupt_immediate=1
    if cast.able.mindFlay() and buff.mindFlayInsanity.exists() and talent.idolOfCthun then
        cast.mindFlay()
    end
    -- actions.aoe+=/call_action_list,name=filler
    actionList.filler()
end

actionList.pl_torrent = function()
    -- actions.pl_torrent=void_bolt
    if cast.able.voidBolt() then
        cast.voidBolt()
    end
    -- actions.pl_torrent+=/vampiric_touch,if=remains<=6&cooldown.void_torrent.remains<gcd*2
    if cast.able.vampiricTouch() and debuff.vampiricTouch.remains() <= 6 and cd.voidTorrent.remains() < unit.gcd()*2 then
        cast.vampiricTouch()
    end
    -- actions.pl_torrent+=/devouring_plague,if=remains<=4&cooldown.void_torrent.remains<gcd*2
    if cast.able.devouringPlague() and debuff.devouringPlague.remains() <= 4 and cd.voidTorrent.remains() < unit.gcd() * 2 then
        cast.devouringPlague()
    end
    -- actions.pl_torrent+=/mind_blast,if=!prev_gcd.1.mind_blast
    if cast.able.mindBlast() and not cast.last.mindBlast(1) then
        cast.mindBlast()
    end
    -- actions.pl_torrent+=/void_torrent,if=dot.vampiric_touch.ticking&dot.shadow_word_pain.ticking|buff.voidform.up
    if cast.able.voidTorrent() and debuff.vampiricTouch.exists() and debuff.shadowWordPain.exists() or buff.voidForm.exists() then
        cast.voidTorrent()
    end
end

actionList.main = function()
    -- actions.main=call_action_list,name=main_variables
    actionList.main_variables()
    -- actions.main+=/call_action_list,name=cds,if=fight_remains<30|target.time_to_die>15&(!variable.holding_crash|active_enemies>2)
    if unit.ttd() > 15 then
        actionList.cds()
    end
    -- actions.main+=/mindbender,if=variable.dots_up&(fight_remains<30|target.time_to_die>15)&(!talent.dark_ascension|cooldown.dark_ascension.remains<gcd.max|fight_remains<15)
    if cast.able.mindbender() and var.dots_up and (unit.ttd() > 15) and (not talent.darkAscension or cd.darkAscension.remains() < unit.gcd(true)) then
        cast.mindbender()
    end
    -- actions.main+=/devouring_plague,target_if=!talent.distorted_reality|active_enemies=1|remains<=gcd.max,if=remains<=gcd.max|insanity.deficit<=16
    if cast.able.devouringPlague() and not talent.distortedReality or #enemies.yards40 == 1 or debuff.devouringPlague.remains() <= unit.gcd(true) and debuff.devouringPlague.remains() <= unit.gcd(true) or insanityDeficit <= 16 then
        cast.devouringPlague()
    end
    -- actions.main+=/shadow_word_death,if=(set_bonus.tier31_4pc|pet.fiend.active&talent.inescapable_torment&set_bonus.tier31_2pc)&dot.devouring_plague.ticking
    if cast.able.shadowWordDeath() and (equiped.tier(31) >= 4 or IsShadowfiendActive() and not talent.inescapableTorment and equiped.tier(31) >= 2) and debuff.devouringPlague.exists() then
        cast.shadowWordDeath()
    end
    -- actions.main+=/mind_blast,target_if=dot.devouring_plague.remains>execute_time&(cooldown.mind_blast.full_recharge_time<=gcd.max+execute_time)|pet.fiend.remains<=execute_time+gcd.max,if=pet.fiend.active&talent.inescapable_torment&pet.fiend.remains>execute_time&active_enemies<=7
    if cast.able.mindBlast() and debuff.devouringPlague.remains() > cast.time.mindBlast() and (charges.mindBlast.timeTillFull <= unit.gcd(true)+cast.time.mindBlast()) or cd.shadowFiend.remains() <= cast.time.mindBlast() + unit.gcd(true) and IsShadowfiendActive() and talent.inescapableTorment and cd.shadowFiend.remains() - 45 > cast.time.mindBlast() and #enemies.yards40 < 7 then
        cast.mindBlast()
    end
    -- actions.main+=/shadow_word_death,target_if=dot.devouring_plague.ticking&pet.fiend.remains<=2&pet.fiend.active&talent.inescapable_torment&active_enemies<=7
    if cast.able.shadowWordDeath() and debuff.devouringPlague.exists() and cd.shadowFiend.remains() - 45 <= 2 and IsShadowfiendActive() and talent.inescapableTorment and #enemies.yards40 <= 7 then
        cast.shadowWordDeath()
    end
    -- actions.main+=/void_bolt,if=variable.dots_up
    if cast.able.voidBolt() and var.dots_up then
        cast.voidBolt()
    end
    -- actions.main+=/devouring_plague,if=fight_remains<=duration+4
    -- actions.main+=/devouring_plague,target_if=!talent.distorted_reality|active_enemies=1|remains<=gcd.max,if=(remains<=gcd.max|remains<3&cooldown.void_torrent.up)|insanity.deficit<=20|buff.voidform.up&cooldown.void_bolt.remains>buff.voidform.remains&cooldown.void_bolt.remains<=buff.voidform.remains+2|buff.mind_devourer.up&pmultiplier<1.2
    if cast.able.devouringPlague() and not talent.distortedReality or #enemies.yards40 == 1 or debuff.devouringPlague.remains() <= unit.gcd(true) and (debuff.devouringPlague.remains() <= unit.gcd(true) or debuff.devouringPlague.remains() <3 and cd.voidTorrent.ready()) or insanityDeficit <= 20 or buff.voidForm.exists() and cd.voidBolt.remains() > buff.voidForm.remains() and cd.voidBolt.remains() <= buff.voidForm.remains() +2 or buff.mindDevourer.exists() and debuff.devouringPlague.applied(units.dyn5) < 1.6 then
        cast.devouringPlague()
    end
    -- actions.main+=/shadow_word_death,if=set_bonus.tier31_2pc
    if cast.able.shadowWordDeath() and equiped.tier(31) >= 2 then
        cast.shadowWordDeath()
    end
    -- actions.main+=/shadow_crash,if=!variable.holding_crash&(dot.vampiric_touch.refreshable|buff.deaths_torment.stack>9&set_bonus.tier31_4pc)
    if cast.able.shadowCrash("best",nil,1,8) and not var.holdingCrash and (debuff.vampiricTouch.refreshable() or buff.deathsTorment.stack() > 9 and equiped.tier(31) >= 4) then
        cast.shadowCrash()
    end
    -- actions.main+=/shadow_word_pain,if=buff.deaths_torment.stack>9&set_bonus.tier31_4pc&(!variable.holding_crash|!talent.shadow_crash)
    if cast.able.shadowWordPain() and buff.deathsTorment.stack() > 9 and equiped.tier(31) >= 4 and (not var.holdingCrash or not talent.shadowCrash) then
        cast.shadowWordPain()
    end
    -- actions.main+=/shadow_word_death,if=variable.dots_up&talent.inescapable_torment&pet.fiend.active&((!talent.insidious_ire&!talent.idol_of_yoggsaron)|buff.deathspeaker.up)&!set_bonus.tier31_2pc
    if cast.able.shadowWordDeath() and var.dots_up and talent.inescapableTorment and IsShadowfiendActive() and ((not talent.insidiousIre and not talent.idolOfYoggsaron) or buff.deathspeaker.exists() and not equiped.tier(31) >= 2) then
        cast.shadowWordDeath()
    end
    -- actions.main+=/vampiric_touch,target_if=min:remains,if=refreshable&target.time_to_die>=12&(cooldown.shadow_crash.remains>=dot.vampiric_touch.remains&!action.shadow_crash.in_flight|variable.holding_crash|!talent.whispering_shadows)
    if cast.able.vampiricTouch() and debuff.vampiricTouch.refreshable() and unit.ttd() >= 12 and (cd.shadowCrash.remains() >= debuff.vampiricTouch.remains() and not cast.inFlight.shadowCrash or var.holdingCrash or not talent.whisperingShadows) then
        cast.vampiricTouch()
    end
    -- actions.main+=/mind_blast,if=(!buff.mind_devourer.up|cooldown.void_eruption.up&talent.void_eruption)
    if cast.able.mindBlast() and (not buff.mindDevourer.exists() or cd.voidEruption.ready() and talent.voidEruption) then
        cast.mindBlast()
    end
    -- actions.main+=/void_torrent,if=!variable.holding_crash,target_if=dot.devouring_plague.remains>=2.5,interrupt_if=cooldown.shadow_word_death.ready&pet.fiend.active&set_bonus.tier31_2pc
    if cast.able.voidTorrent() and not var.holdingCrash and debuff.devouringPlague.remains() >= 2.5 then
        cast.voidTorrent()
    end
    -- actions.main+=/call_action_list,name=filler
    actionList.filler()
end

actionList.main_variables = function()
    -- actions.main_variables=variable,name=dots_up,op=set,value=(dot.shadow_word_pain.ticking&dot.vampiric_touch.ticking)|action.shadow_crash.in_flight&talent.whispering_shadows
    var.dots_up = (debuff.shadowWordPain.exists() and debuff.vampiricTouch.exists) or cast.inFlight.shadowCrash and talent.whisperingShadows
    -- actions.main_variables+=/variable,name=all_dots_up,op=set,value=dot.shadow_word_pain.ticking&dot.vampiric_touch.ticking&dot.devouring_plague.ticking
    var.all_dots_up = debuff.shadowWordPain.exists() and debuff.vampiricTouch.exists() and debuff.devouringPlague.exists()
    -- actions.main_variables+=/variable,name=pool_for_cds,op=set,value=(cooldown.void_eruption.remains<=gcd.max*3&talent.void_eruption|cooldown.dark_ascension.up&talent.dark_ascension)|talent.void_torrent&talent.psychic_link&cooldown.void_torrent.remains<=4&(!raid_event.adds.exists&spell_targets.vampiric_touch>1|raid_event.adds.in<=5|raid_event.adds.remains>=6&!variable.holding_crash)&!buff.voidform.up
    var.pool_for_cds = (cd.voidEruption.remains() <= unit.gcd(true)*3 and talent.voidEruption or cd.darkAscension.ready() and talent.darkAscension) or talent.voidTorrent and talent.psychicLink and cd.voidTorrent.remains() <= 4 and not buff.voidForm.exists()
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
    cd                                            = br.player.cd
    charges                                         = br.player.charges
    debuff                                        = br.player.debuff
    enemies                                     = br.player.enemies
    has                                           = br.player.has
    mode                                          = br.player.ui.mode
    ui                                            = br.player.ui
    pet                                           = br.player.pet
    spell                                         = br.player.spell
talent                                            = br.player.talent
    ui                                            = br.player.ui
    equiped = br.player.equiped
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    insanityDeficit = br.player.power.insanity.deficit()
    insanity = br.player.power.insanity.amount()
    var = br.player.variables
    -- General Locals
    profileStop                                   = profileStop or false
    haltProfile                                   = (unit.inCombat() and profileStop) or IsMounted() or br.pause() or mode.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40,true)
    -- Enemies
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    enemies.get(10)
    enemies.get(30)
    enemies.get(40) -- Makes a varaible called, enemies.yards40

    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = GetTime() end

    if br.IsMovingTime(1) then
        if talent.angelicFeather and not buff.angelicFeather.exists("player") then
            cast.angelicFeather("player")
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        br.pauseTime = GetTime()
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
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
        if unit.valid("target") and cd.global.remain() == 0 then
            if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                ------------------------------
                --- In Combat - Interrupts ---
                ------------------------------
                -- Start Attack
                -- actions=auto_attack
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    br._G.StartAttack(units.dyn5)
                end
                -- actions=variable,name=holding_crash,op=set,value=raid_event.adds.in<15
                var.holding_crash = false
                -- actions+=/variable,name=pool_for_cds,op=set,value=(cooldown.void_eruption.remains<=gcd.max*3&talent.void_eruption|cooldown.dark_ascension.up&talent.dark_ascension)|talent.void_torrent&talent.psychic_link&cooldown.void_torrent.remains<=4&(!raid_event.adds.exists&spell_targets.vampiric_touch>1|raid_event.adds.in<=5|raid_event.adds.remains>=6&!variable.holding_crash)&!buff.voidform.up
                var.pool_for_cds = (cd.voidEruption.remains() <= unit.gcd(true)*3 and talent.voidEruption or cd.darkAscension.ready() and talent.darkAscension) or talent.voidTorrent and talent.psychicLink and cd.voidTorrent.remains() <= 4 and not buff.voidForm.exists()
                -- actions+=/run_action_list,name=aoe,if=active_enemies>2|spell_targets.vampiric_touch>3
                if #enemies.yards40 >= 3 then
                    actionList.aoe()
                end
                -- actions+=/run_action_list,name=main
                actionList.main()
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 258 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
}) 
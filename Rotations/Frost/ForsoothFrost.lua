local rotationName = "ForsoothFrost"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.runeStrike },
        [2] = {  mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.runeStrike }
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.deathStrike },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.deathStrike }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupt Enabled", tip = "Enabled Interrupt", highlight = 1, icon = br.player.spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupt Disabled", tip = "Disable Interrupt", highlight = 0, icon = br.player.spell.mindFreeze }
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
            -- Death Grip
            br.ui:createCheckbox(section, "Death Grip")
            -- Trinkets
            br.ui:createCheckbox(section, "Trinkets")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Anti-Magic Shell
            br.ui:createSpinner(section, "Anti-Magic Shell", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Death Strike
            br.ui:createSpinner(section, "Death Strike", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupt")
            -- Death Grip
            br.ui:createCheckbox(section, "Death Grip - Int")
            -- Mind Freeze
            br.ui:createCheckbox(section, "Mind Freeze")
            -- "Interrupt At"
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At (0 is random)")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupt Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
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
local cast
local cd
local enemies
local module
local runes
local runicPower
local runicPowerDeficit
local ui
local unit
local units
local use
-- Profile Specific Locals
local actionList = {}
local var = {}
local talent
local buff
local debuff
local equiped
var.haltProfile = false
var.profileStop = false
local pet

--------------------
--- Action Lists ---
--------------------
-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Anti-Magic Shell
        if ui.checked("Anti-Magic Shell") and cast.able.antiMagicShell() and unit.hp() < ui.value("Anti-Magic Shell") then
            if cast.antiMagicShell() then ui.debug("Casting Anti-Magic Shell") return true end
        end
        -- Death Strike
        if ui.checked("Death Strike") and cast.able.deathStrike() and unit.hp() < ui.value("Death Strike") then
            if cast.deathStrike() then ui.debug("Casting Death Strike") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        -- Mind Freeze
        if ui.checked("Mind Freeze") and cast.able.mindFreeze() then
            for i=1, #enemies.yards15 do
                local thisUnit = enemies.yards15[i]
                if br.canInterrupt(thisUnit,ui.value("Interrupt At")) then
                    if cast.mindFreeze(thisUnit) then ui.debug("Casting Mind Freeze") return true end
                end
            end
        end
        --Death Grip
        if ui.checked("Death Grip (Interrupt)") and cast.able.deathGrip() then
            for i = 1,  #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if br.canInterrupt(thisUnit,ui.value("Interrupt At")) and unit.distance(thisUnit) > 8 then
                    if cast.deathGrip(thisUnit) then ui.debug("Casting Death Grip [Int]") return true end
                end
            end
        end
    end
end-- End Action List - Interrupts

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Death Grip
            if ui.checked("Death Grip") and cast.able.deathGrip("target") and not unit.isDummy("target")
                and unit.distance("target") > 8 and unit.distance("target") < 30
            then
                if cast.deathGrip("target") then ui.debug("Casting Death Grip [Pull]") return true end
            end
            -- Start Attack
            -- actions=auto_attack
            if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                br._G.StartAttack(units.dyn5)
            end
            -- 	variable,name=rw_buffs,value=talent.gathering_storm|talent.everfrost
            var.rw_buffs = talent.gatheringStorm or talent.everfrost
            -- 	variable,name=2h_check,value=main_hand.2h
            var.twoh_check = true
            -- actions.precombat+=/variable,name=erw_pooling_time,op=setif,value=25,value_else=45,condition=death_knight.ams_absorb_percent>0.59
            var.erw_pooling_time = 25
        end
    end
end -- End Action List - PreCombat

actionList.variables = function()
    -- actions.variables=variable,name=st_planning,value=active_enemies=1&(raid_event.adds.in>15|!raid_event.adds.exists)
    if #enemies.yards5 == 1 then
        var.st_planning = 1
    else
        var.st_planning = 0
    end
    -- actions.variables+=/variable,name=adds_remain,value=active_enemies>=2&(!raid_event.adds.exists|raid_event.adds.exists&raid_event.adds.remains>5)
    if #enemies.yards5 >= 2 then
        var.adds_remain = 1
    else
        var.adds_remain = 0
    end
    -- variable,name=rime_buffs,value=buff.rime.react&(talent.rage_of_the_frozen_champion|talent.avalanche|talent.icebreaker)
    var.rime_buffs = buff.rime.exists() and (talent.rageOfTheFrozenChampion or talent.avalanche or talent.icebreaker)
    -- variable,name=frostscythe_priority,value=talent.frostscythe&(buff.killing_machine.react|active_enemies>=3)&(!talent.improved_obliterate&!talent.frigid_executioner&!talent.frostreaper&!talent.might_of_the_frozen_wastes|!talent.cleaving_strikes|talent.cleaving_strikes&(active_enemies>6|!death_and_decay.ticking&active_enemies>3))
    var.frostscythe_priority = talent.frostscythe and (buff.killingMachine.exists() or #enemies.yards5 >= 3) and (not talent.improvedObliterate and not talent.frigidExecutioner and not talent.frostReaper and not talent.mightOfTheFrozenWastes or not talent.cleavingStrikes or talent.cleavingStrikes and (#enemies.yards5 > 6 or not buff.deathAndDecay.exists() and #enemies.yards5 > 3))
    -- variable,name=oblit_pooling_time,op=setif,value=((cooldown.pillar_of_frost.remains_expected+1)%gcd.max)%((rune+3)*(runic_power+5))*100,value_else=3,condition=runic_power<35&rune<2&cooldown.pillar_of_frost.remains_expected<10
    if runicPower < 35 and runes < 2 and cd.pillarOfFrost.remains() < 10 then
        var.oblit_pooling_time = 3
    else
        var.oblit_pooling_time = ((cd.pillarOfFrost.remains()+1)%unit.gcd())%((runes+3)*(runicPower+5))*100
    end
    -- variable,name=breath_pooling_time,op=setif,value=((cooldown.breath_of_sindragosa.remains+1)%gcd.max)%((rune+1)*(runic_power+20))*100,value_else=3,condition=runic_power.deficit>10&cooldown.breath_of_sindragosa.remains<10
    if runicPowerDeficit > 10 and cd.breathOfSindragosa.remains() < 10 then
        var.breath_pooling_time = 3
    else
        var.breath_pooling_time = ((cd.breathOfSindragosa.remains()+1)%unit.gcd())%((runes+1)*(runicPower+20))*100
    end
    -- actions.variables+=/variable,name=pooling_runes,value=rune<4&talent.obliteration&cooldown.pillar_of_frost.remains_expected<variable.oblit_pooling_time
    var.pooling_runes = runes < 4 and talent.obliteration and cd.pillarOfFrost.remains() < var.oblit_pooling_time
    -- variable,name=pooling_runic_power,value=talent.breath_of_sindragosa&cooldown.breath_of_sindragosa.remains<variable.breath_pooling_time|talent.obliteration&runic_power<35&cooldown.pillar_of_frost.remains_expected<variable.oblit_pooling_time
    var.pooling_runic_power = talent.breathOfSindragosa and cd.breathOfSindragosaActive.remains() < var.breath_pooling_time or talent.obliteration and runicPower < 35 and cd.pillarOfFrost.remains() < var.oblit_pooling_time
end

actionList.high_prio_actions = function()
    -- actions.high_prio_actions+=/mind_freeze,if=target.debuff.casting.react
    actionList.Interrupts()
    -- actions.high_prio_actions+=/antimagic_shell,if=runic_power.deficit>40
    if cast.able.antiMagicShell() and runicPowerDeficit > 40 then
        cast.antiMagicShell()
    end
    -- actions.high_prio_actions+=/antimagic_zone,if=!death_knight.amz_specified&(death_knight.amz_absorb_percent>0&runic_power.deficit>70&talent.assimilation&(buff.breath_of_sindragosa.up|cooldown.breath_of_sindragosa.ready|!talent.breath_of_sindragosa&!buff.pillar_of_frost.up))
    -- actions.high_prio_actions+=/antimagic_zone,if=death_knight.amz_specified&buff.amz_timing.up
    -- actions.high_prio_actions+=/howling_blast,if=!dot.frost_fever.ticking&active_enemies>=2&(!talent.obliteration|talent.obliteration&(!cooldown.pillar_of_frost.ready|buff.pillar_of_frost.up&!buff.killing_machine.react))
    if cast.able.howlingBlast() and not debuff.frostFever.exists() and #enemies.yards5 >= 2 and (not talent.obliteration or talent.obliteration and (not cd.pillarOfFrost.ready() or buff.pillarOfFrost.exists() and not buff.killingMachine.exists())) then
        cast.howlingBlast()
    end
    -- actions.high_prio_actions+=/glacial_advance,if=active_enemies>=2&variable.rp_buffs&talent.obliteration&talent.breath_of_sindragosa&!buff.pillar_of_frost.up&!buff.breath_of_sindragosa.up&cooldown.breath_of_sindragosa.remains>variable.breath_pooling_time
    if cast.able.glacialAdvance() and #enemies.yards5 >= 2 and var.rp_buffs and talent.obliteration and talent.breathOfSindragosa and not buff.pillarOfFrost.exists() and not buff.breathOfSindragosa.exists() and cd.breathOfSindragosa.remains() > var.breath_pooling_time then
        cast.glacialAdvance()
    end
    -- actions.high_prio_actions+=/glacial_advance,if=active_enemies>=2&variable.rp_buffs&talent.breath_of_sindragosa&!buff.breath_of_sindragosa.up&cooldown.breath_of_sindragosa.remains>variable.breath_pooling_time
    if cast.able.glacialAdvance() and #enemies.yards5 >= 2 and var.rp_buffs and talent.breathOfSindragosa.exists() and not buff.breathOfSindragosa.exists() and cd.breathOfSindragosa.remains() > var.breath_pooling_time then
        cast.glacialAdvance()
    end
    -- actions.high_prio_actions+=/glacial_advance,if=active_enemies>=2&variable.rp_buffs&!talent.breath_of_sindragosa&talent.obliteration&!buff.pillar_of_frost.up
    if cast.able.glacialAdvance() and #enemies.yards5 >= 2 and var.rp_buffs and not talent.breathOfSindragosa and talent.obliteration and not buff.pillarOfFrost.exists() then
        cast.glacialAdvance()
    end
    -- actions.high_prio_actions+=/frost_strike,if=active_enemies=1&variable.rp_buffs&talent.obliteration&talent.breath_of_sindragosa&!buff.pillar_of_frost.up&!buff.breath_of_sindragosa.up&-- cooldown.breath_of_sindragosa.remains>variable.breath_pooling_time
    if cast.able.frostStrike() and #enemies.yards5 == 1 and var.rp_buffs and talent.obliteration and talent.breathOfSindragosa and not buff.pillarOfFrost.exists() and not buff.breathOfSindragosa.exists() and cd.breathOfSindragosa.remains() > var.breath_pooling_time then
        cast.frostStrike()
    end
    -- actions.high_prio_actions+=/frost_strike,if=active_enemies=1&variable.rp_buffs&talent.breath_of_sindragosa&!buff.breath_of_sindragosa.up&cooldown.breath_of_sindragosa.remains>variable.breath_pooling_time
    if cast.able.frostStrike() and #enemies.yards5 == 1 and var.rp_buffs and talent.breathOfSindragosa and not buff.breathOfSindragosa.exists() and cd.breathOfSindragosa.remains() > var.breath_pooling_time then
        cast.frostStrike()
    end
    -- actions.high_prio_actions+=/frost_strike,if=active_enemies=1&variable.rp_buffs&!talent.breath_of_sindragosa&talent.obliteration&!buff.pillar_of_frost.up
    if cast.able.frostStrike() and #enemies.yards5 == 1 and var.rp_buffs and not talent.breathOfSindragosa and talent.obliteration and not buff.pillarOfFrost.exists() then
        cast.frostStrike()
    end
    -- actions.high_prio_actions+=/remorseless_winter,if=variable.rw_buffs|variable.adds_remain
    if cast.able.remorselessWinter() and var.rw_buffs or var.adds_remain then
        cast.remorselessWinter()
    end
end

actionList.cooldowns = function()
    -- actions.cooldowns=potion,if=variable.cooldown_check|fight_remains<25
    -- actions.cooldowns+=/empower_rune_weapon,if=talent.obliteration&!buff.empower_rune_weapon.up&rune<6&(cooldown.pillar_of_frost.remains_expected<7&(variable.adds_remain|variable.st_planning)|buff.pillar_of_frost.up)|fight_remains<20
    if cast.able.empowerRuneWeapon() and talent.obliteration and not buff.empowerRuneWeapon.exists() and runes < 6 and (cd.pillarOfFrost.remains() < 7 and (var.adds_remain or var.st_planning) or buff.pillarOfFrost.exists()) or unit.ttd() < 20 then
        cast.empowerRuneWeapon()
    end
    -- actions.cooldowns+=/empower_rune_weapon,use_off_gcd=1,if=buff.breath_of_sindragosa.up&!buff.empower_rune_weapon.up&(time<10&buff.bloodlust.up)|(runic_power<70&rune<3&(cooldown.breath_of_sindragosa.remains>variable.erw_pooling_time|full_recharge_time<10))
    if cast.able.empowerRuneWeapon() and buff.breathOfSindragosa.exists() and not buff.empowerRuneWeapon.exists() and (unit.combatTime() < 10 and buff.bloodLust.exists()) or (runicPower < 70 and runes<3 and (cd.breathOfSindragosa.remains() > var.erw_pooling_time or cd.breathOfSindragosa.remains() < 10)) then
        cast.empowerRuneWeapon()
    end
    -- actions.cooldowns+=/empower_rune_weapon,use_off_gcd=1,if=!talent.breath_of_sindragosa&!talent.obliteration&!buff.empower_rune_weapon.up&rune<5&(cooldown.pillar_of_frost.remains_expected<7|buff.pillar_of_frost.up|!talent.pillar_of_frost)
    if cast.able.empowerRuneWeapon() and not talent.breathOfSindragosa() and not talent.obliteration and not buff.empowerRuneWeapon.exists() and runes < 5 and (cd.pillarOfFrost.remains() < 7 or buff.pillarOfFrost.exists() or not talent.pillarOfFrost()) then
        cast.empowerRuneWeapon()
    end
    -- actions.cooldowns+=/abomination_limb,if=talent.obliteration&!buff.pillar_of_frost.up&cooldown.pillar_of_frost.remains<3&(variable.adds_remain|variable.st_planning)|fight_remains<12
    if cast.able.abominationLimb() and talent.obliteration and not buff.pillarOfFrost.exists() and cd.pillarOfFrost.remains() < 3 and (var.adds_remain or var.st_planning) or unit.ttd() < 12 then
        cast.abominationLimb()
    end
    -- actions.cooldowns+=/abomination_limb,if=talent.breath_of_sindragosa&(variable.adds_remain|variable.st_planning)
    if cast.able.abominationLimb() and talent.breathOfSindragosa and (var.adds_remain or var.st_planning) then
        cast.abominationLimb()
    end
    -- actions.cooldowns+=/abomination_limb,if=!talent.breath_of_sindragosa&!talent.obliteration&(variable.adds_remain|variable.st_planning)
    if cast.able.abominationLimb() and not talent.breathOfSindragosa and not talent.obliteration and (var.adds_remain or var.st_planning) then
        cast.abominationLimb()
    end
    -- actions.cooldowns+=/chill_streak,if=set_bonus.tier31_2pc
    if cast.able.chillStreak() and equiped.tier(31) >= 2 then
        cast.chillStreak()
    end
    -- actions.cooldowns+=/chill_streak,if=!set_bonus.tier31_2pc&active_enemies>=2&(!death_and_decay.ticking&talent.cleaving_strikes|!talent.cleaving_strikes|active_enemies<=5)
    if cast.able.chillStreak() and equiped.tier(31) < 2 and #enemies.yards5 >=2 and (not buff.deathAndDecay.exists() and talent.cleavingStrikes or not talent.cleavingStrikes or #enemies.yards5 <= 5) then
        cast.chillStreak()
    end
    -- actions.cooldowns+=/pillar_of_frost,if=talent.obliteration&(variable.adds_remain|variable.st_planning)&(buff.empower_rune_weapon.up|cooldown.empower_rune_weapon.remains)|fight_remains<12
    if cast.able.pillarOfFrost() and talent.obliteration and (var.adds_remain or var.st_planning) and (buff.empowerRuneWeapon.exists() or cd.empowerRuneWeapon.remains()) then
        cast.pillarOfFrost()
    end
    -- actions.cooldowns+=/pillar_of_frost,if=talent.breath_of_sindragosa&(variable.adds_remain|variable.st_planning)&(!talent.icecap&(runic_power>70|cooldown.breath_of_sindragosa.remains>40)|talent.icecap&(cooldown.breath_of_sindragosa.remains>10|buff.breath_of_sindragosa.up))
    if cast.able.pillarOfFrost() and talent.breathOfSindragosa and (var.adds_remain or var.st_planning) and (not talent.icecap and (runicPower > 70 or cd.breathOfSindragosa.remains() > 40 ) or talent.icecap and (cd.breathOfSindragosa.remains() > 10 or buff.breathOfSindragosa.exists())) then
        cast.pillarOfFrost()
    end
    -- actions.cooldowns+=/pillar_of_frost,if=talent.icecap&!talent.obliteration&!talent.breath_of_sindragosa&(variable.adds_remain|variable.st_planning)
    if cast.able.pillarOfFrost() and talent.icecap and not talent.obliteration and not talent.breathOfSindragosa and (var.adds_remain or var.st_planning) then
        cast.pillarOfFrost()
    end
    -- actions.cooldowns+=/breath_of_sindragosa,if=!buff.breath_of_sindragosa.up&runic_power>60&(variable.adds_remain|variable.st_planning)|fight_remains<30
    if cast.able.breathOfSindragosa() and not buff.breathOfSindragosa.exists() and runicPower > 60 and (var.adds_remain or var.st_planning) or unit.ttd() < 30 then
        cast.breathOfSindragosa()
    end
    -- actions.cooldowns+=/frostwyrms_fury,if=active_enemies=1&(talent.pillar_of_frost&buff.pillar_of_frost.remains<gcd*2&buff.pillar_of_frost.up&!talent.obliteration|!talent.pillar_of_frost)&(!raid_event.adds.exists|(raid_event.adds.in>15+raid_event.adds.duration|talent.absolute_zero&raid_event.adds.in>15+raid_event.adds.duration))|fight_remains<3
    if cast.able.frostwyrmsFury() and #enemies.yards5 == 1 and (talent.pillarOfFrost and buff.pillarOfFrost.remains() < unit.gcd()*2 and buff.pillarOfFrost.exists() and not talent.obliteration or not talent.pillarOfFrost) or unit.ttd() < 3 then
        cast.frostwyrmsFury()
    end
    -- actions.cooldowns+=/frostwyrms_fury,if=active_enemies>=2&(talent.pillar_of_frost&buff.pillar_of_frost.up|raid_event.adds.exists&raid_event.adds.up&raid_event.adds.in>cooldown.pillar_of_frost.remains_expected-raid_event.adds.in-raid_event.adds.duration)&(buff.pillar_of_frost.remains<gcd*2|raid_event.adds.exists&raid_event.adds.remains<gcd*2)
    if cast.able.frostwyrmsFury() and #enemies.yards5 >= 2 and (talent.pillarOfFrost and buff.pillarOfFrost.exists()) and (buff.pillarOfFrost.remains() < unit.gcd()*2) then
        cast.frostwyrmsFury()
    end
    -- actions.cooldowns+=/frostwyrms_fury,if=talent.obliteration&(talent.pillar_of_frost&buff.pillar_of_frost.up&!variable.2h_check|!buff.pillar_of_frost.up&variable.2h_check&cooldown.pillar_of_frost.remains|!talent.pillar_of_frost)&((buff.pillar_of_frost.remains<gcd|buff.unholy_strength.up&buff.unholy_strength.remains<gcd)&(debuff.razorice.stack=5|!death_knight.runeforge.razorice&!talent.glacial_advance))
    if cast.able.frostwyrmsFury() and talent.obliteration and (talent.pillarOfFrost and buff.pillarOfFrost.exists() and not var.twoh_check or not buff.pillarOfFrost.exists() and var.twoh_check and cd.pillarOfFrost.remains() or not talent.pillarOfFrost) and ((buff.pillarOfFrost.remains() < unit.gcd() or buff.unholyStrength.exists() and buff.unholyStrength.remains()<unit.gcd()) and (debuff.razorice.stack() == 5 or not var.razorice and not talent.glacialAdvance)) then
        cast.frostwyrmsFury()
    end
    -- actions.cooldowns+=/raise_dead
    if cast.able.raiseDead() then
        cast.raiseDead()
    end
    -- actions.cooldowns+=/soul_reaper,if=fight_remains>5&target.time_to_pct_35<5&active_enemies<=2&(talent.obliteration&(buff.pillar_of_frost.up&!buff.killing_machine.react|!buff.pillar_of_frost.up)|talent.breath_of_sindragosa&(buff.breath_of_sindragosa.up&runic_power>40|!buff.breath_of_sindragosa.up)|!talent.breath_of_sindragosa&!talent.obliteration)
    if cast.able.soulReaper() and unit.ttd() > 5 and unit.ttd("target",35) < 5 and #enemies.yards5 <= 2 and (talent.obliteration and (buff.pillarOfFrost.exists() and not buff.killingMachine.exists() or not buff.pillarOfFrost.exists()) or talent.breathOfSindragosa and (buff.breathOfSindragosa.exists() and runicPower > 40 or not buff.breathOfSindragosa.exists()) or not talent.breathOfSindragosa and not talent.obliteration) then
        cast.soulReaper()
    end
    -- actions.cooldowns+=/sacrificial_pact,if=!talent.glacial_advance&!buff.breath_of_sindragosa.up&pet.ghoul.remains<gcd*2&active_enemies>3
    if cast.able.sacrificialPact and not talent.glacialAdvance and not buff.breathOfSindragosa.exists() and pet.active.exists() < unit.gcd()*2 and #enemies.yards5 > 3 then
        cast.sacrificialPact()
    end
    -- actions.cooldowns+=/any_dnd,if=!death_and_decay.ticking&variable.adds_remain&(buff.pillar_of_frost.up&buff.pillar_of_frost.remains>5&buff.pillar_of_frost.remains<11|!buff.pillar_of_frost.up&cooldown.pillar_of_frost.remains>10|fight_remains<11)&(active_enemies>5|talent.cleaving_strikes&active_enemies>=2)
    if cast.able.deathAndDecay() and not buff.deathAndDecay.exists() and var.adds_remain and (buff.pillarOfFrost.exists() and buff.pillarOfFrost.remains() > 5 and buff.pillarOfFrost.remains() < 11 or not buff.pillarOfFrost.exists() and cd.pillarOfFrost.remains() > 10 or unit.ttd() < 11) and (#enemies.yards5 > 5 or talent.cleavingStrikes and #enemies.yards5 >= 2) then
        cast.deathAndDecay()
    end
end

actionList.cold_heart = function()
    -- actions.cold_heart=chains_of_ice,if=fight_remains<gcd&(rune<2|!buff.killing_machine.up&(!variable.2h_check&buff.cold_heart.stack>=4|variable.2h_check&buff.cold_heart.stack>8)|buff.killing_machine.up&(!variable.2h_check&buff.cold_heart.stack>8|variable.2h_check&buff.cold_heart.stack>10))
    if cast.able.chainsOfIce and unit.ttd() < unit.gcd() and (runes < 2 or not buff.killingMachine.exists() and (not var.twoh_check and buff.coldHeart.stack() >= 4 or var.twoh_check and buff.coldHeart.stack() > 8 or buff.killingMachine.exist() and (not var.twoh_check and buff.coldHeart.stack() > 8 or var.twoh_check and buff.coldHeart.stack() > 10))) then
        cast.chainsOfIce()
    end
    --actions.cold_heart+=/chains_of_ice,if=!talent.obliteration&buff.pillar_of_frost.up&buff.cold_heart.stack>=10&(buff.pillar_of_frost.remains<gcd*(1+(talent.frostwyrms_fury&cooldown.frostwyrms_fury.ready))|buff.unholy_strength.up&buff.unholy_strength.remains<gcd)
    if cast.able.chainsOfIce() and not talent.obliteration and buff.pillarOfFrost.exists() and buff.coldHeart.stack() >= 10 and (buff.pillarOfFrost.remains() < unit.gcd()*(1+((talent.frostWyrmsFury and 1 or 0) and cd.frostWyrmsFury.ready())) or buff.unholyStrength.exists() and buff.unholyStrength.remains() < unit.gcd()) then
        cast.chainsOfIce()
    end
    --actions.cold_heart+=/chains_of_ice,if=!talent.obliteration&death_knight.runeforge.fallen_crusader&!buff.pillar_of_frost.up&cooldown.pillar_of_frost.remains_expected>15&(buff.cold_heart.stack>=10&buff.unholy_strength.up|buff.cold_heart.stack>=13)
    if cast.able.chainsOfIce() and not talent.obliteration and var.fallencrusader and not buff.pillarOfFrost.exists() and cd.pillarOfFrost.remains() > 15 and (buff.coldHeart.stack() >= 10 and buff.unholyStrength.exists() or buff.coldHeart.stack() >= 13) then
        cast.chainsOfIce()
    end
    --actions.cold_heart+=/chains_of_ice,if=!talent.obliteration&!death_knight.runeforge.fallen_crusader&buff.cold_heart.stack>=10&!buff.pillar_of_frost.up&cooldown.pillar_of_frost.remains_expected>20
    if cast.able.chainsOfIce() and not talent.obliteration and not var.fallencrusader and buff.coldHeart.stack() >= 10 and not buff.pillarOfFrost.exists() and cd.pillarOfFrost.remains() > 20 then
        cast.chainsOfIce()
    end
    --actions.cold_heart+=/chains_of_ice,if=talent.obliteration&!buff.pillar_of_frost.up&(buff.cold_heart.stack>=14&(buff.unholy_strength.up|buff.chaos_bane.up)|buff.cold_heart.stack>=19|cooldown.pillar_of_frost.remains_expected<3&buff.cold_heart.stack>=14)
    if cast.able.chainsOfIce() and talent.obliteration and not buff.pillarOfFrost.exists() and (buff.coldHeart.stack() >= 14 and (buff.unholyStrength.exists() or buff.chaosBane.exists())  or buff.coldHeart.stack() >= 19 or cd.pillarOfFrost.remains() < 3 and buff.coldHeart.stack() >= 14) then
        cast.chainsOfIce()
    end
end

actionList.breath = function()
    -- howling_blast,if=variable.rime_buffs&runic_power>(45-talent.rage_of_the_frozen_champion*8)
    if cast.able.howlingBlast() and var.rime_buffs and runicPower > (45-(talent.rageOfTheFrozenChampion and 1 or 0)*8) then
        cast.howlingBlast()
    end
    -- horn_of_winter,if=rune<2&runic_power.deficit>25
    if cast.able.hornOfWinter() and runes < 2 and runicPowerDeficit > 25 then
        cast.hornOfWinter()
    end
    -- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=buff.killing_machine.react&!variable.frostscythe_priority
    if cast.able.obliterate() and buff.killingMachine.exists() and not var.frostscythe_priority and var.razorice then
        local max = 0
        local maxPlayer = {}
        for i=1, #enemies.yards5 do
            if debuff.razorice.exists() then
                local check = (debuff.razorice.stack(enemies.yards5[i]) + 1)%(debuff.razorice.remains(enemies.yards5[i])+1)
                if check > 0 then
                    max = check
                    maxPlayer = enemies.yards5[i]
                end
            end
        end
        if(max > 0) then
            cast.obliterate(maxPlayer)
        end
    end
    --actions.breath+=/frostscythe,if=buff.killing_machine.react&variable.frostscythe_priority
    if cast.able.frostscythe() and buff.killingMachine.exists() and var.frostscythe_priority then
        cast.frostscythe()
    end
    --actions.breath+=/frostscythe,if=variable.frostscythe_priority&runic_power>45
    if cast.able.frostscythe() and var.frostscythe_priority and runicPower > 45 then
        cast.frostscythe()
    end
    --actions.breath+=/obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit>40|buff.pillar_of_frost.up&runic_power.deficit>17
    if cast.able.obliterate() and runicPowerDeficit > 40 or buff.pillarOfFrost.exists() and runicPowerDeficit > 17 and var.razorice then
        local max = 0
        local maxPlayer = {}
        for i=1, #enemies.yards5 do
            if debuff.razorice.exists() then
                local check = (debuff.razorice.stack(enemies.yards5[i]) + 1)%(debuff.razorice.remains(enemies.yards5[i])+1)
                if check > 0 then
                    max = check
                    maxPlayer = enemies.yards5[i]
                end
            end
        end
        if(max > 0) then
            cast.obliterate(maxPlayer)
        end
    end
    --actions.breath+=/death_and_decay,if=runic_power<36&rune.time_to_2>runic_power%18
    if cast.able.deathAndDecay() and runicPower < 36 and br.runeTimeTill(2) > runicPower%18 then
        cast.deathAndDecay()
    end
    --actions.breath+=/remorseless_winter,if=runic_power<36&rune.time_to_2>runic_power%18
    if cast.able.remorselessWinter and runicPower < 36 and br.runeTimeTill(2) > runicPower%18 then
        cast.remorselessWinter()
    end
    --actions.breath+=/howling_blast,if=runic_power<36&rune.time_to_2>runic_power%18
    if cast.able.howlingBlast() and runicPower < 36 and rune.runeTimeTill(2) > runicPower%18 then
        cast.howlingBlast()
    end
    --actions.breath+=/obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit>25
    if cast.able.obliterate() and var.razorice and runicPowerDeficit > 25 then
        local max = 0
        local maxPlayer = {}
        for i=1, #enemies.yards5 do
            if debuff.razorice.exists() then
                local check = (debuff.razorice.stack(enemies.yards5[i]) + 1)%(debuff.razorice.remains(enemies.yards5[i])+1)
                if check > 0 then
                    max = check
                    maxPlayer = enemies.yards5[i]
                end
            end
        end
        if(max > 0) then
            cast.obliterate(maxPlayer)
        end
    end
    --actions.breath+=/howling_blast,if=buff.rime.react
    if cast.able.howlingBlast() and buff.rime.exists() then
        cast.howlingBlast()
    end
    --actions.breath+=/arcane_torrent,if=runic_power<60
end

actionList.breath_oblit = function()
    --actions.breath_oblit=frostscythe,if=buff.killing_machine.up&variable.frostscythe_priority
    if cast.able.frostscythe() and buff.killingMachine.exists() and var.frostscythe_priority then
        cast.frostscythe()
    end
    --actions.breath_oblit+=/obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=buff.killing_machine.up
    if cast.able.obliterate() and var.razorice and buff.killingMachine.exists() then
        local max = 0
        local maxPlayer = {}
        for i=1, #enemies.yards5 do
            if debuff.razorice.exists() then
                local check = (debuff.razorice.stack(enemies.yards5[i]) + 1)%(debuff.razorice.remains(enemies.yards5[i])+1)
                if check > 0 then
                    max = check
                    maxPlayer = enemies.yards5[i]
                end
            end
        end
        if(max > 0) then
            cast.obliterate(maxPlayer)
        end
    end
    --actions.breath_oblit+=/howling_blast,if=buff.rime.react
    if cast.able.howlingBlast() and buff.rime.exists() then
        cast.howlingBlast()
    end
    --actions.breath_oblit+=/howling_blast,if=!buff.killing_machine.up
    if cast.able.howlingBlast() and not buff.killingMachine.exists() then
        cast.howlingBlast()
    end
    --actions.breath_oblit+=/horn_of_winter,if=runic_power.deficit>25
    if cast.able.hornOfWinter() and runicPowerDeficit > 25 then
        cast.hornOfWinter()
    end
    --actions.breath_oblit+=/arcane_torrent,if=runic_power.deficit>20
end

actionList.obliteration = function()
    -- actions.obliteration=howling_blast,if=buff.killing_machine.stack<2&buff.pillar_of_frost.remains<gcd&buff.rime.react
    if cast.able.howlingBlast() and buff.killingMachine.stack() < 2 and buff.pillarOfFrost.remains() < unit.gcd() and buff.rime.exists() then
        cast.howlingBlast()
    end
    -- actions.obliteration+=/frost_strike,if=(active_enemies<=1|!talent.glacial_advance)&buff.killing_machine.react<2&buff.pillar_of_frost.remains<gcd&!death_and_decay.ticking
    if cast.able.frostStrike() and (#enemies.yards5 <= 1 or not talent.glacialAdvance) and buff.killingMachine.remains() < 2 and buff.pillarOfFrost.remains() < unit.gcd() and not debuff.deathAndDecay.exists() then
        cast.frostStrike()
    end
    -- actions.obliteration+=/glacial_advance,if=buff.killing_machine.react<2&buff.pillar_of_frost.remains<gcd&!death_and_decay.ticking
    if cast.able.glacialAdvance() and buff.killingMachine.remains() < 2 and buff.pillarOfFrost.remains() < unit.gcd() and not debuff.deathAndDecay.exists() then
        cast.glacialAdvance()
    end
    -- actions.obliteration+=/obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=buff.killing_machine.react&!variable.frostscythe_priority
    if cast.able.obliterate() and var.razorice and buff.killingMachine.exists() and not var.frostscythe_priority then
        local max = 0
        local maxPlayer = {}
        for i=1, #enemies.yards5 do
            if debuff.razorice.exists() then
                local check = (debuff.razorice.stack(enemies.yards5[i]) + 1)%(debuff.razorice.remains(enemies.yards5[i])+1)
                if check > 0 then
                    max = check
                    maxPlayer = enemies.yards5[i]
                end
            end
        end
        if(max > 0) then
            cast.obliterate(maxPlayer)
        end
    end
    -- actions.obliteration+=/frostscythe,if=buff.killing_machine.react&variable.frostscythe_priority
    if cast.able.frostscythe() and buff.killingMachine.exists() and var.frostscythe_priority then
        cast.frostscythe()
    end
    -- actions.obliteration+=/howling_blast,if=!buff.killing_machine.react&(!dot.frost_fever.ticking|buff.rime.react&set_bonus.tier30_2pc&!variable.rp_buffs)
    if cast.able.howlingBlast() and not buff.killingMachine.exists() and (not debuff.frostFever.exists() or buff.rime.exists() and equiped.tier(30) >= 2 and not var.rp_buffs) then
        cast.howlingBlast()
    end
    -- actions.obliteration+=/glacial_advance,if=!buff.killing_machine.react&(!death_knight.runeforge.razorice&(!talent.avalanche|debuff.razorice.stack<5|debuff.razorice.remains<gcd*3)|(variable.rp_buffs&active_enemies>1))
    if cast.able.glacialAdvance() and not buff.killingMachine.exists() and (not var.razorice and (not talent.avalanche or debuff.razorice.stack() < 5 or debuff.razorice.remains() < unit.gcd()*3) or (var.rp_buffs and #enemies.yards5 > 1)) then
        cast.glacialAdvance()
    end
    -- actions.obliteration+=/frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=!buff.killing_machine.react&(rune<2|variable.rp_buffs|debuff.razorice.stack=5&talent.shattering_blade)&!variable.pooling_runic_power&(!talent.glacial_advance|active_enemies=1)
    if cast.able.frostStrike() and var.razorice and not buff.killingMachine.exists() and (runes < 2 or var.rp_buffs or debuff.razorice.stack() == 5 and talent.shatteringBlade) and not var.pooling_runic_power and (not talent.glacialAdvance or #enemies.yards5 == 1) then
        local max = 0
        local maxPlayer = {}
        for i=1, #enemies.yards5 do
            if debuff.razorice.exists() then
                local check = (debuff.razorice.stack(enemies.yards5[i]) + 1)%(debuff.razorice.remains(enemies.yards5[i])+1)
                if check > 0 then
                    max = check
                    maxPlayer = enemies.yards5[i]
                end
            end
        end
        if(max > 0) then
            cast.frostStrike(maxPlayer)
        end
    end
    -- actions.obliteration+=/howling_blast,if=buff.rime.react&!buff.killing_machine.react
    if cast.able.howlingBlast() and buff.rime.exists() and not buff.killingMachine.exists() then
        cast.howlingBlast()
    end
    -- actions.obliteration+=/glacial_advance,if=!variable.pooling_runic_power&variable.rp_buffs&!buff.killing_machine.react&active_enemies>=2
    if cast.able.glacialAdvance() and not var.pooling_runic_power and var.rp_buffs and not buff.killingMachine.exists() and #enemies.yards5 >= 2 then
        cast.glacialAdvance()
    end
    -- actions.obliteration+=/frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=!buff.killing_machine.react&!variable.pooling_runic_power&(!talent.glacial_advance|active_enemies=1)
    if cast.able.frostStrike() and var.razorice and not buff.killingMachine.exists() and not var.pooling_runic_power and (not talent.glacialAdvance or #enemies.yards5 == 1) then
        local max = 0
        local maxPlayer = {}
        for i=1, #enemies.yards5 do
            if debuff.razorice.exists() then
                local check = (debuff.razorice.stack(enemies.yards5[i]) + 1)%(debuff.razorice.remains(enemies.yards5[i])+1)
                if check > 0 then
                    max = check
                    maxPlayer = enemies.yards5[i]
                end
            end
        end
        if(max > 0) then
            cast.frostStrike(maxPlayer)
        end
    end
    -- actions.obliteration+=/howling_blast,if=!buff.killing_machine.react&runic_power<25
    if cast.able.howlingBlast() and not buff.killingMachine.exists() and runicPower<25 then
        cast.howlingBlast()
    end
    -- actions.obliteration+=/arcane_torrent,if=rune<1&runic_power<25
    -- actions.obliteration+=/glacial_advance,if=!variable.pooling_runic_power&active_enemies>=2
    if cast.able.glacialAdvance() and not var.pooling_runic_power and #enemies.yards5 >= 2 then
        cast.glacialAdvance()
    end
    -- actions.obliteration+=/frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=!variable.pooling_runic_power&(!talent.glacial_advance|active_enemies=1)
    if cast.able.frostStrike() and var.razorice and not var.pooling_runic_power and (not talent.glacialAdvance or #enemies.yards5 == 1) then
        cast.frostStrike()
    end
    -- actions.obliteration+=/howling_blast,if=buff.rime.react
    if cast.able.howlingBlast() and buff.rime.exists() then
        cast.howlingBlast()
    end
    -- actions.obliteration+=/obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice
    if cast.able.obliterate() and var.razorice then
        local max = 0
        local maxPlayer = {}
        for i=1, #enemies.yards5 do
            if debuff.razorice.exists() then
                local check = (debuff.razorice.stack(enemies.yards5[i]) + 1)%(debuff.razorice.remains(enemies.yards5[i])+1)
                if check > 0 then
                    max = check
                    maxPlayer = enemies.yards5[i]
                end
            end
        end
        if(max > 0) then
            cast.obliterate(maxPlayer)
        end
    end
end

actionList.aoe = function()
    -- howling_blast,if=buff.rime.react|!dot.frost_fever.ticking
    if cast.able.howlingBlast() and buff.rime.exists() or not debuff.frostFever.exists() then
        cast.howlingBlast()
    end
    -- 	glacial_advance,if=!variable.pooling_runic_power&variable.rp_buffs
    if cast.able.glacialAdvance() and var.rp_buffs then
        cast.glacialAdvance()
    end
    -- 	obliterate,if=buff.killing_machine.react&talent.cleaving_strikes&death_and_decay.ticking&!variable.frostscythe_priority
    if cast.able.obliterate() and buff.killingMachine.exists() and talent.cleavingStrikes and buff.deathAndDecay.exists() and not var.frostscythe_priority then
        cast.obliterate()
    end
    -- 	glacial_advance,if=!variable.pooling_runic_power
    if cast.able.glacialAdvance() and not var.pooling_runic_power then
        cast.glacialAdvance()
    end
    -- frostscythe,if=variable.frostscythe_priority
    if cast.able.frostscythe() and var.frostscythe_priority then
        cast.frostscythe()
    end
    -- obliterate,if=!variable.frostscythe_priority
    if cast.able.obliterate() and not var.frostscythe_priority then
        cast.obliterate()
    end
    -- frost_strike,if=!variable.pooling_runic_power&!talent.glacial_advance
    if cast.able.frostStrike() and not var.pooling_runic_power and not talent.glacialAdvance then
        cast.frostStrike()
    end
    -- horn_of_winter,if=rune<2&runic_power.deficit>25
    if cast.able.hornOfWinter() and runes < 2 and runicPowerDeficit > 25 then
        cast.hornOfWinter()
    end
    -- arcane_torrent,if=runic_power.deficit>25
end

actionList.single_target = function()
    -- actions.single_target=frost_strike,if=buff.killing_machine.react<2&runic_power.deficit<20&!variable.2h_check
    if cast.able.frostStrike() and buff.killingMachine.remains() < 2 and runicPowerDeficit < 20 and not var.twoh_check then
        cast.frostStrike()
    end
    -- actions.single_target+=/howling_blast,if=buff.rime.react&set_bonus.tier30_2pc&buff.killing_machine.stack<2
    if cast.able.howlingBlast() and buff.rime.exists() and equiped.tier(30) >= 2 and buff.killingMachine.stack() < 2 then
        cast.howlingBlast()
    end
    -- actions.single_target+=/frostscythe,if=buff.killing_machine.react&variable.frostscythe_priority
    if cast.able.frostscythe() and buff.killingMachine.exists() and var.frostscythe_priority then
        cast.frostscythe()
    end
    -- actions.single_target+=/obliterate,if=buff.killing_machine.react
    if cast.able.obliterate() and buff.killingMachine.exists() then
        cast.obliterate()
    end
    -- actions.single_target+=/howling_blast,if=buff.rime.react&talent.icebreaker.rank=2
    if cast.able.howlingBlast() and buff.rime.react() and talent.rank.icebreaker == 2 then
        cast.howlingBlast()
    end
    -- actions.single_target+=/horn_of_winter,if=rune<4&runic_power.deficit>25&talent.obliteration&talent.breath_of_sindragosa
    if cast.able.hornOfWinter() and runes < 4 and runicPowerDeficit > 25 and talent.obliteration and talent.breathOfSindragosa then
        cast.hornOfWinter()
    end
    -- actions.single_target+=/frost_strike,if=!variable.pooling_runic_power&(variable.rp_buffs|runic_power.deficit<25|debuff.razorice.stack=5&talent.shattering_blade)
    if cast.able.frostStrike() and not var.pooling_runic_power and (var.rp_buffs or runicPowerDeficit < 25 or debuff.razorice.stack() == 5 and talent.shatteringBlade) then
        cast.frostStrike()
    end
    -- actions.single_target+=/howling_blast,if=variable.rime_buffs
    if cast.able.howlingBlast() and var.rime_buffs then
        cast.howlingBlast()
    end
    -- actions.single_target+=/glacial_advance,if=!variable.pooling_runic_power&!death_knight.runeforge.razorice&(debuff.razorice.stack<5|debuff.razorice.remains<gcd*3)
    if cast.able.glacialAdvance() and not var.pooling_runic_power and not var.razorice and (debuff.razorice.stack() < 5 or debuff.razorice.remains() < unit.gcd()*3) then
        cast.glacialAdvance()
    end
    -- actions.single_target+=/obliterate,if=!variable.pooling_runes
    if cast.able.obliterate() and not var.pooling_runes then
        cast.obliterate()
    end
    -- actions.single_target+=/horn_of_winter,if=rune<4&runic_power.deficit>25&(!talent.breath_of_sindragosa|cooldown.breath_of_sindragosa.remains>cooldown.horn_of_winter.duration)
    if cast.able.hornOfWinter() and runes < 4 and runicPowerDeficit > 25 and (not talent.breathOfSindragosa or cd.breathOfSindragosa.remains() > cd.hornOfWinter.remains()) then
        cast.hornOfWinter()
    end
    -- actions.single_target+=/arcane_torrent,if=runic_power.deficit>20
    -- actions.single_target+=/frost_strike,if=!variable.pooling_runic_power
    if cast.able.frostStrike() and not var.pooling_runic_power then
        cast.frostStrike()
    end
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    enemies                                       = br.player.enemies
    module                                        = br.player.module
    runes                                         = br.player.power.runes.amount()
    runicPower                                    = br.player.power.runicPower.amount()
    runicPowerDeficit = br.player.power.runicPower.deficit()
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    equiped = br.player.equiped
    buff = br.player.buff
    debuff = br.player.debuff
    talent = br.player.talent
    pet = br.player.pet
    -- General Locals
    var.haltProfile                               = (unit.inCombat() and var.profileStop) or unit.mounted() or br.pause() or ui.mode.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(8)
    enemies.get(15)
    var.getItemLink = br._G.GetInventoryItemLink
    if var.getItemLink("player",17) ~= nil then
        var.EnchantOH = (select(6,string.find(var.getItemLink("player",17),itemLinkRegex)))
        var.EnchantOH = tonumber(var.EnchantOH)
    end
    if var.EnchantMH == 3370 or var.EnchantOH == 3370 then var.razorice = true end
    if var.EnchantMH == 3368 or var.EnchantOH == 3368 then var.fallencrusader = true end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") then
        var.profileStop = false
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
        if cd.global.remain() == 0 then
            if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                -----------------
                --- Interrupt ---
                -----------------
                if actionList.Interrupts() then return true end
                -- Start Attack
                -- actions=auto_attack
                if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    br._G.StartAttack(units.dyn5)
                end
                -- Trinkets
                for i = 13, 14 do
                    local opValue = ui.value("Trinkets")
                    local iValue = i - 12
                    if (opValue == iValue or opValue == 3) and use.able.slot(i) then
                        if use.able.slot(i) and unit.isBoss("target") then
                            use.slot(i)
                            ui.debug("Using Trinket in Slot "..i)
                            return
                        end
                    end
                end
                actionList.variables()
                -- call_action_list,name=high_prio_actions
                actionList.high_prio_actions()
                -- call_action_list,name=cooldowns
                if br.isBoss() then
                    actionList.cooldowns()
                end
                -- call_action_list,name=cold_heart,if=talent.cold_heart&(!buff.killing_machine.up|talent.breath_of_sindragosa)&((debuff.razorice.stack=5|!death_knight.runeforge.razorice&!talent.glacial_advance&!talent.avalanche)|fight_remains<=gcd)
                if talent.coldHeart and (not buff.killingMachine.exists() or talent.breathOfSindragosa.exists()) and ((debuff.razorice.stack() == 5 or not var.razorice and not talent.glacialAdvance and not talent.avalanche) or unit.ttd() < unit.gcd()) then
                    actionList.cold_heart()
                end
                -- run_action_list,name=breath_oblit,if=buff.breath_of_sindragosa.up&talent.obliteration&buff.pillar_of_frost.up
                if buff.breathOfSindragosa.exists() and talent.obliteration and buff.pillarOfFrost.exists() then
                    actionList.breath_oblit()
                end
                -- run_action_list,name=breath,if=buff.breath_of_sindragosa.up&(!talent.obliteration|talent.obliteration&!buff.pillar_of_frost.up)
                if buff.breathOfSindragosa.exists() and (not talent.obliteration or talent.obliteration and not buff.pillarOfFrost.exists()) then
                    actionList.breath()
                end
                -- 	run_action_list,name=obliteration,if=talent.obliteration&buff.pillar_of_frost.up&!buff.breath_of_sindragosa.up
                if talent.obliteration and buff.pillarOfFrost.exists() and not buff.breathOfSindragosa.exists() then
                    actionList.obliteration()
                end
                -- call_action_list,name=aoe,if=active_enemies>=2
                if #enemies.yards5 >=2 then
                    actionList.aoe()
                end
                -- call_action_list,name=single_target,if=active_enemies=1
                if #enemies.yards5 == 1 then
                    actionList.single_target()
                end
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 251
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
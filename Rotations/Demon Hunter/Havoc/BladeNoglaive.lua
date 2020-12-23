local rotationName = "Bladenoglaive"

---------------
--- Toggles ---d
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.bladeDance},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladeDance},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.chaosStrike},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.spectralSight}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.metamorphosis},
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.metamorphosis},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.metamorphosis}
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.darkness},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.darkness}
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.consumeMagic},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.consumeMagic}
    };
    CreateButton("Interrupt",4,0)
    -- Mover
    MoverModes = {
        [1] = { mode = "AC", value = 1 , overlay = "Movement Animation Cancel Enabled", tip = "Will Cancel Movement Animation.", highlight = 1, icon = br.player.spell.felRush},
        [2] = { mode = "On", value = 2 , overlay = "Auto Movement Enabled", tip = "Will Cast Movement Abilities.", highlight = 0, icon = br.player.spell.felRush},
        [3] = { mode = "Off", value = 3 , overlay = "Auto Movement Disabled", tip = "Will NOT Cast Movement Abilities", highlight = 0, icon = br.player.spell.felRush}
    };
    CreateButton("Mover",5,0)
    -- Hold Eye Beam
    EyeBeamModes = {
        [1] = { mode = "On", value = 1 , overlay = "Use Eye beam", tip = "Use Eye beam", highlight = 1, icon = br.player.spell.eyeBeam},
        [2] = { mode = "Off", value = 2 , overlay = "Don't use Eye beam", tip = "Don't use Eye beam", highlight = 0, icon = br.player.spell.eyeBeam}
    };
    CreateButton("EyeBeam",6,0)
    -- Hold Fel Barrage
    FelBarrageModes = {
        [1] = { mode = "On", value = 1 , overlay = "Use Fel Barrage", tip = "Use Fel Barrage", highlight = 1, icon = br.player.spell.felBarrage},
        [2] = { mode = "Off", value = 2 , overlay = "Don't use Fel Barrage", tip = "Don't use Fel Barrage", highlight = 0, icon = br.player.spell.felBarrage}
    };
    CreateButton("FelBarrage",7,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        local alwaysCdNever = {"|cff0000FFAlways","|cffFFFFFFCD Only","|cffFF0000Never"}
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- M+ Meta Pre-Pull Timer
            br.ui:createSpinner(section, "M+ Pre-Pull",  3,  1,  10,  1,  "|cffFFFFFFSet to desired time to Meta Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Auto Engage
            br.ui:createCheckbox(section, "Auto Engage")
            -- Eye Beam Targets
            br.ui:createDropdownWithout(section,"Eye Beam Usage",{"|cff00FF00Per APL","|cffFFFFFFAoE Only","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Eye Beam.")
            br.ui:createSpinnerWithout(section, "Units To AoE", 3, 1, 10, 1, "|cffFFBB00Number of Targets to use AoE spells on.")
            -- Fel Rush Charge Hold
            br.ui:createSpinnerWithout(section, "Hold Fel Rush Charge", 1, 0, 2, 1, "|cffFFBB00Number of Fel Rush charges the bot will hold for manual use.");
            -- Fel Rush Only In Melee
            br.ui:createCheckbox(section, "Fel Rush Only In Melee")
            -- Fel Rush After Vengeful Retreat
            br.ui:createCheckbox(section, "Auto Fel Rush After Retreat")
            -- Throw Glaive 
            br.ui:createCheckbox(section, "Throw Glaive")
            -- Vengeful Retreat
            br.ui:createCheckbox(section, "Vengeful Retreat")
            -- Glide Fall Time
            br.ui:createSpinner(section, "Glide", 2, 0, 10, 1, "|cffFFBB00Seconds until Glide will be used while falling.")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Flask Module
            br.player.module.FlaskUp("Agility",section)
            -- Augment Rune
            br.ui:createCheckbox(section,"Augment Rune")
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- Racial
            br.ui:createDropdownWithout(section,"Racial",alwaysCdNever,1,"|cffFFBB00When to use Racial.")
            -- Basic Trinket Module
            br.player.module.BasicTrinkets(nil,section)
            -- Metamorphosis
            br.ui:createDropdownWithout(section,"Metamorphosis",alwaysCdNever,1,"|cffFFBB00When to use Metamorphosis.")
            -- Covenant Ability
            br.ui:createDropdownWithout(section,"Covenant Ability",alwaysCdNever,1,"|cffFFBB00When to use Covenant Ability.")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Blur
            br.ui:createSpinner(section, "Blur", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Darkness
            br.ui:createSpinner(section, "Darkness", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Chaos Nova
            br.ui:createSpinner(section, "Chaos Nova - HP", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            br.ui:createSpinner(section, "Chaos Nova - AoE", 3, 1, 10, 1, "|cffFFBB00Number of Targets to use at.")
            -- Consume Magic
            br.ui:createCheckbox(section, "Consume Magic")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Chaos Nova
            br.ui:createCheckbox(section, "Chaos Nova")
            -- Disrupt
            br.ui:createCheckbox(section, "Disrupt")
            -- Fel Eruption
            br.ui:createCheckbox(section, "Fel Eruption")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
            br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            -- Defensive Key Toggle
            br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Mover Key Toggle
            br.ui:createDropdownWithout(section, "Mover Mode", br.dropOptions.Toggle,  6)
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
local buff
local cast
local cd
local charges
local conduit
local covenant
local debuff
local enemies
local equiped
local fury
local furyDeficit
local gcd
local module
local race
local runeforge
local talent
local ui
local unit
local units
local use

local var = {}
var.felBarrageSync = false
var.leftCombat = GetTime()
var.lastRune = GetTime()
var.profileStop = false
var.useBasicTrinkets = false

-- Custom Functions
local function cancelRushAnimation()
    if cast.able.felRush() and GetUnitSpeed("player") == 0 then
        MoveBackwardStart()
        JumpOrAscendStart()
        cast.felRush()
        MoveBackwardStop()
        AscendStop()
    end
    return
end
local function cancelRetreatAnimation()
    if cast.able.vengefulRetreat() then

        -- C_Timer.After(.001, function() SetHackEnabled("NoKnockback", true) end)
        -- C_Timer.After(.35, function() cast.vengefulRetreat() end)
        -- C_Timer.After(.55, function() SetHackEnabled("NoKnockback", false) end)
        -- SetHackEnabled("NoKnockback", true)
        if cast.vengefulRetreat() then
            C_Timer.After(.35, function() StopFalling(); end)
            C_Timer.After(.55, function() MoveForwardStart(); end)
            C_Timer.After(.75, function() MoveForwardStop(); end)
        --     SetHackEnabled("NoKnockBack", false)
        end
    end
    return
end
local function eyebeamTTD()
    local length = talent.blindFury and 3 or 2
    if enemies.yards20r > 0 then
        for i = 1, enemies.yards20r do
            if unit.ttd(enemies.yards20rTable[i]) >= length then
                return true
            end
        end
    end
    return false
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
local actionList = {}
actionList.Extras = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if getCombatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy("target") then
                StopAttack()
                ClearTarget()
                Print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Glide
    if ui.checked("Glide") and cast.able.glide() and not buff.glide.exists() then
        if var.falling >= ui.value("Glide") then
            if cast.glide("player") then ui.debug("Casting Glide") return true end
        end
    end
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Heal Module
        module.BasicHealing()
        -- Blur
        if ui.checked("Blur") and cast.able.blur() and unit.hp()<= ui.value("Blur") and unit.inCombat() then
            if cast.blur() then ui.debug("Casting Blur") return true end
        end
        -- Darkness
        if ui.checked("Darkness") and cast.able.darkness() and unit.hp()<= ui.value("Darkness") and unit.inCombat() then
            if cast.darkness() then ui.debug("Casting Darkness") return true end
        end
        -- Chaos Nova
        if ui.checked("Chaos Nova - HP") and cast.able.chaosNova() and not buff.metamorphosis.exists()
            and unit.hp() <= ui.value("Chaos Nova - HP") and unit.inCombat() and #enemies.yards5 > 0
        then
            if cast.chaosNova() then ui.debug("Casting Chaos Nova [HP]") return true end
        end
        if ui.checked("Chaos Nova - AoE") and cast.able.chaosNova() and not buff.metamorphosis.exists()
            and #enemies.yards5 >= ui.value("Chaos Nova - AoE")
        then
            if cast.chaosNova() then ui.debug("Casting Chaos Nova [AoE]") return true end
        end
		if ui.checked("Consume Magic") then
            for i=1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if cast.able.consumeMagic(thisUnit) and cast.dispel.consumeMagic(thisUnit)
                    and not unit.isBoss(thisUnit) and unit.exists(thisUnit)
                then
                    if cast.consumeMagic(thisUnit) then ui.debug("Casting Consume Magic") return true end
                end
            end
        end
    end -- End Defensive Toggle
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        -- Fel Eruption
        if ui.checked("Fel Eruption") and talent.felEruption then
            for i=1, #enemies.yards20 do
                local thisUnit = enemies.yards20[i]
                if canInterrupt(thisUnit,ui.value("Interrupt At")) and cast.able.felEruption(thisUnit) then
                    if cast.felEruption(thisUnit) then ui.debug("Casting Fel Eruption") return true end
                end
            end 
        end
        -- Disrupt
        if ui.checked("Disrupt") then
            for i=1, #enemies.yards10 do
                local thisUnit = enemies.yards10[i]
                if canInterrupt(thisUnit,ui.value("Interrupt At")) and cast.able.disrupt(thisUnit) then
                    if cast.disrupt(thisUnit) then ui.debug("Disrupt") return true end
                end
            end
        end
        -- Chaos Nova
        if ui.checked("Chaos Nova") then
            for i=1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if canInterrupt(thisUnit,ui.value("InterruptAt")) and cast.able.chaosNova(thisUnit) then
                    if cast.chaosNova(thisUnit) then ui.debug("Chaos Nova [Int]") return true end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
        if ui.alwaysCdNever("Racial") and cast.able.racial() and (race == "Orc" or race == "Troll" or race == "BloodElf") then
            if cast.racial() then ui.debug("Casting Racial Ability") return true end
        end
        -- Metamorphosis
        if ui.alwaysCdNever("Metamorphosis") then
            -- metamorphosis,if=!(talent.demonic.enabled|variable.pooling_for_meta)&cooldown.eye_beam.remains>20&(!covenant.venthyr.enabled|!dot.sinful_brand.ticking)|fight_remains<25
            if cast.able.metamorphosis() and #enemies.yards8 > 0 and (not (talent.demonic or var.poolForMeta) and cd.eyeBeam.remains() > 20
                and (not covenant.venthyr.enabled or not debuff.sinfulBrand.exists(units.dyn5) or (unit.isBoss("target") and unit.ttdGroup(5) < 25)))
            then
                if cast.metamorphosis("player") then ui.debug("Casting Metamorphosis") return true end
            end
            -- metamorphosis,if=talent.demonic.enabled&(cooldown.eye_beam.remains>20&(!variable.blade_dance|cooldown.blade_dance.remains>gcd.max))&(!covenant.venthyr.enabled|!dot.sinful_brand.ticking)
            if cast.able.metamorphosis() and #enemies.yards8 > 0 and talent.demonic
                and (cd.eyeBeam.remain() > 20 and (not var.bladeDance or cd.bladeDance.remain() > unit.gcd(true)))
                and (not covenant.venthyr.enabled or not debuff.sinfulBrand.exists(units.dyn5))
            then
                if cast.metamorphosis("player") then ui.debug("Casting Metamorphosis [Demonic]") return true end
            end
        end
        -- Covenant Abilities
        if ui.alwaysCdNever("Covenant Ability") then
            -- Sinful Brand
            -- sinful_brand,if=!dot.sinful_brand.ticking
            if cast.able.sinfulBrand() and not debuff.sinfulBrand.exists(units.dyn5) then
                if cast.sinfulBrand() then ui.debug("Casting Sinful Brand") return true end
            end
            -- The Hunt
            -- the_hunt,if=!talent.demonic.enabled&!variable.waiting_for_momentum|buff.furious_gaze.up
            if cast.able.theHunt() and buff.metamorphosis.exists() and (not var.waitingForMomentum) then
                if cast.theHunt() then ui.debug("Casting The Hunt") return true end
            end
            -- Fodder to the Flame
            -- fodder_to_the_flame
            if cast.able.fodderToTheFlame() then
                if cast.fodderToTheFlame() then ui.debug("Casting Fodder to the Flame") return true end
            end
            -- Elysian Decree
            -- elysian_decree,if=(active_enemies>desired_targets|raid_event.adds.in>30)
            if cast.able.elysianDecree() and ((ui.mode.rotation == 1 and #enemies.yards8 >= ui.value("Units To AoE")) or ui.mode.rotation == 2) then
                if cast.elysianDecree() then ui.debug("Casting Elysian Decree") return true end
            end
        end
        -- Potion
        -- potion,if=buff.metamorphosis.remains>25|fight_remains<60
        if ui.checked("Potion") and ui.useCDs() and use.able.potionOfUnbridledFury() and var.inRaid then
            if buff.metamorphosis.remain() > 25 and unit.ttd(units.dyn5) >= 60 then
                use.potionOfUnbridledFury()
                ui.debug("Unit Postiion of Unbridaled Fury")
                return
            end
        end
        -- Trinkets
        if buff.metamorphosis.exists() or not ui.alwaysCdNever("Metamorphosis") then
            module.BasicTrinkets()
        end
    end
end -- End Action List - Cooldowns

-- Action List - Essence Break
actionList.EssenceBreak = function()
    -- Essence Break
    -- essence_break,if=fury>=80&(cooldown.blade_dance.ready|!variable.blade_dance)
    if cast.able.essenceBreak() and fury >= 80 and (cd.bladeDance.ready() or not var.bladeDance) then
        if cast.essenceBreak() then ui.debug("Casting Essence Break") return true end
    end
    if debuff.essenceBreak.exists(units.dyn5) then
        if var.bladeDance then
            -- Death Sweep
            -- death_sweep,if=variable.blade_dance&debuff.essence_break.up
            if cast.able.deathSweep() then
                if cast.deathSweep("player","aoe",1,8) then ui.debug("Casting Death Sweep [Essence Break]") return true end
            end
            -- Blade Dance
            -- blade_dance,if=variable.blade_dance&debuff.essence_break.up
            if cast.able.bladeDance() then
                if cast.bladeDance("player","aoe",1,8) then ui.debug("Casting Blade Dance [Essence Break]") return true end
            end
        end
        -- Annihilation
        -- annihilation,if=debuff.essence_break.up
        if cast.able.annihilation() then
            if cast.annihilation() then ui.debug("Casting Annihilation [Essence Break]") return true end
        end
        -- Chaos Strike
        -- chaos_strike,if=debuff.essence_break.up
        if cast.able.chaosStrike() then
            if cast.chaosStrike() then ui.debug("Casting Chaos Strike [Essence Break]") return true end
        end
    end
end -- End Action List - Essence Break

-- Action List - Demonic
actionList.Demonic = function()
    -- Fel Rush
    -- fel_rush,if=(talent.unbound_chaos.enabled&buff.unbound_chaos.up)&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
    if cast.able.felRush() and not unit.isExplosive("target") and unit.facing("player","target",10)        
        and talent.unboundChaos and buff.innerDemon.exists()
        and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation()
        elseif not ui.checked("Fel Rush Only In Melee") and (ui.mode.mover == 2 or (unit.distance("target") >= 8 and ui.mode.mover ~= 3)) then
            if cast.felRush() then ui.debug("Casting Fel Rusg [Unbound Chaos]") return true end
        end
    end
    -- Death Sweep
    -- death_sweep,if=variable.blade_dance
    if cast.able.deathSweep() and not unit.isExplosive("target") and #enemies.yards8 >= 1 and var.bladeDance then
        if cast.deathSweep("player","aoe",1,8) then ui.debug("Casting Death Sweep") return true end
    end
    -- Glaive Tempest
    -- glaive_tempest,if=active_enemies>desired_targets|raid_event.adds.in>10
    --if cast.able.glaiveTempest() and unit.distance("target") < 1 then
       -- if cast.glaiveTempest() then ui.debug("Casting Glaive Tempest") return true end
    --end
    -- Throw Glaive
    -- throw_glaive,if=conduit.serrated_glaive.enabled&cooldown.eye_beam.remains<6&!buff.metamorphosis.up&!debuff.exposed_wound.up
    if ui.checked("Throw Glaive") and cast.able.throwGlaive() and conduit.serratedGlaive.enabled and cd.eyeBeam.remains() < 6
        and not buff.metamorphosis.exists() and not debuff.exposedWound.exists(units.dyn10)
    then
        if cast.throwGlaive() then ui.debug("Casting Throw Glaive [Serrated Glaive]") return true end
    end
    -- Eye Beam
    -- eye_beam,if=raid_event.adds.up|raid_event.adds.in>25
    if ui.mode.eyeBeam == 1 and not unit.isExplosive("target") and cast.able.eyeBeam() and not unit.moving() and enemies.yards20r > 0
        and ((ui.value("Eye Beam Usage") == 1 and ui.mode.rotation == 1)
            or (ui.value("Eye Beam Usage") == 2 and ui.mode.rotation == 1 and enemies.yards20r >= ui.value("Units To AoE"))
            or ui.mode.rotation == 2) and (eyebeamTTD() or unit.isDummy(units.dyn8))
			or ui.mode.rotation == 3
    then
        if cast.eyeBeam("player","rect",1,20) then ui.debug("Casting Eye Beam") return true end
    end
    -- Blade Dance
    -- blade_dance,if=variable.blade_dance&!cooldown.metamorphosis.ready&(cooldown.eye_beam.remains>5|(raid_event.adds.in>cooldown&raid_event.adds.in<25))
    if cast.able.bladeDance() and not unit.isExplosive("target") and #enemies.yards8 >= 1 and var.bladeDance
        and (cd.metamorphosis.remain() > unit.gcd(true) or not ui.useCDs() or not ui.checked("Metamorphosis"))
        and (cd.eyeBeam.remain() > 1 or ui.mode.eyeBeam == 2)
    then
        if cast.bladeDance("player","aoe",1,8) then ui.debug("Casting Blade Dance") return true end
    end
    -- Immolation Aura
    -- immolation_aura
    if cast.able.immolationAura() and not unit.isExplosive("target") and #enemies.yards8 > 0 then
        if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura") return true end
    end
    -- Annihilation
    -- annihilation,if=!variable.pooling_for_blade_dance
    if cast.able.annihilation() and not var.poolForBladeDance then
        if cast.annihilation() then ui.debug("Casting Annihilation") return true end
    end
    -- Felblade
    -- felblade,if=fury.deficit>=40
    if cast.able.felblade() and furyDeficit >= 40 and not cast.last.vengefulRetreat() and unit.distance("target") <= 1 then
        if cast.felblade() then ui.debug("Casting Felblade") return true end
    end
    -- Chaos Strike
    -- chaos_strike,if=!variable.pooling_for_blade_dance&!variable.pooling_for_eye_beam
    if cast.able.chaosStrike() and not var.poolForBladeDance and not var.poolForEyeBeam then
        if cast.chaosStrike() then ui.debug("Casting Chaos Strike") return true end
    end
    -- Fel Rush
    -- fel_rush,if=talent.demon_blades.enabled&!cooldown.eye_beam.ready&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
    if cast.able.felRush() and not unit.isExplosive("target") and unit.facing("player","target",10)
        and talent.demonBlades and cd.eyeBeam.remain() > gcd
        and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation()
        elseif not ui.checked("Fel Rush Only In Melee") and (ui.mode.mover == 2 or (unit.distance("target") >= 8 and ui.mode.mover ~= 3)) then
            if cast.felRush() then ui.debug("Casting Fel Rush [Demon Blades]") return true end
        end
    end
    -- Demon's Bite
    -- demons_bite,target_if=min:debuff.burning_wound.remains,if=runeforge.burning_wound.equipped&debuff.burning_wound.remains<4
    if cast.able.demonsBite(var.lowestBurningWound) and runeforge.burningWound.equiped and debuff.burningWound.remain(units.dyn5) < 4 then
        if cast.demonsBite(var.lowestBurningWound) then ui.debug("Casting Demon's Bite [Burning Wound]") return true end
    end
    -- demons_bite
    if cast.able.demonsBite(units.dyn5) and not talent.demonBlades and furyDeficit >= 30 then
        if cast.demonsBite(units.dyn5) then ui.debug("Casting Demon's Bite") return true end
    end
    -- Throw Glaive
    -- throw_glaive,if=buff.out_of_range.up
    if ui.checked("Throw Glaive") and cast.able.throwGlaive() and unit.distance(units.dyn30) > 8 then
        if cast.throwGlaive() then ui.debug("Casting Throw Glaive [Out of Range]") return true end
    end
    -- Fel Rush
    -- fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum.enabled)
    if not ui.checked("Fel Rush Only In Melee") and not unit.isExplosive("target") and cast.able.felRush()
        and ui.mode.mover ~= 3 and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
        and (unit.distance("target") > 15 or (unit.distance("target") > 8 and not talent.momentum))
    then
        if cast.felRush() then ui.debug("Casting Fel Rush [Out of Range]") return true end
    end
    -- Throw Glaive
    -- throw_glaive,if=talent.demon_blades.enabled
    if ui.checked("Throw Glaive") and cast.able.throwGlaive() and talent.demonBlades then
        if cast.throwGlaive() then ui.debug("Casting Throw Glaive [Demon Blades]") return true end
    end
end -- End Action List - Demonic

-- Action List - Normal
actionList.Normal = function()
    -- Vengeful Retreat
    -- vengeful_retreat,if=talent.momentum.enabled&buff.prepared.down&time>1
    if ui.checked("Vengeful Retreat") and cast.able.vengefulRetreat() and talent.momentum
        and not buff.prepared.exists() and var.combatTime > 1 and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5
    then
        if ui.mode.mover == 1 then
            cancelRetreatAnimation()
        elseif ui.mode.mover == 2 then
            if cast.vengefulRetreat() then ui.debug("Casting Vengeful Retreat [Momentum]") return true end
        end
    end
    -- Fel Rush
    -- fel_rush,if=(variable.waiting_for_momentum|talent.unbound_chaos.enabled&buff.unbound_chaos.up)&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
    if cast.able.felRush() and not unit.isExplosive("target") and unit.facing("player","target",10)
        and (var.waitingForMomentum or (talent.unboundChaos and buff.innerDemon.exists()))
        and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation()
        elseif not ui.checked("Fel Rush Only In Melee") and (ui.mode.mover == 2 or (unit.distance("target") >= 8 and ui.mode.mover ~= 3)) then
            if cast.felRush() then ui.debug("Casting Fel Rush [Momentum/Unbound Chaos]") return true end
        end
    end
    -- Fel Barrage
    -- fel_barrage,if=active_enemies>desired_targets|raid_event.adds.in>30
    if ui.mode.felBarrage == 1 and not unit.isExplosive("target") and cast.able.felBarrage()
        and ((ui.mode.rotation == 1 and #enemies.yards8 >= ui.value("Units To AoE")) or (ui.mode.rotation == 2 and #enemies.yards8 > 0)) 
    then
        if cast.felBarrage("player","aoe",1,8) then ui.debug("Casting Fel Barrage") return true end
    end
    -- Death Sweep
    -- death_sweep,if=variable.blade_dance
    if cast.able.deathSweep() and not unit.isExplosive("target") and #enemies.yards8 >= 1 and var.bladeDance then
        if cast.deathSweep("player","aoe",1,8) then ui.debug("Casting Death Sweep") return true end
    end
    -- Immolation Aura
    -- immolation_aura
    if cast.able.immolationAura() and not unit.isExplosive("target") and #enemies.yards8 > 0 then
        if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura") return true end
    end
    -- Glaive Tempest
    -- glaive_tempest,if=!variable.waiting_for_momentum&(active_enemies>desired_targets|raid_event.adds.in>10)
    --if cast.able.glaiveTempest() and not var.waitingForMomentum and unit.distance("target") < 1 then
        --if cast.glaiveTempest() then ui.debug("Casting Glaive Tempest") return true end
    --end
    -- Throw Glaive
    -- throw_glaive,if=conduit.serrated_glaive.enabled&cooldown.eye_beam.remains<6&!buff.metamorphosis.up&!debuff.exposed_wound.up
    if ui.checked("Throw Glaive") and cast.able.throwGlaive() and conduit.serratedGlaive and cd.eyeBeam.remains() < 6 and not buff.metamorphosis.exists() and not debuff.exposedWound.exists(units.dyn10) then
        if cast.throwGlaive() then ui.debug("Casting Throw Glaive [Serrated Glaive]") return true end
    end
    -- Eye Beam
    -- eye_beam,if=!variable.waiting_for_momentum&(active_enemies>desired_targets|raid_event.adds.in>15)
    if ui.mode.eyeBeam == 1 and not unit.isExplosive("target") and cast.able.eyeBeam() and enemies.yards20r > 1 and not unit.moving() and not var.waitingForMomentum
        and (eyebeamTTD() or unit.isDummy(units.dyn8))
		or ui.mode.rotation == 3
    then
        if cast.eyeBeam("player","rect",1,20) then ui.debug("Casting Eye Beam [Multi]") return true end
    end
    -- Blade Dance
    -- blade_dance,if=variable.blade_dance
    if cast.able.bladeDance() and not unit.isExplosive("target") and #enemies.yards8 >= 1 and var.bladeDance then
        if cast.bladeDance("player","aoe",1,8) then ui.debug("Casting Blade Dance") return true end
    end
    -- Felblade
    -- felblade,if=fury.deficit>=40
    if cast.able.felblade() and furyDeficit >= 40 and not cast.last.vengefulRetreat() and unit.distance("target") <= 1 then
        if cast.felblade() then ui.debug("Casting Fel Blade") return true end
    end
    -- Annihilation
    -- annihilation,if=(talent.demon_blades.enabled|!variable.waiting_for_momentum|fury.deficit<30|buff.metamorphosis.remains<5)&!variable.pooling_for_blade_dance&!variable.waiting_for_essence_break
    if cast.able.annihilation() and (talent.demonBlades or not var.waitingForMomentum or furyDeficit < 30 or buff.metamorphosis.remain() < 5)
        and not var.poolForBladeDance and not var.waitingForEssenceBreak
    then
        if cast.annihilation() then ui.debug("Casting Annihilation") return true end
    end
    -- Chaos Strike
    -- chaos_strike,if=(talent.demon_blades.enabled|!variable.waiting_for_momentum|fury.deficit<30)&!variable.pooling_for_meta&!variable.pooling_for_blade_dance&!variable.waiting_for_essence_break
    if cast.able.chaosStrike() and (talent.demonBlades or not var.waitingForMomentum or furyDeficit < 30)
        and not var.poolForMeta and not var.poolForBladeDance and not var.waitingForEssenceBreak
    then
        if cast.chaosStrike() then ui.debug("Casting Chaos Strike") return true end
    end
    -- Eye Beam
    -- eye_beam,if=talent.blind_fury.enabled&raid_event.adds.in>cooldown
    if ui.mode.eyeBeam == 1 and not unit.isExplosive("target") and cast.able.eyeBeam()
        and enemies.yards20r > 0 and not unit.moving() and talent.blindFury
        and (not talent.momentum or buff.momentum.exists()) and (eyebeamTTD() or unit.isDummy(units.dyn8))
		or ui.mode.rotation == 3
    then
        if cast.eyeBeam("player","rect",1,20) then ui.debug("Casting Eye Beam [Blind Fury]") return true end
    end
    -- Demon's Bite
    -- demons_bite,target_if=min:debuff.burning_wound.remains,if=runeforge.burning_wound.equipped&debuff.burning_wound.remains<4
    if cast.able.demonsBite(var.lowestBurningWound) and runeforge.burningWound.equiped and debuff.burningWound.remain(units.dyn5) < 4 then
        if cast.demonsBite(var.lowestBurningWound) then ui.debug("Casting Demon's Bite [Burning Wound]") return true end
    end
    -- demons_bite
    if cast.able.demonsBite(units.dyn5) and not talent.demonBlades and furyDeficit >= 30 then
        if cast.demonsBite(units.dyn5) then ui.debug("Casting Demon's Bite") return true end
    end
    -- Fel Rush
    -- fel_rush,if=!talent.momentum.enabled&raid_event.movement.in>charges*10&talent.demon_blades.enabled
    if cast.able.felRush() and not unit.isExplosive("target") and unit.facing("player","target",10) and not talent.momentum
        and talent.demonBlades and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation()
        elseif not ui.checked("Fel Rush Only In Melee") and (ui.mode.mover == 2 or (unit.distance("target") >= 8 and ui.mode.mover ~= 3)) then
            if cast.felRush() then ui.debug("Casting Fel Rush [Demon Blades]") return true end
        end
    end
    -- Felblade
    -- felblade,if=movement.distance|buff.out_of_range.up
    --if cast.able.felblade() and unit.distance("target") > 8 and not cast.last.vengefulRetreat() and unit.distance("target") >= 10 and unit.distance("target") < 15 then
    --    if cast.felblade("target") then ui.debug("Casting Fel Blade [Out of Range") return true end
    --end
    -- Fel Rush
    -- fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum.enabled)
    if not ui.checked("Fel Rush Only In Melee") and not unit.isExplosive("target") and cast.able.felRush()
        and ui.mode.mover ~= 3 and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
        and (unit.distance("target") > 15 or (unit.distance("target") > 8 and not talent.momentum))
    then
        if cast.felRush() then ui.debug("Casting Fel Rush [Out of Range]") return true end
    end
    -- Throw Glaive
    -- throw_glaive,if=talent.demon_blades.enabled
    if ui.checked("Throw Glaive") and cast.able.throwGlaive() and talent.demonBlades then
        if cast.throwGlaive(nil,"aoe",1,10) then ui.debug("Casting Throw Glaive [Demon Blades]") return true end
    end
end -- End Action List - Normal

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (IsFlying() or IsMounted()) then
        -- Fel Crystal Fragments -- Only Usable in Madum/Vault of the Wardens
        -- if not buff.felCrystalInfusion.exists() and use.able.felCrystalFragments() and has.felCrystalFragments() then
        --     if use.felCrystalFragments() then ui.debug("Using Fel Crystal Fragments") return true end
        -- end
        -- Flask Module
        -- flask
        module.FlaskUp("Agility")
        -- Battle Scarred Augment Rune
        if ui.checked("Augment Rune") and var.inRaid and not buff.battleScarredAugmentation.exists()
            and use.able.battleScarredAugmentRune() and var.lastRune + gcd < GetTime()
        then
            if use.battleScarredAugmentRune() then ui.debug("Using Battle Scarred Augment Rune") var.lastRune = GetTime() return true end
        end
        if ui.checked("Pre-Pull Timer") and (var.inRaid or var.inInstance) and ui.pullTimer()<= ui.value("Pre-Pull Timer") then
            -- Potion
            if ui.value("Potion") ~= 5 and ui.pullTimer()<= 1 then
                if ui.value("Potion") == 1 and use.able.potionOfUnbridledFury() then
                    use.potionOfUnbridledFury()
                    ui.debug("Using Potion of Unbridled Fury")
                end
            end
        end -- End Pre-Pull
        if ui.checked("M+ Pre-Pull") and var.inMythic and ui.pullTimer()<= ui.value("M+ Meta Pre-Pull") then
            -- Eye Beam
            if cast.able.eyeBeam() then
                cast.eyeBeam()
                ui.debug("Castin Eye Beam [Pre-Pull]")
            end
            -- Metamorphosis
            if ui.checked("Metamorphosis") and cast.able.metamorphosis() then
                if cast.metamorphosis("player") then ui.debug("Casting Metamorphosis [Pre-Pull]") return true end
            end
        end -- End M+ Pre-Pull
        if unit.exists("target") and unit.valid("target") and unit.facing("target") and unit.distance("target") < 30 then
            if ui.checked("Auto Engage") and var.solo then
                -- Throw Glaive
                if ui.checked("Throw Glaive") and cast.able.throwGlaive("target") and #enemies.yards10tnc == 1 then
                    if cast.throwGlaive("target","aoe") then ui.debug("Casting Throw Glaive [Pre-Pull]") return true end
                end
                -- Torment
                if cast.able.torment("target") and (cast.timeSinceLast.throwGlaive() > unit.gcd(true) or not ui.checked("Throw Glaive")) then
                    if cast.torment("target") then ui.debug("Casting Torment [Pre-Pull]") return true end
                end
            end
            -- Start Attack
            -- auto_attack
            if unit.distance("target") < 5 then
                StartAttack()
            end
        end
    end -- End No Combat
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------
    --- BR API ---
    --------------
    buff                                            = br.player.buff
    cast                                            = br.player.cast
    cd                                              = br.player.cd
    charges                                         = br.player.charges
    conduit                                         = br.player.conduit
    covenant                                        = br.player.covenant
    debuff                                          = br.player.debuff
    enemies                                         = br.player.enemies
    equiped                                         = br.player.equiped
    fury                                            = br.player.power.fury.amount()
    furyDeficit                                     = br.player.power.fury.deficit()
    gcd                                             = br.player.unit.gcd(true)
    module                                          = br.player.module
    race                                            = br.player.race
    runeforge                                       = br.player.runeforge
    ui                                              = br.player.ui
    unit                                            = br.player.unit
    units                                           = br.player.units
    use                                             = br.player.use
    talent                                          = br.player.talent

    ------------
    --- Vars ---
    ------------

    var.combatTime                                  = getCombatTime()
    var.falling                                     = getFallTime()
    var.flood                                       = (equiped.soulOfTheSlayer() or talent.firstBlood) and 1 or 0
    var.getHealPot                                  = getHealthPot()
    var.hasHealPot                                  = hasHealthPot()
    var.inInstance                                  = unit.instance=="party"
    var.inMythic                                    = select(3,GetInstanceInfo())==23
    var.inRaid                                      = unit.instance=="raid"
    var.lowestBurningWound                          = debuff.burningWound.lowest(5,"remain") or "target"
    var.solo                                        = #br.friend == 1

    units.get(5)
    units.get(8)
    units.get(30)
    enemies.get(5)
    enemies.get(8)
    enemies.get(8,"player",false,true) -- makes enemies.yards8f
    enemies.get(8,"target") -- makes enemies.yards8t
    enemies.get(10)
    enemies.get(10,"target",true)
    enemies.get(20)
    enemies.get(30)
    enemies.get(40)
    enemies.get(40,"player",false,true)
    enemies.get(50)
    enemies.yards20r, enemies.yards20rTable = getEnemiesInRect(10,20,false)
    enemies.yards25r = getEnemiesInRect(8,25,false) or 0
    
    if cast.active.eyeBeam("player") and buff.metamorphosis.exists() then
        var.metaExtended = true 
    elseif not buff.metamorphosis.exists() then
        var.metaExtended = false 
    end

    var.ruinedTrail = talent.trailOfRuin and 1 or 0
    var.meta = buff.metamorphosis.exists() and 1 or 0

    -- Blade Dance Variable
    -- variable,name=blade_dance,value=talent.first_blood.enabled|spell_targets.blade_dance1>=(3-(talent.trail_of_ruin.enabled+buff.metamorphosis.up))|runeforge.chaos_theory&buff.chaos_theory.down
    var.bladeDance = (talent.cycleOfHatred or talent.firstBlood or #enemies.yards8 >= (2 - (var.ruinedTrail + var.meta)) or (runeforge.chaosTheory and not buff.chaosTheory.exists())) and #enemies.yards8 >= 1 and not unit.isExplosive("target") -- (ui.mode.rotation == 1 and #enemies.yards8 >= ui.value("Units To AoE")) or ui.mode.rotation == 2)
    -- Pool for Meta Variable
    -- variable,name=pooling_for_meta,value=!talent.demonic.enabled&cooldown.metamorphosis.remains<6&fury.deficit>30
    var.poolForMeta = ui.checked("Metamorphosis") and ui.useCDs() and not talent.demonic and cd.metamorphosis.remain() < 6 and furyDeficit >= 30
    -- Pool for Blade Dance Variable
    -- variable,name=pooling_for_blade_dance,value=variable.blade_dance&(fury<75-talent.first_blood.enabled*20)
    var.poolForBladeDance = var.bladeDance and fury < 75 - var.flood * 20 and not unit.isExplosive("target")
    -- Pool for Eye Beam
    -- variable,name=pooling_for_eye_beam,value=talent.demonic.enabled&!talent.blind_fury.enabled&cooldown.eye_beam.remains<(gcd.max*2)&fury.deficit>20
    var.poolForEyeBeam = talent.demonic and not talent.blindFury and cd.eyeBeam.remain() < (gcd * 2) and furyDeficit >= 20 and not unit.isExplosive("target")
    -- Waiting for Essence Break
    -- variable,name=waiting_for_essence_break,value=talent.essence_break.enabled&!variable.pooling_for_blade_dance&!variable.pooling_for_meta&cooldown.essence_break.up
    var.waitingForEssenceBreak = talent.essenceBreak and not var.poolForBladeDance and not var.poolingForMeta and cd.essenceBreak.ready()
    -- Wait for Momentum
    -- variable,name=waiting_for_momentum,value=talent.momentum.enabled&!buff.momentum.up
    var.waitingForMomentum = talent.momentum and not buff.momentum.exists()

    -- if ui.mode.mover == 1 and cast.last.vengefulRetreat() then StopFalling(); end
    -- if IsHackEnabled("NoKnockback") then
    --     SetHackEnabled("NoKnockback", false)
    -- end
    -- Fel Rush Special
    if unit.inCombat() and ui.checked("Auto Fel Rush After Retreat") and cast.able.felRush()
        and buff.prepared.exists() and not buff.momentum.exists() and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation()
        elseif not ui.checked("Fel Rush Only In Melee") and (ui.mode.mover == 2 or (unit.distance("target") >= 8 and ui.mode.mover ~= 3)) then
            if cast.felRush() then ui.debug("Casting Fel Rush [Special]") return true end
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not IsMounted() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or (IsMounted() or IsFlying()) or pause() or ui.mode.rotation==4 or cast.active.eyeBeam() then
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
        if unit.inCombat() and not IsMounted() and not var.profileStop and unit.valid("target") then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return true end
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            if ui.value("APL Mode") == 1 then
                -- Start Attack
                if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    StartAttack()
                end
                -- Cooldowns
                -- call_action_list,name=cooldown,if=gcd.remains=0
                if cd.global.remain() == 0 then
                    if actionList.Cooldowns() then return true end
                end
                -- Pickup Fragments
                -- pick_up_fragment,if=demon_soul_fragments>0
                -- pick_up_fragment,if=fury.deficit>=35
                if furyDeficit >= 35 then
                    ui.chatOverlay("Low Fury - Pickup Fragments!")
                end
                -- Throw Glaive
                -- throw_glaive,if=buff.fel_bombardment.stack=5&(buff.immolation_aura.up|!buff.metamorphosis.up)
                if ui.checked("Throw Glaive") and cast.able.throwGlaive() and buff.felBombardment.stack() == 5 and (buff.imolationAura.exists() or not buff.metamorphosis.exists()) then
                    if cast.throwGlaive(nil,"aoe",1,10) then ui.debug("Casting Throw Glaive [Fel Bombardment]") return true end
                end
                -- Call Action List - Essence Break
                -- call_action_list,name=essence_break,if=talent.essence_break.enabled&(variable.waiting_for_essence_break|debuff.essence_break.up)
                if talent.essenceBreak and (var.waitingForEssenceBreak or debuff.essenceBreak.exists(units.dyn5)) then
                    if actionList.EssenceBreak() then return true end
                end
                -- Call Action List - Demonic
                -- run_action_list,name=demonic,if=talent.demonic.enabled
                if talent.demonic then
                    if actionList.Demonic() then return true end
                else
                    -- Call Action List - Normal
                    -- run_action_list,name=normal
                    if actionList.Normal() then return true end
                end
            end -- End SimC APL
        end --End In Combat
    end --End Rotation Logic
end -- End runRotation
local id = 577
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
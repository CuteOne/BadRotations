local rotationName = "CuteOne"
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.bladeDance},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladeDance},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.chaosStrike},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.spectralSight}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.metamorphosis},
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.metamorphosis},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.metamorphosis}
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.darkness},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.darkness}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.consumeMagic},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.consumeMagic}
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
    -- Mover
    local MoverModes = {
        [1] = { mode = "AC", value = 1 , overlay = "Movement Animation Cancel Enabled", tip = "Will Cancel Movement Animation.", highlight = 1, icon = br.player.spell.felRush},
        [2] = { mode = "On", value = 2 , overlay = "Auto Movement Enabled", tip = "Will Cast Movement Abilities.", highlight = 0, icon = br.player.spell.felRush},
        [3] = { mode = "Off", value = 3 , overlay = "Auto Movement Disabled", tip = "Will NOT Cast Movement Abilities", highlight = 0, icon = br.player.spell.felRush}
    };
    br.ui:createToggle(MoverModes,"Mover",5,0)
    -- Hold Eye Beam
    local EyeBeamModes = {
        [1] = { mode = "On", value = 1 , overlay = "Use Eye beam", tip = "Use Eye beam", highlight = 1, icon = br.player.spell.eyeBeam},
        [2] = { mode = "Off", value = 2 , overlay = "Don't use Eye beam", tip = "Don't use Eye beam", highlight = 0, icon = br.player.spell.eyeBeam}
    };
    br.ui:createToggle(EyeBeamModes,"EyeBeam",6,0)
    -- Hold Fel Barrage
    local FelBarrageModes = {
        [1] = { mode = "On", value = 1 , overlay = "Use Fel Barrage", tip = "Use Fel Barrage", highlight = 1, icon = br.player.spell.felBarrage},
        [2] = { mode = "Off", value = 2 , overlay = "Don't use Fel Barrage", tip = "Don't use Fel Barrage", highlight = 0, icon = br.player.spell.felBarrage}
    };
    br.ui:createToggle(FelBarrageModes,"FelBarrage",7,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        local alwaysCdNever = {"|cff0000FFAlways","|cffFFFFFFCD Only","|cffFF0000Never"}
        local alwaysCdAoENever = {"Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never"}
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
            br.ui:createDropdownWithout(section,"Metamorphosis",alwaysCdAoENever,1,"|cffFFBB00When to use Metamorphosis.")
            br.ui:createCheckbox(section,"Metamorphosis M+ Pre-pull","Uses Meta during M+ pre-pull, regardless of CD setting.")
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
var.leftCombat = br._G.GetTime()
var.lastRune = br._G.GetTime()
var.profileStop = false
var.useBasicTrinkets = false

-- Custom Functions
local function cancelRushAnimation(debugMessage)
    -- if cast.able.felRush() and GetUnitSpeed("player") == 0 then
        br._G.MoveBackwardStart()
        br._G.JumpOrAscendStart()
        cast.felRush()
        br._G.MoveBackwardStop()
        br._G.AscendStop()
        ui.debug(debugMessage)
    -- end
    return true
end
-- local function cancelRetreatAnimation()
--     if cast.able.vengefulRetreat() then

--         -- C_Timer.After(.001, function() SetHackEnabled("NoKnockback", true) end)
--         -- C_Timer.After(.35, function() cast.vengefulRetreat() end)
--         -- C_Timer.After(.55, function() SetHackEnabled("NoKnockback", false) end)
--         -- SetHackEnabled("NoKnockback", true)
--         if cast.vengefulRetreat() then
--             C_Timer.After(.35, function() StopFalling(); end)
--             C_Timer.After(.55, function() MoveForwardStart(); end)
--             C_Timer.After(.75, function() MoveForwardStop(); end)
--         --     SetHackEnabled("NoKnockBack", false)
--         end
--     end
--     return
-- end
local function eyebeamTTD()
    local length = talent.blindFury and 3 or 2
    if #enemies.yards20r > 0 then
        for i = 1, #enemies.yards20r do
            if unit.ttd(enemies.yards20r[i]) >= length then
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
            if br.getCombatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy("target") then
                br._G.StopAttack()
                br._G.ClearTarget()
                br._G.Print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
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
                if br.canInterrupt(thisUnit,ui.value("Interrupt At")) and cast.able.felEruption(thisUnit) then
                    if cast.felEruption(thisUnit) then ui.debug("Casting Fel Eruption") return true end
                end
            end
        end
        -- Disrupt
        if ui.checked("Disrupt") then
            for i=1, #enemies.yards10 do
                local thisUnit = enemies.yards10[i]
                if br.canInterrupt(thisUnit,ui.value("Interrupt At")) and cast.able.disrupt(thisUnit) then
                    if cast.disrupt(thisUnit) then ui.debug("Casting Disrupt") return true end
                end
            end
        end
        -- Chaos Nova
        if ui.checked("Chaos Nova") then
            for i=1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if br.canInterrupt(thisUnit,ui.value("InterruptAt")) and cast.able.chaosNova(thisUnit) then
                    if cast.chaosNova(thisUnit) then ui.debug("Casting Chaos Nova [Int]") return true end
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
        if ui.alwaysCdAoENever("Metamorphosis",3,8) and cast.able.metamorphosis("player") and #enemies.yards8 > 0 then
            -- metamorphosis,if=!talent.demonic.enabled&(cooldown.eye_beam.remains>20|fight_remains<25)
            -- metamorphosis,if=talent.demonic.enabled&(cooldown.eye_beam.remains>20&(!variable.blade_dance|cooldown.blade_dance.remains>gcd.max)|fight_remains<25)
            if not talent.demonic and cd.eyeBeam.remains() > 20 then
                if cast.metamorphosis("player") then ui.debug("Casting Metamorphosis") return true end
            end
            if talent.demonic and cd.eyeBeam.remains() > 20 and (not var.bladeDance or cd.bladeDance.remain() > gcd) then
                if cast.metamorphosis("player") then ui.debug("Casting Metamorphosis [Demonic]") return true end
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
        -- use_item,name=cache_of_acquired_treasures,if=buff.acquired_axe.up&(active_enemies=desired_targets&raid_event.adds.in>60|active_enemies>desired_targets|fight_remains<25)
        -- use_items,slots=trinket1,if=variable.trinket_sync_slot=1&(buff.metamorphosis.up|(!talent.demonic.enabled&cooldown.metamorphosis.remains>(fight_remains>?trinket.1.cooldown.duration%2))|fight_remains<=20)|(variable.trinket_sync_slot=2&!trinket.2.cooldown.ready)|!variable.trinket_sync_slot
        -- use_items,slots=trinket2,if=variable.trinket_sync_slot=2&(buff.metamorphosis.up|(!talent.demonic.enabled&cooldown.metamorphosis.remains>(fight_remains>?trinket.2.cooldown.duration%2))|fight_remains<=20)|(variable.trinket_sync_slot=1&!trinket.1.cooldown.ready)|!variable.trinket_sync_slot
        if buff.metamorphosis.exists() or not ui.alwaysCdAoENever("Metamorphosis",3,8) then
            module.BasicTrinkets()
        end
        -- Covenant Abilities
        if ui.alwaysCdAoENever("Covenant Ability",3,8) then
            -- Sinful Brand
            -- sinful_brand,if=!dot.sinful_brand.ticking&(!runeforge.agony_gaze|(cooldown.eye_beam.remains<=gcd&fury>=30))&(!cooldown.metamorphosis.up|active_enemies=1)
            if cast.able.sinfulBrand() and not debuff.sinfulBrand.exists(units.dyn5)
                and (not runeforge.agonyGaze.equiped or (cd.eyeBeam.remain() <= gcd and fury >= 30))
                and (not cd.metamorphosis.exists() or #enemies.yards5 == 1)
            then
                if cast.sinfulBrand() then ui.debug("Casting Sinful Brand") return true end
            end
            -- The Hunt
            -- the_hunt,if=!talent.demonic.enabled&!variable.waiting_for_momentum&!variable.pooling_for_meta|buff.furious_gaze.up
            if cast.able.theHunt() and ((not talent.demonic and not var.waitingForMomentum and not var.poolForMeta) or buff.furiousGaze.exists()) then
                if cast.theHunt() then ui.debug("Casting The Hunt") return true end
            end
            -- Elysian Decree
            -- elysian_decree,if=(active_enemies>desired_targets|raid_event.adds.in>30)
            if cast.able.elysianDecree("best",nil,1,8) and unit.standingTime() > 2
                and ((ui.mode.rotation == 1 and #enemies.yards8 >= ui.value("Units To AoE")) or ui.mode.rotation == 2 or ui.useCDs())
            then
                if cast.elysianDecree("best",nil,1,8) then ui.debug("Casting Elysian Decree") return true end
            end
            -- Fleshcraft
            -- fleshcraft,if=soulbind.volatile_solvent&!buff.volatile_solvent_humanoid.up,interrupt_immediate=1,interrupt_global=1,interrupt_if=soulbind.volatile_solvent
        end
    end
end -- End Action List - Cooldowns

-- Action List - Demonic
actionList.Demonic = function()
    -- Eye Beam
    -- eye_beam,if=runeforge.agony_gaze&(active_enemies>desired_targets|raid_event.adds.in>25-talent.cycle_of_hatred*10)&dot.sinful_brand.ticking&dot.sinful_brand.remains<=gcd
    if ui.mode.eyeBeam == 1 and not unit.isExplosive("target") and cast.able.eyeBeam("player","rect",1,20)
        and not unit.moving() and #enemies.yards20r > 0 and (eyebeamTTD() or unit.isDummy(units.dyn8))
        and runeforge.agonyGaze.equiped and debuff.sinfulBrand.exists(units.dyn5) and debuff.sinfulBrand.remain(units.dyn5) <= gcd
    then
        if cast.eyeBeam("player","rect",1,20) then ui.debug("Casting Eye Beam [Agony Gaze]") return true end
    end
    -- Fel Rush
    -- fel_rush,if=talent.unbound_chaos.enabled&buff.unbound_chaos.up&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
    if cast.able.felRush() and ui.mode.mover ~= 3 and not unit.isExplosive("target") and #enemies.yards23r > 0
        and talent.unboundChaos and buff.unboundChaos.exists()
        and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush [Unbound Chaos]")
            return true
        elseif not ui.checked("Fel Rush Only In Melee") and (ui.mode.mover == 2 or (unit.distance("target") >= 8 and ui.mode.mover ~= 3)) then
            if cast.felRush() then ui.debug("Casting Fel Rush [Unbound Chaos]") return true end
        end
    end
    -- Death Sweep
    -- death_sweep,if=variable.blade_dance
    if cast.able.deathSweep("player","aoe",1,8) and not unit.isExplosive("target") and #enemies.yards8 > 0 and var.bladeDance then
        if cast.deathSweep("player","aoe",1,8) then ui.debug("Casting Death Sweep") return true end
    end
    -- Glaive Tempest
    -- glaive_tempest,if=active_enemies>desired_targets|raid_event.adds.in>10
    if cast.able.glaiveTempest("player","aoe",1,8) and unit.standingTime() > 2
        and ((ui.mode.rotation == 1 and #enemies.yards8 >= ui.value("Units To AoE")) or ui.mode.rotation == 2 or ui.useCDs() or unit.ttd(units.dyn5) >= 7)
    then
        if cast.glaiveTempest("player","aoe",1,8) then ui.debug("Casting Glaive Tempest") return true end
    end
    -- Throw Glaive
    -- throw_glaive,if=conduit.serrated_glaive.enabled&cooldown.eye_beam.remains<6&!buff.metamorphosis.up&!debuff.exposed_wound.up
    if ui.checked("Throw Glaive") and cast.able.throwGlaive() and conduit.serratedGlaive.enabled and cd.eyeBeam.remains() < 6
        and not buff.metamorphosis.exists() and not debuff.exposedWound.exists(units.dyn10)
    then
        if cast.throwGlaive() then ui.debug("Casting Throw Glaive [Serrated Glaive]") return true end
    end
    -- Eye Beam
    -- eye_beam,if=active_enemies>desired_targets|raid_event.adds.in>25-talent.cycle_of_hatred*10&(!variable.use_eye_beam_fury_condition|spell_targets>1|fury<70)&!variable.waiting_for_agony_gaze
    if ui.mode.eyeBeam == 1 and not unit.isExplosive("target") and cast.able.eyeBeam("player","rect",1,20)
        and not unit.moving() and #enemies.yards20r > 0 and (eyebeamTTD() or unit.isDummy(units.dyn8)) and not var.waitingForAgonyGaze
    then
        if (ui.value("Eye Beam Usage") == 1 and (not var.useEyeBeamFuryCondition or #enemies.yards20r >= ui.value("Units To AoE") or fury < 70))
            or (ui.value("Eye Beam Usage") == 2 and (#enemies.yards20r >= ui.value("Units To AoE") or ui.mode.rotation == 2))
        then
            if cast.eyeBeam("player","rect",1,20) then ui.debug("Casting Eye Beam") return true end
        end
    end
    -- Blade Dance
    -- blade_dance,if=variable.blade_dance&!cooldown.metamorphosis.ready&(cooldown.eye_beam.remains>5|(raid_event.adds.in>cooldown&raid_event.adds.in<25))
    if cast.able.bladeDance("player","aoe",1,8) and not unit.isExplosive("target") and #enemies.yards8 > 0 and var.bladeDance
        and (cd.metamorphosis.remain() > unit.gcd(true) or not ui.useCDs() or not ui.alwaysCdAoENever("Metamorphosis",3,8))
        and (cd.eyeBeam.remain() > 5 or not eyebeamTTD() or not cast.safe.eyeBeam("player","rect",1,20) or ui.mode.eyeBeam == 2)
    then
        if cast.bladeDance("player","aoe",1,8) then ui.debug("Casting Blade Dance") return true end
    end
    -- Immolation Aura
    -- immolation_aura,if=!buff.immolation_aura.up
    if cast.able.immolationAura() and not unit.isExplosive("target") and #enemies.yards8 > 0 and not buff.immolationAura.exists() then
        if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura") return true end
    end
    -- Annihilation
    -- annihilation,if=!variable.pooling_for_blade_dance
    if cast.able.annihilation() and not var.poolForBladeDance then
        if cast.annihilation() then ui.debug("Casting Annihilation") return true end
    end
    -- Felblade
    -- felblade,if=fury.deficit>=40
    if cast.able.felblade() and furyDeficit >= 40 and not cast.last.vengefulRetreat() and unit.distance(units.dyn15) < 5 then
        if cast.felblade() then ui.debug("Casting Felblade") return true end
    end
    -- Essence Break
    -- essence_break
    if cast.able.essenceBreak() then
        if cast.essenceBreak() then ui.debug("Casting Essence Break") return true end
    end
    -- Chaos Strike
    -- chaos_strike,if=!variable.pooling_for_blade_dance&!variable.pooling_for_eye_beam
    if cast.able.chaosStrike() and not var.poolForBladeDance and not var.poolForEyeBeam then
        if cast.chaosStrike() then ui.debug("Casting Chaos Strike") return true end
    end
    -- Fel Rush
    -- fel_rush,if=talent.demon_blades.enabled&!cooldown.eye_beam.ready&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
    if cast.able.felRush() and ui.mode.mover ~= 3 and not unit.isExplosive("target") and #enemies.yards23r > 0
        and talent.demonBlades and cd.eyeBeam.remain() > gcd
        and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush [Demon Blades]")
            return true
        elseif not ui.checked("Fel Rush Only In Melee") and (ui.mode.mover == 2 or (unit.distance("target") >= 8 and ui.mode.mover ~= 3)) then
            if cast.felRush() then ui.debug("Casting Fel Rush [Demon Blades]") return true end
        end
    end
    -- Demon's Bite
    -- demons_bite,target_if=min:debuff.burning_wound.remains,if=runeforge.burning_wound.equipped&debuff.burning_wound.remains<4
    if cast.able.demonsBite(var.lowestBurningWound) and runeforge.burningWound.equiped and debuff.burningWound.remain(var.lowestBurningWound) < 4 then
        if cast.demonsBite(var.lowestBurningWound) then ui.debug("Casting Demon's Bite [Burning Wound]") return true end
    end
    -- Fel Rush
    -- fel_rush,if=!talent.demon_blades.enabled&spell_targets>1&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
    if cast.able.felRush() and ui.mode.mover ~= 3 and not unit.isExplosive("target") and #enemies.yards23r > 0
        and not talent.demonBlades and #enemies.yards23r > 1 and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush [AOE]")
            return true
        elseif not ui.checked("Fel Rush Only In Melee") and (ui.mode.mover == 2 or (unit.distance("target") >= 8 and ui.mode.mover ~= 3)) then
            if cast.felRush() then ui.debug("Casting Fel Rush [AOE]") return true end
        end
    end
    -- Demon's Bite
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
    -- Vengeful Retreat
    -- vengeful_retreat,if=movement.distance>15
    -- Throw Glaive
    -- throw_glaive,if=talent.demon_blades.enabled
    if ui.checked("Throw Glaive") and cast.able.throwGlaive() and talent.demonBlades then
        if cast.throwGlaive() then ui.debug("Casting Throw Glaive [Demon Blades]") return true end
    end
end -- End Action List - Demonic

-- Action List - Normal
actionList.Normal = function()
    -- Eye Beam
    -- eye_beam,if=runeforge.agony_gaze&(active_enemies>desired_targets|raid_event.adds.in>15)&dot.sinful_brand.ticking&dot.sinful_brand.remains<=gcd
    if ui.mode.eyeBeam == 1 and not unit.isExplosive("target") and cast.able.eyeBeam("player","rect",1,20)
        and not unit.moving() and #enemies.yards20r > 0 and (eyebeamTTD() or unit.isDummy(units.dyn8))
        and runeforge.agonyGaze.equiped and debuff.sinfulBrand.exists(units.dyn5) and debuff.sinfulBrand.remain(units.dyn5) <= gcd
    then
        if cast.eyeBeam("player","rect",1,20) then ui.debug("Casting Eye Beam [Agony Gaze]") return true end
    end
    -- Vengeful Retreat
    -- vengeful_retreat,if=talent.momentum.enabled&buff.prepared.down&time>1
    if ui.checked("Vengeful Retreat") and cast.able.vengefulRetreat() and talent.momentum
        and not buff.prepared.exists() and var.combatTime > 1 and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5
    then
        -- if ui.mode.mover == 1 then
        --     cancelRetreatAnimation()
        -- elseif ui.mode.mover == 2 then
            if cast.vengefulRetreat() then ui.debug("Casting Vengeful Retreat [Momentum]") return true end
        -- end
    end
    -- Fel Rush
    -- fel_rush,if=(buff.unbound_chaos.up|variable.waiting_for_momentum&(!talent.unbound_chaos.enabled|!cooldown.immolation_aura.ready))&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
    if cast.able.felRush() and ui.mode.mover ~= 3 and not unit.isExplosive("target") and #enemies.yards23r > 0
        and ((buff.unboundChaos.exists() or (var.waitingForMomentum and (not talent.unboundChaos or cd.immolationAura.exists()))))
        and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush [Momentum/Unbound Chaos]")
            return true
        elseif not ui.checked("Fel Rush Only In Melee") and (ui.mode.mover == 2 or (unit.distance("target") >= 8 and ui.mode.mover ~= 3)) then
            if cast.felRush() then ui.debug("Casting Fel Rush [Momentum/Unbound Chaos]") return true end
        end
    end
    -- Fel Barrage
    -- fel_barrage,if=active_enemies>desired_targets|raid_event.adds.in>30
    if ui.mode.felBarrage == 1 and not unit.isExplosive("target") and cast.able.felBarrage("player","aoe",1,8)
        and ((ui.mode.rotation == 1 and #enemies.yards8 >= ui.value("Units To AoE")) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
    then
        if cast.felBarrage("player","aoe",1,8) then ui.debug("Casting Fel Barrage") return true end
    end
    -- Death Sweep
    -- death_sweep,if=variable.blade_dance
    if cast.able.deathSweep("player","aoe",1,8) and not unit.isExplosive("target") and #enemies.yards8 > 0 and var.bladeDance then
        if cast.deathSweep("player","aoe",1,8) then ui.debug("Casting Death Sweep") return true end
    end
    -- Immolation Aura
    -- immolation_aura,if=!buff.immolation_aura.up
    if cast.able.immolationAura() and not unit.isExplosive("target") and #enemies.yards8 > 0 and not buff.immolationAura.exists() then
        if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura") return true end
    end
    -- Glaive Tempest
    -- glaive_tempest,if=!variable.waiting_for_momentum&(active_enemies>desired_targets|raid_event.adds.in>10)
    if cast.able.glaiveTempest("player","aoe",1,8) and not var.waitingForMomentum and unit.standingTime() > 2
        and ((ui.mode.rotation == 1 and #enemies.yards8 >= ui.value("Units To AoE")) or ui.mode.rotation == 2 or ui.useCDs() or unit.ttd(units.dyn5) >= 7)
    then
        if cast.glaiveTempest("player","aoe",1,8) then ui.debug("Casting Glaive Tempest") return true end
    end
    -- Throw Glaive
    -- throw_glaive,if=conduit.serrated_glaive.enabled&cooldown.eye_beam.remains<6&!buff.metamorphosis.up&!debuff.exposed_wound.up
    if ui.checked("Throw Glaive") and cast.able.throwGlaive() and conduit.serratedGlaive and cd.eyeBeam.remains() < 6 and not buff.metamorphosis.exists() and not debuff.exposedWound.exists(units.dyn10) then
        if cast.throwGlaive() then ui.debug("Casting Throw Glaive [Serrated Glaive]") return true end
    end
    -- Eye Beam
    -- eye_beam,if=!variable.waiting_for_momentum&(active_enemies>desired_targets|raid_event.adds.in>15&(!variable.use_eye_beam_fury_condition|spell_targets>1|fury<70)&!variable.waiting_for_agony_gaze)
    if ui.mode.eyeBeam == 1 and not unit.isExplosive("target") and cast.able.eyeBeam("player","rect",1,20)
        and not unit.moving() and #enemies.yards20r >= 0 and (eyebeamTTD() or unit.isDummy(units.dyn8))
        and not var.waitingForMomentum and not var.waitingForAgonyGaze
    then
        if (ui.value("Eye Beam Usage") == 1 and (not var.useEyeBeamFuryCondition or #enemies.yards20r >= ui.value("Units To AoE") or fury < 70))
            or (ui.value("Eye Beam Usage") == 2 and (#enemies.yards20r >= ui.value("Units To AoE") or ui.mode.rotation == 2))
        then
            if cast.eyeBeam("player","rect",1,20) then ui.debug("Casting Eye Beam") return true end
        end
    end
    -- Blade Dance
    -- blade_dance,if=variable.blade_dance
    if cast.able.bladeDance("player","aoe",1,8) and not unit.isExplosive("target") and #enemies.yards8 > 0 and var.bladeDance then
        if cast.bladeDance("player","aoe",1,8) then ui.debug("Casting Blade Dance") return true end
    end
    -- Felblade
    -- felblade,if=fury.deficit>=40
    if cast.able.felblade() and furyDeficit >= 40 and not cast.last.vengefulRetreat() and unit.distance(units.dyn15) < 5 then
        if cast.felblade() then ui.debug("Casting Felblade") return true end
    end
    -- Essence Break
    -- essence_break
    if cast.able.essenceBreak() then
        if cast.essenceBreak() then ui.debug("Casting Essence Break") return true end
    end
    -- Annihilation
    -- annihilation,if=(talent.demon_blades.enabled|!variable.waiting_for_momentum|fury.deficit<30|buff.metamorphosis.remains<5)&!variable.pooling_for_blade_dance
    if cast.able.annihilation() and (talent.demonBlades or not var.waitingForMomentum or furyDeficit < 30 or buff.metamorphosis.remain() < 5)
        and not var.poolForBladeDance
    then
        if cast.annihilation() then ui.debug("Casting Annihilation") return true end
    end
    -- Chaos Strike
    -- chaos_strike,if=(talent.demon_blades.enabled|!variable.waiting_for_momentum|fury.deficit<30)&!variable.pooling_for_meta&!variable.pooling_for_blade_dance
    if cast.able.chaosStrike() and (talent.demonBlades or not var.waitingForMomentum or furyDeficit < 30)
        and not var.poolForMeta and not var.poolForBladeDance
    then
        if cast.chaosStrike() then ui.debug("Casting Chaos Strike") return true end
    end
    -- Eye Beam
    -- eye_beam,if=talent.blind_fury.enabled&raid_event.adds.in>cooldown&!variable.waiting_for_agony_gaze
    if ui.mode.eyeBeam == 1 and not unit.isExplosive("target") and cast.able.eyeBeam("player","rect",1,20)
        and #enemies.yards20r > 0 and not unit.moving() and talent.blindFury
        and (not talent.momentum or buff.momentum.exists()) and (eyebeamTTD() or unit.isDummy(units.dyn8))
        and not var.waitingForAgonyGaze
    then
        if cast.eyeBeam("player","rect",1,20) then ui.debug("Casting Eye Beam [Blind Fury]") return true end
    end
    -- Demon's Bite
    -- demons_bite,target_if=min:debuff.burning_wound.remains,if=runeforge.burning_wound.equipped&debuff.burning_wound.remains<4
    if cast.able.demonsBite(var.lowestBurningWound) and runeforge.burningWound.equiped and debuff.burningWound.remain(units.dyn5) < 4 then
        if cast.demonsBite(var.lowestBurningWound) then ui.debug("Casting Demon's Bite [Burning Wound]") return true end
    end
    -- Demon's Bite
    -- demons_bite
    if cast.able.demonsBite(units.dyn5) and not talent.demonBlades and furyDeficit >= 30 then
        if cast.demonsBite(units.dyn5) then ui.debug("Casting Demon's Bite") return true end
    end
    -- Fel Rush
    -- fel_rush,if=!talent.momentum.enabled&raid_event.movement.in>charges*10&talent.demon_blades.enabled
    if cast.able.felRush() and ui.mode.mover ~= 3 and not unit.isExplosive("target") and #enemies.yards23r > 0 and not talent.momentum
        and talent.demonBlades and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush [Demon Blades]")
            return true
        elseif not ui.checked("Fel Rush Only In Melee") and (ui.mode.mover == 2 or (unit.distance("target") >= 8 and ui.mode.mover ~= 3)) then
            if cast.felRush() then ui.debug("Casting Fel Rush [Demon Blades]") return true end
        end
    end
    -- Felblade
    -- felblade,if=movement.distance|buff.out_of_range.up
    if cast.able.felblade("target") and unit.distance("target") > 8 and not cast.last.vengefulRetreat()
        and ui.mode.mover ~= 3 and unit.distance("target") >= 10 and unit.distance("target") < 15
    then
        if cast.felblade("target") then ui.debug("Casting Felblade [Out of Range") return true end
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
end -- End Action List - Normal

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        -- Fel Crystal Fragments -- Only Usable in Madum/Vault of the Wardens
        -- if not buff.felCrystalInfusion.exists() and use.able.felCrystalFragments() and has.felCrystalFragments() then
        --     if use.felCrystalFragments() then ui.debug("Using Fel Crystal Fragments") return true end
        -- end
        -- Flask Module
        -- flask
        module.FlaskUp("Agility")
        -- Battle Scarred Augment Rune
        if ui.checked("Augment Rune") and var.inRaid and not buff.battleScarredAugmentation.exists()
            and use.able.battleScarredAugmentRune() and var.lastRune + gcd < br._G.GetTime()
        then
            if use.battleScarredAugmentRune() then ui.debug("Using Battle Scarred Augment Rune") var.lastRune = br._G.GetTime() return true end
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
            if ui.checked("Metamorphosis M+ Pre-pull") and cast.able.metamorphosis() then
                if cast.metamorphosis("player") then ui.debug("Casting Metamorphosis [Pre-Pull]") return true end
            end
        end -- End M+ Pre-Pull
        if unit.exists("target") and unit.valid("target") and unit.facing("target") and unit.distance("target") < 30 then
            if ui.checked("Auto Engage") and var.solo then
                -- Throw Glaive
                if ui.checked("Throw Glaive") and cast.able.throwGlaive("target","aoe",1,8) and #enemies.yards10tnc == 1 then
                    if cast.throwGlaive("target","aoe",1,8) then ui.debug("Casting Throw Glaive [Pre-Pull]") return true end
                end
                -- Torment
                if not unit.isDummy("target") and cast.able.torment("target") and (cast.timeSinceLast.throwGlaive() > unit.gcd(true) or not ui.checked("Throw Glaive")) then
                    if cast.torment("target") then ui.debug("Casting Torment [Pre-Pull]") return true end
                end
            end
            -- Start Attack
            -- auto_attack
            if unit.distance("target") < 5 then
                br._G.StartAttack()
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

    var.combatTime                                  = br.getCombatTime()
    var.falling                                     = br.getFallTime()
    var.flood                                       = (equiped.soulOfTheSlayer() or talent.firstBlood) and 1 or 0
    var.inInstance                                  = unit.instance=="party"
    var.inMythic                                    = select(3,br._G.IsInInstance)==23
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
    enemies.rect.get(8,20,false)
    enemies.rect.get(3,23,false)

    if cast.active.eyeBeam("player") and buff.metamorphosis.exists() then
        var.metaExtended = true
    elseif not buff.metamorphosis.exists() then
        var.metaExtended = false
    end

    var.ruinedTrail = talent.trailOfRuin and 1 or 0
    var.meta = buff.metamorphosis.exists() and 1 or 0

    -- Blade Dance Variable
    var.bladeDance = false
    -- variable,name=blade_dance,if=!runeforge.chaos_theory&!runeforge.darkglare_medallion,value=talent.first_blood.enabled|spell_targets.blade_dance1>=(3-talent.trail_of_ruin.enabled)
    if not runeforge.chaosTheory.equiped and not runeforge.darkglareMedallion.equiped then
        var.bladeDance = not unit.isExplosive("target") and (talent.firstBlood or #enemies.yards8 >= (3 - var.ruinedTrail))
    end
    -- variable,name=blade_dance,if=runeforge.chaos_theory,value=buff.chaos_theory.down|talent.first_blood.enabled&spell_targets.blade_dance1>=(2-talent.trail_of_ruin.enabled)|!talent.cycle_of_hatred.enabled&spell_targets.blade_dance1>=(4-talent.trail_of_ruin.enabled)
    if runeforge.chaosTheory.equiped then
        var.bladeDance = not unit.isExplosive("target") and (not buff.chaosTheory.exists() or (talent.firstBlood and #enemies.yards8 >= (2 - var.ruinedTrail))
            or (not talent.cycleOfHatred and #enemies.yards8 >= (4 - var.ruinedTrail)))
    end
    -- variable,name=blade_dance,if=runeforge.darkglare_medallion,value=talent.first_blood.enabled|(buff.metamorphosis.up|talent.trail_of_ruin.enabled|debuff.essence_break.up)&spell_targets.blade_dance1>=(3-talent.trail_of_ruin.enabled)|!talent.demonic.enabled&spell_targets.blade_dance1>=4
    if runeforge.darkglareMedallion.equiped then
        var.bladeDance = not unit.isExplosive("target") and (talent.firstBlood or ((buff.metamorphosis.exists() or talent.trailOfRuin or debuff.essenceBreak.exists("target"))
            and #enemies.yards8 >= (3 - var.ruinedTrail)) or (not talent.demonic and #enemies.yards8 >= 4))
    end
    -- variable,name=blade_dance,op=reset,if=talent.essence_break.enabled&cooldown.essence_break.ready
    if talent.essenceBreak and not cd.essenceBreak.exists() then var.bladeDance = false end
    -- variable,name=blade_dance,if=runeforge.agony_gaze&talent.cycle_of_hatred,value=variable.blade_dance&active_dot.sinful_brand<2
    if runeforge.agonyGaze.equiped and talent.cycleOfHatred then
        var.bladeDance = var.bladeDance and debuff.sinfulBrand.count() < 2
    end

    -- Pool for Meta Variable
    -- variable,name=pooling_for_meta,value=!talent.demonic.enabled&cooldown.metamorphosis.remains<6&fury.deficit>30
    var.poolForMeta = ui.alwaysCdAoENever("Metamorphosis",3,8) and ui.useCDs() and not talent.demonic and cd.metamorphosis.remain() < 6 and furyDeficit >= 30

    -- Pool for Blade Dance Variable
    -- variable,name=pooling_for_blade_dance,value=variable.blade_dance&(fury<75-talent.first_blood.enabled*20)
    var.poolForBladeDance = var.bladeDance and fury < 75 - var.flood * 20 and not unit.isExplosive("target")

    -- Pool for Eye Beam
    -- variable,name=pooling_for_eye_beam,value=talent.demonic.enabled&!talent.blind_fury.enabled&cooldown.eye_beam.remains<(gcd.max*2)&fury.deficit>20
    var.poolForEyeBeam = talent.demonic and not talent.blindFury and cd.eyeBeam.remain() < (gcd * 2) and furyDeficit >= 20 and not unit.isExplosive("target")

    -- Wait for Momentum
    -- variable,name=waiting_for_momentum,value=talent.momentum.enabled&!buff.momentum.up
    var.waitingForMomentum = talent.momentum and not buff.momentum.exists()

    -- Wait for Agony Gaze
    -- variable,name=waiting_for_agony_gaze,if=runeforge.agony_gaze,value=!dot.sinful_brand.ticking&cooldown.sinful_brand.remains<gcd.max*4&(!cooldown.metamorphosis.up|active_enemies=1)&spell_targets.eye_beam<=3
    var.waitingForAgonyGaze = runeforge.agonyGaze.equiped and ui.alwaysCdAoENever("Covenant Ability",3,8) and not debuff.sinfulBrand.exists(units.dyn5) and cd.sinfulBrand.remain() < gcd * 4 and (not cd.metamorphosis.exists() or #enemies.yards5 == 1) and #enemies.yards20r <= 3

    -- Trinket Sync
    -- variable,name=trinket_sync_slot,value=1,if=trinket.1.has_stat.any_dps&(!trinket.2.has_stat.any_dps|trinket.1.cooldown.duration>=trinket.2.cooldown.duration)
    -- variable,name=trinket_sync_slot,value=2,if=trinket.2.has_stat.any_dps&(!trinket.1.has_stat.any_dps|trinket.2.cooldown.duration>trinket.1.cooldown.duration)

    -- Use Eye Beam
    -- variable,name=use_eye_beam_fury_condition,value=talent.blind_fury.enabled&(runeforge.darkglare_medallion|talent.demon_blades.enabled&!runeforge.agony_gaze)
    var.useEyeBeamFuryCondition = talent.blindFury and (runeforge.darkglareMedallion.equiped or talent.demonBlades and not runeforge.agonyGaze.equiped)

    -- if ui.mode.mover == 1 and cast.last.vengefulRetreat() then StopFalling(); end
    -- if IsHackEnabled("NoKnockback") then
    --     SetHackEnabled("NoKnockback", false)
    -- end
    -- Fel Rush Special
    if unit.inCombat() and ui.mode.mover ~= 3 and ui.checked("Auto Fel Rush After Retreat") and cast.able.felRush()
        and (buff.prepared.exists() or cast.timeSinceLast.vengefulRetreat() < unit.gcd(true) * 2) and not buff.momentum.exists() and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
    then
        --[[if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush [Special]")
        else]]if not ui.checked("Fel Rush Only In Melee") and (ui.mode.mover == 2 or (unit.distance("target") >= 8 and ui.mode.mover ~= 3)) then
            if cast.felRush() then ui.debug("Casting Fel Rush [Special]") return true end
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.mounted() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or (unit.mounted() or unit.flying()) or ui.pause() or ui.mode.rotation==4 or cast.active.eyeBeam() then
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
        if unit.inCombat() and not unit.mounted() and not var.profileStop and unit.valid("target") then
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
                    br._G.StartAttack()
                end
                -- Cooldowns
                -- call_action_list,name=cooldown,if=gcd.remains=0
                if cd.global.remain() == 0 then
                    if actionList.Cooldowns() then return true end
                end
                -- Pickup Fragments
                -- pick_up_fragment,if=demon_soul_fragments>0
                -- pick_up_fragment,mode=nearest,if=(talent.demonic_appetite.enabled&fury.deficit>=35|runeforge.blind_faith&buff.blind_faith.up)&(!cooldown.eye_beam.ready|fury<30)
                -- if furyDeficit >= 35 then
                --     ui.chatOverlay("Low Fury - Pickup Fragments!")
                -- end
                -- Throw Glaive
                -- throw_glaive,if=buff.fel_bombardment.stack=5&(buff.immolation_aura.up|!buff.metamorphosis.up)
                if ui.checked("Throw Glaive") and cast.able.throwGlaive() and buff.felBombardment.stack() == 5 and (buff.immolationAura.exists() or not buff.metamorphosis.exists()) then
                    if cast.throwGlaive() then ui.debug("Casting Throw Glaive [Fel Bombardment]") return true end
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
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

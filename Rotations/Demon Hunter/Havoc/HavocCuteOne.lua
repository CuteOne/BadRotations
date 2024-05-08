------------------------------------------------------
-- Author = CuteOne
-- Patch = 10.2
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 100%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Full
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Untested
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
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spells.bladeDance},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spells.bladeDance},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spells.chaosStrike},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.spectralSight}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.metamorphosis},
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spells.metamorphosis},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.metamorphosis}
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.darkness},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.darkness}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spells.consumeMagic},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.consumeMagic}
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
    -- Mover
    local MoverModes = {
        [1] = { mode = "AC", value = 1 , overlay = "Movement Animation Cancel Enabled", tip = "Will Cancel Movement Animation.", highlight = 1, icon = br.player.spells.felRush},
        [2] = { mode = "On", value = 2 , overlay = "Auto Movement Enabled", tip = "Will Cast Movement Abilities.", highlight = 0, icon = br.player.spells.felRush},
        [3] = { mode = "Off", value = 3 , overlay = "Auto Movement Disabled", tip = "Will NOT Cast Movement Abilities", highlight = 0, icon = br.player.spells.felRush}
    };
    br.ui:createToggle(MoverModes,"Mover",5,0)
    -- Hold Eye Beam
    local EyeBeamModes = {
        [1] = { mode = "On", value = 1 , overlay = "Use Eye beam", tip = "Use Eye beam", highlight = 1, icon = br.player.spells.eyeBeam},
        [2] = { mode = "Off", value = 2 , overlay = "Don't use Eye beam", tip = "Don't use Eye beam", highlight = 0, icon = br.player.spells.eyeBeam}
    };
    br.ui:createToggle(EyeBeamModes,"EyeBeam",6,0)
    -- Hold Fel Barrage
    local FelBarrageModes = {
        [1] = { mode = "On", value = 1 , overlay = "Use Fel Barrage", tip = "Use Fel Barrage", highlight = 1, icon = br.player.spells.felBarrage},
        [2] = { mode = "Off", value = 2 , overlay = "Don't use Fel Barrage", tip = "Don't use Fel Barrage", highlight = 0, icon = br.player.spells.felBarrage}
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
            -- br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- M+ Meta Pre-Pull Timer
            -- br.ui:createSpinner(section, "M+ Pre-Pull",  3,  1,  10,  1,  "|cffFFFFFFSet to desired time to Meta Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Auto Engage
            br.ui:createCheckbox(section, "Auto Engage")
            -- Eye Beam Targets
            -- br.ui:createDropdownWithout(section,"Eye Beam Usage",{"|cff00FF00Per APL","|cffFFFFFFAoE Only","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Eye Beam.")
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
            -- Metamorphosis
            br.ui:createDropdownWithout(section,"Metamorphosis",alwaysCdAoENever,1,"|cffFFBB00When to use Metamorphosis.")
            -- br.ui:createCheckbox(section,"Metamorphosis M+ Pre-pull","Uses Meta during M+ pre-pull, regardless of CD setting.")
            -- The Hunt
            br.ui:createDropdownWithout(section,"The Hunt",alwaysCdAoENever,1,"|cffFFBB00When to use The Hunt.")
            -- Elysian Decree
            br.ui:createDropdownWithout(section,"Elysian Decree",alwaysCdAoENever,1,"|cffFFBB00When to use Elysian Decree.")
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
            -- Sigil of Misery
            br.ui:createSpinner(section, "Sigil of Misery - HP",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            br.ui:createSpinner(section, "Sigil of Misery - AoE", 3, 0, 10, 1, "|cffFFFFFFNumber of Units in 8 Yards to Cast At")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Chaos Nova
            br.ui:createCheckbox(section, "Chaos Nova")
            -- Disrupt
            br.ui:createCheckbox(section, "Disrupt")
            -- Fel Eruption
            br.ui:createCheckbox(section, "Fel Eruption")
            -- Sigil of Misery
            br.ui:createCheckbox(section, "Sigil of Misery")
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
local actionList = {}
local buff
local cast
local cd
local charges
local debuff
local enemies
local equiped
local fury
local has
local module
local talent
local ui
local unit
local units
local use
local var

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
        -- Consume Magic
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
        -- Sigil of Misery
        if ui.checked("Sigil of Misery - HP") and cast.able.sigilOfMisery()
            and unit.hp() <= ui.value("Sigil of Misery - HP") and unit.inCombat() and #enemies.yards8 > 0
        then
            if cast.sigilOfMisery("player","ground") then ui.debug("Casting Sigil of Misery [HP]") return true end
        end
        if ui.checked("Sigil of Misery - AoE") and cast.able.sigilOfMisery()
            and #enemies.yards8 >= ui.value("Sigil of Misery - AoE") and unit.inCombat()
        then
            if cast.sigilOfMisery("best",false,ui.value("Sigil of Misery - AoE"),8) then ui.debug("Casting Sigil of Misery [AOE]") return true end
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
        -- Sigil of Misery
        for i=1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if ui.checked("Sigil of Misery") and cast.able.sigilOfMisery(thisUnit) and cd.disrupt.remain() > 0 then
                if cast.sigilOfMisery(thisUnit,"ground",1,8) then ui.debug("Casting Sigil of Misery [Interrupt]") return true end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldown
actionList.Cooldown = function()
    if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
        -- Metamorphosis
        if ui.alwaysCdAoENever("Metamorphosis",3,#enemies.yards8) and cast.able.metamorphosis("player") and #enemies.yards8 > 0 then
            -- metamorphosis,if=!talent.demonic&((!talent.chaotic_transformation|cooldown.eye_beam.remains>20)&active_enemies>desired_targets|raid_event.adds.in>60|fight_remains<25)
            if ((not talent.demonic and ((not talent.chaoticTransformation or cd.eyeBeam.remains()>20) and #enemies.yards0>ui.value("Units to AoE") or unit.ttdGroup(40)<25))) then
                if cast.metamorphosis("player") then ui.debug("Casting Metamorphosis [Cooldown]") return true end
            end

            -- metamorphosis,if=talent.demonic&(!talent.chaotic_transformation&cooldown.eye_beam.remains|cooldown.eye_beam.remains>20&(!variable.blade_dance|prev_gcd.1.death_sweep|prev_gcd.2.death_sweep)|fight_remains<25+talent.shattered_destiny*70&cooldown.eye_beam.remains&cooldown.blade_dance.remains)&buff.inner_demon.down
            if ((talent.demonic and (not talent.chaoticTransformation and cd.eyeBeam.remains() or cd.eyeBeam.remains()>20
                and (not var.bladeDance or cast.last.deathSweep(1) or cast.last.deathSweep(2)) or unit.ttdGroup(40)<25+var.shatteredDestiny*70
                and cd.eyeBeam.remains() and cd.bladeDance.remains()) and not buff.innerDemon.exists()))
            then
                if cast.metamorphosis("player") then ui.debug("Casting Metamorphosis - Not Demonic [Cooldown]") return true end
            end
        end

        -- Use Item - Potion
        -- potion,if=buff.metamorphosis.remains>25|buff.metamorphosis.up&cooldown.metamorphosis.ready|fight_remains<60|time>0.1&time<10
        if ui.checked("Potion") and ui.useCDs() and var.inRaid and use.able.potion()
            and ((buff.metamorphosis.remains()>25 or buff.metamorphosis.exists()
            and not cd.metamorphosis.exists() or unit.ttdGroup(40)<60 or unit.combatTime()>0.1 and unit.combatTime()<10))
        then
            if use.potion() then ui.debug("Using Potion [Cooldown]") return true end
        end

        -- Elysian Decree
        -- elysian_decree,if=(active_enemies>desired_targets|raid_event.adds.in>30)&debuff.essence_break.down
        if ui.alwaysCdAoENever("Elysian Decree",ui.value("Units to AoE"),#enemies.yards30) and cast.able.elysianDecree("best",nil,1,8) and unit.standingTime() > 2
            and ((ui.mode.rotation == 1 and #enemies.yards8 >= ui.value("Units To AoE")) or ui.mode.rotation == 2 or ui.useCDs())
            and not debuff.essenceBreak.exists(units.dyn5)
        then
            if cast.elysianDecree("best",nil,1,8) then ui.debug("Casting Elysian Decree [Cooldown]") return true end
        end

        -- Use Item - Manic Grieftorch,Use Off Gcd=1
        -- use_item,name=manic_grieftorch,use_off_gcd=1,if=buff.vengeful_retreat_movement.down&((buff.initiative.remains>2&debuff.essence_break.down&cooldown.essence_break.remains>gcd.max&time>14|time_to_die<10|time<1&!equipped.algethar_puzzle_box|fight_remains%%120<5)&!prev_gcd.1.essence_break)
        if use.able.manicGrieftorch() and ((not cast.last.vengefulRetreat() and ((buff.initiative.remains()>2 and not debuff.essenceBreak.exists(units.dyn5)
            and cd.essenceBreak.remains()>unit.gcd(true) and unit.combatTime()>14 or unit.ttd(units.dyn5)<10 or unit.combatTime()<1
            and not equiped.algetharPuzzleBox() or unit.ttdGroup(40)%120<5) and not cast.last.essenceBreak(1))))
        then
            if use.manicGrieftorch() then ui.debug("Using Manic Grieftorch [Cooldown]") return true end
        end

        -- Use Item - Algethar Puzzle Box,Use Off Gcd=1
        -- use_item,name=algethar_puzzle_box,use_off_gcd=1,if=cooldown.metamorphosis.remains<=gcd.max*5|fight_remains%%180>10&fight_remains%%180<22|fight_remains<25
        if use.able.algetharPuzzleBox() and ((cd.metamorphosis.remains()<=unit.gcd(true)*5 or unit.ttdGroup(40)%180>10
            and unit.ttdGroup(40)%180<22 or unit.ttdGroup(40)<25))
        then
            if use.algetharPuzzleBox() then ui.debug("Using Algethar Puzzle Box [Cooldown]") return true end
        end

        -- Use Item - Irideus Fragment,Use Off Gcd=1
        -- use_item,name=irideus_fragment,use_off_gcd=1,if=cooldown.metamorphosis.remains<=gcd.max&time>2|fight_remains%%180>10&fight_remains%%180<22|fight_remains<22
        if use.able.irideusFragment() and ((cd.metamorphosis.remains()<=unit.gcd(true) and unit.combatTime()>2 or unit.ttdGroup(40)%180>10
            and unit.ttdGroup(40)%180<22 or unit.ttdGroup(40)<22))
        then
            if use.irideusFragment() then ui.debug("Using Irideus Fragment [Cooldown]") return true end
        end

        -- Use Item - Stormeaters Boon,Use Off Gcd=1
        -- use_item,name=stormeaters_boon,use_off_gcd=1,if=cooldown.metamorphosis.remains&(!talent.momentum|buff.momentum.remains>5)&(active_enemies>1|raid_event.adds.in>140)
        if use.able.stormeatersBoon() and ((cd.metamorphosis.remains() and (not talent.momentum or buff.momentum.remains()>5) and #enemies.yards0>1)) then
            if use.stormeatersBoon() then ui.debug("Using Stormeaters Boon [Cooldown]") return true end
        end

        -- Use Item - Beacon To The Beyond,Use Off Gcd=1
        -- use_item,name=beacon_to_the_beyond,use_off_gcd=1,if=buff.vengeful_retreat_movement.down&debuff.essence_break.down&!prev_gcd.1.essence_break&(!equipped.irideus_fragment|trinket.1.cooldown.remains>20|trinket.2.cooldown.remains>20)
        if use.able.beaconToTheBeyond() and ((not cast.last.vengefulRetreat() and not debuff.essenceBreak.exists(units.dyn5)
            and not cast.last.essenceBreak(1) and (not equiped.irideusFragment() or cd.slot.remains(13)>20 or cd.slot.remains(14)>20)))
        then
            if use.beaconToTheBeyond() then ui.debug("Using Beacon To The Beyond [Cooldown]") return true end
        end

        -- Use Item - Dragonfire Bomb Dispenser,Use Off Gcd=1
        -- use_item,name=dragonfire_bomb_dispenser,use_off_gcd=1,if=(time_to_die<30|cooldown.vengeful_retreat.remains<5|equipped.beacon_to_the_beyond|equipped.irideus_fragment)&(trinket.1.cooldown.remains>10|trinket.2.cooldown.remains>10|trinket.1.cooldown.duration=0|trinket.2.cooldown.duration=0|equipped.elementium_pocket_anvil|equipped.screaming_black_dragonscale|equipped.mark_of_dargrul)|(trinket.1.cooldown.duration>0|trinket.2.cooldown.duration>0)&(trinket.1.cooldown.remains|trinket.2.cooldown.remains)&!equipped.elementium_pocket_anvil&time<25
        if use.able.dragonfireBombDispenser() and (((unit.ttd(units.dyn5)<30 or cd.vengefulRetreat.remains()<5 or equiped.beaconToTheBeyond() or equiped.irideusFragment())
            and (cd.slot.remains(13)>10 or cd.slot.remains(14)>10 or cd.slot.duration()==0 or cd.slot.duration()==0 or equiped.elementiumPocketAnvil()
                or equiped.screamingBlackDragonscale() or equiped.markOfDargrul()) or (cd.slot.duration()>0 or cd.slot.duration()>0)
            and (cd.slot.remains(13) or cd.slot.remains(14)) and not equiped.elementiumPocketAnvil() and unit.combatTime()<25))
        then
            if use.dragonfireBombDispenser() then ui.debug("Using Dragonfire Bomb Dispenser [Cooldown]") return true end
        end

        -- Use Item - Elementium Pocket Anvil,Use Off Gcd=1
        -- use_item,name=elementium_pocket_anvil,use_off_gcd=1,if=!prev_gcd.1.fel_rush&gcd.remains
        if use.able.elementiumPocketAnvil() and not cast.last.felRush(1) and cd.elementiumPocketAnvil.remains() then
            if use.elementiumPocketAnvil() then ui.debug("Using Elementium Pocket Anvil [Cooldown]") return true end
        end

        -- Use Item - Slots
        -- use_items,slots=trinket1,if=(variable.trinket_sync_slot=1&(buff.metamorphosis.up|(!talent.demonic.enabled&cooldown.metamorphosis.remains>(fight_remains>?trinket.1.cooldown.duration%2))|fight_remains<=20)|(variable.trinket_sync_slot=2&!trinket.2.cooldown.ready)|!variable.trinket_sync_slot)&(!talent.initiative|buff.initiative.up)
        if use.able.slot(1) and (((var.trinketSyncSlot==1 and (buff.metamorphosis.exists() or (not talent.demonic
            and cd.metamorphosis.remains()>(math.max(unit.ttdGroup(40),cd.slot.duration()/2))) or unit.ttdGroup(40)<=20)
                or (var.trinketSyncSlot==2 and not not cd.slot.exists()) or not var.trinketSyncSlot)
            and (not talent.initiative or buff.initiative.exists())))
        then
            if use.slot(1) then ui.debug("Using Slots 1 [Cooldown]") return true end
        end

        -- Use Item - Slots
        -- use_items,slots=trinket2,if=(variable.trinket_sync_slot=2&(buff.metamorphosis.up|(!talent.demonic.enabled&cooldown.metamorphosis.remains>(fight_remains>?trinket.2.cooldown.duration%2))|fight_remains<=20)|(variable.trinket_sync_slot=1&!trinket.1.cooldown.ready)|!variable.trinket_sync_slot)&(!talent.initiative|buff.initiative.up)
        if use.able.slot(2) and (((var.trinketSyncSlot==2 and (buff.metamorphosis.exists() or (not talent.demonic
            and cd.metamorphosis.remains()>(math.max(unit.ttdGroup(40),cd.slot.duration()/2))) or unit.ttdGroup(40)<=20)
                or (var.trinketSyncSlot==1 and not not cd.slot.exists()) or not var.trinketSyncSlot)
            and (not talent.initiative or buff.initiative.exists())))
        then
            if use.slot(2) then ui.debug("Using Slots 2 [Cooldown]") return true end
        end
    end
end -- End Action List - Cooldown

-- Action List - Precombat
actionList.Precombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        -- Fel Crystal Fragments -- Only Usable in Madum/Vault of the Wardens
        -- if not buff.felCrystalInfusion.exists() and use.able.felCrystalFragments() and has.felCrystalFragments() then
        --     if use.felCrystalFragments() then ui.debug("Using Fel Crystal Fragments") return true end
        -- end
        -- Flask Module
        -- flask
        module.FlaskUp("Agility")

        -- Use Item - Augmentation
        -- augmentation
        if ui.checked("Augment Rune") and var.inRaid and not buff.augmentation.exists()
            and use.able.augmentation() and var.lastRune + unit.gcd() < ui.time()
        then
            if use.augmentation() then ui.debug("Using Augmentation [Precombat]") return true end
        end

        -- Variable - 3Min Trinket
        -- variable,name=3min_trinket,value=trinket.1.cooldown.duration=180|trinket.2.cooldown.duration=180
        var.value3minTrinket = (cd.slot.duration(13)==180 or cd.slot.duration(14)==180)

        -- Variable - Trinket Sync Slot
        -- variable,name=trinket_sync_slot,value=1,if=trinket.1.has_stat.any_dps&(!trinket.2.has_stat.any_dps|trinket.1.cooldown.duration>=trinket.2.cooldown.duration)
        if ((has.stats.dps(13) and (not has.stats.dps(14) or cd.slot.duration(13)>=cd.slot.duration(14)))) then
            var.trinketSyncSlot = 1
        end

        -- Variable - Trinket Sync Slot
        -- variable,name=trinket_sync_slot,value=2,if=trinket.2.has_stat.any_dps&(!trinket.1.has_stat.any_dps|trinket.2.cooldown.duration>trinket.1.cooldown.duration)
        if ((has.stats.dps(14) and (not has.stats.dps(13) or cd.slot.duration(14)>cd.slot.duration(13)))) then
            var.trinketSyncSlot = 2
        end

        if unit.exists("target") and unit.valid("target") and unit.facing("target") and unit.distance("target") < 30 then
            -- Arcane Torrent
            -- arcane_torrent
            if ui.alwaysCdNever("Racial") and cast.able.racial() and unit.race() == "BloodElf" then
                if cast.racial() then ui.debug("Casting Arcane Torrent [Precombat]") return true end
            end

            -- Use Item - Algethar Puzzle Box
            -- use_item,name=algethar_puzzle_box
            if use.able.algetharPuzzleBox() then
                if use.algetharPuzzleBox() then ui.debug("Using Algethar Puzzle Box [Precombat]") return true end
            end

            -- Immolation Aura
            -- immolation_aura
            if cast.able.immolationAura("player","aoe",1,8) then
                if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura [Precombat]") return true end
            end

            -- Sigil Of Flame
            -- sigil_of_flame,if=!equipped.algethar_puzzle_box
            if equiped.algetharPuzzleBox() then
                if talent.preciseSigils and cast.able.sigilOfFlame("target","aoe",1,8) then
                    if cast.sigilOfFlame("target","aoe",1,8) then ui.debug("Casting Sigil of Flame [Precombat]") return true end
                end
                if cast.able.sigilOfFlame("best",false,1,8) and not talent.preciseSigils then
                    if cast.sigilOfFlame("best",false,1,8) then ui.debug("Casting Sigil of Flame [Precombat]") return true end
                end
            end

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
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Pull]") return true end
                end
            end
        end
    end -- End No Combat
end -- End Action List - Precombat

-- Action List - Combat
actionList.Combat = function()
    -- Auto Attack
    -- auto_attack,if=!buff.out_of_range.up
    if cast.able.autoAttack() and unit.distance(units.dyn5)<5 then
        if cast.autoAttack() then ui.debug("Casting Auto Attack [Combat]") return true end
    end

    -- Auto Attack
    -- retarget_auto_attack,line_cd=1,target_if=min:debuff.burning_wound.remains,if=talent.burning_wound&talent.demon_blades&active_dot.burning_wound<(spell_targets>?3)
    if cast.able.autoAttack(var.lowestBurningWound) and ui.delay("AutoAttack0",1) and talent.burningWound and talent.demonBlades
        and debuff.burningWound.count(var.lowestBurningWound)<(math.max(#enemies.yards5,3))
    then
        -- unit.target(var.lowestBurningWound)
        if cast.autoAttack(var.lowestBurningWound) then ui.debug("Casting Auto Attack with retarget - Burning Wound [Combat]") return true end
    end

    -- Auto Attack
    -- retarget_auto_attack,line_cd=1,target_if=min:!target.is_boss,if=talent.burning_wound&talent.demon_blades&active_dot.burning_wound=(spell_targets>?3)
    if cast.able.autoAttack(var.minTTDUnit) and ui.delay("AutoAttack1",1) and talent.burningWound and talent.demonBlades
        and debuff.burningWound.count(var.minTTDUnit)==(math.max(#enemies.yards5,3))
    then
        -- unit.target(var.minTTDUnit)
        if cast.autoAttack(var.minTTDUnit) then ui.debug("Casting Auto Attack with retarget - Lowest TTD Non-Boss [Combat]") return true end
    end

    -- Variable - Blade Dance
    -- variable,name=blade_dance,value=talent.first_blood|talent.trail_of_ruin|talent.chaos_theory&buff.chaos_theory.down|spell_targets.blade_dance1>1
    var.bladeDance = (talent.firstBlood or talent.trailOfRuin or talent.chaosTheory and not buff.chaosTheory.exists() or #enemies.yards8>1)

    -- Variable - Pooling For Blade Dance
    -- variable,name=pooling_for_blade_dance,value=variable.blade_dance&fury<(75-talent.demon_blades*20)&cooldown.blade_dance.remains<gcd.max
    var.poolingForBladeDance = var.bladeDance and fury()<(75-var.demonBlades*20) and cd.bladeDance.remains()<unit.gcd(true)

    -- Variable - Pooling For Eye Beam
    -- variable,name=pooling_for_eye_beam,value=talent.demonic&!talent.blind_fury&cooldown.eye_beam.remains<(gcd.max*3)&fury.deficit>30
    var.poolingForEyeBeam = talent.demonic and not talent.blindFury and cd.eyeBeam.remains()<(unit.gcd(true)*3) and fury.deficit()>30

    -- Variable - Waiting For Momentum
    -- variable,name=waiting_for_momentum,value=talent.momentum&!buff.momentum.up|talent.inertia&!buff.inertia.up
    var.waitingForMomentum = (talent.momentum and not buff.momentum.exists() or talent.inertia and not buff.inertia.exists())

    -- Variable - Holding Meta
    -- variable,name=holding_meta,value=(talent.demonic&talent.essence_break)&variable.3min_trinket&fight_remains>cooldown.metamorphosis.remains+30+talent.shattered_destiny*60&cooldown.metamorphosis.remains<20&cooldown.metamorphosis.remains>action.eye_beam.execute_time+gcd.max*(talent.inner_demon+2)
    var.holdingMeta = (talent.demonic and talent.essenceBreak) and var.value3minTrinket
        and unit.ttdGroup(40)>cd.metamorphosis.remains()+30+var.shatteredDestiny*60 and cd.metamorphosis.remains()<20
        and cd.metamorphosis.remains()>cast.time.eyeBeam()+unit.gcd(true)*(var.innerDemon+2)

    -- Immolation Aura
    -- immolation_aura,if=talent.ragefire&active_enemies>=3&(cooldown.blade_dance.remains|debuff.essence_break.down)
    if cast.able.immolationAura("player","aoe",1,8) and ((talent.ragefire and #enemies.yards8>=3
        and (cd.bladeDance.remains() or not debuff.essenceBreak.exists(units.dyn8AoE))))
    then
        if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura - Ragefire +3 | No Essence Break [Combat]") return true end
    end

    -- Disrupt
    -- disrupt
    if actionList.Interrupts() then return true end

    -- Immolation Aura
    -- immolation_aura,if=talent.a_fire_inside&talent.inertia&buff.unbound_chaos.down&full_recharge_time<gcd.max*2&debuff.essence_break.down
    if cast.able.immolationAura("player","aoe",1,8) and talent.aFireInside and talent.inertia and not buff.unboundChaos.exists()
        and charges.immolationAura.timeTillFull()<unit.gcd(true)*2 and not debuff.essenceBreak.exists(units.dyn8AoE)
    then
        if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura - A Fire Inside Inertia [Combat]") return true end
    end

    -- Fel Rush
    -- fel_rush,if=buff.unbound_chaos.up&(action.immolation_aura.charges=2&debuff.essence_break.down|prev_gcd.1.eye_beam&buff.inertia.up&buff.inertia.remains<3)
    if cast.able.felRush() and not unit.isExplosive("target") and #enemies.yards23r > 1 and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
        and ((buff.unboundChaos.exists() and (charges.immolationAura.count()==2
        and not debuff.essenceBreak.exists(units.dyn5) or cast.last.eyeBeam(1) and buff.inertia.exists() and buff.inertia.remains()<3)))
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush - Unbound Chaos [Combat]")
            return true
        end
        if ui.mode.mover ~= 3 and (unit.distance("target") < 8 or (not ui.checked("Fel Rush Only In Melee") and unit.distance("target") >= 8)) then
            if cast.felRush() then ui.debug("Casting Fel Rush - Unbound Chaos [Combat]") return true end
        end
    end

    -- The Hunt
    -- the_hunt,if=time<10&buff.potion.up&(!talent.inertia|buff.metamorphosis.up&debuff.essence_break.down)
    if ui.alwaysCdAoENever("The Hunt",ui.value("Units to AoE"),#enemies.yards50r) and cast.able.theHunt()
        and ((unit.combatTime()<10 and buff.potion.exists() and (not talent.inertia or buff.metamorphosis.exists() and not debuff.essenceBreak.exists(units.dyn5))))
    then
        if cast.theHunt() then ui.debug("Casting The Hunt [Combat]") return true end
    end

    -- Immolation Aura
    -- immolation_aura,if=talent.inertia&(cooldown.eye_beam.remains<gcd.max*2|buff.metamorphosis.up)&cooldown.essence_break.remains<gcd.max*3&buff.unbound_chaos.down&buff.inertia.down&debuff.essence_break.down
    if cast.able.immolationAura("player","aoe",1,8) and ((talent.inertia and (cd.eyeBeam.remains()<unit.gcd(true)*2 or buff.metamorphosis.exists())
        and cd.essenceBreak.remains()<unit.gcd(true)*3 and not buff.unboundChaos.exists() and not buff.inertia.exists() and not debuff.essenceBreak.exists(units.dyn8AoE)))
    then
        if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura - Inertia [Combat]") return true end
    end

    -- Immolation Aura
    -- immolation_aura,if=talent.inertia&buff.unbound_chaos.down&(full_recharge_time<cooldown.essence_break.remains|!talent.essence_break)&debuff.essence_break.down&(buff.metamorphosis.down|buff.metamorphosis.remains>6)&cooldown.blade_dance.remains&(fury<75|cooldown.blade_dance.remains<gcd.max*2)
    if cast.able.immolationAura("player","aoe",1,8) and ((talent.inertia and not buff.unboundChaos.exists()
        and (charges.immolationAura.timeTillFull()<cd.essenceBreak.remains() or not talent.essenceBreak)
        and not debuff.essenceBreak.exists(units.dyn8AoE) and (not buff.metamorphosis.exists() or buff.metamorphosis.remains()>6)
        and cd.bladeDance.remains() and (fury()<75 or cd.bladeDance.remains()<unit.gcd(true)*2)))
    then
        if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura - Inertia No Unbound Chaos [Combat]") return true end
    end

    -- Fel Rush
    -- fel_rush,if=buff.unbound_chaos.up&(buff.unbound_chaos.remains<gcd.max*2|target.time_to_die<gcd.max*2)
    if cast.able.felRush() and not unit.isExplosive("target") and #enemies.yards23r > 1 and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
        and ((buff.unboundChaos.exists() and (buff.unboundChaos.remains()<unit.gcd(true)*2 or unit.ttd(units.dyn5)<unit.gcd(true)*2)))
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush - Unbound Chaos Low Buff|TTD [Combat]")
            return true
        end
        if ui.mode.mover ~= 3 and (unit.distance("target") < 8 or (not ui.checked("Fel Rush Only In Melee") and unit.distance("target") >= 8)) then
            if cast.felRush() then ui.debug("Casting Fel Rush - Unbound Chaos Low Buff|TTD [Combat]") return true end
        end
    end

    -- Fel Rush
    -- fel_rush,if=talent.inertia&buff.inertia.down&buff.unbound_chaos.up&cooldown.eye_beam.remains+3>buff.unbound_chaos.remains&(cooldown.blade_dance.remains|cooldown.essence_break.up)
    if cast.able.felRush() and not unit.isExplosive("target") and #enemies.yards23r > 1 and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
        and ((talent.inertia and not buff.inertia.exists() and buff.unboundChaos.exists() and cd.eyeBeam.remains()+3>buff.unboundChaos.remains()
        and (cd.bladeDance.remains() or not cd.essenceBreak.exists())))
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush - Inertia No Buff [Combat]")
            return true
        end
        if ui.mode.mover ~= 3 and (unit.distance("target") < 8 or (not ui.checked("Fel Rush Only In Melee") and unit.distance("target") >= 8)) then
            if cast.felRush() then ui.debug("Casting Fel Rush - Intertia No Buff [Combat]") return true end
        end
    end

    -- Fel Rush
    -- fel_rush,if=buff.unbound_chaos.up&talent.inertia&buff.inertia.down&(buff.metamorphosis.up|cooldown.essence_break.remains>10)
    if cast.able.felRush() and not unit.isExplosive("target") and #enemies.yards23r > 1 and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
        and ((buff.unboundChaos.exists() and talent.inertia and not buff.inertia.exists() and (buff.metamorphosis.exists() or cd.essenceBreak.remains()>10)))
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush - Intertia Meta|Recent Essence Break [Combat]")
            return true
        end
        if ui.mode.mover ~= 3 and (unit.distance("target") < 8 or (not ui.checked("Fel Rush Only In Melee") and unit.distance("target") >= 8)) then
            if cast.felRush() then ui.debug("Casting Fel Rush - Intertia Meta|Recent Essence Break [Combat]") return true end
        end
    end

    -- Call Action List - Cooldown
    -- call_action_list,name=cooldown
    if actionList.Cooldown() then return true end

    -- Call Action List - Meta End
    -- call_action_list,name=meta_end,if=buff.metamorphosis.up&buff.metamorphosis.remains<gcd.max&active_enemies<3
    if buff.metamorphosis.exists() and buff.metamorphosis.remains()<unit.gcd(true) and #enemies.yards5<3 then
        if actionList.MetaEnd() then return true end
    end

    -- Annihilation
    -- annihilation,if=buff.inner_demon.up&cooldown.metamorphosis.remains<=gcd*3
    if cast.able.annihilation() and buff.innerDemon.exists() and cd.metamorphosis.remains()<=unit.gcd()*3 then
        if cast.annihilation() then ui.debug("Casting Annihilation [Combat]") return true end
    end

    -- Vengeful Retreat
    -- vengeful_retreat,use_off_gcd=1,if=cooldown.eye_beam.remains<0.3&cooldown.essence_break.remains<gcd.max*2&time>5&fury>=30&gcd.remains<0.1&talent.inertia
    if ui.checked("Vengeful Retreat") and cast.able.vengefulRetreat() and ui.mode.mover ~= 3
        and cd.eyeBeam.remains()<0.3 and cd.essenceBreak.remains()<unit.gcd(true)*2 and unit.combatTime()>5
        and fury()>=30 and cd.vengefulRetreat.remains()<0.1 and talent.inertia
    then
        -- if ui.mode.mover == 1 then
            -- cancelRetreatAnimation()
        -- elseif ui.mode.mover == 2 then
            if cast.vengefulRetreat() then ui.debug("Casting Vengeful Retreat - Eye Beam Soon [Combat]") return true end
        -- end
    end

    -- Vengeful Retreat
    -- vengeful_retreat,use_off_gcd=1,if=talent.initiative&talent.essence_break&time>1&(cooldown.essence_break.remains>15|cooldown.essence_break.remains<gcd.max&(!talent.demonic|buff.metamorphosis.up|cooldown.eye_beam.remains>15+(10*talent.cycle_of_hatred)))&(time<30|gcd.remains-1<0)&(!talent.initiative|buff.initiative.remains<gcd.max|time>4)
    if ui.checked("Vengeful Retreat") and cast.able.vengefulRetreat() and ui.mode.mover ~= 3
        and ((talent.initiative and talent.essenceBreak and unit.combatTime()>1 and (cd.essenceBreak.remains()>15 or cd.essenceBreak.remains()<unit.gcd(true)
        and (not talent.demonic or buff.metamorphosis.exists() or cd.eyeBeam.remains()>15+(10*var.cycleOfHatred)))
        and (unit.combatTime()<30 or cd.vengefulRetreat.remains()-1<0) and (not talent.initiative or buff.initiative.remains()<unit.gcd(true) or unit.combatTime()>4)))
    then
        -- if ui.mode.mover == 1 then
            -- cancelRetreatAnimation()
        -- elseif ui.mode.mover == 2 then
            if cast.vengefulRetreat() then ui.debug("Casting Vengeful Retreat - No Initiative Essence Break [Combat]") return true end
        -- end
    end

    -- Vengeful Retreat
    -- vengeful_retreat,use_off_gcd=1,if=talent.initiative&talent.essence_break&time>1&(cooldown.essence_break.remains>15|cooldown.essence_break.remains<gcd.max*2&(buff.initiative.remains<gcd.max&!variable.holding_meta&cooldown.eye_beam.remains<=gcd.remains&(raid_event.adds.in>(40-talent.cycle_of_hatred*15))&fury>30|!talent.demonic|buff.metamorphosis.up|cooldown.eye_beam.remains>15+(10*talent.cycle_of_hatred)))&(buff.unbound_chaos.down|buff.inertia.up)
    if ui.checked("Vengeful Retreat") and cast.able.vengefulRetreat() and ui.mode.mover ~= 3
        and ((talent.initiative and talent.essenceBreak and unit.combatTime()>1 and (cd.essenceBreak.remains()>15 or cd.essenceBreak.remains()<unit.gcd(true)*2
        and (buff.initiative.remains()<unit.gcd(true) and not var.holdingMeta and cd.eyeBeam.remains()<=cd.vengefulRetreat.remains()
        and fury()>30 or not talent.demonic or buff.metamorphosis.exists() or cd.eyeBeam.remains()>15+(10*var.cycleOfHatred)))
        and (not buff.unboundChaos.exists() or buff.inertia.exists())))
    then
        -- if ui.mode.mover == 1 then
            -- cancelRetreatAnimation()
        -- elseif ui.mode.mover == 2 then
            if cast.vengefulRetreat() then ui.debug("Casting Vengeful Retreat - Initiative Essence Break [Combat]") return true end
        -- end
    end

    -- Vengeful Retreat
    -- vengeful_retreat,use_off_gcd=1,if=talent.initiative&!talent.essence_break&time>1&((!buff.initiative.up|prev_gcd.1.death_sweep&cooldown.metamorphosis.up&talent.chaotic_transformation)&talent.initiative)
    if ui.checked("Vengeful Retreat") and cast.able.vengefulRetreat() and ui.mode.mover ~= 3
        and ((talent.initiative and not talent.essenceBreak and unit.combatTime()>1 and ((not buff.initiative.exists() or cast.last.deathSweep(1)
        and not cd.metamorphosis.exists() and talent.chaoticTransformation) and talent.initiative)))
    then
        -- if ui.mode.mover == 1 then
            -- cancelRetreatAnimation()
        -- elseif ui.mode.mover == 2 then
            if cast.vengefulRetreat() then ui.debug("Casting Vengeful Retreat - Initiative No Essence Break [Combat]") return true end
        -- end
    end

    -- Fel Rush
    -- fel_rush,if=talent.momentum.enabled&buff.momentum.remains<gcd.max*2&cooldown.eye_beam.remains<=gcd.max&debuff.essence_break.down&cooldown.blade_dance.remains
    if cast.able.felRush() and not unit.isExplosive("target") and #enemies.yards23r > 1 and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
        and talent.momentum and buff.momentum.remains()<unit.gcd(true)*2 and cd.eyeBeam.remains()<=unit.gcd(true) and not debuff.essenceBreak.exists(units.dyn5)
        and cd.bladeDance.remains()
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush - Momentum [Combat]")
            return true
        end
        if ui.mode.mover ~= 3 and (unit.distance("target") < 8 or (not ui.checked("Fel Rush Only In Melee") and unit.distance("target") >= 8)) then
            if cast.felRush() then ui.debug("Casting Fel Rush - Momentum [Combat]") return true end
        end
    end

    -- Fel Rush
    -- fel_rush,if=talent.inertia.enabled&!buff.inertia.up&buff.unbound_chaos.up&(buff.metamorphosis.up|cooldown.eye_beam.remains>action.immolation_aura.recharge_time&cooldown.eye_beam.remains>4)&debuff.essence_break.down&cooldown.blade_dance.remains
    if cast.able.felRush() and not unit.isExplosive("target") and #enemies.yards23r > 1 and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
        and ((talent.inertia and not buff.inertia.exists() and buff.unboundChaos.exists() and (buff.metamorphosis.exists() or cd.eyeBeam.remains()>charges.immolationAura.recharge()
        and cd.eyeBeam.remains()>4) and not debuff.essenceBreak.exists(units.dyn5) and cd.bladeDance.remains()))
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush - Intertia [Combat]")
            return true
        end
        if ui.mode.mover ~= 3 and (unit.distance("target") < 8 or (not ui.checked("Fel Rush Only In Melee") and unit.distance("target") >= 8)) then
            if cast.felRush() then ui.debug("Casting Fel Rush - Intertia [Combat]") return true end
        end
    end

    -- Essence Break
    -- essence_break,if=(active_enemies>desired_targets|raid_event.adds.in>40)&(buff.metamorphosis.remains>gcd.max*3|cooldown.eye_beam.remains>10)&(!talent.tactical_retreat|buff.tactical_retreat.up|time<10)&(buff.vengeful_retreat_movement.remains<gcd.max*0.5|time>0)&cooldown.blade_dance.remains<=3.1*gcd.max|fight_remains<6
    if cast.able.essenceBreak() and ((#enemies.yards5>ui.value(units.dyn5) and (buff.metamorphosis.remains()>unit.gcd(true)*3 or cd.eyeBeam.remains()>10)
        and (not talent.tacticalRetreat or buff.tacticalRetreat.exists() or unit.combatTime()<10)
        and (cast.timeSinceLast.vengefulRetreat()>=unit.gcd(true)*0.5 or unit.combatTime()>0) and cd.bladeDance.remains()<=3.1*unit.gcd(true) or unit.ttdGroup(40)<6))
    then
        if cast.essenceBreak() then ui.debug("Casting Essence Break [Combat]") return true end
    end

    -- Death Sweep
    -- death_sweep,if=variable.blade_dance&(!talent.essence_break|cooldown.essence_break.remains>gcd.max*2)&buff.fel_barrage.down
    if cast.able.deathSweep("player","aoe",1,8) and not unit.isExplosive("target") and #enemies.yards8 > 0
        and ((var.bladeDance and (not talent.essenceBreak or cd.essenceBreak.remains()>unit.gcd(true)*2) and not buff.felBarrage.exists()))
    then
        if cast.deathSweep("player","aoe",1,8) then ui.debug("Casting Death Sweep [Combat]") return true end
    end

    -- The Hunt
    -- the_hunt,if=debuff.essence_break.down&(time<10|cooldown.metamorphosis.remains>10|!equipped.algethar_puzzle_box)&(raid_event.adds.in>90|active_enemies>3|time_to_die<10)&(debuff.essence_break.down&(!talent.furious_gaze|buff.furious_gaze.up|set_bonus.tier31_4pc)|!set_bonus.tier30_2pc)&time>10
    if ui.alwaysCdAoENever("The Hunt",ui.value("Units to AoE"),#enemies.yards50r) and cast.able.theHunt()
        and ((not debuff.essenceBreak.exists(units.dyn5) and (unit.combatTime()<10 or cd.metamorphosis.remains()>10 or not equiped.algetharPuzzleBox())
        and (#enemies.yards5>3 or unit.ttd(units.dyn5)<10) and (not debuff.essenceBreak.exists(units.dyn5)
        and (not talent.furiousGaze or buff.furiousGaze.exists() or equiped.tier(31,4)) or not equiped.tier(30,2)) and unit.combatTime()>10))
    then
        if cast.theHunt() then ui.debug("Casting The Hunt - No Essence Break Debuff [Combat]") return true end
    end

    -- Fel Barrage
    -- fel_barrage,if=active_enemies>desired_targets|raid_event.adds.in>30&fury.deficit<20&buff.metamorphosis.down
    if ui.mode.felBarrage == 1 and not unit.isExplosive("target") and cast.able.felBarrage("player","aoe",1,8)
        and ((ui.mode.rotation == 1 and #enemies.yards8 >= ui.value("Units To AoE")) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
        and ((fury.deficit()<20 and not buff.metamorphosis.exists()))
    then
        if cast.felBarrage("player","aoe",1,8) then ui.debug("Casting Fel Barrage [Combat]") return true end
    end

    -- Glaive Tempest
    -- glaive_tempest,if=(active_enemies>desired_targets|raid_event.adds.in>10)&(debuff.essence_break.down|active_enemies>1)&buff.fel_barrage.down
    if cast.able.glaiveTempest("player","aoe",1,8) and unit.standingTime() > 2
        and ((((ui.mode.rotation == 1 and #enemies.yards8 >= ui.value("Units To AoE")) or ui.mode.rotation == 2 or ui.useCDs() or unit.ttd(units.dyn5) >= 7)
        and (not debuff.essenceBreak.exists(units.dyn5) or #enemies.yards8>1) and not buff.felBarrage.exists())) then
        if cast.glaiveTempest("player","aoe",1,8) then ui.debug("Casting Glaive Tempest [Combat]") return true end
    end

    -- Annihilation
    -- annihilation,if=buff.inner_demon.up&cooldown.eye_beam.remains<=gcd&buff.fel_barrage.down
    if cast.able.annihilation() and buff.innerDemon.exists() and cd.eyeBeam.remains()<=unit.gcd() and not buff.felBarrage.exists() then
        if cast.annihilation() then ui.debug("Casting Annihilation - Inner Demon [Combat]") return true end
    end

    -- Fel Rush
    -- fel_rush,if=talent.momentum.enabled&cooldown.eye_beam.remains<=gcd.max&buff.momentum.remains<5&buff.metamorphosis.down
    if cast.able.felRush() and not unit.isExplosive("target") and #enemies.yards23r > 1 and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
        and talent.momentum and cd.eyeBeam.remains()<=unit.gcd(true) and buff.momentum.remains()<5 and not buff.metamorphosis.exists()
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush - Momentum Eye Beam Soon [Combat]")
            return true
        end
        if ui.mode.mover ~= 3 and (unit.distance("target") < 8 or (not ui.checked("Fel Rush Only In Melee") and unit.distance("target") >= 8)) then
            if cast.felRush() then ui.debug("Casting Fel Rush - Momentum Eye Beam Soon [Combat]") return true end
        end
    end

    -- Eye Beam
    -- eye_beam,if=active_enemies>desired_targets|raid_event.adds.in>(40-talent.cycle_of_hatred*15)&!debuff.essence_break.up&(cooldown.metamorphosis.remains>30-talent.cycle_of_hatred*15|cooldown.metamorphosis.remains<gcd.max*2&(!talent.essence_break|cooldown.essence_break.remains<gcd.max*1.5))&(buff.metamorphosis.down|buff.metamorphosis.remains>gcd.max|!talent.restless_hunter)&(talent.cycle_of_hatred|!talent.initiative|cooldown.vengeful_retreat.remains>5|time<10)&buff.inner_demon.down|fight_remains<15
    if ui.mode.eyeBeam == 1 and not unit.isExplosive("target") and cast.able.eyeBeam("player","rect",1,20)
        and #enemies.yards20r > 0 and not unit.moving() and (eyebeamTTD() or unit.isDummy(units.dyn5))
        and ((not debuff.essenceBreak.exists(units.dyn5) and (cd.metamorphosis.remains()>30-var.cycleOfHatred*15 or cd.metamorphosis.remains()<unit.gcd(true)*2
        and (not talent.essenceBreak or cd.essenceBreak.remains()<unit.gcd(true)*1.5))
        and (not buff.metamorphosis.exists() or buff.metamorphosis.remains()>unit.gcd(true) or not talent.restlessHunter)
        and (talent.cycleOfHatred or not talent.initiative or cd.vengefulRetreat.remains()>5 or unit.combatTime()<10) and not buff.innerDemon.exists() or unit.ttdGroup(40)<15))
    then
        if cast.eyeBeam() then ui.debug("Casting Eye Beam [Combat]") return true end
    end

    -- Blade Dance
    -- blade_dance,if=variable.blade_dance&(cooldown.eye_beam.remains>5|equipped.algethar_puzzle_box&cooldown.metamorphosis.remains>(cooldown.blade_dance.duration)|!talent.demonic|(raid_event.adds.in>cooldown&raid_event.adds.in<25))&buff.fel_barrage.down|set_bonus.tier31_2pc
    if cast.able.bladeDance("player","aoe",1,8) and not unit.isExplosive("target") and #enemies.yards8 > 0
        and ((var.bladeDance and (cd.eyeBeam.remains()>5 or equiped.algetharPuzzleBox() and cd.metamorphosis.remains()>(cd.bladeDance.duration())
            or not talent.demonic) and not buff.felBarrage.exists() or equiped.tier(31,2)))
    then
        if cast.bladeDance("player","aoe",1,8) then ui.debug("Casting Blade Dance [Combat]") return true end
    end

    -- Sigil Of Flame
    -- sigil_of_flame,if=talent.any_means_necessary&debuff.essence_break.down&active_enemies>=4
    if not unit.moving(units.dyn5) and #enemies.yards5 > 0
        and talent.anyMeansNecessary and not debuff.essenceBreak.exists(units.dyn5) and #enemies.yards30>=4
    then
        if talent.preciseSigils and cast.able.sigilOfFlame(units.dyn30,"aoe",1,8) then
            if cast.sigilOfFlame(units.dyn30,"aoe",1,8) then ui.debug("Casting Sigil of Flame [Combat]") return true end
        end
        if cast.able.sigilOfFlame("best",false,1,8) and not talent.preciseSigils and not talent.concentratedSigils then
            if cast.sigilOfFlame("best",false,1,8) then ui.debug("Casting Sigil of Flame [Combat]") return true end
        end
    end

    -- Throw Glaive
    -- throw_glaive,if=talent.soulscar&(active_enemies>desired_targets|raid_event.adds.in>full_recharge_time+9)&spell_targets>=(2-talent.furious_throws)&!debuff.essence_break.up&(full_recharge_time<gcd.max*3|active_enemies>1)&!set_bonus.tier31_2pc
    if ui.checked("Throw Glaive") and cast.able.throwGlaive() and ((talent.soulscar and #enemies.yards8>ui.value("Units to AoE") and #enemies.yards8>=(2-var.furiousThrows)
        and not debuff.essenceBreak.exists(units.dyn5) and (charges.throwGlaive.timeTillFull()<unit.gcd(true)*3 or #enemies.yards8>1) and not equiped.tier(31,2)))
    then
        if cast.throwGlaive() then ui.debug("Casting Throw Glaive - Max Charges [Combat]") return true end
    end

    -- Immolation Aura
    -- immolation_aura,if=active_enemies>=2&fury<70&debuff.essence_break.down
    if cast.able.immolationAura("player","aoe",1,8) and #enemies.yards8>=2 and fury()<70 and not debuff.essenceBreak.exists(units.dyn5) then
        if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura - No Essence Break [Combat]") return true end
    end

    -- Annihilation
    -- annihilation,if=!variable.pooling_for_blade_dance&(cooldown.essence_break.remains|!talent.essence_break)&buff.fel_barrage.down|set_bonus.tier30_2pc
    if cast.able.annihilation() and ((not var.poolingForBladeDance and (cd.essenceBreak.remains() or not talent.essenceBreak)
        and not buff.felBarrage.exists() or equiped.tier(30,2)))
    then
        if cast.annihilation() then ui.debug("Casting Annihilation  - No Blade Dance Pooling [Combat]") return true end
    end

    -- Felblade
    -- felblade,if=fury.deficit>=40&talent.any_means_necessary&debuff.essence_break.down|talent.any_means_necessary&debuff.essence_break.down
    if cast.able.felblade() and ((fury.deficit()>=40 and talent.anyMeansNecessary
        and not debuff.essenceBreak.exists(units.dyn5) or talent.anyMeansNecessary and not debuff.essenceBreak.exists(units.dyn5)))
    then
        if cast.felblade() then ui.debug("Casting Felblade [Combat]") return true end
    end

    -- Sigil Of Flame
    -- sigil_of_flame,if=fury.deficit>=40&talent.any_means_necessary
    if not unit.moving(units.dyn5) and #enemies.yards5 > 0 and fury.deficit()>=40 and talent.anyMeansNecessary then
        if talent.preciseSigils and cast.able.sigilOfFlame(units.dyn30,"aoe",1,8) then
            if cast.sigilOfFlame(units.dyn30,"aoe",1,8) then ui.debug("Casting Sigil of Flame - Any Means Necessary [Combat]") return true end
        end
        if cast.able.sigilOfFlame("best",false,1,8) and not talent.preciseSigils and not talent.concentratedSigils then
            if cast.sigilOfFlame("best",false,1,8) then ui.debug("Casting Sigil of Flame - Any Means Necessary [Combat]") return true end
        end
    end

    -- Throw Glaive
    -- throw_glaive,if=talent.soulscar&(active_enemies>desired_targets|raid_event.adds.in>full_recharge_time+9)&spell_targets>=(2-talent.furious_throws)&!debuff.essence_break.up&!set_bonus.tier31_2pc
    if ui.checked("Throw Glaive") and cast.able.throwGlaive() and ((talent.soulscar and #enemies.yards8>ui.value("Units to AoE") and #enemies.yards8>=(2-talent.furiousThrows)
        and not debuff.essenceBreak.exists(units.dyn5) and not equiped.tier(31,2)))
    then
        if cast.throwGlaive() then ui.debug("Casting Throw Glaive [Combat]") return true end
    end

    -- Immolation Aura
    -- immolation_aura,if=buff.immolation_aura.stack<buff.immolation_aura.max_stack&(!talent.ragefire|active_enemies>desired_targets|raid_event.adds.in>15)&buff.out_of_range.down&(!buff.unbound_chaos.up|!talent.unbound_chaos)&(recharge_time<cooldown.essence_break.remains|!talent.essence_break&cooldown.eye_beam.remains>recharge_time)
    if cast.able.immolationAura("player","aoe",1,8) and ((buff.immolationAura.stack()<buff.immolationAura.stackMax()
        and (not talent.ragefire or #enemies.yards8>ui.value("Units to AoE")) and unit.distance(units.dyn8AoE)<8
        and (not buff.unboundChaos.exists() or not talent.unboundChaos) and (charges.immolationAura.recharge()<cd.essenceBreak.remains() or not talent.essenceBreak
        and cd.eyeBeam.remains()>charges.immolationAura.recharge())))
    then
        if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura - No Eye Beam Before Recharge [Combat]") return true end
    end

    -- Throw Glaive
    -- throw_glaive,if=talent.soulscar&cooldown.throw_glaive.full_recharge_time<cooldown.blade_dance.remains&set_bonus.tier31_2pc&buff.fel_barrage.down&!variable.pooling_for_eye_beam
    if ui.checked("Throw Glaive") and cast.able.throwGlaive() and talent.soulscar and charges.throwGlaive.timeTillFull()<cd.bladeDance.remains()
        and equiped.tier(31,2) and not buff.felBarrage.exists() and not var.poolingForEyeBeam
    then
        if cast.throwGlaive() then ui.debug("Casting Throw Glaive - No Eye Beam Pooling [Combat]") return true end
    end

    -- Chaos Strike
    -- chaos_strike,if=!variable.pooling_for_blade_dance&!variable.pooling_for_eye_beam&buff.fel_barrage.down
    if cast.able.chaosStrike() and not var.poolingForBladeDance and not var.poolingForEyeBeam and not buff.felBarrage.exists() then
        if cast.chaosStrike() then ui.debug("Casting Chaos Strike [Combat]") return true end
    end

    -- Sigil Of Flame
    -- sigil_of_flame,if=raid_event.adds.in>15&fury.deficit>=30&buff.out_of_range.down
    if not unit.moving(units.dyn5) and #enemies.yards5 > 0 and fury.deficit()>=30 and unit.distance(units.dyn8AOE)<8 then
        if talent.preciseSigils and cast.able.sigilOfFlame(units.dyn30,"aoe",1,8) then
            if cast.sigilOfFlame(units.dyn30,"aoe",1,8) then ui.debug("Casting Sigil of Flame - Low Fury [Combat]") return true end
        end
        if cast.able.sigilOfFlame("best",false,1,8) and not talent.preciseSigils and not talent.concentratedSigils then
            if cast.sigilOfFlame("best",false,1,8) then ui.debug("Casting Sigil of Flame - Low Fury [Combat]") return true end
        end
    end

    -- Felblade
    -- felblade,if=fury.deficit>=40
    if cast.able.felblade() and fury.deficit()>=40 then
        if cast.felblade() then ui.debug("Casting Felblade - Low Fury [Combat]") return true end
    end

    -- Fel Rush
    -- fel_rush,if=!talent.momentum&talent.demon_blades&!cooldown.eye_beam.ready&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))&(buff.unbound_chaos.down)&(recharge_time<cooldown.essence_break.remains|!talent.essence_break)
    if cast.able.felRush() and not unit.isExplosive("target") and #enemies.yards23r > 1 and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
        and ((not talent.momentum and talent.demonBlades and not not cd.eyeBeam.exists() and charges==2
        and (not buff.unboundChaos.exists()) and (charges.felRush.recharge()<cd.essenceBreak.remains() or not talent.essenceBreak)))
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush - 2 Charges [Combat]")
            return true
        end
        if ui.mode.mover ~= 3 and (unit.distance("target") < 8 or (not ui.checked("Fel Rush Only In Melee") and unit.distance("target") >= 8)) then
            if cast.felRush() then ui.debug("Casting Fel Rush - 2 Charges [Combat]") return true end
        end
    end

    -- Demons Bite
    -- demons_bite,target_if=min:debuff.burning_wound.remains,if=talent.burning_wound&debuff.burning_wound.remains<4&active_dot.burning_wound<(spell_targets>?3)
    if cast.able.demonsBite(var.lowestBurningWound) and talent.burningWound and debuff.burningWound.remains(var.lowestBurningWound)<4
        and debuff.burningWound.count(var.lowestBurningWound)<(math.max(#enemies.yards5,3))
    then
        if cast.demonsBite(var.lowestBurningWound) then ui.debug("Casting Demons Bite - Low Burning Wounds [Combat]") return true end
    end

    -- Fel Rush
    -- fel_rush,if=!talent.momentum&!talent.demon_blades&spell_targets>1&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))&(buff.unbound_chaos.down)
    if cast.able.felRush() and not unit.isExplosive("target") and #enemies.yards23r > 1 and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
        and ((not talent.momentum and not talent.demonBlades and #enemies.yards5>1 and charges==2 and (not buff.unboundChaos.exists())))
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush - 2 Charges AoE [Combat]")
            return true
        end
        if ui.mode.mover ~= 3 and (unit.distance("target") < 8 or (not ui.checked("Fel Rush Only In Melee") and unit.distance("target") >= 8)) then
            if cast.felRush() then ui.debug("Casting Fel Rush - 2 Charges AoE [Combat]") return true end
        end
    end

    -- Sigil Of Flame
    -- sigil_of_flame,if=raid_event.adds.in>15&fury.deficit>=30&buff.out_of_range.down
    if not unit.moving(units.dyn5) and #enemies.yards5 > 0 and fury.deficit()>=30 and unit.distance(units.dyn8AoE)<8 then
        if talent.preciseSigils and cast.able.sigilOfFlame(units.dyn30,"aoe",1,8) then
            if cast.sigilOfFlame(units.dyn30,"aoe",1,8) then ui.debug("Casting Sigil of Flame - Low Fury 2 [Combat]") return true end
        end
        if cast.able.sigilOfFlame("best",false,1,8) and not talent.preciseSigils and not talent.concentratedSigils then
            if cast.sigilOfFlame("best",false,1,8) then ui.debug("Casting Sigil of Flame - Low Fury 2 [Combat]") return true end
        end
    end

    -- Demons Bite
    -- demons_bite
    if cast.able.demonsBite() then
        if cast.demonsBite() then ui.debug("Casting Demons Bite [Combat]") return true end
    end

    -- Fel Rush
    -- fel_rush,if=talent.momentum&buff.momentum.remains<=20
    if cast.able.felRush() and not unit.isExplosive("target") and #enemies.yards23r > 1 and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
        and talent.momentum and buff.momentum.remains()<=20
    then
        if ui.mode.mover == 1 and unit.distance("target") < 8 then
            cancelRushAnimation("Casting Fel Rush - Momentum Expire Soon [Combat]")
            return true
        end
        if ui.mode.mover ~= 3 and (unit.distance("target") < 8 or (not ui.checked("Fel Rush Only In Melee") and unit.distance("target") >= 8)) then
            if cast.felRush() then ui.debug("Casting Fel Rush - Momentum Expire Soon [Combat]") return true end
        end
    end

    -- Fel Rush
    -- fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum)
    if cast.able.felRush() and not unit.isExplosive("target") and #enemies.yards23r > 1 and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
        and ((unit.distance("target")>15 or (unit.distance("target")>=8 and not talent.momentum)))
    then
        if ui.mode.mover ~= 3 then
            if cast.felRush() then ui.debug("Casting Fel Rush - Close Distance [Combat]") return true end
        end
    end

    -- Vengeful Retreat
    -- vengeful_retreat,if=!talent.initiative&movement.distance>15
    if ui.checked("Vengeful Retreat") and cast.able.vengefulRetreat() and ui.mode.mover ~= 3
        and not talent.initiative and not unit.facing("player","target") and unit.distance("target")>15
    then
        -- if ui.mode.mover == 1 then
            -- cancelRetreatAnimation()
        -- elseif ui.mode.mover == 2 then
            if cast.vengefulRetreat() then ui.debug("Casting Vengeful Retreat - No Initiative Close Distance [Combat]") return true end
        -- end
    end

    -- Throw Glaive
    -- throw_glaive,if=(talent.demon_blades|buff.out_of_range.up)&!debuff.essence_break.up&buff.out_of_range.down&!set_bonus.tier31_2pc
    if ui.checked("Throw Glaive") and cast.able.throwGlaive() and (((talent.demonBlades or unit.distance("target")>=8)
        and not debuff.essenceBreak.exists(units.dyn5) and unit.distance("target")<8 and not equiped.tier(31,2)))
    then
        if cast.throwGlaive() then ui.debug("Casting Throw Glaive - Melee [Combat]") return true end
    end
end -- End Action List - Combat

-- Action List - MetaEnd
actionList.MetaEnd = function()
    -- Death Sweep
    -- death_sweep,if=buff.fel_barrage.down
    if cast.able.deathSweep() and not buff.felBarrage.exists() then
        if cast.deathSweep() then ui.debug("Casting Death Sweep [Meta End]") return true end
    end

    -- Annihilation
    -- annihilation,if=buff.fel_barrage.down
    if cast.able.annihilation() and not buff.felBarrage.exists() then
        if cast.annihilation() then ui.debug("Casting Annihilation [Meta End]") return true end
    end
end -- End Action List - MetaEnd

----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------
    --- BR API ---
    --------------
    -- Initialize
    if not br.player.initialized then
        -- BR API
        br.player.actionList = actionList
        buff                                            = br.player.buff
        cast                                            = br.player.cast
        cd                                              = br.player.cd
        charges                                         = br.player.charges
        debuff                                          = br.player.debuff
        enemies                                         = br.player.enemies
        equiped                                         = br.player.equiped
        fury                                            = br.player.power.fury
        has                                             = br.player.has
        module                                          = br.player.module
        ui                                              = br.player.ui
        unit                                            = br.player.unit
        units                                           = br.player.units
        use                                             = br.player.use
        talent                                          = br.player.talent
        var                                             = br.player.variables

        var.lastRune = ui.time()
        var.profileStop = false
        br.player.initialized = true
    end

    ------------
    --- Vars ---
    ------------
    var.falling                                     = br.getFallTime()
    var.inRaid                                     = unit.instance=="raid"
    -- target_if=min:debuff.burning_wound.remains
    var.lowestBurningWound                          = debuff.burningWound.lowest(5,"remain") or "target"
    var.solo                                       = #br.friend == 1

    units.get(5)
    units.get(8,true)
    units.get(30)
    enemies.get(5)
    enemies.get(8)
    enemies.get(10)
    enemies.get(10,"target",true)
    enemies.get(20)
    enemies.get(30)
    enemies.rect.get(8,20,false)
    enemies.rect.get(3,23,false)
    enemies.rect.get(8,50,false)

    -- Talent to Number
    var.cycleOfHatred = talent.cycleOfHatred and 1 or 0
    var.demonBlades = talent.demonBlades and 1 or 0
    var.furiousThrows = talent.furiousThrows and 1 or 0
    var.innerDemon = talent.innerDemon and 1 or 0
    var.shatteredDestiny = talent.shatteredDestiny and 1 or 0

    -- if ui.mode.mover == 1 and cast.last.vengefulRetreat() then StopFalling(); end
    -- if IsHackEnabled("NoKnockback") then
    --     SetHackEnabled("NoKnockback", false)
    -- end
    -- -- Fel Rush Special
    -- if unit.inCombat() and ui.mode.mover ~= 3 and ui.checked("Auto Fel Rush After Retreat") and cast.able.felRush()
    --     and (buff.prepared.exists() or cast.timeSinceLast.vengefulRetreat() < unit.gcd(true) * 2) and not buff.momentum.exists() and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
    -- then
    --     --[[if ui.mode.mover == 1 and unit.distance("target") < 8 then
    --         cancelRushAnimation("Casting Fel Rush [Special]")
    --     else]]if not ui.checked("Fel Rush Only In Melee") and (ui.mode.mover == 2 or (unit.distance("target") >= 8 and ui.mode.mover ~= 3)) then
    --         if cast.felRush() then ui.debug("Casting Fel Rush [Special]") return true end
    --     end
    -- end

    -- target_if=min:!target.is_boss
    var.minTTD=99999
    var.minTTDUnit="target"
    for i=1,#enemies.yards5 do
        local thisUnit=enemies.yards5[i]
        local thisCondition=unit.ttd(thisUnit)
        if not unit.isBoss(thisUnit) and thisCondition<var.minTTD then
            var.minTTD=thisCondition
            var.minTTDUnit=thisUnit
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or ui.mode.rotation==4 or cast.active.eyeBeam() then
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
        if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
            if actionList.Precombat() then return true end
        end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if (unit.inCombat() or (not unit.inCombat() and unit.valid("target"))) and not var.profileStop
            and unit.exists("target") and cd.global.remain() == 0
        then
            if actionList.Combat() then return true end
        end
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

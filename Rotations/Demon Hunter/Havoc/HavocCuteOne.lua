local rotationName = "CuteOne"

---------------
--- Toggles ---
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
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
            -- br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Auto Engage
            br.ui:createCheckbox(section, "Auto Engage")
            -- Eye Beam Targets
            br.ui:createDropdownWithout(section,"Eye Beam Usage",{"|cff00FF00Per APL","|cffFFFF00AoE Only","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Eye Beam.")
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
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Seventh Demon","Repurposed Fel Focuser","Oralius' Whispering Crystal","Gaze of the Legion","None"}, 1, "|cffFFFFFFSet Elixir to use.")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF001st Only","|cff00FF002nd Only","|cffFFFF00Both","|cffFF0000None"}, 1, "|cffFFFFFFSelect Trinket Usage.")
            -- Metamorphosis
            br.ui:createCheckbox(section,"Metamorphosis")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
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
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Mover Key Toggle
            br.ui:createDropdown(section, "Mover Mode", br.dropOptions.Toggle,  6)
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
local combatTime
local cd
local charges
local hastar
local debuff
local enemies
local equiped
local falling, flying, moving
local gcd
local has
local healPot
local inCombat
local inRaid
local item
local mode
local php
local power, powerDeficit
local pullTimer
local solo
local spell
local talent
local ttd
local traits
local units
local use

local leftCombat
local profileStop
local flood
local metaExtended
local metaEyeBeam

local bladeDanceVar
local poolForMeta
local poolForBladeDance
local poolForEyeBeam
local waitForDarkSlash
local waitForMomentum
local waitForNemesis

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

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
local actionList = {}
actionList.Extras = function()
    -- Dummy Test
    if isChecked("DPS Testing") then
        if GetObjectExists("target") then
            if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                StopAttack()
                ClearTarget()
                Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                profileStop = true
            end
        end
    end -- End Dummy Test
    -- Glide
    if isChecked("Glide") and cast.able.glide() and not buff.glide.exists() then
        if falling >= getOptionValue("Glide") then
            if cast.glide("player") then return end
        end
    end
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    if useDefensive() then
        -- Pot/Stoned
        if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned")
            and inCombat and (hasHealthPot() or hasItem(5512))
        then
            if canUse(5512) then
                useItem(5512)
            elseif canUse(129196) then --Legion Healthstone
                useItem(129196)
            elseif canUse(healPot) then
                useItem(healPot)
            end
        end
        -- Heirloom Neck
        if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
            if hasEquiped(122668) then
                if GetItemCooldown(122668)==0 then
                    useItem(122668)
                end
            end
        end
        -- Blur
        if isChecked("Blur") and cast.able.blur() and php <= getOptionValue("Blur") and inCombat then
            if cast.blur() then return end
        end
        -- Darkness
        if isChecked("Darkness") and cast.able.darkness() and php <= getOptionValue("Darkness") and inCombat then
            if cast.darkness() then return end
        end
        -- Chaos Nova
        if isChecked("Chaos Nova - HP") and cast.able.chaosNova() and not buff.metamorphosis.exists()
            and php <= getValue("Chaos Nova - HP") and inCombat and #enemies.yards5 > 0
        then
            if cast.chaosNova() then return end
        end
        if isChecked("Chaos Nova - AoE") and cast.able.chaosNova() and not buff.metamorphosis.exists()
            and #enemies.yards5 >= getValue("Chaos Nova - AoE")
        then
            if cast.chaosNova() then return end
        end
        -- Consume Magic
        if isChecked("Consume Magic") and cast.able.consumeMagic("target") and canDispel("target",spell.consumeMagic) and not isBoss() and GetObjectExists("target") then
            if cast.consumeMagic("target") then return end
        end
    end -- End Defensive Toggle
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if useInterrupts() then
        -- Fel Eruption
        if isChecked("Fel Eruption") and talent.felEruption then 
            for i=1, #enemies.yards20 do
                thisUnit = enemies.yards20[i]
                if canInterrupt(thisUnit,getOptionValue("Interrupt At")) and cast.able.felEruption(thisUnit) then
                    if cast.felEruption(thisUnit) then return end
                end
            end 
        end
        -- Disrupt
        if isChecked("Disrupt") then
            for i=1, #enemies.yards10 do
                thisUnit = enemies.yards10[i]
                if canInterrupt(thisUnit,getOptionValue("Interrupt At")) and cast.able.disrupt(thisUnit) then
                    if cast.disrupt(thisUnit) then return end
                end
            end
        end
        -- Chaos Nova
        if isChecked("Chaos Nova") then
            for i=1, #enemies.yards5 do
                thisUnit = enemies.yards5[i]
                if canInterrupt(thisUnit,getOptionValue("InterruptAt")) and cast.able.chaosNova(thisUnit) then
                    if cast.chaosNova(thisUnit) then return end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if useCDs() and getDistance(units.dyn5) < 5 then
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
        if isChecked("Racial") and cast.able.racial() and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
            if cast.racial() then return end
        end
        -- Metamorphosis
        if isChecked("Metamorphosis") then
            -- metamorphosis,if=!(talent.demonic.enabled|variable.pooling_for_meta|variable.waiting_for_nemesis)|target.time_to_die<25
            if cast.able.metamorphosis() and (not (talent.demonic or poolForMeta or waitForNemesis) and ttd(units.dyn5) >= 25) then
                -- if cast.metamorphosis("best",false,1,8) then return end
                if cast.metamorphosis("player") then return end
            end
            -- metamorphosis,if=talent.demonic.enabled&(!azerite.chaotic_transformation.enabled|(cooldown.eye_beam.remains>20&cooldown.blade_dance.remains>gcd.max))
            if cast.able.metamorphosis() and talent.demonic and (not traits.chaoticTransformation.active 
                or (cd.eyeBeam.remain() > 20 and cd.bladeDance.remain() > gcd)) 
            then
                if cast.metamorphosis("player") then return end
            end
        end
        -- Nemesis
        -- nemesis,target_if=min:target.time_to_die,if=raid_event.adds.exists&debuff.nemesis.down&(active_enemies>desired_targets|raid_event.adds.in>60)
        -- nemesis,if=!raid_event.adds.exists
        if cast.able.nemesis() then
            local lowestUnit = units.dyn5
            if isDummy("target") then
                lowestUnit = "target"
            else
                for i = 1, #enemies.yards50 do
                    local thisUnit = enemies.yards50[i]
                    local lowestTTD = lowestTTD or 999
                    if ttd(thisUnit) < lowestTTD and not debuff.nemesis.exists(thisUnit) then
                        lowestTTD = ttd(thisUnit)
                        lowestUnit = thisUnit
                    end
                end
            end
            if cast.nemesis(lowestUnit) then return end
        end
        -- Trinkets
        -- use_item,slot=trinket2,if=!buff.metamorphosis.up&(!talent.first_blood.enabled|!cooldown.blade_dance.ready)&(!talent.nemesis.enabled|cooldown.nemesis.remains>30|target.time_to_die<cooldown.nemesis.remains+3)
            -- if not buff.metamorphosis.exists() and (not talent.firstBlood or cd.bladeDance.remain() ~= 0) and (not talent.nemesis or cd.nemesis.remain() > 30 or ttd(units.dyn5) < cd.nemesis.remain() + 3) then
        if (getOptionValue("Trinkets") == 1 or getOptionValue("Trinkets") == 3) and canUse(13) then
            useItem(13)
        end
        if (getOptionValue("Trinkets") == 2 or getOptionValue("Trinkets") == 3) and canUse(14) then
            useItem(14)
        end
        -- Potion
        -- potion,if=buff.metamorphosis.remains>25|target.time_to_die<60
        if isChecked("Potion") and canUse(127844) and inRaid then
            if buff.metamorphosis.remain() > 25 and ttd(units.dyn5) >= 60 then
                useItem(127844)
            end
        end
    end -- End useCDs check
end -- End Action List - Cooldowns

-- Action List - Dark Slash
actionList.DarkSlash = function()
    -- Dark Slash
    -- dark_slash,if=fury>=80&(!variable.blade_dance|!cooldown.blade_dance.ready)
    if cast.able.darkSlash(units.dyn5) and power >= 80 and (not bladeDanceVar or cd.bladeDance.remain() ~= 0) then
        Print("Action List - Dark Slash")
        if cast.darkSlash(units.dyn5) then return end
    end
    -- Annihilation
    -- annihilation,if=debuff.dark_slash.up
    if cast.able.annihilation() and debuff.darkSlash.exists(units.dyn5) then
        if cast.able.annihilation() then return end
    end
    -- Chaos Strike
    -- chaos_strike,if=debuff.dark_slash.up
    if cast.able.chaosStrike() and debuff.darkSlash.exists(units.dyn5) then
        if cast.able.chaosStrike() then return end
    end
end -- End Action List - Dark Slash

-- Action List - Demonic
actionList.Demonic = function()
    -- Fel Barrage
    -- fel_barrage,if=active_enemies>desired_targets|raid_event.adds.in>30
    if mode.felBarrage == 1 and cast.able.felBarrage() and ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Units To AoE")) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
        if cast.felBarrage("player","aoe",1,8) then return end
    end
    -- Death Sweep
    -- death_sweep,if=variable.blade_dance
    if cast.able.deathSweep() and #enemies.yards8 > 0 and buff.metamorphosis.exists() and bladeDanceVar then
        if cast.deathSweep("player","aoe",1,8) then return end
    end
    -- Eye Beam
    -- eye_beam,if=raid_event.adds.up|raid_event.adds.in>25
    if mode.eyeBeam == 1 and cast.able.eyeBeam() and not moving and enemies.yards8r > 0
        and ((getOptionValue("Eye Beam Usage") == 1 and mode.rotation == 1 and enemies.yards8r > 0)
            or (getOptionValue("Eye Beam Usage") == 2 and mode.rotation == 1 and enemies.yards8r >= getOptionValue("Units To AoE"))
            or (mode.rotation == 2 and enemies.yards8r > 0)) and (ttd(units.dyn8) > 2 or isDummy(units.dyn8))
    then
        -- if cast.eyeBeam(units.dyn5) then return end
        if cast.eyeBeam(nil,"rect",1,8) then return end
    end
    -- Blade Dance
    -- blade_dance,if=variable.blade_dance&!cooldown.metamorphosis.ready&(cooldown.eye_beam.remains>(5-azerite.revolving_blades.rank*3)|(raid_event.adds.in>cooldown&raid_event.adds.in<25))
    if cast.able.bladeDance() and #enemies.yards8 > 0 and bladeDanceVar and (cd.metamorphosis.remain() > 0 or not useCDs() or not isChecked("Metamorphosis"))
        and ((cd.eyeBeam.remain() > (5 - traits.revolvingBlades.rank * 3)) or mode.eyeBeam == 2)
        --     or ((mode.rotation == 1 and (getOptionValue("Eye Beam Usage") == 3
        --         or (getOptionValue("Eye Beam Usage") == 2 and enemies.yards8r < getOptionValue("Units To AoE"))
        --         or (getOptionValue("Eye Beam Usage") == 1 and enemies.yards8r == 0)))
        --     or mode.rotation == 2))
        -- and (cd.metamorphosis.remain() ~= 0 or not isChecked("Metamorphosis") or not useCDs() or not isBoss())
    then
        if cast.bladeDance("player","aoe",1,8) then return end
    end
    -- Immolation Aura
    -- immolation_aura
    if cast.able.immolationAura() and #enemies.yards8 > 0 then
        if cast.immolationAura("player","aoe",1,8) then return end
    end
    -- Annihilation
    -- annihilation,if=!variable.pooling_for_blade_dance
    if cast.able.annihilation() and buff.metamorphosis.exists() and not poolForBladeDance then
        if cast.annihilation() then return end
    end
    -- Felblade
    -- felblade,if=fury.deficit>=40
    if cast.able.felblade() and powerDeficit >= 40 and not cast.last.vengefulRetreat() and getDistance("target") < 5 then
        if cast.felblade() then return end
    end
    -- Chaos Strike
    -- chaos_strike,if=!variable.pooling_for_blade_dance&!variable.pooling_for_eye_beam
    if cast.able.chaosStrike() and not poolForBladeDance and not poolForEyeBeam then
        if cast.chaosStrike() then return end
    end
    -- Fel Rush
    -- fel_rush,if=talent.demon_blades.enabled&!cooldown.eye_beam.ready&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
    if cast.able.felRush() and getFacing("player","target",10) and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge")
        and talent.demonBlades and cd.eyeBeam.remain() ~= 0 and charges.felRush.count() == 2
    then
        if mode.mover == 1 and getDistance("target") < 8 then
            cancelRushAnimation()
        elseif not isChecked("Fel Rush Only In Melee") and (mode.mover == 2 or (getDistance("target") >= 8 and mode.mover ~= 3)) then
            if cast.felRush() then return end
        end
    end
    -- Demon's Bite
    -- demons_bite
    if cast.able.demonsBite(units.dyn5) and not talent.demonBlades then
        if cast.demonsBite(units.dyn5) then return end
    end
    -- Throw Glaive
    -- throw_glaive,if=buff.out_of_range.up
    if isChecked("Throw Glaive") and cast.able.throwGlaive() and getDistance(units.dyn30) > 8 then
        if cast.throwGlaive(nil,"aoe",1,10) then return end
    end
    -- Fel Rush
    -- fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum.enabled)
    if not isChecked("Fel Rush Only In Melee") and cast.able.felRush() and mode.mover ~= 3 and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge")
        and (getDistance("target") > 15 or (getDistance("target") > 8 and not talent.momentum))
    then
        if cast.felRush() then return end
    end
    -- Throw Glaive
    -- throw_glaive,if=talent.demon_blades.enabled
    if isChecked("Throw Glaive") and cast.able.throwGlaive() and talent.demonBlades then
        if cast.throwGlaive(nil,"aoe",1,10) then return end
    end
end -- End Action List - Demonic

-- Action List - Normal
actionList.Normal = function()
    -- Vengeful Retreat
    -- vengeful_retreat,if=talent.momentum.enabled&buff.prepared.down&time>1
    if isChecked("Vengeful Retreat") and cast.able.vengefulRetreat() and talent.momentum
        and not buff.prepared.exists() and combatTime > 1 and getDistance(units.dyn5) < 5
    then
        if mode.mover == 1 then
            cancelRetreatAnimation()
        elseif mode.mover == 2 then
            if cast.vengefulRetreat() then return end
        end
    end
    -- Fel Rush
    -- fel_rush,if=(variable.waiting_for_momentum|talent.fel_mastery.enabled)&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
    if cast.able.felRush() and getFacing("player","target",10) and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge")
        and (waitForMomentum or talent.felMastery)
    then
        if mode.mover == 1 and getDistance("target") < 8 then
            cancelRushAnimation()
        elseif not isChecked("Fel Rush Only In Melee") and (mode.mover == 2 or (getDistance("target") >= 8 and mode.mover ~= 3)) then
            if cast.felRush() then return end
        end
    end
    -- Fel Barrage
    -- fel_barrage,if=!variable.waiting_for_momentum&(active_enemies>desired_targets|raid_event.adds.in>30)
    if mode.felBarrage == 1 and cast.able.felBarrage() and waitForMomentum and ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Units To AoE")) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
        if cast.felBarrage("player","aoe",1,8) then return end
    end
    -- Death Sweep
    -- death_sweep,if=variable.blade_dance
    if cast.able.deathSweep() and #enemies.yards8 > 0 and buff.metamorphosis.exists() and bladeDanceVar then
        if cast.deathSweep("player","aoe",1,8) then return end
    end
    -- Immolation Aura
    -- immolation_aura
    if cast.able.immolationAura() and #enemies.yards8 > 0 then
        if cast.immolationAura("player","aoe",1,8) then return end
    end
    -- Eye Beam
    -- eye_beam,if=active_enemies>1&(!raid_event.adds.exists|raid_event.adds.up)&!variable.waiting_for_momentum
    if mode.eyeBeam == 1 and cast.able.eyeBeam() and enemies.yards8r > 0 and not moving and not waitForMomentum and (not talent.momentum or buff.momentum.exists())
        and (ttd(units.dyn8) > 2 or isDummy(units.dyn8))
        -- and ((getOptionValue("Eye Beam Usage") == 1 and mode.rotation == 1 and enemies.yards8r > 1)
        --     or (getOptionValue("Eye Beam Usage") == 2 and mode.rotation == 1 and enemies.yards8r >= getOptionValue("Units To AoE"))
        --     or (mode.rotation == 2 and enemies.yards8r > 0))
    then
        -- if cast.eyeBeam(units.dyn5) then return end
        if cast.eyeBeam(nil,"rect",1,8) then return end
    end
    -- Blade Dance
    -- blade_dance,if=variable.blade_dance
    if cast.able.bladeDance() and #enemies.yards8 > 0 and not buff.metamorphosis.exists() and bladeDanceVar then
        if cast.bladeDance("player","aoe",1,8) then return end
    end
    -- Felblade
    -- felblade,if=fury.deficit>=40
    if cast.able.felblade() and powerDeficit >= 40 and not cast.last.vengefulRetreat() and getDistance("target") < 5 then
        if cast.felblade() then return end
    end
    -- Eye Beam
    -- eye_beam,if=!talent.blind_fury.enabled&!variable.waiting_for_dark_slash&raid_event.adds.in>cooldown
    if cast.able.eyeBeam() and enemies.yards8r > 0 and not moving and not talent.blindFury and not waitForDarkSlash and (not talent.momentum or buff.momentum.exists())
        and (ttd(units.dyn8) > 2 or isDummy(units.dyn8))
        -- and ((getOptionValue("Eye Beam Usage") == 1 and mode.rotation == 1 and enemies.yards8r > 0)
        --     or (getOptionValue("Eye Beam Usage") == 2 and mode.rotation == 1 and enemies.yards8r >= getOptionValue("Units To AoE"))
        --     or (mode.rotation == 2 and enemies.yards8r > 0))
    then
        -- if cast.eyeBeam(units.dyn5) then return end
        if cast.eyeBeam(nil,"rect",1,8) then return end
    end
    -- Annihilation
    -- annihilation,if=(talent.demon_blades.enabled|!variable.waiting_for_momentum|fury.deficit<30|buff.metamorphosis.remains<5)&!variable.pooling_for_blade_dance&!variable.waiting_for_dark_slash
    if cast.able.annihilation() and buff.metamorphosis.exists() and (talent.demonBlades or not waitForMomentum or powerDeficit < 30 or buff.metamorphosis.remain() < 5)
        and not poolForBladeDance and not waitForDarkSlash
    then
        if cast.annihilation() then return end
    end
    -- Chaos Strike
    -- chaos_strike,if=(talent.demon_blades.enabled|!variable.waiting_for_momentum|fury.deficit<30)&!variable.pooling_for_meta&!variable.pooling_for_blade_dance&!variable.waiting_for_dark_slash
    if cast.able.chaosStrike() and not buff.metamorphosis.exists() and (talent.demonBlades or not waitForMomentum or powerDeficit < 30)
        and not poolForMeta and not poolForBladeDance and not waitForDarkSlash
    then
        if cast.chaosStrike() then return end
    end
    -- Eye Beam
    -- eye_beam,if=talent.blind_fury.enabled&raid_event.adds.in>cooldown
    if cast.able.eyeBeam() and enemies.yards8r > 0 and not moving and talent.blindFury and (not talent.momentum or buff.momentum.exists())
        and (ttd(units.dyn8) > 2 or isDummy(units.dyn8))
        -- and ((getOptionValue("Eye Beam Usage") == 1 and mode.rotation == 1 and enemies.yards8r > 0)
        --     or (getOptionValue("Eye Beam Usage") == 2 and mode.rotation == 1 and enemies.yards8r >= getOptionValue("Units To AoE"))
        --     or (mode.rotation == 2 and enemies.yards8r > 0))
    then
        -- if cast.eyeBeam(units.dyn5) then return end
        if cast.eyeBeam(nil,"rect",1,8) then return end
    end
    -- Demon's Bite
    -- demons_bite
    if cast.able.demonsBite(units.dyn5) and not talent.demonBlades then
        if cast.demonsBite(units.dyn5) then return end
    end
    -- Fel Rush
    -- fel_rush,if=!talent.momentum.enabled&raid_event.movement.in>charges*10&talent.demon_blades.enabled
    if cast.able.felRush() and getFacing("player","target",10) and not talent.momentum and talent.demonBlades and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge") then
        if mode.mover == 1 and getDistance("target") < 8 then
            cancelRushAnimation()
        elseif not isChecked("Fel Rush Only In Melee") and (mode.mover == 2 or (getDistance("target") >= 8 and mode.mover ~= 3)) then
            if cast.felRush() then return end
        end
    end
    -- Felblade
    -- felblade,if=movement.distance|buff.out_of_range.up
    if cast.able.felblade() and getDistance("target") > 8 and not cast.last.vengefulRetreat() and getDistance("target") < 5 then
        if cast.felblade("target") then return end
    end
    -- Fel Rush
    -- fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum.enabled)
    if not isChecked("Fel Rush Only In Melee") and cast.able.felRush() and mode.mover ~= 3 and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge")
        and (getDistance("target") > 15 or (getDistance("target") > 8 and not talent.momentum))
    then
        if cast.felRush() then return end
    end
    -- Throw Glaive
    -- throw_glaive,if=talent.demon_blades.enabled
    if isChecked("Throw Glaive") and cast.able.throwGlaive() and talent.demonBlades then
        if cast.throwGlaive(nil,"aoe",1,10) then return end
    end
end -- End Action List - Normal

-- Action List - PreCombat
actionList.PreCombat = function()
    if not inCombat and not (IsFlying() or IsMounted()) then
        -- Flask / Crystal
        -- flask,type=flask_of_the_seventh_demon
        if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheSeventhDemon.exists() and canUse(item.flaskOfTheSeventhDemon) then
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if buff.gazeOfTheLegion.exists() then buff.gazeOfTheLegion.cancel() end
            if use.flaskOfTheSeventhDemon() then return end
        end
        if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and canUse(item.repurposedFelFocuser) then
            if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
            if buff.gazeOfTheLegion.exists() then buff.gazeOfTheLegion.cancel() end
            if use.repurposedFelFocuser() then return end
        end
        if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUse(item.oraliusWhisperingCrystal) then
            if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if buff.gazeOfTheLegion.exists() then buff.gazeOfTheLegion.cancel() end
            if use.oraliusWhisperingCrystal() then return end
        end
        if getOptionValue("Elixir") == 4 and not buff.gazeOfTheLegion.exists() and canUse(item.inquisitorsMenacingEye) then
            if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if use.inquisitorsMenacingEye() then return end
        end
        -- if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

        -- end -- End Pre-Pull
        if isValidUnit("target") then
            if GetUnitReaction("target","player") < 4 then
                -- Throw Glaive
                if isChecked("Throw Glaive") and cast.able.throwGlaive("target") and #enemies.get(10,"target",true) == 1 and solo and isChecked("Auto Engage") then
                    if cast.throwGlaive("target","aoe") then return end
                end
                -- Torment
                if cast.able.torment("target") and solo and isChecked("Auto Engage") then
                    if cast.torment("target") then return end
                end
            end
            -- Start Attack
            -- auto_attack
            if getDistance("target") < 5 then
                StartAttack()
            end
        end
    end -- End No Combat
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()

    ---------------
    --- Toggles ---
    ---------------
    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Defensive",0.25)
    UpdateToggle("Interrupt",0.25)
    UpdateToggle("Mover",0.25)
    br.player.mode.mover = br.data.settings[br.selectedSpec].toggles["Mover"]
    UpdateToggle("EyeBeam",0.25)
    br.player.mode.eyeBeam = br.data.settings[br.selectedSpec].toggles["EyeBeam"]
    UpdateToggle("FelBarrage",0.25)
    br.player.mode.felBarrage = br.data.settings[br.selectedSpec].toggles["FelBarrage"]

    ------------
    --- Vars ---
    ------------
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    combatTime                                    = getCombatTime()
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    hastar                                        = hastar or GetObjectExists("target")
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    equiped                                       = br.player.equiped
    falling, flying, moving                       = getFallTime(), IsFlying(), GetUnitSpeed("player")>0
    gcd                                           = br.player.gcdMax
    has                                           = br.player.has
    healPot                                       = getHealthPot()
    inCombat                                      = br.player.inCombat
    inRaid                                        = br.player.instance=="raid"
    item                                          = br.player.spell.items
    mode                                          = br.player.mode
    php                                           = br.player.health
    power, powerDeficit                           = br.player.power.fury.amount(), br.player.power.fury.deficit()
    pullTimer                                     = br.DBM:getPulltimer()
    solo                                          = #br.friend == 1
    spell                                         = br.player.spell
    talent                                        = br.player.talent
    ttd                                           = getTTD
    traits                                        = br.player.traits
    units                                         = br.player.units
    use                                           = br.player.use

    units.get(5)
    units.get(8)
    units.get(30)
    enemies.get(5)
    enemies.get(8)
    enemies.get(10)
    enemies.get(20)
    enemies.get(50)
    enemies.yards8r = getEnemiesInRect(10,20,false) or 0

    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end

    if (equiped.soulOfTheSlayer() or talent.firstBlood) then flood = 1 else flood = 0 end
    if isCastingSpell(spell.eyeBeam,"player") and buff.metamorphosis.exists() then 
        metaExtended = true 
    elseif not buff.metamorphosis.exists() then 
        metaExtended = false 
    end

    -- Blade Dance Variable
    -- variable,name=blade_dance,value=talent.first_blood.enabled|spell_targets.blade_dance1>=(3-talent.trail_of_ruin.enabled)
    bladeDanceVar = talent.firstBlood or ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Units To AoE")) or (mode.rotation == 2 and #enemies.yards8 > 0))
    -- Wait for Nemesis
    -- variable,name=waiting_for_nemesis,value=!(!talent.nemesis.enabled|cooldown.nemesis.ready|cooldown.nemesis.remains>target.time_to_die|cooldown.nemesis.remains>60)
    waitForNemesis = not (not talent.nemesis or cd.nemesis.remain() == 0 or cd.nemesis.remain() > ttd(units.dyn5) or cd.nemesis.remain() > 60)
    -- Pool for Meta Variable
    -- variable,name=pooling_for_meta,value=!talent.demonic.enabled&cooldown.metamorphosis.remains<6&fury.deficit>30&(!variable.waiting_for_nemesis|cooldown.nemesis.remains<10)
    poolForMeta = isChecked("Metamorphosis") and useCDs() and not talent.demonic and cd.metamorphosis.remain() < 6 
        and powerDeficit > 30 and (not waitForNemesis or cd.nemesis.remain() < 10)
    -- Pool for Blade Dance Variable
    -- variable,name=pooling_for_blade_dance,value=variable.blade_dance&(fury<75-talent.first_blood.enabled*20)
    poolForBladeDance = bladeDanceVar and power < 75 - flood * 20
    -- Pool for Eye Beam
    -- variable,name=pooling_for_eye_beam,value=talent.demonic.enabled&!talent.blind_fury.enabled&cooldown.eye_beam.remains<(gcd.max*2)&fury.deficit>20
    poolForEyeBeam = talent.demonic and not talent.blindFury and cd.eyeBeam.remain() < (gcd * 2) and powerDeficit > 20
    -- Wait for Dark Slash
    -- variable,name=waiting_for_dark_slash,value=talent.dark_slash.enabled&!variable.pooling_for_blade_dance&!variable.pooling_for_meta&cooldown.dark_slash.up
    waitForDarkSlash = talent.darkSlash and not poolForBladeDance and not poolForMeta and cd.darkSlash.remain() == 0
    -- Wiat for Momentum
    -- variable,name=waiting_for_momentum,value=talent.momentum.enabled&!buff.momentum.up
    waitForMomentum = talent.momentum and not buff.momentum.exists()

    -- Check for Eye Beam During Metamorphosis
    if talent.demonic and buff.metamorphosis.duration() > 10 and cast.last.eyeBeam() then metaEyeBeam = true end
    if metaEyeBeam == nil or (metaEyeBeam == true and not buff.metamorphosis.exists()) then metaEyeBeam = false end

    -- if mode.mover == 1 and cast.last.vengefulRetreat() then StopFalling(); end
    -- if IsHackEnabled("NoKnockback") then
    --     SetHackEnabled("NoKnockback", false)
    -- end
    -- Fell Rush Special
    if inCombat and isChecked("Auto Fel Rush After Retreat") and cast.able.felRush()
        and buff.prepared.exists() and not buff.momentum.exists() and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge")
    then
        if mode.mover == 1 and getDistance("target") < 8 then
            cancelRushAnimation()
        elseif not isChecked("Fel Rush Only In Melee") and (mode.mover == 2 or (getDistance("target") >= 8 and mode.mover ~= 3)) then
            if cast.felRush() then return end
        end
    end            

    -- ChatOverlay("Pools - Meta: "..tostring(poolForMeta)..", BD: "..tostring(poolForBladeDance)..", CS: "..tostring(poolForChaosStrike))

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not IsMounted() and not hastar and profileStop then
        profileStop = false
    elseif (inCombat and profileStop) or (IsMounted() or IsFlying()) or pause() or mode.rotation==4 or cast.active.eyeBeam() then
        return true
    else
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extras() then return end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.Defensive() then return end
        ------------------------------
        --- Out of Combat Rotation ---
        ------------------------------
        if actionList.PreCombat() then return end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if inCombat and not IsMounted() and not profileStop and isValidUnit("target") then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return end
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            if getOptionValue("APL Mode") == 1 then
                -- Start Attack
                if getDistance(units.dyn5) < 5 then
                    StartAttack()
                end
                -- Cooldowns
                -- call_action_list,name=cooldown,if=gcd.remains=0
                if cd.global.remain() == 0 then
                    if actionList.Cooldowns() then return end
                end
                -- Pickup Fragments
                -- pick_up_fragment,if=fury.deficit>=35
                if powerDeficit >= 35 then
                    ChatOverlay("Low Fury - Pickup Fragments!")
                end
                -- Call Action List - Dark Slash
                -- call_action_list,name=dark_slash,if=talent.dark_slash.enabled&(variable.waiting_for_dark_slash|debuff.dark_slash.up)
                if talent.darkSlash and (waitForDarkSlash or debuff.darkSlash.exists(units.dyn5)) then
                    if actionList.DarkSlash() then return end
                end
                -- Call Action List - Demonic
                -- run_action_list,name=demonic,if=talent.demonic.enabled
                if talent.demonic then
                    if actionList.Demonic() then return end
                else
                    -- Call Action List - Normal
                    -- run_action_list,name=normal
                    if actionList.Normal() then return end
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
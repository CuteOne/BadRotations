local rotationName = "Kuukuu"

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
        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.0")
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
            -- br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Auto Engage
            br.ui:createCheckbox(section, "Pull Spell")
            -- Torment
            br.ui:createCheckbox(section, "Torment")
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
            -- Augment
            br.ui:createCheckbox(section,"Augment")
            -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Greater Flask of The Currents","Flask of the Currents","None"}, 1, "|cffFFFFFFSet Elixir to use.")
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF001st Only","|cff00FF002nd Only","|cffFFFF00Both","|cffFF0000None"}, 1, "|cffFFFFFFSelect Trinket Usage.")
            -- Metamorphosis
            br.ui:createCheckbox(section,"Metamorphosis")
            -- Heart Essences
            br.ui:createCheckbox(section,"Use Essence")
            -- Azerite Beam Units
            br.ui:createSpinnerWithout(section, "Azerite Beam Units", 3, 1, 10, 1, "|cffFFBB00Number of Targets to use Azerite Beam on.")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00He  alth Percentage to use at.");
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
local debug
local essense
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
    if GetUnitSpeed("player") == 0 then
        MoveBackwardStart()
        JumpOrAscendStart()
        cast.felRush()
        MoveBackwardStop()
        AscendStop()
    end
    return
end
local function cancelRetreatAnimation()
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
    if isChecked("Glide") and not buff.glide.exists() then
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
            if canUseItem(5512) then
                useItem(5512)
            elseif canUseItem(129196) then --Legion Healthstone
                useItem(129196)
            elseif canUseItem(healPot) then
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
        if isChecked("Blur") and php <= getOptionValue("Blur") and inCombat then
            if cast.blur() then return end
        end
        -- Darkness
        if isChecked("Darkness") and php <= getOptionValue("Darkness") and inCombat then
            if cast.darkness() then return end
        end
        -- Chaos Nova
        if isChecked("Chaos Nova - HP") and not buff.metamorphosis.exists()
            and php <= getValue("Chaos Nova - HP") and inCombat and #enemies.yards5 > 0
        then
            if cast.chaosNova() then return end
        end
        if isChecked("Chaos Nova - AoE") and not buff.metamorphosis.exists()
            and #enemies.yards5 >= getValue("Chaos Nova - AoE")
        then
            if cast.chaosNova() then return end
        end
        -- Consume Magic
        -- if isChecked("Consume Magic") and cast.able.consumeMagic("target") and canDispel("target",spell.consumeMagic) and not isBoss() and GetObjectExists("target") then
        --    if cast.consumeMagic("target") then return end
			
		if isChecked("Consume Magic") then
            for i=1, #enemies.yards10 do
                thisUnit = enemies.yards10[i]
                if canDispel(thisUnit,spell.consumeMagic) and not isBoss() and GetObjectExists(thisUnit) then
                    if cast.consumeMagic(thisUnit) then return end
                end
            end
        --end
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
                if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                    if cast.felEruption(thisUnit) then return end
                end
            end 
        end
        -- Disrupt
        if isChecked("Disrupt") then
            for i=1, #enemies.yards10 do
                thisUnit = enemies.yards10[i]
                if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                    if cast.disrupt(thisUnit) then return end
                end
            end
        end
        -- Chaos Nova
        if isChecked("Chaos Nova") then
            for i=1, #enemies.yards5 do
                thisUnit = enemies.yards5[i]
                if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                    if cast.chaosNova(thisUnit) then return end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if useCDs() and getDistance("target") < 5 then
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
        if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or (br.player.race == "BloodElf" and powerDeficit >= 15)) then
            if cast.racial() then debug("Casting Racial") return end
        end
        -- Metamorphosis
        if isChecked("Metamorphosis") then
            -- metamorphosis,if=!(talent.demonic.enabled|variable.pooling_for_meta|variable.waiting_for_nemesis)|target.time_to_die<25
            if (not (talent.demonic or poolForMeta or waitForNemesis)) or ttd("target") < 25 then
                if cast.metamorphosis("player") then debug("Casting Metamorphosis") return end
            end
            -- metamorphosis,if=talent.demonic.enabled&(!azerite.chaotic_transformation.enabled|(cooldown.eye_beam.remains>20&(!variable.blade_dance|cooldown.blade_dance.remains>gcd.max)))
            if talent.demonic and (not traits.chaoticTransformation.active or ((cd.eyeBeam.remain() > 20 or mode.eyeBeam == 2) and (not bladeDanceVar or cd.bladeDance.remain() > gcd))) then
                if cast.metamorphosis("player") then debug("Casting Metamorphosis") return end
            end
        end
        -- Nemesis
        -- nemesis,target_if=min:target.time_to_die,if=raid_event.adds.exists&debuff.nemesis.down&(active_enemies>desired_targets|raid_event.adds.in>60)
        -- nemesis,if=!raid_event.adds.exists
        local lowestUnit = "target"
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
        -- Potion
        -- potion,if=buff.metamorphosis.remains>25|target.time_to_die<60
        if isChecked("Potion") and canUseItem(item.potionOfUnbridledFury) and inRaid then
            if buff.metamorphosis.remain() > 25 and ttd("target") >= 60 then
                use.potionOfUnbridledFury()
            end
        end
        -- Trinkets
        for i = 13, 14 do
            local opValue = getOptionValue("Trinkets")
            local iValue = i - 12
            if (opValue == iValue or opValue == 3) and use.able.slot(i) then
                -- actions.cooldown+=/use_item,name=galecallers_boon,if=!talent.fel_barrage.enabled|cooldown.fel_barrage.ready
                if equiped.galecallersBoon(i) and (not talent.felBarrage or cd.felBarrage.remain() <= gcd) then
                    use.slot(i)
                    debug("Using Gale Caller's Boon")
                    return
                -- actions.cooldown+=/use_item,effect_name=cyclotronic_blast,if=buff.metamorphosis.up&buff.memory_of_lucid_dreams.down&(!variable.blade_dance|!cooldown.blade_dance.ready)
                elseif (equiped.pocketSizedComputationDevice(i) and equiped.socket.pocketSizedComputationDevice(167672,1)) and buff.metamorphosis.exists("player")
                 and not buff.memoryOfLucidDreams.exists("player") and (not bladeDanceVar or cd.bladeDance.remain() > gcd) 
                then
                    use.slot(i)
                    debug("Using Cyclotronic Blast")
                    return
                -- actions.cooldown+=/use_item,name=ashvanes_razor_coral,if=debuff.razor_coral_debuff.down|(debuff.conductive_ink_debuff.up|buff.metamorphosis.remains>20)&target.health.pct<31|target.time_to_die<20
                elseif equiped.ashvanesRazorCoral(i) and (not debuff.razorCoral.exists("target") or ((equiped.dribblingInkpod() and debuff.conductiveInk.exists("target") and getHP("target") < 31)
                 or (buff.metamorphosis.remain("player") > 20 and debuff.razorCoral.stack() >= 15 and cd.eyeBeam.remain() > gcd)) or ttd("target") < 20)
                then
                    use.slot(i)
                    debug("Using Ashvane's Razor Coral")
                    return
                -- actions.cooldown+=/use_item,name=azsharas_font_of_power,if=cooldown.metamorphosis.remains<10|cooldown.metamorphosis.remains>60
                elseif equiped.azsharasFontOfPower(i) and (cd.metamorphosis.remain() < 10 or cd.metamorphosis.remain() > 60) and not UnitBuffID("player",296962) then
                    use.slot(i)
                end
            end
        end
        if buff.metamorphosis.exists("player") or not isChecked("Metamorphosis") then
            if (getOptionValue("Trinkets") == 1 or getOptionValue("Trinkets") == 3) and canUseItem(13) and not equiped.galecallersBoon(13) 
            and not (equiped.pocketSizedComputationDevice(13) and equiped.socket.pocketSizedComputationDevice(167672,1)) and not equiped.ashvanesRazorCoral(13)
            and not equiped.azsharasFontOfPower(13) then
                useItem(13)
            end
            if (getOptionValue("Trinkets") == 2 or getOptionValue("Trinkets") == 3) and canUseItem(14) and not equiped.galecallersBoon(14) 
            and not (equiped.pocketSizedComputationDevice(14) and equiped.socket.pocketSizedComputationDevice(167672,1)) and not equiped.ashvanesRazorCoral(14)
            and not equiped.azsharasFontOfPower(14) then
                useItem(14)
            end
        end
   end -- End useCDs check
    -- Heart Essences
    if isChecked("Use Essence") then
        -- Essence: Concentrated Flame
        -- concentrated_flame,if=(!dot.concentrated_flame_burn.ticking&!action.concentrated_flame.in_flight|full_recharge_time<gcd.max)
        if essence.concentratedFlame.active and cd.concentratedFlame.remain() <= gcd and (not debuff.concentratedFlame.exists("target") and not cast.last.concentratedFlame()
            or charges.concentratedFlame.timeTillFull() < gcd)
        then
            if cast.concentratedFlame() then debug("Casting Concentrated Flame") return end
        end
        -- Essence: Blood of the Enemy
        -- blood_of_the_enemy,if=buff.metamorphosis.up|target.time_to_die<=10
        if essence.bloodOfTheEnemy.active and cd.bloodOfTheEnemy.remain() <= gcd and useCDs() and (buff.metamorphosis.exists() or ttd("target") <= 10) then
            if cast.bloodOfTheEnemy() then debug("Casting Blood of the Enemy") return end
        end
        -- Essence: Guardian of Azeroth
        -- (buff.metamorphosis.up&cooldown.metamorphosis.ready)|buff.metamorphosis.remains>25|target.time_to_die<=30
        if useCDs() and ((buff.metamorphosis.exists("player") and cd.metamorphosis.remains() <= gcd) or buff.metamorphosis.remains() > 25 or ttd("target") <= 30) then
            if cast.guardianOfAzeroth() then debug("Casting Guardian of Azeroth") return end
        end
        -- Essence: Focused Azerite Beam
        -- focused_azerite_beam,if=spell_targets.blade_dance1>=2|raid_event.adds.in>60
        if essence.focusedAzeriteBeam.active and cd.focusedAzeriteBeam.remain() <= gcd and getFacing("player","target") and (getEnemiesInRect(2,25,isChecked("Show Drawings"),false) >= getOptionValue("Azerite Beam Units") or (useCDs() and (getEnemiesInRect(2,25,isChecked("Show Drawings"),false) >= 1 or (getDistance("target") < 6 and isBoss("target"))))) then
            if cast.focusedAzeriteBeam() then
                debug("Casting Focused Azerite Beam")
                return 
            end
        end
        -- Essence: Purifying Blast
        -- purifying_blast,if=spell_targets.blade_dance1>=2|raid_event.adds.in>60
        if (#enemies.yards8t >= 1 or useCDs()) then
            local minCount = useCDs() and 1 or 3
            if cast.purifyingBlast("best", nil, minCount, 40) then debug("Casting Purifying Blast") return true end
        end
        -- Essence: The Unbound Force
        -- the_unbound_force,if=buff.reckless_force.up|buff.reckless_force_counter.stack<10
        if (buff.recklessForce.exists() or buff.recklessForceCounter.stack() < 10) and useCDs() then
            if cast.theUnboundForce() then debug("Casting The Unbound Force") return true end
        end
        -- Essence: Ripple In Space
        -- ripple_in_space    
        if useCDs() then  
            if cast.rippleInSpace("target") then debug("Casting Ripple In Space") return true end
        end
        -- Essence: Worldvein Resonance
        -- worldvein_resonance,if=buff.lifeblood.stack<3
        if useCDs() and buff.lifeblood.stack() < 3 then
            if cast.worldveinResonance() then debug("Casting Worldvein Resonance") return end
        end
        -- Essence: Memory of Lucid Dreams
        -- memory_of_lucid_dreams,if=fury<40&buff.metamorphosis.up
        if useCDs() and buff.metamorphosis.exists() and power < 40 then
            if cast.memoryOfLucidDreams() then debug("Casting Memory of Lucid Dreams") return true end
        end
        --reaping_flames,if=target.health.pct>80|target.health.pct<=20|target.time_to_pct_20>30
        if essence.reapingFlames.active and cd.reapingFlames.remain() <= gcd then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                local thisHP = getHP(thisUnit)
                if ((essence.reapingFlames.rank >= 2 and thisHP > 80) or thisHP <= 20 or getTTD(thisUnit,20) > 30) and getFacing("player","target") then
                    if cast.reapingFlames(thisUnit) then debug("Casting Reaping Flames") return true end
                end
            end
        end
    end
end -- End Action List - Cooldowns

-- Action List - Dark Slash
actionList.DarkSlash = function()
    -- Dark Slash
    -- dark_slash,if=fury>=80&(!variable.blade_dance|!cooldown.blade_dance.ready)
    if power >= 80 and (not bladeDanceVar or cd.bladeDance.remain() > gcd) then
        if cast.darkSlash("target") then debug("Casting Dark Slash") return end
    end
    -- Annihilation
    -- annihilation,if=debuff.dark_slash.up
    if debuff.darkSlash.exists("target") and buff.metamorphosis.exists("player") then
        if cast.annihilation("target") then debug("Casting Annihilation") return end
    end
    -- Chaos Strike
    -- chaos_strike,if=debuff.dark_slash.up
    if debuff.darkSlash.exists("target") then
        if cast.chaosStrike("target") then debug("Casting Chaos Strike") return end
    end
end -- End Action List - Dark Slash

-- Action List - Demonic
actionList.Demonic = function()
    -- Death Sweep
    -- death_sweep,if=variable.blade_dance
    if getDistance("target") < 6 and buff.metamorphosis.exists("player") and bladeDanceVar then
        if cast.deathSweep("target","aoe",1,8) then debug("Casting Death Sweep") return end
    end
    -- Eye Beam
    -- eye_beam,if=raid_event.adds.up|raid_event.adds.in>25
    if mode.eyeBeam == 1 and not moving
        and ((getOptionValue("Eye Beam Usage") == 1 and mode.rotation == 1 and (getFacing("player","target") and enemies.yards8r > 0 or (getDistance("target") < 6 and isBoss("target"))))
            or (getOptionValue("Eye Beam Usage") == 2 and mode.rotation == 1 and enemies.yards8r >= getOptionValue("Units To AoE"))
            or (mode.rotation == 2 and (getFacing("player","target") and enemies.yards8r > 0 or (getDistance("target") < 6 and isBoss("target"))))) and (ttd("target") > 10 or isDummy("target"))
    then
        if cast.eyeBeam() then debug("Casting Eye Beam") return end
    end
    -- Fel Barrage
    -- fel_barrage,if=((!cooldown.eye_beam.up|buff.metamorphosis.up)&raid_event.adds.in>30)|active_enemies>desired_targets
    if talent.felBarrage and mode.felBarrage == 1 and (cd.eyeBeam.remain() > gcd or buff.metamorphosis.exists("player")) and ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Units To AoE"))
            or (mode.rotation == 2 and #enemies.yards8 > 0))
    then
        if cast.felBarrage("target","aoe",1,8) then debug("Casting Fel Barrage") return end
    end
    -- Blade Dance
    -- blade_dance,if=variable.blade_dance&!cooldown.metamorphosis.ready&(cooldown.eye_beam.remains>(5-azerite.revolving_blades.rank*3)|(raid_event.adds.in>cooldown&raid_event.adds.in<25))
    if bladeDanceVar and not buff.metamorphosis.exists("player") and #enemies.yards8 > 0 
        and ((cd.eyeBeam.remain() > (5 - traits.revolvingBlades.rank*3)) or mode.eyeBeam == 2)
    then
        if cast.bladeDance("target","aoe",1,20) then debug("Casting Blade Dance") return end
    end
    -- Immolation Aura
    -- immolation_aura
    if #enemies.yards8 > 0 then
        if cast.immolationAura("player","aoe",1,8) then debug("Casting Immolation Aura") return end
    end
    -- Annihilation
    -- annihilation,if=!variable.pooling_for_blade_dance
    if buff.metamorphosis.exists() and not poolForBladeDance then
        if cast.annihilation() then debug("Casting Annihilation") return end
    end
    -- Felblade
    -- felblade,if=fury.deficit>=40
    if powerDeficit >= 40 and getDistance("target") < 5 then
        if cast.felblade() then debug("Casting Fel Blade") return end
    end
    -- Chaos Strike
    -- chaos_strike,if=!variable.pooling_for_blade_dance&!variable.pooling_for_eye_beam
    if not poolForBladeDance and not poolForEyeBeam then
        if cast.chaosStrike() then debug("Casting Chaos Strike") return end
    end
    -- Fel Rush
    -- fel_rush,if=talent.demon_blades.enabled&!cooldown.eye_beam.ready&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
    if talent.demonBlades and getFacing("player","target") and charges.felRush.count() == 2 and cd.eyeBeam.remain() > gcd and br.timer:useTimer("Rush Delay", 2) and
        not isChecked("Fel Rush Only In Melee") and getDistance("target") >= 15 and getDistance("target") <= 30 and mode.mover ~= 3
    then
        if cast.felRush() then debug("Casting Fel Rush") return end
    end
    -- Demon's Bite
    -- demons_bite
    if not talent.demonBlades then
        if cast.demonsBite() then debug("Casting Demon's Bite") return end
    end
    -- Throw Glaive
    -- throw_glaive,if=buff.out_of_range.up
    if isChecked("Throw Glaive") and enemies.yards8f == 0 then
        if cast.throwGlaive(nil,"aoe",1,10) then debug("Casting Throw Glaive") return end
    end
    -- Fel Rush
    -- fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum.enabled)
    if getFacing("player","target") and getDistance("target") > 15 and getDistance("target") <= 30 and br.timer:useTimer("Rush Delay", 2) and not isChecked("Fel Rush Only In Melee") and mode.mover ~= 3
        and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge")
    then
        if cast.felRush() then debug("Casting Fel Rush") return end
    end
    -- Throw Glaive
    -- throw_glaive,if=talent.demon_blades.enabled
    if isChecked("Throw Glaive") and talent.demonBlades then
        if cast.throwGlaive(nil,"aoe",1,10) then debug("Casting Throw Glaive") return end
    end
end -- End Action List - Demonic

-- Action List - Normal
actionList.Normal = function()
    -- Vengeful Retreat
    -- vengeful_retreat,if=talent.momentum.enabled&buff.prepared.down&time>1
    if isChecked("Vengeful Retreat") and talent.momentum
        and not buff.prepared.exists() and combatTime > 1 and getDistance("target") < 5
    then
        if mode.mover == 1 then
            cancelRetreatAnimation()
        elseif mode.mover == 2 then
            if cast.vengefulRetreat() then debug("Casting Vengeful Retreat") return end
        end
    end
    -- Fel Rush
    -- fel_rush,if=(variable.waiting_for_momentum|talent.fel_mastery.enabled)&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
    if getFacing("player","target") and (waitForMomentum or talent.felMastery) and charges.felRush.count() == 2 and br.timer:useTimer("Rush Delay", 2)
    then
        if mode.mover == 1 and getDistance("target") < 8 then
            cancelRushAnimation()
        elseif not isChecked("Fel Rush Only In Melee") and getDistance("target") >= 15 and getDistance("target") <= 30 and mode.mover ~= 3 then
            if cast.felRush() then debug("Casting Fel Rush") return end
        end
    end
    -- Fel Barrage
    -- fel_barrage,if=!variable.waiting_for_momentum&(active_enemies>desired_targets|raid_event.adds.in>30)
    if talent.felBarrage and mode.felBarrage == 1 and not waitForMomentum and 
    ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Units To AoE")) or (mode.rotation == 2 and #enemies.yards8 > 0)) 
    then
        if cast.felBarrage("target","aoe",1,8) then debug("Casting Fel Barrage") return end
    end
    -- Death Sweep
    -- death_sweep,if=variable.blade_dance
    if #enemies.yards8 > 0 and buff.metamorphosis.exists() and bladeDanceVar then
        if cast.deathSweep("target","aoe",1,8) then debug("Casting Death Sweep") return end
    end
    -- Immolation Aura
    -- immolation_aura
    if #enemies.yards8 > 0 then
        if cast.immolationAura("player","aoe",1,8) then debug("Casting Immolation Aura") return end
    end
    -- Eye Beam
    -- eye_beam,if=active_enemies>1&(!raid_event.adds.exists|raid_event.adds.up)&!variable.waiting_for_momentum
    if not waitForMomentum and not moving and mode.eyeBeam == 1 and ((getOptionValue("Eye Beam Usage") == 1 and mode.rotation == 1 and (getFacing("player","target") and enemies.yards8r > 0 or (getDistance("target") < 6 and isBoss("target"))))
    or (getOptionValue("Eye Beam Usage") == 2 and mode.rotation == 1 and enemies.yards8r >= getOptionValue("Units To AoE"))
    or (mode.rotation == 2 and (getFacing("player","target") and enemies.yards8r > 0 or (getDistance("target") < 6 and isBoss("target"))))) and (ttd("target") > 10 or isDummy("target"))
    then
        if cast.eyeBeam(nil,"rect",1,20) then debug("Casting Eye Beam") return end
    end
    -- Blade Dance
    -- blade_dance,if=variable.blade_dance
    if #enemies.yards8 > 0 and not buff.metamorphosis.exists() and bladeDanceVar then
        if cast.bladeDance("target","aoe",1,8) then debug("Casting Blade Dance") return end
    end
    -- Felblade
    -- felblade,if=fury.deficit>=40
    if powerDeficit >= 40 and getDistance("target") < 5 then
        if cast.felblade() then debug("Casting Fel Blade") return end
    end
    -- Eye Beam
    -- eye_beam,if=!talent.blind_fury.enabled&!variable.waiting_for_dark_slash&raid_event.adds.in>cooldown
    if mode.eyeBeam == 1 and ((getOptionValue("Eye Beam Usage") == 1 and mode.rotation == 1 and (getFacing("player","target") and enemies.yards8r > 0 or (getDistance("target") < 6 and isBoss("target"))))
    or (getOptionValue("Eye Beam Usage") == 2 and mode.rotation == 1 and enemies.yards8r >= getOptionValue("Units To AoE"))
    or (mode.rotation == 2 and (getFacing("player","target") and enemies.yards8r > 0 or (getDistance("target") < 6 and isBoss("target"))))) and not moving and not talent.blindFury and not waitForDarkSlash and (ttd("target") > 2 or isDummy("target"))
    then
        if cast.eyeBeam(nil,"rect",1,20) then debug("Casting Eye Beam") return end
    end
    -- Annihilation
    -- annihilation,if=(talent.demon_blades.enabled|!variable.waiting_for_momentum|fury.deficit<30|buff.metamorphosis.remains<5)&!variable.pooling_for_blade_dance&!variable.waiting_for_dark_slash
    if buff.metamorphosis.exists() and (talent.demonBlades or not waitForMomentum or powerDeficit < 30 or buff.metamorphosis.remain() < 5)
        and not poolForBladeDance and not waitForDarkSlash
    then
        if cast.annihilation() then debug("Casting Annihilation") return end
    end
    -- Chaos Strike
    -- chaos_strike,if=(talent.demon_blades.enabled|!variable.waiting_for_momentum|fury.deficit<30)&!variable.pooling_for_meta&!variable.pooling_for_blade_dance&!variable.waiting_for_dark_slash
    if not buff.metamorphosis.exists() and (talent.demonBlades or not waitForMomentum or powerDeficit < 30)
        and not poolForMeta and not poolForBladeDance and not waitForDarkSlash
    then
        if cast.chaosStrike() then debug("Casting Chaos Strike") return end
    end
    -- Eye Beam
    -- eye_beam,if=talent.blind_fury.enabled&raid_event.adds.in>cooldown
    if mode.eyeBeam == 1 and ((getOptionValue("Eye Beam Usage") == 1 and mode.rotation == 1 and (getFacing("player","target") and enemies.yards8r > 0 or (getDistance("target") < 6 and isBoss("target"))))
    or (getOptionValue("Eye Beam Usage") == 2 and mode.rotation == 1 and enemies.yards8r >= getOptionValue("Units To AoE"))
    or (mode.rotation == 2 and (getFacing("player","target") and enemies.yards8r > 0 or (getDistance("target") < 6 and isBoss("target"))))) and not moving and talent.blindFury
    then
        if cast.eyeBeam(nil,"rect",1,8) then debug("Casting Eye Beam") return end
    end
    -- Demon's Bite
    -- demons_bite
    if not talent.demonBlades and powerDeficit > 30 then
        if cast.demonsBite() then debug("Casting Demon's Bite") return end
    end
    -- Fel Rush
    -- fel_rush,if=!talent.momentum.enabled&raid_event.movement.in>charges*10&talent.demon_blades.enabled
    if getFacing("player","target") and not talent.momentum and talent.demonBlades 
        and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge") and br.timer:useTimer("Rush Delay", 2)
    then
        if not isChecked("Fel Rush Only In Melee") and getDistance("target") >= 15 and getDistance("target") <= 30 and mode.mover ~= 3 then
            if cast.felRush() then debug("Casting Fel Rush") return end
        end
    end
    -- Felblade
    -- felblade,if=movement.distance|buff.out_of_range.up
    if enemies.yards8f == 0 then
        if cast.felblade("target") then debug("Casting Fel Blade") return end
    end
    -- Fel Rush
    -- fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum.enabled)
    if not talent.momentum and getFacing("player","target") and not isChecked("Fel Rush Only In Melee") and mode.mover ~= 3 and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge")
        and getDistance("target") > 15 and getDistance("target") <= 30 and br.timer:useTimer("Rush Delay", 2)
    then
        if cast.felRush() then debug("Casting Fel Rush") return end
    end
    -- Throw Glaive
    -- throw_glaive,if=talent.demon_blades.enabled
    if isChecked("Throw Glaive") and talent.demonBlades then
        if cast.throwGlaive(nil,"aoe",1,10) then debug("Casting Throw Glaive") return end
    end
end -- End Action List - Normal

-- Action List - PreCombat
actionList.PreCombat = function()
    if not inCombat and not (IsFlying() or IsMounted()) then
        if isChecked("Pre-Pull") then
            -- Flask / Crystal
            if ((pullTimer <= 5 and (not equiped.azsharasFontOfPower or not canUseItem(item.azsharasFontOfPower))) or (equiped.azsharasFontOfPower and canUseItem(item.azsharasFontOfPower) and pullTimer <= 9 and pullTimer > 5)) then
                if getOptionValue("Elixir") == 1 and inRaid and not buff.greaterFlaskOfTheCurrents.exists() and canUseItem(item.greaterFlaskOfTheCurrents) then
                    if use.greaterFlaskOfTheCurrents() then debug("Using Greater Flask of the Currents") return end
                elseif getOptionValue("Elixir") == 2 and inRaid and not buff.flaskOfTheCurrents.exists() and canUseItem(item.flaskOfTheCurrents) then
                    if use.greaterFlaskOfTheCurrents() then debug("Using Flask of the Currents") return end
                end
                -- augment
                if isChecked("Augment") and not buff.battleScarredAugmentRune.exists() and canUseItem(item.battleScarredAugmentRune) then
                    if use.battleScarredAugmentRune() then debug("Using Battle-Scarred Augment Rune") return end
                end
                -- potion
                if isChecked("Potion") and not buff.potionOfUnbridledFury.exists() and canUseItem(item.potionOfUnbridledFury) then
                    if use.potionOfUnbridledFury() then debug("Using Potion of Unbridled Fury") return end
                end
                if not traits.chaoticTransformation.active and isChecked("Metamorphosis") then
                    if cast.metamorphosis() then debug("Using Metamorphosis") return end
                end
            elseif equiped.azsharasFontOfPower and canUseItem(item.azsharasFontOfPower) and pullTimer <= 5 then
                if br.timer:useTimer("Font Delay", 4) then
                    debug("Using Font Of Azshara")
                    useItem(169314)
                end
            end
        end -- End Pre-Pull        
        if isValidUnit("target") then
            if GetUnitReaction("target","player") < 4 or isDummy("target") then
                -- Throw Glaive
                if isChecked("Throw Glaive") and #enemies.yards10t >= 1 and solo and isChecked("Pull Spell") then
                    if cast.throwGlaive("target","aoe") then return end
                end
                -- Torment
                if solo and isChecked("Torment") then
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
    debug                                         = br.addonDebug
    enemies                                       = br.player.enemies
    equiped                                       = br.player.equiped
    essence                                       = br.player.essence
    falling, flying, moving                       = getFallTime(), IsFlying(), GetUnitSpeed("player")>0
    gcd                                           = br.player.gcdMax
    has                                           = br.player.has
    healPot                                       = getHealthPot()
    inCombat                                      = br.player.inCombat
    inRaid                                        = br.player.instance=="raid"
    item                                          = br.player.items
    mode                                          = br.player.ui.mode
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
    enemies.get(10,"target") -- makes enemies.yards8t
    enemies.get(8,"player",false,true) -- makes enemies.yards8f
    enemies.get(8,"target") -- makes enemies.yards8t
    enemies.get(10)
    enemies.get(20)
    enemies.get(40)
    enemies.get(50)
    enemies.yards8r = getEnemiesInRect(2,20,isChecked("Show Drawings"),false)

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
    bladeDanceVar = talent.firstBlood or ((mode.rotation == 1 and ((not talent.trailOfRuin and #enemies.yards8t >= 2) or talent.trailOfRuin and #enemies.yards8t >= 1)) or (mode.rotation == 2 and #enemies.yards8t >= 0))
    -- Wait for Nemesis
    -- variable,name=waiting_for_nemesis,value=!(!talent.nemesis.enabled|cooldown.nemesis.ready|cooldown.nemesis.remains>target.time_to_die|cooldown.nemesis.remains>60)
    waitForNemesis = not (not talent.nemesis or cd.nemesis.remain() <= gcd or cd.nemesis.remain() > ttd("target") or cd.nemesis.remain() > 60)
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
    waitForDarkSlash = talent.darkSlash and not poolForBladeDance and not poolForMeta and cd.darkSlash.remain() <= gcd
    -- Wait for Momentum
    -- variable,name=waiting_for_momentum,value=talent.momentum.enabled&!buff.momentum.up
    waitForMomentum = talent.momentum and not buff.momentum.exists()

    -- Check for Eye Beam During Metamorphosis
    if talent.demonic and buff.metamorphosis.duration() > 10 and cast.last.eyeBeam() then metaEyeBeam = true end
    if metaEyeBeam == nil or (metaEyeBeam == true and not buff.metamorphosis.exists()) then metaEyeBeam = false end

    -- if mode.mover == 1 and cast.last.vengefulRetreat() then StopFalling(); end
    -- if IsHackEnabled("NoKnockback") then
    --     SetHackEnabled("NoKnockback", false)
    -- end
    -- Fel Rush Special
    if inCombat and isChecked("Auto Fel Rush After Retreat") 
        and buff.prepared.exists() and not buff.momentum.exists() and charges.felRush.count() > getOptionValue("Hold Fel Rush Charge") and br.timer:useTimer("Rush Delay", 2)
    then
        if mode.mover == 1 and getDistance("target") < 8 then
            cancelRushAnimation()
        elseif not isChecked("Fel Rush Only In Melee") and (mode.mover == 2 or (getDistance("target") >= 8 and mode.mover ~= 3)) then
            if cast.felRush() then return end
        end
    end
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not IsMounted() and not hastar and profileStop then
        profileStop = false
    elseif (inCombat and profileStop) or (IsMounted() or IsFlying()) or pause() or mode.rotation==4 or cast.active.eyeBeam() then
        return true
    else --if br.timer:useTimer("playerUpdate", getUpdateRate()) then
        if not inCombat and br.data.settings[br.selectedSpec]["Combat Time"] ~= 0 then br.data.settings[br.selectedSpec]["Combat Time"] = 0 end
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
        if inCombat and not IsMounted() and not profileStop then
            br.addonDebug(enemies.yards8r > 0, true)
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return end
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            if getOptionValue("APL Mode") == 1 or getOptionValue("APL Mode") == nil then
                -- Start Attack
                if getDistance("target") < 5 then
                    StartAttack()
                end
                -- Cooldowns
                -- call_action_list,name=cooldown,if=gcd.remains=0
                if cd.global.remain() <= gcd then
                    if actionList.Cooldowns() then return end
                end
                -- Call Action List - Dark Slash
                -- call_action_list,name=dark_slash,if=talent.dark_slash.enabled&(variable.waiting_for_dark_slash|debuff.dark_slash.up)
                if talent.darkSlash and (waitForDarkSlash or debuff.darkSlash.exists("target")) then
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
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

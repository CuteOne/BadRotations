------------------------------------------------------
-- Author = CuteOne
-- Patch = 10.0
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 100%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Full
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Raid
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
            -- br.ui:createSpinner(section, "M+ Pre-Pull",  3,  1,  10,  1,  "|cffFFFFFFSet to desired time to Meta Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
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
local buff
local cast
local cd
local charges
local conduit
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

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
        if ui.alwaysCdNever("Racial") and cast.able.racial() and (race == "Orc" or race == "Troll" or race == "BloodElf") then
            if cast.racial() then ui.debug("Casting Racial Ability") return true end
        end
        -- Metamorphosis
        if ui.alwaysCdAoENever("Metamorphosis",3,#enemies.yards8) and cast.able.metamorphosis("player") and #enemies.yards8 > 0 then
            -- metamorphosis,if=!talent.demonic&((!talent.chaotic_transformation|cooldown.eye_beam.remains>20)&active_enemies>desired_targets|raid_event.adds.in>60|fight_remains<25)
            -- metamorphosis,if=talent.demonic&(!talent.chaotic_transformation|cooldown.eye_beam.remains>20&(!variable.blade_dance|cooldown.blade_dance.remains>gcd.max)|fight_remains<25)
            if not talent.demonic and (not talent.chaoticTransformation or cd.eyeBeam.remains() > 20) then
                if cast.metamorphosis("player") then ui.debug("Casting Metamorphosis") return true end
            end
            if talent.demonic and (not talent.chaoticTransformation or cd.eyeBeam.remains() > 20 and (not var.bladeDance or cd.bladeDance.remain() > unit.gcd(true))) then
                if cast.metamorphosis("player") then ui.debug("Casting Metamorphosis [Demonic]") return true end
            end
        end
        -- Potion
        -- potion,if=buff.metamorphosis.remains>25|buff.metamorphosis.up&cooldown.metamorphosis.ready|fight_remains<60
        if ui.checked("Potion") and ui.useCDs() and use.able.potionOfUnbridledFury() and var.inRaid then
            if buff.metamorphosis.remain() > 25 and unit.ttd(units.dyn5) >= 60 then
                use.potionOfUnbridledFury()
                ui.debug("Unit Postiion of Unbridaled Fury")
                return
            end
        end
        -- Trinkets
        -- use_items,slots=trinket1,if=variable.trinket_sync_slot=1&(buff.metamorphosis.up|(!talent.demonic.enabled&cooldown.metamorphosis.remains>(fight_remains>?trinket.1.cooldown.duration%2))|fight_remains<=20)|(variable.trinket_sync_slot=2&!trinket.2.cooldown.ready)|!variable.trinket_sync_slot
        -- use_items,slots=trinket2,if=variable.trinket_sync_slot=2&(buff.metamorphosis.up|(!talent.demonic.enabled&cooldown.metamorphosis.remains>(fight_remains>?trinket.2.cooldown.duration%2))|fight_remains<=20)|(variable.trinket_sync_slot=1&!trinket.1.cooldown.ready)|!variable.trinket_sync_slot
        if buff.metamorphosis.exists() or not ui.alwaysCdAoENever("Metamorphosis",3,8) then
            module.BasicTrinkets()
        end
        -- The Hunt
        -- the_hunt,if=(!talent.momentum|!buff.momentum.up)
        if ui.alwaysCdAoENever("The Hunt",ui.value("Units to AoE"),#enemies.yards50r) and cast.able.theHunt() and (not talent.momentum or not buff.momentum.exists()) then
            if cast.theHunt() then ui.debug("Casting The Hunt") return true end
        end
        -- Elysian Decree
        -- elysian_decree,if=(active_enemies>desired_targets|raid_event.adds.in>30)
        if ui.alwaysCdAoENever("Elysian Decree",ui.value("Units to AoE"),#enemies.yards30) and cast.able.elysianDecree("best",nil,1,8) and unit.standingTime() > 2
            and ((ui.mode.rotation == 1 and #enemies.yards8 >= ui.value("Units To AoE")) or ui.mode.rotation == 2 or ui.useCDs())
        then
            if cast.elysianDecree("best",nil,1,8) then ui.debug("Casting Elysian Decree") return true end
        end
    end
end -- End Action List - Cooldowns

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
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Pull]") return true end
                end
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
    enemies.get(10,"target")
    enemies.get(10,"target",true)
    enemies.get(20)
    enemies.get(30)
    enemies.get(40)
    enemies.get(40,"player",false,true)
    enemies.get(50)
    enemies.rect.get(8,20,false)
    enemies.rect.get(3,23,false)
    enemies.rect.get(8,50,false)

    if cast.active.eyeBeam("player") and buff.metamorphosis.exists() then
        var.metaExtended = true
    elseif not buff.metamorphosis.exists() then
        var.metaExtended = false
    end

    -- Talent to Number
    var.cycleOfHatred = talent.cycleOfHatred and 1 or 0
    var.demonBlades = talent.demonBlades and 1 or 0
    var.furiousThrows = talent.furiousThrows and 1 or 0
    var.ruinedTrail = talent.trailOfRuin and 1 or 0
    var.meta = buff.metamorphosis.exists() and 1 or 0

    -- Blade Dance Variable
    -- variable,name=blade_dance,value=talent.first_blood|talent.trail_of_ruin|talent.chaos_theory&buff.chaos_theory.down|spell_targets.blade_dance1>1
    var.bladeDance = talent.firstBlood or talent.trailOfRuin or (talent.chaosTheory and not buff.chaosTheory.exists()) or #enemies.yards8 >= 1

    -- Pool for Blade Dance Variable
    -- variable,name=pooling_for_blade_dance,value=variable.blade_dance&fury<(75-talent.demon_blades*20)&cooldown.blade_dance.remains<gcd.max
    var.poolForBladeDance = var.bladeDance and fury < (75 - var.demonBlades * 20) and cd.bladeDance.remains() < unit.gcd(max) and not unit.isExplosive("target")

    -- Pool for Eye Beam
    -- variable,name=pooling_for_eye_beam,value=talent.demonic&!talent.blind_fury&cooldown.eye_beam.remains<(gcd.max*2)&fury.deficit>20
    var.poolForEyeBeam = talent.demonic and not talent.blindFury and cd.eyeBeam.remain() < (gcd * 2) and furyDeficit >= 20 and not unit.isExplosive("target")

    -- Wait for Momentum
    -- variable,name=waiting_for_momentum,value=talent.momentum&!buff.momentum.up
    var.waitingForMomentum = talent.momentum and not buff.momentum.exists()

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
                    if cast.able.autoAttack("target") then
                        if cast.autoAttack("target") then ui.debug("Casting Auto Attack") return true end
                    end
                end
                -- Cooldowns
                -- call_action_list,name=cooldown,if=gcd.remains=0
                if cd.global.remain() == 0 then
                    if actionList.Cooldowns() then return true end
                end
                -- Pickup Fragments
                -- pick_up_fragment,if=demon_soul_fragments>0
                -- pick_up_fragment,mode=nearest,if=talent.demonic_appetite&fury.deficit>=35&(!cooldown.eye_beam.ready|fury<30)
                -- if furyDeficit >= 35 then
                --     ui.chatOverlay("Low Fury - Pickup Fragments!")
                -- end
                -- Annihilation
                -- annihilation,if=buff.inner_demon.up&cooldown.metamorphosis.remains<=gcd*3
                if cast.able.annihilation() and buff.innerDemon.exists() and cd.metamorphosis.remains() <= unit.gcd() * 3 then
                    if cast.annihilation() then ui.debug("Casting Annihilation [Inner Demon]") return true end
                end
                -- Vengeful Retreat
                if ui.checked("Vengeful Retreat") and cast.able.vengefulRetreat() and ui.mode.mover ~= 3 then
                    -- vengeful_retreat,use_off_gcd=1,if=talent.initiative&talent.essence_break&time>1&(cooldown.essence_break.remains>15|cooldown.essence_break.remains<gcd.max&(!talent.demonic|buff.metamorphosis.up|cooldown.eye_beam.remains>15+(10*talent.cycle_of_hatred)))
                    if talent.initiative and talent.essenceBreak
                        and unit.combatTime() > 1 and (cd.essenceBreak.remains() > 15 or cd.essenceBreak.remains() < unit.gcd(true)
                        and (not talent.demonic or buff.metamorphosis.exists() or cd.eyeBeam.remains() > 15 + (10 * var.cycleOfHatred)))
                        and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5
                    then
                        -- if ui.mode.mover == 1 then
                        --     cancelRetreatAnimation()
                        -- elseif ui.mode.mover == 2 then
                            if cast.vengefulRetreat() then ui.debug("Casting Vengeful Retreat [Initiative/Essence Break]") return true end
                        -- end
                    end
                    -- vengeful_retreat,use_off_gcd=1,if=talent.initiative&!talent.essence_break&time>1&!buff.momentum.up
                    if talent.initiative and not talent.essenceBreak and unit.combatTime() > 1 and not buff.momentum.exists() then
                        -- if ui.mode.mover == 1 then
                        --     cancelRetreatAnimation()
                        -- elseif ui.mode.mover == 2 then
                            if cast.vengefulRetreat() then ui.debug("Casting Vengeful Retreat [Initiative]") return true end
                        -- end
                    end
                end
                -- Fel Rush
                -- fel_rush,if=(buff.unbound_chaos.up|variable.waiting_for_momentum&(!talent.unbound_chaos|!cooldown.immolation_aura.ready))&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
                if cast.able.felRush() and not unit.isExplosive("target") and #enemies.yards23r > 0
                    and ((buff.unboundChaos.exists() or (var.waitingForMomentum and (not talent.unboundChaos or cd.immolationAura.exists()))))
                    and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
                then
                    if ui.mode.mover == 1 and unit.distance("target") < 8 then
                        cancelRushAnimation("Casting Fel Rush [Momentum/Unbound Chaos]")
                        return true
                    end
                    if ui.mode.mover ~= 3 and (unit.distance("target") < 8 or (not ui.checked("Fel Rush Only In Melee") and unit.distance("target") >= 8)) then
                        if cast.felRush() then ui.debug("Casting Fel Rush [Momentum/Unbound Chaos]") return true end
                    end
                end
                -- Essence Break
                -- essence_break,if=(active_enemies>desired_targets|raid_event.adds.in>40)&!variable.waiting_for_momentum&fury>40&(cooldown.eye_beam.remains>8|buff.metamorphosis.up)&(!talent.tactical_retreat|buff.tactical_retreat.up)
                if cast.able.essenceBreak() and (not var.waitingForMomentum and fury > 40
                    and (cd.eyeBeam.remains() > 8 or buff.metamorphosis.exists())
                    and (not talent.tacticalRetreat or buff.tacticalRetreat.exists()))
                then
                    if cast.essenceBreak() then ui.debug("Casting Essence Break") return true end
                end
                -- Death Sweep
                -- death_sweep,if=variable.blade_dance&(!talent.essence_break|cooldown.essence_break.remains>(cooldown.death_sweep.duration-4))
                if cast.able.deathSweep("player","aoe",1,8) and not unit.isExplosive("target") and #enemies.yards8 > 0 and var.bladeDance
                    and (not talent.essenceBreak or cd.essenceBreak.remains() > (cd.deathSweep.duration() - 4))
                then
                    if cast.deathSweep("player","aoe",1,8) then ui.debug("Casting Death Sweep") return true end
                end
                -- Fel Barrage
                -- fel_barrage,if=active_enemies>desired_targets|raid_event.adds.in>30
                if ui.mode.felBarrage == 1 and not unit.isExplosive("target") and cast.able.felBarrage("player","aoe",1,8)
                    and ((ui.mode.rotation == 1 and #enemies.yards8 >= ui.value("Units To AoE")) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
                then
                    if cast.felBarrage("player","aoe",1,8) then ui.debug("Casting Fel Barrage") return true end
                end
                -- Glaive Tempest
                -- glaive_tempest,if=active_enemies>desired_targets|raid_event.adds.in>10
                if cast.able.glaiveTempest("player","aoe",1,8) and unit.standingTime() > 2
                    and ((ui.mode.rotation == 1 and #enemies.yards8 >= ui.value("Units To AoE")) or ui.mode.rotation == 2 or ui.useCDs() or unit.ttd(units.dyn5) >= 7)
                then
                    if cast.glaiveTempest("player","aoe",1,8) then ui.debug("Casting Glaive Tempest") return true end
                end
                -- Eye Beam
                -- eye_beam,if=active_enemies>desired_targets|raid_event.adds.in>(40-talent.cycle_of_hatred*15)&!debuff.essence_break.up
                if ui.mode.eyeBeam == 1 and not unit.isExplosive("target") and cast.able.eyeBeam("player","rect",1,20)
                    and #enemies.yards20r > 0 and not unit.moving() and (eyebeamTTD() or unit.isDummy(units.dyn8))
                    and debuff.essenceBreak.count() == 0
                then
                    if cast.eyeBeam("player","rect",1,20) then ui.debug("Casting Eye Beam") return true end
                end
                -- Blade Dance
                -- blade_dance,if=variable.blade_dance&(cooldown.eye_beam.remains>5|!talent.demonic|(raid_event.adds.in>cooldown&raid_event.adds.in<25))
                if cast.able.bladeDance("player","aoe",1,8) and not unit.isExplosive("target") and #enemies.yards8 > 0 and var.bladeDance
                    and (cd.eyeBeam.remains() > 5 or not talent.demonic)
                then
                    if cast.bladeDance("player","aoe",1,8) then ui.debug("Casting Blade Dance") return true end
                end
                -- Throw Glaive
                -- throw_glaive,if=talent.soulrend&(active_enemies>desired_targets|raid_event.adds.in>full_recharge_time+9)&spell_targets>=(2-talent.furious_throws)&!debuff.essence_break.up
                if ui.checked("Throw Glaive") and cast.able.throwGlaive() and talent.soulrend
                    and #enemies.yards10t >= (2 - var.furiousThrows) and debuff.essenceBreak.count() == 0
                then
                    if cast.throwGlaive() then ui.debug("Casting Throw Glaive [Soulrend]") return true end
                end
                -- Annihilation
                -- annihilation,if=!variable.pooling_for_blade_dance
                if cast.able.annihilation() and not var.poolForBladeDance then
                    if cast.annihilation() then ui.debug("Casting Annihilation") return true end
                end
                -- Throw Glaive
                -- throw_glaive,if=talent.serrated_glaive&cooldown.eye_beam.remains<4&!debuff.serrated_glaive.up&!debuff.essence_break.up
                if ui.checked("Throw Glaive") and cast.able.throwGlaive() and talent.serratedGlaive and cd.eyeBeam.remains() < 4 and debuff.essenceBreak.count() == 0 then
                    if cast.throwGlaive() then ui.debug("Casting Throw Glaive [Serrated Glaive]") return true end
                end
                -- Immolation Aura
                -- immolation_aura,if=!buff.immolation_aura.up&(!talent.ragefire|active_enemies>desired_targets|raid_event.adds.in>15)
                if cast.able.immolationAura() and not unit.isExplosive("target") and #enemies.yards8 > 0 and not buff.immolationAura.exists() then
                    if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura") return true end
                end
                -- Fel Rush
                -- fel_rush,if=talent.isolated_prey&active_enemies=1&fury.deficit>=35
                if cast.able.felRush() and not unit.isExplosive("target") and #enemies.yards23r == 1
                    and talent.isolatedPrey and furyDeficit >= 35
                    and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
                then
                    if ui.mode.mover == 1 and unit.distance("target") < 8 then
                        cancelRushAnimation("Casting Fel Rush [Isolated Prey]")
                        return true
                    end
                    if ui.mode.mover ~= 3 and (unit.distance("target") < 8 or (not ui.checked("Fel Rush Only In Melee") and unit.distance("target") >= 8)) then
                        if cast.felRush() then ui.debug("Casting Fel Rush [Isolated Prey]") return true end
                    end
                end
                -- Felblade
                -- felblade,if=fury.deficit>=40
                if cast.able.felblade() and furyDeficit >= 40 and not cast.last.vengefulRetreat() and unit.distance(units.dyn15) < 5 then
                    if cast.felblade() then ui.debug("Casting Felblade") return true end
                end
                -- Sigil of Flame
                -- sigil_of_flame,if=active_enemies>desired_targets
                if not unit.moving(units.dyn5) and #enemies.yards5 > 0 and #enemies.yards30 > ui.value("Units to AOE") then
                    if talent.preciseSigils and cast.able.sigilOfFlame(units.dyn30,"aoe",1,8) then
                        if cast.sigilOfFlame(units.dyn30,"aoe",1,8) then ui.debug("Casting Sigil of Flame") return true end
                    end
                    if talent.concentratedSigils and cast.able.sigilOfFlame("player","aoe",1,8) then
                        if cast.sigilOfFlame("player","aoe",1,8) then ui.debug("Casting Sigil of Flame") return true end
                    end
                    if cast.able.sigilOfFlame("best",false,1,8) and not talent.preciseSigils and not talent.concentratedSigils then
                        if cast.sigilOfFlame("best",false,1,8) then ui.debug("Casting Sigil of Flame") return true end
                    end
                end
                -- Chaos Strike
                -- chaos_strike,if=!variable.pooling_for_blade_dance&!variable.pooling_for_eye_beam
                if cast.able.chaosStrike() and not var.poolForBladeDance and not var.poolForEyeBeam then
                    if cast.chaosStrike() then ui.debug("Casting Chaos Strike") return true end
                end
                -- Fel Rush
                -- fel_rush,if=!talent.momentum&talent.demon_blades&!cooldown.eye_beam.ready&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
                if cast.able.felRush() and not unit.isExplosive("target") and #enemies.yards23r > 0
                    and not talent.momentum and talent.demonBlades and cd.eyeBeam.exists()
                    and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
                then
                    if ui.mode.mover == 1 and unit.distance("target") < 8 then
                        cancelRushAnimation("Casting Fel Rush [Demon Blades]")
                        return true
                    end
                    if ui.mode.mover ~= 3 and (unit.distance("target") < 8 or (not ui.checked("Fel Rush Only In Melee") and unit.distance("target") >= 8)) then
                        if cast.felRush() then ui.debug("Casting Fel Rush [Demon Blades]") return true end
                    end
                end
                -- Demon's Bite
                -- demons_bite,target_if=min:debuff.burning_wound.remains,if=talent.burning_wound&debuff.burning_wound.remains<4&active_dot.burning_wound<(spell_targets>?3)
                if cast.able.demonsBite(var.lowestBurningWound) and talent.burningWound and debuff.burningWound.remain(units.dyn5) < 4 then
                    if cast.demonsBite(var.lowestBurningWound) then ui.debug("Casting Demon's Bite [Burning Wound]") return true end
                end
                -- Fel Rush
                -- fel_rush,if=!talent.momentum&!talent.demon_blades&spell_targets>1&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
                if cast.able.felRush() and not unit.isExplosive("target") and #enemies.yards23r > 1
                    and not talent.momentum and not talent.demonBlades
                    and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
                then
                    if ui.mode.mover == 1 and unit.distance("target") < 8 then
                        cancelRushAnimation("Casting Fel Rush [AOE]")
                        return true
                    end
                    if ui.mode.mover ~= 3 and (unit.distance("target") < 8 or (not ui.checked("Fel Rush Only In Melee") and unit.distance("target") >= 8)) then
                        if cast.felRush() then ui.debug("Casting Fel Rush [AOE]") return true end
                    end
                end
                -- Sigil of Flame
                -- sigil_of_flame,if=raid_event.adds.in>15&fury.deficit>=30
                if not unit.moving(units.dyn5) and #enemies.yards5 > 0 and furyDeficit >= 30 then
                    if talent.preciseSigils and cast.able.sigilOfFlame(units.dyn30,"aoe",1,8) then
                        if cast.sigilOfFlame(units.dyn30,"aoe",1,8) then ui.debug("Casting Sigil of Flame") return true end
                    end
                    if talent.concentratedSigils and cast.able.sigilOfFlame("player","aoe",1,8) then
                        if cast.sigilOfFlame("player","aoe",1,8) then ui.debug("Casting Sigil of Flame") return true end
                    end
                    if cast.able.sigilOfFlame("best",false,1,8) and not talent.preciseSigils and not talent.concentratedSigils then
                        if cast.sigilOfFlame("best",false,1,8) then ui.debug("Casting Sigil of Flame") return true end
                    end
                end
                -- Demon's Bite
                -- demons_bite
                if cast.able.demonsBite(units.dyn5) then --and not talent.demonBlades and furyDeficit >= 30 then
                    if cast.demonsBite(units.dyn5) then ui.debug("Casting Demon's Bite") return true end
                end
                -- Fel Rush
                -- fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum)
                if not ui.checked("Fel Rush Only In Melee") and not unit.isExplosive("target") and cast.able.felRush()
                    and ui.mode.mover ~= 3 and charges.felRush.count() > ui.value("Hold Fel Rush Charge")
                    and (unit.distance("target") > 15 or (unit.distance("target") > 8 and not talent.momentum))
                then
                    if cast.felRush() then ui.debug("Casting Fel Rush [Out of Range]") return true end
                end
                -- Vengeful Retreat
                -- vengeful_retreat,if=!talent.initiative&movement.distance>15
                -- Throw Glaive
                -- throw_glaive,if=(talent.demon_blades|buff.out_of_range.up)&!debuff.essence_break.up
                if ui.checked("Throw Glaive") and cast.able.throwGlaive()
                    and (talent.demonBlades or unit.distance("target") > 15)
                    and debuff.essenceBreak.count() == 0
                then
                    if cast.throwGlaive() then ui.debug("Casting Throw Glaive [Demon Blades/Out of Range]") return true end
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

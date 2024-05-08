-------------------------------------------------------
-- Author = CuteOne
-- Patch = 10.2
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 100%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Limited
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
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spells.soulCleave},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spells.soulCleave},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spells.shear},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.spectralSight}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.metamorphosis},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spells.metamorphosis},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.metamorphosis}
    };
   	br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.demonSpikes},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.demonSpikes}
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
        [1] = { mode = "On", value = 2 , overlay = "Auto Movement Enabled", tip = "Will Cast Movement Abilities.", highlight = 1, icon = br.player.spells.infernalStrike},
        [2] = { mode = "Off", value = 1 , overlay = "Auto Movement Disabled", tip = "Will NOT Cast Movement Abilities", highlight = 0, icon = br.player.spells.infernalStrike}
    };
    br.ui:createToggle(MoverModes,"Mover",5,0)
    -- Tankbuster Modes
    local TankbusterModes = {
        [1] = {mode = "On", value = 1, overlay = "M+ Tankbuster Enabled", tip = "Will use Demon Spikes to Mitigate Tank Busters", highlight = 1, icon = br.player.spells.demonSpikes},
        [2] = {mode = "Off", value = 2, overlay = "M+ Tankbuster Disabled", tip = "Will NOT use Demon Spikes to Mitigate Tank Busters", highlight = 0, icon = br.player.spells.demonSpikes}
    }
    br.ui:createToggle(TankbusterModes,"Tankbuster", 6, 0)
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
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Auto Engage
            br.ui:createCheckbox(section, "Auto Engage")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Fel Devastation
            br.ui:createDropdownWithout(section, "Fel Devastation",alwaysCdNever, 1, "|cffFFFFFFWhen to use Fel Devastation")
            -- Immolation Aura
            br.ui:createCheckbox(section,"Immolation Aura")
            -- Sigil of Chains
            br.ui:createCheckbox(section,"Sigil of Chains - Filler")
            -- Sigil of Flame
            br.ui:createCheckbox(section,"Sigil of Flame")
            -- Sigil of Misery
            br.ui:createCheckbox(section,"Sigil of Misery - Filler")
            -- Sigil of Silence
            br.ui:createCheckbox(section,"Sigil of Silence - Filler")
            -- Torment
            br.ui:createCheckbox(section,"Torment")
            -- Throw Glaive
            br.ui:createCheckbox(section,"Throw Glaive")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Augment Rune
            br.ui:createCheckbox(section,"Augment Rune")
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- Basic Flask Module
            br.player.module.FlaskUp("Strength",section)
            -- Basic Trinkets
            br.player.module.BasicTrinkets(nil,section)
            -- Soul Carver
            br.ui:createDropdownWithout(section, "Soul Carver", alwaysCdNever, 1, "|cffFFFFFFWhen to use Soul Carver")
            -- The Hunt
            br.ui:createDropdownWithout(section, "The Hunt", alwaysCdAoENever, 1, "|cffFFFFFFWhen to use The Hunt")
            -- Elysian Decree
            br.ui:createDropdownWithout(section, "Elysian Decree", alwaysCdAoENever, 1, "|cffFFFFFFWhen to use Elysian Decree")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            br.ui:createSpinnerWithout(section, "PoS removes Necrotic", 20, 0, 50, 1, "","|cffFFFFFFNecrotic stacks Phial of Serenity to use at")
		    -- Fiery Brand
            br.ui:createSpinner(section, "Fiery Brand",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Demon Spikes
            br.ui:createSpinner(section, "Demon Spikes",  90,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            br.ui:createSpinnerWithout(section, "Hold Demon Spikes", 1, 0, 2, 1, "|cffFFBB00Number of Demon Spikes the bot will hold for manual use.");
            -- Metamorphosis
            br.ui:createSpinner(section, "Metamorphosis",  40,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Sigil of Chains
            br.ui:createSpinner(section, "Sigil of Chains - HP",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            br.ui:createSpinner(section, "Sigil of Chains - AoE", 3, 0, 10, 1, "|cffFFFFFFNumber of Units in 8 Yards to Cast At")
            -- Sigil of Misery
            br.ui:createSpinner(section, "Sigil of Misery - HP",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            br.ui:createSpinner(section, "Sigil of Misery - AoE", 3, 0, 10, 1, "|cffFFFFFFNumber of Units in 8 Yards to Cast At")
            -- Soul Barrier
            br.ui:createSpinner(section, "Soul Barrier",  70,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Consume Magic
            br.ui:createCheckbox(section, "Disrupt")
            -- Imprison
            br.ui:createCheckbox(section, "Imprison")
            -- Sigil of Silence
            br.ui:createCheckbox(section, "Sigil of Silence")
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
        -- Tankbuster Toggle
            br.ui:createDropdownWithout(section, "Tankbuster Mode", br.dropOptions.Toggle, 6)
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
-- BR API
local actionList = {}
local buff
local cast
local casting
local cd
local charges
local debuff
local enemies
local fury
local module
local talent
local ui
local unit
local units
local use
local var

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
actionList.Extras = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Torment
    if ui.checked("Torment") and cast.able.torment() then
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if not unit.isTanking(thisUnit) and unit.threat(thisUnit) and not unit.isExplosive(thisUnit) then
                if cast.torment(thisUnit) then ui.debug("Casting Torment [Not Tanking]") return true end
            end
        end
    end
    -- Throw Glaive Aggro
    if ui.checked("Throw Glaive") and cast.able.throwGlaive() then
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if not unit.isTanking(thisUnit) and unit.threat(thisUnit) and not unit.isExplosive(thisUnit) then
                if cast.throwGlaive(thisUnit) then ui.debug("Casting Throw Glaive [Not Tanking]") return true end
            end
        end
    end
    --Tank buster
    if ui.mode.tankbuster == 1 and unit.inCombat() then
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if br._G.UnitThreatSituation("player", thisUnit) == 3 and br._G.UnitCastingInfo("target") then
                if br.lists.tankBuster[select(9, br._G.UnitCastingInfo("target"))] ~= nil then
                    if cd.demonSpikes.ready() and not debuff.fieryBrand.exists(thisUnit) then
                        if cast.demonSpikes() then
                            br.addonDebug("[TANKBUST] Demon Spike")
                            return true
                        end
                    end
                    if cast.able.fieryBrand() and not buff.demonSpikes.exists() then
                        if cast.fieryBrand(thisUnit) then
                            br.addonDebug("[TANKBUST] Fiery Brand")
                            return true
                        end
                    end
                end
            end
        end
    end  -- End Tankbuster
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Soul Barrier
        if ui.checked("Soul Barrier") and unit.inCombat() and cast.able.soulBarrier() and unit.hp() < ui.value("Soul Barrier") then
            if cast.soulBarrier() then ui.debug("Casting Soul Barrier") return true end
        end
        -- Demon Spikes
        -- demon_spikes
        if ui.checked("Demon Spikes") and unit.inCombat() and cast.able.demonSpikes() and charges.demonSpikes.count() > ui.value("Hold Demon Spikes") and unit.hp() <= ui.value("Demon Spikes") then
            -- if (charges.demonSpikes.count() == 2 or not buff.demonSpikes.exists()) and not debuff.fieryBrand.exists(units.dyn5) and not buff.metamorphosis.exists() then
                if cast.demonSpikes() then ui.debug("Casting Demon Spikes") return true end
            -- end
        end
        -- Metamorphosis
        -- metamorphosis,if=!buff.metamorphosis.up&(!covenant.venthyr.enabled|!dot.sinful_brand.ticking)|target.time_to_die<15
        if ui.checked("Metamorphosis") and unit.inCombat() and cast.able.metamorphosis() and not buff.demonSpikes.exists()
            and not debuff.fieryBrand.exists(units.dyn5) and not buff.metamorphosis.exists() and unit.hp() <= ui.value("Metamorphosis")
            -- and not talent.demonic and (not covenant.venthyr.enabled or debuff.sinfulBrand.exists(units.dyn5))
        then
            if cast.metamorphosis() then ui.debug("Casting Metamorphosis") return true end
        end
        -- Fiery Brand
        -- fiery_brand
        if ui.checked("Fiery Brand") and unit.inCombat() and unit.hp() <= ui.value("Fiery Brand") then
            if not buff.demonSpikes.exists() and not buff.metamorphosis.exists() then
                if cast.fieryBrand() then ui.debug("Casting Fiery Brand") return true end
            end
        end
        -- Basic Healing Module
        module.BasicHealing()
        if ui.checked("PoS removes Necrotic") and unit.instance() and debuff.necroticWound.stacks() >= ui.value("PoS removes Necrotic") and use.able.phialOfSerenity() then
            if use.phialOfSerenity() then return true end
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
        -- Sigil of Chains
        if ui.checked("Sigil of Chains - HP") and cast.able.sigilOfChains()
            and unit.hp() <= ui.value("Sigil of Chains - HP") and unit.inCombat() and #enemies.yards8 > 0
        then
            if cast.sigilOfChains("player","ground") then ui.debug("Casting Sigil of Chains [HP]") return true end
        end
        if ui.checked("Sigil of Chains - AoE") and cast.able.sigilOfChains()
            and #enemies.yards8 >= ui.value("Sigil of Chains - AoE") and unit.inCombat()
        then
            if cast.sigilOfChains("best",false,ui.value("Sigil of Chains - AoE"),8) then ui.debug("Casting Sigil of Chains [AOE]") return true end
        end
    end -- End Defensive Toggle
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        for i=1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                -- Disrupt
                if ui.checked("Disrupt") and cast.able.disrupt(thisUnit) and unit.distance(thisUnit) < 20 then
                    if cast.disrupt(thisUnit) then ui.debug("Casting Disrupt") return true end
                end
                -- Imprison
                if ui.checked("Imprison") and cast.able.imprison(thisUnit) and unit.distance(thisUnit) < 20 then
                    if cast.imprison(thisUnit) then ui.debug("Casting Imprison") return true end
                end
                -- Sigil of Silence
                if ui.checked("Sigil of Silence") and cast.able.sigilOfSilence(thisUnit) and cd.disrupt.remain() > 0 then
                    if cast.sigilOfSilence(thisUnit,"ground",1,8) then ui.debug("Casting Sigil of Silence") return true end
                end
                -- Sigil of Misery
                if ui.checked("Sigil of Misery") and cast.able.sigilOfMisery(thisUnit)
                    and cd.disrupt.remain() > 0 and cd.sigilOfSilence.remain() > 0 and cd.sigilOfSilence.remain() < 45
                then
                    if cast.sigilOfMisery(thisUnit,"ground",1,8) then ui.debug("Casting Sigil of Misery [Interrupt]") return true end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Precombat
actionList.Precombat = function()
    if not unit.inCombat() then
        -- Module - Flask Up
        -- flask
        module.FlaskUp("Strength")
        -- Battle Scarred Augment Rune
        -- augmentation
        if ui.checked("Augment Rune") and var.inRaid and not buff.battleScarredAugmentation.exists()
            and use.able.augmentation() and var.lastRune + unit.gcd(true) < var.getTime()
        then
            if use.augmentation() then ui.debug("Using Augment Rune") var.lastRune = var.getTime() return true end
        end
        -- Pre-Pull
        if ui.checked("Pre-Pull Timer") and ui.pullTimer()<= ui.value("Pre-Pull Timer") then
            -- Potion
            -- potion
            if ui.value("Potion") ~= 5 and ui.pullTimer()<= 1 and (var.inRaid or var.inInstance) then
                if ui.value("Potion") == 1 and use.able.potionOfUnbridledFury() then
                    use.potionOfUnbridledFury()
                    ui.debug("Using Potion of Unbridled Fury")
                end
            end
        end -- End Pre-Pull
        -- Pull
        if unit.valid("target") then
            if unit.reaction("target","player") < 4 then
                -- Sigil Of Flame
                -- sigil_of_flame
                if ui.checked("Sigil of Flame") and cast.able.sigilOfFlame("best",nil,1,8) then
                    if cast.sigilOfFlame("best",nil,1,8) then ui.debug("Casting Sigil of Flame [Precombat]") return true end
                end
                -- Immolation Aura
                -- immolation_aura
                if ui.checked("Immolation Aura") and cast.able.immolationAura("player","aoe",1,8) then
                    if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura [Precombat]") return true end
                end
                -- Throw Glaive
                if ui.checked("Throw Glaive") and cast.able.throwGlaive("target","aoe") and #enemies.get(10,"target",true) == 1 and ui.checked("Auto Engage") then
                    if cast.throwGlaive("target","aoe") then ui.debug("Casting Throw Glaive [Pre-Pull]") return true end
                end
                -- Torment
                if ui.checked("Torment") and cast.able.torment("target") and ui.checked("Auto Engage") then
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
        end -- End Pull
    end -- End No Combat
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    -- Variable - Fd Ready
    -- variable,name=fd_ready,value=talent.fiery_brand&talent.fiery_demise&active_dot.fiery_brand>0
    var.fdReady = talent.fieryBrand and talent.fieryDemise and debuff.fieryBrand.count(units.dyn5)>0

    -- Variable - Dont Cleave
    -- variable,name=dont_cleave,value=(cooldown.fel_devastation.remains<=(action.soul_cleave.execute_time+gcd.remains))&fury<80
    var.dontCleave = (cd.felDevastation.remains()<=(cast.time.soulCleave()+unit.gcd())) and fury()<80

    -- Variable - Single Target
    -- variable,name=single_target,value=spell_targets.spirit_bomb=1
    var.singleTarget = #enemies.yards8==1

    -- Variable - Small Aoe
    -- variable,name=small_aoe,value=spell_targets.spirit_bomb>=2&spell_targets.spirit_bomb<=5
    var.smallAoe = #enemies.yards8>=2 and #enemies.yards8<=5

    -- Variable - Big Aoe
    -- variable,name=big_aoe,value=spell_targets.spirit_bomb>=6
    var.bigAoe = #enemies.yards8>=6

    -- Variable - Can Spb,Op=Setif,Condition=Variable.Fd Ready,Value=(Variable.Single Target&Soul Fragments>=5)|(Variable.Small Aoe&Soul Fragments>=4)|(Variable.Big Aoe&Soul Fragments>=3),Value Else=(Variable.Small Aoe&Soul Fragments>=5)|(Variable.Big Aoe&Soul Fragments>=4)
    -- variable,name=can_spb,op=setif,condition=variable.fd_ready,value=(variable.single_target&soul_fragments>=5)|(variable.small_aoe&soul_fragments>=4)|(variable.big_aoe&soul_fragments>=3),value_else=(variable.small_aoe&soul_fragments>=5)|(variable.big_aoe&soul_fragments>=4)
    if var.fdReady then
        var.canSpb = (var.SingleTarget and buff.soulFragments.stack()>=5) or (var.SmallAoe and buff.soulFragments.stack()>=4) or (var.BigAoe and buff.soulFragments.stack()>=3)
    else
        var.canSpb = (var.SmallAoe and buff.soulFragments.stack()>=5) or (var.BigAoe and buff.soulFragments.stack()>=4)
    end

    -- Auto Attack
    -- auto_attack
    if cast.able.autoAttack() then
        if cast.autoAttack() then ui.debug("Casting Auto Attack [Combat]") return true end
    end

    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
    if actionList.Interrupts() then return true end

    -- Infernal Strike
    -- infernal_strike,use_off_gcd=1
    if ui.mode.mover == 1 and cast.able.infernalStrike("player","ground",1,6) then
        if cast.infernalStrike("player","ground",1,6) then ui.debug("Casting Infernal Strike [Combat]") return true end
    end

    -- Demon Spikes
    -- demon_spikes,use_off_gcd=1,if=!buff.demon_spikes.up&!cooldown.pause_action.remains
    if cast.able.demonSpikes() and not buff.demonSpikes.exists() then
        if cast.demonSpikes() then ui.debug("Casting Demon Spikes [Combat]") return true end
    end

    -- Metamorphosis
    -- metamorphosis,use_off_gcd=1,if=!buff.metamorphosis.up
    if ui.checked("Metamorphosis") and unit.inCombat() and unit.hp() <= ui.value("Metamorphosis") and cast.able.metamorphosis() and not buff.metamorphosis.exists() then
        if cast.metamorphosis() then ui.debug("Casting Metamorphosis [Combat]") return true end
    end

    -- -- Use Item - Use Off Gcd=1
    -- -- potion,use_off_gcd=1
    -- if use.able.potion() then
    --     if use.potion() then ui.debug("Using Potion [Combat]") return true end
    -- end

    -- -- Call Action List - Externals
    -- -- call_action_list,name=externals
    -- if actionList.Externals() then return true end

    -- Module - Basic Trinkets
    -- use_items,use_off_gcd=1
    module.BasicTrinkets()

    -- Call Action List - Fiery Demise
    -- call_action_list,name=fiery_demise,if=talent.fiery_brand&talent.fiery_demise&active_dot.fiery_brand>0
    if talent.fieryBrand and talent.fieryDemise and debuff.fieryBrand.count(units.dyn5)>0 then
        if actionList.FieryDemise() then return true end
    end

    -- Call Action List - Maintenance
    -- call_action_list,name=maintenance
    if actionList.Maintenance() then return true end

    -- Call Action List - Single Target
    -- run_action_list,name=single_target,if=variable.single_target
    if var.singleTarget then
        if actionList.SingleTarget() then return true end
    end

    -- Call Action List - Small Aoe
    -- run_action_list,name=small_aoe,if=variable.small_aoe
    if var.smallAoe then
        if actionList.SmallAoe() then return true end
    end

    -- Call Action List - Big Aoe
    -- run_action_list,name=big_aoe,if=variable.big_aoe
    if var.bigAoe then
        if actionList.BigAoe() then return true end
    end

end -- End Action List - Combat

-- Action List - BigAoe
actionList.BigAoe = function()
    -- Fel Devastation
    -- fel_devastation,if=talent.collective_anguish|talent.stoke_the_flames
    if ui.alwaysCdNever("Fel Devastation") and cast.able.felDevastation("player","cone",1,8) and ((talent.collectiveAnguish or talent.stokeTheFlames)) then
        if cast.felDevastation("player","cone",1,8) then ui.debug("Casting Fel Devastation - Collective Anguish | Stoke the Flames [Big Aoe]") return true end
    end

    -- The Hunt
    -- the_hunt
    if ui.alwaysCdAoENever("The Hunt",ui.value("Units to AoE"),#enemies.yards50r) and cast.able.theHunt() then
        if cast.theHunt() then ui.debug("Casting The Hunt [Big Aoe]") return true end
    end

    -- Elysian Decree
    -- elysian_decree,line_cd=1.85,if=fury>=40&(soul_fragments.total<=1|soul_fragments.total>=4)
    if ui.alwaysCdAoENever("Elysian Decree",ui.value("Units to AoE"),#enemies.yards30) and cast.able.elysianDecree("best",nil,1,8) and unit.standingTime() > 2
        and ((ui.delay("ElysianDecree0",1) and (fury()>=40 and (buff.soulFragments.stack()<=1 or buff.soulFragments.stack()>=4))))
    then
        if cast.elysianDecree("best",nil,1,8) then ui.debug("Casting Elysian Decree [Big Aoe]") return true end
    end

    -- Fel Devastation
    -- fel_devastation
    if ui.alwaysCdNever("Fel Devastation") and cast.able.felDevastation("player","cone",1,8) then
        if cast.felDevastation("player","cone",1,8) then ui.debug("Casting Fel Devastation [Big Aoe]") return true end
    end

    -- Soul Carver
    -- soul_carver,if=soul_fragments.total<3
    if ui.alwaysCdNever("Soul Carver") and cast.able.soulCarver() and buff.soulFragments.stack()<3 then
        if cast.soulCarver() then ui.debug("Casting Soul Carver [Big Aoe]") return true end
    end

    -- Spirit Bomb
    -- spirit_bomb,if=soul_fragments>=4
    if cast.able.spiritBomb() and buff.soulFragments.stack()>=4 then
        if cast.spiritBomb() then ui.debug("Casting Spirit Bomb [Big Aoe]") return true end
    end

    -- Fracture
    -- fracture
    if cast.able.fracture() then
        if cast.fracture() then ui.debug("Casting Fracture [Big Aoe]") return true end
    end

    -- Shear
    -- shear
    if cast.able.shear() then
        if cast.shear() then ui.debug("Casting Shear [Big Aoe]") return true end
    end

    -- Soul Cleave
    -- soul_cleave,if=!variable.dont_cleave
    if cast.able.soulCleave() and not var.dontCleave then
        if cast.soulCleave() then ui.debug("Casting Soul Cleave [Big Aoe]") return true end
    end

    -- Call Action List - Filler
    -- call_action_list,name=filler
    if actionList.Filler() then return true end
end -- End Action List - BigAoe

-- Action List - FieryDemise
actionList.FieryDemise = function()
    -- Immolation Aura
    -- immolation_aura
    if ui.checked("Immolation Aura") and cast.able.immolationAura("player","aoe",1,8) then
        if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura [Fiery Demise]") return true end
    end

    -- Sigil Of Flame
    -- sigil_of_flame,if=talent.ascending_flame|active_dot.sigil_of_flame=0
    if ui.checked("Sigil of Flame") and cast.able.sigilOfFlame("best",nil,1,8) and ((talent.ascendingFlame or debuff.sigilOfFlame.count(units.dyn30AoE)==0)) then
        if cast.sigilOfFlame("best",nil,1,8) then ui.debug("Casting Sigil Of Flame [Fiery Demise]") return true end
    end

    -- Felblade
    -- felblade,if=(cooldown.fel_devastation.remains<=(execute_time+gcd.remains))&fury<50
    if cast.able.felblade() and (cd.felDevastation.remains()<=(unit.ttd(units.dyn5)+unit.gcd())) and fury()<50 then
        if cast.felblade() then ui.debug("Casting Felblade [Fiery Demise]") return true end
    end

    -- Fel Devastation
    -- fel_devastation
    if ui.alwaysCdNever("Fel Devastation") and cast.able.felDevastation("player","cone",1,8) then
        if cast.felDevastation("player","cone",1,8) then ui.debug("Casting Fel Devastation [Fiery Demise]") return true end
    end

    -- Soul Carver
    -- soul_carver,if=soul_fragments.total<3
    if ui.alwaysCdNever("Soul Carver") and cast.able.soulCarver() and buff.soulFragments.stack()<3 then
        if cast.soulCarver() then ui.debug("Casting Soul Carver [Fiery Demise]") return true end
    end

    -- The Hunt
    -- the_hunt
    if ui.alwaysCdAoENever("The Hunt",ui.value("Units to AoE"),#enemies.yards50r) and cast.able.theHunt() then
        if cast.theHunt() then ui.debug("Casting The Hunt [Fiery Demise]") return true end
    end

    -- Elysian Decree
    -- elysian_decree,line_cd=1.85,if=fury>=40
    if ui.alwaysCdAoENever("Elysian Decree",ui.value("Units to AoE"),#enemies.yards30) and cast.able.elysianDecree("best",nil,1,8) and unit.standingTime() > 2
        and ui.delay("ElysianDecree1",1) and fury()>=40
    then
        if cast.elysianDecree("best",nil,1,8) then ui.debug("Casting Elysian Decree [Fiery Demise]") return true end
    end

    -- Spirit Bomb
    -- spirit_bomb,if=variable.can_spb
    if cast.able.spiritBomb() and var.canSpb then
        if cast.spiritBomb() then ui.debug("Casting Spirit Bomb [Fiery Demise]") return true end
    end

end -- End Action List - FieryDemise

-- Action List - Filler
actionList.Filler = function()
    -- Sigil Of Chains
    -- sigil_of_chains,if=talent.cycle_of_binding&talent.sigil_of_chains
    if ui.checked("Sigil of Chains - Filler") and cast.able.sigilOfChains() and talent.cycleOfBinding and talent.sigilOfChains then
        if cast.sigilOfChains() then ui.debug("Casting Sigil Of Chains [Filler]") return true end
    end

    -- Sigil Of Misery
    -- sigil_of_misery,if=talent.cycle_of_binding&talent.sigil_of_misery
    if ui.checked("Sigil of Misery - Filler") and cast.able.sigilOfMisery(units.dyn5,"ground",1,8) and talent.cycleOfBinding and talent.sigilOfMisery then
        if cast.sigilOfMisery(units.dyn5,"ground",1,8) then ui.debug("Casting Sigil Of Misery [Filler]") return true end
    end

    -- Sigil Of Silence
    -- sigil_of_silence,if=talent.cycle_of_binding&talent.sigil_of_silence
    if ui.checked("Sigil of Silence - Filler") and cast.able.sigilOfSilence(units.dyn5,"ground",1,8) and talent.cycleOfBinding and talent.sigilOfSilence then
        if cast.sigilOfSilence(units.dyn5,"ground",1,8) then ui.debug("Casting Sigil Of Silence [Filler]") return true end
    end

    -- Felblade
    -- felblade
    if cast.able.felblade() then
        if cast.felblade() then ui.debug("Casting Felblade [Filler]") return true end
    end

    -- Throw Glaive
    -- throw_glaive
    if ui.checked("Throw Glaive") and cast.able.throwGlaive() then
        if cast.throwGlaive() then ui.debug("Casting Throw Glaive [Filler]") return true end
    end

end -- End Action List - Filler

-- Action List - Maintenance
actionList.Maintenance = function()
    -- Fiery Brand
    -- fiery_brand,if=talent.fiery_brand&((active_dot.fiery_brand=0&(cooldown.sigil_of_flame.remains<=(execute_time+gcd.remains)|cooldown.soul_carver.remains<=(execute_time+gcd.remains)|cooldown.fel_devastation.remains<=(execute_time+gcd.remains)))|(talent.down_in_flames&full_recharge_time<=(execute_time+gcd.remains)))
    if cast.able.fieryBrand() and ((talent.fieryBrand and ((debuff.fieryBrand.count(units.dyn5)==0
        and (cd.sigilOfFlame.remains()<=(unit.ttd(units.dyn5)+unit.gcd()) or cd.soulCarver.remains()<=(unit.ttd(units.dyn5)+unit.gcd())
            or cd.felDevastation.remains()<=(unit.ttd(units.dyn5)+unit.gcd())))
            or (talent.downInFlames and charges.fieryBrand.timeTillFull()<=(unit.ttd(units.dyn5)+unit.gcd())))))
    then
        if cast.fieryBrand() then ui.debug("Casting Fiery Brand [Maintenance]") return true end
    end

    -- Sigil Of Flame
    -- sigil_of_flame,if=talent.ascending_flame|active_dot.sigil_of_flame=0
    if ui.checked("Sigil of Flame") and cast.able.sigilOfFlame("best",nil,1,8) and ((talent.ascendingFlame or debuff.sigilOfFlame.count(units.dyn5)==0)) then
        if cast.sigilOfFlame("best",nil,1,8) then ui.debug("Casting Sigil Of Flame [Maintenance]") return true end
    end

    -- Immolation Aura
    -- immolation_aura
    if ui.checked("Immolation Aura") and cast.able.immolationAura("player","aoe",1,8) then
        if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura [Maintenance]") return true end
    end

    -- Bulk Extraction
    -- bulk_extraction,if=((5-soul_fragments)<=spell_targets)&soul_fragments<=2
    if cast.able.bulkExtraction() and ((5-buff.soulFragments.stack())<=#enemies.yards8) and buff.soulFragments.stack()<=2 then
        if cast.bulkExtraction() then ui.debug("Casting Bulk Extraction [Maintenance]") return true end
    end

    -- Spirit Bomb
    -- spirit_bomb,if=variable.can_spb
    if cast.able.spiritBomb() and var.canSpb then
        if cast.spiritBomb() then ui.debug("Casting Spirit Bomb [Maintenance]") return true end
    end

    -- Felblade
    -- felblade,if=(fury.deficit>=40&active_enemies=1)|((cooldown.fel_devastation.remains<=(execute_time+gcd.remains))&fury<50)
    if cast.able.felblade() and (((fury.deficit()>=40 and #enemies.yards8==1) or ((cd.felDevastation.remains()<=(unit.ttd(units.dyn5)+unit.gcd())) and fury()<50))) then
        if cast.felblade() then ui.debug("Casting Felblade [Maintenance]") return true end
    end

    -- Fracture
    -- fracture,if=(cooldown.fel_devastation.remains<=(execute_time+gcd.remains))&fury<50
    if cast.able.fracture() and (cd.felDevastation.remains()<=(unit.ttd(units.dyn5)+unit.gcd())) and fury()<50 then
        if cast.fracture() then ui.debug("Casting Fracture [Maintenance]") return true end
    end

    -- Shear
    -- shear,if=(cooldown.fel_devastation.remains<=(execute_time+gcd.remains))&fury<50
    if cast.able.shear() and (cd.felDevastation.remains()<=(unit.ttd(units.dyn5)+unit.gcd())) and fury()<50 then
        if cast.shear() then ui.debug("Casting Shear [Maintenance]") return true end
    end

    -- Spirit Bomb
    -- spirit_bomb,if=fury.deficit<=30&spell_targets>1&soul_fragments>=4
    if cast.able.spiritBomb() and fury.deficit()<=30 and #enemies.yards8>1 and buff.soulFragments.stack()>=4 then
        if cast.spiritBomb() then ui.debug("Casting Spirit Bomb - AOE [Maintenance]") return true end
    end

    -- Soul Cleave
    -- soul_cleave,if=fury.deficit<=40
    if cast.able.soulCleave() and fury.deficit()<=40 then
        if cast.soulCleave() then ui.debug("Casting Soul Cleave [Maintenance]") return true end
    end
end -- End Action List - Maintenance

-- Action List - SingleTarget
actionList.SingleTarget = function()
    -- The Hunt
    -- the_hunt
    if ui.alwaysCdAoENever("The Hunt",ui.value("Units to AoE"),#enemies.yards50r) and cast.able.theHunt() then
        if cast.theHunt() then ui.debug("Casting The Hunt [Single Target]") return true end
    end

    -- Soul Carver
    -- soul_carver
    if ui.alwaysCdNever("Soul Carver") and cast.able.soulCarver() then
        if cast.soulCarver() then ui.debug("Casting Soul Carver [Single Target]") return true end
    end

    -- Fel Devastation
    -- fel_devastation,if=talent.collective_anguish|(talent.stoke_the_flames&talent.burning_blood)
    if ui.alwaysCdNever("Fel Devastation") and cast.able.felDevastation("player","cone",1,8)
        and ((talent.collectiveAnguish or (talent.stokeTheFlames and talent.burningBlood)))
    then
        if cast.felDevastation("player","cone",1,8) then ui.debug("Casting Fel Devastation - CA or (StF and BB) [Single Target]") return true end
    end

    -- Elysian Decree
    -- elysian_decree
    if ui.alwaysCdAoENever("Elysian Decree",ui.value("Units to AoE"),#enemies.yards30) and cast.able.elysianDecree("best",nil,1,8) and unit.standingTime() > 2 then
        if cast.elysianDecree("best",nil,1,8) then ui.debug("Casting Elysian Decree [Single Target]") return true end
    end

    -- Fel Devastation
    -- fel_devastation
    if ui.alwaysCdNever("Fel Devastation") and cast.able.felDevastation("player","cone",1,8) then
        if cast.felDevastation("player","cone",1,8) then ui.debug("Casting Fel Devastation [Single Target]") return true end
    end

    -- Soul Cleave
    -- soul_cleave,if=!variable.dont_cleave
    if cast.able.soulCleave() and not var.dontCleave then
        if cast.soulCleave() then ui.debug("Casting Soul Cleave [Single Target]") return true end
    end

    -- Fracture
    -- fracture
    if cast.able.fracture() then
        if cast.fracture() then ui.debug("Casting Fracture [Single Target]") return true end
    end

    -- Shear
    -- shear
    if cast.able.shear() then
        if cast.shear() then ui.debug("Casting Shear [Single Target]") return true end
    end

    -- Call Action List - Filler
    -- call_action_list,name=filler
    if actionList.Filler() then return true end
end -- End Action List - SingleTarget

-- Action List - SmallAoe
actionList.SmallAoe = function()
    -- The Hunt
    -- the_hunt
    if ui.alwaysCdAoENever("The Hunt",ui.value("Units to AoE"),#enemies.yards50r) and cast.able.theHunt() then
        if cast.theHunt() then ui.debug("Casting The Hunt [Small Aoe]") return true end
    end

    -- Fel Devastation
    -- fel_devastation,if=talent.collective_anguish.enabled|(talent.stoke_the_flames.enabled&talent.burning_blood.enabled)
    if ui.alwaysCdNever("Fel Devastation") and cast.able.felDevastation("player","cone",1,8)
        and ((talent.collectiveAnguish or (talent.stokeTheFlames and talent.burningBlood)))
    then
        if cast.felDevastation("player","cone",1,8) then ui.debug("Casting Fel Devastation - CA or (StF and BB) [Small Aoe]") return true end
    end

    -- Elysian Decree
    -- elysian_decree,line_cd=1.85,if=fury>=40&(soul_fragments.total<=1|soul_fragments.total>=4)
    if ui.alwaysCdAoENever("Elysian Decree",ui.value("Units to AoE"),#enemies.yards30) and cast.able.elysianDecree("best",nil,1,8) and unit.standingTime() > 2
        and ((ui.delay("ElysianDecree2",1) and (fury()>=40 and (buff.soulFragments.stack()<=1 or buff.soulFragments.stack()>=4))))
    then
        if cast.elysianDecree("best",nil,1,8) then ui.debug("Casting Elysian Decree [Small Aoe]") return true end
    end

    -- Fel Devastation
    -- fel_devastation
    if ui.alwaysCdNever("Fel Devastation") and cast.able.felDevastation("player","cone",1,8) then
        if cast.felDevastation("player","cone",1,8) then ui.debug("Casting Fel Devastation [Small Aoe]") return true end
    end

    -- Soul Carver
    -- soul_carver,if=soul_fragments.total<3
    if ui.alwaysCdNever("Soul Carver") and cast.able.soulCarver() and buff.soulFragments.stack()<3 then
        if cast.soulCarver() then ui.debug("Casting Soul Carver [Small Aoe]") return true end
    end

    -- Soul Cleave
    -- soul_cleave,if=soul_fragments<=1&!variable.dont_cleave
    if cast.able.soulCleave() and buff.soulFragments.stack()<=1 and not var.dontCleave then
        if cast.soulCleave() then ui.debug("Casting Soul Cleave [Small Aoe]") return true end
    end

    -- Fracture
    -- fracture
    if cast.able.fracture() then
        if cast.fracture() then ui.debug("Casting Fracture [Small Aoe]") return true end
    end

    -- Shear
    -- shear
    if cast.able.shear() then
        if cast.shear() then ui.debug("Casting Shear [Small Aoe]") return true end
    end

    -- Call Action List - Filler
    -- call_action_list,name=filler
    if actionList.Filler() then return true end
end -- End Action List - SmallAoe

----------------
--- ROTATION ---
----------------
local function runRotation()

---------------
--- Defines ---
---------------
    -- BR API
    -- Initialize
    if not br.player.initialized then
        -- BR API
        br.player.actionList = actionList
        buff = br.player.buff
        cast = br.player.cast
        casting = br.player.casting
        cd = br.player.cd
        charges = br.player.charges
        debuff = br.player.debuff
        enemies = br.player.enemies
        fury = br.player.power.fury
        module = br.player.module
        talent = br.player.talent
        ui = br.player.ui
        unit = br.player.unit
        units = br.player.units
        use = br.player.use
        var = br.player.variables

        var.lastRune = ui.time()
        var.profileStop = false
        br.player.initialized = true
    end
    -- Variable List
    var.inRaid                                    = br.player.instance=="raid"
    -- Dynamic Units
    units.get(5)
    units.get(8,true)
    units.get(20)
    -- Enemies Listss
    enemies.get(5)
    enemies.get(8)
    enemies.get(30)
    enemies.rect.get(8,50,false)

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop==true then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop==true) or unit.mounted() or unit.flying() or ui.pause() or ui.mode.rotation==4 then
        return true
    else
        if actionList.Defensive() then return true end
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extras() then return true end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if not unit.inCombat() then
            if actionList.Defensive() then return true end
        end
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
local id = 581
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.crashLightning},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.crashLightning},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.rockbiter},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.healingSurge}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.feralSpirit},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.feralSpirit},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.feralSpirit}
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.astralShift},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.astralShift}
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.windShear},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.windShear}
    };
    CreateButton("Interrupt",4,0)
    FuryModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Fury Auto", tip = "Used per profile logic.", highlight = 1, icon = br.player.spell.furyOfAir},
        [2] = { mode = "On", value = 1, overlay = "Fury On", tip = "Always used.", highlight = 0, icon = br.player.spell.furyOfAir}
    };
    CreateButton("Fury",5,0)
    SunderModes = {
        [1] = { mode = "On", value = 1, overlay = "Sundering On", tip = "Auto Use", highlight = 1, icon = br.player.spell.sundering},
        [2] = { mode = "Off", value = 1, overlay = "Sundering Off", tip = "Manual Use", highlight = 0, icon = br.player.spell.sundering}
    };
    CreateButton("Sunder",6,0)
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
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Ghost Wolf
            br.ui:createCheckbox(section,"Ghost Wolf")
            -- Feral Lunge
            br.ui:createCheckbox(section,"Feral Lunge")
            -- Lightning Bolt OOC
            br.ui:createCheckbox(section,"Lightning Bolt Out of Combat")
            -- Spirit Walk
            br.ui:createCheckbox(section,"Spirit Walk")
            -- Sundering
            br.ui:createSpinnerWithout(section,"Units to Sunder", 3,  1,  10,  1,  "|cffFFFFFFSet to desired number of units to cast Sunder. Min: 1 / Max: 10 / Interval: 1")
            -- Water Walking
            br.ui:createCheckbox(section,"Water Walking")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Agi Pot
            br.ui:createCheckbox(section,"Potion")
            -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Seventh Demon","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- Ascendance
            br.ui:createCheckbox(section,"Ascendance")
            -- Earth Elemental Totem
            br.ui:createCheckbox(section,"Earth Elemental")
            -- Feral Spirit
            br.ui:createDropdownWithout(section,"Feral Spirit", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Feral Spirit.")
            -- Heart Essence
            br.ui:createCheckbox(section,"Use Essence")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
            -- Ancestral Spirit
            br.ui:createDropdown(section, "Ancestral Spirit", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Astral Shift
            br.ui:createSpinner(section, "Astral Shift",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Cleanse Spirit
            br.ui:createDropdown(section, "Clease Spirit", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Earth Shield
            br.ui:createCheckbox(section, "Earth Shield")
            -- Healing Surge
            br.ui:createSpinner(section, "Healing Surge",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Lightning Surge Totem
            br.ui:createSpinner(section, "Capacitor Totem - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Capacitor Totem - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
            -- Purge
            br.ui:createCheckbox(section,"Purge")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Wind Shear
            br.ui:createCheckbox(section,"Wind Shear")
            -- Hex
            br.ui:createCheckbox(section,"Hex")
            -- Lightning Surge Totem
            br.ui:createCheckbox(section,"Capacitor Totem")
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
local debuff
local enemies
local essence
local gcdMax
local inCombat
local inRaid
local item
local maelstrom
local mode
local option
local php
local race
local spell
local talent
local trait
local units
local use

-- General API Locals
local actionList = {}
local combatTime
local deadMouse
local deadtar
local falling
local hasMouse
local hastar
local healPot
local moving
local playerMouse
local playertar
local profileStop = false
local pullTimer
local ttd

-- Profile Specific Locals
-- variable,name=cooldown_sync
local cooldownSync
-- variable,name=furyCheck_SS
local furyCheckSS
-- variable,name=furyCheck_LL
local furyCheckLL
-- variable,name=furyCheck_CL
local furyCheckCL
-- variable,name=furyCheck_FB
local furyCheckFB
-- variable,name=furyCheck_ES
local furyCheckES
-- variable,name=furyCheck_LB
local furyCheckLB
-- variable,name=OCPool
local ocPool
-- variable,name=OCPool_SS
local ocPoolSS
-- variable,name=OCPool_LL
local ocPoolLL
-- variable,name=OCPool_CL
local ocPoolCL
-- variable,name=CLPool_LL
local clPoolLL
-- variable,name=CLPool_SS
local clPoolSS
-- variable,name=freezerburn_enabled
local freezerburnEnabled

-- Custom Profile Locals
local activeEnemies
local activeEnemiesMore1
local activeEnemiesMore2
local activeEnemiesLess3
local feralSpiritCastTime = 0
local feralSpiritRemain = 0
local furiousAir
local icyHot
local overcharged
local totemMaster = 0
local windforce

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
actionList.Extras = function()
    -- Dummy Test
    if option.checked("DPS Testing") then
        if GetObjectExists("target") then
            if getCombatTime() >= (tonumber(option.value("DPS Testing"))*60) and isDummy() then
                StopAttack()
                ClearTarget()
                Print(tonumber(option.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                profileStop = true
            end
        end
    end -- End Dummy Test
    -- Ghost Wolf
    if option.checked("Ghost Wolf") and cast.able.ghostWolf() and not (IsMounted() or IsFlying()) then
        if ((#enemies.yards20 == 0 and not inCombat) or (#enemies.yards10 == 0 and inCombat)) and isMoving("player") and not buff.ghostWolf.exists() then
            if cast.ghostWolf() then return true end
        end
    end
    -- Purge
    if option.checked("Purge") and cast.able.purge() and canDispel("target",spell.purge) and not isBoss() and GetObjectExists("target") then
        if cast.purge() then return true end
    end
    -- Spirit Walk
    if option.checked("Spirit Walk") and cast.able.spiritWalk() and hasNoControl(spell.spiritWalk) then
        if cast.spiritWalk() then return true end
    end
    -- Water Walking
    if falling > 1.5 and buff.waterWalking.exists() then
        CancelUnitBuffID("player", spell.waterWalking)
    end
    if option.checked("Water Walking") and cast.able.waterWalking() and not inCombat and IsSwimming() and not buff.waterWalking.exists() then
        if cast.waterWalking() then return true end
    end
end -- End Action List - Extras
-- Action List - Defensive
actionList.Defensive = function()
    if useDefensive() then
        -- Pot/Stoned
        if option.checked("Pot/Stoned") and php <= option.value("Pot/Stoned")
            and inCombat and (hasHealthPot() or hasItem(5512))
        then
            if canUseItem(5512) then
                useItem(5512)
            elseif canUseItem(healPot) then
                useItem(healPot)
            end
        end
        -- Heirloom Neck
        if option.checked("Heirloom Neck") and php <= option.value("Heirloom Neck") then
            if hasEquiped(122668) then
                if GetItemCooldown(122668)==0 then
                    useItem(122668)
                end
            end
        end
        -- Gift of the Naaru
        if option.checked("Gift of the Naaru") and cast.able.giftOfTheNaaru() and php <= option.value("Gift of the Naaru") and php > 0 and race == "Draenei" then
            if cast.giftOfTheNaaru() then return true end
        end
        -- Ancestral Spirit
        if option.checked("Ancestral Spirit") then
            if option.value("Ancestral Spirit")==1 and cast.able.ancestralSpirit("target") and hastar and playertar and deadtar then
                if cast.ancestralSpirit("target","dead") then return true end
            end
            if option.value("Ancestral Spirit")==2 and cast.able.ancestralSpirit("mouseover") and hasMouse and playerMouse and deadMouse then
                if cast.ancestralSpirit("mouseover","dead") then return true end
            end
        end
        -- Astral Shift
        if option.checked("Astral Shift") and cast.able.astralShift() and php <= option.value("Astral Shift") and inCombat then
            if cast.astralShift() then return true end
        end
        -- Cleanse Spirit
        if option.checked("Cleanse Spirit") then
            if option.value("Cleanse Spirit")==1 and cast.able.cleanseSpirit("player") and canDispel("player",spell.cleanseSpirit) then
                if cast.cleanseSpirit("player") then return; end
            end
            if option.value("Cleanse Spirit")==2 and cast.able.cleanseSpirit("target") and canDispel("target",spell.cleanseSpirit) then
                if cast.cleanseSpirit("target") then return true end
            end
            if option.value("Cleanse Spirit")==3 and cast.able.cleanseSpirit("mouseover") and canDispel("mouseover",spell.cleanseSpirit) then
                if cast.cleanseSpirit("mouseover") then return true end
            end
        end
        -- Earthen Shield
        if option.checked("Earth Shield") and cast.able.earthShield() and not buff.earthShield.exists() then
            if cast.earthShield() then return true end
        end
        -- Healing Surge
        if option.checked("Healing Surge") and cast.able.healingSurge() and cast.timeSinceLast.healingSurge() > gcdMax
            and ((inCombat and ((php <= option.value("Healing Surge") / 2 and maelstrom > 20)
                or (maelstrom >= 90 and php <= option.value("Healing Surge")))) or (not inCombat and php <= option.value("Healing Surge") and not moving))
        then
            if cast.healingSurge() then return true end
        end
        -- Capacitor Totem
        if option.checked("Capacitor Totem - HP") and cast.able.capacitorTotem() and cd.capacitorTotem.ready()
            and php <= option.value("Capacitor Totem - HP") and inCombat and #enemies.yards5 > 0
        then
            if cast.capacitorTotem("player","ground") then return true end
        end
        if option.checked("Capacitor Totem - AoE") and cast.able.capacitorTotem() and cd.capacitorTotem.ready()
            and #enemies.yards5 >= option.value("Capacitor Totem - AoE") and inCombat
        then
            if cast.capacitorTotem("best",nil,option.value("Capacitor Totem - AoE"),8) then return true end
        end
    end -- End Defensive Toggle
end -- End Action List - Defensive
-- Action List - Interrupts
actionList.Interrupts = function()
    if useInterrupts() then
        for i=1, #enemies.yards30 do
            thisUnit = enemies.yards30[i]
            if canInterrupt(thisUnit,option.value("Interrupt At")) then
                -- Wind Shear
                -- wind_shear
                if option.checked("Wind Shear") and cast.able.windShear(thisUnit) then
                    if cast.windShear(thisUnit) then return true end
                end
                -- Hex
                if option.checked("Hex") and cast.able.hex(thisUnit) then
                    if cast.hex(thisUnit) then return true end
                end
                -- Capacitor Totem
                if option.checked("Capacitor Totem") and cast.able.capacitorTotem(thisUnit)
                    and cd.capacitorTotem.ready() and cd.windShear.remain() > gcdMax
                then
                    if hasThreat(thisUnit) and not isMoving(thisUnit) and ttd(thisUnit) > 7 then
                        if cast.capacitorTotem(thisUnit,"ground") then return true end
                    end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts
-- Action List - Cooldowns
actionList.Cooldowns = function()
    local usableCD = useCDs() and getDistance("target") < 5 or false
    if usableCD then
        -- Bloodlust/Heroism
        -- bloodlust,if=azerite.ancestral_resonance.enabled
        -- Heart Essence - Worldvein Resonance
        -- worldvein_resonance
        if option.checked("Use Essence") then
            if cast.worldveinResonance() then return true end
        end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
        -- berserking,if=variable.cooldown_sync
        -- blood_fury,if=variable.cooldown_sync
        -- fireblood,if=variable.cooldown_sync
        -- ancestral_call,if=variable.cooldown_sync
        if option.checked("Racial") and cast.able.racial() and cooldownSync
        and (race == "Troll" or race == "Orc" or race == "DarkIronDwarf" or race == "MagharOrc")
        then
            if cast.racial() then return true end
        end
        -- Potion
        -- potion,if=buff.ascendance.up|!talent.ascendance.enabled&feral_spirit.remains>5|target.time_to_die<=60
        if option.checked("Potion") and canUseItem(142117) and inRaid and not buff.prolongedPower.exists() then
            if (hasBloodLust() or (not talent.ascendance and feralSpiritRemain > 5) or ttd(units.dyn5) <= 60) then
                useItem(142117)
            end
        end
        -- Heart Essence - Guardian of Azeroth
        -- guardian_of_azeroth
        if option.checked("Use Essence") and cast.able.guardianOfAzeroth() then
            if cast.guardianOfAzeroth() then return true end
        end
        -- Heart Essence - Memory of Lucid Dreams
        -- memory_of_lucid_dreams
        if option.checked("Use Essence") and cast.able.memoryOfLucidDreams() then
            if cast.memoryOfLucidDreams() then return true end
        end
    end
    -- Feral Spirit
    -- feral_spirit
    if cast.able.feralSpirit() and (option.value("Feral Spirit") == 1 or (option.value("Feral Spirit") == 2 and useCDs())) then
        if cast.feralSpirit() then return true end
    end
    if usableCD then
        -- Heart Essence - Blood of the Enemy
        -- blood_of_the_enemy
        if option.checked("Use Essence") and cast.able.bloodOfTheEnemy() then
            if cast.bloodOfTheEnemy() then return true end
        end
        -- Ascendance
        -- ascendance,if=cooldown.strike.remains>0
        if option.checked("Ascendance") and cast.able.ascendance() and cd.stormstrike.remain() > 0 then
            if cast.ascendance() then return true end
        end
        -- Trinkets
        -- use_items
        if option.checked("Trinkets") then
            if canUseItem(11) then
                useItem(11)
            end
            if canUseItem(12) then
                useItem(12)
            end
            if canUseItem(13) then
                useItem(13)
            end
            if canUseItem(14) then
                useItem(14)
            end
        end
        -- Earth Elemental
        -- earth_elemental
        if option.checked("Earth Elemental") and cast.able.earthElemental() then
            if cast.earthElemental() then return true end
        end
    end -- End useCDs check
end -- End Action List - Cooldowns
-- Action List - Ascendance
actionList.Ascendance = function()
    -- Crash Lightning
    -- crash_lightning,if=!buff.crash_lightning.up&active_enemies>1&variable.furyCheck_CL
    if cast.able.crashLightning() and not buff.crashLightning.exists() and activeEnemiesMore1 and furyCheckCL then
        if cast.crashLightning(nil,"cone",2,8) then return true end
    end
    -- Rockbiter
    -- rockbiter,if=talent.landslide.enabled&!buff.landslide.up&charges_fractional>1.7
    if cast.able.rockbiter() and talent.landslide and not buff.landslide.exists() and charges.rockbiter.frac() > 1.7 then --and cd.windstrike.remain() > gcdMax then
        if cast.rockbiter() then return true end
    end
    -- Windstrike
    -- windstrike
    if cast.able.windstrike() then
        if cast.windstrike() then return true end
    end
end -- End Action List - Ascendance
-- Action List - Priority
actionList.Priority = function()
    -- Crash lightning
    -- crash_lightning,if=active_enemies>=(8-(talent.forceful_winds.enabled*3))&variable.freezerburn_enabled&variable.furyCheck_CL
    if cast.able.crashLightning() and freezerburnEnabled and furyCheckCL
        and ((mode.rotation == 1 and #enemies.yards8 >= (8 - (windforce * 3))) or (mode.rotation == 2 and #enemies.yards8 > 0))
    then
        if cast.crashLightning(nil,"cone",8 - (windforce * 3),8) then return true end
    end
    -- Heart Essence - The Unbound Force
    -- the_unbound_force,if=buff.reckless_force.up|time<5
    if option.checked("Use Essence") and cast.able.theUnboundForce()
        and (buff.recklessForce.exists() or combatTime < 5)
    then
        if cast.theUnboundForce() then return true end
    end
    -- Lava Lash
    -- lava_lash,if=azerite.primal_primer.rank>=2&debuff.primal_primer.stack=10&active_enemies=1&variable.freezerburn_enabled&variable.furyCheck_LL
    if cast.able.lavaLash() and trait.primalPrimer.rank >= 2 and debuff.primalPrimer.stack(units.dyn5)
        and freezerburnEnabled and furyCheckLL
    then
        if cast.lavaLash() then return true end
    end
    -- Crash lightning
    -- crash_lightning,if=!buff.crash_lightning.up&active_enemies>1&variable.furyCheck_CL
    if cast.able.crashLightning() and not buff.crashLightning.exists() and activeEnemiesMore1 and furyCheckCL then
        if cast.crashLightning(nil,"cone",2,8) then return true end
    end
    -- Fury of Air
    -- fury_of_air,if=!buff.fury_of_air.up&maelstrom>=20&spell_targets.fury_of_air_damage>=(1+variable.freezerburn_enabled)
    if cast.able.furyOfAir() and not buff.furyOfAir.exists() and maelstrom >= 20 and (#enemies.yards8 >= (1 + icyHot) or mode.fury == 2) then
        if cast.furyOfAir() then return true end
    end
    -- fury_of_air,if=buff.fury_of_air.up&&spell_targets.fury_of_air_damage<(1+variable.freezerburn_enabled)
    if cast.able.furyOfAir() and buff.furyOfAir.exists() and (#enemies.yards8 < (1 + icyHot) and mode.fury == 1) then
        if cast.furyOfAir() then return true end
    end
    -- Totem Mastery
    -- totem_mastery,if=buff.resonance_totem.remains<=2*gcd
    if cast.able.totemMastery() and not cast.last.totemMastery() and (totemMaster - buff.resonanceTotem.remain()) <= 2 * gcdMax then
        if cast.totemMastery() then return true end
    end
    -- Sundering
    -- sundering,if=active_enemies>=3&(!essence.blood_of_the_enemy.major|(essence.blood_of_the_enemy.major&(buff.seething_rage.up|cooldown.blood_of_the_enemy.remains>40)))
    if mode.sunder == 1 and cast.able.sundering() and activeEnemiesMore2 and (not essence.bloodOfTheEnemy.active
        or (essence.bloodOfTheEnemy.active and (buff.seethingRage.exists() or cd.bloodOfTheEnemy.remain() > 40)))
    then
        if cast.sundering(nil,"rect",3,11) then return true end
    end
    -- Heart Essence - Focused Azerite Beam
    -- focused_azerite_beam,if=active_enemies>=3
    if option.checked("Use Essence") and cast.able.focusedAzeriteBeam() and activeEnemiesMore2 then
        if cast.focusedAzeriteBeam() then return true end
    end
    -- Heart Essence - Purifying Blast
    -- purifying_blast,if=active_enemies>=3
    if option.checked("Use Essence") and cast.able.purifyingBlast() and activeEnemiesMore2 then
        if cast.purifyingBlast("best", nil, 3, 8) then return true end
    end
    -- Rockbiter
    -- rockbiter,if=talent.landslide.enabled&!buff.landslide.up&charges_fractional>1.7
    if cast.able.rockbiter() and talent.landslide and not buff.landslide.exists() and charges.rockbiter.frac() > 1.7 then
        if cast.rockbiter() then return true end
    end
    -- Frostbrand
    -- frostbrand,if=(azerite.natural_harmony.enabled&buff.natural_harmony_frost.remains<=2*gcd)&talent.hailstorm.enabled&variable.furyCheck_FB
    if cast.able.frostbrand() and (trait.naturalHarmony.active and buff.naturalHarmonyFrost.remain() <= 2 * gcdMax)
        and talent.hailstorm and furyCheckFB
    then
        if cast.frostbrand() then return true end
    end
    -- Flametongue
    -- flametongue,if=(azerite.natural_harmony.enabled&buff.natural_harmony_fire.remains<=2*gcd)
    if cast.able.flametongue() and (trait.naturalHarmony.active and buff.naturalHarmonyFire.remain() <= 2 * gcdMax) then
        if cast.flametongue() then return true end
    end
    -- Rockbiter
    -- rockbiter,if=(azerite.natural_harmony.enabled&buff.natural_harmony_nature.remains<=2*gcd)&maelstrom<70
    if cast.able.rockbiter() and (trait.naturalHarmony.active and buff.naturalHarmonyNature.remain() <= 2 * gcdMax) and maelstrom < 70 then
        if cast.rockbiter() then return true end
    end
end -- End Action List - Priority
-- Action List - Maintenance
actionList.Maintenance = function()
    -- Flametongue
    -- flametongue,if=!buff.flametongue.up
    if cast.able.flametongue() and not buff.flametongue.exists() then
        if cast.flametongue() then return true end
    end
    -- Frostbrand
    -- frostbrand,if=talent.hailstorm.enabled&!buff.frostbrand.up&variable.furyCheck_FB
    if cast.able.frostbrand() and talent.hailstorm and not buff.frostbrand.exists() and furyCheckFB then
        if cast.frostbrand() then return true end
    end
end -- End Action List - Maintenance
-- Action List - Freezerburn Core
actionList.FreezerburnCore = function()
    -- Lava Lash
    -- lava_lash,target_if=max:debuff.primal_primer.stack,if=azerite.primal_primer.rank>=2&debuff.primal_primer.stack=10&variable.furyCheck_LL&variable.CLPool_LL
    if cast.able.lavaLash() and trait.primalPrimer.rank >= 2 and furyCheckLL and clPoolLL then
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5[i]
            if debuff.primalPrimer.stack(thisUnit) == 10 then
                if cast.lavaLash(thisUnit) then return true end
            end
        end
    end
    -- Earthen Spike
    -- earthen_spike,if=variable.furyCheck_ES
    if cast.able.earthenSpike() and furyCheckES then
        if cast.earthenSpike() then return true end
    end
    -- Stormstrike
    -- stormstrike,cycle_targets=1,if=active_enemies>1&azerite.lightning_conduit.enabled&!debuff.lightning_conduit.up&variable.furyCheck_SS
    if cast.able.stormstrike() and activeEnemiesMore1 and trait.lightningConduit and furyCheckSS then
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5[i]
            if not debuff.lightningConduit.exists(thisUnit) then
                if cast.stormstrike(thisUnit) then return true end
            end
        end
    end
    -- stormstrike,if=buff.stormbringer.up|(active_enemies>1&buff.gathering_storms.up&variable.furyCheck_SS)
    if cast.able.stormstrike() and (buff.stormbringer.exists() or (activeEnemiesMore1 and buff.gatheringStorms.exists() and furyCheckSS)) then
        if cast.stormstrike() then return true end
    end
    -- Crash lightning
    -- crash_lightning,if=active_enemies>=3&variable.furyCheck_CL
    if cast.able.crashLightning() and activeEnemiesMore2 and furyCheckCL then
        if cast.crashLightning(nil,"cone",3,8) then return true end
    end
    -- Lightning Bolt
    -- lightning_bolt,if=talent.overcharge.enabled&active_enemies=1&variable.furyCheck_LB&maelstrom>=40
    if cast.able.lightningBolt() and talent.overcharge and activeEnemies and furyCheckLB and maelstrom >= 40 then
        if cast.lightningBolt() then return true end
    end
    -- Lava Lash
    -- lava_lash,if=azerite.primal_primer.rank>=2&debuff.primal_primer.stack>7&variable.furyCheck_LL&variable.CLPool_LL
    if cast.able.lavaLash() and trait.primalPrimer.rank >= 2
        and debuff.primalPrimer.stack(units.dyn5) > 7 and furyCheckLL and clPoolLL
    then
        if cast.lavaLash() then return true end
    end
    -- Stormstrike
    -- stormstrike,if=variable.OCPool_SS&variable.furyCheck_SS&variable.CLPool_SS
    if cast.able.stormstrike() and ocPoolSS and furyCheckSS and clPoolSS then
        if cast.stormstrike() then return true end
    end
    -- Lava Lash
    -- lava_lash,if=debuff.primal_primer.stack=10&variable.furyCheck_LL
    if cast.able.lavaLash() and debuff.primalPrimer.stack(units.dyn5) == 10 and furyCheckLL then
        if cast.lavaLash() then return true end
    end
end -- End Action List - Freezerburn Core
-- Action List - Default Core
actionList.DefaultCore = function()
    -- Earthen Spike
    -- earthen_spike,if=variable.furyCheck_ES
    if cast.able.earthenSpike() and furyCheckES then
        if cast.earthenSpike() then return true end
    end
    -- Stormstrike
    -- stormstrike,cycle_targets=1,if=active_enemies>1&azerite.lightning_conduit.enabled&!debuff.lightning_conduit.up&variable.furyCheck_SS
    if cast.able.stormstrike() and activeEnemiesMore1 and trait.lightningConduit and furyCheckSS then
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5[i]
            if not debuff.lightningConduit.exists(thisUnit) then
                if cast.stormstrike(thisUnit) then return true end
            end
        end
    end
    -- stormstrike,if=buff.stormbringer.up|(active_enemies>1&buff.gathering_storms.up&variable.furyCheck_SS)
    if cast.able.stormstrike() and (buff.stormbringer.exists() or (activeEnemiesMore1 and buff.gatheringStorms.exists() and furyCheckSS)) then
        if cast.stormstrike() then return true end
    end
    -- Crash lightning
    -- crash_lightning,if=active_enemies>=3&variable.furyCheck_CL
    if cast.able.crashLightning() and activeEnemiesMore2 and furyCheckCL then
        if cast.crashLightning(nil,"cone",3,8) then return true end
    end
    -- Lightning Bolt
    -- lightning_bolt,if=talent.overcharge.enabled&active_enemies=1&variable.furyCheck_LB&maelstrom>=40
    if cast.able.lightningBolt() and talent.overcharge and activeEnemies and furyCheckLB and maelstrom >= 40 then
        if cast.lightningBolt() then return true end
    end
    -- Stormstrike
    -- stormstrike,if=variable.OCPool_SS&variable.furyCheck_SS
    if cast.able.stormstrike() and ocPoolSS and furyCheckSS then
        if cast.stormstrike() then return true end
    end
end -- End Action List - Defualt Core
-- Action List - Filler
actionList.Filler = function()
    -- Sundering
    -- sundering,if=active_enemies<3
    if mode.sunder == 1 and cast.able.sundering() and activeEnemiesLess3 then
        if cast.sundering(nil,"rect",1,11) then return true end
    end
    -- Heart Essence - Focused Azerite Beam
    -- focused_azerite_beam,if=!buff.ascendance.up&!buff.molten_weapon.up&!buff.icy_edge.up&!buff.crackling_surge.up&!debuff.earthen_spike.up
    if option.checked("Use Essence") and cast.able.focusedAzeriteBeam() and not buff.ascendance.exists()
        and not buff.moltenWeapon.exists() and not buff.icyEdge.exists() and not buff.cracklingSurge.exists()
        and not debuff.earthenSpike.exists(units.dyn8)
    then
        if cast.focusedAzeriteBeam() then return true end
    end
    -- Heart Essence - Purifying Blast
    -- purifying_blast
    if option.checked("Use Essence") and cast.able.purifyingBlast() then
        if cast.purifyingBlast("best", nil, 1, 8) then return true end
    end
    -- Heart Essence - Concentrated Flame
    -- concentrated_flame
    if option.checked("Use Essence") and cast.able.concentratedFlame() and cd.concentratedFlame.ready() then
        if cast.concentratedFlame() then return true end
    end
    -- Heart Essence - Reaping Flames
    -- reaping_flames,if=target.health.pct>80|target.health.pct<=20|target.time_to_pct_20>30
    if cast.able.reapingFlames() then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            local thisHP = getHP(thisUnit)
            if ((essence.reapingFlames.rank >= 2 and thisHP > 80) or thisHP <= 20 or ttd(thisUnit,20) > 30) then
                if cast.reapingFlames(thisUnit) then return true end
            end
        end
    end
    -- Crash lightning
    -- crash_lightning,if=talent.forceful_winds.enabled&active_enemies>1&variable.furyCheck_CL
    if cast.able.crashLightning() and talent.forcefulWinds and activeEnemiesMore1 and furyCheckCL then
        if cast.crashLightning(nil,"cone",2,8) then return true end
    end
    -- Flametongue
    -- flametongue,if=talent.searing_assault.enabled
    if cast.able.flametongue() and talent.searingAssault then
        if cast.flametongue() then return true end
    end
    -- Lava Lash
    -- lava_lash,if=!azerite.primal_primer.enabled&talent.hot_hand.enabled&buff.hot_hand.react
    if cast.able.lavaLash() and not trait.primalPrimer.active and talent.hotHand and buff.hotHand.exists() then
        if cast.lavaLash() then return true end
    end
    -- Crash Lightning
    -- crash_lightning,if=active_enemies>1&variable.furyCheck_CL
    if cast.able.crashLightning() and activeEnemiesMore1 and furyCheckCL then
        if cast.crashLightning(nil,"cone",2,8) then return true end
    end
    -- Rockbiter
    -- rockbiter,if=maelstrom<70&!buff.strength_of_earth.up
    if cast.able.rockbiter() and maelstrom < 70 and not buff.strengthOfTheEarth.exists() then
        if cast.rockbiter() then return true end
    end
    -- Crash lightning
    -- crash_lightning,if=(talent.crashing_storm.enabled|talent.forceful_winds.enabled)&variable.OCPool_CL
    if cast.able.crashLightning() and (talent.crashingStorm or talent.forcefulWinds) and ocPoolCL then
        if cast.crashLightning(nil,"cone",1,8) then return true end
    end
    -- Lava Lash
    -- lava_lash,if=variable.OCPool_LL&variable.furyCheck_LL
    if cast.able.lavaLash() and ocPoolLL and furyCheckLL then
        if cast.lavaLash() then return true end
    end
    -- Rockbiter
    -- rockbiter
    if cast.able.rockbiter() then
        if cast.rockbiter() then return true end
    end
    -- Frostbrand
    -- frostbrand,if=talent.hailstorm.enabled&buff.frostbrand.remains<4.8+gcd&variable.furyCheck_FB
    if cast.able.frostbrand() and talent.hailstorm and buff.frostbrand.remain() < 4.8 + gcdMax and furyCheckFB then
        if cast.frostbrand() then return true end
    end
    -- Flametongue
    -- flametongue
    if cast.able.flametongue() then
        if cast.flametongue() then return true end
    end
end -- End Action List - Filler
-- Action List - Opener
actionList.Opener = function()
    -- Rockbiter
    -- rockbiter,if=maelstrom<15&time<gcd
    if cast.able.rockbiter() and maelstrom < 15 and combatTime < gcdMax then
        if cast.rockbiter() then return true end
    else
        StartAttack()
    end
end -- End Action List - Opener
-- Action List - PreCombat
actionList.PreCombat = function()
    if not inCombat and not (IsFlying() or IsMounted()) then
        -- Flask / Crystal
        -- flask,type=flask_of_the_seventh_demon
        if option.value("Elixir") == 1 and inRaid and not buff.flaskOfTheSeventhDemon.exists() and canUseItem(item.flaskOfTheSeventhDemon) then
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if use.flaskOfTheSeventhDemon() then return true end
        end
        if option.value("Elixir") == 2 and not buff.felFocus.exists() and canUseItem(item.repurposedFelFocuser) then
            if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
            if use.repurposedFelFocuser() then return true end
        end
        if option.value("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUseItem(item.oraliusWhisperingCrystal) then
            if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if use.oraliusWhisperingCrystal() then return true end
        end
        -- Lightning Shield
        -- /lightning_shield
        if cast.able.lightningShield() and not buff.lightningShield.exists() then
            if cast.lightningShield() then return true end
        end
        if option.checked("Pre-Pull Timer") and pullTimer <= option.value("Pre-Pull Timer") then
            -- Potion
            -- potion,name=prolonged_maelstrom,if=feral_spirit.remain()s>5
            if option.checked("Potion") and canUseItem(142117) and inRaid then
                if feralSpiritRemain > 5 and not buff.prolongedPower.exists() then
                    useItem(142117)
                end
            end
        end -- End Pre-Pull
        if isValidUnit("target") then
            -- Feral Lunge
            if option.checked("Feral Lunge") and cast.able.feralLunge() then
                if cast.feralLunge("target") then return true end
            end
            -- Lightning Bolt
            if option.checked("Lightning Bolt Out of Combat") and cast.able.lightningBolt()
                and getDistance("target") >= 10 and not talent.overcharge
                and (not option.checked("Feral Lunge") or not talent.feralLunge
                    or cd.feralLunge.remain() > gcdMax or not cast.able.feralLunge())
                and (not option.checked("Ghost Wolf") or getDistance("target") <= 20 or not buff.ghostWolf.exists())
            then
                if cast.lightningBolt("target") then return true end
            end
            -- Start Attack
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
    --------------
    --- Locals ---
    --------------
    -- BR API
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    essence                                       = br.player.essence
    gcdMax                                        = br.player.gcdMax
    inCombat                                      = br.player.inCombat
    inRaid                                        = br.player.instance=="raid"
    item                                          = br.player.items
    maelstrom                                     = br.player.power.maelstrom.amount()
    mode                                          = br.player.mode
    option                                        = br.player.option
    php                                           = br.player.health
    race                                          = br.player.race
    spell                                         = br.player.spell
    talent                                        = br.player.talent
    trait                                         = br.player.traits
    units                                         = br.player.units
    use                                           = br.player.use

    -- General API
    combatTime                                    = getCombatTime()
    deadMouse                                     = UnitIsDeadOrGhost("mouseover")
    deadtar                                       = UnitIsDeadOrGhost("target")
    falling                                       = getFallTime()
    hasMouse                                      = GetObjectExists("mouseover")
    hastar                                        = GetObjectExists("target")
    healPot                                       = getHealthPot()
    moving                                        = GetUnitSpeed("player") > 0
    playerMouse                                   = UnitIsPlayer("mouseover")
    playertar                                     = UnitIsPlayer("target")
    pullTimer                                     = PullTimerRemain()
    ttd                                           = getTTD

    -- Dynamic Units
    units.get(5)
    units.get(8) --units.dyn8 = br.player.units(8)
    units.get(20)--units.dyn20 = br.player.units(20)

    -- Enemies Lists
    enemies.get(5)
    enemies.get(5,"player",false,true)
    enemies.get(8) --enemies.yards8 = br.player.enemies(8)
    enemies.get(10) --enemies.yards10 = br.player.enemies(10)
    enemies.yards11r = getEnemiesInRect(10,11,false) or 0
    enemies.get(20) --enemies.yards20 = br.player.enemies(20)
    enemies.get(30) --enemies.yards30 = br.player.enemies(30)
    enemies.get(40)

    -- Custom Profile Specific

    -- active_enemies=1
    activeEnemies                                   = ((mode.rotation == 1 and #enemies.yards8 == 1) or (mode.rotation == 2 and #enemies.yards8 > 0))
    -- active_enemies>1
    activeEnemiesMore1                              = ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0))
    -- active_enemies>=3
    activeEnemiesMore2                              = ((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0))
    -- active_enemies<3
    activeEnemiesLess3                              = ((mode.rotation == 1 and #enemies.yards8 < 3) or (mode.rotation == 3 and #enemies.yards8 > 0))
    -- Crash Lightning
    -- crashedEnemies                                  = getEnemiesInCone(100,7)
    -- Fury of Air
    furiousAir                                      = talent.furyOfAir and 1 or 0
    -- Overcharge
    overcharged                                     = talent.overcharge and 1 or 0
    -- Forceful Winds
    windforce                                       = talent.forcefulWinds and 1 or 0

    -- Feral Spirit
    if cast.last.feralSpirit() then feralSpiritCastTime = GetTime() + 15 end
    if feralSpiritCastTime > GetTime() then feralSpiritRemain = feralSpiritCastTime - GetTime() else feralSpiritCastTime = 0; feralSpiritRemain = 0 end
    -- Totem Mastery
    if buff.resonanceTotem.remain() > 0 and totemMaster == 0 then totemMaster = GetTime() + 120 end
    if buff.resonanceTotem.remain() == 0 then totemMaster = 0 end

    -- Profile Specific
    -- cooldown_sync,value=(talent.ascendance.enabled&(buff.ascendance.up|cooldown.ascendance.remains>50))|(!talent.ascendance.enabled&(feral_spirit.remains>5|cooldown.feral_spirit.remains>50))
    cooldownSync = (talent.ascendance and (buff.ascendance.exists() or cd.ascendance.remain() > 50)) or (not talent.ascendance and (feralSpiritRemain > 5 or cd.feralSpirit.remain() > 50))
    -- furyCheck_SS,value=maelstrom>=(talent.fury_of_air.enabled*(6+action.stormstrike.cost))
    furyCheckSS = maelstrom >= (furiousAir * (6 + cast.cost.stormstrike()))
    -- furyCheck_LL,value=maelstrom>=(talent.fury_of_air.enabled*(6+action.lava_lash.cost))
    furyCheckLL = maelstrom >= (furiousAir * (6 + cast.cost.lavaLash()))
    -- furyCheck_CL,value=maelstrom>=(talent.fury_of_air.enabled*(6+action.crash_lightning.cost))
    furyCheckCL = maelstrom >= (furiousAir * (6 + cast.cost.crashLightning()))
    -- furyCheck_FB,value=maelstrom>=(talent.fury_of_air.enabled*(6+action.frostbrand.cost))
    furyCheckFB = maelstrom >= (furiousAir * (6 + cast.cost.frostbrand()))
    -- furyCheck_ES,value=maelstrom>=(talent.fury_of_air.enabled*(6+action.earthen_spike.cost))
    furyCheckES = maelstrom >= (furiousAir * (6 + cast.cost.earthenSpike()))
    -- furyCheck_LB,value=maelstrom>=(talent.fury_of_air.enabled*(6+40))
    furyCheckLB = maelstrom >= (furiousAir * (6 + 40))
    -- OCPool,value=(active_enemies>1|(cooldown.lightning_bolt.remains>=2*gcd))
    ocPool = (activeEnemiesMore1 or (cd.lightningBolt.remain() >= 2 * gcdMax))
    -- OCPool_SS,value=(variable.OCPool|maelstrom>=(talent.overcharge.enabled*(40+action.stormstrike.cost)))
    ocPoolSS = (ocPool or maelstrom >= (overcharged * (40 + cast.cost.stormstrike())))
    -- OCPool_LL,value=(variable.OCPool|maelstrom>=(talent.overcharge.enabled*(40+action.lava_lash.cost)))
    ocPoolLL = (ocPool or maelstrom >= (overcharged * (40 + cast.cost.lavaLash())))
    -- OCPool_CL,value=(variable.OCPool|maelstrom>=(talent.overcharge.enabled*(40+action.crash_lightning.cost)))
    ocPoolCL = (ocPool or maelstrom >= (overcharged * (40 + cast.cost.crashLightning())))
    -- CLPool_LL,value=active_enemies=1|maelstrom>=(action.crash_lightning.cost+action.lava_lash.cost)
    clPoolLL = activeEnemies or maelstrom >= (cast.cost.crashLightning() + cast.cost.lavaLash())
    -- CLPool_SS,value=active_enemies=1|maelstrom>=(action.crash_lightning.cost+action.stormstrike.cost)
    clPoolSS = activeEnemies or maelstrom >= (cast.cost.crashLightning() + cast.cost.stormstrike())
    -- freezerburn_enabled,value=(talent.hot_hand.enabled&talent.hailstorm.enabled&azerite.primal_primer.enabled)
    freezerburnEnabled = (talent.hotHand and talent.hailstorm and trait.primalPrimer.active)

    icyHot = freezerburnEnabled and 1 or 2

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop==true then
        profileStop = false
    elseif (inCombat and profileStop==true) or pause() or IsMounted() or IsFlying() or mode.rotation==4 then
        if buff.furyOfAir.exists() then
            cast.furyOfAir()
        end
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
        ---------------------------
        --- Pre-Combat Rotation ---
        ---------------------------
        if actionList.PreCombat() then return true end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if inCombat and isValidUnit(units.dyn20) and profileStop==false then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return true end
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            if option.value("APL Mode") == 1 then
                -- Feral Lunge
                if option.checked("Feral Lunge") and hasThreat("target") then
                    if cast.feralLunge("target") then return true end
                end
                -- Start Attack
                if getDistance("target") <= 5 then
                    StartAttack()
                end
                -- Call Action List - Opener
                -- call_action_list,name=opener
                if actionList.Opener() then return true end
                -- Call Action List - Ascendance
                -- call_action_list,name=asc,if=buff.ascendance.up
                if buff.ascendance.exists() then
                    if actionList.Ascendance() then return true end
                end
                -- Call Action List - Priority
                -- call_action_list,name=priority
                if actionList.Priority() then return true end
                -- Call Action List - Maintenance
                -- call_action_list,name=maintenance,if=active_enemies<3
                if activeEnemiesLess3 then
                    if actionList.Maintenance() then return true end
                end
                -- Call Action List - Cooldowns
                -- call_action_list,name=cds
                if actionList.Cooldowns() then return true end
                -- Call Action List - Freezerburn Core
                -- call_action_list,name=freezerburn_core,if=variable.freezerburn_enabled
                if freezerburnEnabled then
                    if actionList.FreezerburnCore() then return true end
                end
                -- Call Action List - Default Core
                -- call_action_list,name=default_core,if=!variable.freezerburn_enabled
                if not freezerburnEnabled then
                    if actionList.DefaultCore() then return true end
                end
                -- Call Action List - Maintenance
                -- call_action_list,name=maintenance,if=active_enemies>=3
                if activeEnemiesMore2 then
                    if actionList.Maintenance() then return true end
                end
                -- Call Action List - Filler
                -- call_action_list,name=filler
                if actionList.Filler() then return true end
            end -- End SimC APL
            ----------------------
            --- AskMrRobot APL ---
            ----------------------
            if option.value("APL Mode") == 2 then

            end
        end --End In Combat
    end --End Rotation Logic
end -- End runRotation
local id = 263
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

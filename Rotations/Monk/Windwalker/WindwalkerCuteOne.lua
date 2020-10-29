local br = _G["br"]
local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.tigerPalm },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.spinningCraneKick },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.tigerPalm },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.vivify}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.invokeXuenTheWhiteTiger },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.invokeXuenTheWhiteTiger },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.invokeXuenTheWhiteTiger }
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.vivify },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.vivify }
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.spearHandStrike },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.spearHandStrike }
    };
    CreateButton("Interrupt",4,0)
    -- Storm, Earth, and Fire Button
    SefModes = {
        [1] = { mode = "Boss", value = 1 , overlay = "Auto SEF on Boss Only", tip = "Will cast Storm, Earth and Fire on Bosses only.", highlight = 1, icon = br.player.spell.stormEarthAndFireFixate},
        [2] = { mode = "On", value = 2 , overlay = "Auto SEF Enabled", tip = "Will cast Storm, Earth, and Fire.", highlight = 0, icon = br.player.spell.stormEarthAndFire},
        [3] = { mode = "Off", value = 3 , overlay = "Auto SEF Disabled", tip = "Will NOT cast Storm, Earth, and Fire.", highlight = 0, icon = br.player.spell.stormEarthAndFireFixate}

    };
    CreateButton("Sef",5,0)
    -- Flying Serpent Kick Button
    FskModes = {
        [1] = { mode = "On", value = 2 , overlay = "Auto FSK Enabled", tip = "Will cast Flying Serpent Kick.", highlight = 1, icon = br.player.spell.flyingSerpentKick},
        [2] = { mode = "Off", value = 1 , overlay = "Auto FSK Disabled", tip = "Will NOT cast Flying Serpent Kick.", highlight = 0, icon = br.player.spell.flyingSerpentKickEnd}
    };
    CreateButton("Fsk",6,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        local alwaysCdNever = {"|cff00FF00Always","|cffFFFF00Cooldowns","|cffFF0000Never"}
        local race = select(2,UnitRace("player"))
        local racial = GetSpellInfo(br.getRacial())
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
            -- br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Crackling Jade lightning
            br.ui:createCheckbox(section, "Crackling Jade Lightning")
            br.ui:createSpinnerWithout(section, "Cancel CJL Range", 10, 5, 40, 5, "|cffFFFFFFCancels Crackling Jade Lightning below this range in yards.")
            -- Chi Burst
            br.ui:createSpinnerWithout(section,"Chi Burst Min Units",1,1,10,1,"|cffFFFFFFSet to the minumum number of units to cast Chi Burst on.")
            -- Disable
            br.ui:createCheckbox(section, "Disable")
            -- FoF Targets
            br.ui:createSpinnerWithout(section, "Fists of Fury Targets", 1, 1, 10, 1, "|cffFFFFFFSet to the minumum number of units to cast Fists of Fury on.")
            -- Provoke
            br.ui:createCheckbox(section, "Provoke", "Will aid in grabbing mobs when solo.")
            -- Roll
            br.ui:createCheckbox(section, "Roll / Chi Torpedo")
            -- Tiger's Lust
            br.ui:createCheckbox(section, "Tiger's Lust")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Flask Module
            br.player.module.FlaskUp("Agility",section)
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- Racial
            -- br.ui:createCheckbox(section,"Racial")
            if race == "Orc" or race == "BloodElf" or race == "LightforgedDraenei" or race == "DarkIronDwarf" or race == "MagharOrc" then
                br.ui:createDropdownWithout(section, racial, alwaysCdNever, 1, "|cffFFFFFFWhen to use "..racial)
            end
            -- Touch of the Void
            br.ui:createCheckbox(section,"Touch of the Void")
            -- Invoke Xuen - The White Tiger
            br.ui:createDropdownWithout(section, "Invoke Xuen", alwaysCdNever, 2, "|cffFFFFFFWhen to use Invoke Xuen.")
            -- Serenity
            br.ui:createDropdownWithout(section, "Serenity", alwaysCdNever, 2, "|cffFFFFFFWhen to use Serenity.")
            -- Storm, Earth, and Fire
            br.ui:createDropdownWithout(section, "Storm, Earth, and Fire", alwaysCdNever, 1, "|cffFFFFFFWhen to use Storm, Earth, and Fire.")
            -- SEF Fixate
            br.ui:createCheckbox(section, "SEF Fixate", "|cffFFFFFFStorm, Earth, and Fire Fixate on Target.")
            -- Touch of Death
            br.ui:createDropdownWithout(section, "Touch of Death", alwaysCdNever, 2, "|cffFFFFFFWhen to use Touch of Death.")
            -- Touch of Karma
            br.ui:createDropdownWithout(section, "Touch of Karma - CD", alwaysCdNever, 1, "|cffFFFFFFWhen to use Touch of Karma.")
        br.ui:checkSectionState(section)
        -----------------------
        --- ESSENCE OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Essences")
            -- Heart Essence
            br.ui:createCheckbox(section,"Use Essence")
            -- Essence - Blood of the Enemy
            br.ui:createDropdownWithout(section, "Blood of the Enemy", alwaysCdNever, 1, "|cffFFFFFFWhen to use Blood of the Enemy.")
            -- Essence - Concentrated Flame
            br.ui:createDropdownWithout(section, "Concentrated Flame", alwaysCdNever, 1, "|cffFFFFFFWhen to use Concentrated Flame.")
            -- Essence - Focused Azerite Beam
            br.ui:createDropdownWithout(section, "Focused Azerite Beam", alwaysCdNever, 1, "|cffFFFFFFWhen to use Focused Azerite Beam.")
            -- Essence - Guardian of Azeroth
            br.ui:createDropdownWithout(section, "Guardian of Azeroth", alwaysCdNever, 2, "|cffFFFFFFWhen to use Guardian of Azeroth.")
            -- Essence - Memory of Lucid Dreams
            br.ui:createDropdownWithout(section, "Memory of Lucid Dreams", alwaysCdNever, 2, "|cffFFFFFFWhen to use Memory of Lucid Dreams.")
            -- Essence - Purifying Blast
            br.ui:createDropdownWithout(section, "Purifying Blast", alwaysCdNever, 1, "|cffFFFFFFWhen to use Purifying Blast.")
            -- Essence - Reaping Flames
            br.ui:createDropdownWithout(section, "Reaping Flames", alwaysCdNever, 1, "|cffFFFFFFWhen to use Reaping Flames.")
            -- Essence - Ripple In Space
            br.ui:createDropdownWithout(section, "Ripple In Space", alwaysCdNever, 1, "|cffFFFFFFWhen to useRipple In Space.")
            -- Essence - The Unbound Force
            br.ui:createDropdownWithout(section, "The Unbound Force", alwaysCdNever, 1, "|cffFFFFFFWhen to use The Unbound Force.")
            -- Essence - Worldvein Resonance
            br.ui:createDropdownWithout(section, "Worldvein Resonance", alwaysCdNever, 1, "|cffFFFFFFWhen to use Worldvein Resonance.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
         section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Modile
            br.player.module.BasicHealing(section)
            -- Detox
            br.ui:createCheckbox(section,"Detox")
            -- Diffuse Magic/Dampen Harm
            br.ui:createSpinner(section, "Diffuse/Dampen",  35,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Fortifying Brew
            br.ui:createSpinner(section, "Fortifying Brew",  45,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Leg Sweep
            br.ui:createSpinner(section, "Leg Sweep - HP", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Leg Sweep - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
            -- Resuscitate
            br.ui:createDropdown(section, "Resuscitate", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
            -- Touch of Karma
            br.ui:createSpinner(section, "Touch of Karma",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Vivify
            br.ui:createSpinner(section, "Vivify",  40,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Spear Hand Strike
            br.ui:createCheckbox(section, "Spear Hand Strike")
            -- Paralysis
            br.ui:createCheckbox(section, "Paralysis")
            -- Leg Sweep
            br.ui:createCheckbox(section, "Leg Sweep")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- SEF Toggle
            br.ui:createDropdownWithout(section,  "SEF Mode", br.dropOptions.Toggle,  5)
            -- FSK Toggle
            br.ui:createDropdownWithout(section,  "FSK Mode", br.dropOptions.Toggle,  5)
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
local chi
local chiMax
local debuff
local enemies
local energy
local energyTTM
local equiped
local essence
local module
local pet
local spell
local talent
local ui
local unit
local units
local use
local var

-----------------------
--- Local Functions ---
-----------------------
local function alwaysCdNever(option)
    if option == "Racial" then GetSpellInfo(br.player.spell.racial) end
    local thisOption = ui.value(option)
    return thisOption == 1 or (thisOption == 2 and ui.useCDs())
end

local function wasLastCombo(spellID)
    return var.lastCombo == spellID
end

--------------------
--- Action Lists ---
--------------------
local actionList = {}
-- Action List - Extras
actionList.Extras = function()
    local startTime = debugprofilestop()
    -- Tiger's Lust
    if ui.checked("Tiger's Lust") and cast.able.tigersLust() then
        if cast.noControl.tigersLust() or (unit.inCombat() and unit.distance("target") > 10 and unit.valid("target")) then
            if cast.tigersLust() then ui.debug("Casting Tiger's Lust") return true end
        end
    end
    -- Resuscitate
    if ui.checked("Resuscitate") and cast.able.resuscitate() then
        local opValue = ui.value("Resuscitate")
        local thisUnit
        if opValue == 1 then thisUnit = "target" end
        if opValue == 2 then thisUnit = "mouseover" end
        if unit.player(thisUnit) and unit.deadOrGhost(thisUnit) and unit.friend(thisUnit,"player") then
            if cast.resuscitate(thisUnit) then ui.debug("Casting Resuscitate") return true end
        end
    end
    -- Provoke
    if ui.checked("Provoke") and cast.able.provoke() and var.solo and not unit.inCombat()
        and select(3,GetSpellInfo(101545)) ~= "INTERFACE\\ICONS\\priest_icon_chakra_green"
        and unit.valid("target") and not unit.isBoss("target")
        and cd.flyingSerpentKick.remain() > 1 and unit.distance("target") > 10
    then
        if cast.provoke() then ui.debug("Casting Provoke [Extras]") return true end
    end
    -- Disable
    if ui.checked("Disable") and unit.valid("target") and not unit.isBoss("target")
        and (not debuff.disable.exists("target") or (debuff.disable.exists("target") and unit.level() > 41 and not debuff.disableRoot.exists("target")))
    then
        if cast.disable() then ui.debug("Casting Disable [Extras]") return true end
    end
    -- Roll
    if ui.checked("Roll / Chi Torpedo") and cast.able.roll() and unit.distance("target") > 10
        and unit.valid("target") and getFacingDistance() < 5 and unit.facing("player","target",10)
    then
        if not talent.chiTorpedo then
            if cast.roll() then ui.debug("Casting Roll") return true end
        end
        if talent.chiTorpedo then
            if cast.chiTorpedo() then ui.debug("Casting Chi Torpedo") return true end
        end
    end
    -- Dummy Test
    if ui.checked("DPS Testing") and unit.isDummy() then
        if unit.exists("target") then
            if var.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) then
                if buff.stormEarthAndFire.exists() then
                    buff.stormEarthAndFile.cancel()
                    ui.debug("Canceling Storm, Earth, and Fire")
                end
                StopAttack()
                ClearTarget()
                Print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end
    -- Crackling Jade Lightning
    if ui.checked("Crackling Jade Lightning") and not cast.current.cracklingJadeLightning()
        and not unit.moving() and unit.distance("target") > ui.value("Cancel CJL Range")
    then
        if cast.cracklingJadeLightning() then ui.debug("Casting Crackling Jade Lightning [Pull]") return true end
    end
    -- Touch of the Void
    if ui.checked("Touch of the Void") and use.able.touchOfTheVoid()
        and unit.inCombat() and #enemies.yards8 > 0
        and equiped.touchOfTheVoid() and (ui.useCDs() or ui.useAOE())
    then
        if use.touchOfTheVoid() then ui.debug("Using Touch of the Void") return true end
    end
    -- Fixate - Storm, Earth, and Fire
    if cast.able.stormEarthAndFireFixate("target") and ui.value("SEF Fixate") == 1
        and not talent.serenity and not cast.current.fistsOfFury() and not unit.isUnit(var.fixateTarget,"target")
        and #enemies.yards5 > 0
    then
        if cast.stormEarthAndFireFixate("target") then var.fixateTarget = "target" ui.debug("Casting SEF [Fixate]") return true end
    end
    -- Debugging
	br.debug.cpu:updateDebug(startTime,"rotation.profile.extras")
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        local startTime = debugprofilestop()
        -- Basic Healing Module
        module.BasicHealing()
        -- Print("Rotating")
        -- Dampen Harm / Diffuse Magic
        if ui.checked("Diffuse/Dampen") and unit.hp() <= ui.value("Diffuse/Dampen") and unit.inCombat() then
            if talent.dampenHarm and cast.able.dampenHarm() then
                if cast.dampenHarm() then ui.debug("Casting Dampen Harm") return true end
            end
            if talent.diffuseMagic and cast.able.diffuseMagic() and cast.dispel.diffuseMagic("player") then
                if cast.diffuseMagic() then ui.debug("Casting Diffuse Magic") return true end
            end
        end
        -- Detox
        if ui.checked("Detox") and cast.able.detox() then
            if cast.dispel.detox("player") then
                if cast.detox("player") then ui.debug("Casting Detox [Player]") return true end
            end
            if unit.player("mouseover") and not unit.deadOrGhost("mouseover") then
                if cast.dispel.detox("mouseover") then
                    if cast.detox("mouseover") then ui.debug("Casting Detox [Mouseover]") return true end
                end
            end
        end
        -- Fortifying Brew
        if ui.checked("Fortifying Brew") and cast.able.fortifyingBrew() and unit.hp() <= ui.value("Fortifying Brew") and unit.inCombat() then
            if cast.fortifyingBrew() then ui.debug("Casting Fortifying Brew") return true end
        end
        -- Leg Sweep
        if cast.able.legSweep() and unit.inCombat() and #enemies.yards5 > 0 then
            if ui.checked("Leg Sweep - HP") and unit.hp() <= ui.value("Leg Sweep - HP") then
                if cast.legSweep() then ui.debug("Casting Leg Sweep [HP]") return true end
            end
            if ui.checked("Leg Sweep - AoE") and #enemies.yards5 >= ui.value("Leg Sweep - AoE") then
                if cast.legSweep() then ui.debug("Casting Leg Sweep [AOE]") return true end
            end
        end
        -- Touch of Karma
        if ui.checked("Touch of Karma") and cast.able.touchOfKarma() and unit.hp() <= ui.value("Touch of Karma") and unit.inCombat() then
            if cast.touchOfKarma() then ui.debug("Casting Touch of Karma [Defensive]") return true end
        end
        -- Vivify
        if ui.checked("Vivify") and cast.able.vivify() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if unit.hp(thisUnit) <= ui.value("Vivify") then
                if cast.vivify(thisUnit) then ui.debug("Casting Vivify on "..unit.name(thisUnit)) return true end
            end
        end
        -- Debugging
	    br.debug.cpu:updateDebug(startTime,"rotation.profile.defensive")
    end -- End Defensive Check
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        local startTime = debugprofilestop()
        for i=1, #enemies.yards20 do
            local thisUnit = enemies.yards20[i]
            local distance = unit.distance(thisUnit)
            if canInterrupt(thisUnit,ui.value("Interrupt At")) then
                -- Spear Hand Strike
                if ui.checked("Spear Hand Strike") and cast.able.spearHandStrike(thisUnit) and  distance < 5 then
                    if cast.spearHandStrike(thisUnit) then ui.debug("Casting Spear Hand Strike") return true end
                end
                -- Leg Sweep
                if ui.checked("Leg Sweep") and cast.able.legSweep(thisUnit) and (distance < 5 or (talent.tigerTailSweep and distance < 7)) then
                    if cast.legSweep(thisUnit) then ui.debug("Casting Leg Sweep [Interrupt]") return true end
                end
                -- Paralysis
                if ui.checked("Paralysis") and cast.able.paralysis(thisUnit) then
                    if cast.paralysis(thisUnit) then ui.debug("Casting Paralysis") return true end
                end
            end
        end
        -- Debugging
	    br.debug.cpu:updateDebug(startTime,"rotation.profile.interrupts")
    end -- End Interrupt Check
end -- End Action List - Interrupts

-- Action List - CdSef
actionList.CdSef = function()
    -- Invoke Xuen - The White Tiger
    -- invoke_xuen_the_white_tiger,if=!variable.hold_xuen|fight_remains<25
    if cast.able.invokeXuenTheWhiteTiger() and alwaysCdNever("Invoke Xuen") and (not var.holdXuen or (unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) < 25)) then
        if cast.invokeXuenTheWhiteTiger() then ui.debug("Casting Invoke Xuen - The White Tiger") return true end
    end
    -- Racial - Arcane Torrent [Blood Elf]
    -- arcane_torrent,if=chi.max-chi>=1
    if cast.able.racial() and alwaysCdNever("Racial") and (chiMax - chi >= 1 and unit.race() == "BloodElf") then
        if cast.racial() then ui.debug("Casting Arcane Torrent") return true end
    end
    -- Touch of Death
    -- touch_of_death,if=target.health.pct<=15&buff.storm_earth_and_fire.down
    if cast.able.touchOfDeath() and alwaysCdNever("Touch of Death") and not buff.stormEarthAndFire.exists() and (unit.health("target") < unit.health("player")
        or (unit.level() > 44 and unit.health("target") >= unit.health("player") and unit.hp("target") < 15))
    then
        if cast.touchOfDeath() then ui.debug("Casting Touch of Death") return true end
    end
    -- Heart Essence
    if ui.checked("Use Essence") then
        -- Essence - Blood of the Enemy
        -- blood_of_the_enemy,if=cooldown.fists_of_fury.remains<2|fight_remains<12
        if cast.able.bloodOfTheEnemy() and alwaysCdNever("Blood of the Enemy")
            and (cd.fistsOfFury.remain() < 2 or (unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) < 12))
        then
            if cast.bloodOfTheEnemy() then ui.debug("Casting Blood of the Enemy") return true end
        end
        -- Essence - Guardian of Azeroth
        -- guardian_of_azeroth
        if cast.able.guardianOfAzeroth() and alwaysCdNever("Guardian of Azeroth") then
            if cast.guardianOfAzeroth() then ui.debug("Casting Guardian of Azeroth") return true end
        end
        -- Essence - Worldvein Resonance
        -- worldvein_resonance
        if cast.able.worldveinResonance() and alwaysCdNever("Worldvein Resonance") then
            if cast.worldveinResonance() then ui.debug("Casting Worldvein Resonance") return true end
        end
        -- Essence - Concentrated Flame
        -- concentrated_flame,if=!dot.concentrated_flame_burn.remains&((!talent.whirling_dragon_punch.enabled|cooldown.whirling_dragon_punch.remains)&cooldown.rising_sun_kick.remains&cooldown.fists_of_fury.remains&buff.storm_earth_and_fire.down)|fight_remains<8
        if cast.able.concentratedFlame() and alwaysCdNever("Concentrated Flame") and (not debuff.concentratedFlameBurn.remain(units.dyn5)
            and ((not talent.whirlingDragonPunch or cd.whirlingDragonPunch.exists())
                and cd.risingSunKick.exists() and cd.fistsOfFury.exists() and not buff.stormEarthAndFire.exists())
                    or (unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) < 8))
        then
            if cast.concentratedFlame() then ui.debug("Casting Concentrated Flame") return true end
        end
        -- Essence - The Unbound Force
        -- the_unbound_force
        if cast.able.theUnboundForce() and alwaysCdNever("The Unbound Force") then
            if cast.theUnboundForce() then ui.debug("Casting The Unbound Force") return true end
        end
        -- Essence - Purifying Blast
        -- purifying_blast
        if cast.able.purifyingBlast() and alwaysCdNever("Purifying Blast") then
            if cast.purifyingBlast("best", nil, var.minCount, 8) then ui.debug("Casting Purifying Blast") return true end
        end
        -- Essence - Reaping Flames
        -- reaping_flames,if=target.time_to_pct_20>30|target.health.pct<=20
        if cast.able.reapingFlames() and alwaysCdNever("Reaping Flames") and (unit.ttd(units.dyn5,20) > 30 or unit.hp(units.dyn5) <= 20) then
            if cast.reapingFlames() then ui.debug("Casting Reaping Flames") return true end
        end
        -- Essence - Focused Azerite Beam
        -- focused_azerite_beam
        if cast.able.focusedAzeriteBeam() and alwaysCdNever("Focused Azerite Beam") then
            if cast.focusedAzeriteBeam(nil,"rect",var.minCount,30) then ui.debug("Casting Focused Azerite Beam") return true end
        end
        -- Essence - Memory of Lucid Dreams
        -- memory_of_lucid_dreams,if=energy<40
        if cast.able.memoryOfLucidDreams() and alwaysCdNever("Memory of Lucid Dreams") and energy < 40 then
            if cast.memoryOfLucidDreams() then ui.debug("Casting Memory of Lucid Dreams") return true end
        end
        -- Essence - Ripple In Space
        -- ripple_in_space
        if cast.able.rippleInSpace() and alwaysCdNever("Ripple In Space") then
            if cast.rippleInSpace() then ui.debug("Casting Ripple In Space") return true end
        end
    end
    -- Storm, Earth, and Fire
    -- storm_earth_and_fire,if=cooldown.storm_earth_and_fire.charges=2|fight_remains<20|buff.seething_rage.up|(cooldown.blood_of_the_enemy.remains+1>cooldown.storm_earth_and_fire.full_recharge_time|!essence.blood_of_the_enemy.major)&cooldown.fists_of_fury.remains<10&chi>=2&cooldown.whirling_dragon_punch.remains<12
    if cast.able.stormEarthAndFire() and alwaysCdNever("Storm, Earth, and Fire") and (charges.stormEarthAndFire.count() == 2 or (unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) < 20)
        or buff.seethingRage.exists() or (cd.bloodOfTheEnemy.remain() + 1 > charges.stormEarthAndFire.timeTillFull() or not essence.bloodOfTheEnemy.major)
        and cd.fistsOfFury.remain() < 10 and chi >= 2 and cd.whirlingDragonPunch.remain() < 12)
    then
        if cast.stormEarthAndFire() then ui.debug("Casting Storm, Earth, and Fire") return true end
    end
    -- Ashvane's Razor Coral
    -- use_item,name=ashvanes_razor_coral
    --TODO: parsing use_item
    -- Touch of Karma
    -- touch_of_karma,interval=90,pct_health=0.5
    if cast.able.touchOfKarma() and alwaysCdNever("Touch of Karma - CD") then
        if cast.touchOfKarma() then ui.debug("Casting Touch of Karma [CD]") return true end
    end
    -- Racials
    if alwaysCdNever("Racial") then
        -- Racial - Blood Fury
        -- blood_fury,if=fight_remains>125|buff.storm_earth_and_fire.up|fight_remains<20
        if cast.able.racial() and ((unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) > 125)
            or buff.stormEarthAndFire.exists() or (unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) < 20)
            and unit.race() == "Orc")
        then
            if cast.racial() then ui.debug("Casting Blood Fury") return true end
        end
        -- Racial - Berserking
        -- berserking,if=fight_remains>185|buff.storm_earth_and_fire.up|fight_remains<20
        if cast.able.racial() and ((unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) > 125)
            or buff.stormEarthAndFire.exists() or (unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) < 20)
            and unit.race() == "Troll")
        then
            if cast.racial() then ui.debug("Casting Berserking") return true end
        end
        -- Racial - Light's Judgment
        -- lights_judgment
        if cast.able.racial() and (unit.race() == "LightforgedDraenei") then
            if cast.racial() then ui.debug("Casting Light's Judgment") return true end
        end
        -- Racial - Fireblood
        -- fireblood,if=fight_remains>125|buff.storm_earth_and_fire.up|fight_remains<20
        if cast.able.racial() and ((unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) > 125)
            or buff.stormEarthAndFire.exists() or (unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) < 20)
            and unit.race() == "DarkIronDwarf")
        then
            if cast.racial() then ui.debug("Casting Fireblood") return true end
        end
        -- Racial - Ancestral Call
        -- ancestral_call,if=fight_remains>185|buff.storm_earth_and_fire.up|fight_remains<20
        if cast.able.racial() and ((unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) > 125)
            or buff.stormEarthAndFire.exists() or (unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) < 20)
            and unit.race() == "MagharOrc")
        then
            if cast.racial() then ui.debug("Casting Ancestral Call") return true end
        end
        -- bag_of_tricks,if=buff.storm_earth_and_fire.down
        -- if cast.able.bagOfTricks() and (not buff.stormEarthAndFire.exists()) then
        --     if cast.bagOfTricks() then ui.debug("") return true end
        -- end
    end
end -- End Action List - CdSef

-- Action List - CdSerenity
actionList.CdSerenity = function()
    -- Invoke Xuen - The White Tiger
    -- invoke_xuen_the_white_tiger,if=!variable.hold_xuen|fight_remains<25
    if cast.able.invokeXuenTheWhiteTiger() and alwaysCdNever("Invoke Xuen")
        and (not var.holdXuen or (unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) < 25))
    then
        if cast.invokeXuenTheWhiteTiger() then ui.debug("Casting Invoke Xuen - The White Tiger") return true end
    end
    -- Heart Essence
    if ui.checked("Use Essence") then
        -- Essence - Guardian of Azeroth
        -- guardian_of_azeroth,if=fight_remains>185|variable.serenity_burst|fight_remains<35
        if cast.able.guardianOfAzeroth() and alwaysCdNever("Guardian of Azeroth") and ((unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) > 185)
            or var.serenityBurst or (unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) < 35))
        then
            if cast.guardianOfAzeroth() then ui.debug("Casting Guardian of Azeroth") return true end
        end
        -- Essence - Worldvein Resonance
        -- worldvein_resonance,if=variable.serenity_burst
        if cast.able.worldveinResonance() and alwaysCdNever("Worldvein Resonance") and (var.serenityBurst) then
            if cast.worldveinResonance() then ui.debug("Casting Worldvein Resonance") return true end
        end
        -- Essence - Blood of the Enemy
        -- blood_of_the_enemy,if=variable.serenity_burst
        if cast.able.bloodOfTheEnemy() and alwaysCdNever("Blood of the Enemy") and (var.serenityBurst) then
            if cast.bloodOfTheEnemy() then ui.debug("Casting Blood of the Enemy") return true end
        end
        -- Essence - Concentrated Flame
        -- concentrated_flame,if=(cooldown.serenity.remains|cooldown.concentrated_flame.charges=2)&!dot.concentrated_flame_burn.remains&(cooldown.rising_sun_kick.remains&cooldown.fists_of_fury.remains|fight_remains<8)
        if cast.able.concentratedFlame() and alwaysCdNever("Concentrated Flame")
            and ((cd.serenity.exists() or charges.concentratedFlame.count() == 2) and not debuff.concentratedFlameBurn.exists()
            and (cd.risingSunKick.exists() and cd.fistsOfFury.exists() or (unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) < 8)))
        then
            if cast.concentratedFlame() then ui.debug("Casting Concentrated Flame") return true end
        end
        -- Essence - The Unbound Force
        -- the_unbound_force
        if cast.able.theUnboundForce() and alwaysCdNever("The Unbound Force") then
            if cast.theUnboundForce() then ui.debug("Casting The Unbound Force") return true end
        end
        -- Essence - Purifying Blast
        -- purifying_blast
        if cast.able.purifyingBlast() and alwaysCdNever("Purifying Blast") then
            if cast.purifyingBlast("best", nil, var.minCount, 8) then ui.debug("Casting Purifying Blast") return true end
        end
        -- Essence - Reaping Flames
        -- reaping_flames,if=target.time_to_pct_20>30|target.health.pct<=20|target.time_to_die<2
        if cast.able.reapingFlames() and alwaysCdNever("Reaping Flames")
            and (unit.ttd(units.dyn5,30) > 30 or unit.hp(units.dyn5) <= 20 or unit.ttd(units.dyn5) < 2)
        then
            if cast.reapingFlames() then ui.debug("Casting Reaping Flames") return true end
        end
        -- Essence - Focused Azerite Beam
        -- focused_azerite_beam
        if cast.able.focusedAzeriteBeam() and alwaysCdNever("Focused Azerite Beam") then
            if cast.focusedAzeriteBeam(nil,"rect",var.minCount,30) then ui.debug("Casting Focused Azerite Beam") return true end
        end
        -- Essence - Memory of Lucid Dreams
        -- memory_of_lucid_dreams,if=energy<40
        if cast.able.memoryOfLucidDreams() and alwaysCdNever("Memory of Lucid Dreams") and (energy < 40) then
            if cast.memoryOfLucidDreams() then ui.debug("Casting Memory of Lucid Dreams") return true end
        end
        -- Essence - Ripple In Space
        -- ripple_in_space
        if cast.able.rippleInSpace() and alwaysCdNever("Ripple In Space") then
            if cast.rippleInSpace() then ui.debug("Casting Ripple In Space") return true end
        end
    end
    -- Racials
    if alwaysCdNever("Racial") then
        -- Racial - Blood Fury
        -- blood_fury,if=fight_remains>125|variable.serenity_burst
        if cast.able.racial() and ((unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) > 125) or var.serenityBurst and unit.race() == "Orc") then
            if cast.racial() then ui.debug("Casting Blood Fury") return true end
        end
        -- Racial - Berserking
        -- berserking,if=fight_remains>185|variable.serenity_burst
        if cast.able.racial() and ((unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) > 185) or var.serenityBurst and unit.race() == "Troll") then
            if cast.racial() then ui.debug("Casting Berserking") return true end
        end
        -- Racial - Arcane Torrent
        -- arcane_torrent,if=chi.max-chi>=1
        if cast.able.racial() and (chiMax - chi >= 1 and unit.race() == "BloodElf") then
            if cast.racial() then ui.debug("Casting Arcane Torrent") return true end
        end
        -- Racial - Light's Judgment
        -- lights_judgment
        if cast.able.racial() and (unit.race() == "LightforgedDraenei") then
            if cast.racial() then ui.debug("Casting Light's Judgment") return true end
        end
        -- Racial - Fireblood
        -- fireblood,if=fight_remains>125|variable.serenity_burst
        if cast.able.racial() and ((unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) > 125) or var.serenityBurst and unit.race() == "DarkIronDwarf") then
            if cast.racial() then ui.debug("Casting Fireblood") return true end
        end
        -- Racial - Ancestral Call
        -- ancestral_call,if=fight_remains>125|variable.serenity_burst
        if cast.able.racial() and ((unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) > 125) or var.serenityBurst and unit.race()== "MagharOrc") then
            if cast.racial() then ui.debug("Casting Ancestral Call") return true end
        end
        -- bag_of_tricks,if=variable.serenity_burst
        -- if cast.able.bagOfTricks() and (var.serenityBurst) then
        --     if cast.bagOfTricks() then ui.debug("") return true end
        -- end
    end
    -- use_item,name=ashvanes_razor_coral
    --TODO: parsing use_item
    -- Touch of Death
    -- touch_of_death,if=target.health.pct<=15
    if cast.able.touchOfDeath() and alwaysCdNever("Touch of Death") and (unit.health("target") < unit.health("player") 
        or (unit.level() > 44 and unit.health("target") >= unit.health("player") and unit.hp("target") < 15))
    then
        if cast.touchOfDeath() then ui.debug("Casting Touch of Death") return true end
    end
    -- Touch of Karma
    -- touch_of_karma,interval=90,pct_health=0.5
    if cast.able.touchOfKarma() and alwaysCdNever("Touch of Karma - CD") then
        if cast.touchOfKarma() then ui.debug("Casting Touch of Karma") return true end
    end
    -- Serenity
    -- serenity,if=cooldown.rising_sun_kick.remains<2|fight_remains<15
    if cast.able.serenity() and alwaysCdNever("Serenity") and (cd.risingSunKick.remain() < 2 or (unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) < 15)) then
        if cast.serenity() then ui.debug("Casting Serenity") return true end
    end
    -- -- bag_of_tricks
    -- if cast.able.bagOfTricks() then
    --     if cast.bagOfTricks() then ui.debug("") return true end
    -- end
end -- End Action List - CdSerenity

-- Action List - Single Target
actionList.SingleTarget = function()
    local startTime = debugprofilestop()
    -- Whirling Dragon Punch
    -- whirling_dragon_punch,if=buff.whirling_dragon_punch.up
    if ui.checked("Whirling Dragon Punch") and cast.able.whirlingDragonPunch() and talent.whirlingDragonPunch and not unit.moving() and not unit.isExplosive("target")
        and buff.whirlingDragonPunch.exists()
    then
        if cast.whirlingDragonPunch("player","aoe",1,8) then ui.debug("Casting Whirling Dragon Punch [ST]") return true end
    end
    -- Energizing Elixir
    -- energizing_elixir,if=chi.max-chi>=2&energy.time_to_max>3|chi.max-chi>=4&(energy.time_to_max>2|!prev_gcd.1.tiger_palm)
    if cast.able.energizingElixir() and (chiMax - chi >= 2 and energyTTM() > 3 or chiMax - chi >= 4 and (energyTTM() > 2 or not cast.last.tigerPalm(1))) then
        if cast.energizingElixir() then ui.debug("Casting Energizing Elixir [ST]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=combo_strike&(buff.dance_of_chiji.up|buff.dance_of_chiji_azerite.up)
    if cast.able.spinningCraneKick() and (not wasLastCombo(spell.spinningCraneKick) and buff.danceOfChiJi.exists())
        and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick(nil,"aoe") then ui.debug("Casting Spinning Crane Kick [ST Dance of Chi-Ji]") return true end
    end
    -- Fists of Fury
    -- fists_of_fury
    if cast.able.fistsOfFury() and cast.timeSinceLast.stormEarthAndFire() > unit.gcd(true) then --and var.useFists then
        if cast.fistsOfFury(nil,"cone",1,8) then ui.debug("Casting Fists of Fury [ST]") return true end
    end
    -- Rising Sun Kick
    -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=cooldown.serenity.remains>1|!talent.serenity.enabled
    if cast.able.risingSunKick() and (cd.serenity.remain() > 1 or not talent.serenity) then
        if cast.risingSunKick() then ui.debug("Casting Rising Sun Kick [ST]") return true end
    end
    -- Rushing Jade Wind
    -- rushing_jade_wind,if=buff.rushing_jade_wind.down&active_enemies>1
    if cast.able.rushingJadeWind() and not buff.rushingJadeWind.exists() and not unit.isExplosive("target")
        and ((ui.mode.rotation == 1 and #enemies.yards8 > 1) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
    then
        if cast.rushingJadeWind() then ui.debug("Casting Rushing Jade Wind [ST]") return true end
    end
    -- Expel Harm
    -- expel_harm,if=chi.max-chi>=1+essence.conflict_and_strife.major
    if cast.able.expelHarm() and (chiMax - chi >= 1 + var.expelCAS) then
        if cast.expelHarm() then ui.debug("Casting Expel Harm [ST]") return true end
    end
    -- Fist of the White Tiger
    -- fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi<3
    if cast.able.fistOfTheWhiteTiger() and (chi < 3) then
        if cast.fistOfTheWhiteTiger() then ui.debug("Casting Fist of the White Tiger [ST]") return true end
    end
    -- Chi Burst
    -- chi_burst,if=chi.max-chi>=1&active_enemies=1|chi.max-chi>=2
    if cast.able.chiBurst() and chiMax - chi >= 1
        and ((ui.mode.rotation == 1 and enemies.yards40r >= ui.value("Chi Burst Min Units"))
            or (ui.mode.rotation == 3 and enemies.yards40r > 1))
    then
        if cast.chiBurst(nil,"rect",1,12) then ui.debug("Casting Chi Burst [ST]") return true end
    end
    -- Chi Wave
    -- chi_wave
    if cast.able.chiWave() then
        if cast.chiWave(nil,"aoe") then ui.debug("Casting Chi Wave [ST]") return true end
    end
    -- Tiger Palm
    -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&chi.max-chi>=2&buff.storm_earth_and_fire.down
    if cast.able.tigerPalm() and (not wasLastCombo(spell.tigerPalm) and chiMax - chi >= 2 and not buff.stormEarthAndFire.exists())
        and cast.timeSinceLast.tigerPalm() > unit.gcd("true")
    then
        if cast.tigerPalm() then ui.debug("Casting Tiger Palm [ST No SEF]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=buff.chi_energy.stack>30-5*active_enemies&combo_strike&buff.storm_earth_and_fire.down&(cooldown.rising_sun_kick.remains>2&cooldown.fists_of_fury.remains>2|cooldown.rising_sun_kick.remains<3&cooldown.fists_of_fury.remains>3&chi>3|cooldown.rising_sun_kick.remains>3&cooldown.fists_of_fury.remains<3&chi>4|chi.max-chi<=1&energy.time_to_max<2)|buff.chi_energy.stack>10&fight_remains<7
    if cast.able.spinningCraneKick() and (buff.chiEnergy.stack() > 30 - 5 * #enemies.yards5 and not wasLastCombo(spell.spinningCraneKick)
        and not buff.stormEarthAndFire.exists() and (cd.risingSunKick.remain() > 2 and cd.fistsOfFury.remain() > 2 or cd.risingSunKick.remain() < 3
        and cd.fistsOfFury.remain() > 3 and chi > 3 or cd.risingSunKick.remain() > 3 and cd.fistsOfFury.remain() < 3 and chi > 4 or chiMax - chi <= 1
        and energyTTM() < 2) or buff.chiEnergy.stack() > 10 and (unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) < 7))
        and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick(nil,"aoe") then ui.debug("Casting Spinning Crane Kick [ST]") return true end
    end
    -- Blackout Kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&(talent.serenity.enabled&cooldown.serenity.remains<3|cooldown.rising_sun_kick.remains>1&cooldown.fists_of_fury.remains>1|cooldown.rising_sun_kick.remains<3&cooldown.fists_of_fury.remains>3&chi>2|cooldown.rising_sun_kick.remains>3&cooldown.fists_of_fury.remains<3&chi>3|chi>5|buff.bok_proc.up)
    if cast.able.blackoutKick() and not wasLastCombo(spell.blackoutKick) and ((talent.serenity and cd.serenity.remain() < 3 or cd.risingSunKick.remain() > 1
        and cd.fistsOfFury.remain() > 1 or cd.risingSunKick.remain() < 3 and cd.fistsOfFury.remain() > 3 and chi > 2 or cd.risingSunKick.remain() > 3
        and cd.fistsOfFury.remain() < 3 and chi > 3 or chi > 5 or buff.blackoutKick.exists()))
        and cast.timeSinceLast.blackoutKick() > unit.gcd("true")
    then
        if cast.blackoutKick() then ui.debug("Casting Blackout Kick [ST High Chi / Free Blackout Kick]") return true end
    end
    -- Tiger Palm
    -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&chi.max-chi>=2
    if cast.able.tigerPalm() and (not wasLastCombo(spell.tigerPalm) and chiMax - chi >= 2)
        and cast.timeSinceLast.tigerPalm() > unit.gcd("true")
    then
        if cast.tigerPalm() then ui.debug("Casting Tiger Palm [ST]") return true end
    end
    -- Flying Serpent Kick
    -- flying_serpent_kick,interrupt=1
    if ui.mode.fsk == 1 and cast.able.flyingSerpentKick() then
        if cast.flyingSerpentKick() then var.castFSK = true ui.debug("Casting Flying Serpent Kick [ST]") return true end
    end
    -- Blackout Kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&cooldown.fists_of_fury.remains<3&chi=2&prev_gcd.1.tiger_palm&energy.time_to_50<1
    if cast.able.blackoutKick() and (not wasLastCombo(spell.blackoutKick) and cd.fistsOfFury.remain() < 3 and chi == 2 and cast.last.tigerPalm(1) and energyTTM(50) < 1)
        and cast.timeSinceLast.blackoutKick() > unit.gcd("true")
    then
        if cast.blackoutKick() then ui.debug("Casting Blackout Kick [ST 2 Chi and Near 50 Energy]") return true end
    end
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&energy.time_to_max<2&(chi.max-chi<=1|prev_gcd.1.tiger_palm)
    if cast.able.blackoutKick() and (not wasLastCombo(spell.blackoutKick) and energyTTM() < 2 and (chiMax - chi <= 1 or cast.last.tigerPalm(1)))
        and cast.timeSinceLast.blackoutKick() > unit.gcd("true")
    then
        if cast.blackoutKick() then ui.debug("Casting Blackout Kick [ST High Energy]") return true end
    end
    -- Debugging
	br.debug.cpu:updateDebug(startTime,"rotation.profile.singleTarget")
end -- End Action List - Single Target

-- Action List - AoE
actionList.AoE = function()
    local startTime = debugprofilestop()
    -- Whirling Dragon Punch
    -- whirling_dragon_punch,if=buff.whirling_dragon_punch.up
    if cast.able.whirlingDragonPunch() and ui.checked("Whirling Dragon Punch") and talent.whirlingDragonPunch and not unit.moving() and not unit.isExplosive("target")
        and buff.whirlingDragonPunch.exists()
    then
        if cast.whirlingDragonPunch("player","aoe") then ui.debug("Casting Whirling Dragon Punch [AOE]") return true end
    end
    -- Energizing Elixir
    -- energizing_elixir,if=chi.max-chi>=2&energy.time_to_max>3|chi.max-chi>=4&(energy.time_to_max>2|!prev_gcd.1.tiger_palm)
    if cast.able.energizingElixir() and (chiMax - chi >= 2 and energyTTM() > 3 or chiMax - chi >= 4 and (energyTTM() > 2 or not cast.last.tigerPalm(1))) then
        if cast.energizingElixir() then ui.debug("Casting Energizing Elixir [AOE]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=combo_strike&(buff.dance_of_chiji.up|buff.dance_of_chiji_azerite.up)
    if cast.able.spinningCraneKick() and (not wasLastCombo(spell.spinningCraneKick) and buff.danceOfChiJi.exists())
        and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick(nil,"aoe") then ui.debug("Casting Spinning Crane Kick [AOE Dance of Chi-Ji]") return true end
    end
    -- Fists of Fury
    -- fists_of_fury,if=energy.time_to_max>execute_time-1|buff.storm_earth_and_fire.remains
    if cast.able.fistsOfFury() and (energyTTM() > var.fofExecute - 1 or buff.stormEarthAndFire.remain()) then
        if cast.fistsOfFury(nil,"cone",1,8) then ui.debug("Casting Fists of Fury [AOE]") return true end
    end
    -- Rising Sun Kick
    -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=(talent.whirling_dragon_punch.enabled&cooldown.rising_sun_kick.duration>cooldown.whirling_dragon_punch.remains+3)&(cooldown.fists_of_fury.remains>3|chi>=5)
    if cast.able.risingSunKick(var.lowestMark) and ((talent.whirlingDragonPunch and var.rskDuration > cd.whirlingDragonPunch.remain() + 3) and (cd.fistsOfFury.remain() > 3 or chi >= 5)) then
        if cast.risingSunKick(var.lowestMark) then ui.debug("Casting Rising Sun Kick [AOE]") return true end
    end
    -- Rushing Jade Wind
    -- rushing_jade_wind,if=buff.rushing_jade_wind.down
    if cast.able.rushingJadeWind() and not buff.rushingJadeWind.exists() and not unit.isExplosive("target") then
        if cast.rushingJadeWind() then ui.debug("Casting Rushing Jade Wind [AOE]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=combo_strike&((chi>3|cooldown.fists_of_fury.remains>6)&(chi>=5|cooldown.fists_of_fury.remains>2)|energy.time_to_max<=3)
    if cast.able.spinningCraneKick() and (not wasLastCombo(spell.spinningCraneKick) and ((chi > 3 or cd.fistsOfFury.remain() > 6) and (chi >= 5 or cd.fistsOfFury.remain() > 2) or energyTTM() <= 3))
        and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick(nil,"aoe") then ui.debug("Casting Spinning Crane Kick [AOE High Chi | High Energy | FoF Soon]") return true end
    end
    -- Expel Harm
    -- expel_harm,if=chi.max-chi>=1+essence.conflict_and_strife.major
    if cast.able.expelHarm() and (chiMax - chi >= 1 + var.expelCAS) then
        if cast.expelHarm() then ui.debug("Casting Expel Harm [AOE]") return true end
    end
    -- Chi Burst
    -- chi_burst,if=chi.max-chi>=1
    if cast.able.chiBurst() and chiMax - chi >= 1
        and ((ui.mode.rotation == 1 and enemies.yards40r >= ui.value("Chi Burst Min Units")) or (ui.mode.rotation == 2 and enemies.yards40r > 0))
    then
        if cast.chiBurst(nil,"rect",1,12) then ui.debug("Casting Chi Burst [AOE]") return true end
    end
    -- Fist of the White Tiger
    -- fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi.max-chi>=3
    if cast.able.fistOfTheWhiteTiger(var.lowestMark) and (chiMax - chi >= 3) then
        if cast.fistOfTheWhiteTiger(var.lowestMark) then ui.debug("Casting Fist of the White Tiger [AOE]") return true end
    end
    -- Tiger Palm
    -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=chi.max-chi>=2&(!talent.hit_combo.enabled|combo_strike)
    if cast.able.tigerPalm(var.lowestMark) and (chiMax - chi >= 2 and (not talent.hitCombo or not wasLastCombo(spell.tigerPalm)))
        and cast.timeSinceLast.tigerPalm() > unit.gcd("true")
    then
        if cast.tigerPalm(var.lowestMark) then ui.debug("Casting Tiger Palm [AOE]") return true end
    end
    -- Chi Wave
    -- chi_wave
    if cast.able.chiWave() then
        if cast.chiWave(nil,"aoe") then ui.debug("Casting Chi Wave [AOE]") return true end
    end
    -- Flying Serpent Kick
    -- flying_serpent_kick,if=buff.bok_proc.down,interrupt=1
    if ui.mode.fsk == 1 and cast.able.flyingSerpentKick() and not buff.blackoutKick.exists() then
        if cast.flyingSerpentKick() then var.castFSK = true ui.debug("Casting Flying Serpent Kick [AOE]") return true end
    end
    -- Blackout kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&(buff.bok_proc.up|talent.hit_combo.enabled&prev_gcd.1.tiger_palm&(chi.max-chi>=1&energy.time_to_50<1|chi=2&cooldown.fists_of_fury.remains<3))
    if cast.able.blackoutKick(var.lowestMark) and (not wasLastCombo(spell.blackoutKick) and (buff.blackoutKick.exists() or talent.hitCombo
        and cast.last.tigerPalm(1) and (chiMax - chi >= 1 and energyTTM(50) < 1 or chi == 2 and cd.fistsOfFury.remain() < 3)))
        and cast.timeSinceLast.blackoutKick() > unit.gcd("true")
    then
        if cast.blackoutKick(var.lowestMark) then ui.debug("Casting Blackout Kick [AOE]") return true end
    end
    -- Debugging
	br.debug.cpu:updateDebug(startTime,"rotation.profile.aoe")
end -- End Action List - AoE

-- Action List - Serenity
actionList.Serenity = function()
    local startTime = debugprofilestop()
    -- Fists of Fury
    -- fists_of_fury,if=buff.serenity.remains<1|active_enemies>1
    if cast.able.fistsOfFury() and (buff.serenity.remain() < 1 or #enemies.yards5 > 1) then
        if cast.fistsOfFury(nil,"cone",1,8) then ui.debug("Casting Fists of Fury [Serenity]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=combo_strike&(active_enemies>2|active_enemies>1&!cooldown.rising_sun_kick.up)
    if cast.able.spinningCraneKick() and (not wasLastCombo(spell.spinningCraneKick) 
        and ((ui.mode.rotation == 1 and (#enemies.yards8 > 2 or (#enemies.yards > 1 and cd.risingSunKick.exists()))) or (ui.mode.rotation == 2 and #enemies.yards8 > 0)))
        and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick(nil,"aoe") then ui.debug("Casting Spinning Crane Kick [Serenity AOE]") return true end
    end
    -- Rising Sun Kick
    -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike
    if cast.able.risingSunKick(var.lowestMark) and not wasLastCombo(spell.risingSunKick) then
        if cast.risingSunKick(var.lowestMark) then ui.debug("Casting Rising Sun Kick [Serenity]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=combo_strike&(buff.dance_of_chiji.up|buff.dance_of_chiji_azerite.up)
    if cast.able.spinningCraneKick() and (not wasLastCombo(spell.spinningCraneKick) and buff.danceOfChiJi.exists())
        and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick() then ui.debug("Casting Spinning Crane Kick [Serenity Dance of Chi-Ji") return true end
    end
    -- Fists of Fury
    -- fists_of_fury,interrupt_if=gcd.remains=0
    if cast.current.fistsOfFury() and (unit.gcd() == 0) then
        SpellStopCasting()
        ui.debug("Canceling Fists of Fury [Serenity]")
        return true
    end
    -- Fist of the White Tiger
    -- fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi<3
    if cast.able.fistOfTheWhiteTiger(var.lowestMark) and (chi < 3) then
        if cast.fistOfTheWhiteTiger(var.lowestMark) then ui.debug("Casting Fist of the White Tiger [Serenity]") return true end
    end
    -- Blackout Kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike|!talent.hit_combo.enabled
    if cast.able.blackoutKick(var.lowestMark) and (not wasLastCombo(spell.blackoutKick) or not talent.hitCombo)
        and cast.timeSinceLast.blackoutKick() > unit.gcd("true")
    then
        if cast.blackoutKick(var.lowestMark) then ui.debug("Casting Blackout Kick [Serenity]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick
    if cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick)
        and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick() then ui.debug("Casting Spinning Crane Kick [Serenity]") return true end
    end

    -- Fists of Fury
    -- fists_of_fury,if=(buff.bloodlust.up&prev_gcd.1.rising_sun_kick)|buff.serenity.remains<1|(active_enemies>1&active_enemies<5)
    if chi >= 3 and cast.able.fistsOfFury() and ((buff.bloodLust.exists() and wasLastCombo(spell.risingSunKick)) or buff.serenity.remain() < 1
        or (#enemies.yards8f > 1 and #enemies.yards8f < 5))
    then
        if cast.fistsOfFury(nil,"cone",1,8) then ui.debug("Casting Fists of Fury [Serenity]") return true end
    end
    -- Fist of the White Tiger
    -- fist_of_the_white_tiger,if=talent.hit_combo.enabled&energy.time_to_max<2&prev_gcd.1.blackout_kick&chi<=2
    if cast.able.fistOfTheWhiteTiger() and talent.hitCombo and energyTTM() < 2 and cast.last.blackoutKick() and chi <= 2 then
        if cast.fistOfTheWhiteTiger() then ui.debug("Casting Fist of the White Tiger [Serenity]") return true end
    end
    -- Tiger Palm
    -- tiger_palm,if=talent.hit_combo.enabled&energy.time_to_max<1&prev_gcd.1.blackout_kick&chi.max-chi>=2
    if cast.able.tigerPalm() and not wasLastCombo(spell.tigerPalm) and talent.hitCombo and energyTTM() < 1 and cast.last.blackoutKick() and chi <= 2
        and cast.timeSinceLast.tigerPalm() > unit.gcd("true")
    then
        if cast.tigerPalm() then ui.debug("Casting Tiger Palm [Serenity]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=combo_strike&(active_enemies>=3|(talent.hit_combo.enabled&prev_gcd.1.blackout_kick)|(active_enemies=2&prev_gcd.1.blackout_kick))
    if chi >= 2 and cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick)
        and (((ui.mode.rotation == 1 and #enemies.yards8 >= 3) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
            or (talent.hitCombo and cast.last.blackoutKick())
            or ((ui.mode.rotation == 1 and #enemies.yards8 == 2) or (ui.mode.rotation == 2 and #enemies.yards8 > 0)) and cast.last.blackoutKick())
        and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick(nil,"aoe") then ui.debug("Casting Spinning Crance Kick [Serenity]") return true end
    end
    -- Blackout Kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains
    if chi >= 1 and cast.able.blackoutKick(var.lowestMark) and not wasLastCombo(spell.blackoutKick)
        and cast.timeSinceLast.blackoutKick() > unit.gcd("true")
    then
        if cast.blackoutKick(var.lowestMark) then ui.debug("Casting Blackout Kick [Serenity]") return true end
    end
    -- Debugging
	br.debug.cpu:updateDebug(startTime,"rotation.profile.serenity")
end -- End Action List - Serenity

-- Action List - Opener
actionList.Opener = function()
    local startTime = debugprofilestop()
    -- Fist of the White Tiger
    -- fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi.max-chi>=3
    if cast.able.fistOfTheWhiteTiger(var.lowestMark) and chiMax - chi >= 3 then
        if cast.fistOfTheWhiteTiger(var.lowestMark) then ui.debug("Casting Fist of the White Tiger [Opener]") return true end
    end
    -- expel_harm,if=talent.chi_burst.enabled&chi.max-chi>=3
    if cast.able.expelHarm() and (talent.chiBurst and chiMax - chi >= 3) then
        if cast.expelHarm() then ui.debug("Casting Expel Harm [Opener Chi Burst") return true end
    end
    -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.recently_rushing_tiger_palm.up*20),if=combo_strike&chi.max-chi>=2
    if cast.able.tigerPalm(var.lowestMark) and (not wasLastCombo(spell.tigerPalm) and chiMax - chi >= 2)
        and cast.timeSinceLast.tigerPalm() > unit.gcd("true")
    then
        if cast.tigerPalm(var.lowestMark) then ui.debug("Casting Tiger Palm [Opener Not Last Combo]") return true end
    end
    -- expel_harm
    if cast.able.expelHarm() then
        if cast.expelHarm() then ui.debug("Casting Expel Harm [Opener]") return true end
    end
    -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.recently_rushing_tiger_palm.up*20),if=chi.max-chi>=2
    if cast.able.tigerPalm(var.lowestMark) and not wasLastCombo(spell.tigerPalm) and (chiMax - chi >= 2)
        and cast.timeSinceLast.tigerPalm() > unit.gcd("true")
    then
        if cast.tigerPalm(var.lowestMark) then ui.debug("Casting Tiger Palm [Opener]") return true end
    end
    -- Debugging
	br.debug.cpu:updateDebug(startTime,"rotation.profile.opener")
end -- End Action List - Opener

-- Action List - Pre-Combat
actionList.PreCombat = function()
    local startTime = debugprofilestop()
    if not unit.inCombat() then
        -- Flask / Crystal
        -- flask
        module.FlaskUp("Agility")
        -- Augmentation
        -- augmentation
        -- Potion
        -- potion
        -- Pull
        if unit.valid("target") then
            if unit.exists("target") and unit.distance("target") < 5 then
                -- -- Chi Burst
                -- -- chi_burst,if=(!talent.serenity.enabled|!talent.fist_of_the_white_tiger.enabled)
                -- if cast.able.chiBurst() and (not talent.serenity or not talent.fistOfTheWhiteTiger)
                --     and ((ui.mode.rotation == 1 and enemies.yards40r >= ui.value("Chi Burst Min Units")) or (ui.mode.rotation == 2 and enemies.yards40r > 0))
                -- then
                --     if cast.chiBurst(nil,"rect",1,12) then ui.debug("") return true end
                -- end
                -- -- Chi Wave
                -- -- chi_wave,if=!talent.energizing_elixer.enabled
                -- if cast.able.chiWave() and not talent.energizingElixir then
                --     if cast.chiWave(nil,"aoe") then ui.debug("") return true end
                -- end
                -- Start Attack
                -- auto_attack
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) then
                    StartAttack("target")
                end
            end
            -- Crackling Jade Lightning
            if ui.checked("Crackling Jade Lightning") and not cast.current.cracklingJadeLightning()
                and not unit.moving() and unit.distance("target") > ui.value("Cancel CJL Range")
            then
                if cast.cracklingJadeLightning() then ui.debug("Casting Crackling Jade Lightning [Pre-Pull]") return true end
            end
            -- Provoke
            if ui.checked("Provoke") and var.solo and unit.exists("target") and unit.distance("target") < 30 then
                if cast.provoke("target") then StartAttack(); ui.debug("Casting Provoke [Pre-Pull]") return true end
            end
        end
    end -- End No Combat Check
    -- Opener
    -- if actionList.Opener() then ui.debug("=== Opener [Action List] ===") return true end
    -- Debugging
	br.debug.cpu:updateDebug(startTime,"rotation.profile.precombat")
end --End Action List - Pre-Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    local startTime = debugprofilestop()
    ------------------
    --- Define API ---
    ------------------
    -- BR API
    buff              = br.player.buff
    cast              = br.player.cast
    cd                = br.player.cd
    charges           = br.player.charges
    chi               = br.player.power.chi.amount()
    chiMax            = br.player.power.chi.max()
    debuff            = br.player.debuff
    enemies           = br.player.enemies
    energy            = br.player.power.energy.amount()
    energyTTM         = br.player.power.energy.ttm
    equiped           = br.player.equiped
    essence           = br.player.essence
    module            = br.player.module
    pet               = br.player.pet
    spell             = br.player.spell
    talent            = br.player.talent
    ui                = br.player.ui
    unit              = br.player.unit
    units             = br.player.units
    use               = br.player.use
    var               = br.player.variables
    
    units.get(5)
    enemies.get(5)
    enemies.get(5,"player",false,true)
    enemies.get(8)
    enemies.get(8,"target")
    enemies.get(8,"player",false,true)
    enemies.get(10)
    enemies.get(20)
    enemies.yards40r = getEnemiesInRect(10,40,false) or 0

    -- Profile Variables
    if var.castFSK          == nil then var.castFSK         = false                 end
    if var.combatTime       == nil then var.combatTime      = _G["getCombatTime"]   end
    if var.comboCounter     == nil then var.comboCounter    = 0                     end
    if var.fixateTarget     == nil then var.fixateTarget    = "player"              end
    if var.lowestMark       == nil then var.lowestMark      = 99                    end
    if var.profileStop      == nil then var.profileStop     = false                 end
    if var.useFists         == nil then var.useFists        = true                  end
    if not unit.inCombat() or var.lastCombo == nil then var.lastCombo = 1822 end --6603 end
    var.expelCAS = 0
    var.fofExecute = 4 - (4 * (GetHaste() / 100))
    var.lowestMark = debuff.markOfTheCrane.lowest(5,"remain") or units.dyn5
    var.rskDuration = 10 - (10 * (GetHaste() / 100))
    var.solo = unit.instance("none") or #br.friend == 1
    
    -- Simc Variables
    -- variable,name=hold_xuen,op=set,value=cooldown.invoke_xuen_the_white_tiger.remains>fight_remains|fight_remains<120&fight_remains>cooldown.serenity.remains&cooldown.serenity.remains>10
    var.holdXuen = cd.invokeXuenTheWhiteTiger.remain() > unit.ttd(units.dyn5) or unit.ttd(unit.dyn5) < 120 and unit.ttd(unit.dyn5) > cd.serenity.remain() and cd.serenity.remain() > 10
    -- variable,name=serenity_burst,op=set,value=cooldown.serenity.remains<1|fight_remains<20
    var.serenityBurst = cd.serenity.exists() and 1 or 0
    -- variable,name=xuen_on_use_trinket,op=set,value=0
    var.xuenOnUseTrinket = 0

    -- Lost Combo
    if buff.hitCombo.stack() < var.comboCounter and unit.inCombat() then
        ui.debug("|cffFF0000HIT COMBO WAS RESET!!!!")
        var.comboCounter = buff.hitCombo.stack()
    else
        var.comboCounter = buff.hitCombo.stack()
    end
    
    -- Crackling Jade Lightning - Cancel
    if cast.current.cracklingJadeLightning() and unit.distance("target") < ui.value("Cancel CJL Range") then
        ui.debug("Canceling Crackling Jade Lightning [Within "..ui.value("Cancel CJL Range").."yrds]")
        MoveBackwardStart()
        MoveBackwardStop()
    end

    -- Flying Serpent Kick - Cancel
    if ui.mode.fsk == 1 and cast.able.flyingSerpentKickEnd() and var.castFSK
        and select(3,GetSpellInfo(spell.flyingSerpentKick)) == 463281
    then
        if cast.flyingSerpentKickEnd() then ui.debug("Casting Flying Serpent Kick [End]") return true end
    end
    
    -- Rushing Jade Wind - Cancel
    if not unit.inCombat() and buff.rushingJadeWind.exists() then
        if buff.rushingJadeWind.cancel() then ui.debug("Canceled Rushing Jade Wind") return true end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or pause() or (unit.mounted() or unit.flying()) or ui.mode.rotation==4 then
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
        -- FIGHT!
        if unit.inCombat() and not var.profileStop and unit.valid(units.dyn5)
            and not cast.current.spinningCraneKick() and not cast.current.fistsOfFury()
            and not cast.current.flyingSerpentKick()
        then
            local startTimeInC = debugprofilestop()
            ------------------
            --- Interrupts ---
            ------------------
            -- Run Action List - Interrupts
            if actionList.Interrupts() then return true end
            ----------------------
            --- Start Rotation ---
            ----------------------
            -- Touch of Death
            if cast.able.touchOfDeath("target") and alwaysCdNever("Touch of Death") and (unit.health("target") < unit.health("player") 
                or (unit.level() > 44 and unit.health("target") >= unit.health("player") and unit.hp("target") < 15))
            then
                if cast.touchOfDeath("target") then ui.debug("Casting Touch of Death - DIE!") return true end
            end
            -- Auto Attack
            -- auto_attack
            if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                StartAttack()
            end
            -- Potion
            -- potion,if=(buff.serenity.up|buff.storm_earth_and_fire.up)&pet.xuen_the_white_tiger.active|fight_remains<=60
            -- if unit.instance("raid") and ui.checked("Potion") and useCDs() and unit.distance("target") < 5 then
            --     if buff.serenity.exists() or buff.stormEarthAndFire.exists() or talent.serenity or buff.bloodLust.exists() or unit.ttd(units.dyn5) <= 60 then
            --         if canUseItem(127844) then
            --             useItem(127844)
            --             ui.debug("Using Potion [127844]")
            --         end
            --         if canUseItem(142117) then
            --             useItem(142117)
            --             ui.debug("Using Potion [142117]")
            --         end
            --     end
            -- end
            -- Call Action List - Serenity
            -- call_action_list,name=serenity,if=buff.serenity.up
            if buff.serenity.exists() then
                if actionList.Serenity() then return true end
            end
            -- Opener 
            -- call_action_list,name=opener,if=time<5&chi<5&!pet.xuen_the_white_tiger.active
            if var.combatTime() < 5 and chi < 5 and not pet.xuenTheWhiteTiger.active() then
                if actionList.Opener() then return true end
            end
            -- Fist of the White Tiger
            -- fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi.max-chi>=3&(energy.time_to_max<1|energy.time_to_max<4&cooldown.fists_of_fury.remains<1.5)
            if cast.able.fistOfTheWhiteTiger(var.lowestMark) and chiMax - chi >= 3 and (energyTTM() < 1 or (energyTTM() < 4 and cd.fistsOfFury.remain() < 1.5)) then
                if cast.fistOfTheWhiteTiger(var.lowestMark) then ui.debug("Casting Fist of the White Tiger [High Energy]") return true end
            end
            -- Expel Harm
            -- expel_harm,if=chi.max-chi>=1+essence.conflict_and_strife.major&(energy.time_to_max<1|cooldown.serenity.remains<2|energy.time_to_max<4&cooldown.fists_of_fury.remains<1.5)
            if cast.able.expelHarm() and chiMax - chi >= var.expelCAS and (energyTTM() < 1 or cd.serenity.remain() < 2 or (energyTTM() < 2 and cd.fistsOfFury.remain() < 1.5)) then
                if cast.expelHarm() then ui.debug("Casting Expel Harm [High Energy]") return true end
            end
            -- Tiger Palm
            -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&chi.max-chi>=2&(energy.time_to_max<1|cooldown.serenity.remains<2|energy.time_to_max<4&cooldown.fists_of_fury.remains<1.5)
            if cast.able.tigerPalm(var.lowestMark) and not wasLastCombo(spell.tigerPalm) and chiMax - chi >= 2 
                and (energyTTM() < 1 or cd.serenity.remain() < 2 or (energyTTM() < 4 and cd.fistsOfFury.remain() < 1.5))
                and cast.timeSinceLast.tigerPalm() > unit.gcd("true")
            then
                if cast.tigerPalm(var.lowestMark) then ui.debug("Casting Tiger Palm [Max Energy / Pre-Serenity]") return true end
            end
            -- Call Action List - CdSef
            -- call_action_list,name=cd_sef,if=!talent.serenity.enabled
            if not talent.serenity then
                if actionList.CdSef() then return true end
            end
            -- Call Action List - CdSerenity
            -- call_action_list,name=cd_serenity,if=talent.serenity.enabled
            if talent.serenity then
                if actionList.CdSerenity() then return true end
            end
            -- Call Action List - Single Target
            -- call_action_list,name=st,if=active_enemies<3
            if ((ui.mode.rotation == 1 and #enemies.yards8 < 3) or (ui.mode.rotation == 3 and #enemies.yards8 > 0)) then
                if actionList.SingleTarget() then return true end
            end
            -- Call Action List - AoE
            -- call_action_list,name=aoe,if=active_enemies>=3
            if ((ui.mode.rotation == 1 and #enemies.yards8 >= 3) or (ui.mode.rotation == 2 and #enemies.yards8 > 0)) then
                if actionList.AoE() then return true end
            end
            -- Debugging
	        br.debug.cpu:updateDebug(startTimeInC,"rotation.profile.unit.inCombat()")
        end -- End Combat Check
    end -- End Pause
    -- Debugging
	br.debug.cpu:updateDebug(startTime,"rotation.profile")
end -- End Timer
local id = 269
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

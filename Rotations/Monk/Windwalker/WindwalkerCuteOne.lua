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
        [1] = { mode = "Fixate", value = 1 , overlay = "SEF Fixate Enabled", tip = "SEF will Fixate on Target.", highlight = 1, icon = br.player.spell.stormEarthAndFireFixate},
        [2] = { mode = "Any", value = 2 , overlay = "SEF Fixate Disabled", tip = "SEF will attack any nearby targets.", highlight = 0, icon = br.player.spell.stormEarthAndFire},
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
            br.ui:createSpinnerWithout(section, "Chi Burst Min Units", 1, 1, 10, 1, "|cffFFFFFFSet to the minumum number of units to cast Chi Burst on.")
            -- Fists of Fury
            br.ui:createSpinnerWithout(section, "Fists of Fury Min Units", 1, 1, 10, 1, "|cffFFFFFFSet to the minumum number of units to cast Fists of Fury on.")
            -- Whirling Dragon Punch
            br.ui:createCheckbox(section, "Whirling Dragon Punch")
            br.ui:createSpinnerWithout(section, "Whirling Dragon Punch Min Units", 1, 1, 10, 1, "|cffFFFFFFSet to the minumum number of units to cast Whirling Dragon Punch on.")
            -- Disable
            br.ui:createCheckbox(section, "Disable")
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
                br.ui:createDropdownWithout(section, "Racial", alwaysCdNever, 1, "|cffFFFFFFWhen to use racial ability")
            end
            -- Basic Trinkets Module
            br.player.module.BasicTrinkets(nil,section)
            -- Covenant Ability
            br.ui:createDropdownWithout(section,"Covenant Ability", alwaysCdNever, 2, "|cffFFFFFFWhen to use Covenant Ability.")
            -- Invoke Xuen - The White Tiger
            br.ui:createDropdownWithout(section, "Invoke Xuen", alwaysCdNever, 2, "|cffFFFFFFWhen to use Invoke Xuen.")
            -- Serenity
            br.ui:createDropdownWithout(section, "Serenity", alwaysCdNever, 2, "|cffFFFFFFWhen to use Serenity.")
            -- Storm, Earth, and Fire
            br.ui:createDropdownWithout(section, "Storm, Earth, and Fire", alwaysCdNever, 1, "|cffFFFFFFWhen to use Storm, Earth, and Fire.")
            -- Touch of Death
            br.ui:createDropdownWithout(section, "Touch of Death", alwaysCdNever, 2, "|cffFFFFFFWhen to use Touch of Death.")
            -- Touch of Karma
            br.ui:createDropdownWithout(section, "Touch of Karma - CD", alwaysCdNever, 1, "|cffFFFFFFWhen to use Touch of Karma.")
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
local covenant
local conduit
local debuff
local enemies
local energy
local energyTTM
local equiped
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
            local thisUnit = (unit.friend("target") and not unit.deadOrGhost("target")) and "target" or "player"
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
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
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
    if cast.able.invokeXuenTheWhiteTiger() and ui.alwaysCdNever("Invoke Xuen") and (not var.holdXuen or (ui.useCDs() and unit.ttd(units.dyn5) < 25)) then
        if cast.invokeXuenTheWhiteTiger() then ui.debug("Casting Invoke Xuen - The White Tiger [CD SEF]") return true end
    end
    -- Racial - Arcane Torrent [Blood Elf]
    -- arcane_torrent,if=chi.max-chi>=1
    if cast.able.racial() and ui.alwaysCdNever("Racial") and (chiMax - chi >= 1 and unit.race() == "BloodElf") then
        if cast.racial() then ui.debug("Casting Arcane Torrent [CD SEF]") return true end
    end
    -- Touch of Death
    -- touch_of_death,if=buff.storm_earth_and_fire.down&pet.xuen_the_white_tiger.active|fight_remains<10|fight_remains>180
    if cast.able.touchOfDeath() and ui.alwaysCdNever("Touch of Death")
        and not buff.stormEarthAndFire.exists() and (pet.xuenTheWhiteTiger.active() or (ui.useCDs() and unit.ttdGroup() < 10) or unit.ttdGroup(5) > 180)
        and (unit.health("target") < unit.health("player") or (unit.level() > 44 and unit.health("target") >= unit.health("player") and unit.hp("target") < 15))
    then
        if cast.touchOfDeath("target") then ui.debug("Casting Touch of Death [CD SEF]") return true end
    end
    -- Weapons of Order
    -- weapons_of_order,if=(raid_event.adds.in>45|raid_event.adds.up)&cooldown.rising_sun_kick.remains<execute_time
    if ui.alwaysCdNever("Covenant Ability") and cast.able.weaponsOfOrder() and cd.risingSunKick.remain() < cast.time.weaponsOfOrder() then
        if cast.weaponsOfOrder("player") then ui.debug("Casting Weapons of Order [CD SEF]") return true end
    end
    -- Faeline Stomp
    -- faeline_stomp,if=combo_strike&(raid_event.adds.in>10|raid_event.adds.up)
    if ui.alwaysCdNever("Covenant Ability") and cast.able.faelineStomp() and not wasLastCombo(spell.faelineStomp) then
        if cast.faelineStomp("player","rect",1,5) then ui.debug("Casting Faeline Stomp [CD SEF]") return true end
    end
    -- Fallen Order
    -- fallen_order,if=raid_event.adds.in>30|raid_event.adds.up
    if ui.alwaysCdNever("Covenant Ability") and cast.able.fallenOrder() then
        if cast.fallenOrder() then ui.debug("Casting Fallen Order [CD SEF]") return true end
    end
    -- Bonedust Brew
    -- bonedust_brew,if=raid_event.adds.in>50|raid_event.adds.up,line_cd=60
    if ui.alwaysCdNever("Bonedust Brew") and cast.able.bonedustBrew() then
        if cast.bonedustBrew() then ui.debug("Casting Bonedust Brew [CD SEF]") return true end
    end
    -- Storm, Earth, and Fire
    if cast.able.stormEarthAndFire() and ui.alwaysCdNever("Storm, Earth, and Fire") then
        -- storm_earth_and_fire,if=cooldown.storm_earth_and_fire.charges=2|fight_remains<20|(raid_event.adds.remains>15|!covenant.kyrian&((raid_event.adds.in>cooldown.storm_earth_and_fire.full_recharge_time|!raid_event.adds.exists)&(cooldown.invoke_xuen_the_white_tiger.remains>cooldown.storm_earth_and_fire.full_recharge_time|variable.hold_xuen))&cooldown.fists_of_fury.remains<=9&chi>=2&cooldown.whirling_dragon_punch.remains<=12)
        if charges.stormEarthAndFire.count() == 2 or (ui.useCDs() and unit.ttdGroup() < 20) or (ui.useAOE(8,2) or not covenant.kyrian.active
            and ((cd.invokeXuenTheWhiteTiger.remains() > charges.stormEarthAndFire.timeTillFull() or var.holdXuen)) and cd.fistsOfFury.remain() <= 9 and chi >= 2 and cd.whirlingDragonPunch.remains() <= 12)
        then
            if cast.stormEarthAndFire() then ui.debug("Casting Storm, Earth, and Fire") var.fixateTarget = "player" return true end
        end
        -- storm_earth_and_fire,if=covenant.kyrian&(buff.weapons_of_order.up|(fight_remains<cooldown.weapons_of_order.remains|cooldown.weapons_of_order.remains>cooldown.storm_earth_and_fire.full_recharge_time)&cooldown.fists_of_fury.remains<=9&chi>=2&cooldown.whirling_dragon_punch.remains<=12)
        if covenant.kyrian.active and (buff.weaponsOfOrder.exists() or (unit.ttdGroup(5) < cd.weaponsOfOrder.remain() or cd.weaponsOfOrder.remain() > charges.stormEarthAndFire.timeTillFull()) and cd.fistsOfFury.remain() <= 9 and chi >= 2 and cd.whirlingDragonPunch.remains() <= 12) then
            if cast.stormEarthAndFire() then ui.debug("Casting Storm, Earth, and Fire [Kyrian]") var.fixateTarget = "player" return true end
        end
    end
    -- Basic Trinkets Module
    -- use_item,name=inscrutable_quantum_device
    -- use_item,name=dreadfire_vessel
    br.player.module.BasicTrinkets()
    -- Touch of Karma
    -- touch_of_karma,if=fight_remains>159|pet.xuen_the_white_tiger.active|variable.hold_xuen
    if cast.able.touchOfKarma() and ui.alwaysCdNever("Touch of Karma - CD") and (unit.ttdGroup(5) > 159 or pet.xuenTheWhiteTiger.active() or var.holdXuen) then
        if cast.touchOfKarma() then ui.debug("Casting Touch of Karma [CD SEF]") return true end
    end
    -- Racials
    if ui.alwaysCdNever("Racial") then
        -- Racial - Blood Fury
        -- blood_fury,if=cooldown.invoke_xuen_the_white_tiger.remains>30|variable.hold_xuen|fight_remains<20
        if cast.able.racial() and unit.race() == "Orc"
            and (cd.invokeXuenTheWhiteTiger.remain() > 30 or var.holdXuen or (ui.useCDs() and unit.ttdGroup() < 20))
        then
            if cast.racial("player") then ui.debug("Casting Blood Fury [CD SEF]") return true end
        end
        -- Racial - Berserking
        -- berserking,if=cooldown.invoke_xuen_the_white_tiger.remains>30|variable.hold_xuen|fight_remains<15
        if cast.able.racial() and unit.race() == "Troll"
            and (cd.invokeXuenTheWhiteTiger.remain() > 30 or var.holdXuen or (ui.useCDs() and unit.ttdGroup() < 15))
        then
            if cast.racial() then ui.debug("Casting Berserking [CD SEF]") return true end
        end
        -- Racial - Light's Judgment
        -- lights_judgment
        if cast.able.racial() and (unit.race() == "LightforgedDraenei") then
            if cast.racial() then ui.debug("Casting Light's Judgment [CD SEF]") return true end
        end
        -- Racial - Fireblood
        -- fireblood,if=cooldown.invoke_xuen_the_white_tiger.remains>30|variable.hold_xuen|fight_remains<10
        if cast.able.racial() and unit.race() == "DarkIronDwarf"
            and (cd.invokeXuenTheWhiteTiger.remain() > 30 or var.holdXuen or (ui.useCDs() and unit.ttdGroup() < 20))
        then
            if cast.racial() then ui.debug("Casting Fireblood [CD SEF]") return true end
        end
        -- Racial - Ancestral Call
        -- ancestral_call,if=fight_remains>185|buff.storm_earth_and_fire.up|fight_remains<20
        if cast.able.racial() and unit.race() == "MagharOrc"
            and (cd.invokeXuenTheWhiteTiger.remain() > 30 or var.holdXuen or (ui.useCDs() and unit.ttdGroup() < 20))
        then
            if cast.racial() then ui.debug("Casting Ancestral Call [CD SEF]") return true end
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
    if cast.able.invokeXuenTheWhiteTiger() and ui.alwaysCdNever("Invoke Xuen")
        and (not var.holdXuen or (ui.useCDs() and unit.ttdGroup() < 25))
    then
        if cast.invokeXuenTheWhiteTiger() then ui.debug("Casting Invoke Xuen - The White Tiger [CD Serenity]") return true end
    end
    -- Basic Trinket Module
    -- use_item,name=inscrutable_quantum_device
    -- use_item,name=dreadfire_vessel
    br.player.module.BasicTrinkets()
    -- Racials
    if ui.alwaysCdNever("Racial") then
        -- Racial - Blood Fury
        -- blood_fury,if=variable.serenity_burst
        if cast.able.racial() and unit.race() == "Orc" and var.serenityBurst then
            if cast.racial("player") then ui.debug("Casting Blood Fury [CD Serenity]") return true end
        end
        -- Racial - Berserking
        -- berserking,if=variable.serenity_burst
        if cast.able.racial() and unit.race() == "Troll" and var.serenityBurst then
            if cast.racial() then ui.debug("Casting Berserking [CD Serenity]") return true end
        end
        -- Racial - Arcane Torrent
        -- arcane_torrent,if=chi.max-chi>=1
        if cast.able.racial() and unit.race() == "BloodElf" and chiMax - chi >= 1 then
            if cast.racial() then ui.debug("Casting Arcane Torrent [CD Serenity]") return true end
        end
        -- Racial - Light's Judgment
        -- lights_judgment
        if cast.able.racial() and (unit.race() == "LightforgedDraenei") then
            if cast.racial() then ui.debug("Casting Light's Judgment [CD Serenity]") return true end
        end
        -- Racial - Fireblood
        -- fireblood,if=variable.serenity_burst
        if cast.able.racial() and unit.race() == "DarkIronDwarf" and var.serenityBurst then
            if cast.racial() then ui.debug("Casting Fireblood [CD Serenity]") return true end
        end
        -- Racial - Ancestral Call
        -- ancestral_call,if=variable.serenity_burst
        if cast.able.racial() and unit.race()== "MagharOrc" and var.serenityBurst then
            if cast.racial() then ui.debug("Casting Ancestral Call [CD Serenity]") return true end
        end
        -- bag_of_tricks,if=variable.serenity_burst
        -- if cast.able.bagOfTricks() and (var.serenityBurst) then
        --     if cast.bagOfTricks() then ui.debug("") return true end
        -- end
    end
    -- Touch of Death
    -- touch_of_death,if=fight_remains>180|pet.xuen_the_white_tiger.active|fight_remains<10
    if cast.able.touchOfDeath() and ui.alwaysCdNever("Touch of Death")
        and (unit.ttdGroup(5) > 180 or pet.xuenTheWhiteTiger.active() or (ui.useCDs() and unit.ttdGroup() < 10))
        and (unit.health("target") < unit.health("player") or (unit.level() > 44 and unit.health("target") >= unit.health("player") and unit.hp("target") < 15))
    then
        if cast.touchOfDeath("target") then ui.debug("Casting Touch of Death [CD Serenity]") return true end
    end
    -- Touch of Karma
    -- touch_of_karma,if=fight_remains>90|pet.xuen_the_white_tiger.active|fight_remains<10
    if cast.able.touchOfKarma() and ui.alwaysCdNever("Touch of Karma - CD")
        and (unit.ttdGroup(5) > 90 or pet.xuenTheWhiteTiger.active() or (ui.useCDs() and unit.ttdGroup() < 10))
    then
        if cast.touchOfKarma() then ui.debug("Casting Touch of Karma [CD Serenity]") return true end
    end
    -- Weapons of Order
    -- weapons_of_order,if=cooldown.rising_sun_kick.remains<execute_time
    if ui.alwaysCdNever("Covenant Ability") and cast.able.weaponsOfOrder() and cd.risingSunKick.remains() < cast.time.weaponsOfOrder() then
        if cast.weaponsOfOrder("player") then ui.debug("Casting Weapons of Order [CD Serenity]") return true end
    end
    -- Faeline Stomp
    -- faeline_stomp
    if ui.alwaysCdNever("Covenant Ability") and cast.able.faelineStomp() then
        if cast.faelineStomp("player","rect",1,5) then ui.debug("Casting Faeline Stomp [CD Serenity]") return true end
    end
    -- Fallen Order
    -- fallen_order
    if ui.alwaysCdNever("Covenant Ability") and cast.able.fallenOrder() then
        if cast.fallenOrder() then ui.debug("Casting Fallen Order [CD Serenity]") return true end
    end
    -- Bonedust Brew
    -- bonedust_brew
    if ui.alwaysCdNever("Bonedust Brew") and cast.able.bonedustBrew() then
        if cast.bonedustBrew() then ui.debug("Casting Bonedust Brew [CD Serenity]") return true end
    end
    -- Serenity
    -- serenity,if=cooldown.rising_sun_kick.remains<2|fight_remains<15
    if cast.able.serenity() and ui.alwaysCdNever("Serenity") and (cd.risingSunKick.remain() < 2 or (ui.useCDs() and unit.ttdGroup(5) < 15)) then
        if cast.serenity() then ui.debug("Casting Serenity") return true end
    end
    -- -- bag_of_tricks
    -- if cast.able.bagOfTricks() then
    --     if cast.bagOfTricks() then ui.debug("") return true end
    -- end
end -- End Action List - CdSerenity

-- Actioin List - Weapons of Order
actionList.WeaponsOfTheOrder = function()
    -- Call Action List - Cd Sef
    -- call_action_list,name=cd_sef,if=!talent.serenity
    if not talent.serenity then
        if actionList.CdSef() then return true end
    end
    -- Call Action List - Cd Serenity
    -- call_action_list,name=cd_serenity,if=talent.serenity
    if talent.serenity then
        if actionList.CdSerenity() then return true end
    end
    -- Energizing Elixir
    -- energizing_elixir,if=chi.max-chi>=2&energy.time_to_max>3
    if cast.able.energizingElixir() and chiMax - chi >= 2 and energyTTM() > 3 then
        if cast.energizingElixir() then ui.debug("Casting Energizing Elixir [Weapons of Order]") return true end
    end
    -- Rising Sun Kick
    -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains
    if cast.able.risingSunKick(var.lowestMark) then
        if cast.risingSunKick(var.lowestMark) then ui.debug("Casting Rising Sun Kick [Weapons of Order]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=combo_strike&buff.dance_of_chiji.up
    if cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick)
        and buff.danceOfChiJi.exists() and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick("player","aoe") then ui.debug("Casting Spinning Crane Kick [Weapons of Order - Chi-Ji]") return true end
    end
    -- Fists of Fury
    -- fists_of_fury,if=active_enemies>=2&buff.weapons_of_order_ww.remains<1
    if cast.able.fistsOfFury() and buff.weaponsOfOrderWW.remains() < 1 then-- and ui.useAOE(8,ui.value("Fists of Fury Min Units")) then
        if cast.fistsOfFury() then ui.debug("Casting Fists of Fury [Weapons of Order - Low WW Buff]") return true end
    end
    -- Whirling Dragon Punch
    -- whirling_dragon_punch,if=active_enemies>=2
    if cast.able.whirlingDragonPunch() and cd.risingSunKick.exists() and cd.fistsOfFury.exists()
        and ui.useAOE(8,ui.value("Whirling Dragon Punch Min Units")) and not unit.moving() and not unit.isExplosive("target")
    then
        if cast.whirlingDragonPunch("player","aoe",1,8) then ui.debug("Casting Whirling Dragon Punch [Weapons of Order - AOE]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=combo_strike&active_enemies>=3&buff.weapons_of_order_ww.up
    if cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick)
        and ui.useAOE(8,3) and buff.weaponsOfOrderWW.exists() and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick("player","aoe") then ui.debug("Casting Spinning Crane Kick [Weapons of Order - WW Buff]") return true end
    end
    -- Blackout Kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&active_enemies<=2
    if cast.able.blackoutKick(var.lowestMark) and not wasLastCombo(spell.blackoutKick) and ui.useST(5,2) then
        if cast.blackoutKick(var.lowestMark) then ui.debug("Casting Blackout Kick [Weapons of Order]") return true end
    end
    -- Whirling Dragon Punch
    -- whirling_dragon_punch
    if cast.able.whirlingDragonPunch() and cd.risingSunKick.exists() and cd.fistsOfFury.exists() then
        if cast.whirlingDragonPunch("player","aoe",1,8) then ui.debug("Casting Whirling Dragon Punch [Weapons of Order]") return true end
    end
    -- Fists of Fury
    -- fists_of_fury,interrupt=1,if=buff.storm_earth_and_fire.up&raid_event.adds.in>cooldown.fists_of_fury.duration*0.6
    if cast.able.fistsOfFury() and buff.stormEarthAndFire.exists() then
        if cast.fistsOfFury() then ui.debug("Casting Fists of Fury [Weapons of Order - SEF]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=buff.chi_energy.stack>30-5*active_enemies
    if cast.able.spinningCraneKick() and buff.chiEnergy.stack() > 30 - 5 * #enemies.yards8
        and not wasLastCombo(spell.spinningCraneKick) and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick("player","aoe") then ui.debug("Casting Spinning Crane Kick [Weapons of Order - Chi Energy]") return true end
    end
    -- Fist of the White Tiger
    -- fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi<3
    if cast.able.fistOfTheWhiteTiger(var.lowestMark) and chi < 3 then
        if cast.fistOfTheWhiteTiger(var.lowestMark) then ui.debug("Casting Fist of the White Tiger [Weapons of Order]") return true end
    end
    -- Expel Harm
    -- expel_harm,if=chi.max-chi>=1
    if cast.able.expelHarm() and (chiMax - chi >= 1) then
        if cast.expelHarm() then ui.debug("Casting Expel Harm [Weapons of Order]") return true end
    end
    -- Chi Burst
    -- chi_burst,if=chi.max-chi>=(1+active_enemies>1)
    if cast.able.chiBurst() and chiMax - chi >= 1 + var.chiBurstMoreThan1 then
        if cast.chiBurst(nil,"rect",1,12) then ui.debug("Casting Chi Burst [Weapons of Order]") return true end
    end
    -- Tiger Palm
    -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.recently_rushing_tiger_palm.up*20),if=(!talent.hit_combo|combo_strike)&chi.max-chi>=2
    if cast.able.tigerPalm(var.lowestMark) and (not talent.hitCombo or not wasLastCombo(spell.tigerPalm)) and chiMax - chi >= 2 then
        if cast.tigerPalm(var.lowestMark) then ui.debug("Casting Tiger Palm [Weapons of Order]") return true end
    end
    -- Chi Wave
    -- chi_wave
    if cast.able.chiWave() then
        if cast.chiWave(nil,"aoe") then ui.debug("Casting Chi Wave [Weapons of Order]") return true end
    end
    -- Blackout Kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=chi>=3|buff.weapons_of_order_ww.up
    if cast.able.blackoutKick(var.lowestMark) and (chi >= 3 or buff.weaponsOfOrderWW.exists()) and not wasLastCombo(spell.blackoutKick) then
        if cast.blackoutKick(var.lowestMark) then ui.debug("Casting Blackout Kick [Weapons of Order - WW Buff]") return true end
    end
    -- Flying Serpent Kick
    -- flying_serpent_kick,interrupt=1
    if ui.mode.fsk == 1 and cast.able.flyingSerpentKick() then
        if cast.flyingSerpentKick() then var.castFSK = true ui.debug("Casting Flying Serpent Kick [Weapons of Order]") return true end
    end
end -- End Action List - Weapons of Order

-- Action List - Serenity
actionList.Serenity = function()
    local startTime = debugprofilestop()
    -- Fists of Fury
    -- fists_of_fury,if=buff.serenity.remains<1
    if cast.able.fistsOfFury() and buff.serenity.remain() < 1 then
        if cast.fistsOfFury() then ui.debug("Casting Fists of Fury [Serenity]") return true end
    end
    -- Basic Trinkets Module
    -- use_item,name=inscrutable_quantum_device
    -- use_item,name=dreadfire_vessel
    br.player.module.BasicTrinkets()
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=combo_strike&(active_enemies>=3|active_enemies>1&!cooldown.rising_sun_kick.up)
    if cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick) 
        and ((ui.mode.rotation == 1 and (#enemies.yards8 >= 3 or (#enemies.yards8 > 1 and cd.risingSunKick.exists()))) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
        and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick(nil,"aoe") then ui.debug("Casting Spinning Crane Kick [Serenity AOE]") return true end
    end
    -- Rising Sun Kick
    -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike
    if cast.able.risingSunKick(var.lowestMark) and not wasLastCombo(spell.risingSunKick) then
        if cast.risingSunKick(var.lowestMark) then ui.debug("Casting Rising Sun Kick [Serenity]") return true end
    end
    -- Fists of Fury
    -- fists_of_fury,if=active_enemies>=3
    if cast.able.fistsOfFury() and ui.useAOE(5,3) then
        if cast.fistsOfFury() then ui.debug("Casting Fists of Fury [Serenity AOE]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=combo_strike&buff.dance_of_chiji.up
    if cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick) and buff.danceOfChiJi.exists()
        and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick() then ui.debug("Casting Spinning Crane Kick [Serenity Dance of Chi-Ji") return true end
    end
    -- Blackout Kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&buff.weapons_of_order_ww.up&cooldown.rising_sun_kick.remains>2
    if cast.able.blackoutKick(var.lowestMark) and not wasLastCombo(spell.blackoutKick) and buff.weaponsOfOrderWW.exists() and cd.risingSunKick.remain() > 2 then
        if cast.blackoutKick(var.lowestMark) then ui.debug("Casting Blackout Kick [Serenity Weapons of Order]") return true end
    end
    -- Fists of Fury
    -- fists_of_fury,interrupt_if=!cooldown.rising_sun_kick.up
    if cast.able.fistsOfFury() and cd.risingSunKick.exists() then
        if cast.fistsOfFury() then ui.debug("Casting Fists of Fury [Serenity RSK on CD]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=combo_strike&debuff.bonedust_brew.up
    if cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick)
        and debuff.bonedustBrew.exists(units.dyn8) and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick() then ui.debug("Casting Spinning Crane Kick [Serenity Bonedust Brew]") return true end
    end
    -- Fist of the White Tiger
    -- fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi<3
    if cast.able.fistOfTheWhiteTiger(var.lowestMark) and (chi < 3) then
        if cast.fistOfTheWhiteTiger(var.lowestMark) then ui.debug("Casting Fist of the White Tiger [Serenity]") return true end
    end
    -- Blackout Kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike|!talent.hit_combo
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
    -- Debugging
	br.debug.cpu:updateDebug(startTime,"rotation.profile.serenity")
end -- End Action List - Serenity

-- Action List - Single Target
actionList.SingleTarget = function()
    local startTime = debugprofilestop()
    -- Whirling Dragon Punch
    -- whirling_dragon_punch,if=raid_event.adds.in>cooldown.whirling_dragon_punch.duration*0.8|raid_event.adds.up
    if ui.checked("Whirling Dragon Punch") and cast.able.whirlingDragonPunch()
        and talent.whirlingDragonPunch and not unit.moving() and not unit.isExplosive("target")
        and ui.useAOE(8,ui.value("Whirling Dragon Punch Min Units")) and buff.whirlingDragonPunch.exists()
    then
        if cast.whirlingDragonPunch("player","aoe",1,8) then ui.debug("Casting Whirling Dragon Punch [ST]") return true end
    end
    -- Energizing Elixir
    -- energizing_elixir,if=chi.max-chi>=2&energy.time_to_max>3|chi.max-chi>=4&(energy.time_to_max>2|!prev_gcd.1.tiger_palm)
    if cast.able.energizingElixir() and (chiMax - chi >= 2 and energyTTM() > 3 or chiMax - chi >= 4 and (energyTTM() > 2 or not cast.last.tigerPalm(1))) then
        if cast.energizingElixir() then ui.debug("Casting Energizing Elixir [ST]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=combo_strike&buff.dance_of_chiji.up&(raid_event.adds.in>buff.dance_of_chiji.remains-2|raid_event.adds.up)
    if cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick) and buff.danceOfChiJi.exists()
        and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick("player","aoe") then ui.debug("Casting Spinning Crane Kick [ST Dance of Chi-Ji]") return true end
    end
    -- Rising Sun Kick
    -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=cooldown.serenity.remains>1|!talent.serenity
    if cast.able.risingSunKick(var.lowestMark) and (cd.serenity.remain() > 1 or not talent.serenity) then
        if cast.risingSunKick(var.lowestMark) then ui.debug("Casting Rising Sun Kick [ST]") return true end
    end
    -- Fists of Fury
    -- fists_of_fury,if=(raid_event.adds.in>cooldown.fists_of_fury.duration*0.8|raid_event.adds.up)&(energy.time_to_max>execute_time-1|chi.max-chi<=1|buff.storm_earth_and_fire.remains<execute_time+1)|fight_remains<execute_time+1
    if cast.able.fistsOfFury() and cast.timeSinceLast.stormEarthAndFire() > unit.gcd(true) --and ui.useAOE(8,ui.value("Fists of Fury Min Units"))
        and (energyTTM() > var.fofExecute - 1 or chiMax - chi <= 1 or buff.stormEarthAndFire.remains() < var.fofExecute + 1 or (ui.useCDs() and units.ttdGroup(5) < var.fofExecute + 1))
    then
        if cast.fistsOfFury() then ui.debug("Casting Fists of Fury [ST]") return true end
    end
    -- Crackling Jade Lightning
    -- crackling_jade_lightning,if=buff.the_emperors_capacitor.stack>19&energy.time_to_max>execute_time-1&cooldown.rising_sun_kick.remains>execute_time|buff.the_emperors_capacitor.stack>14&(cooldown.serenity.remains<5&talent.serenity|cooldown.weapons_of_order.remains<5&covenant.kyrian|fight_remains<5)
    if cast.able.cracklingJadeLightning() and buff.theEmperorsCapacitor.stack() > 19 and energyTTM() > cast.time.cracklingJadeLightning() - 1 and cd.risingSunKick.remains() > cast.time.cracklingJadeLightning()
        or buff.theEmperorsCapacitor.stack() > 14 and (cd.serenity.remains() < 5 and talent.serenity or cd.weaponsOfOrder.remains() < 5 and covenant.kryian.active or (ui.useCDs() and unit.ttdGroup(5) < 5))
    then
        if cast.cracklingJadeLightning() then ui.debug("Casting Crackling Jade Lightning [ST The Emperor's Capacitor]") return true end
    end
    -- Rushing Jade Wind
    -- rushing_jade_wind,if=buff.rushing_jade_wind.down&active_enemies>1
    if cast.able.rushingJadeWind() and not buff.rushingJadeWind.exists() and not unit.isExplosive("target")
        and ((ui.mode.rotation == 1 and #enemies.yards8 > 1) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
    then
        if cast.rushingJadeWind() then ui.debug("Casting Rushing Jade Wind [ST]") return true end
    end
    -- Fist of the White Tiger
    -- fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi<3
    if cast.able.fistOfTheWhiteTiger(var.lowestMark) and (chi < 3) then
        if cast.fistOfTheWhiteTiger(var.lowestMark) then ui.debug("Casting Fist of the White Tiger [ST]") return true end
    end
    -- Expel Harm
    -- expel_harm,if=chi.max-chi>=1
    if cast.able.expelHarm() and (chiMax - chi >= 1) then
        if cast.expelHarm() then ui.debug("Casting Expel Harm [ST]") return true end
    end
    -- Chi Burst
    -- chi_burst,if=chi.max-chi>=1&active_enemies=1&raid_event.adds.in>20|chi.max-chi>=2&active_enemies>=2
    if cast.able.chiBurst() and (chiMax - chi >= 1 and ((ui.mode.rotation == 1 and enemies.yards40r == 1) or (ui.mode.rotation == 3 and enemies.yards40r > 0)))
        or (chiMax - chi >= 2 and ((ui.mode.rotation == 1 and enemies.yards40r >= ui.value("Chi Burst Min Units")) or (ui.mode.rotation == 3 and enemies.yards40r > 1)))
    then
        if cast.chiBurst("player","rect",1,12) then ui.debug("Casting Chi Burst [ST]") return true end
    end
    -- Chi Wave
    -- chi_wave
    if cast.able.chiWave() then
        if cast.chiWave("player","aoe") then ui.debug("Casting Chi Wave [ST]") return true end
    end
    -- Tiger Palm
    -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.recently_rushing_tiger_palm.up*20),if=combo_strike&chi.max-chi>=2&buff.storm_earth_and_fire.down
    if cast.able.tigerPalm(var.lowestMark) and (not wasLastCombo(spell.tigerPalm) and chiMax - chi >= 2 and not buff.stormEarthAndFire.exists())
        and cast.timeSinceLast.tigerPalm() > unit.gcd("true")
    then
        if cast.tigerPalm(var.lowestMark) then ui.debug("Casting Tiger Palm [ST No SEF]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=buff.chi_energy.stack>30-5*active_enemies&buff.storm_earth_and_fire.down&(cooldown.rising_sun_kick.remains>2&cooldown.fists_of_fury.remains>2|cooldown.rising_sun_kick.remains<3&cooldown.fists_of_fury.remains>3&chi>3|cooldown.rising_sun_kick.remains>3&cooldown.fists_of_fury.remains<3&chi>4|chi.max-chi<=1&energy.time_to_max<2)|buff.chi_energy.stack>10&fight_remains<7
    if cast.able.spinningCraneKick() and (buff.chiEnergy.stack() > 30 - 5 * #enemies.yards5 --and not wasLastCombo(spell.spinningCraneKick)
        and not buff.stormEarthAndFire.exists() and (((cd.risingSunKick.remain() > 2 and cd.fistsOfFury.remain() > 2) or (cd.risingSunKick.remain() < 3
        and cd.fistsOfFury.remain() > 3 and chi > 3) or (cd.risingSunKick.remain() > 3 and cd.fistsOfFury.remain() < 3 and chi > 4) or (chiMax - chi <= 1
        and energyTTM() < 2)) or buff.chiEnergy.stack() > 10) and (unit.isBoss(units.dyn5) and unit.ttd(units.dyn5) < 7))
        and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick(nil,"aoe") then ui.debug("Casting Spinning Crane Kick [ST]") return true end
    end
    -- Blackout Kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&(talent.serenity&cooldown.serenity.remains<3|cooldown.rising_sun_kick.remains>1&cooldown.fists_of_fury.remains>1|cooldown.rising_sun_kick.remains<3&cooldown.fists_of_fury.remains>3&chi>2|cooldown.rising_sun_kick.remains>3&cooldown.fists_of_fury.remains<3&chi>3|chi>5|buff.bok_proc.up)
    if cast.able.blackoutKick(var.lowestMark) and not wasLastCombo(spell.blackoutKick) and ((talent.serenity and cd.serenity.remain() < 3 or cd.risingSunKick.remain() > 1
        and cd.fistsOfFury.remain() > 1 or cd.risingSunKick.remain() < 3 and cd.fistsOfFury.remain() > 3 and chi > 2 or cd.risingSunKick.remain() > 3
        and cd.fistsOfFury.remain() < 3 and chi > 3 or chi > 5 or buff.blackoutKick.exists()))
        and cast.timeSinceLast.blackoutKick() > unit.gcd("true")
    then
        if cast.blackoutKick(var.lowestMark) then ui.debug("Casting Blackout Kick [ST High Chi / Free Blackout Kick]") return true end
    end
    -- Tiger Palm
    -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.recently_rushing_tiger_palm.up*20),if=combo_strike&chi.max-chi>=2
    if cast.able.tigerPalm(var.lowestMark) and (not wasLastCombo(spell.tigerPalm) and chiMax - chi >= 2)
        and cast.timeSinceLast.tigerPalm() > unit.gcd("true")
    then
        if cast.tigerPalm(var.lowestMark) then ui.debug("Casting Tiger Palm [ST]") return true end
    end
    -- Flying Serpent Kick
    -- flying_serpent_kick,interrupt=1
    if ui.mode.fsk == 1 and cast.able.flyingSerpentKick() then
        if cast.flyingSerpentKick() then var.castFSK = true ui.debug("Casting Flying Serpent Kick [ST]") return true end
    end
    -- Blackout Kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&cooldown.fists_of_fury.remains<3&chi=2&prev_gcd.1.tiger_palm&energy.time_to_50<1
    if cast.able.blackoutKick(var.lowestMark) and (not wasLastCombo(spell.blackoutKick) and cd.fistsOfFury.remain() < 3 and (chi == 2 or (chi == 3 and unit.level() < 17)) and cast.last.tigerPalm(1) and energyTTM(50) < 1)
        and cast.timeSinceLast.blackoutKick() > unit.gcd("true")
    then
        if cast.blackoutKick(var.lowestMark) then ui.debug("Casting Blackout Kick [ST 2 Chi and Near 50 Energy]") return true end
    end
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&energy.time_to_max<2&(chi.max-chi<=1|prev_gcd.1.tiger_palm)
    if cast.able.blackoutKick(var.lowestMark) and (not wasLastCombo(spell.blackoutKick) and energyTTM() < 2 and (chiMax - chi <= 1 or cast.last.tigerPalm(1)))
        and cast.timeSinceLast.blackoutKick() > unit.gcd("true")
    then
        if cast.blackoutKick(var.lowestMark) then ui.debug("Casting Blackout Kick [ST High Energy]") return true end
    end
    -- Debugging
	br.debug.cpu:updateDebug(startTime,"rotation.profile.singleTarget")
end -- End Action List - Single Target

-- Action List - AoE
actionList.AoE = function()
    local startTime = debugprofilestop()
    -- Whirling Dragon Punch
    -- whirling_dragon_punch
    if cast.able.whirlingDragonPunch() and ui.checked("Whirling Dragon Punch") 
        and talent.whirlingDragonPunch and not unit.moving() and not unit.isExplosive("target")
        and ui.useAOE(8,ui.value("Whirling Dragon Punch Min Units")) and buff.whirlingDragonPunch.exists()
    then
        if cast.whirlingDragonPunch("player","aoe",1,8) then ui.debug("Casting Whirling Dragon Punch [AOE]") return true end
    end
    -- Energizing Elixir
    -- energizing_elixir,if=chi.max-chi>=2&energy.time_to_max>2|chi.max-chi>=4
    if cast.able.energizingElixir() and ((chiMax - chi >= 2 and energyTTM() > 2) or chiMax - chi >= 4) then
        if cast.energizingElixir() then ui.debug("Casting Energizing Elixir [AOE]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=combo_strike&(buff.dance_of_chiji.up|debuff.bonedust_brew.up)
    if cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick) and (buff.danceOfChiJi.exists() or debuff.bonedustBrew.exists(units.dyn8))
        and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick(nil,"aoe") then ui.debug("Casting Spinning Crane Kick [AOE Dance of Chi-Ji / Bonedust Brew]") return true end
    end
    -- Fists of Fury
    -- fists_of_fury,if=energy.time_to_max>execute_time|chi.max-chi<=1
    if cast.able.fistsOfFury() --and ui.useAOE(8,ui.value("Fists of Fury Min Units"))
        and (energyTTM() > var.fofExecute or chiMax - chi <= 1)
    then
        if cast.fistsOfFury() then ui.debug("Casting Fists of Fury [AOE]") return true end
    end
    -- Rising Sun Kick
    -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=(talent.whirling_dragon_punch&cooldown.rising_sun_kick.duration>cooldown.whirling_dragon_punch.remains+4)&(cooldown.fists_of_fury.remains>3|chi>=5)
    if cast.able.risingSunKick(var.lowestMark) and ((talent.whirlingDragonPunch and var.rskDuration > cd.whirlingDragonPunch.remain() + 4) and (cd.fistsOfFury.remain() > 3 or chi >= 5)) then
        if cast.risingSunKick(var.lowestMark) then ui.debug("Casting Rising Sun Kick [AOE]") return true end
    end
    -- Rushing Jade Wind
    -- rushing_jade_wind,if=buff.rushing_jade_wind.down
    if cast.able.rushingJadeWind() and not buff.rushingJadeWind.exists() and not unit.isExplosive("target") then
        if cast.rushingJadeWind() then ui.debug("Casting Rushing Jade Wind [AOE]") return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=combo_strike&((cooldown.bonedust_brew.remains>2&(chi>3|cooldown.fists_of_fury.remains>6)&(chi>=5|cooldown.fists_of_fury.remains>2))|energy.time_to_max<=3)
    if cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick)
        and ((cd.bonedustBrew.remains() > 2 and (chi > 3 or cd.fistsOfFury.remain() > 6) and (chi >= 5 or cd.fistsOfFury.remain() > 2)) or energyTTM() <= 3)
        and cast.timeSinceLast.spinningCraneKick() > unit.gcd("true")
    then
        if cast.spinningCraneKick(nil,"aoe") then ui.debug("Casting Spinning Crane Kick [AOE High Chi | High Energy | FoF Soon]") return true end
    end
    -- Expel Harm
    -- expel_harm,if=chi.max-chi>=1
    if cast.able.expelHarm() and (chiMax - chi >= 1) then
        if cast.expelHarm() then ui.debug("Casting Expel Harm [AOE]") return true end
    end
    -- Fist of the White Tiger
    -- fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi.max-chi>=3
    if cast.able.fistOfTheWhiteTiger(var.lowestMark) and (chiMax - chi >= 3) then
        if cast.fistOfTheWhiteTiger(var.lowestMark) then ui.debug("Casting Fist of the White Tiger [AOE]") return true end
    end
    -- Chi Burst
    -- chi_burst,if=chi.max-chi>=2
    if cast.able.chiBurst() and chiMax - chi >= 2
        and ((ui.mode.rotation == 1 and enemies.yards40r >= ui.value("Chi Burst Min Units")) or (ui.mode.rotation == 2 and enemies.yards40r > 0))
    then
        if cast.chiBurst("player","rect",1,12) then ui.debug("Casting Chi Burst [AOE]") return true end
    end
    -- Crackling Jade Lightning
    -- crackling_jade_lightning,if=buff.the_emperors_capacitor.stack>19&energy.time_to_max>execute_time-1&cooldown.fists_of_fury.remains>execute_time
    if cast.able.cracklingJadeLightning() and buff.theEmperorsCapacitor.stack() > 19 and energyTTM() > cast.time.cracklingJadeLightninig() and cd.fistsOfFury.remains() > cast.time.cracklingJadeLightning() then
        if cast.cracklingJadeLightning() then ui.debug("Casting Crackling Jade Lightning [AOE The Emperor's Capacitor]") return true end
    end
    -- Tiger Palm
    -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.recently_rushing_tiger_palm.up*20),if=chi.max-chi>=2&(!talent.hit_combo|combo_strike)
    if cast.able.tigerPalm(var.lowestMark) and (chiMax - chi >= 2 and (not talent.hitCombo or not wasLastCombo(spell.tigerPalm)))
        and cast.timeSinceLast.tigerPalm() > unit.gcd("true")
    then
        if cast.tigerPalm(var.lowestMark) then ui.debug("Casting Tiger Palm [AOE]") return true end
    end
    -- Chi Wave
    -- chi_wave,if=combo_strike
    if cast.able.chiWave() and not wasLastCombo(spell.chiWave) then
        if cast.chiWave("player","aoe") then ui.debug("Casting Chi Wave [AOE]") return true end
    end
    -- Flying Serpent Kick
    -- flying_serpent_kick,if=buff.bok_proc.down,interrupt=1
    if ui.mode.fsk == 1 and cast.able.flyingSerpentKick() and not buff.blackoutKick.exists() then
        if cast.flyingSerpentKick() then var.castFSK = true ui.debug("Casting Flying Serpent Kick [AOE]") return true end
    end
    -- Blackout kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&(buff.bok_proc.up|talent.hit_combo&prev_gcd.1.tiger_palm&chi=2&cooldown.fists_of_fury.remains<3|chi.max-chi<=1&prev_gcd.1.spinning_crane_kick&energy.time_to_max<3)
    if cast.able.blackoutKick(var.lowestMark) and (not wasLastCombo(spell.blackoutKick) and (buff.blackoutKick.exists() or talent.hitCombo
        and cast.last.tigerPalm(1) and (chi == 2 or (chi == 3 and unit.level() < 17)) and cd.fistsOfFury.remain() < 3 or chiMax - chi <= 1 and wasLastCombo(spell.spinningCraneKick) and energyTTM() < 3))
        and cast.timeSinceLast.blackoutKick() > unit.gcd("true")
    then
        if cast.blackoutKick(var.lowestMark) then ui.debug("Casting Blackout Kick [AOE]") return true end
    end
    -- Debugging
	br.debug.cpu:updateDebug(startTime,"rotation.profile.aoe")
end -- End Action List - AoE

-- Action List - Opener
actionList.Opener = function()
    local startTime = debugprofilestop()
    -- Fist of the White Tiger
    -- fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi.max-chi>=3
    if cast.able.fistOfTheWhiteTiger(var.lowestMark) and chiMax - chi >= 3 then
        if cast.fistOfTheWhiteTiger(var.lowestMark) then ui.debug("Casting Fist of the White Tiger [Opener]") return true end
    end
    -- Expel Harm
    -- expel_harm,if=talent.chi_burst.enabled&chi.max-chi>=3
    if cast.able.expelHarm() and (talent.chiBurst and chiMax - chi >= 3) then
        if cast.expelHarm() then ui.debug("Casting Expel Harm [Opener Chi Burst") return true end
    end
    -- Tiger Palm
    -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.recently_rushing_tiger_palm.up*20),if=combo_strike&chi.max-chi>=2
    if cast.able.tigerPalm(var.lowestMark) and (not wasLastCombo(spell.tigerPalm) and chiMax - chi >= 2)
        and cast.timeSinceLast.tigerPalm() > unit.gcd("true")
    then
        if cast.tigerPalm(var.lowestMark) then ui.debug("Casting Tiger Palm [Opener Not Last Combo]") return true end
    end
    -- Chi Wave
    -- chi_wave,if=chi.max-chi=2
    if cast.able.chiWave() and chiMax - chi == 2 then
        if cast.chiWave() then ui.debug("Casting Chi Wave [Opener]") return true end
    end
    -- Expel Harm
    -- expel_harm
    if cast.able.expelHarm() then
        if cast.expelHarm() then ui.debug("Casting Expel Harm [Opener]") return true end
    end
    -- Tiger Palm
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
    conduit           = br.player.conduit
    covenant          = br.player.covenant
    debuff            = br.player.debuff
    enemies           = br.player.enemies
    energy            = br.player.power.energy.amount()
    energyTTM         = br.player.power.energy.ttm
    equiped           = br.player.equiped
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
    if not unit.inCombat() or var.lastCombo == nil then var.lastCombo = 1822 end --6603 end
    var.chiBurstMoreThan1 = enemies.yards40r >= 1 and 1 or 0
    var.fofExecute = 4 - (4 * (GetHaste() / 100))
    var.lowestMark = debuff.markOfTheCrane.lowest(5,"remain") or units.dyn5
    var.rskDuration = 10 - (10 * (GetHaste() / 100))
    var.solo = unit.instance("none") or #br.friend == 1
    
    -- Simc Variables
    -- variable,name=hold_xuen,op=set,value=cooldown.invoke_xuen_the_white_tiger.remains>fight_remains|fight_remains<120&fight_remains>cooldown.serenity.remains&cooldown.serenity.remains>10
    var.holdXuen = cd.invokeXuenTheWhiteTiger.remain() > unit.ttd(units.dyn5) or unit.ttd(unit.dyn5) < 120 and unit.ttd(unit.dyn5) > cd.serenity.remain() and cd.serenity.remain() > 10
    -- variable,name=serenity_burst,op=set,value=cooldown.serenity.remains<1|pet.xuen_the_white_tiger.active&cooldown.serenity.remains>30|fight_remains<20
    var.serenityBurst = cd.serenity.remains() < 1 or (pet.xuenTheWhiteTiger.active() and cd.serenity.remains() > 30) or (ui.useCDs() and unit.ttdGroup() < 20)
    -- variable,name=xuen_on_use_trinket,op=set,value=0
    var.xuenOnUseTrinket = 0

    -- Lost Combo
    if buff.hitCombo.stack() < var.comboCounter and unit.inCombat() then
        ui.debug("|cffFF0000HIT COMBO WAS RESET!!!!")
        var.comboCounter = buff.hitCombo.stack()
    else
        var.comboCounter = buff.hitCombo.stack()
    end

    -- Fixate - Storm, Earth, and Fire
    if ui.mode.sef == 1 and not talent.serenity and cast.able.stormEarthAndFireFixate() and buff.stormEarthAndFire.exists()
        and cast.timeSinceLast.stormEarthAndFire() > unit.gcd("true") and not cast.current.fistsOfFury() and not unit.isUnit(var.fixateTarget,"target")
    then
        if cast.stormEarthAndFireFixate("target") then var.fixateTarget = "target" ui.debug("Casting SEF [Fixate]") return true end
    end
    
    -- Crackling Jade Lightning - Cancel
    if cast.current.cracklingJadeLightning() and unit.distance("target") < ui.value("Cancel CJL Range") then
        if cast.cancel.cracklingJadeLightning() then ui.debug("Canceling Crackling Jade Lightning [Within "..ui.value("Cancel CJL Range").."yrds]") return true end
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
            if cast.able.touchOfDeath("target") and ui.alwaysCdNever("Touch of Death") and (unit.health("target") < unit.health("player") 
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
            -- Call Action List - Weapons of Order
            -- call_action_list,name=weapons_of_order,if=buff.weapons_of_order.up
            if buff.weaponsOfOrder.exists() then
                if actionList.WeaponsOfTheOrder() then return true end
            end
            -- Opener
            -- call_action_list,name=opener,if=time<4&chi<5&!pet.xuen_the_white_tiger.active
            if var.combatTime() < 4 and chi < 5 and not pet.xuenTheWhiteTiger.active() then
                if actionList.Opener() then return true end
            end
            -- Fist of the White Tiger
            -- fist_of_the_white_tiger,target_if=min:debuff.mark_of_the_crane.remains,if=chi.max-chi>=3&(energy.time_to_max<1|energy.time_to_max<4&cooldown.fists_of_fury.remains<1.5|cooldown.weapons_of_order.remains<2)
            if cast.able.fistOfTheWhiteTiger(var.lowestMark) and chiMax - chi >= 3 and (energyTTM() < 1 or (energyTTM() < 4 and cd.fistsOfFury.remain() < 1.5) or cd.weaponsOfOrder.remains() < 2) then
                if cast.fistOfTheWhiteTiger(var.lowestMark) then ui.debug("Casting Fist of the White Tiger [High Energy]") return true end
            end
            -- Expel Harm
            -- expel_harm,if=chi.max-chi>=1&(energy.time_to_max<1|cooldown.serenity.remains<2|energy.time_to_max<4&cooldown.fists_of_fury.remains<1.5|cooldown.weapons_of_order.remains<2)
            if cast.able.expelHarm() and chiMax - chi >= 1 and (energyTTM() < 1 or cd.serenity.remain() < 2 or (energyTTM() < 2 and cd.fistsOfFury.remain() < 1.5) or cd.weaponsOfOrder.remains() < 2) then
                if cast.expelHarm() then ui.debug("Casting Expel Harm [High Energy]") return true end
            end
            -- Tiger Palm
            -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=combo_strike&chi.max-chi>=2&(energy.time_to_max<1|cooldown.serenity.remains<2|energy.time_to_max<4&cooldown.fists_of_fury.remains<1.5|cooldown.weapons_of_order.remains<2)
            if cast.able.tigerPalm(var.lowestMark) and not wasLastCombo(spell.tigerPalm) and chiMax - chi >= 2 
                and (energyTTM() < 1 or cd.serenity.remain() < 2 or (energyTTM() < 4 and cd.fistsOfFury.remain() < 1.5) or cd.weaponsOfOrder.remains() < 2)
                and cast.timeSinceLast.tigerPalm() > unit.gcd("true")
            then
                if cast.tigerPalm(var.lowestMark) then ui.debug("Casting Tiger Palm [Max Energy / Pre-Serenity]") return true end
            end
            -- Call Action List - CdSef
            -- call_action_list,name=cd_sef,if=!talent.serenity
            if not talent.serenity then
                if actionList.CdSef() then return true end
            end
            -- Call Action List - CdSerenity
            -- call_action_list,name=cd_serenity,if=talent.serenity
            if talent.serenity then
                if actionList.CdSerenity() then return true end
            end
            -- Call Action List - Single Target
            -- call_action_list,name=st,if=active_enemies<3
            if ui.useST(8,3) then
                if actionList.SingleTarget() then return true end
            end
            -- Call Action List - AoE
            -- call_action_list,name=aoe,if=active_enemies>=3
            if ui.useAOE(8,3) then
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

local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.spinningCraneKick },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.spinningCraneKick },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.tigerPalm },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.effuse}
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
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dampenHarm },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dampenHarm }
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.spearHandStrike },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.spearHandStrike }
    };
    CreateButton("Interrupt",4,0)
    -- Storm, Earth, and Fire Button
    SEFModes = {
        [1] = { mode = "Boss", value = 1 , overlay = "Auto SEF on Boss Only", tip = "Will cast Storm, Earth and Fire on Bosses only.", highlight = 1, icon = br.player.spell.stormEarthAndFireFixate},
        [2] = { mode = "On", value = 2 , overlay = "Auto SEF Enabled", tip = "Will cast Storm, Earth, and Fire.", highlight = 0, icon = br.player.spell.stormEarthAndFire},
        [3] = { mode = "Off", value = 3 , overlay = "Auto SEF Disabled", tip = "Will NOT cast Storm, Earth, and Fire.", highlight = 0, icon = br.player.spell.stormEarthAndFireFixate}

    };
    CreateButton("SEF",5,0)
    -- Flying Serpent Kick Button
    FSKModes = {
        [1] = { mode = "On", value = 2 , overlay = "Auto FSK Enabled", tip = "Will cast Flying Serpent Kick.", highlight = 1, icon = br.player.spell.flyingSerpentKick},
        [2] = { mode = "Off", value = 1 , overlay = "Auto FSK Disabled", tip = "Will NOT cast Flying Serpent Kick.", highlight = 0, icon = br.player.spell.flyingSerpentKickEnd}
    };
    CreateButton("FSK",6,0)
    -- Fists of Fury Button 
    FOFModes = {
        [1] = { mode = "On", value = 2 , overlay = "FoF Enabled", tip = "Will cast Fists Of Fury.", highlight = 1, icon = br.player.spell.fistsOfFury},
        [2] = { mode = "Off", value = 1 , overlay = "FoF Disabled", tip = "Will NOT cast Fists Of Fury.", highlight = 0, icon = br.player.spell.fistsOfFury}
    };
    CreateButton("FOF",7,0)
    -- Opener
    OpenerModes = {
        [1] = { mode = "On", value = 2 , overlay = "Opener Enabled", tip = "Will use Opener.", highlight = 1, icon = br.player.spell.fistOfTheWhiteTiger},
        [2] = { mode = "Off", value = 1 , overlay = "Opener Disabled", tip = "Will NOT use Opener.", highlight = 0, icon = br.player.spell.fistOfTheWhiteTiger}
    };
    CreateButton("Opener",8,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Opener
            -- br.ui:createCheckbox(section, "Opener")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- CJL OOR
            br.ui:createSpinner(section,"CJL OOR", 100,  5,  160,  5, "Cast CJL when 0 enemies in 8 yds when at X Energy")
            -- Cancel CJL OOR
            br.ui:createSpinnerWithout(section,"CJL OOR Cancel", 30,  5,  160,  5, "Cancel CJL OOR when under X Energy")
            -- Chi Burst 
            br.ui:createSpinnerWithout(section,"Chi Burst Min Units",1,1,10,1,"|cffFFFFFFSet to the minumum number of units to cast Chi Burst on.")
            -- FoF Targets
            br.ui:createSpinnerWithout(section, "Fists of Fury Targets", 1, 1, 10, 1, "|cffFFFFFFSet to the minumum number of units to cast Fists of Fury on.")
            -- Provoke
            br.ui:createCheckbox(section, "Provoke", "Will aid in grabbing mobs when solo.")
            -- Roll
            br.ui:createCheckbox(section, "Roll")
            -- Spread Mark Cap
            br.ui:createSpinnerWithout(section, "Spread Mark Cap", 5, 0, 10, 1, "|cffFFFFFFSet to limit Mark of the Crane Buffs, 0 for unlimited. Min: 0 / Max: 10 / Interval: 1")
            -- Tiger's Lust
            br.ui:createCheckbox(section, "Tiger's Lust")
            -- Whirling Dragon Punch
            br.ui:createCheckbox(section, "Whirling Dragon Punch")
            -- Whirling Dragon Punch Targets
            br.ui:createSpinnerWithout(section, "Whirling Dragon Punch Targets", 1, 1, 10, 1, "|cffFFFFFFSet to the minumum number of units to cast Whirling Dragon Punch on.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Flask / Crystal
            br.ui:createCheckbox(section,"Flask / Crystal")
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Touch of the Void
            br.ui:createCheckbox(section,"Touch of the Void")
            -- Trinkets
            br.ui:createDropdownWithout(section,"Trinket 1", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Trinket 1.")
            br.ui:createDropdownWithout(section,"Trinket 2", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Trinket 2.")
            -- Heart Essence
            br.ui:createCheckbox(section,"Use Essence")
            -- Energizing Elixir
            br.ui:createDropdownWithout(section,"Energizing Elixir", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Energizing Elixir.")
            -- SEF Timer/Behavior
            br.ui:createSpinnerWithout(section, "SEF Targets", 3, 1, 5, 1, "|cffFFFFFFDesired enemies to cast SEF on.")
            br.ui:createSpinnerWithout(section, "SEF Timer",  0.3,  0,  1,  0.05,  "|cffFFFFFFDesired time in seconds to resume rotation after casting SEF so clones can get into place. This value changes based on different factors so requires some testing to find what works best for you.")
            br.ui:createDropdownWithout(section, "SEF Behavior", {"|cff00FF00Fixate","|cffFFFF00Go Ham!"}, 1, "|cffFFFFFFStorm, Earth, and Fire Behavior.")
            -- Serenity
            br.ui:createDropdownWithout(section,"Serenity", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Serenity.")
            -- Touch of Death
            br.ui:createCheckbox(section,"Touch of Death")
            -- Xuen
            br.ui:createCheckbox(section,"Xuen")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
         section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Detox
            br.ui:createCheckbox(section,"Detox")
            -- Diffuse Magic/Dampen Harm
            br.ui:createSpinner(section, "Diffuse/Dampen",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Effuse
            br.ui:createSpinner(section, "Vivify",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Leg Sweep
            br.ui:createSpinner(section, "Leg Sweep - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Leg Sweep - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
            -- Resuscitate
            br.ui:createDropdown(section, "Resuscitate", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
            -- Touch of Karma
            br.ui:createSpinner(section, "Touch of Karma",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")        
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
            br.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- SEF Toggle
            br.ui:createDropdown(section,  "SEF Mode", br.dropOptions.Toggle,  5)
            -- FSK Toggle
            br.ui:createDropdown(section,  "FSK Mode", br.dropOptions.Toggle,  5)
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

-- BR API Locals
local buff
local cast
local cd
local charges
local chi
local chiDeficit
local chiMax
local combatTime
local debuff
local enemies
local energy
local equiped
local gcd
local healthPot
local inCombat
local inRaid
local level
local mode
local moving
local opener
local option
local php
local power
local powerMax
local pullTimer
local race
local solo
local spell
local talent
local thp
local traits
local ttd
local ttm
local units
local use

-- General API Locals
local castFSK
local fixateTarget
local FoFTimerOpener
local leftCombat
local lowestMark
local profileStop
local SEFTimer
local SerenityTest

local function wasLastCombo(spellID)
    return lastCombo == spellID
end

--------------------
--- Action Lists ---
--------------------
local actionList = {}
-- Action List - Extras
actionList.Extras = function()
    -- Stop Casting
    if isCastingSpell(spell.cracklingJadeLightning) then
        --   Print("channeling cjl")
    end
    -- Tiger's Lust
    if option.checked("Tiger's Lust") then
        if hasNoControl() or (inCombat and getDistance("target") > 10 and isValidUnit("target")) then
            if cast.tigersLust() then return true end
        end
    end
    -- Resuscitate
    if option.checked("Resuscitate") then
        local opValue = option.value("Resuscitate")
        local thisUnit
        if opValue == 1 then thisUnit = "target" end
        if opValue == 2 then thisUnit = "mouseover" end
        if UnitIsPlayer(thisUnit) and UnitIsDeadOrGhost(thisUnit) and GetUnitIsFriend(thisUnit,"player") then
            if cast.resuscitate(thisUnit) then return true end
        end
    end
    -- Provoke
    if option.checked("Provoke") and not inCombat and select(3,GetSpellInfo(101545)) ~= "INTERFACE\\ICONS\\priest_icon_chakra_green"
        and cd.flyingSerpentKick.remain() > 1 and getDistance("target") > 10 and isValidUnit("target") and not isBoss("target")
    then
        if solo or #br.friend == 1 then
            if cast.provoke() then return true end
        end
    end
    -- Flying Serpent Kick
    if mode.fsk == 1 then
        -- if cast.flyingSerpentKick() then return true end
        if castFSK then
            if cast.flyingSerpentKickEnd() then castFSK = false; return true end
        end
    end
    -- Roll
    if option.checked("Roll") and getDistance("target") > 10 and isValidUnit("target") and getFacingDistance() < 5 and getFacing("player","target",10) then
        if cast.roll() then return true end
    end
    -- Dummy Test
    if option.checked("DPS Testing") then
        if GetObjectExists("target") then
            if combatTime >= (tonumber(option.value("DPS Testing"))*60) and isDummy() then
                CancelUnitBuff("player", GetSpellInfo(br.player.spell.stormEarthAndFire))
                StopAttack()
                ClearTarget()
                StopAttack()
                ClearTarget()
                Print(tonumber(option.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
            end
        end
    end
    -- Crackling Jade Lightning
    if option.checked("CJL OOR") and (lastCombo ~= spell.cracklingJadeLightning or buff.hitCombo.stack() <= 1) and #enemies.yards8f == 0 and not isCastingSpell(spell.cracklingJadeLightning) and (hasThreat("target") or isDummy()) and not moving and power >= option.value("CJL OOR") then
        if cast.cracklingJadeLightning() then return true end
    end
    -- Touch of the Void
    if (useCDs() or useAoE()) and option.checked("Touch of the Void") and inCombat and #enemies.yards8 > 0 then
        if hasEquiped(128318) then
            if GetItemCooldown(128318)==0 then
                useItem(128318)
            end
        end
    end
    -- Fixate - Storm, Earth, and Fire
    if cast.able.stormEarthAndFireFixate("target") and option.value("SEF Behavior") == 1
        and not talent.serenity and not cast.current.fistsOfFury() and not UnitIsUnit(fixateTarget,"target")
    then
        if cast.stormEarthAndFireFixate("target") then fixateTarget = ObjectPointer("target") return true end
    end
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    if useDefensive() then
        -- Pot/Stoned
        if option.checked("Healthstone") and getHP("player") <= option.value("Healthstone") and inCombat then
            if canUseItem(5512) then
                useItem(5512)
            elseif canUseItem(healthPot) then
                useItem(healthPot)
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
        -- Dampen Harm / Diffuse Magic
        if option.checked("Diffuse/Dampen") and php <= option.value("Diffuse/Dampen") and inCombat 
            and (talent.dampenHarm or (talent.diffuseMagic and canDispel("player",spell.diffuseMagic))) 
        then
            if talent.dampenHarm then
                if cast.dampenHarm() then return true end
            end
            if talent.diffuseMagic then
                if cast.diffuseMagic() then return true end
            end
        end
        -- Detox
        if option.checked("Detox") then
            if canDispel("player",spell.detox) then
                if cast.detox("player") then return true end
            end
            if UnitIsPlayer("mouseover") and not UnitIsDeadOrGhost("mouseover") then
                if canDispel("mouseover",spell.detox) then
                    if cast.detox("mouseover") then return true end
                end
            end
        end
        -- Leg Sweep
        if option.checked("Leg Sweep - HP") and php <= option.value("Leg Sweep - HP") and inCombat and #enemies.yards5 > 0 then
            if cast.legSweep() then return true end
        end
        if option.checked("Leg Sweep - AoE") and #enemies.yards5 >= option.value("Leg Sweep - AoE") then
            if cast.legSweep() then return true end
        end
        -- Touch of Karma
        if option.checked("Touch of Karma") and php <= option.value("Touch of Karma") and inCombat then
            if cast.touchOfKarma() then return true end
        end
        -- Vivify
        if option.checked("Vivify") and php <= option.value("Vivify") and not inCombat and cast.able.vivify() then
            if cast.vivify() then return true end
        end
    end -- End Defensive Check
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if useInterrupts() then
        for i=1, #getEnemies("player",20) do
            local thisUnit = getEnemies("player",20)[i]
            local distance = getDistance(thisUnit)
            if canInterrupt(thisUnit,option.value("InterruptAt")) then
                -- Spear Hand Strike
                if option.checked("Spear Hand Strike") and cast.able.spearHandStrike(thisUnit) and  distance < 5 then
                    if cast.spearHandStrike(thisUnit) then return true end
                end
                -- Leg Sweep
                if option.checked("Leg Sweep") and cast.able.legSweep(thisUnit) and (distance < 5 or (talent.tigerTailSweep and distance < 7)) then
                    if cast.legSweep(thisUnit) then return true end
                end
                -- Paralysis
                if option.checked("Paralysis") and cast.able.paralysis(thisUnit) then
                    if cast.paralysis(thisUnit) then return true end
                end
            end
        end
    end -- End Interrupt Check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    -- Trinkets
    if getDistance(units.dyn5) < 5  then
        local thisTrinket
        for i = 13, 14 do 
            if i == 13 then thisTrinket = "Trinket 1" else thisTrinket = "Trinket 2" end
            local opValue = option.value(thisTrinket)
            if (opValue == 1 or (opValue == 2 and useCDs())) and canUseItem(i) then
                useItem(i)
            end
        end
    end
    if useCDs() and getDistance(units.dyn5) < 5 then
        -- Invoke Xuen
        -- invoke_xuen_the_white_tiger
        if option.checked("Xuen") and cast.able.invokeXuenTheWhiteTiger() then
            if cast.invokeXuenTheWhiteTiger() then return true end
        end
        -- Racial - Blood Fury / Berserking / Arcane Torrent / Fireblood
        -- blood_fury
        -- berserking
        -- arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.5
        -- lightsJudgment
        -- fireblood
        -- ancestral_call
        if option.checked("Racial") and cast.able.racial() then
            if (race == "BloodElf" and chiMax - chi >= 1 and ttm >= 0.5)
                or race == "Orc" or race == "Troll" or race == "LightforgedDraenei"
                or race == "DarkIronDwarf" or race == "MagharOrc"
            then
                if race == "LightforgedDraenei" then
                    if cast.racial("target","ground") then return true end
                else
                    if cast.racial() then return true end
                end
            end
        end
        -- Touch of Death
        -- touch_of_death,if=target.time_to_die>9
        if option.checked("Touch of Death") and cast.able.touchOfDeath() and ttd > 9 and cast.last.tigerPalm() then --and cd.fistsOfFury.remain() < gcd then
            if cast.touchOfDeath("target") then return true end
        end
    end
    -- Storm, Earth, and Fire
    -- storm_earth_and_fire,if=cooldown.storm_earth_and_fire.charges=2|(cooldown.fists_of_fury.remains<=6&chi>=3&cooldown.rising_sun_kick.remains<=1)|target.time_to_die<=15
    if ((mode.sef == 2 and (#enemies.yards8 >= option.value("SEF Targets") or isBoss())) or (mode.sef == 1 and useCDs())) 
        and cast.able.stormEarthAndFire() and getDistance(units.dyn5) < 5
        and (charges.stormEarthAndFire.count() == 2 or (cd.fistsOfFury.remain() <= 6 and chi >= 3 and cd.risingSunKick.remain() <= 1) or ttd <= 15) and not talent.serenity
        and (cast.last.touchOfDeath() or not useCDs() or not option.checked("Touch of Death") or cd.touchOfDeath.remain() > gcd)
    then
        if cast.stormEarthAndFire() then fixateTarget = "player"; return true end
    end
    -- Serenity
    -- serenity,if=cooldown.rising_sun_kick.remains<=2|target.time_to_die<=12
    if (option.value("Serenity") == 1 or (option.value("Serenity") == 2 and useCDs()))
        and getDistance(units.dyn5) < 5 and (cd.risingSunKick.remain() <= 2 or ttd <= 12)
    then
        if cast.serenity() then return true end
    end
end -- End Cooldown - Action List

-- Action List - Single Target
actionList.SingleTarget = function()
    -- Whirling Dragon Punch
    -- whirling_dragon_punch
    if option.checked("Whirling Dragon Punch") and cast.able.whirlingDragonPunch() and talent.whirlingDragonPunch and not moving and not isExplosive("target")
        and cd.fistsOfFury.exists() and cd.risingSunKick.exists() and #enemies.yards8 >= option.value("Whirling Dragon Punch Targets") 
    then
        if cast.whirlingDragonPunch("player","aoe") then return true end
    end
    -- Rising Sun Kick 
    -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=chi>=5
    if cast.able.risingSunKick() and chi >= 5 then 
        if cast.risingSunKick() then return true end 
    end 
    -- Fists of Fury 
    -- fists_of_fury,if=energy.time_to_max>3
    if cast.able.fistsOfFury() and not cast.last.stormEarthAndFire() and (ttm > 3 and #enemies.yards8f >= option.value("Fists of Fury Targets")) 
        and mode.fof == 1 and (ttd > 3 or #enemies.yards8f > 1) and not isExplosive("target")
    then 
        if cast.fistsOfFury() then return true end 
    end 
    -- Rising Sun Kick
    -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains
    if cast.able.risingSunKick() then
        if cast.risingSunKick() then return true end
    end
    -- Spinning Crane Kick 
    -- spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick&buff.dance_of_chiji.up
    if cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick) and buff.danceOfChiJi.exists() and not isExplosive("target") then 
        if cast.spinningCraneKick(nil,"aoe") then return true end 
    end
    -- Rushing Jade Wind
    -- rushing_jade_wind,if=buff.rushing_jade_wind.down&active_enemies>1
    if cast.able.rushingJadeWind() and not buff.rushingJadeWind.exists() and not isExplosive("target")
        and ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0))
    then
        if cast.rushingJadeWind() then return true end
    end
    -- Fist of the White Tiger
    -- fist_of_the_white_tiger,if=chi<=2
    if cast.able.fistOfTheWhiteTiger() and chi <= 2 then
        if cast.fistOfTheWhiteTiger() then return true end
    end
    -- Energizing Elixir
    -- energizing_elixir,if=chi<=3&energy<50
    if cast.able.energizingElixir() and (option.value("Energizing Elixir") == 1 or (option.value("Energizing Elixir") == 2 and useCDs()))
        and chi <= 3 and energy < 50 and getDistance("target") < 5
    then
        if cast.energizingElixir() then return true end
    end
    -- Blackout kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.blackout_kick&(cooldown.rising_sun_kick.remains>3|chi>=3)&(cooldown.fists_of_fury.remains>4|chi>=4|(chi=2&prev_gcd.1.tiger_palm))&buff.swift_roundhouse.stack<2
    if cast.able.blackoutKick() and not wasLastCombo(spell.blackoutKick) and buff.swiftRoundhouse.stack() < 2 and (((cd.risingSunKick.remain() > 3 or chi >= 3) 
        and (cd.fistsOfFury.remain() > 4 or chi >= 4 or ((chi == 2 or ttm <= 3) and wasLastCombo(spell.tigerPalm) or ttd <= 3 
        or #enemies.yards8f < option.value("Fists of Fury Targets") or mode.fof == 2))) or buff.blackoutKick.exists() or isExplosive("target"))
    then
        if cast.blackoutKick() then return true end
    end
    -- Chi Wave
    -- chi_wave
    if cast.able.chiWave() then
        if cast.chiWave(nil,"aoe") then return true end
    end
    -- Chi Burst
    -- chi_burst,if=chi.max-chi>=1&active_enemies=1|chi.max-chi>=2
    if cast.able.chiBurst() and ((chiMax - chi >= 1 and enemies.yards40r == 1) or chiMax - chi >= 2)
        and ((mode.rotation == 1 and enemies.yards40r >= option.value("Chi Burst Min Units")) or (mode.rotation == 3 and enemies.yards40r > 0)) 
    then
        if cast.chiBurst(nil,"rect",1,12) then return true end
    end
    -- Tiger Palm
    -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.tiger_palm&chi.max-chi>=2
    if cast.able.tigerPalm() and not wasLastCombo(spell.tigerPalm) and (chiMax - chi >= 2 or ttd < 3 or ttm < 3 or isExplosive("target"))
    then
        if cast.tigerPalm() then return true end
    end
    -- Flying Serpent Kick
    -- flying_serpent_kick,if=prev_gcd.1.blackout_kick&chi>3&buff.swift_roundhouse.stack<2,interrupt=1
    if mode.fsk == 1 and cast.able.flyingSerpentKick() and wasLastCombo(spell.blackoutKick) and chi > 3 and buff.swiftRoundhouse.stack() < 2 then
        if cast.flyingSerpentKick() then return true end
    end
end -- End Action List - Single Target

-- Action List - AoE
actionList.AoE = function()
    -- Rising Sun Kick
    -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=(talent.whirling_dragon_punch.enabled&cooldown.whirling_dragon_punch.remains<5)&cooldown.fists_of_fury.remains>3
    if cast.able.risingSunKick(lowestMark) and (((talent.whirlingDragonPunch and cd.whirlingDragonPunch.remain() < 5) and cd.fistsOfFury.remain() > 3) 
        or isExplosive("target")) 
    then
        if cast.risingSunKick(lowestMark) then return true end
    end
    -- Whirling Dragon Punch
    -- whirling_dragon_punch
    if cast.able.whirlingDragonPunch() and option.checked("Whirling Dragon Punch") and talent.whirlingDragonPunch and not moving and not isExplosive("target")
        and cd.fistsOfFury.exists() and cd.risingSunKick.exists() and #enemies.yards8 >= option.value("Whirling Dragon Punch Targets") 
    then
        if cast.whirlingDragonPunch("player","aoe") then return true end
    end
    -- Energizing Elixir
    -- energizing_elixir,if=!prev_gcd.1.tiger_palm&chi<=1&energy<50
    if cast.able.energizingElixir() and (option.value("Energizing Elixir") == 1 or (option.value("Energizing Elixir") == 2 and useCDs()))
        and cast.last.tigerPalm() and chi <= 1 and energy < 50 and getDistance("target") < 8
    then
        if cast.energizingElixir() then return true end
    end
    -- Fists of Fury
    -- fists_of_fury,if=energy.time_to_max>3
    if cast.able.fistsOfFury() and not cast.last.stormEarthAndFire() and (ttd > 3 or #enemies.yards8f > 1) and ttm > 3 
        and #enemies.yards8f >= option.value("Fists of Fury Targets") and mode.fof == 1 and not isExplosive("target") 
    then
        if cast.fistsOfFury() then return true end
    end
    -- Rushing Jade Wind
    -- rushing_jade_wind,if=buff.rushing_jade_wind.down
    if cast.able.rushingJadeWind() and not buff.rushingJadeWind.exists() and not isExplosive("target") then
        if cast.rushingJadeWind() then return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick&(((chi>3|cooldown.fists_of_fury.remains>6)&(chi>=5|cooldown.fists_of_fury.remains>2))|energy.time_to_max<=3)
    if cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick) and not isExplosive("target")
        and (((chi > 3 or cd.fistsOfFury.remain() > 6) and (chi >= 5 or cd.fistsOfFury.remain() > 2)) or ttm <= 3 or ttd <= 3 
            or #enemies.yards8f < option.value("Fists of Fury Targets") and mode.fof == 2) 
    then
        if cast.spinningCraneKick(nil,"aoe") then return true end
    end
    -- Chi Burst
    -- chi_burst,if=chi<=3
    if cast.able.chiBurst() and chi <= 3
        and ((mode.rotation == 1 and enemies.yards40r >= option.value("Chi Burst Min Units")) or (mode.rotation == 2 and enemies.yards40r > 0)) 
    then
        if cast.chiBurst(nil,"rect",1,12) then return true end
    end
    -- Fist of the White Tiger
    -- fist_of_the_white_tiger,if=chi.max-chi>=3
    if cast.able.fistOfTheWhiteTiger() and chiMax - chi >= 3 then
        if cast.fistOfTheWhiteTiger() then return true end
    end
    -- Tiger Palm
    -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=chi.max-chi>=2&(!talent.hit_combo.enabled|!prev_gcd.1.tiger_palm)
    if cast.able.tigerPalm(lowestMark) and (chiMax - chi >= 2 or ttd < 3 or ttm < 3 or isExplosive("target")) and (not talent.hitCombo or not wasLastCombo(spell.tigerPalm)) then
        if cast.tigerPalm(lowestMark) then return true end
    end
    -- Chi Wave
    -- chi_wave
    if cast.able.chiWave() then
        if cast.chiWave(nil,"aoe") then return true end
    end
    -- Flying Serpent Kick
    -- flying_serpent_kick,if=buff.bok_proc.down,interrupt=1
    if mode.fsk == 1 and cast.able.flyingSerpentKick() and not buff.blackoutKick.exists() then
        if cast.flyingSerpentKick() then return true end
    end
    -- Blackout Kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.blackout_kick&(buff.bok_proc.up|(talent.hit_combo.enabled&prev_gcd.1.tiger_palm&chi<4))
    if cast.able.blackoutKick(lowestMark) and not wasLastCombo(spell.blackoutKick)
        and (buff.blackoutKick.exists() or (talent.hitCombo and wasLastCombo(spell.tigerPalm) and chi < 4) or ttd <= 3 or ttm <= 3 or isExplosive("target"))
    then
        if cast.blackoutKick(lowestMark) then return true end
    end
end -- End Action List - AoE

-- Action List - Essence
actionList.Essence = function()
    -- concentrated_flame
    if cast.able.concentratedFlame() then
        if cast.concentratedFlame() then return end
    end
    -- blood_of_the_enemy
    if useCDs() and cast.able.bloodOfTheEnemy() then
        if cast.bloodOfTheEnemy() then return end 
    end
    -- guardian_of_azeroth
    if useCDs() and cast.able.guardianOfAzeroth() then 
        if cast.guardianOfAzeroth() then return end 
    end
    -- focused_azerite_beam
    if cast.able.focusedAzeriteBeam() and (#enemies.yards8f >= 3 or useCDs()) then
        local minCount = useCDs() and 1 or 3
        if cast.focusedAzeriteBeam(nil,"cone",minCount, 8) then return true end
    end
    -- purifying_blast
    if cast.able.purifyingBlast() and (#enemies.yards8t >= 3 or useCDs()) then
        local minCount = useCDs() and 1 or 3
        if cast.purifyingBlast("best", nil, minCount, 8) then return true end
    end
    -- the_unbound_force
    if cast.able.theUnboundForce() then
        if cast.theUnboundForce() then return end
    end
    -- ripple_in_space
    if cast.able.rippleInSpace() then
        if cast.rippleInSpace() then return end
    end
    -- worldvein_resonance
    if cast.able.worldveinResonance() then
        if cast.worldveinResonance() then return end
    end
    -- memory_of_lucid_dreams,if=energy<40&buff.storm_earth_and_fire.up
    if useCDs() and cast.able.memoryOfLucidDreams() 
        and energy < 40 and buff.stormEarthAndFire.exists() 
    then
        if cast.memoryOfLucidDreams() then return end
    end
end

-- Action List - Serenity
actionList.Serenity = function()
    -- Rising Sun Kick
    -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=active_enemies<3|prev_gcd.1.spinning_crane_kick
    if chi >= 2 and  cast.able.risingSunKick(lowestMark) and (#enemies.yards8 < 3 or wasLastCombo(spell.spinningCraneKick)) then
        if cast.risingSunKick(lowestMark) then return true end
    end
    -- Fists of Fury
    -- fists_of_fury,if=(buff.bloodlust.up&prev_gcd.1.rising_sun_kick)|buff.serenity.remains<1|(active_enemies>1&active_enemies<5)
    if chi >= 3 and  cast.able.fistsOfFury() and ((buff.bloodLust.exists() and wasLastCombo(spell.risingSunKick)) or buff.serenity.remain() < 1
        or (#enemies.yards8f > 1 and #enemies.yards8f < 5)) and mode.fof == 1
    then
        if cast.fistsOfFury() then return true end
    end
    -- Spinning Crane Kick
    -- spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick&(active_enemies>=3|(active_enemies=2&prev_gcd.1.blackout_kick))
    if chi >= 2 and cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick) and (((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0))
        or (((mode.rotation == 1 and #enemies.yards8 == 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) and wasLastCombo(spell.blackoutKick)))
    then
        if cast.spinningCraneKick(nil,"aoe") then return true end
    end
    -- Blackout Kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains
    if chi >= 1 and cast.able.blackoutKick(lowestMark) then
        if cast.blackoutKick(lowestMark) then return true end
    end
end -- End Action List - Serenity

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not inCombat then
        -- Flask / Crystal
        -- flask,type=flask_of_the_seventh_demon
        if option.value("Flask/Crystal") == 1 and inRaid and not buff.flaskOfTheSeventhDemon.exists() and use.able.flaskOfTheSeventhDemon() then
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if use.flaskOfTheSeventhDemon() then return true end
        end
        if option.value("Flask/Crystal") == 2 and not buff.felFocus.exists() and use.able.repurposedFelFocuser() and not buff.flaskOfTheSeventhDemon.exists() then
            -- if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
            if use.repurposedFelFocuser() then return true end
        end
        if option.value("Flask/Crystal") == 3 and not buff.whispersOfInsanity.exists() and use.able.oraliusWhisperingCrystal() then
            if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if use.oraliusWhisperingCrystal() then return true end
        end
        if isValidUnit("target") and opener.complete then
            if getDistance("target") < 5 then
    -- -- Chi Burst
    --         -- chi_burst,if=(!talent.serenity.enabled|!talent.fist_of_the_white_tiger.enabled)
    --             if cast.able.chiBurst() and (not talent.serenity or not talent.fistOfTheWhiteTiger) 
    --                 and ((mode.rotation == 1 and enemies.yards40r >= option.value("Chi Burst Min Units")) or (mode.rotation == 2 and enemies.yards40r > 0)) 
    --             then
    --                 if cast.chiBurst(nil,"rect",1,12) then return true end
    --             end
    -- -- Chi Wave
    --         -- chi_wave
    --             if cast.able.chiWave() and (not talent.invokeXuenTheWhiteTiger or cd.invokeXuenTheWhiteTiger.remain() > gcd or not useCDs() or not option.checked("Xuen"))
    --                 and (not talent.fistOfTheWhiteTiger or cd.fistOfTheWhiteTiger.remain() > gcd or chi > 2) 
    --             then 
    --                 if cast.chiWave(nil,"aoe") then return true end
    --             end
            -- Start Attack
            -- auto_attack
                StartAttack()
            end
            -- Crackling Jade Lightning 
            if option.checked("CJL OOR") and getDistance("target") < 40 and not moving and power >= option.value("CJL OOR") then 
                if cast.cracklingJadeLightning("target") then StartAttack(); return true end                         
            end
            -- Provoke 
            if option.checked("Provoke") and not isBoss("target") and getDistance("target") < 30 and (moving or power < option.value("CJL OOR")) then 
                if cast.provoke("target") then StartAttack(); return true end 
            end
        end
    end -- End No Combat Check
    -- Opener
    if actionList.Opener() then return true end
end --End Action List - Pre-Combat

-- Action List - Opener
actionList.Opener = function()
    -- Start Attack
    -- auto_attack
    if mode.opener == 1 and isBoss("target") and not opener.complete then
        if isValidUnit("target") and getDistance("target") < 5 and getFacing("player","target") and getSpellCD(61304) == 0 then
            -- Potion
            -- potion,name=old_war,if=buff.serenity.up|buff.storm_earth_and_fire.up|(!talent.serenity.enabled&trinket.proc.agility.react)|buff.bloodlust.react|target.time_to_die<=60
            -- Agility Proc
            if inRaid and option.checked("Potion") and useCDs() then
                if option.checked("Pre-Pull Timer") and pullTimer <= option.value("Pre-Pull Timer") then
                    if canUseItem(127844) and talent.serenity then
                        useItem(127844)
                    end
                    if canUseItem(142117) and talent.whirlingDragonPunch then
                        useItem(142117)
                    end
                end
            end
            -- Begin
            if not opener.OPN1 then
                Print("Starting Opener")
                opener.count = opener.count + 1
                opener.OPN1 = true
                return
            -- Xuen
            elseif opener.OPN1 and not opener.XUEN then
                if not talent.invokeXuenTheWhiteTiger or cd.invokeXuenTheWhiteTiger.remain() > gcd then
                    castOpenerFail("invokeXuenTheWhiteTiger","XUEN",opener.count)
                elseif cast.able.invokeXuenTheWhiteTiger() then
                    castOpener("invokeXuenTheWhiteTiger","XUEN",opener.count)
                end
                opener.count = opener.count + 1; 
                return
            -- Trinkets 
            elseif opener.XUEN and not opener.TRNK1 then 
                if not canUseItem(13) or option.value("Trinkets") == 3 then 
                    Print(opener.count..": Trinket 1 (Uncastable)") 
                elseif canUseItem(13) and not (hasEquiped(151190,13) or hasEquiped(147011,13)) then
                    useItem(13)
                    Print(opener.count..": Trinket 1")
                end 
                opener.count = opener.count + 1;                            
                opener.TRNK1 = true
                return
            elseif opener.TRNK1 and not opener.TRNK2 then 
                if not canUseItem(14) or option.value("Trinkets") == 3 then 
                    Print(opener.count..": Trinket 2 (Uncastable)") 
                elseif canUseItem(14) and not (hasEquiped(151190,14) or hasEquiped(147011,14)) then
                    useItem(14)
                    Print(opener.count..": Trinket 2")
                end
                opener.count = opener.count + 1
                opener.TRNK2 = true 
                return
            -- Fist of the White Tiger
            elseif opener.TRNK2 and not opener.FotWT then 
                if not talent.fistOfTheWhiteTiger or cd.fistOfTheWhiteTiger.remain() > gcd then
                    castOpenerFail("fistOfTheWhiteTiger","FotWT",opener.count)
                elseif cast.able.fistOfTheWhiteTiger() then
                    castOpener("fistOfTheWhiteTiger","FotWT",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Tiger Palm 1
            elseif opener.FotWT and not opener.TP1 then
                if wasLastCombo(spell.tigerPalm) then 
                    castOpenerFail("tigerPalm","TP1",opener.count)
                elseif cast.able.tigerPalm() then
                    castOpener("tigerPalm","TP1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Touch of Death
            elseif opener.TP1 and not opener.TOD then
                if level < 32 or cd.touchOfDeath.remain() > 0 then 
                    castOpenerFail("touchOfDeath","TOD",opener.count)
                elseif cast.able.touchOfDeath() then
                    castOpener("touchOfDeath","TOD",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Storm, Earth, and Fire
            elseif opener.TOD and not opener.SEF then
                if level < 50 or not charges.stormEarthAndFire.exists() then 
                    castOpenerFail("stormEarthAndFire","SEF",opener.count)
                elseif cast.able.stormEarthAndFire() then
                    castOpener("stormEarthAndFire","SEF",opener.count)
                    fixateTarget = "player"
                end
                opener.count = opener.count + 1
                return
            -- Rising Sun Kick 1
            elseif opener.SEF and not opener.RSK1 then 
                if level < 10 or chi < 2 or cd.risingSunKick.remain() > gcd then 
                    castOpenerFail("risingSunKick","RSK1",opener.count)
                elseif cast.able.risingSunKick() then
                    castOpener("risingSunKick","RSK1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Fists of Fury 
            elseif opener.RSK1 and not opener.FOF then 
                if level < 20 or chi < 3 or cd.fistsOfFury.remain() > gcd then 
                    castOpenerFail("fistsOfFury","FOF",opener.count)
                elseif cast.able.fistsOfFury() then
                    castOpener("fistsOfFury","FOF",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Whirling Dragon Punch 
            elseif opener.FOF and not opener.WDP then 
                if not talent.whirlingDragonPunch or cd.whirlingDragonPunch.remain() > gcd or (cd.fistsOfFury.remain() == 0 and cd.risingSunKick.remain() == 0) then 
                    castOpenerFail("whirlingDragonPunch","WDP",opener.count)
                elseif cast.able.whirlingDragonPunch() then
                    castOpener("whirlingDragonPunch","WDP",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Tiger Palm 2 
            elseif opener.WDP and not opener.TP2 then
                if wasLastCombo(spell.tigerPalm) then 
                    castOpenerFail("tigerPalm","TP2",opener.count)
                elseif cast.able.tigerPalm() then
                    castOpener("tigerPalm","TP2",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Blackout Kick 1
            elseif opener.TP2 and not opener.BOK1 then
                if chi < 1 or (chi == 0 and not buff.blackoutKick.exists()) or wasLastCombo(spell.blackoutKick) then 
                    castOpenerFail("blackoutKick","BOK1",opener.count)
                elseif cast.able.blackoutKick() then
                    castOpener("blackoutKick","BOK1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Tiger Palm 3
            elseif opener.BOK1 and not opener.TP3 then 
                if wasLastCombo(spell.tigerPalm) then 
                    castOpenerFail("tigerPalm","TP3",opener.count)
                elseif cast.able.tigerPalm() then
                    castOpener("tigerPalm","TP3",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Rising Sun Kick 2
            elseif opener.TP3 and not opener.RSK2 then
                if level < 10 or chi < 2 or cd.risingSunKick.remain() > gcd then 
                    castOpenerFail("risingSunKick","RSK2",opener.count)
                elseif cast.able.risingSunKick() then 
                    castOpener("risingSunKick","RSK2",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Blackout Kick 2
            elseif opener.RSK2 and not opener.BOK2 then
                if chi < 1 or (chi == 0 and not buff.blackoutKick.exists()) or wasLastCombo(spell.blackoutKick) then 
                    castOpenerFail("blackoutKick","BOK2",opener.count)
                elseif cast.able.blackoutKick() then
                    castOpener("blackoutKick","BOK2",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Tiger Palm 4
            elseif opener.BOK2 and not opener.TP4 then 
                if wasLastCombo(spell.tigerPalm) then 
                    castOpenerFail("tigerPalm","TP4",opener.count)
                elseif cast.able.tigerPalm() then
                    castOpener("tigerPalm","TP4",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Blackout Kick 3
            elseif opener.TP4 and not opener.BOK3 then
                if chi < 1 or (chi == 0 and not buff.blackoutKick.exists()) or wasLastCombo(spell.blackoutKick) then 
                    castOpenerFail("blackoutKick","BOK3",opener.count)
                elseif cast.able.blackoutKick() then
                    castOpener("blackoutKick","BOK3",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Chi Burst/Wave
            elseif opener.BOK3 and not opener.CBW then 
                if talent.chiBurst then 
                    if not cast.able.chiBurst() then 
                        castOpenerFail("chiBurst","CBW",opener.count)
                        opener.count = opener.count + 1
                    elseif cast.able.chiBurst() then
                        castOpener("chiBurst","CBW",opener.count)
                        opener.count = opener.count + 1
                    end
                elseif talent.chiWave then 
                    if not cast.able.chiWave() then 
                        castOpenerFail("chiWave","CBW",opener.count)
                        opener.count = opener.count + 1
                    elseif cast.able.chiWave() then
                        castOpener("chiWave","CBW",opener.count)
                        opener.count = opener.count + 1
                    end
                else 
                    opener.CBW = true 
                end
                return
            -- Blackout Kick 4
            elseif opener.CBW and not opener.BOK4 then
                if chi < 1 or (chi == 0 and not buff.blackoutKick.exists()) or wasLastCombo(spell.blackoutKick) then 
                    castOpenerFail("blackoutKick","BOK4",opener.count)
                elseif cast.able.blackoutKick() then
                    castOpener("blackoutKick","BOK4",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Finish (rip exists)
            elseif opener.BOK4 then
                Print("Opener Complete")
                opener.count = 0
                opener.complete = true
            end
        end
    elseif (UnitExists("target") and not isBoss("target")) or mode.opener == 2 then
        opener.complete = true
    end -- End Boss and Opener Check
end -- End Action List - Opener

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
    UpdateToggle("SEF",0.25)
    br.player.mode.sef = br.data.settings[br.selectedSpec].toggles["SEF"]
    UpdateToggle("FSK",0.25)
    br.player.mode.fsk = br.data.settings[br.selectedSpec].toggles["FSK"]
    BurstToggle("burstKey", 0.25)
    UpdateToggle("FOF", 0.25)
    br.player.mode.fof = br.data.settings[br.selectedSpec].toggles["FOF"]

    --------------
    --- Locals ---
    --------------
    buff              = br.player.buff
    cast              = br.player.cast
    cd                = br.player.cd
    charges           = br.player.charges
    chi               = br.player.power.chi.amount()
    chiDeficit        = br.player.power.chi.deficit()
    chiMax            = br.player.power.chi.max()
    combatTime        = getCombatTime()
    debuff            = br.player.debuff
    enemies           = br.player.enemies
    energy            = br.player.power.energy.amount()
    equiped           = br.player.equiped
    gcd               = br.player.gcdMax
    healthPot         = getHealthPot() or 0
    inCombat          = br.player.inCombat
    inRaid            = select(2,IsInInstance())=="raid"
    level             = br.player.level
    mode              = br.player.mode
    moving            = GetUnitSpeed("player")>0
    opener            = br.player.opener
    option            = br.player.option
    php               = br.player.health
    power             = br.player.power.energy.amount()
    powerMax          = br.player.power.energy.max()
    pullTimer         = br.DBM:getPulltimer()
    race              = br.player.race
    solo              = select(2,IsInInstance())=="none"
    spell             = br.player.spell
    talent            = br.player.talent
    thp               = getHP("target")
    traits            = br.player.traits
    ttd               = getTTD("target")
    ttm               = br.player.power.energy.ttm()
    units             = br.player.units
    use               = br.player.use

    units.get(5)
    enemies.get(5)
    enemies.get(5,"player",false,true)
    enemies.get(8)
    enemies.get(8,"target")
    enemies.get(8,"player",false,true)
    enemies.yards40r = getEnemiesInRect(10,40,false) or 0

    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end
    if SerenityTest == nil then SerenityTest = GetTime() end
    if SEFTimer == nil then SEFTimer = GetTime() end
    if FoFTimerOpener == nil then FoFTimerOpener = GetTime() end
    if castFSK == nil then castFSK = false end
    if fixateTarget == nil then fixateTarget = "player" end

    if isCastingSpell(spell.cracklingJadeLightning)
        and (getDistance(units.dyn5) <= 5 or (#enemies.yards8 == 0 and power <= option.value("CJL OOR Cancel") and option.checked("CJL OOR")))
    then
        SpellStopCasting()
    end

    lowestMark = debuff.markOfTheCrane.lowest(5,"remain") or units.dyn5
    if not inCombat or lastCombo == nil then lastCombo = 6603 end
    if lastCast == nil then lastCast = 6603 end

    -- Opener Reset
    if (not inCombat and not GetObjectExists("target")) or opener.complete == nil then
        opener.count = 0
        opener.OPN1 = false
        opener.XUEN = false
        opener.TRNK1 = false
        opener.TRNK2 = false
        opener.FotWT = false
        opener.TP1 = false
        opener.TOD = false
        opener.SEF = false
        opener.SEFF = false
        opener.RSK1 = false
        opener.FOF = false
        opener.WDP = false
        opener.TP2 = false
        opener.BOK1 = false
        opener.TP3 = false
        opener.RSK2 = false
        opener.BOK2 = false
        opener.TP4 = false
        opener.BOK3 = false
        opener.CBW = false
        opener.BOK4 = false
        opener.complete = false
    end

    -- Touch of Deathable
    if not canToD then canToD = false end
    if ToDTime == nil then ToDTimer = GetTime() end
    if hasEquiped(137057) then
        if lastCombo == spell.touchOfDeath and not canToD then
            ToDTimer = GetTime() + 3;
            canToD = true
        end
        if canToD and GetTime() > ToDTimer then
            canToD = false
        end
    end

    -- Rushing Jade Wind - Cancel
    if not inCombat and buff.rushingJadeWind.exists() then
        if buff.rushingJadeWind.cancel() then return true end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop==true then
        profileStop = false
    elseif (inCombat and profileStop==true) or pause() or (IsMounted() or IsFlying()) or mode.rotation==4 then
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
        if inCombat and profileStop==false and isValidUnit(units.dyn5) and opener.complete 
            and not cast.current.spinningCraneKick() and not cast.current.fistsOfFury() 
        then
            ------------------
            --- Interrupts ---
            ------------------
            -- Run Action List - Interrupts
            if actionList.Interrupts() then return true end
            ----------------------
            --- Start Rotation ---
            ----------------------
            -- Auto Attack
            -- auto_attack
            if getDistance(units.dyn5) < 5 then
                StartAttack()
            end
            ---------------------------------
            --- APL Mode: SimulationCraft ---
            ---------------------------------
            if option.value("APL Mode") == 1 then -- --[[and cd.global.remain() <= getLatency()]] and GetTime() >= SEFTimer + option.value("SEF Timer") then
                -- Touch of Karma
                -- touch_of_karma,interval=90,pct_health=0.5
                if option.checked("Touch of Karma") and useCDs() and cast.able.touchOfKarma() and php >= 50 then
                    if cast.touchOfKarma() then return true end
                end
                -- Potion
                -- potion,if=buff.serenity.up|buff.storm_earth_and_fire.up|(!talent.serenity.enabled&trinket.proc.agility.react)|buff.bloodlust.react|target.time_to_die<=60
                if inRaid and option.checked("Potion") and useCDs() and getDistance("target") < 5 then
                    if buff.serenity.exists() or buff.stormEarthAndFire.exists() or talent.serenity or buff.bloodLust.exists() or ttd <= 60 then
                        if canUseItem(127844) then
                            useItem(127844)
                        end
                        if canUseItem(142117) then
                            useItem(142117)
                        end
                    end
                end
                -- Call Action List - Serenity
                -- call_action_list,name=serenity,if=buff.serenity.up
                if buff.serenity.exists() then
                    if actionList.Serenity() then return true end
                end
                -- Xuen 
                if cast.able.invokeXuenTheWhiteTiger() and useCDs() and option.checked("Xuen") then 
                    if cast.invokeXuenTheWhiteTiger() then return true end 
                end
                -- Fist of the White Tiger
                -- fist_of_the_white_tiger,if=(energy.time_to_max<1|(talent.serenity.enabled&cooldown.serenity.remains<2))&chi.max-chi>=3
                if cast.able.fistOfTheWhiteTiger() and (ttm < 1 or (talent.serenity and cd.serenity.remain() < 2)) and chiMax - chi >= 3 then
                    if cast.fistOfTheWhiteTiger() then return true end
                end
                -- Tiger Palm
                -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=(energy.time_to_max<1|(talent.serenity.enabled&cooldown.serenity.remains<2))&chi.max-chi>=2&!prev_gcd.1.tiger_palm
                if cast.able.tigerPalm(lowestMark) and (ttm < 1 or (talent.serenity and cd.serenity.remain() < 2)) 
                and chiMax - chi >= 2 and not wasLastCombo(spell.tigerPalm)
                then
                    if cast.tigerPalm(lowestMark) then return true end
                end
                -- Call Action List - Cooldowns
                -- call_action_list,name=cd
                if actionList.Cooldowns() then return true end
                -- Call Action List - Essence
                -- call_action_list,name=essences
                if option.checked("Use Essence") then 
                    if actionList.Essence() then return end
                end
                -- Call Action List - Single Target
                -- call_action_list,name=st,if=active_enemies<3
                if level < 40 or ((mode.rotation == 1 and #enemies.yards8 < 3) or (mode.rotation == 3 and #enemies.yards8 > 0)) then
                    if actionList.SingleTarget() then return true end
                end
                -- Call Action List - AoE
                -- call_action_list,name=aoe,if=active_enemies>=3
                if level >= 40 and ((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                    if actionList.AoE() then return true end
                end
            end -- End Simulation Craft APL
            ----------------------------
            --- APL Mode: AskMrRobot ---
            ----------------------------
            if option.value("APL Mode") == 2 then

            end -- End AskMrRobot APL
        end -- End Combat Check
    end -- End Pause
end -- End Timer
local id = 269
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

-------------------------------------------------------
-- Author = BrewingCoder
-- Patch = 10.2.5
-- Coverage = 95%
-- Status = Limited
-- Readiness = Development
-------------------------------------------------------
local rotationName = "BrewWindWalker"
local colors = {
    blue    = "|cff4285F4",
    red     = "|cffDB4437",
    yellow  = "|cffF4B400",
    green   = "|cff0F9D58",
    white   = "|cffFFFFFF",
    purple  = "|cff9B30FF",
    aqua    = "|cff89E2C7",
    blue2   = "|cffb8d0ff",
    green2  = "|cff469a81",
    blue3   = "|cff6c84ef",
    orange  = "|cffff8000"
}

local text = {
    cooldowns = {
        title                       = colors.purple .. "Cooldowns",
        summonWhiteStatuue          = colors.purple .. "Summon White Tiger Statue",
        invokeXuenTheWhiteTiger     = colors.purple .. "Invoke Xuen The White Tiger",
        useSerenity                 = colors.purple .. "Serenity",
        fortifyingBrew              = colors.purple .. "Fortifying Brew",
        touchOfKarma                = colors.purple .. "Touch of Karma",
        aoeOverrideCoolowns         = colors.purple .. "AOE targets invoke CDs"
    },
    consumables = {
        onlyUseConsumablesInRaid    = colors.white .. "Only use consumables in dungeon/raid"
    },
    interrupts = {
        title                       = colors.yellow .. "Interrupts",
        useSpearHandStrike          = colors.yellow .. "Spear Hand Strike",
        useLegSweep                 = colors.yellow .. "Leg Sweep",
    },
    options = {
        title                       = colors.blue2 .. "General Options",
        aoeNumber                   = colors.blue2 .. "Number of enemies to use AOE routines",
        touchOfDeath                = colors.blue2 .. "Use Touch Of Death",
        useDisable                  = colors.blue2 .. "Use Disable",
        PullAllTargets              = colors.blue2 .. "Pull/Taunt Additional targets",
    },
    defensive = {
        title                       = colors.aqua .. "Defensive Measures",
        useDetox                    = colors.aqua .. "Use Detox on self",
        useDetoxOnParty             = colors.aqua .. "Use Detox on Party Member (req. HE)"
    }
}

local function createToggles()
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spells.whirlwind },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spells.bladestorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spells.ragingBlow },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.enragedRegeneration}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.touchOfKarma },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spells.fortifyingBrew },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.touchOfDeath }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.vivify },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.vivify }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spells.tigersLust },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.tigersLust }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
    local DebugModes = {
            [1] = { mode = "ON", value = 1 , overlay = "Debugs On", tip = "Debug Messages On", highlight = 1, icon =200733 },
            [2] = { mode = "OFF", value = 0 , overlay = "Debugs Off", tip = "Debug Messages Off", highlight = 0, icon =200733 },
        }
    br.ui:createToggle(DebugModes,"Debugs",5,0)
end

local function createOptions()

    local optionTable

    local function rotationOptions()
        local section
        section = br.ui:createSection(br.ui.window.profile,  text.options.title)
            br.ui:createCheckbox(section,text.options.touchOfDeath)
            br.ui:createCheckbox(section,text.options.useDisable)
            br.ui:createCheckbox(section,text.options.PullAllTargets)
            br.ui:createSpinner(section,text.options.aoeNumber,4,1,10,1,"|cffFFBB00Number of enemies in front to enable AOE routines")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile,"Consumables")
            br.ui:createCheckbox(section,text.consumables.onlyUseConsumablesInRaid)
            br.player.module.PhialUp(section)
            br.player.module.CombatPotionUp(section)
            br.player.module.ImbueUp(section)
            br.player.module.BasicHealing(section)
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile,text.interrupts.title)
            br.ui:createSpinner(section, colors.yellow .. "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
            br.ui:createCheckbox(section,text.interrupts.useSpearHandStrike)
            br.ui:createCheckbox(section,text.interrupts.useLegSweep)
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile,  text.cooldowns.title)
            br.ui:createSpinner(section,text.cooldowns.aoeOverrideCoolowns,4,2,10,1,"|cffFFBB00Number of Targets to allow CDs")
            br.ui:createCheckbox(section,text.cooldowns.fortifyingBrew)
            br.ui:createCheckbox(section,text.cooldowns.invokeXuenTheWhiteTiger)
            br.ui:createCheckbox(section,text.cooldowns.summonWhiteStatuue)
            br.ui:createCheckbox(section,text.cooldowns.touchOfKarma)
            br.ui:createCheckbox(section,text.cooldowns.useSerenity)
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile,text.defensive.title)
                br.ui:createCheckbox(section,text.defensive.useDetox)
                br.ui:createCheckbox(section,text.defensive.useDetoxOnParty)
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
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
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local buff
local debuff
local cast
local cd
local charges
local enemies
local module
local power
local talent
local ui
local unit
local units
local var
local chi
local has
local chiMax
local chiDefecit
local fight_remains
local energy


local function boolNumeric(value)
    if value then return 1 end
    return 0
end

local function printStats(message)

    local chiString
    local powerString
    local xuenString = ""
    local whiteStatueString = ""
    local serentityString = ""
    chiString = colors.white .. "[CHI:" .. chi .. "]".. colors.white
    powerString = colors.white .. "[PWR:" .. string.format("%03d",power) .. "]".. colors.white
    if var.hasWhiteTigerStatue then
        whiteStatueString = colors.white .. "[" .. colors.green .. "WTS:" .. math.floor(var.WhiteTigerStatueTTL) .. colors.white .. "]" .. colors.white
    else
        whiteStatueString = colors.white .. "[" .. colors.red .. "WTS" .. colors.white .. "]" .. colors.white
    end
    if var.hasXuen then
        xuenString = colors.white .. "[" .. colors.green .. "X:" .. math.floor(var.XuenTTL) .. colors.white .. "]" .. colors.white
    else
        xuenString = colors.white .. "[" .. colors.red .. "X" .. colors.white .. "]" .. colors.white
    end
    if buff.serenity.exists() then
        serentityString = colors.white .. "[" .. colors.green .. "+SER" .. colors.white .. "]" .. colors.white
    else
        serentityString = colors.white .. "[" .. colors.red .. "-SER" .. colors.white .. "]" .. colors.white
    end

    local lastTime = ui.time() - var.lastCast
    br._G.print(colors.red.. date("%T") ..colors.aqua .."[+" .. string.sub(tostring(lastTime),0,4) .. "]" .. xuenString .. whiteStatueString .. serentityString .. colors.white .. chiString .. powerString .. colors.white .. " : ".. message)
end

local debugMessage = function(message)
    if ui.mode.Debug == 1 then printStats(message) end
    var.lastCast = ui.time()
end

-- local function checkTiming(message)
--     if ui.mode.Debug == 1 then
--         if (ui.time() - var.lastCast > 2 and #enemies.yards5f >= 1) or var.DoTiming ~= nil then
--             printStats("TIMING:" .. message)
--         end
--     end
-- end

local function CanUseCooldown()
    --ui.modes.cooldown
    if ui.mode.CoolDown == 3 then return false end
    if ui.mode.CoolDown == 2 then return true end
    if ui.mode.CoolDown == 1 then
        if (var.inRaid or var.inInstance) and unit.isBoss("target") then return true end
        if #enemies.yards5f >= ui.value(text.cooldowns.aoeOverrideCoolowns) then return true end
    end
    return false
end
local actionList = {} -- Table for holding action lists.
-- Action List - Extra
actionList.Extra = function()

    -- if cast.able.expelHarm() and unit.distance("target") <= 20 then
    --     if cast.expelHarm() then ui.debug("CAST Expel Harm"); return true; end
    -- end

    -- if unit.inCombat() and unit.valid("target") then
    --     if unit.distance("target") <= 20 and cast.able.expelHarm() and power >= 15 and chi <= 5 then
    --         if cast.expelHarm() then ui.debug("CAST Expel Harm"); return true; end
    --     end
    --     if unit.distance("target") <= 40 and unit.distance("target") >= 10  and cast.able.chiBurst() and chi <= 5 then
    --         if cast.chiBurst("target") then ui.debug("CAST Chi Burst"); return true; end
    --     end
    -- end

end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if br.canDispel("player") and cast.able.detox() then
        if cast.detox() then debugMessage("DETOX") return true end
    end
end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()
    if ui.useInterrupt() and ui.delay("Interrupts",unit.gcd(true)) then
        local thisUnit
        for i=1, #enemies.yards5f do
            thisUnit = enemies.yards5f[i]
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                if ui.checked(text.interrupts.useSpearHandStrike) and cast.able.spearHandStrike(thisUnit) then
                    if cast.spearHandStrike(thisUnit) then debugMessage("Casting Spear Hand Strike on "..unit.name(thisUnit)) return true end
                end
            end
        end
        for i=1, #enemies.yards6 do
            thisUnit = enemies.yards6[i]
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                if ui.checked(text.interrupts.useLegSweep) and cast.able.legSweep() then
                    if cast.legSweep() then debugMessage("Casting Leg Sweep") return true end
                end
            end
        end
    end
end

-- Action List - Cooldowns
actionList.Cooldown = function()
    if ui.checked("Use Serenity") and cast.able.serenity() then
        if cast.serenity() then ui.debug("CAST serenity"); return true; end
    end
end
-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Logic based on pull timers (IE: DBM/BigWigs)
        end -- End Pre-Pull
        if unit.valid("target") then -- Abilities below this only used when target is valid

            if unit.distance("target") <= 40 then
                if cast.able.chiWave() then
                    if cast.chiWave() then ui.debug("RANGE: Chi Wave"); return true; end;
                end
                if unit.distance("target") >= 6 and not unit.moving() and cast.able.cracklingJadeLightning("target") then
                    if cast.cracklingJadeLightning("target") then ui.debug("RANGE: Crackling Jade Lightning"); return true; end;
                end
            end
            -- Start Attack
            if unit.distance("target") < 5 then -- Starts attacking if enemy is within 5yrds
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                end
            end
        end
    end -- End No Combat
end
actionList.Opener = function ()
    if CanUseCooldown() and cast.able.summonWhiteTigerStatue("target") then
        if cast.summonWhiteTigerStatue("target") then debugMessage("OPEN: White Tiger Statue") return true end
    end
    if talent.chiBurst and chiMax-chi >= 3 and cast.able.chiBurst() then
        if cast.chiBurst() then debugMessage("OPEN: Chi Burst") return true end
    end
    if cast.able.jadefireStomp() and ( debuff.skyreachExhaustion.remains() < 2) then
        if cast.jadefireStomp() then debugMessage("OPEN: Jadefire Stomp") return true end
    end
    if talent.chiBurst and chi == 3 and cast.able.expelHarm() then
        if cast.expelHarm() then debugMessage("OPEN: Expel Harm") return true end
    end
    if cast.able.expelHarm() then
        if cast.expelHarm() then debugMessage("OPEN: Expel Harm") return true end
    end
    if cast.able.chiBurst() and (chi > 1 and chiMax-chi >= 3) then
        if cast.chiBurst() then debugMessage("OPEN: Chi-Burst") return true end
    end
end
actionList.bdb_setup = function()
-- actions.bdb_setup=strike_of_the_windlord,target_if=max:debuff.keefers_skyreach.remains,if=talent.thunderfist&active_enemies>3
-- actions.bdb_setup+=/bonedust_brew,if=spinning_crane_kick.max&chi>=4
-- actions.bdb_setup+=/tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.skyreach_exhaustion.up*20),if=combo_strike&chi.max-chi>=2&buff.storm_earth_and_fire.up
-- actions.bdb_setup+=/blackout_kick,target_if=min:debuff.mark_of_the_crane.remains-spinning_crane_kick.max*(target.time_to_die+debuff.keefers_skyreach.remains*20),if=combo_strike&!talent.whirling_dragon_punch&!spinning_crane_kick.max
-- actions.bdb_setup+=/rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains-spinning_crane_kick.max*(target.time_to_die+debuff.keefers_skyreach.remains*20),if=combo_strike&chi>=5&talent.whirling_dragon_punch
-- actions.bdb_setup+=/rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains-spinning_crane_kick.max*(target.time_to_die+debuff.keefers_skyreach.remains*20),if=combo_strike&active_enemies>=2&talent.whirling_dragon_punch
end
actionList.cd_sef = function()
    if cast.able.summonWhiteTigerStatue() then
        --if=!cooldown.invoke_xuen_the_white_tiger.remains|active_enemies>4|cooldown.invoke_xuen_the_white_tiger.remains>50|fight_remains<=30
        if (#enemies.yards5>4 or cd.invokeXuenTheWhiteTiger.remains()>50 or unit.ttdGroup(40) <=30) then
            if cast.summonWhiteTigerStatue("target") then debugMessage("CDSEF: White Tiger Statue") return true end
        end
        --invoke_xuen_the_white_tiger,if=!variable.hold_xuen&target.time_to_die>25&talent.bonedust_brew&cooldown.bonedust_brew.remains<=5&
        if cast.able.invokeXuenTheWhiteTiger() and (
            not var.hold_xuen and unit.ttd("target") >25 and talent.bonedustBrew and cd.bonedustBrew.remains <= 5 and (
                #enemies.yards5 <3 and chi >=3 or #enemies.yards5 >=3 and chi>=2) or unit.ttdGroup(40) < 25
        ) then
            if cast.invokeXuenTheWhiteTiger() then debugMessage("CDSEF: Xuen the White Tiger") return true end
        end
        --actions.cd_sef+=/invoke_xuen_the_white_tiger,if=target.time_to_die>25&fight_remains>120|fight_remains<60
        --&(debuff.skyreach_exhaustion.remains<2|debuff.skyreach_exhaustion.remains>55)&!cooldown.serenity.remains&active_enemies<3|buff.bloodlust.up|fight_remains<23
        if cast.able.invokeXuenTheWhiteTiger() and (
            unit.ttd("target")>24 and unit.ttdGroup(40)>120 or unit.ttdGroup(40)<60 and
            (debuff.skyreachExhaustion.remains("target")<2 or debuff.skyreachExhaustion.remains("target")>55) and not cd.serenity.remains()>0 and #enemies.yards5<3 or buff.bloodlust.exists() or unit.ttdGroup(40)<23
        ) then
            if cast.invokeXuenTheWhiteTiger() then debugMessage("CDSEF: Xuen the White Tiger") return true end
        end
        --actions.cd_sef+=/storm_earth_and_fire,if=talent.bonedust_brew
        --&(fight_remains<30&cooldown.bonedust_brew.remains<4&chi>=4|buff.bonedust_brew.up|!spinning_crane_kick.max&active_enemies>=3&cooldown.bonedust_brew.remains<=2&chi>=2)
        --&(pet.xuen_the_white_tiger.active|cooldown.invoke_xuen_the_white_tiger.remains>cooldown.storm_earth_and_fire.full_recharge_time)
        if cast.able.stormEarthAndFire() and (
            talent.bonedustBrew
        ) then
            if cast.stormEarthAndFire() then debugMessage("CDSEF: Storm Earth and Fire") return true end
        end


    end

end
actionList.cd_serenity = function()
-- actions.cd_serenity=summon_white_tiger_statue,if=!cooldown.invoke_xuen_the_white_tiger.remains|active_enemies>4|cooldown.invoke_xuen_the_white_tiger.remains>50|fight_remains<=30
    if cast.able.summonWhiteTigerStatue("target") and (cd.invokeXuenTheWhiteTiger.ready() or #enemies.yards5 > 4 or cd.invokeXuenTheWhiteTiger.remains()>50 or unit.ttdGroup(40) <= 30) then
        if cast.summonWhiteTigerStatue("target") then debugMessage("SER: White Tiger Statue") return true end
    end
-- # Use <a href='https://www.wowhead.com/spell=10060/power-infusion'>Power Infusion</a> while <a href='https://www.wowhead.com/spell=123904/invoke-xuen-the-white-tiger'>Invoke Xuen, the White Tiger</a> is active.
-- actions.cd_serenity+=/invoke_external_buff,name=power_infusion,if=pet.xuen_the_white_tiger.active

-- actions.cd_serenity+=/invoke_xuen_the_white_tiger,if=!variable.hold_xuen&talent.bonedust_brew&cooldown.bonedust_brew.remains<=5&target.time_to_die>25|buff.bloodlust.up|fight_remains<25
    if cast.able.invokeXuenTheWhiteTiger() and (not var.hold_xuen and unit.ttd("target")>25 or unit.ttdGroup(40) < 25) then
        if cast.invokeXuenTheWhiteTiger() then debugMessage("SER: Invoke Xuen The White Tiger") return true end
    end
-- actions.cd_serenity+=/invoke_xuen_the_white_tiger,if=target.time_to_die>25&fight_remains>120|fight_remains<60&(debuff.skyreach_exhaustion.remains<2|debuff.skyreach_exhaustion.remains>55)&!cooldown.serenity.remains&active_enemies<3|buff.bloodlust.up|fight_remains<23
    if cast.able.invokeXuenTheWhiteTiger() and (unit.ttd("target")>120 or unit.ttdGroup(40) < 60 and (debuff.skyreachExhaustion.remains("target")<2) or debuff.skyreachExhaustion.remains("target")>55) and cd.serenity.ready() and #enemies.yards5<3 or unit.ttdGroup(40)< 23 then
        if cast.invokeXuenTheWhiteTiger() then debugMessage("SER: Invoke Xuen The White Tiger") return true end
    end
-- actions.cd_serenity+=/bonedust_brew,if=buff.invokers_delight.up|!buff.bonedust_brew.up&(cooldown.serenity.up|cooldown.serenity.remains>15|fight_remains<30&fight_remains>10)|fight_remains<10
-- actions.cd_serenity+=/serenity,if=variable.sync_serenity&(buff.invokers_delight.up|variable.hold_xuen
--&(talent.drinking_horn_cover&fight_remains>110|!talent.drinking_horn_cover&fight_remains>105))|!talent.invoke_xuen_the_white_tiger|fight_remains<15
    if cast.able.serenity() and (
        var.sync_serenity and (buff.invokersDelight.exists() or var.hold_xuen and (talent.drinkingHornCover and unit.ttdGroup(40)>110 or not talent.drinkingHornCover and unit.ttdGroup(40)>105)) or not talent.invokeXuenTheWhiteTiger or unit.ttdGroup(40) < 15
    ) then
        if cast.serenity() then debugMessage("SER: Serenity") return true end
    end
-- actions.cd_serenity+=/serenity,if=!variable.sync_serenity&(buff.invokers_delight.up|cooldown.invoke_xuen_the_white_tiger.remains>fight_remains|fight_remains>(cooldown.invoke_xuen_the_white_tiger.remains+10)&fight_remains>90)
    if cast.able.serenity() and (not var.sync_serenity and (buff.invokersDelight.exists() or cd.invokeXuenTheWhiteTiger.remains() > unit.ttdGroup(40) or unit.ttdGroup(40) > (cd.invokeXuenTheWhiteTiger.remains+10) and unit.ttdGroup(40) > 90)) then
        if cast.serenity() then debugMessage("SER: Serenity") return true end
    end
-- actions.cd_serenity+=/touch_of_death,target_if=max:target.health,if=fight_style.dungeonroute&!buff.serenity.up&(combo_strike&target.health<health)|(buff.hidden_masters_forbidden_touch.remains<2)|(buff.hidden_masters_forbidden_touch.remains>target.time_to_die)
    if cast.able.touchOfDeath("target") then
        --if cast.touchOfDeath("target") then debugMessage("SER: Touch of Death") return true end
    end
-- actions.cd_serenity+=/touch_of_death,cycle_targets=1,if=fight_style.dungeonroute&combo_strike&(target.time_to_die>60|debuff.bonedust_brew_debuff.up|fight_remains<10)&!buff.serenity.up
-- actions.cd_serenity+=/touch_of_death,cycle_targets=1,if=!fight_style.dungeonroute&combo_strike&!buff.serenity.up
-- actions.cd_serenity+=/touch_of_karma,if=fight_remains>90|fight_remains<10
    if cast.able.touchOfKarma() and (unit.ttdGroup(40)>90 or unit.ttdGroup(40)<10) then
        if cast.touchOfKarma() then debugMessage("SER: Touch of Karma") return true end
    end
-- actions.cd_serenity+=/blood_fury,if=buff.serenity.up|fight_remains<20
-- actions.cd_serenity+=/berserking,if=!buff.serenity.up|fight_remains<20
-- actions.cd_serenity+=/lights_judgment
-- actions.cd_serenity+=/fireblood,if=buff.serenity.up|fight_remains<20
-- actions.cd_serenity+=/ancestral_call,if=buff.serenity.up|fight_remains<20
-- actions.cd_serenity+=/bag_of_tricks,if=buff.serenity.up|fight_remains<20
end
actionList.default_st = function()
-- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.skyreach_exhaustion.up*20),
--if=combo_strike&chi<2&(cooldown.rising_sun_kick.remains<1|cooldown.fists_of_fury.remains<1|cooldown.strike_of_the_windlord.remains<1)
--&buff.teachings_of_the_monastery.stack<3
    if var.unitsMinMarkOfTheCrane ~= nil and cast.able.tigerPalm() and not cast.last.tigerPalm() and (
        chi<2 and (cd.risingSunKick.remains()<1 or cd.fistsOfFury.remains()<1 or cd.strikeOfTheWindlord.remains()<1) and buff.teachingsOfTheMonastery.stack()<3
    ) then
        if cast.tigerPalm("target") then debugMessage("ST.01: Tiger Palm") return true end
    end

--actions.default_st+=/expel_harm,if=chi=1&(!cooldown.rising_sun_kick.remains|!cooldown.strike_of_the_windlord.remains)|chi=2&!cooldown.fists_of_fury.remains&cooldown.rising_sun_kick.remains
    if cast.able.expelHarm() and (
        chi==1 and (cd.risingSunKick.ready() or cd.strikeOfTheWindlord.ready()) or chi==2 and cd.fistsOfFury.ready() and cd.risingSunKick.remains()>0
    ) then
        if cast.expelHarm() then debugMessage("ST.02: Expel Harm") return true end
    end

-- actions.default_st+=/strike_of_the_windlord,if=buff.domineering_arrogance.up&talent.thunderfist&talent.serenity&cooldown.invoke_xuen_the_white_tiger.remains>20|fight_remains<5|talent.thunderfist&debuff.skyreach_exhaustion.remains>10&!buff.domineering_arrogance.up|talent.thunderfist&debuff.skyreach_exhaustion.remains>35&!talent.serenity
    if cast.able.strikeOfTheWindlord() and (
        buff.domineeringArrogance.exists() and talent.thunderfist and talent.serenity and cd.invokeXuenTheWhiteTiger.remains()>20 or var.fight_remains < 5 or talent.thunderfist and debuff.skyreachExhaustion.remains("target") > 10 and not buff.domineeringArrogance.exists() or talent.thunderfist and debuff.skyreachExhaustion.remains("target") > 35 and not talent.serenity
    ) then
        if cast.strikeOfTheWindlord() then debugMessage("ST.03: Strike of the Windlord") return true end
    end

    -- actions.default_st+=/spinning_crane_kick,target_if=max:target.time_to_die,if=target.time_to_die>duration&combo_strike&buff.dance_of_chiji.up&set_bonus.tier31_2pc&!buff.blackout_reinforcement.up
    if cast.able.spinningCraneKick() and not cast.last.spinningCraneKick() then
   --     if unit.ttd("target") >
    end

-- actions.default_st+=/rising_sun_kick,if=!cooldown.fists_of_fury.remains
    if cast.able.risingSunKick("target") and (cd.fistsOfFury.ready()) then
        if cast.risingSunKick("target") then debugMessage("ST: Rising Sun Kick") return true end
    end
-- actions.default_st+=/fists_of_fury,if=!buff.pressure_point.up&debuff.skyreach_exhaustion.remains<55
    if cast.able.fistsOfFury() and (not buff.pressurePoint.exists() and debuff.skyreachExhaustion.remains("target")<55) then
        if cast.fistsOfFury() then debugMessage("ST: Fists of Fury") return true end
    end
-- actions.default_st+=/faeline_stomp,if=debuff.skyreach_exhaustion.remains<1&debuff.fae_exposure_damage.remains<3
    if cast.able.jadefireStomp() and (debuff.skyreachExhaustion.remains("target")<1) then
        if cast.jadefireStomp() then debugMessage("ST:Jadefire Stomp") return true end
    end
-- actions.default_st+=/rising_sun_kick,,if=buff.pressure_point.up|debuff.skyreach_exhaustion.remains>55
    if cast.able.risingSunKick("target") and (buff.pressurePoint.exists() and debuff.skyreachExhaustion.remains("target") > 55) then
        if cast.risingSunKick("target") then debugMessage("ST:Rising Sun Kick") return true end
    end
-- actions.default_st+=/blackout_kick,if=buff.pressure_point.remains&chi>2&prev.rising_sun_kick
    if cast.able.blackoutKick("target") and (buff.pressurePoint.exists() and chi > 2 and cast.last.risingSunKick()) then
        if cast.blackoutKick("target") then debugMessage("ST: Blackout Kick") return true end
    end
-- actions.default_st+=/spinning_crane_kick,if=combo_strike&buff.dance_of_chiji.up&set_bonus.tier31_4pc&!buff.blackout_reinforcement.up
    if cast.able.spinningCraneKick() and (buff.hitCombo.exists() and buff.danceOfChiJi.exists()) then
        if cast.spinningCraneKick() then debugMessage("ST: Spinning Crane Kick") return true end
    end
-- actions.default_st+=/rising_sun_kick,if=buff.kicks_of_flowing_momentum.up|buff.pressure_point.up|debuff.skyreach_exhaustion.remains>55
    if cast.able.risingSunKick("target") and (buff.kicksOfFlowingMomentum.exists() or buff.pressurePoint.exists() or debuff.skyreachExhaustion.remains("target")> 55) then
        if cast.risingSunKick("target") then debugMessage("ST: Rising Sun Kick") return true end
    end
-- actions.default_st+=/blackout_kick,if=buff.teachings_of_the_monastery.stack=3
    if cast.able.blackoutKick("target") and buff.teachingsOfTheMonastery.stack() == 3 and not cast.last.blackoutKick() then
        if cast.blackoutKick("target") then debugMessage("ST: Blackout Kick") return true end
    end
-- actions.default_st+=/rising_sun_kick
    if cast.able.risingSunKick("target") then
        if cast.risingSunKick("target") then debugMessage("ST: Rising Sun Kick") return true end
    end
-- actions.default_st+=/blackout_kick,if=buff.blackout_reinforcement.up&cooldown.rising_sun_kick.remains&cooldown.strike_of_the_windlord.remains&combo_strike&buff.dance_of_chiji.up
    if cast.able.blackoutKick("target") and not cast.last.blackoutKick() and (not cd.risingSunKick.ready() and not cd.strikeOfTheWindlord.ready() and buff.hitCombo.exists() and buff.danceOfChiJi.exists()) then
        if cast.blackoutKick("target") then debugMessage("ST: Blackout Kick") return true end
    end
-- actions.default_st+=/fists_of_fury
    if cast.able.fistsOfFury() then
        if cast.fistsOfFury() then debugMessage("ST: Fists of Fury") return true end
    end
-- actions.default_st+=/blackout_kick,if=buff.blackout_reinforcement.up&combo_strike
    if cast.able.blackoutKick("target") and (buff.blackoutReinforcement.exists() and buff.hitCombo.exists()) and not cast.last.blackoutKick() then
        if cast.blackoutKick("target") then debugMessage("ST: Blackout Kick") return true end
    end
-- actions.default_st+=/whirling_dragon_punch,if=!buff.pressure_point.up
    if cast.able.whirlingDragonPunch() and not buff.pressurePoint.exists() then
        if cast.whirlingDragonPunch() then debugMessage("ST: Whirling Dragon Punch") return true end
    end
-- actions.default_st+=/chi_burst,if=buff.bloodlust.up&chi<5
    -- if cast.able.chiBurst() and buff.bloodlust.exists() and chi < 5 then
    --     if cast.chiBurst() then debugMessage("ST: Chi Burst") return true end
    -- end
-- actions.default_st+=/blackout_kick,if=buff.teachings_of_the_monastery.stack=2&debuff.skyreach_exhaustion.remains>1
    if cast.able.blackoutKick("target") and buff.teachingsOfTheMonastery.stack()==2 and debuff.skyreachExhaustion.remains("target") > 1  and not cast.last.blackoutKick() then
        if cast.blackoutKick("target") then debugMessage("ST: blackout kick") return true end
    end
-- actions.default_st+=/chi_burst,if=chi<5&energy<50
    if cast.able.chiBurst() and chi < 5 and power < 50 then
        if cast.chiBurst() then debugMessage("ST: Chi Burst") return true end
    end
-- actions.default_st+=/strike_of_the_windlord,if=debuff.skyreach_exhaustion.remains>30|fight_remains<5
    if cast.able.strikeOfTheWindlord() and debuff.skyreachExhaustion.remains("target")>30 or unit.ttdGroup(40) < 5 then
        if cast.strikeOfTheWindlord() then debugMessage("ST: Strike of the Windlord") return true end
    end
-- actions.default_st+=/spinning_crane_kick,if=combo_strike&buff.dance_of_chiji.up&!set_bonus.tier31_2pc
    if cast.able.spinningCraneKick() and buff.hitCombo.exists() and buff.danceOfChiJi.exists() then
        if cast.spinningCraneKick() then debugMessage("ST: Spinning Crane Kick") return true end
    end


-- actions.default_st+=/blackout_kick,if=buff.teachings_of_the_monastery.up&cooldown.rising_sun_kick.remains>1
    if cast.able.blackoutKick("target") and buff.teachingsOfTheMonastery.exists() and cd.risingSunKick.remains() > 1 and not cast.last.blackoutKick() then
        if cast.blackoutKick("target") then debugMessage("ST: Blackout Kick") return true end
    end
-- actions.default_st+=/spinning_crane_kick,if=buff.bonedust_brew.up&combo_strike&spinning_crane_kick.modifier>=2.7
    if cast.able.spinningCraneKick() and buff.bonedustBrew.exists() and buff.hitCombo.exists() then
        if cast.spinningCraneKick() then debugMessage("ST: Spinning Crane Kick") return true end
    end
-- actions.default_st+=/whirling_dragon_punch
    if cast.able.whirlingDragonPunch() then
        if cast.whirlingDragonPunch() then debugMessage("ST: whirling Dragon Punch") return true end
    end
-- actions.default_st+=/rushing_jade_wind,if=!buff.rushing_jade_wind.up
    if cast.able.rushingJadeWind() and not buff.rushingJadeWind.exists() then
        if cast.rushingJadeWind() then debugMessage("ST: Rushing Jade Wind") return true end
    end
-- actions.default_st+=/blackout_kick,if=combo_strike
    if cast.able.blackoutKick("target") and buff.hitCombo.exists() and not cast.last.blackoutKick() then
        if cast.blackoutKick("target") then debugMessage("ST: blackout Kick") return true end
    end
end
actionList.fallthru = function()
-- actions.fallthru=crackling_jade_lightning,if=buff.the_emperors_capacitor.stack>19&energy.time_to_max>execute_time-1&cooldown.rising_sun_kick.remains>execute_time|buff.the_emperors_capacitor.stack>14&(cooldown.serenity.remains<5&talent.serenity|fight_remains<5)
-- actions.fallthru+=/faeline_stomp,if=combo_strike
    if cast.able.jadefireStomp() and buff.hitCombo.exists() then
        if cast.jadefireStomp() then debugMessage("FallThru: Jadefire Stomp") return true end
    end
-- actions.fallthru+=/tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.skyreach_exhaustion.up*20),if=combo_strike&chi.max-chi>=(2+buff.power_strikes.up)

    if var.unitsMinMarkOfTheCrane ~= nil and cast.able.tigerPalm(var.unitsMinMarkOfTheCrane) and ( (buff.hitCombo.exists() and not cast.last.tigerPalm()) and chiDefecit>=(2+buff.powerStrikes.stack())) then
        if cast.tigerPalm(var.unitsMinMarkOfTheCrane) then debugMessage("FallThru: Tiger Palm") return true end
    end
-- actions.fallthru+=/expel_harm,if=chi.max-chi>=1&active_enemies>2
    if cast.able.expelHarm() and chiMax-chi >= 1 and #enemies.yards5 > 2 then
        if cast.expelHarm() then debugMessage("FallThru: Expel Harm") return true end
    end
-- actions.fallthru+=/chi_burst,if=chi.max-chi>=1&active_enemies=1&raid_event.adds.in>20|chi.max-chi>=2&active_enemies>=2
    if cast.able.chiBurst() and (chiMax-chi >= 1 and #enemies.yards5f==1 or chiMax-chi >= 2 and #enemies.yards5f >= 2) then
        if cast.chiBurst() then debugMessage("FallThru: Chi Burst") return true end
    end
-- actions.fallthru+=/chi_wave
    if cast.able.chiWave() then
        if cast.chiWave() then debugMessage("FallThru: Chi Wave") return true end
    end
-- actions.fallthru+=/expel_harm,if=chi.max-chi>=1
    if cast.able.expelHarm() and chiMax-chi >= 1 then
        if cast.expelHarm() then debugMessage("FallThru: Expel harm") return true end
    end
-- actions.fallthru+=/blackout_kick,target_if=min:debuff.mark_of_the_crane.remains-spinning_crane_kick.max*(target.time_to_die+debuff.keefers_skyreach.remains*20),if=combo_strike&active_enemies>=5
    --TODO

-- actions.fallthru+=/spinning_crane_kick,if=combo_strike&buff.chi_energy.stack>30-5*active_enemies&buff.storm_earth_and_fire.down&(cooldown.rising_sun_kick.remains>2&cooldown.fists_of_fury.remains>2|cooldown.rising_sun_kick.remains<3&cooldown.fists_of_fury.remains>3&chi>3|cooldown.rising_sun_kick.remains>3&cooldown.fists_of_fury.remains<3&chi>4|chi.max-chi<=1&energy.time_to_max<2)|buff.chi_energy.stack>10&fight_remains<7
    -- if cast.able.spinningCraneKick() and (
    --     buff.hitCombo.exists and buff.chiEn
    -- ) then
    --     if cast.spinningCraneKick() then debugMessage("FallThru: Spinning Crane Kick") return true end
    -- end

-- actions.fallthru+=/arcane_torrent,if=chi.max-chi>=1
    --if cast.able.arcaneTorrent()
-- actions.fallthru+=/flying_serpent_kick,interrupt=1
-- actions.fallthru+=/tiger_palm
end
actionList.aoe = function()
    if chiDefecit >= 3 and not cast.last.tigerPalm() and var.unitsMinMarkOfTheCrane ~= nil and cast.able.tigerPalm(var.unitsMinMarkOfTheCrane) then
        if cast.tigerPalm(var.unitsMinMarkOfTheCrane) then debugMessage("AOE: TP on Min Unit") return true end
    end
end






----------------
--- ROTATION ---
----------------
local function runRotation() -- This is the main profile loop, any below this point is ran every cycle, everything above is ran only once during initialization.
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals - These are the same as the locals above just defined for use.
    buff                                          = br.player.buff
    debuff                                        = br.player.debuff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    enemies                                       = br.player.enemies
    module                                        = br.player.module
    power                                         = br.player.power.energy()
    energy                                        = br.player.power.energy()
    talent                                        = br.player.talent
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    var                                           = br.player.variables
    chi                                           = br.player.power.chi()
    has                                           = br.player.has
    chiMax                                        = br.player.power.chi.max()
    chiDefecit                                    = chiMax-chi
    fight_remains                                 = unit.ttdGroup(40)

        ui.mode.AutoPull        = br.data.settings[br.selectedSpec].toggles["Autopull"]
        ui.mode.CoolDown        = br.data.settings[br.selectedSpec].toggles["Cooldown"]
        ui.mode.Rotation        = br.data.settings[br.selectedSpec].toggles["Rotation"]
        ui.mode.Debug           = br.data.settings[br.selectedSpec].toggles["Debugs"]

    local validTargets=nil

    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    enemies.get(6)
    enemies.get(10)
    enemies.get(15)
    enemies.get(20)
    enemies.get(25)
    enemies.get(30)
    enemies.get(35)
    enemies.get(40)
    enemies.get(5,"player",false,true)  --enemies.yards5f
    enemies.get(10,"player",false,true)  --enemies.yards5f
    enemies.get(40,"player",false,true)  --enemies.yards40f
    var.active_enemies = #enemies.yards10

--variable,name=hold_xuen,op=set,value=!talent.invoke_xuen_the_white_tiger|cooldown.invoke_xuen_the_white_tiger.duration>fight_remains
var.hold_xuen = not talent.invokeXuenTheWhiteTiger or cd.invokeXuenTheWhiteTiger.duration > unit.ttdGroup(40)

--variable,name=hold_tp_rsk,op=set,value=!debuff.skyreach_exhaustion.remains<1&cooldown.rising_sun_kick.remains<1&(set_bonus.tier30_2pc|active_enemies<5)
var.hold_tp_rsk = not (debuff.skyreachExhaustion.remains("target") < 1) and
                      (cd.risingSunKick.remains() < 1) and
                      (#enemies.yards5 < 5)
--actions+=/variable,name=hold_tp_bdb,op=set,value=!debuff.skyreach_exhaustion.remains<1&cooldown.bonedust_brew.remains<1&active_enemies=1
var.hold_tp_bdb = not (debuff.skyreachExhaustion.remains("target") < 1)
                    and (cd.bonedustBrew.remains() < 1)
                    and (var.active_enemies==1)


if var.lastCast == nil then var.lastCast=ui.time() end



 var.unitsMinMarkOfTheCrane = nil
 local TPUnits = {}
 if talent.skyreach or talent.skytouch then
    TPUnits = enemies.yards10f
 else
    TPUnits = enemies.yards5f
 end
local minVal = 9999
for i=1,#TPUnits do
    local thisUnit = TPUnits[i]
    local targetVal = debuff.markOfTheCrane.remains()+(boolNumeric(debuff.skyreachExhaustion.exists(thisUnit))*20)
    if targetVal < minVal then
        var.unitsMinMarkOfTheCrane = thisUnit
        minVal = targetVal
    end
end

var.hasWhiteTigerStatue = false
var.WhiteTigerStatueTTL = 0
var.hasXuen = false
var.XuenTTL = 0
for index = 1,5 do
    local exists, totemName, startTime, duration, icon = GetTotemInfo(index)
    if exists then
        local estimateDuration = br.round2(startTime + duration - GetTime())
        if icon == 4667418 then
            var.hasWhiteTigerStatue = true
            var.WhiteTigerStatueTTL = estimateDuration
        end
        if icon == 620832 then
            var.hasXuen = true
            var.XuenTTL = estimateDuration + 4
        end
    end
end



    ------------------------
    --- Custom Variables ---
    ------------------------
    -- Any other local varaible from above would also need to be defined here to be use.
    if var.profileStop == nil then var.profileStop = false end -- Trigger variable to help when needing to stop a profile.


    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then -- Reset profile stop once stopped
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then -- If profile triggered to stop go here until it has.
        return true
    else -- Profile is free to perform actions

        --------------
        --- Extras ---
        --------------
        if actionList.Extra() then return true end
        if actionList.Defensive() then return true end
        if actionList.PreCombat() then return true end

        if unit.inCombat() and unit.valid("target") and not var.profileStop then
            if actionList.Interrupt() then return true end

            --actions+=/potion,if=buff.serenity.up|buff.storm_earth_and_fire.up&pet.xuen_the_white_tiger.active|fight_remains<=30
            if buff.serenity.exists() or buff.stormEarthAndFire.exists() and var.hasXuen or fight_remains <= 30 then
                if (ui.checked(text.consumables.onlyUseConsumablesInRaid) and (var.inInstance or var.inRaid)) or not (ui.checked(text.consumables.onlyUseConsumablesInRaid)) then
                    if module.CombatPotionUp() then return true end
                end
            end

            --actions+=/call_action_list,name=opener,if=time<4&chi<5&!pet.xuen_the_white_tiger.active&!talent.serenity
            if unit.combatTime() < 4 and chi < 5 and not var.hasXuen and not talent.serenity  then
                if actionList.Opener() then return true end
            end

            --actions+=/jadefire_stomp,target_if=min:debuff.jadefire_brand_damage.remains,if=combo_strike&talent.jadefire_harmony&debuff.jadefire_brand_damage.remains<1
            if talent.jadefireHarmony  and cast.able.jadefireStomp() and (not debuff.jadefireBrand.exists("target") or debuff.jadefireBrand.remains("target") < 1) then
                if cast.jadefireStomp() then debugMessage("Jadefire Stomp") return true end
            end

            --TODO Bonedust Brew
            --actions+=/bonedust_brew,if=active_enemies=1&!debuff.skyreach_exhaustion.remains&(pet.xuen_the_white_tiger.active|cooldown.xuen_the_white_tiger.remains)

            --TP to not waste energy
            --actions+=/tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.skyreach_exhaustion.up*20),
            --if=!buff.serenity.up&energy>50&buff.teachings_of_the_monastery.stack<3&combo_strike&chi.max-chi>=(2+buff.power_strikes.up)
            --&(!talent.invoke_xuen_the_white_tiger&!talent.serenity|((!talent.skyreach&!talent.skytouch)|time>5|pet.xuen_the_white_tiger.active))
            --&!variable.hold_tp_rsk&(active_enemies>1|!talent.bonedust_brew|talent.bonedust_brew&active_enemies=1&cooldown.bonedust_brew.remains)

            if var.unitsMinMarkOfTheCrane ~= nil and cast.able.tigerPalm(var.unitsMinMarkOfTheCrane) and not cast.last.tigerPalm() then
                if not buff.serenity.exists() and energy  > 50 and buff.teachingsOfTheMonastery.stack() < 3  and chiDefecit >= (2+ boolNumeric(buff.powerStrikes.exists()))
                and (not talent.invokeXuenTheWhiteTiger and not talent.serenity or ((not talent.skyreach and not talent.skytouch) or unit.combatTime()>5 or var.hasXuen))
                and not var.hold_tp_rsk and (var.active_enemies > 1 or not talent.bonedustBrew or talent.bonedustBrew and var.active_enemies==1 and cd.bonedustBrew.remains()>0)
                then
                    if cast.tigerPalm(var.unitsMinMarkOfTheCrane) then debugMessage("Energy Burn: Tiger Palm") return true end
                end
            end

            --# TP if not overcapping Chi or TotM
            --actions+=/tiger_palm,target_if=min:debuff.mark_of_the_crane.remains+(debuff.skyreach_exhaustion.up*20),
            --if=!buff.serenity.up&buff.teachings_of_the_monastery.stack<3&combo_strike&chi.max-chi>=(2+buff.power_strikes.up)
            --&(!talent.invoke_xuen_the_white_tiger&!talent.serenity|((!talent.skyreach&!talent.skytouch)|time>5|pet.xuen_the_white_tiger.active))
            --&!variable.hold_tp_rsk&(active_enemies>1|!talent.bonedust_brew|talent.bonedust_brew&active_enemies=1&cooldown.bonedust_brew.remains)

            if var.unitsMinMarkOfTheCrane ~= nil and cast.able.tigerPalm(var.unitsMinMarkOfTheCrane) and not cast.last.tigerPalm() then
                if not buff.serenity.exists() and buff.teachingsOfTheMonastery.stack()<3 and chiDefecit >= (2+boolNumeric(buff.powerStrikes.exists()))
                and(not talent.invokeXuenTheWhiteTiger and not talent.serenity or ((not talent.skyreach and not talent.skytouch) or unit.combatTime()>5 or var.hasXuen))
                and not var.hold_tp_rsk and (var.active_enemies > 1 or not talent.bonedustBrew or talent.bonedustBrew and var.active_enemies==1 and cd.bonedustBrew.remains()>0)
                then
                    if cast.tigerPalm(var.unitsMinMarkOfTheCrane) then debugMessage("TP no Overcap Chi or TotM") return true end
                end
            end

            --# Use Chi Burst to reset jadefire Stomp
            --actions+=/chi_burst,if=talent.jadefire_stomp&cooldown.jadefire_stomp.remains&(chi.max-chi>=1&active_enemies=1|chi.max-chi>=2&active_enemies>=2)
            --&!talent.jadefire_harmony

            if cast.able.chiBurst() and (
                talent.jadefireStomp and cd.jadefireStomp.remains()>0 and (chiDefecit>=1 and var.active_enemies==1 or chiDefecit>=2 and var.active_enemies>=2)
                and not talent.jadefireHarmony
            ) then
                if cast.chiBurst() then debugMessage("Reset JfS: chi burst") return true end
            end

            --# Use Cooldowns
            --actions+=/call_action_list,name=cd_sef,if=!talent.serenity
            --actions+=/call_action_list,name=cd_serenity,if=talent.serenity
            if not talent.serenity and CanUseCooldown() then
                if actionList.cd_sef() then return true end
            end
            if talent.serenity and CanUseCooldown() then
                if actionList.cd_serenity() then return true end
            end

            --#Serenity Priority
            --actions+=/call_action_list,name=serenity_aoelust,if=buff.serenity.up&((buff.bloodlust.up&(buff.invokers_delight.up|buff.power_infusion.up))|buff.invokers_delight.up&buff.power_infusion.up)&active_enemies>4
            --actions+=/call_action_list,name=serenity_lust,if=buff.serenity.up&((buff.bloodlust.up&(buff.invokers_delight.up|buff.power_infusion.up))|buff.invokers_delight.up&buff.power_infusion.up)&active_enemies<4
            --actions+=/call_action_list,name=serenity_aoe,if=buff.serenity.up&active_enemies>4
            --actions+=/call_action_list,name=serenity_st,if=buff.serenity.up&active_enemies=1

            ---actions+=/call_action_list,name=default_aoe,if=active_enemies>4
            --actions+=/call_action_list,name=default_4t,if=active_enemies=4
            --actions+=/call_action_list,name=default_3t,if=active_enemies=3
            --actions+=/call_action_list,name=default_2t,if=active_enemies=2
            --actions+=/call_action_list,name=default_st,if=active_enemies=1

            if var.active_enemies==1 then
                if actionList.default_st() then return true end
            end
            --actions+=/summon_white_tiger_statue
            if cast.able.summonWhiteTigerStatue() and CanUseCooldown() then
                if cast.summonWhiteTigerStatue("target") then return true end
            end

            --actions+=/call_action_list,name=fallthru
            if actionList.fallthru() then return true end



            -- if buff.serenity.exists() and #enemies.yards5 == 1 then
            --     if actionList.serenity_st() then return true end
            -- end

            if cast.able.autoAttack("target") then
                if cast.autoAttack("target") then ui.debug("EOR - Auto Attack") return true end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 269 -- Change to the spec id profile is for. Spec ID can be found at: https://wowpedia.fandom.com/wiki/SpecializationID
-- DO NOT EDIT ANYTHING BELOW THIS LINE, WILL BREAK PROFILE --
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
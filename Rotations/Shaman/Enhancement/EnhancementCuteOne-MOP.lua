-------------------------------------------------------
-- Author = CuteOne
-- Patch = 11.0.2
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 100%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Limited
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = NoRaid
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
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spells.stormstrike },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spells.fireNova },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spells.stormstrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.healingSurge }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.feralSpirit },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spells.feralSpirit },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.feralSpirit }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.astralShift },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.astralShift }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spells.windShear },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.windShear }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        local alwaysCdNever = {"|cff00FF00Always","|cffFFFF00Cooldowns","|cffFF0000Never"}
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Ghost Wolf
            br.ui:createDropdownWithout(section,"Ghost Wolf", {"|cff00FF00Always","|cffFFFF00OoC Only","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Ghost Wolf.")
            -- Feral Lunge
            br.ui:createCheckbox(section,"Feral Lunge")
            -- Lightning Bolt OOC
            br.ui:createCheckbox(section,"Lightning Bolt Out of Combat")
            -- Lightning Filler
            br.ui:createCheckbox(section,"Lightning Filler","Select to use LB/CL when all other abilities are on CD and can cast before any available.")
            -- Lightning Shield
            br.ui:createCheckbox(section, "Lightning Shield")
            -- Water Shield
            br.ui:createSpinner(section, "Water Shield", 30, 0, 100, 5, "|cffFFFFFFMana percent to swap to Water Shield.")
            -- Spirit Walk
            br.ui:createCheckbox(section,"Spirit Walk")
            -- Water Walking
            br.ui:createCheckbox(section,"Water Walking")
            -- Weapon Imbues
            br.ui:createCheckbox(section,"Windfury Weapon")
            br.ui:createCheckbox(section,"Flametongue Weapon")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Ascendance
            br.ui:createDropdownWithout(section,"Ascendance", alwaysCdNever, 1, "|cffFFFFFFWhen to use Ascendance.")
            -- Ancestral Swiftness
            br.ui:createDropdownWithout(section,"Ancestral Swiftness", alwaysCdNever, 1, "|cffFFFFFFWhen to use Ancestral Swiftness.")
            -- Earth Elemental Totem
            br.ui:createDropdownWithout(section,"Earth Elemental", alwaysCdNever, 1, "|cffFFFFFFWhen to use Earth Elemental.")
            -- Elemental Mastery
            br.ui:createDropdownWithout(section,"Elemental Mastery", alwaysCdNever, 1, "|cffFFFFFFWhen to use Elemental Mastery.")
            -- Feral Spirit
            br.ui:createDropdownWithout(section,"Feral Spirit", alwaysCdNever, 1, "|cffFFFFFFWhen to use Feral Spirit.")
            -- Fire Elemental Totem
            br.ui:createDropdownWithout(section,"Fire Elemental", alwaysCdNever, 1, "|cffFFFFFFWhen to use Fire Elemental Totem.")
            -- Stormlash Totem
            br.ui:createDropdownWithout(section,"Stormlash", alwaysCdNever, 1, "|cffFFFFFFWhen to use Stormlash Totem.")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Ancestral Spirit
            br.ui:createDropdown(section, "Ancestral Spirit", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Astral Shift
            br.ui:createSpinner(section, "Astral Shift",  40,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Cleanse Spirit
            br.ui:createDropdown(section, "Cleanse Spirit", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Healing Surge
            br.ui:createSpinner(section, "Healing Surge",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Healing Surge OoC",  90,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Auto/Insta-Heal
            br.ui:createDropdownWithout(section, "Heal Target", { "|cffFFDD11LowestHP", "|cffFFDD11Player"},  1,  "|cffFFFFFFSelect Target to Heal")
            br.ui:createDropdownWithout(section, "Instant Behavior", {"|cff00FF00Always","|cffFFFF00Combat Only","|cffFF0000Never"}, 2, "|cffFFFFFFSelect how to use Instant Heal proc.")
            -- Healing Steam Totem
            br.ui:createSpinner(section, "Healing Stream Totem", 35, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createCheckbox(section, "Use HST While Solo")
            br.ui:createSpinnerWithout(section, "Healing Stream Totem - Min Units", 1, 0, 5, 1, "|cffFFFFFFNumber of Units below HP Level to Cast At")
            -- Lightning Surge Totem
            br.ui:createSpinner(section, "Capacitor Totem - HP", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
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
            br.ui:createDropdownWithout(section, "Rotation Mode", br.ui.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
            br.ui:createDropdownWithout(section, "Cooldown Mode", br.ui.dropOptions.Toggle,  3)
            -- Defensive Key Toggle
            br.ui:createDropdownWithout(section, "Defensive Mode", br.ui.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section, "Interrupt Mode", br.ui.dropOptions.Toggle,  6)
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
local debuff
local enemies
local equiped
local glyph
local mana
local spell
local talent
local totem
local ui
local unit
local units
local var

-- General API Locals
local actionList = {}

-----------------
--- Functions ---
-----------------
-- Cancel a filler lightning cast if it's actively being cast
local function cancelFillerLightning()
    if var.fillerLightningBolt and cast.current.lightningBolt() then
        if cast.cancel.lightningBolt() then
            ui.debug("Canceled Filler Lightning Bolt")
            var.fillerLightningBolt = false
            return true
        end
    end
    if var.fillerChainLightning and cast.current.chainLightning() then
        if cast.cancel.chainLightning() then
            ui.debug("Canceled Filler Chain Lightning")
            var.fillerChainLightning = false
            return true
        end
    end
    return false
end
-- Calculate time until next priority ability is ready
local function getTimeToNextAbility()
    if not unit.exists("target") then return 0 end

    local dist = unit.distance("target") or 99
    local timeToNext = 99

    -- Helper to check cooldown and distance
    local function checkAbility(spellKnown, abilityCD, maxRange)
        -- Only check if spell is known and we're in range
        if spellKnown and dist <= maxRange and abilityCD and abilityCD.exists() then
            local remain = abilityCD.remain()
            -- If ability is ready now or will be ready very soon, return 0
            if remain <= 0 then
                timeToNext = 0
            else
                timeToNext = math.min(timeToNext, remain)
            end
        end
    end

    -- Check all priority abilities based on what's known and in range
    if spell.stormstrike.known() and not buff.ascendance.exists() then
        checkAbility(true, cd.stormstrike, 5)
    end
    if spell.stormblast.known() and buff.ascendance.exists() then
        checkAbility(true, cd.stormblast, 5)
    end
    checkAbility(spell.lavaLash.known(), cd.lavaLash, 5)
    checkAbility(spell.primalStrike.known(), cd.primalStrike, 5)
    checkAbility(spell.flameShock.known(), cd.flameShock, 40)
    checkAbility(spell.earthShock.known(), cd.earthShock, 40)
    checkAbility(spell.frostShock.known(), cd.frostShock, 40)
    checkAbility(spell.unleashElements.known(), cd.unleashElements, 30)

    if talent.elementalBlast then
        checkAbility(true, cd.elementalBlast, 40)
    end
    if spell.fireNova.known() and debuff.flameShock.count() >= 1 then
        checkAbility(true, cd.fireNova, 10)
    end

    return timeToNext
end

-- Check if we can safely cast filler Lightning Bolt/Chain Lightning
local function canCastFillerLightning(isChainLightning, castTimeOverride)
    if not ui.checked("Lightning Filler") then return false end
    if not unit.exists("target") or not unit.inCombat() then return false end

    -- Don't filler cast if we're in melee range (< 5 yards)
    local dist = unit.distance("target") or 99
    if dist < 5 then return false end

    -- Calculate cast time (GCD doesn't matter since it happens AFTER the cast)
    local castTime = castTimeOverride or (isChainLightning and cast.time.chainLightning() or cast.time.lightningBolt())

    -- Get time until next priority ability
    local timeToNext = getTimeToNextAbility()

    -- Only allow filler cast if we have enough time to complete the cast
    -- Add a small buffer (0.2s) to account for latency and ensure priority spell can be cast immediately
    return timeToNext > (castTime + 0.2)
end

-- local function canLightning(aoe)
--     local level = unit.level()
--     if not ui.checked("Lightning Filler") or level < 10 then return false end
--     local timeTillLightning = (aoe and talent.chainLightning) and cast.time.chainLightning() or cast.time.lightningBolt()

--     local earthShock = spell.earthShock.known() and cd.earthShock.remain() or 99
--     local elementalBlast = talent.elementalBlast and cd.elementalBlast.remain() or 99
--     local fireNova = spell.fireNova.known() and cd.fireNova.remain() or 99
--     local flameShock = spell.flameShock.known() and cd.flameShock.remain() or --[[debuff.flameShock.exists() and debuff.flameShock.remain(units.dyn25) or]] 99
--     local frostShock = spell.frostShock.known() and cd.frostShock.remain() or 99
--     local lavaLash  = spell.lavaLash.known() and cd.lavaLash.remain() or 99
--     local primalStrike = (level < 26 and not spell.stormStrike.known()) and cd.primalStrike.remain() or 99
--     local stormblast = (spell.stormblast.known() and buff.ascendance.exists()) and cd.stormblast.remain() or 99
--     local stormstrike = (spell.stormstrike.known() and not buff.ascendance.exists()) and cd.stormstrike.remain() or 99

--     return math.min(earthShock,elementalBlast,fireNova,flameShock,frostShock,lavaLash,primalStrike,stormblast,stormstrike) > timeTillLightning
-- end

--------------------
--- Action Lists ---
--------------------

-- Action List - Extras
actionList.Extras = function()
    local startTime = br._G.debugprofilestop()
    -- * Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end
    -- * Ghost Wolf
    if (ui.value("Ghost Wolf") == 1 or (ui.value("Ghost Wolf") == 2 and not unit.inCombat())) and cast.able.ghostWolf() and not (unit.mounted() or unit.flying()) then
        if ((#enemies.yards20 == 0 and not unit.inCombat()) or (#enemies.yards10 == 0 and unit.inCombat())) and unit.moving("player") and not buff.ghostWolf.exists() then
            if cast.ghostWolf() then ui.debug("Casting Ghost Wolf [Extra]") return true end
        end
    end
    -- * Purge
    if ui.checked("Purge") and cast.able.purge() and cast.dispel.purge("target") and not unit.isBoss() and unit.exists("target") then
        if cast.purge() then ui.debug("Casting Purge [Extra]") return true end
    end
    -- * Spirit Walk
    if ui.checked("Spirit Walk") and cast.able.spiritWalk() and unit.moving() then
        if cast.spiritWalk() then ui.debug("Casting Spirit Walk [Extra]") return true end
    end
    -- * Water Walking
    if ui.checked("Water Walking") and cast.able.waterWalking() and not unit.inCombat() and not buff.waterWalking.exists() then
        if cast.waterWalking() then ui.debug("Casting Water Walking [Extra]") return true end
    end
    -- * Windfury Weapon
    -- windfury_weapon,weapon=main
    if ui.checked("Windfury Weapon") and cast.able.windfuryWeapon() and not unit.weaponImbue.exists(283) and unit.level() >= 30 then
        if cast.windfuryWeapon("player") then ui.debug("Casting Windfury Weapon - Main [Precombat]") return true end
    end
    -- * Flametongue Weapon
    -- flametongue_weapon,weapon=main
    if ui.checked("Flametongue Weapon") and cast.able.flametongueWeapon() and not unit.weaponImbue.exists(5) and unit.level() < 30 then
        if cast.flametongueWeapon("player") then ui.debug("Casting Flametongue Weapon - Main [Precombat]") return true end
    end
    -- flametongue_weapon,weapon=off
    if ui.checked("Flametongue Weapon") and cast.able.flametongueWeapon() and unit.dualWielding()
        and not unit.weaponImbue.exists(5,true)
    then
        if cast.flametongueWeapon("player") then ui.debug("Casting Flametongue Weapon - Off [Precombat]") return true end
    end
    -- * Lightning Shield
    -- lightning_shield,if=!buff.lightning_shield.up
    if ui.checked("Lightning Shield") and cast.able.lightningShield()
        and not buff.lightningShield.exists() and (mana.percent() >= math.min(100, ui.value("Water Shield") * 2) or not ui.checked("Water Shield"))
    then
        if cast.lightningShield("player") then ui.debug("Casting Lightning Shield [Precombat]") return true end
    end
    -- * Water Shield
    if cast.able.waterShield() and ui.checked("Water Shield")
        and mana.percent() <= ui.value("Water Shield") and not buff.waterShield.exists()
    then
        if cast.waterShield("player") then ui.debug("Casting Water Shield [Extra]") return true end
    end
    -- * Totemic Recall
    if cast.able.totemicRecall() and totem.exists() and ((not unit.inCombat() and #enemies.yards25nc == 0)
        or (unit.inCombat() and math.max(totem.fire.distance(), totem.earth.distance(), totem.water.distance(), totem.air.distance()) > 25))
    then
        if cast.totemicRecall() then ui.debug("Casting Totemic Recall [Extra]") return true end
    end
    br.debug.cpu:updateDebug(startTime,"rotation.profile.extras")
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    local startTime = br._G.debugprofilestop()
    if ui.useDefensive() then
        -- * Ancestral Spirit
        if ui.checked("Ancestral Spirit") and cast.timeSinceLast.ancestralSpirit() > 5 then
            if ui.value("Ancestral Spirit")==1 and cast.able.ancestralSpirit("target","dead") and unit.player("target") then
                if cast.ancestralSpirit("target","dead") then ui.debug("Casting Ancestral Spirit - Target [Defensive]") return true end
            end
            if ui.value("Ancestral Spirit")==2 and cast.able.ancestralSpirit("mouseover","dead") and unit.player("mouseover") then
                if cast.ancestralSpirit("mouseover","dead") then ui.debug("Casting Ancestral Spirit - Mouseover [Defensive]") return true end
            end
        end
        -- * Astral Shift
        if ui.checked("Astral Shift") and cast.able.astralShift() and unit.hp() <= ui.value("Astral Shift") and unit.inCombat() then
            if cast.astralShift() then ui.debug("Casting Astral Shift [Defensive]") return true end
        end
        -- * Capacitor Totem
        if ui.checked("Capacitor Totem - HP") and cast.able.capacitorTotem("player") and cd.capacitorTotem.ready()
            and unit.hp() <= ui.value("Capacitor Totem - HP") and unit.inCombat() and #enemies.yards5 > 0
        then
            if cast.capacitorTotem("player") then ui.debug("Casting Capacitor Totem - Low HP [Defensive]") return true end
        end
        if ui.checked("Capacitor Totem - AoE") and cast.able.capacitorTotem("best",nil,ui.value("Capacitor Totem - AoE"),8) and cd.capacitorTotem.ready()
            and #enemies.yards5 >= ui.value("Capacitor Totem - AoE") and unit.inCombat()
        then
            if cast.capacitorTotem("best",nil,ui.value("Capacitor Totem - AoE"),8) then ui.debug("Casting Capacitor Totem - AOE [Defensive]") return true end
        end
        -- * Cleanse Spirit
        if ui.checked("Cleanse Spirit") then
            if ui.value("Cleanse Spirit")==1 and cast.able.cleanseSpirit("player") and cast.dispel.cleanseSpirit("player") then
                if cast.cleanseSpirit("player") then ui.debug("Casting Cleanse Spirit - Player [Defensive]") return true end
            end
            if ui.value("Cleanse Spirit")==2 and cast.able.cleanseSpirit("target") and cast.dispel.cleanseSpirit("target") then
                if cast.cleanseSpirit("target") then ui.debug("Casting Cleanse Spirit - Target [Defensive]") return true end
            end
            if ui.value("Cleanse Spirit")==3 and cast.able.cleanseSpirit("mouseover") and cast.dispel.cleanseSpirit("mouseover") then
                if cast.cleanseSpirit("mouseover") then ui.debug("Casting Cleanse Spirit - Mouseover [Defensive]") return true end
            end
        end
        -- * Healing Surge
        if ui.checked("Healing Surge") and cast.able.healingSurge(var.healUnit) and not (unit.mounted() or unit.flying())
            and (ui.value("Heal Target") ~= 1 or (ui.value("Heal Target") == 1
            and unit.distance(br.engines.healingEngine.friend[1].unit) < 40)) and not cast.current.healingSurge()
        then
            if not unit.inCombat() then
                -- Lowest Party/Raid or Player
                if (var.healHP <= ui.value("Healing Surge OoC") and not unit.moving())
                    and (buff.maelstromWeapon.stack() == 0 or ui.value("Instant Behavior") == 1)
                then
                    if cast.healingSurge(var.healUnit) then ui.debug("Casting Healing Surge - Ooc on "..unit.name(var.healUnit).." [Defensive]") return true end
                end
            elseif unit.inCombat() and (not unit.moving() or buff.maelstromWeapon.stack() >= 5) then
                -- Lowest Party/Raid or Player
                if var.healHP <= ui.value("Healing Surge") then
                    if ui.value("Instant Behavior") == 1 or (ui.value("Instant Behavior") == 2 and buff.maelstromWeapon.stack() >= 5) or (ui.value("Instant Behavior") == 3 and buff.maelstromWeapon.stack() == 0) then
                        if buff.maelstromWeapon.stack() >= 5 then
                            if cast.healingSurge(var.healUnit) then ui.debug("Casting Healing Surge - IC Instant on "..unit.name(var.healUnit).." [Defensive]") return true end
                        else
                            if cast.healingSurge(var.healUnit) then ui.debug("Casting Healing Surge - IC Long on "..unit.name(var.healUnit).." [Defensive]") return true end
                        end
                    end
                end
            end
        end
        -- * Healing Stream Totem
        if ui.checked("Healing Stream Totem") and cast.able.healingStreamTotem("player")
            and var.unitsNeedingHealing >= ui.value("Healing Stream Totem - Min Units")
        then
            if cast.healingStreamTotem("player") then ui.debug("Casting Healing Stream Totem [Defensive]") return true end
        end
    end -- End Defensive Toggle
    br.debug.cpu:updateDebug(startTime,"rotation.profile.defensive")
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupt = function()
    -- * Wind Shear
    if ui.useInterrupt() and ui.checked("Wind Shear") and cast.able.windShear() then
        local thisUnit
        for i = 1, #enemies.yards30 do
            thisUnit = enemies.yards30[i]
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                if cast.windShear(thisUnit) then
                    ui.debug("Casting Wind Shear on " .. unit.name(thisUnit) .. " [Interrupt]")
                    return true
                end
            end
        end
    end
end -- End Action List - Interrupts

-- Action List - AOE
actionList.AOE = function()
    local startTime = br._G.debugprofilestop()
    -- * Fire Nova
    -- fire_nova,if=active_flame_shock>=4
    if cast.able.fireNova("player","aoe",1,10) and debuff.flameShock.count() >= 4 then
        if cast.fireNova("player","aoe",1,10) then ui.debug("Casting Fire Nova - 4+ Flame Shock [AOE]") return true end
    end
    -- * Wait
    -- wait,sec=cooldown.fire_nova.remains,if=active_flame_shock>=4&cooldown.fire_nova.remains<0.67
    if debuff.flameShock.count() >= 4 and cd.fireNova.remain() < 0.67 then
        return true
    end
    -- * Magma Totem
    -- magma_totem,if=active_enemies>5&!totem.fire.active
    if #enemies.yards8 > 5 and cast.able.magmaTotem("player")
        and (not totem.fire.magma.exists() or totem.fire.magma.distance() > 8)
        and unit.standingTime() > 1
    then
        if cast.magmaTotem("player") then ui.debug("Casting Magma Totem - 5+ Enemies [AOE]") return true end
    end
    -- * Searing Totem
    -- searing_totem,if=active_enemies<=5&!totem.fire.active
    if #enemies.yards8 <= 5 and cast.able.searingTotem("player")
        and not totem.fire.searing.exists() and unit.standingTime() > 1
    then
        if cast.searingTotem("player") then ui.debug("Casting Searing Totem [AOE]") return true end
    end
    -- * Lava Lash
    -- lava_lash,if=dot.flame_shock.ticking
    for i = 1, #enemies.yards5 do
        local thisUnit = enemies.yards5[i]
        if cast.able.lavaLash(thisUnit) and debuff.flameShock.exists(thisUnit) then
            if cast.lavaLash(thisUnit) then ui.debug("Casting Lava Lash on "..unit.name(thisUnit).." [AOE]") return true end
        end
    end
    -- * Elemental Blast
    -- elemental_blast,if=talent.elemental_blast.enabled&buff.maelstrom_weapon.react>=1
    if cast.able.elementalBlast() and talent.elementalBlast and buff.maelstromWeapon.stack() >= 1 then
        if cast.elementalBlast() then ui.debug("Casting Elemental Blast [AOE]") return true end
    end
    -- * Chain Lightning
    -- chain_lightning,if=active_enemies>=2&buff.maelstrom_weapon.react>=3
    if cast.able.chainLightning() and #enemies.yards8t >= 2 and buff.maelstromWeapon.stack() >= 3 then
        if cast.chainLightning() then
            var.fillerChainLightning = false
            ui.debug("Casting Chain Lightning - 3+ Maelstrom [AOE]")
            return true
        end
    end
    -- * Unleash Elements
    -- unleash_elements
    if cast.able.unleashElements() then
        if cast.unleashElements() then ui.debug("Casting Unleash Elements [AOE]") return true end
    end
    -- * Flame Shock
    -- flame_shock,cycle_targets=1,if=!ticking
    for i = 1, #enemies.yards5 do
        local thisUnit = enemies.yards5[i]
        if cast.able.flameShock(thisUnit) and not debuff.flameShock.exists(thisUnit) then
            if cast.flameShock(thisUnit) then ui.debug("Casting Flame Shock on "..unit.name(thisUnit).." [AOE]") return true end
        end
    end
    -- * Stormblast
    -- stormblast
    if cast.able.stormblast() and buff.ascendance.exists() then
        if cast.stormblast() then ui.debug("Casting Stormblast [AOE]") return true end
    end
    -- * Fire Nova
    -- fire_nova,if=active_flame_shock>=3
    if cast.able.fireNova("player","aoe",1,10) and debuff.flameShock.count() >= 3 then
        if cast.fireNova("player","aoe",1,10) then ui.debug("Casting Fire Nova - 3+ Flame Shock [AOE]") return true end
    end
    -- * Chain Lightning
    -- chain_lightning,if=active_enemies>=2&buff.maelstrom_weapon.react>=1
    if cast.able.chainLightning() and #enemies.yards8t >= 2 and buff.maelstromWeapon.stack() >= 1 then
        if cast.chainLightning() then
            var.fillerChainLightning = false
            ui.debug("Casting Chain Lightning [AOE]")
            return true
        end
    end
    -- * Stormstrike
    -- stormstrike
    if cast.able.stormstrike() and not buff.ascendance.exists() and unit.level() >= 26 then
        if cast.stormstrike() then ui.debug("Casting Stormstrike [AOE]") return true end
    end
    -- * Primal Strike
    -- primal_strike
    if cast.able.primalStrike() and unit.level() < 26 then
        if cast.primalStrike() then ui.debug("Casting Primal Strike [AOE]") return true end
    end
    -- * Earth Shock
    -- earth_shock,if=active_enemies<4
    if cast.able.earthShock() and #enemies.yards8 < 4 then
        if cast.earthShock() then ui.debug("Casting Earth Shock [AOE]") return true end
    end
    -- * Feral Spirit
    -- feral_spirit
    if ui.alwaysCdNever("Feral Spirit") and cast.able.feralSpirit() then
        if cast.feralSpirit() then ui.debug("Casting Feral Spirit [AOE]") return true end
    end
    -- * Earth Elemental Totem
    -- earth_elemental_totem,if=!active&cooldown.fire_elemental_totem.remains>=50
    if ui.alwaysCdNever("Earth Elemental") and cast.able.earthElementalTotem("player") and not totem.earth.exists()
        and cd.fireElementalTotem.remain() >= 50
    then
        if cast.earthElementalTotem("player") then ui.debug("Casting Earth Elemental Totem [AOE]") return true end
    end
    -- * Spiritwalkers Grace
    -- spiritwalkers_grace,moving=1
    if cast.able.spiritwalkersGrace() and unit.moving() then
        if cast.spiritwalkersGrace() then ui.debug("Casting Spiritwalkers Grace [AOE]") return true end
    end
    -- * Fire Nova
    -- fire_nova,if=active_flame_shock>=1
    if cast.able.fireNova("player","aoe",1,10) and debuff.flameShock.count() >= 1 then
        if cast.fireNova("player","aoe",1,10) then ui.debug("Casting Fire Nova - 1+ Flame Shock [AOE]") return true end
    end
    -- * Filler Chain Lightning
    -- chain_lightning
    if cast.able.chainLightning() and canCastFillerLightning(true) then
        if cast.chainLightning() then
            var.fillerChainLightning = true
            ui.debug("Casting Chain Lightning - Filler [AOE]")
            return true
        end
    end
    br.debug.cpu:updateDebug(startTime,"rotation.profile.aoe")
end -- End Action List - AOE

-- Action List - Single
actionList.Single = function()
    local startTime = br._G.debugprofilestop()
    -- * Searing Totem
    -- searing_totem,if=!totem.fire.active
    if cast.able.searingTotem("player") and not totem.fire.active() and unit.standingTime() > 1 then
        if cast.searingTotem("player") then ui.debug("Casting Searing Totem [Single]") return true end
    end
    -- * Unleash Elements
    -- unleash_elements,if=(talent.unleashed_fury.enabled|set_bonus.tier16_2pc_melee=1)
    if cast.able.unleashElements() and (talent.unleashedFury or equiped.tier(16) >= 2) then
        if cast.unleashElements() then ui.debug("Casting Unleash Elements - T16 2pc [Single]") return true end
    end
    -- * Elemental Blast
    -- elemental_blast,if=talent.elemental_blast.enabled&buff.maelstrom_weapon.react>=1
    if cast.able.elementalBlast() and talent.elementalBlast and buff.maelstromWeapon.stack() >= 1 then
        if cast.elementalBlast() then ui.debug("Casting Elemental Blast [Single]") return true end
    end
    -- * Lightning Bolt
    -- lightning_bolt,if=buff.maelstrom_weapon.react=5
    if cast.able.lightningBolt() and buff.maelstromWeapon.stack() == 5 then
        if cast.lightningBolt() then
            var.fillerLightningBolt = false
            ui.debug("Casting Lightning Bolt - 5 Stack Maelstrom [Single]")
            return true
        end
    end
    -- * Feral Spirit
    -- feral_spirit,if=set_bonus.tier15_4pc_melee=1
    if ui.alwaysCdNever("Feral Spirit") and cast.able.feralSpirit() and equiped.tier(15) >= 4 then
        if cast.feralSpirit() then ui.debug("Casting Feral Spirit - T15 4pc [Single]") return true end
    end
    -- * Stormblast
    -- stormblast
    if cast.able.stormblast() and buff.ascendance.exists()then
        if cast.stormblast() then ui.debug("Casting Stormblast [Single]") return true end
    end
    -- * Stormstrike
    -- stormstrike
    if cast.able.stormstrike() and not buff.ascendance.exists() and unit.level() >= 26 then
        if cast.stormstrike() then ui.debug("Casting Stormstrike [Single]") return true end
    end
    -- * Primal Strike
    -- primal_strike,if=level<26
    if cast.able.primalStrike() and unit.level() < 26 then
        if cast.primalStrike() then ui.debug("Casting Primal Strike [Single]") return true end
    end
    -- * Flame Shock
    -- flame_shock,if=buff.unleash_flame.up&!ticking
    if cast.able.flameShock(units.dyn5) and buff.unleashFlame.exists() and not debuff.flameShock.exists(units.dyn5) then
        if cast.flameShock(units.dyn5) then ui.debug("Casting Flame Shock - Unleash Flame [Single]") return true end
    end
    -- * Lava Lash
    -- lava_lash
    if cast.able.lavaLash(units.dyn5) and debuff.flameShock.exists(units.dyn5) then
        if cast.lavaLash(units.dyn5) then ui.debug("Casting Lava Lash [Single]") return true end
    end
    -- * Lightning Bolt
    -- lightning_bolt,if=set_bonus.tier15_2pc_melee=1&buff.maelstrom_weapon.react>=4&!buff.ascendance.up
    if cast.able.lightningBolt() and equiped.tier(15) >= 2 and buff.maelstromWeapon.stack() >= 4 and not buff.ascendance.exists() then
        if cast.lightningBolt() then
            var.fillerLightningBolt = false
            ui.debug("Casting Lightning Bolt - T15 2pc [Single]")
            return true
        end
    end
    -- * Flame Shock
    -- flame_shock,if=(buff.unleash_flame.up&(dot.flame_shock.remains<10|action.flame_shock.tick_damage>dot.flame_shock.tick_dmg))|!ticking
    if cast.able.flameShock(units.dyn5) and ((buff.unleashFlame.exists()
        and (debuff.flameShock.remains(units.dyn5) < 10 --[[or cast.flameShock.tickDamage() > debuff.flameShock.tickDamage(units.dyn25)]]))
            or not debuff.flameShock.exists(units.dyn5))
    then
        if cast.flameShock(units.dyn5) then ui.debug("Casting Flame Shock [Single]") return true end
    end
    -- * Unleash Elements
    -- unleash_elements
    if cast.able.unleashElements() then
        if cast.unleashElements() then ui.debug("Casting Unleash Elements [Single]") return true end
    end
    -- * Frost Shock
    -- frost_shock,if=glyph.frost_shock.enabled&set_bonus.tier14_4pc_melee=0
    if cast.able.frostShock() and glyph.frostShock.enabled() and equiped.tier(14) < 4 then
        if cast.frostShock() then ui.debug("Casting Frost Shock - Glyph [Single]") return true end
    end
    -- * Lightning Bolt
    -- lightning_bolt,if=buff.maelstrom_weapon.react>=3&!buff.ascendance.up
    if cast.able.lightningBolt() and buff.maelstromWeapon.stack() >= 3 and not buff.ascendance.exists() then
        if cast.lightningBolt() then
            var.fillerLightningBolt = false
            ui.debug("Casting Lightning Bolt - 3+ Stack Maelstrom [Single]")
            return true
        end
    end
    -- * Ancestral Swiftness
    -- ancestral_swiftness,if=talent.ancestral_swiftness.enabled&buff.maelstrom_weapon.react<2
    if ui.alwaysCdNever("Ancestral Swiftness") and cast.able.ancestralSwiftness() and talent.ancestralSwiftness and buff.maelstromWeapon.stack() < 2 then
        if cast.ancestralSwiftness() then ui.debug("Casting Ancestral Swiftness [Single]") return true end
    end
    -- * Lightning Bolt
    -- lightning_bolt,if=buff.ancestral_swiftness.up
    if cast.able.lightningBolt() and buff.ancestralSwiftness.exists() then
        if cast.lightningBolt() then
            var.fillerLightningBolt = false
            ui.debug("Casting Lightning Bolt - Ancestral Swiftness [Single]")
            return true
        end
    end
    -- * Earth Shock
    -- earth_shock,if=(!glyph.frost_shock.enabled|set_bonus.tier14_4pc_melee=1)
    if cast.able.earthShock() and (not glyph.frostShock.enabled() or equiped.tier(14) >= 4) then
        if cast.earthShock() then ui.debug("Casting Earth Shock [Single]") return true end
    end
    -- * Feral Spirit
    -- feral_spirit
    if ui.alwaysCdNever("Feral Spirit") and cast.able.feralSpirit() then
        if cast.feralSpirit() then ui.debug("Casting Feral Spirit [Single]") return true end
    end
    -- * Earth Elemental Totem
    -- earth_elemental_totem,if=!active
    if ui.alwaysCdNever("Earth Elemental") and cast.able.earthElementalTotem("player") and not totem.earth.active() then
        if cast.earthElementalTotem("player") then ui.debug("Casting Earth Elemental Totem [Single]") return true end
    end
    -- * Spiritwalkers Grace
    -- spiritwalkers_grace,moving=1
    if ui.alwaysCdNever("Spiritwalkers Grace") and cast.able.spiritwalkersGrace() and unit.moving() then
        if cast.spiritwalkersGrace() then ui.debug("Casting Spiritwalkers Grace [Single]") return true end
    end
    -- * Lightning Bolt
    -- lightning_bolt,if=buff.maelstrom_weapon.react>1&!buff.ascendance.up
    if cast.able.lightningBolt() and buff.maelstromWeapon.stack() > 1 and not buff.ascendance.exists() then
        if cast.lightningBolt() then
            var.fillerLightningBolt = false
            ui.debug("Casting Lightning Bolt - 2+ Stack Maelstrom [Single]")
            return true
        end
    end
    -- * Filler Lightning Bolt
    if cast.able.lightningBolt() and canCastFillerLightning(false) then
        if cast.lightningBolt() then
            var.fillerLightningBolt = true
            ui.debug("Casting Lightning Bolt - Filler [Single]")
            return true
        end
    end
    br.debug.cpu:updateDebug(startTime,"rotation.profile.single")
end -- End Action List - Single

-- Action List - PreCombat
actionList.PreCombat = function()
    local startTime = br._G.debugprofilestop()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then
        -- * Flask
        -- flask,type=spring_blossoms
        -- * Food
        -- food,type=sea_mist_rice_noodles
        -- # Snapshot raid buffed stats before combat begins and pre-potting is done.
        -- snapshot_stats
        -- virmens_bite_potion
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- * Potion
            -- potion
            -- if ui.checked("Potion") and br.functions.item:canUseItem(142117) and unit.instance("raid") then
            --     if feralSpiritRemain > 5 and not buff.prolongedPower.exists() then
            --         br.functions.item:useItem(142117)
            --     end
            -- end
        end -- End Pre-Pull
        if unit.valid("target") then
            -- * Lightning Bolt
            if ui.checked("Lightning Bolt Out of Combat") and cast.able.lightningBolt()
                and not unit.moving() and unit.distance("target") >= 10
                and cast.timeSinceLast.lightningBolt() > cast.time.lightningBolt() + unit.gcd(true)
                -- and (not ui.checked("Ghost Wolf") or unit.distance("target") <= 20 or not buff.ghostWolf.exists())
            then
                if cast.lightningBolt("target") then ui.debug("Casting Lightning Bolt [Precombat]") return true end
            end
            -- * Start Attack
            if unit.distance("target") < 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Precombat]") return true end
                end
            end
        end
    end -- End No Combat
    br.debug.cpu:updateDebug(startTime,"rotation.profile.precombat")
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    local startTime = br._G.debugprofilestop()
    if (unit.inCombat() --[[or (not unit.inCombat() and unit.valid(units.dyn5))]]) and not var.profileStop
        and unit.exists(units.dyn5) and cd.global.remain() == 0
    then
        -- * Cancel ranged lightning casts if enemies are in melee range
        if (cast.current.lightningBolt() or cast.current.chainLightning()) and #enemies.yards5 > 0 then
            if cast.current.lightningBolt() then
                if cast.cancel.lightningBolt() then
                    ui.debug("Canceled Lightning Bolt - Enemy in melee range")
                    return true
                end
            elseif cast.current.chainLightning() then
                if cast.cancel.chainLightning() then
                    ui.debug("Canceled Chain Lightning - Enemy in melee range")
                    return true
                end
            end
        end
        -- * Call Action List - Interrupt
        -- wind_shear
        if actionList.Interrupt() then return true end
        -- * Heroism / Bloodlust
        -- # Bloodlust casting behavior mirrors the simulator settings for proxy bloodlust. See options 'bloodlust_percent', and 'bloodlust_time'.
        -- bloodlust,if=target.health.pct<25|time>0.500
        -- * Start Attack
        -- auto_attack
        if cast.able.autoAttack(units.dyn5) then --and #enemies.yards5 > 0 then
            if cast.autoAttack(units.dyn5) then
                ui.debug("Casting Auto Attack [Combat]")
                return true
            end
        end
        -- * Ranged Lightning when not in melee range
        if unit.valid("target") and #enemies.yards5 == 0 and unit.distance("target") > 5 and unit.distance("target") <= 40 then
            -- Chain Lightning for multiple targets
            if cast.able.chainLightning() and #enemies.yards8t >= 2 then
                if cast.chainLightning() then
                    ui.debug("Casting Chain Lightning - Out of Melee [Combat]")
                    return true
                end
            end
            -- Lightning Bolt for single target
            if cast.able.lightningBolt() then
                if cast.lightningBolt() then
                    ui.debug("Casting Lightning Bolt - Out of Melee [Combat]")
                    return true
                end
            end
        end
        -- * Use Items - Hands
        -- use_item,name=grips_of_the_witch_doctor
        -- * Stormlash Totem
        -- # Link Stormlash totem cast to early Bloodlust, and ensure that only one Stormlash is used at a time.
        -- stormlash_totem,if=!active&!buff.stormlash.up&(buff.bloodlust.up|time>=60)
        if ui.alwaysCdNever("Stormlash Totem") and cast.able.stormlashTotem("player")
            and not totem.air.stormlash.exists() and not buff.stormlash.exists()
            and (buff.bloodlust.exists() or unit.combatTime() >= 60)
        then
            if cast.stormlashTotem("player") then
                ui.debug("Casting Stormlash Totem")
                return true
            end
        end
        -- * In-Combat Potion
        -- # In-combat potion is linked to Primal or Greater Fire Elemental Totem, after the first 60 seconds of combat.
        -- virmens_bite_potion,if=time>60&(pet.primal_fire_elemental.active|pet.greater_fire_elemental.active|target.time_to_die<=60)
        -- * Racials
        -- blood_fury
        -- arcane_torrent
        -- berserking
        if ui.alwaysCdNever("Racial") and cast.able.racial()
            and (unit.race() == "Orc" or unit.race() == "BloodElf" or unit.race() == "Troll")
        then
            if cast.racial() then ui.debug("Casting Racial") return true end
        end
        -- * Elemental Mastery
        -- elemental_mastery,if=talent.elemental_mastery.enabled&(talent.primal_elementalist.enabled&glyph.fire_elemental_totem.enabled&(cooldown.fire_elemental_totem.remains=0|cooldown.fire_elemental_totem.remains>=80))
        if ui.alwaysCdNever("Elemental Mastery") and cast.able.elementalMastery() and talent.elementalMastery
            and (talent.primalElementalist and glyph.fireElementalTotem.exists()
            and (cd.fireElementalTotem.remain() == 0 or cd.fireElementalTotem.remain() >= 80))
        then
            if cast.elementalMastery() then
                ui.debug("Casting Elemental Mastery")
                return true
            end
        end
        -- elemental_mastery,if=talent.elemental_mastery.enabled&(talent.primal_elementalist.enabled&!glyph.fire_elemental_totem.enabled&(cooldown.fire_elemental_totem.remains=0|cooldown.fire_elemental_totem.remains>=50))
        if ui.alwaysCdNever("Elemental Mastery") and cast.able.elementalMastery() and talent.elementalMastery
            and (talent.primalElementalist and not glyph.fireElementalTotem.enabled()
            and (cd.fireElementalTotem.remain() == 0 or cd.fireElementalTotem.remain() >= 50))
        then
            if cast.elementalMastery() then
                ui.debug("Casting Elemental Mastery")
                return true
            end
        end
        -- elemental_mastery,if=talent.elemental_mastery.enabled&!talent.primal_elementalist.enabled
        if ui.alwaysCdNever("Elemental Mastery") and cast.able.elementalMastery() and talent.elementalMastery
            and not talent.primalElementalist
        then
            if cast.elementalMastery() then
                ui.debug("Casting Elemental Mastery")
                return true
            end
        end
        -- * Fire Elemental Totem
        -- fire_elemental_totem,if=!active
        if ui.alwaysCdNever("Fire Elemental") and cast.able.fireElementalTotem("player") and not totem.fireElemental.exists() then
            if cast.fireElementalTotem("player") then
                ui.debug("Casting Fire Elemental Totem")
                return true
            end
        end
        -- * Ascendance
        -- ascendance,if=cooldown.strike.remains>=3
        if ui.alwaysCdNever("Ascendance") and cast.able.ascendance() and cd.stormstrike.remain() >= 3 then
            if cast.ascendance() then
                ui.debug("Casting Ascendance")
                return true
            end
        end
        -- * Lifeblood
        -- lifeblood,if=(glyph.fire_elemental_totem.enabled&(pet.primal_fire_elemental.active|pet.greater_fire_elemental.active))|!glyph.fire_elemental_totem.enabled
        -- * Call Action List - Single
        -- # If only one enemy, priority follows the 'single' action list.
        -- run_action_list,name=single,if=active_enemies=1
        if ui.useST(8,2) then
            if actionList.Single() then return true end
        end
        -- * Call Action List - AOE
        -- # On multiple enemies, the priority follows the 'aoe' action list.
        -- run_action_list,name=aoe,if=active_enemies>1
        if ui.useAOE(8,2) then
            if actionList.AOE() then return true end
        end
    end
    br.debug.cpu:updateDebug(startTime,"rotation.profile.combat")
end -- End Action List - Combat

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
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    equiped                                       = br.player.equiped
    glyph                                         = br.player.glyph
    mana                                          = br.player.power.mana
    spell                                         = br.player.spell
    talent                                        = br.player.talent
    totem                                         = br.player.totem
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    var                                           = br.player.variables

    -- Dynamic Units
    units.get(5)

    -- Enemies Lists
    enemies.get(5)
    enemies.get(8)
    enemies.get(8, "target")
    enemies.get(10)
    enemies.get(20)
    enemies.get(25,"player",true,false)
    enemies.get(30)

    -- Initialize filler tracking variables
    if var.fillerLightningBolt == nil then var.fillerLightningBolt = false end
    if var.fillerChainLightning == nil then var.fillerChainLightning = false end

    -- Cancel filler casts if a priority ability becomes available (check BEFORE clearing flags)
    if unit.inCombat() and (var.fillerLightningBolt or var.fillerChainLightning) then
        local isCasting = cast.current.lightningBolt() or cast.current.chainLightning()
        if isCasting then
            local timeToNext = getTimeToNextAbility()
            -- Cancel if a priority ability is ready NOW or will be ready very soon
            if timeToNext <= 0.1 then
                if cancelFillerLightning() then
                    ui.debug("Canceled filler cast - priority ability ready (timeToNext: "..tostring(timeToNext)..")")
                end
            end
        else
            -- Not casting anymore, clear the filler flags
            var.fillerLightningBolt = false
            var.fillerChainLightning = false
        end
    end


    var.healUnit = ui.value("Heal Target") == 1 and unit.lowest(40) or "player"
    var.healHP = unit.hp(var.healUnit)
    var.unitsNeedingHealing = 0
    if ui.checked("Use HST While Solo") and br.functions.unit:getHP("player") <= ui.value("Healing Stream Totem") then
        var.unitsNeedingHealing = var.unitsNeedingHealing + 1
    end
    if #br.engines.healingEngine.friend > 1 then
        for i = 1, #br.engines.healingEngine.friend do
            local thisFriend = br.engines.healingEngine.friend[i].unit
            local thisDistance = unit.distance(thisFriend)
            if not unit.isUnit(thisFriend,"player") and thisDistance < 40 and unit.hp(thisFriend) <= ui.value("Healing Stream Totem") then
                var.unitsNeedingHealing = var.unitsNeedingHealing + 1
            end
        end
    end

    if var.profileStop == nil then var.profileStop = false end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- * Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() then
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
        -------------------
        --- No Rotation ---
        -------------------
        if ui.mode.rotation == 4 then return true end
        ---------------------------
        --- Pre-Combat Rotation ---
        ---------------------------
        if actionList.PreCombat() then return true end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if actionList.Combat() then return true end
    end --End Rotation Logic
end -- End runRotation
local id = 263
local expansion = br.isMOP
if br.loader.rotations[id] == nil then br.loader.rotations[id] = {} end
br._G.tinsert(br.loader.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

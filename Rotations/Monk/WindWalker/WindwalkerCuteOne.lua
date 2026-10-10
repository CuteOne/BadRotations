local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function toggles()
    br.ui:toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = "spinningCraneKick", overlay = "Automatic Rotation Enabled", tip = "Swaps between Single and Multiple based on number of targets in range." },
        { name = "AOE", icon = "spinningCraneKick", overlay = "AOE Rotation Enabled", tip = "AOE Rotation Used" },
        { name = "Single", icon = "tigerPalm", overlay = "Single Target Rotation Enabled", tip = "Single Target Rotation Used" },
        { name = "Off", icon = "expelHarm", overlay = "Rotation Disabled", tip = "No Rotation will be used." },
    } })
    br.ui:toggle("Cooldown", { modes = {
        { name = "Auto", icon = "touchOfDeath", overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection." },
        { name = "On", icon = "touchOfDeath", overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target." },
        { name = "Off", icon = "touchOfDeath", overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used." },
    } })
    br.ui:toggle("Defensive", { modes = {
        { name = "On", icon = "expelHarm", overlay = "Defensive Enabled", tip = "Enables Defensive" },
        { name = "Off", icon = "expelHarm", overlay = "Defensive Disabled", tip = "Disables Defensive" },
    } })
    br.ui:toggle("Interrupt", { modes = {
        { name = "On", icon = "legSweep", overlay = "Interrupt Enabled", tip = "Enables Interrupt" },
        { name = "Off", icon = "legSweep", overlay = "Interrupt Disabled", tip = "Interrupt Defensive" },
    } })
    br.ui:toggle("StormEarthAndFire", { modes = {
        { name = "On", icon = "stormEarthAndFire", overlay = "Storm, Earth, and Fire Enabled", tip = "Enables Storm, Earth, and Fire" },
        { name = "Off", icon = "stormEarthAndFire", overlay = "Storm, Earth, and Fire Disabled", tip = "Disables Storm, Earth, and Fire" },
    } })
    br.ui:toggle("FlyingSerpentKick", { modes = {
        { name = "On", icon = "flyingSerpentKick", overlay = "Auto Flying Serpent Kick Enabled", tip = "Enables Flying Serpent Kick" },
        { name = "Off", icon = "flyingSerpentKick", overlay = "Auto Flying Serpent Kick Disabled", tip = "Disables Flying Serpent Kick" },
    } })
    br.ui:toggle("ChiBuilder", { modes = {
        { name = "On", icon = "expelHarm", overlay = "Chi Builder Enabled", tip = "Enables Chi Builder" },
        { name = "Off", icon = "expelHarm", overlay = "Chi Builder Disabled", tip = "Disables Chi Builder" },
    } })
end

---------------
--- OPTIONS ---
---------------
local function options()
    local section
    -----------------------
    --- GENERAL OPTIONS ---
    -----------------------
    section = br.ui:section("General")
        -- Dummy DPS Test
        br.ui:spinner(section, "DPS Testing", { value = 5, min = 5, max = 60,
            tip = "Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5" })
        -- Crackling Jade lightning
        br.ui:checkbox(section, "Crackling Jade Lightning")
        br.ui:spinner(section, "Cancel CJL Range", { value = 10, min = 5, max = 40, checkbox = false,
            tip = "Cancels Crackling Jade Lightning below this range in yards." })
        -- Grapple Weapon
        br.ui:checkbox(section, "Grapple Weapon", { tip = "Automatically disarms dangerous melee enemies in PvE." })
        -- Legacy of the Emperor
        br.ui:dropdown(section, "Legacy of the Emperor", { choices = { "Player", "Target", "Mouseover", "Focus", "Group" }, value = "Player",
            tip = "Set how to use Legacy of the Emperor" })
        -- Legacy of the White Tiger
        br.ui:dropdown(section, "Legacy of the White Tiger", { choices = { "Player", "Target", "Mouseover", "Focus", "Group" }, value = "Player",
            tip = "Set how to use Legacy of the White Tiger" })
        -- Roll
        br.ui:checkbox(section, "Roll")
    ------------------------
    --- COOLDOWN OPTIONS ---
    ------------------------
    section = br.ui:section("Cooldown")
        -- Invoke Xuen the White Tiger
        br.ui:dropdown(section, "Invoke Xuen", { choices = "AlwaysCdAoeNever", value = "AOE/CD", checkbox = false,
            tip = "When to use Invoke Xuen the White Tiger" })
        -- Touch of Death
        br.ui:dropdown(section, "Touch of Death", { choices = "AlwaysCdAoeNever", value = "AOE/CD", checkbox = false,
            tip = "When to use Touch of Death" })
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = br.ui:section("Defensive")
        -- Dampen Harm / Diffuse Magic
        br.ui:spinner(section, "Dampen Harm / Diffuse Magic", { value = 60, tip = "Health Percent to Cast At" })
        -- Detox
        br.ui:checkbox(section, "Detox")
        br.ui:dropdown(section, "Detox - Target", { choices = { "|cff00FF00Player", "|cffFFFF00Target", "|cffFF0000Mouseover" }, value = "Player", checkbox = false,
            tip = "Target to cast on" })
        -- Disable
        br.ui:checkbox(section, "Disable", { tip = "Disables all defensive abilities." })
        -- Expel Harm
        br.ui:spinner(section, "Expel Harm", { value = 40, tip = "Health Percent to Cast At" })
        -- Fortifying Brew
        br.ui:spinner(section, "Fortifying Brew", { value = 30, tip = "Health Percent to Cast At" })
        -- Healing Sphere
        br.ui:spinner(section, "Healing Sphere", { value = 50, tip = "Health Percent to Cast At" })
        br.ui:dropdown(section, "Healing Sphere - Target", { choices = { "|cff00FF00Self", "|cffFFFF00Lowest" }, value = "Self", checkbox = false,
            tip = "Target to cast Healing Sphere on" })
        -- Leg Sweep
        br.ui:spinner(section, "Leg Sweep - HP", { value = 50, tip = "Health Percent to Cast At" })
        br.ui:spinner(section, "Leg Sweep - AoE", { value = 5, max = 10, step = 1, tip = "Number of Units in 5 Yards to Cast At" })
        -- Nimble Brew
        br.ui:checkbox(section, "Nimble Brew")
        -- Resuscitate
        br.ui:checkbox(section, "Resuscitate")
        br.ui:dropdown(section, "Resuscitate - Target", { choices = { "|cff00FF00Target", "|cffFF0000Mouseover" }, value = "Target", checkbox = false,
            tip = "Target to cast on" })
        -- Touch of Karma
        br.ui:spinner(section, "Touch of Karma", { value = 60, tip = "Health Percent to Cast At" })
        -- Tiger's Lust
        br.ui:checkbox(section, "Tiger's Lust", { tip = "Auto-cast Tiger's Lust to free movement impairment." })
    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = br.ui:section("Interrupts")
        -- Leg Sweep
        br.ui:checkbox(section, "Leg Sweep")
        -- Paralysis
        br.ui:checkbox(section, "Paralysis")
        -- Spear Hand Strike
        br.ui:checkbox(section, "Spear Hand Strike")
        -- Interrupt Percentage
        br.ui:spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "|cffFFBB00Cast Percentage to use at." })
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
local debuff
local enemies
local energy
local module
local ui
local unit
local units
local spell
local talent
-- Profile Specific Locals
local actionList = {}
local var = {}
var.getFacingDistance = br.functions.range.getFacingDistance
var.haltProfile = false
var.profileStop = false
var.grappleWeaponBlacklist = {} -- Stores NPC IDs that don't have weapons
var.lastGrappleTarget = nil

-- * Get Buff Unit Option (Generic for all buffs)
local getBuffUnitOption = function(option, buffObject)
    local thisTar = ui.value(option)
    local thisUnit
    if thisTar == 1 then
        thisUnit = "player"
    end
    if thisTar == 2 then
        thisUnit = "target"
    end
    if thisTar == 3 then
        thisUnit = "mouseover"
    end
    if thisTar == 4 then
        thisUnit = "focus"
    end
    if thisTar == 5 then
        -- Group mode: Only buff when:
        -- 1. At least one member needs the buff
        -- 2. All current party/raid members are alive and in range
        -- 3. Group size has been stable for at least 3 seconds (prevents buffing when someone just left)

        -- Don't buff if group size changed recently (within 3 seconds)
        if not br.engines.healingEngine:isGroupStable(3) then
            return nil
        end

        local allAliveAndInRange = true
        local someoneNeedsBuff = false
        local unitNeedingBuff = nil
        local currentGroupSize = #br.engines.healingEngine.friend

        if currentGroupSize == 1 then return "player" end

        if currentGroupSize > 1 then
            -- First pass: Check if all members are alive and in range
            for i = 1, currentGroupSize do
                local checkUnit = br.engines.healingEngine.friend[i].unit
                if unit.deadOrGhost(checkUnit) or unit.distance(checkUnit) >= 40 then
                    allAliveAndInRange = false
                    break
                end
            end

            -- Second pass: Check if anyone needs the buff
            if allAliveAndInRange then
                for i = 1, currentGroupSize do
                    local nextUnit = br.engines.healingEngine.friend[i].unit
                    if buffObject.refresh(nextUnit) and unit.distance(nextUnit) < 40 then
                        someoneNeedsBuff = true
                        if unitNeedingBuff == nil then
                            unitNeedingBuff = nextUnit
                        end
                    end
                end
            end
        end

        -- Only return a unit if all members are ready AND someone needs the buff
        if allAliveAndInRange and someoneNeedsBuff then
            thisUnit = unitNeedingBuff or "player"
        else
            return nil
        end
    end
    return thisUnit
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- * Crackling Jade Lightning
    if ui.checked("Crackling Jade Lightning") and not unit.mounted() and not cast.current.cracklingJadeLightning()
        and not unit.moving() and cast.able.cracklingJadeLightning("target") and unit.valid("target")
        and var.targetDistance > ui.value("Cancel CJL Range")
    then
        if cast.cracklingJadeLightning("target") then
            ui.debug("Casting Crackling Jade Lightning")
            return true
        end
    end
    -- * Roll
    if ui.checked("Roll") and cast.able.roll() and unit.moving()
        and var.targetDistance > 10 and unit.valid("target")
        and var.getFacingDistance() < 5 and unit.facing("player", "target", 10)
    then
        if cast.roll() then
            ui.debug("Casting Roll")
            return true
        end
    end
    -- * Grapple Weapon
    if ui.checked("Grapple Weapon") and unit.inCombat() and #enemies.yards5 > 0 then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if cast.able.grappleWeapon(thisUnit) and unit.exists(thisUnit) and unit.distance(thisUnit) <= 40
                and not debuff.grappleWeapon.exists(thisUnit)
            then
                -- Get NPC ID to check blacklist
                local npcID = br.functions.unit:GetObjectID(thisUnit)
                -- Skip if this NPC type is blacklisted (known to not have weapons)
                if not var.grappleWeaponBlacklist[npcID] then
                    var.lastGrappleTarget = thisUnit
                    if cast.grappleWeapon(thisUnit) then
                        ui.debug("Casting Grapple Weapon on " .. unit.name(thisUnit) .. " [Extra]")
                        return true
                    end
                end
            end
        end
    end
    -- * Legacy of the Emperor
    if ui.checked("Legacy of the Emperor") and not (buff.markOfTheWild.exists() or buff.blessingOfKings.exists()) then
        var.markUnit = getBuffUnitOption("Legacy of the Emperor", buff.legacyOfTheEmperor)
        -- Only cast if we have a valid unit (will be nil in Group mode if not all members are ready)
        if var.markUnit and cast.able.legacyOfTheEmperor(var.markUnit) and buff.legacyOfTheEmperor.refresh(var.markUnit)
            and not unit.inCombat()
            and not unit.resting() and unit.distance(var.markUnit) < 40
        then
            if cast.legacyOfTheEmperor(var.markUnit) then
                local targetName = ui.value("Legacy of the Emperor") == 5 and "Party" or unit.name(var.markUnit)
                ui.debug("Casting Legacy of the Emperor on " .. targetName)
                return true
            end
        end
    end
    -- * Legacy of the White Tiger
    if ui.checked("Legacy of the White Tiger") and not (buff.arcaneBrilliance.exists() or buff.dalaranBrilliance.exists()
            or buff.leaderOfThePack.exists()) then
                -- Only cast if we have a valid unit (will be nil in Group mode if not all members are ready)
        var.whiteTigerUnit = getBuffUnitOption("Legacy of the White Tiger", buff.legacyOfTheWhiteTiger)
        if var.whiteTigerUnit and cast.able.legacyOfTheWhiteTiger(var.whiteTigerUnit) and buff.legacyOfTheWhiteTiger.refresh(var.whiteTigerUnit)
            and not unit.inCombat()
            and not unit.resting() and unit.distance(var.whiteTigerUnit) < 40
        then
            if cast.legacyOfTheWhiteTiger(var.whiteTigerUnit) then
                local targetName = ui.value("Legacy of the White Tiger") == 5 and "Party" or unit.name(var.whiteTigerUnit)
                ui.debug("Casting Legacy of the White Tiger on " .. targetName)
                return true
            end
        end
    end
    -- * Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing")) * 60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
end -- End Action List- Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() and not unit.mounted() then
        local opValue
        local thisUnit
        -- * Disable
        if ui.checked("Disable") then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if cast.able.disable(thisUnit) and unit.isFleeing(thisUnit) then
                    if cast.disable(thisUnit) then
                        ui.debug("Casting Disable on " .. unit.name(thisUnit) .. " [Defensive]")
                        return true
                    end
                end
            end
        end
        -- * Nimble Brew
        if ui.checked("Nimble Brew") and cast.able.nimbleBrew()
            and cast.noControl.nimbleBrew()
        then
            if cast.nimbleBrew() then
                ui.debug("Casting Nimble Brew [Defensive]")
                return true
            end
        end
        -- * Tiger's Lust
        if ui.checked("Tiger's Lust") and talent.tigersLust
            and cast.able.tigersLust() and cast.noControl.tigersLust()
            and (not ui.checked("Nimble Brew") or not spell.nimbleBrew.known()
            or cd.nimbleBrew.remain() > 1 and cd.nimbleBrew.remain() < 119)
        then
            if cast.tigersLust() then
                ui.debug("Casting Tiger's Lust [Defensive]")
                return true
            end
        end
        -- * Expel Harm
        if ui.checked("Expel Harm") and cast.able.expelHarm()
            and unit.hp() <= ui.value("Expel Harm") and energy() >= 40
        then
            if cast.expelHarm() then
                ui.debug("Casting Expel Harm [Defensive]")
                return true
            end
        end
        -- * Touch of Karma
        if ui.checked("Touch of Karma") and cast.able.touchOfKarma() and unit.hp() <= ui.value("Touch of Karma") then
            if cast.touchOfKarma() then
                ui.debug("Casting Touch of Karma [Defensive]")
                return true
            end
        end
        -- * Fortifying Brew
        if ui.checked("Fortifying Brew") and cast.able.fortifyingBrew() and unit.hp() <= ui.value("Fortifying Brew")
            and not buff.fortifyingBrew.exists()
        then
            if cast.fortifyingBrew() then
                ui.debug("Casting Fortifying Brew [Defensive]")
                return true
            end
        end
        -- * Leg Sweep
        if ui.checked("Leg Sweep - HP") and cast.able.legSweep() and unit.hp() <= ui.value("Leg Sweep - HP")
            and unit.inCombat() and #enemies.yards5 > 0
        then
            if cast.legSweep() then
                ui.debug("Casting Leg Sweep - HP [Defensive]")
                return true
            end
        end
        if ui.checked("Leg Sweep - AoE") and cast.able.legSweep()
            and #enemies.yards5 >= ui.value("Leg Sweep - AoE")
        then
            if cast.legSweep() then
                ui.debug("Casting Leg Sweep - AoE [Defensive]")
                return true
            end
        end
        -- * Dampen Harm
        if ui.checked("Dampen Harm / Diffuse Magic") and cast.able.dampenHarm() and unit.hp() <= ui.value("Dampen Harm / Diffuse Magic")
            and not buff.dampenHarm.exists() and unit.inCombat()
        then
            if cast.dampenHarm() then
                ui.debug("Casting Dampen Harm [Defensive]")
                return true
            end
        end
        -- * Diffuse Magic
        if ui.checked("Dampen Harm / Diffuse Magic") and cast.able.diffuseMagic() and unit.hp() <= ui.value("Dampen Harm / Diffuse Magic")
            and not buff.diffuseMagic.exists() and unit.inCombat()
        then
            if cast.diffuseMagic() then
                ui.debug("Casting Diffuse Magic [Defensive]")
                return true
            end
        end
        -- * Detox
        if ui.checked("Detox") then
            opValue = ui.value("Detox - Target")
            if opValue == 1 then
                thisUnit = "player"
            elseif opValue == 2 then
                thisUnit = "target"
            elseif opValue == 3 then
                thisUnit = "mouseover"
            end
            if cast.able.detox(thisUnit) and (unit.friend(thisUnit) or unit.player(thisUnit))
                and cast.dispel.detox(thisUnit)
            then
                if cast.detox(thisUnit) then
                    ui.debug("Casting Detox on " .. unit.name(thisUnit) .. "[Defensive]")
                    return true
                end
            end
        end
        -- * Resuscitate
        if ui.checked("Resuscitate") and not unit.inCombat() then
            opValue = ui.value("Resuscitate - Target")
            if opValue == 1 then
                thisUnit = "target"
            elseif opValue == 2 then
                thisUnit = "mouseover"
            end
            if cast.able.resuscitate(thisUnit, "dead") and unit.deadOrGhost(thisUnit)
                and (unit.friend(thisUnit) and unit.player(thisUnit))
            then
                if cast.resuscitate(thisUnit, "dead") then
                    ui.debug("Casting Resuscitate on " .. unit.name(thisUnit) .. "[Defensive]")
                    return true
                end
            end
        end
        -- * Healing Sphere
        if ui.checked("Healing Sphere") and energy() >= 40 then
            local healTarget = "player"
            local shouldCast = false

            if ui.value("Healing Sphere - Target") == 1 then
                -- Self only
                if unit.hp() <= ui.value("Healing Sphere") or (not unit.inCombat() and unit.hp() < 80) then
                    healTarget = "player"
                    shouldCast = true
                end
            elseif ui.value("Healing Sphere - Target") == 2 then
                -- Lowest health
                local lowestUnit = "player"
                local lowestHP = unit.hp()

                -- Check party/raid members
                if #br.engines.healingEngine.friend > 1 then
                    for i = 1, #br.engines.healingEngine.friend do
                        local friendUnit = br.engines.healingEngine.friend[i].unit
                        local friendHP = unit.hp(friendUnit)
                        if friendHP < lowestHP and unit.distance(friendUnit) < 40 then
                            lowestHP = friendHP
                            lowestUnit = friendUnit
                        end
                    end
                end

                if lowestHP <= ui.value("Healing Sphere") or (not unit.inCombat() and lowestHP < 80) then
                    healTarget = lowestUnit
                    shouldCast = true
                end
            end

            if shouldCast and cast.able.healingSphere(healTarget, "ground", 0) then
                if cast.healingSphere(healTarget, "ground", 0) then
                    ui.debug("Casting Healing Sphere on " .. unit.name(healTarget) .. " [Defensive]")
                    return true
                end
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Cooldowns
actionList.Cooldowns = function()
    -- Trinket - Non-Specific
    if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
        module.BasicTrinkets()
    end
end -- End Action List - Cooldowns

-- Action List - Interrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) and unit.distance(thisUnit) < 5 then
                -- * Quaking Palm (Pandaren Racial)
                if ui.checked("Use Racial") and unit.race() == "Pandaren" then
                    module.Racial(nil,thisUnit)
                end
                -- * Spear Hand Strike
                if ui.checked("Spear Hand Strike") and cast.able.spearHandStrike(thisUnit)
                    and not (ui.checked("Use Racial") and unit.race() == "Pandaren" and cast.able.quakingPalm(thisUnit))
                 then
                    if cast.spearHandStrike(thisUnit) then
                        ui.debug("Casting Spear Hand Strike [Interrupt]")
                        return true
                    end
                end
                -- * Leg Sweep
                if ui.checked("Leg Sweep") and cast.able.legSweep(thisUnit)
                    and not (ui.checked("Use Racial") and unit.race() == "Pandaren" and cast.able.quakingPalm(thisUnit))
                    and not (ui.checked("Spear Hand Strike") and cast.able.spearHandStrike(thisUnit))
                then
                    if cast.legSweep(thisUnit) then
                        ui.debug("Casting Leg Sweep [Interrupt]")
                        return true
                    end
                end
            end
        end
        if #enemies.yards5 > 0 then
            for i = 1,#enemies.yards20 do
                local thisUnit = enemies.yards20[i]
                if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                    local thisDistance = unit.distance(thisUnit)
                    -- Only use Paralysis on targets outside melee range OR when melee interrupts are on cooldown
                    local useMeleeInterrupt = thisDistance < 5 and (
                        (ui.checked("Use Racial") and unit.race() == "Pandaren" and cast.able.quakingPalm(thisUnit)) or
                        (ui.checked("Spear Hand Strike") and cast.able.spearHandStrike(thisUnit)) or
                        (ui.checked("Leg Sweep") and cast.able.legSweep(thisUnit))
                    )

                    -- * Paralysis
                    if ui.checked("Paralysis") and cast.able.paralysis(thisUnit)
                        and thisDistance < 20 and not useMeleeInterrupt
                    then
                        if cast.paralysis(thisUnit) then
                            ui.debug("Casting Paralysis [Interrupt]")
                            return true
                        end
                    end
                end
            end
        end
    end -- End Interrupt Check
end -- End Action List - Interrupt

-- Action List - AOE
actionList.AOE = function()
    -- * Rushing Jade Wind
    -- rushing_jade_wind,if=talent.rushing_jade_wind.enabled
    if talent.rushingJadeWind and cast.able.rushingJadeWind() then
        if cast.rushingJadeWind() then
            ui.debug("Casting Rushing Jade Wind [AOE]")
            return true
        end
    end
    -- * Zen Sphere
    -- zen_sphere,cycle_targets=1,if=talent.zen_sphere.enabled&!dot.zen_sphere.ticking
    if talent.zenSphere then
        for i = 1, #enemies.yards8 do
            local thisUnit = enemies.yards8[i]
            if cast.able.zenSphere(thisUnit) and not debuff.zenSphere.exists(thisUnit) then
                if cast.zenSphere(thisUnit) then
                    ui.debug("Casting Zen Sphere on " .. unit.name(thisUnit) .. " [AOE]")
                    return true
                end
            end
        end
    end
    -- * Chi Wave
    -- chi_wave,if=talent.chi_wave.enabled
    if talent.chiWave and cast.able.chiWave(units.dyn40) then
        if cast.chiWave(units.dyn40) then
            ui.debug("Casting Chi Wave [AOE]")
            return true
        end
    end
    -- * Chi Burst
    -- chi_burst,if=talent.chi_burst.enabled
    if talent.chiBurst and cast.able.chiBurst(units.dyn40) then
        if cast.chiBurst(units.dyn40) then
            ui.debug("Casting Chi Burst [AOE]")
            return true
        end
    end
    -- * Rising Sun Kick
    -- rising_sun_kick,if=chi=chi.max
    if cast.able.risingSunKick() and chi() == chi.max() then
        if cast.risingSunKick() then
            ui.debug("Casting Rising Sun Kick [AOE]")
            return true
        end
    end
    -- * Spinning Crane Kick
    -- spinning_crane_kick,if=!talent.rushing_jade_wind.enabled
    if cast.able.spinningCraneKick("player", "aoe", 1, 8) and not talent.rushingJadeWind then
        if cast.spinningCraneKick("player", "aoe", 1, 8) then
            ui.debug("Casting Spinning Crane Kick [AOE]")
            return true
        end
    end
end -- End Action List - AOE

-- Action List - Single Target
actionList.SingleTarget = function()
    -- * Rising Sun Kick
    -- rising_sun_kick
    if cast.able.risingSunKick() then--and not debuff.risingSunKick.exists(units.dyn5) then
        if cast.risingSunKick() then
            ui.debug("Casting Rising Sun Kick [Single Target]")
            return true
        end
    end
    -- * Fists of Fury
    -- fists_of_fury,if=buff.energizing_brew.down&energy.time_to_max>4&buff.tiger_power.remains>4
    if cast.able.fistsOfFury("player","cone",1,90) and unit.standingTime() > 1 and (unit.ttdGroup(5) > 5 or unit.isDummy())
        and not buff.energizingBrew.exists() and energy.ttm() > 4 and buff.tigerPower.remain() > 4
    then
        if cast.fistsOfFury("player","cone",1,90) then
            ui.debug("Casting Fists of Fury [Single Target]")
            return true
        end
    end
    -- * Chi Wave
    -- chi_wave,if=talent.chi_wave.enabled&energy.time_to_max>2
    if talent.chiWave and cast.able.chiWave(units.dyn40) and energy.ttm() > 2 then
        if cast.chiWave(units.dyn40) then
            ui.debug("Casting Chi Wave [Single Target]")
            return true
        end
    end
    -- * Chi Burst
    -- chi_burst,if=talent.chi_burst.enabled&energy.time_to_max>2
    if talent.chiBurst and cast.able.chiBurst(units.dyn40) and energy.ttm() > 2 then
        if cast.chiBurst(units.dyn40) then
            ui.debug("Casting Chi Burst [Single Target]")
            return true
        end
    end
    -- * Zen Sphere
    -- zen_sphere,cycle_targets=1,if=talent.zen_sphere.enabled&energy.time_to_max>2&!dot.zen_sphere.ticking
    if talent.zenSphere and cast.able.zenSphere(units.dyn40) and energy.ttm() > 2 and not debuff.zenSphere.exists(units.dyn40) then
        if cast.zenSphere(units.dyn40) then
            ui.debug("Casting Zen Sphere [Single Target]")
            return true
        end
    end
    -- * Blackout Kick
    -- blackout_kick,if=buff.combo_breaker_bok.react
    if cast.able.blackoutKick() and buff.comboBreakerBoK.exists() then
        if cast.blackoutKick() then
            ui.debug("Casting Blackout Kick - Combo Breaker [Single Target]")
            return true
        end
    end
    -- * Tiger Palm
    -- tiger_palm,if=buff.combo_breaker_tp.react&(buff.combo_breaker_tp.remains<=2|energy.time_to_max>=2)
    if cast.able.tigerPalm() and buff.comboBreakerTP.exists() and (buff.comboBreakerTP.remain() <= 2 or energy.ttm() >= 2) then
        if cast.tigerPalm() then
            ui.debug("Casting Tiger Palm - Combo Breaker [Single Target]")
            return true
        end
    end
    -- * Jab
    -- jab,if=chi.max-chi>=2
    if cast.able.jab() and (chi.max() - chi()) >= 2 then
        if cast.jab() then
            ui.debug("Casting Jab [Single Target]")
            return true
        end
    end
    -- * Blackout Kick
    -- blackout_kick,if=energy+energy.regen*cooldown.rising_sun_kick.remains>=40
    if cast.able.blackoutKick() and (energy() + energy.regen() * cd.risingSunKick.remain() >= 40) then
        if cast.blackoutKick() then
            ui.debug("Casting Blackout Kick [Single Target]")
            return true
        end
    end
end -- End Action List - Single Target

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- * Expel Harm - Chi Builder
            if ui.mode.chiBuilder == 1 and cast.able.expelHarm() and energy() >= 40 and unit.hp() <= 80 then
                if cast.expelHarm() then
                    ui.debug("Casting Expel Harm - Chi Builder [Precombat]")
                    return true
                end
            end
            -- * Auto Attack
            if cast.able.autoAttack("target") and unit.exists("target") and var.targetDistance < 5 then
                if cast.autoAttack("target") then
                    ui.debug("Casting Auto Attack [Precombat]")
                    return true
                end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    -- Check for combat
    if unit.valid("target") and cd.global.remain() == 0 then
        if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 and not buff.spinningCraneKick.exists() then
            -- * Touch of Death
            if ui.alwaysCdAoENever("Touch of Death",3,5) then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if cast.able.touchOfDeath(thisUnit)
                        and (unit.health(thisUnit) <= unit.healthMax("player") or buff.deathNote.exists())
                    then
                        if cast.touchOfDeath(thisUnit) then
                            ui.debug("Casting Touch of Death - Omae wa mou shindeiru")
                            return true
                        end
                    end
                end
            end
            -- * Auto Attack
            -- auto_attack
            if cast.able.autoAttack(units.dyn5) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                if cast.autoAttack(units.dyn5) then
                    ui.debug("Casting Auto Attack [Combat]")
                    return true
                end
            end
            -- * Chi Sphere
            -- chi_sphere,if=talent.power_strikes.enabled&buff.chi_sphere.react&chi<4
            -- TODO: Notify when to collect chi spheres
            -- * Use Items: Potion
            -- virmens_bite_potion,if=buff.bloodlust.react|target.time_to_die<=60
            -- TODO: Potion
            -- * Use Items: Hands
            -- use_item,name=gloves_of_the_golden_protector
            -- TODO: Gloves
            -- * Racial: Troll
            -- berserking
            if unit.race() == "Troll" then
                module.Racial()
            end
            -- * Chi Brew
            -- chi_brew,if=talent.chi_brew.enabled&chi<=2&(trinket.proc.agility.react|(charges=1&recharge_time<=10)|charges=2|target.time_to_die<charges*10)
            if talent.chiBrew and cast.able.chiBrew() and chi() <= 2
                and ((charges.chiBrew.count() == 1 and charges.chiBrew.recharge() <= 10)
                    or charges.chiBrew.count() == 2 or unit.ttd(units.dyn5) < charges.chiBrew.count() * 10)
            then
                if cast.chiBrew() then
                    ui.debug("Casting Chi Brew [Combat]")
                    return true
                end
            end
            -- * Tiger Palm
            -- tiger_palm,if=buff.tiger_power.remains<=3
            if cast.able.tigerPalm() and buff.tigerPower.remain() <= 3 then
                if cast.tigerPalm() then
                    ui.debug("Casting Tiger Palm - Low Tiger Power [Combat]")
                    return true
                end
            end
            -- * Tigereye Brew
            -- tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack=20
            if cast.able.tigereyeBrew("player") and not buff.tigereyeBrewUse.exists("player","EXACT") and buff.tigereyeBrew.stack() == 20 then
                if cast.tigereyeBrew("player") then
                    ui.debug("Casting Tigereye Brew - 20 Stacks [Combat]")
                    return true
                end
            end
            -- tigereye_brew,if=buff.tigereye_brew_use.down&trinket.proc.agility.react
            -- TODO: Trinket Procs
            -- tigereye_brew,if=buff.tigereye_brew_use.down&chi>=2&(trinket.proc.agility.react|trinket.proc.strength.react|buff.tigereye_brew.stack>=15|target.time_to_die<40)&debuff.rising_sun_kick.up&buff.tiger_power.up
            if cast.able.tigereyeBrew("player") and not buff.tigereyeBrewUse.exists("player","EXACT") and chi() >= 2
                and (buff.tigereyeBrew.stack() >= 15 or (unit.ttdGroup() < 40 and not unit.isDummy()))
                and debuff.risingSunKick.exists(units.dyn5) and buff.tigerPower.exists()
            then
                if cast.tigereyeBrew("player") then
                    ui.debug("Casting Tigereye Brew - 15 Stacks or TTD < 40 [Combat]")
                    return true
                end
            end
            -- * Energizing Brew
            -- energizing_brew,if=energy.time_to_max>5
            if cast.able.energizingBrew() and energy.ttm() > 5 then
                if cast.energizingBrew() then
                    ui.debug("Casting Energizing Brew [Combat]")
                    return true
                end
            end
            -- * Rising Sun Kick
            -- rising_sun_kick,if=debuff.rising_sun_kick.down
            if cast.able.risingSunKick() and not debuff.risingSunKick.exists(units.dyn5) then
                if cast.risingSunKick() then
                    ui.debug("Casting Rising Sun Kick [Combat]")
                    return true
                end
            end
            -- * Tiger Palm
            -- tiger_palm,if=buff.tiger_power.down&debuff.rising_sun_kick.remains>1&energy.time_to_max>1
            if cast.able.tigerPalm() and not buff.tigerPower.exists() and debuff.risingSunKick.remain(units.dyn5) > 1 and energy.ttm() > 1 then
                if cast.tigerPalm() then
                    ui.debug("Casting Tiger Palm [Combat]")
                    return true
                end
            end
            -- * Invoke Xuen
            -- invoke_xuen,if=talent.invoke_xuen.enabled
            if ui.alwaysCdAoENever("Invoke Xuen") and talent.invokeXuenTheWhiteTiger and cast.able.invokeXuenTheWhiteTiger() and var.targetDistance < 5 then
                if cast.invokeXuenTheWhiteTiger() then
                    ui.debug("Casting Invoke Xuen [Combat]")
                    return true
                end
            end
            -- * Run Action List - AOE
            -- run_action_list,name=aoe,if=active_enemies>=3
            if ui.useAOE(8,3) and unit.level() >= 46 then
                if actionList.AOE() then return true end
            end
            -- * Run Action List - Single Target
            -- run_action_list,name=single_target,if=active_enemies<3
            if ui.useST(8,3) or unit.level() < 46 then
                if actionList.SingleTarget() then return true end
            end
        end -- End In Combat Rotation
    end
end -- End Action List - Combat

----------------
--- ROTATION ---
----------------
-- Event frame for error detection
var.grappleWeaponErrorFrame = var.grappleWeaponErrorFrame or CreateFrame("Frame")

var.grappleWeaponErrorFrame:RegisterEvent("UI_ERROR_MESSAGE")
var.grappleWeaponErrorFrame:SetScript("OnEvent", function(self, event, errorType, message)
    if message and var.lastGrappleTarget and var.grappleWeaponBlacklist then
        -- Check for weapon-related errors (common messages: "Target has no weapons", "Can't do that")
        local weaponError = message:lower():find("weapon") or message:lower():find("disarm")
        if weaponError then
            local npcID = br.functions.unit:GetObjectID(var.lastGrappleTarget)
            if npcID and not var.grappleWeaponBlacklist[npcID] then
                var.grappleWeaponBlacklist[npcID] = true
                print("|cff8000FFBadRotations|r: Blacklisted " .. (UnitName(var.lastGrappleTarget) or "Unknown") .. " (ID: " .. npcID .. ") - No weapons to grapple")
            end
        end
        var.lastGrappleTarget = nil
    end
end)

local function runRotation()
    -- This profile handles racials itself; skip the shared Racial module
    if not br.player.localRacial then br.player.localRacial = true end
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff            = br.player.buff
    cast            = br.player.cast
    cd              = br.player.cd
    charges         = br.player.charges
    chi             = br.player.power.chi
    debuff          = br.player.debuff
    enemies         = br.player.enemies
    energy          = br.player.power.energy
    module          = br.player.module
    ui              = br.player.ui
    unit            = br.player.unit
    units           = br.player.units
    spell           = br.player.spell
    talent          = br.player.talent
    -- General Locals
    var.haltProfile = (unit.inCombat() and var.profileStop) or unit.mounted() or ui.pause() or ui.mode.rotation == 4
    -- Dynamic Units
    -- Units
    units.get(5)
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(8)
    -- enemies.get(8,"player",true) -- No Combat
    enemies.get(20)
    enemies.get(40)

    var.targetDistance = unit.distance("target")

    -- Cancel Crackling Jade Lightning
    if cast.current.cracklingJadeLightning() and var.targetDistance < ui.value("Cancel CJL Range") then
        if cast.cancel.cracklingJadeLightning() then
            ui.debug("Canceling Crackling Jade Lightning [Within " .. ui.value("Cancel CJL Range") .. "yrds]")
            return true
        end
    end


    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif var.haltProfile then
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -------------
        --- Extra ---
        -------------
        if actionList.Extra() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        if ui.mode.rotation ~= 4 then
            ------------------------------
            --- Out of Combat Rotation ---
            ------------------------------
            if actionList.PreCombat() then return true end
            --------------------------
            --- In Combat Rotation ---
            --------------------------
            -----------------
            --- Interrupt ---
            -----------------
            if actionList.Interrupt() then return true end
            if actionList.Combat() then return true end
        end
    end -- Pause
end     -- End runRotation
br.loader.registerRotation({
    name      = rotationName,
    specID    = 269,
    expansion = "MOP",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

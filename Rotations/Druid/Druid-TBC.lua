local rotationName = "Feral-TBC" -- Port of wowsims/tbc feral rotation.go

---------------
--- Toggles ---
---------------
local function createToggles()
    local RotationModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Auto", highlight = 1, icon = br.player.spells.swipe },
        [2] = { mode = "Multi", value = 2, overlay = "Multiple Target", tip = "Multi", highlight = 0, icon = br.player.spells.swipe },
        [3] = { mode = "Single", value = 3, overlay = "Single Target", tip = "Single", highlight = 0, icon = br.player.spells.shred },
        [4] = { mode = "Off", value = 4, overlay = "Disabled", tip = "Disable", highlight = 0, icon = br.player.spells.healingTouch }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Defensive", highlight = 1, icon = br.player.spells.barkskin },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives", highlight = 0, icon = br.player.spells.barkskin }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
end

---------------
--- Options ---
---------------
local function createOptions()
    local optionTable
    local function rotationOptions()
        local section = br.ui:createSection(br.ui.window.profile, "Feral (TBC) Options")
        br.ui:createCheckbox(section, "Use Rip Weave", "Enable Rip-weave (RipTrick)")
        br.ui:createCheckbox(section, "Use Rake Trick", "Enable Rake tricks")
        br.ui:createCheckbox(section, "Use Mangle Trick", "Enable Mangle trick")
        br.ui:createCheckbox(section, "Maintain Faerie Fire", "Keep Feral Faerie Fire up")
        br.ui:createSpinner(section, "Rip CP", 3, 1, 5, 1, "Combo points to Rip at")
        br.ui:createSpinner(section, "Bite CP", 5, 1, 5, 1, "Combo points to Bite at")
        br.ui:createSpinner(section, "Barkskin", 50, 0, 100, 5, "Health percent to cast Barkskin at")
        br.ui:checkSectionState(section)
    end
    optionTable = { {
        [1] = "Rotation Options",
        [2] = rotationOptions,
    } }
    return optionTable
end

--------------
--- Locals ---
--------------
local buff, cast, cd, comboPoints, debuff, enemies, energy, rage, module, ui, unit, units, spell
local var = {}
local profileStop
local actionList = {}
local readyToShift = false
local waitingForTick = false
local latency = 0.10

-- Constants mapped from rotation.go
local BiteTrickCP = 2
local BiteTrickMax = 39.0
local RipEndThresh = 10 -- seconds
local MaxWaitTime = 1.0 -- seconds

-- Helper: simple next energy tick estimate (approx)
-- Helper: estimate time (s) until next energy 'tick' using regen (energy/sec)
local function timeToNextEnergyTick()
    local regen = br.player.power.energy.regen() or 0
    if regen > 0 then
        return 1 / regen
    end
    return 99
end

-- Shift (powershift) logic (two-stage readyToShift)
local function doShift()
    waitingForTick = false
    if not readyToShift then
        readyToShift = true
        return false
    end
    readyToShift = false
    -- Attempt to powershift using engine API if available
    if unit and unit.cancelForm then
        unit.cancelForm()
        ui.debug("Powershift: canceled form")
        return true
    end
    return false
end

--------------------
--- Action Lists ---
--------------------
actionList.Extra = function()
    -- Maintain Faerie Fire
    if ui.checked("Maintain Faerie Fire") and cast.able.faerieFireFeral() and unit.enemy(units.dyn5) and not debuff.faerieFireFeral.exists(units.dyn5) then
        if cast.faerieFireFeral(units.dyn5) then ui.debug("Casting Faerie Fire (Feral)") return true end
    end
    return false
end

actionList.Defensive = function()
    if ui.useDefensive() then
        if ui.checked("Barkskin") and cast.able.barkskin() and unit.hp() <= ui.value("Barkskin") then
            if cast.barkskin() then ui.debug("Casting Barkskin") return true end
        end
    end
    return false
end

actionList.Interrupts = function()
    if ui.useInterrupt() then
        if ui.checked("Bash - Int") then
            for i = 1, #enemies.yards5f do
                local thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                    if cast.able.bearForm() and not buff.bearForm.exists() then
                        if cast.bearForm() then ui.debug("Shifting to Bear for Bash") return true end
                    end
                    if cast.able.bash(thisUnit) then if cast.bash(thisUnit) then ui.debug("Casting Bash") return true end end
                end
            end
        end
    end
    return false
end

-- Core rotation port of doRotation (simplified mapping)
actionList.Rotation = function()
    -- Ensure in Cat form
    if not buff.catForm.exists() then
        if cast.able.catForm() then
            if cast.catForm() then ui.debug("Casting Cat Form") end
        end
        return true
    end

    if readyToShift then
        return doShift()
    end

    local rotation = {}
    rotation.RipCP = ui.value("Rip CP") or 3
    rotation.BiteCP = ui.value("Bite CP") or 5
    rotation.UseRipTrick = ui.checked("Use Rip Weave")
    rotation.UseRakeTrick = ui.checked("Use Rake Trick")
    rotation.UseMangleTrick = ui.checked("Use Mangle Trick")

    comboPoints = br.player.power.comboPoints()
    energy = br.player.power.energy()
    local cp = comboPoints
    local omenProc = buff.clearcasting.exists()
    local ripDebuff = debuff.rip.exists(units.dyn5)
    local mangleDebuff = debuff.mangle.exists(units.dyn5)
    local rakeDebuff = debuff.rake.exists(units.dyn5)
    local nextTick = br._G.GetTime() + timeToNextEnergyTick()
    local energyRegen = br.player.power.energy.regen() or 0
    local timeToNextTick = timeToNextEnergyTick()

        local pseudoNoCost = br.player.pseudoStats and br.player.pseudoStats.noCost
        local ripNow = (cp >= rotation.RipCP and not ripDebuff)
            or (rotation.UseRipTrick and cp >= rotation.RipTrickCP and not ripDebuff and energy >= 52 and not pseudoNoCost)

        local biteNow = (cp >= rotation.BiteCP)

        -- debuff remaining times (seconds)
        local ripRemains = ripDebuff and debuff.rip.remains(units.dyn5) or 0
        local mangleRemains = mangleDebuff and debuff.mangle.remains(units.dyn5) or 0

        -- time until next energy 'tick' (use ttm to reach next whole energy point)
        local energyRegen = br.player.power.energy.regen() or 0
        local timeToNextTick = 99
        if energyRegen > 0 then
            -- time to gain 1 energy
            timeToNextTick = br.player.power.energy.ttm((br.player.power.energy() or 0) + 1) or (1 / energyRegen)
        end

        -- ripNext logic: either we should rip now OR rip would fall off before next tick
        local ripNext = (ripNow or (cp >= rotation.RipCP and ripDebuff and ripRemains <= timeToNextTick))
            and (unit.ttd(units.dyn5) > RipEndThresh)

        -- mangleNext: only if rip won't be next and mangle needs refresh or will fall off
        local mangleNow = not ripNow and not mangleDebuff
        local mangleNext = (not ripNext) and (mangleNow or (mangleDebuff and mangleRemains <= timeToNextTick))

        -- biteBeforeRip: if rip exists and we want to bite before rip falls
        local biteBeforeRip = ripDebuff and rotation.UseBite and (ripRemains >= 0)
        local biteBeforeRipNext = biteBeforeRip and (ripRemains - timeToNextTick >= 0)

        local prioBiteOverMangle = rotation.BiteOverRip or (not mangleNow)

        -- Decide action following the Go decision tree
        local shiftCost = 0
        if br.player.spell and br.player.spell.catForm and br.player.spell.catForm.DefaultCast then shiftCost = br.player.spell.catForm.DefaultCast.Cost or 0 end
        local hasShiftMana = true
        if br.player.CurrentMana and br.player.CurrentMana() < shiftCost then hasShiftMana = false end

        local mangleCost = (br.player.spell and br.player.spell.mangle and br.player.spell.mangle.DefaultCast and br.player.spell.mangle.DefaultCast.Cost) or 40

        if not hasShiftMana then
            -- No-shift rotation
            if ripNow and (energy >= 30 or omenProc) then
                if cast.rip(units.dyn5) then ui.debug("Casting Rip") return true end
            elseif mangleNow and (energy >= mangleCost or omenProc) then
                if cast.mangle(units.dyn5) then ui.debug("Casting Mangle") return true end
            elseif biteNow and (energy >= 35 or omenProc) then
                if cast.ferociousBite(units.dyn5) then ui.debug("Casting Ferocious Bite") return true end
            elseif energy >= 42 or omenProc then
                if cast.shred(units.dyn5) then ui.debug("Casting Shred") return true end
            else
                if timeToNextTick > MaxWaitTime then doShift() else waitingForTick = true end
            end
        else
            -- Shift allowed path: mirror Go's more complex branching
            if energy < 10 then
                if timeToNextTick > MaxWaitTime then doShift() else waitingForTick = true end
            elseif ripNow then
                if energy >= 30 or omenProc then
                    if cast.rip(units.dyn5) then ui.debug("Casting Rip") waitingForTick = false return true end
                elseif timeToNextTick > MaxWaitTime then
                    doShift()
                end
            elseif (biteNow and prioBiteOverMangle) then
                -- Bite vs Shred decision tree (simplified)
                local cutoffMod = 20.0
                if timeToNextTick <= 1.0 then cutoffMod = 0.0 end
                if energy >= 57.0 + cutoffMod or (energy >= 15 + cutoffMod and omenProc) then
                    if cast.shred(units.dyn5) then ui.debug("Casting Shred (bite gate)") return true end
                elseif energy >= 35 then
                    if cast.ferociousBite(units.dyn5) then ui.debug("Casting Ferocious Bite") return true end
                else
                    -- decide wait vs shift
                    local wait = false
                    if energy >= 22 and biteBeforeRip and not biteBeforeRipNext then
                        wait = true
                    elseif energy >= 15 and (not biteBeforeRip or biteBeforeRipNext) then
                        wait = true
                    elseif not ripNext and (energy < 20 or not mangleNext) then
                        doShift(); return true
                    else
                        wait = true
                    end
                    if wait and timeToNextTick > MaxWaitTime then doShift() end
                end
            elseif energy >= 35 and energy <= BiteTrickMax and rotation.UseRakeTrick and timeToNextTick > latency and not omenProc and cp >= BiteTrickCP then
                if cast.ferociousBite(units.dyn5) then ui.debug("Casting Ferocious Bite (Bite Trick)") return true end
            elseif energy >= 35 and energy < mangleCost and rotation.UseRakeTrick and timeToNextTick > 1.0 + latency and not rakeDebuff and not omenProc then
                if cast.rake(units.dyn5) then ui.debug("Casting Rake (Rake Trick)") return true end
            elseif mangleNow then
                if energy < mangleCost - 20 and not ripNext then doShift()
                elseif energy >= mangleCost or omenProc then if cast.mangle(units.dyn5) then ui.debug("Casting Mangle") return true end
                elseif timeToNextTick > MaxWaitTime then doShift() end
            elseif energy >= 22 then
                if omenProc then if cast.shred(units.dyn5) then ui.debug("Casting Shred (omen)") return true end end
                if energy >= 2 * mangleCost - 20 and energy < 22 + mangleCost and timeToNextTick <= 1.0 and rotation.UseMangleTrick and (not rotation.UseRakeTrick or mangleCost == 35) then
                    if cast.mangle(units.dyn5) then ui.debug("Casting Mangle (trick)") return true end
                end
                if energy >= 42 then if cast.shred(units.dyn5) then ui.debug("Casting Shred") return true end end
                if energy >= mangleCost and timeToNextTick > 1.0 + latency then if cast.mangle(units.dyn5) then ui.debug("Casting Mangle") return true end end
                if timeToNextTick > MaxWaitTime then doShift() end
            elseif not ripNext and (energy < mangleCost - 20 or not (mangleNext or rotation.UseMangleTrick)) then
                doShift()
            elseif timeToNextTick > MaxWaitTime then
                doShift()
            end
        end
    if not hasShiftMana then
        -- No-shift rotation
        if ripNow and (energy >= 30 or omenProc) then
            if cast.rip(units.dyn5) then ui.debug("Casting Rip") return true end
        elseif not mangleDebuff and (energy >= mangleCost or omenProc) then
            if cast.mangle(units.dyn5) then ui.debug("Casting Mangle") return true end
        elseif biteNow and (energy >= 35 or omenProc) then
            if cast.ferociousBite(units.dyn5) then ui.debug("Casting Ferocious Bite") return true end
        elseif energy >= 42 or omenProc then
            if cast.shred(units.dyn5) then ui.debug("Casting Shred") return true end
        else
            if energy < 10 then
                if timeToNextTick > MaxWaitTime then
                    doShift()
                else
                    waitingForTick = true
                    ui.debug("Waiting for energy tick")
                end
            end
        end
    else
        -- Shift allowed
        if energy < 10 then
            if timeToNextTick > MaxWaitTime then
                doShift()
            else
                waitingForTick = true
                ui.debug("Waiting for energy tick")
            end
        end
        if ripNow and (energy >= 30 or omenProc) then if cast.rip(units.dyn5) then ui.debug("Casting Rip") return true end end
        if not mangleDebuff and (energy >= mangleCost or omenProc) then if cast.mangle(units.dyn5) then ui.debug("Casting Mangle") return true end end
        if biteNow and (energy >= 35 or omenProc) then if cast.ferociousBite(units.dyn5) then ui.debug("Casting Ferocious Bite") return true end end
    end

    -- Fallbacks
    if cast.able.shred() and energy >= 42 then if cast.shred(units.dyn5) then ui.debug("Casting Shred - fallback") return true end end
    if cast.able.claw() then if cast.claw(units.dyn5) then ui.debug("Casting Claw fallback") return true end end

    return false
end

----------------
--- RUNNER ----
----------------
local function runRotation()
    -- Bind engine locals
    buff        = br.player.buff
    cast        = br.player.cast
    cd          = br.player.cd
    comboPoints = br.player.power.comboPoints()
    debuff      = br.player.debuff
    enemies     = br.player.enemies
    energy      = br.player.power.energy()
    module      = br.player.module
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    spell       = br.player.spell

    units.get(5)

    profileStop = profileStop or false
    if ui.pause() or ui.mode.rotation == 4 then return true end

    if actionList.Extra() then return true end
    if actionList.Defensive() then return true end
    if actionList.Interrupts() then return true end
    if actionList.Rotation() then return true end

    return true
end

local id = 283
local expansion = br.isTBC
if br.loader.rotations[id] == nil then br.loader.rotations[id] = {} end
br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

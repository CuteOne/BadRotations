local rotationName = "Panglo"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.spinningCraneKick },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.effuse}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.invokeXuenTheWhiteTiger },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.invokeXuenTheWhiteTiger },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.invokeXuenTheWhiteTiger }
    };
    CreateButton("Cooldown",2,0)
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
            br.ui:createSpinnerWithout(section,"Energy Cap",  60,  0,  100,  5)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    if br.timer:useTimer("debugWindwalker", math.random(0.15,0.3)) then

    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)

    local buff              = br.player.buff
    local cast              = br.player.cast
    local cd                = br.player.cd
    local charges           = br.player.charges
    local chi               = br.player.power.chi.amount()
    local chiDeficit        = br.player.power.chi.deficit()
    local chiMax            = br.player.power.chi.max()
    local combatTime        = getCombatTime()
    local debuff            = br.player.debuff
    local enemies           = br.player.enemies
    local energy            = br.player.power.energy.amount()
    local equiped           = br.player.equiped
    local gcd               = br.player.gcdMax
    local healthPot         = getHealthPot() or 0
    local inCombat          = br.player.inCombat
    local inRaid            = select(2,IsInInstance())=="raid"
    local mode              = br.player.mode
    local moving            = GetUnitSpeed("player")>0
    local php               = br.player.health
    local power             = br.player.power.energy.amount()
    local powerMax          = br.player.power.energy.max()
    local pullTimer         = br.DBM:getPulltimer()
    local race              = br.player.race
    local solo              = select(2,IsInInstance())=="none"
    local spell             = br.player.spell
    local talent            = br.player.talent
    local thp               = getHP("target")
    local traits            = br.player.traits
    local ttd               = getTTD
    local ttm               = br.player.power.energy.ttm()
    local units             = br.player.units
    local use               = br.player.use
    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end

    units.get(5)
    enemies.get(5)
    enemies.get(8)
    enemies.yards12r = getEnemiesInRect(10,12,false) or 0
    enemies.yards8c = getEnemiesInCone(45, 8,false, false) or 0

    local lowestMark = debuff.markOfTheCrane.lowest(5,"remain")

        --wipe timers table
        if timersTable then
            wipe(timersTable)
        end


    ---APL TIME---
    local function singleTarget()
        if cast.able.fistOfTheWhiteTiger() and chi < 3 and energy >= getValue("Energy Cap") and not cast.last.fistOfTheWhiteTiger() then
            if cast.fistOfTheWhiteTiger() then return end
        end
        Print("1")
        if cast.able.tigerPalm() and chi < 4 and energy >= getValue("Energy Cap") and not cast.last.tigerPalm() then
            if cast.tigerPalm() then return end
        end
        Print("2")
        if cd.risingSunKick.remain() > 0 and cd.fistsOfFury.remain() > 0 then
            if cast.whirlingDragonPunch() then return end
        end
        Print("3")
        if cast.able.fistsOfFury() then
            if cast.fistsOfFury() then return end
        end
        Print("4")
        if cast.able.risingSunKick() and chi >= 3 then
            if cast.risingSunKick() then return end
        end
        Print("5")
        if chi < chiMax then 
            if cast.chiBurst() then return end
        end
        Print("6")
        if chi < 3 then
            if cast.fistOfTheWhiteTiger() then return end
        end
        Print("7")
        if not cast.last.blackoutKick() and cd.fistsOfFury.exists() then
            if cast.blackoutKick() then return end
        end
        Print("8")
        if cast.chiWave() then return end
        if not cast.last.tigerPalm() and energy >= 45 then
                if cast.tigerPalm() then return end
        end
    end -- end single

    local function multiTarget()
        if cd.risingSunKick.remain() > 0 and cd.fistsOfFury.remain() > 0 then
            if cast.whirlingDragonPunch() then return end
        end
        Print("1Aoe")
        if cast.able.fistsOfFury() then
            if cast.fistsOfFury() then return end
        end
        Print("2Aoe")
        if cd.fistsOfFury.exists() then
            if cast.risingSunKick() then return end
        end
        Print("3Aoe")
        if cast.able.chiBurst() and chi < chiMax then 
            if cast.chiBurst() then return end
        end
        Print("4Aoe")
        if not cast.last.fistOfTheWhiteTiger() then
            if cast.fistOfTheWhiteTiger() then return end
        end
        Print("5Aoe")
        if #enemies.yards8 >= 2 then
            if cast.rushingJadeWind() then return end
        end
        Print("6Aoe")
        if #enemies.yards8 < 2 and buff.rushingJadeWind.exists() then
           if buff.rushingJadeWind.cancel() then return end
        end
        Print("7Aoe")
        if #enemies.yards8 >= 3 and br.player.debuff.markOfTheCrane.count() >= 3 and not cast.last.spinningCraneKick() and cd.fistsOfFury.exists() then 
            if cast.spinningCraneKick() then return end
        end
        Print("8Aoe")
        if not cast.last.blackoutKick() and cd.fistsOfFury.exists() then
            if cast.blackoutKick() then return end
        end
        Print("9Aoe")
        if not cast.last.risingSunKick() and not (cast.able.whirlingDragonPunch() or cast.able.fistsOfFury() or cast.able.chiBurst()) then
            if cast.risingSunKick() then return end
        end
        if cast.chiWave() then return end
        if not cast.last.tigerPalm() and energy >= 45 then
                if cast.tigerPalm() then return end
        end
    end--end multi

    local function coolies()
        if useCDs() then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if cast.able.touchOfDeath() and ttd(thisUnit) > 9 then
                    if cast.touchOfDeath(thisUnit) then return end 
                end
            end
            if chi < 2 and energy <20 then
                if cast.energizingElixir() then return end
            end
            if cast.last.energizingElixir() then
                if cast.tigerPalm() then return end
            end
            if charges.stormEarthAndFire.count() == 2 or cd.fistsOfFury.remain() <= 3 and not buff.stormEarthAndFire.exists() then
                if cast.stormEarthAndFire() then return end
            end
        end
    end--end coolies






            if inCombat and not isCastingSpell(spell.fistsOfFury) then
                if coolies() then return end
                if #enemies.yards8 >= 2 then
                    if multiTarget() then return end
                end
                if #enemies.yards8 < 2 then 
                    if singleTarget() then return end
                end
            end
        end 
end--end run

local id = 269
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})


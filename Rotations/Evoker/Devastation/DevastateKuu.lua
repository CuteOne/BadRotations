-------------------------------------------------------
-- Author = Kuukuu
-- Patch = 10.0
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 25%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Sporadic
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Development
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --
-------------------------------------------------------

local rotationName = "Devastated Kuu" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.furyOfTheAspects },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.pyre },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.disintegrate },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.emeraldBlossom}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.regrowth },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.regrowth }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Living Flame
            br.ui:createSpinner(section, "Living Flame",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
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
local cast
local cd
local comboPoints
local debuff
local enemies
local energy
local gcd
local module
local ui
local unit
local units
local spell
local talent
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
local profileStop
-- Profile Specific Locals - Any custom to profile locals
local actionList = {}
local fbMaxEnergy
local movingTimer

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
local function getEmpowerStage(unit)
    local stage = 0
    local _, _, _, startTime, _, _, _, _, _, totalStages = br._G.UnitChannelInfo(unit)
    if totalStages and totalStages > 0 then
        startTime = startTime / 1000 -- Doing this here so we don't divide by 1000 every loop index
        local currentTime = GetTime() -- If you really want to get time each loop, go for it. But the time difference will be miniscule for a single frame loop
        local stageDuration = 0
        for i = 1, totalStages do
            stageDuration = stageDuration + br._G.GetUnitEmpowerStageDuration(unit, i - 1) / 1000
            if startTime + stageDuration > currentTime then
                break -- Break early so we don't keep checking, we haven't hit this stage yet
            end
            stage = i
        end
    end
    return stage
end

-- Time Moving
local function timeMoving()
    if movingTimer == nil then movingTimer = br._G.GetTime() end
    if not unit.moving() then
        movingTimer = br._G.GetTime()
    end
    return br._G.GetTime() - movingTimer
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
   
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Living Flame
        if ui.checked("Living Flame") and cast.able.livingFlame() and not cast.current.livingFlame() and not unit.moving() then
            if unit.friend("target") and unit.hp("target") <= ui.value("Living Flame") and br._G.UnitIsPlayer("target") then
                if cast.livingFlame("target") then ui.debug("Casting Living Flame on "..unit.name("target")) return true end
            end
            if not unit.friend("target") and unit.hp() <= ui.value("Living Flame") then
                if cast.livingFlame("player") then ui.debug("Casting Living Flame on "..unit.name("player")) return true end
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() then
        if unit.valid("target") then
            local thisDistance = unit.distance("target") or 99
            if not unit.moving() and thisDistance <= 26 then
                if cast.able.livingFlame("target") and (not cast.last.livingFlame() or not unit.inCombat()) then
                    if cast.livingFlame("target") then ui.debug("Casting Living Flame [Pre-Pull]") return true end
                end
            end
            if thisDistance < 5 then
                -- Auto Attack
                if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) then
                    br._G.StartAttack(units.dyn5)
                end
            end
        end
    end
end -- End Action List - PreCombat

actionList.SingleTarget = function()
    if talent.dragonrage then
        if cast.dragonrage() then
            ui.debug("Casting Dragon Rage")
            return true
        end
    end
    if cd.fireBreath.remain() <= gcd and ((talent.dragonrage and cd.dragonrage.remain() > 10) or not talent.dragonrage) and not unit.moving() then
        if cast.fireBreath() then
            ui.debug("Casting Fire Breath")
            return true
        end
    end
    if cd.fireBreath.remain() > 0 or cd.dragonrage.remain() < 10 then
        if talent.shatteringStar and cd.shatteringStar.remain() <= gcd then
            if cast.shatteringStar() then
                ui.debug("Casting Shattering Star")
                return true
            end
        end
        if not talent.shatteringStar or cd.shatteringStar.remain() > 0 then
            if talent.eternitySurge and cd.dragonrage.remain() > 15 and br.getSpellCD(382411) <= gcd then
                if cast["eternitySurge"]() then
                    ui.debug("Casting Eternity Surge")
                    return true
                end
            end
            if not talent.eternitySurge or br.getSpellCD(382411) > 0 or cd.dragonrage.remain() < 10 then
                if (br.getEssence("player") >= 3 or buff.essenceBurst.exists("player")) and not unit.moving() then
                    if cast.disintegrate() then
                        ui.debug("Casting Disintegrate")
                        return true
                    end
                end
                if not unit.moving() then
                    if cast.livingFlame()  then
                        ui.debug("Casting Living Flame")
                        return true
                    end
                end
                if unit.moving() then 
                    if cast.azureStrike() then
                        ui.debug("Casting Azure Strike")
                        return true
                    end
                end
            end
        end
    end
end -- End Actionlist Single Target

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff                                        = br.player.buff
    cast                                        = br.player.cast
    cd                                          = br.player.cd
    comboPoints                                 = br.player.power.comboPoints.amount()
    debuff                                      = br.player.debuff
    enemies                                     = br.player.enemies
    energy                                      = br.player.power.energy.amount()
    gcd                                         = br.player.gcd
    module                                      = br.player.module
    ui                                          = br.player.ui
    unit                                        = br.player.unit
    units                                       = br.player.units
    spell                                       = br.player.spell
    talent                                      = br.player.talent
    -- General Locals
    profileStop                                 = profileStop or false
    haltProfile                                 = (unit.inCombat() and profileStop) or br.pause(true) or ui.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(25) -- Makes a variable called, units.dyn25
    units.get(40) -- Makes a variable called, units.dyn40
    -- Enemies
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    units.get(25) -- Makes a variable called, units.dyn25
    enemies.get(40) -- Makes a varaible called, enemies.yards40

    -- Profile Specific Locals
    if not unit.inCombat() and not unit.exists("target") then
        if profileStop then profileStop = false end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extra() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if unit.inCombat() and unit.valid("target") then
            local channel = UnitChannelInfo("player")
            if channel then
                if getEmpowerStage("player") >= 1 then
                    br._G.CastSpellByName(channel)
                end
            end
            -- ------------------------
            -- --- In Combat - Main ---
            -- ------------------------
            if cd.global.remain() == 0 and not channel then
                if unit.exists(units.dyn25) and unit.distance(units.dyn25) < 25 then
                   if actionList.SingleTarget() then return true end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
    return true
end -- End runRotation
local id = 1467 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
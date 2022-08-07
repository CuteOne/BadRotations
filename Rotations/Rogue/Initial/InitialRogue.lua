local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.sinisterStrike},
        [2] = { mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.sinisterStrike}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.crimsonVial},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.crimsonVial}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
    -- Interrupts Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Use Interrupt Abilities", highlight = 1, icon = br.player.spell.kick},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "Do Not Use Interrupt Abilities", highlight = 0, icon = br.player.spell.kick}
    };
    br.ui:createToggle(InterruptModes,"Interrupt",3,0)
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
            -- Eviscerate Execute
            br.ui:createDropdownWithout(section, "Eviscerate Execute",{"|cffFFFF00Enabled Notify","|cff00FF00Enabled","|cffFF0000Disabled"}, 2,"Options for using Eviscerate when the damage from it will kill the unit.")
            -- Sprint
            br.ui:createCheckbox(section, "Auto Sprint", "Will use sprint automatically.")
            -- Stealth
            br.ui:createCheckbox(section, "Always Stealth", "Will use stealth at all times.")
            -- Stealth Breaker
            br.ui:createDropdownWithout(section, "Stealth Breaker", {"|cff00FF00Ambush","|cffFFFF00Cheapshot","|cffFF0000Sinister Strike"}, 3, "|cffFFFFFFSet what to break Stealth with.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Crimson Vial
            br.ui:createSpinner(section, "Crimson Vial", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupt")
            -- Kick
            br.ui:createCheckbox(section, "Kick", "|cffFFFFFFUse Kick")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At (0 is random)")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  6)
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
local combo
local enemies
local energy
local mode
local ui
local spell
local unit
local units
-- General Locals
local haltProfile
local profileStop
local eviscerateDamage
local finishHim
-- Profile Specific Locals
local actionList = {}

-----------------
--- Functions ---
-----------------
-- Eviscerate Finish
local function eviscerateFinish(thisUnit)
    local GetSpellDescription = br._G["GetSpellDescription"]
    local desc = GetSpellDescription(spell.eviscerate)
    local damage = 0
    local finishHim = false
    if ui.value("Eviscerate Execute") ~= 3 and combo > 0 and not unit.isDummy(thisUnit) then
        local comboStart = desc:find(" "..combo.." ",1,true)
        if comboStart ~= nil then
            comboStart = comboStart + 2
            local damageList = desc:sub(comboStart,desc:len())
            comboStart = damageList:find(": ",1,true)+2
            damageList = damageList:sub(comboStart,desc:len())
            local comboEnd = damageList:find(" ",1,true)-1
            damageList = damageList:sub(1,comboEnd)
            damage = damageList:gsub(",","")
        end
        eviscerateDamage = tonumber(damage)
        finishHim = tonumber(damage) >= unit.health(thisUnit) and unit.health(thisUnit) > 0
    end
    return finishHim
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
actionList.Extras = function()
    -- Instant Poison
    if cast.able.instantPoison() and not buff.instantPoison.exists() then
        if cast.instantPoison() then ui.debug("Casting Instant Poison") return true end
    end
    -- Stealth
    if ui.checked("Always Stealth") and cast.able.stealth() and not unit.casting() and cast.timeSinceLast.stealth() > unit.gcd(true) then
        if cast.stealth() then ui.debug("Casting Stealth") return true end
    end
    -- Sprint
    if ui.checked("Auto Sprint") and cast.able.sprint() then
        if cast.sprint() then ui.debug("Casting Sprint") return true end
    end
end
-- Action List - Defensive
actionList.Defensive = function()
    --Crimson Vial
    if unit.level() >= 8 and ui.checked("Crimson Vial") then
        if cast.able.crimsonVial() and unit.inCombat() and unit.hp() <= ui.value("Crimson Vial") then
            if cast.crimsonVial() then ui.debug("Casting Crimson Vial") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        -- Kick
        if ui.checked("Kick") then
            for i=1, #enemies.yards5f do
                local thisUnit = enemies.yards5f[i]
                if cast.able.kick(thisUnit) and unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.kick(thisUnit) then ui.debug("Casting Kick on "..unit.name(thisUnit)) return true end
                end
            end
        end
    end
end -- End Action List - Interrupt

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if unit.valid("target") then
        --Stealth
        if cast.able.stealth() and unit.level() >= 3 and unit.distance("target") <= 20 and not buff.stealth.exists() and cast.timeSinceLast.stealth() > unit.gcd(true) then
            if cast.stealth() then ui.debug("Casting Stealth [Pre-Combat]") return true end
        end
        if buff.stealth.exists() or unit.level() < 3 then
            --Ambush
            if ui.value("Stealth Breaker") == 1 and cast.able.ambush("target") and cast.timeSinceLast.ambush() > unit.gcd(true) then
                if cast.ambush("target") then ui.debug("Casting Ambush [Pre-Combat]") return true end
            end
            -- Cheap Shot
            if (ui.value("Stealth Breaker") == 2 or (ui.value("Stealth Breaker") == 1 and unit.level() < 7))
                and cast.able.cheapShot("target") and cast.timeSinceLast.cheapShot() > unit.gcd(true)
            then
                if cast.cheapShot("target") then ui.debug("Casting Cheap Shot [Pre-Combat]") return true end
            end
            -- Sinister Strike
            if ui.value("Stealth Breaker") == 3 and cast.able.sinisterStrike("target")
                and (combo < 5 or unit.level() < 2) and cast.timeSinceLast.sinisterStrike() > unit.gcd(true)
            then
                if cast.sinisterStrike("target") then ui.debug("Casting Sinister Strike [Pre-Combat]") return true end
            end
        end
        -- Start Attack
        if cast.able.autoAttack("target") and energy < 45 then
            if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
        end
    end
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    combo                                         = br.player.power.comboPoints.amount()
    enemies                                       = br.player.enemies
    energy                                        = br.player.power.energy.amount()
    mode                                          = br.player.ui.mode
    ui                                            = br.player.ui
    spell                                         = br.player.spell
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    -- General Locals
    profileStop                                   = profileStop or false
    haltProfile                                   = (unit.inCombat() and profileStop) or unit.mounted() or br.pause() or mode.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40,true)
    -- Enemies
    enemies.get(5,"player",false,true) -- makes enemies.yards5f

    if eviscerateDamage == nil then eviscerateDamage = 0 end
    finishHim = eviscerateFinish(units.dyn5)

    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = ui.time() end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        br.pauseTime = ui.time()
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        if actionList.Extras() then return true end
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
        -- Check for combat
        if unit.inCombat() and not profileStop and unit.exists(units.dyn5) then
            if ui.value("Eviscerate Execute") == 1 then
                ui.chatOverlay("Eviscerate Damage: "..eviscerateDamage..", Unit HP: "..unit.health(units.dyn5))
            end
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupt() then return true end
            -- Start Attack
            if cast.able.autoAttack(units.dyn5) then
                if cast.autoAttack(units.dyn5) then ui.debug("Casting Auto Attack") return true end
            end
            -- Eviscerate Finish
            if cast.able.eviscerate() and (combo >= 5 or finishHim) then
                if finishHim then
                    if cast.eviscerate() then ui.debug("Casting Eviscerate [Finish]") return true end
                else
                    if cast.eviscerate() then ui.debug("Casting Eviscerate") return true end
                end
            end
            --Ambush
            if cast.able.ambush() and buff.stealth.exists() then
                if cast.ambush() then ui.debug("Casting Ambush") return true end
            end
            --Slice and Dice
            if cast.able.sliceAndDice() and unit.level() >= 9 and combo > 4 and not buff.sliceAndDice.exists() then
                if cast.sliceAndDice() then ui.debug("Casting Slice and Dice") return true end
            end
            --Eviscerate
            if cast.able.eviscerate() and (combo > 4 or unit.hp(units.dyn5) < 20) and unit.level() >= 2 then
                if cast.eviscerate() then ui.debug("Casting Eviscerate") return true end
            end
            -- Sinister Strike
            if cast.able.sinisterStrike() then
                if cast.sinisterStrike() then ui.debug("Casting Sinister Strike") return true end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 1453 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
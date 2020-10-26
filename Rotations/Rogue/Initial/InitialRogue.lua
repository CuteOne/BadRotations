local rotationName = "Overlord"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.sinisterStrike},
        [2] = { mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.sinisterStrike}
    };
    CreateButton("Rotation",1,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.crimsonVial},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.crimsonVial}
    };
    CreateButton("Defensive",2,0)
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
        br.ui:createCheckbox(section, "Auto Sprint", "Will use sprint automatically.")
        br.ui:createCheckbox(section, "Always Stealth", "Will use stealth at all times.")
        br.ui:createCheckbox(section, "Use Eviscerate", "Will use Eviscerate.")
        br.ui:createCheckbox(section, "Use Slice and Dice", "Will use Slice and Dice.")

        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Crimson Vial", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")

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
local comboPoints
local debuff
local has
local mode
local ui
local pet
local spell
local unit
local units
local use
-- General Locals
local haltProfile
local profileStop
-- Profile Specific Locals
local actionList = {}

--------------------
--- Action Lists ---
--------------------
-- Action List - Defensive
actionList.Defensive = function()
    --Crimson Vial
    if unit.level() >= 8 and ui.checked("Crimson Vial") then
        if cast.able.crimsonVial() and unit.inCombat() and unit.hp() <= ui.value("Crimson Vial") then
            if cast.crimsonVial() then ui.debug("Casting Crimson Vial") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()

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
    cd                                            = br.player.cd
    combo                                         = br.player.power.comboPoints.amount()
    debuff                                        = br.player.debuff
    energy                                        = br.player.power.energy.amount()
    has                                           = br.player.has
    mode                                          = br.player.ui.mode
    ui                                            = br.player.ui
    pet                                           = br.player.pet
    spell                                         = br.player.spell
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    -- General Locals
    profileStop                                   = profileStop or false
    haltProfile                                   = (unit.inCombat() and profileStop) or IsMounted() or pause() or mode.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40,true)

    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = GetTime() end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        br.pauseTime = GetTime()
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        --Instant Poison
        if spell.known.instantPoison() and not buff.instantPoison.exists() then
            if cast.instantPoison() then ui.debug("Casting Instant Poison") return true end
        end
        --Auto Sprint
        if unit.level() >= 6 and ui.checked("Auto Sprint") then
            if br.player.moving and not unit.inCombat() then
                if cast.sprint() then ui.debug("Casting Sprint") return true end
            end
        end
        --Always Stealth
        if unit.level() >= 3 and ui.checked("Always Stealth") then
            if not unit.inCombat() and not buff.stealth.exists("player") then
                if cast.stealth () then ui.debug("Casting Stealth") return true end
            end
        end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
            --Stealth
            if unit.level() >= 3 and not unit.inCombat() and unit.valid("target") and cast.able.stealth() and getDistance("player", "target") <= 20 and not buff.stealth.exists("player") then
                if cast.stealth() then ui.debug("Casting Stealth") return true end
            end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        -- Check for combat
        if unit.valid("target") and cd.global.remain() == 0 then
            if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                ------------------------------
                --- In Combat - Interrupts ---
                ------------------------------
                -- Start Attack
                -- actions=auto_attack
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    StartAttack(units.dyn5)
                end
                --Ambush
                if buff.stealth.exists() and unit.exists("target") and unit.distance("target") < 5 then
                    if CastSpellByID(8676) then ui.debug("Casting Ambush") return true end
                end
                --Eviscerate
                if unit.level() >= 2 and ui.checked("Use Eviscerate") then
                    if combo > 4 or unit.hp("target") < 20 then
                        if spell.known.eviscerate() and cast.able.eviscerate and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                            if cast.eviscerate("target") then ui.debug("Casting Eviscerate") return true end
                        end
                    end
                end
                --Slice and Dice
                if unit.level() >= 9 and ui.checked("Use Slice and Dice") then
                    if combo > 4 or unit.hp("target") < 20 then
                        if spell.known.sliceAndDice() and cast.able.eviscerate and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                            if cast.sliceAndDice("target") then ui.debug("Casting Slice and Dice") return true end
                        end
                    end
                end
                -- Sinister Strike
                if spell.known.sinisterStrike() and cast.able.sinisterStrike and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    if cast.sinisterStrike() then ui.debug("Casting Sinister Strike") return true end
                end
                --Kick Interrupt
                if canInterrupt() then
                    if spell.known.kick() and cast.able.kick() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                        if cast.kick() then ui.debug("Casting Kick") return true end
                    end
                end
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 1453 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
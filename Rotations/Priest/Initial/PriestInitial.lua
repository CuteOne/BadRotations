local rotationName = "Overlord"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.smite },
        [2] = {  mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.smite }
    };
    CreateButton("Rotation",1,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.powerWordShield},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.powerWordShield}
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

        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            br.ui:createSpinner(section, "Flash Heal", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Pyschic Scream", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Desperate Prayer", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Fade", 25, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

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
-- BR API Locals
local cast
local cd
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
--Flash Heal
    if unit.level() >= 2 and ui.checked("Flash Heal") then
        if cast.able.flashHeal() and unit.inCombat() and unit.hp() <= ui.value("Flash Heal") then
            if cast.flashHeal() then ui.debug("Casting Flash Heal") return true end
        end
    end
    --Pyschic Scream
    if unit.level() >= 7 and ui.checked("Pyschic Scream") then
        if cast.able.pyschicScream() and unit.inCombat() and unit.hp() <= ui.value("Pyschic Scream") then
            if cast.pyschicScream() then ui.debug("Casting Pyschic Scream") return true end
        end
    end
    --Desperate Prayer
    if unit.level() >= 8 and ui.checked("Flash Heal") then
        if cast.able.desperatePrayer() and unit.inCombat() and unit.hp() <= ui.value("Desperate Prayer") then
            if cast.desperatePrayer() then ui.debug("Casting Desperate Prayer") return true end
        end
    end
    --Fade
    if unit.level() >= 9 and ui.checked("Fade") then
        if cast.able.fade() and unit.inCombat() and unit.hp() <= ui.value("Fade") then
            if cast.fade() then ui.debug("Casting Flash Heal") return true end
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
    debuff                                        = br.player.debuff
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
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
            --Power Word Fortitude
            if unit.level() >= 6 and cast.able.powerWordFortitude() and not buff.powerWordFortitude.exists("player") then
                if cast.powerWordFortitude() then ui.debug("Casting Power Word Fortitude") return true end
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
                --Power Word:Shield
                if cast.able.powerWordShield("player") and not buff.powerWordShield.exists(thisUnit) and unit.inCombat() then
                    if cast.powerWordShield("player") then ui.debug("Casting Power Word:Shield") return true end
                end
                --Shadow Word:Pain
                if unit.level() >= 2 and cast.able.shadowWordPain() and debuff.shadowWordPain.refresh(units.dyn40) then
                    if cast.shadowWordPain() then br.addonDebug("Casting Shadow Word:Pain") return true end
                end
                --Mind Blast
                if unit.level() >= 5 and cast.able.mindBlast() and not unit.moving() then
                    if cast.mindBlast() then ui.debug ("Casting Mind Blast") return true end
                end
                --Smite
                if cast.able.smite() and not unit.moving() then
                    if cast.smite() then br.addonDebug("Casting Smite") return true end
                end
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 1452 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
}) 
local rotationName = "Overlord"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.victoryRush },
        [2] = { mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.victoryRush}
    };
    CreateButton("Rotation",1,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.shieldBlock},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.shieldBlock}
    };
    CreateButton("Defensive",2,0)
    -- Movement Button
    MoverModes = {
        [1] = { mode = "On", value = 1, overlay = "Mover Enabled", tip = "Will use Charge.", tip = "Will use Charge.", highlight = 1, icon = br.player.spell.charge},
        [2] = { mode = "Off", value = 2, overlay = "Mover Disabled", overlay = "Mover Disabled", tip = "Will NOT use Charge.", highlight = 0, icon = br.player.spell.charge}
    };
    CreateButton("Mover", 3, 0)
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
    --Shield Block
    if unit.hp() < 70 then
        if spell.known.shieldBlock() and cast.able.shieldBlock and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            if cast.shieldBlock() then ui.debug("Casting Shield Block") return true end
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
                if mode.mover == 1 and spell.known.charge() then
                    if cast.able.charge("target") and getDistance("player", "target") >= 8 and getDistance("player", "target") <= 25 then
                        if cast.charge("target") then ui.debug("Casting Charge") return true end
                    end
                end
                -- actions=auto_attack
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    StartAttack(units.dyn5)
                end
                -- Execute
                if unit.hp("target") < 20 and spell.known.execute() and cast.able.execute and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    if cast.execute() then ui.debug("Casting Execute") return true end
                end
                -- Victory Rush
                if spell.known.victoryRush() and cast.able.victoryRush and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    if cast.victoryRush() then ui.debug("Casting Victory Rush") return true end
                end
                -- Shield Slam
                if spell.known.shieldSlam() and cast.able.shieldSlam and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    if cast.shieldSlam() then ui.debug("Casting Shield Slam") return true end
                end
                -- WhirlWind            
                if spell.known.whirlwind() and cast.able.whirlwind() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    if cast.whirlwind() then ui.debug("Casting Whirlwind") return true end
                end
                -- Slam
                if spell.known.slam() and cast.able.slam() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    if cast.slam() then ui.debug("Casting Slam") return true end
                end
                --Pummel Interrupt
                if canInterrupt() then
                    if spell.known.pummel() and cast.able.pummel() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                        if cast.pummel() then ui.debug("Casting Pummel") return true end
                    end
                end
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 1446 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
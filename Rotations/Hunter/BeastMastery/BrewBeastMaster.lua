-------------------------------------------------------
-- Author = BrewingCoder
-- Patch = 10.2.6
-- Coverage = 75%
-- Status = Limited
-- Readiness = Development
-------------------------------------------------------
local rotationName = "BrewBeastMaster" -- Change to name of profile listed in options drop down
br.loadSupport("PetCuteOne")

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1, overlay = "Rotation Enabled", tip = "Enables Rotation", highlight = 1, icon = br.player.spells.steadyShot },
        [2] = { mode = "Off", value = 2, overlay = "Rotation Disabled", tip = "Disables Rotation", highlight = 0, icon = br.player.spells.steadyShot }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Enables Defensive", highlight = 1, icon = br.player.spells.exhilaration },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "Disables Defensive", highlight = 0, icon = br.player.spells.exhilaration }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupt Enabled", tip = "Enables Interrupt", highlight = 1, icon = br.player.spells.freezingTrap },
        [2] = { mode = "Off", value = 2, overlay = "Interrupt Disabled", tip = "Disables Interrupt", highlight = 0, icon = br.player.spells.freezingTrap }
    };
    br.ui:createToggle(InterruptModes, "Interrupt", 3, 0)
    -- Pet summon
    local PetSummonModes = {
        [1] = { mode = "1", value = 1, overlay = "Summon Pet 1", tip = "Summon Pet 1", highlight = 1, icon = br.player.spells.callPet1 },
        [2] = { mode = "2", value = 2, overlay = "Summon Pet 2", tip = "Summon Pet 2", highlight = 1, icon = br.player.spells.callPet2 },
        [3] = { mode = "3", value = 3, overlay = "Summon Pet 3", tip = "Summon Pet 3", highlight = 1, icon = br.player.spells.callPet3 },
        [4] = { mode = "4", value = 4, overlay = "Summon Pet 4", tip = "Summon Pet 4", highlight = 1, icon = br.player.spells.callPet4 },
        [5] = { mode = "5", value = 5, overlay = "Summon Pet 5", tip = "Summon Pet 5", highlight = 1, icon = br.player.spells.callPet5 },
        [6] = { mode = "None", value = 6, overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spells.callPet }
    };
    br.ui:createToggle(PetSummonModes, "PetSummon", 4, 0)
end


---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")

        br.ui:checkSectionState(section)

        br.rotations.support["PetCuteOne"].options()
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")

        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")

        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle, 4)
        --Cooldown Key Toggle
        br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle, 3)
        --Defensive Key Toggle
        br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle, 6)
        -- Interrupts Key Toggle
        br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
        -- Pause Toggle
        br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
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

-- Any variables/functions made should have a local here to prevent possible conflicts with other things.


-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------

local actionList = {}
actionList.Extra = function()
end
actionList.Defensive = function()
end
actionList.Interrupt = function()
end
actionList.Cooldown = function()
end
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
        if unit.valid("target") then
            -- Start Attack
            if unit.distance("target") <= 40 then
                br._G.PetAttack("target")
                if not br._G.C_Spell.IsAutoRepeatSpell(br._G.GetSpellInfo(75)) and unit.exists("target") then
                    br._G.StartAttack("target")
                end
            end
        end
    end
end

----------------
--- ROTATION ---
----------------
local function runRotation() -- This is the main profile loop, any below this point is ran every cycle, everything above is ran only once during initialization.
    if math.random() > 0.80 then return false end;

    if actionList.PetManagement == nil then
        actionList.PetManagement = br.rotations.support["PetCuteOne"].run
    end

    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals - These are the same as the locals above just defined for use.
    buff    = br.player.buff
    debuff  = br.player.debuff
    cast    = br.player.cast
    cd      = br.player.cd
    charges = br.player.charges
    enemies = br.player.enemies
    module  = br.player.module
    power   = br.player.power
    talent  = br.player.talent
    ui      = br.player.ui
    unit    = br.player.unit
    units   = br.player.units
    var     = br.player.variables

    units.get(5)                       -- Makes a variable called, units.dyn5
    units.get(40)                      -- Makes a variable called, units.dyn40
    enemies.get(5)                     -- Makes a varaible called, enemies.yards5
    enemies.get(40)                    -- Makes a varaible called, enemies.yards40
    enemies.get(5, "player", false, true) -- makes enemies.yards5f
    enemies.get(10, "player", false, true)
    enemies.get(20, "player", false, true)
    enemies.get(30, "player", false, true)
    enemies.get(40, "player", false, true)

    ------------------------
    --- Custom Variables ---
    ------------------------
    -- Any other local varaible from above would also need to be defined here to be use.
    if var.profileStop == nil then var.profileStop = false end -- Trigger variable to help when needing to stop a profile.



    --if actionList.PetManagement() then return true end
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then                                               -- Reset profile stop once stopped
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then -- If profile triggered to stop go here until it has.
        return true
    else
        if actionList.Extra() then return true end
        if actionList.Defensive() then return true end
        if actionList.PreCombat() then return true end
        if unit.inCombat() and unit.valid("target") and not var.profileStop then
            if actionList.Interrupt() then return true end

            if unit.valid("target") and cd.global.remain() == 0 then
                if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                    -----------------
                    --- Interrupt ---
                    -----------------
                    if actionList.Interrupt() then return true end
                    if not br._G.C_Spell.IsAutoRepeatSpell(br._G.GetSpellInfo(75)) and unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                        br._G.StartAttack(units.dyn40)
                    end

                    if #enemies.yards40f >= 3 then
                        if cast.able.multishot() then
                            if cast.multishot() then
                                ui.debug("Casting Multi-Shot")
                                return true
                            end
                        else
                            if cast.able.disengage() then
                                if cast.disengage() then
                                    ui.debug("Casting Disengage")
                                    return true
                                end
                            end
                        end
                    end

                    if cast.able.bestialWrath() and unit.ttd("target") >= 20 then
                        if cast.bestialWrath() then
                            ui.debug("Casting Bestial Wrath")
                            return true
                        end
                    end

                    if cast.able.huntersMark() and not debuff.huntersMark.exists(units.dyn40) then
                        if cast.huntersMark() then
                            ui.debug("Cast Hunter's Mark")
                            return true
                        end
                    end

                    if unit.hp("target") <= 20 and cast.able.killShot() then
                        if cast.killShot() then
                            ui.debug("Casting Kill Shot")
                            return true
                        end
                    end

                    if cast.able.killCommand("target") then
                        if cast.killCommand("target") then
                            ui.debug("Casting Kill Command")
                            return true
                        end
                    end

                    if not buff.barbedShot.exists() or charges.barbedShot.frac() > 1.0 then
                        if cast.able.barbedShot() then
                            if cast.barbedShot() then
                                ui.debug("Casting Barbed Shot")
                                return true
                            end
                        end
                    end

                    if cast.able.arcaneShot() then
                        if cast.arcaneShot() then
                            ui.debug("Casting Arcane Shot")
                            return true
                        end
                    end

                    if cast.able.cobraShot("target") then
                        if cast.cobraShot() then
                            ui.debug("Casting Cobra Shot")
                            return true
                        end
                    elseif cast.able.steadyShot() then
                        if cast.steadyShot() then
                            ui.debug("Casting Steady Shot")
                            return true
                        end
                    end
                end -- End In Combat Rotation
            end
        end         -- End In Combat Rotation
    end             -- Pause
end                 -- End runRotation
local id = 253      -- Change to the spec id profile is for. Spec ID can be found at: https://wowpedia.fandom.com/wiki/SpecializationID
-- DO NOT EDIT ANYTHING BELOW THIS LINE, WILL BREAK PROFILE --
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

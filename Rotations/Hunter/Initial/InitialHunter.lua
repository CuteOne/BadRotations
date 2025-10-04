local rotationName = "Initial"
br.loader.cBuilder:loadSupport("PetCuteOne")

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
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- Hunter's Mark
        br.ui:createCheckbox(section, "Hunter's Mark")
        -- Basic Trinkets Module
        br.player.module.BasicTrinkets(nil, section)
        br.ui:checkSectionState(section)
        -------------------
        --- PET OPTIONS ---
        -------------------
        br.loader.rotations.support["PetCuteOne"].options()
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Basic Healing Module
        br.player.module.BasicHealing(section)
        -- Aspect of the Turtle
        br.ui:createSpinner(section, "Aspect of the Turtle", 25, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Disengage
        br.ui:createCheckbox(section, "Disengage")
        -- Exhilaration
        br.ui:createSpinner(section, "Exhilaration", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Feign Death
        br.ui:createSpinner(section, "Feign Death", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Wing Clip
        br.ui:createCheckbox(section, "Wing Clip")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Freezing Trap
        br.ui:createCheckbox(section, "Freezing Trap")
        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.ui.dropOptions.Toggle, 4)
        --Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.ui.dropOptions.Toggle, 6)
        -- Interrupts Key Toggle
        br.ui:createDropdownWithout(section, "Interrupt Mode", br.ui.dropOptions.Toggle, 6)
        -- Pause Toggle
        br.ui:createDropdown(section, "Pause Mode", br.ui.dropOptions.Toggle, 6)
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
-- BR API Locals
local buff
local cast
local cd
local debuff
local enemies
local module
local ui
local unit
local units
-- Profile Specific Locals
local actionList = {}
local var = {}
var.getFacingDistance = br._G["getFacingDistance"]
var.getItemInfo = br._G["GetItemInfo"]
var.haltProfile = false
var.loadSupport = br._G["loadSupport"]
var.profileStop = false
var.specificToggle = br._G["SpecificToggle"]

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Hunter's Mark
    if ui.checked("Hunter's Mark") and cast.able.huntersMark("target") and not debuff.huntersMark.exists("target")
        and not unit.friend("target") and unit.hp("target") > 80
    then
        if cast.huntersMark("target") then
            ui.debug("Cast Hunter's Mark")
            return true
        end
    end
end -- End Action List- Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Aspect of the Turtle
        if ui.checked("Aspect of the Turtle") and cast.able.aspectOfTheTurtle()
            and unit.inCombat() and unit.hp() < ui.value("Apect of the Turtle")
        then
            if cast.aspectOfTheTurtle() then
                ui.debug("Casting Aspect of the Turtle")
                return true
            end
        end
        -- Exhilaration
        if ui.checked("Exhilaration") and cast.able.exhilaration() and unit.hp() < ui.value("Exhilaration") then
            if cast.exhilaration() then
                ui.debug("Casting Exhilaration")
                return true
            end
        end
        -- Feign Death
        if ui.checked("Feign Death") and cast.able.feignDeath()
            and unit.inCombat() and unit.hp() < ui.value("Feign Death")
        then
            if cast.feignDeath() then
                ui.debug("Casting Feign Death - Shh! Maybe they won't notice.")
                return true
            end
        end
        -- Wing Clip
        if ui.checked("Wing Clip") and cast.able.wingClip() and unit.exists(units.dyn5)
            and unit.ttd(units.dyn5) > 2 and unit.distance(units.dyn5) < 5 then
            if cast.wingClip() then
                ui.debug("Casting Wing Clip")
                return true
            end
        end
        -- Disengage
        if ui.checked("Disengage") and cast.able.disengage("player") and unit.exists(units.dyn5)
            and unit.ttd(units.dyn5) > 2 and unit.distance(units.dyn5) < 5 then
            if cast.disengage("player") then
                ui.debug("Casting Disengage")
                return true
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if br.functions.spell:canInterrupt(thisUnit, ui.value("Interrupt At")) then
                -- Freezing Trap
                if ui.hecked("Freezing Trap") and cast.able.freezingTrap() then
                    for j = 1, #enemies.yards40 do
                        thisUnit = enemies.yards40[j]
                        if unit.distance(thisUnit) > 8 and cast.timeRemain(thisUnit) > 3 then
                            if cast.freezingTrap(thisUnit, "ground") then return true end
                        end
                    end
                end
            end
        end
    end -- End Interrupt Check
end     -- End Action List - Interrupt

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Steady Shot
            if cast.able.steadyShot("target") then
                if cast.steadyShot("target") then
                    ui.debug("Casting Steady Shot [Precombat]")
                    return true
                end
            end
            -- Arcane Shot
            if cast.able.arcaneShot("target") then
                if cast.arcaneShot("target") then
                    ui.debug("Casting Arcane Shot [Precombat]")
                    return true
                end
            end
            -- Start Attack
            if cast.able.autoShoot("target") then
                if cast.autoShoot("target") then
                    ui.debug("Casting Auto Attack [Precombat]")
                    return true
                end
            end
        end
    end
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------------------------------
    --- Load Additional Rotation Files ---
    --------------------------------------
    if actionList.PetManagement == nil then
        actionList.PetManagement = br.loader.rotations.support["PetCuteOne"].run
    end

    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff            = br.player.buff
    cast            = br.player.cast
    cd              = br.player.cd
    debuff          = br.player.debuff
    enemies         = br.player.enemies
    module          = br.player.module
    ui              = br.player.ui
    unit            = br.player.unit
    units           = br.player.units
    -- General Locals
    var.haltProfile = (unit.inCombat() and var.profileStop) or unit.mounted() or br.functions.misc:pause() or buff.feignDeath.exists() or
        ui.mode.rotation == 2
    -- Units
    units.get(5)
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(8)
    enemies.get(40)

    -----------------
    --- Pet Logic ---
    -----------------
    if actionList.PetManagement() then return true end
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
                -----------------
                --- Interrupt ---
                -----------------
                if actionList.Interrupt() then return true end
                ------------
                --- Main ---
                ------------
                -- Start Attack
                if cast.able.autoShoot("target") then
                    if cast.autoShoot("target") then
                        ui.debug("Casting Auto Attack")
                        return true
                    end
                end
                -- Basic Trinkets Module
                module.BasicTrinkets()
                -- Arcane Shot
                if cast.able.arcaneShot() then
                    if cast.arcaneShot() then
                        ui.debug("Casting Arcane Shot")
                        return true
                    end
                end
                -- Steady Shot
                if cast.able.steadyShot() then
                    if cast.steadyShot() then
                        ui.debug("Casting Steady Shot")
                        return true
                    end
                end
            end -- End In Combat Rotation
        end
    end         -- Pause
end             -- End runRotation
local id = 1448
if br.loader.rotations[id] == nil then br.loader.rotations[id] = {} end
br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

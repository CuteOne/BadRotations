-- Editor types: the keys of Retail Hunter BeastMastery's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.Retail.Hunter.BeastMastery.buff]]
local cast = cast --[[@as BR.Retail.Hunter.BeastMastery.cast]]
local cd = cd --[[@as BR.Retail.Hunter.BeastMastery.cd]]
local charges = charges --[[@as BR.Retail.Hunter.BeastMastery.charges]]
local debuff = debuff --[[@as BR.Retail.Hunter.BeastMastery.debuff]]

local rotationName = "BrewBeastMaster" -- Change to name of profile listed in options drop down
local petSupport = loadSupport("PetCuteOne")

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "On", icon = "steadyShot", overlay = "Rotation Enabled", tip = "Enables Rotation" },
        { name = "Off", icon = "steadyShot", overlay = "Rotation Disabled", tip = "Disables Rotation" },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "exhilaration", overlay = "Defensive Enabled", tip = "Enables Defensive" },
        { name = "Off", icon = "exhilaration", overlay = "Defensive Disabled", tip = "Disables Defensive" },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "freezingTrap", overlay = "Interrupt Enabled", tip = "Enables Interrupt" },
        { name = "Off", icon = "freezingTrap", overlay = "Interrupt Disabled", tip = "Disables Interrupt" },
    } })
    ui.toggle("PetSummon", { modes = {
        { name = "1", icon = "callPet1", overlay = "Summon Pet 1", tip = "Summon Pet 1" },
        { name = "2", icon = "callPet2", overlay = "Summon Pet 2", tip = "Summon Pet 2", highlight = true },
        { name = "3", icon = "callPet3", overlay = "Summon Pet 3", tip = "Summon Pet 3", highlight = true },
        { name = "4", icon = "callPet4", overlay = "Summon Pet 4", tip = "Summon Pet 4", highlight = true },
        { name = "5", icon = "callPet5", overlay = "Summon Pet 5", tip = "Summon Pet 5", highlight = true },
        { name = "None", icon = "callPet", overlay = "No pet", tip = "Dont Summon any Pet" },
    } })
end


---------------
--- OPTIONS ---
---------------
local function options()
    local section
    -----------------------
    --- GENERAL OPTIONS --- -- Define General Options
    -----------------------
    section = ui.section("General")


    petSupport.options()
    ------------------------
    --- COOLDOWN OPTIONS --- -- Define Cooldown Options
    ------------------------
    section = ui.section("Cooldowns")

    -------------------------
    --- DEFENSIVE OPTIONS --- -- Define Defensive Options
    -------------------------
    section = ui.section("Defensive")

    -------------------------
    --- INTERRUPT OPTIONS --- -- Define Interrupt Options
    -------------------------
    section = ui.section("Interrupts")
    -- Interrupt Percentage
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, tip = "|cffFFBB00Cast Percentage to use at." })
end

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive

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
                pet.attack("target")
                if not cast.auto.autoShot() and unit.exists("target") then
                    unit.startAttack("target")
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
        actionList.PetManagement = petSupport.run
    end

    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals - These are the same as the locals above just defined for use.

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
                    if not cast.auto.autoShot() and unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                        unit.startAttack(units.dyn40)
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
registerRotation({
    name      = rotationName,
    specID    = 253,
    expansion = "Retail",
    author    = "BrewingCoder",
    patch     = "10.2.6",
    coverage  = "75%",
    status    = "Limited",
    readiness = "Development",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

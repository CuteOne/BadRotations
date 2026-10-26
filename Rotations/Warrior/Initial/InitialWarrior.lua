-- Editor types: the keys of MOP Warrior's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.MOP.Warrior.buff]]
local cast = cast --[[@as BR.MOP.Warrior.cast]]
local cd = cd --[[@as BR.MOP.Warrior.cd]]
local charges = charges --[[@as BR.MOP.Warrior.charges]]
local debuff = debuff --[[@as BR.MOP.Warrior.debuff]]
local equiped = equiped --[[@as BR.MOP.Warrior.equiped]]
local glyph = glyph --[[@as BR.MOP.Warrior.glyph]]
local has = has --[[@as BR.MOP.Warrior.has]]
local heroTree = heroTree --[[@as BR.MOP.Warrior.heroTree]]
local imbues = imbues --[[@as BR.MOP.Warrior.imbues]]
local spell = spell --[[@as BR.MOP.Warrior.spell]]
local talent = talent --[[@as BR.MOP.Warrior.talent]]
local totem = totem --[[@as BR.MOP.Warrior.totem]]
local use = use --[[@as BR.MOP.Warrior.use]]

local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { modes = {
        { name = "On", icon = "slam", overlay = "Rotation Enabled", tip = "Enable Rotation" },
        { name = "Off", icon = "victoryRush", overlay = "Rotation Disabled", tip = "Disable Rotation" },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "shieldBlock", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "shieldBlock", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "pummel", overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts." },
        { name = "Off", icon = "pummel", overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
    } })
    ui.toggle("Mover", { modes = {
        { name = "On", icon = "charge", overlay = "Mover Enabled", tip = "Will use Charge." },
        { name = "Off", icon = "charge", overlay = "Mover Disabled", tip = "Will NOT use Charge." },
    } })
end

---------------
--- OPTIONS ---
---------------
local function options()
    local section
    -----------------------
    --- GENERAL OPTIONS ---
    -----------------------
    section = ui.section("General")
    -- Basic Trinket Module
    -- module.BasicTrinkets(nil, section)
    -- Battle Shout
    -- br.ui:createCheckbox(section, "Battle Shout")
    -- Charge
    ui.checkbox(section, "Charge")
    -- Hamstring
    -- br.ui:createCheckbox(section, "Hamstring")
    -- Heroic Throw
    -- br.ui:createCheckbox(section, "Heroic Throw")
    -- Victory Rush
    ui.checkbox(section, "Victory Rush")
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = ui.section("Defensive")
    -- Basic Healing Module
    -- module.BasicHealing(section)
    -- Shield Block
    -- br.ui:createSpinner(section, "Shield Block", 30, 0, 100, 5, "|cffFFFFFFPet Health Percent to Cast At")
    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = ui.section("Interrupt")
    -- Pummel
    -- br.ui:createCheckbox(section, "Pummel", "|cffFFFFFFUse Pummel")
    -- Interrupt Percentage
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "Cast Percent to Cast At (0 is random)" })
end

--------------
--- Locals ---
--------------
-- BR API Locals
local mode
-- General Locals

-- Profile Specific Locals
local actionList = {}

--------------------
--- Action Lists ---
--------------------
-- Action List -Extras
actionList.Extras = function()
    -- -- Battle Shout
    -- if ui.checked("Battle Shout") then
    --     if cast.able.battleShout() and buff.battleShout.refresh() and not unit.resting() then
    --         if cast.battleShout() then
    --             ui.debug("Casting Battle Shout")
    --             return true
    --         end
    --     end
    -- end
    -- -- Hamstring
    -- if ui.checked("Hamstring") and cast.able.hamstring("target") and not unit.facing("target", "player") and unit.moving("target") then
    --     if cast.hamstring("target") then
    --         ui.debug("Casting Hamstring")
    --         return true
    --     end
    -- end
end -- End Action List -Extras

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        --Shield Block
        -- if ui.checked("Shield Block") and cast.able.shieldBlock() and unit.exists("target")
        --     and unit.distance("target") < 5 and unit.hp() < ui.value("Shield Block")
        -- then
        --     if cast.shieldBlock() then
        --         ui.debug("Casting Shield Block")
        --         return true
        --     end
        -- end
    end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        -- Pummel
        -- if ui.checked("Pummel") then
        --     for i = 1, #enemies.yards5f do
        --         local thisUnit = enemies.yards5f[i]
        --         if cast.able.pummel(thisUnit) and unit.interruptable(thisUnit, ui.value("Interrupt At")) then
        --             if cast.pummel(thisUnit) then
        --                 ui.debug("Casting Pummel on " .. unit.name(thisUnit))
        --                 return true
        --             end
        --         end
        --     end
        -- end
    end
end -- End Action List - Interrupt

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() and unit.valid("target") then
        -- Execute
        if unit.hp("target") < 20 and cast.able.execute() then
            if cast.execute("target") then
                ui.debug("Casting Execute [Precombat]")
                return true
            end
        end
        -- Victory Rush
        if ui.checked("Victory Rush") and cast.able.victoryRush("target") and buff.victorious.exists() then
            if cast.victoryRush("target") then
                ui.debug("Casting Victory Rush [Precombat]")
                return true
            end
        end
        -- Heroic Strike
        if cast.able.heroicStrike("target") then
            if cast.heroicStrike("target") then
                ui.debug("Casting Heroic Strike [Precombat]")
                return true
            end
        end
        -- -- Attack
        -- if cast.able.attack("target") then
        --     if cast.attack("target") then
        --         ui.debug("Casting Attack [Precombat]")
        --         return true
        --     end
        -- end
        -- Start Attack
        if cast.able.autoAttack("target") then
            if cast.autoAttack("target") then
                ui.debug("Casting Auto Attack [Precombat]")
                return true
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    if (unit.inCombat() or (not unit.inCombat() and unit.valid(units.dyn5))) and not var.profileStop
        and unit.exists(units.dyn5) and cd.global.remain() == 0
    then
        -- Charge
        if mode.mover == 1 and ui.checked("Charge") and cast.able.charge("target")
            and unit.distance("target") >= 8 and unit.distance("target") <= 25
        then
            if cast.charge("target") then
                ui.debug("Casting Charge")
                return true
            end
        end
        -- Interrupts
        if actionList.Interrupt() then return true end
        if unit.inCombat() then
            -- Basic Trinkets Module
            module.BasicTrinkets()
            -- Execute
            if unit.hp("target") < 20 and cast.able.execute("target") then
                if cast.execute() then
                    ui.debug("Casting Execute")
                    return true
                end
            end
            -- Victory Rush
            if ui.checked("Victory Rush") and cast.able.victoryRush("target") and buff.victorious.exists() then
                if cast.victoryRush("target") then
                    ui.debug("Casting Victory Rush")
                    return true
                end
            end
            -- Heroic Strike
            if cast.able.heroicStrike() then
                if cast.heroicStrike() then
                    ui.debug("Casting Heroic Strike")
                    return true
                end
            end
            -- Attack
            -- if cast.able.attack() then
            --     if cast.attack() then
            --         ui.debug("Casting Attack")
            --         return true
            --     end
            -- end
            -- Start Attack
            if not cast.auto.autoAttack(units.dyn5) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                if cast.autoAttack(units.dyn5) then
                    ui.debug("Casting Auto Attack")
                    return true
                end
            end
        end -- End In Combat Rotation
    end
end -- End Action List - Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    if not var.initialized then
        mode        = ui.mode
        -- General Locals
        var.profileStop = false

        var.initialized = true
    end
    -- haltProfile = (unit.inCombat() and profileStop) or unit.mounted() or ui.pause() or mode.rotation == 2
    -- Units
    units.get(5)  -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40, true)
    -- Enemies
    enemies.get(5, "player", false, true) -- Makes a variable called, enemies.yards5f

    if not unit.inCombat() then
        if var.profileStop then var.profileStop = false end
    end

    -- Pause Timer
    if var.pauseTime == nil then var.pauseTime = ui.time() end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- * Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() then
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        --------------
        --- Extras ---
        --------------
        if actionList.Extras() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        if ui.mode.rotation == 2 then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if actionList.Combat() then return true end
    end         -- Pause
end             -- End runRotation
registerRotation({
    name      = rotationName,
    specID    = 1446,
    expansion = "MOP",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

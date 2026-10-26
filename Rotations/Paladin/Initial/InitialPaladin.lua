-- Editor types: the keys of Retail Paladin's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.Retail.Paladin.buff]]
local cast = cast --[[@as BR.Retail.Paladin.cast]]
local cd = cd --[[@as BR.Retail.Paladin.cd]]
local charges = charges --[[@as BR.Retail.Paladin.charges]]
local debuff = debuff --[[@as BR.Retail.Paladin.debuff]]
local equiped = equiped --[[@as BR.Retail.Paladin.equiped]]
local glyph = glyph --[[@as BR.Retail.Paladin.glyph]]
local has = has --[[@as BR.Retail.Paladin.has]]
local heroTree = heroTree --[[@as BR.Retail.Paladin.heroTree]]
local imbues = imbues --[[@as BR.Retail.Paladin.imbues]]
local spell = spell --[[@as BR.Retail.Paladin.spell]]
local talent = talent --[[@as BR.Retail.Paladin.talent]]
local totem = totem --[[@as BR.Retail.Paladin.totem]]
local use = use --[[@as BR.Retail.Paladin.use]]

local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "On", icon = "crusaderStrike", overlay = "Rotation Enabled", tip = "Enables Rotation" },
        { name = "Off", icon = "crusaderStrike", overlay = "Rotation Disabled", tip = "Disables Rotation" },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "flashOfLight", overlay = "Defensive Enabled", tip = "Enables Defensive" },
        { name = "Off", icon = "flashOfLight", overlay = "Defensive Disabled", tip = "Disables Defensive" },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "hammerOfJustice", overlay = "Interrupt Enabled", tip = "Enables Interrupt" },
        { name = "Off", icon = "hammerOfJustice", overlay = "Interrupt Disabled", tip = "Disables Interrupt" },
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

    ------------------------
    --- COOLDOWN OPTIONS ---
    ------------------------
    section = ui.section("Cooldown")
    -- Trinkets
    module.BasicTrinkets(nil, section)
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = ui.section("Defensive")
    -- Basic Healing Module
    module.BasicHealing(section)
    -- Divine Shield
    ui.spinner(section, "Divine Shield", { value = 20, tip = "Health Percent to Cast At" })
    -- Flash of Light
    ui.spinner(section, "Flash of Light", { value = 50, tip = "Health Percent to Cast At" })
    -- Hammer of Justice
    ui.spinner(section, "Hammer of Justice - Defensive", { value = 30, tip = "Health Percent to Cast At" })
    -- Word of Glory
    ui.spinner(section, "Word of Glory", { value = 40, tip = "Health Percent to Cast At" })
    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = ui.section("Interrupts")
    -- Hammer of Justice
    ui.checkbox(section, "Hammer of Justice")
    -- Interrupt Percentage
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "|cffFFBB00Cast Percentage to use at." })
end

--------------
--- Locals ---
--------------
-- BR API Locals
-- Profile Specific Locals
local actionList     = {}
local var            = {}
var.haltProfile      = false
var.profileStop      = false

--------------------
--- Action Lists ---
--------------------

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Divine Shield
        if ui.checked("Divine Shield") and cast.able.divineShield() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if unit.inCombat(thisUnit) and not debuff.forbearance.exists(thisUnit) and unit.hp(thisUnit) <= ui.value("Divine Shield") then
                if cast.divineShield(thisUnit) then
                    ui.debug("Casting Divine Shield on " .. unit.name(thisUnit))
                    return true
                end
            end
        end
        -- Call Module- Basic Healing
        module.BasicHealing()
        -- Hammer of Justice
        if ui.checked("Hammer of Justice - Defensive") and cast.able.hammerOfJustice()
            and unit.inCombat() and unit.hp() < ui.value("Hammer of Justice - Defensive")
        then
            if cast.hammerOfJustice() then
                ui.debug("Casting Hammer of Justice [Defensive]")
                return true
            end
        end
        -- Word of Glory
        if ui.checked("Word of Glory") and cast.able.wordOfGlory() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if unit.inCombat(thisUnit) and unit.hp(thisUnit) <= ui.value("Word of Glory") then
                if cast.wordOfGlory(thisUnit) then
                    ui.debug("Casting Word of Glory on " .. unit.name(thisUnit))
                    return true
                end
            end
        end
        -- Flash of Light
        if ui.checked("Flash of Light") and cast.able.flashOfLight() and not unit.moving() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if (unit.inCombat() and unit.hp(thisUnit) <= ui.value("Flash of Light"))
                or (not unit.inCombat() and unit.hp() < 90)
            then
                if cast.flashOfLight(thisUnit) then
                    ui.debug("Casting Flash of Light on " .. unit.name(thisUnit))
                    return true
                end
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards10 do
            local thisUnit = enemies.yards10[i]
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                -- Hammer of Justice
                if ui.checked("Hammer of Justice") and cast.able.hammerOfJustice(thisUnit) then
                    if cast.hammerOfJustice(thisUnit) then
                        ui.debug("Casting Hammer of Justice [Interrupt]")
                        return true
                    end
                end
            end
        end
    end -- End Interrupt Check
end     -- End Action List - Interrupt

-- Action List - Cooldowns
actionList.Cooldowns = function()
    -- Trinket - Non-Specific
    if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
        module.BasicTrinkets()
    end
end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Judgment
            if cast.able.judgment("target") and unit.exists("target") and unit.distance("target") < 30 then
                if cast.judgment("target") then
                    ui.debug("Casting Judgment [Pull]")
                    return true
                end
            end
            -- Auto Attack
            if cast.able.autoAttack("target") and unit.exists("target") and unit.distance("target") < 5 then
                if cast.autoAttack("target") then
                    ui.debug("Casting Auto Attack [Precombat]")
                    return true
                end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat    = function()
    if unit.valid("target") and cd.global.remain() == 0 then
        if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            -- Auto Attack
            if cast.able.autoAttack(units.dyn5) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                if cast.autoAttack(units.dyn5) then
                    ui.debug("Casting Auto Attack")
                    return true
                end
            end
            -- Shield of the Righteous
            if cast.able.shieldOfTheRighteous() then
                if cast.shieldOfTheRighteous() then
                    ui.debug("Casting Shield of the Righteous")
                    return true
                end
            end
            -- Consecration
            if cast.able.consecration("player", "aoe", 3, 10) and not buff.consecration.exists() and #enemies.yards10 > 2 and not unit.moving() then
                if cast.consecration("player", "aoe", 3, 10) then
                    ui.debug("Casting Consecration")
                    return true
                end
            end
            -- Judgment
            if cast.able.judgment() then
                if cast.judgment() then
                    ui.debug("Casting Judgment")
                    return true
                end
            end
            -- Crusader Strike
            if cast.able.crusaderStrike() then
                if cast.crusaderStrike() then
                    ui.debug("Casting Crusader Strike")
                    return true
                end
            end
        end -- End In Combat Rotation
    end
end         -- End Action List - Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    -- Units
    units.get(5)
    -- Enemies
    enemies.get(10)
    -- General Locals
    var.haltProfile = (unit.inCombat() and var.profileStop) or unit.mounted() or ui.pause() or ui.mode.rotation == 2


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
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        -----------------
        --- Cooldowns ---
        -----------------
        if actionList.Cooldowns() then return true end
        if unit.inCombat() then
            -----------------
            --- Interrupt ---
            -----------------
            if actionList.Interrupt() then return true end
            --------------
            --- Combat ---
            --------------
            if actionList.Combat() then return true end
        end
    end -- Pause
end     -- End runRotation
registerRotation({
    name      = rotationName,
    specID    = 1451,
    expansion = "Retail",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

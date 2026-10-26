-- Editor types: the keys of Retail DeathKnight's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.Retail.DeathKnight.buff]]
local cast = cast --[[@as BR.Retail.DeathKnight.cast]]
local cd = cd --[[@as BR.Retail.DeathKnight.cd]]
local charges = charges --[[@as BR.Retail.DeathKnight.charges]]
local debuff = debuff --[[@as BR.Retail.DeathKnight.debuff]]
local equiped = equiped --[[@as BR.Retail.DeathKnight.equiped]]
local glyph = glyph --[[@as BR.Retail.DeathKnight.glyph]]
local has = has --[[@as BR.Retail.DeathKnight.has]]
local heroTree = heroTree --[[@as BR.Retail.DeathKnight.heroTree]]
local imbues = imbues --[[@as BR.Retail.DeathKnight.imbues]]
local spell = spell --[[@as BR.Retail.DeathKnight.spell]]
local talent = talent --[[@as BR.Retail.DeathKnight.talent]]
local totem = totem --[[@as BR.Retail.DeathKnight.totem]]
local use = use --[[@as BR.Retail.DeathKnight.use]]

local rotationName = "BrewDKFrost"

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "On", icon = "runeStrike", overlay = "Rotation Enabled", tip = "Enable Rotation" },
        { name = "Off", icon = "runeStrike", overlay = "Rotation Disabled", tip = "Disable Rotation" },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "deathStrike", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "deathStrike", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "mindFreeze", overlay = "Interrupt Enabled", tip = "Enabled Interrupt" },
        { name = "Off", icon = "mindFreeze", overlay = "Interrupt Disabled", tip = "Disable Interrupt" },
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
    -- Death Grip
    ui.checkbox(section, "Death Grip")
    -- Trinkets
    ui.checkbox(section, "Trinkets")
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = ui.section("Defensive")
    -- Basic Healing Module
    module.BasicHealing(section)
    -- Anti-Magic Shell
    ui.spinner(section, "Anti-Magic Shell", { value = 50, tip = "Health Percent to use at." })
    -- Death Strike
    ui.spinner(section, "Death Strike", { value = 50, tip = "Health Percent to Cast At" })
    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = ui.section("Interrupt")
    -- Death Grip
    ui.checkbox(section, "Death Grip - Int")
    -- Mind Freeze
    ui.checkbox(section, "Mind Freeze")
    -- "Interrupt At"
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "Cast Percent to Cast At (0 is random)" })
end

--------------
--- Locals ---
--------------
-- BR API Locals
local runes
local runicPower
-- Profile Specific Locals
local actionList = {}
local var = {}
var.haltProfile = false
var.profileStop = false

--------------------
--- Action Lists ---
--------------------
-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Anti-Magic Shell
        if ui.checked("Anti-Magic Shell") and cast.able.antiMagicShell() and unit.hp() < ui.value("Anti-Magic Shell") then
            if cast.antiMagicShell() then
                ui.debug("Casting Anti-Magic Shell")
                return true
            end
        end
        -- Death Strike
        if ui.checked("Death Strike") and cast.able.deathStrike() and unit.hp() < ui.value("Death Strike") then
            if cast.deathStrike() then
                ui.debug("Casting Death Strike")
                return true
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        -- Mind Freeze
        if ui.checked("Mind Freeze") and cast.able.mindFreeze() then
            for i = 1, #enemies.yards15 do
                local thisUnit = enemies.yards15[i]
                if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                    if cast.mindFreeze(thisUnit) then
                        ui.debug("Casting Mind Freeze")
                        return true
                    end
                end
            end
        end
        --Death Grip
        if ui.checked("Death Grip (Interrupt)") and cast.able.deathGrip() then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if unit.interruptable(thisUnit, ui.value("Interrupt At")) and unit.distance(thisUnit) > 8 then
                    if cast.deathGrip(thisUnit) then
                        ui.debug("Casting Death Grip [Int]")
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - Interrupts

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Death Grip
            if ui.checked("Death Grip") and cast.able.deathGrip("target") and not unit.isDummy("target")
                and unit.distance("target") > 8 and unit.distance("target") < 30
            then
                if cast.deathGrip("target") then
                    ui.debug("Casting Death Grip [Pull]")
                    return true
                end
            end
            -- Start Attack
            -- actions=auto_attack
            if not cast.auto.autoAttack() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                unit.startAttack(units.dyn5)
            end
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
    runes           = power.runes()
    runicPower      = power.runicPower()
    -- General Locals
    var.haltProfile = (unit.inCombat() and var.profileStop) or unit.mounted() or ui.pause() or ui.mode.rotation == 4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40)
    -- Enemies
    enemies.get(8)
    enemies.get(15)

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
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        -- Check for combat
        if unit.valid("target") and cd.global.remain() == 0 then
            if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                -----------------
                --- Interrupt ---
                -----------------
                if actionList.Interrupts() then return true end
                -- Start Attack

                -- actions=auto_attack
                if not cast.auto.autoAttack() and unit.distance("target") <= 5 then
                    unit.startAttack("target")
                end

                -- Death Grip
                if ui.checked("Death Grip") and cast.able.deathGrip("target") and not unit.isDummy("target")
                    and unit.distance("target") > 8 and unit.distance("target") < 30
                then
                    if cast.deathGrip("target") then
                        ui.debug("Casting Death Grip [Pull]")
                        return true
                    end
                end
                -- Trinkets
                for i = 13, 14 do
                    local opValue = ui.value("Trinkets")
                    local iValue = i - 12
                    if (opValue == iValue or opValue == 3) and use.able.slot(i) then
                        if use.able.slot(i) and unit.isBoss("target") then
                            use.slot(i)
                            ui.debug("Using Trinket in Slot " .. i)
                            return
                        end
                    end
                end

                -- Death and Decay
                -- if cast.able.deathAndDecay() and runes > 0 and #enemies.yards8 > 2 then
                --     if cast.deathAndDecay("best",nil,1,8) then ui.debug("Casting Death and Decay") return true end
                -- end
                if cast.able.deathAndDecay("playerGround") and not buff.deathAndDecay.exists() and #enemies.yards8 > 2 then
                    if cast.deathAndDecay("playerGround") then
                        ui.debug("Casting Death and Decay")
                        return true
                    end
                end

                -- Death Coil
                if cast.able.deathCoil() and runicPower > 40 and (runes == 0 or runicPower >= 80) and not spell.frostStrike.known() then
                    if cast.deathCoil() then
                        ui.debug("Casting Death Coil")
                        return true
                    end
                end

                if cast.able.frostStrike() and runicPower >= 30 then
                    if cast.frostStrike() then
                        ui.debug("Casting Frost Strike")
                        return true
                    end
                end

                -- if cast.able.deathStrike() and unit.hp() < 90 then
                --     if cast.deathStrike() then ui.debug("Casting Death Strike") return true end
                -- end

                -- Rune Strike / obliterate
                if cast.able.runeStrike() and runes > 0 and not spell.obliterate.known() then
                    if cast.runeStrike() then
                        ui.debug("Casting Rune Strike")
                        return true
                    end
                end
                if cast.able.obliterate() and runes > 0 then
                    if cast.obliterate() then
                        ui.debug("Casting Obliterate")
                        return true
                    end
                end
            end -- End In Combat Rotation
        end
    end         -- Pause
end             -- End runRotation
registerRotation({
    name      = rotationName,
    specID    = 0,
    expansion = "Retail",
    author    = "BrewingCoder",
    patch     = "10.2.6",
    coverage  = "0%",
    status    = "Development",
    readiness = "Development",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

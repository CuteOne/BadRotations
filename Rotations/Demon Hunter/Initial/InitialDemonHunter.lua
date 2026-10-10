local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function toggles()
    br.ui:toggle("Rotation", { key = "RightShift", modes = {
        { name = "On", icon = "chaosStrike", overlay = "Rotation Enabled", tip = "Enable Rotation" },
        { name = "Off", icon = "chaosStrike", overlay = "Rotation Disabled", tip = "Disable Rotation" },
    } })
    br.ui:toggle("Defensive", { modes = {
        { name = "On", icon = select(2, br._G.GetItemSpell(br.player.items.legionHealthstone)), overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = select(2, br._G.GetItemSpell(br.player.items.legionHealthstone)), overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    br.ui:toggle("Cooldown", { modes = {
        { name = "On", icon = "metamorphosis", overlay = "Cooldown Enabled", tip = "Includes Offensive Cooldowns." },
        { name = "Off", icon = "metamorphosis", overlay = "Cooldown Disabled", tip = "No Offensive Cooldowns Used." },
    } })
end

---------------
--- OPTIONS ---
---------------
local function options()
    local section
    local alwaysCdNever = { "|cff0000FFAlways", "|cffFFFFFFCD Only", "|cffFF0000Never" }
    -----------------------
    --- GENERAL OPTIONS ---
    -----------------------
    section = br.ui:section("General")
    -- Inquisitor's Menacing Eye
    br.ui:checkbox(section, "Inquisitor's Menacing Eye")
    -- Sigil of Flame
    br.ui:checkbox(section, "Sigil of Flame")
    -- Torment
    br.ui:checkbox(section, "Torment")
    ------------------------
    --- COOLDOWN OPTIONS ---
    ------------------------
    section = br.ui:section("Cooldowns")
    -- Basic Trinkets Module
    br.player.module.BasicTrinkets(nil, section)
    -- Fel Crystal Fragments
    br.ui:dropdown(section, "Fel Crystal Fragments", { choices = alwaysCdNever, value = 1, checkbox = false,
        tip = "|cffFFBB00When to use Fel Crystal Fragments." })
    -- Twisted Heard
    br.ui:dropdown(section, "Twisted Heart", { choices = alwaysCdNever, value = 1, checkbox = false,
        tip = "|cffFFBB00When to use Twisted Heart." })
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = br.ui:section("Defensive")
    -- Basic Healing Module
    br.player.module.BasicHealing(section)
end

--------------
--- Locals ---
--------------
-- BR API Locals
local buff
local cast
local cd
local enemies
local furyDeficit
local has
local module
local ui
local unit
local units
local use
-- Profile Specific Locals
local actionList = {}
local var = {}
var.haltProfile = false
var.profileStop = false

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
actionList.Extras = function()
    -- Inquisitor's Menacing Eye
    if ui.checked("Inquisitor's Menacing Eye") and not buff.gazeOfTheLegion.exists() and use.able.inquisitorsMenacingEye() then
        if use.inquisitorsMenacingEye() then
            ui.debug("Using Inquisitor's Menacing Eye")
            return true
        end
    end
end -- End Action list - Extras
-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
    end
end -- End Action List - Defensive

-- Action List - Cooldowns
actionList.Cooldowns = function()
    -- Basic Trinkets
    module.BasicTrinkets()
    -- Fel Crystal Fragments
    if ui.alwaysCdNever("Fel Crystal Fragments") and not buff.felCrystalInfusion.exists()
        and use.able.felCrystalFragments() and has.felCrystalFragments()
    then
        if use.felCrystalFragments() then
            ui.debug("Using Fel Crystal Fragments")
            return true
        end
    end
    -- Twisted Heart
    if ui.alwaysCdNever("Twisted Heart") and not buff.twistedHeart.exists()
        and use.able.twistedHeart() and has.twistedHeart()
    then
        if use.twistedHeart() then
            ui.debug("Using Twisted Heart")
            return true
        end
    end
end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not br._G.IsMounted() then
        if unit.valid("target") then
            -- Torment
            if cast.able.torment("target") and ui.checked("Torment") then
                if cast.torment("target") then
                    ui.debug("Casting Torment [Pre-Pull]")
                    return true
                end
            end
            -- Start Attack
            -- actions=auto_attack
            if cast.able.autoAttack() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                if cast.autoAttack() then
                    ui.debug("Casting Auto Attack [Precombat]")
                    return true
                end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    -- Check for combat
    if unit.valid("target") and cd.global.remain() == 0 then
        if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
            -- Start Attack
            -- actions=auto_attack
            if cast.able.autoAttack() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                if cast.autoAttack() then
                    ui.debug("Casting Auto Attack [Combat]")
                    return true
                end
            end
            -- Call Action List- Cooldowns
            if actionList.Cooldowns() then return true end
            -- Sigil of Flame
            if ui.checked("Sigil of Flame") and cast.able.sigilOfFlame("best", false, 1, 8) and #enemies.yards5 > 0 then
                if cast.sigilOfFlame("best", false, 1, 8) then
                    ui.debug("Casting Sigil of Flame [Combat]")
                    return true
                end
            end
            -- Chaos Strike
            if cast.able.chaosStrike() and furyDeficit < 30 then
                if cast.chaosStrike() then
                    ui.debug("Casting Chaos Strike")
                    return true
                end
            end
            -- Demon's Bite
            if cast.able.demonsBite() and furyDeficit >= 30 then
                if cast.demonsBite() then
                    ui.debug("Casting Demon's Bite")
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
    buff            = br.player.buff
    cast            = br.player.cast
    cd              = br.player.cd
    enemies         = br.player.enemies
    furyDeficit     = br.player.power.fury.deficit()
    has             = br.player.has
    module          = br.player.module
    ui              = br.player.ui
    unit            = br.player.unit
    units           = br.player.units
    use             = br.player.use
    -- General Locals
    var.haltProfile = (unit.inCombat() and var.profileStop) or br._G.IsMounted() or br.functions.misc:pause() or ui.mode.rotation == 2
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40)
    -- Enemies
    enemies.get(8)

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
        --------------
        --- Extras ---
        --------------
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
        if actionList.Combat() then return end
    end -- Pause
end     -- End runRotation
br.loader.registerRotation({
    name      = rotationName,
    specID    = 1456,
    expansion = "MOP",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

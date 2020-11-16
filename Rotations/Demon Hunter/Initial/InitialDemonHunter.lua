local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.chaosStrike },
        [2] = {  mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.chaosStrike }
    };
    CreateButton("Rotation",1,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = select(2,GetItemSpell(br.player.items.legionHealthstone))},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = select(2,GetItemSpell(br.player.items.legionHealthstone))}
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
            -- Fel Crystal Fragments
            br.ui:createCheckbox(section, "Fel Crystal Fragments")
            -- Inquisitor's Menacing Eye
            br.ui:createCheckbox(section, "Inquisitor's Menacing Eye")
            -- Torment
            br.ui:createCheckbox(section, "Torment")
            -- Trinkets
            br.ui:createCheckbox(section, "Trinkets")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
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
-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
    end
end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not IsMounted() then
        -- Fel Crystal Fragments
        if ui.checked("Fel Crystal Fragments") and not buff.felCrystalInfusion.exists() and use.able.felCrystalFragments() and has.felCrystalFragments() then
            if use.felCrystalFragments() then ui.debug("Using Fel Crystal Fragments") return true end
        end
        -- Inquisitor's Menacing Eye
        if ui.checked("Inquisitor's Menacing Eye") and not buff.gazeOfTheLegion.exists() and use.able.inquisitorsMenacingEye() then
            if use.inquisitorsMenacingEye() then ui.debug("Using Inquisitor's Menacing Eye") return true end
        end
        if unit.valid("target") then
            -- Torment
            if cast.able.torment("target") and ui.checked("Torment") then
                if cast.torment("target") then ui.debug("Casting Torment [Pre-Pull]") return true end
            end
            -- Start Attack
            -- actions=auto_attack
            if not IsAutoRepeatSpell(GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                StartAttack(units.dyn5)
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
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    enemies                                       = br.player.enemies
    furyDeficit                                   = br.player.power.fury.deficit()
    has                                           = br.player.has
    item                                          = br.player.items
    module                                        = br.player.module
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    -- General Locals
    var.haltProfile                                   = (unit.inCombat() and var.profileStop) or IsMounted() or pause() or ui.mode.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
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
                -- Start Attack
                -- actions=auto_attack
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    StartAttack(units.dyn5)
                end
                -- Trinkets
                for i = 13, 14 do
                    local opValue = ui.value("Trinkets")
                    local iValue = i - 12
                    if (opValue == iValue or opValue == 3) and use.able.slot(i) then
                        -- use_items,if=buff.metamorphosis.up
                        if use.able.slot(i) and unit.isBoss("target") then
                            use.slot(i)
                            ui.debug("Using Trinket in Slot "..i)
                            return
                        end
                    end
                end
                -- Immolation Aura
                if cast.able.immolationAura() and not unit.isExplosive("target") and #enemies.yards8 > 0 then
                    if cast.immolationAura("player","aoe",1,8) then ui.debug("Casting Immolation Aura") return true end
                end           
                -- Chaos Strike
                if cast.able.chaosStrike() and furyDeficit < 30 then
                    if cast.chaosStrike() then ui.debug("Casting Chaos Strike") return true end
                end
                -- Demon's Bite
                if cast.able.demonsBite() and furyDeficit >= 30 then
                    if cast.demonsBite() then ui.debug("Casting Demon's Bite") return true end
                end
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 1456
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
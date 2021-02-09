local br = _G["br"]
local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enables Rotation", highlight = 1, icon = br.player.spell.tigerPalm},
        [2] = { mode = "Off", value = 2 , overlay = "Rotation Disabled", tip = "Disables Rotation", highlight = 0, icon = br.player.spell.tigerPalm}
    };
    CreateButton("Rotation",1,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Enables Defensive", highlight = 1, icon = br.player.spell.vivify},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "Disables Defensive", highlight = 0, icon = br.player.spell.vivify}
    };
    CreateButton("Defensive",2,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupt Enabled", tip = "Enables Interrupt", highlight = 1, icon = br.player.spell.legSweep},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupt Disabled", tip = "Interrupt Defensive", highlight = 0, icon = br.player.spell.legSweep}
    };
    CreateButton("Interrupt",3,0)
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
            -- Crackling Jade lightning
            br.ui:createCheckbox(section, "Crackling Jade Lightning")
            br.ui:createSpinnerWithout(section, "Cancel CJL Range", 10, 5, 40, 5, "|cffFFFFFFCancels Crackling Jade Lightning below this range in yards.")
            -- Roll
            br.ui:createCheckbox(section, "Roll")
            -- Touch of Death
            br.ui:createCheckbox(section, "Touch of Death")
            -- Trinkets
            br.player.module.BasicTrinkets(nil,section)
            -- br.ui:createDropdownWithout(section,"Trinket 1", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Trinket 1.")
            -- br.ui:createDropdownWithout(section,"Trinket 2", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Trinket 2.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Expel Harm
            br.ui:createSpinner(section, "Expel Harm",  40,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Healthstone / Potion
            br.ui:createSpinner(section, "Healthstone/Potion", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Leg Sweep
            br.ui:createSpinner(section, "Leg Sweep - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Leg Sweep - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
            -- Vivify
            br.ui:createSpinner(section, "Vivify",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Target Heal Key
            br.ui:createDropdownWithout(section, "Target Heal Key", br.dropOptions.Toggle,  2)
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Leg Sweep
            br.ui:createCheckbox(section, "Leg Sweep")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
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
local enemies
local equiped
local module
local ui
local unit
local units
local use
-- Profile Specific Locals
local actionList = {}
local var = {}
var.getFacingDistance = _G["getFacingDistance"]
var.getItemInfo = _G["GetItemInfo"]
var.haltProfile = false
var.profileStop = false
var.specificToggle = _G["SpecificToggle"]

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Roll
    if ui.checked("Roll") and unit.moving() and unit.distance("target") > 10 and unit.valid("target")
        and var.getFacingDistance() < 5 and unit.facing("player","target",10)
    then
        if cast.roll() then ui.debug("Casting Roll") return true end
    end
end -- End Action List- Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Expel Harm
        if ui.checked("Expel Harm") and unit.hp() <= ui.value("Expel Harm") then
            if cast.expelHarm() then ui.debug("Casting Expel Harm") return true end
        end
        -- Leg Sweep
        if ui.checked("Leg Sweep - HP") and unit.hp() <= ui.value("Leg Sweep - HP") and unit.inCombat() and #enemies.yards5 > 0 then
            if cast.legSweep() then ui.debug("Casting Leg Sweep [HP]") return true end
        end
        if ui.checked("Leg Sweep - AoE") and #enemies.yards5 >= ui.value("Leg Sweep - AoE") then
            if cast.legSweep() then ui.debug("Casting Leg Sweep [AOE]") return true end
        end
        -- Vivify
        if ui.checked("Vivify") and cast.able.vivify() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if unit.hp(thisUnit) <= ui.value("Vivify") then
                if cast.vivify(thisUnit) then ui.debug("Casting Vivify on "..unit.name(thisUnit)) return true end
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        for i=1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if canInterrupt(thisUnit,ui.value("Interrupt At")) then
                -- Leg Sweep
                if ui.checked("Leg Sweep") and cast.able.legSweep(thisUnit) and unit.distance(thisUnit) < 5 then
                    if cast.legSweep(thisUnit) then ui.debug("Casting Leg Sweep [Interrupt]") return true end
                end
            end
        end
    end -- End Interrupt Check
end -- End Action List - Interrupt

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Touch of Death
            if cast.able.touchOfDeath("target") and unit.health("target") < unit.health("player") then
                if cast.touchOfDeath("target") then ui.debug("Casting Touch of Death - DIE! [Pull]") return true end
            end
            -- Crackling Jade Lightning
            if ui.checked("Crackling Jade Lightning") and not cast.current.cracklingJadeLightning()
                and not unit.moving() and unit.distance("target") > ui.value("Cancel CJL Range")
            then
                if cast.cracklingJadeLightning() then ui.debug("Casting Crackling Jade Lightning [Pull]") return true end
            end
            -- Start Attack
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
    cast                                            = br.player.cast
    cd                                              = br.player.cd
    enemies                                         = br.player.enemies
    equiped                                         = br.player.equiped
    module                                          = br.player.module
    ui                                              = br.player.ui
    unit                                            = br.player.unit
    units                                           = br.player.units
    use                                             = br.player.use
    -- General Locals
    var.getHealPot                                  = _G["getHealthPot"]()
    var.haltProfile                                 = (unit.inCombat() and var.profileStop) or unit.mounted() or pause() or ui.mode.rotation==4
    -- Units
    units.get(5)
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(8)

    -- Cancel Crackling Jade Lightning
    if cast.current.cracklingJadeLightning() and unit.distance("target") < ui.value("Cancel CJL Range") then
        if cast.cancel.cracklingJadeLightning() then ui.debug("Canceling Crackling Jade Lightning [Within "..ui.value("Cancel CJL Range").."yrds]") return true end
    end

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
                -- Crackling Jade Lightning
                if ui.checked("Crackling Jade Lightning") and not cast.current.cracklingJadeLightning()
                and not unit.moving() and unit.distance("target") > ui.value("Cancel CJL Range")
                then
                    if cast.cracklingJadeLightning() then ui.debug("Casting Crackling Jade Lightning [Pre-Pull]") return true end
                end                
                -- Start Attack
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    StartAttack(units.dyn5)
                end
                -- Trinket - Non-Specific
                if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5  then
                    module.BasicTrinkets()
                    -- local thisTrinket
                    -- for i = 13, 14 do
                    --     thisTrinket = i == 13 and "Trinket 1" or "Trinket 2"
                    --     local opValue = ui.value(thisTrinket)
                    --     if (opValue == 1 or (opValue == 2 and ui.useCDs())) and use.able.slot(i) 
                    --     and (not equiped.touchOfTheVoid(i) or (equiped.touchOfTheVoid(i) and (#enemies.yards8 > 2 or (ui.useCDs() and opValue ~= 3))))
                    --     then
                    --         use.slot(i)
                    --         ui.debug("Using Trinket in Slot "..i)
                    --         return
                    --     end
                    -- end
                end
                -- Touch of Death
                if cast.able.touchOfDeath("target") and unit.health("target") < unit.health("player") then
                    if cast.touchOfDeath("target") then ui.debug("Casting Touch of Death - DIE!") return true end
                end
                -- Blackout Kick
                if cast.able.blackoutKick() then
                    if cast.blackoutKick() then ui.debug("Casting Blackout Kick") return true end
                end
                -- Spinning Crane Kick
                if cast.able.spinningCraneKick() and #enemies.yards8 > 2 then
                    if cast.spinningCraneKick() then ui.debug("Casting Spinning Crane Kick") return true end
                end
                -- Tiger Palm
                if cast.able.tigerPalm() and #enemies.yards8 < 3 then
                    if cast.tigerPalm() then ui.debug("Casting Tiger Palm") return true end
                end
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 1450
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
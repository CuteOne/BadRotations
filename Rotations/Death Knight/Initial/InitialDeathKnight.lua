local br = _G["br"]
local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.runeStrike },
        [2] = {  mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.runeStrike }
    };
    CreateButton("Rotation",1,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.deathStrike },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.deathStrike }
    };
    CreateButton("Defensive",2,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupt Enabled", tip = "Enabled Interrupt", highlight = 1, icon = br.player.spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupt Disabled", tip = "Disable Interrupt", highlight = 0, icon = br.player.spell.mindFreeze }
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
            -- Death Grip
            br.ui:createCheckbox(section, "Death Grip")
            -- Trinkets
            br.ui:createCheckbox(section, "Trinkets")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Anti-Magic Shell
            br.ui:createSpinner(section, "Anti-Magic Shell", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Death Strike
            br.ui:createSpinner(section, "Death Strike", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupt")
            -- Death Grip
            br.ui:createCheckbox(section, "Death Grip - Int")
            -- Mind Freeze
            br.ui:createCheckbox(section, "Mind Freeze")
            -- "Interrupt At"
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At (0 is random)")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupt Key Toggle
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
local module
local runes
local runicPower
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
        -- Anti-Magic Shell
        if ui.checked("Anti-Magic Shell") and cast.able.antiMagicShell() and unit.hp() < ui.value("Anti-Magic Shell") then
            if cast.antiMagicShell() then ui.debug("Casting Anti-Magic Shell") return true end
        end
        -- Death Strike
        if ui.checked("Death Strike") and cast.able.deathStrike() and unit.hp() < ui.value("Death Strike") then
            if cast.deathStrike() then ui.debug("Casting Death Strike") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        -- Mind Freeze
        if ui.checked("Mind Freeze") and cast.able.mindFreeze() then
            for i=1, #enemies.yards15 do
                local thisUnit = enemies.yards15[i]
                if canInterrupt(thisUnit,ui.value("Interrupt At")) then
                    if cast.mindFreeze(thisUnit) then ui.debug("Casting Mind Freeze") return true end
                end
            end
        end
        --Death Grip
        if ui.checked("Death Grip (Interrupt)") and cast.able.deathGrip() then
            for i = 1,  #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if canInterrupt(thisUnit,ui.value("Interrupt At")) and unit.distance(thisUnit) > 8 then
                    if cast.deathGrip(thisUnit) then ui.debug("Casting Death Grip [Int]") return true end
                end
            end
        end
    end
end-- End Action List - Interrupts

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Death Grip
            if ui.checked("Death Grip") and cast.able.deathGrip("target") and not unit.isDummy("target")
                and unit.distance("target") > 8 and unit.distance("target") < 30
            then
                if cast.deathGrip("target") then ui.debug("Casting Death Grip [Pull]") return true end
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
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    enemies                                       = br.player.enemies
    module                                        = br.player.module
    runes                                         = br.player.power.runes.amount()
    runicPower                                    = br.player.power.runicPower.amount()
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    -- General Locals
    var.haltProfile                               = (unit.inCombat() and var.profileStop) or unit.mounted() or pause() or ui.mode.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
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
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    StartAttack(units.dyn5)
                end
                -- Death Grip
                if ui.checked("Death Grip") and cast.able.deathGrip("target") and not unit.isDummy("target")
                    and unit.distance("target") > 8 and unit.distance("target") < 30
                then
                    if cast.deathGrip("target") then ui.debug("Casting Death Grip [Pull]") return true end
                end
                -- Trinkets
                for i = 13, 14 do
                    local opValue = ui.value("Trinkets")
                    local iValue = i - 12
                    if (opValue == iValue or opValue == 3) and use.able.slot(i) then
                        if use.able.slot(i) and unit.isBoss("target") then
                            use.slot(i)
                            ui.debug("Using Trinket in Slot "..i)
                            return
                        end
                    end
                end
                -- Death and Decay
                if cast.able.deathAndDecay() and runes > 0 and #enemies.yards8 > 2 then
                    if cast.deathAndDecay("best",nil,1,8) then ui.debug("Casting Death and Decay") return true end
                end
                -- Death Coil
                if cast.able.deathCoil() and runicPower > 40 and (runes == 0 or runicPower >= 80) then
                    if cast.deathCoil() then ui.debug("Casting Death Coil") return true end
                end
                -- Rune Strike
                if cast.able.runeStrike() and runes > 0 then
                    if cast.runeStrike() then ui.debug("Casting Rune Strike") return true end
                end
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 1455
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
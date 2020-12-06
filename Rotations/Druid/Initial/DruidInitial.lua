local rotationName = "Initial Druid" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.wrath },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.moonfire },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.shred },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.regrowth}
    };
    CreateButton("Rotation",1,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.regrowth },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.regrowth }
    };
    CreateButton("Defensive",2,0)
    -- Form Button
    FormModes = {
        [1] = { mode = "Caster", value = 1 , overlay = "Caster Form", tip = "Will force and use Caster Form", highlight = 1, icon = br.player.spell.moonkinForm },
        [2] = { mode = "Cat", value = 2 , overlay = "Cat Form", tip = "Will force and use Cat Form", highlight = 0, icon = br.player.spell.catForm },
        [3] = { mode = "Bear", value = 3 , overlay = "Bear Form", tip = "Will force and use Bear Form", highlight = 0, icon = br.player.spell.bearForm }
    };
    CreateButton("Form",3,0)
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
            br.ui:createSpinnerWithout(section, "Shift Wait Time", 2, 0, 5, 1, "|cffFFFFFFTime in seconds the profile will wait while moving to shift. Combat is instant!")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Regrowth
            br.ui:createSpinner(section, "Regrowth",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
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
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local buff
local cast
local cd
local comboPoints
local debuff
local enemies
local energy
local module
local ui
local unit
local units
local spell
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
local profileStop
-- Profile Specific Locals - Any custom to profile locals
local actionList = {}
local fbMaxEnergy
local movingTimer

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
-- Ferocious Bite Finish
local function ferociousBiteFinish(thisUnit)
    local GetSpellDescription = _G["GetSpellDescription"]
    local desc = GetSpellDescription(spell.ferociousBite)
    local damage = 0
    local finishHim = false
    if thisUnit == nil then thisUnit = units.dyn5 end
    if comboPoints > 0 and not unit.isDummy(thisUnit) then
        local comboStart = desc:find(" "..comboPoints.." ",1,true)
        if comboStart ~= nil then
            comboStart = comboStart + 2
            local damageList = desc:sub(comboStart,desc:len())
            comboStart = damageList:find(": ",1,true)+2
            damageList = damageList:sub(comboStart,desc:len())
            local comboEnd = damageList:find(" ",1,true)-1
            damageList = damageList:sub(1,comboEnd)
            damage = damageList:gsub(",","")
        end
        finishHim = tonumber(damage) >= unit.health(thisUnit)
    end
    return finishHim
end
-- Time Moving
local function timeMoving()
    if movingTimer == nil then movingTimer = GetTime() end
    if not unit.moving() then
        movingTimer = GetTime()
    end
    return GetTime() - movingTimer
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Auto Shapeshift
    if (not buff.travelForm.exists() and unit.moving() and timeMoving() > ui.value("Shift Wait Time")) or unit.inCombat() then
        local formValue = ui.mode.form
        -- Bear Form
        if formValue == 3 and unit.level() >= 8 and cast.able.bearForm() and not buff.bearForm.exists() then
            if cast.bearForm() then ui.debug("Casting Bear Form") return true end
        end
        -- Caster Form
        if formValue == 1 and (buff.bearForm.exists() or buff.catForm.exists()) then
            RunMacroText("/CancelForm")
            ui.debug("Casting Caster Form")
            return true
        end
        --Cat Form
        if (formValue == 2 or (formValue == 3 and unit.level() < 8)) and unit.level() >= 5 and cast.able.catForm() and not buff.catForm.exists() then
            if cast.catForm() then ui.debug("Casting Cat Form") return true end
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Regrowth
        if ui.checked("Regrowth") and cast.able.regrowth() and not cast.current.regrowth() and not unit.moving() then
            if unit.friend("target") and unit.hp("target") <= ui.value("Regrowth") and UnitIsPlayer("target") then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    -- CancelShapeshiftForm()
                    RunMacroText("/CancelForm")
                else
                    if cast.regrowth("target") then ui.debug("Casting Regrowth on "..unit.name("target")) return true end
                end
            end
            if not unit.friend("target") and unit.hp() <= ui.value("Regrowth") then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    -- CancelShapeshiftForm()
                    RunMacroText("/CancelForm")
                else
                    if cast.regrowth("player") then ui.debug("Casting Regrowth on "..unit.name("player")) return true end
                end
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() then
        if unit.valid("target") then
            local thisDistance = unit.distance("target") or 99
            if not unit.moving() and not (buff.catForm.exists() or buff.bearForm.exists()) and thisDistance < 40 then
                if cast.able.wrath("target") and (unit.level() < 2 or not cast.last.wrath() or not unit.inCombat()) then
                    if cast.wrath("target") then ui.debug("Casting Wrath [Pre-Pull]") return true end
                end
            end
            if thisDistance < 5 then
                -- Shred
                if cast.able.shred() and buff.catForm.exists() then
                    if cast.shred() then ui.debug("Casting Shred [Pre-Pull]") return true end
                end
                -- Auto Attack
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) then
                    StartAttack(units.dyn5)
                end
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
    buff                                        = br.player.buff
    cast                                        = br.player.cast
    cd                                          = br.player.cd
    comboPoints                                 = br.player.power.comboPoints.amount()
    debuff                                      = br.player.debuff
    enemies                                     = br.player.enemies
    energy                                      = br.player.power.energy.amount()
    module                                      = br.player.module
    ui                                          = br.player.ui
    unit                                        = br.player.unit
    units                                       = br.player.units
    spell                                       = br.player.spell
    -- General Locals
    movingTimer                                 = timeMoving()
    profileStop                                 = profileStop or false
    haltProfile                                 = (unit.inCombat() and profileStop) or pause() or ui.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    -- Enemies
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    enemies.get(40) -- Makes a varaible called, enemies.yards40

    -- Profile Specific Locals
    fbMaxEnergy = energy >= 50
    if not unit.inCombat() and not unit.exists("target") then
        if profileStop then profileStop = false end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -----------------------
        --- Extras Rotation ---
        -----------------------
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
        if unit.inCombat() and unit.valid("target") and cd.global.remain() == 0 then

            ------------------------
            --- In Combat - Main ---
            ------------------------
            -- Melee in melee range
            if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                -- Start Attack
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) then
                    StartAttack(units.dyn5)
                end
                -- Bear Form
                if buff.bearForm.exists() then
                    -- Mangle
                    if cast.able.mangle(units.dyn5) then
                        if cast.mangle(units.dyn5) then ui.debug("Casting Mangle") return true end
                    end
                end
                -- Cat Form
                if buff.catForm.exists() then
                    local finish = ferociousBiteFinish()
                    -- Ferocious Bite
                    if cast.able.ferociousBite() and ((comboPoints == 5 and fbMaxEnergy) or finish) then
                        if finish then
                            if cast.ferociousBite() then ui.debug("Casting Ferocious Bite [Finish]") return true end
                        else
                            if cast.ferociousBite() then ui.debug("Casting Ferocious Bite") return true end
                        end
                    end
                    -- Shred
                    if cast.able.shred() and (comboPoints < 5 or unit.level() < 7) then
                        if cast.shred() then ui.debug("Casting Shred") return true end
                    end
                end
            end
            -- Caster Form
            if not (buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists()) then
                -- Moonfire
                if cast.able.moonfire() and (unit.level() < 5 or not buff.catForm.exists()) and debuff.moonfire.refresh(units.dyn40) then
                    if cast.moonfire() then ui.debug("Casting Moonfire") return true end
                end
                -- Wrath
                if not unit.moving() and cast.able.wrath() and (unit.level() < 2 or not cast.last.wrath() or not debuff.moonfire.refresh(units.dyn40)) then
                    if cast.wrath() then ui.debug("Casting Wrath") return true end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
    return true
end -- End runRotation
local id = 1447 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
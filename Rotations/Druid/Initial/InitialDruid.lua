local rotationName = "Initial Druid" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spells.wrath },
        [2] = { mode = "Off", value = 2, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.rejuvenation }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.rejuvenation },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.rejuvenation }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "On", value = 1, overlay = "Cooldown Enabled", tip = "Includes Offensive Cooldowns.", highlight = 1, icon = br.player.spells.berserk },
        [2] = { mode = "Off", value = 2, overlay = "Cooldown Disabled", tip = "No Offensive Cooldowns Used.", highlight = 0, icon = br.player.spells.berserk },
    };
    br.ui:createToggle(CooldownModes, "Cooldown", 3, 0)
    -- Form Button
    local FormModes = {
        [1] = { mode = "Caster", value = 1, overlay = "Caster Form", tip = "Will force and use Caster Form", highlight = 1, icon = br.player.spells.moonkinForm },
        [2] = { mode = "Cat", value = 2, overlay = "Cat Form", tip = "Will force and use Cat Form", highlight = 0, icon = br.player.spells.catForm },
        [3] = { mode = "Bear", value = 3, overlay = "Bear Form", tip = "Will force and use Bear Form", highlight = 0, icon = br.player.spells.bearForm }
    };
    br.ui:createToggle(FormModes, "Forms", 4, 0)
    -- Prowl Button
    local ProwlModes = {
        [1] = { mode = "On", value = 1, overlay = "Prowl Enabled", tip = "Rotation will use Prowl", highlight = 1, icon = br.player.spells.prowl },
        [2] = { mode = "Off", value = 2, overlay = "Prowl Disabled", tip = "Rotation will not use Prowl", highlight = 0, icon = br.player.spells.prowl }
    };
    br.ui:createToggle(ProwlModes, "Prowl", 5, 0)
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
        br.ui:createSpinnerWithout(section, "Shift Wait Time", 2, 0, 5, 1,
            "|cffFFFFFFTime in seconds the profile will wait while moving to shift. Combat is instant!")
        -- Mark of the Wild
        br.ui:createDropdown(section, "Mark of the Wild",
            { "|cffFFFFFFPlayer", "|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFFocus", "|cffFFFFFFGroup" }, 1,
            "|cffFFFFFFSet how to use Mark of the Wild")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Basic Trinkets Module
        br.player.module.BasicTrinkets(nil, section)
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Basic Healing Module
        br.player.module.BasicHealing(section)
        -- Regrowth
        br.ui:createSpinner(section, "Regrowth", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Rejuvenation
        br.ui:createSpinner(section, "Rejuvenation", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle, 4)
        --Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle, 6)
        -- Cooldown Key Toggle
        br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle, 6)
        -- Pause Toggle
        br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
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
local var = {}
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
-- AutoProwl
local function autoProwl()
    if not unit.inCombat() and not buff.prowl.exists() then
        if #enemies.yards20 > 0 then return true end
        if #enemies.yards20nc > 0 then
            for i = 1, #enemies.yards20nc do
                local thisUnit = enemies.yards20nc[i]
                local threatRange = math.max((20 + (unit.level(thisUnit) - unit.level())), 5)
                local react = unit.reaction(thisUnit) or 10
                if unit.distance(thisUnit) < threatRange and (react < 4 or (unit.isUnit("target", thisUnit) and react == 4)) and unit.enemy(thisUnit) and unit.canAttack(thisUnit) then
                    return true
                end
            end
        end
        -- if unit.isDummy("target") and unit.distance("target") < 20 then return true end
    end
    return false
end
-- Ferocious Bite Finish
local function ferociousBiteFinish(thisUnit)
    local desc = br._G.C_Spell.GetSpellDescription(spell.ferociousBite.id())
    local damage = 0
    local finishHim = false
    if thisUnit == nil then thisUnit = units.dyn5 end
    if comboPoints > 0 and not unit.isDummy(thisUnit) then
        local comboStart = desc:find(" " .. comboPoints .. " ", 1, true)
        if comboStart ~= nil then
            comboStart = comboStart + 2
            local damageList = desc:sub(comboStart, desc:len())
            comboStart = damageList:find(": ", 1, true) + 2
            damageList = damageList:sub(comboStart, desc:len())
            local comboEnd = damageList:find(" ", 1, true) - 1
            damageList = damageList:sub(1, comboEnd)
            damage = damageList:gsub(",", "")
        end
        local lower = tonumber(damage:match("^(%d+)%-%d+$"))
        finishHim = tonumber(lower) >= unit.health(thisUnit)
    end
    return finishHim
end
-- Time Moving
local function timeMoving()
    if movingTimer == nil then movingTimer = br._G.GetTime() end
    if not unit.moving() then
        movingTimer = br._G.GetTime()
    end
    return br._G.GetTime() - movingTimer
end

local getMarkUnitOption = function(option)
    local thisTar = ui.value(option)
    local thisUnit
    if thisTar == 1 then
        thisUnit = "player"
    end
    if thisTar == 2 then
        thisUnit = "target"
    end
    if thisTar == 3 then
        thisUnit = "mouseover"
    end
    if thisTar == 4 then
        thisUnit = "focus"
    end
    if thisTar == 5 then
        thisUnit = "player"
        if #br.friend > 1 then
            for i = 1, #br.friend do
                local nextUnit = br.friend[i].unit
                if buff.markOfTheWild.refresh(nextUnit) and unit.distance(var.markUnit) < 40 then
                    thisUnit = nextUnit
                    break
                end
            end
        end
    end
    return thisUnit
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Auto Shapeshift
    if (not buff.travelForm.exists() and unit.moving() and timeMoving() > ui.value("Shift Wait Time")) or unit.inCombat()
        or (unit.exists("target") and (unit.id("target") == 164577 or unit.id("target") == 166906) and unit.canAttack("player", "target"))
    then
        local formValue = ui.mode.forms
        -- Bear Form
        if formValue == 3 and unit.level() >= 8 and cast.able.bearForm() and not buff.bearForm.exists() then
            if cast.bearForm() then
                ui.debug("Casting Bear Form")
                return true
            end
        end
        -- Caster Form
        if (formValue == 1 or (unit.exists("target") and (unit.id("target") == 164577 or unit.id("target") == 166906) and unit.canAttack("player", "target")))
            and (buff.bearForm.exists() or buff.catForm.exists())
        then
            br._G.RunMacroText("/CancelForm")
            ui.debug("Casting Caster Form")
            return true
        end
        --Cat Form
        if (formValue == 2 or (formValue == 3 and unit.level() < 8)) and unit.level() >= 5 and cast.able.catForm() and not buff.catForm.exists()
            and ((unit.id("target") ~= 164577 and unit.id("target") ~= 166906) or not unit.canAttack("player", "target"))
        then
            if cast.catForm() then
                ui.debug("Casting Cat Form")
                return true
            end
        end
    end
    -- -- Mark of the Wild
    -- if ui.checked("Mark of the Wild") then
    --     var.markUnit = getMarkUnitOption("Mark of the Wild")
    --     if cast.able.markOfTheWild(var.markUnit) and buff.markOfTheWild.refresh(var.markUnit) and not unit.resting() and unit.distance(var.markUnit) < 40 then
    --         if cast.markOfTheWild(var.markUnit) then
    --             ui.debug("Casting Mark of the Wild")
    --             return true
    --         end
    --     end
    -- end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Rejuvenation
        if ui.checked("Rejuvenation") and not cast.current.rejuvenation() then
            if cast.able.rejuvenation("target") and unit.friend("target") and unit.hp("target") <= ui.value("Rejuvenation")
                and br._G.UnitIsPlayer("target") and buff.rejuvenation.refresh("target")
            then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    -- CancelShapeshiftForm()
                    br._G.RunMacroText("/CancelForm")
                else
                    ui.debug("Attempting to cast Rejuvenation on " .. unit.name("target"))
                    if cast.rejuvenation("target") then
                        return true
                    end
                end
            end
            if cast.able.rejuvenation("player") and not unit.friend("target") and unit.hp() <= ui.value("Rejuvenation") and buff.rejuvenation.refresh("player") then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    -- CancelShapeshiftForm()
                    br._G.RunMacroText("/CancelForm")
                else
                    if cast.rejuvenation("player") then
                        ui.debug("Casting Rejuvenation on " .. unit.name("player"))
                        return true
                    end
                end
            end
        end
        -- Regrowth
        -- if ui.checked("Regrowth") and cast.able.regrowth() and not cast.current.regrowth() and not unit.moving() then
        --     if unit.friend("target") and unit.hp("target") <= ui.value("Regrowth") and br._G.UnitIsPlayer("target") then
        --         if buff.catForm.exists() or buff.bearForm.exists() then
        --             -- CancelShapeshiftForm()
        --             br._G.RunMacroText("/CancelForm")
        --         else
        --             if cast.regrowth("target") then
        --                 ui.debug("Casting Regrowth on " .. unit.name("target"))
        --                 return true
        --             end
        --         end
        --     end
        --     if not unit.friend("target") and unit.hp() <= ui.value("Regrowth") then
        --         if buff.catForm.exists() or buff.bearForm.exists() then
        --             -- CancelShapeshiftForm()
        --             br._G.RunMacroText("/CancelForm")
        --         else
        --             if cast.regrowth("player") then
        --                 ui.debug("Casting Regrowth on " .. unit.name("player"))
        --                 return true
        --             end
        --         end
        --     end
        -- end
    end
end -- End Action List - Defensive

-- Action List - Cooldowns
actionList.Cooldowns = function()
    module.BasicTrinkets()
end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        if not (buff.prowl.exists() or buff.shadowmeld.exists()) then
            -- Prowl
            if cast.able.prowl("player") and buff.catForm.exists() and autoProwl() and ui.mode.prowl == 1
                and not buff.prowl.exists() and (not unit.resting() or unit.isDummy("target"))
            then
                if cast.prowl("player") then
                    ui.debug("Casting Prowl [Precombat]")
                    return true
                end
            end
        end -- End No Stealth
        if unit.valid("target") then
            local thisDistance = unit.distance("target") or 99
            -- Wrath
            if not unit.moving() and not (buff.catForm.exists() or buff.bearForm.exists()) and thisDistance < 40 then
                if cast.able.wrath("target") and (unit.level() < 2 or not cast.last.wrath() or cast.timeSinceLast.wrath() > unit.gcd(true) + 0.5) then
                    if cast.wrath("target") then
                        ui.debug("Casting Wrath [Precombat]")
                        return true
                    end
                end
            end
            if thisDistance < 5 then
                -- Shred
                -- if cast.able.shred() and buff.catForm.exists() then
                --     if cast.shred() then
                --         ui.debug("Casting Shred [Precombat]")
                --         return true
                --     end
                -- end
                -- Mangle
                if cast.able.mangleBear(units.dyn5) and buff.bearForm.exists() then
                    if cast.mangleBear(units.dyn5) then
                        ui.debug("Casting Mangle [Precombat]")
                        return true
                    end
                end
                -- Rake
                if cast.able.rake() and buff.catForm.exists() then
                    if cast.rake() then
                        ui.debug("Casting Rake [Precombat]")
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
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    if unit.inCombat() and unit.valid("target") and cd.global.remain() == 0 then
        ------------------------
        --- In Combat - Main ---
        ------------------------
        -- Melee in melee range
        if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            -- Start Attack
            if cast.able.autoAttack("target") and unit.exists("target") and unit.distance("target") < 5 then
                if cast.autoAttack("target") then
                    ui.debug("Casting Auto Attack")
                    return true
                end
            end
            -- Call Action List - Cooldowns
            if actionList.Cooldowns() then return true end
            -- Bear Form
            if buff.bearForm.exists() then
                -- Maul
                if cast.able.maul(units.dyn5) then
                    if cast.maul(units.dyn5) then
                        ui.debug("Casting Maul")
                        return true
                    end
                end
                -- Mangle
                if cast.able.mangleBear(units.dyn5) then
                    if cast.mangleBear(units.dyn5) then
                        ui.debug("Casting Mangle")
                        return true
                    end
                end
            end
            -- Cat Form
            if buff.catForm.exists() then
                -- Ferocious Bite
                local finish = ferociousBiteFinish(units.dyn5)
                if cast.able.ferociousBite(units.dyn5) and ((comboPoints == 5 and fbMaxEnergy) or finish) then
                    if finish then
                        if cast.ferociousBite() then
                            ui.debug("Casting Ferocious Bite [Finish]")
                            return true
                        end
                    else
                        if cast.ferociousBite() then
                            ui.debug("Casting Ferocious Bite")
                            return true
                        end
                    end
                end
                -- Rake
                if cast.able.rake() and comboPoints < 5 and debuff.rake.refresh(units.dyn5) then
                    if cast.rake() then
                        ui.debug("Casting Rake")
                        return true
                    end
                end
                -- Mangle
                if cast.able.mangle() and comboPoints < 5 and not debuff.rake.refresh(units.dyn5) then
                    if cast.mangle() then
                        ui.debug("Casting Mangle")
                        return true
                    end
                end
            end
        end
        -- Caster Form
        if not (buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists()) then
            -- Moonfire
            if cast.able.moonfire(units.dyn40AOE) and (unit.level() < 5 or not buff.catForm.exists()) and debuff.moonfire.refresh(units.dyn40AOE) then
                if cast.moonfire(units.dyn40AOE) then
                    ui.debug("Casting Moonfire")
                    return true
                end
            end
            -- Wrath
            if not unit.moving() and cast.able.wrath() and (unit.level() < 2 or (not cast.last.wrath() and cast.timeSinceLast.wrath() > unit.gcd(true) + 0.5) or not debuff.moonfire.refresh(units.dyn40AOE)) then
                if cast.wrath() then
                    ui.debug("Casting Wrath")
                    return true
                end
            end
        end
    end -- End In Combat Rotation
end     -- End Action list - Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff        = br.player.buff
    cast        = br.player.cast
    cd          = br.player.cd
    comboPoints = br.player.power.comboPoints()
    debuff      = br.player.debuff
    enemies     = br.player.enemies
    energy      = br.player.power.energy()
    module      = br.player.module
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    spell       = br.player.spell
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or br.pause() or ui.mode.rotation == 2 or unit.id("target") == 156716
    -- Units
    units.get(5)        -- Makes a variable called, units.dyn5
    units.get(40, true) -- Makes a variable called, units.dyn40AOE
    -- Enemies
    enemies.get(5)      -- Makes a varaible called, enemies.yards5
    enemies.get(20)     -- Makes a varaible called, enemies.yards20
    enemies.get(20, "player", true)        -- makes enemies.yards20nc
    enemies.get(40)     -- Makes a varaible called, enemies.yards40

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
        if actionList.Combat() then return true end
    end         -- Pause
    return true
end             -- End runRotation
local id = 1447 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

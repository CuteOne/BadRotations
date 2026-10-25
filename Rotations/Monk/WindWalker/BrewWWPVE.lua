local rotationName = "BrewWWPVE"

---------------
--- Toggles ---
---------------
local function toggles()
    br.ui:toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = "whirlwind", overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range." },
        { name = "Mult", icon = "bladestorm", overlay = "Multiple Target Rotation", tip = "Multiple target rotation used." },
        { name = "Sing", icon = "ragingBlow", overlay = "Single Target Rotation", tip = "Single target rotation used." },
        { name = "Off", icon = "enragedRegeneration", overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation" },
    } })
    br.ui:toggle("Cooldown", { key = "RightCtrl", modes = {
        { name = "Auto", icon = "recklessness", overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection." },
        { name = "On", icon = "recklessness", overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target." },
        { name = "Off", icon = "recklessness", overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used." },
    } })
    br.ui:toggle("Defensive", { modes = {
        { name = "On", icon = "enragedRegeneration", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "enragedRegeneration", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    br.ui:toggle("Interrupt", { modes = {
        { name = "On", icon = "pummel", overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts." },
        { name = "Off", icon = "pummel", overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
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
    section = br.ui:section("General")

    ------------------------
    --- COOLDOWN OPTIONS --- -- Define Cooldown Options
    ------------------------
    section = br.ui:section("Cooldowns")

    -------------------------
    --- DEFENSIVE OPTIONS --- -- Define Defensive Options
    -------------------------
    section = br.ui:section("Defensive")

    -------------------------
    --- INTERRUPT OPTIONS --- -- Define Interrupt Options
    -------------------------
    section = br.ui:section("Interrupts")
    -- Interrupt Percentage
    br.ui:spinner(section, "Interrupt At", { value = 0, max = 95, tip = "|cffFFBB00Cast Percentage to use at." })
end

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local buff
local debuff
local cast
local cd
local charges
local enemies
local module
local power
local talent
local ui
local unit
local units
local var
local chi

local getRealHP = function(Unit)
    if Unit ~= nil then
        if br.functions.unit:GetObjectExists(Unit) and br.functions.unit:GetUnitIsVisible(Unit) and not br.functions.unit:GetUnitIsDeadOrGhost(Unit) then
            return 100 * (br.game.UnitHealth(Unit) + br.game.UnitGetIncomingHeals(Unit, "player")) /
            br.game.UnitHealthMax(Unit)
        end
    else
        return 100
    end
end

--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------

local actionList = {} -- Table for holding action lists.
-- Action List - Extra
actionList.Extra = function()
    if unit.inCombat() and unit.valid("target") then
        if unit.distance("target") <= 20 and cast.able.expelHarm() and power >= 15 and chi <= 5 then
            if cast.expelHarm() then
                ui.debug("CAST Expel Harm"); return true;
            end
        end
        if unit.distance("target") <= 40 and cast.able.chiBurst() and chi <= 5 then
            if cast.chiBurst("target") then
                ui.debug("CAST Chi Burst"); return true;
            end
        end
    end
    if unit.isBoss("target") and unit.valid("target") then
        if unit.distance("target") <= 40 and cast.able.invokeXuenTheWhiteTiger() then
            if cast.invokeXuenTheWhiteTiger() then
                ui.debug("CAST Invoking Xuen")
                return true;
            end
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if getRealHP("player") <= 90 and cast.able.expelHarm() and chi < 6 then
        if cast.expelHarm() then
            ui.debug("CAST Expel Harm"); return true;
        end
    end

    if getRealHP("player") <= 75 and cast.able.vivify() and not cast.last.vivify() then
        if cast.vivify("player") then
            ui.debug("DEFENSE: Vivify"); return true;
        end
    end

    if getRealHP("player") <= 50 and cast.able.touchOfKarma("player") then
        if cast.touchOfKarma("player") then
            ui.debug("DEFENSE: Touch of Karma")
            return true;
        end
    end
    if getRealHP("player") <= 60 and cast.able.fortifyingBrew("player") then
        if cast.fortifyingBrew("player") then
            ui.debug("DEFENSE: fortifyingBrew")
            return true;
        end
    end
end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()

end -- End Action List - Interrupt

-- Action List - Cooldowns
actionList.Cooldown = function()

end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Logic based on pull timers (IE: DBM/BigWigs)
        end                          -- End Pre-Pull
        if unit.valid("target") then -- Abilities below this only used when target is valid
            if br.unlockers.selected == "Tinkr" and not br.functions.unit:getFacing("player", "target") then
                return br.game.FaceObject("target")
            end

            if br.unlockers.selected == "Tinkr" and unit.distance("target") > 5 then
                return br.game.MoveToRaw(br.game.ObjectRawPosition("target"))
            end

            -- Start Attack
            if unit.distance("target") < 5 then -- Starts attacking if enemy is within 5yrds
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then
                        ui.debug("Casting Auto Attack [Pre-Combat]")
                        return true
                    end
                end
            end
        end
    end -- End No Combat
end     -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation() -- This is the main profile loop, any below this point is ran every cycle, everything above is ran only once during initialization.
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals - These are the same as the locals above just defined for use.
    buff    = br.player.buff
    debuff  = br.player.debuff
    cast    = br.player.cast
    cd      = br.player.cd
    charges = br.player.charges
    enemies = br.player.enemies
    module  = br.player.module
    power   = br.player.power.energy()
    talent  = br.player.talent
    ui      = br.player.ui
    unit    = br.player.unit
    units   = br.player.units
    var     = br.player.variables
    chi     = br.player.power.chi()

    -- Explanations on the Units and Enemies functions can be found in System/API/Units.lua and System/API/Enemies.lua
    -------------
    --- Units ---
    -------------
    units.get(5)  -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40

    ---------------
    --- Enemies ---
    ---------------
    enemies.get(5)  -- Makes a varaible called, enemies.yards5
    enemies.get(40) -- Makes a varaible called, enemies.yards40

    ------------------------
    --- Custom Variables ---
    ------------------------
    -- Any other local varaible from above would also need to be defined here to be use.
    if var.profileStop == nil then var.profileStop = false end -- Trigger variable to help when needing to stop a profile.


    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then                                               -- Reset profile stop once stopped
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then -- If profile triggered to stop go here until it has.
        return true
    else                                                                                                                        -- Profile is free to perform actions
        --------------
        --- Extras ---
        --------------
        if actionList.Extra() then return true end
        if actionList.Defensive() then return true end
        if actionList.PreCombat() then return true end

        if unit.inCombat() and unit.valid("target") and not var.profileStop then
            if actionList.Interrupt() then return true end -- This runs the Interrupt Action List, this generally contains interrupt functions.
            ------------
            --- Main ---
            ------------
            if br.unlockers.selected == "Tinkr" then
                br.game.FaceObject("target")
            end

            --- Priority PROCS
            if buff.danceOfChiJi.exists() then
                ui.debug("PROC BUFF of Chi-Ji, Castable: " .. tostring(cast.able.spinningCraneKick()))
            end
            if buff.blackoutKick.exists() and not cast.last.blackoutKick() and cast.able.blackoutKick("target") then
                if cast.blackoutKick("target") then
                    ui.debug("PROC Blackout Kick"); return true;
                end;
            end

            if buff.danceOfChiJi.exists() and cast.able.spinningCraneKick() then
                if cast.spinningCraneKick() then
                    ui.debug("PROC ChiJi: Spinning Crane Kick"); return true;
                end;
            end
            if buff.teachingsOfTheMonastery.exists() and cast.able.blackoutKick("target") then
                if cast.blackoutKick("target") then
                    ui.debug("PROC Teachings: Blackout Kick"); return true;
                end;
            end


            -- Priority, don don't let chi cap
            if chi == 6 and cast.able.blackoutKick("target") and not cast.last.blackoutKick(1) then
                if cast.blackoutKick("target") then
                    ui.debug("CHI CAP: Cast Blackout"); return true;
                end;
            end


            if cast.able.touchOfDeath("target") and unit.health("target") <= unit.health("player") then
                if cast.touchOfDeath("target") then
                    ui.debug("CAST touch of Death"); return true;
                end;
            end



            if cast.able.tigerPalm() and chi < 5 and not (buff.serenity.exists() and cast.last.tigerPalm(1)) then
                if cast.tigerPalm("target") then
                    ui.debug("Cast Tiger Palm"); return true;
                end
            end

            if cast.able.serenity() then
                if cast.serenity() then
                    ui.debug("CAST serenity"); return true;
                end
            end

            if cast.able.strikeOfTheWindlord() and chi > 2 then
                if cast.strikeOfTheWindlord() then
                    ui.debug("CAST strike of the windlord"); return true;
                end
            end

            if cast.able.risingSunKick("target") and chi > 2 then
                if cast.risingSunKick("target") then
                    ui.debug("CAST Rising Sun Kick"); return true;
                end
            end

            if cast.able.fistsOfFury("target") and chi >= 3 and unit.distance("target") <= 8 then
                if cast.fistsOfFury("target") then
                    ui.debug("CAST Fist of Fury"); return true;
                end
            end

            if cast.able.blackoutKick("target") and chi >= 1 and not cast.last.blackoutKick(1) then
                if cast.blackoutKick("target") then
                    ui.debug("CAST blackout Kick"); return true;
                end;
            end

            if cast.able.rushingJadeWind() and chi >= 1 then
                if cast.rushingJadeWind() then
                    ui.debug("CAST rushingJadeWind"); return true;
                end;
            end

            if cast.able.spinningCraneKick() and chi <= 2 then
                if cast.spinningCraneKick() then
                    ui.debug("CAST Spinning Crane Kick"); return true;
                end;
            end
            if cast.able.chiWave() then
                if cast.chiWave() then
                    ui.debug("CAST: Chi Wave"); return true;
                end;
            end

            -- Start Attack - This will start auto attacking your target if it's within 5yrds and valid
            if unit.distance("target") <= 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then
                        ui.debug("Casting Auto Attack [Pre-Combat]")
                        return true
                    end
                end
            end
        end    -- End In Combat Rotation
    end        -- Pause
end            -- End runRotation
br.loader.registerRotation({
    name      = rotationName,
    specID    = 0,
    expansion = "MOP",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

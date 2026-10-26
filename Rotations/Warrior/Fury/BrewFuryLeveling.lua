-- Editor types: the keys of Retail Warrior Fury's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.Retail.Warrior.Fury.buff]]
local cast = cast --[[@as BR.Retail.Warrior.Fury.cast]]
local talent = talent --[[@as BR.Retail.Warrior.Fury.talent]]

local rotationName = "BrewFuryLeveling"

local colors = {
    blue    = "|cff4285F4",
    red     = "|cffDB4437",
    yellow  = "|cffF4B400",
    green   = "|cff0F9D58",
    white   = "|cffFFFFFF",
    purple  = "|cff9B30FF",
    aqua    = "|cff89E2C7",
    blue2   = "|cffb8d0ff",
    green2  = "|cff469a81",
    blue3   = "|cff6c84ef",
    orange  = "|cffff8000"
}

local text = {
    options={
        onlyUseConsumablesInRaids = "Only use consumables in raids",

    },
    cooldowns={
        cooldowns = colors.purple .. "Cooldowns",
        useCooldowns = colors.purple .. "Use cooldowns",
        numberOfMobs = colors.purple .. "Number of mobs",
        enragedRegeneration = colors.purple .. "Enraged Regeneration",
    },
    defensive={
        defensive = colors.orange .. "Defensive",
        useSpellReflection = colors.orange .. "Use Spell Reflection if can't interrupt",
        usePummel = colors.orange .. "Use Pummel as interrupt",
        beserkerRage = colors.orange .. "Use Beserker Rage",

    }
}

local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = "whirlwind", overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range." },
        { name = "Mult", icon = "bladestorm", overlay = "Multiple Target Rotation", tip = "Multiple target rotation used." },
        { name = "Sing", icon = "ragingBlow", overlay = "Single Target Rotation", tip = "Single target rotation used." },
        { name = "Off", icon = "enragedRegeneration", overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation" },
    } })
    ui.toggle("Cooldown", { key = "RightCtrl", modes = {
        { name = "Auto", icon = "recklessness", overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection." },
        { name = "On", icon = "recklessness", overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target." },
        { name = "Off", icon = "recklessness", overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used." },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "enragedRegeneration", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "enragedRegeneration", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "pummel", overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts." },
        { name = "Off", icon = "pummel", overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
    } })
    ui.toggle("Debugs", { modes = {
        { name = "ON", icon = 200733, overlay = "Debugs On", tip = "Debug Messages On" },
        { name = "OFF", icon = 200733, overlay = "Debugs Off", tip = "Debug Messages Off" },
    } })
    ui.toggle("HeroicLeap", { row = 1, col = 4, modes = {
        { name = "ON", icon = "heroicLeap", overlay = "Heroic Leap On", tip = "Heroic Leap On" },
        { name = "OFF", icon = "heroicLeap", overlay = "Heroic Leap Off", tip = "Heroic Leap Off" },
    } })
    ui.toggle("Charge", { row = 1, col = 3, modes = {
        { name = "ON", icon = "charge", overlay = "Charge On", tip = "Charge On" },
        { name = "OFF", icon = "charge", overlay = "Charge Off", tip = "Charge Off" },
    } })
end


local function options()
    local section
    -----------------------
    --- GENERAL OPTIONS --- -- Define General Options
    -----------------------
    section = ui.section("General")

    section = ui.section(text.cooldowns.cooldowns)
        ui.checkbox(section, text.cooldowns.useCooldowns)
        ui.spinner(section, text.cooldowns.numberOfMobs, { value = 2, min = 2, max = 10, step = 1,
            tip = "|cffFFBB00Number of enemies to use cooldowns on." })
        ui.checkbox(section, text.cooldowns.enragedRegeneration)

    section = ui.section(text.defensive.defensive)
        ui.checkbox(section, text.defensive.useSpellReflection)
        ui.checkbox(section, text.defensive.usePummel)
        ui.checkbox(section, text.defensive.beserkerRage)
        ui.spinner(section, colors.orange .. "Interrupt At", { value = 0, max = 95, tip = "|cffFFBB00Cast Percentage to use at." })
end

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local rage

-- Any variables/functions made should have a local here to prevent possible conflicts with other things.
local function round(number, digit_position)
    local precision = math.pow(10, digit_position)
    number = number + (precision / 2); -- this causes value #.5 and up to round up
                                       -- and #.4 and lower to round down.

    return math.floor(number / precision) * precision
  end

local function printStats(message)
    local rageString
     rageString = colors.red .. "[" .. tostring(power.rage()) .. "]"
     local lastTime = util.time() - var.lastCast
    ui.print(colors.red.. string.format("%.1f", util.time()) ..colors.aqua .."[+" .. string.format("%f2",round(lastTime,-2)) .. "] "  .. string.format("%f",unit.gcd())..colors.white .. rageString .. " : ".. message)
end

local debugMessage = function(message)
    if ui.mode.debugs == 1 then printStats(message) end
    var.lastCast = util.time()
end

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------

--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------
local actionList = {} -- Table for holding action lists.
-- Action List - Extra
actionList.Extra = function()

end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    -- for i=1, #enemies.yards5 do
    --     local name,_,_,startTime,endTime,_,_,notInterruptable,spellId = br.game.UnitCastingInfo(enemies.yards5[i])
    --     if name ~= nil then
    --         if notInterruptable or (not notInterruptable and )
    --     end
    -- end

end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()
    if  util.timer("Interrupts",unit.gcd(true)) then
        local thisUnit
            for i=1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At"))  and cast.able.pummel(thisUnit) then
                    if cast.pummel(thisUnit) then
                        debugMessage("Interrupt: pummel "..unit.name(thisUnit))
                        return true
                    else
                        debugMessage("Failed to Interrupt: pummel "..unit.name(thisUnit))
                    end
                end
            end
    end
end -- End Action List - Interrupt

-- Action List - Cooldowns
actionList.Cooldown = function()

end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
        if not buff.battleShout.exists() and cast.able.battleShout() then
                if cast.battleShout() then
                    debugMessage("Casting Battle Shout")
                    return true
                else
                    debugMessage("Failed to Battle Shout")
                end
        end
        if unit.valid("target") then -- Abilities below this only used when target is valid

            if ui.mode.heroicLeap==1 and unit.distance("target") >=8 and unit.distance("target") <= 40
                and cast.able.heroicLeap("target")
                and not cast.last.heroicLeap()
                and not cast.last.charge()
                and not cast.last.heroicThrow()
                then
                if cast.heroicLeap("target") then
                    debugMessage("Casting Heroic Leap")
                    return true
                else
                    debugMessage("Failed to Heroic Leap")
                end
            end

            if ui.mode.charge==1 and unit.distance("target") >=8 and unit.distance("target") <= 25
                and cast.able.charge("target")
                and not cast.last.heroicLeap()
                and not cast.last.charge()
                and not cast.last.heroicThrow()
                then
                    if cast.charge("target") then
                        debugMessage("Casting Charge")
                        return true
                    else
                        debugMessage("Failed to Charge")
                    end
            end

            if unit.distance("target") <= 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then debugMessage("Casting Auto Attack [Pre-Combat]") return true end
                end
            end
        end
    end -- End No Combat
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation() -- This is the main profile loop, any below this point is ran every cycle, everything above is ran only once during initialization.
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals - These are the same as the locals above just defined for use.
    rage                                          = power.rage()


    if var.lastCast == nil then var.lastCast=util.time() end

    -- Explanations on the Units and Enemies functions can be found in System/API/Units.lua and System/API/Enemies.lua
    -------------
    --- Units ---
    -------------
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40

    ---------------
    --- Enemies ---
    ---------------
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    enemies.get(40) -- Makes a varaible called, enemies.yards40
    enemies.get(5,"player",false,true) -- makes enemies.yards5f

    ------------------------
    --- Custom Variables ---
    ------------------------
    -- Any other local varaible from above would also need to be defined here to be use.
    if var.profileStop == nil then var.profileStop = false end -- Trigger variable to help when needing to stop a profile.


    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then -- Reset profile stop once stopped
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then -- If profile triggered to stop go here until it has.
        return true
    else -- Profile is free to perform actions
        --------------
        --- Extras ---
        --------------
        if actionList.Extra() then return true end -- This runs the Extra Action List and anything in it will run in or out of combat, this generally contains utility functions.
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end -- This runs the Defensive Action List and anything in it will run in or out of combat, this generally contains defensive functions.
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end  -- This runs the Pre-Combat Action List and anything in it will run in or out of combat, this generally includes functions that prepare for or start combat.
        -----------------
        --- In Combat ---
        -----------------
        if unit.inCombat() and unit.valid("target") and not var.profileStop then -- Everything below this line only run if you are in combat and the selected target is validated and not triggered to stop.
            ------------------
            --- Interrupts ---
            ------------------
            if actionList.Interrupt() then return true end -- This runs the Interrupt Action List, this generally contains interrupt functions.
            ------------
            --- Main ---
            ------------

            if not talent.impendingVictory and buff.victorious.exists() and cast.able.victoryRush("target") and unit.gcd()<= 0 then
                if cast.victoryRush("target") then
                    debugMessage("Casting Victory Rush")
                    return true
                else
                    debugMessage("Failed to Victory Rush")
                end
            end
            if talent.impendingVictory and cast.able.impendingVictory("target") and unit.gcd()<= 0 then
                if cast.impendingVictory("target") then
                    debugMessage("Casting Impending Victory")
                    return true
                else
                    debugMessage("Failed to Impending Victory")
                end
            end
            -- if cast.able.victoryRush("target") and unit.gcd()<= 0 then
            --     if cast.victoryRush("target") then
            --         debugMessage("Casting Victory Rush")
            --         return true
            --     else
            --         debugMessage("Failed to Victory Rush")
            --     end
            -- end

            if cast.able.execute("target") and unit.hp("target") < 20  and unit.gcd()<= 0 then
                if cast.execute("target") then
                    debugMessage("Casting Execute")
                    return true
                else
                    debugMessage("Failed to Execute")
                end
            end

            if cast.able.bloodthirst("target") and unit.gcd()<= 0 then
                if cast.bloodthirst("target") then
                    debugMessage("Casting Bloodthirst")
                    return true
                else
                    debugMessage("Failed to Bloodthirst")
                end
            end

            if cast.able.ragingBlow("target") and unit.gcd()<= 0 then
                if cast.ragingBlow("target") then
                    debugMessage("Casting Raging Blow")
                    return true
                else
                    debugMessage("Failed to Raging Blow")
                end
            end

            if #enemies.yards5 >= 3 then
                if cast.able.whirlwind() and unit.gcd()<= 0 then
                    if cast.whirlwind() then
                        debugMessage("Casting whirlwind")
                        return true
                    else
                        debugMessage("Failed to Whirlwind")
                    end
                end
            end

            if cast.able.slam("target") and unit.gcd()<= 0 then
                if cast.slam("target") then
                    debugMessage("Casting Slam")
                    return true
                else
                    debugMessage("Failed to Slam")
                end
            end



            -- Start Attack - This will start auto attacking your target if it's within 5yrds and valid
            if unit.distance("target") <= 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then
                        debugMessage("Casting Auto Attack [Pre-Combat]")
                        return true
                    else
                        debugMessage("Failed to Auto Attack")
                    end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
registerRotation({
    name      = rotationName,
    specID    = 72,
    expansion = "Retail",
    author    = "BrewingCoder",
    patch     = "10.2.6",
    coverage  = "20%",
    status    = "Limited",
    readiness = "PVE Leveling",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

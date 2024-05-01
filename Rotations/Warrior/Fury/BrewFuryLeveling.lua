-------------------------------------------------------
-- Author = BrewingCoder
-- Patch = 10.2.6
-- Coverage = 20%
-- Status = Limited
-- Readiness = PVE Leveling
-------------------------------------------------------
local rotationName = "BrewFuryLeveling" -- Change to name of profile listed in options drop down

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



---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles, these are the buttons from the toggle bar
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.whirlwind },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladestorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.ragingBlow },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.recklessness },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.recklessness },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.recklessness }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.enragedRegeneration },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.enragedRegeneration }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.pummel },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
    local DebugModes = {
        [1] = { mode = "ON", value = 1 , overlay = "Debugs On", tip = "Debug Messages On", highlight = 1, icon =200733 },
        [2] = { mode = "OFF", value = 0 , overlay = "Debugs Off", tip = "Debug Messages Off", highlight = 0, icon =200733 },
    }
    br.ui:createToggle(DebugModes,"Debugs",5,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")

        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")

        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")

        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
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
local charges
local enemies
local module
local power
local talent
local ui
local unit
local units
local var
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
     rageString = colors.red .. "[" .. tostring(br._G.UnitPower("player")) .. "]"
     local lastTime = ui.time() - var.lastCast 
    br._G.print(colors.red.. date("%T") ..colors.aqua .."[+" .. string.format("%f2",round(lastTime,-2)) .. "] "  .. string.format("%f",unit.gcd())..colors.white .. rageString .. " : ".. message)
end

local debugMessage = function(message)
    if ui.mode.Debug == 1 then printStats(message) end
    var.lastCast = ui.time()
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

end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()
    if  ui.delay("Interrupts",unit.gcd(true)) then
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
            -- Start Attack
            if unit.distance("target") >=8 and unit.distance("target") <= 40 
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
            if unit.distance("target") >=8 and unit.distance("target") <= 25 
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
            if not unit.moving("player") and unit.distance("target") >=8 and unit.distance("target") <= 30 
                and cast.able.heroicThrow("target") 
                and not cast.last.heroicLeap()
                and not cast.last.charge()
                and not cast.last.heroicThrow()
                then 
                    if cast.heroicThrow("target") 
                    then 
                        debugMessage("Casting Heroic Throw") 
                        return true 
                    else
                        debugMessage("Failed to Heroic Throw")
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
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    enemies                                       = br.player.enemies
    module                                        = br.player.module
    power                                         = br.player.power
    talent                                        = br.player.talent
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    var                                           = br.player.variables
    rage                                          = br._G.UnitPower("player")


    if var.lastCast == nil then var.lastCast=ui.time() end
    ui.mode.Debug = br.data.settings[br.selectedSpec].toggles["Debugs"]

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

            if buff.victorious.exists() and cast.able.victoryRush("target") and unit.gcd()<= 0 then
                if cast.victoryRush("target") then 
                    debugMessage("Casting Victory Rush") 
                    return true 
                else
                    debugMessage("Failed to Victory Rush")
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
local id = 72 -- Change to the spec id profile is for. Spec ID can be found at: https://wowpedia.fandom.com/wiki/SpecializationID
-- DO NOT EDIT ANYTHING BELOW THIS LINE, WILL BREAK PROFILE --
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
local rotationName = "BrewWWPVE" 

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

-- Any variables/functions made should have a local here to prevent possible conflicts with other things.


-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------

--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------
local actionList = {} -- Table for holding action lists.
-- Action List - Extra
actionList.Extra = function()
    if unit.inCombat() and unit.valid("target") then
        if unit.distance("target") <= 20 and cast.able.expelHarm() and power >= 15 and chi <= 5 then
            if cast.expelHarm() then ui.debug("CAST Expel Harm"); return true; end
        end
        if unit.distance("target") <= 40 and cast.able.chiBurst() and chi <= 5 then
            if cast.chiBurst("target") then ui.debug("CAST Chi Burst"); return true; end
        end
    end
    if unit.isBoss("target") and unit.valid("target") then
        if unit.distance("target") <= 40 and cast.able.invokeXuenTheWhiteTiger() then
            if cast.invokeXuenTheWhiteTiger() then ui.debug("CAST Invoking Xuen") return true; end
        end
    end


end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if br.getHP("player") <= 50 and cast.able.touchOfKarma("player") then
        if cast.touchOfKarma("player") then ui.debug("DEFENSE: Touch of Karma") return true; end
    end
    if br.getHP("player") <= 50 and cast.able.fortifyingBrew("player") then
        if cast.fortifyingBrew("player") then ui.debug("DEFENSE: fortifyingBrew") return true; end
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
        end -- End Pre-Pull
        if unit.valid("target") then -- Abilities below this only used when target is valid
            
            


            -- Start Attack
            if unit.distance("target") < 5 then -- Starts attacking if enemy is within 5yrds
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
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
    debuff                                        = br.player.debuff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    enemies                                       = br.player.enemies
    module                                        = br.player.module
    power                                         = br.player.power.energy()
    talent                                        = br.player.talent
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    var                                           = br.player.variables
    chi                                            = br.player.power.chi()

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
        if actionList.Extra() then return true end
        if actionList.Defensive() then return true end
        if actionList.PreCombat() then return true end
        
        if unit.inCombat() and unit.valid("target") and not var.profileStop then 
            if actionList.Interrupt() then return true end -- This runs the Interrupt Action List, this generally contains interrupt functions.
            ------------
            --- Main ---
            ------------

            --- Priority PROCS
            if buff.danceOfChiJi.exists() then
                ui.debug("PROC BUFF of Chi-Ji, Castable: " .. tostring(cast.able.spinningCraneKick()))
            end
            
            if buff.danceOfChiJi.exists() and cast.able.spinningCraneKick() then
                if cast.spinningCraneKick() then ui.debug("PROC ChiJi: Spinning Crane Kick"); return true; end;
            end
            if buff.teachingsOfTheMonastery.exists() and cast.able.blackoutKick("target") then
                if cast.blackoutKick("target") then ui.debug("PROC Teachings: Blackout Kick"); return true; end;
            end

            -- Priority, don don't let chi cap
            if chi == 6 and cast.able.blackoutKick("target") and not cast.last.blackoutKick(1) then
                if cast.blackoutKick("target") then ui.debug("CHI CAP: Cast Blackout"); return true; end;
            end

           
            if cast.able.touchOfDeath("target") and unit.health("target") <= unit.health("player") then
                if cast.touchOfDeath("target") then ui.debug("CAST touch of Death"); return true; end;
            end

            if cast.able.expelHarm() and chi < 6 then
                if cast.expelHarm() then ui.debug("CAST Expel Harm"); return true; end
            end

            if cast.able.tigerPalm() and chi < 5 and not (buff.serenity.exists() and cast.last.tigerPalm(1)) then
                if cast.tigerPalm("target") then ui.debug("Cast Tiger Palm"); return true; end
            end

            if cast.able.serenity() then
                if cast.serenity() then ui.debug("CAST serenity"); return true; end
            end

            if cast.able.strikeOfTheWindlord() and chi > 2 then
                if cast.strikeOfTheWindlord() then ui.debug("CAST strike of the windlord"); return true; end
            end

            if cast.able.risingSunKick("target") and chi > 2 then
                if cast.risingSunKick("target") then ui.debug("CAST Rising Sun Kick"); return true; end
            end

            if cast.able.fistsOfFury("target") and chi >= 3 and unit.distance("target") <= 8 then
                if cast.fistsOfFury("target") then ui.debug("CAST Fist of Fury"); return true; end
            end

            if cast.able.blackoutKick("target") and chi >= 1 then
                if cast.blackoutKick("target") then ui.debug("CAST blackout Kick"); return true; end;
            end

            if cast.able.rushingJadeWind() and chi >= 1 then
                if cast.rushingJadeWind() then ui.debug("CAST rushingJadeWind"); return true; end;
            end

            if cast.able.spinningCraneKick() and chi <= 2 then
                if cast.spinningCraneKick() then ui.debug("CAST Spinning Crane Kick"); return true; end;
            end
            if cast.able.chiWave() then
                if cast.chiWave() then ui.debug("CAST: Chi Wave"); return true; end;
            end 





            -- Start Attack - This will start auto attacking your target if it's within 5yrds and valid
            if unit.distance("target") <= 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 269 -- Change to the spec id profile is for. Spec ID can be found at: https://wowpedia.fandom.com/wiki/SpecializationID
-- DO NOT EDIT ANYTHING BELOW THIS LINE, WILL BREAK PROFILE --
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
-------------------------------------------------------
-- Author = BrewingCoder
-- Patch = 10.2.5
-- Coverage = 90%
-- Status = Limited,Hardcoded Vals
-- Readiness = Development
-------------------------------------------------------
local rotationName = "BrewBrewMaster" -- Change to name of profile listed in options drop down

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
local debuff

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

end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if unit.hp() <= 90 and cast.able.expelHarm("player") then
        if cast.expelHarm("player") then ui.debug("DEF: ExpelHarm") return true;end;
    end
    if (debuff.moderateStagger.exists("player") or debuff.heavyStagger.exists("player")) and cast.able.purifyingBrew("player") then
        if cast.purifyingBrew("player") then ui.debug("DEF: Purifying Brew") return true; end;
    end
    if unit.hp() <= 80 and cast.able.healingElixir("player") then
        if cast.healingElixir("player") then ui.debug("DEF: Healing Elixir") return true; end;
    end
    if unit.hp() <= 70 and cast.able.invokeNiuzao() then
        if cast.invokeNiuzao() then ui.debug("DEF: Invoking Niuzao") return true; end;
    end
    if unit.hp() <= 50 and cast.able.dampenHarm("player") then
        if cast.dampenHarm("player") then ui.debug("DEF: Dampen Harm") return true; end;
    end
    if unit.hp() <= 40 and cast.able.fortifyingBrew("player") then
        if cast.fortifyingBrew("player") then ui.debug("DEF: Fortifying Brew") return true; end;
    end
end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()
    if ui.useInterrupt() and ui.delay("Interrupts",unit.gcd(true)) then
        local thisUnit
        if cast.able.spearHandStrike("target") then
            for i=1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.spearHandStrike(thisUnit) then ui.debug("Interrupt:SpearHandStrike "..unit.name(thisUnit)) return true end
                end
            end
        end
        if  cast.able.legSweep("target") then
            for i=1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.legSweep(thisUnit) then ui.debug("Interrupt:Leg Sweep "..unit.name(thisUnit)) return true end
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
    debuff                                        = br.player.debuff

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
    enemies.get(8)
    enemies.get(10)
    enemies.get(20)
    enemies.get(30)
    enemies.get(40) -- Makes a varaible called, enemies.yards40
    enemies.get(5,"player",false,true) -- makes enemies.yards5f
    enemies.get(10,"player",false, true)
    enemies.get(20,"player",false,true)
    enemies.get(30,"player",false,true)
    enemies.get(40,"player",false,true)

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
        if actionList.Defensive() then  return true end -- This runs the Defensive Action List and anything in it will run in or out of combat, this generally contains defensive functions.
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
            --Always Maintain Buffs
            if not buff.rushingJadeWind.exists("player") and cast.able.rushingJadeWind() then
                if cast.rushingJadeWind() then ui.debug("Rushing Jade Wind") return true;end;
            end

            if cast.able.chiWave("target") and unit.distance("target") >= 8 then
                if cast.chiWave("target") then ui.debug("Chi Wave") return true; end;
            end

            --Melee Range Attacks
            if unit.distance("target") <= 5 then
                if buff.hitScheme.exists() and buff.hitScheme.stack("player") >= 3 and cast.able.kegSmash("target") then
                    if cast.kegSmash("target") then ui.debug("Proc Hit Scheme: Keg Smash") return true; end;
                end
                if cast.able.celestialBrew() and not buff.celestialBrew.exists("player") then
                    if cast.celestialBrew("player") then ui.debug("Celestial Brew") return true; end;
                end

                --Make sure shuffle is being maintained
                -- +5 sec for Keg Smash, 3 sec for Blackout kick, max 15 sec.
                if (not buff.shuffle.exists() or (buff.shuffle.remains() <= 3)) then
                    if cast.able.kegSmash("target") then
                        if cast.kegSmash("target") then ui.debug("SHUFFLE +5: Keg Smash") return true; end;
                    elseif cast.able.blackoutKick("target") then 
                        if cast.blackoutKick("target") then ui.debug("SHUFFLE +3: Blackout Kick") return true; end;
                    else
                        if cast.able.spinningCraneKick() then
                            if cast.spinningCraneKick() then ui.debug("SHUFFLE PUSH: Spinning Crane Kick") return true; end;
                        end
                    end
                end

                if cast.able.breathOfFire("target") then
                    if cast.breathOfFire("target") then ui.debug("Breath of Fire") return true; end;
                end
                if cast.able.weaponsOfOrder("target") then
                    if cast.weaponsOfOrder("target") then ui.debug("WOE") return true; end;
                end
                if cast.able.risingSunKick("target") then
                    if cast.risingSunKick("target") then ui.debug("Rising Sun Kick") return true; end;
                end
                if cast.able.touchOfDeath("target") then
                    if cast.touchOfDeath("target") then ui.debug("Touch of Death") return true; end;
                end
                if cast.able.summonWhiteTigerStatue("target") then
                    if cast.summonWhiteTigerStatue("target") then ui.debug("White Target Statue") return true; end;
                end
                if cast.able.bonedustBrew("playerGround") then
                    if cast.bonedustBrew("playerGround") then ui.debug("Bone Dust Brew") return true; end;
                end
                if buff.rushingJadeWind.exists("player") and cast.able.explodingKeg("target") then
                    if cast.explodingKeg("target") then ui.debug("Exploding Keg") return true; end;
                end
                -- We need to ocassionally cast a damage spell; but the tigerPalm vs Spinning Crane kick options
                -- Would depend on # of enemies as well as if we need to collect globes.  Not sure we can get the 
                -- # of globes on the ground nearby.
                -- if (ui.mode.rotation == 1 or ui.mode.rotation==2) and 
                --         #enemies.yards8 >= 3 and 
                --         buff.counterStrike.exists() and 
                --         cast.able.spinningCraneKick() then
                --     if cast.spinningCraneKick() then ui.debug("PROC: Spinning Crane Kick") return true; end;
                -- elseif ui.mode.rotation == 3 and buff.counterStrike.exists() and cast.able.tigerPalm("target") then
                --     if cast.tigerPalm("target") then ui.debug("PROC: Tiger Palm") return true; end;
                -- end
                -- if buff.counterStrike.exists() and cast.able.tigerPalm("target") and not cast.last.tigerPalm(2)  then
                --     if cast.tigerPalm("target") then ui.debug("Proc Counterstrike, Tiger Palm") return true; end;
                -- end
                -- if buff.counterStrike.exists() and cast.able.spinningCraneKick() then
                --     if cast.spinningCraneKick() then ui.debug("Spinning Crane Kick") return true; end;
                -- end
                -- if cast.able.tigerPalm("target") then
                --     if cast.tigerPalm("target") then ui.debug("tiger Palm") return true; end;
                -- end
                if cast.able.tigersLust("player") then
                    if cast.tigersLust("player") then ui.debug("tiger's Lust") return true; end;
                end

                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 268 -- Change to the spec id profile is for. Spec ID can be found at: https://wowpedia.fandom.com/wiki/SpecializationID
-- DO NOT EDIT ANYTHING BELOW THIS LINE, WILL BREAK PROFILE --
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
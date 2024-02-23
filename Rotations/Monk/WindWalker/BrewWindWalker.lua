-------------------------------------------------------
-- Author = BrewingCoder
-- Patch = 10.2.5
-- Coverage = 95%
-- Status = Limited
-- Readiness = Development
-------------------------------------------------------
local rotationName = "BrewWindWalker" 

    ---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles, these are the buttons from the toggle bar
    -- Rotation Button
    ---------------
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.whirlwind },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladestorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.ragingBlow },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.touchOfKarma },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.fortifyingBrew },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.touchOfDeath }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.vivify },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.vivify }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.tigersLust },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.tigersLust }
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
        section = br.ui:createSection(br.ui.window.profile,  "General")
            br.ui:createCheckbox(section,"Use Disable")
            br.ui:createCheckbox(section,"Use Rushing Jade Wind")
            br.ui:createCheckbox(section,"Use Touch of Death")
            br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,"Item Use (Not implemented)")
            br.ui:createCheckbox(section,"Deviously Deviled Eggs")
            br.ui:createCheckbox(section,"thousandbone Tongueslicer")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,"AtRange")
            br.ui:createCheckbox(section,"Expel Harm on Approach")
            br.ui:createCheckbox(section,"Jade Lightning to Pull")
            br.ui:createCheckbox(section,"Taunt to pull")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,"Opening Moves")
            br.ui:createCheckbox(section,"Always Drop White Tiger")
            br.ui:createSpinner(section,"White Tiger Targets",1,1,10,1,"|cffFFFFFFMin. Number of targets in range to drop white tiger statue.")
            br.ui:createSpinner(section,"White Tiger Tgt Range",5,5,40,5,"|cffFFFFFFRange to do target count")
            br.ui:createCheckbox(section,"Always do Jadefire Stomp")
            br.ui:createSpinner(section,"Jadefire Stomp Targets",1,1,10,1,"|cffFFFFFFMin. Number of targets in range to do Jadefire Stomp.")
            br.ui:createSpinner(section,"Jadefire Stomp Tgt Range",5,5,40,5,"|cffFFFFFFRange to do target count")
            br.ui:createCheckbox(section,"Always Summon Xeun")
            br.ui:createSpinner(section,"Xeun Targets",1,1,10,1,"|cffFFFFFFMin. Number of targets in range to summon Xeun.")
            br.ui:createSpinner(section,"Xeun Tgt Range",5,5,40,5,"|cffFFFFFFRange to do target count")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,"Tiger Palm")
                br.ui:createCheckbox(section,"use Tiger Palm")
                br.ui:createCheckbox(section,"Power Strikes priority Use")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,"Fists of Fury")
                br.ui:createCheckbox(section,"Use Fists of Fury")
                br.ui:createCheckbox(section,"Transfer the Power Priority Use")
                br.ui:createSpinner(section,"Max Transfer the Power Stacks",1,1,10,1,"|cffFFFFFFMaximum # of Transfer the Power Proc Stacks")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,"Blackout Kick")
                br.ui:createCheckbox(section,"Use Blackout Kick")
                br.ui:createCheckbox(section,"Wait for Teachings of the Monastery")
                br.ui:createCheckbox(section,"But prioritize on Blackout Kick Proc")
        br.ui:checkSectionState(section)

        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
                br.ui:createCheckbox(section,"Use Serenity")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
                br.ui:createCheckbox(section,"Use Detox")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
            br.ui:createCheckbox(section,"Leg Sweep")
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
local has

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
    
    if cast.able.expelHarm() and unit.distance("target") <= 20 then
        if cast.expelHarm() then ui.debug("CAST Expel Harm"); return true; end
    end

    if unit.inCombat() and unit.valid("target") then
        if unit.distance("target") <= 20 and cast.able.expelHarm() and power >= 15 and chi <= 5 then
            if cast.expelHarm() then ui.debug("CAST Expel Harm"); return true; end
        end
        if unit.distance("target") <= 40 and unit.distance("target") >= 10  and cast.able.chiBurst() and chi <= 5 then
            if cast.chiBurst("target") then ui.debug("CAST Chi Burst"); return true; end
        end
    end

end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.checked("Use Detox") and cast.able.detox("player") and cast.dispel.detox("player") then
        if cast.detox("player") then ui.debug("DEFENSIVE: DETOX") return true; end;
    end
    if br.getHP("player") <= 75 and cast.able.touchOfKarma("player") and unit.inCombat() then
        if cast.touchOfKarma("player") then ui.debug("DEFENSE: Touch of Karma") return true; end
    end
    if br.getHP("player") <= 50 and cast.able.fortifyingBrew("player") and unit.inCombat() then
        if cast.fortifyingBrew("player") then ui.debug("DEFENSE: fortifyingBrew") return true; end
    end
end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()
    if ui.useInterrupt() and ui.delay("Interrupts",unit.gcd(true)) then
        local thisUnit
        if ui.checked("Leg Sweep") and cast.able.legSweep() then
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.legSweep() then ui.debug("Interrupt Leg Sweep ") return true end
                end
            end
        end
end -- End Action List - Interrupt

-- Action List - Cooldowns
actionList.Cooldown = function()
    if ui.checked("Use Serenity") and cast.able.serenity() then
        if cast.serenity() then ui.debug("CAST serenity"); return true; end
    end
end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Logic based on pull timers (IE: DBM/BigWigs)
        end -- End Pre-Pull
        if unit.valid("target") then -- Abilities below this only used when target is valid
            if unit.distance("target") <= 40 then
                if cast.able.chiWave() then
                    if cast.chiWave() then ui.debug("RANGE: Chi Wave"); return true; end;
                end 
                if unit.distance("target") >= 6 and not unit.moving() and cast.able.cracklingJadeLightning("target") then
                    if cast.cracklingJadeLightning("target") then ui.debug("RANGE: Crackling Jade Lightning"); return true; end;
                end
            end
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
    chi                                           = br.player.power.chi()
    has                                           = br.player.has

    local validTargets=nil

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
    enemies.get(10)
    enemies.get(15)
    enemies.get(20)
    enemies.get(25)
    enemies.get(30)
    enemies.get(35)
    enemies.get(40) 
    enemies.get(40,"player",false,true)  --enemies.yards40f

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
        

        -- for i=1,#br.player.talent do
        --     ui.debug(br.player.talent[i][0])
        -- end
        --ui.debug("Touch of ascension: " .. tostring(br.player.talent.ascension))
        --ui.debug("Talent SkyTouch: " .. tostring(talent.skytouch))
        --ui.debug("Talent SkyReach: " .. tostring(talent.skyreach))
        if unit.inCombat() and unit.valid("target") and not var.profileStop then 
            if actionList.Interrupt() then return true end -- This runs the Interrupt Action List, this generally contains interrupt functions.
            ------------
            --- Main ---
            ------------

            --- Priority PROCS
           --extended melee range (10 yds with talents on Tiger Palm)
           if unit.distance("target") <= 10 and 
                unit.distance("target") >= 5 
                and cast.able.tigerPalm("target") 
                and (talent.skyreach or talent.skytouch)
                then
                if cast.tigerPalm("target") then ui.debug("TALENT: Skytouch/Skyreach"); return true; end;
           end

            if unit.distance("target") <= 9 and buff.danceOfChiJi.exists() and cast.able.spinningCraneKick() then
                if cast.spinningCraneKick() then ui.debug("PROC: Dance Of Chi-Ji") return true; end;
            end

            if unit.distance("target") <= 9 and cast.able.strikeOfTheWindlord() and chi > 2 then
                if cast.strikeOfTheWindlord() then ui.debug("CAST strike of the windlord"); return true; end
            end

            -- if ui.checked("Xeun on Approach") and
            --      unit.distance("target") <= 40 and 
            --      cast.able.invokeXuenTheWhiteTiger() then
            --         if cast.invokeXuenTheWhiteTiger() then ui.debug("CAST Invoking Xuen") return true; end
            -- end
            

            if ui.checked("Always Summon Xeun") and 
                    cast.able.invokeXuenTheWhiteTiger() then
                        validTargets = nil
                        if ui.value("Xeun Tgt Range") == 5 then validTargets = enemies.yards5; end
                        if ui.value("Xeun Tgt Range") == 10 then validTargets = enemies.yards10; end
                        if ui.value("Xeun Tgt Range") == 15 then validTargets = enemies.yards15; end
                        if ui.value("Xeun Tgt Range") == 20 then validTargets = enemies.yards20; end
                        if ui.value("Xeun Tgt Range") == 25 then validTargets = enemies.yards25; end
                        if ui.value("Xeun Tgt Range") == 30 then validTargets = enemies.yards30; end
                        if ui.value("Xeun Tgt Range") == 35 then validTargets = enemies.yards35; end
                        if ui.value("Xeun Tgt Range") == 40 then validTargets = enemies.yards40; end

                        if (validTargets ~= nil and #validTargets >= ui.value("Xeun Tgt Range")) then
                            if cast.invokeXuenTheWhiteTiger() then ui.debug("CAST: Xeun"); return true; end;
                        end
                end


            -- Melee Range
            if unit.distance("target") <= 5 then
                

                 --Blackout kick priority Proc on Blackout Kick Buff
                 if ui.checked("Blackout Kick") and
                 cast.able.blackoutKick("target") and
                 buff.blackoutKick.exists("player") and
                 ui.checked("But prioritize on Blackout Kick Proc") then
                     if cast.blackoutKick("target") then ui.debug("PROC: Blackout Kick"); return true; end;    
                end

                --White Tiger Statue

                if ui.checked("Always Drop White Tiger") and 
                    cast.able.summonWhiteTigerStatue() then
                        validTargets = nil
                        if ui.value("White Tiger Tgt Range") == 5 then validTargets = enemies.yards5; end
                        if ui.value("White Tiger Tgt Range") == 10 then validTargets = enemies.yards10; end
                        if ui.value("White Tiger Tgt Range") == 15 then validTargets = enemies.yards15; end
                        if ui.value("White Tiger Tgt Range") == 20 then validTargets = enemies.yards20; end
                        if ui.value("White Tiger Tgt Range") == 25 then validTargets = enemies.yards25; end
                        if ui.value("White Tiger Tgt Range") == 30 then validTargets = enemies.yards30; end
                        if ui.value("White Tiger Tgt Range") == 35 then validTargets = enemies.yards35; end
                        if ui.value("White Tiger Tgt Range") == 40 then validTargets = enemies.yards40; end

                        if (validTargets ~= nil and #validTargets >= ui.value("White Tiger Targets")) then
                            if cast.summonWhiteTigerStatue("target") then ui.debug("CAST: White Tiger Statue"); return true; end;
                        end
                end

                if ui.checked("Always do Jadefire Stomp") and
                    --#enemies.yards20 >= ui.value("Jadefile Stomp Targets") and
                    not buff.jadefireStomp.exists() and
                    not cast.last.jadefireStomp(1) and
                    cast.able.jadefireStomp() then
                        validTargets=nil
                        if ui.value("Jadefire Stomp Tgt Range") == 5 then validTargets = enemies.yards5; end
                        if ui.value("Jadefire Stomp Tgt Range") == 10 then validTargets = enemies.yards10; end
                        if ui.value("Jadefire Stomp Tgt Range") == 15 then validTargets = enemies.yards15; end
                        if ui.value("Jadefire Stomp Tgt Range") == 20 then validTargets = enemies.yards20; end
                        if ui.value("Jadefire Stomp Tgt Range") == 25 then validTargets = enemies.yards25; end
                        if ui.value("Jadefire Stomp Tgt Range") == 30 then validTargets = enemies.yards30; end
                        if ui.value("Jadefire Stomp Tgt Range") == 35 then validTargets = enemies.yards35; end
                        if ui.value("Jadefire Stomp Tgt Range") == 40 then validTargets = enemies.yards40; end
                        if(validTargets ~= nil and #validTargets >= ui.value("Jadefire Stomp Targets")) then
                            if cast.jadefireStomp() then ui.debug("CAST Jadefire Stomp"); return true; end;    
                        end
                end
                
                --Disable
                if ui.checked("Use Disable") and not debuff.disable.exists("target") and cast.able.disable() then
                    if cast.disable("target") then ui.debug("MELEE: Disable"); return true; end;
                end

                --priority Tiger Palm
                if ui.checked("Power Strikes priority Use") and buff.powerStrikes.exists() and cast.able.tigerPalm("target") then
                    if cast.tigerPalm("target") then ui.debug("PROC Power Strike: Tiger Palm"); return true; end;
                end

                if ui.checked("Use Fists of Fury") and
                    cast.able.fistsOfFury() and
                    (ui.checked("Transfer the Power Priority Use") and 
                        buff.transferThePower.stack("player") >= ui.value("Max Transfer the Power Stacks")) then
                    if cast.fistsOfFury("target") then ui.debug("PROC transfer the power: Fist of Fury"); return true; end
                end

                if ui.checked("Blackout Kick") and
                ( (ui.checked("Wait for Teachings of the Monastery") and buff.teachingsOfTheMonastery.exists()) or not ui.checked("Wait for Teachings of the Monastery")) and
                cast.able.blackoutKick()
                then
                    if cast.blackoutKick("target") then ui.debug("CAST Blackout Kick"); return true; end;
                end

                if cast.able.risingSunKick("target") then
                    if cast.risingSunKick("target") then ui.debug("CAST Rising Sun Kick"); return true; end
                end
              
                if ui.checked("Use Touch of Death") and cast.able.touchOfDeath("target") then
                    if cast.touchOfDeath("target") then ui.debug("CAST touch of Death"); return true; end;
                end
    
                if cast.able.tigerPalm() and chi < 5 and not (buff.serenity.exists() and cast.last.tigerPalm(1)) then
                    if cast.tigerPalm("target") then ui.debug("Cast Tiger Palm"); return true; end
                end
        
                if ui.checked("Use Rushing Jade Wind") and cast.able.rushingJadeWind() then
                    if cast.rushingJadeWind() then ui.debug("CAST rushingJadeWind"); return true; end;
                end
               
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
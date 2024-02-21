-------------------------------------------------------
-- Author = BrewingCoder
-- Patch = 10.2.5
-- Coverage = 98%
-- Status = Limited
-- Readiness = Development
-------------------------------------------------------
local rotationName = "BrewBK" 

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles, these are the buttons from the toggle bar
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.darkCommand },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.heartStrike },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.iceboundFortitude },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.bloodTap}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)

    local AutoPullModes = {
        [1] = { mode = "On", value =1, overlay = "Auto Pull Enabled", tip = "Auto Pull Enemies", highlight = 1, icon = br.player.spell.deathGrip},
        [2] = { mode = "Off", value = 2, overlay = "Auto Pull Disabled", tip = "Do Not AutoPull Enemies", highlight=0, icon=br.player.spell.deathGrip}
    };
    br.ui:createToggle(AutoPullModes,"Autopull",2,0)

    
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.antiMagicShell },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.deathsAdvance},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.antiMagicShell }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",3,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.lichborne },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.lichborne }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",4,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.mindFreeze }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",5,0)
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
                    br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
                    br.ui:createCheckbox(section, "Auto Engage")
                    br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
                    
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,"Taunting")
            br.ui:createCheckbox(section,"Only Taunt in Instance or Raid")
            br.ui:createSpinner(section,"Taunt Range",30,10,30,10,"|cffFFFFFFSet Range to Taunt")
            br.ui:createCheckbox(section,"Use Dark Command")
            br.ui:createCheckbox(section,"Use Death Grip to Taunt")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Auto Pull more units during combat")
            br.ui:createCheckbox(section, "Only pull trivial enemies")
            br.ui:createCheckbox(section, "Use Death Grip")
            br.ui:createCheckbox(section, "DG only pull from FRONT")
            br.ui:createSpinner(section, "Death Grip Range", 10, 10, 40, 10, "|cffFFFFFFSet Range to auto-pull with DG.  Min: 10 / Max: 40 / Interval: 10")
            br.ui:createCheckbox(section, "Use Deaths Caress to pull")
            br.ui:createCheckbox(section, "DC only pull from FRONT")
            br.ui:createSpinner(section, "Deaths Caress Range",10,10,30,10, "|cffFFFFFFSet Range to auto-pull with DC.  Min: 10 / Max: 30 / Interval: 10")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,"General Combat Spells")
            br.ui:createCheckbox(section,"Allow Deaths Caress at range","|cffFFFFFFAllow casting of Death's Caress on targets at range. Can be used to pull.")
            br.ui:createCheckbox(section,"Liberal Dancing Rune Weapon","|cffFFFFFFAllow casting of Dancing Rune Weapon whenever available.")
            br.ui:createCheckbox(section,"Maintain D&D","|cffFFFFFFAlways maintain D&D at your feet when in combat.")
            br.ui:createCheckbox(section,"Maintain Deaths Caress","|cffFFFFFFAlways maintain a blood plague on current target.(usually handled by D&D but make sure)")
            br.ui:createCheckbox(section,"Empower Rune Weapon")
            br.ui:createCheckbox(section,"Blood Boil")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,"Bone Shield")
            br.ui:createCheckbox(section,"Use Marrowrend")
            br.ui:createSpinner(section,"Use Marrowrend below",6,2,9,1)
            br.ui:createSpinner(section,"Use Deaths Caress below",6,2,9,1)
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,"Raise Dead")
            br.ui:createCheckbox(section,"Use Raise Dead")
            br.ui:createSpinner(section,"RD Min Targets",1,1,10,1,"|cffFFFFFFSet Minimum # of combat targets to use ghoul")
            br.ui:createSpinner(section,"RD Min Distance",5,5,40,5,"|cffFFFFFFSet Minimum distance to target to use ghouls")
            br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,"Tombstone")
            br.ui:createCheckbox(section,"Use Tombstone")
            br.ui:createSpinner(section,"Minimum Boneshield Stack",1,1,10,1,"|cffFFFFFFSet Minimum # of boneshields to have in order to cast tombstone")
            br.ui:createCheckbox(section,"Only in D&D")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,"Death Strike")
            br.ui:createCheckbox(section,"Use Death Strike")
            br.ui:createSpinner(section, "Prioritize Runic Power",90,10,130,10,"|cffFFFFFFPrioritize casting Death Strike if runic power hits this %. (You don't want to cap Runic Power)")
            br.ui:createSpinner(section, "Prioritize For Damage",10,5,50,5,"|cffFFFFFFPrioritize casting on % Damage Taken in last 5 seconds")
            br.ui:createCheckbox(section,"Use in Regular Rotation")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,"Soul Reaper")
            br.ui:createCheckbox(section,"Use Soul Reaper")
            br.ui:createCheckbox(section,"Use only at Pct Health")
            br.ui:createSpinner(section,"Health of Target Pct",30,5,100,5,"|cffFFFFFFPct Health of Target to use Soul Reaper")
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
            br.ui:createCheckbox(section,"Use Anti-Magic Shell")
            br.ui:createCheckbox(section,"Use Vampiric Blood")
            br.ui:createCheckbox(section,"Use Icebound Fortitude")
            br.ui:createCheckbox(section,"Use Lichborne")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Mind Freeze
            br.ui:createCheckbox(section,"Mind Freeze")
            br.ui:createCheckbox(section,"Use Death Grip as Interrupt")
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
local runes
local runicPower

-- Any variables/functions made should have a local here to prevent possible conflicts with other things.

--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------
local actionList = {} -- Table for holding action lists.

-- Action List - Extra
actionList.Extra = function()
    if ui.checked("Use Dark Command") then
        if ui.checked("Only Taunt in Instance or Raid") and not (var.inRaid or var.inInstance) then return false end
        local enemiesList = nil
        if ui.value("Taunt Range") == 30 then enemiesList = enemies.yards30 end
        if ui.value("Taunt Range") == 20 then enemiesList = enemies.yards20 end
        if ui.value("Taunt Range") == 10 then enemiesList = enemies.yards10 end
        if enemiesList ~= nil then
            for i=1,#enemiesList do
                local thisUnit = enemiesList[i]
                if not unit.isTanking(thisUnit) and unit.threat(thisUnit) and not unit.isExplosive(thisUnit) and cast.able.darkCommand(thisUnit) then
                    if cast.darkCommand(thisUnit) then ui.debug("Casting Dark Command [Not Tanking]") return true end
                end
            end
        end
    end

    if ui.checked("Use Death Grip to Taunt") then
        if ui.checked("Only Taunt in Instance or Raid") and not (var.inRaid or var.inInstance) then return false end
        local enemiesList = nil
        if ui.value("Taunt Range") == 30 then enemiesList = enemies.yards30 end
        if ui.value("Taunt Range") == 20 then enemiesList = enemies.yards20 end
        if ui.value("Taunt Range") == 10 then enemiesList = enemies.yards10 end
        if enemiesList ~= nil then
            for i=1,#enemiesList do
                local thisUnit = enemiesList[i]
                if not unit.isTanking(thisUnit) and unit.threat(thisUnit) and not unit.isExplosive(thisUnit) and cast.able.deathGrip(thisUnit) then
                    if cast.deathGrip(thisUnit) then ui.debug("Casting Death Grip [Not Tanking]") return true end
                end
            end
        end
    end
end -- End Action List - Extra


actionList.CombatPull = function ()
    if ui.mode.autopull==1 and unit.inCombat then

        local validTargets = nil
        if cast.able.deathsCaress("target") and ui.checked("Use Deaths Caress to pull") then
            if ui.checked("DC only pull from FRONT") then
                if ui.value("Deaths Caress Range") == 10 then validTargets = enemies.yards10f;end
                if ui.value("Deaths Caress Range") == 20 then validTargets = enemies.yards20f;end
                if ui.value("Deaths Caress Range") == 30 then validTargets = enemies.yards30f;end
            else
                if ui.value("Deaths Caress Range") == 10 then validTargets = enemies.yards10;end
                if ui.value("Deaths Caress Range") == 20 then validTargets = enemies.yards20;end
                if ui.value("Deaths Caress Range") == 30 then validTargets = enemies.yards30;end
            end
            if validTargets ~= nil and #validTargets > 0 then
                for i=1, #validTargets do
                    if not unit.isBoss(validTargets[i]) and  (not unit.inCombat(validTargets[i]) or not unit.threat(validTargets[i])) then
                            if cast.deathsCaress(validTargets[i]) then
                                ui.debug("Pulling target with Death's Caress: " .. validTargets[i])
                                return true
                            end
                    end
                end
            end
        end
        
        validTargets = nil

        if cast.able.deathGrip("target") and ui.checked("Use Death Grip") then
            
            if ui.checked("DG only pull from FRONT") then
                if ui.value("Death Grip Range") == 10 then validTargets = enemies.yards10f;end
                if ui.value("Death Grip Range") == 20 then validTargets = enemies.yards20f;end
                if ui.value("Death Grip Range") == 30 then validTargets = enemies.yards30f;end
                if ui.value("Death Grip Range") == 40 then validTargets = enemies.yards40f;end
            else
                if ui.value("Death Grip Range") == 10 then validTargets = enemies.yards10;end
                if ui.value("Death Grip Range") == 20 then validTargets = enemies.yards20;end
                if ui.value("Death Grip Range") == 30 then validTargets = enemies.yards30;end
                if ui.value("Death Grip Range") == 40 then validTargets = enemies.yards40;end
            end
            if validTargets ~= nil and #validTargets > 0 then
                for i=1, #validTargets do
                    if not unit.isBoss(validTargets[i]) and  (not unit.inCombat(validTargets[i]) or not unit.threat(validTargets[i])) then
                            if cast.deathGrip(validTargets[i]) then
                                ui.debug("Pulling target with Death Grip: " .. validTargets[i])
                                return true
                            end
                    end
                end
            end
        end
    end
end

-- Action List - Defensive
actionList.Defensive = function()


end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()
    if ui.useInterrupt() and ui.delay("Interrupts",unit.gcd(true)) then
        local thisUnit
        if ui.checked("Mind Freeze") and cast.able.mindFreeze("target") then
            for i=1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.mindFreeze(thisUnit) then ui.debug("Casting Mind Freeze on "..unit.name(thisUnit)) return true end
                end
            end
        end
        if ui.checked("Use Death Grip as Interrupt") and cast.able.deathGrip("target") then
            for i=1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.deathGrip(thisUnit) then ui.debug("Casting Death Grip Interrupt on "..unit.name(thisUnit)) return true end
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
            if unit.distance("target") <= 30 then
                if cast.able.deathsCaress("target") then
                    if cast.deathsCaress("target") then ui.debug("[Pre-Combat] pull w/death's caress") return true end
                end
            end
            if unit.distance("target") <= 40 then
                if cast.able.deathGrip("target") then
                    if cast.deathGrip("target") then ui.debug("[Pre-Combat] pull w/Death Grip") return true end
                end
            end
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
    runes                                         = br.player.power.runes()
    runicPower                                    = br.player.power.runicPower()
    var.inRaid                                    = br.player.instance=="raid"

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
            if actionList.Interrupt() then return true end

            --------------------
            ---In Combat Pull---
            --------------------
            if actionList.CombatPull() then return true end


            ------------
            --- Main ---
            ------------
           

            --Distance Combat
            if unit.distance("target") <= 30 and not unit.isDummy("target") and not unit.isBoss("target") then

                --Ensure blood plague
                if not debuff.bloodPlague.exists("target") and 
                    ui.checked("Allow Deaths Caress at range") and
                    cast.able.deathsCaress("target") and runes > 0 then
                    if cast.deathsCaress("target") then ui.debug("Cating Death's Caress"); return true end
                end
                
                --Dancing Rune weap
                if cast.able.dancingRuneWeapon("target") and
                   ui.checked("Liberal Dancing Rune Weapon") then
                    if cast.dancingRuneWeapon("target") then ui.debug("Dancing Rune Weapon") return true; end
                end

            end

            -- raise dead
            if ui.checked("Use Raise Dead") and
                cast.able.raiseDead() and
                unit.distance("target") <= ui.value("RD Min Distance") and
                #enemies.yards30f >= ui.value("RD Min Targets") then
                    if cast.raiseDead() then ui.debug("Casting Raise Dead") return true; end
            end

            -- Death and Decay
            if  ui.checked("Maintain D&D") and
                cast.able.deathAndDecay("playerGround") and 
                not buff.deathAndDecay.exists() and 
                runes > 0 then
                    if cast.deathAndDecay("playerGround") then ui.debug("Death and Decay Maintain") return true; end
            end

            --  Tombstone
            if talent.tombstone and
                ui.checked("Use Tombstone") and
                buff.boneShield.stack("player") > ui.value("Minimum Boneshield Stack") and
                ((buff.deathAndDecay.exists() and ui.checked("Only in D&D")) or (not ui.checked("Only in D&D")))and
                cast.able.tombstone() then
                    if cast.tombstone() then ui.debug("Casting Tombstone") return true; end
            end

            -- Maintain Blood Plague via Deaths Caress
            if ui.checked("Maintain Deaths Caress") and
                not debuff.bloodPlague.exists("target") and
                cast.able.deathsCaress("target") and
                runes > 0 then
                    if cast.deathsCaress("target") then ui.debug("Cating Death's Caress"); return true end
            end



            -- Melee range attacks
            if unit.distance("target") <= 5 then
                
                --Priority Cast of Death Strike if Runic Power is close to capping or we need health
                local priority_power = (runicPower >= ui.value("Prioritize Runic Power"))
                local priority_health = (br.getHPLossPercent("player",5) >= ui.value("Prioritize For Damage"))
                if ui.checked("Use Death Strike") and
                     (priority_power or priority_health) and
                    cast.able.deathStrike("target") then
                        if priority_health then ui.debug("DS PRIORITY: Health") end
                        if priority_power then  ui.debug("DS PRIORITY:  Runic Power") end
                        if cast.deathStrike("target") then return true; end
                end

                --Soul Reaper, see if we can catch target at right health
                if ui.checked("Use Soul Reaper") and
                    cast.able.soulReaper("target") then
                    if ui.checked("Use only at Pct Health") then
                        if br.getHP("target") <= ui.value("Health of Target Pct") then
                            if cast.soulReaper("target") then
                                ui.debug("Casting Soul Reaper at Pct: " .. br.getHP("target"))
                                return true
                            end
                        end
                    else
                        if cast.soulReaper("target") then
                            ui.debug("Casting Soul Reaper")
                            return true
                        end
                    end
                end
                
                if ui.checked("Use Marrowrend") and buff.boneShield.stack("player") <= ui.value("Use Marrowrend below")
                    and cast.able.marrowrend("target") then
                        if cast.marrowrend("target") then
                            ui.debug("Casting Marrowrend")
                            return true
                        end    
                    end

                if ui.checked("Empower Rune Weapon") and cast.able.empowerRuneWeapon() then
                    if cast.empowerRuneWeapon() then
                        ui.debug("Casting Empower Rune Weapon")
                        return true
                    end
                end
                if ui.checked("Blood Boil") and cast.able.bloodBoil() then
                    if cast.bloodBoil() then
                        ui.debug("Casting Blood Boil")
                        return true;
                    end
                end
                
                if cast.able.deathStrike("target") and buff.ossuary.exists() and runicPower >= 35 then
                    if cast.deathStrike("target") then
                        ui.debug("Casting Death Strike")
                        return true;
                    end
                end
                
                if cast.able.heartStrike("target") and runes >= 1 then
                    if cast.heartStrike("target") then
                        ui.debug("Casting Heart Strike")
                        return true;
                    end
                end

                if (runes < 3 and charges.bloodTap.count() > 1) or (runes < 1 and charges.bloodTap.count()==1) and cast.able.bloodTap()  then
                    ui.debug("casting Blood Tap")
                    if cast.bloodTap() then
                        ui.debug("Casting Blood Tap")
                        return true
                    end
                end
                if cast.able.autoAttack("target") and unit.distance("target") <= 5 then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 250 
-- DO NOT EDIT ANYTHING BELOW THIS LINE, WILL BREAK PROFILE --
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
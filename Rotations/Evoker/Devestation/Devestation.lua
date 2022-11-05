local rotationName = "Devestation"
local rotationVersion = "0.0.1"

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles, these are the buttons from the toggle bar
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.blazingBarrier},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.blizzard},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.fireball},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.slowFall}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.timewarp},
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.combustion},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.slowFall}
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.blazingBarrier},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.slowFall}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterspell},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.slowFall}
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
        br.ui:createCheckbox(section, "Start Combat", "|cffFFFFFFStart Combat")
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
-- Variables --
    local var = {}
    local facingUnits = 0
    local unit
    local ui
    local spell
    local talent
    local buff
    local cast
    local cd
    local charges
    local debuff
    local debug
    local enemies
    local falling, swimming, flying, moving
    local inCombat
    local inInstance
    local inRaid
    local manaPercent
    local mode
    local module
    local moving
    local php
    local pullTimer
    local racial
    local thp
    local ttd
    local units
    local use
    local playerCasting
    local cl
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
        if ui.useInterrupt() and cd.quell.remain() == 0 and talent.quell then
            if not playerCasting then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i].unit
                    if br.canInterrupt(thisUnit, br.getOptionValue("Interrupt At")) then
                        if cast.quell(thisUnit) then
                            return
                        end
                    end
                end
            end
        end
end -- End Action List - Interrupt

-- Action List - Cooldowns
    actionList.Cooldowns = function()
        if br.useCDs() and br.getDistance("target") < 40 then

        end -- End br.useCDs check
end -- End Action List - Cooldowns

-- Action List - Pre-Combat
    actionList.PreCombat = function()
        if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
            if unit.valid("target") and br.isChecked("Start Combat") then -- Abilities below this only used when target is valid
                -- Start Attack
                if unit.distance("target") < 5 then -- Starts attacking if enemy is within 5yrds
                    if cast.able.autoAttack("target") then
                        if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                    end
                end
            end
        end -- End No Combat
end -- End Action List - PreCombat

-- Action List - SingleTarget
    actionList.SingleTarget = function()
    -- SINGLETARGET
        -- Tip the Scales
        if cd.tipTheScales.remains() = 0 and unit.isBoss("target") and thp >= 5 then
            if cast.tipTheScales("player") then ui.debug("Casting: Tip the Scales") return true end
        end
        -- Dragonrage at 20 stacks of Charged Blast
        if buff.chargedBlast.stacks("player") == 20 then
            if cast.dragonrage("target") then ui.debug ("Casting: Dragonrage") return true end
        end 
        -- Shattering Star (if selected)
        if talent.shatteringStar and cd.shatteringStar.remains() == 0 then
            if cast.shatteringStar("target") then ui.debug ("Casting: Shattering Star") return true end
        end
        -- Eternity Surge (Emp 1:2 Targets)
        if talent.eternitySurge and cd.eternitySurge.remains() == 0 then
                if cast.eternitySurge("target") then ui.debug ("Casting: Eternity Surge 1") return true end
        end
        -- Fire Breath (Level 1 Empower) and maintain debuff
        -- Use Level 3 Empower when the target will die within 12 seconds.
        if unit.ttd("target") >= 12 and cd.fireBreath.remains() == 0 then --EMP 3
            if cast.fireBreath("target") then ui.debug ("Casting: Fire Breath 3") return true end
        elseif unit.ttd("target") <= 11  and cd.fireBreath.remains() == 0 --EMP 1
            if cast.fireBreath("target") then ui.debug ("Casting:  Fire Breath 1") return true end
        end
        -- Disintegrate with Essence Burst
        if buff.essenceBurst.exists() then
            if cast.disintigrate("target") then ui.debug ("Casting:  Disintigrate") return true end
        end
        -- Living Flame with Burnout
        if talent.burnout and buff.burnout.exists() then
            if cast.livingFlame("target") then ui.debug ("Casting:  Living Flame") return true end
        end
        -- Azure Strike only during Dragonrage to generate Essence Burst
        if buff.dragonrage.exists() then
            if cast.azureStrike("target") then ui.debug ("Casting:  Azure Strike") return true end
        end
        -- Disintegrate
        if not debuff.disintigrate.exists("target") then
            if cast.disintigrate("target") then ui.debug ("Casting:  Disintigrate") return true end
        end
        -- Living Flame without Burnout
        if not talent.burnout then
            if cast.livingFlame("target") then ui.debug ("Casting:  Living Flame") return true end
        end
end -- End Action List - SingleTarget
-- Action List - AOE
actionList.AOE = function()
    --AOE
        if #Enemies.yards8t() >= 3 and cd.firestorm.remains() == 0 then
            if cast.firestorm("target") then
                br._G.SpellStopTargeting()
                debug("Casting: Firestorm") 
                return true 
            end
        end
        -- Tip the Scales
        if cd.tipTheScales.remains() = 0 and unit.isBoss("target") and thp >= 5 then
            if cast.tipTheScales("player") then ui.debug("Casting: Tip the Scales") return true end
        end
        -- Shattering Star (if selected)
        if talent.shatteringStar and cd.shatteringStar.remains() == 0 then
            if cast.shatteringStar("target") then ui.debug ("Casting: Shattering Star") return true end
        end
        -- Fire Breath
        if unit.ttd("target") >= 12 then --EMP 3
            if cast.fireBreath("target") then ui.debug ("Casting: Fire Breath 3") return true end
        elseif unit.ttd("target") <= 11 --EMP 1
            if cast.fireBreath("target") then ui.debug ("Casting:  Fire Breath 1") return true end
        end
        -- Dragonrage at 20 stacks of Charged Blast
        if buff.chargedBlast.stacks("player") == 20 then
            if cast.dragonrage("target") then ui.debug ("Casting: Dragonrage") return true end
        end 
        -- Pyre at 20 stacks of Charged Blast; if Dragonrage is on cooldown.
        if buff.chargedBlast.stacks("player") == 20 and cd.dragonrage.remains() >= 1 then
            if cast.pyre("target") then ui.debug ("Casting: Pyre") return true end
        end 
        -- Eternity Surge (Empower level can change depending on the amount of targets)
        -- With Eternity's Span talent: Empower Level 1: 2 Targets, 2: 4 Targets, 3: 6 Targets
        if talent.eternitySurge and cd.eternitySurge.remains() == 0 then
            if #Enemies.yards8t <= 3 then  --EMP 1
                if cast.eternitySurge("target") then ui.debug ("Casting: Eternity Surge 1") return true end
            elseif #Enemies.yards8t <= 5 then --EMP 2
                if cast.eternitySurge("target") then ui.debug ("Casting: Eternity Surge 2") return true end
            elseif #Enemies.yards8t <= 6 then --EMP 3
                if cast.eternitySurge("target") then ui.debug ("Casting: Eternity Surge 3") return true end
            end
        end
        -- Fire Breath (Level 3 Empower)
        if  cd.fireBreath.remains() == 0 then
            if cast.fireBreath("target") then ui.debug ("Casting: Fire Breath 3") return true end
        end
        -- Disintegrate with Essence Burst
        if buff.essenceBurst.exists() then
            if cast.disintigrate("target") then ui.debug ("Casting:  Disintigrate") return true end
        end
        -- Living Flame with Burnout
        if talent.burnout and buff.burnout.exists() then
            if cast.livingFlame("target") then ui.debug ("Casting:  Living Flame") return true end
        end
        -- Disintegrate
        if not debuff.disintigrate.exists("target") then
            if cast.disintigrate("target") then ui.debug ("Casting:  Disintigrate") return true end
        end
        -- Azure Strike only during Dragonrage to generate Essence Burst
        if buff.dragonrage.exists() then
            if cast.azureStrike("target") then ui.debug ("Casting:  Azure Strike") return true end
        end
        -- Living Flame without Burnout
        if not talent.burnout then
            if cast.livingFlame("target") then ui.debug ("Casting:  Living Flame") return true end
        end
end -- End Action List - AOE

----------------
--- ROTATION ---
----------------
local function runRotation() -- This is the main profile loop, any below this point is ran every cycle, everything above is ran only once during initialization.
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals - These are the same as the locals above just defined for use.
    buff                                          = br.player.buff
    unit                                          = br.player.unit
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    debuff                                        = br.player.debuff
    debug                                         = br.addonDebug
    enemies                                       = br.player.enemies
    falling, swimming, flying, moving             = br.getFallTime(), IsSwimming(), IsFlying(), br._G.GetUnitSpeed("player")>0
    inCombat                                      = br.player.inCombat
    inInstance                                    = br.player.instance=="party"
    inRaid                                        = br.player.instance=="raid"
    manaPercent                                   = br.player.power.mana.percent()
    mode                                          = br.player.ui.mode
    module                                        = br.player.module
    moving                                        = br.isMoving("player")     
    php                                           = br.player.health
    pullTimer                                     = br.DBM:getPulltimer()
    racial                                        = br.player.getRacial()
    spell                                         = br.player.spell
    talent                                        = br.player.talent
    thp                                           = br.getHP("target")
    ttd                                           = br.getTTD
    units                                         = br.player.units
    use                                           = br.player.use
    ui                                            = br.player.ui
    cl                                            = br.read

    -- Explanations on the Units and Enemies functions can be found in System/API/Units.lua and System/API/Enemies.lua
    -------------
    --- Units ---
    -------------
    units.get(5)            -- Makes a variable called, units.dyn5
    units.get(40)           -- Makes a variable called, units.dyn40

    ---------------
    --- Enemies ---
    ---------------
    enemies.get(5)          -- Makes a varaible called, enemies.yards5
    enemies.get(40)         -- Makes a varaible called, enemies.yards40
    enemies.get(6,"target") -- makes enemies.yards6t
    enemies.get(8,"target") -- makes enemies.yards8t
    enemies.get(40,"target") -- makes enemies.yards40t

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
            if actionList.Extra() then return true end -- This runs the Extra Action List and anything in it will run in or out of combat, this generally contains utility functions.
        --- Defensive ---
            if actionList.Defensive() then return true end -- This runs the Defensive Action List and anything in it will run in or out of combat, this generally contains defensive functions.
        --- Pre-Combat ---
            if actionList.PreCombat() then return true end  -- This runs the Pre-Combat Action List and anything in it will run in or out of combat, this generally includes functions that prepare for or start combat.
        --- In Combat ---
            if unit.inCombat() and unit.valid("target") and not var.profileStop then -- Everything below this line only run if you are in combat and the selected target is validated and not triggered to stop.
            --- Interrupts ---
                if actionList.Interrupt() then return true end -- This runs the Interrupt Action List, this generally contains interrupt functions.
            --- Cooldowns ---
                if actionList.Cooldowns() then return true end
            --- Combat ---
                if #enemies.yards8t <= 2 then
                    if actionList.SingleTarget() then return true end
                else
                    if actionList.AOE() then return true end
                end  
            ----------------------
                --- Main ---
            -- Start Attack - This will start auto attacking your target if it's within 5yrds and valid
            if unit.distance("target") <= 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 1467 -- Change to the spec id profile is for. Spec ID can be found at: https://wowpedia.fandom.com/wiki/SpecializationID
-- DO NOT EDIT ANYTHING BELOW THIS LINE, WILL BREAK PROFILE --
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
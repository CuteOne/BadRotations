local rotationName = "Fiery"
local rotationVersion = "0.0.1"

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles, these are the buttons from the toggle bar
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.phoenixFlames},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.flamestrike},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.fireball},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.slowFall}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.timeWarp},
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
local covenant
-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
local function calcDamage(spellID, unit)
    local spellPower = GetSpellBonusDamage(5)
    local spMod
    local dmg = 0
    return dmg * (1 + ((GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100))
end

local function calcHP(unit)
    local thisUnit = unit.unit
    local hp = br._G.UnitHealth(thisUnit)
    if br.unlocked then
        local castID, _, castTarget = br._G.UnitCastID("player")
        if castID and castTarget and br.GetUnitIsUnit(unit, castTarget) and playerCasting then
            hp = hp - calcDamage(castID, unit)
        end
        for k, v in pairs(spell.abilities) do
            if br.InFlight.Check(v, thisUnit) then
                hp = hp - calcDamage(v, unit)
            end
        end
    end
    return hp
end


--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------
local actionList = {} -- Table for holding action lists.
-- Action List - Extra
    actionList.Extra = function()

end -- End Action List - Extra

-- Action List - Defensive
    actionList.Defensive = function()
        if not buff.blazingBarrier.exists("player") and php < 60 then
            if cast.blazingBarrier("player") then debug("Blazing Barrier UP") return true end
        end

        if not buff.arcaneIntellect.exists("player") then
            if cast.arcaneIntellect("player") then debug("Arcane Intellect UP") return true end
        end
    
end -- End Action List - Defensive

-- Action List - Interrrupt
    actionList.Interrupt = function()
        if ui.useInterrupt() and cd.counterspell.remain() == 0 then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i].unit
                if br.canInterrupt(thisUnit, br.getOptionValue("Interrupt At")) then
                     if cast.counterspell(thisUnit) then
                         return
                    end
                end
            end
        end
end -- End Action List - Interrupt

-- Action List - Cooldowns
    actionList.Cooldowns = function()
        if br.useCDs() and br.getDistance("target") < 40 then
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
            if (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "Blood Elf") and buff.combustion.exists("player") then
                if br.castSpell("player",racial,false,false,false) then return end
            end
            -- Trinkets
            if buff.combustion.exists("player") then 
                if br.canUseItem(13) then
                    if br._G.UnitCastingInfo("player") then
                        br._G.SpellStopCasting()
                    end
                    br.useItem(13)
                    br.addonDebug("Using Trinket 1")
                    return
                end

                if br.canUseItem(14) then
                    if br._G.UnitCastingInfo("player") then
                        br._G.SpellStopCasting()
                    end
                    br.useItem(14)
                    br.addonDebug("Using Trinket 2")
                    return
                end
            end
            -- Rune of Power
            if not buff.runeOfPower.exists("player") and cd.runeOfPower.remains() == 0 and not moving then
                if cast.runeOfPower("target") then debug("Rune Of Power") return true end
            end

            if cd.mirrorImage.remains() then
                if cast.mirrorImage() then debug("Boss: Mirror Image") return true end
            end

            if cd.timeWarp.remains() == 0 and not debuff.temporalDisplacement.exists("player") then
                if cast.timeWarp() then debug("Boss: Time Warp") return true end
            end
            if covenant.kyrian.active and not buff.combustion.react() then 
                if cast.radiantSpark("target") then debug("Radiant Spark") return true end 
            end
            if cd.meteor.remains() == 0 then
                if cast.meteor("target") then
                    br._G.SpellStopTargeting()
                    debug("meteor - Multitarget") 
                    return true 
                end
            end
        end -- End br.useCDs check
end -- End Action List - Cooldowns

-- Action List - Pre-Combat
    actionList.PreCombat = function()
        if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
            if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
                -- Logic based on pull timers (IE: DBM/BigWigs)
            end -- End Pre-Pull
            if unit.valid("target") then -- Abilities below this only used when target is valid
                -- Start Attackwd
                if unit.distance("target") < 5 then -- Starts attacking if enemy is within 5yrds
                    if cast.able.autoAttack("target") then
                        if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                    end
                end
            end
        end -- End No Combat
end -- End Action List - PreCombat

-- Action List - Combat
    actionList.Combat = function()
        -- If SunkingsBlessing is available - force casted pyro to get combustion
        if buff.sunKingsBlessings.exists("player") and not buff.hotStreak.react() then
            if cast.pyroblast("target") then debug("Pyro - SunKings Blessing") return true end
        end
        -- If target Close and AlexstrazasFury is talented - force Dragonbreath to get 100% crit.
        if talent.alexstraszasFury and (not buff.combustion.react() and not buff.hotStreak.react()) and br.getDistance("target") <= 8 then
            if cast.dragonsBreath("player") then debug("Dragon's Breath to get HotStreak") return true end
        end
        -- If hostStreak is available and below / equal 3 enemies -> instant pyro
        if buff.hotStreak.react() and #enemies.yards8t <= 3 then
            if cast.pyroblast("target") then debug("Instant Pyro - SingleTarget") return true end
        end
        -- If hostStreak is available and above / equal 4 enemies -> instant flamestrike
        if buff.hotStreak.react() and #enemies.yards8t >= 4 then
            if cast.flamestrike("target") then
                br._G.SpellStopTargeting()
                debug("Instant Flamestrike - Multitarget") 
                return true 
            end
        end
        -- 
        if cd.meteor.remains() == 0 and (buff.combustion.exists() or cd.combustion.remains() >= 40) and #enemies.yards8t >= 3 then
            if cast.meteor("target") then
                br._G.SpellStopTargeting()
                debug("meteor - Multitarget") 
                return true 
            end
        end
        -- if none of the buffs is available, neither fireBlast or phoenixFlames are available, not moving -> cast fireball
        if not buff.heatingUp.react() and not buff.hotStreak.react() and charges.phoenixFlames.count() == 0 and charges.fireBlast.count() == 0 and thp > 30 then
            if cast.fireball("target") then debug("Fireball as last resort 2.0") return true end
        end
        -- if none of the buffs is available
        if not buff.heatingUp.react() and not buff.hotStreak.react() and thp > 30 then
            if charges.fireBlast.count() == 0 then
                if charges.phoenixFlames.count() == 0 then      
                    if cast.fireball("target") then debug("fireball as last resort 2.0") return true end
                end
                if cast.phoenixFlames("target") then debug("phoenixFlames as last resort 2.0") return true end
            end
            if cast.fireBlast("target") then debug("fireBlast as last resort 2.0") return true end
        end
        if not buff.heatingUp.react() and not buff.hotStreak.react() and thp < 30 then
            if charges.fireBlast.count() == 0 then
                if charges.phoenixFlames.count() == 0 then      
                    if cast.scorch("target") then debug("scorch as last resort 2.0") return true end
                end
                if cast.phoenixFlames("target") then debug("phoenixFlames as last resort 2.0") return true end
            end
            if cast.fireBlast("target") then debug("fireBlast as last resort 2.0") return true end
        end
        -- if none of the buffs is available, neither fireBlast or phoenixFlames are available, not moving -> cast fireball
        if not buff.heatingUp.react() and not buff.hotStreak.react() and charges.phoenixFlames.count() == 0 and charges.fireBlast.count() == 0 and thp <= 30 then
            if cast.scorch("target") then debug("Scorch as last resort 2.0") return true end
        end        
        -- If heatingUp is available - and fireblast as well -> force crit for insta pyro
        if buff.heatingUp.react() and charges.fireBlast.count() >= 1 then
            if cast.fireBlast("target") then debug("Fire Blast to get 2nd Crit") return true end
        end
        -- If heatingUp is available - and fireblast not -> check phoenix flame and try force crit for insta pyro
        if buff.heatingUp.react() and charges.fireBlast.count() == 0 then 
            if charges.phoenixFlames.count() >= 1 then
                if cast.phoenixFlames() then debug("Casting Phoenix Flames to try and get 2nd Crit") return true end
            elseif charges.phoenixFlames.count() == 0 then
                if cast.fireball("target") then debug("Fireball to try and get 2nd Crit") return true 
            end
        end
        -- if none of the buffs is available, above 30% hp current target, fireBlast available -> use fireBlast or if phoenixFlame available -> use phoenixFlame
        if not buff.heatingUp.react() and not buff.hotStreak.react() and thp > 30 and charges.fireBlast.count() >= 1 then
            if cast.fireBlast("target") then debug("Fire Blast to get 2nd Crit") return true end
        elseif not buff.heatingUp.exists() and not buff.hotStreak.react() and thp > 30 and charges.phoenixFlames.count() >= 1 then
            if cast.phoenixFlames("target") then debug("PhoenixFlames to get 2nd Crit") return true end
        end
        -- if none of the buffs is available, below 30% hp current target, not moving -> cast scorch
        if not buff.heatingUp.react() and not buff.hotStreak.react() and thp <= 30 then
            if cast.scorch() then br.addonDebug("Casting Scorch below 30%") return true end
        end
        -- if none of the buffs is available, below 30% hp current target, moving, phoenixFlames available -> use phoenixFlame
        if not buff.heatingUp.react() and not buff.hotStreak.react() and charges.phoenixFlames.count() >= 1 then
            if cast.phoenixFlames() then br.addonDebug("Casting Phoenix Flames while moving") return true end
        end
        -- if none of the buffs is available, neither fireBlast or phoenixFlames are available, not moving -> cast fireball
        if not buff.heatingUp.react() and not buff.hotStreak.react() and charges.phoenixFlames.count() == 0 and charges.fireBlast.count() == 0 then
            if cast.fireball("target") then debug("Fireball as last resort") return true end
        end

end -- End Action List - Combat
end -- End Action Lists
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
        covenant                                      = br.player.covenant

    -- Explanations on the Units and Enemies functions can be found in System/API/Units.lua and System/API/Enemies.lua

    --- Units ---
        units.get(5)            -- Makes a variable called, units.dyn5
        units.get(40)           -- Makes a variable called, units.dyn40


    --- Enemies ---

        enemies.get(5)              -- Makes a varaible called, enemies.yards5
        enemies.get(40)             -- Makes a varaible called, enemies.yards40
        enemies.get(6,"target")     -- makes enemies.yards6t
        enemies.get(8,"target")     -- makes enemies.yards8t
        enemies.get(40,"target")    -- makes enemies.yards40t

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
        if unit.inCombat() and unit.valid("target") and not var.profileStop then -- Everything below this line only run if you are in combat and the selected target is validated and not triggered to stop.w

            if actionList.Interrupt() then return true end
            if actionList.Cooldowns() then return true end
            if actionList.Combat() then return true end
            --debug("no Combat required, is this correct?")
            ------------
            --- Main ---
            ------------
            -- Start Attack - This will start auto attacking your target if it's within 5yrds and valid
            if unit.distance("target") <= 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 63 -- Change to the spec id profile is for. Spec ID can be found at: https://wowpedia.fandom.com/wiki/SpecializationID
-- DO NOT EDIT ANYTHING BELOW THIS LINE, WILL BREAK PROFILE --
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
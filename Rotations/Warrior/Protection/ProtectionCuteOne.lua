-------------------------------------------------------
-- Author = CuteOne
-- Patch = 9.2.5
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 100%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Limited
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Basic
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --
-------------------------------------------------------

local rotationName = "CuteOne" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local createToggles = function() -- Define custom toggles, these are the buttons from the toggle bar
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.revenge },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.revenge },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.devastate },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.avatar },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.avatar },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.avatar }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.lastStand },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.lastStand }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.pummel },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
    -- Movement Button
    local MoverModes = {
        [1] = { mode = "On", value = 1 , overlay = "Mover Enabled", tip = "Will use Charge/Heroic Leap.", highlight = 1, icon = br.player.spell.charge },
        [2] = { mode = "Off", value = 2 , overlay = "Mover Disabled", tip = "Will NOT use Charge/Heroic Leap.", highlight = 0, icon = br.player.spell.charge }
    };
    br.ui:createToggle(MoverModes,"Mover",5,0)
end

---------------
--- OPTIONS ---
---------------
local createOptions = function()
    local optionTable

    local rotationOptions = function()
        local section
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Battle Cry
            br.ui:createCheckbox(section, "Battle Shout")
            -- Berserker Rage
            br.ui:createCheckbox(section,"Berserker Rage", "Check to use Berserker Rage")
            -- Charge
            br.ui:createCheckbox(section,"Charge", "Check to use Charge")
			-- Heroic Throw
            br.ui:createCheckbox(section,"Heroic Throw", "Check to use Heroic Throw out of range")
            -- Intervene
            br.ui:createCheckbox(section,"Intervene", "Check to use Intervene")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            local alwaysCdAoENever = {"Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never"}
            -- Flask Up Module
            br.player.module.FlaskUp("Agility", section)
            -- Racial
            br.ui:createDropdownWithout(section, "Racial", alwaysCdAoENever, 4, "|cffFFFFFFWhen to use Racial.")
            -- Basic Trinkets Module
            br.player.module.BasicTrinkets(nil, section)
            -- Avatar
            br.ui:createDropdownWithout(section, "Avatar", alwaysCdAoENever, 4, "|cffFFFFFFWhen to use Avatar.")
            -- Dragon Roar
            br.ui:createDropdownWithout(section, "Dragon Roar", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Dragon Roar.")
            -- Last Stand
            br.ui:createDropdownWithout(section, "Last Stand", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Last Stand.")
            -- Ravager
            br.ui:createDropdownWithout(section, "Ravager", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Ravager.")
            -- Covenant
            br.ui:createDropdownWithout(section, "Covenant", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Covenant Ability.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            local defTooltip = "|cffFFBB00Health Percentage to use at."
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Ignore Pain
            br.ui:createSpinner(section, "Ignore Pain", 60, 0, 100, 5, defTooltip)
            -- Intimidating Shout
            br.ui:createSpinner(section, "Intimidating Shout",  60,  0,  100,  5,  defTooltip)
            -- Rallying Cry
            br.ui:createSpinner(section, "Rallying Cry",  60,  0,  100,  5, defTooltip)
            -- Shield Wall
            br.ui:createSpinner(section, "Shield Wall",  60,  0,  100,  5,  defTooltip)
            -- Shockwave
            br.ui:createSpinner(section, "Shockwave",  60,  0,  100,  5,  defTooltip)
            -- Victory Rush
            br.ui:createSpinner(section, "Victory Rush", 60, 0, 100, 5, defTooltip)
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Pummel
            br.ui:createCheckbox(section,"Pummel")
            -- Intimidating Shout
            br.ui:createCheckbox(section,"Intimidating Shout - Int")
            -- Storm Bolt Logic
            br.ui:createCheckbox(section, "Storm Bolt Logic", "Stun specific Spells and Mobs")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section,  "Interrupt At",  70,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Mover Toggle
            br.ui:createDropdownWithout(section,  "Mover Mode", br.dropOptions.Toggle,  6)
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
local covenant
local enemies
local module
local race
local rage
local runeforge
local talent
local ui
local unit
local units
local var

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
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Battle Shout
    if ui.checked("Battle Shout") and cast.able.battleShout() then
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            if not unit.deadOrGhost(thisUnit) and unit.distance(thisUnit) < 100 and buff.battleShout.remain(thisUnit) < 600 then
                if cast.battleShout() then ui.debug("Casting Battle Shout") return true end
            end
        end
    end
    -- Berserker Rage
    if ui.checked("Berserker Rage") and cast.able.berserkerRage() and cast.noControl.berserkerRage() then
        if cast.berserkerRage() then ui.debug("Casting Berserker Rage") return true end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        local useDefensive = function(op)
            return unit.inCombat() and unit.hp() <= ui.value(op)
        end
        -- Basic Healing Module
        module.BasicHealing()
        -- Defensive Stance
        if ui.checked("Defensive Stance") and cast.able.defensiveStance() then
            if useDefensive("Defensive Stance") and not buff.defensiveStance.exists() then
                if cast.defensiveStance() then ui.debug("Casting Defensive Stance") return end
            elseif buff.defensiveStance.exists() and unit.hp() > ui.value("Defensive Stance") then
                if cast.defensiveStance() then debug("Casting Defensive Stance") return end
            end
        end
        -- Die By The Sword
        if ui.checked("Die By The Sword") and cast.able.dieByTheSword() and useDefensive("Die By The Sword") then
            if cast.dieByTheSword() then debug("Casting Die By The Sword") return end
        end
        -- Ignore Pain
        if ui.checked("Ignore Pain") and cast.able.ignorePain() and useDefensive("Ignore Pain") and rage >= 40 then
            if cast.ignorePain() then ui.debug("Casting Ignore Pain") return true end
        end
        -- Intimidating Shout
        if ui.checked("Intimidating Shout") and cast.able.intimidatingShout() and useDefensive("Intimidating Shout") then
            if cast.intimidatingShout() then ui.debug("Casting Intimidating Shout") return true end
        end
        -- Rallying Cry
        if ui.checked("Rallying Cry") and cast.able.rallyingCry() and useDefensive("Rallying Cry") then
            if cast.rallyingCry() then ui.debug("Casting Rallying Cry") return true end
        end
        -- Shield Wall
        if ui.checked("Shield Wall") and cast.able.shieldWall() and useDefensive("Shield Wall") then
            if cast.shieldWall() then ui.debug("Casting Shield Wall") return true end
        end
        -- Shockwave
        if ui.checked("Shockwave") and cast.able.shockwave("player","cone",1,10) and useDefensive("Shockwave") then
            if cast.shockwave("player","cone",1,10) then ui.debug("Casting Shockwave") return true end
        end
        -- Spell Reflection
        if ui.checked("Spell Reflection") and cast.able.spellReflection() and useDefensive("Spell Relection") then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (cast.timeRemain(thisUnit) < 5 or cast.inFlight.spellReflection(thisUnit)) then
                    if cast.spellReflection() then ui.debug("Casting Spell Reflection") return true end
                end
            end
        end
        -- Storm Bolt
        if ui.checked("Storm Bolt") and cast.able.stormBolt() and useDefensive("Storm Bolt") then
            if cast.stormBolt() then ui.debug("Casting Storm Bolt") return true end
        end
        -- Victory Rush
        if ui.checked("Victory Rush") and (cast.able.victoryRush() or cast.able.impendingVictory())
            and unit.inCombat() and buff.victorious.exists()
        then
            for i = 1, #enemies.yards5f do
                local thisUnit = enemies.yards5f[i]
                if unit.hp() <= ui.value("Victory Rush") or buff.victorious.remain() < unit.gcd(true) or unit.ttd(thisUnit) < unit.gcd(true) then
                    if talent.impendingVictory then
                        if cast.impendingVictory(thisUnit) then ui.debug("Casting Impending Victory") return true end
                    else
                        if cast.victoryRush(thisUnit) then ui.debug("Casting Victory Rush") return true end
                    end
                end
            end
        end
    end -- End Defensive Check
end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        for i=1, #enemies.yards20 do
            local thisUnit = enemies.yards20[i]
            local distance = unit.distance(thisUnit)
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                -- Pummel
                if ui.checked("Pummel") and cast.able.pummel(thisUnit) and distance < 5 then
                    if cast.pummel(thisUnit) then ui.debug("Casting Pummel") return true end
                end
                -- Intimidating Shout
                if ui.checked("Intimidating Shout - Int") and cast.able.intimidatingShout() and distance < 8 then
                    if cast.intimidatingShout() then ui.debug("Casting Intimidating Shout [Int]") return true end
                end
                -- Storm Bolt
                if ui.checked("Storm Bolt - Int") and cast.able.stormBolt(thisUnit) and distance < 20 then
                    if cast.stormBolt(thisUnit) then ui.debug("Casting Storm Bolt [Int]") return true end
                end
            end
        end
    end
end -- End Action List - Interrupt

-- Action List - Aoe
actionList.Aoe = function()
    -- Ravager
    -- ravager
    if ui.alwaysCdAoENever("Ravager",3,8) and cast.able.ravager("best",nil,1,8) then
        if cast.ravager("best",nil,1,8) then ui.debug("Casting Ravager [AOE]") return true end
    end
    -- Dragon Roar
    -- dragon_roar
    if ui.alwaysCdAoENever("Dragon Roar",3,8) and cast.able.dragonRoar("player","aoe",1,8) then
        if cast.dragonRoar("player","aoe",1,8) then ui.debug("Casting Dragon Roar [AOE]") return true end
    end
    -- Revenge
    -- revenge
    if cast.able.revenge("player","cone",1,8) then
        if cast.revenge("player","cone",1,8) then ui.debug("Casting Revenge [AOE]") return true end
    end
    -- Thunder Clap
    -- thunder_clap
    if cast.able.thunderClap("player","aoe",1,8) then
        if cast.thunderClap("player","aoe",1,8) then ui.debug("Casting Thunder Clap [AOE]") return true end
    end
    -- Shield Slam
    -- shield_slam
    if cast.able.shieldSlam() then
        if cast.shieldSlam() then ui.debug("Casting Shield Slam [AOE]") return true end
    end
end -- End Action List - Aoe

-- Action List - Generic
actionList.Generic = function()
    -- Ravager
    -- ravager
    if ui.alwaysCdAoENever("Ravager",3,8) and cast.able.ravager("best",nil,1,8) then
        if cast.ravager("best",nil,1,8) then ui.debug("Casting Ravager [ST]") return true end
    end
    -- Dragon Roar
    -- dragon_roar
    if ui.alwaysCdAoENever("Dragon Roar",3,8) and cast.able.dragonRoar("player","aoe",1,8) then
        if cast.dragonRoar("player","aoe",1,8) then ui.debug("Casting Dragon Roar [ST]") return true end
    end
    -- Execute
    -- execute
    if cast.able.execute() and unit.hp(units.dyn5) < 20 then
        if cast.execute() then ui.debug("Casting Execute [ST]") return true end
    end
    -- Shield Slam
    -- shield_slam
    if cast.able.shieldSlam() then
        if cast.shieldSlam() then ui.debug("Casting Shield Slam [ST]") return true end
    end
    -- Thunder Clap
    -- thunder_clap,if=buff.outburst.down
    if cast.able.thunderClap("player","aoe",1,8) and (not buff.outburst.exists()) then
        if cast.thunderClap("player","aoe",1,8) then ui.debug("Casting Thunder Clap [ST]") return true end
    end
    -- Revenge
    -- revenge
    if cast.able.revenge("player","cone",1,8) then
        if cast.revenge("player","cone",1,8) then ui.debug("Casting Revenge [ST]") return true end
    end
    -- Devastate
    -- devastate
    if cast.able.devastate() and not talent.devastator then
        if cast.devastate() then ui.debug("Casting Devastate [ST]") return true end
    end
end -- End Action List - Generic

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Logic based on pull timers (IE: DBM/BigWigs)
        end -- End Pre-Pull
        if unit.valid("target") then -- Abilities below this only used when target is valid
            -- Flask
            -- flask
            module.FlaskUp("Agility")
            -- Conqueror's Banner
            -- conquerors_banner
            if ui.alwaysCdAoENever("Covenant",3,8) and covenant.necrolord.active and cast.able.conquerorsBanner() and ui.useCDs() then
                if cast.conquerorsBanner() then ui.debug("Casting Conqueror's Banner [Pre-Combat]") return true end
            end
            -- Fleshcraft
            -- fleshcraft
            -- if cast.able.fleshcraft() then
            --     if cast.fleshcraft() then return end
            -- end
            -- Charge
            if ui.mode.mover == 1 and ui.checked("Charge") and cast.able.charge("target") then
                if cast.charge("target") then ui.debug("Casting Charge [Pre-Combat]") return true end
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
    buff        = br.player.buff
    cast        = br.player.cast
    cd          = br.player.cd
    covenant    = br.player.covenant
    enemies     = br.player.enemies
    module      = br.player.module
    race        = br.player.race
    rage        = br.player.power.rage.amount()
    runeforge   = br.player.runeforge
    talent      = br.player.talent
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    var         = br.player.variables

    -- Explanations on the Units and Enemies functions can be found in System/API/Units.lua and System/API/Enemies.lua
    -------------
    --- Units ---
    -------------
    units.get(5)
    units.get(8)
    units.get(8,true)
    ---------------
    --- Enemies ---
    ---------------
    enemies.get(5)
    enemies.get(5,"player",false,true) -- makes enemies.yards5f
    enemies.get(8)
    enemies.get(8,"target")
    enemies.get(8,"player",false,true) -- makes enemies.yards8f
    enemies.get(20)

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
            -- Start Attack - This will start auto attacking your target if it's within 5yrds and valid
            if unit.distance("target") <= 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack") return true end
                end
            end
            -- Charge
            -- charge,if=time=0
            if ui.mode.mover == 1 and ui.checked("Charge") and cast.able.charge(units.dyn5) then
                if cast.charge(units.dyn5) then ui.debug("Casting Charge") return true end
            end
            -- heroic_charge,if=buff.revenge.down&(rage<60|rage<44&buff.last_stand.up)
            -- if cast.able.heroicCharge() and (not buff.revenge.exists() and (rage < 60 or rage < 44 and buff.lastStand.exists())) then
            --     if cast.heroicCharge() then return end
            -- end
            -- Intervene
            -- intervene,if=buff.revenge.down&(rage<80|rage<77&buff.last_stand.up)&runeforge.reprisal
            if ui.mode.mover == 1 and ui.checked("Intervene") and cast.able.intervene("target") and unit.friend("target")
                and (not buff.revenge.exists() and (rage < 80 or rage < 77 and buff.lastStand.exists()) and runeforge.reprisal.equiped)
            then
                if cast.intervene("target") then ui.debug("Casting Intervene") return true end
            end
            -- Trinkets
            -- use_items,if=cooldown.avatar.remains<=gcd|buff.avatar.up
            if (cd.avatar.remains() <= unit.gcd(true) or buff.avatar.exists()) then
                module.BasicTrinkets()
            end
            -- Racials
            -- blood_fury,if=buff.avatar.up
            -- berserking,if=buff.avatar.up
            -- fireblood,if=buff.avatar.up
            -- ancestral_call,if=buff.avatar.up
            if ui.alwaysCdAoENever("Racial",3,8) and cast.able.racial() and buff.avatar.exists()
                and (race == "Orc" or race == "Troll" or race == "DarkIronDwarf" or race == "MagharOrc")
            then
                if cast.racial() then ui.debug("Casting Racial") return true end
            end
            -- Thunder Clap
            -- thunder_clap,if=buff.outburst.up&((buff.seeing_red.stack>6&cooldown.shield_slam.remains>2))
            if cast.able.thunderClap("player",1,8) and (buff.outburst.exists() and ((buff.seeingRed.stack() > 6 and cd.shieldSlam.remain() > 2))) then
                if cast.thunderClap("player",1,8) then ui.debug("Casting Thunder Clap") return true end
            end
            -- Avatar
            -- avatar,if=buff.outburst.down
            if ui.alwaysCdAoENever("Avatar",3,8) and cast.able.avatar() and (not buff.outburst.exists()) then
                if cast.avatar() then ui.debug("Casting Avatar") return true end
            end
            -- potion,if=buff.avatar.up|target.time_to_die<25
            -- if cast.able.potion() and (buff.avatar.exists() or ttd() < 25) then
            --     if cast.potion() then return end
            -- end
            -- Conqueror's Banner
            -- conquerors_banner
            if ui.alwaysCdAoENever("Covenant",3,8) and covenant.necrolord.active and cast.able.conquerorsBanner() then
                if cast.conquerorsBanner() then ui.debug("Casting Conqueror's Banner") return true end
            end
            -- Revenge
            -- revenge,if=buff.revenge.up&(target.health.pct>20|spell_targets.thunder_clap>3)&cooldown.shield_slam.remains
            if cast.able.revenge("player","cone",1,8) and (buff.revenge.exists() and (unit.hp(units.dyn5) > 20 or ui.useAOE(8,4)) and cd.shieldSlam.remain()) then
                if cast.revenge("player","cone",1,8) then ui.debug("Casting Revenge") return true end
            end
            -- Ignore Pain
            -- ignore_pain,if=target.health.pct>=20&(target.health.pct>=80&!covenant.venthyr)&(rage>=85&cooldown.shield_slam.ready&buff.shield_block.up|rage>=60&cooldown.demoralizing_shout.ready&talent.booming_voice.enabled|rage>=70&cooldown.avatar.ready|rage>=40&cooldown.demoralizing_shout.ready&talent.booming_voice.enabled&buff.last_stand.up|rage>=55&cooldown.avatar.ready&buff.last_stand.up|rage>=80|rage>=55&cooldown.shield_slam.ready&buff.outburst.up&buff.shield_block.up|rage>=30&cooldown.shield_slam.ready&buff.outburst.up&buff.last_stand.up&buff.shield_block.up),use_off_gcd=1
            if cast.able.ignorePain() and (unit.hp(units.dyn5) >= 20 and (unit.hp(units.dyn5) >= 80 and not covenant.venthyr.active)
                and (rage >= 85 and not cd.shieldSlam.exists() and buff.shieldBlock.exists() or rage >= 60 and not cd.demoralizingShout.exists()
                and talent.boomingVoice or rage >= 70 and not cd.avatar.exists() or rage >= 40 and not cd.demoralizingShout.exists()
                and talent.boomingVoice and buff.lastStand.exists() or rage >= 55 and not cd.avatar.exists() and buff.lastStand.exists() or rage >= 80 or rage >= 55
                and not cd.shieldSlam.exists() and buff.outburst.exists() and buff.shieldBlock.exists() or rage >= 30 and not cd.shieldSlam.exists()
                and buff.outburst.exists() and buff.lastStand.exists() and buff.shieldBlock.exists()))
            then
                if cast.ignorePain() then ui.debug("Casting Ignore Pain") return true end
            end
            -- Shield Block
            -- shield_block,if=(buff.shield_block.down|buff.shield_block.remains<cooldown.shield_slam.remains)&target.health.pct>20
            if cast.able.shieldBlock() and ((not buff.shieldBlock.exists() or buff.shieldBlock.remain() < cd.shieldSlam.remain()) and unit.hp(units.dyn5) > 20) then
                if cast.shieldBlock() then ui.debug("Casting Shield Block") return true end
            end
            -- Last Stand
            -- last_stand,if=target.health.pct>=90|target.health.pct<=20
            if ui.alwaysCdAoENever("Last Stand") and cast.able.lastStand() and (unit.hp(units.dyn5) >= 90 or unit.hp(units.dyn5) <= 20) then
                if cast.lastStand() then ui.debug("Casting Last Stand") return true end
            end
            -- Demoralizing Shout
            -- demoralizing_shout,if=talent.booming_voice.enabled&rage<60
            if cast.able.demoralizingShout() and (talent.boomingVoice and rage < 60) then
                if cast.demoralizingShout() then ui.debug("Casting Demoralizing Shout") return true end
            end
            -- Shield Slam
            -- shield_slam,if=buff.outburst.up&rage<=55
            if cast.able.shieldSlam() and (buff.outburst.exists() and rage <= 55) then
                if cast.shieldSlam() then ui.debug("Casting Shield Slam") return true end
            end
            -- Action List - Aoe
            -- run_action_list,name=aoe,if=spell_targets.thunder_clap>3
            if ui.useAOE(8,4) then
                if actionList.Aoe() then return end
            end
            -- Action List - Generic
            -- call_action_list,name=generic
            if actionList.Generic() then return end
            -- Racials
            -- bag_of_tricks
            -- arcane_torrent,if=rage<80
            -- lights_judgment
            if ui.alwaysCdAoENever("Racial",3,8) and cast.able.racial()
                and ((race == "BloodElf" and rage < 80) or race == "Nightborne" or race == "LightforgedDraenei")
            then
                if race == "LightforgedDraenei" then
                    if cast.racial("target","ground") then ui.debug("Casting Racial") return true end
                else
                    if cast.racial("player") then ui.debug("Casting Racial") return true end
                end
            end
            -- Heroic Throw
            if ui.checked("Heroic Throw") and cast.able.heroicThrow() then
                if cast.heroicThrow() then ui.debug("Casting Heroic Throw") return true end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 73 -- Change to the spec id profile is for. Spec ID can be found at: https://wowpedia.fandom.com/wiki/SpecializationID
-- DO NOT EDIT ANYTHING BELOW THIS LINE, WILL BREAK PROFILE --
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
local rotationName = "Daemon" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles, these are the buttons from the toggle bar
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.curseOfTongues },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.felstorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.axeToss },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.eyeOfKilrogg}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.ritualOfDoom },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.darkPact },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.eyeOfKilrogg }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.unendingResolve },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.eyeOfKilrogg }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.axeToss },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.eyeOfKilrogg }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
    --Pet summon
    local PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Felguard", tip = "Summon Felguard", highlight = 1, icon = br.player.spell.summonFelguard },
        [2] = { mode = "2", value = 2 , overlay = "Imp", tip = "Summon Imp", highlight = 1, icon = br.player.spell.summonImp },
        [3] = { mode = "3", value = 3 ,overlay = "Voidwalker", tip = "Summon Voidwalker", highlight = 1, icon = br.player.spell.summonVoidwalker },
        [4] = { mode = "4", value = 4 , overlay = "Felhunter", tip = "Summon Felhunter", highlight = 1, icon = br.player.spell.summonFelhunter },
        [5] = { mode = "5", value = 5 , overlay = "Succubus", tip = "Summon Succubus", highlight = 1, icon = br.player.spell.summonSuccubus },
        [6] = { mode = "None", value = 6 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.conflagrate }
    };
    br.ui:createToggle(PetSummonModes,"PetSummon",5,0)
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
    local shards
    local activePet
    local activePetId
    local pet
    local wildImps

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
        if not inInstance and not inRaid and (not buff.soulstone.exists("player") or buff.soulstone.remain("player") < 100) and not inCombat and not moving then
            if cast.soulstone("player") then
                return
            end
        end
        if not moving and not inCombat then
            if GetItemCount(5512) < 1 and br.timer:useTimer("CH", math.random(2,3.96)) then
                 if cast.createHealthstone() then br.addonDebug("Casting Create Healthstone" ) return true end
            end
        end
end -- End Action List - Extra

-- Action List - Defensive
    actionList.Defensive = function()

end -- End Action List - Defensive

-- Action List - Interrrupt
    actionList.Interrupt = function()
        if br.useInterrupts() and (activePetId == 17252 or activePetId == 58965) then
            for i=1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if br.canInterrupt(thisUnit,br.getOptionValue("Interrupt At")) then
                    if (activePetId == 17252 or activePetId == 58965) then
                        if cast.axeToss(thisUnit) then return true end
                    end
                end
            end
        end 
end -- End Action List - Interrupt

-- Action List - Cooldowns
    actionList.Cooldown = function()

end -- End Action List - Cooldowns

-- Action List - Pets
    actionList.Pets = function()

        if ((mode.petSummon == 1 and not IsPetActive()) or (mode.petSummon == 1 and activePetId ~= 58965)) and not cast.last.summonWrathguard() then
            if cast.summonWrathguard() then br.addonDebug("Summon Wrathguard") return true end
        end

        if ((mode.petSummon == 2 and not IsPetActive()) or (mode.petSummon == 2 and activePetId ~= 416)) and not cast.last.summonImp() then
            if cast.summonImp() then br.addonDebug("Summon Imp") return true end
        end

        if ((mode.petSummon == 3 and not IsPetActive()) or (mode.petSummon == 3 and activePetId ~= 1860)) and not cast.last.summonVoidwalker() then
            if cast.summonVoidwalker() then br.addonDebug("Summon Voidwalker") return true end
        end

        if ((mode.petSummon == 4 and not IsPetActive()) or (mode.petSummon == 4 and activePetId ~= 417)) and not cast.last.summonFelhunter() then
            if cast.summonFelhunter() then br.addonDebug("Summon Felhunter") return true end
        end

        if ((mode.petSummon == 5 and not IsPetActive()) or (mode.petSummon == 5 and activePetId ~= 1863)) and not cast.last.summonSuccubus() then
            if cast.summonSuccubus() then br.addonDebug("Summon Succubus") return true end
        end  

        if unit.inCombat() and unit.valid("target") and not UnitAffectingCombat("pet") and unit.distance("target") <= 40 then
            br._G.RunMacroText("/petattack")
        end

end -- End Action List - Pets

-- Action List - SingleTarget
    actionList.SingleTarget = function()
        var.DemonBoltCasttime = select(4,GetSpellInfo(spell.demonbolt))
        --Nether Portal on cooldown
        if cd.netherPortal.remain() == 0 and unit.isBoss("target") and thp >= 3 then
            if cast.netherPortal("target") then ui.debug("Nether Portal get the Party started") return true end
        end
        --Demonic Strength on cooldown
        if cd.demonicStrength.remain() == 0 and ((unit.isBoss("target") and thp >= 3) or thp >= 50) then
            if cast.demonicStrength() then ui.debug("Demonic Strength") return true end
        end
        --Grimoire: Felguard on cooldown,, if playing  Summon Demonic Tyrant, cast as often as possible before Tyrant
        if talent.grimoireFelguard and cd.grimoireFelguard.remain() == 0 and unit.isBoss("target") and thp >= 3 then
            if cast.grimoireFelguard() then ui.debug("Grimoire Felguard") return true end
        end
        --Demonbolt only when you have  Demonic Core procs
        if var.DemonBoltCasttime == 0 or buff.demonicCore.react() then 
            if cast.demonbolt("target") then ui.debug("Demonbolt") return true end
        end
        --Soul Strike as much as possible, when it will generate a  Soul Shards
        if talent.soulStrike and (activePetId == 17252 or activePetId == 58965) and cd.soulStrike.remain() == 0 and shards <= 4 then
            if cast.soulStrike("target") then ui.debug("Soul Strike to generate Shard") return true end
        end
        --Call Dreadstalkers
        if cd.callDreadstalkers.remain() == 0 and ((unit.isBoss("target") and thp >= 3) or thp >= 15) then
            if cast.callDreadstalkers("target") then ui.debug("Call Dreadstalkers") return true end
        end
        --Hand of Gul'dan
        if shards >= 1 then
            if cast.handOfGuldan("target") then ui.debug("Hand Of Guldan") return true end
        end
        --Shadow Bolt
        if shards < 1 then
            if cast.shadowBolt("target") then ui.debug("Shadow Bolt") return true end
        end
        --Summon Demonic Tyrant with as many demons summoned possible
        if wildImps >= 5 and cd.summonDemonicTyrant.remain() == 0 and unit.isBoss("target") and thp >= 5 then
            if cast.summonDemonicTyrant("target") then ui.debug("Summon Demonic Tyrant") return true end
        end

end -- End Action List - SingleTarget

-- Action List - MultiTarget
    actionList.MultiTarget = function()
        --Nether Portal on cooldown
        if cd.netherPortal.remain() == 0 and unit.isBoss("target") and thp >= 3 then
            if cast.netherPortal("target") then ui.debug("Nether Portal get the Party started") return true end
        end
        --Demonic Strength on cooldown
        if cd.demonicStrength.remain() == 0 and ((unit.isBoss("target") and thp >= 3) or thp >= 50) then
            if cast.demonicStrength() then ui.debug("Demonic Strength") return true end
        end
        --Grimoire: Felguard on cooldown
        if talent.grimoireFelguard and cd.grimoireFelguard.remain() == 0 and unit.isBoss("target") and thp >= 3 then
            if cast.grimoireFelguard() then ui.debug("Grimoire Felguard") return true end
        end
        --Felstorm on cooldown
            -- auto executed by pet
        --Demonbolt only when you have  Demonic Core procs
        if var.DemonBoltCasttime == 0 or buff.demonicCore.react() then 
            if cast.demonbolt("target") then ui.debug("Demonbolt") return true end
        end
        --Call Dreadstalkers
        if cd.callDreadstalkers.remain() == 0 and ((unit.isBoss("target") and thp >= 3) or thp >= 15) then
            if cast.callDreadstalkers("target") then ui.debug("Call Dreadstalkers") return true end
        end
        --Hand of Gul'dan
        if shards >= 1 then
            if cast.handOfGuldan("target") then ui.debug("Hand Of Guldan") return true end
        end
        --Summon Demonic Tyrant with as many demons summoned possible
        if wildImps >= 5 and cd.summonDemonicTyrant.remain() == 0 and unit.isBoss("target") and thp >= 5 then
            if cast.summonDemonicTyrant("target") then ui.debug("Summon Demonic Tyrant") return true end
        end
        --Shadow Bolt
        if shards < 1 then
            if cast.shadowBolt("target") then ui.debug("Shadow Bolt") return true end
        end
end -- End Action List - MultiTarget

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
        shards                                        = br.player.power.soulShards.frac()
        pet                                           = br.player.pet.list
        activePet                                     = br.activePet
        activePetId                                   = br.player.petId
        wildImps                                      = 0
        if pet ~= nil then
            for k, v in pairs(pet) do
                local thisUnit = pet[k] or 0
                if thisUnit.id == 55659 and not br.GetUnitIsDeadOrGhost(thisUnit.unit) then
                    wildImps = wildImps + 1
                end
            end
        end
    -- Explanations on the Units and Enemies functions can be found in System/API/Units.lua and System/API/Enemies.lua
    -------------
    --- Units ---
    -------------
    units.get(5)                -- Makes a variable called, units.dyn5
    units.get(8)                -- Makes a variable called, units.dyn40
    units.get(40)               -- Makes a variable called, units.dyn40

    ---------------
    --- Enemies ---
    ---------------
    enemies.get(5)              -- Makes a varaible called, enemies.yards5
    enemies.get(8)              -- Makes a varaible called, enemies.yards8
    enemies.get(30)             -- Makes a varaible called, enemies.yards30
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

        --- Extras ---
            if actionList.Extra() then return true end -- This runs the Extra Action List and anything in it will run in or out of combat, this generally contains utility functions.
            if actionList.Pets() then return true end
        --- Defensive ---
            if actionList.Defensive() then return true end -- This runs the Defensive Action List and anything in it will run in or out of combat, this generally contains defensive functions.
        --- Pre-Combat ---
            if actionList.PreCombat() then return true end  -- This runs the Pre-Combat Action List and anything in it will run in or out of combat, this generally includes functions that prepare for or start combat.
        --- In Combat ---
            if unit.inCombat() and unit.valid("target") and not var.profileStop then -- Everything below this line only run if you are in combat and the selected target is validated and not triggered to stop.
                --- Interrupts ---
                if actionList.Interrupt() then return true end -- This runs the Interrupt Action List, this generally contains interrupt functions.
                --- Main ---
                if actionList.Cooldown() then return true end
                -- Start Attack - This will start auto attacking your target if it's within 5yrds and valid
                br._G.RunMacroText("/petattack")
                if unit.distance("target") <= 5 then
                    if cast.able.autoAttack("target") then
                        if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                    end
                end
                if #enemies.yards8t <= 3 then
                    if actionList.SingleTarget() then return true end
                elseif #enemies.yards8t >= 4 then
                    if actionList.MultiTarget() then return true end
                end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 266 -- Change to the spec id profile is for. Spec ID can be found at: https://wowpedia.fandom.com/wiki/SpecializationID
-- DO NOT EDIT ANYTHING BELOW THIS LINE, WILL BREAK PROFILE --
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
<<<<<<< HEAD
local rotationName = "Mage Initial" -- Change to name of profile listed in options drop down
=======
local rotationName = "Overlord"
>>>>>>> parent of 075af4d79... Revert "Mage Initial"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
<<<<<<< HEAD
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.frostbolt },
        [2] = {  mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.frostbolt }
    };
    CreateButton("Rotation",1,0)
end
=======
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.frostBolt },
        [2] = {  mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.frostBolt }
    };
    CreateButton("Rotation",1,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.frostNova},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.frostNova}
    };
    CreateButton("Defensive",2,0)
end

>>>>>>> parent of 075af4d79... Revert "Mage Initial"
---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
<<<<<<< HEAD
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General - 20201021")
        br.ui:createCheckbox(section, "Arcane Intellect")
        br.ui:createSpinner(section, "Arcane Explosion Units", 2, 1, 10, 1, "|cffFFB000 Number of adds to cast Arcane Explosion")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Interrupt Percentage
            br.ui:createCheckbox(section, "Counterspell")
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
=======
        local section
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")

        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")

        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")

>>>>>>> parent of 075af4d79... Revert "Mage Initial"
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
<<<<<<< HEAD
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local buff
local cast
local cd
local debuff
local enemies
local equiped
local gcd
local gcdMax
local has
local inCombat
local item
local level
local mode
local php
local spell
local talent
local units
local use
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
local hastar
local healPot
local profileStop
local ttd
local playerCasting
local manaPercent
-- Profile Specific Locals - Any custom to profile locals
local actionList = {}
local deadtar, attacktar, hastar, playertar
local solo

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------

--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------
-- Action List - Interrrupt
actionList.Interrupt = function()
    if useInterrupts() then
        for i=1, #enemies.yards40 do
            thisUnit = enemies.yards40[i]
            if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                if isChecked("Counterspell") then
                    if cast.counterspell(thisUnit) then return end
                end
            end
        end
    end
end -- End Action List - Interrupt

-- Action List - Pre-Combat
actionList.PreCombat = function()
--Arcane Intellect
    if isChecked("Arcane Intellect") and br.timer:useTimer("Arcane Intellect Delay", math.random(15, 30)) then
        for i = 1, #br.friend do
            if level >= 8 and cast.able.arcaneIntellect() and not buff.arcaneIntellect.exists(br.friend[i].unit,"any") and getDistance("player", br.friend[i].unit) < 40 and not UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsPlayer(br.friend[i].unit) then
                if cast.arcaneIntellect() then return true end
            end
        end
    end
=======
-- BR API Locals
local cast
local cd
local debuff
local has
local mode
local ui
local pet
local spell
local unit
local units
local use
-- General Locals
local haltProfile
local profileStop
-- Profile Specific Locals
local actionList = {}

--------------------
--- Action Lists ---
--------------------
-- Action List - Defensive
actionList.Defensive = function()
    --Frost Nova
    if unit.hp() < 95 then
        if spell.known.frostNova() and cast.able.frostNova and unit.distance(units.dyn5) < 5 then
            if cast.frostNova() then ui.debug("Casting Frost Nova") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()

>>>>>>> parent of 075af4d79... Revert "Mage Initial"
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    debuff                                        = br.player.debuff
<<<<<<< HEAD
    enemies                                       = br.player.enemies
    equiped                                       = br.player.equiped
    gcd                                           = br.player.gcd
    gcdMax                                        = br.player.gcdMax
    has                                           = br.player.has
    inCombat                                      = br.player.inCombat
    item                                          = br.player.items
    level                                         = br.player.level
    mode                                          = br.player.ui.mode
    php                                           = br.player.health
    spell                                         = br.player.spell
    talent                                        = br.player.talent
    units                                         = br.player.units
    use                                           = br.player.use
    manaPercent                                   = br.player.power.mana.percent()
    playerCasting                                 = UnitCastingInfo("player")
    deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
    solo                                          = #br.friend == 1
    -- General Locals
    hastar                                        = GetObjectExists("target")
    healPot                                       = getHealthPot()
    profileStop                                   = profileStop or false
    ttd                                           = getTTD
    haltProfile                                   = (inCombat and profileStop) or (IsMounted() or IsFlying()) or pause() or mode.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(10) -- Makes a variable called, units.dyn10
    units.get(40) -- Makes a variable called, units.dyn40
    -- Enemies
    enemies.get(5)  -- Makes a varaible called, enemies.yards5
    enemies.get(10) -- Makes a varaible called, enemies.yards10
    enemies.get(40) -- Makes a varaible called, enemies.yards40

    -- Profile Specific Locals

    -- SimC specific variables

=======
    has                                           = br.player.has
    mode                                          = br.player.ui.mode
    ui                                            = br.player.ui
    pet                                           = br.player.pet
    spell                                         = br.player.spell
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    -- General Locals
    profileStop                                   = profileStop or false
    haltProfile                                   = (unit.inCombat() and profileStop) or IsMounted() or pause() or mode.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40,true)

    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = GetTime() end
>>>>>>> parent of 075af4d79... Revert "Mage Initial"

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
<<<<<<< HEAD
    if not inCombat and not hastar and profileStop then
        profileStop = false
    elseif haltProfile then
=======
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        br.pauseTime = GetTime()
>>>>>>> parent of 075af4d79... Revert "Mage Initial"
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
<<<<<<< HEAD
=======
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
>>>>>>> parent of 075af4d79... Revert "Mage Initial"
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
<<<<<<< HEAD
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if mode.rotation ~=2 and inCombat or isDummy() and isValidUnit("target") and cd.global.remain() == 0 then
            -- Start Attack
            -- actions=auto_attack
            --Frostbolt
            if cast.able.frostbolt("target") then
                if cast.frostbolt("target") then return true end
            end
            --FireBlast
            if level >= 2 and cast.able.fireBlast("target") then
                if cast.fireBlast("target") then return true end
            end
            if level >= 3 and getDistance("target") < 12 and not isBoss("target") then
                if cast.frostNova("player") then return true end
            end
            if level >= 10 and isMoving("player") then
                if cast.iceLance("target") then return true end
            end
            if level >= 6 and cast.able.arcaneExplosion() and getDistance("target") <= 10 and manaPercent > 30 and #enemies.yards10 >= getOptionValue("Arcane Explosion Units") then
                CastSpellByName(GetSpellInfo(spell.arcaneExplosion))
            end

            if not IsAutoRepeatSpell(GetSpellInfo(6603)) and getDistance(units.dyn5) < 5 then
                StartAttack(units.dyn5)
            end
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupt() then return true end
        end -- End In Combat Rotation
    end -- Pause
    return true
end -- End runRotation
local id = 1449
=======
            --Arcane Intellect
            if spell.known.arcaneIntellect() and cast.able.arcaneIntellect() and not buff.arcaneIntellect.exists("player") then
                if cast.arcaneIntellect() then ui.debug("Casting Arcane Intellect") return true end
            end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        -- Check for combat
        if unit.valid("target") and cd.global.remain() == 0 then
            if unit.distance(units.dyn40) < 40 then
                ------------------------------
                --- In Combat - Interrupts ---
                ------------------------------
                -- Start Attack
                -- actions=auto_attack
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) and unit.distance(units.dyn5) < 5 then
                    StartAttack(units.dyn5)
                end
                --Arcane Explosion
                if spell.known.arcaneExplosion() and cast.able.arcaneExplosion() then
                    if cast.arcaneExplosion("player","aoe",1,10) then ui.debug("Casting Arcane Explosion") return true end
                end
                --Fire Blast
                if spell.known.fireBlast() and cast.able.fireBlast() and unit.distance(units.dyn40) then
                    if cast.fireBlast() then ui.debug("Casting Fire Blast") return true end
                end
                --Frost Bolt
                if spell.known.frostBolt() and cast.able.frostBolt(units.dyn40) and not unit.moving() then
                    if cast.frostBolt() then ui.debug("Casting Frost Bolt") return true end
                end
                --Counterspell Interrupt
                if canInterrupt() then
                    if spell.known.counterspell() and cast.able.counterspell() and unit.distance(units.dyn40) then
                        if cast.counterspell() then ui.debug("Casting Counterspell") return true end
                    end
                end
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 1449 -- Change to the spec id profile is for.
>>>>>>> parent of 075af4d79... Revert "Mage Initial"
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
<<<<<<< HEAD
})
=======
}) 
>>>>>>> parent of 075af4d79... Revert "Mage Initial"

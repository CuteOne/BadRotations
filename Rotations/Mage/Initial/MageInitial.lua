local rotationName = "Mage Initial" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.frostbolt },
        [2] = {  mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.frostbolt }
    };
    CreateButton("Rotation",1,0)
end
---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
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


    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop then
        profileStop = false
    elseif haltProfile then
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
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
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

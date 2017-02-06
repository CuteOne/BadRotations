local rotationName = "Kuukuu" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.beaconOfLight },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.beaconOfLight },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.holyShock },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.blessingOfSacrifice}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.holyAvenger},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.auraMastery},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.absolution}
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.divineProtection},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.blessingOfProtection}
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.hammerOfJustice},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.hammerOfJustice}
    };
    CreateButton("Interrupt",4,0)
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
        section = br.ui:createSection(br.ui.window.profile,  "General")
        --    br.ui:createCheckbox(section, "Boss Helper")
            --Cleanse
        --    br.ui:createCheckbox(section, "Cleanse")
        --Beacon of Light
            br.ui:createCheckbox(section, "Beacon of Light")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        --Hammer of Justice
            br.ui:createCheckbox(section, "Hammer of Justice")
        -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        ---- SINGLE TARGET ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
            --Flash of Light
            br.ui:createSpinner(section, "Flash of Light",  30,  0,  100,  5,  "Health Percent to Cast At")
            --Holy Light
            br.ui:createSpinner(section, "Holy Light",  85,  0,  100,  5,  "Health Percent to Cast At")
            --Holy Shock
            br.ui:createSpinner(section, "Holy Shock", 99, 0, 100, 5, "Health Percent to Cast At")
            --Bestow Faith
            br.ui:createSpinner(section, "Bestow Faith", 99, 0, 100, 5, "Health Percent to Cast At")
            -- Light of the Martyr
            br.ui:createSpinner(section, "Light of the Martyr", 50, 0, 100, 5, "Health Percent to Cast At")
            -- Tyr's Deliverance
            br.ui:createSpinner(section, "Tyr's Deliverance", 50, 0, 100, 5, "Health Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        ------ AOE HEALING ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
            -- Light of Dawn
            br.ui:createSpinner(section, "Light of Dawn",  80,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinner(section, "LoD Targets",  6,  0,  40,  1,  "Minimum Light of Dawn Targets")
        br.ui:checkSectionState(section)
        -------------------------
        ------ COOL  DOWNS ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cool Downs")
            -- Avenging Wrath
            br.ui:createSpinner(section, "Avenging Wrath", 30, 0, 100, 5, "Health Percent to Cast At")
            -- Lay on Hands
            br.ui:createSpinner(section, "Lay on Hands", 20, 0, 100, 5, "Health Percent to Cast At")
            -- Holy Avenger
            br.ui:createSpinner(section, "Holy Avenger", 50, 0, 100, 5, "Health Percent to Cast At")
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    if br.timer:useTimer("debugHoly", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
--------------
--- Locals ---
--------------
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mana                                          = br.player.powerPercentMana
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power.amount.mana, br.player.power.mana.max, br.player.power.regen
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local recharge                                      = br.player.recharge
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttm                                           = br.player.power.ttm
        local units                                         = br.player.units

        local lowest                                        = {}    --Lowest Unit
        lowest.hp                                           = br.friend[1].hp
        lowest.role                                         = br.friend[1].role
        lowest.unit                                         = br.friend[1].unit
        lowest.range                                        = br.friend[1].range
        lowest.guid                                         = br.friend[1].guid
        local tank                                          = {}    --Tank
        local averageHealth                                 = 100

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

--------------------
--- Action Lists ---
--------------------

-----------------
--- Rotations ---
-----------------
-----------------------------
--- In Combat - Rotations ---
-----------------------------
    -- Action List - Interrupts
            if useInterrupts() then
                for i=1, #getEnemies("player",20) do
                    thisUnit = getEnemies("player",20)[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                        if distance < 5 then
        -- Hammer of Justice
                            if isChecked("Hammer of Justice") then
                                if cast.hammerOfJustice(thisUnit) then return end
                            end
                        end
                    end
                end
            end -- End Interrupt Check

        if inCombat then

            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            --Cooldowns ----- Cooldowns -----Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- 
            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            -- Avenging Wrath
            if isChecked("Avenging Wrath") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue ("Avenging Wrath") then
                        if cast.avengingWrath("player") then return end
                    end
                end
            end
            -- Lay on Hands
            if isChecked("Lay on Hands") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue ("Lay on Hands") then
                        if cast.layOnHands(br.friend[i].unit) then return end
                    end
                end
            end
            -- Holy Avenger
            if isChecked("Holy Avenger") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue ("Holy Avenger") then
                        if cast.holyAvenger("player") then return end
                    end
                end
            end
        end
            ---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
        if not inCombat then
             ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            --AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing
            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            -- Beacon of Light on Tank
            if isChecked("Beacon of Light") then
                for i = 1, #br.friend do
                    if not UnitBuffID(br.friend[i].unit,53563) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                        if cast.beaconOfLight(br.friend[i].unit) then return end
                    end
                end
            end
            -- Light of Dawn
            if isChecked("Light of Dawn") then
                if getLowAllies(getValue"Light of Dawn") >= getValue("LoD Targets") and getFacing("player",lowest.unit) and getDistance("player",lowest.unit) <= 15 then
                    if cast.lightOfDawn(lowest.unit) then return end
                end
            end       
            -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            --Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing--
            -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            -- Flash of Light
            if isChecked("Flash of Light") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Flash of Light") then
                        if cast.flashOfLight(br.friend[i].unit) then return end
                    end
                end
            end
            -- Tyr's Deliverance
            if isChecked("Tyr's Deliverance") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Tyr's Deliverance") then
                        if cast.tyrsDeliverance(br.friend[i].unit) then return end
                    end
                end
            end
            -- Holy Shock
            if isChecked("Holy Shock") then
                if lowest.hp <= getValue("Holy Shock") then
                    if cast.holyShock(lowest.unit) then return end
--                else 
--                    if cast.holyShock(units.dyn30) then return end
                end
            end
            -- Bestow Faith
            if isChecked("Bestow Faith") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Bestow Faith") and not UnitBuffID(br.friend[i].unit,223306) then
                        if cast.bestowFaith(br.friend[i].unit) then return end
                    end
                end
            end

            if isChecked("Holy Light") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Holy Light") then
                        if cast.holyLight(br.friend[i].unit) then return end
                    end
                end
            end

            if isChecked("Light of the Martyr") and isMoving("player") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Light of the Martyr") then
                        if cast.lightOfTheMartyr(br.friend[i].unit) then return end
                    end
                end
            end
        end -- End In Combat Rotation
    end -- End Timer
end -- End runRotation

                if isChecked("Boss Helper") then
                        bossManager()
                end
local id = 65
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

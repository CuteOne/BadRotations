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
            --General or Test
            br.ui:createDropdownWithout(section, "Mode", {"|cffFFFFFFNormal","|cffFFFFFFTest"}, 1, "|cffFFFFFFSet Mode to use.")
        --    br.ui:createCheckbox(section, "Boss Helper")
            --Cleanse
            br.ui:createCheckbox(section, "Cleanse")
        --Beacon of Light
            br.ui:createCheckbox(section, "Beacon of Light")
        -- Beacon of Virtue
            br.ui:createSpinner(section, "Beacon of Virtue", 30, 0, 100, 5, "Health Percent to Cast At")
            br.ui:createSpinner(section, "BoV Targets",  6,  0,  40,  1,  "Minimum Beacon of Virtue Targets")
        -- Crusader Strike
            br.ui:createCheckbox(section, "Crusader Strike")
        -- Redemption
            br.ui:createDropdownWithout(section, "Redemption", {"|cffFFFFFFTarget","|cffFFFFFFMouseover"}, 1, "|cffFFFFFFSelect Redemption Mode.")
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
            br.ui:createDropdownWithout(section, "Holy Light Infuse", {"|cffFFFFFFNormal","|cffFFFFFFOnly Infuse"}, 1, "|cffFFFFFFOnly Use Infusion Procs.")
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
            br.ui:createSpinner(section, "AW Targets",  6,  0,  40,  1,  "Minimum Avenging Wrath Targets")
            -- Lay on Hands
            br.ui:createSpinner(section, "Lay on Hands", 20, 0, 100, 5, "Health Percent to Cast At")
            -- Holy Avenger
            br.ui:createSpinner(section, "Holy Avenger", 50, 0, 100, 5, "Health Percent to Cast At")
            br.ui:createSpinner(section, "HA Targets",  6,  0,  40,  1,  "Minimum Holy Avenger Targets")
            -- Aura Mastery
            br.ui:createSpinner(section, "Aura Mastery",  30,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinner(section, "AM Targets",  6,  0,  40,  1,  "Minimum Aura Mastery Targets")
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
        local enemies                                       = enemies or {}
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
        local units                                         = units or {}

        units.dyn5 = br.player.units(5)
        units.dyn30AoE = br.player.units(30,true)
        enemies.yards8 = br.player.enemies(8)
        enemies.yards30 = br.player.enemies(30)
        enemies.yards40 = br.player.enemies(40)

        local lowest                                        = {}    --Lowest Unit
        lowest.hp                                           = br.friend[1].hp
        lowest.role                                         = br.friend[1].role
        lowest.unit                                         = br.friend[1].unit
        lowest.range                                        = br.friend[1].range
        lowest.guid                                         = br.friend[1].guid
        local lowestTank                                    = {}    --Tank
        local beacon                                       
        local tHp                                           = 95
        local averageHealth                                 = 100

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

--------------------
--- Action Lists ---
--------------------

-----------------
--- Rotations ---
-----------------
        if getOptionValue("Mode") == 1 and not IsMounted() then
            -- Redemption
            if isChecked("Redemption") then
                if getOptionValue("Redemption") == 1
                    and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                then
                    if cast.redemption("target") then return end
                end
                if getOptionValue("Redemption") == 2
                    and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                then
                    if cast.redemption("mouseover") then return end
                end
            end
            -- Cleanse
            if isChecked("Cleanse") then
                for i = 1, #br.friend do
                    for n = 1,40 do
                        local buff,_,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                        if buff then
                            if bufftype == "Disease" or bufftype == "Magic" or bufftype == "Poison" then
                                if cast.cleanse(br.friend[i].unit) then return end
                            end
                        end
                    end
                end
            end
             -- Beacon of Light on Tank
            if isChecked("Beacon of Light") then
                if inInstance then    
                    for i = 1, #br.friend do
                        if beacon == nil and not buff.beaconOfLight.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                            beacon = br.friend[i].hp
                            if cast.beaconOfLight(br.friend[i].unit) then return end
                        else
                            if buff.beaconOfLight.exists(br.friend[i].unit) then
                                beacon = br.friend[i].hp
                            end
                        end
                    end              
                else 
                    if inRaid then
                        for i = 1, #br.friend do
                            if beacon == nil and not buff.beaconOfLight.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                                beacon = br.friend[i].hp
                                if cast.beaconOfLight(br.friend[i].unit) then return end
                            else
                                if buff.beaconOfLight.exists(br.friend[i].unit) then
                                    beacon = br.friend[i].hp
                                end
                            end
                        end
                        for i =1, #br.friend do
                            if br.friend[i].hp < beacon and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" and not buff.beaconOfLight.exists(br.friend[i].unit) then
                                beacon = br.friend[i].hp
                                if cast.beaconOfLight(br.friend[i].unit) then return end
                            end
                        end
                    end
                end
            end
             ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            --AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing----AOE Healing
            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            -- Light of Dawn
            if isChecked("Light of Dawn") then
                if getLowAllies(getValue"Light of Dawn") >= getValue("LoD Targets") and getFacing("player",lowest.unit) and getDistance("player",lowest.unit) <= 15 then
                    if cast.ruleOfLaw() then 
                        if cast.lightOfDawn(lowest.unit) then return end
                    end
                end
            end       
            -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            --Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing--
            -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
            -- Holy Light
            if isChecked("Holy Light") and (getOptionValue("Holy Light Infuse") == 1 or (getOptionValue("Holy Light Infuse") == 2 and buff.infusionOfLight.exists("player"))) then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Holy Light") then
                        if cast.holyLight(br.friend[i].unit) then return end
                    end
                end
            end
            -- Light of the Martyr
            if isChecked("Light of the Martyr") and isMoving("player") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Light of the Martyr") then
                        if cast.lightOfTheMartyr(br.friend[i].unit) then return end
                    end
                end
            end
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
                ----AOEction List - Interrupts
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
            end -- End In Combat Check
        end -- NOrmal Mode Check
        if getOptionValue("Mode") == 2 and not IsMounted() then
            -- Redemption
            if isChecked("Redemption") then
                if getOptionValue("Redemption") == 1
                    and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                then
                    if cast.redemption("target") then return end
                end
                if getOptionValue("Redemption") == 2
                    and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                then
                    if cast.redemption("mouseover") then return end
                end
            end
            if isChecked("Cleanse") then
                for i = 1, #br.friend do
                    for n = 1,40 do
                        local buff,_,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                        if buff then
                            if bufftype == "Disease" or bufftype == "Magic" or bufftype == "Poison" then
                                if cast.cleanse(br.friend[i].unit) then return end
                            end
                        end
                    end
                end
            end
            -- Beacon of Light on Tank
            if isChecked("Beacon of Light") then
                if inInstance then    
                    for i = 1, #br.friend do
                        if beacon == nil and not buff.beaconOfLight.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                            beacon = br.friend[i].hp
                            if cast.beaconOfLight(br.friend[i].unit) then return end
                        else
                            if buff.beaconOfLight.exists(br.friend[i].unit) then
                                beacon = br.friend[i].hp
                            end
                        end
                     end              
                else 
                    if inRaid then
                        if not talent.beaconOfFaith then
                            for i = 1, #br.friend do
                                if beacon == nil and not buff.beaconOfLight.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                                    beacon = br.friend[i].hp
                                    if cast.beaconOfLight(br.friend[i].unit) then return end
                                else
                                    if buff.beaconOfLight.exists(br.friend[i].unit) then
                                        beacon = br.friend[i].hp
                                    end
                                end
                            end
                            for i =1, #br.friend do
                                if br.friend[i].hp < beacon and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" and not buff.beaconOfLight.exists(br.friend[i].unit) then
                                    beacon = br.friend[i].hp
                                    if cast.beaconOfLight(br.friend[i].unit) then return end
                                end
                            end
                        else
                            if talent.beaconOfFaith then
                                for i = 1, #br.friend do
                                    if not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                                        if cast.beaconOfLight(br.friend[i].unit) then return end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            -- Beacon of Faith on Off Tank
            if isChecked("Beacon of Faith") and inRaid and talent.beaconOfFaith then
                for i = 1, #br.friend do
                    if not buff.beaconOfLight.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                        if cast.beaconOfFaith(br.friend[i].unit) then return end
                    end
                end
            end
            --Judgement
            --if HasItem(IlterendiCrownJewelOfSilvermoon) and (not HasTalent(BeaconOfVirtue) or CooldownSecRemaining(BeaconOfVirtue) < 10 and BuffCount(BeaconOfLight) > 0)
            --Beacon of Virtue
            if talent.beaconOfVirtue and isChecked("Beacon of Virtue") then
                for i= 1, #br.friend do
                    if not buff.beaconOfVirtue.exists(br.friend[i].unit)  then
                        local lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit,30,getValue("Beacon of Virtue"),#br.friend)
                        if #lowHealthCandidates >= getValue("BoV Targets") then
                            if cast.beaconOfVirtue(br.friend[i].unit) then return end
                        end
                    end
                end
            end
            -- Cool downs
            if inCombat then
                ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                --Cooldowns ----- Cooldowns -----Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- Cooldowns ----- 
                ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                -- Tyr's Deliverance
                if isChecked("Tyr's Deliverance") then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= getValue("Tyr's Deliverance") then
                            if cast.tyrsDeliverance(br.friend[i].unit) then return end
                        end
                    end
                end
                -- Avenging Wrath
                if isChecked("Avenging Wrath") and not buff.auraMastery.exists("player") then
                    if getLowAllies(getValue"Avenging Wrath") >= getValue("AW Targets") then
                        if cast.avengingWrath() then return end
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
                if isChecked("Holy Avenger") and talent.holyAvenger then
                   if getLowAllies(getValue"Holy Avenger") >= getValue("HA Targets") then
                        if cast.holyAvenger() then return end
                    end
                end
                -- Aura Mastery
                if isChecked("Aura Mastery") and not buff.avengingWrath.exists("player") then
                    if getLowAllies(getValue"Aura Mastery") >= getValue("AM Targets") then
                        if cast.auraMastery() then return end
                    end
                end
            end
            -- Holy Prism
            if isChecked("Holy Prism") then
                if getLowAllies(getValue"Holy Prism") >= getValue("Holy Prism Targets") then
                    if cast.holyPrism(units.dyn15) then return end
                end
            end
            -- Light of Dawn
            if isChecked("Light of Dawn") then
                 for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Light of Dawn") then
                        local lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit,15,getValue("Light of Dawn"),#br.friend)
                        if #lowHealthCandidates >= getValue("LoD Targets") then
                            if cast.ruleOfLaw() then
                                if cast.lightOfDawn(br.friend[i].unit) then return end
                            end
                        end
                    end
                end
            end
            -- Judgement
            if talent.judgementOfLight then
                if cast.judgement(units.dyn40) then return end
            end
            -- Bestow Faith
            if isChecked("Bestow Faith") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Bestow Faith") and not UnitBuffID(br.friend[i].unit,223306) then
                        if cast.bestowFaith(br.friend[i].unit) then return end
                    end
                end
            end
            -- Holy Shock
            if isChecked("Holy Shock") then
                if lowest.hp <= getValue("Holy Shock") then
                    if cast.holyShock(lowest.unit) then return end
                else 
                    if not buff.infusionOfLight.exists("player") then
                        if cast.holyShock(units.dyn30) then return end
                    end
                end
            end
            -- Light of Martyr
            if isChecked("Light of the Martyr") then
                if talent.ferventMartyr then
                    if getBuffStacks("player", 223316) == 2 then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue ("Light of the Martyr") then
                                if cast.lightOfTheMartyr(br.friend[i].unit) then return end
                            end
                        end
                    end
                end
            end
            -- Flash of Light
            if isChecked("Flash of Light") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Flash of Light") then
                        if cast.flashOfLight(br.friend[i].unit) then return end
                    end
                end
            end
            -- Holy Light
            if isChecked("Holy Light") and (getOptionValue("Holy Light Infuse") == 1 or (getOptionValue("Holy Light Infuse") == 2 and buff.infusionOfLight.exists("player"))) then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Holy Light") then
                        if cast.holyLight(br.friend[i].unit) then return end
                    end
                end
            end
            -- Emergency Martyr Heals
            if isMoving("player") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= 20 then
                        if cast.lightOfTheMartyr(br.friend[i].unit) then return end
                    end
                end
            end
            -- Crusader Strike
            if isChecked("Crusader Strike") then
                if not UnitIsFriend(units.dyn5, "player") then
                    if cast.crusaderStrike(units.dyn5) then return end
                end
            end
         end -- Test Mode
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

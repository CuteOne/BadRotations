local rotationName = "Kuukuu" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.holyAvenger},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.auraMastery},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.absolution}
    };
    CreateButton("Cooldown",1,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.divineProtection},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.blessingOfProtection}
    };
    CreateButton("Defensive",2,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.hammerOfJustice},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.hammerOfJustice}
    };
    CreateButton("Interrupt",3,0)
    -- Cleanse Button
    CleanseModes = {
        [1] = { mode = "On", value = 1 , overlay = "Cleanse Enabled", tip = "Cleanse Enabled", highlight = 1, icon = br.player.spell.cleanse },
        [2] = { mode = "Off", value = 2 , overlay = "Cleanse Disabled", tip = "Cleanse Disabled", highlight = 0, icon = br.player.spell.cleanse }
    };
    CreateButton("Cleanse",4,0)
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
        --Beacon of Light
            br.ui:createCheckbox(section, "Beacon of Light")
        -- Beacon of Virtue
            br.ui:createSpinner(section, "Beacon of Virtue", 30, 0, 100, 5, "Health Percent to Cast At")
            br.ui:createSpinner(section, "BoV Targets",  6,  0,  40,  1,  "Minimum Beacon of Virtue Targets")
        -- Redemption
            br.ui:createDropdown(section, "Redemption", {"|cffFFFFFFTarget","|cffFFFFFFMouseover"}, 1, "|cffFFFFFFSelect Redemption Mode.")
            br.ui:createSpinner(section, "Beacon of Virtue", 30, 0, 100, 5, "Health Percent to Cast At")

            br.ui:createSpinner(section, "Critical HP", 30, 0, 100, 5, "Health Percent to Spam FoL")
        br.ui:checkSectionState(section)
        -------------------------
        ------ DEFENSIVES -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Pot/Stone
            br.ui:createSpinner (section, "Pot/Stoned", 30, 0, 100, 5, "Health Percent to Cast At")
            br.ui:createSpinner (section, "Divine Protection", 20, 0, 100, 5, "Health Percent to Cast At")
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
            br.ui:createDropdownWithout(section, "FoL Infuse", {"|cffFFFFFFNormal","|cffFFFFFFOnly Infuse"}, 1, "|cffFFFFFFOnly Use Infusion Procs.")
            --Holy Light
            br.ui:createSpinner(section, "Holy Light",  85,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createDropdownWithout(section, "Holy Light Infuse", {"|cffFFFFFFNormal","|cffFFFFFFOnly Infuse"}, 1, "|cffFFFFFFOnly Use Infusion Procs.")
            --Holy Shock
            br.ui:createSpinner(section, "Holy Shock", 99, 0, 100, 5, "Health Percent to Cast At")
            --Bestow Faith
            br.ui:createSpinner(section, "Bestow Faith", 99, 0, 100, 5, "Health Percent to Cast At")
            br.ui:createDropdownWithout(section, "Bestow Faith Target", {"|cffFFFFFFAll","|cffFFFFFFTanks"}, 1, "|cffFFFFFFTarget for BF")
            -- Light of the Martyr
            br.ui:createSpinner(section, "Light of the Martyr", 50, 0, 100, 5, "Health Percent to Cast At")
            br.ui:createCheckbox(section, "Non Moving Martyr")
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
        ---------- DPS ----------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "DPS")
            br.ui:createSpinner(section, "DPS", 80, 0, 100, 5, "Minimum Health to DPS")
            -- Consecration
            br.ui:createSpinner(section, "Consecration",  6,  0,  40,  1,  "Minimum Consecration Targets")
            -- Holy Prism
            br.ui:createSpinner(section, "Holy Prism Damage",  6,  0,  40,  1,  "Minimum Holy Prism Targets")
            -- Light's Hammer
            br.ui:createSpinner(section, "Light's Hammer Damage",  6,  0,  40,  1,  "Minimum Light's Hammer Targets")
            -- Judgement
            br.ui:createCheckbox(section, "Judgement")
            -- Holy Shock
            br.ui:createCheckbox(section, "Holy Shock Damage")
            -- Crusader Strike
            br.ui:createCheckbox(section, "Crusader Strike")
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
            br.ui:createDropdownWithout(section, "Lay on Hands Target", {"|cffFFFFFFAll","|cffFFFFFFTanks", "|cffFFFFFFSelf"}, 1, "|cffFFFFFFTarget for LoH")
            -- Holy Avenger
            br.ui:createSpinner(section, "Holy Avenger", 50, 0, 100, 5, "Health Percent to Cast At")
            br.ui:createSpinner(section, "HA Targets",  6,  0,  40,  1,  "Minimum Holy Avenger Targets")
            -- Aura Mastery
            br.ui:createSpinner(section, "Aura Mastery",  30,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinner(section, "AM Targets",  6,  0,  40,  1,  "Minimum Aura Mastery Targets")
        br.ui:checkSectionState(section)
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
        UpdateToggle("Cleanse",0.25)
        br.player.mode.cleanse = br.data.settings[br.selectedSpec].toggles["Cleanse"]
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
        local power, powmax, powgen                         = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units

        units.get(5)
        units.get(15)
        units.get(30)
        units.get(40)
        units.get(30,true)
        enemies.get(8)
        enemies.get(10)
        enemies.get(15)
        enemies.get(30)
        enemies.get(40)

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
        local function actionList_Defensive()
            if useDefensive() then
                if isChecked("Pot/Stoned") and php <= getValue("Pot/Stoned") and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUseItem(5512) then
                        useItem(5512)
                    elseif canUseItem(getHealthPot()) then
                        useItem(getHealthPot())
                    end
                end
                if isChecked("Divine Protection") then
                    if php <= getOptionValue("Divine Protection") and inCombat then
                        if cast.divineProtection() then return end
                    end
                end
            end
        end

-----------------
--- Rotations ---
-----------------
        if getOptionValue("Mode") == 1 and not IsMounted() and getBuffRemain("player", 192002 ) < 10 then
            if actionList_Defensive() then return end
             -- Redemption
            if isChecked("Redemption") then
                if getOptionValue("Redemption") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player") then
                    if cast.redemption("target") then return end
                end
                if getOptionValue("Redemption") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player") then
                    if cast.redemption("mouseover") then return end
                end
            end
            if br.player.mode.cleanse == 1 then
                for i = 1, #br.friend do
                    if UnitIsPlayer(br.friend[i].unit) then
                        for n = 1,40 do
                            local buff,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                            if buff then
                                if bufftype == "Disease" or bufftype == "Magic" or bufftype == "Poison" then
                                    if cast.cleanse(br.friend[i].unit) then return end
                                end
                            end
                        end
                    end
                end
            end
            -- Interrupt
            if useInterrupts() then
                for i=1, #getEnemies("player",10) do
                    thisUnit = getEnemies("player",10)[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                        if distance <= 10 then
        -- Hammer of Justice
                            if isChecked("Hammer of Justice") and GetSpellCooldown(853) == 0 then
                                if cast.hammerOfJustice(thisUnit) then return end
                            end
                        end
                    end
                end
            end -- End Interrupt Check
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
                                    if beacon == nil and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                                        beacon = br.friend[i].hp
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
                    if not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
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
            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            -- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS -----------
            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            if isChecked("DPS") and lowest.hp >= getValue("DPS") and not GetUnitIsFriend("target", "player") then
                --Consecration
                if isChecked("Consecration") and #enemies.yards8 >= getValue("Consecration") and not isMoving("player") then
                    if cast.consecration() then return end
                end
                -- Holy Prism
                if isChecked("Holy Prism Damage") and talent.holyPrism and #enemies.yards15 >= getValue("Holy Prism Damage") and php < 90 then
                    if cast.holyPrism(units.dyn15) then return end
                end
                -- Light's Hammer
                if isChecked("Light's Hammer Damage") and talent.lightsHammer and not isMoving("player") and #enemies.yards10 >= getValue("Light's Hammer Damage") then
                    if cast.lightsHammer("best",nil,1,10) then return end
                end
                -- Judgement
                if isChecked("Judgement") then
                    if cast.judgment(units.dyn30) then return end
                end
                -- Holy Shock
                if isChecked("Holy Shock Damage") then
                    if cast.holyShock(units.dyn40) then return end
                end
                -- Crusader Strike
                if isChecked("Crusader Strike") and (charges.crusaderStrike.count() == 2 or debuff.judgement.exists(units.dyn5) or (charges.crusaderStrike.count() >= 1 and charges.crusaderStrike.recharge() < 3)) then
                    if not GetUnitIsFriend(units.dyn5, "player") then
                        if cast.crusaderStrike(units.dyn5) then return end
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
                        if br.friend[i].hp <= getValue("Tyr's Deliverance") and getDistance("player",br.friend[i].unit) <= 15 then
                            if cast.tyrsDeliverance(br.friend[i].unit) then return end
                        end
                    end
                end
                -- Avenging Wrath
                if isChecked("Avenging Wrath") and not buff.auraMastery.exists("player") and GetSpellCooldown(31842) == 0 then
                    if getLowAllies(getValue"Avenging Wrath") >= getValue("AW Targets") then
                        if isCastingSpell(spell.holyLight) then
                            SpellStopCasting()
                        end
                        if cast.avengingWrath() then return end
                    end
                end
                -- Lay on Hands
                if isChecked("Lay on Hands") and GetSpellCooldown(633) == 0 then
                    if getOptionValue("Lay on Hands Target") == 1 then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue ("Lay on Hands") then
                                if isCastingSpell(spell.holyLight) then
                                    SpellStopCasting()
                                end
                                if cast.layOnHands(br.friend[i].unit) then return end
                            end
                        end
                    elseif getOptionValue("Lay on Hands Target") == 2 then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue ("Lay on Hands") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                                if cast.layOnHands(br.friend[i].unit) then return end
                            end
                        end
                    elseif getOptionValue("Lay on Hands Target") == 3 then
                        if php <= getValue("Lay on Hands") then
                            if cast.layOnHands("player") then return end
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
            if isCastingSpell(spell.holyLight) then return end
            if isCastingSpell(spell.flashOfLight) then return end
            -- Holy Prism
            if isChecked("Holy Prism") and talent.holyPrism then
                if getLowAllies(getValue"Holy Prism") >= getValue("Holy Prism Targets") then
                    if cast.holyPrism(units.dyn15) then return end
                end
            end
            -- Light of Dawn
            if isChecked("Light of Dawn") then
                 for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Light of Dawn") then
                        local lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit,15,getValue("Light of Dawn"),#br.friend)
                        if #lowHealthCandidates >= getValue("LoD Targets") and getFacing("player",br.friend[i].unit) then
                            if GetSpellCooldown(85222) == 0 then
                                if cast.ruleOfLaw() then end
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
                if getOptionValue("Bestow Faith Target") == 1 then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= getValue ("Bestow Faith") then
                            if cast.bestowFaith(br.friend[i].unit) then return end
                        end
                    end
                elseif getOptionValue("Bestow Faith Target") == 2 then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= getValue ("Bestow Faith") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                            if cast.bestowFaith(br.friend[i].unit) then return end
                        end
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
                            if br.friend[i].hp <= getValue ("Light of the Martyr") and not GetUnitIsUnit(br.friend[i].unit,"player") then
                                if cast.lightOfTheMartyr(br.friend[i].unit) then return end
                            end
                        end
                    end
                end
            end
            -- Flash of Light
            if isChecked("Flash of Light") and (getOptionValue("FoL Infuse") == 1 or (getOptionValue("FoL Infuse") == 2 and buff.infusionOfLight.exists("player"))) then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Flash of Light")  then
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
            if isMoving("player") or isChecked("Non Moving Martyr") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= 20 and not GetUnitIsUnit(br.friend[i].unit,"player") then
                        if cast.lightOfTheMartyr(br.friend[i].unit) then return end
                    end
                end
            end

        end -- NOrmal Mode Check
        if getOptionValue("Mode") == 2 and not IsMounted() and getBuffRemain("player", 192002 ) < 5 then
            if actionList_Defensive() then return end
            -- Redemption
            if isChecked("Redemption") then
                if getOptionValue("Redemption") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player") then
                    if cast.redemption("target") then return end
                end
                if getOptionValue("Redemption") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player") then
                    if cast.redemption("mouseover") then return end
                end
            end
            if br.player.mode.cleanse == 1 then
                for i = 1, #br.friend do
                    if UnitIsPlayer(br.friend[i].unit) then
                        for n = 1,40 do
                            local buff,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                            if buff then
                                if bufftype == "Disease" or bufftype == "Magic" or bufftype == "Poison" then
                                    if cast.cleanse(br.friend[i].unit) then return end
                                end
                            end
                        end
                    end
                end
            end
            -- Interrupt
            if useInterrupts() then
                for i=1, #getEnemies("player",10) do
                    thisUnit = getEnemies("player",10)[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                        if distance <= 10 then
        -- Hammer of Justice
                            if isChecked("Hammer of Justice") and GetSpellCooldown(853) == 0 then
                                if isCastingSpell(spell.holyLight) then
                                    SpellStopCasting()
                                end
                                if cast.hammerOfJustice(thisUnit) then return end
                            end
                        end
                    end
                end
            end -- End Interrupt Check
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
                                    if beacon == nil and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                                        beacon = br.friend[i].hp
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
                    if not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
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
            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            -- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS ----------- DPS -----------
            ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            if isChecked("DPS") and lowest.hp >= getValue("DPS") and not GetUnitIsFriend("target", "player") then
                --Consecration
                if isChecked("Consecration") and #enemies.yards8 >= getValue("Consecration") and not isMoving("player") then
                    if cast.consecration() then return end
                end
                -- Holy Prism
                if isChecked("Holy Prism Damage") and talent.holyPrism and #enemies.yards15 >= getValue("Holy Prism Damage") and php < 90 then
                    if cast.holyPrism(units.dyn15) then return end
                end
                -- Light's Hammer
                if isChecked("Light's Hammer Damage") and talent.lightsHammer and not isMoving("player") and #enemies.yards10 >= getValue("Light's Hammer Damage") then
                    if cast.lightsHammer("best",nil,1,10) then return end
                end
                -- Judgement
                if isChecked("Judgement") then
                    if cast.judgment(units.dyn30) then return end
                end
                -- Holy Shock
                if isChecked("Holy Shock Damage") then
                    if cast.holyShock(units.dyn40) then return end
                end
                -- Crusader Strike
                if isChecked("Crusader Strike") and (charges.crusaderStrike.count() == 2 or debuff.judgement.exists(units.dyn5) or (charges.crusaderStrike.count() >= 1 and charges.crusaderStrike.recharge() < 3)) then
                    if not GetUnitIsFriend(units.dyn5, "player") then
                        if cast.crusaderStrike(units.dyn5) then return end
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
                        if br.friend[i].hp <= getValue("Tyr's Deliverance") and getDistance("player", br.friend[i].unit) <= 15 then
                            if cast.tyrsDeliverance() then return end
                        end
                    end
                end
                -- Avenging Wrath
                if isChecked("Avenging Wrath") and not buff.auraMastery.exists("player") and GetSpellCooldown(31842) == 0 then
                    if getLowAllies(getValue"Avenging Wrath") >= getValue("AW Targets") then
                        if isCastingSpell(spell.holyLight) then
                            SpellStopCasting()
                        end
                        if cast.avengingWrath() then return end
                    end
                end
                -- Lay on Hands
                if isChecked("Lay on Hands") and GetSpellCooldown(633) == 0 then
                    if getOptionValue("Lay on Hands Target") == 1 then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue ("Lay on Hands") then
                                if isCastingSpell(spell.holyLight) then
                                    SpellStopCasting()
                                end
                                if cast.layOnHands(br.friend[i].unit) then return end
                            end
                        end
                    elseif getOptionValue("Lay on Hands Target") == 2 then
                        for i = 1, #br.friend do
                            if br.friend[i].hp <= getValue ("Lay on Hands") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                                if isCastingSpell(spell.holyLight) then
                                    SpellStopCasting()
                                end
                                if cast.layOnHands(br.friend[i].unit) then return end
                            end
                        end
                    elseif getOptionValue("Lay on Hands Target") == 3 then
                        if php <= getValue("Lay on Hands") then
                            if isCastingSpell(spell.holyLight) then
                                SpellStopCasting()
                            end
                            if cast.layOnHands("player") then return end
                        end
                    end
                end
                -- Holy Avenger
                if isChecked("Holy Avenger") and talent.holyAvenger and GetSpellCooldown(105809) == 0 then
                   if getLowAllies(getValue"Holy Avenger") >= getValue("HA Targets") then
                        if isCastingSpell(spell.holyLight) then
                            SpellStopCasting()
                        end
                        if cast.holyAvenger() then return end
                    end
                end
                -- Aura Mastery
                if isChecked("Aura Mastery") and not buff.avengingWrath.exists("player") and GetSpellCooldown(31821) == 0 then
                    if getLowAllies(getValue"Aura Mastery") >= getValue("AM Targets") then
                        if isCastingSpell(spell.holyLight) then
                            SpellStopCasting()
                        end
                        if cast.auraMastery() then return end
                    end
                end
            end
            -- Holy Prism
            if isChecked("Holy Prism") and talent.holyPrism then
                if getLowAllies(getValue"Holy Prism") >= getValue("Holy Prism Targets") then
                    if cast.holyPrism(units.dyn15) then return end
                end
            end
            -- Light of Dawn
            if isChecked("Light of Dawn") then
                 for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Light of Dawn") then
                        local lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit,15,getValue("Light of Dawn"),#br.friend)
                        if #lowHealthCandidates >= getValue("LoD Targets") and getFacing("player",br.friend[i].unit) then
                            if GetSpellCooldown(85222) == 0 then
                                if isCastingSpell(spell.holyLight) then
                                    SpellStopCasting()
                                end
                                if cast.ruleOfLaw() then end
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
            if isChecked("Bestow Faith") and GetSpellCooldown(223306) == 0 then
                if getOptionValue("Bestow Faith Target") == 1 then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= getValue ("Bestow Faith") and not buff.bestowFaith.exists(br.friend[i].unit) then
                            if isCastingSpell(spell.holyLight) and getCastTime(spell.holyLight) > 1 then
                                SpellStopCasting()
                            end
                            if cast.bestowFaith(br.friend[i].unit) then return end
                        end
                    end
                elseif getOptionValue("Bestow Faith Target") == 2 then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= getValue ("Bestow Faith") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" and not buff.bestowFaith.exists(br.friend[i].unit) then
                            if isCastingSpell(spell.holyLight) and getCastTime(spell.holyLight) > 1 then
                                SpellStopCasting()
                            end
                            if cast.bestowFaith(br.friend[i].unit) then return end
                        end
                    end
                end
            end
            -- Holy Shock
            if isChecked("Holy Shock") and GetSpellCooldown(20473) == 0 then
                if lowest.hp <= getValue("Holy Shock") then
                    if isCastingSpell(spell.holyLight) and getCastTime(spell.holyLight) > 1 then
                        SpellStopCasting()
                    end
                    if cast.holyShock(lowest.unit) then return end
                else
                    if not buff.infusionOfLight.exists("player") then
                        if isCastingSpell(spell.holyLight) and getCastTime(spell.holyLight) > 1 then
                            SpellStopCasting()
                        end
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
                                if isCastingSpell(spell.holyLight) then
                                    SpellStopCasting()
                                end
                                if cast.lightOfTheMartyr(br.friend[i].unit) then return end
                            end
                        end
                    end
                end
            end
            -- Flash of Light
            if isChecked("Critical HP") and lowest.hp <= getOptionValue("Critical HP") then
                if cast.flashOfLight(lowest.unit) then return end
            end
            if isChecked("Flash of Light") and (getOptionValue("FoL Infuse") == 1 or (getOptionValue("FoL Infuse") == 2 and buff.infusionOfLight.exists("player"))) and (not LastFoLTime or GetTime() - LastFoLTime > 8) then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Flash of Light")  then
                        if isCastingSpell(spell.holyLight) then
                            SpellStopCasting()
                        end
                        if cast.flashOfLight(br.friend[i].unit) then
                        LastFoLTime = GetTime()
                        return
                        end
                    end
                end
            end
            -- Emergency Martyr Heals
            if isMoving("player") or isChecked("Non Moving Martyr") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= 20 then
                        if cast.lightOfTheMartyr(br.friend[i].unit) then return end
                    end
                end
            end
            -- Holy Light
            if isChecked("Holy Light") and (getOptionValue("Holy Light Infuse") == 1 or (getOptionValue("Holy Light Infuse") == 2 and buff.infusionOfLight.exists("player"))) and not isMoving("player") then
                if GetSpellCooldown(20473) >  getCastTime(spell.holyLight) then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= getValue("Holy Light") then
                            if cast.holyLight(br.friend[i].unit) then return end
                        end
                    end
                end
            end

         end -- Test Mode
    end -- End Timer
end -- End runRotation

                if isChecked("Boss Helper") then
                        bossManager()
                end
--local id = 65
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

--Version 1.0.0
local rotationName = "Panglopal" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles()
    CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 0, icon = br.player.spell.holyAvenger},
        [2] = {mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.auraMastery},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.absolution}
    }
    CreateButton("Cooldown", 1, 0)
    DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 0, icon = br.player.spell.divineProtection},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.blessingOfProtection}
    }
    CreateButton("Defensive", 2, 0)
    InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 0, icon = br.player.spell.blindingLight},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.blindingLight}
    }
    CreateButton("Interrupt", 3, 0)
    CleanseModes = {
        [1] = {mode = "On", value = 1, overlay = "Cleanse Enabled", tip = "Cleanse Enabled", highlight = 0, icon = br.player.spell.cleanse},
        [2] = {mode = "Off", value = 2, overlay = "Cleanse Disabled", tip = "Cleanse Disabled", highlight = 0, icon = br.player.spell.cleanse}
    }
    CreateButton("Cleanse", 4, 0)
    GlimmerModes = {
        [1] = {mode = "On", value = 1, overlay = "Glimmer mode", tip = "Glimmer on", highlight = 0, icon = 287280},
        [2] = {mode = "Off", value = 2, overlay = "Normal", tip = "Glimmer off", highlight = 0, icon = br.player.spell.holyShock},
        [3] = {mode = "Tank", value = 3, overlay = "Normal", tip = "Glimmer on tank", highlight = 0, icon = 278573}
    }
    CreateButton("Glimmer", 5, 0)
    DamageModes = {
        [1] = {mode = "On", value = 1, overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 0, icon = br.player.spell.judgment},
        [2] = {mode = "Off", value = 2, overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.judgment},
    }
    CreateButton("Damage", 6, 0)
    BeaconModes = {
        [1] = {mode = "BossTarget1", value = 1, overlay = "Boss1", tip = "BossTarget1", highlight = 0, icon = br.player.spell.beaconOfLight},
        [2] = {mode = "BossTarget2", value = 2, overlay = "Boss2", tip = "BossTarget2", highlight = 0, icon = br.player.spell.beaconOfLight},
        [3] = {mode = "BossTarget3", value = 3, overlay = "Boss3", tip = "BossTarget3", highlight = 0, icon = br.player.spell.beaconOfLight},
        [4] = {mode = "Off", value = 4, overlay = "Off", tip = "Off", highlight = 0, icon = br.player.spell.beaconOfLight}
    }
    CreateButton("Beacon", 7, 0)
    WrathModes = {
        [1] = {mode = "High", value = 1, overlay = "High Prio HoW", tip = "High Prio HoW", highlight = 1, icon = br.player.spell.hammerOfWrath},
        [2] = {mode = "Low", value = 2, overlay = "Low Prio HoW", tip = "Low Prio HoW", highlight = 0, icon = br.player.spell.hammerOfWrath},
        [3] = {mode = "Off", value = 3, overlay = "HoW Enabled", tip = "HoW Disabled", highlight = 0, icon = br.player.spell.repentance},
    }
    CreateButton("Wrath", 0, 1)
end

local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        ----------------------
        --[[ section = br.ui:createSection(br.ui.window.profile, "Trinkets")
        --br.ui:createCheckbox(section,"glimmer debug")
        br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "", "Minimum Trinket 1 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 1 Mode", {"|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround", "|cffFFFFFFDPS-Target"}, 1, "", "")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 2 Mode", {"|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround", "|cffFFFFFFDPS-Target"}, 1, "", "")
        -- br.ui:createCheckbox(section, "Advanced Trinket Support")
        br.ui:checkSectionState(section) ]]

        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.002")
        br.ui:createCheckbox(section,"Sunking")
        -- Blessing of Freedom
        br.ui:createCheckbox(section, "Blessing of Freedom")
        br.ui:createCheckbox(section, "Automatic Aura replacement")
        -- Critical
        br.ui:createSpinnerWithout(section, "Critical HP", 30, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Critical Heals")
        br.ui:createCheckbox(section,"Hard Lock Crit Heal")
        br.ui:createCheckbox(section, "OOC Healing", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.", 1)
        br.ui:checkSectionState(section)
        -- Raid
--[[         section = br.ui:createSection(br.ui.window.profile, "Raid")
        br.ui:checkSectionState(section) ]]
        -------------------------
        ------ DEFENSIVES -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Basic Healing Module
	br.player.module.BasicHealing(section)
        br.ui:createSpinner(section, "Divine Protection", 60, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Divine Shield", 20, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        -- Gift of The Naaru
        if br.player.race == "Draenei" then
            br.ui:createSpinner(section, "Gift of The Naaru", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        end
        br.ui:checkSectionState(section)
        -------------------------
        ------ Keys -------
        -------------------------

        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        --Hammer of Justice
        br.ui:createCheckbox(section, "Hammer of Justice")
        -- Blinding Light
        br.ui:createCheckbox(section, "Blinding Light")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "InterruptAt", 95, 0, 95, 5, "", "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        ------ COOL  DOWNS ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cool Downs")
        
        -- Lay on Hand
        br.ui:createSpinner(section, "Lay on Hands - min", 20, 0, 100, 5, "", "|cffFFFFFFMin Health Percent to Cast At")
        br.ui:createSpinner(section, "Lay on Hands - max", 20, 0, 100, 5, "", "|cffFFFFFFMax Health Percent to Cast At", true)
        br.ui:createDropdownWithout(section, "Lay on Hands Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFSelf", "|cffFFFFFFHealer/DPS"}, 1, "|cffFFFFFFTarget for LoH")
        -- Blessing of Protection
        br.ui:createSpinner(section, "Blessing of Protection", 20, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "BoP Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFHealer/Damage", "|cffFFFFFFSelf"}, 3, "|cffFFFFFFTarget for BoP")
        -- Blessing of Sacrifice
        br.ui:createSpinner(section, "Blessing of Sacrifice", 40, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "BoS Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFDamage"}, 2, "|cffFFFFFFTarget for BoS")
        br.ui:checkSectionState(section)

        -------------------------
        ---- SINGLE TARGET ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
        --Flash of Light
        br.ui:createSpinner(section, "Flash of Light", 70, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "FoL Beacon", 70, 0, 100, 5,"", "Health of Beacon Target to cast FoL At")
        br.ui:createSpinner(section, "FoL Tanks", 70, 0, 100, 5, "", "|cffFFFFFFTanks Health Percent to Cast At", true)
        br.ui:createSpinner(section, "FoL Infuse", 70, 0, 100, 5, "", "|cffFFFFFFIn Infuse buff Health Percent to Cast At", true)
        --Holy Light
        br.ui:createSpinner(section, "Holy Light", 85, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "Holy Light Infuse", {"|cffFFFFFFNormal", "|cffFFFFFFOnly Infuse"}, 2, "|cffFFFFFFOnly Use Infusion Procs.")
        --Holy Shock
        br.ui:createSpinner(section, "Holy Shock", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Self Shock", 35, 0, 100, 5, "")
        --Word of Glory
        br.ui:createSpinner(section, "Word of Glory", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        --[[ --Bestow Faith
        br.ui:createSpinner(section, "Bestow Faith", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "Bestow Faith Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFSelf", "|cffFFFFFFSelf+LotM"}, 4, "|cffFFFFFFTarget for BF")
        ]]---- Light of the Martyr
        br.ui:createSpinner(section, "Light of the Martyr", 40, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Moving LotM", 80, 0, 100, 5, "", "|cffFFFFFFisMoving Health Percent to Cast At")
        br.ui:createSpinner(section, "LoM after FoL", 60, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "LotM player HP limit", 50, 0, 100, 5, "", "|cffFFFFFFLight of the Martyr Self HP limit", true)
        br.ui:checkSectionState(section)
        -------------------------
        ------ AOE HEALING ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
        --Trinket?
        --Divine Toll
        br.ui:createDropdown(section,"Divine Toll", {"At 0 Holy Power","As a Heal"}, 1)
        br.ui:createSpinnerWithout(section,"Divine Toll Units", 3, 1, 5, 1)
        br.ui:createSpinnerWithout(section,"Divine Toll Health", 70, 0, 100, 1)
        br.ui:createSpinnerWithout(section,"Max Holy Power", 2, 0, 5, 1, "Only use Divine Toll when at or below this value")
        -- Rule of Law
        br.ui:createSpinner(section, "Rule of Law", 70, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "RoL Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum RoL Targets", true)
        -- Light of Dawn
        br.ui:createSpinner(section, "Light of Dawn", 90, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "LoD Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum LoD Targets", true)
        -- Beacon of Virtue
        br.ui:createSpinner(section, "Beacon of Virtue", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "BoV Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum BoV Targets", true)
        -- Holy Prism
        br.ui:createSpinner(section, "Holy Prism", 90, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Holy Prism Targets", 3, 0, 5, 1, "", "|cffFFFFFFMinimum Holy Prism Targets", true)
        --[[-- Light's Hammer
        br.ui:createSpinner(section, "Light's Hammer", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Light's Hammer Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Light's Hammer Targets", true)
        br.ui:createDropdown(section, "Light's Hammer Key", br.dropOptions.Toggle, 6, "", "|cffFFFFFFLight's Hammer usage.") ]]
        br.ui:checkSectionState(section)
        -------------------------
        ---------- DPS ----------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "DPS")
        br.ui:createDropdown(section, "Hard DPS Key", br.dropOptions.Toggle, 6)
        br.ui:createSpinner(section, "Divine Toll during DPS Key", 3, 1, 5, 1,"Use Divine Toll at >= x units")
        br.ui:createCheckbox(section, "Auto Focus target")
        -- Consecration
        br.ui:createSpinner(section, "Consecration", 1, 0, 40, 1, "", "|cffFFFFFFMinimum Consecration Targets")
        --[[ -- Holy Prism
        br.ui:createSpinner(section, "Holy Prism Damage", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Holy Prism Targets")
        -- Light's Hammer
        br.ui:createSpinner(section, "Light's Hammer Damage", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Light's Hammer Targets") ]]
        -- Judgment
        br.ui:createCheckbox(section, "Judgment - DPS")
        -- Holy Shock
        br.ui:createCheckbox(section, "Holy Shock Damage")
        --br.ui:createCheckbox(section, "Aggressive Glimmer", "tries to keep one glimmer on target")
        -- Shield of the Righteous
        br.ui:createSpinner(section, "Shield of the Righteous", 1, 0, 40, 1, "", "|cffFFFFFFMinimum Shield of the Righteous Targets")
        -- Crusader Strike
        br.ui:createCheckbox(section, "Crusader Strike")
        br.ui:checkSectionState(section)
    end
    local function OtherStuff()
        section = br.ui:createSection(br.ui.window.profile, "Devstuff")
        br.ui:createCheckbox(section, "Dev Stuff Leave off")
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions  
        },
        {
            [1] = "Other Options",
            [2] = OtherStuff
        }
    }
    return optionTable
end
local setwindow = false
local function runRotation()
    if UnitDebuffID("player", 307161) then
        return true
    end
    if setwindow == false then
        RunMacroText("/console SpellQueueWindow 0")
        Print("Set SQW")
        setwindow = true
    end

    local holyPower     = br.player.power.holyPower.amount()
    local holyPowerMax  = br.player.power.holyPower.max()
    local mana = getMana("player")
    local buff = br.player.buff
    local cast = br.player.cast
    local php = br.player.health
    local spell = br.player.spell
    local item = br.player.items
    local equiped = br.player.equiped
    local talent = br.player.talent
    local essence = br.player.essence
    local gcd = (((br.player.gcdMax + br.player.gcd) / 2) * 0.9)
    local charges = br.player.charges
    local cd = br.player.cd
    local debuff = br.player.debuff
    local drinking = getBuffRemain("player", 192002) ~= 0 or getBuffRemain("player", 167152) ~= 0 or getBuffRemain("player", 192001) ~= 0
    local resable = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player") and UnitInRange("target")
    local inCombat = isInCombat("player")
    local inInstance = br.player.instance == "party" or br.player.instance == "scenario"
    local inRaid = br.player.instance == "raid"
    local solo = #br.friend == 1
    local OWGroup = br.player.instance == "none" and #br.friend >= 2
    local race = br.player.race
    local racial = br.player.getRacial()
    local traits = br.player.traits
    local moving = isMoving("player")
    local BleedFriend = nil
    local BleedFriendCount = 0
    local BleedStack = 0
    local tanks = getTanksTable()
    local lowest = br.friend[1]
    local friends = friends or {}
    local module = br.player.module
    local glimmerCount = 0
    local enemies = br.player.enemies
    local lastSpell = lastSpellCast
    local mode = br.player.ui.mode
    local pullTimer = br.DBM:getPulltimer()
    local units = br.player.units
    local LightCount = 0
    local FaithCount = 0

    if br.player.runeforge.shadowbreaker.equiped then
        lightOfDawn_distance = 40
    else
        lightOfDawn_distance = 15
    end
    if buff.ruleOfLaw.exists("player") then
        lightOfDawn_distance_coff = 1.5
    else
        lightOfDawn_distance_coff = 1
    end

    local lowest = {}
    lowest.unit = "player"
    lowest.hp = 100

    for i = 1, #br.friend do
        if br.friend[i].hp < lowest.hp and getLineOfSight(br.friend[i].unit, "player") and not UnitIsDeadOrGhost(br.friend[i].unit) then
            lowest = br.friend[i]
        end
    end

    local lowestBeacon = {}
    lowestBeacon.unit = nil
    lowestBeacon.hp = 100

    for i = 1, #br.friend do
        if buff.beaconOfLight.exists(br.friend[i].unit) or buff.beaconOfVirtue.exists(br.friend[i].unit) or buff.beaconOfFaith.exists(br.friend[i].unit) then
            if br.friend[i].hp <= lowestBeacon.hp and getLineOfSight(br.friend[i].unit, "player") and not UnitIsDeadOrGhost(br.friend[i].unit) then
                lowestBeacon = br.friend[i]
            end
        end
    end


    for i = 1, #br.friend do
        if buff.glimmerOfLight.remain(br.friend[i].unit) > gcd then
            glimmerCount = glimmerCount + 1
        end
    end

    if cast.current.holyLight() and not buff.infusionOfLight.exists("player") and getOptionValue("Holy Light Infuse") == 2 then
        SpellStopCasting()
    end

    units.get(5)
    units.get(8)
    units.get(15)
    units.get(30)
    units.get(40)
    enemies.get(5)
    enemies.get(8)
    enemies.get(10)
    enemies.get(15)
    enemies.get(30)
    enemies.get(40)
    friends.yards40 = getAllies("player", 40)

    if timersTable then
        wipe(timersTable)
    end

    local function bestConeHeal(spell, minUnits, health, angle, rangeInfront, rangeAround)
        if not isKnown(spell) or getSpellCD(spell) ~= 0 or select(2, IsUsableSpell(spell)) then
            return false
        end
        local curFacing = ObjectFacing("player")
        local playerX, playerY, playerZ = ObjectPosition("player")
        local coneTable = {}

        local unitsAround = 0
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            if br.friend[i].hp < health then
                if br.friend[i].distance < rangeAround then
                    unitsAround = unitsAround + 1
                elseif br.friend[i].distance < rangeInfront then
                    local unitX, unitY, unitZ = ObjectPosition(thisUnit)
                    if playerX and unitX then
                        local angleToUnit = rad(atan2(unitY - playerY, unitX - playerX))
                        if angleToUnit < 0 then
                            angleToUnit = rad(360 + atan2(unitY - playerY, unitX - playerX))
                        end
                        tinsert(coneTable, angleToUnit)
                    end
                end
            end
        end
        local facing, bestAngle, bestAngleUnitsHit = 0.1, 0, 0
        while facing <= 6.2 do
            local unitsHit = unitsAround
            for i = 1, #coneTable do
                local angleToUnit = coneTable[i]
                local angleDifference = facing > angleToUnit and facing - angleToUnit or angleToUnit - facing
                --local shortestAngle = angleDifference < math.pi and angleDifference or math.pi * 2 - angleDifference
                local finalAngle = angleDifference / math.pi * 180
                if finalAngle < angle then
                    unitsHit = unitsHit + 1
                end
            end
            if unitsHit > bestAngleUnitsHit then
                bestAngleUnitsHit = unitsHit
                bestAngle = facing
            end
            facing = facing + 0.05
        end
        if bestAngleUnitsHit >= minUnits then
            local mouselookActive = false
            if IsMouselooking() then
                mouselookActive = true
                MouselookStop()
                TurnOrActionStop()
                MoveAndSteerStop()
            end
            FaceDirection(bestAngle, true)
            CastSpellByName(GetSpellInfo(spell))
            FaceDirection(curFacing)
            if mouselookActive then
                MouselookStart()
            end
            lodFaced = true
            return true
        end
        return false
    end


    if inCombat and isChecked("Beacon of Virtue") and talent.beaconOfVirtue and cast.able.beaconOfVirtue() and getSpellCD(200025) == 0 and not IsMounted() then
        if getLowAllies(getValue("Beacon of Virtue")) >= getValue("BoV Targets") then
            if cast.beaconOfVirtue(lowest.unit) then
                return true
            end
        end
    end
    --[[ local function dumpers()

    end ]]
    local function bigDPS()
        if holyPower >= 3 then
            if cast.shieldOfTheRighteous() then
                return true
            end
        end

        if isChecked("Consecration") and cast.able.consecration() and #enemies.yards5 >= getValue("Consecration") and getDebuffRemain("target", 204242) == 0 and (not GetTotemInfo(1) or (getDistanceToObject("player", cX, cY, cZ) > 7) or GetTotemTimeLeft(1) < 2) then
            if cast.consecration() then
                cX, cY, cZ = GetObjectPosition("player")
                return
            end
        end

        if isChecked("Divine Toll during DPS Key") and #enemies.yards30 >= getValue("Divine Toll during DPS Key") and not GetUnitIsFriend("target", "player") then
            if cast.divineToll("target") then
                return
            end
        end

        if isChecked("Holy Shock Damage") and lowest.hp > getOptionValue("Holy Shock") and cast.able.holyShock() then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (isChecked("Dev Stuff Leave off") or getFacing("player", thisUnit)) and not debuff.glimmerOfLight.exists(thisUnit, "player") and not UnitIsDeadOrGhost(thisUnit) and getLineOfSight(thisUnit, "player") then
                    if cast.holyShock(thisUnit) then
                        --Print("Holy Shock 11: on " .. thisUnit)
                        return
                    end
                end
            end
            if cast.able.holyShock() then
                if cast.holyShock("target") then
                    --Print("Holy Shock 12")
                    return
                end
            end
        end

        for i = 1, #enemies.yards30 do
            thisUnit = enemies.yards30[i]
            if (isChecked("Dev Stuff Leave off") or getFacing("player", thisUnit)) and holyPower < 5 then
                if getHP(thisUnit) < 20 or buff.avengingWrath.exists("player") then
                    if cast.hammerOfWrath(thisUnit) then
                        return true
                    end
                end
            end
        end

        if isChecked("Crusader Strike") then
            if cast.crusaderStrike(units.dyn5) then
                return true
            end
        end

        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if (isChecked("Dev Stuff Leave off") or getFacing("player", thisUnit)) and not UnitIsDeadOrGhost(thisUnit) then
                if isChecked("Auto Focus target") and not UnitExists("target") and not UnitIsDeadOrGhost("focustarget") and UnitAffectingCombat("focustarget") and hasThreat("focustarget") then
                    TargetUnit("focustarget")
                end
                -- Start Attack
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) and isValidUnit("target") and getDistance("target") <= 5 then
                    StartAttack(units.dyn5)
                end
                -- Light's Hammer
                if isChecked("Light's Hammer Damage") and talent.lightsHammer and cast.able.lightsHammer() and not moving then
                    if cast.lightsHammer("best", false, getOptionValue("Light's Hammer Damage"), 10) then
                        return true
                    end
                end
                -- Judgment
                if not debuff.judgmentOfLight.exists("target") and talent.judgmentOfLight then
                    thisUnit = "target"
                end
                if isChecked("Judgment - DPS") and cast.able.judgment() and getFacing("player",thisUnit) and getLineOfSight(thisUnit, "player") then
                    if cast.judgment(thisUnit) then
                        return true
                    end
                end    
            end
        end  
    end
    local function spendies()
        if isChecked("Word of Glory") and (holyPower >= 3 or buff.divinePurpose.exists()) and inCombat then
            --Critical first
            if php <= getValue("Critical HP") then
                if cast.wordOfGlory("player") then
                    return true
                end
            end
            if (lowest.hp <= getValue("Word of Glory") or (holyPower == holyPowerMax and getLowAllies(99) < 2)) then
                if cast.wordOfGlory(lowest.unit) then 
                    return true
                end
            end
        end

        if isChecked("Light of Dawn") and cast.able.lightOfDawn() and (holyPower >= 3 or buff.divinePurpose.exists()) and inCombat then
            local LoDHealth = getValue("Light of Dawn")
            local LoDUnits = getValue("LoD Targets")
            if holyPower == holyPowerMax then
                LoDHealth = 100
                LoDUnits = 1
            end
            if not br.unlocked then --EasyWoWToolbox == nil then
                if healConeAround(LoDUnits, LoDHealth, 90, lightOfDawn_distance * lightOfDawn_distance_coff, 5 * lightOfDawn_distance_coff) then
                    if cast.lightOfDawn() then
                        return true
                    end
                end
            else
                if bestConeHeal(spell.lightOfDawn, LoDUnits, LoDHealth, 45, lightOfDawn_distance * lightOfDawn_distance_coff, 5) then
                    return true
                end
            end
        end
    end

    local function defensiveTime()
        if useDefensive() then
             module.BasicHealing()
			
            if isChecked("Gift of The Naaru") and php <= getOptionValue("Gift of The Naaru") and php > 0 and race == "Draenei" then
                if castSpell("player", racial, false, false, false) then
                    return true
                end
            end

            if isChecked("Divine Shield") and cast.able.divineShield() then
                if php <= getOptionValue("Divine Shield") and not UnitDebuffID("player", 25771) then
                    if cast.divineShield("player") then
                        return true
                    end
                end
            end

            if isChecked("Divine Protection") and cast.able.divineProtection() and not buff.divineShield.exists("player") then
                if php <= getOptionValue("Divine Protection") then
                    if cast.divineProtection() then
                        return true
                    end
                elseif buff.blessingOfSacrifice.exists("player") then
                    if cast.divineProtection() then
                        return true
                    end
                end
            end
        end
    end-- end defensive list

    local function bellsAndWhistles()
        -- cleanse your friends
        if mode.cleanse == 1 and cast.able.cleanse() then
            for i = 1, #br.friend do
                if canDispel(br.friend[i].unit, spell.cleanse) and getLineOfSight(br.friend[i].unit) and getDistance(br.friend[i].unit) <= 40 then
                    if cast.cleanse(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end

        -- Interrupt your enemies
        if useInterrupts() and (cast.able.blindingLight() or cast.able.hammerOfJustice()) then
            for i = 1, #enemies.yards10 do
                local thisUnit = enemies.yards10[i]
                local distance = getDistance(thisUnit)
                if canInterrupt(thisUnit, getOptionValue("InterruptAt")) and distance <= 10 then
                    -- Blinding Light
                    if isChecked("Blinding Light") and cast.able.blindingLight() then
                        if cast.blindingLight() then
                            return true
                        end
                    end
                    -- Hammer of Justice
                    if isChecked("Hammer of Justice") and cast.able.hammerOfJustice() and getBuffRemain(thisUnit, 226510) == 0 then
                        if cast.hammerOfJustice(thisUnit) then
                            return true
                        end
                    end
                end
            end
        end
    end

    local function Beacon() -- 100% credit to Laksmackt
        local beaconOfLightinRaid = nil
        local beaconOfLightTANK = nil
        local beaconOfFaithTANK = nil
        local beaconOfFaithplayer = nil
        LightCount = 0
        FaithCount = 0
        for i = 1, #br.friend do
            if UnitInRange(br.friend[i].unit) then
                if buff.beaconOfLight.exists(br.friend[i].unit) then
                    LightCount = LightCount + 1
                end
                if buff.beaconOfFaith.exists(br.friend[i].unit) then
                    FaithCount = FaithCount + 1
                end
            end
        end
        if mode.beacon == 1 and (inInstance or inRaid or OWGroup) and #tanks > 0 then
            for i = 1, #br.friend do
                if UnitInRange(br.friend[i].unit) and not UnitIsDeadOrGhost(br.friend[i].unit) then
                    if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and GetUnitIsUnit(br.friend[i].unit, "boss1target") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfLightinRaid = br.friend[i].unit
                    end
                    if LightCount < 1 and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfLightTANK = br.friend[i].unit
                    end
                    if FaithCount < 1 and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfFaithTANK = br.friend[i].unit
                    elseif FaithCount < 1 and not inRaid and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfFaithplayer = br.friend[i].unit
                    end
                end
            end
        end
        if mode.beacon == 2 and (inInstance or inRaid or OWGroup) and #tanks > 0 then
            for i = 1, #br.friend do
                if UnitInRange(br.friend[i].unit) and not UnitIsDeadOrGhost(br.friend[i].unit) then
                    if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and GetUnitIsUnit(br.friend[i].unit, "boss2target") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfLightinRaid = br.friend[i].unit
                    end
                    if LightCount < 1 and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfLightTANK = br.friend[i].unit
                    end
                    if FaithCount < 1 and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfFaithTANK = br.friend[i].unit
                    elseif FaithCount < 1 and not inRaid and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfFaithplayer = br.friend[i].unit
                    end
                end
            end
        end
        if mode.beacon == 3 and (inInstance or inRaid or OWGroup) and #tanks > 0 then
            for i = 1, #br.friend do
                if UnitInRange(br.friend[i].unit) and not UnitIsDeadOrGhost(br.friend[i].unit) then
                    if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and GetUnitIsUnit(br.friend[i].unit, "boss3target") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfLightinRaid = br.friend[i].unit
                    end
                    if LightCount < 1 and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfLightTANK = br.friend[i].unit
                    end
                    if FaithCount < 1 and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfFaithTANK = br.friend[i].unit
                    elseif FaithCount < 1 and not inRaid and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
                        beaconOfFaithplayer = br.friend[i].unit
                    end
                end
            end
        end
        if inRaid and beaconOfLightinRaid ~= nil then
            if cast.beaconOfLight(beaconOfLightinRaid) then
                return true
            end
        end
        if beaconOfLightTANK ~= nil and not cast.last.beaconOfLight() then
            if cast.beaconOfLight(beaconOfLightTANK) then
                return true
            end
        end
        if talent.beaconOfFaith then
            if beaconOfFaithTANK ~= nil then
                if cast.beaconOfFaith(beaconOfFaithTANK) then
                    return true
                end
            end
            if beaconOfFaithplayer ~= nil then
                if cast.beaconOfFaith(beaconOfFaithplayer) then
                    return true
                end
            end
        end
    end

    local function Coolies()
        local blessingOfProtectionall = nil
        local blessingOfProtectionTANK = nil
        local blessingOfProtectionHD = nil
        local blessingOfSacrificeall = nil
        local blessingOfSacrificeTANK = nil
        local blessingOfSacrificeDAMAGER = nil
        local layOnHandsTarget = nil

        -- check for bop target / BoS target
        for i = 1, #br.friend do
            if br.friend[i].hp < 100 and UnitInRange(br.friend[i].unit) and not UnitDebuffID(br.friend[i].unit, 25771) and not UnitIsDeadOrGhost(br.friend[i].unit) then
                if br.friend[i].hp <= getValue("Blessing of Protection") then
                    blessingOfProtectionall = br.friend[i].unit
                end
                if br.friend[i].hp <= getValue("Blessing of Protection") and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
                    blessingOfProtectionTANK = br.friend[i].unit
                end
                if br.friend[i].hp <= getValue("Blessing of Protection") and (UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or UnitGroupRolesAssigned(br.friend[i].unit) == "DAMAGER") then
                    blessingOfProtectionHD = br.friend[i].unit
                end
                if br.friend[i].hp <= getValue("Blessing of Sacrifice") and not GetUnitIsUnit(br.friend[i].unit, "player") then
                    blessingOfSacrificeall = br.friend[i].unit
                end
                if br.friend[i].hp <= getValue("Blessing of Sacrifice") and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
                    blessingOfSacrificeTANK = br.friend[i].unit
                end
                if br.friend[i].hp <= getValue("Blessing of Sacrifice") and UnitGroupRolesAssigned(br.friend[i].unit) == "DAMAGER" then
                    blessingOfSacrificeDAMAGER = br.friend[i].unit
                end
            end
        end

        if isChecked("Blessing of Protection") and cast.able.blessingOfProtection() and not UnitExists("boss1") then
            if getOptionValue("BoP Target") == 1 then
                if blessingOfProtectionall ~= nil then
                    if cast.blessingOfProtection(blessingOfProtectionall) then
                        return true
                    end
                end
            elseif getOptionValue("BoP Target") == 2 then
                if blessingOfProtectionTANK ~= nil then
                    if cast.blessingOfProtection(blessingOfProtectionTANK) then
                        return true
                    end
                end
            elseif getOptionValue("BoP Target") == 3 then
                if blessingOfProtectionHD ~= nil then
                    if cast.blessingOfProtection(blessingOfProtectionHD) then
                        return true
                    end
                end
            elseif getOptionValue("BoP Target") == 4 then
                if php <= getValue("Blessing of Protection") then
                    if cast.blessingOfProtection("player") then
                        return true
                    end
                end
            end
        end

        --get lay-d
        if isChecked("Lay on Hands - min") and getSpellCD(633) == 0 then
            for i = 1, #br.friend do
                if br.friend[i].hp < 100 and UnitInRange(br.friend[i].unit) and not UnitDebuffID(br.friend[i].unit, 25771) and not UnitIsDeadOrGhost(br.friend[i].unit) then
                    if getOptionValue("Lay on Hands Target") == 1 then
                        if br.friend[i].hp <= math.random(getValue("Lay on Hands - min"), getValue("Lay on Hands - max")) and (solo or OWGroup or inRaid or (inInstance)) then
                            layOnHandsTarget = br.friend[i].unit
                        end
                    elseif getOptionValue("Lay on Hands Target") == 2 then
                        if br.friend[i].hp <= math.random(getValue("Lay on Hands - min"), getValue("Lay on Hands - max")) and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and (not inInstance or (inInstance)) then
                            layOnHandsTarget = br.friend[i].unit
                        end
                    elseif getOptionValue("Lay on Hands Target") == 3 and getDebuffRemain("player", 267037) == 0 and php <= math.random(getValue("Lay on Hands - min"), getValue("Lay on Hands - max")) then
                        layOnHandsTarget = "player"
                    elseif getOptionValue("Lay on Hands Target") == 4 then
                        if UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "DAMAGER" then
                            if br.friend[i].hp <= math.random(getValue("Lay on Hands - min"), getValue("Lay on Hands - max")) and (not inInstance or (inInstance)) then
                                layOnHandsTarget = br.friend[i].unit
                            end
                        end
                    end
                    if layOnHandsTarget ~= nil then
                        if cast.layOnHands(layOnHandsTarget) then
                            return true
                        end
                    end
                end
            end
        end

        -- Cast BoS
        if isChecked("Blessing of Sacrifice") and cast.able.blessingOfSacrifice() then
            if getOptionValue("BoS Target") == 1 then
                if blessingOfSacrificeall ~= nil then
                    if cast.blessingOfSacrifice(blessingOfSacrificeall) then
                        return true
                    end
                end
            elseif getOptionValue("BoS Target") == 2 then
                if blessingOfSacrificeTANK ~= nil then
                    if cast.blessingOfSacrifice(blessingOfSacrificeTANK) then
                        return true
                    end
                end
            elseif getOptionValue("BoS Target") == 3 then
                if blessingOfSacrificeDAMAGER ~= nil then
                    if cast.blessingOfSacrifice(blessingOfSacrificeDAMAGER) then
                        return true
                    end
                end
            end
        end

        -- Holy Avenger
        if isChecked("Holy Avenger") and cast.able.holyAvenger() and talent.holyAvenger then
            if getLowAllies(getValue "Holy Avenger") >= getValue("Holy Avenger Targets") then
                if cast.holyAvenger() then
                    return true
                end
            end
        end
        -- Avenging Wrath
        if isChecked("Avenging Wrath") and cast.able.avengingWrath() and not talent.avengingCrusader then
            if getLowAllies(getValue "Avenging Wrath") >= getValue("Avenging Wrath Targets") then
                if cast.avengingWrath() then
                    return true
                end
            end
        end
        -- Avenging Crusader
        if isChecked("Avenging Crusader") and cast.able.avengingCrusader() and talent.avengingCrusader and getDistance("target") <= 5 then
            if getLowAllies(getValue "Avenging Crusader") >= getValue("Avenging Crusader Targets") then
                if cast.avengingCrusader() then
                    return true
                end
            end
        end
        -- Aura Mastery
        if isChecked("Aura Mastery") and cast.able.auraMastery() then
            if getLowAllies(getValue "Aura Mastery") >= getValue("Aura Mastery Targets") then
                if cast.auraMastery() then
                    return true
                end
            end
        end
        if isChecked("Rule of Law") and cast.able.ruleOfLaw() and talent.ruleOfLaw and not buff.ruleOfLaw.exists("player") then
            if getLowAllies(getValue("Rule of Law")) >= getValue("RoL Targets") then
                if cast.ruleOfLaw() then
                    return
                end
            end
        end
    end-- end coolies

    local function damageTime()
        if mode.damage == 1 then
            if isChecked("Shield of the Righteous") and lowest.hp >= getValue("Word of Glory") and cast.able.shieldOfTheRighteous() and #enemies.yards5 >= getValue("Shield of the Righteous") and (holyPower >= 3 or buff.divinePurpose.exists()) then
                if cast.shieldOfTheRighteous(units.dyn5) then
                    return true
                end
            end
            if isChecked("Holy Shock Damage") and lowest.hp > getOptionValue("Holy Shock") and cast.able.holyShock() then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (isChecked("Dev Stuff Leave off") or getFacing("player", thisUnit)) and not debuff.glimmerOfLight.exists(thisUnit, "player") and not UnitIsDeadOrGhost(thisUnit) and getLineOfSight(thisUnit, "player") then
                        if cast.holyShock(thisUnit) then
                            --Print("Holy Shock 11: on " .. thisUnit)
                            return
                        end
                    end
                end
                if cast.able.holyShock() then
                    if cast.holyShock("target") then
                        --Print("Holy Shock 12")
                        return
                    end
                end
            end

            
            --Consecration
            if isChecked("Consecration") and cast.able.consecration() and #enemies.yards5 >= getValue("Consecration") and getDebuffRemain("target", 204242) == 0 and (not GetTotemInfo(1) or (getDistanceToObject("player", cX, cY, cZ) > 7) or GetTotemTimeLeft(1) < 2) then
                if cast.consecration() then
                    cX, cY, cZ = GetObjectPosition("player")
                    return
                end
            end
            if mode.wrath == 2 then
                for i = 1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if (isChecked("Dev Stuff Leave off") or getFacing("player", thisUnit)) and holyPower < 5 then
                        if getHP(thisUnit) < 20 or buff.avengingWrath.exists("player") then
                            if cast.hammerOfWrath(thisUnit) then
                                return true
                            end
                        end
                    end
                end
            end
            if isChecked("Crusader Strike") then
                if cast.crusaderStrike(units.dyn5) then
                    return true
                end
            end


            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if (isChecked("Dev Stuff Leave off") or getFacing("player", thisUnit)) and not UnitIsDeadOrGhost(thisUnit) then
                    if isChecked("Auto Focus target") and not UnitExists("target") and not UnitIsDeadOrGhost("focustarget") and UnitAffectingCombat("focustarget") and hasThreat("focustarget") then
                        TargetUnit("focustarget")
                    end
                    -- Start Attack
                    if not IsAutoRepeatSpell(GetSpellInfo(6603)) and isValidUnit("target") and getDistance("target") <= 5 then
                        StartAttack(units.dyn5)
                    end
                    -- Light's Hammer
                    if isChecked("Light's Hammer Damage") and talent.lightsHammer and cast.able.lightsHammer() and not moving then
                        if cast.lightsHammer("best", false, getOptionValue("Light's Hammer Damage"), 10) then
                            return true
                        end
                    end
                    -- Judgment
                    if not debuff.judgmentOfLight.exists("target") and talent.judgmentOfLight then
                        thisUnit = "target"
                    end
                    if isChecked("Judgment - DPS") and cast.able.judgment() and getFacing("player",thisUnit) and getLineOfSight(thisUnit, "player") then
                        if cast.judgment(thisUnit) then
                            return true
                        end
                    end    
                end
            end            
        end
    end-- end of dps

    local function healingTime()
        --Divine Toll Implementation
        if isChecked("Divine Toll") and cast.able.divineToll() and holyPower <= getValue("Max Holy Power") and inCombat then
            if getOptionValue("Divine Toll") == 1 and holyPower == 0 then
                --Print("trying to cast")
                CastSpellByName(GetSpellInfo(spell.divineToll),lowest.unit)
            end
            if getOptionValue("Divine Toll") == 2 then
                if getLowAllies(getValue("Divine Toll Health")) >= getValue("Divine Toll Units") then
                    --Print("trying to cast")
                    CastSpellByName(GetSpellInfo(spell.divineToll),lowest.unit)
                end
            end
        end

        -- Glimmer support
        if mode.glimmer == 3 and (inInstance or inRaid) and #tanks > 0 then
            for i = 1, #tanks do
                local thisUnit = tanks[i].unit
                if not UnitBuffID(thisUnit, 287280, "PLAYER") and not UnitBuffID(thisUnit, 115191) and getLineOfSight(thisUnit, "player") then
                    if cast.holyShock(thisUnit) then
                        --Print("Holy Shock tank")
                        return true
                    end
                end
            end
            if talent.crusadersMight and lowest.hp > getValue("Critical HP") and (getSpellCD(20473) > (gcd)) then
                if cast.crusaderStrike(units.dyn5) then
                    return true
                end
            end
        end

        if mode.glimmer == 1 and (inInstance or inRaid or OWGroup or solo) then
            if getSpellCD(20473) < gcd then
                -- Check here to see if shock is not ready, but dawn is - then use dawn
                --critical first
                for i = 1, #tanks do
                    local thisUnit = tanks[i].unit
                    local thisHP = tanks[i].hp
                    if thisHP <= getValue("Critical HP") and getLineOfSight(tanks[i].unit, "player") then
                        if cast.holyShock(thisUnit) then
                            --Print("Holy Shock 1")
                            return true
                        end
                    end
                end
                if isChecked("Self Shock") and php <= getValue("Self Shock") and not UnitBuffID("player", 287280, "PLAYER") then
                    if cast.holyShock("player") then
                        --Print("Holy Shock 2")
                        return true
                    end
                end
                if lowest.hp <= getValue("Critical HP") then
                    if cast.holyShock(lowest.unit) then
                        --Print("Holy Shock 3")
                        return true
                    end
                end
                --find lowest friend without glitter buff on them - tank first
                for i = 1, #br.friend do
                    if getLineOfSight(br.friend[i].unit, "player") then
                        if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not UnitIsDeadOrGhost(br.friend[i].unit) and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) and not UnitBuffID(br.friend[i].unit, 287280) then
                            if cast.holyShock(br.friend[i].unit) then
                                --Print("Holy Shock 4")
                                --Print(br.friend[i].unit)
                                return true
                            end
                        end
                    end
                end
                glimmerTable = {}
                for i = 1, #br.friend do
                    if getLineOfSight(br.friend[i].unit, "player") and not UnitIsDeadOrGhost(br.friend[i].unit) and not UnitBuffID(br.friend[i].unit, 287280, "PLAYER") and not UnitBuffID(br.friend[i].unit, 115191) then
                        tinsert(glimmerTable, br.friend[i])
                    end
                end
                if #glimmerTable > 1 then
                    table.sort(
                        glimmerTable,
                        function(x, y)
                            return x.hp < y.hp
                        end
                    )
                end
                if glimmerCount ~= nil and glimmerCount >= 8 and getLineOfSight(lowest.unit, "player") then
                    if cast.holyShock(lowest.unit) then
                        --Print("Holy Shock 5")
                        --Print("Glimmer cap glimmer")
                        return
                    end
                end
                if #glimmerTable >= 1 and glimmerTable[1].unit ~= nil and mode.glimmer == 1 then
                    if cast.holyShock(glimmerTable[1].unit) then
                        --Print("Holy Shock 6")
                        --Print("Just glimmered: " .. glimmerTable[1].unit)
                        return true
                    end
                end
                if glimmerTable ~= nil and #glimmerTable == 0 and (not isChecked("Holy Shock Damage") or (isChecked("Holy Shock Damage") and lowest.hp <= getValue("Holy Shock"))) then
                    if cast.holyShock(lowest.unit) then
                        --Print("Holy Shock 7")
                        return true
                    end
                end
            end
            if talent.crusadersMight and lowest.hp > getValue("Critical HP") and (getSpellCD(20473) > (gcd)) then
                if cast.crusaderStrike(units.dyn5) then
                    return true
                end
            end
        end

        if isChecked("Holy Shock") and getSpellCD(20473) < gcd and mode.glimmer ~= 1 then
            --critical first
            if #tanks > 0 then
                if tanks[1].hp <= getValue("Critical HP") and not UnitIsDeadOrGhost(tanks[1].unit) then
                    if cast.holyShock(tanks[1].unit) then
                        --Print("Holy Shock 8")
                        return true
                    end
                end
            end
            if php <= getValue("Critical HP") or getBuffRemain("player", 265773) ~= 0 then
                if cast.holyShock("player") then
                    --Print("Holy Shock 9")
                    return true
                end
            end
            if lowest.hp <= getValue("Holy Shock") then
                if cast.holyShock(lowest.unit) then
                    --("Holy Shock 10")
                    return true
                end
            end
        end

        if php >= getValue("LotM player HP limit") then
            for i = 1, #br.friend do
                local thisUnit = br.friend[i].unit
                local thisHP = br.friend[i].hp
                if not GetUnitIsUnit(thisUnit, "player") and not UnitIsDeadOrGhost(thisUnit) then
                    if isChecked("Moving LotM") and thisHP <= getValue("Moving LotM") and moving then
                        if cast.lightOfTheMartyr(thisUnit) then
                            return true
                        end
                    end
                    if isChecked("LoM after FoL") and thisHP <= getValue("LoM after FoL") and cast.last.flashOfLight() then
                        if cast.lightOfTheMartyr(thisUnit) then
                            return true
                        end
                    end
                    if isChecked("Light of the Martyr") and thisHP <= getValue("Light of the Martyr") then
                        if cast.lightOfTheMartyr(thisUnit) then
                            return true
                        end
                    end
                end
            end
        end

        if isChecked("Flash of Light") and not moving and select(2,GetSpellCooldown(61304)) == 0 then
            --Critical first
            if php <= getValue("Critical HP") then
                if cast.flashOfLight("player") then
                    return true
                end
            end
            if #tanks > 0 then
                if tanks[1].hp <= getValue("Critical HP") and not UnitIsDeadOrGhost(tanks[1].unit) then
                    if cast.flashOfLight(tanks[1].unit) then
                        return true
                    end
                end
            end
            if lowest.hp <= getValue("Critical HP") then
                if cast.flashOfLight(lowest.unit) then
                    return true
                end
            end

            if lowestBeacon.unit ~= nil and isChecked("FoL Beacon") and lowestBeacon.hp <= getValue("FoL Beacon") then
                if cast.flashOfLight(lowestBeacon.unit) then
                    return true
                end
            end

            if lowest.hp <= getValue("Flash of Light") or (lowest.hp <= getValue("FoL Infuse") and buff.infusionOfLight.exists() and not cast.last.flashOfLight()) then
                if cast.flashOfLight(lowest.unit) then
                    return true
                end
            end

            if #tanks > 0 then
                if tanks[1].hp <= getValue("FoL Tanks") and not UnitIsDeadOrGhost(tanks[1].unit) then
                    if cast.flashOfLight(tanks[1].unit) then
                        return true
                    end
                end
            end
        end

        if isChecked("Holy Prism") and talent.holyPrism and cast.able.holyPrism() and inCombat then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                local lowHealthCandidates = getUnitsToHealAround(thisUnit, 15, getValue("Holy Prism"), #br.friend)
                if #lowHealthCandidates >= getValue("Holy Prism Targets") then
                    if cast.holyPrism(thisUnit) then
                        return true
                    end
                end
            end
        end

        if isChecked("Holy Light") and not moving and getSpellCD(20473) > gcd and (getOptionValue("Holy Light Infuse") == 1 or (getOptionValue("Holy Light Infuse") == 2 and buff.infusionOfLight.remain() > getCastTime(spell.holyLight))) then
            if lowest.hp <= getValue("Holy Light") then
                if cast.holyLight(lowest.unit) then
                    return true
                end
            end
        end
    end -- end healing

    if isChecked("Sunking") and lowest.hp >= getValue("Critical HP") then
        if (GetObjectID("target") == 165759 or GetObjectID("target") == 171577) and inCombat then
            if getHP("target") < 100 then
                if not buff.beaconOfLight.exists("target") then 
                    if cast.beaconOfLight("target") then
                        return true
                    end
                end
                if holyPower >= 3 or buff.divinePurpose.exists() then 
                    if cast.wordOfGlory("target") then
                        return true
                    end
                end
                if cast.holyShock("target") then
                    return true
                end
                if cast.flashOfLight("target") then
                    return true
                end
            end
        end
    end

    if isChecked("Automatic Aura replacement") then
		if not buff.devotionAura.exists() and (not IsMounted() or buff.divineSteed.exists()) then
			if CastSpellByName(GetSpellInfo(465)) then return end
		elseif not buff.crusaderAura.exists() and IsMounted() then
			if CastSpellByName(GetSpellInfo(32223)) then return end
		end
    end
    if (not IsMounted() or buff.divineSteed.exists()) then
        if pause(true) or drinking or isLooting() then
            return true
        else
            if not inCombat and not UnitBuffID("player", 115834) then

                if bellsAndWhistles() then
                    return
                end

                if isChecked("OOC Healing") then
                    if mode.beacon ~= 4 and not talent.beaconOfVirtue then
                        if Beacon() then
                            return
                        end
                    end

                    if healingTime() then
                        return
                    end
                end
            end
            if inCombat and not UnitBuffID("player", 115834) then
                if isChecked("Hard DPS Key") and (SpecificToggle("Hard DPS Key") and not GetCurrentKeyBoardFocus()) then
                    if bigDPS() then
                        return true
                    end
                elseif not isChecked("Hard DPS Key") or not (SpecificToggle("Hard DPS Key") and not GetCurrentKeyBoardFocus()) then
                    if (isChecked("Blessing of Freedom") and cast.able.blessingOfFreedom()) then
                        if UnitCastingInfo("boss1") == GetSpellInfo(320788) then
                            if cast.blessingOfFreedom("boss1target") then return true end
                        end
                        if hasNoControl(spell.blessingOfFreedom) then
                            if cast.blessingOfFreedom("player") then
                                return true
                            end
                        end
                    end
                    if spendies() then
                        return
                    end

                    if useCDs() then
                        if Coolies() then
                            return
                        end
                    end

                    if mode.wrath == 1 then
                        for i = 1, #enemies.yards30 do
                            thisUnit = enemies.yards30[i]
                            if (isChecked("Dev Stuff Leave off") or getFacing("player", thisUnit)) and holyPower < 5 and lowest.hp >= getValue("Critical HP") then
                                if getHP(thisUnit) < 20 or buff.avengingWrath.exists("player") then
                                    if cast.hammerOfWrath(thisUnit) then
                                        return true
                                    end
                                end
                            end
                        end
                    end

                    if defensiveTime() then
                        return
                    end

                    if bellsAndWhistles() then
                        return
                    end

                    if mode.beacon ~= 4 and not talent.beaconOfVirtue then
                        if Beacon() then
                            return
                        end
                    end

                    if healingTime() then
                        return
                    end

                    if not isChecked("Hard Lock Crit Heal") or lowest.hp > getValue("Critical HP") then
                        if damageTime() then
                            return
                        end
                    end
                end
            end
        end
    end
end

local id = 65
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
tinsert(
    br.rotations[id],
    {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation
    }
)

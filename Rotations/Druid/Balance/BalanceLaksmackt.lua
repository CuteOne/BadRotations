local rotationName = "Laksmackt" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Define custom toggles
    -- Rotation Button
    local RotationModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Automatic Rotation",
            tip = "Swaps between Single and Multiple based on number of enemies in range.",
            highlight = 1,
            icon = br.player.spell.moonfire
        },
        [2] = { mode = "Mult", value = 2, overlay = "Multi Target rotation", tip = "Multi Target rotation", highlight = 1, icon = br.player.spell.starfall },
        [3] = { mode = "Sing", value = 3, overlay = "Force single target", tip = "Force single target", highlight = 0, icon = br.player.spell.wrath },
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.soothe }
    }
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)

    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.celestialAlignment },
        [2] = { mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.celestialAlignment },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.celestialAlignment }
    }
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)

    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.barkskin },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.barkskin }
    }
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)

    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.solarBeam },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.solarBeam }
    }
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)

    -- FoN Button
    local ForceofNatureModes = {
        [1] = { mode = "On", value = 1, overlay = "Force of Nature Enabled", tip = "Will Use Force of Nature", highlight = 0, icon = br.player.spell.forceOfNature },
        [2] = { mode = "Key", value = 2, overlay = "Force of Nature hotkey", tip = "Key triggers Force of Nature", highlight = 0, icon = br.player.spell.forceOfNature },
        [3] = { mode = "Off", value = 2, overlay = "Force of Nature Disabled", tip = "Will Not Use Force of Nature", highlight = 0, icon = br.player.spell.forceOfNature }
    }
    br.ui:createToggle(ForceofNatureModes, "ForceofNature", 5, 0)

    local FormsModes = {
        [1] = { mode = "On", value = 1, overlay = "Auto Forms Enabled", tip = "Will change forms", highlight = 0, icon = br.player.spell.travelForm },
        [2] = { mode = "Key", value = 2, overlay = "Auto Forms hotkey", tip = "Key triggers Auto Forms", highlight = 0, icon = br.player.spell.travelForm },
        [3] = { mode = "Off", value = 3, overlay = "Auto Forms Disabled", tip = "Will Not change forms", highlight = 0, icon = br.player.spell.travelForm }
    }
    br.ui:createToggle(FormsModes, "Forms", 6, 0)

    local CovModes = {
        [1] = { mode = "On", value = 1, overlay = "Use Covenant", tip = "Use Covenant powers", highlight = 0, icon = br.player.spell.summonSteward },
        [2] = { mode = "Off", value = 2, overlay = "Use Covenant", tip = "Use Covenant powers", highlight = 0, icon = br.player.spell.summonSteward }
    }
    br.ui:createToggle(CovModes, "Cov", 1, -1)

    --[[
    --pots
    PotsModes = {
        [1] = { mode = "On", value = 1, overlay = "Auto Pots Enabled", tip = "Auto Pots Enabled", highlight = 0, icon = 197524 },
        [2] = { mode = "Off", value = 2, overlay = "Auto Pots Disabled", tip = "Auto Pots Disabled", highlight = 0, icon = 197524 },
    };
    CreateButton("Pots", 7, 0)
]]
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
        local section = br.ui:createSection(br.ui.window.profile, "Forms - SL 2101171530")
        br.ui:createDropdownWithout(section, "Cat Key", br.dropOptions.Toggle, 6, "Set a key for cat")
        br.ui:createDropdownWithout(section, "Bear Key", br.dropOptions.Toggle, 6, "Set a key for bear")
        br.ui:createDropdown(section, "Treants Key", br.dropOptions.Toggle, 6, "", "Treant Key")
        br.ui:createDropdownWithout(section, "Travel Key", br.dropOptions.Toggle, 6, "Set a key for travel")
        br.ui:createCheckbox(section, "Use Mount Form", "Uses the Mount Form for ground travel.", 1)
        br.ui:createCheckbox(section, "Cat Charge", "Use Wild Charge to close distance.", 1)
        br.ui:createCheckbox(section, "auto stealth", 1)
        br.ui:createCheckbox(section, "auto dash", 1)
        br.ui:createSpinner(section, "Bear Frenzies Regen HP", 50, 0, 100, 1, "HP Threshold start regen")
        br.ui:createSpinner(section, "Standing Time", 2.5, 0.5, 10, 0.5, "How long you will stand still before changing to owl - in seconds")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "General")
        br.ui:createSpinner(section, "Pre-Pull Timer", 2.5, 0, 10, 0.5, "Set to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")

        br.ui:createSpinner(section, "OOC Regrowth", 50, 1, 100, 5, "Set health to heal while out of combat. Min: 1 / Max: 100 / Interval: 5")
        if br.player.talent.restorationAffinity then
            br.ui:createSpinner(section, "OOC Wild Growth", 50, 1, 100, 5, "Set health to heal while out of combat. Min: 1 / Max: 100 / Interval: 5")
        end
        br.ui:createCheckbox(section, "Auto Soothe")
        br.ui:createCheckbox(section, "Auto Engage On Target", "Check this to cast sunfire on target OOC to engage combat")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Healing")
        br.ui:createDropdown(section, "Rebirth", { "Tanks", "Healers", "Tanks and Healers", "Mouseover Target", "Any" }, 3, "", "Target to Cast On")
        br.ui:createDropdown(section, "Revive", { "Target", "mouseover" }, 1, "", "Target to Cast On")
        br.ui:createDropdown(section, "Remove Corruption", { "Player Only", "Selected Target", "Player and Target", "Mouseover Target", "Any" }, 3, "", "Target to Cast On")
        br.ui:createDropdown(section, "Off-healing", { "Nope", "always", "No-Healer" }, 1, "", "offheal")

        br.ui:checkSectionState(section)

        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------

        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Pots")
        br.ui:createDropdown(section, "Auto use Pots", { "Always", "Groups", "Raids", "solo", "never" }, 5, "", "when to use pots")
        br.ui:createDropdownWithout(
                section,
                "Pots - 1 target",
                { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury" },
                1,
                "",
                "Use Pot when Incarnation/Celestial Alignment is up"
        )
        br.ui:createDropdownWithout(
                section,
                "Pots - 2-3 targets",
                { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury" },
                1,
                "",
                "Use Pot when Incarnation/Celestial Alignment is up"
        )
        br.ui:createDropdownWithout(
                section,
                "Pots - 4+ target",
                { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury" },
                1,
                "",
                "Use Pot when Incarnation/Celestial Alignment is up"
        )
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createCheckbox(section, "Auto Innervate", "Use Innervate")
        br.ui:createCheckbox(section, "Racial")
        br.ui:createCheckbox(section, "Use Trinkets")
        br.ui:createCheckbox(section, "Warrior Of Elune")
        br.ui:createCheckbox(section, "Fury Of Elune")
        br.ui:createSpinnerWithout(section, "Fury of Elune Targets", 3, 1, 10, 1, "How many baddies before using Fury?")
        br.ui:createCheckbox(section, "Group Fury with CD")
        br.ui:createSpinner(section, "Incarnation/Celestial Alignment", 10, 5, 30, 5, "Min TTD")
        br.ui:createSpinnerWithout(section, "Treant Targets", 3, 1, 10, 1, "How many baddies before using Treant?")
        br.ui:createCheckbox(section, "Group treants with CD")
        br.ui:checkSectionState(section)
        -------------------------
        ---  TARGET OPTIONS   ---  -- Define Target Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Targets")
        br.ui:createSpinnerWithout(section, "Max Stellar Flare Targets", 2, 1, 10, 1, "Set to maximum number of targets to dot with Stellar Flare. Min: 1 / Max: 10 / Interval: 1")
        br.ui:createSpinnerWithout(section, "Max Moonfire Targets", 5, 1, 10, 1, "Set to maximum number of targets to dot with Moonfire. Min: 1 / Max: 10 / Interval: 1")
        br.ui:createSpinnerWithout(section, "Max Sunfire Targets", 10, 1, 10, 1, "Set to maximum number of targets to dot with Sunfire. Min: 1 / Max: 10 / Interval: 1")
        br.ui:createCheckbox(section, "Safe Dots")
        br.ui:createDropdownWithout(section, "Starfall", { "Simc", "AOE", "Never" }, 1, "", "Do We use Starfall?")
        br.ui:createCheckbox(section, "Starfall While moving")
        br.ui:createSpinnerWithout(section, "Fury of Elune Targets", 2, 1, 10, 1, "Set to minimum number of targets to use Fury of Elune. Min: 1 / Max: 10 / Interval: 1")
        br.ui:createCheckbox(section, "Prefer Lunar Eclipse")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "M+")
        br.ui:createCheckbox(section, "Sunfire Explosives")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Root/CC")
        br.ui:createCheckbox(section, "Mist - Spirit vulpin")
        br.ui:createCheckbox(section, "Plague - Globgrod")
        br.ui:createCheckbox(section, "Root - Spiteful(M+)")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Potion/Healthstone", 20, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Renewal", 25, 0, 100, 1, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Barkskin", 60, 0, 100, 1, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Regrowth", 30, 0, 100, 1, "Health Percent to Cast At")
        if br.player.talent.restorationAffinity then
            br.ui:createSpinner(section, "Swiftmend", 15, 0, 100, 1, "Health Percent to Cast At")
            br.ui:createSpinner(section, "Rejuvenation", 50, 0, 100, 1, "Health Percent to Cast At")
        end
        br.ui:checkSectionState(section)

        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createCheckbox(section, "Solar Beam")
        br.ui:createCheckbox(section, "Mighty Bash")
        br.ui:createCheckbox(section, "Typhoon")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "InterruptAt", 0, 0, 95, 5, "Cast Percentage to use at.")
        br.ui:checkSectionState(section)

    end

    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        }
    }
    return optionTable
end
local eclipse_next = "any"

local timers = {}
timers._timers = {}
function timers.time(name, fn)
    local time = timers._timers[name]
    if fn then
        if not time then
            time = br._G.GetTime()
        end
    else
        time = nil
    end
    timers._timers[name] = time
    return time and (br._G.GetTime() - time) or 0
end

local function runRotation()
    --------------
    --- Locals ---
    --------------

    local power = br.player.power.astralPower.amount()
    local buff = br.player.buff
    local cast = br.player.cast
    local php = br.player.health
    local spell = br.player.spell
    local talent = br.player.talent
    local cd = br.player.cd
    local charges = br.player.charges
    local debuff = br.player.debuff
    local drinking = br.getBuffRemain("player", 192002) ~= 0 or br.getBuffRemain("player", 167152) ~= 0 or br.getBuffRemain("player", 192001) ~= 0
    local inCombat = br.player.inCombat
    local inInstance = br.player.instance == "party" or br.player.instance == "scenario"
    local inRaid = br.player.instance == "raid"
    local solo = #br.friend == 1
    local race = br.player.race
    local moving = br.isMoving("player")
    local swimming = br._G.IsSwimming()
    local flying = br._G.IsFlying()
    local ttd = br.getTTD
    local catspeed = br.player.buff.dash.exists() or br.player.buff.tigerDash.exists() or br.player.buff.stampedingRoar.exists() or br.player.buff.stampedingRoarCat.exists() or br.player.buff.stampedingRoar.exists()
    local hasteAmount = br._G.GetHaste() / 100
    local masteryAmount = br._G.GetMastery() / 100
    local thisUnit
    local conduit = br.player.conduit
    local covenant = br.player.covenant
    local travel = br.player.buff.travelForm.exists()
    local mount = br._G.GetShapeshiftForm() == 6 --- or maybe br.player.buff.mountForm.exists() but this is not working (mountform has no buff? idk)
    local cat = br.player.buff.catForm.exists()
    local moonkin = br.player.buff.moonkinForm.exists()
    local bear = br.player.buff.bearForm.exists()

    local unit = br.player.unit
    local units = br.player.units
    local ui = br.player.ui
    local runeforge = br.player.runeforge

    -- spellqueue ready
    local function spellQueueReady()
        --Check if we can queue cast
        local castingInfo = { br._G.UnitCastingInfo("player") }
        if castingInfo[5] then
            if (br._G.GetTime() - ((castingInfo[5] - tonumber(br._G.C_CVar.GetCVar("SpellQueueWindow"))) / 1000)) < 0 then
                return false
            end
        end
        return true
    end

    -------------
    -- Raid
    ------------

    local tanks = br.getTanksTable()
    local gcd = br.player.gcdMax
    -- Enemies
    -------------
    local enemies = br.player.enemies
    local mode
    local units = br.player.units
    local pewbuff = (buff.incarnationChoseOfElune.exists() or buff.celestialAlignment.exists()) or false

    local tank
    if #tanks > 0 and inInstance then
        tank = tanks[1].unit
    else
        tank = "Player"
    end

    --wipe timers table
    if br.timersTable then
        br._G.wipe(br.timersTable)
    end
    mode = br.player.ui.mode
    enemies.get(5)

    enemies.get(8, "target") -- enemies.yards8t
    enemies.get(10, "target", true)
    enemies.get(11, "target") -- enemies.yards8t
    enemies.get(12)
    enemies.get(12, "target") -- enemies.yards12t
    enemies.get(15)
    enemies.get(15, "target") -- enemies.yards15t
    enemies.get(40)
    enemies.get(45)
    units.get(45)

    local furyUnits = 0
    if cast.able.furyOfElune() then
        for i = 1, #enemies.yards10tnc do
            thisUnit = enemies.yards10tnc[i]
            if ttd(thisUnit) > 8 then
                furyUnits = furyUnits + 1
            end
        end
    end

    local function already_stunned(Unit)
        if Unit == nil then
            return false
        end
        local already_stunned_list = {
            [47481] = "Gnaw",
            [5211] = "Mighty Bash",
            [22570] = "Maim",
            [19577] = "Intimidation",
            [119381] = "Leg Sweep",
            [853] = "Hammer of Justice",
            [408] = "Kidney Shot",
            [1833] = "Cheap Shot",
            [199804] = "Between the eyes",
            [107570] = "Storm Bolt",
            [46968] = "Shockwave",
            [221562] = "Asphyxiate",
            [91797] = "Monstrous Blow",
            [179057] = "Chaos Nova",
            [211881] = "Fel Eruption",
            [1822] = "Rake",
            [192058] = "Capacitor Totem",
            [118345] = "Pulverize",
            [89766] = "Axe Toss",
            [30283] = "Shadowfury",
            [1122] = "Summon Infernal"
        }
        for i = 1, #already_stunned_list do
            local debuffSpellID = select(10, br._G.UnitDebuff(Unit, i))
            if debuffSpellID == nil then
                return false
            end

            if already_stunned_list[tonumber(debuffSpellID)] ~= nil then
                return true
            end
        end
        return false
    end

    local function int (b)
        return b and 1 or 0
    end

    local function isCC(unit)
        if br.getOptionCheck("Don't break CCs") then
            return br.isLongTimeCCed(unit)
        end
    end

    local function hasHot(unit)
        if buff.rejuvenation.exists(unit) or buff.regrowth.exists(unit) or buff.wildGrowth.exists(unit) then
            return true
        else
            return false
        end
    end

    local function count_hots(unit)
        local count = 0
        if buff.rejuvenation.exists(unit) then
            count = count + 1
        end
        if buff.regrowth.exists(unit) then
            count = count + 1
        end
        if buff.wildGrowth.exists(unit) then
            count = count + 1
        end
        return count
    end

    function br.getDebuffCount(spellID)
        local counter = 0
        for k, _ in pairs(br.enemy) do
            thisUnit = br.enemy[k].unit
            -- check if unit is valid
            if br.GetObjectExists(thisUnit) then
                -- increase counter for each occurences
                if br.UnitDebuffID(thisUnit, spellID, "exact") then
                    counter = counter + 1
                end
            end
        end
        return tonumber(counter)
    end
    local function getBiggestUnitCluster(maxRange, radius)
        if type(maxRange) ~= "number" then
            return nil
        end
        if type(radius) ~= "number" then
            return nil
        end

        local enemiesInRange = 0
        local theReturnUnit

        for i = 1, #br.enemy do
            thisUnit = br.enemy[i].unit
            if br.getLineOfSight(thisUnit) == true then
                if br.enemy[i].distance < maxRange then
                    if br.getNumEnemies(thisUnit, radius) > enemiesInRange then
                        theReturnUnit = thisUnit
                    end
                end
            end
        end
        return select(1, theReturnUnit)
    end

    --Clear last cast table ooc to avoid strange casts
    if #br.lastCastTable.tracker > 0 then
        br._G.wipe(br.lastCastTable.tracker)
    end

    local astral_max = 0
    local astral_def = 0

    if talent.naturesBalance then
        astral_max = 95
    else
        astral_max = 100
    end
    astral_def = astral_max - power

    local function noDamageCheck(unit)
        if br.isChecked("Sunfire Explosives") and br.GetObjectID(unit) == 120651 then
            return true
        end
        if br.isChecked("Dont DPS spotter") and br.GetObjectID(unit) == 135263 then
            return true
        end
        if isCC(unit) then
            return true
        end
        if br.GetObjectID(unit) == 127019 then
            --dummies inside of Freehold
            return true
        end
        if br.hasBuff(263246, unit) then
            -- shields on first boss in temple
            return true
        end
        if br.hasBuff(260189, unit) then
            -- shields on last boss in MOTHERLODE
            return true
        end
        if br.hasBuff(261264, unit) or br.hasBuff(261265, unit) or br.hasBuff(261266, unit) then
            -- shields on witches in wm
            return true
        end
        return false
    end

    local function pew_remain()
        if talent.incarnationChoseOfElune then
            return cd.incarnationChoseOfElune.remain()
        else
            return cd.celestialAlignment.remain()
        end
    end

    local standingTime = 0
    if br.DontMoveStartTime then
        standingTime = br._G.GetTime() - br.DontMoveStartTime
    end

    function br.isExplosive(Unit)
        return br.GetObjectID(Unit) == 120651
    end

    local function getOutLaksTTDMAX()
        local highTTD = 0
        local mob_count = #enemies.yards45
        if mob_count > 6 then
            mob_count = 6
        end
        if #enemies.yards45 > 0 then
            for i = 1, mob_count do
                if br.getTTD(enemies.yards45[i]) > highTTD and br.getTTD(enemies.yards45[i]) < 999 and not br.isExplosive(enemies.yards45[i]) and br.isSafeToAttack(enemies.yards45[i]) then
                    highTTD = br.getTTD(enemies.yards45[i])
                end
            end
        end
        return tonumber(highTTD)
    end

    local function dps()
        if spellQueueReady() then

            if #enemies.yards45 == 0 and buff.ravenousFrenzy.exists() then
                if cast.rejuvenation() then
                    return true
                end
            end

            if mode.forms ~= 3 then
                if not br.player.buff.moonkinForm.exists() and not buff.prowl.exists() and not cast.last.moonkinForm(1) then
                    unit.cancelForm()
                    if cast.moonkinForm() then
                        return true
                    end
                end
            end

            local radar = "off"

            --Building root list
            local root_UnitList = {}
            if br.isChecked("Mist - Spirit vulpin") then
                root_UnitList[165251] = "Spirit vulpin"
                radar = "on"
            end
            if br.isChecked("Plague - Globgrod") then
                root_UnitList[171887] = "Globgrod"
                radar = "on"
            end
            if br.isChecked("Root - Spiteful(M+)") then
                root_UnitList[174773] = "Spiteful"
                radar = "on"
            end

            if radar == "on" then
                local root = "Entangling Roots"
                local root_range = 35
                if talent.massEntanglement and cast.able.massEntanglement then
                    root = "Mass Entanglement"
                end

                if (root == "Mass Entanglement" and cast.able.massEntanglement()) or cast.able.entanglingRoots() then
                    for i = 1, br._G.GetObjectCount() do
                        local object = br._G.GetObjectWithIndex(i)
                        local ID = br._G.ObjectID(object)
                        if
                        root_UnitList[ID] ~= nil and br.getBuffRemain(object, 226510) == 0 and br.getHP(object) > 90 and not br.isLongTimeCCed(object) and
                                (br.getBuffRemain(object, 102359) < 2 or br.getBuffRemain(object, 339) < 2)
                        then
                            local x1, y1, z1 = br._G.ObjectPosition("player")
                            local x2, y2, z2 = br._G.ObjectPosition(object)
                            local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                            if distance <= 8 and talent.mightyBash then
                                br._G.CastSpellByName("Mighty Bash", object)
                                return true
                            end
                            if distance < root_range and not br.isLongTimeCCed(object) and not already_stunned(object) then
                                br._G.CastSpellByName(root, object)
                            end
                        end
                    end
                end -- end root
            end -- end radar

            --potion support
            --[[
            1, none, frX
            2, battle, 163222
            3, RisingDeath, 152559
            4, Draenic, 109218
            5, Prolonged, 142117
            6, Empowered Proximity, 168529
            7, Focused Resolve, 168506
            8, Superior Battle, 168498
            ]]
            if br.isChecked("Auto use Pots") then
                local pot_use
                if
                br.getValue("Auto use Pots") == 1 or br.getValue("Auto use Pots") == 2 and inInstance or br.getValue("Auto use Pots") == 3 and inRaid or
                        br.getValue("Auto use Pots") == 4 and solo
                then
                    pot_use = true
                end

                if pot_use then
                    local auto_pot
                    if #enemies.yards12t == 1 and br.isBoss("target") then
                        auto_pot = br.getOptionValue("Pots - 1 target")
                    elseif #enemies.yards12t >= 2 and #enemies.yards12t <= 3 then
                        auto_pot = br.getOptionValue("Pots - 2-3 targets")
                    elseif #enemies.yards12t >= 4 then
                        auto_pot = br.getOptionValue("Pots - 4+ target")
                    end

                    if
                    not auto_pot == 1 and (buff.incarnationChoseOfElune.exists() and buff.incarnationChoseOfElune.remain() > 16.5) or
                            (buff.celestialAlignment.exists() and buff.celestialAlignment.remain() > 13)
                    then
                        if auto_pot == 2 and br.canUseItem(163222) then
                            br.useItem(163222)
                        elseif auto_pot == 3 and br.canUseItem(152559) then
                            br.useItem(152559)
                        elseif auto_pot == 4 and br.canUseItem(109218) then
                            br.useItem(109218)
                        elseif auto_pot == 5 and br.canUseItem(142117) then
                            br.useItem(142117)
                        elseif auto_pot == 6 and #enemies.yards12 > 3 and br.canUseItem(168529) then
                            br.useItem(168529)
                        elseif auto_pot == 7 and br.canUseItem(168506) then
                            br.useItem(168506)
                        elseif auto_pot == 8 and br.canUseItem(168498) then
                            br.useItem(168498)
                        elseif auto_pot == 9 and br.canUseItem(169299) then
                            br.useItem(169299)
                        end
                    end
                end
            end

            if
            race == "Troll" and br.isChecked("Racial") and br.useCDs() and ttd("target") >= 12 and
                    ((buff.incarnationChoseOfElune.exists() and buff.incarnationChoseOfElune.remain() > 16.5) or
                            (buff.celestialAlignment.exists() and buff.celestialAlignment.remain() > 13))
            then
                cast.racial("player")
            end

            local is_aoe = false
            if #enemies.yards45 > 1 and (not talent.starlord or talent.stellarDrift) or #enemies.yards45 > 2 then
                is_aoe = true
            else
                is_aoe = false
            end
            local is_cleave = #enemies.yards45 > 1 or false
            local starfall_wont_fall_off = false
            if power > 80 - (buff.starfall.remains() * 3 / hasteAmount) and buff.starfall.exists() then
                starfall_wont_fall_off = true
            end

            local starfire_in_solar = #enemies.yards45 > (8 + math.floor(masteryAmount / 20))

            local convoke_desync = false
            if
            math.floor((getOutLaksTTDMAX() - 20 - cd.convokeTheSpirits.remains() - gcd) / 120) >
                    math.floor((getOutLaksTTDMAX() - 25 - (10 * int(talent.incarnationChoseOfElune) - (int(conduit.preciseAlignment.enabled)) - pew_remain())) / 180) or
                    pew_remain() > getOutLaksTTDMAX() or
                    cd.convokeTheSpirits.remains() - gcd > getOutLaksTTDMAX() or
                    not covenant.nightFae.active
            then
                convoke_desync = true
            else
                convoke_desync = false
            end

            local current_eclipse = "none"
            local eclipse_in = false
            local eclipse_last = "none"

            if br._G.GetSpellCount(190984) == 0 and br._G.GetSpellCount(194153) == 0 then
                eclipse_in = true
            else
                eclipse_in = false
            end

            if not eclipse_in then
                if br._G.GetSpellCount(190984) == 0 and br._G.GetSpellCount(194153) > 0 then
                    -- starfire >0
                    eclipse_next = "solar"
                    eclipse_last = "lunar"
                elseif br._G.GetSpellCount(190984) > 0 and br._G.GetSpellCount(194153) == 0 then
                    --wrath > 0
                    eclipse_next = "lunar"
                    eclipse_last = "solar"
                end
                if eclipse_next == "any" then
                    if eclipse_last == "none" and not br.isChecked("Prefer Lunar Eclipse") then
                        if #enemies.yards45 > 1 then
                            eclipse_next = "lunar"
                        else
                            eclipse_next = "solar"
                        end
                    elseif eclipse_last == "none" and not br.isChecked("Prefer Lunar Eclipse") then
                        eclipse_next = "lunar"
                    end
                else
                    if eclipse_last == "solar" then
                        eclipse_next = "lunar"
                    else
                        eclipse_next = "solar"
                    end
                end
            else
                if br._G.IsSpellOverlayed(spell.starfire) then
                    current_eclipse = "lunar"
                end
                if br._G.IsSpellOverlayed(spell.wrath) then
                    current_eclipse = "solar"
                end
            end

            if mode.rotation < 4 then
                --trinkets
                local Trinket13 = _G.GetInventoryItemID("player", 13)
                local Trinket14 = _G.GetInventoryItemID("player", 14)

                if br.isChecked("Use Trinkets") then
                    --VenumousShivers
                    if (Trinket13 == 168905 or Trinket14 == 168905) and br.getDebuffStacks("target", 301624) == 5 then
                        if br.canUseItem(168905) then
                            br.useItem(168905)
                        end
                    end

                    -- Generic fallback
                    if (pewbuff or (cd.celestialAlignment.remain() > 30 or cd.incarnationChoseOfElune.remain() > 30)) then
                        if Trinket13 ~= 168905 and Trinket13 ~= 167555 then
                            if br.canUseItem(13) then
                                br.useItem(13)
                            end
                        end
                        if Trinket14 ~= 168905 and Trinket14 ~= 167555 then
                            if br.canUseItem(14) then
                                br.useItem(14)
                            end
                        end
                    end
                end

                --	fury_of_elune
                if
                talent.furyOfElune and br.isChecked("Fury Of Elune") and (furyUnits >= br.getValue("Fury of Elune Targets") or br.isBoss("target")) and astral_def > 8 and
                        (br.isChecked("Group Fury with CD") and (pewbuff or cd.celestialAlignment.remain() > 30 or cd.incarnationChoseOfElune.remain() > 30) or
                                not br.isChecked("Group Fury with CD"))
                then
                    if cast.furyOfElune() then
                        return true
                    end
                end

                -- DPS rotation

                --if we are moving, we should try to starfall, otherwise rotate instants

                if br.isMoving("player") and mode.rotation ~= 3 and (talent.stellarDrift and not buff.starfall.exists()) then
                    if cast.able.sunfire(units.dyn45) and not debuff.sunfire.exists(units.dyn45) then
                        if cast.sunfire(units.dyn45) then
                            return true
                        end
                    end
                    if cast.able.moonfire(units.dyn45) and not debuff.moonfire.exists(units.dyn45) then
                        if cast.moonfire(units.dyn45) then
                            return true
                        end
                    end

                    if br.isChecked("Starfall While moving") and talent.stellarDrift and not buff.starfall.exists() and br.getValue("Starfall") ~= 3 then
                        if power < 50 then
                            return true
                        end
                        if cast.starfall() then
                            return true
                        end
                    end
                    if cast.moonfire(units.dyn45) then
                        return true
                    end
                end

                -- Print(tostring(timers.time("Explosion_delay", isExplosive(units.dyn45))))



                if br.isChecked("Sunfire Explosives") and timers.time("Explosion_delay", br.isExplosive(units.dyn45)) > 1.5 then
                    --to kill explosives - need more work TODO
                    if cast.able.sunfire(units.dyn45) and br.isExplosive(units.dyn45) then
                        -- and timers.time("Explosion_delay", isExplosive(units.dyn45)) > 2.5 then
                        if not buff.balanceOfAllThingsArcane.exists() and not buff.balanceOfAllThingsNature.exists() then
                            --    Print(tostring(timers.time("Explosion_delay", isExplosive(units.dyn45))))
                            if cast.sunfire(units.dyn45) then
                                br.addonDebug("killed explosive - at" .. timers.time("Explosion_delay", br.isExplosive(units.dyn45)))
                                return true
                            end
                        end
                    end
                end

                if mode.rotation == 1 and is_aoe or mode.rotation == 2 then
                    -- AOE rotation
                    --AOE Variables
                    local ignore_starsurge = current_eclipse == "lunar" and (#enemies.yards45 > 4 and talent.soulOfTheForest or #enemies.yards45 > 6) or false

                    if mode.cov == 1 then
                        --convoke_the_spirits,
                        if
                        br.useCDs() and cd.convokeTheSpirits.remain() - gcd <= 0 and getOutLaksTTDMAX() > 10 and
                                ((convoke_desync and pew_remain() > 0 or pewbuff) and (power < 50 or ignore_starsurge) and
                                        (buff.eclipse_lunar.remains() > 6 or buff.eclipse_solar.remains() > 6) and
                                        (not runeforge.balanceOfAllThings.equiped or buff.balanceOfAllThingsNature.stack() > 3 or buff.balanceOfAllThingsArcane.stack() > 3))
                        then
                            if cast.convokeTheSpirits() then
                                return true
                            end
                        end
                    end


                    --&target.time_to_die>14-spell_targets+remains&(eclipse.in_any|remains<gcd.max),if=" );


                    local splash_count = 0
                    if debuff.sunfire.count() < br.getOptionValue("Max Sunfire Targets") then
                        for i = 1, #enemies.yards45 do
                            thisUnit = enemies.yards45[i]
                            if br._G.UnitAffectingCombat(thisUnit) and not noDamageCheck(thisUnit) then
                                if br.getDistance(thisUnit, tank) <= 8 then
                                    splash_count = splash_count + 1
                                end
                                if splash_count == #enemies.yards45 or splash_count >= 3 or br.getCombatTime() > 5 then
                                    if cast.able.sunfire()
                                            and (not cast.last.sunfire(1)
                                            and (debuff.sunfire.refresh(thisUnit) or buff.eclipse_solar.remains() < 3 and eclipse_in == "solar" and buff.eclipse_solar.remains() < 14 and talent.soulOfTheForest)
                                            and ttd(thisUnit) > (14 - #enemies.yards45 + debuff.sunfire.remains(thisUnit)) and (eclipse_in or (buff.eclipse_solar.remain() < gcd or (buff.eclipse_lunar.remain() < gcd))))
                                            or br.isMoving("player") and not cast.last.sunfire(1)
                                    then
                                        if cast.sunfire(thisUnit) then
                                            return true
                                        end
                                    end
                                end
                            end
                        end
                    end

                    -- if  (buff.starfall.refreshable&(spell_targets.starfall<3|!runeforge.timeworn_dreambinder.equipped)|talent.soul_of_the_forest.enabled&buff.eclipse_solar.remains<3&eclipse.in_solar&buff.starfall.remains<7&spell_targets.starfall>=4)&(!runeforge.lycaras_fleeting_glimpse.equipped|time%%45>buff.starfall.remains+2)&target.time_to_die>5" );
                    if cast.able.starfall() and (br.getValue("Starfall") == 1 or br.getValue("Starfall") == 2)

                            and (buff.starfall.refresh() and (#enemies.yards45 < 3 or not runeforge.timewornDreambinder.equiped)
                            or talent.soulOfTheForest and buff.eclipse_solar.remains() < 3 and eclipse_in == "solar" and buff.starfall.remains() < 7
                            and #enemies.yards45 < 4)
                            and getOutLaksTTDMAX() > 5
                    then
                        if cast.starfall() then
                            return true
                        end
                    end

                    if power > 80 - (10 * buff.timewornDreambinder.stack()) - (buff.starfall.remains() * 3 / br._G.GetHaste() / 100) and buff.starfall.exists() then
                        starfall_wont_fall_off = true
                    end

                    --starsurge here

                    if not noDamageCheck(units.dyn45) and dream_will_fall_off and starfall_wont_fall_off and not ignore_starsurge
                            or (buff.balanceOfAllThingsNature.stack() > 3 or buff.balanceOfAllThingsArcane.stack() > 3) and #enemies.yards45 < 4 then
                        if cast.starsurge(units.dyn45) then
                            br.addonDebug("SS - BOAT")
                            return true
                        end
                    end

                    --adaptive swarm here
                    if mode.cov == 1 then
                        if cd.adaptiveSwarm.remain() - gcd <= 0 then
                            if not debuff.adaptiveSwarm.exists(units.dyn45) or debuff.adaptiveSwarm.exists(units.dyn45) and debuff.adaptiveSwarm.remains(units.dyn45) < 3 then
                                if cast.adaptiveSwarm(units.dyn45) then
                                    return true
                                end
                            end
                        end
                    end

                    --dots
                    if not noDamageCheck(thisUnit) then
                        if br.isChecked("Safe Dots") and
                                ((inInstance and #tanks > 0 and br.getDistance(thisUnit, tanks[1].unit) <= 10)
                                        or (inInstance and #tanks == 0)
                                        or (inRaid and #tanks > 1 and (br.getDistance(thisUnit, tanks[1].unit) <= 10 or (br.getDistance(thisUnit, tanks[2].unit) <= 10)))
                                        or solo
                                        or (inInstance and #tanks > 0 and br.getDistance(tanks[1].unit) >= 90)
                                        --need to add, or if tank is dead
                                ) or not br.isChecked("Safe Dots") then

                            if cast.able.moonfire(thisUnit) and debuff.moonfire.count() < br.getOptionValue("Max Moonfire Targets")
                                    and (current_eclipse ~= "lunar" or #enemies.yards45 <= 4) then
                                for i = 1, #enemies.yards45 do
                                    thisUnit = enemies.yards45[i]
                                    if br._G.UnitAffectingCombat(thisUnit) then
                                        -- moonfire
                                        if (not debuff.moonfire.exists(thisUnit) or debuff.moonfire.refresh(thisUnit)) and br.getTTD(thisUnit) > (14 + (#enemies.yards45 * 1.5)) / #enemies.yards45 + debuff.moonfire.remain(thisUnit) then
                                            if pew_remain() == 0 and not br.useCDs() and (convoke_desync or cd.convokeTheSpirits.ready() or not covenant.nightFae.active)
                                                    or #enemies.yards45 < (5 * (1 + (talent.twinMoons and 0 or 1)))
                                                    or (current_eclipse == "solar" or (current_eclipse == "any" or current_eclipse == "lunar")
                                                    and not talent.soulOfTheForest or buff.primordialArcanicPulsar.count() >= 250)
                                                    and (#enemies.yards45 < 10 * (1 + int(talent.twinMoons)) and power > 50 - buff.starfall.remains() * 6)
                                            then
                                                if cast.moonfire(thisUnit) then
                                                    return true
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    -- Force Of Nature / treants
                    if talent.forceOfNature and cast.able.forceOfNature() and astral_def > 20 then
                        if
                        br.player.ui.mode.forceofNature == 1 and br.getTTD("target") >= 10 and
                                (br.isChecked("Group treants with CD") and (pewbuff or cd.celestialAlignment.remain() > 30 or cd.incarnationChoseOfElune.remain() > 30) or
                                        not br.isChecked("Group treants with CD")) and
                                (#enemies.yards12t >= br.getValue("Treant Targets") or br.isBoss())
                        then
                            if cast.forceOfNature("best", nil, 1, 15, true) then
                                return true
                            end
                        elseif br.player.ui.mode.forceofNature == 2 and br.isChecked("Treants Key") and br.SpecificToggle("Treants Key") and not br._G.GetCurrentKeyBoardFocus() then
                            if cast.forceOfNature("best", nil, 1, 15, true) then
                                return true
                            end
                        end
                    end

                    if mode.cov == 1 then
                        if cast.able.ravenousFrenzy() and (pewbuff or (getOutLaksTTDMAX() > 35) and eclipse_next == "lunar") then
                            if cast.ravenousFrenzy() then
                                br.addonDebug("Rav_aoe")
                                return true
                            end
                        end


                    end

                    -- celestialAlignment
                    if br.getCombatTime() > 2 and br.useCDs() and br.isChecked("Incarnation/Celestial Alignment") and getOutLaksTTDMAX() > br.getValue("Incarnation/Celestial Alignment") then
                        if
                        (buff.starfall.exists() or power > 50) and not eclipse_in and not pewbuff and
                                (not covenant.nightFae.active or convoke_desync or cd.convokeTheSpirits.ready() or getOutLaksTTDMAX() < 20)
                        then
                            if not talent.incarnationChoseOfElune and cast.able.celestialAlignment() then
                                if cast.celestialAlignment() then
                                end
                            elseif talent.incarnationChoseOfElune and cast.able.incarnationChoseOfElune() then
                                if cast.incarnationChoseOfElune() then
                                end
                            end
                        end
                    end

                    if mode.cov == 1 then
                        if cast.able.kindredSpirits() then
                            if
                            getOutLaksTTDMAX() > 15 and -- or (buff.primordial_arcanic_pulsar.value<250|buff.primordial_arcanic_pulsar.value>=250)
                                    buff.starfall.exists() and
                                    (pew_remain() > 50) or
                                    not br.useCDs()
                            then
                                if cast.kindredSpirits("player") then
                                    return true
                                end
                            end
                        end
                    end

                    --starsurge,
                    if not noDamageCheck(units.dyn45) and cast.able.starsurge(units.dyn45) and starfall_wont_fall_off and #enemies.yards45 < 3 then
                        if buff.onethsClearVision.exists()
                                or (astral_def < 8
                                or ((buff.incarnationChoseOfElune.remains() < 5 or buff.celestialAlignment.remains() < 5) and pewbuff
                                or (buff.ravenousFrenzy.remains() < gcd * math.ceil(power / 30) and buff.ravenousFrenzy.exists())))
                                and (not runeforge.timewornDreambinder.equiped or #enemies.yards45 < 3) then
                            if cast.starsurge(units.dyn45) then
                                br.addonDebug("[SS] - 1")
                                return true
                            end
                        end

                        --starsurge

                        if not noDamageCheck(units.dyn45) and buff.onethsClearVision.exists()
                                or astral_def < 8
                                or ((buff.incarnationChoseOfElune.remains() < 5 or buff.celestialAlignment.remains() < 5) and pewbuff
                                or (buff.ravenousFrenzy.remains() < gcd * math.ceil(power / 30) and buff.ravenousFrenzy.exists()))
                        then
                            if cast.starsurge(units.dyn45) then
                                br.addonDebug("[SS] - 2")
                                return true
                            end
                        end
                    end

                    --new starfall here
                    if cast.able.starfall() and (br.getValue("Starfall") == 1 or br.getValue("Starfall") == 2) then
                        if
                        covenant.nightFae.active and (convoke_desync or pew_remain() == 0 or pewbuff) and cd.convokeTheSpirits.remains() < gcd * math.ceil(power / 50) and
                                buff.starfall.remains() < 4
                        then
                            if cast.starfall() then
                                return true
                            end
                        end
                    end

                    if not noDamageCheck(units.dyn45) and cast.able.starsurge(units.dyn45) and starfall_wont_fall_off then
                        -- starsurge 2
                        if
                        covenant.nightFae.active and (convoke_desync or pew_remain() == 0 or pewbuff and cd.convokeTheSpirits.remains() - gcd < 6) and buff.starfall.exists() and
                                eclipse_in and
                                not ignore_starsurge
                        then
                            if cast.starsurge(units.dyn45) then
                                br.addonDebug("[SS] - 3")
                                return true
                            end
                        end
                        -- starsurge 3
                        if not noDamageCheck(units.dyn45) and buff.onethsClearVision.exists() or (astral_def > 8 or (pew_remain() < 5 and pewbuff
                                or (buff.ravenousFrenzy.remains() < gcd * math.ceil(power / 30) and buff.ravenousFrenzy.exists()))
                                and starfall_wont_fall_off and #enemies.yards45 < 3) and (not runeforge.timewornDreambinder.equiped or #enemies.yards45 < 3) then
                            if cast.starsurge(units.dyn45) then
                                br.addonDebug("[SS] - 4")
                                return true
                            end
                        end
                    end

                    --moon shit here .. not supported ..cause fuck that

                    -- Warrior of Elune
                    if br.useCDs() and br.isChecked("Warrior Of Elune") and talent.warriorOfElune and not buff.warriorOfElune.exists() then
                        if cast.warriorOfElune() then
                            return true
                        end
                    end

                    starfire_in_solar = #enemies.yards45 > 10 and true or false

                    if not noDamageCheck(units.dyn45) then
                        if current_eclipse == "solar" and #enemies.yards45 < 5
                                or (eclipse_next == "lunar" and not eclipse_in) then
                            --  or buff.eclipse_solar.exists() then
                            if cast.wrath(units.dyn45) then
                                br.addonDebug("wrath - eclipse is:" .. current_eclipse)
                                return true
                            end
                        else
                            if cast.able.starfire() then
                                if cast.starfire(getBiggestUnitCluster(45, 8)) then
                                    br.addonDebug("sfall - eclipse is: " .. current_eclipse)
                                    return true
                                end
                            end
                        end
                    end
                elseif not runeforge.balanceOfAllThings.equiped and (not is_aoe or mode.rotation == 3) then
                    --ST   - NO BOAT (single target rotation)

                    --adaptive swarm here
                    if mode.cov == 1 then
                        if cast.able.adaptiveSwarm("target") and not br.isExplosive("target") then
                            if not debuff.adaptiveSwarm.exists("target") or debuff.adaptiveSwarm.exists("target") and debuff.adaptiveSwarm.remains("target") < 3 then
                                if cast.adaptiveSwarm("target") then
                                    return true
                                end
                            end
                        end

                        --convoke_the_spirits
                        if br.useCDs() and covenant.nightFae and cd.convokeTheSpirits.remain() - gcd <= 0 and getOutLaksTTDMAX() > 10 then
                            if ((convoke_desync and pew_remain() > 0 or pewbuff)
                                    and power < 40
                                    and (buff.eclipse_lunar.remains() > 10 or buff.eclipse_solar.remains() > 10)) then
                                if cast.convokeTheSpirits() then
                                    return true
                                end
                            end
                        end
                    end

                    local dot_requirements = (buff.incarnationChoseOfElune.remains() < 5 or buff.celestialAlignment.remains() < 5) and
                            (buff.ravenousFrenzy.remains() > 5 or not buff.ravenousFrenzy.exists() or not pewbuff or power < 30) and
                            (not buff.kindredEmpowermentEnergize.exists() or power < 30) and
                            (buff.eclipse_solar.remains() > gcd or buff.eclipse_lunar.remains() > gcd) or
                            false

                    if not noDamageCheck(thisUnit) then
                        if br.isChecked("Safe Dots") and
                                ((inInstance and #tanks > 0 and br.getDistance(thisUnit, tanks[1].unit) <= 10)
                                        or (inInstance and #tanks == 0)
                                        or (inRaid and #tanks > 1 and (br.getDistance(thisUnit, tanks[1].unit) <= 10 or (br.getDistance(thisUnit, tanks[2].unit) <= 10)))
                                        or solo
                                        or (inInstance and #tanks > 0 and br.getDistance(tanks[1].unit) >= 90)
                                        --need to add, or if tank is dead
                                ) or not br.isChecked("Safe Dots") then

                            if cast.able.moonfire("target") and dot_requirements and br.getTTD("target") > 12 and astral_def > 8 and (not debuff.moonfire.exists("target") or debuff.moonfire.remain("target") < 6.6) then
                                if cast.moonfire("target") then
                                    return true
                                end
                            end
                            if cast.able.sunfire("target") and dot_requirements and (not debuff.sunfire.exists("target") or debuff.sunfire.remain("target") < 5.4) and ttd("target") > 12 then
                                if cast.sunfire("target") then
                                    return true
                                end
                            end

                            -- stellarFlare
                            if talent.stellarFlare and not cast.last.stellarFlare(1) and cast.able.stellarFlare()
                                    and debuff.stellarFlare.refresh("target") and ttd("target") > 16
                                    and dot_requirements then
                                if cast.stellarFlare("target") then
                                    return true
                                end
                            end
                        end
                    end

                    -- Force Of Nature / treants   SINGLE TARGET
                    if talent.forceOfNature and cast.able.forceOfNature() and astral_def > 20 then
                        if
                        br.player.ui.mode.forceofNature == 1 and br.getTTD("target") >= 10 and
                                (br.isChecked("Group treants with CD") and (pewbuff or cd.celestialAlignment.remain() > 30 or cd.incarnationChoseOfElune.remain() > 30) or
                                        not br.isChecked("Group treants with CD")) and
                                (#enemies.yards12t >= br.getValue("Treant Targets") or br.isBoss())
                        then
                            if cast.forceOfNature("best", nil, 1, 15, true) then
                                return true
                            end
                        elseif br.player.ui.mode.forceofNature == 2 and br.isChecked("Treants Key") and br.SpecificToggle("Treants Key") and not br._G.GetCurrentKeyBoardFocus() then
                            if cast.forceOfNature("best", nil, 1, 15, true) then
                                return true
                            end
                        end
                    end

                    -- RavenousFrenzy here
                    if mode.cov == 1 then
                        if cast.able.ravenousFrenzy() and (pewbuff or getOutLaksTTDMAX() > 30) then
                            if cast.ravenousFrenzy() then
                                br.addonDebug("RAv1")
                                return true
                            end
                        end

                        --kindred spirit
                        if cast.able.kindredSpirits() then
                            if
                            ((buff.eclipse_solar.remains() > 10 or buff.eclipse_lunar.remains() > 10) and pew_remain() > 30) or --buff.primordial_arcanic_pulsar.value < 240
                                    --  |!runeforge.primordial_arcanic_pulsar.equipped))|buff.primordial_arcanic_pulsar.value>=270
                                    pew_remain() == 0 and (power > 90 or is_aoe)
                            then
                                if cast.kindredSpirits("player") then
                                    return true
                                end
                            end
                        end
                    end
                    if br.getCombatTime() > 2 and br.useCDs() and br.isChecked("Incarnation/Celestial Alignment") and getOutLaksTTDMAX() > br.getValue("Incarnation/Celestial Alignment") then
                        if not talent.incarnationChoseOfElune then
                            if
                            (power > 90 and (buff.kindredEmpowermentEnergize.exists() or not covenant.kyrian.active) or covenant.nightFae.active or is_aoe or
                                    br.hasBloodLust() and (br.br.hasBloodLustRemain() < 20) + ((9 * int(runeforge.primordialArcanicPulsar.equiped)) + (int(conduit.preciseAlignment)))) and
                                    not pewbuff and
                                    (not covenant.nightFae.active or (cd.convokeTheSpirits.remains() - gcd) <= 0 or getOutLaksTTDMAX() < (cd.convokeTheSpirits.remains() + 6 - gcd))
                            then
                                if cast.celestialAlignment() then
                                    return true
                                end
                            end
                        else
                            if
                            (power > 90 and (buff.kindredEmpowermentEnergize.exists() or not covenant.kyrian.active) or covenant.nightFae.active or is_aoe or
                                    br.hasBloodLust() and (br.br.hasBloodLustRemain() < 30) + ((9 * int(runeforge.primordialArcanicPulsar.equiped)) + (int(conduit.preciseAlignment)))) and
                                    not pewbuff and
                                    (not covenant.nightFae.active or cd.convokeTheSpirits.remains() == 0 or getOutLaksTTDMAX() < (cd.convokeTheSpirits.remains() + 6))
                            then
                                if cast.incarnationChoseOfElune() then
                                    return true
                                end
                            end
                        end
                    end

                    local save_for_ca_inc = (pew_remain() > 0 or not convoke_desync and covenant.night_fae or not br.useCDs()) or false

                    -- fury of elune - single target
                    if
                    eclipse_in and astral_def > 20 and --and buff.primordialArcanicPulsar.value() < 240
                            (debuff.adaptiveSwarm.exists("target") or not covenant.necrolord.active) and
                            save_for_ca_inc
                    then
                        if cast.furyOfElune("target") then
                            return true
                        end
                    end

                    if br.getValue("Starfall") == 1 then
                        -- starfall - single target, with legendary
                        if buff.onethsPerception.exists() and not buff.starfall.exists() then
                            if cast.starfall() then
                                return true
                            end
                        end
                    end

                    -- cancel starlord here
                    if buff.starlord.exists() and buff.starlord.remains() < 5 and (buff.eclipse_solar.remains() > 5 or buff.eclipse_lunar.remains() > 5) and power > 90 then
                        br.addonDebug("[Cancel SL]:Buff Remains:" .. tostring(buff.starlord.remain()) .. "Astral Def:" .. tostring(astral_def))
                        br.cancelBuff(279709)
                    end

                    --starsurge - first of many
                    if cast.able.starsurge("target") then
                        if covenant.nightFae.active and convoke_desync and cd.convokeTheSpirits.remains() < 5 and br.useCDs() then
                            if cast.starsurge("target") then
                                br.addonDebug("[SS] Night Fae")
                                return true
                            end
                        end
                    end

                    --Starfall - ST
                    if
                    br.getValue("Starfall") == 1 and talent.stellarDrift and not talent.starlord and buff.starfall.remains() < 2 and
                            (buff.eclipse_lunar.remains() > 6 and current_eclipse == "lunar" or
                                    --          and buff.primordialArcanicPulsar.value() < 250 or buff.primordialArcanicPulsar.value() >= 250 and power > 90
                                    debuff.adaptiveSwarm.remains("target") > 8) and
                            pew_remain() > 0
                    then
                        if cast.starfall() then
                            br.addonDebug("[SF] Stellardrift")
                            return true
                        end
                    end

                    --sTarsurge wave 2
                    if cast.able.starsurge("target") then
                        if
                        buff.onethsClearVision.exists() or buff.kindredEmpowermentEnergize.exists() or
                                pewbuff and
                                        (buff.ravenousFrenzy.remains() < gcd * math.ceil(power / 30) and buff.ravenousFrenzy.exists() or
                                                not buff.ravenousFrenzy.exists() and not cd.ravenousFrenzy.ready() or
                                                not covenant.venthyr) or
                                power > 90 and eclipse_in
                        then
                            if cast.starsurge("target") then
                                br.addonDebug("[SS] COND1")
                                return true
                            end
                        end
                        if
                        talent.starlord and (buff.starlord.exists() or power > 90) and buff.starlord.stack() < 3 and (current_eclipse == "solar" or current_eclipse == "lunar") and
                                (pew_remain() > 10 or not convoke_desync and covenant.nightFae.active)
                        then
                            if cast.starsurge("target") then
                                br.addonDebug("[SS] COND2")
                                return true
                            end
                        end
                        --if (buff.primordialArcanicPulsar.value() < 270 or buff.primordialArcanicPulsar.value() < 250 and talent.stellarDrift)                     and buff.eclipse_solar.remains() > 7 and current_eclipse == "solar" and not buff.onethsPerception.exists()
                        --       and
                        if not talent.starlord and pew_remain() > 7 and (cd.kindredSpirits.remains() > 7 or not covenant.kyrian.active) then
                            if cast.starsurge("target") then
                                br.addonDebug("[SS] COND3")
                                return true
                            end
                        end
                    end
                    -- Warrior of Elune
                    if br.useCDs() and br.isChecked("Warrior Of Elune") and talent.warriorOfElune and not buff.warriorOfElune.exists() then
                        if cast.warriorOfElune() then
                            return true
                        end
                    end

                    --starfire
                    if
                    cast.able.starfire("target") and current_eclipse == "lunar" or eclipse_next == "solar" or eclipse_next == "any" or
                            buff.warriorOfElune.exists() and current_eclipse == "lunar" or
                            ((buff.incarnationChoseOfElune.remains() > br.getCastTime(spell.wrath) or buff.celestialAlignment.remains() > br.getCastTime(spell.wrath)) and pewbuff)
                    then
                        if cast.starfire("target") then
                            return true
                        end
                    end
                    --wrath fall back
                    if cast.able.wrath("target") then
                        if cast.wrath("target") then
                            return true
                        end
                    end
                elseif runeforge.balanceOfAllThings.equiped and (not is_aoe or mode.rotation == 3) then
                    local critnotup = not buff.balanceOfAllThingsNature.exists() and not buff.balanceOfAllThingsArcane.exists() or false

                    -- damn vampires
                    if mode.cov == 1 then
                        if cast.able.ravenousFrenzy() and (pewbuff or eclipse_in and getOutLaksTTDMAX() > 35) then
                            if cast.ravenousFrenzy() then
                                br.addonDebug("RAv2 @:" .. getOutLaksTTDMAX())
                                return true
                            end
                        end
                        --adaptive swarm here
                        if not noDamageCheck("target") and cast.able.adaptiveSwarm() then
                            if not debuff.adaptiveSwarm.exists("target") or debuff.adaptiveSwarm.exists("target") and debuff.adaptiveSwarm.remains("target") < 3 then
                                if cast.adaptiveSwarm("target") then
                                    return true
                                end
                            end
                        end
                        --convoke_the_spirits,
                        if
                        br.useCDs() and cd.convokeTheSpirits.remain() - gcd <= 0 and getOutLaksTTDMAX() > 10 and
                                ((convoke_desync and pew_remain() ~= 0 or pewbuff) and (buff.balanceOfAllThingsNature.stack() == 5 or buff.balanceOfAllThingsArcane.stack() == 5))
                        then
                            br._G.CastSpellByID(323764, "player")
                            return true
                        end
                    end

                    --starlord cancel here
                    if talent.starlord then
                        if
                        (buff.balanceOfAllThingsNature.remains() > 4.5 or buff.balanceOfAllThingsArcane.remains() > 4.5) and
                                (pew_remain() > 7 or (cd.empowerBond.remains() > 7 and not buff.kindredEmpowermentEnergize.exists() and covenant.kyrian.active))
                        then
                            br.cancelBuff(279709)
                        end
                    end

                    --starsurge - its why we boat :)
                    if not noDamageCheck("target") and cast.able.starsurge(units.dyn45) then
                        if not critnotup
                                and (covenant.nightFae.active or pew_remain() > 7
                                or not cd_condition and covenant.kyrian.active
                                or (cd.empowerBond.remains() > 7 and not buff.kindredEmpowermentEnergize.exists() and covenant.kyrian.active))
                        then
                            if cast.starsurge("target") then
                                br.addonDebug("[SS] - Critting a boatload")
                                return true
                            end
                        end

                        --starsurge,if=(cooldown.convoke_the_spirits.remains<5&!druid.no_cds&(variable.convoke_desync|cooldown.ca_inc.remains<5))&astral_power>40&covenant.night_fae&!druid.no_cds
                        if not noDamageCheck("target") and ((cd.convokeTheSpirits.remains() < 5 and cd.convokeTheSpirits.remains() - gcd > 0)
                                and br.useCDs() and (convoke_desync or pew_remain() < 5))
                                and power > 40 and covenant.nightFae.active and br.useCDs() and mode.cov == 1
                        then
                            if cast.starsurge("target") then
                                br.addonDebug("[SS] - Overflow1 - cd:" .. tostring(cd.convokeTheSpirits.remains()))
                                return true
                            end
                        end
                    end
                    --dots
                    local dot_requirements = false

                    if ((buff.incarnationChoseOfElune.remains() > 5 or buff.celestialAlignment.remains() > 5)
                            and (buff.ravenousFrenzy.remains() > 5 or not buff.ravenousFrenzy.exists)
                            or not pewbuff)
                            and (not buff.kindredEmpowermentEnergize.exists())
                            and (buff.eclipse_solar.remains() > gcd or buff.eclipse_lunar.remains() > gcd)
                    then
                        dot_requirements = true
                    end

                    if not noDamageCheck(thisUnit) then
                        if br.isChecked("Safe Dots") and
                                ((inInstance and #tanks > 0 and br.getDistance(thisUnit, tanks[1].unit) <= 10)
                                        or (inInstance and #tanks == 0)
                                        or (inRaid and #tanks > 1 and (br.getDistance(thisUnit, tanks[1].unit) <= 10 or (br.getDistance(thisUnit, tanks[2].unit) <= 10)))
                                        or solo
                                        or (inInstance and #tanks > 0 and br.getDistance(tanks[1].unit) >= 90)
                                        --need to add, or if tank is dead
                                ) or not br.isChecked("Safe Dots") then

                            if cast.able.sunfire("target") and dot_requirements and (not debuff.sunfire.exists("target") or debuff.sunfire.remain("target") < 5.4) and br.getTTD("target") > 16 then
                                if cast.sunfire("target") then
                                    return true
                                end
                            end

                            if cast.able.moonfire("target") and dot_requirements and br.getTTD("target") > 13.5 and astral_def > 8 and (not debuff.moonfire.exists("target") or debuff.moonfire.remain("target") < 6.6) then
                                if cast.moonfire("target") then
                                    return true
                                end
                            end

                            if cast.able.stellarFlare("target") and dot_requirements and br.getTTD("target") > 16 and astral_def > 8 and (not debuff.stellarFlare.exists("target") or debuff.stellarFlare.remain("target") < 4) then
                                if cast.stellarFlare("target") then
                                    return true
                                end
                            end
                        end
                    end
                    --end of dots
                    -- Force Of Nature / treants
                    if talent.forceOfNature and cast.able.forceOfNature() and astral_def > 20 then
                        if
                        br.player.ui.mode.forceofNature == 1 and br.getTTD("target") >= 10 and
                                (br.isChecked("Group treants with CD") and (pewbuff or cd.celestialAlignment.remain() > 30 or cd.incarnationChoseOfElune.remain() > 30) or
                                        not br.isChecked("Group treants with CD")) and
                                (#enemies.yards12t >= br.getValue("Treant Targets") or br.isBoss())
                        then
                            if cast.forceOfNature("best", nil, 1, 15, true) then
                                return true
                            end
                        elseif br.player.ui.mode.forceofNature == 2 and br.isChecked("Treants Key") and br.SpecificToggle("Treants Key") and not br._G.GetCurrentKeyBoardFocus() then
                            if cast.forceOfNature("best", nil, 1, 15, true) then
                                return true
                            end
                        end
                    end
                    --need to support fury of elune here ...at somet point
                    --fury_of_elune,if=(eclipse.in_any|eclipse.solar_in_1|eclipse.lunar_in_1)&(!covenant.night_fae|druid.no_cds|(astral_power<95&(variable.critnotup|astral_power<30|variable.is_aoe)&(variable.convoke_desync&!cooldown.convoke_the_spirits.up|!variable.convoke_desync&!cooldown.ca_inc.up)))&(cooldown.ca_inc.remains>30|druid.no_cds|astral_power>90&cooldown.ca_inc.up&(cooldown.empower_bond.remains<action.starfire.execute_time|!covenant.kyrian)|interpolated_fight_remains<10)&(dot.adaptive_swarm_damage.remains>4|!covenant.necrolord)

                    if mode.cov == 1 then
                        if cast.able.kindredSpirits() then
                            if
                            (eclipse_next == "lunar" or eclipse_next == "solar" or eclipse_next == "any" or buff.balanceOfAllThingsNature.remains() > 4.5 or
                                    buff.balanceOfAllThingsArcane.remains() > 4.5 or
                                    power > 90 and pew_remain() == 0 and br.useCDs()) and
                                    (pew_remain() > 30 or pew_remain() == 0)
                            then
                                if cast.kindredSpirits("player") then
                                    return true
                                end
                            end
                        end
                    end

                    --pewbuff
                    if br.getCombatTime() > 2 and br.useCDs() and br.isChecked("Incarnation/Celestial Alignment") and getOutLaksTTDMAX() > br.getValue("Incarnation/Celestial Alignment") then
                        if not talent.incarnationChoseOfElune and cast.able.celestialAlignment() then
                            if
                            (power > 90 and (buff.kindredEmpowermentEnergize.exists() or not covenant.kyrian.active) or covenant.nightFae.active or
                                    br.hasBloodLust() and (br.br.hasBloodLustRemain() < 20)) and
                                    (convoke_desync or cd.convokeTheSpirits.remain() - gcd <= 0)
                            then
                                if cast.celestialAlignment() then
                                    return true
                                end
                            end
                        else
                            if
                            cast.able.incarnationChoseOfElune() and
                                    (power > 90 and (buff.kindredEmpowermentEnergize.exists() or not covenant.kyrian.active) or covenant.nightFae.active or
                                            br.hasBloodLust() and (br.br.hasBloodLustRemain() < 30)) and
                                    (convoke_desync or cd.convokeTheSpirits.remain() - gcd <= 0)
                            then
                                if cast.incarnationChoseOfElune() then
                                    return true
                                end
                            end
                        end
                    end
                    local aspPerSec = int(current_eclipse == "lunar") * 8 / br.getCastTime(spell.starfire) + int(not current_eclipse == "lunar") * 6 / br.getCastTime(spell.wrath) + 0.2 / hasteAmount

                    --Starsurge .. what is this ...  wtf
                    if not noDamageCheck("target") then
                        if cast.able.starsurge("target") then
                            if ((buff.ravenousFrenzy.remains() < gcd * math.ceil(power / 30) and buff.ravenousFrenzy.exists()))
                                    or (power + aspPerSec * buff.eclipse_solar.remains() > 120
                                    or power + aspPerSec * buff.eclipse_lunar.remains() > 120)
                                    and eclipse_in and (not pewbuff or not talent.starlord)
                                    and ((pew_remain() > 0 or covenant.kyrian.active and cd.empowerBond.remain() > 0)
                                    or covenant.nightFae.ative)
                                    and (not covenant.venthyr.active or not pewbuff or power > 90)
                                    or (talent.starlord and pewbuff and (buff.starlord.stack() < 3 or power > 90))
                                    or (buff.celestialAlignment.remain() > 8 or buff.incarnationChoseOfElune.remain() > 8)
                                    and not buff.ravenousFrenzy.exists() and not talent.starlord
                            then
                                if cast.starsurge("target") then
                                    br.addonDebug("[SS] - Overflow2")
                                    return true
                                end
                            end
                        end

                        --moon stuff goes here ... as if


                        if cast.able.starfire("target") then
                            if current_eclipse == "lunar"
                                    or current_eclipse ~= "solar" and eclipse_next == "solar"
                                    or current_eclipse ~= "solar" and eclipse_next == "any"
                                    or (buff.warriorOfElune.exists() and current_eclipse == "lunar")
                                    or ((buff.celestialAlignment.remain() < br.getCastTime(spell.wrath) or buff.incarnationChoseOfElune.remain() < br.getCastTime(spell.wrath)) and pewbuff)
                            then
                                --    if cast.starfire(getBiggestUnitCluster(45, 8)) then
                                if cast.starfire("target") then
                                    br.addonDebug("[SFIRE] Lunar:" .. tostring(current_eclipse == "lunar") .. " Solar:" .. tostring(current_eclipse == "solar") .. " Next:" .. eclipse_next)
                                    return true
                                end
                            end
                        end

                        if cast.wrath("target") then
                            br.addonDebug("[WRATH] Lunar:" .. tostring(current_eclipse == "lunar") .. " Solar:" .. tostring(current_eclipse == "solar") .. " Next:" .. eclipse_next)
                            return true
                        end
                    end
                end
            end -- end aoe/st/boat loop
        end
    end -- end dps()

    local function defensive()
        --Healthstone / Heathpots :  156634 == Silas Vial of Continuous curing / 5512 == warlock health stones
        if br.isChecked("Pot/Stoned") and php <= br.getValue("Pot/Stoned") and (br.hasHealthPot() or br.hasItem(5512) or br.hasItem(156634) or br.hasItem(177278)) then
            if br.canUseItem(177278) then
                br.useItem(177278)
            elseif br.canUseItem(5512) then
                br.useItem(5512)
            elseif br.canUseItem(156634) then
                br.useItem(156634)
            elseif br.canUseItem(169451) then
                br.useItem(169451)
            elseif br.canUseItem(br.getHealthPot()) then
                br.useItem(br.getHealthPot())
            elseif br.canUseItem(br.getHealthPot()) then
                br.useItem(br.getHealthPot())
            end
        end

        if mode.cov == 1 then
            if covenant.kyrian.active and not br.hasItem(177278) and cast.able.summonSteward() then
                if cast.summonSteward() then
                    return true
                end
            end
        end

        -- Renewal
        if br.isChecked("Renewal") and talent.renewal and php <= br.getValue("Renewal") then
            if cast.renewal("player") then
                return
            end
        end
        -- Barkskin
        if br.isChecked("Barkskin") and inCombat and php <= br.getValue("Barkskin") then
            if cast.barkskin() then
                return
            end
        end
        -- Swiftmend
        if talent.restorationAffinity and br.isChecked("Swiftmend") and cast.able.swiftmend() and php <= br.getValue("Swiftmend") and charges.swiftmend.count() >= 1 and hasHot("player") then
           unit.cancelForm()
            if cast.swiftmend("player") then
                return true
            end
        end
        -- Regrowth
        if br.isChecked("Regrowth") and not moving and php <= br.getValue("Regrowth") then
             unit.cancelForm()
            if cast.regrowth("player") then
                return true
            end
        end

        --rejuvenation
        if br.isChecked("Rejuvenation") and php <= br.getValue("Rejuvenation") and not buff.rejuvenation.exists("player") then
             unit.cancelForm()
            if cast.rejuvenation("player") then
                return true
            end
        end
        -- Rebirth
        if inCombat and br.isChecked("Rebirth") and cd.rebirth.remain() <= gcd and not br.isMoving("player") then
            if br.getOptionValue("Rebirth") == 1 then
                tanks = br.getTanksTable()
                for i = 1, #tanks do
                    thisUnit = tanks[i].unit
                    if br.GetUnitIsDeadOrGhost(thisUnit) and br._G.UnitIsPlayer(thisUnit) then
                        if cast.rebirth(thisUnit, "dead") then
                            return true
                        end
                    end
                end
            elseif inCombat and br.getOptionValue("Rebirth") == 2 then
                for i = 1, #br.friend do
                    thisUnit = br.friend[i].unit
                    if br.GetUnitIsDeadOrGhost(thisUnit) and br._G.UnitGroupRolesAssigned(thisUnit) == "HEALER" and br._G.UnitIsPlayer(thisUnit) then
                        if cast.rebirth(thisUnit, "dead") then
                            return true
                        end
                    end
                end
            elseif inCombat and br.getOptionValue("Rebirth") == 3 then
                for i = 1, #br.friend do
                    thisUnit = br.friend[i].unit
                    if br.GetUnitIsDeadOrGhost(thisUnit) and (br._G.UnitGroupRolesAssigned(thisUnit) == "TANK" or br._G.UnitGroupRolesAssigned(thisUnit) == "HEALER") and br._G.UnitIsPlayer(thisUnit) then
                        if cast.rebirth(thisUnit, "dead") then
                            return true
                        end
                    end
                end
            elseif inCombat and br.getOptionValue("Rebirth") == 4 then
                if br.GetUnitExists("mouseover") and br.GetUnitIsDeadOrGhost("mouseover") and br.GetUnitIsFriend("mouseover", "player") then
                    if cast.rebirth("mouseover", "dead") then
                        return true
                    end
                end
            elseif inCombat and br.getOptionValue("Rebirth") == 5 then
                for i = 1, #br.friend do
                    thisUnit = br.friend[i].unit
                    if br.GetUnitIsDeadOrGhost(thisUnit) and br._G.UnitIsPlayer(thisUnit) then
                        if cast.rebirth(thisUnit, "dead") then
                            return true
                        end
                    end
                end
            end
        end

        -- offheal

        local offheal = false
        if br.getOptionValue("offheal") == 2 then
            offheal = true
        elseif br.getOptionValue("offheal") == 3 then
            for i = 1, #br.friend do
                thisUnit = br.friend[i].unit
                if br.GetUnitIsDeadOrGhost(thisUnit) and br._G.UnitGroupRolesAssigned(thisUnit) == "HEALER" and br._G.UnitIsPlayer(thisUnit) then
                    offheal = true
                end
            end
        end

        -- Remove Corruption
        if br.isChecked("Remove Corruption") then
            if br.getOptionValue("Remove Corruption") == 1 then
                if br.canDispel("player", spell.removeCorruption) then
                    if cast.removeCorruption("player") then
                        return true
                    end
                end
            elseif br.getOptionValue("Remove Corruption") == 2 then
                if br.canDispel("target", spell.removeCorruption) then
                    if cast.removeCorruption("target") then
                        return true
                    end
                end
            elseif br.getOptionValue("Remove Corruption") == 3 then
                if br.canDispel("player", spell.removeCorruption) then
                    if cast.removeCorruption("player") then
                        return true
                    end
                elseif br.canDispel("target", spell.removeCorruption) then
                    if cast.removeCorruption("target") then
                        return true
                    end
                end
            elseif br.getOptionValue("Remove Corruption") == 4 then
                if br.canDispel("mouseover", spell.removeCorruption) then
                    if cast.removeCorruption("mouseover") then
                        return true
                    end
                end
            elseif (br.getOptionValue("Remove Corruption") == 5 or offheal == true) then
                for i = 1, #br.friend do
                    if br.canDispel(br.friend[i].unit, spell.removeCorruption) then
                        if cast.removeCorruption(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            end
        end
    end

    local function interrupts()
        if br.useInterrupts() then
            for i = 1, #enemies.yards45 do
                thisUnit = enemies.yards45[i]
                if br.canInterrupt(thisUnit, br.getValue("InterruptAt")) then
                    -- Solar Beam
                    if br.isChecked("Solar Beam") then
                        if cast.solarBeam(thisUnit) then
                            return
                        end
                    end
                    -- Typhoon
                    if br.isChecked("Typhoon") and talent.typhoon and br.getDistance(thisUnit) <= 15 then
                        if cast.typhoon() then
                            return
                        end
                    end
                    -- Mighty Bash
                    if br.isChecked("Mighty Bash") and talent.mightyBash and br.getDistance(thisUnit) <= 10 then
                        if cast.mightyBash(thisUnit) then
                            return true
                        end
                    end
                end
            end
        end
    end

    local function root_cc()
        local root_UnitList = {}
        if br.isChecked("Freehold - root grenadier") then
            root_UnitList[129758] = "Irontide Grenadier"
        end
        if br.isChecked("Atal - root Spirit of Gold") then
            root_UnitList[131009] = "Spirit of Gold"
        end

        for i = 1, #enemies.yards45 do
            thisUnit = enemies.yards45[i]

            if br.isChecked("Auto Soothe") then
                if cast.able.soothe() and br.canDispel(thisUnit, spell.soothe) then
                    if cast.soothe(thisUnit) then
                        return true
                    end
                end
            end

            if br.isChecked("Freehold - root grenadier") or br.isChecked("Atal - root Spirit of Gold") or br.isChecked("All - root Emissary of the Tides") or br.isChecked("KR - Minions of Zul") then
                --br.addonDebug("Mob:" .. thisUnit .. " Health: " .. br.getHP(thisUnit))
                if cast.able.massEntanglement() and not br.isLongTimeCCed(thisUnit) and br.getHP(thisUnit) > 90 then
                    if (root_UnitList[br.GetObjectID(thisUnit)] ~= nil and br.getBuffRemain(thisUnit, 226510) <= 3) then
                        if cast.massEntanglement(thisUnit) then
                            br.addonDebug("Mass Rooting:" .. thisUnit)
                            return true
                        end
                    end
                end
                if cast.able.entanglingRoots() and not br.isLongTimeCCed(thisUnit) and br.getHP(thisUnit) > 90 then
                    if (root_UnitList[br.GetObjectID(thisUnit)] ~= nil and br.getBuffRemain(thisUnit, 226510) <= 3) then
                        if cast.entanglingRoots(thisUnit) then
                            br.addonDebug("Rooting:" .. thisUnit)
                            return true
                        end
                    end
                end
            end
        end
    end
    local function PreCombat()
        if br.isValidUnit("target") then
            -- Pre-Pull Timer
            if br.isChecked("Pre-Pull Timer") and br.GetObjectExists("target") and not br.GetUnitIsDeadOrGhost("target") and br._G.UnitCanAttack("target", "player") then
                if br.PullTimerRemain() <= br.getOptionValue("Pre-Pull Timer") then
                    if mode.forms ~= 3 then
                        if not br.player.buff.moonkinForm.exists() and not cast.last.moonkinForm(1) and not br.isMoving("player") then
                             unit.cancelForm()
                            if cast.moonkinForm() then
                                return true
                            end
                        end
                    end
                    if cast.wrath() then
                        return true
                    end
                end
            end
            if br.isChecked("Auto Engage On Target") then
                if cast.able.sunfire("target") then
                    if cast.sunfire("target") then
                        return true
                    end
                elseif cast.able.moonfire("target") then
                    if cast.moonfire("target") then
                        return true
                    end
                end
            end
        end
    end

    local function travel_form()
        if br.SpecificToggle("Travel Key") and not br._G.GetCurrentKeyBoardFocus() then
            if not travel then
                if cast.travelForm("Player") then
                    return true
                end
            end
            if br.SpecificToggle("Travel Key") and not br._G.GetCurrentKeyBoardFocus() then
                return
            end
        end
    end

    local function bear_form()
        if br.SpecificToggle("Bear Key") and not br._G.GetCurrentKeyBoardFocus() then
            if not bear then
                if cast.bearForm("Player") then
                    return true
                end
            end
            if br.isChecked("Bear Frenzies Regen HP") and talent.guardianAffinity and cast.able.frenziedRegeneration() and php <= br.getValue("Bear Frenzies Regen HP") then
                if cast.frenziedRegeneration() then
                    br.addonDebug("[BEAR]Regen")
                    return true
                end
            end
            if br.SpecificToggle("Bear Key") and not br._G.GetCurrentKeyBoardFocus() then
                return
            end
        end
    end

    local function cat_form()
        if br.SpecificToggle("Cat Key") and not br._G.GetCurrentKeyBoardFocus() then
            if not cat then
                if cast.catForm("player") then
                    return true
                end
            end

            if br.isChecked("auto stealth") and not inCombat and cat then
                if not br.player.buff.prowl.exists() then
                    if cast.prowl("Player") then
                        return true
                    end
                end
            end

            if br.isChecked("auto dash") and not catspeed then
                if cast.stampedingRoarCat("player") then
                    return true
                end
                if talent.tigerDash then
                    if cast.tigerDash() then
                        return true
                    end
                end
                if cast.dash() then
                    return true
                end
            end

            if br.SpecificToggle("Cat Key") and not br._G.GetCurrentKeyBoardFocus() then
                return
            end
        end
    end

    local function extras()


        -- to prevent stun from frenzy
        if (not inCombat or #enemies.yards40 == 0) and buff.ravenousFrenzy.exists() then
            if cast.rejuvenation() then
                return true
            end
        end

        --Forms key management, in and out of combat
        if mode.forms == 2 then
            if not moonkin then
                 unit.cancelForm()
                if cast.moonkinForm() then
                    return true
                end
            end
        end

        if br.isChecked("Auto Innervate") and inCombat and cast.able.innervate() then
            for i = 1, #br.friend do
                if
                br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" and br.getDistance(br.friend[i].unit) < 45 and not br.GetUnitIsDeadOrGhost(br.friend[i].unit) and
                        br.getLineOfSight(br.friend[i].unit) and
                        not br.hasBuff(29166, br.friend[i].unit)
                then
                    if cast.innervate(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end

        if not inCombat then


            --futile attempt to keep frenzy from stunning us
            if buff.ravenousFrenzy.exists() then
                if cast.rejuvenation() then
                    return true
                end
            end



            --Resurrection
            if br.getOptionValue("Revive") == 1 then
                if br.isChecked("Revive") and not inCombat and not br.isMoving("player") then
                    if br._G.UnitIsPlayer("target") and br.GetUnitIsDeadOrGhost("target") and br.GetUnitIsFriend("target", "player") then
                        if cast.revive("target", "dead") then
                            return true
                        end
                    end
                end
            elseif br.getOptionValue("Revive") == 2 then
                if br.GetUnitExists("mouseover") and br.GetUnitIsDeadOrGhost("mouseover") and br.GetUnitIsFriend("mouseover", "player") then
                    if cast.revive("mouseover", "dead") then
                        return true
                    end
                end
            end
            -- Wild Growth
            if br.isChecked("OOC Wild Growth") and not br.isMoving("player") and php <= br.getValue("OOC Wild Growth") then
                if cast.wildGrowth() then
                    return true
                end
            end
            -- Regrowth
            if br.isChecked("OOC Regrowth") and not br.isMoving("player") and php <= br.getValue("OOC Regrowth") then
                if cast.regrowth("player") then
                    return true
                end
            end
            -- Shapeshift Form Management
            standingTime = 0
            if br.DontMoveStartTime then
                standingTime = br._G.GetTime() - br.DontMoveStartTime
            end

            if mode.forms == 1 then
                if br.isChecked("Standing Time") then
                    if (travel or buff.catForm.exists()) and not buff.prowl.exists() and standingTime > br.getValue("Standing Time") then
                         unit.cancelForm()
                        if cast.moonkinForm("player") then
                            return true
                        end
                    end
                end

                -- Flight Form
                if
                not inCombat and br.canFly() and not swimming and br.fallDist > 90 --[[falling > br.getOptionValue("Fall Timer")]] and br.player.level >= 58 and
                        not buff.prowl.exists()
                then
                    if br._G.GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                        -- CancelShapeshiftForm()
                        br._G.RunMacroText("/CancelForm")
                        br._G.CastSpellByID(783, "player")
                        return true
                    else
                        br._G.CastSpellByID(783, "player")
                        return true
                    end
                end
                -- Aquatic Form
                if (not inCombat) --[[or br.getDistance("target") >= 10--]] and swimming and not travel and not buff.prowl.exists() and br.isMoving("player") then
                    if br._G.GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                        -- CancelShapeshiftForm()
                        br._G.RunMacroText("/CancelForm")
                        br._G.CastSpellByID(783, "player")
                        return true
                    else
                        br._G.CastSpellByID(783, "player")
                        return true
                    end
                end
                -- Travel Form
                if not inCombat and not swimming and br.player.level >= 58 and not buff.prowl.exists() and not catspeed and not travel and not mount and not br._G.IsIndoors() and br.IsMovingTime(1) then
                    if br._G.GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                        br._G.RunMacroText("/CancelForm")
                        if br.isChecked("Use Mount Form") and not br.canFly() then
                            br._G.CastSpellByID(210053, "player")
                        else
                            br._G.CastSpellByID(783, "player")
                        end
                        return true
                    else
                        if br.isChecked("Use Mount Form") and not br.canFly() then
                            br._G.CastSpellByID(210053, "player")
                        else
                            br._G.CastSpellByID(783, "player")
                        end
                        return true
                    end
                end
                -- Cat Form
                if not cat and not br._G.IsMounted() and not flying and br._G.IsIndoors() then
                    -- Cat Form when not swimming or flying or stag and not in combat
                    if moving and br.IsMovingTime(3) and not swimming and not flying and not travel then
                        if cast.catForm("player") then
                            return true
                        end
                    end
                    -- Cat Form - Less Fall Damage
                    if (not br.canFly() or inCombat or br.player.level < 58) and (not swimming or (not moving and swimming and #enemies.yards5 > 0)) and br.fallDist > 90 then
                        --falling > br.getOptionValue("Fall Timer") then
                        if cast.catForm("player") then
                            return true
                        end
                    end
                end
            end -- End Shapeshift Form Management
        end
    end

    -----------------
    --- Rotations ---
    -----------------
    -- Pause
    if not br._G.IsMounted() or mode.rotation == 4 then
        -- br.player.buff.travelForm.exists() or br.player.buff.flightForm.exists())
        if br.pause() or drinking or mode.rotation == 4 or buff.soulshape.exists() then
            return true
        else
            ---------------------------------
            --- Out Of Combat - Rotations ---
            ---------------------------------````````````````````````````````````````````
            if not inCombat and not br.UnitBuffID("player", 115834) then

                if mode.forms == 2 then
                    if br.SpecificToggle("Cat Key") and not br._G.GetCurrentKeyBoardFocus() then
                        cat_form()
                        return true
                    elseif br.SpecificToggle("Bear Key") and not br._G.GetCurrentKeyBoardFocus() then
                        bear_form()
                        return true
                    elseif br.SpecificToggle("Travel Key") and not br._G.GetCurrentKeyBoardFocus() then
                        travel_form()
                        return true
                    end
                end

                if extras() then
                    return true
                end
                if br.useDefensive() then
                    if defensive() then
                        return true
                    end
                end
                if PreCombat() then
                    return true
                end
            end -- End Out of Combat Rotation
            -----------------------------
            --- In Combat - Rotations ---
            -----------------------------
            if inCombat and not br.UnitBuffID("player", 115834) then
                if mode.forms == 2 then
                    if br.SpecificToggle("Cat Key") and not br._G.GetCurrentKeyBoardFocus() then
                        cat_form()
                        return true
                    elseif br.SpecificToggle("Bear Key") and not br._G.GetCurrentKeyBoardFocus() then
                        bear_form()
                        return true
                    elseif br.SpecificToggle("Travel Key") and not br._G.GetCurrentKeyBoardFocus() then
                        travel_form()
                        return true
                    end
                end
                if extras() then
                    return true
                end
                if br.useInterrupts() then
                    if interrupts() then
                        return true
                    end
                end
                if br.useDefensive() then
                    if defensive() then
                        return true
                    end
                end
                if root_cc() then
                    return true
                end
                if mode.rotation ~= 4 then
                    if dps() then
                        return true
                    end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation

local id = 102
if br.rotations[id] == nil then
    br.rotations[id] = {}
end

br._G.tinsert(
        br.rotations[id],
        {
            name = rotationName,
            toggles = createToggles,
            options = createOptions,
            run = runRotation
        }
)

local rotationName = "Laksmackt" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Define custom toggles
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of enemies in range.", highlight = 1, icon = br.player.spell.moonfire },
        [2] = { mode = "Mult", value = 2, overlay = "Multi Target rotation", tip = "Multi Target rotation", highlight = 1, icon = br.player.spell.starfall },
        [3] = { mode = "Sing", value = 3, overlay = "Force single target", tip = "Force single target", highlight = 0, icon = br.player.spell.wrath },
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.soothe }
    };
    CreateButton("Rotation", 1, 0)

    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.celestialAlignment },
        [2] = { mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.celestialAlignment },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.celestialAlignment }
    };
    CreateButton("Cooldown", 2, 0)

    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.barkskin },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.barkskin }
    };
    CreateButton("Defensive", 3, 0)

    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.solarBeam },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.solarBeam }
    };
    CreateButton("Interrupt", 4, 0)

    -- FoN Button
    ForceofNatureModes = {
        [1] = { mode = "On", value = 1, overlay = "Force of Nature Enabled", tip = "Will Use Force of Nature", highlight = 0, icon = br.player.spell.forceOfNature },
        [2] = { mode = "Key", value = 2, overlay = "Force of Nature hotkey", tip = "Key triggers Force of Nature", highlight = 0, icon = br.player.spell.forceOfNature },
        [3] = { mode = "Off", value = 2, overlay = "Force of Nature Disabled", tip = "Will Not Use Force of Nature", highlight = 0, icon = br.player.spell.forceOfNature }
    };
    CreateButton("ForceofNature", 5, 0)

    FormsModes = {
        [1] = { mode = "On", value = 1, overlay = "Auto Forms Enabled", tip = "Will change forms", highlight = 0, icon = br.player.spell.travelForm },
        [2] = { mode = "Key", value = 2, overlay = "Auto Forms hotkey", tip = "Key triggers Auto Forms", highlight = 0, icon = br.player.spell.travelForm },
        [3] = { mode = "Off", value = 3, overlay = "Auto Forms Disabled", tip = "Will Not change forms", highlight = 0, icon = br.player.spell.travelForm }
    };
    CreateButton("Forms", 6, 0)


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
        section = br.ui:createSection(br.ui.window.profile, "Forms - SL 2101011533")
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
        br.ui:createDropdownWithout(section, "Pots - 1 target", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury" }, 1, "", "Use Pot when Incarnation/Celestial Alignment is up")
        br.ui:createDropdownWithout(section, "Pots - 2-3 targets", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury" }, 1, "", "Use Pot when Incarnation/Celestial Alignment is up")
        br.ui:createDropdownWithout(section, "Pots - 4+ target", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury" }, 1, "", "Use Pot when Incarnation/Celestial Alignment is up")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createCheckbox(section, "Auto Innervate", "Use Innervate")
        br.ui:createCheckbox(section, "Racial")
        br.ui:createCheckbox(section, "Use Trinkets")
        br.ui:createCheckbox(section, "Warrior Of Elune")
        br.ui:createCheckbox(section, "Fury Of Elune")
        br.ui:createSpinnerWithout(section, "Fury of Elune Targets", 3, 1, 10, 1, "How many baddies before using Fury?")
        br.ui:createCheckbox(section, "Group Fury with CD")
        br.ui:createCheckbox(section, "Incarnation/Celestial Alignment")
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
        br.ui:createSpinnerWithout(section, "Starfall Targets (0 for auto)", 0, 0, 30, 1, "Set to minimum number of targets to use Starfall. 0 to calculate")
        br.ui:createSpinnerWithout(section, "Fury of Elune Targets", 2, 1, 10, 1, "Set to minimum number of targets to use Fury of Elune. Min: 1 / Max: 10 / Interval: 1")
        br.ui:createCheckbox(section, "Ignore dots during pewbuff")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Root/CC")
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

        --[[
           ----------------------
           --- TOGGLE OPTIONS --- -- Define Toggle Options
           ----------------------
           section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
           -- Single/Multi Toggle
           br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle, 4)
           --Cooldown Key Toggle
           br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle, 3)
           --Defensive Key Toggle
           br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle, 6)
           -- Interrupts Key Toggle
           br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
           -- Pause Toggle
           br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
           br.ui:checkSectionState(section)
       ]]
    end

    optionTable = { {
                        [1] = "Rotation Options",
                        [2] = rotationOptions,
                    } }
    return optionTable
end

local function runRotation()

    ---------------
    --- Toggles --- -- List toggles here in order to update when pressed
    ---------------
    UpdateToggle("Rotation", 0.25)
    UpdateToggle("Cooldown", 0.25)
    UpdateToggle("Defensive", 0.25)
    UpdateToggle("Interrupt", 0.25)
    UpdateToggle("ForceofNature", 0.25)
    UpdateToggle("Forms", 0.25)
    --UpdateToggle("Pots", 0.25)

    --    br.ui.player.mode.forceOfNature = br.data.settings[br.selectedSpec].toggles["ForceofNature"]
    --  br.ui.player.mode.DPS = br.data.settings[br.selectedSpec].toggles["Rotation"]
    --br.ui.player.mode.forms = br.data.settings[br.selectedSpec].toggles["Forms"]


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
    local drinking = getBuffRemain("player", 192002) ~= 0 or getBuffRemain("player", 167152) ~= 0 or getBuffRemain("player", 192001) ~= 0
    local inCombat = br.player.inCombat
    local inInstance = br.player.instance == "party" or br.player.instance == "scenario"
    local inRaid = br.player.instance == "raid"
    local solo = #br.friend == 1
    local race = br.player.race
    local traits = br.player.traits
    local moving = isMoving("player")
    local swimming = IsSwimming()
    local ttd = getTTD
    local catspeed = br.player.buff.dash.exists() or br.player.buff.tigerDash.exists()
    local hasteAmount = GetHaste() / 100
    local masteryAmount = GetMastery() / 100
    local thisUnit
    local aoeTarget = 0
    local conduit = br.player.conduit
    local covenant = br.player.covenant
    local travel = br.player.buff.travelForm.exists()
    local mount = GetShapeshiftForm() == 6 --- or maybe br.player.buff.mountForm.exists() but this is not working (mountform has no buff? idk)
    local cat = br.player.buff.catForm.exists()
    local moonkin = br.player.buff.moonkinForm.exists()
    local bear = br.player.buff.bearForm.exists()
    local eclipse_next = "any"
    local ui = br.player.ui
    local runeforge = br.player.runeforge


    -------------
    -- Raid
    ------------

    local tanks = getTanksTable()
    local gcd = br.player.gcdMax
    -- Enemies
    -------------
    local enemies = br.player.enemies
    local mode
    local units = br.player.units
    local pewbuff = buff.incarnationChoseOfElune.exists() or buff.celestialAlignment.exists()
    local starfallRadius

    local tank
    if #tanks > 0 and inInstance then
        tank = tanks[1].unit
    else
        tank = "Player"
    end

    --wipe timers table
    if timersTable then
        wipe(timersTable)
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
            [1122] = "Summon Infernal",
        }
        for i = 1, #already_stunned_list do
            --  Print(select(10, UnitDebuff(Unit, i)))
            local debuffSpellID = select(10, UnitDebuff(Unit, i))
            if debuffSpellID == nil then
                return false
            end

            --    Print(tostring(already_stunned_list[tonumber(debuffSpellID)]))
            if already_stunned_list[tonumber(debuffSpellID)] ~= nil then
                return true
            end
        end
        return false
    end

    local timers = {}
    timers._timers = {}
    function timers.time(name, fn)
        local time = timers._timers[name]
        if fn then
            if not time then
                time = GetTime()
            end
        else
            time = nil
        end
        timers._timers[name] = time
        return time and (GetTime() - time) or 0
    end

    local function int (b)
        return b and 1 or 0
    end

    local function isCC(unit)
        if getOptionCheck("Don't break CCs") then
            return isLongTimeCCed(Unit)
        end
    end
    --Print(tostring(mode.DPS))

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

    function getDebuffCount(spellID)
        local counter = 0
        for k, _ in pairs(br.enemy) do
            thisUnit = br.enemy[k].unit
            -- check if unit is valid
            if GetObjectExists(thisUnit) then
                -- increase counter for each occurences
                if UnitDebuffID(thisUnit, spellID, "exact") then
                    counter = counter + 1
                end
            end
        end
        return tonumber(counter)
    end
    function getBiggestUnitCluster(maxRange, radius)
        -- Description:
        -- returns the enemy with most enemies in radius in maxRange from player

        -- rerturns:
        -- "0x0000000110E4F09C"

        -- how to use:
        -- castSpell(getBiggestUnitCluster(40,10),SpellID,...,...)
        -- use "getBiggestUnitCluster(maxRange,radius)" instead of "target"

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
            if getLineOfSight(thisUnit) == true then
                if br.enemy[i].distance < maxRange then
                    if getNumEnemies(thisUnit, radius) > enemiesInRange then
                        theReturnUnit = thisUnit
                    end
                end
            end
        end
        return select(1, theReturnUnit)
    end



    --Clear last cast table ooc to avoid strange casts
    if #br.lastCast.tracker > 0 then
        wipe(br.lastCast.tracker)
    end

    local astral_max = 0
    local astral_def = 0

    if talent.naturesBalance then
        astral_max = 95
    else
        astral_max = 100
    end
    astral_def = astral_max - power

    --Print(astral_def)

    local function noDamageCheck(unit)
        if isChecked("Dont DPS spotter") and GetObjectID(unit) == 135263 then
            return true
        end
        if isCC(unit) then
            return true
        end
        if GetObjectID(unit) == 127019 then
            --dummies inside of Freehold
            return true
        end
        if hasBuff(263246, unit) then
            -- shields on first boss in temple
            return true
        end
        if hasBuff(260189, unit) then
            -- shields on last boss in MOTHERLODE
            return true
        end
        if hasBuff(261264, unit) or hasBuff(261265, unit) or hasBuff(261266, unit) then
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
    if DontMoveStartTime then
        standingTime = GetTime() - DontMoveStartTime
    end
    function isExplosive(Unit)
        return GetObjectID(Unit) == 120651
    end

    function getOutLaksTTDMAX()
        local highTTD = 0
        local mob_count = #enemies.yards45
        if mob_count > 6 then
            mob_count = 6
        end
        if #enemies.yards45 > 1 then
            for i = 1, mob_count do

                if getTTD(enemies.yards45[i]) > highTTD and getTTD(enemies.yards45[i]) < 999 and not isExplosive(enemies.yards45[i]) and
                        isSafeToAttack(enemies.yards45[i]) then
                    highTTD = getTTD(enemies.yards45[i])
                end
            end
        end
        return tonumber(highTTD)
    end

    local function dps()

        if mode.forms ~= 3 then
            if not br.player.buff.moonkinForm.exists() and not buff.prowl.exists() and not cast.last.moonkinForm(1) then
                if cast.moonkinForm() then
                    return true
                end
            end
        end

        local radar = "off"

        --Building root list
        local root_UnitList = {}

        if isChecked("Root - Spiteful(M+)") then
            root_UnitList[174773] = "Spiteful"
            radar = "on"
        end
        if isChecked("KR - root Minions of Zul") then
            root_UnitList[133943] = "minion-of-zul"
            radar = "on"
        end
        if isChecked("FH - root grenadier") then
            root_UnitList[129758] = "grenadier"
            radar = "on"
        end
        if isChecked("KR - root Spirit of Gold") then
            root_UnitList[131009] = "root Spirit of Gold"
            radar = "on"
        end
        if isChecked("KR - animated gold") then
            root_UnitList[135406] = "animated gold"
            radar = "on"
        end
        --test dude
        if 1 == 2 then
            root_UnitList[143647] = "my little friend"
            radar = "on"
        end

        if radar == "on" then

            local root = "Entangling Roots"
            local root_range = 35
            if talent.massEntanglement and cast.able.massEntanglement then
                root = "Mass Entanglement"
            end

            if (root == "Mass Entanglement" and cast.able.massEntanglement()) or cast.able.entanglingRoots() then
                for i = 1, GetObjectCountBR() do
                    local object = GetObjectWithIndex(i)
                    local ID = ObjectID(object)
                    if root_UnitList[ID] ~= nil and getBuffRemain(object, 226510) == 0 and getHP(object) > 90 and not isLongTimeCCed(object) and (getBuffRemain(object, 102359) < 2 or getBuffRemain(object, 339) < 2) then
                        local x1, y1, z1 = ObjectPosition("player")
                        local x2, y2, z2 = ObjectPosition(object)
                        local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                        if distance <= 8 and talent.mightyBash then
                            CastSpellByName("Mighty Bash", object)
                            return true
                        end
                        if distance < root_range and not isLongTimeCCed(object) and not already_stunned(object) then
                            CastSpellByName(root, object)
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
        if isChecked("Auto use Pots") then
            local pot_use
            if getValue("Auto use Pots") == 1
                    or getValue("Auto use Pots") == 2 and inInstance
                    or getValue("Auto use Pots") == 3 and inRaid
                    or getValue("Auto use Pots") == 4 and solo
            then
                pot_use = true
            end

            if pot_use then
                local auto_pot
                if #enemies.yards12t == 1 and isBoss("target") then
                    auto_pot = getOptionValue("Pots - 1 target")
                elseif #enemies.yards12t >= 2 and #enemies.yards12t <= 3 then
                    auto_pot = getOptionValue("Pots - 2-3 targets")
                elseif #enemies.yards12t >= 4 then
                    auto_pot = getOptionValue("Pots - 4+ target")
                end

                if not auto_pot == 1 and (buff.incarnationChoseOfElune.exists() and buff.incarnationChoseOfElune.remain() > 16.5) or (buff.celestialAlignment.exists() and buff.celestialAlignment.remain() > 13) then
                    if auto_pot == 2 and canUseItem(163222) then
                        useItem(163222)
                    elseif auto_pot == 3 and canUseItem(152559) then
                        useItem(152559)
                    elseif auto_pot == 4 and canUseItem(109218) then
                        useItem(109218)
                    elseif auto_pot == 5 and canUseItem(142117) then
                        useItem(142117)
                    elseif auto_pot == 6 and #enemies.yards12 > 3 and canUseItem(168529) then
                        useItem(168529)
                    elseif auto_pot == 7 and canUseItem(168506) then
                        useItem(168506)
                    elseif auto_pot == 8 and canUseItem(168498) then
                        useItem(168498)
                    elseif auto_pot == 9 and canUseItem(169299) then
                        useItem(169299)
                    end
                end
            end
        end

        if race == "Troll" and isChecked("Racial") and useCDs() and ttd("target") >= 12 and ((buff.incarnationChoseOfElune.exists() and buff.incarnationChoseOfElune.remain() > 16.5) or (buff.celestialAlignment.exists() and buff.celestialAlignment.remain() > 13)) then
            cast.racial("player")
        end

        local is_aoe = (#enemies.yards45 > 1 and (not talent.starlord or talent.stellarDrift) or #enemies.yards45 > 2) or false
        local is_cleave = #enemies.yards45 > 1 or false
        local starfall_wont_fall_off = power > 80 - (buff.starfall.remains() * 3 / hasteAmount) and buff.starfall.exists() or false
        local starfire_in_solar = #enemies.yards45 > 8 + math.floor(masteryAmount / 20)

        local starfire_fallback = cast.last.starfire(1) and cast.last.starfire(2) and cast.last.starfire(3) or false
        local wrath_fallback = cast.last.wrath(1) and cast.last.wrath(2) and cast.last.wrath(3) or false

        local convoke_desync = false
        if math.floor((getOutLaksTTDMAX() - 20 - cd.convokeTheSpirits.remains()) / 120) > math.floor((getOutLaksTTDMAX() - 25 - (10 * int(talent.incarnationChoseOfElune) - (int(conduit.preciseAlignment.enabled)) - pew_remain())) / 180)
                or pew_remain() > getOutLaksTTDMAX()
                or cd.convokeTheSpirits.remains() > getOutLaksTTDMAX()
                or not covenant.nightFae.active then
            convoke_desync = true

        else
            convoke_desync = false
        end



        --   local cd_condition = ( not equipped.empyreal_ordnance|cooldown.empyreal_ordnance.remains<160&!cooldown.empyreal_ordnance.ready)|covenant.kyrian


        if buff.starlord.exists() and buff.starlord.remains() < 3 and astral_def < 8 then
            br.addonDebug("[Cancel SL]: Buff Remains: " .. tostring(buff.starlord.remain()) .. "Astral Def: " .. tostring(astral_def))
            cancelBuff(279709)
        end

        local current_eclipse = "none"
        local eclipse_in = false

        if GetSpellCount(190984) == 0 and GetSpellCount(194153) == 0 then
            eclipse_in = true
        else
            eclipse_in = false
        end

        if not eclipse_in then
            if GetSpellCount(190984) == 0 and GetSpellCount(194153) > 0 then
                eclipse_next = "solar"
            elseif GetSpellCount(190984) > 0 and GetSpellCount(194153) == 0 then
                eclipse_next = "lunar"
            else
                eclipse_next = "any"
            end
        else
            if buff.eclipse_solar.exists() and not buff.eclipse_lunar.exists() then
                current_eclipse = "solar"
            elseif not buff.eclipse_solar.exists() and buff.eclipse_lunar.exists() then
                current_eclipse = "lunar"
            elseif buff.eclipse_solar.exists() and buff.eclipse_lunar.exists() then
                current_eclipse = "any "
            end
            eclipse_next = "none"
        end

        -- Print("In Eclipse: " .. tostring(eclipse_in) .. " next:  " .. eclipse_next)

        if mode.rotation < 4 then


            --trinkets
            local Trinket13 = GetInventoryItemID("player", 13)
            local Trinket14 = GetInventoryItemID("player", 14)

            if isChecked("Use Trinkets") then
                --VenumousShivers
                if (Trinket13 == 168905 or Trinket14 == 168905)
                        and getDebuffStacks("target", 301624) == 5 then
                    if canUseItem(168905) then
                        useItem(168905)
                    end
                end


                -- Generic fallback
                if (pewbuff or (cd.celestialAlignment.remain() > 30 or cd.incarnationChoseOfElune.remain() > 30)) then
                    if Trinket13 ~= 168905 and Trinket13 ~= 167555 then
                        if canUseItem(13) then
                            useItem(13)
                        end
                    end
                    if Trinket14 ~= 168905 and Trinket14 ~= 167555 then
                        if canUseItem(14) then
                            useItem(14)
                        end
                    end
                end
            end


            -- Force Of Nature / treants
            if talent.forceOfNature and cast.able.forceOfNature() and astral_def > 20 then
                if br.player.ui.mode.forceofNature == 1 and getTTD("target") >= 10
                        and (isChecked("Group treants with CD") and (pewbuff or cd.celestialAlignment.remain() > 30 or cd.incarnationChoseOfElune.remain() > 30) or not isChecked("Group treants with CD"))
                        and (#enemies.yards12t >= getValue("Treant Targets") or isBoss()) then
                    if cast.forceOfNature("best", nil, 1, 15, true) then
                        return true
                    end
                elseif br.player.ui.mode.forceofNature == 2 and isChecked("Treants Key") and SpecificToggle("Treants Key") and not GetCurrentKeyBoardFocus() then
                    if cast.forceOfNature("best", nil, 1, 15, true) then
                        return true
                    end
                end
            end
            --	fury_of_elune
            if talent.furyOfElune and isChecked("Fury Of Elune") and
                    (furyUnits >= getValue("Fury of Elune Targets") or isBoss("target"))
                    and astral_def > 8
                    and (isChecked("Group Fury with CD") and (pewbuff or cd.celestialAlignment.remain() > 30 or cd.incarnationChoseOfElune.remain() > 30) or not isChecked("Group Fury with CD")) then
                if cast.furyOfElune() then
                    return true
                end
            end


            -- DPS rotation


            --if we are moving, we should try to starfall, otherwise rotate instants
            if isMoving("player") and not buff.starfall.exists() then
                if cast.able.starfall() then
                    if cast.starfall() then
                        return true
                    end
                elseif cast.able.sunfire(units.dyn45) and not cast.last.sunfire(1) then
                    if cast.sunfire(units.dyn45) then
                        return true
                    end
                else
                    if cast.moonfire(units.dyn45) then
                        return true
                    end
                end
            end

            if mode.rotation == 1 and is_aoe or mode.rotation == 2 then
                -- AOE rotation
                --AOE Variables

                --        local dream_will_fall_off =(buff.timewornDreambinder.remains<gcd +0.1 or buff.timewornDreambinder.remains<action.starfire.execute_time+0.1&(eclipse.in_lunar|eclipse.solar_next|eclipse.any_next))&buff.timeworn_dreambinder.up&runeforge.timeworn_dreambinder.equipped
                local ignore_starsurge = buff.eclipse_lunar.exists() and (#enemies.yards45 > 4 and talent.soulOfTheForest or #enemies.yards45 > 6) or false


                --convoke_the_spirits,
                if useCDs() and cast.able.convokeTheSpirits()
                        and (
                        (convoke_desync and pew_remain() > 0 or pewbuff)
                                and (power < 50 or ignore_starsurge)
                                and (buff.eclipse_lunar.remains() > 6 or buff.eclipse_solar.remains() > 6)
                                and (not runeforge.balanceOfAllThings.equipped or buff.balanceOfAllThingsNature.stack() > 3 or buff.balanceOfAllThingsArcane.stack() > 3)
                                or getOutLaksTTDMAX() < 10) then
                    if cast.convokeTheSpirits(units.dyn45) then
                        return true
                    end
                end
                if debuff.sunfire.count() < getOptionValue("Max Sunfire Targets") then
                    for i = 1, #enemies.yards45 do
                        thisUnit = enemies.yards45[i]
                        if UnitAffectingCombat(thisUnit) then
                            if cast.able.sunfire()
                                    and (not cast.last.sunfire(1)
                                    and debuff.sunfire.refresh(thisUnit)
                                    and ttd(thisUnit) > (14 - #enemies.yards45 + debuff.sunfire.remains(thisUnit)) and eclipse_in)
                                    or isMoving("player") and not cast.last.sunfire(1)
                            then
                                if cast.sunfire(thisUnit) then
                                    return true
                                end
                            end
                        end
                    end
                end

                --starfall
                if cast.able.starfall()
                        and not buff.starfall.exists() or buff.starfall.refresh() and (#enemies.yards45 < 3 or not runeforge.timewornDreambinder.equipped) and (not runeforge.lycarasFleetingGlimpse.equipped) and getTTD(enemies.yards45[i]) > 5 then
                    if cast.starfall() then
                        return true
                    end
                end

                starfall_wont_fall_off = power > 80 - (10 * buff.timewornDreambinder.stack()) - (buff.starfall.remains() * 3 / GetHaste() / 100) and buff.starfall.exists() or false

                --starsurge here

                if dream_will_fall_off and starfall_wont_fall_off and not ignore_starsurge
                        or (buff.balanceOfAllThingsNature.stack() > 3 or buff.balanceOfAllThingsArcane.stack() > 3) and #enemies.yards45 < 4 then
                    if cast.starsurge(units.dyn45) then
                        br.addonDebug("SS - BOAT")
                        return true
                    end
                end


                --adaptive swarm here
                --  if =!ticking&!action.adaptive_swarm_damage.in_flight|dot.adaptive_swarm_damage.stack<3&dot.adaptive_swarm_damage.remains<3
                if cast.able.adaptiveSwarm() then
                    if not debuff.adaptiveSwarm.exists(units.dyn45) or debuff.adaptiveSwarm.exists(units.dyn45) and debuff.adaptiveSwarm.remains(units.dyn45) < 3 then
                        if cast.adaptiveSwarm(units.dyn45) then
                            return true
                        end
                    end
                end

                --dots
                if cast.able.moonfire(thisUnit) and debuff.moonfire.count() < getOptionValue("Max Moonfire Targets") then
                    for i = 1, #enemies.yards45 do
                        thisUnit = enemies.yards45[i]
                        if UnitAffectingCombat(thisUnit) then
                            -- moonfire
                            if (not debuff.moonfire.exists(thisUnit) or debuff.moonfire.refresh(thisUnit)) and getTTD(thisUnit) > (14 + (#enemies.yards45 * 1.5)) / #enemies.yards45 + debuff.moonfire.remain(thisUnit) then
                                if pew_remain() == 0 and not useCDs() and (convoke_desync or cd.convokeTheSpirits.ready() or not covenant.nightFae.active)
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

                    --[[
                    --stellarFlare
                    if talent.stellarFlare and debuff.stellarFlare.refresh() and ttd(thisUnit) > 15 then
                        if #enemies.yards45 < 4
                                and astral_def > 8 and (buff.celestialAlignment.remain() > 10 or buff.incarnationChoseOfElune.remain() > 10 or not pewbuff)
                        then
                            if cast.stellarFlare(thisUnit) then
                                return true
                            end
                        end
                    end  ]]
                end

                -- Force Of Nature / treants
                if talent.forceOfNature and cast.able.forceOfNature() and astral_def > 20 then
                    if br.player.ui.mode.forceofNature == 1 and getTTD("target") >= 10
                            and (isChecked("Group treants with CD") and (pewbuff or cd.celestialAlignment.remain() > 30 or cd.incarnationChoseOfElune.remain() > 30) or not isChecked("Group treants with CD"))
                            and (#enemies.yards12t >= getValue("Treant Targets") or isBoss()) then
                        if cast.forceOfNature("best", nil, 1, 15, true) then
                            return true
                        end
                    elseif br.player.ui.mode.forceofNature == 2 and isChecked("Treants Key") and SpecificToggle("Treants Key") and not GetCurrentKeyBoardFocus() then
                        if cast.forceOfNature("best", nil, 1, 15, true) then
                            return true
                        end
                    end
                end

                -- celestialAlignment
                if useCDs() and isChecked("Incarnation/Celestial Alignment") then
                    if (buff.starfall.exists() or power > 50) and not eclipse_in and not pewbuff
                            and (not covenant.nightFae.active or convoke_desync or cd.convokeTheSpirits.ready() or getOutLaksTTDMAX() < 20) then
                        if not talent.incarnationChoseOfElune and cast.able.celestialAlignment() then
                            if cast.celestialAlignment() then
                            end
                        elseif talent.incarnationChoseOfElune and cast.able.incarnationChoseOfElune() then
                            if cast.incarnationChoseOfElune() then
                            end
                        end
                    end
                end

                --starsurge,
                if cast.able.starsurge() then


                    if buff.onethsClearVision.exists() or (astral_def > 8 or ((buff.incarnationChoseOfElune.remains() < 5 or buff.celestialAlignment.remains() < 5) and pewbuff
                            or (buff.ravenousFrenzy.remains() < gcd * math.ceil(power / 30) and buff.ravenousFrenzy.exists())) and starfall_wont_fall_off and #enemies.yards45 < 3)
                            and (not runeforge.timewornDreambinder.equipped or #enemies.yards45 < 3) then
                        if cast.starsurge(units.dyn45) then
                            return true
                        end
                    end

                    --starsurge

                    if buff.onethsClearVision.exists()
                            or astral_def < 8
                            or ((buff.incarnationChoseOfElune.remains() < 5 or buff.celestialAlignment.remains() < 5) and pewbuff
                            or (buff.ravenousFrenzy.remains() < gcd * math.ceil(power / 30) and buff.ravenousFrenzy.exists()))
                            and starfall_wont_fall_off and #enemies.yards45 < 3 then
                        if cast.starsurge(units.dyn45) then
                            return true
                        end
                    end
                end


                --new starfall here
                if covenant.nightFae.active and (convoke_desync or pew_remain() == 0 or pewbuff)
                        and cd.convokeTheSpirits.remains() < gcd * math.ceil(power / 50) and buff.starfall.remains() < 4 then
                    if cast.starfall() then
                        return true
                    end
                end


                -- starsurge 2
                if covenant.nightFae.active and (convoke_desync or pew_remain() == 0 or pewbuff and cd.convokeTheSpirits.remains() < 6)
                        and buff.starfall.exists() and eclipse_in and not ignore_starsurge then
                    if cast.starsurge(units.dyn45) then
                        return true
                    end
                end
                -- starsurge 3
                if buff.onethsClearVision.exists() or (astral_def > 8 or (pew_remain() < 5 and pewbuff
                        or (buff.ravenousFrenzy.remains() < gcd * math.ceil(power / 30) and buff.ravenousFrenzy.exists()))
                        and starfall_wont_fall_off and #enemies.yards45 < 3) and (not runeforge.timewornDreambinder.equipped or #enemies.yards45 < 3) then
                    if cast.starsurge(units.dyn45) then
                        return true
                    end
                end

                --moon shit here .. not supported ..cause fuck that

                -- Warrior of Elune
                if useCDs() and isChecked("Warrior Of Elune") and talent.warriorOfElune and not buff.warriorOfElune.exists() then
                    if cast.warriorOfElune() then
                        return true
                    end
                end

                starfire_in_solar = #enemies.yards45 > 4 + math.floor(masteryAmount * 100 / 20) + math.floor(buff.solarEmpowerment.stack() / 4)

                --wrath
                if eclipse_next == "lunar" or eclipse_next == "any" and is_cleave or buff.eclipse_solar.remains() < getCastTime(spell.starfire) and buff.eclipse_solar.exists()
                        or buff.eclipse_solar.exists() and not starfire_in_solar or (buff.incarnationChoseOfElune.remains() < getCastTime(spell.starfire) or buff.celestialAlignment.remains() < getCastTime(spell.starfire))
                        and not is_cleave and (buff.incarnationChoseOfElune.remains() < getCastTime(spell.wrath) or buff.celestialAlignment.remains() < getCastTime(spell.wrath)) and pewbuff
                        or buff.ravenousFrenzy.exists() and (GetHaste() / 100) > 0.6 and (#enemies.yards45 <= 3 or not talent.soulOfTheForest) or not is_cleave
                        and (buff.incarnationChoseOfElune.remains() < getCastTime(spell.wrath) or buff.celestialAlignment.remains() < getCastTime(spell.wrath)) then
                    if cast.wrath(units.dyn45) then
                        return true
                    end
                end

                if cast.able.starfire() then
                    if cast.starfire(getBiggestUnitCluster(45, 8)) then
                        return true
                    end
                end
            elseif not is_aoe or mode.rotation == 3 then
                --ST   (single target rotation)

                --adaptive swarm here
                --  if =!ticking&!action.adaptive_swarm_damage.in_flight|dot.adaptive_swarm_damage.stack<3&dot.adaptive_swarm_damage.remains<3
                if cast.able.adaptiveSwarm() then
                    if not debuff.adaptiveSwarm.exists(units.dyn45) or debuff.adaptiveSwarm.exists(units.dyn45) and debuff.adaptiveSwarm.remains(units.dyn45) < 3 then
                        if cast.adaptiveSwarm(units.dyn45) then
                            return true
                        end
                    end
                end

                --convoke_the_spirits
                if useCDs() and cd.convokeTheSpirits.remain() == 0
                        and (
                        (convoke_desync and pew_remain() > 0 or pewbuff)
                                and power < 40
                                and (buff.eclipse_lunar.remains() > 10 or buff.eclipse_solar.remains() > 10)
                                and getOutLaksTTDMAX() > 10) then
                    if cast.convokeTheSpirits() then
                        return true
                    end
                end

                local dot_requirements = (buff.incarnationChoseOfElune.remains() < 5 or buff.celestialAlignment.remains() < 5)
                        and (buff.ravenousFrenzy.remains() > 5 or not buff.ravenousFrenzy.exists() or not pewbuff or power < 30)
                        and (not buff.kindredEmpowermentEnergize.exists() or power < 30)
                        and (buff.eclipse_solar.remains() > gcd or buff.eclipse_lunar.remains() > gcd) or false

                if cast.able.moonfire(units.dyn45) and dot_requirements and getTTD(units.dyn45) > 12 and astral_def > 8 and (not debuff.moonfire.exists(units.dyn45) or debuff.moonfire.remain(units.dyn45) < 6.6) then
                    if cast.moonfire("target") then
                        return true
                    end
                end
                if cast.able.sunfire(units.dyn45) and dot_requirements and (not debuff.sunfire.exists(units.dyn45) or debuff.sunfire.remain(units.dyn45) < 5.4) and ttd(units.dyn45) > 12 then
                    if cast.sunfire(units.dyn45) then
                        return true
                    end
                end

                -- stellarFlare
                if talent.stellarFlare and not cast.last.stellarFlare(1) and cast.able.stellarFlare()
                        and debuff.stellarFlare.refresh(units.dyn45) and ttd(units.dyn45) > 16
                        and dot_requirements then
                    if cast.stellarFlare(units.dyn45) then
                        return true
                    end
                end

                -- Force Of Nature / treants   SINGLE TARGET
                if talent.forceOfNature and cast.able.forceOfNature() and astral_def > 20 then
                    if br.player.ui.mode.forceofNature == 1 and getTTD("target") >= 10
                            and (isChecked("Group treants with CD") and (pewbuff or cd.celestialAlignment.remain() > 30 or cd.incarnationChoseOfElune.remain() > 30) or not isChecked("Group treants with CD"))
                            and (#enemies.yards12t >= getValue("Treant Targets") or isBoss()) then
                        if cast.forceOfNature("best", nil, 1, 15, true) then
                            return true
                        end
                    elseif br.player.ui.mode.forceofNature == 2 and isChecked("Treants Key") and SpecificToggle("Treants Key") and not GetCurrentKeyBoardFocus() then
                        if cast.forceOfNature("best", nil, 1, 15, true) then
                            return true
                        end
                    end
                end


                -- racenousFrenzy here
                if cast.able.ravenousFrenzy() and pewbuff then
                    if cast.ravenousFrenzy() then
                        return true
                    end
                end

                if useCDs() and isChecked("Incarnation/Celestial Alignment") then
                    if not talent.incarnationChoseOfElune then
                        if (power > 90 and (buff.kindredEmpowermentEnergize.exists() or not covenant.kyrian.active)
                                or covenant.nightFae.active or is_aoe or hasBloodLust() and (hasBloodLustRemain() < 20) + ((9 * int(runeforge.primordialArcanicPulsar.equipped)) + (int(conduit.preciseAlignment))))
                                and not pewbuff and (not covenant.nightFae.active or cd.convokeTheSpirits == 0 or getOutLaksTTDMAX() < (cd.convokeTheSpirits.remains() + 6))
                        then
                            if cast.celestialAlignment() then
                                return true
                            end
                        end
                    else
                        if (power > 90 and (buff.kindredEmpowermentEnergize.exists() or not covenant.kyrian.active)
                                or covenant.nightFae.active or is_aoe or hasBloodLust() and (hasBloodLustRemain() < 30) + ((9 * int(runeforge.primordialArcanicPulsar.equipped)) + (int(conduit.preciseAlignment))))
                                and not pewbuff and (not covenant.nightFae.active or cd.convokeTheSpirits == 0 or getOutLaksTTDMAX() < (cd.convokeTheSpirits.remains() + 6))
                        then
                            if cast.incarnationChoseOfElune() then
                                return true
                            end
                        end
                    end
                end

                local save_for_ca_inc = (pew_remain() > 0 or not convoke_desync and covenant.night_fae or not useCDs()) or false

                -- fury of elune - single target
                if eclipse_in and astral_def > 20 --and buff.primordialArcanicPulsar.value() < 240
                        and (debuff.adaptiveSwarm.exists(units.dyn45) or not covenant.necrolord.active) and save_for_ca_inc
                then
                    if cast.furyOfElune(units.dyn45) then
                        return true
                    end
                end

                -- starfall - single target, with legendary
                if buff.onethsPerception.exists() and not buff.starfall.exists() then
                    if cast.starfall() then
                        return true
                    end
                end

                -- cancel starlord here
                if buff.starlord.exists() and buff.starlord.remains() < 5 and (buff.eclipse_solar.remains() > 5 or buff.eclipse_lunar.remains() > 5) and power > 90 then
                    br.addonDebug("[Cancel SL]: Buff Remains: " .. tostring(buff.starlord.remain()) .. "Astral Def: " .. tostring(astral_def))
                    cancelBuff(279709)
                end


                --starsurge - first of many
                if cast.able.starsurge(units.dyn45) then
                    if covenant.nightFae.active and convoke_desync and cd.convokeTheSpirits.remains() < 5 and useCDs() then
                        if cast.starsurge(units.dyn45) then
                            br.addonDebug("[SS] Night Fae")
                            return true
                        end
                    end
                end


                --Starfall - ST
                if talent.stellarDrift and not talent.starlord and buff.starfall.remains() < 2
                        and (buff.eclipse_lunar.remains() > 6 and buff.eclipse_lunar.exists()
                        --          and buff.primordialArcanicPulsar.value() < 250 or buff.primordialArcanicPulsar.value() >= 250 and power > 90
                        or debuff.adaptiveSwarm.remains(units.dyn45) > 8) and pew_remain() > 0
                then
                    if cast.starfall() then
                        br.addonDebug("[SF] Stellardrift")
                        return true
                    end
                end

                --sTarsurge wave 2
                if cast.able.starsurge(units.dyn45) then
                    if buff.onethsClearVision.exists() or buff.kindredEmpowermentEnergize.exists() or pewbuff
                            and (buff.ravenousFrenzy.remains() < gcd * math.ceil(power / 30) and buff.ravenousFrenzy.exists()
                            or not buff.ravenousFrenzy.exists() and not cd.ravenousFrenzy.ready() or not covenant.venthyr)
                            or power > 90 and eclipse_in then
                        if cast.starsurge(units.dyn45) then
                            br.addonDebug("[SS] COND1")
                            return true
                        end
                    end
                    if talent.starlord and (buff.starlord.exists() or power > 90) and buff.starlord.stack() < 3
                            and (buff.eclipse_solar.exists() or buff.eclipse_lunar.exists())
                            and buff.primordialArcanicPulsar.value() < 270 and (pew_remain() > 10
                            or not convoke_desync and covenant.nightFae.active) then
                        if cast.starsurge(units.dyn45) then
                            br.addonDebug("[SS] COND2")
                            return true
                        end
                    end
                    --if (buff.primordialArcanicPulsar.value() < 270 or buff.primordialArcanicPulsar.value() < 250 and talent.stellarDrift)                     and buff.eclipse_solar.remains() > 7 and buff.eclipse_solar.exists() and not buff.onethsPerception.exists()
                    --       and
                    if not talent.starlord and pew_remain() > 7 and (cd.kindredSpirits.remains() > 7 or not covenant.kyrian.active) then
                        if cast.starsurge(units.dyn45) then
                            br.addonDebug("[SS] COND3")
                            return true
                        end
                    end
                end
                -- Warrior of Elune
                if useCDs() and isChecked("Warrior Of Elune") and talent.warriorOfElune and not buff.warriorOfElune.exists() then
                    if cast.warriorOfElune() then
                        return true
                    end
                end

                --starfire
                if cast.able.starfire(units.dyn45) and buff.eclipse_lunar.exists() or eclipse_next == "solar"
                        or eclipse_next == "any" or buff.warriorOfElune.exists() and buff.eclipse_lunar.exists()
                        or ((buff.incarnationChoseOfElune.remains() > getCastTime(spell.wrath) or buff.celestialAlignment.remains() > getCastTime(spell.wrath)) and pewbuff) then
                    if cast.starfire(units.dyn45) then
                        return true
                    end
                end
                --wrath fall back
                if cast.able.wrath(units.dyn45) then
                    if cast.wrath(units.dyn45) then
                        return true
                    end
                end
            end
        end
    end -- end dps()

    local function defensive()


        -- Pot/Stoned
        if isChecked("Potion/Healthstone") and php <= getValue("Potion/Healthstone") then
            if inCombat and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
                if canUseItem(5512) then
                    br.addonDebug("Using Healthstone")
                    useItem(5512)
                elseif hasItem(156634) and canUseItem(156634) then
                    br.addonDebug("Using Silas' Vial of Continuous Curing")
                    useItem(156634)
                elseif hasItem(166799) and canUseItem(166799) then
                    br.addonDebug("Using Emerald of Vigor")
                    useItem(166799)
                elseif hasItem(169451) and canUseItem(169451) then
                    br.addonDebug("Using Health Pot")
                    useItem(169451)
                end
            end
        end

        -- Renewal
        if isChecked("Renewal") and talent.renewal and php <= getValue("Renewal") then
            if cast.renewal("player") then
                return
            end
        end
        -- Barkskin
        if isChecked("Barkskin") and inCombat and php <= getValue("Barkskin") then
            if cast.barkskin() then
                return
            end
        end
        -- Swiftmend
        if talent.restorationAffinity and isChecked("Swiftmend") and cast.able.swiftmend()
                and php <= getValue("Swiftmend") and charges.swiftmend.count() >= 1
                and hasHot("player") then
            if cast.swiftmend("player") then
                return true
            end
        end
        -- Regrowth
        if isChecked("Regrowth") and not moving and php <= getValue("Regrowth") then
            if cast.regrowth("player") then
                return true
            end
        end

        --rejuvenation
        if isChecked("Rejuvenation") and php <= getValue("Rejuvenation") and not buff.rejuvenation.exists("player") then
            if cast.rejuvenation("player") then
                return true
            end
        end
        -- Rebirth
        if inCombat and isChecked("Rebirth") and cd.rebirth.remain() <= gcd and not isMoving("player") then
            if getOptionValue("Rebirth") == 1 then
                tanks = getTanksTable()
                for i = 1, #tanks do
                    thisUnit = tanks[i].unit
                    if UnitIsDeadOrGhost(thisUnit) and UnitIsPlayer(thisUnit) then
                        if cast.rebirth(thisUnit, "dead") then
                            return true
                        end
                    end
                end
            elseif inCombat and getOptionValue("Rebirth") == 2 then
                for i = 1, #br.friend do
                    thisUnit = br.friend[i].unit
                    if UnitIsDeadOrGhost(thisUnit) and UnitGroupRolesAssigned(thisUnit) == "HEALER" and UnitIsPlayer(thisUnit) then
                        if cast.rebirth(thisUnit, "dead") then
                            return true
                        end
                    end
                end
            elseif inCombat and getOptionValue("Rebirth") == 3 then
                for i = 1, #br.friend do
                    thisUnit = br.friend[i].unit
                    if UnitIsDeadOrGhost(thisUnit) and (UnitGroupRolesAssigned(thisUnit) == "TANK" or UnitGroupRolesAssigned(thisUnit) == "HEALER") and UnitIsPlayer(thisUnit) then
                        if cast.rebirth(thisUnit, "dead") then
                            return true
                        end
                    end
                end
            elseif inCombat and getOptionValue("Rebirth") == 4 then
                if GetUnitExists("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover", "player") then
                    if cast.rebirth("mouseover", "dead") then
                        return true
                    end
                end
            elseif inCombat and getOptionValue("Rebirth") == 5 then
                for i = 1, #br.friend do
                    thisUnit = br.friend[i].unit
                    if UnitIsDeadOrGhost(thisUnit) and UnitIsPlayer(thisUnit) then
                        if cast.rebirth(thisUnit, "dead") then
                            return true
                        end
                    end
                end
            end
        end

        -- offheal

        local offheal = false
        if getOptionValue("offheal") == 2 then
            offheal = true
        elseif getOptionValue("offheal") == 3 then
            for i = 1, #br.friend do
                thisUnit = br.friend[i].unit
                if UnitIsDeadOrGhost(thisUnit) and UnitGroupRolesAssigned(thisUnit) == "HEALER" and UnitIsPlayer(thisUnit) then
                    offheal = true
                end
            end
        end

        -- Remove Corruption
        if isChecked("Remove Corruption") then
            if getOptionValue("Remove Corruption") == 1 then
                if canDispel("player", spell.removeCorruption) then
                    if cast.removeCorruption("player") then
                        return true
                    end
                end
            elseif getOptionValue("Remove Corruption") == 2 then
                if canDispel("target", spell.removeCorruption) then
                    if cast.removeCorruption("target") then
                        return true
                    end
                end
            elseif getOptionValue("Remove Corruption") == 3 then
                if canDispel("player", spell.removeCorruption) then
                    if cast.removeCorruption("player") then
                        return true
                    end
                elseif canDispel("target", spell.removeCorruption) then
                    if cast.removeCorruption("target") then
                        return true
                    end
                end
            elseif getOptionValue("Remove Corruption") == 4 then
                if canDispel("mouseover", spell.removeCorruption) then
                    if cast.removeCorruption("mouseover") then
                        return true
                    end
                end
            elseif (getOptionValue("Remove Corruption") == 5 or offheal == true) then
                for i = 1, #br.friend do
                    if canDispel(br.friend[i].unit, spell.removeCorruption) then
                        if cast.removeCorruption(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            end
        end
    end

    local function interrupts()
        if useInterrupts() then
            for i = 1, #enemies.yards45 do
                thisUnit = enemies.yards45[i]
                if canInterrupt(thisUnit, getValue("InterruptAt")) then
                    -- Solar Beam
                    if isChecked("Solar Beam") then
                        if cast.solarBeam(thisUnit) then
                            return
                        end
                    end
                    -- Typhoon
                    if isChecked("Typhoon") and talent.typhoon and getDistance(thisUnit) <= 15 then
                        if cast.typhoon() then
                            return
                        end
                    end
                    -- Mighty Bash
                    if isChecked("Mighty Bash") and talent.mightyBash and getDistance(thisUnit) <= 10 then
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
        if isChecked("Freehold - root grenadier") then
            root_UnitList[129758] = "Irontide Grenadier"
        end
        if isChecked("Atal - root Spirit of Gold") then
            root_UnitList[131009] = "Spirit of Gold"
        end

        for i = 1, #enemies.yards45 do
            thisUnit = enemies.yards45[i]

            if isChecked("Auto Soothe") then
                if cast.able.soothe() and canDispel(thisUnit, spell.soothe) then
                    if cast.soothe(thisUnit) then
                        return true
                    end
                end
            end


            --[[
                        --Enchanted emmisary == 155432
                        if isChecked("Punt Enchanted Emissary") then
                            --and inInstance then
                            if GetObjectID(thisUnit) == 155432 and not isCasting(155432, thisUnit) then
                                if #tanks > 0 and getDistance(tank, thisUnit) <= 26 then
                                    br.addonDebug("Punting Emissary - Range from tank: " .. getDistance(tank, thisUnit))
                                    if cast.moonfire(thisUnit) then
                                        return true
                                    end
                                end
                            end
                        end
            ]]
            if isChecked("Freehold - root grenadier") or isChecked("Atal - root Spirit of Gold") or isChecked("All - root Emissary of the Tides") or isChecked("KR - Minions of Zul") then
                --br.addonDebug("Mob: " .. thisUnit .. " Health: " .. getHP(thisUnit))
                if cast.able.massEntanglement() and not isLongTimeCCed(thisUnit) and getHP(thisUnit) > 90 then
                    if (root_UnitList[GetObjectID(thisUnit)] ~= nil and getBuffRemain(thisUnit, 226510) <= 3) then
                        if cast.massEntanglement(thisUnit) then
                            br.addonDebug("Mass Rooting: " .. thisUnit)
                            return true
                        end
                    end
                end
                if cast.able.entanglingRoots() and not isLongTimeCCed(thisUnit) and getHP(thisUnit) > 90 then
                    if (root_UnitList[GetObjectID(thisUnit)] ~= nil and getBuffRemain(thisUnit, 226510) <= 3) then
                        if cast.entanglingRoots(thisUnit) then
                            br.addonDebug("Rooting: " .. thisUnit)
                            return true
                        end
                    end
                end
            end

        end
    end
    local function PreCombat()
        if isValidUnit("target") then
            -- Pre-Pull Timer
            if isChecked("Pre-Pull Timer") and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                if PullTimerRemain() <= getOptionValue("Pre-Pull Timer") then
                    if mode.forms ~= 3 then
                        if not br.player.buff.moonkinForm.exists() and not cast.last.moonkinForm(1) and not isMoving("player") then
                            if cast.moonkinForm() then
                                return true
                            end
                        end
                    end
                    if cast.solarWrath() then
                        return true
                    end
                end
            end
            if isChecked("Auto Engage On Target") then
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
        if isChecked("Freehold - pig") and GetMinimapZoneText() == "Ring of Booty" then
            bossHelper()
        end
    end

    local function travel_form()

        if SpecificToggle("Travel Key") and not GetCurrentKeyBoardFocus() then
            if not travel then
                if cast.travelForm("Player") then
                    return true
                end
            end
            if SpecificToggle("Travel Key") and not GetCurrentKeyBoardFocus()
            then
                return
            end
        end

    end

    local function bear_form()

        if SpecificToggle("Bear Key") and not GetCurrentKeyBoardFocus() then
            if not bear then
                if cast.bearForm("Player") then
                    return true
                end
            end
            if isChecked("Bear Frenzies Regen HP") and talent.guardianAffinity and cast.able.frenziedRegeneration() and php <= getValue("Bear Frenzies Regen HP") then
                if cast.frenziedRegeneration() then
                    br.addonDebug("[BEAR]Regen")
                    return true
                end
            end
            if SpecificToggle("Bear Key") and not GetCurrentKeyBoardFocus()
            then
                return
            end
        end

    end

    local function cat_form()
        if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus() then
            if not cat then
                if cast.catForm("player") then
                    return true
                end
            end

            if isChecked("auto stealth") and not inCombat and cat then
                if not br.player.buff.prowl.exists() then
                    if cast.prowl("Player") then
                        return true
                    end
                end
            end

            if isChecked("auto dash") and not catspeed then
                if cast.tigerDash() then
                    return true
                end
                if cast.dash() then
                    return true
                end
            end

            if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus()
            then
                return
            end
        end
    end

    local function extras()

        --Forms key management, in and out of combat
        if mode.forms == 2 then
            if not moonkin then
                if cast.moonkinForm() then
                    return true
                end

            end
        end

        if isChecked("Auto Innervate") and inCombat and cast.able.innervate() then
            for i = 1, #br.friend do
                if UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" and getDistance(br.friend[i].unit) < 45
                        and not UnitIsDeadOrGhost(br.friend[i].unit) and getLineOfSight(br.friend[i].unit) and not hasBuff(29166, br.friend[i].unit) then
                    if cast.innervate(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end

        if not inCombat then
            --Resurrection

            if getOptionValue("Revive") == 1 then
                if isChecked("Revive") and not inCombat and not isMoving("player") then
                    if UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player") then
                        if cast.revive("target", "dead") then
                            return true
                        end
                    end
                end
            elseif getOptionValue("Revive") == 2 then
                if GetUnitExists("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover", "player") then
                    if cast.revive("mouseover", "dead") then
                        return true
                    end
                end

            end
            -- Wild Growth
            if isChecked("OOC Wild Growth") and not isMoving("player") and php <= getValue("OOC Wild Growth") then
                if cast.wildGrowth() then
                    return true
                end
            end
            -- Regrowth
            if isChecked("OOC Regrowth") and not isMoving("player") and php <= getValue("OOC Regrowth") then
                if cast.regrowth("player") then
                    return true
                end
            end
            -- Shapeshift Form Management
            standingTime = 0
            if DontMoveStartTime then
                standingTime = GetTime() - DontMoveStartTime
            end

            if mode.forms == 1 then
                if isChecked("Standing Time") then
                    if (travel or buff.catForm.exists()) and not buff.prowl.exists() and standingTime > getValue("Standing Time") then
                        if cast.moonkinForm("player") then
                            return true
                        end
                    end
                end

                -- Flight Form
                if not inCombat and canFly() and not swimming and br.fallDist > 90 --[[falling > getOptionValue("Fall Timer")]] and br.player.level >= 58 and not buff.prowl.exists() then
                    if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                        -- CancelShapeshiftForm()
                        RunMacroText("/CancelForm")
                        CastSpellByID(783, "player")
                        return true
                    else
                        CastSpellByID(783, "player")
                        return true
                    end
                end
                -- Aquatic Form
                if (not inCombat --[[or getDistance("target") >= 10--]]) and swimming and not travel and not buff.prowl.exists() and isMoving("player") then
                    if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                        -- CancelShapeshiftForm()
                        RunMacroText("/CancelForm")
                        CastSpellByID(783, "player")
                        return true
                    else
                        CastSpellByID(783, "player")
                        return true
                    end
                end
                -- Travel Form
                if not inCombat and not swimming and br.player.level >= 58 and not buff.prowl.exists() and not catspeed and not travel and not mount and not IsIndoors() and IsMovingTime(1) then
                    -- Print(GetShapeshiftForm())
                    if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                        RunMacroText("/CancelForm")
                        if isChecked("Use Mount Form") and not canFly() then
                            CastSpellByID(210053, "player")
                        else
                            CastSpellByID(783, "player")
                        end
                        return true
                    else
                        if isChecked("Use Mount Form") and not canFly() then
                            CastSpellByID(210053, "player")
                        else
                            CastSpellByID(783, "player")
                        end
                        return true
                    end
                end
                -- Cat Form
                if not cat and not IsMounted() and not flying and IsIndoors() then
                    -- Cat Form when not swimming or flying or stag and not in combat
                    if moving and IsMovingTime(3) and not swimming and not flying and not travel then
                        if cast.catForm("player") then
                            return true
                        end
                    end
                    -- Cat Form - Less Fall Damage
                    if (not canFly() or inCombat or br.player.level < 58) and (not swimming or (not moving and swimming and #enemies.yards5 > 0)) and br.fallDist > 90 then
                        --falling > getOptionValue("Fall Timer") then
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
    if not IsMounted() or mode.rotation == 4 then
        -- br.player.buff.travelForm.exists() or br.player.buff.flightForm.exists())
        if pause() or drinking or mode.rotation == 4 or cast.current.focusedAzeriteBeam() or buff.soulshape.exists() then
            return true
        else

            ---------------------------------
            --- Out Of Combat - Rotations ---
            ---------------------------------````````````````````````````````````````````
            if not inCombat and not UnitBuffID("player", 115834) then
                if mode.forms == 2 then
                    if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus() then
                        cat_form()
                        return true
                    elseif SpecificToggle("Bear Key") and not GetCurrentKeyBoardFocus() then
                        bear_form()
                        return true
                    elseif SpecificToggle("Travel Key") and not GetCurrentKeyBoardFocus() then
                        travel_form()
                        return true
                    end
                end

                if extras() then
                    return true
                end
                if useDefensive() then
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
            if inCombat and not UnitBuffID("player", 115834) then

                if mode.forms == 2 then
                    if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus() then
                        cat_form()
                        return true
                    elseif SpecificToggle("Bear Key") and not GetCurrentKeyBoardFocus() then
                        bear_form()
                        return true
                    elseif SpecificToggle("Travel Key") and not GetCurrentKeyBoardFocus() then
                        travel_form()
                        return true
                    end
                end
                if extras() then
                    return true
                end
                if useInterrupts() then
                    if interrupts() then
                        return true
                    end
                end
                if useDefensive() then
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

tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

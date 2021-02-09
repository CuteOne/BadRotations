local rotationName = "Aura"

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    -- Rotation Button
    RotationModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Automatic Rotation",
            tip = "Swaps between Single and Multiple based on number of enemies in range.",
            highlight = 1,
            icon = br.player.spell.liquidMagmaTotem
        },
        [2] = {mode = "Mult", value = 2, overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 1, icon = br.player.spell.chainLightning},
        [3] = {mode = "Sing", value = 3, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 1, icon = br.player.spell.lightningBolt},
        [4] = {mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.thunderstorm}
    }
    CreateButton("Rotation", 1, 0)
    -- Cooldown Button
    CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.ascendance},
        [2] = {mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.fireElemental},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.earthElemental}
    }
    CreateButton("Cooldown", 2, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.astralShift},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.earthShield}
    }
    CreateButton("Defensive", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.windShear},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.hex}
    }
    CreateButton("Interrupt", 4, 0)
    -- Ghost Wolf Button
    GhostWolfModes = {
        [1] = {mode = "Moving", value = 1, overlay = "Moving Enabled", tip = "Will Ghost Wolf when movement detected", highlight = 1, icon = br.player.spell.ghostWolf},
        [2] = {mode = "Hold", value = 1, overlay = "Hold Enabled", tip = "Will Ghost Wolf when key is held down", highlight = 0, icon = br.player.spell.ghostWolf}
    }
    CreateButton("GhostWolf", 5, 0)
    -- StormKeeper Button
    StormKeeperModes = {
        [1] = {mode = "On", value = 1, overlay = "Storm Keeper Enabled", tip = "Will use Storm Keeper", highlight = 1, icon = br.player.spell.stormKeeper},
        [2] = {mode = "Off", value = 1, overlay = "Storm Keeper Disabled", tip = "Will not use Storm Keeper", highlight = 0, icon = br.player.spell.stormKeeper}
    }
    CreateButton("StormKeeper", 6, 0)
    -- Earth Shock Override Button
    EarthShockModes = {
        [2] = {mode = "On", value = 1, overlay = "ES Override Enabled", tip = "Will only use Earth Shock", highlight = 1, icon = br.player.spell.earthShock},
        [1] = {mode = "Off", value = 1, overlay = "ES Override Disabled", tip = "Will use Earthquake and Earth Shock", highlight = 0, icon = br.player.spell.earthquake}
    }
    CreateButton("EarthShock", 7, 0)
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
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- APL
        br.ui:createDropdownWithout(section, "APL Mode", {"|cff0070deSimC", "|cff0070deAMR"}, 1, "|cff0070deSet APL Mode to use.")
        -- Auto Engage
        br.ui:createCheckbox(section, "Auto Engage On Target", "|cff0070deCheck this to start combat upon clicking a target.", 1)
        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5, "|cff0070deSet to desired time for test in minutes. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
        br.ui:createSpinner(section, "Pre-Pull Timer", 5, 1, 10, 1, "|cff0070deSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        br.ui:createCheckbox(section, "Auto Ghost Wolf", "|cff0070deCheck this to automatically control GW transformation based on toggle bar setting.")
        br.ui:createDropdownWithout(
            section,
            "Ghost Wolf Key",
            br.dropOptions.Toggle,
            6,
            "|cff0070deSet key to hold down for Ghost Wolf(Will break form for instant cast lava burst and flame shock.)"
        )
        br.ui:createDropdownWithout(section, "Force GW Key", br.dropOptions.Toggle, 6, "|cff0070deSet key to hold down for Ghost Wolf(Will not break form until key is released.)")
        -- Purge
        br.ui:createDropdown(section, "Purge", {"|cffFFFF00Selected Target", "|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")
        -- Water Walking
        br.ui:createCheckbox(section, "Water Walking")
        -- Frost Shock
        br.ui:createCheckbox(section, "Frost Shock")
        --
        br.ui:createSpinner(section, "Capacitor Totem - Tank Stuns", 3, 1, 10, 1, "|cff0070deWill use capacitor totem on groups of mobs when in a party.")

        br.ui:createCheckbox(section, "Pig Catcher", "Catch the freehold Pig in the ring of booty")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createCheckbox(section, "Racial", "|cff0070deCheck to use Racials")
        br.ui:createCheckbox(section, "Trinkets", "|cff0070deCheck to use Trinkets when Fire/Storm Elemental is Out, during AoE or during Ascendance")
        br.ui:createCheckbox(section, "Storm Elemental/Fire Elemental", "|cff0070deCheck to use Storm/Fire Elemental")
        br.ui:createCheckbox(section, "Earth Elemental", "|cff0070deCheck to use Earth Elemental")
        br.ui:createCheckbox(section, "Ascendance", "|cff0070deCheck to use Ascendance")
        br.ui:checkSectionState(section)
        -------------------------
        ---  TARGET OPTIONS   ---  -- Define Target Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Targets")
        br.ui:createSpinnerWithout(
            section,
            "Azerite Beam Units",
            3,
            1,
            10,
            1,
            "|cff0070deSet to maximum number of targets to use Azerite Beam in AoE. Min: 1 / Max: 10 / Interval: 1"
        )
        br.ui:createSpinnerWithout(
            section,
            "Maximum FlameShock Targets",
            2,
            1,
            10,
            1,
            "|cff0070deSet to maximum number of targets to use FlameShock in AoE. Min: 1 / Max: 10 / Interval: 1"
        )
        br.ui:createSpinnerWithout(
            section,
            "Maximum LB Targets",
            2,
            1,
            10,
            1,
            "|cff0070deSet to maximum number of targets to use Lava Burst in AoE. Min: 1 / Max: 10 / Interval: 1"
        )
        br.ui:createSpinnerWithout(
            section,
            "Maximum EB Targets",
            2,
            1,
            10,
            1,
            "|cff0070deSet to maximum number of targets to use Elemental Blast in AoE. Min: 1 / Max: 10 / Interval: 1"
        )
        br.ui:createSpinnerWithout(section, "SK Targets", 3, 1, 10, 1, "|cff0070deSet to desired number of targets needed to use Storm Keeper. Min: 1 / Max: 10 / Interval: 1")
        br.ui:createSpinnerWithout(
            section,
            "LMT Targets",
            3,
            1,
            10,
            1,
            "|cff0070deSet to desired number of targets needed to use Liquid Magma Totem. Min: 1 / Max: 10 / Interval: 1"
        )
        br.ui:createSpinnerWithout(
            section,
            "Earthquake Targets",
            3,
            1,
            10,
            1,
            "|cff0070deSet to desired number of targets needed to use Earthquake. Min: 1 / Max: 10 / Interval: 1"
        )
        br.ui:createSpinnerWithout(section, "Lava Beam Targets", 3, 1, 10, 1, "|cff0070deSet to desired number of targets needed to use Lava Beam. Min: 1 / Max: 10 / Interval: 1")
        br.ui:createSpinnerWithout(section, "Meteor Targets", 2, 1, 10, 1, "|cff0070deSet to desired number of targets needed to use Meteor. Min: 1 / Max: 10 / Interval: 1")
        br.ui:createSpinnerWithout(
            section,
            "Earth Shock Maelstrom Dump",
            90,
            1,
            100,
            5,
            "|cff0070deSet to desired value to use Earth Shock as maelstrom dump. Min: 1 / Max: 100 / Interval: 5"
        )
        br.ui:createSpinnerWithout(
            section,
            "Chain Lightning Stormkeeper",
            3,
            1,
            10,
            1,
            "|cff0070deSet to desired number of targets needed to use Chain Lightning during Stormkeeper. Min: 1 / Max: 10 / Interval: 1"
        )
        br.ui:checkSectionState(section)
        ------------------------
        --- ESSENCE  OPTIONS --- -- Define Essence Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Essence")
        br.ui:createCheckbox(section, "Use Essence")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
        br.ui:createSpinner(section, "Pot/Stoned", 60, 0, 100, 5, "|cff0070deHealth Percent to Cast At")
        -- Heirloom Neck
        br.ui:createSpinner(section, "Heirloom Neck", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Gift of The Naaru
        if br.player.race == "Draenei" then
            br.ui:createSpinner(section, "Gift of the Naaru", 50, 0, 100, 5, "|cff0070deHealth Percent to Cast At")
        end
        -- Ancestral Spirit
        br.ui:createDropdown(section, "Ancestral Spirit", {"|cffFFFF00Selected Target", "|cffFF0000Mouseover Target"}, 1, "|ccf0070deTarget to Cast On")
        -- Astral Shift
        br.ui:createSpinner(section, "Astral Shift", 50, 0, 100, 5, "|cff0070deHealth Percent to Cast At")
        -- Cleanse Spirit
        br.ui:createDropdown(section, "Cleanse Spirit", {"|cff00FF00Player Only", "|cffFFFF00Selected Target", "|cffFF0000Mouseover Target"}, 1, "|cff0070deTarget to Cast On")
        -- Earth Shield
        br.ui:createCheckbox(section, "Earth Shield")
        -- Healing Surge
        br.ui:createSpinner(section, "Healing Surge", 80, 0, 100, 5, "|cff0070deHealth Percent to Cast At")
        -- Capacitor Surge Totem
        br.ui:createSpinner(section, "Capacitor Totem - HP", 50, 0, 100, 5, "|cff0070deHealth Percent to Cast At")
        br.ui:createSpinner(section, "Capacitor Totem - AoE", 5, 0, 10, 1, "|cff0070deNumber of Units in 5 Yards to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Wind Shear
        br.ui:createCheckbox(section, "Wind Shear")
        -- Hex
        br.ui:createCheckbox(section, "Hex")
        -- Lightning Surge Totem
        br.ui:createCheckbox(section, "Capacitor Totem")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "|cff0070deCast Percent to Cast At")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
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
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        }
    }
    return optionTable
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    --if br.timer:useTimer("debugElemental", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
    --Print("Running: "..rotationName)
    --------------
    --- Locals ---
    --------------
    local artifact = br.player.artifact
    local buff = br.player.buff
    local cast = br.player.cast
    local combatTime = getCombatTime()
    local cd = br.player.cd
    local charges = br.player.charges
    local deadMouse, hasMouse, playerMouse = UnitIsDeadOrGhost("mouseover"), GetObjectExists("mouseover"), UnitIsPlayer("mouseover")
    local deadtar, playertar = UnitIsDeadOrGhost("target"), UnitIsPlayer("target")
    local debuff = br.player.debuff
    local enemies = br.player.enemies
    local equiped = br.player.equiped
    local essence = br.player.essence
    local falling, swimming, flying, moving = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player") > 0
    local gcd = br.player.gcd
    local gcdMax = br.player.gcdMax
    local hastar = GetObjectExists("target")
    local healPot = getHealthPot()
    local inCombat = br.player.inCombat
    local inInstance = br.player.instance == "party"
    local inRaid = br.player.instance == "raid"
    local level = br.player.level
    local lowestHP = br.friend[1].unit
    local mana = br.player.power.mana.amount()
    local mode = br.player.ui.mode
    local perk = br.player.perk
    local pet = br.player.pet.list
    local php = br.player.health
    local power = br.player.power.maelstrom.amount()
    local pullTimer = br.DBM:getPulltimer()
    local race = br.player.race
    local racial = br.player.getRacial()
    local spell = br.player.spell
    local talent = br.player.talent
    local traits = br.player.traits
    local ttd = getTTD
    local ttm = br.player.timeToMax
    local units = br.player.units

    if leftCombat == nil then
        leftCombat = GetTime()
    end
    if profileStop == nil then
        profileStop = false
    end

    --if gcd > 0.1 then return true end

    enemies.get(5)
    enemies.get(10)
    enemies.get(20) --enemies.yards20
    enemies.get(30) --enemies.yards30 = br.player.enemies(30)
    enemies.get(40) --enemies.yards40
    enemies.get(8, "target") -- enemies.yards8t
    enemies.get(10, "target") -- enemies.yards10t

    --TTD
    local function ttd(unit)
        local ttdSec = getTTD(unit)
        if getOptionCheck("Enhanced Time to Die") then
            return ttdSec
        end
        if ttdSec == -1 then
            return 999
        end
        return ttdSec
    end

    local fireEle = nil
    local earthEle = nil
    local stormEle = nil
    local holdBreak = (buff.ghostWolf.exists() and mode.ghostWolf == 1) or not buff.ghostWolf.exists()

    if talent.primalElementalist then
        if pet ~= nil then
            for k, v in pairs(pet) do
                -- for i = 1, #br.player.pet do
                local thisUnit = pet[k].id or 0
                if thisUnit == 61029 then
                    fireEle = true
                elseif thisUnit == 77942 then
                    stormEle = true
                elseif thisUnit == 61056 then
                    earthEle = true
                end
            end
        end
    end

    local flameShockCount = 0
    for i = 1, #enemies.yards40 do
        local flameShockRemain = getDebuffRemain(enemies.yards40[i], spell.debuffs.flameShock, "player") or 0 -- 194384
        if flameShockRemain > 5.4 then
            flameShockCount = flameShockCount + 1
        end
    end

    --------------------
    --- Action Lists ---
    --------------------
    -- Action List - Extras
    local function actionList_Extra()
        -- Dummy Test
        if isChecked("DPS Testing") then
            if GetObjectExists("target") then
                if getCombatTime() >= (tonumber(getOptionValue("DPS Testing")) * 60) and isDummy() then
                    StopAttack()
                    ClearTarget()
                    Print(tonumber(getOptionValue("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
                    profileStop = true
                end
            end
        end -- End Dummy Test
        -- Water Walking
        if falling > 1.5 and buff.waterWalking.exists() then
            CancelUnitBuffID("player", spell.waterWalking)
        end
        if isChecked("Water Walking") and not inCombat and IsSwimming() and not buff.waterWalking.exists() then
            if cast.waterWalking() then
                br.addonDebug("Casting Waterwalking")
                return true
            end
        end
        -- Healing Surge (OOC)
        if isChecked("Healing Surge") and not isMoving("player") and php <= getOptionValue("Healing Surge") then
            if cast.healingSurge("player") then
                br.addonDebug("Casting Healing Surge")
                return true
            end
        end
        -- Ancestral Spirit
        if isChecked("Ancestral Spirit") and not isMoving("player") then
            if getOptionValue("Ancestral Spirit") == 1 and hastar and playertar and deadtar then
                if cast.ancestralSpirit("target", "dead") then
                    br.addonDebug("Casting Ancestral Spirit")
                    return true
                end
            end
            if getOptionValue("Ancestral Spirit") == 2 and hasMouse and playerMouse and deadMouse then
                if cast.ancestralSpirit("mouseover", "dead") then
                    br.addonDebug("Casting Ancestral Spirit")
                    return true
                end
            end
        end
    end -- End Action List - Extras
    local function ghostWolf()
        -- Ghost Wolf
        if not (IsMounted() or IsFlying()) and isChecked("Auto Ghost Wolf") then
            if mode.ghostWolf == 1 then
                if isMoving("player") and not buff.ghostWolf.exists("player") then
                    if cast.ghostWolf("player") then
                        br.addonDebug("Casting Ghost Wolf")
                    end
                elseif not isMoving("player") and buff.ghostWolf.exists("player") and br.timer:useTimer("Delay", 0.5) then
                    RunMacroText("/cancelAura Ghost Wolf")
                end
            elseif mode.ghostWolf == 2 then
                if not buff.ghostWolf.exists("player") then
                    if SpecificToggle("Ghost Wolf Key") and not GetCurrentKeyBoardFocus() then
                        if cast.ghostWolf("player") then
                            br.addonDebug("Casting Ghost Wolf")
                        end
                    end
                elseif buff.ghostWolf.exists("player") then
                    if SpecificToggle("Ghost Wolf Key") then
                        return
                    elseif not SpecificToggle("Force GW Key") then
                        if br.timer:useTimer("Delay", 0.25) then
                            RunMacroText("/cancelAura Ghost Wolf")
                        end
                    end
                end
            end
        end
    end
    --Action List PreCombat
    local function actionList_PreCombat()
        if isChecked("Pig Catcher") then
            bossHelper()
        end
        prepullOpener = inRaid and isChecked("Pre-pull Opener") and pullTimer <= getOptionValue("Pre-pull Opener")
        -- Totem Mastery
        if prepullOpener then
            if hasItem(166801) and canUseItem(166801) then
                br.addonDebug("Using Sapphire of Brilliance")
                useItem(166801)
            end
            if not isMoving("player") then
                if cast.totemMastery() then
                    br.addonDebug("Casting Totem Mastery")
                    return true
                end
            end
        end
        if isChecked("Auto Engage On Target") then
            if cast.flameShock() then
                br.addonDebug("Casting Flameshock")
                return true
            end
        end
    end
    -- Action List - Defensive
    local function actionList_Defensive()
        -- Purge
        if isChecked("Purge") then
            if getOptionValue("Purge") == 1 then
                if canDispel("target", spell.purge) and GetObjectExists("target") then
                    if cast.purge("target") then
                        br.addonDebug("Casting Purge")
                        return true
                    end
                end
            elseif getOptionValue("Purge") == 2 then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if canDispel(thisUnit, spell.purge) then
                        if cast.purge(thisUnit) then
                            br.addonDebug("Casting Purge")
                            return true
                        end
                    end
                end
            end
        end
        if useDefensive() then
            -- Pot/Stoned
            if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned") and inCombat and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
                if canUseItem(5512) then
                    br.addonDebug("Using Healthstone")
                    useItem(5512)
                elseif canUseItem(healPot) then
                    br.addonDebug("Using Health Pot")
                    useItem(healPot)
                elseif hasItem(166799) and canUseItem(166799) then
                    br.addonDebug("Using Emerald of Vigor")
                    useItem(166799)
                end
            end
            -- Heirloom Neck
            if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                if hasEquiped(122668) then
                    if GetItemCooldown(122668) == 0 then
                        useItem(122668)
                        br.addonDebug("Using Heirloom Neck")
                    end
                end
            end
            -- Gift of the Naaru
            if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and race == "Draenei" then
                if cast.giftOfTheNaaru() then
                    br.addonDebug("Casting Gift of the Naaru")
                    return true
                end
            end
            -- Astral Shift
            if isChecked("Astral Shift") and php <= getOptionValue("Astral Shift") and inCombat then
                if cast.astralShift() then
                    br.addonDebug("Casting Astral Shift")
                    return true
                end
            end
            -- Cleanse Spirit
            if isChecked("Cleanse Spirit") then
                if getOptionValue("Cleanse Spirit") == 1 and canDispel("player", spell.cleanseSpirit) then
                    if cast.cleanseSpirit("player") then
                        br.addonDebug("Casting Cleanse Spirit")
                        return true
                    end
                end
                if getOptionValue("Cleanse Spirit") == 2 and canDispel("target", spell.cleanseSpirit) then
                    if cast.cleanseSpirit("target") then
                        br.addonDebug("Casting Cleanse Spirit")
                        return true
                    end
                end
                if getOptionValue("Cleanse Spirit") == 3 and canDispel("mouseover", spell.cleanseSpirit) then
                    if cast.cleanseSpirit("mouseover") then
                        br.addonDebug("Casting Cleanse Spirit")
                        return true
                    end
                end
            end
            -- Earthen Shield
            if isChecked("Earth Shield") and not buff.earthShield.exists() then
                if cast.earthShield() then
                    br.addonDebug("Casting Earth Shield")
                    return true
                end
            end
            -- Healing Surge
            if
                isChecked("Healing Surge") and not isMoving("player") and
                    ((mana >= 90 and php <= getOptionValue("Healing Surge")) or (php <= getOptionValue("Healing Surge") / 2 and mana > 20))
             then
                if cast.healingSurge("player") then
                    br.addonDebug("Casting Healing Surge")
                    return true
                end
            end
            -- Capacitor Totem
            if isChecked("Capacitor Totem - HP") and php <= getOptionValue("Capacitor Totem - HP") and inCombat and #enemies.yards5 > 0 then
                if cast.capacitorTotem("player", "ground") then
                    br.addonDebug("Casting Capacitor Totem")
                    return true
                end
            end
            if isChecked("Capacitor Totem - AoE") and #enemies.yards5 >= getOptionValue("Capacitor Totem - AoE") and inCombat then
                if createCastFunction("best", false, 1, 8, spell.capacitorTotem, nil, true) then
                    br.addonDebug("Casting Capacitor Totem")
                    return true
                end
            --if cast.capacitorTotem("best",nil,getOptionValue("Capacitor Totem - AoE"),8) then return true end
            end
        end -- End Defensive Toggle
    end -- End Action List - Defensive
    -- Action List - Interrupts
    local function actionList_Interrupt()
        if useInterrupts() then
            for i = 1, #enemies.yards30 do
                thisUnit = enemies.yards30[i]
                if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                    -- Wind Shear
                    if isChecked("Wind Shear") then
                        if cast.windShear(thisUnit) then
                            br.addonDebug("Casting Wind Shear")
                            return true
                        end
                    end
                    -- Hex
                    if isChecked("Hex") then
                        if cast.hex(thisUnit) then
                            br.addonDebug("Casting Hex")
                            return true
                        end
                    end
                    -- Capacitor Totem
                    if isChecked("Capacitor Totem") and cd.windShear.remain() > gcd then
                        if hasThreat(thisUnit) and not isMoving(thisUnit) and ttd(thisUnit) > 7 then
                            if cast.capacitorTotem(thisUnit, "ground") then
                                br.addonDebug("Casting Capacitor Totem")
                                return true
                            end
                        end
                    end
                end
            end
        end -- End useInterrupts check
    end -- End Action List - Interrupts

    -- Action List Simc AoE
    local function actionList_AoE()
        --Storm Keeper
        --actions.aoe=stormkeeper,if=talent.stormkeeper.enabled
        if not isMoving("player") and talent.stormKeeper and #enemies.yards10t >= getValue("SK Targets") and mode.stormKeeper == 1 and holdBreak then
            if cast.stormKeeper() then
                br.addonDebug("Casting Stormkeeper")
                return true
            end
        end
        -- Flame Shock
        --actions.aoe+=/flame_shock,if=spell_targets.chain_lightning<4,target_if=refreshable
        if flameShockCount < getValue("Maximum FlameShock Targets") then
            if not talent.stormElemental or not stormEle or (#enemies.yards40 == 3 and buff.windGust.stack() < 14) then
                if debuff.flameShock.remain("target") < 5.4 then
                    if cast.flameShock("target") then
                        br.addonDebug("Casting Flameshock")
                        return true
                    end
                end
                for i = 1, #enemies.yards40 do
                    if debuff.flameShock.remain(enemies.yards40[i]) < 5.4 then
                        if cast.flameShock(enemies.yards40[i]) then
                            br.addonDebug("Casting Flameshock")
                            return true
                        end
                    end
                end
            end
        end
        -- Ascendance
        --actions.aoe+=/ascendance,if=talent.ascendance.enabled&(talent.storm_elemental.enabled&cooldown.storm_elemental.remains<120&cooldown.storm_elemental.remains>15|!talent.storm_elemental.enabled)
        if
            isChecked("Ascendance") and talent.ascendance and
                ((talent.stormElemental and cd.stormElemental.remain() < 120 and cd.stormElemental.remain() > 15) or not talent.stormElemental) and
                useCDs() and
                holdBreak
         then
            if cast.ascendance() then
                br.addonDebug("Casting Ascendance")
                return true
            end
        end
        -- Liquid Magma Totem
        --actions.aoe+=/liquid_magma_totem,if=talent.liquid_magma_totem.enabled
        if talent.liquidMagmaTotem and useCDs() and #enemies.yards8t >= getValue("LMT Targets") and holdBreak then
            local cc = false
            if getOptionCheck("Don't break CCs") then
                for i = 1, #enemies.yards8t do
                    local thisUnit = #enemies.yards8t[i]
                    if isLongTimeCCed(thisUnit) then
                        cc = true
                        break
                    end
                end
            end
            if cc == false then
                if cast.liquidMagmaTotem("target") then
                    br.addonDebug("Casting Liquid Magma Totem")
                    return true
                end
            end
        end
        -- Earthquake
        --actions.aoe+=/earthquake
        if
            #enemies.yards8t >= getValue("Earthquake Targets") and
                (not talent.masterOfTheElements or buff.stormKeeper.exists() or power >= getOptionValue("Earth Shock Maelstrom Dump") or buff.masterOfTheElements.exists() or
                    #enemies.yards10t > 3) and
                holdBreak
         then
            if mode.earthShock == 1 then
                local cc = false
                if getOptionCheck("Don't break CCs") then
                    for i = 1, #enemies.yards8t do
                        local thisUnit = #enemies.yards8t[i]
                        if isLongTimeCCed(thisUnit) then
                            cc = true
                            break
                        end
                    end
                end
                if cc == false then
                    if createCastFunction("best", false, 1, 8, spell.earthquake, nil, true) then
                        br.addonDebug("Casting Earthquake")
                        return true
                    end
                end
            elseif mode.earthShock == 2 then
                if cast.earthShock() then
                    br.addonDebug("Casting Earthshock")
                    return true
                end
            end
        end
        -- Moving Chain Lightning
        if buff.stormKeeper.exists() and (isMoving("player") or buff.stormKeeper.remains() < 3 * gcdMax * buff.stormKeeper.stack()) and holdBreak then
            local cc = false
            if getOptionCheck("Don't break CCs") then
                for i = 1, #enemies.yards10t do
                    local thisUnit = #enemies.yards8t[i]
                    if isLongTimeCCed(thisUnit) then
                        cc = true
                        break
                    end
                end
            end
            if cc == false then
                if cast.chainLightning() then
                    br.addonDebug("Casting Chain Lightning")
                    return true
                end
            end
        end
        -- Lava Burst (Instant)
        --actions.aoe+=/lava_burst,if=(buff.lava_surge.up|buff.ascendance.up)&spell_targets.chain_lightning<4
        if cd.lavaBurst.remain() <= gcd and buff.lavaSurge.exists() and #enemies.yards10t <= getValue("Maximum LB Targets") and (not talent.stormElemental or not stormEle) then
            if debuff.flameShock.exists("target") then
                if UnitCastingInfo("player") then
                    SpellStopCasting()
                end
                if cast.lavaBurst() then
                    br.addonDebug("Casting Lava Burst")
                    return true
                end
            else
                for i = 1, #enemies.yards10t do
                    local thisUnit = enemies.yards10t[i]
                    if debuff.flameShock.exists(thisUnit) then
                        if UnitCastingInfo("player") then
                            SpellStopCasting()
                        end
                        if cast.lavaBurst(thisUnit) then
                            br.addonDebug("Casting Lava Burst")
                            return true
                        end
                    end
                end
            end
        end
        -- actions.aoe+=/icefury,if=spell_targets.chain_lightning<4&!buff.ascendance.up
        if not isMoving("player") and talent.iceFury and #enemies.yards10t < 4 and not buff.ascendance.exists() and holdBreak then
            if cast.iceFury() then
                br.addonDebug("Casting Ice Fury")
                return true
            end
        end
        -- actions.aoe+=/frost_shock,if=spell_targets.chain_lightning<4&buff.icefury.up&!buff.ascendance.up
        if talent.iceFury and #enemies.yards10t < 4 and buff.iceFury.exists() and not buff.ascendance.exists() and isChecked("Frost Shock") and holdBreak then
            if cast.frostShock() then
                br.addonDebug("Casting Frostshock")
                return true
            end
        end
        -- Elemental Blast
        --actions.aoe+=/elemental_blast,if=talent.elemental_blast.enabled&spell_targets.chain_lightning<4
        if not isMoving("player") and talent.elementalBlast and #enemies.yards10t <= getValue("Maximum EB Targets") and (not talent.stormElemental or not stormEle) and holdBreak then
            if cast.elementalBlast() then
                br.addonDebug("Casting Elemental Blast")
                return true
            end
        end
        -- Lava Beam
        --actions.aoe+=/lava_beam,if=talent.ascendance.enabled
        if not isMoving("player") and buff.ascendance.exists() and #enemies.yards10t >= getValue("Lava Beam Targets") and holdBreak then
            local cc = false
            if getOptionCheck("Don't break CCs") then
                for i = 1, #enemies.yards10t do
                    local thisUnit = #enemies.yards10t[i]
                    if isLongTimeCCed(thisUnit) then
                        cc = true
                        break
                    end
                end
            end
            if cc == false then
                if cast.lavaBeam() then
                    br.addonDebug("Casting Lava Beam")
                    return true
                end
            end
        end
        -- Chain Lightning
        --actions.aoe+=/chain_lightning
        if not isMoving("player") and #enemies.yards10t > 2 and holdBreak then
            local cc = false
            if getOptionCheck("Don't break CCs") then
                for i = 1, #enemies.yards10t do
                    local thisUnit = #enemies.yards10t[i]
                    if isLongTimeCCed(thisUnit) then
                        cc = true
                        break
                    end
                end
            end
            if cc == false then
                if cast.chainLightning() then
                    br.addonDebug("Casting Chain Lightning")
                    return true
                end
            end
        end
        -- Lava Burst (Moving)
        --actions.aoe+=/lava_burst,moving=1,if=talent.ascendance.enabled
        if buff.lavaSurge.exists() and isMoving("player") then
            if debuff.flameShock.exists("target") then
                if cast.lavaBurst() then
                    br.addonDebug("Casting Lava Burst")
                    return true
                end
            else
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.flameShock.exists(thisUnit) then
                        if cast.lavaBurst(thisUnit) then
                            br.addonDebug("Casting Lava Burst")
                            return true
                        end
                    end
                end
            end
        end
        -- Flame Shock (Moving)
        --actions.aoe+=/flame_shock,moving=1,target_if=refreshable
        if isMoving("player") then
            for i = 1, #enemies.yards40 do
                if debuff.flameShock.remain(enemies.yards40[i]) < 5.4 or not debuff.flameShock.exists(enemies.yards40[i]) then
                    if cast.flameShock(enemies.yards40[i]) then
                        br.addonDebug("Casting Flameshock")
                        return true
                    end
                end
            end
        end
        -- Frost Shock (Moving)
        --actions.aoe+=/frost_shock,moving=1
        if isMoving("player") and isChecked("Frost Shock") and holdBreak then
            if cast.frostShock() then
                br.addonDebug("Casting Frostshock")
                return true
            end
        end
    end

    -- Action List Simc ST
    local function actionList_ST()
        --Flame Shock
        --actions.single_target=(|talent.storm_elemental.enabled&cooldown.storm_elemental.remains<2*gcd|dot.flame_shock.remains<=gcd|talent.ascendance.enabled&dot.flame_shock.remains<(cooldown.ascendance.remains+buff.ascendance.duration)&cooldown.ascendance.remains<4&(!talent.storm_elemental.enabled|talent.storm_elemental.enabled&cooldown.storm_elemental.remains<120))&buff.wind_gust.stack<14&!buff.surge_of_power.up
        if flameShockCount < #enemies.yards40 then
            for i = 1, #enemies.yards40 do
                if
                    ((talent.stormElemental and cd.stormElemental.remains() < 2 * gcd) or (debuff.flameShock.remains(enemies.yards40[i]) <= 5.4) or
                        (talent.ascendance and debuff.flameShock.remains(enemies.yards40[i]) < (cd.ascendance.remains() + buff.ascendance.duration()) and
                            cd.ascendance.remains() < 4 and
                            (not talent.stormElemental or not stormEle))) and
                        buff.windGust.stack() < 14 and
                        not buff.surgeOfPower.exists()
                 then
                    if cast.flameShock(enemies.yards40[i]) then
                        br.addonDebug("Casting Flameshock")
                        return true
                    end
                end
            end
        end
        --Ascendance
        --actions.single_target+=/ascendance,if=talent.ascendance.enabled&(time>=60|buff.bloodlust.up)&cooldown.lava_burst.remains>0&!talent.storm_elemental.enabled
        if
            isChecked("Ascendance") and talent.ascendance and useCDs() and cd.lavaBurst.remain() > 0 and (not talent.stormElemental or not stormEle) and not buff.iceFury.exists() and
                holdBreak
         then
            if cast.ascendance() then
                br.addonDebug("Casting Ascendance")
                return true
            end
        end
        -- Elemental Blast
        --# Don't use Elemental Blast if you could cast a Master of the Elements empowered Earth Shock instead.
        --actions.single_target+=/elemental_blast,if=talent.elemental_blast.enabled&(talent.master_of_the_elements.enabled&buff.master_of_the_elements.up&maelstrom<60|!talent.master_of_the_elements.enabled)
        --&(!(cooldown.storm_elemental.remains>120&talent.storm_elemental.enabled)|azerite.natural_harmony.rank=3&buff.wind_gust.stack<14)
        if
            not isMoving("player") and talent.elementalBlast and
                ((talent.masterOfTheElements and buff.masterOfTheElements.exists() and power < 60) or not talent.masterOfTheElements) and
                (not talent.stormElemental or not stormEle or (traits.naturalHarmony.rank == 3 and buff.windGust.stack() < 14)) and
                holdBreak
         then
            if cast.elementalBlast() then
                br.addonDebug("Casting Elemental Blast")
                return true
            end
        end
        --Storm Keeper
        --# Keep SK for large or soon add waves.
        --actions.single_target+=/stormkeeper,if=talent.stormkeeper.enabled&(raid_event.adds.count<3|raid_event.adds.in>50)
        if
            not isMoving("player") and useCDs() and talent.stormKeeper and (not talent.surgeOfPower or buff.surgeOfPower.exists() or power >= 44) and mode.stormKeeper == 1 and
                holdBreak
         then
            if cast.stormKeeper() then
                br.addonDebug("Casting Stormkeeper")
                return true
            end
        end
        -- Liquid Magma Totem
        --actions.single_target+=/liquid_magma_totem,if=talent.liquid_magma_totem.enabled&(raid_event.adds.count<3|raid_event.adds.in>50)
        if useCDs() and #enemies.yards8t >= getValue("LMT Targets") and talent.liquidMagmaTotem and holdBreak then
            local cc = false
            if getOptionCheck("Don't break CCs") then
                for i = 1, #enemies.yards8t do
                    local thisUnit = #enemies.yards8t[i]
                    if isLongTimeCCed(thisUnit) then
                        cc = true
                        break
                    end
                end
            end
            if cc == false then
                if cast.liquidMagmaTotem() then
                    br.addonDebug("Casting Liquid Magma Totem")
                    return true
                end
            end
        end
        --Echoing Shock
        if talent.echoingShock then
            if power >= 60 and cast.able.earthShock and cast.able.echoingShock then
                if cast.echoingShock() then
                    if buff.echoingShock.exists() and castable.able.earthShock() then
                        if cast.earthShock() then
                            return true
                        end
                    end
                end
            elseif talent.stormKeeper and #enemies.yards10t >= getOptionValue("Chain Lightning Stormkeeper") and cast.able.echoingShock then
                if cast.echoingShock() then
                    if buff.echoingShock.exists() then
                        if cast.chainLightning() then
                            return true
                        end
                    end
                end
            elseif power <= 59 and cast.able.lavaBurst then
                if cast.echoingShock() then
                    if buff.echoingShock.exists() then
                        if cast.lavaBurst() then
                            return true
                        end
                    end
                end
            end
        end
        -- Lightning Bolt
        --actions.single_target+=/lightning_bolt,if=buff.stormkeeper.up&spell_targets.chain_lightning<2&(buff.master_of_the_elements.up&!talent.surge_of_power.enabled|buff.surge_of_power.up)
        if
            buff.stormKeeper.exists() and
                (isMoving("player") or (#enemies.yards10t <= 2 and ((buff.masterOfTheElements.exists() and not talent.surgeOfPower) or buff.surgeOfPower.exists()))) and
                holdBreak
         then
            if cast.lightningBolt() then
                br.addonDebug("Casting Lightning Bolt")
                return true
            end
        end
        -- Earthquake
        --actions.single_target+=/earthquake,if=active_enemies>1&spell_targets.chain_lightning>1&!talent.exposed_elements.enabled
        --&(!talent.surge_of_power.enabled|!dot.flame_shock.refreshable|cooldown.storm_elemental.remains>120)&(!talent.master_of_the_elements.enabled|buff.master_of_the_elements.up|maelstrom>=92)
        if
            #enemies.yards8t >= getValue("Earthquake Targets") and
                (not talent.surgeOfPower or (not debuff.flameShock.exists() or debuff.flameShock.remain() < 5.4) or
                    (talent.stormElemental and stormEle and
                        (not talent.masterOfTheElements or buff.masterOfTheElements.exists() or power >= getOptionValue("Earth Shock Maelstrom Dump")))) and
                holdBreak
         then
            if mode.earthShock == 1 then
                local cc = false
                if getOptionCheck("Don't break CCs") then
                    for i = 1, #enemies.yards8t do
                        local thisUnit = #enemies.yards8t[i]
                        if isLongTimeCCed(thisUnit) then
                            cc = true
                            break
                        end
                    end
                end
                if cc == false then
                    if createCastFunction("best", false, 1, 8, spell.earthquake, nil, true) then
                        br.addonDebug("Casting Earthquake")
                        return true
                    end
                end
            elseif mode.earthShock == 2 then
                if cast.earthShock() then
                    br.addonDebug("Casting Earthshock")
                    return true
                end
            end
        end
        -- Earth Shock
        --actions.single_target+=/earth_shock,if=!buff.surge_of_power.up&talent.master_of_the_elements.enabled
        --&(buff.master_of_the_elements.up|maelstrom>=92+30*talent.call_the_thunder.enabled|buff.stormkeeper.up&active_enemies<2)|!talent.master_of_the_elements.enabled
        --&(buff.stormkeeper.up|maelstrom>=90+30*talent.call_the_thunder.enabled|!(cooldown.storm_elemental.remains>120&talent.storm_elemental.enabled)
        if
            not buff.surgeOfPower.exists() and (talent.masterOfTheElements and buff.masterOfTheElements.exists() or buff.stormKeeper.exists()) or
                ((not talent.masterOfTheElements and buff.stormKeeper.exists()) or power >= getOptionValue("Earth Shock Maelstrom Dump")) or
                (talent.stormElemental and stormEle) and holdBreak
         then
            if cast.earthShock() then
                br.addonDebug("Casting Earthshock")
                return true
            end
        end
        -- Earth Shock
        --actions.single_target+=/earth_shock,if=talent.surge_of_power.enabled&!buff.surge_of_power.up&cooldown.lava_burst.remains<=gcd&(!talent.storm_elemental.enabled&!(cooldown.fire_elemental.remains>120)|talent.storm_elemental.enabled&!(cooldown.storm_elemental.remains>120))
        if
            talent.surgeOfPower and not buff.surgeOfPower.exists() and cd.lavaBurst.remain() <= gcdMax and
                ((not talent.stormElemental and fireEle) or (talent.stormElemental and stormEle)) and
                holdBreak
         then
            if cast.earthShock() then
                br.addonDebug("Casting Earthshock")
                return true
            end
        end
        -- Lightning Bolt
        --actions.single_target+=/lightning_bolt,if=cooldown.storm_elemental.remains>120&talent.storm_elemental.enabled
        if talent.stormElemental and stormEle and holdBreak then
            if cast.lightningBolt() then
                br.addonDebug("Casting Lightning Bolt")
                return true
            end
        end
        --# Cast Lightning Bolt regardless of the previous condition if you'd lose a Stormkeeper stack or have Stormkeeper and Master of the Elements active.
        -- actions.single_target+=/lightning_bolt,if=(buff.stormkeeper.remains<1.1*gcd*buff.stormkeeper.stack|buff.stormkeeper.up&buff.master_of_the_elements.up)
        if ((buff.stormKeeper.remains() < 1.1 * gcdMax * buff.stormKeeper.stack()) or buff.stormKeeper.exists() and buff.masterOfTheElements.exists()) then
            if cast.lightningBolt() then
                br.addonDebug("Casting Lightning Bolt")
                return true
            end
        end
        -- Frost Shock
        --actions.single_target+=/frost_shock,if=talent.icefury.enabled&talent.master_of_the_elements.enabled&buff.icefury.up&buff.master_of_the_elements.up
        if talent.iceFury and talent.masterOfTheElements and buff.iceFury.exists() and buff.masterOfTheElements.exists() and isChecked("Frost Shock") then
            if cast.frostShock() then
                br.addonDebug("Casting Frostshock")
                return true
            end
        end
        --Lava Burst
        --actions.single_target+=/lava_burst,if=cooldown_react|buff.ascendance.up
        if buff.ascendance.exists() and not stormEle and holdBreak then
            if debuff.flameShock.remain("target") > getCastTime(spell.lavaBurst) then
                if cast.lavaBurst() then
                    br.addonDebug("Casting Lava Burst")
                    return true
                end
            else
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.flameShock.remain(thisUnit) > getCastTime(spell.lavaBurst) then
                        if cast.lavaBurst(thisUnit) then
                            br.addonDebug("Casting Lava Burst")
                            return true
                        end
                    end
                end
            end
        end
        -- Flame Shock (Surge of Power)
        --actions.single_target+=/flame_shock,target_if=refreshable&active_enemies>1&buff.surge_of_power.up
        if flameShockCount < #enemies.yards40 and #enemies.yards40 <= 2 then
            for i = 1, #enemies.yards40 do
                if talent.surgeOfPower and debuff.flameShock.remain(enemies.yards40[i]) < 5.4 and #enemies.yards40 > 1 and buff.surgeOfPower.exists() then
                    if cast.flameShock(enemies.yards40[i]) then
                        br.addonDebug("Casting Flameshock")
                        return true
                    end
                end
            end
        end
        -- Lightning Bolt (Surge of Power)
        if talent.surgeOfPower and buff.surgeOfPower.exists() and holdBreak then
            if cast.lightningBolt() then
                br.addonDebug("Casting Lightning Bolt")
                return true
            end
        end
        -- actions.single_target+=/lava_burst,if=cooldown_react&!talent.master_of_the_elements.enabled
        if cd.lavaBurst.remain() <= gcdMax and not talent.masterOfTheElements and not stormEle and holdBreak then
            if debuff.flameShock.remain("target") > getCastTime(spell.lavaBurst) then
                if cast.lavaBurst() then
                    br.addonDebug("Casting Lava Burst")
                    return true
                end
            else
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.flameShock.remain(thisUnit) > getCastTime(spell.lavaBurst) then
                        if cast.lavaBurst(thisUnit) then
                            br.addonDebug("Casting Lava Burst")
                            return true
                        end
                    end
                end
            end
        end
        --# Slightly game Icefury buff to hopefully buff some empowered Frost Shocks with Master of the Elements.
        --actions.single_target+=/icefury,if=talent.icefury.enabled&!(maelstrom>75&cooldown.lava_burst.remains<=0)&(!talent.storm_elemental.enabled|cooldown.storm_elemental.remains<120)
        if not isMoving("player") and talent.iceFury and (power <= 75 and cd.lavaBurst.remains() > 0) and not stormEle then
            if cast.iceFury() then
                br.addonDebug("Casting Ice Fury")
                return true
            end
        end
        -- actions.single_target+=/lava_burst,if=cooldown_react&charges>talent.echo_of_the_elements.enabled
        if cd.lavaBurst.remains() <= gcdMax and charges.lavaBurst.count() > 1 then
            if UnitCastingInfo("player") then
                SpellStopCasting()
            end
            if cast.lavaBurst() then
                br.addonDebug("Casting Lava Burst")
                return true
            end
        end
        --# Slightly delay using Icefury empowered Frost Shocks to empower them with Master of the Elements too.
        --actions.single_target+=/frost_shock,if=talent.icefury.enabled&buff.icefury.up&buff.icefury.remains<1.1*gcd*buff.icefury.stack
        if talent.masterOfTheElements and talent.iceFury and buff.iceFury.exists() and (buff.iceFury.remains() < 1.5 * gcdMax * buff.iceFury.stack()) and isChecked("Frost Shock") then
            if cast.frostShock() then
                br.addonDebug("Casting Frostshock")
                return true
            end
        end
        -- actions.single_target+=/lava_burst,if=cooldown_react
        if cd.lavaBurst.remain() <= gcdMax and not stormEle and holdBreak then
            if debuff.flameShock.remain("target") > getCastTime(spell.lavaBurst) then
                if cast.lavaBurst() then
                    br.addonDebug("Casting Lava Burst")
                    return true
                end
            else
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.flameShock.remain(thisUnit) > getCastTime(spell.lavaBurst) then
                        if cast.lavaBurst(thisUnit) then
                            br.addonDebug("Casting Lava Burst")
                            return true
                        end
                    end
                end
            end
        end
        --Flame Shock (Refresh)
        --actions.single_target+=/flame_shock,target_if=refreshable
        if flameShockCount < #enemies.yards40 and #enemies.yards40 <= 2 and not buff.surgeOfPower.exists() then
            for i = 1, #enemies.yards40 do
                if debuff.flameShock.remain(enemies.yards40[i]) < 5.4 and ((talent.surgeOfPower and not buff.surgeOfPower.exists()) or not talent.surgeOfPower) then
                    if cast.flameShock(enemies.yards40[i]) then
                        br.addonDebug("Casting Flameshock")
                        return true
                    end
                end
            end
        end
        -- Totem Mastery
        --actions.single_target+=/totem_mastery,if=talent.totem_mastery.enabled&(buff.resonance_totem.remains<6|(buff.resonance_totem.remains<(buff.ascendance.duration+cooldown.ascendance.remains)&cooldown.ascendance.remains<15))
        if
            talent.totemMastery and not isMoving("player") and not cast.last.totemMastery(1) and
                (not buff.resonanceTotem.exists() or buff.resonanceTotem.remain() < 6 or
                    (buff.resonanceTotem.remain() < (buff.ascendance.duration() + cd.ascendance.remain()) and cd.ascendance.remain() < 15)) and
                holdBreak
         then
            if cast.totemMastery() then
                br.addonDebug("Casting Totem Mastery")
                return true
            end
        end
        -- Frost Shock
        --actions.single_target+=/frost_shock,if=talent.icefury.enabled&buff.icefury.up&(buff.icefury.remains<gcd*4*buff.icefury.stack|buff.stormkeeper.up|!talent.master_of_the_elements.enabled)
        if
            talent.iceFury and buff.iceFury.exists() and
                ((buff.iceFury.remains() < 4 * gcdMax * buff.iceFury.stack()) or buff.stormKeeper.exists() or not talent.masterOfTheElements) and
                isChecked("Frost Shock") and
                holdBreak
         then
            if cast.frostShock() then
                br.addonDebug("Casting Frostshock")
                return true
            end
        end
        -- actions.single_target+=/chain_lightning,if=buff.tectonic_thunder.up&!buff.stormkeeper.up&spell_targets.chain_lightning>1
        if traits.tectonicThunder.active and buff.tectonicThunder.exists() and not buff.stormKeeper.exists() and #enemies.yards10t > 0 then
            if cast.chainLightning() then
                br.addonDebug("Casting Chain Lightning")
                return true
            end
        end
        -- Lightning Bolt
        --actions.single_target+=/lightning_bolt
        if cast.lightningBolt() and holdBreak then
            return true
        end
        -- Moving Flame Shock
        --actions.single_target+=/flame_shock,moving=1,target_if=refreshable
        if flameShockCount < #enemies.yards40 and #enemies.yards40 <= 2 and isMoving("player") then
            for i = 1, #enemies.yards40 do
                if debuff.flameShock.remain(enemies.yards40[i]) < 5.4 then
                    if cast.flameShock(enemies.yards40[i]) then
                        br.addonDebug("Casting Flameshock")
                        return true
                    end
                end
            end
        end
        -- Frost Shock
        --# Frost Shock is our movement filler.
        --actions.single_target+=/frost_shock,moving=1
        if isMoving("player") and isChecked("Frost Shock") and holdBreak then
            if cast.frostShock() then
                br.addonDebug("Casting Frostshock")
                return true
            end
        end
    end
    -- Action List AMR()
    local function actionList_AMR()
        local fireEleTime = fireEleTime or nil
        local stormEleTime = stormEleTime or nil
        -- Use Potion(To do)
        -- Racial Buffs
        if (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") and isChecked("Racial") and useCDs() then
            if race == "LightforgedDraenei" then
                if cast.racial("target", "ground") then
                    br.addonDebug("Casting Racial")
                    return true
                end
            else
                if cast.racial("player") then
                    br.addonDebug("Casting Racial")
                    return true
                end
            end
        end
        --Trinkets
        if isChecked("Trinkets") and useCDs() and (buff.ascendance.exists("player") or #enemies.yards10t >= 3 or cast.last.fireElemental() or cast.last.stormElemental()) then
            if canTrinket(13) then
                useItem(13)
                br.addonDebug("Using Trinket 1")
            end
            if canTrinket(14) then
                useItem(14)
                br.addonDebug("Using Trinket 2")
            end
        end
        -- Storm Elemental
        if isChecked("Storm Elemental/Fire Elemental") and useCDs() and talent.stormElemental and holdBreak then
            if cast.stormElemental() then
                stormEleTime = GetTime()
                br.addonDebug("Casting Storm Elemental")
                return true
            end
        end
        -- Fire Elemental
        if isChecked("Storm Elemental/Fire Elemental") and useCDs() and holdBreak then
            if cast.fireElemental() then
                fireEleTime = GetTime()
                br.addonDebug("Casting Fire Elemental")
                return true
            end
        end
        --Earth Elemental
        if not talent.primalElementalist then
            if isChecked("Earth Elemental") and useCDs() and holdBreak then
                if cast.earthElemental() then
                    br.addonDebug("Casting Earth Elemental")
                    return true
                end
            end
        else
            if
                useCDs() and isChecked("Earth Elemental") and
                    ((talent.stormElemental and (stormEleTime ~= nil or (GetTime() - stormEleTime >= 35)) or not talent.stormElemental) and
                        (fireEleTime ~= nil or (GetTime() - fireEleTime >= 35)) and
                        (cd.fireElemental.remain() > 60 and (not talent.stormElemental or (talent.stormElemental and cd.stormElemental.remain() > 60)))) and
                    holdBreak
             then
                if cast.earthElemental() then
                    br.addonDebug("Casting Earth Elemental")
                    return true
                end
            end
        end
        -- Flame Shock
        if debuff.flameShock.remain("target") < 2 then
            if cast.flameShock("target") then
                br.addonDebug("Casting Flameshock")
                return true
            end
        end
        -- Totem Mastery
        if buff.emberTotem.remain() < 0.3 * buff.emberTotem.duration() and not isMoving("player") and holdBreak then
            if cast.totemMastery() then
                br.addonDebug("Casting Totem Mastery")
                return true
            end
        end
        -- Earthquake
        if #enemies.yards8t >= getValue("Earthquake Targets") and holdBreak then
            if mode.earthShock == 1 then
                local cc = false
                if getOptionCheck("Don't break CCs") then
                    for i = 1, #enemies.yards8t do
                        local thisUnit = #enemies.yards8t[i]
                        if isLongTimeCCed(thisUnit) then
                            cc = true
                            break
                        end
                    end
                end
                if cc == false then
                    if createCastFunction("best", false, 1, 8, spell.earthquake, nil, true) then
                        br.addonDebug("Casting Earthquake")
                        return true
                    end
                end
            elseif mode.earthShock == 2 then
                if cast.earthShock() then
                    br.addonDebug("Casting Earthshock")
                    return true
                end
            end
        end
        -- Earth Shock
        if (not talent.masterOfTheElements or buff.masterOfTheElements.exists()) and holdBreak then
            if cast.earthShock() then
                br.addonDebug("Casting Earthshock")
                return true
            end
        end
        -- Liquid Magma Totem
        if useCDs() and #enemies.yards8t >= getValue("LMT Targets") and holdBreak then
            local cc = false
            if getOptionCheck("Don't break CCs") then
                for i = 1, #enemies.yards8t do
                    local thisUnit = #enemies.yards8t[i]
                    if isLongTimeCCed(thisUnit) then
                        cc = true
                        break
                    end
                end
            end
            if cc == false then
                if cast.liquidMagmaTotem("target") then
                    br.addonDebug("Casting Liquid Magma Totem")
                    return true
                end
            end
        end
        -- Stormkeeper
        if useCDs() and (#enemies.yards8t >= getValue("SK Targets") or #enemies.yards8t == 0) and talent.stormKeeper and mode.stormKeeper == 1 and holdBreak then
            if cast.stormKeeper() then
                br.addonDebug("Casting Stormkeeper")
                return true
            end
        end
        -- Elemental Blast
        if talent.elementalBlast and holdBreak then
            if cast.elementalBlast() then
                br.addonDebug("Casting Elemental Blast")
                return true
            end
        end
        -- Lava Beam (3+ Targets)
        if #enemies.yards10t >= getValue("Lava Beam Targets") and buff.ascendance.exists() and holdBreak then
            local cc = false
            if getOptionCheck("Don't break CCs") then
                for i = 1, #enemies.yards10t do
                    local thisUnit = #enemies.yards10t[i]
                    if isLongTimeCCed(thisUnit) then
                        cc = true
                        break
                    end
                end
            end
            if cc == false then
                if cast.lavaBeam() then
                    br.addonDebug("Casting Lava Beam")
                    return true
                end
            end
        end
        if buff.surgeOfPower.exists() and holdBreak then
            if cast.lightningBolt() then
                br.addonDebug("Casting Lightning Bolt")
                return true
            end
        end
        -- Chain Lightning (3+ Targets)
        if #enemies.yards10t >= 3 and not buff.ascendance.exists() and holdBreak then
            local cc = false
            if getOptionCheck("Don't break CCs") then
                for i = 1, #enemies.yards10t do
                    local thisUnit = #enemies.yards10t[i]
                    if isLongTimeCCed(thisUnit) then
                        cc = true
                        break
                    end
                end
            end
            if cc == false then
                if cast.chainLightning() then
                    br.addonDebug("Casting Chain Lightning")
                    return true
                end
            end
        end
        -- Lava Burst
        if debuff.flameShock.remain("target") > getCastTime(spell.lavaBurst) and holdBreak then
            if cast.lavaBurst() then
                br.addonDebug("Casting Lava Burst")
                return true
            end
        end
        -- Ice Fury
        if talent.iceFury and holdBreak then
            if cast.iceFury() then
                br.addonDebug("Casting Ice Fury")
                return true
            end
        end
        -- Frost Shock
        if buff.iceFury.exists() and isChecked("Frost Shock") and holdBreak then
            if cast.frostShock() then
                br.addonDebug("Casting Frostshock")
                return true
            end
        end
        -- Flame Shock (Dot Refresh)
        if debuff.flameShock.remain("target") < 5.4 then
            if cast.flameShock() then
                br.addonDebug("Casting Flameshock")
                return true
            end
        end
        -- Ascendance
        if isChecked("Ascendance") and useCDs() and cd.lavaBurst.remain() > 0 and holdBreak then
            if cast.ascendance() then
                br.addonDebug("Casting Ascendance")
                return true
            end
        end
        -- Chain Lightning
        if #enemies.yards10t > 1 and not buff.ascendance.exists() and holdBreak then
            local cc = false
            if getOptionCheck("Don't break CCs") then
                for i = 1, #enemies.yards10t do
                    local thisUnit = #enemies.yards10t[i]
                    if isLongTimeCCed(thisUnit) then
                        cc = true
                        break
                    end
                end
            end
            if cc == false then
                if cast.chainLightning() then
                    br.addonDebug("Casting Chain Lightning")
                    return true
                end
            end
        end
        -- Lightning Bolt
        if holdBreak then
            if cast.lightningBolt() then
                br.addonDebug("Casting Lightning Bolt")
                return true
            end
        end
        -- Frost Shock (Moving)
        if isMoving("player") and isChecked("Frost Shock") and holdBreak then
            if cast.frostShock() then
                br.addonDebug("Casting Frostshock")
                return true
            end
        end
    end
    --ELEMENTALS
    local eyeActive = nil
    local function actionList_Elementals()
        if talent.primalElementalist then
            if pet ~= nil then
                for k, v in pairs(pet) do
                    -- for i = 1, #br.player.pet do
                    local thisUnit = pet[k].id or 0
                    if fireEle then
                        --print("Fire Elemental Detected")
                        if #enemies.yards8t >= getValue("Meteor Targets") then
                            --if cast.meteor("pettarget") then end
                            CastSpellByName(GetSpellInfo(spell.meteor))
                        --br.addonDebug("Casting Meteor (Pet)")
                        end
                        if not cd.immolate.exists() then
                            CastSpellByName(GetSpellInfo(spell.immolate))
                        --br.addonDebug("Casting Immolate (Pet)")
                        end
                    elseif stormEle then
                        if select(2, GetSpellCooldown(157348)) ~= 0 then
                            if eyeActive == nil or GetTime() - eyeActive > 8 then
                                --print("Storm Elemental Detected")
                                if #enemies.yards8t >= 1 then
                                    eyeActive = GetTime()
                                    CastSpellByName(GetSpellInfo(spell.eyeOfTheStorm))
                                --br.addonDebug("Casting Eye Of The Storm (Pet)")
                                end
                            end
                        end
                    elseif earthEle then
                        --print("Earth Elemental Detected")
                        if not buff.hardenSkin.exists() then
                            CastSpellByName(GetSpellInfo(spell.hardenSkin))
                        --br.addonDebug("Casting Harden Skin (Pet)")
                        end
                        CastSpellByName(GetSpellInfo(spell.pulverize))
                    --br.addonDebug("Casting Pulverize (Pet)")
                    end
                end
            end
        end
    end

    -----------------
    --- Rotations ---
    -----------------
    -- Pause
    ghostWolf()
    if SpecificToggle("Force GW Key") and not GetCurrentKeyBoardFocus() and isChecked("Auto Ghost Wolf") then
        if buff.ghostWolf.exists("player") then
            return
        else
            if cast.ghostWolf("player") then
                br.addonDebug("Casting Ghost Wolf")
                return true
            end
        end
    elseif pause() or (UnitExists("target") and not UnitCanAttack("target", "player")) or mode.rotation == 4 or isCastingSpell(293491) or cast.current.focusedAzeriteBeam() then
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        if not inCombat then
            --if (buff.ghostWolf.exists() and mode.ghostWolf ~= 1) then return end
            actionList_PreCombat()
            actionList_Extra()
        end -- End Out of Combat Rotation
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if inCombat then
            --if (buff.ghostWolf.exists() and mode.ghostWolf ~= 1) then return end
            actionList_Interrupt()
            actionList_Defensive()
            actionList_Elementals()
            if isChecked("Capacitor Totem - Tank Stuns") and getDistance("target") <= 40 and (inInstance or inRaid) then
                if #enemies.yards8t >= getOptionValue("Capacitor Totem - Tank Stuns") and inCombat then
                    if createCastFunction("best", false, 1, 8, spell.capacitorTotem, nil, true) then
                        br.addonDebug("Casting Capacitor Totem")
                        return true
                    end
                end
            end
            if useCDs() and hasItem(166801) and canUseItem(166801) then
                br.addonDebug("Using Sapphire of Brilliance")
                useItem(166801)
            end
            --Simc
            if getOptionValue("APL Mode") == 1 then
                --AMR
                --Trinkets
                if isChecked("Trinkets") and useCDs() then
                    if equiped.shiverVenomRelic() and isChecked("Shiver Venom") then
                        if debuff.shiverVenom.stack("target") == 5 then
                            if UnitCastingInfo("player") then
                                SpellStopCasting()
                            end
                            use.shiverVenomRelic()
                            br.addonDebug("Using Shiver Venom Relic")
                        end
                    elseif (buff.ascendance.exists("player") or #enemies.yards10t >= 3 or cast.last.fireElemental() or cast.last.stormElemental()) and holdBreak then
                        if canUseItem(13) and not equiped.shiverVenomRelic(13) then
                            if UnitCastingInfo("player") then
                                SpellStopCasting()
                            end
                            useItem(13)
                            br.addonDebug("Using Trinket 1")
                        end
                        if canUseItem(14) and not equiped.shiverVenomRelic(14) then
                            if UnitCastingInfo("player") then
                                SpellStopCasting()
                            end
                            useItem(14)
                            br.addonDebug("Using Trinket 2")
                        end
                    end
                end
                --actions+=/totem_mastery,if=talent.totem_mastery.enabled&buff.resonance_totem.remains<2
                if talent.totemMastery and (not buff.resonanceTotem.exists() or buff.resonanceTotem.remain() < 2) and holdBreak then
                    if cast.totemMastery() then
                        br.addonDebug("Casting Totem Mastery")
                        return true
                    end
                end
                --actions+=/fire_elemental,if=!talent.storm_elemental.enabled
                if isChecked("Storm Elemental/Fire Elemental") and useCDs() and holdBreak and not earthEle then
                    if not talent.stormElemental then
                        --actions+=/storm_elemental,if=talent.storm_elemental.enabled&(!talent.icefury.enabled|!buff.icefury.up&!cooldown.icefury.up)&(!talent.ascendance.enabled|!cooldown.ascendance.up)
                        if cast.fireElemental() then
                            br.addonDebug("Casting Fire Elemental")
                            return true
                        end
                    elseif
                        talent.stormElemental and (not talent.iceFury or (not buff.iceFury.exists("player") and cd.iceFury.remain() > gcd)) and
                            (not talent.ascendance or (cd.ascendance.remain() > gcd or not useCDs()))
                     then
                        if cast.stormElemental() then
                            br.addonDebug("Casting Storm Elemental")
                            return true
                        end
                    end
                end
                --actions+=/earth_elemental,if=cooldown.fire_elemental.remains<120&!talent.storm_elemental.enabled|cooldown.storm_elemental.remains<120&talent.storm_elemental.enabled
                --actions+=/earth_elemental,if=!talent.primal_elementalist.enabled|talent.primal_elementalist.enabled&(cooldown.fire_elemental.remains<120&!talent.storm_elemental.enabled|cooldown.storm_elemental.remains<120&talent.storm_elemental.enabled)
                if
                    useCDs() and isChecked("Earth Elemental") and
                        (not talent.primalElementalist or (talent.primalElementalist and ((not fireEle and not talent.stormElemental) or (not stormEle and talent.stormElemental)))) and
                        holdBreak
                 then
                    if cast.earthElemental() then
                        br.addonDebug("Casting Earth Elemental")
                        return true
                    end
                end
                -- Essence
                if isChecked("Use Essence") and ttd("target") > 30 then
                    if essence.concentratedFlame.active and cd.concentratedFlame.remains() <= gcd then
                        if cast.concentratedFlame("target") then
                            br.addonDebug("Casting Concentrated Flame")
                            return true
                        end
                    elseif essence.memoryOfLucidDreams.active and cd.memoryOfLucidDreams.remains() <= gcd and #enemies.yards10 >= 1 then
                        if cast.memoryOfLucidDreams("player") then
                            br.addonDebug("Casting Memory of Lucid Dreams")
                            return true
                        end
                    elseif essence.bloodOfTheEnemy.active and cd.bloodOfTheEnemy.remains() <= gcd and #enemies.yards10 >= 1 then
                        if cast.bloodOfTheEnemy() then
                            br.addonDebug("Casting Blood of the Enemy")
                            return true
                        end
                    elseif essence.guardianOfAzeroth.active and cd.guardianOfAzeroth.remains() <= gcd and #enemies.yards30 >= 1 then
                        if cast.guardianOfAzeroth() then
                            br.addonDebug("Casting Guardian of Azeroth")
                            return true
                        end
                    elseif
                        essence.focusedAzeriteBeam.active and cd.focusedAzeriteBeam.remains() <= gcd and
                            ((essence.focusedAzeriteBeam.rank < 3 and not isMoving("player")) or essence.focusedAzeriteBeam.rank >= 3) and
                            getFacing("player", "target") and
                            (getEnemiesInRect(10, 25, false, false) >= getOptionValue("Azerite Beam Units") or
                                (useCDs() and (getEnemiesInRect(10, 40, false, false) >= 1 or (getDistance("target") < 6 and isBoss("target")))))
                     then
                        if cast.focusedAzeriteBeam() then
                            br.addonDebug("Casting Focused Azerite Beam")
                            return true
                        end
                    elseif essence.purifyingBlast.active and cd.purifyingBlast.remains() <= gcd and getDistance("target") <= 30 then
                        if cast.purifyingBlast("best", nil, 1, 8) then
                            br.addonDebug("Casting Purifying Blast")
                            return true
                        end
                    elseif essence.theUnboundForce.active and cd.theUnboundForce.remains() <= gcd and getDistance("target") <= 30 then
                        if cast.theUnboundForce() then
                            br.addonDebug("Casting The Unbound Force")
                            return true
                        end
                    elseif essence.rippleInSpace.active and cd.rippleInSpace.remains() <= gcd and getDistance("target") <= 25 then
                        if cast.rippleInSpace("target") then
                            br.addonDebug("Casting Ripple in Space")
                            return true
                        end
                    elseif essence.worldveinResonance.active and cd.worldveinResonance.remains() <= gcd then
                        if cast.worldveinResonance() then
                            br.addonDebug("Casting Worldvein Resonance")
                            return true
                        end
                    end
                end
                -- Racial Buffs
                if
                    (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") and isChecked("Racial") and useCDs() and
                        (not talent.ascendance or buff.ascendance.exists("player") or cd.ascendance.remain() > 50) and
                        holdBreak
                 then
                    if race == "LightforgedDraenei" then
                        if cast.racial("target", "ground") then
                            br.addonDebug("Casting Racial")
                            return true
                        end
                    else
                        if cast.racial("player") then
                            br.addonDebug("Casting Racial")
                            return true
                        end
                    end
                end
                if (#enemies.yards10t > 2 and (mode.rotation ~= 3 and mode.rotation ~= 2)) or mode.rotation == 2 then
                    if actionList_AoE() then
                        return true
                    end
                elseif (#enemies.yards10t <= 2 and (mode.rotation ~= 2 and mode.rotation ~= 3)) or mode.rotation == 3 then
                    if actionList_ST() then
                        return true
                    end
                end
            elseif getOptionValue("APL Mode") == 2 then
                if actionList_AMR() then
                    return true
                end
            end
        end
    end -- End In Combat Rotation
    --end -- End Timer
end -- End runRotation
local id = 0 -- Change to the spec id profile is for.
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

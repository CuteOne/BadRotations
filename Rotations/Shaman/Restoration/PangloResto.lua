local rotationName = "Resto Shamlo" -- Change to name of profile listed in options drop down

local function createToggles() -- Define custom toggles
    -- Cooldown Button
    CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.healingTideTotem},
        [2] = {mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.healingTideTotem},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.healingTideTotem}
    }
    CreateButton("Cooldown", 1, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.astralShift},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.astralShift}
    }
    CreateButton("Defensive", 2, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.windShear},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.windShear}
    }
    CreateButton("Interrupt", 3, 0)
    DamageModes = {
        [1] = {mode = "On", value = 1, overlay = "Damage", tip = "kill things", highlight = 1, icon = br.player.spell.lightningBolt},
        [2] = {mode = "Off", value = 2, overlay = "No Damage", tip = "pacifist mode", highlight = 0, icon = br.player.spell.lightningBolt}
    }
    CreateButton("Damage", 4, 0)
    PurgeModes = {
        [1] = {mode = "On", value = 1, overlay = "Purge", tip = "Purge ALL magic buffs", highlight = 1, icon = br.player.spell.purge},
        [2] = {mode = "Tar", value = 2, overlay = "Purge Tar", tip = "Purge TARGETS magic buffs", highlight = 0, icon = br.player.spell.purge},
        [3] = {mode = "Off", value = 3, overlay = "No Purge", tip = "Be a bad healer(No purge)", highlight = 0, icon = 136235}
    }
    CreateButton("Purge", 0, -1)
    PurifyModes = {
        [1] = {mode = "On", value = 1, overlay = "Purify", tip = "dispel things", highlight = 1, icon = br.player.spell.purifySpirit},
        [2] = {mode = "Off", value = 2, overlay = "No Purify", tip = "dont dispel", highlight = 0, icon = br.player.spell.purifySpirit}
    }
    CreateButton("Purify", 1, -1)
    WolfModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Auto Wolf OOC", tip = "Auto Wolf OoC while moving", highlight = 1, icon = br.player.spell.ghostWolf},
        [2] = {mode = "Key", value = 2, overlay = "Key Wolf", tip = "Wolf while holding key", highlight = 0, icon = br.player.spell.ghostWolf},
        [3] = {mode = "Off", value = 3, overlay = "No Wolf", tip = "No wolf usage", highlight = 0, icon = 656576}
    }
    CreateButton("Wolf", 2, -1)
    
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
        br.ui:createCheckbox(section, "OOC Healing", "OOC Healing.")
        br.ui:createCheckbox(section, "Water Shield", "Keep Water Shield Up.")
        br.ui:createDropdown(section, "Ghost Wolf Key", br.dropOptions.Toggle, 6, "Hold this key to force ghost wolf")
        

        br.ui:checkSectionState(section)

        ------------------------
        --- HEALING OPTIONS --- --
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Healing")
        br.ui:createSpinner(section,"Tank Emergency", 0, 0, 100, 5, "Oh shit the tank is below this %, heal them before anyone else")
        br.ui:createSpinner(section, "Riptide", 90, 0, 100, 5, "% to cast")
        br.ui:createDropdown(section, "Upkeep Riptide", {"target", "tank", "player"}, 1, "Target to cast on")
        br.ui:createCheckbox(section, "Only in Combat (Riptide Upkeep)")

        br.ui:createSpinner(section, "Healing Wave", 70, 0, 100, 5, "% to Cast At")
        br.ui:createCheckbox(section, "HW Buff", "Only use Healing Wave with Tidal Waves or Undulation.")
        br.ui:createSpinner(section, "Unleash Life", 55, 0, 100, 5, "% to Cast At")
        br.ui:createSpinner(section, "Healing Surge", 55, 0, 100, 5, "% to Cast At")

        br.ui:createSpinner(section, "Chain Heal", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Chain Heal Targets", 3, 0, 40, 1, "Minimum Chain Heal Targets")

        br.ui:createDropdown(section, "Upkeep Earth Shield", {"target", "tank", "player"}, 1, "Target to cast on")
        br.ui:createCheckbox(section, "Only in Combat (Earth Shield)")

        br.ui:createSpinner(section, "Healing Rain", 80, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Healing Rain Targets", 2, 0, 40, 1, "Minimum Healing Rain Targets")

        br.ui:checkSectionState(section)

        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")

        br.ui:createSpinner(section, "Ascendance", 50, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Ascendance Targets", 3, 0, 40, 1, "Targets Below Ascendance (excluding yourself)")

        br.ui:createSpinner(section, "Healing Tide Totem", 50, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Healing Tide Totem Targets", 3, 0, 40, 1, "Minimum Healing Tide Totem Targets (excluding yourself)")

        br.ui:checkSectionState(section)

        -----------
        --- Defensives ---
        -----------
        section = br.ui:createSection(br.ui.window.profile, "Defensives")
        br.ui:createSpinner(section,"Astral Shift", 40, 1, 99, 1)
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Damage Time")
        br.ui:createDropdown(section,"Lavaburst",{"Always", "Only Surge"}, 1)
        br.ui:createDropdown(section,"Flame Shock",{"All Units", "Target"}, 1)
        br.ui:createCheckbox(section,"Lightning Fillers")
        br.ui:checkSectionState(section)

        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createCheckbox(section,"Wind Shear")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "Cast Percentage to use at.")
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
    --Print("Running: "..rotationName
    local essence = br.player.essence
    local equiped = br.player.equiped
    local gcdMax = br.player.gcdMax
    local has = br.player.has
    local item = br.player.items
    local mode = br.player.ui.mode
    local notmoving = not isMoving("player") or br.player.buff.spiritwalkersGrace.exists("player")
    local ui = br.player.ui
    local pet = br.player.pet
    local php = br.player.health
    local pullTimer = br.DBM:getPulltimer()
    local traits = br.player.traits
    local tanks = getTanksTable()
    local units = br.player.units
    local use = br.player.use
    local artifact = br.player.artifact
    local buff = br.player.buff
    local cast = br.player.cast
    local combatTime = getCombatTime()
    local cd = br.player.cd
    local charges = br.player.charges
    local debuff = br.player.debuff
    local enemies = br.player.enemies
    local falling, swimming, flying = getFallTime(), IsSwimming(), IsFlying()
    local gcd = br.player.gcd
    local healPot = getHealthPot()
    local inCombat = br.player.inCombat
    local inInstance = br.player.instance == "party"
    local inRaid = br.player.instance == "raid"
    local level = br.player.level
    local lowestHP = br.friend[1].unit
    local perk = br.player.perk
    local power, powmax, powgen = br.player.power, br.player.powerMax, br.player.powerRegen
    local wolf = br.player.buff.ghostWolf.exists()
    local water = br.player.buff.waterShield.exists()
    local race = br.player.race
    local racial = br.player.getRacial()
    local spell = br.player.spell
    local talent = br.player.talent
    local ttm = br.player.timeToMax
    local mana = br.player.power.mana.percent()
    local tanks = getTanksTable()
    local function tideTotemExists()
        for i=1, 10 do
            if GetTotemInfo(i) ~= nil then
                if select(2,GetTotemInfo(i)) == "Healing Tide Totem" then
                    return true
                end
            end
        end
        return false
    end
    

    if leftCombat == nil then
        leftCombat = GetTime()
    end
    if profileStop == nil then
        profileStop = false
    end

    if timersTable then
        wipe(timersTable)
    end

    units.get(40)
    enemies.get(30)
    enemies.get(40, "player", false, true)
    enemies.get(40)

    local lowest = {}
    lowest.unit = "player"
    lowest.hp = 100

    for i = 1, #br.friend do
        if br.friend[i].hp < lowest.hp then
            lowest = br.friend[i]
        end
    end

    local biggestGroup = 0
    local bestUnit
    for i = 1, #br.friend do
        local thisUnit = br.friend[i].unit
        local thisGroup = #getUnitsToHealAround(thisUnit, 8, getValue("Healing Rain"), getValue("Healing Rain Targets"))
        local tankGroup = 0
        if #tanks > 0 then
            tankGroup = #getUnitsToHealAround(tanks[1].unit, 8, getValue("Healing Rain"), getValue("Healing Rain Targets"))
        end

        if thisGroup > biggestGroup then
            biggestGroup = thisGroup
            bestUnit = thisUnit
        end
        if #tanks > 0 then
            if tankGroup == biggestGroup then
                biggestGroup = tankGroup
                bestUnit = tanks[1].unit
            end
        end
    end

    --------------------
    --- Action Lists ---
    --------------------
    if br.data.settings[br.selectedSpec][br.selectedProfile]["HE ActiveCheck"] == false and br.timer:useTimer("Error delay", 0.5) then
        Print("Detecting Healing Engine is not turned on.  Please activate Healing Engine to use this profile.")
        return 
    end

    local function cooldownTime()
        if useCDs() then
            if isChecked("Ascendance") and getLowAllies(getValue("Ascendance")) >= getValue("Ascendance Targets") and not tideTotemExists() then
                if cast.ascendance("player") then
                    return 
                end
            end
            if isChecked("Healing Tide Totem") and useCDs() and not buff.ascendance.exists() and cd.healingTideTotem.remain() <= gcd then
                if getLowAllies(getValue("Healing Tide Totem")) >= getValue("Healing Tide Totem Targets") then
                    if cast.healingTideTotem("player") then
                        return 
                    end
                end
            end
        end
    end

    local function dontDie()
        if isChecked("Astral Shift") and php <= getValue("Astral Shift") then
            if cast.astralShift("player") then
                return 
            end
        end
    end

    local function healingTime()
        if isChecked("Riptide") then
            for i = 1, #br.friend do
                if br.friend[i].hp <= getValue("Riptide") and buff.riptide.remain(br.friend[i].unit) < 2.1 then
                    if cast.riptide(br.friend[i].unit) then
                        return 
                    end
                end
            end
        end

        -- upkeep riptide start
        if isChecked("Upkeep Riptide") and (inCombat or not isChecked("Only in Combat (Riptide Upkeep)")) then
            if getOptionValue("Upkeep Riptide") == 1 and UnitIsPlayer("target") and not buff.riptide.exists("target") then -- Target
                if cast.riptide("target") then
                    return 
                end
            end

            if getOptionValue("Upkeep Riptide") == 2 then -- Tank
                for i = 1, #tanks do
                    if UnitIsPlayer(tanks[i].unit) and GetUnitIsFriend(tanks[i].unit, "player") and getDistance(tanks[i].unit) <= 40 and not buff.riptide.exists(tanks[i].unit) then
                        if cast.riptide(tanks[i].unit) then
                            return 
                        end
                    end
                end
            end

            if getOptionValue("Upkeep Riptide") == 3 then -- Player
                if not UnitIsDeadOrGhost("player") and not buff.riptide.exists("player") then
                    if cast.riptide("player") then
                        return 
                    end
                end
            end
        end

        -- start of ES upkeep
        if isChecked("Upkeep Earth Shield") and (inCombat or not isChecked("Only in Combat (Earth Shield)")) then
            if getOptionValue("Upkeep Earth Shield") == 1 and UnitIsPlayer("target") and not buff.earthShield.exists("target") then -- Target
                if cast.earthShield("target") then
                    return 
                end
            end

            if getOptionValue("Upkeep Earth Shield") == 2 then -- Tank
                for i = 1, #tanks do
                    if inRaid then
                        if GetUnitIsUnit(tanks[i].unit, "boss1target") and not buff.earthShield.exists(tanks[i].unit) then
                            cast.earthShield(tanks[i].unit)
                        end
                    elseif (not inRaid or buff.earthShield.count() < 1) and UnitIsPlayer(tanks[i].unit) and GetUnitIsFriend(tanks[i].unit, "player") and getDistance(tanks[i].unit) <= 40 and not buff.earthShield.exists(tanks[i].unit) then
                        if cast.earthShield(tanks[i].unit) then
                            return 
                        end
                    end
                end
            end
        end -- end of ES upkeep

        if isChecked("Unleash Life") then
            if lowest.hp <= getValue("Unleash Life") then
                if cast.unleashLife(lowest.unit) then
                    return 
                end
            end
        end

        if isChecked("Healing Surge") and notmoving then
            for i = 1, #tanks do
                if tanks[i].hp <= getValue("Healing Surge")/2 then
                    if cast.healingSurge(tanks[i].unit) then
                        return 
                    end
                end
            end
        end

        if isChecked("Healing Surge") and notmoving then
            if lowest.hp <= getValue("Healing Surge") then
                if cast.healingSurge(lowest.unit) then
                    return true
                end
            end
        end

        if isChecked("Healing Rain") and inCombat and not buff.healingRain.exists("player") and notmoving then
            if biggestGroup >= getValue("Healing Rain Targets") then
                if cast.healingRain(bestUnit) then
                    SpellStopTargeting()
                    return 
                end
            end
        end

        if isChecked("Chain Heal") and notmoving then
            if chainHealUnits(spell.chainHeal, 15, getValue("Chain Heal"), getValue("Chain Heal Targets")) then
                return 
            end
        end

        if isChecked("Healing Wave") and notmoving and not isChecked("HW Buff") then
            if lowest.hp <= getValue("Healing Wave") then
                if cast.healingWave(lowest.unit) then
                    return 
                end
            end
        end

        if isChecked("Healing Wave") and notmoving and isChecked("HW Buff") then
            if lowest.hp <= getValue("Healing Wave") and buff.tidalWaves.exists() or lowest.hp <= getValue("Healing Wave") and buff.undulation.exists() then
                if cast.healingWave(lowest.unit) then
                    return 
                end
            end
        end
    end

    local function dpstime()

        if buff.lavaSurge.exists() and isChecked("Lavaburst") then
            for i = 1, #enemies.yards40f do
                local thisUnit = enemies.yards40[i]
                if debuff.flameShock.remains(thisUnit) > 1 and getFacing("player",thisUnit) then
                    if cast.lavaBurst(thisUnit) then
                        return 
                    end
                end
            end
        end

        if isChecked("Flame Shock") and (not debuff.flameShock.exists("target") or debuff.flameShock.remains("target") < 6) and getFacing("player","target") then
            if cast.flameShock("target") then
                return 
            end
        end

        if isChecked("Flame Shock") and getOptionValue("Flame Shock") ~= 2 then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.flameShock.exists(thisUnit) and getFacing("player",thisUnit) then
                    if cast.flameShock(thisUnit) then
                        return 
                    end
                end
            end
        end
        if isChecked("Lavaburst") and getOptionValue("Lavaburst") ~= 2 then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if debuff.flameShock.remains(thisUnit) > 4 and getFacing("player",thisUnit) then
                    if cast.lavaBurst(thisUnit) then
                        return 
                    end
                end
            end
        end
        if isChecked("Lightning Fillers") then
            if #enemies.yards40 > 1 then
                if cast.chainLightning(units.dyn40) then
                    return 
                end
            elseif cast.lightningBolt(units.dyn40) then
                return 
            end
        end
    end
    local function extraStuff()
        if mode.wolf == 1 and isMoving("player") and not buff.ghostWolf.exists() then
            if cast.ghostWolf("player") then
                return 
            end
        elseif mode.wolf == 2 and SpecificToggle("Ghost Wolf Key") and not GetCurrentKeyBoardFocus() and not buff.ghostWolf.exists() then
            if cast.ghostWolf("player") then
                return 
            end
        elseif mode.wolf == 2 and not SpecificToggle("Ghost Wolf Key") then
            RunMacroText("/cancelAura Ghost Wolf")
        end

        if isChecked("Water Shield") and not buff.waterShield.exists() then
            if cast.waterShield("player") then
                return 
            end
        end

        if mode.purify == 1 then
            for i = 1, #br.friend do
                if canDispel(br.friend[i].unit, spell.purifySpirit) then
                    if cast.purifySpirit(br.friend[i].unit) then
                        return 
                    end
                end
            end
        end

        if mode.purge == 1 then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if canDispel(thisUnit, spell.purge) then
                    if cast.purge(thisUnit) then
                        return 
                    end
                end
            end
        end
        if mode.purge == 2 then
            if canDispel("target", spell.purge) and GetObjectExists("target") then
                if cast.purge("target") then
                    return 
                end
            end
        end
    end

    local function interruptTime()
        if useInterrupts() then
            for i=1, #enemies.yards30 do
                thisUnit = enemies.yards30[i]
                if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                    if isChecked("Wind Shear") then
                        if cast.windShear(thisUnit) then 
                            return  
                        end
                    end
                end
            end
        end
    end

    --if IsAoEPending() and inCombat then SpellStopTargeting() return true end
    -- Pause
    if (select(2,GetSpellCooldown(61304))) == 1 or ((pause(true) or isLooting() or (SpecificToggle("Ghost Wolf Key") and buff.ghostWolf.exists("player"))) or IsMounted() or IsFlying()) then
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        if not inCombat then
            if isChecked("OOC Healing") then
                if healingTime() then
                    return  
                end
            end

            if extraStuff() then
                return  
            end

            if interruptTime() then
                return  
            end
        end

        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if inCombat then
            if dontDie() then
                return  
            end

            if extraStuff() then
                return  
            end
    
            if interruptTime() then
                return  
            end

            if cooldownTime() then
                return  
            end

            if healingTime() then
                return true
            end

            if mode.damage == 1 then
                if dpstime() then
                    return
                end
            end
        end -- End In Combat Rotation
    end -- Pause -- End Timer
end -- End runRotation
local id = 264
-- Change to the spec id profile is for.
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

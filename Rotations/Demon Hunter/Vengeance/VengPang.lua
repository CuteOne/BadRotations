-- Version 1.0.0
local red = "|cffFF0000"
local orange = "|cffFFA500"
local yellow = "|cffFFFF00"
local green = "|cff00FF00"
local blue = "|cff0000FF"
local indigo = "|cff4B0082"
local violet = "|cff7F00FF"

local rotationName = red .. "M" .. orange .. "o" .. yellow .. "n" .. green .. "k" .. blue .. "a" .. indigo .. "G" .. violet .. "i" .. red .. "g" .. orange .. "a"
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = {mode = red .. "A" .. orange .. "u" .. yellow .. "t" .. green .. "o", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.soulCleave},
        [2] = {mode = blue .. "O" .. indigo .. "f" .. violet .. "f", value = 2, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.spectralSight}
    }
    CreateButton("Rotation", 1, 0)
    -- Cooldown Button
    CooldownModes = {
        [1] = {mode = red .. "A" .. orange .. "u" .. yellow .. "t" .. green .. "o", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.metamorphosis},
        [2] = {mode = blue .. "O" .. indigo .. "n", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.metamorphosis},
        [3] = {mode = violet .. "O" .. red .. "f" .. orange .. "f", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.metamorphosis}
    }
    CreateButton("Cooldown", 2, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = {mode = red .. "O" .. orange .. "n", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.demonSpikes},
        [2] = {mode = yellow .. "O" .. green .. "f" .. blue .. "f", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.demonSpikes}
    }
    CreateButton("Defensive", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = {mode = red .. "O" .. orange .. "n", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.consumeMagic},
        [2] = {mode = yellow .. "O" .. green .. "f" .. blue .. "f", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.consumeMagic}
    }
    CreateButton("Interrupt", 4, 0)
    -- Mover
    MoverModes = {
        [1] = {mode = red .. "O" .. orange .. "n", value = 2, overlay = "Auto Movement Enabled", tip = "Will Cast Movement Abilities.", highlight = 1, icon = br.player.spell.infernalStrike},
        [2] = {mode = yellow .. "O" .. green .. "f" .. blue .. "f", value = 1, overlay = "Auto Movement Disabled", tip = "Will NOT Cast Movement Abilities", highlight = 0, icon = br.player.spell.infernalStrike}
    }
    CreateButton("Mover", 5, 0)
end

local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.000")
        br.ui:createCheckbox(section, red .. "C" .. orange .. "o" .. yellow .. "n" .. green .. "s" .. blue .. "u" .. indigo .. "m" .. violet .. "e" .. red .. " M" .. orange .. "a" .. yellow .. "g" .. green .. "i" .. blue .. "c")
        br.ui:createCheckbox(section, orange .. "T" .. yellow .. "a" .. green .. "u" .. blue .. "n" .. indigo .. "t")
        br.ui:createCheckbox(section, yellow .. "I" .. green .. "g" .. blue .. "n" .. indigo .. "o" .. violet .. "r" .. red .. "e" .. orange .. " T" .. yellow .. "h" .. green .. "r" .. blue .. "e" .. indigo .. "a" .. violet .. "t" .. red .. " C" .. orange .. "h" .. yellow .. "e" .. green .. "c" .. blue .. "k")
        br.ui:checkSectionState(section)
        -------------------------
        ---  COOLDOWN OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createDropdownWithout(
            section,
            red .. "T" .. orange .. "r" .. yellow .. "i" .. green .. "n" .. blue .. "k" .. indigo .. "e" .. violet .. "t" .. red .. "s",
            {
                red .. "A" .. orange .. "l" .. yellow .. "w" .. green .. "a" .. blue .. "y" .. indigo .. "s",
                yellow .. "W" .. green .. "h" .. blue .. "e" .. indigo .. "n" .. violet .. " C" .. red .. "D" .. orange .. "s" .. yellow .. " a" .. green .. "r" .. blue .. "e" .. indigo .. " e" .. violet .. "n" .. red .. "a" .. orange .. "b" .. yellow .. "l" .. green .. "e" .. blue .. "d",
                orange .. "N" .. yellow .. "e" .. green .. "v" .. blue .. "e" .. indigo .. "r"
            },
            1,
            ""
        )
        br.ui:createDropdownWithout(
            section,
            orange .. "T" .. yellow .. "r" .. green .. "i" .. blue .. "n" .. indigo .. "k" .. violet .. "e" .. red .. "t" .. orange .. " 1" .. yellow .. " M" .. green .. "o" .. blue .. "d" .. indigo .. "e",
            {
                red .. "N" .. orange .. "o" .. yellow .. "r" .. green .. "m" .. blue .. "a" .. indigo .. "l",
                orange .. "G" .. yellow .. "r" .. green .. "o" .. blue .. "u" .. indigo .. "n" .. violet .. "d",
                yellow .. "D" .. green .. "e" .. blue .. "f" .. indigo .. "e" .. violet .. "n" .. red .. "s" .. orange .. "i" .. yellow .. "v" .. green .. "e" .. blue .. " H" .. indigo .. "P"
            },
            1,
            "",
            ""
        )
        br.ui:createDropdownWithout(
            section,
            yellow .. "T" .. green .. "r" .. blue .. "i" .. indigo .. "n" .. violet .. "k" .. red .. "e" .. orange .. "t" .. yellow .. " 2" .. green .. " M" .. blue .. "o" .. indigo .. "d" .. violet .. "e",
            {
                red .. "N" .. orange .. "o" .. yellow .. "r" .. green .. "m" .. blue .. "a" .. indigo .. "l",
                orange .. "G" .. yellow .. "r" .. green .. "o" .. blue .. "u" .. indigo .. "n" .. violet .. "d",
                yellow .. "D" .. green .. "e" .. blue .. "f" .. indigo .. "e" .. violet .. "n" .. red .. "s" .. orange .. "i" .. yellow .. "v" .. green .. "e" .. blue .. " H" .. indigo .. "P"
            },
            1,
            "",
            ""
        )
        br.ui:createSpinnerWithout(section, green .. "T" .. blue .. "r" .. indigo .. "i" .. violet .. "n" .. red .. "k" .. orange .. "e" .. yellow .. "t" .. green .. " 1" .. blue .. " H" .. indigo .. "P", 50, 1, 100, 5)
        br.ui:createSpinnerWithout(section, blue .. "T" .. indigo .. "r" .. violet .. "i" .. red .. "n" .. orange .. "k" .. yellow .. "e" .. green .. "t" .. blue .. " 2" .. indigo .. " H" .. violet .. "P", 50, 1, 100, 5)
        br.ui:checkSectionState(section)
        -------------------------
        ---- ESSENCE OPTIONS ----
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Essences")
        br.ui:createDropdownWithout(section, red .. "U" .. orange .. "s" .. yellow .. "e" .. green .. " C" .. blue .. "o" .. indigo .. "n" .. violet .. "c" .. red .. "e" .. orange .. "n" .. yellow .. "t" .. green .. "r" .. blue .. "a" .. indigo .. "t" .. violet .. "e" .. red .. "d" .. orange .. " F" .. yellow .. "l" .. green .. "a" .. blue .. "m" .. indigo .. "e", {red .. "D" .. orange .. "P" .. yellow .. "S", orange .. "H" .. yellow .. "e" .. green .. "a" .. blue .. "l", yellow .. "H" .. green .. "y" .. blue .. "b" .. indigo .. "r" .. violet .. "i" .. red .. "d", green .. "N" .. blue .. "e" .. indigo .. "v" .. violet .. "e" .. red .. "r"}, 1)
        br.ui:createSpinnerWithout(section, orange .. "C" .. yellow .. "o" .. green .. "n" .. blue .. "c" .. indigo .. "e" .. violet .. "n" .. red .. "t" .. orange .. "r" .. yellow .. "a" .. green .. "t" .. blue .. "e" .. indigo .. "d" .. violet .. " F" .. red .. "l" .. orange .. "a" .. yellow .. "m" .. green .. "e" .. blue .. " H" .. indigo .. "e" .. violet .. "a" .. red .. "l", 70, 10, 90, 5)
        br.ui:createSpinner(section, yellow .. "A" .. green .. "n" .. blue .. "i" .. indigo .. "m" .. violet .. "a" .. red .. " o" .. orange .. "f" .. yellow .. " D" .. green .. "e" .. blue .. "a" .. indigo .. "t" .. violet .. "h", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, red .. "F" .. orange .. "i" .. yellow .. "e" .. green .. "r" .. blue .. "y" .. indigo .. " B" .. violet .. "r" .. red .. "a" .. orange .. "n" .. yellow .. "d", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createCheckbox(section, orange .. "D" .. yellow .. "e" .. green .. "m" .. blue .. "o" .. indigo .. "n" .. violet .. " S" .. red .. "p" .. orange .. "i" .. yellow .. "k" .. green .. "e" .. blue .. "s")
        br.ui:createSpinnerWithout(section, yellow .. "D" .. green .. "e" .. blue .. "m" .. indigo .. "o" .. violet .. "n" .. red .. " S" .. orange .. "p" .. yellow .. "i" .. green .. "k" .. blue .. "e" .. indigo .. "s" .. violet .. " -" .. red .. " 2", 90, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinnerWithout(section, green .. "D" .. blue .. "e" .. indigo .. "m" .. violet .. "o" .. red .. "n" .. orange .. " S" .. yellow .. "p" .. green .. "i" .. blue .. "k" .. indigo .. "e" .. violet .. "s" .. red .. " -" .. orange .. " 1", 90, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinnerWithout(section, blue .. "H" .. indigo .. "o" .. violet .. "l" .. red .. "d" .. orange .. " D" .. yellow .. "e" .. green .. "m" .. blue .. "o" .. indigo .. "n" .. violet .. " S" .. red .. "p" .. orange .. "i" .. yellow .. "k" .. green .. "e" .. blue .. "s", 1, 0, 2, 1, "|cffFFBB00Number of Demon Spikes the bot will hold for manual use.")
        br.ui:createSpinner(section, indigo .. "M" .. violet .. "e" .. red .. "t" .. orange .. "a" .. yellow .. "m" .. green .. "o" .. blue .. "r" .. indigo .. "p" .. violet .. "h" .. red .. "o" .. orange .. "s" .. yellow .. "i" .. green .. "s", 40, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinner(section, violet .. "S" .. red .. "o" .. orange .. "u" .. yellow .. "l" .. green .. " B" .. blue .. "a" .. indigo .. "r" .. violet .. "r" .. red .. "i" .. orange .. "e" .. yellow .. "r", 70, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinner(section, red.."H"..orange.."e"..yellow.."a"..green.."l"..blue.."t"..indigo.."h"..violet.."s"..red.."t"..orange.."o"..yellow.."n"..green.."e"..blue.." /"..indigo.." P"..violet.."o"..red.."t"..orange.."i"..yellow.."o"..green.."n", 55, 1, 99, 5)
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createCheckbox(section, red .. "D" .. orange .. "i" .. yellow .. "s" .. green .. "r" .. blue .. "u" .. indigo .. "p" .. violet .. "t")
        br.ui:createCheckbox(section, orange .. "S" .. yellow .. "i" .. green .. "g" .. blue .. "i" .. indigo .. "l" .. violet .. " o" .. red .. "f" .. orange .. " S" .. yellow .. "i" .. green .. "l" .. blue .. "e" .. indigo .. "n" .. violet .. "c" .. red .. "e")
        br.ui:createCheckbox(section, yellow .. "S" .. green .. "i" .. blue .. "g" .. indigo .. "i" .. violet .. "l" .. red .. " o" .. orange .. "f" .. yellow .. " M" .. green .. "i" .. blue .. "s" .. indigo .. "e" .. violet .. "r" .. red .. "y")
        br.ui:createSpinner(section, green .. "I" .. blue .. "n" .. indigo .. "t" .. violet .. "e" .. red .. "r" .. orange .. "r" .. yellow .. "u" .. green .. "p" .. blue .. "t" .. indigo .. " A" .. violet .. "t", 0, 0, 95, 5, "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        ----------------------
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        }
    }
    return optionTable
end

local function runRotation()
    --Print("Running: "..rotationName)

    ---------------
    --- Toggles ---
    ---------------
    UpdateToggle("Rotation", 0.25)
    UpdateToggle("Cooldown", 0.25)
    UpdateToggle("Defensive", 0.25)
    UpdateToggle("Interrupt", 0.25)
    UpdateToggle("Mover", 0.25)
    br.player.ui.mode.mover = br.data.settings[br.selectedSpec].toggles["Mover"]

    --------------
    --- Locals ---
    --------------
    local buff = br.player.buff
    local cast = br.player.cast
    local castable = br.player.cast.debug
    local cd = br.player.cd
    local charges = br.player.charges
    local combatTime = getCombatTime()
    local debuff = br.player.debuff
    local deadtar, attacktar, hastar, playertar = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
    local enemies = br.player.enemies
    local equiped = br.player.equiped
    local gcd = br.player.gcd
    local glyph = br.player.glyph
    local healthPot = getHealthPot() or 0
    local healPot = getHealthPot()
    local inCombat = br.player.inCombat
    local inRaid = select(2, IsInInstance()) == "raid"
    local inInstance = br.player.instance == "party"
    local lastSpell = lastSpellCast
    local level = br.player.level
    local mode = br.player.ui.mode
    local moving = GetUnitSpeed("player") > 0
    local pet = br.player.pet.list
    local php = br.player.health
    local power = br.player.power.fury.amount()
    local powgen = br.player.power.fury.regen()
    local powerDeficit = br.player.power.fury.deficit()
    local powerMax = br.player.power.fury.max()
    local pullTimer = br.DBM:getPulltimer()
    local queue = br.player.queue
    local race = br.player.race
    local racial = br.player.getRacial()
    local solo = select(2, IsInInstance()) == "none"
    local spell = br.player.spell
    local talent = br.player.talent
    local thp = getHP("target")
    local ttd = getTTD
    local ttm = br.player.power.fury.ttm()
    local units = br.player.units
    if leftCombat == nil then
        leftCombat = GetTime()
    end
    if profileStop == nil then
        profileStop = false
    end
    local hasAggro = UnitThreatSituation("player")
    if hasAggro == nil then
        hasAggro = 0
    end

    units.get(5)
    units.get(8)
    enemies.get(5)
    enemies.get(8)
    enemies.get(8, "target")
    enemies.get(20)
    enemies.get(30)

    if timersTable then
        wipe(timersTable)
    end

    local function mainTank()
        if (#enemies.yards30 >= 1 and (hasAggro >= 2)) or isChecked(yellow .. "I" .. green .. "g" .. blue .. "n" .. indigo .. "o" .. violet .. "r" .. red .. "e" .. orange .. " T" .. yellow .. "h" .. green .. "r" .. blue .. "e" .. indigo .. "a" .. violet .. "t" .. red .. " C" .. orange .. "h" .. yellow .. "e" .. green .. "c" .. blue .. "k") then
            return true
        else
            return false
        end
    end

    local function coolies()
        if inCombat and getOptionValue(red .. "T" .. orange .. "r" .. yellow .. "i" .. green .. "n" .. blue .. "k" .. indigo .. "e" .. violet .. "t" .. red .. "s") == 2 then
            if canTrinket(13) and getOptionValue(orange .. "T" .. yellow .. "r" .. green .. "i" .. blue .. "n" .. indigo .. "k" .. violet .. "e" .. red .. "t" .. orange .. " 1" .. yellow .. " M" .. green .. "o" .. blue .. "d" .. indigo .. "e") == 1 then
                useItem(13)
            elseif canTrinket(13) and getOptionValue(orange .. "T" .. yellow .. "r" .. green .. "i" .. blue .. "n" .. indigo .. "k" .. violet .. "e" .. red .. "t" .. orange .. " 1" .. yellow .. " M" .. green .. "o" .. blue .. "d" .. indigo .. "e") == 2 then
                useItemGround("target", 13, 40, 0, nil)
            end

            if canTrinket(14) and getOptionValue(yellow .. "T" .. green .. "r" .. blue .. "i" .. indigo .. "n" .. violet .. "k" .. red .. "e" .. orange .. "t" .. yellow .. " 2" .. green .. " M" .. blue .. "o" .. indigo .. "d" .. violet .. "e") == 1 then
                useItem(14)
            elseif canTrinket(14) and getOptionValue(yellow .. "T" .. green .. "r" .. blue .. "i" .. indigo .. "n" .. violet .. "k" .. red .. "e" .. orange .. "t" .. yellow .. " 2" .. green .. " M" .. blue .. "o" .. indigo .. "d" .. violet .. "e") == 2 then
                useItemGround("target", 14, 40, 0, nil)
            end
        end
    end

    local function extras()
        if bossHelper() then
            return
        end

        if isChecked(orange .. "T" .. yellow .. "a" .. green .. "u" .. blue .. "n" .. indigo .. "t") and inInstance or solo then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
                    if cast.torment(thisUnit) then
                        return
                    end
                end
            end
        end

        if inCombat and getOptionValue(red .. "T" .. orange .. "r" .. yellow .. "i" .. green .. "n" .. blue .. "k" .. indigo .. "e" .. violet .. "t" .. red .. "s") == 1 then
            if canTrinket(13) and getOptionValue(orange .. "T" .. yellow .. "r" .. green .. "i" .. blue .. "n" .. indigo .. "k" .. violet .. "e" .. red .. "t" .. orange .. " 1" .. yellow .. " M" .. green .. "o" .. blue .. "d" .. indigo .. "e") == 1 then
                useItem(13)
            elseif canTrinket(13) and getOptionValue(orange .. "T" .. yellow .. "r" .. green .. "i" .. blue .. "n" .. indigo .. "k" .. violet .. "e" .. red .. "t" .. orange .. " 1" .. yellow .. " M" .. green .. "o" .. blue .. "d" .. indigo .. "e") == 2 then
                useItemGround("target", 13, 40, 0, nil)
            end

            if canTrinket(14) and getOptionValue(yellow .. "T" .. green .. "r" .. blue .. "i" .. indigo .. "n" .. violet .. "k" .. red .. "e" .. orange .. "t" .. yellow .. " 2" .. green .. " M" .. blue .. "o" .. indigo .. "d" .. violet .. "e") == 1 then
                useItem(14)
            elseif canTrinket(14) and getOptionValue(yellow .. "T" .. green .. "r" .. blue .. "i" .. indigo .. "n" .. violet .. "k" .. red .. "e" .. orange .. "t" .. yellow .. " 2" .. green .. " M" .. blue .. "o" .. indigo .. "d" .. violet .. "e") == 2 then
                useItemGround("target", 14, 40, 0, nil)
            end
        end

        if isChecked(red .. "C" .. orange .. "o" .. yellow .. "n" .. green .. "s" .. blue .. "u" .. indigo .. "m" .. violet .. "e" .. red .. " M" .. orange .. "a" .. yellow .. "g" .. green .. "i" .. blue .. "c") then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if canDispel(thisUnit, spell.consumeMagic) then
                    if cast.consumeMagic(thisUnit) then
                        return
                    end
                end
            end
        end
    end

    local function dpsThings()
        if buff.soulFragments.stack() >= 4 and #enemies.yards8 >= 1 then
            if cast.spiritBomb() then
                return
            end
        end

        if cast.immolationAura() then
            return
        end

        if (power >= 35) then
            if cast.soulCleave() then
                return
            end
        end

        if mode.mover == 2 or (not debuff.sigilOfFlame.exists("target") and (not talent.flameCrash or charges.infernalStrike.frac() <= 1.8)) then
            if cast.sigilOfFlame("player") then
                return
            end
        end

        if mode.mover == 1 and not debuff.sigilOfFlame.exists("target") and talent.flameCrash and charges.infernalStrike.frac() > 1.9 then
            if cast.infernalStrike("player") then
                return
            end
        end

        if getOptionValue(red .. "U" .. orange .. "s" .. yellow .. "e" .. green .. " C" .. blue .. "o" .. indigo .. "n" .. violet .. "c" .. red .. "e" .. orange .. "n" .. yellow .. "t" .. green .. "r" .. blue .. "a" .. indigo .. "t" .. violet .. "e" .. red .. "d" .. orange .. " F" .. yellow .. "l" .. green .. "a" .. blue .. "m" .. indigo .. "e") == 1 or (getOptionValue(red .. "U" .. orange .. "s" .. yellow .. "e" .. green .. " C" .. blue .. "o" .. indigo .. "n" .. violet .. "c" .. red .. "e" .. orange .. "n" .. yellow .. "t" .. green .. "r" .. blue .. "a" .. indigo .. "t" .. violet .. "e" .. red .. "d" .. orange .. " F" .. yellow .. "l" .. green .. "a" .. blue .. "m" .. indigo .. "e") == 3 and php > getValue(orange .. "C" .. yellow .. "o" .. green .. "n" .. blue .. "c" .. indigo .. "e" .. violet .. "n" .. red .. "t" .. orange .. "r" .. yellow .. "a" .. green .. "t" .. blue .. "e" .. indigo .. "d" .. violet .. " F" .. red .. "l" .. orange .. "a" .. yellow .. "m" .. green .. "e" .. blue .. " H" .. indigo .. "e" .. violet .. "a" .. red .. "l")) then
            if cast.concentratedFlame("target") then
                return
            end
        end

        if talent.fracture and power <= 75 or buff.soulFragments.stack() <= 3 then
            if cast.fracture() then
                return
            end
        end

        if not talent.fracture and buff.soulFragments.stack() < 5 then
            if cast.shear() then
                return
            end
        end

        --[[ if talent.fracture and charges.fracture.frac() < 0.7 and buff.soulFragments.stack() < 4 then
            if cast.throwGlaive() then
                return
            end
        end ]]
    end

    local function dontDie()
        if useDefensive() then
            if isChecked("S" .. red .. "o" .. orange .. "u" .. yellow .. "l" .. green .. " B" .. blue .. "a" .. indigo .. "r" .. violet .. "r" .. red .. "i" .. orange .. "e" .. yellow .. "r") and inCombat and cast.able.soulBarrier() and php < getOptionValue("S" .. red .. "o" .. orange .. "u" .. yellow .. "l" .. green .. " B" .. blue .. "a" .. indigo .. "r" .. violet .. "r" .. red .. "i" .. orange .. "e" .. yellow .. "r") then
                if cast.soulBarrier() then
                    return
                end
            end
            if isChecked(red.."H"..orange.."e"..yellow.."a"..green.."l"..blue.."t"..indigo.."h"..violet.."s"..red.."t"..orange.."o"..yellow.."n"..green.."e"..blue.." /"..indigo.." P"..violet.."o"..red.."t"..orange.."i"..yellow.."o"..green.."n") and php <= getOptionValue(red.."H"..orange.."e"..yellow.."a"..green.."l"..blue.."t"..indigo.."h"..violet.."s"..red.."t"..orange.."o"..yellow.."n"..green.."e"..blue.." /"..indigo.." P"..violet.."o"..red.."t"..orange.."i"..yellow.."o"..green.."n") and inCombat and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
                if canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(healPot) then
                    useItem(healPot)
                elseif hasItem(166799) and canUseItem(166799) then
                    useItem(166799)
                end
            end
            if isChecked(red .. "F" .. orange .. "i" .. yellow .. "e" .. green .. "r" .. blue .. "y" .. indigo .. " B" .. violet .. "r" .. red .. "a" .. orange .. "n" .. yellow .. "d") and inCombat and php <= getOptionValue(red .. "F" .. orange .. "i" .. yellow .. "e" .. green .. "r" .. blue .. "y" .. indigo .. " B" .. violet .. "r" .. red .. "a" .. orange .. "n" .. yellow .. "d") then
                if not buff.metamorphosis.exists() then
                    if cast.fieryBrand() then
                        return
                    end
                end
            end
            if --[[ inCombat and  ]] (getOptionValue(red .. "T" .. orange .. "r" .. yellow .. "i" .. green .. "n" .. blue .. "k" .. indigo .. "e" .. violet .. "t" .. red .. "s") == 1 or getOptionValue(red .. "T" .. orange .. "r" .. yellow .. "i" .. green .. "n" .. blue .. "k" .. indigo .. "e" .. violet .. "t" .. red .. "s") == 2) then
                if canTrinket(13) and getOptionValue(orange .. "T" .. yellow .. "r" .. green .. "i" .. blue .. "n" .. indigo .. "k" .. violet .. "e" .. red .. "t" .. orange .. " 1" .. yellow .. " M" .. green .. "o" .. blue .. "d" .. indigo .. "e") == 3 and php <= getOptionValue(green .. "T" .. blue .. "r" .. indigo .. "i" .. violet .. "n" .. red .. "k" .. orange .. "e" .. yellow .. "t" .. green .. " 1" .. blue .. " H" .. indigo .. "P") then
                    useItem(13)
                end
                if canTrinket(14) and getOptionValue(yellow .. "T" .. green .. "r" .. blue .. "i" .. indigo .. "n" .. violet .. "k" .. red .. "e" .. orange .. "t" .. yellow .. " 2" .. green .. " M" .. blue .. "o" .. indigo .. "d" .. violet .. "e") == 3 and php <= getOptionValue(blue .. "T" .. indigo .. "r" .. violet .. "i" .. red .. "n" .. orange .. "k" .. yellow .. "e" .. green .. "t" .. blue .. " 2" .. indigo .. " H" .. violet .. "P") then
                    useItem(14)
                end
            end
            if isChecked(orange .. "D" .. yellow .. "e" .. green .. "m" .. blue .. "o" .. indigo .. "n" .. violet .. " S" .. red .. "p" .. orange .. "i" .. yellow .. "k" .. green .. "e" .. blue .. "s") and inCombat and charges.demonSpikes.count() > getOptionValue(blue .. "H" .. indigo .. "o" .. violet .. "l" .. red .. "d" .. orange .. " D" .. yellow .. "e" .. green .. "m" .. blue .. "o" .. indigo .. "n" .. violet .. " S" .. red .. "p" .. orange .. "i" .. yellow .. "k" .. green .. "e" .. blue .. "s") and ((php <= getOptionValue(yellow .. "D" .. green .. "e" .. blue .. "m" .. indigo .. "o" .. violet .. "n" .. red .. " S" .. orange .. "p" .. yellow .. "i" .. green .. "k" .. blue .. "e" .. indigo .. "s" .. violet .. " -" .. red .. " 2") and charges.demonSpikes.count() == 2) or (php <= getOptionValue(green .. "D" .. blue .. "e" .. indigo .. "m" .. violet .. "o" .. red .. "n" .. orange .. " S" .. yellow .. "p" .. green .. "i" .. blue .. "k" .. indigo .. "e" .. violet .. "s" .. red .. " -" .. orange .. " 1") and charges.demonSpikes.count() == 1)) then
                if not buff.demonSpikes.exists() and not buff.metamorphosis.exists() then
                    if cast.demonSpikes() then
                        return
                    end
                end
            end
            if getOptionValue(red .. "U" .. orange .. "s" .. yellow .. "e" .. green .. " C" .. blue .. "o" .. indigo .. "n" .. violet .. "c" .. red .. "e" .. orange .. "n" .. yellow .. "t" .. green .. "r" .. blue .. "a" .. indigo .. "t" .. violet .. "e" .. red .. "d" .. orange .. " F" .. yellow .. "l" .. green .. "a" .. blue .. "m" .. indigo .. "e") ~= 1 and php <= getValue(orange .. "C" .. yellow .. "o" .. green .. "n" .. blue .. "c" .. indigo .. "e" .. violet .. "n" .. red .. "t" .. orange .. "r" .. yellow .. "a" .. green .. "t" .. blue .. "e" .. indigo .. "d" .. violet .. " F" .. red .. "l" .. orange .. "a" .. yellow .. "m" .. green .. "e" .. blue .. " H" .. indigo .. "e" .. violet .. "a" .. red .. "l") then
                if cast.concentratedFlame("player") then
                    return
                end
            end
            if isChecked(indigo .. "M" .. violet .. "e" .. red .. "t" .. orange .. "a" .. yellow .. "m" .. green .. "o" .. blue .. "r" .. indigo .. "p" .. violet .. "h" .. red .. "o" .. orange .. "s" .. yellow .. "i" .. green .. "s") and inCombat and cast.able.metamorphosis() and not buff.demonSpikes.exists() and not debuff.fieryBrand.exists(units.dyn5) and not buff.metamorphosis.exists() and php <= getOptionValue(indigo .. "M" .. violet .. "e" .. red .. "t" .. orange .. "a" .. yellow .. "m" .. green .. "o" .. blue .. "r" .. indigo .. "p" .. violet .. "h" .. red .. "o" .. orange .. "s" .. yellow .. "i" .. green .. "s") then
                if cast.metamorphosis() then
                    return
                end
            end
            if isChecked(yellow .. "A" .. green .. "n" .. blue .. "i" .. indigo .. "m" .. violet .. "a" .. red .. " o" .. orange .. "f" .. yellow .. " D" .. green .. "e" .. blue .. "a" .. indigo .. "t" .. violet .. "h") and cd.animaOfDeath.remain() <= gcd and inCombat and (#enemies.yards8 >= 3 or isBoss()) and php <= getOptionValue(yellow .. "A" .. green .. "n" .. blue .. "i" .. indigo .. "m" .. violet .. "a" .. red .. " o" .. orange .. "f" .. yellow .. " D" .. green .. "e" .. blue .. "a" .. indigo .. "t" .. violet .. "h") then
                if cast.animaOfDeath("player") then
                    return
                end
            end
        end
    end

    local function dointerrupt()
        if useInterrupts() then
            for i = 1, #enemies.yards30 do
                thisUnit = enemies.yards30[i]
                -- Disrupt
                if canInterrupt(thisUnit, getOptionValue(green .. "I" .. blue .. "n" .. indigo .. "t" .. violet .. "e" .. red .. "r" .. orange .. "r" .. yellow .. "u" .. green .. "p" .. blue .. "t" .. indigo .. " A" .. violet .. "t")) and (sigilDelay == nil or GetTime() - sigilDelay > 2) then
                    if isChecked(red .. "D" .. orange .. "i" .. yellow .. "s" .. green .. "r" .. blue .. "u" .. indigo .. "p" .. violet .. "t") and getDistance(thisUnit) < 20 and getFacing("player", thisUnit) and cd.disrupt.remain() <= gcd then
                        -- Sigil of Silence
                        if cast.disrupt(thisUnit) then
                            return
                        end
                    elseif isChecked(orange .. "S" .. yellow .. "i" .. green .. "g" .. blue .. "i" .. indigo .. "l" .. violet .. " o" .. red .. "f" .. orange .. " S" .. yellow .. "i" .. green .. "l" .. blue .. "e" .. indigo .. "n" .. violet .. "c" .. red .. "e") and cd.sigilOfSilence.remain() <= gcd then
                        -- Sigil of Misery
                        if not talent.concentratedSigils then
                            if cast.sigilOfSilence(thisUnit, "ground", 1, 8) then
                                sigilDelay = GetTime()
                                return
                            end
                        elseif talent.concentratedSigils and getDistance(thisUnit) <= 8 then
                            if cast.sigilOfSilence() then
                                sigilDelay = GetTime()
                                return
                            end
                        end
                    elseif isChecked(yellow .. "S" .. green .. "i" .. blue .. "g" .. indigo .. "i" .. violet .. "l" .. red .. " o" .. orange .. "f" .. yellow .. " M" .. green .. "i" .. blue .. "s" .. indigo .. "e" .. violet .. "r" .. red .. "y") and cd.sigilOfMisery.remain() <= gcd then
                        if not talent.concentratedSigils then
                            if cast.sigilOfMisery(thisUnit, "ground", 1, 8) then
                                sigilDelay = GetTime()
                                return
                            end
                        elseif talent.concentratedSigils and getDistance(thisUnit) <= 8 then
                            if cast.sigilOfMisery() then
                                sigilDelay = GetTime()
                                return
                            end
                        end
                    end
                end
            end
        end
    end

    if not inCombat and not hastar and profileStop == true then
        profileStop = false
    elseif (inCombat and profileStop == true) or pause() or (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) and getBuffRemain("player", 192002) < 10 or mode.rotation == 2 then
        return
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        if mainTank() or isChecked(yellow .. "I" .. green .. "g" .. blue .. "n" .. indigo .. "o" .. violet .. "r" .. red .. "e" .. orange .. " T" .. yellow .. "h" .. green .. "r" .. blue .. "e" .. indigo .. "a" .. violet .. "t" .. red .. " C" .. orange .. "h" .. yellow .. "e" .. green .. "c" .. blue .. "k") then
            if dontDie() then
                return
            end
        end

        if dointerrupt() then
            return
        end

        if extras() then
            return
        end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if inCombat and profileStop == false and not (IsMounted() or IsFlying()) and #enemies.yards20 >= 1 then
            if getDistance(units.dyn5) < 5 then
                StartAttack()
            end
            if coolies() then
                return
            end
            if dpsThings() then
                return
            end
        end -- end combat check
    end -- Pause
end -- End runRotation

local id = 0 -- commented out until updated
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

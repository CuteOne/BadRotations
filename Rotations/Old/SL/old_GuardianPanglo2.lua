--Version 1.0.0
local rotationName = "GuardianPanglo2.0"

---------------
--- Toggles ---
---------------
local function createToggles()
    RotationModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Automatic Rotation",
            tip = "Enables DPS Rotation",
            highlight = 1,
            icon = br.player.spell.swipeBear
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "DPS Rotation Disabled",
            tip = "Disable DPS Rotation",
            highlight = 0,
            icon = br.player.spell.regrowth
        }
    }
    CreateButton("Rotation", 1, 0)

    CooldownModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Cooldowns Automated",
            tip = "Automatic Cooldowns - Boss Detection.",
            highlight = 1,
            icon = br.player.spell.incarnationGuardianOfUrsoc
        },
        [2] = {
            mode = "On",
            value = 1,
            overlay = "Cooldowns Enabled",
            tip = "Cooldowns used regardless of target.",
            highlight = 0,
            icon = br.player.spell.incarnationGuardianOfUrsoc
        },
        [3] = {
            mode = "Off",
            value = 3,
            overlay = "Cooldowns Disabled",
            tip = "No Cooldowns will be used.",
            highlight = 0,
            icon = br.player.spell.incarnationGuardianOfUrsoc
        }
    }
    CreateButton("Cooldown", 2, 0)

    DefensiveModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Defensive Enabled",
            tip = "Includes Defensive Cooldowns.",
            highlight = 1,
            icon = br.player.spell.survivalInstincts
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Defensive Disabled",
            tip = "No Defensives will be used.",
            highlight = 0,
            icon = br.player.spell.survivalInstincts
        }
    }
    CreateButton("Defensive", 3, 0)

    InterruptModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Interrupts Enabled",
            tip = "Includes Basic Interrupts.",
            highlight = 1,
            icon = br.player.spell.skullBash
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Interrupts Disabled",
            tip = "No Interrupts will be used.",
            highlight = 0,
            icon = br.player.spell.skullBash
        }
    }
    CreateButton("Interrupt", 4, 0)

    BristlingFurModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Bristling Fur Enabled",
            tip = "Will use BF",
            highlight = 1,
            icon = br.player.spell.bristlingFur
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Bristling Fur Disabled",
            tip = "Will not use BF",
            highlight = 0,
            icon = br.player.spell.bristlingFur
        }
    }
    CreateButton("BristlingFur", 1, -1)

    IronfurModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Ironfur Enabled",
            tip = "Will use Ironfur",
            highlight = 1,
            icon = br.player.spell.ironfur
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Ironfur Disabled",
            tip = "Will not use Ironfur",
            highlight = 0,
            icon = br.player.spell.ironfur
        }
    }
    CreateButton("Ironfur", 2, -1)

    TauntModes = {
        [1] = {
            mode = "Dun",
            value = 1,
            overlay = "Taunt only in Dungeon",
            tip = "Taunt will be used in dungeons.",
            highlight = 1,
            icon = br.player.spell.growl
        },
        [2] = {
            mode = "All",
            value = 2,
            overlay = "Auto Taunt Enabled",
            tip = "Taunt will be used everywhere.",
            highlight = 0,
            icon = br.player.spell.growl
        },
        [3] = {
            mode = "Off",
            value = 3,
            overlay = "Auto Taunt Disabled",
            tip = "Taunt will not be used.",
            highlight = 0,
            icon = br.player.spell.incapacitatingRoar
        }
    }
    CreateButton("Taunt", 3, -1)

    KittyModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Kitty Deeps",
            tip = "Will use catform",
            highlight = 1,
            icon = br.player.spell.catForm
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Not Kitty Deeps",
            tip = "Will not use catform",
            highlight = 0,
            icon = br.player.spell.catForm
        }
    }
    CreateButton("Kitty", 4, -1)

    WildChargeModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Wild Charge",
            tip = "Will use Charge",
            highlight = 1,
            icon = br.player.spell.wildCharge
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Wild Charge",
            tip = "Will not use wild charge",
            highlight = 0,
            icon = br.player.spell.wildCharge
        }
    }
    CreateButton("WildCharge", 0, -1)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        ----------------------
        --- General Options---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.000")
        br.ui:createCheckbox(section, "Open World", "Use Cat Weaving Regardless of Threat Situation")
        -- Travel Shapeshifts
        br.ui:createCheckbox(section, "Auto Shapeshifts", "|cffD60000IF THIS OPTION DOESNT AUTO SHIFT... HEARTH TO DALARAN... BECAUSE REASONS...")
        br.ui:createCheckbox(section, "Travel Form Auto Shift")
        -- Displacer Beast / Wild Charge
        br.ui:createCheckbox(section, "Wild Charge", "Enables/Disables Auto Charge usage.")
        br.ui:createCheckbox(section, "Auto Maul")
        br.ui:createDropdownWithout(section, "Use Concentrated Flame", { "DPS", "Heal", "Hybrid", "Never" }, 1)
        br.ui:createSpinnerWithout(section, "Concentrated Flame Heal", 70, 10, 90, 5)
        br.ui:createDropdown(section, "Lucid Dreams", { "Always", "CDS" }, 1)
        br.ui:checkSectionState(section)
        -----------------------
        --- Cooldown Options---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createDropdownWithout(section, "Trinkets", { "Always", "When CDs are enabled", "Never" }, 1, "Decide when Trinkets will be used.")
        br.ui:createCheckbox(section, "Racial")
        br.ui:createCheckbox(section, "Incarnation")
        br.ui:checkSectionState(section)
        ------------------------
        --- Defensive Options---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Healthstone/Potion", 60, 0, 100, 5, "Health Percent to Cast At")

        br.ui:createSpinner(section, "Barkskin", 50, 0, 100, 5, "Health Percentage to use at.")

        br.ui:createCheckbox(section, "Frenzied Regeneration", "Enable FR")
        br.ui:createSpinnerWithout(section, "FR - HP Interval (2 Charge)", 65, 0, 100, 5, "Health Interval to use at with 2 charges.")
        br.ui:createSpinnerWithout(section, "FR - HP Interval (1 Charge)", 40, 0, 100, 5, "Health Interval to use at with 1 charge.")
        -- Swiftmend
        br.ui:createSpinner(section, "Swiftmend", 70, 10, 90, 5, "Will use Swiftmend.")
        -- Rejuvenation
        br.ui:createSpinner(section, "Rejuvenation", 70, 10, 90, 5, "Minimum HP to cast.")
        -- Soothe
        br.ui:createCheckbox(section, "Soothe")
        -- Rebirth
        br.ui:createCheckbox(section, "Rebirth")
        br.ui:createDropdownWithout(section, "Rebirth - Target", { "Target", "Mouseover" }, 1, "Target to cast on")
        -- Remove Corruption
        br.ui:createCheckbox(section, "Remove Corruption")
        br.ui:createDropdownWithout(section, "Remove Corruption - Target", { "Player", "Target", "Mouseover" }, 1, "Target to cast on")
        -- Survival Instincts
        br.ui:createSpinner(section, "Survival Instincts", 40, 0, 100, 5, "Health Percent to Cast At")
        -- Anima of Death
        br.ui:createSpinner(section, "Anima of Death", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        ------------------------
        --- Interrupt Options---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createCheckbox(section, "Skull Bash")

        br.ui:createCheckbox(section, "Mighty Bash")

        br.ui:createCheckbox(section, "Incapacitating Roar")

        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "Cast Percent to Cast At")
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

local function runRotation()
    UpdateToggle("Rotation", 0.25)
    UpdateToggle("Cooldown", 0.25)
    UpdateToggle("Defensive", 0.25)
    UpdateToggle("Interrupt", 0.25)
    UpdateToggle("Ironfur", 0.25)
    UpdateToggle("BristlingFur", 0.25)
    UpdateToggle("Kitty", 0.25)
    br.player.ui.mode.bristlingFur = br.data.settings[br.selectedSpec].toggles["BristlingFur"]
    br.player.ui.mode.ironfur = br.data.settings[br.selectedSpec].toggles["Ironfur"]
    br.player.ui.mode.taunt = br.data.settings[br.selectedSpec].toggles["Taunt"]
    br.player.ui.mode.kitty = br.data.settings[br.selectedSpec].toggles["Kitty"]
    br.player.ui.mode.wildCharge = br.data.settings[br.selectedSpec].toggles["WildCharge"]

    local buff = br.player.buff
    local cast = br.player.cast
    local combatTime = getCombatTime()
    local combo = br.player.power.comboPoints.amount()
    local cd = br.player.cd
    local charges = br.player.charges
    local deadtar, attacktar, hastar, playertar = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
    local debuff = br.player.debuff
    local energy, energyRegen, energyDeficit = br.player.power.energy.amount(), br.player.power.energy.regen(), br.player.power.energy.deficit()
    local enemies = br.player.enemies
    local falling, swimming, flying, moving = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player") > 0
    local flaskBuff = getBuffRemain("player", br.player.flask.wod.buff.agilityBig)
    local gcd = br.player.gcdMax
    local hasMouse = GetObjectExists("mouseover")
    local healPot = getHealthPot()
    local inCombat = br.player.inCombat
    local essence = br.player.essence
    local inInstance = br.player.instance == "party"
    local inRaid = br.player.instance == "raid"
    local level = br.player.level
    local lossPercent = getHPLossPercent("player", 5)
    local lowestHP = br.friend[1].unit
    local mode = br.player.ui.mode
    local php = br.player.health
    local playerMouse = UnitIsPlayer("mouseover")
    local rage, ragemax, ragegen, rageDeficit = br.player.power.rage.amount(), br.player.power.rage.max(), br.player.power.rage.regen(), br.player.power.rage.deficit()
    local pullTimer = br.DBM:getPulltimer()
    local racial = br.player.getRacial()
    local solo = br.player.instance == "none"
    local snapLossHP = 0
    local spell = br.player.spell
    local talent = br.player.talent
    local traits = br.player.traits
    local travel, flight, bear, cat, noform = br.player.buff.travelForm.exists(), br.player.buff.flightForm.exists(), br.player.buff.bearForm.exists(), buff.catForm.exists(), GetShapeshiftForm() == 0
    local trinketProc = false
    local ttd = getTTD
    local ttm = br.player.power.rage.ttm
    local units = br.player.units
    local hasAggro = UnitThreatSituation("player")
    if hasAggro == nil then
        hasAggro = 0
    end

    --wipe timers table
    if timersTable then
        wipe(timersTable)
    end

    units.get(5)
    units.get(8)
    units.get(40)
    enemies.get(5)
    enemies.get(8)
    enemies.get(10)
    enemies.get(13)
    enemies.get(20)
    enemies.get(30)
    enemies.get(40)

    if leftCombat == nil then
        leftCombat = GetTime()
    end
    if profileStop == nil then
        profileStop = false
    end
    if lastForm == nil then
        lastForm = 0
    end

    if energy >= 85 then
        cattime = true
    end
    if energy <= 15 then
        cattime = false
    end

    local function KittyWeave()
        if not cat then
            if cast.catForm() then
                return
            end
        end
        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if combo >= 4 and not debuff.rip.exists(thisUnit) and (ttd(thisUnit) > 8 or isDummy(thisUnit)) then
                if cast.rip(thisUnit) then
                    return
                end
            end
        end

        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if combo >= 4 and debuff.rip.exists(thisUnit) or (combo >= 4 and ttd(thisUnit) < 8) then
                if cast.ferociousBite(thisUnit) then
                    return
                end
            end
        end

        if #enemies.yards5 >= 3 or traits.twistedClaws.active then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if (not debuff.thrashBear.exists(thisUnit) or debuff.thrashBear.remain(thisUnit) <= 2) or (not debuff.thrashCat.exists(thisUnit) or debuff.thrashCat.remain(thisUnit) <= 2) then
                    if cast.thrashCat(thisUnit) then
                        return
                    end
                end
            end
        end
        if #enemies.yards5 >= 3 then
            if cast.swipeCat() then
                return
            end
        end
        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if not debuff.rake.exists(thisUnit) or debuff.rake.remain(thisUnit) <= 2 then
                if cast.rake(thisUnit) then
                    return
                end
            end
        end

        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if debuff.rake.exists(thisUnit) then
                if cast.shred() then
                    return
                end
            end
        end
    end

    local function List_Extras()
        if isChecked("Auto Shapeshifts") and not UnitBuffID("player", 202477) then
            -- Flight Form
            if IsFlyableArea() and ((not (isInDraenor() or isInLegion())) or isKnown(191633)) and not swimming and falling > 1 and level >= 58 and isChecked("Travel Form Auto Shift") then
                if cast.travelForm("player") then
                    return
                end
            end
            -- Aquatic Form
            if swimming and not travel and not hastar and not deadtar and isChecked("Travel Form Auto Shift") then
                if cast.travelForm("player") then
                    return
                end
            end
            -- Bear/Travel Form
            if not inCombat and not buff.dash.exists() and not br.player.buff.prowl.exists() then
                if isValidUnit("target") and ((getDistance("target") < 30 and not swimming) or (getDistance("target") < 10 and swimming)) then
                    if not bear then
                        if cast.bearForm("player") then
                            return
                        end
                    end
                elseif not travel and not IsIndoors() and moving and GetTime() - isMovingStartTime > 2 and isChecked("Travel Form Auto Shift") then
                    if cast.travelForm("player") then
                        return
                    end
                elseif not cat and IsIndoors() and moving and GetTime() - isMovingStartTime > 2 then
                    if cast.catForm("player") then
                        return
                    end
                end
            end
            --Bear Form when in combat and not flying
            if inCombat and not flying and not buff.dash.exists() and not bear and not (travel and moving) then
                if cast.bearForm("player") then
                    return
                end
            end
        end -- End Shapeshift Form Management

        if br.player.ui.mode.taunt == 1 and inInstance then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
                    if cast.growl(thisUnit) then
                        return
                    end
                end
            end
        end
        if br.player.ui.mode.taunt == 2 then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
                    if cast.growl(thisUnit) then
                        return
                    end
                end
            end
        end

        if isChecked("Wild Charge") and br.player.ui.mode.wildCharge == 1 then
            if getDistance("target") > 9 and cast.able.wildCharge() and inCombat and bear then
                if cast.wildCharge("target") then
                    return
                end
            end
        end
    end

    local function List_Defensive()
        if useDefensive() then
            if inCombat and isChecked("Lucid Dreams") and getSpellCD(298357) <= gcd and (getOptionValue("Lucid Dreams") == 1 or (getOptionValue("Lucid Dreams") == 2 and useCDs())) then
                if cast.memoryOfLucidDreams("player") then
                    return
                end
            end

            if isChecked("Healthstone/Potion") and php <= getOptionValue("Healthstone/Potion") and inCombat and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
                if canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(healPot) then
                    useItem(healPot)
                elseif hasItem(166799) and canUseItem(166799) then
                    useItem(166799)
                end
            end
            -- Swiftmend
            if isChecked("Swiftmend") and php <= getOptionValue("Swiftmend") and not inCombat and cast.able.swiftmend() then
                if cast.swiftmend("player") then return end
            end
            -- Rejuvenation
            if isChecked("Rejuvenation") and php <= getOptionValue("Rejuvenation") and not buff.rejuvenation.exists("player") and not inCombat and cast.able.rejuvenation() then
                if cast.rejuvenation("player") then return end
            end
            if isChecked("Rebirth") and rage >= 30 then
                if getOptionValue("Rebirth - Target") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") then
                    --Print("Target bois")
                    if cast.rebirth("mouseover", "dead") then
                        return
                    end
                end
                if getOptionValue("Rebirth - Target") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") then
                    --Print("mouse bois bois")
                    if cast.rebirth("mouseover", "dead") then
                        return
                    end
                end
            end

            if isChecked("Barkskin") then
                if php <= getOptionValue("Barkskin") and inCombat then
                    if cast.barkskin() then
                        return
                    end
                end
            end

            if isChecked("Frenzied Regeneration") and cast.able.frenziedRegeneration() and not buff.frenziedRegeneration.exists() and ((charges.frenziedRegeneration.count() >= 2 and php < getOptionValue("FR - HP Interval (2 Charge)")) or (charges.frenziedRegeneration.count() >= 1 and php < getOptionValue("FR - HP Interval (1 Charge)"))) then
                if cast.frenziedRegeneration() then
                    return
                end
            end

            if getOptionValue("Use Concentrated Flame") ~= 1 and php <= getValue("Concentrated Flame Heal") then
                if cast.concentratedFlame("player") then
                    return
                end
            end

            if isChecked("Soothe") then
                for i = 1, #enemies.yards40 do
                    thisUnit = enemies.yards40[i]
                    if canDispel(thisUnit, spell.soothe) then
                        if cast.soothe(thisUnit) then
                            return
                        end
                    end
                end
            end

            if isChecked("Remove Corruption") then
                if getOptionValue("Remove Corruption - Target") == 1 and canDispel("player", spell.removeCorruption) then
                    if cast.removeCorruption("player") then
                        return
                    end
                end
                if getOptionValue("Remove Corruption - Target") == 2 and canDispel("target", spell.removeCorruption) then
                    if cast.removeCorruption("target") then
                        return
                    end
                end
                if getOptionValue("Remove Corruption - Target") == 3 and canDispel("mouseover", spell.removeCorruption) then
                    if cast.removeCorruption("mouseover") then
                        return
                    end
                end
            end

            if isChecked("Survival Instincts") then
                if php <= getOptionValue("Survival Instincts") and inCombat and not buff.survivalInstincts.exists() then
                    if cast.survivalInstincts() then
                        return
                    end
                end
            end
        end
    end

    local function List_Interrupts()
        if useInterrupts() then
            if isChecked("Skull Bash") then
                for i = 1, #enemies.yards13 do
                    thisUnit = enemies.yards13[i]
                    if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                        if cast.skullBash(thisUnit) then
                            return
                        end
                    end
                end
            end
            if isChecked("Mighty Bash") then
                for i = 1, #enemies.yards5 do
                    thisUnit = enemies.yards5[i]
                    if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                        if cast.mightyBash(thisUnit) then
                            return
                        end
                    end
                end
            end
            if isChecked("Incapacitating Roar") and cd.skullBash.exists() then
                for i = 1, #enemies.yards10 do
                    thisUnit = enemies.yards10[i]
                    if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                        if cast.incapacitatingRoar("player") then
                            return
                        end
                    end
                end
            end
        end
    end

    local function List_Cooldowns()
        if useCDs() and getDistance(units.dyn5) < 5 then
            if getOptionValue("Trinkets") == 2 and inCombat then
                if canUseItem(13) then
                    useItem(13)
                end
                if canUseItem(14) then
                    useItem(14)
                end
            end

            if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                if castSpell("player", racial, false, false, false) then
                    return
                end
            end

            if isChecked("Incarnation") then
                if cast.incarnationGuardianOfUrsoc() then
                    return
                end
            end
        end
    end

    local function List_Bearmode()
        if br.player.ui.mode.ironfur == 1 and (hasAggro >= 2) and bear then
            if (traits.layeredMane.active and rage >= 45) or not buff.ironfur.exists() or buff.goryFur.exists() or rage >= 55 or buff.ironfur.remain() < 2 then
                if cast.ironfur() then
                    return
                end
            end
        end

        -- Anima of Death
        if isChecked("Anima of Death") and essence.animaOfDeath.active and cd.animaOfDeath.remain() <= gcd and inCombat and #enemies.yards8 >= 3 and php <= getOptionValue("Anima of Death") then
            if cast.animaOfDeath("player") then
                br.addonDebug("Casting Anima of Death")
                return
            end
        end

        if getOptionValue("Trinkets") == 1 and inCombat then
            if canUseItem(13) then
                useItem(13)
            end
            if canUseItem(14) then
                useItem(14)
            end
        end

        if br.player.ui.mode.bristlingFur == 1 and rage < 40 and (hasAggro >= 2) then
            if cast.bristlingFur() then
                return
            end
        end

        if cast.lunarBeam() then
            return
        end

        if #enemies.yards8 >= 1 and not buff.incarnationGuardianOfUrsoc.exists() or (buff.incarnationGuardianOfUrsoc.exists() and not debuff.thrashBear.exists(thisUnit) or debuff.thrashBear.refresh(thisUnit) and #enemies.yards8 > 6) then
            if cast.thrashBear() then
                return
            end
        end

        if #enemies.yards40 < 7 then
            if cast.mangle() then
                return
            end
        end

        if getOptionValue("Use Concentrated Flame") == 1 or (getOptionValue("Use Concentrated Flame") == 3 and php > getValue("Concentrated Flame Heal")) then
            if cast.concentratedFlame("target") then
                return
            end
        end

        if talent.pulverize then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if debuff.thrashBear.stack(thisUnit) >= 3 then
                    if not buff.pulverize.exists() or (buff.pulverize.exists() and not (cast.able.mangle() or cast.able.thrashBear())) then
                        if cast.pulverize(thisUnit) then
                            return
                        end
                    end
                end
            end
        end

        if #enemies.yards8 < 5 and inCombat then
            if buff.galacticGuardian.exists() then
                if cast.moonfire(thisUnit) then
                    return
                end
            end
            if debuff.moonfire.count() < 3 or buff.galacticGuardian.exists() then
                for i = 1, #enemies.yards8 do
                    local thisUnit = enemies.yards8[i]
                    if UnitAffectingCombat(thisUnit) then
                        if not debuff.moonfire.exists(thisUnit) or debuff.moonfire.refresh(thisUnit) then
                            if cast.moonfire(thisUnit) then
                                return
                            end
                        end

                    end
                end
            end
        end

        if isChecked("Auto Maul") and rageDeficit < 10 and #enemies.yards8 < 4 then
            if cast.maul() then
                return
            end
        end

        if getDistance("target") < 8 and (#enemies.yards5 >= 4 and not cast.able.thrashBear()) or (not buff.galacticGuardian.exists() and not (cast.able.thrashBear() or cast.able.mangle())) then
            if cast.swipeBear() then
                return
            end
        end
    end

    if pause() or (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) or mode.rotation == 2 then
        return
    else
        if talent.feralAffinity and br.player.ui.mode.kitty == 1 and (hasAggro <= 1 or isChecked("Open World")) and cattime then
            if KittyWeave() then
                return
            end
        else
            if List_Extras() then
                return
            end
            if List_Interrupts() then
                return
            end
            if List_Defensive() then
                return
            end
            if List_Cooldowns() then
                return
            end
            if inCombat then
                if List_Bearmode() then
                    return
                end
            end
        end
    end
end --end runrotation

local id = 0
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

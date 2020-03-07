--Version 1.0.0
local rotationName = "ADSpirit"

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

    RemoveCorruptionModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Remove Corruption Enabled",
            tip = "Will use RC",
            highlight = 1,
            icon = br.player.spell.removeCorruption
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Remove Corruption Disabled",
            tip = "Will not use RC",
            highlight = 0,
            icon = br.player.spell.removeCorruption
        }
    }
    CreateButton("RemoveCorruption", 1, -1)

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
    CreateButton("BristlingFur", 5, 0)

    FormsModes = {
        [1] = { 
            mode = "On",
            value = 1,
            overlay = "Auto Forms Enabled",
            tip = "Will change forms",
            highlight = 0, icon = br.player.spell.travelForm 
        },
        [2] = { 
            mode = "Key", 
            value = 2, 
            overlay = "Auto Forms hotkey", 
            tip = "Key triggers Auto Forms", 
            highlight = 0, icon = br.player.spell.travelForm },
        [3] = { 
            mode = "Off", 
            value = 3, 
            overlay = "Auto Forms Disabled", 
            tip = "Will Not change forms", highlight = 0, icon = br.player.spell.travelForm }
    };
    CreateButton("Forms", 5, -1)
    
    MaulModes = {
        [1] = { 
            mode = "On",
            value = 1,
            overlay = "Auto Maul Enabled",
            tip = "Will use Maul",
            highlight = 1, icon = br.player.spell.maul 
        },
        [2] = { 
            mode = "Off", 
            value = 2, 
            overlay = "Auto Maul Disabled", 
            tip = "Will not use Maul", 
            highlight = 0, icon = br.player.spell.maul }
    };
    CreateButton("Maul", 4, -1)
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
        -- Travel Shapeshifts
        br.ui:createDropdownWithout(section, "Cat Key", br.dropOptions.Toggle, 6, "Set a key for cat")
        br.ui:createDropdownWithout(section, "Travel Key", br.dropOptions.Toggle, 6, "Set a key for travel")
        br.ui:createCheckbox(section, "Auto Engage On Target", "Cast Moonfire on target OOC to engage in combat")
        br.ui:createCheckbox(section, "Auto Stealth in Cat Form", 1)
        br.ui:createCheckbox(section, "Auto Dash in Cat Form", 1)
        br.ui:createSpinner(section, "Standing Time", 2.5, 0.5, 10, 0.5, "How long you will stand still before changing to owl - in seconds")
        -- Wild Charge
        br.ui:createCheckbox(section, "Wild Charge", "Enables/Disables Auto Charge usage.")
        -- Auto Maul
        br.ui:createCheckbox(section, "Auto Maul", "Works when Ironfur toggle is OFF or Rage Generation is HIGH")
        -- Max Moonfire Targets
        br.ui:createSpinnerWithout(section, "Max Moonfire Targets", 5, 1, 10, 1, "|cff0070deSet to maximum number of targets to dot with Moonfire. Min: 1 / Max: 10 / Interval: 1")
        -- FH Pig Helper
        br.ui:createCheckbox(section, "Freehold - Pig")
        br.ui:checkSectionState(section)
        -- Corruption
        section = br.ui:createSection(br.ui.window.profile, "Corruption")
        br.ui:createDropdownWithout(section, "Use Cloak", { "snare", "Eye", "THING", "Everything", "never" }, 5, "", "")
        br.ui:createSpinnerWithout(section, "Eye Stacks", 3, 1, 10, 1, "How many stacks before using cloak")
        br.ui:checkSectionState(section)
        -- Essences
        section = br.ui:createSection(br.ui.window.profile, "Essences")
        br.ui:createDropdownWithout(section, "Use Concentrated Flame", { "DPS", "Heal", "Hybrid", "Never" }, 1)
        br.ui:createSpinnerWithout(section, "Concentrated Flame Heal", 70, 10, 90, 5)
        br.ui:createDropdown(section, "Lucid Dreams", { "Always", "CDS" }, 1)
        br.ui:createSpinner(section, "Anima of Death", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -----------------------
        --- Cooldown Options---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createCheckbox(section, "Racial")
        -- Trinkets
        br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use trinkets.")
        br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")               
        br.ui:checkSectionState(section)
        -- Radar
        section = br.ui:createSection(br.ui.window.profile, "Radar")
        br.ui:createCheckbox(section, "All - Root the thing")
        br.ui:createCheckbox(section, "FH - Root grenadier")
        br.ui:createCheckbox(section, "AD - Root Spirit of Gold")
        br.ui:createCheckbox(section, "KR - Root Minions of Zul")
        br.ui:createCheckbox(section, "KR - Animated gold")
        br.ui:checkSectionState(section)
        ------------------------
        --- Defensive Options---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Healthstone/Potion", 60, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Ironfur (No Aggro)", 85, 0, 100, 5, "Use Ironfur on Adds/Bosses you can't aggro such as Carapace of N'Zoth if below %hp")
        br.ui:createSpinner(section, "Incarnation", 50, 0, 100, 5, "Use Incarnation when below %hp")        
        br.ui:createCheckbox(section, "Spam Mangle during Incarnation", "Generate more Rage")
        br.ui:createCheckbox(section, "Spam Thrash during Incarnation", "Will use Mangle when Gore buff exists")
        br.ui:createSpinner(section, "Barkskin", 50, 0, 100, 5, "Health Percentage to use at.")
        br.ui:createCheckbox(section, "Frenzied Regeneration", "Enable FR")
        br.ui:createSpinnerWithout(section, "FR - HP Interval (2 Charge)", 65, 0, 100, 5, "Health Interval to use at with 2 charges.")
        br.ui:createSpinnerWithout(section, "FR - HP Interval (1 Charge)", 40, 0, 100, 5, "Health Interval to use at with 1 charge.")
        -- Swiftmend
        br.ui:createSpinner(section, "OOC Swiftmend", 70, 10, 90, 5, "Will use Swiftmend Out of Combat.")
        -- Rejuvenation
        br.ui:createSpinner(section, "OOC Rejuvenation", 70, 10, 90, 5, "Minimum HP to cast Out of Combat.")
        -- Regrowth
        br.ui:createSpinner(section, "OOC Regrowth", 70, 10, 90, 5, "Minimum HP to cast Out of Combat.")
        -- Soothe
        br.ui:createCheckbox(section, "Auto Soothe")
        -- Rebirth
        br.ui:createCheckbox(section, "Rebirth")
        br.ui:createDropdownWithout(section, "Rebirth - Target", { "Target", "Mouseover" }, 1, "Target to cast on")
        -- Remove Corruption
        br.ui:createCheckbox(section, "Remove Corruption")
        br.ui:createDropdownWithout(section, "Remove Corruption - Target", { "Player", "Target", "Mouseover" }, 1, "Target to cast on")
        -- Survival Instincts
        br.ui:createSpinner(section, "Survival Instincts", 40, 0, 100, 5, "Health Percent to Cast At")
        br.ui:checkSectionState(section)
        ------------------------
        --- Interrupt Options---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createCheckbox(section, "Skull Bash")
        br.ui:createCheckbox(section, "Mighty Bash")
        br.ui:createCheckbox(section, "Incapacitating Roar")
        br.ui:createCheckbox(section, "Incapacitating Roar Logic (M+)")
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
    UpdateToggle("RemoveCorruption", 0.25)
    UpdateToggle("BristlingFur", 0.25)
    UpdateToggle("Forms", 0.25)
    UpdateToggle("Maul", 0.25)
    br.player.mode.removeCorruption = br.data.settings[br.selectedSpec].toggles["RemoveCorruption"]
    br.player.mode.bristlingFur = br.data.settings[br.selectedSpec].toggles["BristlingFur"]
    br.player.mode.ironfur = br.data.settings[br.selectedSpec].toggles["Ironfur"]
    br.player.mode.taunt = br.data.settings[br.selectedSpec].toggles["Taunt"]
    br.player.mode.forms = br.data.settings[br.selectedSpec].toggles["Forms"]
    br.player.mode.maul = br.data.settings[br.selectedSpec].toggles["Maul"]
    br.player.mode.wildCharge = br.data.settings[br.selectedSpec].toggles["WildCharge"]

    local buff = br.player.buff
    local cast = br.player.cast
    local cat = br.player.buff.catForm.exists()
    local catspeed = br.player.buff.dash.exists() or br.player.buff.tigerDash.exists()
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
    local lowest = br.friend[1]
    local mode = br.player.mode
    local moving = isMoving("player")
    local swimming = IsSwimming()
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
    local use = br.player.use
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

    local Incap_unitList = {
        [131009] = "Spirit of Gold",
        [134388] = "A Knot of Snakes",
        [129758] = "Irontide Grenadier"
    }

    local function List_Extras()
        if mode.forms == 2 then
            if not bear then
                if cast.bearForm("player") then
                    return true
                end
            end
        end
        -- Shapeshift Form Management
            local standingTime = 0
            if DontMoveStartTime then
                standingTime = GetTime() - DontMoveStartTime
            end

            if mode.forms == 1 then
                if isChecked("Standing Time") and not travel and not cat and not buff.prowl.exists() and noform and not IsIndoors() then
                    if standingTime > getOptionValue("Standing Time") then
                        if cast.travelForm("player") then
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
                if not inCombat and not swimming and br.player.level >= 58 and not buff.prowl.exists() and not catspeed and not travel and not IsIndoors() and IsMovingTime(1) then
                    if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                        RunMacroText("/CancelForm")
                        CastSpellByID(783, "player")
                        return true
                    else
                        CastSpellByID(783, "player")
                        return true
                    end
                end
                -- Cat Form
                if not inCombat and not cat and not IsMounted() and not flying and IsIndoors() then
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

        if br.player.mode.taunt == 1 and inInstance then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
                    if cast.growl(thisUnit) then
                        return
                    end
                end
            end
        end
        if br.player.mode.taunt == 2 then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
                    if cast.growl(thisUnit) then
                        return
                    end
                end
            end
        end

        if isChecked("Wild Charge") and br.player.mode.wildCharge == 1 then
            if getDistance("target") > 9 and cast.able.wildCharge() and inCombat and bear then
                if cast.wildCharge("target") then
                    return
                end
            end
        end
        if not inCombat and isChecked("Auto Engage On Target") and debuff.moonfire.count() < getOptionValue("Max Moonfire Targets") and not debuff.moonfire.exists() and solo and isValidTarget("target") and (UnitIsEnemy("target","player")) then
            if cast.moonfire() then
                return true
            end
        end
        if isChecked("Auto Dash in Cat Form") and not catspeed and cat then
            if cast.tigerDash() then
                return true
            end
            if cast.dash() then
                return true
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
        end
        if isChecked("Auto Dash in Cat Form") and not catspeed then
            if cast.tigerDash() then
                return true
            end
            if cast.dash() then
                return true
            end
        end
        if isChecked("Auto Stealth in Cat Form") and not inCombat and cat then
            if not br.player.buff.prowl.exists() then
                if cast.prowl("Player") then
                    return true
                end
            end
        end

        if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus() then
            return
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
            if isChecked("OOC Swiftmend") and php <= getOptionValue("OOC Swiftmend") and not inCombat and cast.able.swiftmend() then
                if cast.swiftmend("player") then return end
            end
            -- Rejuvenation
            if isChecked("OOC Rejuvenation") and php <= getOptionValue("OOC Rejuvenation") and not buff.rejuvenation.exists("player") and not inCombat and cast.able.rejuvenation() then
                if cast.rejuvenation("player") then return end
            end
            -- Regrowth
            if isChecked("OOC Regrowth") and not moving and php <= getOptionValue("OOC Regrowth") and not inCombat then
                if cast.regrowth("player") then return end
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
                if php <= getOptionValue("Barkskin") and inCombat and not buff.survivalInstincts.exists() then
                    if cast.barkskin() then
                        return
                    end
                end
            end

            if isChecked("Incarnation") and php <= getOptionValue("Incarnation") then
                if cast.incarnationGuardianOfUrsoc() then
                    return
                end
            end

            if isChecked("Frenzied Regeneration") and cast.able.frenziedRegeneration() and not buff.frenziedRegeneration.exists() and ((charges.frenziedRegeneration.count() >= 2 and php < getOptionValue("FR - HP Interval (2 Charge)")) or (charges.frenziedRegeneration.count() >= 1 and php < getOptionValue("FR - HP Interval (1 Charge)"))) then
                if cast.frenziedRegeneration() then
                    return
                end
            end

            if inCombat and getOptionValue("Use Concentrated Flame") ~= 1 and php <= getValue("Concentrated Flame Heal") then
                if cast.concentratedFlame("player") then
                    return
                end
            end

            if isChecked("Auto Soothe") then
                for i = 1, #enemies.yards40 do
                    thisUnit = enemies.yards40[i]
                    if canDispel(thisUnit, spell.soothe) then
                        if cast.soothe(thisUnit) then
                            return
                        end
                    end
                end
            end

            if br.player.mode.removeCorruption == 1 and isChecked("Remove Corruption") then
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
                if php <= getOptionValue("Survival Instincts") and inCombat and not buff.survivalInstincts.exists() and not buff.barkskin.exists() then
                    if cast.survivalInstincts() then
                        return
                    end
                end
            end
        end
    end

    local function List_Interrupts()
        if useInterrupts() then
            if isChecked("Incapacitating Roar Logic (M+)") then
                if cast.able.incapacitatingRoar() then
                    local Incap_list = {
                        274400,
                        274383,
                        257756,
                        276292,
                        268273,
                        256897,
                        272542,
                        272888,
                        269266,
                        258317,
                        258864,
                        259711,
                        258917,
                        264038,
                        253239,
                        269931,
                        270084,
                        270482,
                        270506,
                        270507,
                        267433,
                        267354,
                        268702,
                        268846,
                        268865,
                        258908,
                        264574,
                        272659,
                        272655,
                        267237,
                        265568,
                        277567,
                        265540,
                        268202,
                        258058,
                        257739
                    }
                    for i = 1, #enemies.yards10 do
                        local thisUnit = enemies.yards10[i]
                        local distance = getDistance(thisUnit)
                        for k, v in pairs(Incap_list) do
                            if (Incap_unitList[GetObjectID(thisUnit)] ~= nil or UnitCastingInfo(thisUnit) == GetSpellInfo(v) or UnitChannelInfo(thisUnit) == GetSpellInfo(v)) and getBuffRemain(thisUnit, 226510) == 0 and distance <= 20 then
                                if cast.incapacitatingRoar(thisUnit) then
                                    return
                                end
                                if br.player.race == "Tauren" and not moving then
                                    if castSpell("player", racial, false, false, false) then
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            end

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
        -- Trinkets
            if (getOptionValue("Trinkets") == 1 or (getOptionValue("Trinkets") == 2 and useCDs())) and inCombat then
                if php <= getOptionValue("Trinket 1") and use.able.slot(13) then
                    use.slot(13)
                end
                elseif php <= getOptionValue("Trinket 2") and use.able.slot(14) then
                    use.slot(14)
                end
                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                    if castSpell("player", racial, false, false, false) then
                        return
                    end
                end
            end

    local function List_Bearmode()
        if mode.forms ~= 3 then
            if not br.player.buff.bearForm.exists() and not buff.prowl.exists() and not cast.last.bearForm(1) and inCombat and not flying then
                if cast.bearForm() then
                    return true
                end
            end
        end
        local radar = "off"

        --Building root list
        local root_UnitList = {}
        if isChecked("KR - Root Minions of Zul") then
            root_UnitList[133943] = "minion-of-zul"
            radar = "on"
        end
        if isChecked("All - Root the thing") then
            root_UnitList[161895] = "the thing from beyond"
            radar = "on"
        end
        if isChecked("FH - Root grenadier") then
            root_UnitList[129758] = "grenadier"
            radar = "on"
        end
        if isChecked("KR - Root Spirit of Gold") then
            root_UnitList[131009] = "the thing from beyond"
            radar = "on"
        end
        if isChecked("KR - Animated gold") then
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
                local root_range = 30
            end

            for i = 1, GetObjectCount() do
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
                    if distance < root_range and not isLongTimeCCed(object) then
                        CastSpellByName(root, object)
                    end
                -- Corruption stuff
                -- 1 = snare  2 = eye  3 = thing 4 = reverything = 5 = never   -- snare = 315176
                    if br.player.equiped.shroudOfResolve and not debuff.massEntanglement.exists(object) and canUseItem(br.player.items.shroudOfResolve) and br.timer:useTimer("Cloak Delay", 2)then
                        if getValue("Use Cloak") == 1 and debuff.graspingTendrils.exists("player")
                                or getValue("Use Cloak") == 2 and debuff.eyeOfCorruption.stack("player") >= getValue("Eye Stacks")
                                or getValue("Use Cloak") == 3 and debuff.grandDelusions.exists("player")
                                or getValue("Use Cloak") == 4 and (debuff.graspingTendrils.exists("player") and debuff.eyeOfCorruption.stack("player") >= getValue("Eye Stacks"))
                        then
                            if br.player.use.shroudOfResolve() then
                                br.addonDebug("Using shroudOfResolve")
                            end
                        end
                    end
                end
            end -- end root
        end -- end radar

        if br.player.mode.ironfur == 1 and (hasAggro >= 2) and bear and inCombat then
            if (traits.layeredMane.active and rage >= 45) or not buff.ironfur.exists() or buff.goryFur.exists() or rage >= 55 or buff.ironfur.remain() < 2 then
                if cast.ironfur() then
                    return
                end
            end
        end

        if isChecked("Ironfur (No Aggro)") and not (hasAggro >=1) and bear and php <= getOptionValue("Ironfur (No Aggro)") and inCombat then
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

        if br.player.mode.bristlingFur == 1 and rage < 40 and (hasAggro >= 2) then
            if cast.bristlingFur() then
                return
            end
        end

        if cast.lunarBeam() then
            return
        end

        if #enemies.yards8 < 5 and inCombat then
            if buff.galacticGuardian.exists() then
                if cast.moonfire(thisUnit) then
                    return
                end
            end
            if buff.ironfur.exists() and debuff.moonfire.count() < getOptionValue("Max Moonfire Targets") or buff.galacticGuardian.exists() then
                for i = 1, #enemies.yards8 do
                    local thisUnit = enemies.yards8[i]
                    if UnitAffectingCombat(thisUnit) then
                        if (buff.incarnationGuardianOfUrsoc.exists() or not buff.incarnationGuardianOfUrsoc.exists()) and not debuff.moonfire.exists(thisUnit) or debuff.moonfire.refresh(thisUnit) then
                            if cast.moonfire(thisUnit) then
                                return
                            end
                        end

                    end
                end
            end
        end

        if br.player.mode.maul == 1 and isChecked("Auto Maul") and rageDeficit < 10 and #enemies.yards8 < 4 and (buff.incarnationGuardianOfUrsoc.exists() or not buff.incarnationGuardianOfUrsoc.exists()) then
            if cast.maul() then
                return
            end
        end

        if cast.able.mangle() and #enemies.yards5 < 7 and (not buff.incarnationGuardianOfUrsoc.exists() or buff.gore.exists()) then
            if cast.mangle() then
                return
            end
        end

        if cast.able.thrashBear("player") and #enemies.yards8 >=1 and not buff.incarnationGuardianOfUrsoc.exists() or (buff.incarnationGuardianOfUrsoc.exists() and not debuff.thrashBear.exists(thisUnit) or debuff.thrashBear.refresh(thisUnit)) then
            if cast.thrashBear("player") then
                return
            end
        end

        if isChecked("Spam Mangle during Incarnation") and cast.able.mangle() and #enemies.yards5 < 7 and buff.incarnationGuardianOfUrsoc.exists() then
            if cast.mangle() then
                return
            end    
        end

        if isChecked("Spam Thrash during Incarnation") and cast.able.thrashBear("player") and #enemies.yards8 >=1 and buff.incarnationGuardianOfUrsoc.exists() then
            if cast.thrashBear("player") then
                return
            end
        end

        if inCombat and getOptionValue("Use Concentrated Flame") == 1 or (getOptionValue("Use Concentrated Flame") == 3 and php > getValue("Concentrated Flame Heal")) then
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

        if getDistance("target") < 8 and (#enemies.yards5 >= 4 and not cast.able.thrashBear()) or (not buff.galacticGuardian.exists() and not (cast.able.thrashBear() or cast.able.mangle())) then
            if cast.swipeBear() then
                return
            end
        end
    end

    -----------------
    --- Rotations ---
    -----------------
    -- Pause
    if not IsMounted() or mode.rotation == 2 then
        -- br.player.buff.travelForm.exists() or br.player.buff.flightForm.exists())
        if pause() or drinking or mode.rotation == 2 then
            return true
        else

            ---------------------------------
            --- Out Of Combat - Rotations ---
            ---------------------------------````````````````````````````````````````````
            if not inCombat and not UnitBuffID("player", 115834) then
                if mode.forms == 1 then
                    if not inCombat and not buff.dash.exists() and not br.player.buff.prowl.exists() then
                        if #enemies.yards20 >= 1 and moving and isValidUnit("target") and ((getDistance("target") < 30 and not swimming) or (getDistance("target") < 10 and swimming)) then
                            if not bear then
                                if cast.bearForm("player") then
                                    return
                                end
                            end
                        end
                    end
                end
                if mode.forms == 2 then
                    if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus() then
                        cat_form()
                        return true
                    elseif SpecificToggle("Travel Key") and not GetCurrentKeyBoardFocus() then
                        travel_form()
                        return true
                    end
                end

                if List_Extras() then
                    return true
                end
                if List_Defensive() then
                        return true
                end
                if List_Bearmode() then
                    return true
                end
                if isChecked("Freehold - pig") and GetMinimapZoneText() == "Ring of Booty" then
                    bossHelper()
                end

            end -- End Out of Combat Rotation
            -----------------------------
            --- In Combat - Rotations ---
            -----------------------------
            if inCombat and not UnitBuffID("player", 115834) then
                if mode.forms == 1 then
                    if isValidUnit("target") and (getDistance("target") < 30) and not bear then
                            if cast.bearForm("player") then
                                return true
                            end
                    end
                end
                if mode.forms == 2 then
                    if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus() then
                        cat_form()
                        return true
                    elseif SpecificToggle("Travel Key") and not GetCurrentKeyBoardFocus() then
                        travel_form()
                        return true
                    end
                end
                if List_Extras() then
                    return true
                end
                if List_Interrupts() then
                        return true
                end
                if List_Defensive() then
                        return true
                end
                if List_Cooldowns() then
                    return
                end
                if List_Bearmode() then
                        return true
                end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation

local id = 104
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

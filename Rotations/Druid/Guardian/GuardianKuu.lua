local rotationName = "Kuu"

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
    CreateButton("Ironfur", 1, -1)

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
    CreateButton("Taunt", 2, -1)
    
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
    CreateButton("BristlingFur", 0, -1)

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
    CreateButton("Forms", 3, -1)
    
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
        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.010")
        -- Travel Shapeshifts
        br.ui:createDropdownWithout(section, "Cat Key", br.dropOptions.Toggle, 6, "Set a key for cat")
        br.ui:createDropdownWithout(section, "Travel Key", br.dropOptions.Toggle, 6, "Set a key for travel")
        br.ui:createDropdown(section,"Big Hit Oh Shit!", br.dropOptions.Toggle, 6, "Hold down key to use defensives for large hits")
        br.ui:createCheckbox(section, "Feral Affinity", "Check if you want to dps in cat form |cffFF0000 SUPPORTS CAT KEY ONLY")
        br.ui:createCheckbox(section, "Auto Engage On Target", "Cast Moonfire on target OOC to engage in combat")
        br.ui:createCheckbox(section, "Auto Stealth in Cat Form", 1)
        br.ui:createCheckbox(section, "Auto Dash in Cat Form", 1)
        br.ui:createSpinner(section, "Standing Time", 2.5, 0.5, 10, 0.5, "How long you will stand still before changing to owl - in seconds")
        -- Wild Charge
        br.ui:createCheckbox(section, "Wild Charge", "Enables/Disables Auto Charge usage.")
        -- Max Moonfire Targets
        br.ui:createSpinnerWithout(section, "Max Moonfire Targets", 3, 1, 10, 1, "|cff0070deSet to maximum number of targets to dot with Moonfire. Min: 1 / Max: 10 / Interval: 1")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Covenants")
        br.ui:createCheckbox(section, "Use Covenant")
        br.ui:checkSectionState(section)
        -----------------------
        --- Cooldown Options---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createCheckbox(section, "Racial")
        -- Trinkets
        br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "", "Minimum Trinket 1 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 1 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround" }, 1, "", "")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 2 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround" }, 1, "", "")              
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
        -- Survival Instincts
        br.ui:createSpinner(section, "Survival Instincts", 40, 0, 100, 5, "Health Percent to Cast At")
        -- Ironfur
        br.ui:createSpinner(section, "Ironfur (No Aggro)", 85, 0, 100, 5, "Use Ironfur on Adds/Bosses you can't aggro such as Carapace of N'Zoth if below %hp")
        --Incarnation/Berserk
        br.ui:createSpinner(section, "Incarnation/Berserk", 50, 0, 100, 5, "Use Incarnation/Berserk when below %hp")             
        --Barkskin
        br.ui:createSpinner(section, "Barkskin", 50, 0, 100, 5, "Health Percentage to use at.")
        -- Frenzied Regen
        br.ui:createCheckbox(section, "Frenzied Regeneration", "Enable FR")
        br.ui:createSpinnerWithout(section, "FR - HP Interval (2 Charge)", 65, 0, 100, 5, "Health Interval to use at with 2 charges.")
        br.ui:createSpinnerWithout(section, "FR - HP Interval (1 Charge)", 40, 0, 100, 5, "Health Interval to use at with 1 charge.")
        -- Swiftmend
        br.ui:createSpinner(section, "OOC Swiftmend", 70, 10, 90, 5, "Will use Swiftmend Out of Combat.")
        -- Rejuvenation
        br.ui:createSpinner(section, "OOC Rejuvenation", 70, 10, 90, 5, "Minimum HP to cast Out of Combat.")
        -- Regrowth
        br.ui:createSpinner(section, "OOC Regrowth", 70, 10, 90, 5, "Minimum HP to cast Out of Combat.")
        -- Wild Growth
        br.ui:createSpinner(section, "OOC Wild Growth", 70, 10, 90, 5, "Mninimum HP to cast Out of Combat.")
        br.ui:createSpinnerWithout(section, "Friendly Targets", 4, 1, 5, 1, "Number of friendly targets below set HP to cast Wild Growth.")
        -- Soothe
        br.ui:createCheckbox(section, "Auto Soothe")
        -- Revive
		br.ui:createDropdown(section, "Revive", {"|cffFFFF00Selected Target", "|cffFF0000Mouseover Target","|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")
        -- Rebirth
        br.ui:createDropdown(
			section,
			"Rebirth",
			{
				"|cffFFFFFFTarget",
				"|cffFFFFFFMouseover",
				"|cffFFFFFFTank",
				"|cffFFFFFFHealer",
				"|cffFFFFFFHealer/Tank",
				"|cffFFFFFFAny"
			},
			1,
			"|cffFFFFFFTarget to cast on"
		)
        -- Remove Corruption
        br.ui:createCheckbox(section, "Remove Corruption")
        br.ui:createDropdownWithout(section, "Remove Corruption - Target", { "Player", "Target", "Mouseover" }, 1, "Target to cast on")
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
    br.player.ui.mode.bristlingFur = br.data.settings[br.selectedSpec].toggles["BristlingFur"]
    br.player.ui.mode.ironfur = br.data.settings[br.selectedSpec].toggles["Ironfur"]
    br.player.ui.mode.taunt = br.data.settings[br.selectedSpec].toggles["Taunt"]
    br.player.ui.mode.forms = br.data.settings[br.selectedSpec].toggles["Forms"]

    local buff = br.player.buff
    local cast = br.player.cast
    local cat = br.player.buff.catForm.exists()
    local catspeed = br.player.buff.dash.exists() or br.player.buff.tigerDash.exists()
    local combatTime = getCombatTime()
    local combo = br.player.power.comboPoints.amount()
    local cd = br.player.cd
    local charges = br.player.charges
    local conduit = br.player.conduit
    local covenant                                      = br.player.covenant
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
    local mode = br.player.ui.mode
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
    local ui = br.player.ui
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
    enemies.get(8,"target")
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
            if ui.checked("Standing Time") and not travel and not cat and not buff.prowl.exists() and noform and not IsIndoors() then
                if standingTime > ui.value("Standing Time") then
                    if cast.travelForm("player") then
                        return true
                    end
                end
            end

            -- Flight Form
            if not inCombat and canFly() and not swimming and br.fallDist > 90 --[[falling > ui.value("Fall Timer")]] and br.player.level >= 58 and not buff.prowl.exists() then
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
                    --falling > ui.value("Fall Timer") then
                    if cast.catForm("player") then
                        return true

                    end
                end
            end
        end -- End Shapeshift Form Management

        if ui.checked("Revive") and not inCombat and not isMoving("player") and br.timer:useTimer("Resurrect", 4) then
            if ui.value("Revive") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player") then
                if cast.revive("target", "dead") then
                    br.addonDebug("Casting Revive")
                    return true
                end
            end
            if ui.value("Revive") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player") then
                if cast.revive("mouseover", "dead") then
                    br.addonDebug("Casting Revive")
                    return true
                end
            end
            if ui.value("Revive") == 3 then
                for i =1, #br.friend do
                    if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) then
                        if cast.revive(br.friend[i].unit,"dead") then br.addonDebug("Casting Revive (Auto)") return true end
                    end
                end
            end
        end
        if ui.checked("Auto Dash in Cat Form") and not catspeed and cat and not inCombat then
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
        if ui.checked("Auto Dash in Cat Form") and not catspeed then
            if cast.tigerDash() then
                return true
            end
            if cast.dash() then
                return true
            end
        end
        if ui.checked("Auto Stealth in Cat Form") and not inCombat and cat then
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

    local function actionList_OOC()
        -- Swiftmend
        if ui.checked("OOC Swiftmend") and php <= ui.value("OOC Swiftmend") and not inCombat and cast.able.swiftmend() then
            if cast.swiftmend("player") then return end
        end
        -- Rejuvenation
        if ui.checked("OOC Rejuvenation") and php <= ui.value("OOC Rejuvenation") and not buff.rejuvenation.exists("player") and not inCombat and cast.able.rejuvenation() then
            if cast.rejuvenation("player") then return end
        end
        -- Regrowth
        if ui.checked("OOC Regrowth") and not moving and php <= ui.value("OOC Regrowth") and not inCombat then
            if cast.regrowth("player") then return end
        end
        -- Wild Growth
        if ui.checked("OOC Wild Growth") and not moving then
            for i = 1, #br.friend do
                if UnitInRange(br.friend[i].unit) then
                    local lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit, 30, ui.value("OOC Wild Growth"), #br.friend)
                    if (#lowHealthCandidates >= ui.value("Friendly Targets")) and not moving then
                        if cast.wildGrowth(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            end
        end
        if ui.checked("Auto Engage On Target") and debuff.moonfire.count() < ui.value("Max Moonfire Targets") and not debuff.moonfire.exists() and solo and isValidTarget("target") and (UnitIsEnemy("target","player")) then
            if cast.moonfire() then
                return true
            end
        end
    end

    local function actionList_BigHit()
        -- Trinkets
        if ui.checked("Trinket 1") and canTrinket(13) and not hasEquiped(165569,13) and not hasEquiped(160649,13) and not hasEquiped(158320,13) and not hasEquiped(169314,13) then
            if ui.value("Trinket 1 Mode") == 1 then
                if getLowAllies(ui.value("Trinket 1")) >= ui.value("Min Trinket 1 Targets") or burst == true then
                    useItem(13)
                    br.addonDebug("Using Trinket 1")
                    return true
                end
                elseif ui.value("Trinket 1 Mode") == 2 then
                    if (lowest.hp <= ui.value("Trinket 1") or burst == true) and lowest.hp ~= 250 then
                    UseItemByName(GetInventoryItemID("player", 13), lowest.unit)
                    br.addonDebug("Using Trinket 1 (Target)")
                    return true
                    end
                elseif ui.value("Trinket 1 Mode") == 3 and #tanks > 0 then
                    for i = 1, #tanks do
                        -- get the tank's target
                        local tankTarget = UnitTarget(tanks[i].unit)
                        if tankTarget ~= nil then
                        -- get players in melee range of tank's target
                        local meleeFriends = getAllies(tankTarget, 5)
                        -- get the best ground circle to encompass the most of them
                        local loc = nil
                        if #meleeFriends < 12 then
                            loc = getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                        else
                            local meleeHurt = {}
                            for j = 1, #meleeFriends do
                            if meleeFriends[j].hp < ui.value("Trinket 1") then
                                tinsert(meleeHurt, meleeFriends[j])
                            end
                            end
                            if #meleeHurt >= ui.value("Min Trinket 1 Targets") or burst == true then
                            loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                            end
                        end
                        if loc ~= nil then
                            useItem(13)
                            br.addonDebug("Using Trinket 1 (Ground)")
                            local px,py,pz = ObjectPosition("player")
                            loc.z = select(3,TraceLine(loc.x, loc.y, loc.z+5, loc.x, loc.y, loc.z-5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
                            if loc.z ~= nil and TraceLine(px, py, pz+2, loc.x, loc.y, loc.z+1, 0x100010) == nil and TraceLine(loc.x, loc.y, loc.z+4, loc.x, loc.y, loc.z, 0x1) == nil then -- Check z and LoS, ignore terrain and m2 collisions
                                ClickPosition(loc.x, loc.y, loc.z)
                                return true
                            end
                        end
                    end
                end
            end
        end
        if ui.checked("Trinket 2") and canTrinket(14) and not hasEquiped(165569,14) and not hasEquiped(160649,14) and not hasEquiped(158320,14) and not hasEquiped(169314,13) then
            if ui.value("Trinket 2 Mode") == 1 then
                if getLowAllies(ui.value("Trinket 2")) >= ui.value("Min Trinket 2 Targets") or burst == true then
                    useItem(14)
                    br.addonDebug("Using Trinket 2")
                    return true
                end
                elseif ui.value("Trinket 2 Mode") == 2 then
                    if (lowest.hp <= ui.value("Trinket 2") or burst == true) and lowest.hp ~= 250 then
                    UseItemByName(GetInventoryItemID("player", 14), lowest.unit)
                    br.addonDebug("Using Trinket 2 (Target)")
                    return true
                    end
                elseif ui.value("Trinket 2 Mode") == 3 and #tanks > 0 then
                    for i = 1, #tanks do
                        -- get the tank's target
                        local tankTarget = UnitTarget(tanks[i].unit)
                        if tankTarget ~= nil then
                        -- get players in melee range of tank's target
                        local meleeFriends = getAllies(tankTarget, 5)
                        -- get the best ground circle to encompass the most of them
                        local loc = nil
                        if #meleeFriends < 12  then
                            loc = getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                        else
                            local meleeHurt = {}
                            for j = 1, #meleeFriends do
                            if meleeFriends[j].hp < ui.value("Trinket 2") then
                                tinsert(meleeHurt, meleeFriends[j])
                            end
                            end
                            if #meleeHurt >= ui.value("Min Trinket 2 Targets") or burst == true then
                            loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                            end
                        end
                        if loc ~= nil then
                            useItem(14)
                            br.addonDebug("Using Trinket 2 (Ground)")
                            ClickPosition(loc.x, loc.y, loc.z)
                            return true
                        end
                    end
                end
            end
        end
        -- Berserk
        if not talent.incarnationGuardianOfUrsoc and #enemies.yards8t >= 2 then
            if cast.berserk() then br.addonDebug("Casting Berserk (Big Hit)") return end
        end
        -- Incarnation: Guardian of Ursoc
        if talent.incarnationGuardianOfUrsoc and #enemies.yards8t >= 2 then
            if cast.incarnationGuardianOfUrsoc() then br.addonDebug("Casting Incarnation: Guardian Of Ursoc (Big Hit)") return end
        end
        -- Survival Instincts 
        if php < 35 then
            if cast.survivalInstincts() then br.addonDebug("Casting Survival Instincts (Big Hit)") return end
        end
        -- Barkskin
        if not buff.survivalInstincts.exists() and buff.ironfur.stack() < 2 then
            if cast.barkskin() then br.addonDebug("Casting Barkskin (Big Hit)") return end
        end
        -- Ironfur
        if buff.ironfur.remain() < 1.5 and not buff.survivalInstincts.exists() and not buff.barkskin.exists() then
            if cast.ironfur() then br.addonDebug("Casting Ironfur (Big Hit IF Expiring)") return end
        end
        -- Ironfur
        if php < 50 then
            if cast.ironfur() then br.addonDebug("Casting Ironfur (Big Hit < 50% HP)") return end
        end
        -- Bristling Fur
        if talent.bristlingFur and not buff.survivalInstincts.exists() and not buff.barkskin.exists() then
            if cast.bristlingFur() then br.addonDebug("Casting Bristling Fur (Big Hit)") return end
        end

    end

    local function List_Defensive()
        if useDefensive() then
            if ui.checked("Healthstone/Potion") and php <= ui.value("Healthstone/Potion") and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
                if canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(healPot) then
                    useItem(healPot)
                elseif hasItem(166799) and canUseItem(166799) then
                    useItem(166799)
                end
            end
            -- Rebirth
			if ui.checked("Rebirth") and not moving then
				if
					ui.value("Rebirth") == 1 and -- Target
						UnitIsPlayer("target") and
						UnitIsDeadOrGhost("target") and
						GetUnitIsFriend("target", "player")
				 then
					if cast.rebirth("target", "dead") then
						br.addonDebug("Casting Rebirth")
						return true
					end
				end
				if
					ui.value("Rebirth") == 2 and -- Mouseover
						UnitIsPlayer("mouseover") and
						UnitIsDeadOrGhost("mouseover") and
						GetUnitIsFriend("mouseover", "player")
				 then
					if cast.rebirth("mouseover", "dead") then
						br.addonDebug("Casting Rebirth")
						return true
					end
				end
				if ui.value("Rebirth") == 3 then -- Tank
					for i = 1, #tanks do
						if UnitIsPlayer(tanks[i].unit) and UnitIsDeadOrGhost(tanks[i].unit) and GetUnitIsFriend(tanks[i].unit, "player") and getDistance(tanks[i].unit) <= 40 then
							if cast.rebirth(tanks[i].unit, "dead") then
								br.addonDebug("Casting Rebirth")
								return true
							end
						end
					end
				end
				if ui.value("Rebirth") == 4 then -- Healer
					for i = 1, #br.friend do
						if
							UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") and
								(UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER")
						 then
							if cast.rebirth(br.friend[i].unit, "dead") then
								br.addonDebug("Casting Rebirth")
								return true
							end
						end
					end
				end
				if ui.value("Rebirth") == 5 then -- Tank/Healer
					for i = 1, #br.friend do
						if
							UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") and
								(UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER" or br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")
						 then
							if cast.rebirth(br.friend[i].unit, "dead") then
								br.addonDebug("Casting Rebirth")
								return true
							end
						end
					end
				end
				if ui.value("Rebirth") == 6 then -- Any
					for i = 1, #br.friend do
						if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") then
							if cast.rebirth(br.friend[i].unit, "dead") then
								br.addonDebug("Casting Rebirth")
								return true
							end
						end
					end
				end
			end
            -- Berserk
            if not talent.incarnationGuardianOfUrsoc and ui.checked("Incarnation/Berserk") and php <= ui.value("Incarnation/Berserk") then
                if cast.berserk() then br.addonDebug("Casting Berserk") return end
            end
            -- Incarnation
            if ui.checked("Incarnation/Berserk") and php <= ui.value("Incarnation/Berserk") then
                if cast.incarnationGuardianOfUrsoc() then
                    return
                end
            end
            -- Survival Instincts
            if ui.checked("Survival Instincts") then
                if php <= ui.value("Survival Instincts") and inCombat and not buff.survivalInstincts.exists() and not buff.barkskin.exists() then
                    if cast.survivalInstincts() then
                        return
                    end
                end
            end 
            -- Barkskin
            if ui.checked("Barkskin") then
                if php <= ui.value("Barkskin") and inCombat and not buff.survivalInstincts.exists() and not buff.ironfur.exists() then
                    if cast.barkskin() then
                        return
                    end
                end
            end
            -- Ironfur
            if mode.ironfur == 1 and (hasAggro >= 2) and bear then
                if (traits.layeredMane.active and rage >= 45) or not buff.ironfur.exists() or buff.goryFur.exists() or rage >= 55 or buff.ironfur.remain() < 2 then
                    if cast.ironfur() then
                        return
                    end
                end
            end
            -- Ironfur (No Aggro)
            if ui.checked("Ironfur (No Aggro)") and not (hasAggro >=1) and bear and php <= ui.value("Ironfur (No Aggro)") and inCombat then
                if (traits.layeredMane.active and rage >= 45) or not buff.ironfur.exists() or buff.goryFur.exists() or rage >= 55 or buff.ironfur.remain() < 2 then
                    if cast.ironfur() then
                        return
                    end
                end
            end
            -- Bristlingfur
            if mode.bristlingFur == 1 and rage < 40 and (hasAggro >= 2) then
                if cast.bristlingFur() then
                    return
                end
            end
            -- Frenzied Regeneration
            if ui.checked("Frenzied Regeneration") and not buff.frenziedRegeneration.exists() and ((charges.frenziedRegeneration.count() >= 2 and php < ui.value("FR - HP Interval (2 Charge)")) or (charges.frenziedRegeneration.count() >= 1 and php < ui.value("FR - HP Interval (1 Charge)"))) then
                if cast.frenziedRegeneration() then
                    return
                end
            end
            -- Auto Soothe
            if ui.checked("Auto Soothe") then
                for i = 1, #enemies.yards40 do
                    thisUnit = enemies.yards40[i]
                    if canDispel(thisUnit, spell.soothe) then
                        if cast.soothe(thisUnit) then
                            return
                        end
                    end
                end
            end
             -- Remove Corruption
             if ui.checked("Remove Corruption") then
                if ui.value("Remove Corruption - Target") == 1 and canDispel("player", spell.removeCorruption) then
                    if cast.removeCorruption("player") then
                        return
                    end
                end
                if ui.value("Remove Corruption - Target") == 2 and canDispel("target", spell.removeCorruption) then
                    if cast.removeCorruption("target") then
                        return
                    end
                end
                if ui.value("Remove Corruption - Target") == 3 and canDispel("mouseover", spell.removeCorruption) then
                    if cast.removeCorruption("mouseover") then
                        return
                    end
                end
            end
        end
    end
    -- Incap Logic
    local function List_Interrupts()
        if useInterrupts() then
            if ui.checked("Incapacitating Roar Logic (M+)") then
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

            local radar = "off"

            --Building root list
            local root_UnitList = {}
            if ui.checked("KR - Root Minions of Zul") then
                root_UnitList[133943] = "minion-of-zul"
                radar = "on"
            end
            if ui.checked("All - Root the thing") then
                root_UnitList[161895] = "the thing from beyond"
                radar = "on"
            end
            if ui.checked("FH - Root grenadier") then
                root_UnitList[129758] = "grenadier"
                radar = "on"
            end
            if ui.checked("KR - Root Spirit of Gold") then
                root_UnitList[131009] = "the thing from beyond"
                radar = "on"
            end
            if ui.checked("KR - Animated gold") then
                root_UnitList[135406] = "animated gold"
                radar = "on"
            end
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
                        if distance < root_range and not isLongTimeCCed(object) then
                            CastSpellByName(root, object)
                        end
                    end
                end -- end root
            end -- end radar
            -- Skull Bash
    
            if ui.checked("Skull Bash") and not cd.skullBash.exists()  then
                for i = 1, #enemies.yards13 do
                    thisUnit = enemies.yards13[i]
                    if canInterrupt(thisUnit, ui.value("Interrupt At")) and br.timer:useTimer("Interrupt", 0.5) then
                        if cast.skullBash(thisUnit) then
                            return
                        end
                    end
                end
            end
            if ui.checked("Mighty Bash") and talent.mightyBash and (cd.skullBash.exists() or level < 70) then
                for i = 1, #enemies.yards5 do
                    thisUnit = enemies.yards5[i]
                    if canInterrupt(thisUnit, ui.value("Interrupt At")) and br.timer:useTimer("Interrupt", 0.5) then
                        if cast.mightyBash(thisUnit) then
                            return
                        end
                    end
                end
            end
            if ui.checked("Incapacitating Roar") and (cd.skullBash.exists() or level < 70) then
                for i = 1, #enemies.yards10 do
                    thisUnit = enemies.yards10[i]
                    if canInterrupt(thisUnit, ui.value("Interrupt At")) and br.timer:useTimer("Interrupt", 0.5) then
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
            if (ui.value("Trinkets") == 1 or (ui.value("Trinkets") == 2 and useCDs())) and inCombat then
                if php <= ui.value("Trinket 1") and use.able.slot(13) then
                    use.slot(13)
                end
                elseif php <= ui.value("Trinket 2") and use.able.slot(14) then
                    use.slot(14)
                end
            end
        -- Racial
            if ui.checked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                if castSpell("player", racial, false, false, false) then
                    return
                end
            end
    local function cat_dps()
            if mode.forms == 2 and cat and talent.feralAffinity and isValidTarget("target") and inCombat and profileStop == false then
                -- Swipe
                if (#enemies.yards8 > 1 and #enemies.yards8 < 4 and debuff.rake.exists(units.dyn8)) or #enemies.yards8 >= 4 then
                    if cast.swipeCat() then return end
                end
                -- Rip
                if combo == 5 and #enemies.yards8 < 4 then
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                        if getDistance(thisUnit) < 5 then
                            if not debuff.rip.exists(thisUnit) or debuff.rip.remain(thisUnit) < 4 then
                                if cast.rip(thisUnit) then return end
                            end
                        end
                    end
                end
                -- Rake
                if combo < 5 and #enemies.yards8 < 4 then
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                    if getDistance(thisUnit) < 5 then
                            if not debuff.rake.exists(thisUnit) then
                                if cast.rake(thisUnit) then return end
                            end
                        end
                    end
                end
                ---- Ferocious Bite
                if combo == 5 and #enemies.yards8 < 4 then
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                        if getDistance(thisUnit) < 5 and debuff.rip.exists(thisUnit) then
                            if cast.ferociousBite(thisUnit) then return end
                        end
                    end
                end
                -- Shred
                if combo < 5 and debuff.rake.exists(units.dyn5) and #enemies.yards8 < 2 then
                    if cast.shred(units.dyn5) then return end
                end
                if List_Interrupts() then
                        return true
                end
                if List_Defensive() then
                        return true
                end
            end
        end

    local function List_Bearmode()
        if mode.forms ~= 3 then
            if not bear and not buff.prowl.exists() and not cast.last.bearForm() then
                if cast.bearForm() then
                    return true
                end
            end
        end
        if mode.taunt == 1 and inInstance and combatTime > 5 then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
                    if cast.growl(thisUnit) then
                        return
                    end
                end
            end
        end
        if mode.taunt == 2 and combatTime > 5 then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
                    if cast.growl(thisUnit) then
                        return
                    end
                end
            end
        end

        if ui.checked("Wild Charge") then
            if getDistance("target") > 9 and bear then
                if cast.wildCharge("target") then
                    return
                end
            end
        end
        -- Ravenous Frenzy
        if ui.checked("Use Covenant") and covenant.venthyr.active and buff.berserk.exists() then
            if cast.ravenousFrenzy() then br.addonDebug("Casting Ravenous Frenzy") return end
        end
        -- Pulverize
        if talent.pulverize then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if debuff.thrashBear.stack(thisUnit) >= 3 then
                    if not cast.last.pulverize() then
                        if cast.pulverize(thisUnit) then br.addonDebug("Casting Pulverize") return end
                    end
                end
            end
        end
        -- Moonfire
        if talent.galacticGuardian and buff.galacticGuardian.exists() then
            if debuff.moonfire.count() < ui.value("Max Moonfire Targets") then
                for i = 1, #enemies.yards8 do
                    local thisUnit = enemies.yards8[i]
                    if not debuff.moonfire.exists(thisUnit) or debuff.moonfire.refresh(thisUnit) then
                        if cast.moonfire(thisUnit) then br.addonDebug("Casting Moonfire (Galactic Guardian)") return end
                    end
                end
            end
        end
        -- Maul
        if conduit.savageCombatant.enabled and buff.savageCombatant.stack() == 3 and rage >= 50 and php > 75 then
            if cast.maul() then br.addonDebug("Casting Maul (Savage Combatant)") return end
        end
        if talent.toothAndClaw and buff.toothAndClaw.exists() and not debuff.toothAndClaw.exists("target") and rage > 60 then
            if cast.maul() then br.addonDebug("Casting Maul (Tooth and Claw)") return end
        end
        if not conduit.savageCombatant.enabled and not talent.toothAndClaw and rageDeficit < 10 and php >= 75 then
            if cast.maul() then br.addonDebug("Casting Maul") return end
        end
        -- Mangle
        if debuff.thrashBear.stack("target") == 3 and not debuff.thrashBear.refresh("target") then
            if cast.mangle() then br.addonDebug("Casting Mangle (Thrash Bleed)") return end
        end
        -- Thrash
        if cast.thrashBear("player") then br.addonDebug("Casting Thrash") return end
        -- Mangle
        if cast.mangle() then br.addonDebug("Casting Mangle") return end
        -- Adaptive Swarm
        if ui.checked("Use Covenant") and covenant.necrolord.active and debuff.adaptiveSwarm.count() < 2 then
            for i = 1, #enemies.yards8 do
                local thisUnit = enemies.yards8[i]
                if not debuff.adaptiveSwarm.exists(thisUnit) then
                    if cast.adaptiveSwarm(thisUnit) then br.addonDebug("Casting Adaptive Swarm") return end
                end
            end
        end
        -- Convoke the Spirits
        if ui.checked("Use Covenant") and #enemies.yards8 > 0 and ui.useCDs() and covenant.nightFae.active and not buff.berserk.exists() and not buff.incarnationGuardianOfUrsoc.exists() then
            if cast.convokeTheSpirits() then br.addonDebug("Casting Convoke the Spirits") return end
        end
        -- Moonfire
        if debuff.moonfire.count() < ui.value("Max Moonfire Targets") then
            for i = 1, #enemies.yards8 do
                local thisUnit = enemies.yards8[i]
                if not debuff.moonfire.exists(thisUnit) or debuff.moonfire.refresh(thisUnit) then
                    if cast.moonfire(thisUnit) then br.addonDebug("Casting Moonfire (Refresh)") return end
                end
            end
        end
        -- Swipe
        if cast.swipeBear() then br.addonDebug("Casting Swipe") return end
        -- Start Attack
        if getDistance("target") < 5 then StartAttack() end

    end

    -----------------
    --- Rotations ---
    -----------------
    -- Pause
    if pause() or (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) or mode.rotation == 2 then
        return
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        if not inCombat and not UnitBuffID("player", 115834) then
            if mode.forms == 1 then
                if not inCombat and not br.player.buff.prowl.exists() then
                    if UnitCanAttack("player","target") and not UnitIsFriend("player","target") and ((getDistance("target") < 30 and not swimming) or (getDistance("target") < 10 and swimming)) and not bear then
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
        end -- End Out of Combat Rotation
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if inCombat and not UnitBuffID("player", 115834) then
            -- Start Attack
            -- auto_attack
            if getDistance("target") < 5 then
                StartAttack("target")
            end
            if ui.checked("Big Hit Oh Shit!") and SpecificToggle("Big Hit Oh Shit!") and not GetCurrentKeyBoardFocus() and bear then
                if br.timer:useTimer("Big Hit Delay", 2) then 
                    actionList_BigHit()
                end
            end
            if mode.forms == 1 then
                if isValidUnit("target") and (getDistance("target") < 30) and not bear then
                        if cast.bearForm("player") then
                            return true
                        end
                end
            end
            if mode.forms == 2 then
                if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus() and ui.checked("Feral Affinity") and cat then
                    cat_dps() return true
                elseif SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus() then
                    cat_form()
                    return true
                elseif SpecificToggle("Travel Key") and not GetCurrentKeyBoardFocus() then
                    travel_form()
                    return true
                end
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
            if getDistance("target") < 5 then
                StartAttack()
            end
            if List_Bearmode() then
                return true
            end
        end
    end -- End In Combat Rotation
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
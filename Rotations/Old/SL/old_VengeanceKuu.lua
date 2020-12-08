local rotationName = "Kuukuu"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Automatic Rotation",
            tip = "Swaps between Single and Multiple based on number of targets in range.",
            highlight = 1,
            icon = br.player.spell.soulCleave
        },
        [2] = {mode = "Mult", value = 2, overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.soulCleave},
        [3] = {mode = "Sing", value = 3, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.shear},
        [4] = {mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.spectralSight}
    }
    CreateButton("Rotation", 1, 0)
    -- Cooldown Button
    CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.metamorphosis},
        [2] = {mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.metamorphosis},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.metamorphosis}
    }
    CreateButton("Cooldown", 2, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.demonSpikes},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.demonSpikes}
    }
    CreateButton("Defensive", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.consumeMagic},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.consumeMagic}
    }
    CreateButton("Interrupt", 4, 0)
    -- Mover
    MoverModes = {
        [1] = {mode = "On", value = 2, overlay = "Auto Movement Enabled", tip = "Will Cast Movement Abilities.", highlight = 1, icon = br.player.spell.infernalStrike},
        [2] = {mode = "Off", value = 1, overlay = "Auto Movement Disabled", tip = "Will NOT Cast Movement Abilities", highlight = 0, icon = br.player.spell.infernalStrike}
    }
    CreateButton("Mover", 5, 0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.0")
        -- APL
        br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
        br.ui:createSpinner(section, "Pre-Pull Timer", 5, 1, 10, 1, "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Immolation Aura
        br.ui:createCheckbox(section, "Immolation Aura")
        -- Sigil of Flame
        br.ui:createCheckbox(section, "Sigil of Flame")
        -- Torment
        br.ui:createCheckbox(section, "Torment")
        -- Consume Magic
        br.ui:createCheckbox(section, "Consume Magic")
        -- Fel Devestation
        br.ui:createCheckbox(section, "Fel Devastation")
        -- Throw Glaive
        br.ui:createCheckbox(section, "Throw Glaive")
        -- Use Cyclotronic on Pull
        br.ui:createCheckbox(section, "Cyclotronic on Pull")
        -- Font of Azshara
        br.ui:createSpinner(section, "Font of Azshara", 4, 1, 10, 1, "|cffFFFFFFSet to desired time to use Font of Azshara (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Infernal Strike Key
        br.ui:createDropdown(section, "Infernal Strike Key", br.dropOptions.Toggle, 6, "|cffFFFFFFSet key to manually infernal strike")
        -- Sigil of Chains Key
        br.ui:createDropdown(section, "Sigil of Chains Key", br.dropOptions.Toggle, 6, "|cffFFFFFFSet key to manually use Sigil of Chains")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Agi Pot
        br.ui:createCheckbox(section, "Agi-Pot")
        -- Flask / Crystal
        br.ui:createCheckbox(section, "Flask / Crystal")
        -- Legendary Ring
        br.ui:createCheckbox(section, "Legendary Ring")
        -- Racial
        br.ui:createCheckbox(section, "Racial")
        -- Trinkets
        br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
        br.ui:createSpinner(section, "Pot/Stoned", 60, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
        br.ui:createSpinner(section, "Heirloom Neck", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Fiery Brand
        br.ui:createSpinner(section, "Fiery Brand", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Demon Spikes
        br.ui:createSpinner(section, "Demon Spikes", 90, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinnerWithout(section, "Hold Demon Spikes", 1, 0, 2, 1, "|cffFFBB00Number of Demon Spikes the bot will hold for manual use.")
        -- Metamorphosis
        br.ui:createSpinner(section, "Metamorphosis", 40, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Sigil of Misery
        br.ui:createSpinner(section, "Sigil of Misery - HP", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinner(section, "Sigil of Misery - AoE", 3, 0, 10, 1, "|cffFFFFFFNumber of Units in 8 Yards to Cast At")
        -- Soul Barrier
        br.ui:createSpinner(section, "Soul Barrier", 70, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Soul Cleave
        br.ui:createSpinnerWithout(section, "Soul Cleave", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinnerWithout(section, "Fragless Soul Cleave", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use Soul Cleave without Soul Frags at.")
        --Spirit Bomb
        br.ui:createSpinnerWithout(section, "Spirit Bomb", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -- Essence Options
        section = br.ui:createSection(br.ui.window.profile, "Essences")
        -- Lucid Dreams
        br.ui:createCheckbox(section, "Lucid Dreams")
        -- Worldvein Resonance
        br.ui:createCheckbox(section, "Worldvein Resonance")
        -- Aegis of the Deep
        br.ui:createCheckbox(section, "Aegis of the Deep")
        -- Concentrated Flame
        br.ui:createSpinner(section, "Concentrated Flame", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Anima of Death
        br.ui:createSpinner(section, "Anima of Death", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Empower Null Barrier
        br.ui:createSpinner(section, "Empowered Null Barrier", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Strength of the Warden
        br.ui:createCheckbox(section, "Strength of the Warden")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Consume Magic
        br.ui:createCheckbox(section, "Disrupt")
        -- Sigil of Silence
        br.ui:createCheckbox(section, "Sigil of Silence")
        -- Sigil of Misery
        br.ui:createCheckbox(section, "Sigil of Misery")
        -- Imprison
        br.ui:createCheckbox(section, "Imprison")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle, 4)
        -- Cooldown Key Toggle
        br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle, 3)
        -- Defensive Key Toggle
        br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle, 6)
        -- Interrupts Key Toggle
        br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
        -- Mover Key Toggle
        br.ui:createDropdown(section, "Mover Mode", br.dropOptions.Toggle, 6)
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
    -- if br.timer:useTimer("debugVengeance", math.random(0.15,0.3)) then
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
    local canFlask = canUseItem(br.player.flask.wod.agilityBig)
    local cast = br.player.cast
    local combatTime = getCombatTime()
    local cd = br.player.cd
    local charges = br.player.charges
    local hastar = GetObjectExists("target")
    local debuff = br.player.debuff
    local enemies = br.player.enemies
    local equiped = br.player.equiped
    local essence = br.player.essence
    local flying, moving = IsFlying(), GetUnitSpeed("player") > 0
    local flaskBuff = getBuffRemain("player", br.player.flask.wod.buff.agilityBig)
    local gcd = br.player.gcdMax
    local healPot = getHealthPot()
    local inCombat = br.player.inCombat
    local inRaid = br.player.instance == "raid"
    local mode = br.player.ui.mode
    local pain, painDeficit = br.player.power.pain.amount(), br.player.power.pain.deficit()
    local php = br.player.health
    local pullTimer = br.DBM:getPulltimer()
    local racial = br.player.getRacial()
    local spell = br.player.spell
    local talent = br.player.talent
    local ttd = getTTD
    local units = br.player.units
    local hasAggro = UnitThreatSituation("player")
    if hasAggro == nil then
        hasAggro = 0
    end
    iStrikeDelay = iStrikeDelay or 0

    units.get(5)
    units.get(8, true)
    units.get(20)
    enemies.get(5)
    enemies.get(5, "target")
    enemies.get(8)
    enemies.get(30)
    enemies.get(40)

    if profileStop == nil then
        profileStop = false
    end

    if br.vengeance == nil then
        br.vengeance = {}
    end
    br.vengeance.groundOverride = {
        [152364] = "Radiance of Azshara",
        [152671] = "Wekemara"
    }

    local function iStrike(unit)
        --if getDistance("player",unit) < 40 then
        local wasMouseLooking = false
        if IsMouselooking() then
            wasMouseLooking = true
            MouselookStop()
        end
        if getDistance("player", unit) == 0 or br.vengeance.groundOverride[getUnitID(unit)] ~= nil then
            if cast.infernalStrike("playerGround") then
                br.addonDebug("Casting Inferal Strike (Player)")
                iStrikeDelay = GetTime()
                if wasMouseLooking then
                    MouselookStart()
                end
                return
            end
        end
        local combatRange = max(5, UnitCombatReach("player") + UnitCombatReach(unit))
        local px, py, pz = ObjectPosition("player")
        local x, y, z = GetPositionBetweenObjects(unit, "player", combatRange - 1)
        z = select(3, TraceLine(x, y, z + 5, x, y, z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
        if z ~= nil and TraceLine(px, py, pz + 2, x, y, z + 1, 0x100010) == nil and TraceLine(x, y, z + 4, x, y, z, 0x1) == nil then -- Check z and LoS, ignore terrain and m2 colissions and check no m2 on hook location
            CastSpellByName(GetSpellInfo(spell.infernalStrike))
            br.addonDebug("Casting Inferal Strike")
            ClickPosition(x, y, z)
            iStrikeDelay = GetTime()
            if wasMouseLooking then
                MouselookStart()
            end
        end
        return true
        --  end
        --  return false
    end

    local function ShouldMitigate()
        if UnitThreatSituation("player", "target") == 3 and UnitCastingInfo("target") then
            -- if activeMitigationList[select(9, UnitCastingInfo("target"))] ~= nil then
            if br.lists.defensives[select(9, UnitCastingInfo("target"))] ~= nil then
                return true
            end
        -- for i = 1, #activeMitigationList do
        --     local spell_id = activeMitigationList[i]
        --     if UnitCastingInfo("target") == GetSpellInfo(spell_id) then
        --         print(activeMitigationList[i])
        --         br.addonDebug(GetSpellInfo(spell_id))
        --         return true
        --     end
        -- end
        end
        return false
    end

    local function trinketLogic(slot)
        if
            not hasEquiped(169314, slot) and not hasEquiped(165572, slot) and not hasEquiped(167868, slot) and not hasEquiped(169311, slot) and not hasEquiped(167555, slot) and
                ((slot == 13 and php <= getOptionValue("Trinket 1")) or slot == 14 and php <= getOptionValue("Trinket 2"))
         then
            if slot == 13 then
                br.addonDebug("Using Trinket 1")
            elseif slot == 14 then
                br.addonDebug("Using Trinket 2")
            end
            useItem(slot)
        elseif hasEquiped(167555, slot) and br.timer:useTimer("Cyclo Delay", 3) and php >= 70 and not ShouldMitigate() then
            br.addonDebug("Using Cyclotronic Blast")
            useItem(slot)
        elseif hasEquiped(165572, slot) then
            if buff.vigorEngaged.exists() and buff.vigorEngaged.stack() == 6 and br.timer:useTimer("vigor Engaged Delay", 6) then
                br.addonDebug("Using Variable Intensity Gigavolt Oscillating Reactor")
                useItem(slot)
            end
        elseif hasEquiped(167868, slot) then
            if (#getAllies("player", 15) + getNumEnemies("player", 15)) >= 4 and php <= 50 then
                br.addonDebug("Using Idol of Indiscriminate Consumption")
                useItem(slot)
            end
        elseif hasEquiped(169314, slot) then
            local tank = "player"
            if #getFocusedTank() >= 1 then
                tank = getFocusedTank()[1]
            end
            if not GetUnitIsUnit("player", tank) and php >= 75 and not UnitBuffID("player", 296962) and br.timer:useTimer("Font Delay", 4) and not isMoving("player") then
                br.addonDebug("Using Font Of Azshara")
                useItem(slot)
                return true
            end
        elseif hasEquiped(169311, slot) then
            if not debuff.razorCoral.exists("target") or (equiped.dribblingInkpod() and (debuff.conductiveInk.exists("target") and (getHP("target") < 31)) or ttd("target") < 20) then
                br.addonDebug("Using Ashvane's Razor Coral")
                useItem(slot)
                return true
            end
        end
    end

    local typesLoc = {
        "Demon",
        "Dämon",
        "Démon",
        "악마",
        "Demonio",
        "Demônio",
        "Demonarca",
        "Demone",
        "Демон",
        "恶魔",
        "惡魔",
        "Beast",
        "Wildtier",
        "Bête",
        "야수",
        "Bestia",
        "Fera",
        "Животное",
        "野兽",
        "野獸",
        "Humanoid",
        "Humanoid",
        "Humanoide",
        "Humanoïde",
        "Umanoide",
        "Humanoide",
        "Гуманоид",
        "인간형",
        "人型生物",
        "人型生物"
    }

    --------------------
    --- Action Lists ---
    --------------------
    -- Action List - Extras
    local function actionList_Extras()
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
        -- Torment
        if isChecked("Torment") and combatTime > 5 then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                local target = UnitTarget(thisUnit)
                if target and select(2, IsInInstance()) ~= "none" and UnitGroupRolesAssigned(target) ~= "TANK" then
                    if cast.torment(thisUnit) then
                        br.addonDebug("Casting Torment")
                        return
                    end
                end
            end
        end
    end -- End Action List - Extras
    -- Action List - Defensive
    local function actionList_Defensive()
        if useDefensive() then
            -- Demon Spikes
            if isChecked("Demon Spikes") and br.timer:useTimer("Spikes delay", 2) and inCombat and
                    ((charges.demonSpikes.count() > getOptionValue("Hold Demon Spikes") and php <= getOptionValue("Demon Spikes")) or charges.demonSpikes.count() == 2) and
                    #enemies.yards8 > 0 and hasAggro >= 2
             then
                if not buff.demonSpikes.exists() and not debuff.fieryBrand.exists("target") and not buff.metamorphosis.exists() then
                    if cast.demonSpikes() then
                        br.addonDebug("Casting Demon Spikes")
                        return
                    end
                end
            end
            -- Null Barrier
            if isChecked("Empowered Null Barrier") and inCombat and essence.empoweredNullBarrier.active and cd.empoweredNullBarrier.remain() <= gcd and php <= getOptionValue("Empowered Null Barrier") and hasAggro >= 2 then
                if not buff.demonSpikes.exists() and not debuff.fieryBrand.exists("target") and not buff.metamorphosis.exists() then
                    if cast.empoweredNullBarrier() then
                        br.addonDebug("Casting Empowered Null Barrier")
                        return
                    end
                end
            end
            -- Fiery Brand
            if isChecked("Fiery Brand") and inCombat and php <= getOptionValue("Fiery Brand") and #enemies.yards30 > 0 and hasAggro >= 2 then
                if not buff.demonSpikes.exists() and not buff.metamorphosis.exists() then
                    if cast.fieryBrand() then
                        br.addonDebug("Casting Fiery Brand")
                        return
                    end
                end
            end
            -- Metamorphosis
            if
                isChecked("Metamorphosis") and inCombat and not buff.demonSpikes.exists() and not debuff.fieryBrand.exists("target") and not buff.metamorphosis.exists() and
                    php <= getOptionValue("Metamorphosis") and hasAggro >= 2
             then
                if cast.metamorphosis() then
                    br.addonDebug("Casting Metamorphosis")
                    return
                end
            end
            -- Anima of Death
            if isChecked("Anima of Death") and essence.animaOfDeath.active and cd.animaOfDeath.remain() <= gcd and inCombat and #enemies.yards8 >= 3 and php <= getOptionValue("Anima of Death") then
                if cast.animaOfDeath("player") then
                    br.addonDebug("Casting Anima of Death")
                    return
                end
            end
            -- Aegis of the Deep
            if isChecked("Aegis of the Deep") and essence.aegisOfTheDeep.active and cd.aegisOfTheDeep.remain() <= gcd and inCombat and #enemies.yards8 >= 3 then
                if cast.aegisOfTheDeep("player") then
                    br.addonDebug("Casting Aegis of the Deep")
                    return
                end
            end
            -- Soul Barrier
            if isChecked("Soul Barrier") and inCombat and php < getOptionValue("Soul Barrier") and hasAggro >= 2 then
                if cast.soulBarrier() then
                    br.addonDebug("Casting Soul Barrier")
                    return
                end
            end
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
                        br.addonDebug("Using Heirloom Neck")
                        useItem(122668)
                    end
                end
            end
            -- Sigil of Misery
            if isChecked("Sigil of Misery - HP") and php <= getOptionValue("Sigil of Misery - HP") and inCombat and #enemies.yards8 > 0 then
                if cast.sigilOfMisery("player", "ground") then
                    br.addonDebug("Casting Sigil of Misery")
                    return
                end
            end
            if isChecked("Sigil of Misery - AoE") and #enemies.yards8 >= getOptionValue("Sigil of Misery - AoE") and inCombat then
                if cast.sigilOfMisery("best", false, getOptionValue("Sigil of Misery - AoE"), 8) then
                    br.addonDebug("Casting Sigil of Misery")
                    return
                end
            end
        end -- End Defensive Toggle
    end -- End Action List - Defensive
    -- Action List - Interrupts
    local function actionList_Interrupts()
        if useInterrupts() then
            for i = 1, #enemies.yards30 do
                thisUnit = enemies.yards30[i]
                -- Disrupt
                if canInterrupt(thisUnit, getOptionValue("Interrupt At")) and (sigilDelay == nil or GetTime() - sigilDelay > 2) then
                    if isChecked("Disrupt") and getDistance(thisUnit) < 20 and getFacing("player", thisUnit) and cd.disrupt.remain() <= gcd then
                        -- Sigil of Silence
                        if cast.disrupt(thisUnit) then
                            br.addonDebug("Casting Disrupt")
                            return
                        end
                    elseif isChecked("Sigil of Silence") and cd.sigilOfSilence.remain() <= gcd then
                        -- Sigil of Misery
                        if not talent.concentratedSigils then
                            if cast.sigilOfSilence(thisUnit, "ground", 1, 8) then
                                sigilDelay = GetTime()
                                br.addonDebug("Casting Sigil of Silence")
                                return
                            end
                        elseif talent.concentratedSigils and getDistance(thisUnit) <= 8 then
                            if cast.sigilOfSilence() then
                                sigilDelay = GetTime()
                                br.addonDebug("Casting Sigil of Silence")
                                return
                            end
                        end
                    elseif isChecked("Sigil of Misery") and cd.sigilOfMisery.remain() <= gcd then
                        if not talent.concentratedSigils then
                            if cast.sigilOfMisery(thisUnit, "ground", 1, 8) then
                                sigilDelay = GetTime()
                                br.addonDebug("Casting Sigil of Misery")
                                return
                            end
                        elseif talent.concentratedSigils and getDistance(thisUnit) <= 8 then
                            if cast.sigilOfMisery() then
                                sigilDelay = GetTime()
                                br.addonDebug("Casting Sigil of Misery")
                                return
                            end
                        end
                    elseif isChecked("Imprison") and cd.imprison.remain() <= gcd and getFacing("player", thisUnit) then
                        local type = UnitCreatureType(thisUnit)
                        for i = 1, #typesLoc do
                            if type == typesLoc[i] then
                                if getDistance(thisUnit) < 20 then
                                    if cast.imprison(thisUnit) then
                                        br.addonDebug("Casting Imprison")
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end -- End useInterrupts check
    end -- End Action List - Interrupts
    -- Action List - Cooldowns
    local function actionList_Cooldowns()
        -- Trinkets
        if useCDs() and getDistance("target") < 5 then
            if hasItem(166801) and canUseItem(166801) then
                br.addonDebug("Using Sapphire of Brilliance")
                useItem(166801)
            end
            if isChecked("Trinket 1") and canTrinket(13) then
                trinketLogic(13)
            end
            if isChecked("Trinket 2") and canTrinket(14) then
                trinketLogic(14)
            end
        end
    end -- End Action List - Cooldowns
    -- Action List - PreCombat
    local function actionList_PreCombat()
        if not inCombat then
            -- Flask / Crystal
            -- flask,type=flask_of_the_seventh_demon
            if isChecked("Flask / Crystal") then
                if inRaid and canFlask and flaskBuff == 0 and not UnitBuffID("player", 188033) then
                    useItem(br.player.flask.wod.agilityBig)
                    return
                end
                if flaskBuff == 0 then
                    if not UnitBuffID("player", 188033) and canUseItem(118922) then --Draenor Insanity Crystal
                        useItem(118922)
                        return
                    end
                    if not UnitBuffID("player", 193456) and not UnitBuffID("player", 188033) and canUseItem(129192) then -- Gaze of the Legion
                        useItem(129192)
                        return
                    end
                end
            end
            if isChecked("Font of Azshara") and pullTimer <= getOptionValue("Font of Azshara") then
                if hasEquiped(169314) and canUseItem(169314) and br.timer:useTimer("Font Delay", 4) then
                    br.addonDebug("Using Font Of Azshara")
                    useItem(169314)
                end
            end
            if isChecked("Cyclotronic on Pull") and pullTimer <= 2 then
                if hasEquiped(167555) and canUseItem(167555) and br.timer:useTimer("Cyclo Delay", 3) then
                    br.addonDebug("Using Cyclotronic Blast")
                    useItem(167555)
                end
            end
            if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
                if isChecked("Worldvein Resonance") and essence.worldveinResonance.active and cd.worldveinResonance.remain() <= gcd then
                    if cast.worldveinResonance() then
                        br.addonDebug("Casting Worldvein Resonance")
                        return
                    end
                end
                if hasItem(166801) and canUseItem(166801) then
                    br.addonDebug("Using Sapphire of Brilliance")
                    useItem(166801)
                end
            end -- End Pre-Pull
            if GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") and getDistance("target") < 5 then
                -- Start Attack
                StartAttack()
            end
        end -- End No Combat
    end -- End Action List - PreCombat
    -- Action List - FieryBrand
    local function actionList_FieryBrand()
        -- actions.brand=sigil_of_flame,if=cooldown.fiery_brand.remains<2
        if isChecked("Sigil of Flame") and not isMoving(units.dyn5) and getDistance(units.dyn5) < 5 and #enemies.yards5 > 0 and cd.fieryBrand.remain() < 2 then
            if br.vengeance.groundOverride[getUnitID("target")] ~= nil and getDistance("target") <= 8 then
                if cast.sigilOfFlame("player", "ground") then
                    br.addonDebug("Casting Sigil Of Flame")
                    return
                end
            end
            if cast.sigilOfFlame("best", false, 1, 8) then
                br.addonDebug("Casting Sigil Of Flame")
                return
            end
        end
        -- actions.brand+=/infernal_strike,if=cooldown.fiery_brand.remains=0
        if
            mode.mover == 1 and not cast.last.infernalStrike(1) and charges.infernalStrike.count() == 2 and not cd.fieryBrand.exists() and getDistance("target") <= 10 and not isMoving("target") and
                C_LossOfControl.GetNumEvents() == 0 and
                GetTime() - iStrikeDelay > 2
         then
            --if cast.infernalStrike("targetGround","ground",1,6) then return end
            if iStrike("target") then
                return
            end
        end
        -- actions.brand+=/fiery_brand (ignore if checked for defensive use)
        if cd.fieryBrand.remains() <= gcd then
            if cast.fieryBrand() then
                br.addonDebug("Casting Fiery Brand")
                return
            end
        end
        if debuff.fieryBrand.exists(units.dyn5) then
            -- actions.brand+=/immolation_aura,if=dot.fiery_brand.ticking
            if isChecked("Immolation Aura") and #enemies.yards5 > 0 then
                if cast.immolationAura() then
                    br.addonDebug("Casting Immolation Aura")
                    return
                end
            end
            -- actions.brand+=/fel_devastation,if=dot.fiery_brand.ticking
            if getDistance(units.dyn20) < 20 then
                if cast.felDevastation() then
                    br.addonDebug("Casting Fel Devastation")
                    return
                end
            end
            -- actions.brand+=/infernal_strike,if=dot.fiery_brand.ticking
            if
                mode.mover == 1 and not cast.last.infernalStrike(1) and charges.infernalStrike.count() == 2 and getDistance("target") <= 10 and not isMoving("target") and
                    C_LossOfControl.GetNumEvents() == 0 and
                    GetTime() - iStrikeDelay > 2
             then
                --if cast.infernalStrike("player","ground",1,6) then return end
                if iStrike("target") then
                    return
                end
            end
            -- actions.brand+=/sigil_of_flame,if=dot.fiery_brand.ticking
            if isChecked("Sigil of Flame") and not isMoving(units.dyn5) and getDistance(units.dyn5) < 5 and #enemies.yards5 > 0 then
                if br.vengeance.groundOverride[getUnitID("target")] ~= nil and getDistance("target") <= 8 then
                    if cast.sigilOfFlame("player", "ground") then
                        br.addonDebug("Casting Sigil Of Flame")
                        return
                    end
                end
                if cast.sigilOfFlame("best", false, 1, 8) then
                    br.addonDebug("Casting Sigil Of Flame")
                    return
                end
            end
        end
    end -- End Action List - Fiery Brand

    local function actionList_ActiveMitigation()
        if ShouldMitigate() and #enemies.yards8 > 0 and hasAggro >= 2 then
            if isChecked("Trinket 1") and canTrinket(13) and not hasEquiped(169311, 13) and not hasEquiped(167555, 13) then
                trinketLogic(13)
                return
            elseif isChecked("Trinket 2") and canTrinket(14) and not hasEquiped(169311, 14) and not hasEquiped(167555, 14) then
                -- Metamorphosis
                trinketLogic(14)
                return
            elseif isChecked("Metamorphosis") and not buff.demonSpikes.exists() and not debuff.fieryBrand.exists("target") and not buff.metamorphosis.exists() then
                -- Demon Spikes
                if cast.metamorphosis() then
                    br.addonDebug("Casting Metamorphosis (Active Mitigation)")
                    return
                end
            elseif isChecked("Demon Spikes") and charges.demonSpikes.count() > 0 and br.timer:useTimer("Spikes delay", 1) then
                -- Soul Barrier
                if not buff.demonSpikes.exists() and not debuff.fieryBrand.exists("target") and not buff.metamorphosis.exists() then
                    if cast.demonSpikes() then
                        br.addonDebug("Casting Demon Spikes (Active Mitigation)")
                        return
                    end
                end
            elseif isChecked("Soul Barrier") then
                if cast.soulBarrier() then
                    br.addonDebug("Casting Soul Barrier (Active Mitigation)")
                    return
                end
            end
        end
    end
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop == true then
        profileStop = false
    elseif inCombat and IsAoEPending() then
        SpellStopTargeting()
        br.addonDebug("Canceling Spell")
        return false
    elseif (inCombat and profileStop == true) or IsMounted() or IsFlying() or pause() or mode.rotation == 4 then
        return true
    else
        if isCastingSpell(296962) and php < 75 then
            RunMacroText("/stopcasting")
        end
        -- Infernal Strike
        if SpecificToggle("Infernal Strike Key") and not GetCurrentKeyBoardFocus() and isChecked("Infernal Strike Key") and GetTime() - iStrikeDelay > 2 then
            CastSpellByName(GetSpellInfo(spell.infernalStrike), "cursor")
            iStrikeDelay = GetTime()
            return
        end
        -- Sigil of Chains
        if SpecificToggle("Sigil of Chains Key") and not GetCurrentKeyBoardFocus() and isChecked("Sigil of Chains Key") and cd.sigilOfChains.remain() <= gcd then
            CastSpellByName(GetSpellInfo(spell.sigilOfChains), "cursor")
            return
        end
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList_Extras() then
            return
        end
        ------------------------------
        --- Out of Combat Rotation ---
        ------------------------------
        if actionList_PreCombat() then
            return
        end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if inCombat and isValidUnit("target") and getFacing("player", "target") then
            ChatOverlay("In-Combat!")
            if actionList_ActiveMitigation() then
                return
            end
            --------------------------
            --- Defensive Rotation ---
            --------------------------
            if actionList_Defensive() then
                return
            end
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList_Interrupts() then
                return
            end
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            -- Start Attack
            -- auto_attack
            if getDistance(units.dyn5) < 5 then
                StartAttack()
            end
            -- Consume Magic
            if isChecked("Consume Magic") then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if canDispel(thisUnit, spell.consumeMagic) then
                        if cast.consumeMagic(thisUnit) then
                            br.addonDebug("Casting Consume Magic")
                            return
                        end
                    end
                end
            end
            --CDs
            if actionList_Cooldowns() then
                return
            end
            -- actions+=/call_action_list,name=brand,if=talent.charred_flesh.enabled
            if talent.charredFlesh then
                if actionList_FieryBrand() then
                    return
                end
            end
            -- Vigilant Protector
            if isChecked("Strength of the Warden") and essence.vigilantProtector.active and cd.vigilantProtector.remain() <= gcdMax and #enemies.yards8 >= 3 then
                if cast.vigilantProtector() then
                    br.addonDebug("Casting Vigilant Protector")
                    return
                end
            end
            -- fel_devastation
            if #enemies.yards5t >= 2 or php < 0.75 and talent.felDevastation then
                if cast.felDevastation() then
                    br.addonDebug("Casting Fel Devastation")
                    return
                end
            end
            -- sigil_of_flame
            if isChecked("Sigil of Flame") and not isMoving("target") and #enemies.yards5 > 0 then
                if br.vengeance.groundOverride[getUnitID("target")] ~= nil and getDistance("target") <= 8 then
                    if cast.sigilOfFlame("player", "ground") then
                        br.addonDebug("Casting Sigil Of Flame")
                        return
                    end
                end
                if cast.sigilOfFlame("best", false, 1, 8) then
                    br.addonDebug("Casting Sigil Of Flame")
                    return
                end
            end
            -- soul_cleave
            if not talent.spiritBomb and php <= getOptionValue("Fragless Soul Cleave") then
                if cast.soulCleave() then
                    return
                end
            end
            -- Concentrated Flame Damage
            if isChecked("Concentrated Flame") and essence.concentratedFlame.active and php >= getOptionValue("Concentrated Flame") and getSpellCD(295373) <= gcd then
                if cast.concentratedFlame("target") then
                    br.addonDebug("Casting Concentrated Flame Damage")
                    return
                end
            end
            -- Concentrated Flame Heal
            if isChecked("Concentrated Flame") and essence.concentratedFlame.active and php <= getOptionValue("Concentrated Flame") and getSpellCD(295373) <= gcd then
                if cast.concentratedFlame("player") then
                    br.addonDebug("Casting Concentrated Flame Heal")
                    return
                end
            end
            -- soul_cleave
            if talent.spiritBomb and buff.soulFragments.stack() >= 1 and (#enemies.yards5t < 2 and #enemies.yards5t > 0) and php <= getOptionValue("Soul Cleave") then
                if cast.soulCleave() then
                    br.addonDebug("Casting Soul Cleave")
                    return
                end
            end
            -- spirit_bomb
            if talent.spiritBomb and (buff.soulFragments.stack() >= 4 or (#enemies.yards5t >= 3 and php <= getOptionValue("Spirit Bomb"))) then
                if cast.spiritBomb() then
                    br.addonDebug("Casting Spirit Bomb")
                    return
                end
            end
            -- soul_cleave
            if painDeficit <= 30 and getDistance("target", "player") <= 5 and (not buff.soulFragments.exists() or #enemies.yards5t < 2) and talent.spiritBomb then
                if cast.soulCleave() then
                    br.addonDebug("Casting Soul Cleave")
                    return
                end
            end
            -- fracture
            if talent.fracture and charges.fracture.frac() >= 1.75 and #enemies.yards8 > 0 then
                if cast.fracture() then
                    br.addonDebug("Casting Fracture")
                    return
                end
            end
            -- immolation_aura
            if isChecked("Immolation Aura") and pain <= 90 and #enemies.yards5 > 0 then
                if cast.immolationAura("player") then
                    br.addonDebug("Casting Immolation Aura")
                    return
                end
            end
            -- soul_cleave
            if painDeficit <= 30 and not talent.spiritBomb then
                if cast.soulCleave() then
                    br.addonDebug("Casting Soul Cleave")
                    return
                end
            end
            -- fracture
            if talent.fracture and charges.fracture.count() >= 1 and #enemies.yards8 > 0 then
                if cast.fracture() then
                    br.addonDebug("Casting Fracture")
                    return
                end
            end
            -- actions.normal+=/felblade,if=pain<=70
            if painDeficit >= 30 then
                if cast.felblade() then
                    br.addonDebug("Casting Felblade")
                    return
                end
            end
            -- infernal_strike
            if
                mode.mover == 1 and not cast.last.infernalStrike(1) and charges.infernalStrike.count() == 2 and getDistance("target") <= 10 and not isMoving("target") and
                    C_LossOfControl.GetNumEvents() == 0 and
                    GetTime() - iStrikeDelay > 2
             then
                --if cast.infernalStrike("player","ground",1,6) then return end
                if iStrike("target") then
                    return true
                end
            end
            -- Font of Azshara
            if isChecked("Font of Azshara") and hasEquiped(169314) and canUseItem(169314) and br.timer:useTimer("Font Delay", 4) and not isMoving("player") then
                local tank = "player"
                if #getFocusedTank() >= 1 then
                   tank = getFocusedTank()[1]
                end
                if not GetUnitIsUnit(tank, "player") and php >= 75 and not UnitBuffID("player", 296962) then
                    br.addonDebug("Using Font Of Azshara")
                    useItem(169314)
                end
            end
            -- Worldvein Resonance
            if isChecked("Worldvein Resonance") and essence.worldveinResonance.active and getSpellCD(295186) <= gcd and #enemies.yards5 > 0 then
                if cast.worldveinResonance() then
                    br.addonDebug("Casting Worldvein Resonance")
                    return
                end
            end
            -- Lucid Dreams
            if isChecked("Lucid Dreams") and essence.memoryOfLucidDreams.active and getSpellCD(298357) <= gcd and #enemies.yards5 > 0 then
                if cast.memoryOfLucidDreams("player") then
                    br.addonDebug("Casting Memory of Lucid Dreams")
                    return
                end
            end
            -- actions.normal+=/shear
            if not talent.fracture then
                if cast.shear() then
                    br.addonDebug("Casting Shear")
                    return
                end
            end
            -- actions.normal+=/throw_glaive
            if isChecked("Throw Glaive") and #enemies.yards30 > 0 and #enemies.yards5 == 0 and cd.throwGlaive.remain() <= gcd then
                if cast.throwGlaive() then
                    br.addonDebug("Casting Throw Glaive")
                    return
                end
            end
        end --End In Combat
    end --End Rotation Logic
    -- end -- End Timer
end -- End runRotation
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

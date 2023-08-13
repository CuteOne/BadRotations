local rotationName = "BoaT" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps Single/aoebased on number of enemies in range.", highlight = 1, icon = br.player.spell.moonfire },
        [2] = { mode = "Mult", value = 2, overlay = "Multi Target rotation", tip = "Multi Target rotation", highlight = 1, icon = br.player.spell.starfall },
        [3] = { mode = "Sing", value = 3, overlay = "Force single target", tip = "Force single target", highlight = 0, icon = br.player.spell.wrath },
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.soothe },
        [5] = { mode = "Off", value = 5, overlay = "DPS SPECIAL", tip = "does something", highlight = 0, icon = br.player.spell.pepe }
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

        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createSpinnerWithout(section, "Treant Targets", 3, 1, 10, 1, "How many baddies before using Treant?")
        br.ui:createDropdownWithout(section, "DPS Key", br.dropOptions.Toggle, 6, "DPS Override")
        br.ui:createDropdownWithout(section, "Travel Key", br.dropOptions.Toggle, 6, "Set a key for travel")
        br.ui:createDropdownWithout(section, "Cat Key", br.dropOptions.Toggle, 6, "Set a key for cat")
        br.ui:createDropdown(section, "Treants Key", br.dropOptions.Toggle, 6, "", "Treant Key")

        br.ui:createCheckbox(section, "auto stealth", 1)
        br.ui:createCheckbox(section, "auto dash", 1)
        br.ui:createCheckbox(section, "Starfall While moving")
        br.ui:createCheckbox(section, "Auto Innervate", "Use Innervate")

        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Potion/Healthstone", 20, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Renewal", 25, 0, 100, 1, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Barkskin", 60, 0, 100, 1, "Health Percent to Cast At")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Heal/Support")
        br.ui:createDropdown(section, "Rebirth", { "Tanks", "Healers", "Tanks and Healers", "Mouseover Target", "Any" }, 3, "", "Target to Cast On")
        br.ui:createDropdown(section, "Revive", { "Target", "mouseover" }, 1, "", "Target to Cast On")
        br.ui:createDropdown(section, "Remove Corruption", { "Player Only", "Selected Target", "Player and Target", "Mouseover Target", "Any" }, 3, "", "Target to Cast On")
        br.ui:createCheckbox(section, "Auto Soothe")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Root/CC")
        br.ui:createCheckbox(section, "Mist - Spirit vulpin")
        br.ui:createCheckbox(section, "Plague - Globgrod")
        br.ui:createCheckbox(section, "Root - Spiteful(M+)")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "InterruptAt", 0, 0, 95, 5, " or cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
    end

    local function healingOptions()
        section = br.ui:createSection(br.ui.window.profile, "Heal Settings")
        br.ui:createDropdown(section, "Regrowth?", { "Always", "OOC", "SOLO+OOC" }, 2, "Wanna Regrowth?")
        br.ui:createSpinnerWithout(section, "Regrowth%", 30, 0, 100, 1, "Health Percent to Cast At")
        if br.player.talent.restorationAffinity then
            br.ui:createDropdown(section, "WildGrowth?", { "Always", "OOC", "SOLO+OOC" }, 2, "Wanna WildGrowth?")
            br.ui:createSpinnerWithout(section, "WildGrowth%", 30, 0, 100, 1, "Health Percent to Cast At")
            br.ui:createDropdown(section, "Rejuv?", { "Always", "OOC", "SOLO+OOC" }, 2, "Wanna Rejuv?")
            br.ui:createSpinnerWithout(section, "Rejuv%", 30, 0, 100, 1, "Health Percent to Cast At")
            br.ui:createDropdown(section, "Swiftmend?", { "Always", "OOC", "SOLO+OOC" }, 2, "Wanna Rejuv?")
            br.ui:createSpinnerWithout(section, "Swiftmend%", 30, 0, 100, 1, "Health Percent to Cast At")
        end

        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Offheal - REQUIRES HE ENABLED")
        br.ui:createCheckbox(section, "Always")
        br.ui:createCheckbox(section, "healer dead")
        br.ui:createSpinner(section, "Prideful Stacks", 20, 0, 20, 1, "Stacks to offheal @")
    end

    optionTable = {

        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        },
        {
            [1] = "Healing",
            [2] = healingOptions

        }
    }
    return optionTable
end


--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local buff
local cast
local cd
local debuff
local enemies
local equiped
local gcd
local gcdMax
local has
local inCombat
local item
local level
local mode
local php
local covenant
local spell
local talent
local unit
local units
local race
local use
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
local hastar
local profileStop
local ttd
--Rotation locals
local is_aoe
local is_cleave
local pewbuff_spell
local convoke_desync
local Trinket13
local Trinket14
local runeforge
local ignore_starsurge
local thisUnit
local eclipse_next
local eclipse_in
local current_eclipse
local splash_count
local tanks
local ui
local tank
local power
local inInstance
local astral_def
local astral_max
local starfire_in_solar
local pool
local critnotup
local dot_requirements
local aspPerSec
local cat
local catspeed
local travel
local charges
local solo
local castWhileMoving
local boatUP
-- Profile Specific Locals - Any custom to profile locals
local actionList = {}

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
local function int (b)
    return b and 1 or 0
end
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

local function getMaxTTD()
    local highTTD = 0
    local mobs = br.player.enemies.get(45)
    local mob_count = #mobs
    if mob_count > 8 then
        mob_count = 8
    end
    for i = 1, mob_count do
        if br.getTTD(mobs[i]) > highTTD and br.getTTD(mobs[i]) < 999
                and br.GetObjectID(mobs[i]) ~= 120651
                and br.GetObjectID(mobs[i]) ~= 174773
        then
            highTTD = br.getTTD(mobs[i])
        end
    end
    return tonumber(highTTD)
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
        local debuffSpellID = select(10, br._G.UnitDebuff(Unit, i))
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

local function hasHot(unit)
    if buff.rejuvenation.exists(unit) or buff.regrowth.exists(unit) or buff.wildGrowth.exists(unit) then
        return true
    else
        return false
    end
end

local function noDamageCheck(unit)
    if ui.checked("Sunfire Explosives") and br.GetObjectID(unit) == 120651 then
        return true
    end
    --   if br.isCC(unit) then
    --       return true
    --   end
    return false
end
local function travel_form()
    if br.SpecificToggle("Travel Key") and not br._G.GetCurrentKeyBoardFocus() then
        if not travel then
            unit.cancelForm()
            if cast.travelForm("Player") then
                return true
            end
        end
        if br.SpecificToggle("Travel Key") and not br._G.GetCurrentKeyBoardFocus() then
            return
        end
    end
end

local function isTrash(Unit)
    if br.GetObjectID(Unit) == 120651
            or br.GetObjectID(Unit) == 164698
            or br.GetObjectID(Unit) == 151353
    then
        return true
    end
end

local function EclipseUpdate()

    -- 190984 == wrath
    -- 194153 starfire

    if (br._G.GetSpellCount(190984) == 0 or br.isCastingSpell(br.player.spell.wrath) and br._G.GetSpellCount(190984) == 1)
            and (br._G.GetSpellCount(194153) == 0 or br.isCastingSpell(br.player.spell.starfire) and br._G.GetSpellCount(194153) == 1) then
        eclipse_in = true
    end
    if not eclipse_in then
        if br._G.GetSpellCount(190984) == 2 and br._G.GetSpellCount(194153) == 2 then
            eclipse_next = "any"
        elseif br._G.GetSpellCount(190984) == 0 and br._G.GetSpellCount(194153) > 0 then
            eclipse_next = "solar"
        elseif br._G.GetSpellCount(190984) > 0 and br._G.GetSpellCount(194153) == 0 then
            eclipse_next = "lunar"
        end
    else
        if br._G.IsSpellOverlayed(spell.wrath) or br.isCastingSpell(br.player.spell.starfire) and br._G.GetSpellCount(194153) == 1 then
            current_eclipse = "solar"
        end
        if br._G.IsSpellOverlayed(spell.starfire) or br.isCastingSpell(br.player.spell.wrath) and br._G.GetSpellCount(190984) == 1 then
            current_eclipse = "lunar"
        end
    end
    --  ui.debug("[ECLIPSE] Current:" .. current_eclipse .. " Next:" .. eclipse_next)
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
--[[
local function getTTDMAX()
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
]]
local function dps_key()


    if not br.player.buff.moonkinForm.exists() then
        unit.cancelForm()
        if cast.moonkinForm() then
            return true
        end
    end

    if covenant.nightFae.active then
        if inCombat and cd.celestialAlignment.ready() and cd.convokeTheSpirits.ready() then

            if not debuff.moonfire.exists("target") then
                if cast.moonfire("target") then
                    return true
                end
            end

            if use.able.inscrutableQuantumDevice() then
                use.inscrutableQuantumDevice()
            end

            if not debuff.sunfire.exists("target") then
                if cast.sunfire("target") then
                    return true
                end
            end

            if cast.able.starfall() and buff.starfall.remains() < 4 then
                if cast.starfall() then
                    return true
                end
            end

            if not isTrash("target") and cast.able.starsurge("target") then
                if cast.starsurge("target") then
                    return true
                end
            end

            if not br.isCastingSpell(323764) then
                if br.canUseItem(171349) then
                    br.useItem(171349)
                end
                if br.canUseItem(307096) then
                    br.useItem(307096)
                end
                --171273
                if br.canUseItem(171273) then
                    br.useItem(171273)
                end
                if race == "Troll" then
                    if cast.racial("player") then
                        return true
                    end
                end
            end

            if cast.able.celestialAlignment() then
                if cast.celestialAlignment() then
                end
            end

            if cast.convokeTheSpirits() then
                return true

            end
        end
    end -- end night fae
end --end DPS key

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
end -- End Action List - Extra


actionList.Heal = function()


    --Heal here

    -- Regrowth
    if ui.checked("Regrowth?") and (ui.value("Regrowth?") == 1 or ui.value("Regrowth?") >= 2 and not inCombat or ui.value("Regrowth?") == 3 and solo)
            and not br.isMoving("player")
            and php <= br.getValue("Regrowth%") then
        if cast.regrowth("player") then
            br.addonDebug("[DEF]Regrowth at: " .. tostring(php))
            return true
        end
    end
    if talent.restorationAffinity then
        -- WildGrowth
        if ui.checked("WildGrowth?") and (ui.value("WildGrowth?") == 1 or ui.value("WildGrowth?") >= 2 and not inCombat or ui.value("WildGrowth?") == 3 and solo)
                and not br.isMoving("player") and cast.able.wildGrowth("player")
                and php <= br.getValue("WildGrowth%") then
            if cast.wildGrowth("player") then
                br.addonDebug("[DEF]WildGrowth at: " .. tostring(php))
                return true
            end
        end
        -- Swiftmend
        if ui.checked("Swiftmend?") and (ui.value("Swiftmend?") == 1 or ui.value("Swiftmend?") >= 2 and not inCombat or ui.value("Swiftmend?") == 3 and solo)
                and charges.swiftmend.count() >= 1 and hasHot("player")
                and php <= br.getValue("Swiftmend%") then
            if cast.swiftmend("player") then
                br.addonDebug("[DEF]  Swiftmend at: " .. tostring(php))
                return true
            end
        end
        -- rejuvenation
        if ui.checked("Rejuv?") and (ui.value("Rejuv?") == 1 or ui.value("Rejuv?") >= 2 and not inCombat or ui.value("Rejuv?") == 3 and solo)
                and php <= br.getValue("Rejuv%") and not buff.rejuvenation.exists() then
            unit.cancelForm()
            if cast.rejuvenation("player") then
                br.addonDebug("[DEF]  Rejuv at: " .. tostring(php))
                return true
            end
        end
    end


end


-- Action List - Defensive
actionList.Defensive = function()

    --Healthstone / Heathpots :  156634 == Silas Vial of Continuous curing / 5512 == warlock health stones
    if ui.checked("Pot/Stoned") and php <= br.getValue("Pot/Stoned") and (br.hasHealthPot() or br.hasItem(5512) or br.hasItem(156634) or br.hasItem(177278)) then
        if br.canUseItem(177278) then
            br.useItem(177278)
        elseif br.canUseItem(5512) then
            br.useItem(5512)
        elseif br.canUseItem(171267) then
            br.useItem(171267)
        elseif br.canUseItem(169451) then
            br.useItem(169451)
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
    if ui.checked("Renewal") and talent.renewal and php <= br.getValue("Renewal") then
        if cast.renewal("player") then
            return
        end
    end
    -- Barkskin
    if ui.checked("Barkskin") and inCombat and php <= br.getValue("Barkskin") then
        if cast.barkskin() then
            return
        end
    end


    -- Rebirth
    if inCombat and ui.checked("Rebirth") and cd.rebirth.remain() <= gcd and not br.isMoving("player") then
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


    -- Remove Corruption
    if ui.checked("Remove Corruption") then
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


end -- End Action List - Defensive
-- Action List - Interrrupt
actionList.Interrupt = function()


    if br.useInterrupts() and not br.isCastingSpell(br.player.spell.convokeTheSpirits) then
        for i = 1, #enemies.yards45 do
            thisUnit = enemies.yards45[i]
            if br.canInterrupt(thisUnit, br.getValue("InterruptAt")) then
                -- Solar Beam
                if cast.solarBeam(thisUnit) then
                    return
                end
            end
        end
    end

    if cast.able.soothe() and ui.checked("Auto Soothe") then
        for i = 1, #enemies.yards45 do
            thisUnit = enemies.yards45[i]
            if br.canDispel(thisUnit, spell.soothe) then
                if cast.soothe(thisUnit) then
                    return true
                end
            end
        end
    end
    local radar = "off"

    --Building root list
    local root_UnitList = {}
    if ui.checked("Mist - Spirit vulpin") then
        root_UnitList[165251] = "Spirit vulpin"
        radar = "on"
    end
    if ui.checked("Plague - Globgrod") then
        root_UnitList[171887] = "Smorgasbord"
        radar = "on"
    end
    if ui.checked("Root - Spiteful(M+)") then
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

end -- End Action List - Interrupt
-- Action List - Cooldowns
actionList.cooldown = function()


    if race == "Troll" and buff.celestialAlignment.remains() > 15 then
        cast.racial("player")
    end
    --quantum device with pewbuff
    if trinket13 == 179350 or trinket14 == 179350 then
        if br.canUseItem(179350) and buff.celestialAlignment.remains() > 15 then
            br.useItem(179350)
        end
    end
    --pots here
    -- potion,if=buff.ca_inc.remains>15 or fight_remains<25

    if br.isChecked("Auto Innervate") and inCombat and cast.able.innervate() then
        for i = 1, #br.friend do
            if br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" and br.getDistance(br.friend[i].unit) < 45
                    and not br.GetUnitIsDeadOrGhost(br.friend[i].unit) and
                    br.getLineOfSight(br.friend[i].unit) and
                    not br.hasBuff(29166, br.friend[i].unit)
            then
                if cast.innervate(br.friend[i].unit) then
                    return true
                end
            end
        end
    end

    -- Warrior of Elune
    if cd.warriorOfElune.ready() and br.useCDs() and talent.warriorOfElune and not buff.warriorOfElune.exists() then
        if cast.warriorOfElune() then
        end
    end


    -- Force Of Nature / treants
    if talent.forceOfNature and cast.able.forceOfNature() and astral_def > 20 then
        if br.player.ui.mode.forceofNature == 1 and br.getTTD("target") >= 10
                and (#enemies.yards12t >= br.getValue("Treant Targets") or br.isBoss())
        then
            if cast.forceOfNature("best", nil, 1, 15, true) then
                return true
            end
        elseif br.player.ui.mode.forceofNature == 2 and ui.checked("Treants Key") and br.SpecificToggle("Treants Key") and not br._G.GetCurrentKeyBoardFocus() then
            if cast.forceOfNature("best", nil, 1, 15, true) then
                return true
            end
        end
    end
end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
end -- End Action List - PreCombat

actionList.dps_boat = function()


    --  critnotup = not buff.balanceOfAllThingsNature.exists() and not buff.balanceOfAllThingsArcane.exists()
    critnotup = not br.UnitBuffID("player", 339943) and not br.UnitBuffID("player", 339946)
    boatUP = (br.UnitBuffID("player", 339943) or br.UnitBuffID("player", 339946)) and true or false
    -- ui.print("BoatUP: " .. tostring(boatUP))
    --starlord cancel here
    if talent.starlord then
        if (buff.balanceOfAllThingsNature.remains() > 4.5 or buff.balanceOfAllThingsArcane.remains() > 4.5)
                and (buff.celestialAlignment.remains() > 7 or (cd.empowerBond.remains() > 7 and not buff.kindredEmpowermentEnergize.exists() and covenant.kyrian.active))
        then
            br.cancelBuff(279709)
        end
    end

    --starsurge - its why we boat :)
    if not pool then
        if not noDamageCheck("target") and cast.able.starsurge(units.dyn45) then
            if boatUP then
                if cast.starsurge("target") then
                    br.addonDebug("[SS] - Critting a boatload")
                    return true
                end
            end
            --starsurge,if=(cooldown.convoke_the_spirits.remains<5&!druid.no_cds&(variable.convoke_desync|cooldown.ca_inc.remains<5))&astral_power>40&covenant.night_fae&!druid.no_cds
            if not noDamageCheck("target") and ((cd.convokeTheSpirits.remains() < 5 and cd.convokeTheSpirits.remains() - gcd > 0)
                    and br.useCDs() and (convoke_desync or cd.celestialAlignment.remains() < 5))
                    and power > 40 and covenant.nightFae.active and br.useCDs() and mode.cov == 1
            then
                if cast.starsurge("target") then
                    br.addonDebug("[SS] - Overflow1 - cd:" .. tostring(cd.convokeTheSpirits.remains()))
                    return true
                end
            end
        end
    end

    dot_requirements = (buff.eclipse_solar.remains() > gcdMax or buff.eclipse_lunar.remains() > gcdMax)
    if (critnotup or pool) and dot_requirements and astral_def >= 2 then
        if debuff.sunfire.refresh("target") and br.getTTD("target") > 16 then
            if cast.sunfire("target") then
                return true
            end
        end
        if debuff.moonfire.refresh("target") and br.getTTD("target") > 13.5 then
            if cast.moonfire("target") then
                return true
            end
        end
        if debuff.stellarFlare.refresh("target") and br.getTTD("target") > 13.5 then
            if cast.stellarFlare("target") then
                return true
            end
        end
    end
    aspPerSec = int(current_eclipse == "lunar") * 8 / br.getCastTime(spell.starfire) + int(not current_eclipse == "lunar") * (6 + int(talent.soulOfTheForest) * 3) / br.getCastTime(spell.wrath) + 0.2 / br._G.GetHaste() / 100

    --Starsurge .. what is this ...  wtf


    --|(talent.starlord.enabled&buff.ca_inc.up&(buff.starlord.stack<3|astral_power>90))

    if not pool then
        if not noDamageCheck("target") and cast.able.starsurge("target") then
            --[[   if (getTTDMAX() < 4 or power + aspPerSec * buff.eclipse_solar.remains() > 110)
                       and eclipse_in
                       and (not buff.celestialAlignment.exists() or not talent.starlord)
                       and (not cd.celestialAlignment.exists() or covenant.nightFae.active)
                       or talent.starlord and buff.celestialAlignment.exists() and (buff.starlord.count < 3 or power > 90)
                       ]]
            if power > 90 and (buff.eclipse_solar.remains() > 3 or buff.eclipse_lunar.remains() > 3)
            then
                if cast.starsurge("target") then
                    br.addonDebug("[SS] - Overflow2")
                    return true
                end
            end
        end
    end


    --[[
    0.00	new_moon,if=(buff.eclipse_lunar.remains>execute_time|(charges=2&recharge_time<5)|charges=3)&ap_check
    Use Moons in Lunar Eclipse and save Half+Full Moon for CA/Inc
    0.00	half_moon,if=(buff.eclipse_lunar.remains>execute_time&(cooldown.ca_inc.remains>50|cooldown.convoke_the_spirits.remains>50)|(charges=2&recharge_time<5)|charges=3)&ap_check
    0.00	full_moon,if=(buff.eclipse_lunar.remains>execute_time&(cooldown.ca_inc.remains>50|cooldown.convoke_the_spirits.remains>50)|(charges=2&recharge_time<5)|charges=3)&ap_check
    ]]

    if cast.able.starfire("target") and br.getFacing("player", "target", 45) and castWhileMoving
            and (critnotup or power < 30 or not cast.able.starsurge() or pool) then
        if current_eclipse == "lunar"
                or current_eclipse ~= "solar" and eclipse_next == "solar"
                or current_eclipse ~= "solar" and eclipse_next == "any"
                or (buff.warriorOfElune.exists() and current_eclipse == "lunar")
                or buff.celestialAlignment.remain() > br.getCastTime(spell.starfire) and (br._G.GetHaste() / 100) > 110
                or ((buff.celestialAlignment.remain() < br.getCastTime(spell.wrath) or buff.incarnationChoseOfElune.remain() < br.getCastTime(spell.wrath)) and buff.celestialAlignment.exists())
        then
            --    if cast.starfire(getBiggestUnitCluster(45, 8)) then
            if cast.starfire("target") then
                br.addonDebug("[SFIRE] Lunar:" .. tostring(current_eclipse == "lunar") .. " Solar:" .. tostring(current_eclipse == "solar") .. " Next:" .. eclipse_next .. " Crit?: " .. tostring(boatUP))
                return true
            end
        end
    end

    if br.getFacing("player", "target", 45) and castWhileMoving and (critnotup or power < 30 or not cast.able.starsurge() or pool) then
        if cast.wrath("target") then
            br.addonDebug("[WRATH] Lunar:" .. tostring(current_eclipse == "lunar") .. " Solar:" .. tostring(current_eclipse == "solar") .. " Next:" .. eclipse_next .. " Crit?: " .. tostring(boatUP))
            return true
        end
    end
end
--[[

P	29.17	starfire,if=eclipse.in_lunar|eclipse.solar_next|eclipse.any_next|buff.warrior_of_elune.up&buff.eclipse_lunar.up|(buff.ca_inc.remains<action.wrath.execute_time&buff.ca_inc.up)
Use Starfire to proc Solar Eclipse or when in only Lunar Eclipse and use WoE procs if in Lunar Eclipse
Q	60.14	wrath
R	0.00	run_action_list,name=fallthru
]]



actionList.kyrian = function()

    local partnerLinkGO

    if covenant.kyrian.active then

        if not br.UnitBuffID("player", 326967) and not buff.loneSpirit.exists() then
            ui.print("USE KINDRED SPIRITS YOU FOOL!!")
        end

        if br.UnitBuffID("player", 326967) and br.getSpellCD(326446) <= 0.2
                or buff.loneSpirit.exists() and cd.loneEmpowerment.ready() and (cd.celestialAlignment.remains() > 20 or cd.celestialAlignment.ready())
        then
            if br.UnitBuffID("player", 326967) and br.getSpellCD(326446) <= 0.2 then
                for i = 1, #br.friend do
                    thisUnit = br.friend[i].unit
                    --     ui.print("Unit: " .. tostring(thisUnit))
                    if br.UnitBuffID(thisUnit, 326434) and not br.GetUnitIsUnit("player", thisUnit) then
                        local empowerClass = select(2, br._G.UnitClass(thisUnit))
                        br.addonDebug("Buff Unit is : " .. tostring(thisUnit) .. " Class =" .. empowerClass)
                        if empowerClass == "MAGE" and br.UnitBuffID(thisUnit, 190319)
                                or empowerClass == "DRUID" and (br.UnitBuffID(thisUnit, 194223) or br.UnitBuffID(thisUnit, 102560))
                                or empowerClass == "WARRIOR" and br.UnitBuffID(thisUnit, 107574)
                                or empowerClass == "WARRIOR" and br.UnitBuffID(thisUnit, 46924)
                                or empowerClass == "WARLOCK" and br.UnitBuffID(thisUnit, 113860)
                                or empowerClass == "ROGUE" and br.UnitBuffID(thisUnit, 121471)
                                or empowerClass == "PALADIN" and br.UnitBuffID(thisUnit, 31884)
                                or empowerClass == "HUNTER" and br.UnitBuffID(thisUnit, 260402) --260402/double-tap
                                or empowerClass == "SHAMAN" and br.UnitBuffID(thisUnit, 191634) -- storm keeper
                                or empowerClass == "DEATHKNIGHT" and (br.UnitBuffID(thisUnit, 275699) or br.UnitBuffID(thisUnit, 63560) or br.UnitBuffID(thisUnit, 42650))
                        then
                            partnerLinkGO = true
                        end
                    end
                end

            end

            if partnerLinkGO or (buff.loneSpirit.exists() and cd.loneEmpowerment.ready() and getMaxTTD() > 15) or unit.isDummy("target") then

                if not debuff.sunfire.exists("target") then
                    if cast.sunfire("target") then
                        return true
                    end
                end

                if br.canUseItem(13) then
                    br.useItem(13)
                end
                if br.canUseItem(14) then
                    br.useItem(14)
                end

                if not debuff.moonfire.exists("target") then
                    if cast.moonfire("target") then
                        return true
                    end
                end
                if br.canUseItem(171349) then
                    br.useItem(171349)
                end
                if br.canUseItem(307096) then
                    br.useItem(307096)
                end
                --171273
                if br.canUseItem(171273) then
                    br.useItem(171273)
                end
                if race == "Troll" then
                    if cast.racial("player") then
                        return true
                    end
                end
                if cast.celestialAlignment() then
                end
                if cast.empowerBond("player") then
                    return true
                end
                if cast.loneEmpowerment("player") then
                    return true
                end
            end
        end
    end
end -- end Kyrian



actionList.dps_aoe = function()


    -- br.addonDebug("Pool: " .. tostring(pool) .. " TTD:" .. getMaxTTD() .. " Power: " .. power .. " Mobs:" .. tostring(#enemies.yards45))

    ignore_starsurge = current_eclipse ~= "solar" and (#enemies.yards8t > 5 and talent.soulOfTheForest or #enemies.yards8t > 7)

    --starfall
    if cd.starfall.ready() and (buff.starfall.refresh() or not buff.starfall.exists())
            and #enemies.yards45 >= 2 and getMaxTTD() > 10
    then
        if cast.starfall() then
            br.addonDebug("[STARFALL]Mobs: " .. #enemies.yards45 .. " GetTTD:" .. tostring(getMaxTTD()))
            return true
        end
    end


    --sunfire
    if br.timer:useTimer("sunfire_delay", 5) then
        splash_count = 0
        for i = 1, #enemies.yards45 do
            thisUnit = enemies.yards45[i]
            if br._G.UnitAffectingCombat(thisUnit) and not noDamageCheck(thisUnit) then
                if (br.getDistance(thisUnit, tank) <= 8 or #br.friend == 1) then
                    if debuff.sunfire.refresh(thisUnit) then
                        splash_count = splash_count + 1
                    end
                end
                if debuff.sunfire.refresh(thisUnit) and (splash_count == #enemies.yards45 or splash_count >= 2 or br.getCombatTime() > 3 or #br.friend == 1) then
                    if cast.sunfire(thisUnit) then
                        return true
                    end
                end
            end
        end
    end

    if not pool and not noDamageCheck(units.dyn45) and not ignore_starsurge and (#enemies.yards45 == 1 or buff.starfall.exists())
            and boatUP and #enemies.yards45 < 6 then
        if cast.starsurge(units.dyn45) then
            br.addonDebug("SS - BOAT")
            return true
        end
    end

    if cast.able.moonfire() and br.timer:useTimer("moonfire_delay", 4) then
        if current_eclipse == "solar" then
            for i = 1, #enemies.yards45 do
                thisUnit = enemies.yards45[i]
                if br._G.UnitAffectingCombat(thisUnit) then
                    if br.getTTD(thisUnit) > (buff.eclipse_solar.remains() + 6)
                            and (not debuff.moonfire.exists(thisUnit) or debuff.moonfire.refresh(thisUnit))
                    then
                        if cast.moonfire(thisUnit) then
                            return true
                        end
                    end
                end
            end
        else
            if #enemies.yards45 <= 5 or (not eclipse_in and br.getCombatTime() < 10) then
                for i = 1, #enemies.yards45 do
                    thisUnit = enemies.yards45[i]
                    if br._G.UnitAffectingCombat(thisUnit) then
                        if (current_eclipse == "lunar" and br.getTTD(thisUnit) > (buff.eclipse_lunar.remains() + 6)
                                or (br.getCombatTime() < 10 and not eclipse_in and br.getTTD(thisUnit) > 14)
                                or br.isBoss(thisUnit))
                                and (not debuff.moonfire.exists(thisUnit) or debuff.moonfire.refresh(thisUnit))
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


    --starsurge,
    if not noDamageCheck(units.dyn45) and cast.able.starsurge(units.dyn45) and #enemies.yards45 < 3 then
        if buff.onethsClearVision.exists()
                or (astral_def < 8
                or ((buff.incarnationChoseOfElune.remains() < 5 or buff.celestialAlignment.remains() < 5) and buff.celestialAlignment.exists()
                or (buff.ravenousFrenzy.remains() < gcd * math.ceil(power / 30) and buff.ravenousFrenzy.exists())))
                and (not runeforge.timewornDreambinder.equiped or #enemies.yards45 < 3) then
            if cast.starsurge(units.dyn45) then
                br.addonDebug("[SS] - 1")
                return true
            end
        end
    end


    --[[
      0.00	new_moon,if=(buff.eclipse_solar.remains>execute_time or (charges=2 and recharge_time<5) or charges=3) and ap_check
      Use Moons in Solar Eclipse and save Full Moon for CA/Inc
      0.00	half_moon,if=(buff.eclipse_solar.remains>execute_time or (charges=2 and recharge_time<5) or charges=3) and ap_check
      0.00	full_moon,if=(buff.eclipse_solar.remains>execute_time and (cooldown.ca_inc.remains>50 or cooldown.convoke_the_spirits.remains>50) or (charges=2 and recharge_time<5) or charges=3) and ap_check
    ]]

    if not noDamageCheck(units.dyn45) and br.getFacing("player", "target", 45) and castWhileMoving == true then
        if current_eclipse == "solar" and #enemies.yards45 < (4 + (br._G.GetMastery() / 100) / 20)
                or (eclipse_next == "lunar" and not eclipse_in) then
            --  or buff.eclipse_solar.exists() then
            if cast.wrath(units.dyn45) then
                br.addonDebug("wrath - eclipse is:" .. current_eclipse)
                return true
            end
        else
            if cast.able.starfire() then
                if cast.starfire(br.getBiggestUnitCluster(45, 8)) then
                    br.addonDebug("Starfire - eclipse is: " .. current_eclipse)
                    return true
                end
            end
        end
    end
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff = br.player.buff
    cast = br.player.cast
    cd = br.player.cd
    debuff = br.player.debuff
    covenant = br.player.covenant
    enemies = br.player.enemies
    equiped = br.player.equiped
    gcd = br.player.gcd
    gcdMax = br.player.gcdMax
    has = br.player.has
    inCombat = br.player.inCombat
    item = br.player.items
    level = br.player.level
    runeforge = br.player.runeforge
    mode = br.player.ui.mode
    php = br.player.health
    spell = br.player.spell
    talent = br.player.talent
    unit = br.player.unit
    units = br.player.units
    use = br.player.use
    ui = br.player.ui
    -- General Locals
    hastar = br.GetObjectExists("target")
    profileStop = profileStop or false
    ttd = br.getTTD
    haltProfile = br.pause() or drinking or mode.rotation == 4 or buff.soulshape.exists()
    units.get(45) -- Makes a variable called, units.dyn40
    enemies.get(8, "target") -- enemies.yards8t
    enemies.get(12, "target") -- enemies.yards12t
    enemies.get(45) -- Makes a varaible called, enemies.yards40
    -- Profile Specific Locals
    is_aoe = (#enemies.yards45 > 1 and (not talent.starlord or talent.stellarDrift) or #enemies.yards45 > 2) or false
    is_cleave = #enemies.yards8t > 1 or false
    pewbuff_spell = talent.incarnationChoseOfElune and "incarnationChoseOfElune" or "celestialAlignment"  --  if cast[pewbuff_spell]()
    convoke_desync = false
    Trinket13 = br._G.GetInventoryItemID("player", 13)
    Trinket14 = br._G.GetInventoryItemID("player", 14)
    eclipse_in = false
    current_eclipse = "none"
    eclipse_next = "any"
    splash_count = 0
    tanks = br.getTanksTable()
    inInstance = br.player.instance == "party" or br.player.instance == "scenario"
    power = br.player.power.astralPower.amount()
    starfire_in_solar = #enemies.yards8t > 4 + math.floor(br._G.GetHaste() % 20) + math.floor(buff.solarEmpowerment.stack() / 4)
    race = br.player.race
    cat = br.player.buff.catForm.exists()
    travel = br.player.buff.travelForm.exists()
    charges = br.player.charges
    solo = #br.friend == 1
    castWhileMoving = false
    boatUP = (br.UnitBuffID("player", 339943) or br.UnitBuffID("player", 339946)) and true or false
    castWhileMoving = (buff.starfall.exists() or not br.isMoving("player")) and true or false
    catspeed = br.player.buff.dash.exists() or br.player.buff.tigerDash.exists() or br.player.buff.stampedingRoar.exists() or br.player.buff.stampedingRoarCat.exists() or br.player.buff.stampedingRoar.exists()

    if talent.naturesBalance then
        astral_max = 95
    else
        astral_max = 100
    end
    astral_def = astral_max - power

    pool = false
    if ((getMaxTTD() < 20 or (#enemies.yards45 > 1 and buff.starfall.remains() > 5)) and power < 80)
            and not br.isBoss("target")
            and br.getUnitID("target") ~= 173729
    then
        pool = true
    end

    if br.player.buff["pewbuff"] == nil then
        br.player.buff["pewbuff"] = {}
    end
    if talent.incarnationChosenOfElune then
        br.api.buffs(br.player.buff["pewbuff"], 102560)
    else
        br.api.buffs(br.player.buff["pewbuff"], 194223)
    end





    ---------------------
    --- Begin Profile ---
    ---------------------

    if inCombat then

        local ChannelInfo = { br._G.UnitChannelInfo("player") }
        if ChannelInfo[4] then
            return true
        end

        if not is_aoe and power >= 30 and cast.able.starsurge() and not pool and
                (br.UnitBuffID("player", 339943) and br.UnitBuffID("player", 339946))
                and (br.isCastingSpell(br.player.spell.wrath) or br.isCastingSpell(br.player.spell.starfire))
        then
            br._G.SpellStopCasting()
            --       ui.print("STOP! - should surge")
            if cast.starsurge("target") then
                br.addonDebug("[SS] - SURGE SNIPE")
                return true
            end

        end
    end
    -- Profile Stop  or  Pause
    if not inCombat and not hastar and profileStop then
        profileStop = false
    elseif haltProfile then
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
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
            else
                if not br.player.buff.moonkinForm.exists() and not cast.last.moonkinForm(1) then
                    unit.cancelForm()
                    if cast.moonkinForm() then
                        return true
                    end
                end
            end
        end

        if actionList.Extra() then
            return true
        end
        if actionList.Heal() then
            return true
        end
        if actionList.Defensive() then
            return true
        end
        if actionList.PreCombat() then
            return true
        end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------

        --pre-combat variables

        if inCombat and cd.global.remain() == 0 and not br.isCastingSpell(323764) then

            if #tanks > 0 and inInstance then
                tank = tanks[1].unit
            else
                tank = "Player"
            end


            --Auto attack
            if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) then
                br._G.StartAttack()
            end

            if spellQueueReady() then
                if br.SpecificToggle("DPS Key") and not br._G.GetCurrentKeyBoardFocus() then
                    dps_key()
                end
                if actionList.Interrupt() then
                    return true
                end
                if math.ceil((getMaxTTD() - 15 - cd.celestialAlignment.remains()) / 180) == math.ceil((getMaxTTD() - 15 - 120 - cd.convokeTheSpirits.remains()) / 180)
                        or cd.celestialAlignment.remains() > getMaxTTD()
                        or cd.convokeTheSpirits.remains() > getMaxTTD() - 10
                        or not covenant.nightFae.active
                then
                    convoke_desync = true
                end
                EclipseUpdate()
                if actionList.cooldown() then
                    return true
                end
                if mode.forms ~= 3 then
                    if not br.player.buff.moonkinForm.exists() and not cast.last.moonkinForm(1) then
                        unit.cancelForm()
                        if cast.moonkinForm() then
                            return true
                        end
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

                    if br.isChecked("Starfall While moving") and not castWhileMoving and talent.stellarDrift and not buff.starfall.exists() and br.getValue("Starfall") ~= 3 then
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

                if actionList.Heal() then
                    return true
                end
                if covenant.kyrian.active and (cd.loneEmpowerment.ready() or cd.empowerBond.ready()) then
                    if actionList.kyrian() then
                        return true
                    end
                end

                if mode.rotation == 1 and is_aoe or mode.rotation == 2 then
                    if actionList.dps_aoe() then
                        return true
                    end
                elseif runeforge.balanceOfAllThings.equiped and (not is_aoe or mode.rotation == 3) then
                    if actionList.dps_boat() then
                        return true
                    end
                else
                    br.addonDebug("nope, not supported ")
                end
            end

        end -- End In Combat Rotation
    end -- Pause
    return true
end -- End runRotation
local id = 102 -- Change to the spec id profile is for.
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
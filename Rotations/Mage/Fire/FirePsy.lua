local rotationName = "KinkyFireSL"
local versionNum = "1.0.0"
local colorRed      = "|cffFF0000"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.flamestrike},
        [2] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.iceBlock}
    };
    CreateButton("Rotation",1,0)

-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.timeWarp},
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.timeWarp},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.timeWarp}
    };
    CreateButton("Cooldown",2,0)

-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.blazingBarrier},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.blazingBarrier}
    };
    CreateButton("Defensive",3,0)

-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterspell},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterspell}
    };
    CreateButton("Interrupt",4,0)

-- Combustion Button
    CombustionModes = {
        [1] = {mode = "On", value = 1, overlay = "AoE Enabled", tip = "Will use AoE During Combustion", highlight = 1, icon = br.player.spell.combustion},
        [2] = {mode = "Off", value = 0, overlay = "AoE Disabled", tip = "Will Not use AoE During Combustion", highlight = 0, icon = br.player.spell.combustion}
    };
    CreateButton("Combustion",5,0)

    -- Dragonbreath Button
    DragonsBreathModes = {
       [1] = { mode = "On", value = 1 , overlay = "Dragonbreath Enabled", tip = "Always use Dragonbreath.", highlight = 1, icon = br.player.spell.dragonsBreath},
       [2] = { mode = "Off", value = 2 , overlay = "Dragonbreath Disabled", tip = "Don't use Dragonbreath.", highlight = 0, icon = br.player.spell.dragonsBreath}
    };
    CreateButton("DragonsBreath",6,0)
-- Save FB Button
    SaveFBModes = {
       [1] = { mode = "On", value = 1 , overlay = "Using Fireblasts", tip = "Use Fireblast Charges.", highlight = 1, icon = br.player.spell.fireBlast},
       [2] = { mode = "Off", value = 2 , overlay = "Saving Fireblasts", tip = "Save Fireblast Charges.", highlight = 0, icon = br.player.spell.fireBlast}
    };
    CreateButton("SaveFB",1,1)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
    -- General Options
         section = br.ui:createSection(br.ui.window.profile, colorRed .. "Fire " .. ".:|:. General ".. "Ver|" ..colorRed .. rotationVer .. ".:|:. ")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  1,  1,  60,  1,  "|cffFFFFFFSet to desired time for test in minuts. Min: 1 / Max: 60 / Interval: 5")

        br.ui:checkSectionState(section)
    -- Pre-Combat Options
        section = br.ui:createSection(br.ui.window.profile, "Pre-Combat")

        -- Pig Catcher
            br.ui:createCheckbox(section, "Pig Catcher")

        -- Auto Buff Arcane Intellect
            br.ui:createCheckbox(section,"Arcane Intellect", "Check to auto buff Arcane Intellect on party.")

        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")

        -- Out of Combat Attack
            br.ui:createCheckbox(section,"Pull OoC", "Check to Engage the Target out of Combat.")
        br.ui:checkSectionState(section)
    -- AoE Options
        section = br.ui:createSection(br.ui.window.profile, colorRed .. "AoE " .. ".:|:. " .. colorRed .. " Area of Effect")

        -- AoE Meteor
            br.ui:createSpinner(section,"Meteor Targets",  3,  1,  10,  1, "Min AoE Units")
            br.ui:createCheckbox(section, "Use Meteor outside ROP", "If Unchecked, will only use Meteor if ROP buff is up")

        -- Flamestrike
            br.ui:createSpinnerWithout(section,"FS Targets (Hot Streak)",  3,  1,  10,  1, "Min AoE Units")
            br.ui:createSpinnerWithout(section,"FS Targets (Flame Patch)",  3,  1,  10,  1, "Min AoE Units")

        -- Rune of Power
            br.ui:createSpinnerWithout(section,"RoP Targets",  3,  1,  10,  1, "Min AoE Units")

        -- Combustion (Firestarter)
            br.ui:createSpinnerWithout(section,"Combustion Targets",  3,  1,  10,  1, "Min AoE Units to use Combustion with Firestarter Talent")

        -- Focused Beam
            br.ui:createSpinnerWithout(section, "Focused Beam Targets",  3,  2,  10,  1, "Unit Count Limit before casting Focused Beam.")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, colorRed .. "CDs " .. ".:|:. " ..colorRed .. " Cooldowns")
         -- Use Essence
            br.ui:createCheckbox(section, "Use Essence")

         -- Augment
            br.ui:createCheckbox(section,"Augment")

         -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Greater Flask of Endless Fathoms","Flask of Endless Fathoms","None"}, 1, "|cffFFFFFFSet Elixir to use.")

         -- Potion
            br.ui:createCheckbox(section,"Potion")

        -- Mirror Image
            br.ui:createCheckbox(section,"Mirror Image")

        -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF001st Only","|cff00FF002nd Only","|cffFFFF00Both","|cffFF0000None"}, 1, "|cffFFFFFFSelect Trinket Usage.")

        -- Racial 
            br.ui:createCheckbox(section,"Racial")

        br.ui:checkSectionState(section)
    -- Defensive Option
        section = br.ui:createSection(br.ui.window.profile, colorRed .. "DEF" .. ".:|:. " ..colorRed .. " Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end

        -- Blast Wave
            br.ui:createSpinner(section, "Blast Wave",  30,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

        -- Blazing Barrier
            br.ui:createSpinner(section,"Blazing Barrier", 85, 0, 100, 5,   "|cffFFBB00Health Percentage to use at.")
            br.ui:createCheckbox(section, "Blazing Barrier OOC")
        -- Frost Nova
            br.ui:createSpinner(section, "Frost Nova",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        -- Ice Block
            br.ui:createSpinner(section, "Ice Block", 15, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")
        -- Spellsteal
            br.ui:createDropdown(section,"Spellsteal", {"|cffFFFF00Selected Target","|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Couterspell
            br.ui:createCheckbox(section, "Counterspell")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
        -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
        -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
        -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
        -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Defensive",0.25)
    UpdateToggle("Interrupt",0.25)
    br.player.ui.mode.cb = br.data.settings[br.selectedSpec].toggles["Combustion"]
    UpdateToggle("Combustion",0.25)
--------------
--- Locals ---
--------------
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local hasMouse                                      = GetObjectExists("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local equiped                                       = br.player.equiped
        local essence                                       = br.player.essence
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local hasMouse                                      = GetObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local lootDelay                                     = getOptionValue("LootDelay")
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local item                                          = br.player.items
        local mode                                          = br.player.ui.mode
        local moving                                        = isMoving("player")     
        local php                                           = br.player.health
        local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local solo                                          = #br.friend == 1
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local traits                                        = br.player.traits
        local thp                                           = getHP("target")
        local ttd                                           = getTTD
        local units                                         = br.player.units
        local use                                           = br.player.use
        local spellHaste                                    = (1 + (GetHaste()/100))
        local crit                                          = GetSpellCritChance(3)
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local playerCasting                                 = UnitCastingInfo("player")
        local ui                                            = br.player.ui
        local cl                                            = br.read
        local travelTime                                    = getDistance("target") / 50 --Ice lance

        --cooldown.combustion.remains<action.fire_blast.full_recharge_time+cooldown.fire_blast.duration*azerite.blaster_master.enabled
        --if traits.blasterMaster then bMasterFBCRG = charges.fireBlast.timeTillFull() + fblastCDduration else bMasterFBCRG = 0 end

        units.get(6)
        units.get(8)
        units.get(10)
        units.get(12)
        units.get(16)
        units.get(25)
        units.get(30)
        units.get(40)
        enemies.get(6)
        enemies.get(8)
        enemies.get(10)
        enemies.get(10, "player", true)
        enemies.get(12)
        enemies.get(16)
        enemies.get(25)
        enemies.get(30)
        enemies.get(40)
        enemies.get(6,"target")
        enemies.get(8,"target")
        enemies.get(10,"target")
        enemies.get(12,"target")
        enemies.get(16,"target")
        enemies.get(25,"target")
        enemies.get(30,"target")
        enemies.get(40,"target")

        if #enemies.yards6t > 0 then fSEnemies = #enemies.yards6t else fSEnemies = #enemies.yards40 end
        local dBEnemies = getEnemies(units.dyn12, 6, true)
        local firestarterActive = talent.firestarter and thp > 90
        local firestarterInactive = thp < 90 or isDummy()

        local function firestarterRemain(unit, pct)
            if not GetObjectExists(unit) then return -1 end
            if not string.find(unit,"0x") then unit = ObjectPointer(unit) end
            if getOptionCheck("Enhanced Time to Die") and getHP(unit) > pct and br.unitSetup.cache[unit] ~= nil then
                return br.unitSetup.cache[unit]:unitTtd(pct)
            end
            return -1
        end

        local combustionROPcutoff = 60
        local firestarterremain = firestarterRemain("target", 90)
        local cdMeteorDuration = 45 --select(2,GetSpellCooldown(spell.meteor))
        local fblastCDduration = select(2,GetSpellCooldown(spell.fireBlast))
        local pblastcasttime = cast.time.pyroblast()

        if traits.blasterMaster.active then bMasterFBCD = cd.fireBlast.remain() + fblastCDduration else bMasterFBCD = 0 end

        local var = {}
        var.VarHoldCombustionThreshold = 0
        if talent.flamePatch then var.VarHotStreakFlamestrike = 2 * 1 + 99 * 0 elseif not talent.flamePatch then var.VarHotStreakFlamestrike =  2 * 0 + 99 * 1 end
        if talent.flamePatch then var.VarHardCastFlamestrike = 3 * 1 + 99 * 0 elseif not talent.flamePatch then var.VarHardCastFlamestrike =  3 * 0 + 99 * 1 end
        var.VarDelayFlamestrike = 0
        var.VarFireBlastPooling = 0
        var.VarPhoenixPooling = talent.runeOfPower and cd.runeOfPower.remain() < cd.phoenixFlames.remain() and cd.combustion.remain() > combustionROPcutoff and (cd.runeOfPower.remain() < ttd("target") or charges.runeOfPower.count() > 0) or cd.combustion.remain() < charges.phoenixFlames.timeTillFull() and cd.combustion.remain() < ttd("target")
        var.VarCombustionOnUse = 0
        var.VarFontDoubleOnUse = 0
        var.VarFontPrecombatChannel = 0
        var.VarTimeToCombusion = 0
        var.VarKindlingReduction = 0
        var.VarOnUseCutoff = 0
        var.VarFireBlastPooling = talent.runeOfPower and cd.runeOfPower.remain() < cd.fireBlast.remain() and (cd.combustion.remain() > combustionROPcutoff or firestarterActive) and (cd.runeOfPower.remain() < ttd("target") or charges.runeOfPower.count() > 0) or cd.combustion.remain() < bMasterFBCD and firestarterInactive and cd.combustion.remain() < ttd("target") or talent.firestarter and firestarterActive and firestarterremain < bMasterFBCD --then
        IgnoreCombustion = mode.cb ~= 1 or not useCDs()

        -- spellqueue ready
        local function spellQueueReady()
            --Check if we can queue cast
            local castingInfo = {UnitCastingInfo("player")}
           if castingInfo[5] then
            if (GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow")))/1000)) < 0 then
                return false
            end
        end
        return true
    end

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


        if timersTable then
             wipe(timersTable)
        end

        --Clear last cast table ooc to avoid strange casts
        if not inCombat and #br.lastCast.tracker > 0 then
            wipe(br.lastCast.tracker)
        end

        local dispelDelay = 1.5
        if isChecked("Dispel delay") then
            dispelDelay = getValue("Dispel delay")
        end

         --Spell steal
        local doNotSteal = {
            [273432] = "Bound By Shadow(Uldir)",
            [269935] = "Bound By Shadow(KR)"
        }
        local function spellstealCheck(unit)
            local i = 1
            local buffName, _, _, _, duration, expirationTime, _, isStealable, _, spellId = UnitBuff(unit, i)
            while buffName do
                if doNotSteal[spellId] then
                    return false
                elseif isStealable and (GetTime() - (expirationTime - duration)) > dispelDelay then
                    return true
                end
                i = i + 1
                buffName, _, _, _, duration, expirationTime, _, isStealable, _, spellId = UnitBuff(unit, i)            
            end
            return false
        end
        local function meteor(unit)
            local combatRange = max(5, UnitCombatReach("player") + UnitCombatReach(unit))
            local px, py, pz = ObjectPosition("player")
            local x, y, z = GetPositionBetweenObjects(unit, "player", combatRange - 2)
            z = select(3, TraceLine(x, y, z + 5, x, y, z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
            if z ~= nil and TraceLine(px, py, pz + 2, x, y, z + 1, 0x100010) == nil and TraceLine(x, y, z + 4, x, y, z, 0x1) == nil then -- Check z and LoS, ignore terrain and m2 colissions and check no m2 on hook location
                CastSpellByName(GetSpellInfo(spell.meteor))
                br.addonDebug("Casting Meteor")
                ClickPosition(x, y, z)
                if wasMouseLooking then
                    MouselookStart()
                end
            end
        end

        local fbTracker = 0
        for i = 1, 3 do
            local cast = br.lastCast.tracker[i]
            if cast == 108853 then
                fbTracker = fbTracker + 1
            end
        end

        local instantPyro = getCastTime(spell.pyroblast) == 0 or false

--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
        -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if combatTime >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end -- End Dummy Test
            -- Arcane Intellect
            if isChecked("Arcane Intellect") and br.timer:useTimer("AI Delay", math.random(15, 30)) then
                for i = 1, #br.friend do
                    if not buff.arcaneIntellect.exists(br.friend[i].unit,"any") and getDistance("player", br.friend[i].unit) < 40 and not UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsPlayer(br.friend[i].unit) then
                        if cast.arcaneIntellect() then return true end
                    end
                end
            end
        end -- End Action List - Extras

    -- Action List - Defensive
        local function actionList_Defensive()
            if useDefensive() then
        -- Pot/Stoned
                if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned") 
                    and inCombat and (hasHealthPot() or hasItem(5512)) 
                then
                    if canUseItem(5512) then
                        useItem(5512)
                    elseif canUseItem(healPot) then
                        useItem(healPot)
                    end
                end

        -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                        end
                    end
                end

        -- Gift of the Naaru
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                    if castSpell("player",racial,false,false,false) then return end
                end

        -- Frost Nova
                if isChecked("Frost Nova") and php <= getOptionValue("Frost Nova") and #enemies.yards10 > 0 then
                    if cast.frostNova("player","aoe",1,10) then return end --Print("fs") return end
                end

        -- Blast Wave
                if talent.blastWave and isChecked("Blast Wave") and php <= getOptionValue("Blast Wave") then
                    for i = 1, #enemies.yards10 do
                        local thisUnit = enemies.yards10[i]
                        if #enemies.yards10 > 1 and hasThreat(thisUnit) then
                            if cast.blastWave("player","aoe",1,10) then return end
                        end
                    end
                end

        -- Blazing Barrier
                if isChecked("Blazing Barrier") and ((php <= getOptionValue("Blazing Barrier") and inCombat) or (isChecked("Blazing Barrier OOC") and not inCombat)) and not buff.blazingBarrier.exists() and not isCastingSpell(spell.fireball) and not buff.hotStreak.exists() and not buff.heatingUp.exists() then
                    if cast.blazingBarrier("player") then return end
                end

        -- Iceblock
                if isChecked("Ice Block") and php <= getOptionValue("Ice Block") and cd.iceBlock.remains() <= gcd and not solo then
                    if UnitCastingInfo("player") then
                        RunMacroText('/stopcasting')
                    end
                    if cast.iceBlock("player") then
                        return true
                    end
                end

        -- Spell Steal
        if isChecked("Spellsteal") then
            if getOptionValue("Spellsteal") == 1 then
                if spellstealCheck("target") and GetObjectExists("target") then
                    if cast.spellsteal("target") then br.addonDebug("Casting Spellsteal") return true end
                end
            elseif getOptionValue("Spellsteal") == 2 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if spellstealCheck(thisUnit) then
                        if cast.spellsteal(thisUnit) then br.addonDebug("Casting Spellsteal") return true end
                    end
                end
            end
        end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
        
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemies.yards40 do
                    thisUnit = enemies.yards40[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        -- Counterspell
                        if isChecked("Counterspell") then
                            if cast.counterspell(thisUnit) then return end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts

    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            if useCDs() and getDistance("target") < 40 then
        -- Potion
            if isChecked("Potion") and not buff.potionOfUnbridledFury.exists() and canUseItem(item.potionOfUnbridledFury) and buff.combustion.exists("player") then
                if use.potionOfUnbridledFury() then br.addonDebug("Using Potion of Unbridled Fury") return end
            end

        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury | berserking | arcane_torrent
                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "Blood Elf") and buff.combustion.exists("player") then
                    if castSpell("player",racial,false,false,false) then return end
                end

                -- Trinkets
                local mainHand = GetInventorySlotInfo("MAINHANDSLOT")
                if canUseItem(mainHand) and equiped.neuralSynapseEnhancer(mainHand) and ((talent.runeOfPower and buff.runeOfPower.exists("player")) or not talent.runeOfPower) then
                    use.slot(mainHand)
                    br.addonDebug("Using Neural SynapseEnhancer")
                end

                for i = 13, 14 do
                    local opValue = getOptionValue("Trinkets")
                    local iValue = i - 12
                    if (opValue == iValue or opValue == 3) and use.able.slot(i) then
                        if equiped.azsharasFontOfPower(i) and not buff.combustion.exists("player") and not buff.runeOfPower.exists("player") and not UnitBuffID("player",296962) then
                            if UnitCastingInfo("player") then
                                SpellStopCasting()
                            end
                            use.slot(i)
                            br.addonDebug("Using Azshara's Font of Power")
                            return
                        end
                        if equiped.shiverVenomRelic(i) and isChecked("Shiver Venoms") then
                            if  getDebuffStacks("target", 301624) == 5 then
                                if UnitCastingInfo("player") then
                                    SpellStopCasting()
                                end
                                use.slot(i)
                                br.addonDebug("Using Shiver Venom Relic")
                            end
                        end
                    end
                end

                if buff.combustion.exists("player") then 
                    if (getOptionValue("Trinkets") == 1 or getOptionValue("Trinkets") == 3) and canUseItem(13) 
                    and not equiped.azsharasFontOfPower(13) then
                        if UnitCastingInfo("player") then
                            SpellStopCasting()
                        end
                        useItem(13)
                        br.addonDebug("Using Trinket 1")
                        return
                    end

                    if (getOptionValue("Trinkets") == 2 or getOptionValue("Trinkets") == 3) and canUseItem(14) 
                    and not equiped.azsharasFontOfPower(14) then
                        if UnitCastingInfo("player") then
                            SpellStopCasting()
                        end
                        useItem(14)
                        br.addonDebug("Using Trinket 2")
                        return
                    end
                end
            end -- End useCDs check
        end -- End Action List - Cooldowns

    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then
                if isChecked("Pig Catcher") then
                    bossHelper()
                end
                if isChecked("Pre-Pull") then
                    -- Flask / Crystal
                    if ((pullTimer <= getValue("Pre-Pull") and pullTimer > 4 and (not equiped.azsharasFontOfPower or not canUseItem(item.azsharasFontOfPower))) or (equiped.azsharasFontOfPower and canUseItem(item.azsharasFontOfPower) and pullTimer <= 20 and pullTimer > 8)) then
                        if getOptionValue("Elixir") == 1 and inRaid and not buff.greaterFlaskOfEndlessFathoms.exists() and canUseItem(item.greaterFlaskOfEndlessFathoms) then
                            if use.greaterFlaskOfEndlessFathoms() then br.addonDebug("Using Greater Flask of Endless Fathoms") return end
                        elseif getOptionValue("Elixir") == 2 and inRaid and not buff.flaskOfEndlessFathoms.exists() and canUseItem(item.flaskOfEndlessFathoms) then
                            if use.flaskOfEndlessFathoms() then br.addonDebug("Using Flask of Endless Fathoms") return end
                        end
                        -- augment
                        if isChecked("Augment") and not buff.battleScarredAugmentRune.exists() and canUseItem(item.battleScarredAugmentRune) then
                            if use.battleScarredAugmentRune() then br.addonDebug("Using Battle-Scarred Augment Rune") return end
                        end
                        -- potion
                        if isChecked("Potion") and not buff.potionOfUnbridledFury.exists() and canUseItem(item.potionOfUnbridledFury) then
                            if use.potionOfUnbridledFury() then br.addonDebug("Using Potion of Unbridled Fury") return end
                        end
                        -- Mirror Image
                        if isChecked("Mirror Image") and talent.mirrorImage and br.timer:useTimer("MI Delay", 2) then
                            if cast.mirrorImage() then br.addonDebug("Casting Mirror Image") return end
                        end
                    elseif equiped.azsharasFontOfPower and canUseItem(item.azsharasFontOfPower) and pullTimer <= 8 and pullTimer > 4 then
                        if br.timer:useTimer("Font Delay", 4) then
                            br.addonDebug("Using Font Of Azshara")
                            useItem(169314)
                        end
                    elseif pullTimer <= 4 and br.timer:useTimer("PB Delay",5) then
                        CastSpellByName(GetSpellInfo(spell.pyroblast)) br.addonDebug("Casting Pyroblast") return
                    end

                    var.VarDelayFlamestrike = 25
                    var.VarKindlingReduction = 0.2
                    var.VarHoldCombustionThreshold = 20
                end -- End Pre-Pull        
            end -- End No Combat
        end -- End Action List - PreCombat

    local function actionList_ActiveTalents()
        -- living_bomb,if=active_enemies>1&buff.combustion.down&(variable.time_to_combustion>cooldown.living_bomb.duration|variable.time_to_combustion<=0|variable.disable_combustion)
        if cast.able.livingBomb() and (#enemies.yards10t > 1 and not buff.combustion.exists()) and (VarTimeToCombustion > 12 * spellHaste or VarTimeToCombustion <= 0 or IgnoreCombustion) then
           if cast.livingBomb("target") then return true end 
        end

        -- meteor,if=!variable.disable_combustion&variable.time_to_combustion<=0|(buff.rune_of_power.up|cooldown.rune_of_power.remains>target.time_to_die&action.rune_of_power.charges<1|!talent.rune_of_power.enabled)&(cooldown.meteor.duration<variable.time_to_combustion|target.time_to_die<variable.time_to_combustion|variable.disable_combustion)
        if cast.able.meteor() and (not IgnoreCombustion and var.VarTimeToCombusion <= 0 or buff.runeOfPower.exists() or cd.runeOfPower.remains() > getTTD("target") and charges.runeOfpower.count() < 1 or not cast.able.runeOfPower()) and ( 45 < var.VarTimeToCombusion or getTTD("target") < VarTimeToCombustion or IgnoreCombustion) then
            if createCastFunction("best", false, 1, 8, spell.meteor, nil, false, 0) and TargetLastEnemy() then return true end
        end

        -- dragons_breath,if=talent.alexstraszas_fury.enabled&(buff.combustion.down&!buff.hot_streak.react|buff.combustion.up&action.fire_blast.charges<action.fire_blast.max_charges&!buff.hot_streak.react)
        if cast.able.dragonsBreath() and (talent.alexstraszasFury and (not buff.combustion.exists() and not buff.hotStreak.exists() or buff.combustion.exists() and charges.fireBlast.count() < 3 and not buff.hotStreak.exists())) then
             if mode.dragonsBreath == 1 then
                if (getFacing("player","target",30) and (buff.combustion.remain() < gcdMax) and buff.combustion.exists() and getDistance("target") <= 8) then
                    if cast.dragonsBreath("player") then return end --dPrint("db2") return end
                elseif not buff.hotStreak.exists() then
                    if (getDistance("target") <= 8) and talent.alexstraszasFury then
                        if cast.dragonsBreath("player","cone",1,10) then return end --dPrint("db3") return end
                    end
                end
            end
        end
    end -- End Action List - Active Talents



    local function actionList_CombustionPhase()
        -- living_bomb,if=active_enemies>1&buff.combustion.down
        if S.LivingBomb:IsReadyP() and (EnemiesCount > 1 and Player:BuffDownP(S.CombustionBuff)) then
            if HR.Cast(S.LivingBomb, nil, nil, 40) then return "living_bomb 242"; end
        end

        if cast.able.livingBomb() and #enemies.yards10t > 1 and not buff.combustion.exists() then
            if cast.livingBomb("target") then return true end 
        end

        --racials
        if isChecked("Racial") then
            if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei" or race == "Troll" then
                if race == "LightforgedDraenei" then
                    if cast.racial("target","ground") then return true end
                else
                    if cast.racial("player") then return true end
                end
            end
        end

        -- rune_of_power,if=buff.rune_of_power.down&buff.combustion.down
        if cast.able.runeOfPower() and not buff.runeOfPower.exists() and not buff.combustion.exists() then
            if cast.runeOfPower("player") then return true end 
        end

        -- call_action_list,name=active_talents
        if actionList_ActiveTalents() then return end 

        -- combustion,use_off_gcd=1,use_while_casting=1,if=((action.meteor.in_flight&action.meteor.in_flight_remains<=0.5)|!talent.meteor.enabled&(essence.memory_of_lucid_dreams.major|buff.hot_streak.react|action.scorch.executing&action.scorch.execute_remains<0.5|action.pyroblast.executing&action.pyroblast.execute_remains<0.5))&(buff.rune_of_power.up|!talent.rune_of_power.enabled)
        -- Increased CastRemains checks to 1s, up from 0.5s, to help visibility
        if cast.able.combustion() and cast.inFlight.metoer() and cast.last.meteor() or not talent.meteor or buff.hotStreak.exists() or cast.current.scorch() and cast.getCastTimeRemain("player") < 1 or cast.current.pyroblast() and cast.getCastTimeRemain("player")  and buff.runeOfPower.exists() or not talent.runeOfPower then
           if cast.combustion("player") then return true end 
        end

        -- flamestrike,if=((talent.flame_patch.enabled&active_enemies>2)|active_enemies>6)&buff.hot_streak.react&!azerite.blaster_master.enabled
        if cast.able.flamestrike() and talent.flamePatch and #enemies.yards10t > 1 or #enemies.yards10t > 6 and buff.hotStreak.exists() and not traits.blasterMaster.active then
            if createCastFunction("best", false, 1, 8, spell.flamestrike, nil, true) then
                SpellStopTargeting()
                return true 
            end
        end

        -- pyroblast,if=buff.pyroclasm.react&buff.combustion.remains>cast_time
        if cast.able.pyroblast() and not moving and buff.pyroclasm.exists() and buff.combustion.remains() > cast.time.pyroblast() then
            if cast.pyroblast("target") then return true end 
        end

        -- pyroblast,if=buff.hot_streak.react
        if cast.able.pyroblast() and buff.hotStreak.exists() and buff.hotStreak.remains() > cast.time.pyroblast() then
           if cast.pyroblast("target") then return true end 
        end

        -- pyroblast,if=prev_gcd.1.scorch&buff.heating_up.up
        if cast.able.pyroblast() and not moving and last.cast.scorch() and buff.heatingUp.exists() then
            if cast.pyroblast("target") then return true end 
        end

        -- phoenix_flames
        if cast.able.phoenixFlames() then
            if cast.phoenixflames("player") then return true end 
        end

        -- scorch,if=buff.combustion.remains>cast_time&buff.combustion.up|buff.combustion.down&cooldown.combustion.remains<cast_time
        if cast.able.scorch() and buff.combustion.remains() > cast.time.scorch() and buff.combustion.exists() or not buff.combustion.exists() and cd.combustion.remains() < cast.time.scorch() then
            if cast.scorch("target") then return true end 
        end

        -- living_bomb,if=buff.combustion.remains<gcd.max&active_enemies>1
        if cast.able.livingBomb() and buff.combustion.remains() < gcd and #enemies.yards10t > 1 then
            if cast.livingBomb("target") then return true end 
        end

        -- dragons_breath,if=buff.combustion.remains<gcd.max&buff.combustion.up
        if cast.able.dragonsBreath() and buff.combustion.remains() < gcd and buff.combustion.exists() then
            if cast.dragonsBreath("player") then return true end
        end

        -- scorch,if=target.health.pct<=30&talent.searing_touch.enabled
        if cast.able.scorch() and thp <= 30 and talent.searingTouch then
            if cast.scorch("target") then return true end 
        end
    end

    local function actionList_RopPhase()
        -- flamestrike,if=(active_enemies>=variable.hot_streak_flamestrike&(time-buff.combustion.last_expire>variable.delay_flamestrike|variable.disable_combustion))&buff.hot_streak.react
        if cast.able.flamestrike() and ((#enemies.yards10t >= var.VarHotStreakFlamestrike and cast.timeSinceLast.combustion() - 10 > var.VarDelayFlamestrike or IgnoreCombustion))  and buff.hotStreak.exists() then
            if createCastFunction("best", false, 1, 8, spell.flamestrike, nil, true) then
                SpellStopTargeting()
                return true 
            end
      end


      -- pyroblast,if=buff.hot_streak.react
      if cast.able.pyroblast() and buff.hotStreak.exists() then
          if cast.pyroblast("target") then return true end 
      end


      -- fire_blast,use_off_gcd=1,use_while_casting=1,if=!(active_enemies>=variable.hard_cast_flamestrike&(time-buff.combustion.last_expire>variable.delay_flamestrike|variable.disable_combustion))&!firestarter.active&(!buff.heating_up.react&!buff.hot_streak.react&!prev_off_gcd.fire_blast&(action.fire_blast.charges>=2|(action.phoenix_flames.charges>=1&talent.phoenix_flames.enabled)|(talent.alexstraszas_fury.enabled&cooldown.dragons_breath.ready)|(talent.searing_touch.enabled&target.health.pct<=30|spell_crit>=1)))
      -- Using 85% crit, since CritChancePct() does not include Critical Mass's 15% crit
      if cast.able.fireBlast() and #enemies.yards10t < var.VarHardCastFlamestrike and cast.timeSinceLast.combustion() - 10 > var.VarDelayFlamestrike or IgnoreCombustion and firestarterInactive and not buff.heatingUp.exists() and not buff.hotStreak.exists() and not cast.last.fireBlast() and charges.fireBlast.count() >= 2 or charges.phoenixFlames.count() >= 1 and talent.phoenixFlames or talent.alexstraszasFury and cd.dragonsbreath.remains() <= gcdMax or talent.searingTouch and thp <= 30 or crit >= 85 then
            if br.timer:useTimer("fblastdelay", 0.21) then
                if cast.fireBlast("target") then return true end
            end
      end

      -- call_action_list,name=active_talents
      if actionList_ActiveTalents() then return end 


      -- pyroblast,if=buff.pyroclasm.react&cast_time<buff.pyroclasm.remains&buff.rune_of_power.remains>cast_time
      if cast.able.pyroblast() and buff.pyroclasm.exists() and cast.time.pyroblast() < buff.pyroclasm.remains() and buff.runeOfPower.remains() > cast.time.pyroblast() then
        if cast.pyroblast("target") then return true end 
      end
    

      -- fire_blast,use_off_gcd=1,use_while_casting=1,if=!(active_enemies>=variable.hard_cast_flamestrike&(time-buff.combustion.last_expire>variable.delay_flamestrike|variable.disable_combustion))&!firestarter.active&(buff.heating_up.react&spell_crit<1&(target.health.pct>=30|!talent.searing_touch.enabled))
      -- Using 85% crit, since CritChancePct() does not include Critical Mass's 15% crit
      if cast.able.fireBlast() and ( #enemies.yards10t < var.VarHardCastFlamestrike and cast.timeSinceLast.combustion()  - 10 > var.VarDelayFlamestrike or IgnoreCombustion) and firestarterInactive and buff.heatingUp.exists() and crit < 85 and thp >= 30 or not talent.searingTouch then
         if cast.fireBlast("target") then return true end 
      end


      -- fire_blast,use_off_gcd=1,use_while_casting=1,if=!(active_enemies>=variable.hard_cast_flamestrike&(time-buff.combustion.last_expire>variable.delay_flamestrike|variable.disable_combustion))&!firestarter.active&(talent.searing_touch.enabled&target.health.pct<=30|spell_crit>=1)&(buff.heating_up.react&!action.scorch.executing|!buff.heating_up.react&!buff.hot_streak.react)
      -- Using 85% crit, since CritChancePct() does not include Critical Mass's 15% crit

     if cast.able.fireBlast() and #enemies.yards10t < var.VarHardCastFlamestrike and cast.timeSinceLast.combustion() - 10 > var.VarDelayFlamestrike or IgnoreCombustion and firestarterInactive and talent.searingTouch and thp <= 30 or crit >= 1 and buff.heatingUp.exists() and not cast.current.scorch() or not buff.heatingUp.exists() and not buff.hotStreak.exists() then
         if cast.fireBlast("target") then return true end 
     end

      -- pyroblast,if=prev_gcd.1.scorch&buff.heating_up.up&(talent.searing_touch.enabled&target.health.pct<=30|spell_crit>=1)&!(active_enemies>=variable.hot_streak_flamestrike&(time-buff.combustion.last_expire>variable.delay_flamestrike|variable.disable_combustion))
      -- Using 85% crit, since CritChancePct() does not include Critical Mass's 15% crit


      -- phoenix_flames,if=!prev_gcd.1.phoenix_flames&buff.heating_up.react
      if cast.able.phoenixFlames() and not cast.last.phoenixFlames and buff.heatingUp.exists() and getFacing("player", "target") then
         if cast.phoenixFlames("target") then return end
      end


      -- scorch,if=target.health.pct<=30&talent.searing_touch.enabled|spell_crit>=1
      -- Using 85% crit, since CritChancePct() does not include Critical Mass's 15% crit
      if cast.able.scorch() and thp <= 30 and talent.searingTouch or crit >= 85 then
        if cast.scorch("target") then return true end 
      end


      -- dragons_breath,if=active_enemies>2
      if cast.able.dragonsBreath() and #enemies.yards10t > 2 and getFacing("player", "target") then
        if cast.dragonsBreath("player") then return true end 
      end


      -- flamestrike,if=(active_enemies>=variable.hard_cast_flamestrike&(time-buff.combustion.last_expire>variable.delay_flamestrike|variable.disable_combustion))
      if cast.able.flamestrike() and #enemies.yards10t >= var.VarHardCastFlamestrike and cast.timeSinceLast.combustion() - 10 > var.VarDelayFlamestrike or IgnoreCombustion then
            if createCastFunction("best", false, 1, 8, spell.flamestrike, nil, true) then
                SpellStopTargeting()
                return true 
            end
      end


      -- fireball
      if cast.able.fireball() and not moving then
        if cast.fireball("target") then return true end 
      end
    end -- End Action List - RoP Phase

    local function actionList_Standard()
        -- flamestrike,if=(active_enemies>=variable.hot_streak_flamestrike&(time-buff.combustion.last_expire>variable.delay_flamestrike|variable.disable_combustion))&buff.hot_streak.react
        if cast.able.flamestrike() and #enemies.yards10t >= var.VarHotStreakFlamestrike and cast.timeSinceLast.combustion() - 10 > var.VarDelayFlamestrike or IgnoreCombustion and buff.hotStreak.exists() then
            if createCastFunction("best", false, 1, 8, spell.flamestrike, nil, true) then
                SpellStopTargeting()
                return true 
            end
        end

        -- pyroblast,if=buff.hot_streak.react&buff.hot_streak.remains<action.fireball.execute_time
        if cast.able.pyroblast() and buff.hotStreak.exists() and buff.hotStreak.remains() < cast.time.fireball() then
            if cast.pyroblast("target") then return true end 
        end


        -- pyroblast,if=buff.hot_streak.react&(prev_gcd.1.fireball|firestarter.active|action.pyroblast.in_flight)
        if cast.able.pyroblast() and buff.hotStreak.exists() and cast.last.fireball() or firestarterActive or cast.inFlight.pyroblast() then
            if cast.pyroblast("target") then return true end 
        end


       -- phoenix_flames,if=charges>=3&active_enemies>2&!variable.phoenix_pooling
       if cast.able.phoenixFlames() and charges.phoenixFlames.count() >= 3 and #enemies.yards10t > 2 and not bool(var.VarPhoenixPooling) then
            if cast.phoenixFlames("player") then return true end 
       end


       -- pyroblast,if=buff.hot_streak.react&(target.health.pct<=30&talent.searing_touch.enabled|spell_crit>=1)
       -- Using 85% crit, since CritChancePct() does not include Critical Mass's 15% crit
       if cast.able.pyroblast() and buff.hotStreak.exists() and thp <= 30 and talent.searingTouch or crit >= 85 then
           if cast.pyroblast("target") then return true end 
       end


       -- pyroblast,if=buff.pyroclasm.react&cast_time<buff.pyroclasm.remains
       if cast.able.pyroblast() and buff.pyroclasm.exists() and cast.time.pyroblast() < buff.pyroclasm.remains() then
           if cast.pyroblast("target") then return true end 
       end

       -- fire_blast,use_off_gcd=1,use_while_casting=1,if=(buff.rune_of_power.down&!firestarter.active)&!variable.fire_blast_pooling&(((action.fireball.executing|action.pyroblast.executing)&buff.heating_up.react)|((talent.searing_touch.enabled&target.health.pct<=30|spell_crit>=1)&(buff.heating_up.react&!action.scorch.executing|!buff.hot_streak.react&!buff.heating_up.react&action.scorch.executing&!action.pyroblast.in_flight&!action.fireball.in_flight)))
       -- Using 85% crit, since CritChancePct() does not include Critical Mass's 15% crit
       if cast.able.fireBlast() and not buff.runeOfPower.exists() and firestarterInactive and not bool(var.VarFireBlastPooling) and cast.current.fireball() or cast.current.pyroblast() and buff.heatingUp.exists() or talent.searingTouch and thp <= 30 or crit >= 85 and buff.heatingUp.exists() and not cast.current.scorch() or not buff.hotStreak.exists() and not buff.heatingUp.exists() and cast.current.scorch() and not cast.inFlight.pyroblast() and not cast.inFlight.fireball() then
           if cast.fireBlast("target") then return true end 
       end


       -- pyroblast,if=prev_gcd.1.scorch&buff.heating_up.up&(talent.searing_touch.enabled&target.health.pct<=30|spell_crit>=1)&!(active_enemies>=variable.hot_streak_flamestrike&(time-buff.combustion.last_expire>variable.delay_flamestrike|variable.disable_combustion))
       -- Using 85% crit, since CritChancePct() does not include Critical Mass's 15% crit
       if cast.able.pyroblast() and cast.last.scorch() and buff.heatingUp.exists() and talent.searingTouch and thp <= 30 or crit >= 85 and not #enemies.yards10t >= var.VarHotStreakFlamestrike and cast.timeSinceLast.combustion() - 10 > var.VarDelayFlamestrike or IgnoreCombustion then
            if cast.pyroblast("target") then return true end
       end

  
       -- phoenix_flames,if=(buff.heating_up.react|(!buff.hot_streak.react&(action.fire_blast.charges>0|talent.searing_touch.enabled&target.health.pct<=30|spell_crit>=1)))&!variable.phoenix_pooling
       -- Using 85% crit, since CritChancePct() does not include Critical Mass's 15% crit
       if cast.able.phoenixFlames() and buff.heatingUp.exists() or buff.hotStreak.exists() and charges.fireBlast.count() > 0 or talent.searingTouch and thp <= 30 or crit >= 85 and not bool(VarPhoenixPooling) and getFacing("target", "player") then
           if cast.phoenixFlames("player") then return true end 
       end

       -- call_action_list,name=active_talents
       if actionList_ActiveTalents() then return end 

       -- dragons_breath,if=active_enemies>1
       if cast.able.dragonsBreath() and #enemies.yards10t > 1 and getFacing("target","player") then
           if cast.dragonsBreath("player") then return true end 
       end


  -- call_action_list,name=items_low_priority
 ---- if (Settings.Commons.UseTrinkets) then
  --  local ShouldReturn = ItemsLowPriority(); if ShouldReturn then return ShouldReturn; end
  --end


       -- scorch,if=target.health.pct<=30&talent.searing_touch.enabled|spell_crit>=1
       -- Using 85% crit, since CritChancePct() does not include Critical Mass's 15% crit
       if cast.able.scorch() and thp <= 30 and searingTouch or crit >= 85 then
            if cast.scorch("target") then return true end 
       end

       -- flamestrike,if=active_enemies>=variable.hard_cast_flamestrike&(time-buff.combustion.last_expire>variable.delay_flamestrike|variable.disable_combustion)
       if cast.able.flamestrike() and #enemies.yards10t >= var.VarHardCastFlamestrike and cast.timeSinceLast.combustion() - 10 > var.VarDelayFlamestrike or IgnoreCombustion then
            if createCastFunction("best", false, 1, 8, spell.flamestrike, nil, true) then
                SpellStopTargeting()
                return true 
            end
       end

          -- fireball
        if cast.able.fireball() and not moving then
             if cast.fireball("target") then return true end 
        end

        -- scorch
        if cast.able.scorch() then
             if cast.scorch("target") then return true end 
        end
    end

    local function actionList_Rotation()
        -- counterspell
       -- local ShouldReturn = Everyone.Interrupt(40, S.Counterspell, Settings.Commons.OffGCDasOffGCD.Counterspell, false); if ShouldReturn then return ShouldReturn; end

        -- variable,name=time_to_combustion,op=set,value=talent.firestarter.enabled*firestarter.remains+(cooldown.combustion.remains*(1-variable.kindling_reduction*talent.kindling.enabled)-action.rune_of_power.execute_time*talent.rune_of_power.enabled)*!cooldown.combustion.ready*buff.combustion.down

        
        
        -- variable,name=time_to_combustion,op=max,value=cooldown.memory_of_lucid_dreams.remains,if=essence.memory_of_lucid_dreams.major&buff.memory_of_lucid_dreams.down&cooldown.memory_of_lucid_dreams.remains-variable.time_to_combustion<=variable.hold_combustion_threshold
       -- if (Spell:MajorEssenceEnabled(AE.MemoryofLucidDreams) and Player:BuffDownP(S.MemoryofLucidDreams) and S.MemoryofLucidDreams:CooldownRemainsP() - VarTimeToCombusion <= VarHoldCombustionThreshold) then
        --  VarTimeToCombusion = S.MemoryofLucidDreams:CooldownRemainsP()
        --end

        -- variable,name=time_to_combustion,op=max,value=cooldown.worldvein_resonance.remains,if=essence.worldvein_resonance.major&buff.worldvein_resonance.down&cooldown.worldvein_resonance.remains-variable.time_to_combustion<=variable.hold_combustion_threshold
        --if (Spell:MajorEssenceEnabled(AE.WorldveinResonance) and Player:BuffDownP(S.WorldveinResonance) and S.WorldveinResonance:CooldownRemainsP() - VarTimeToCombusion <= VarHoldCombustionThreshold) then
         -- VarTimeToCombusion = S.WorldveinResonance:CooldownRemainsP()
        --end

        -- call_action_list,name=items_high_priority
        --if (Settings.Commons.UseTrinkets) then
       --   local ShouldReturn = ItemsHighPriority(); if ShouldReturn then return ShouldReturn; end
        --end

        -- mirror_image,if=buff.combustion.down
        --if S.MirrorImage:IsCastableP() and (Player:BuffDownP(S.CombustionBuff)) then
        --  if HR.Cast(S.MirrorImage) then return "mirror_image 791"; end
       -- end

        -- guardian_of_azeroth,if=(variable.time_to_combustion<10|target.time_to_die<variable.time_to_combustion)&!variable.disable_combustion
      -- if S.GuardianofAzeroth:IsCastableP() and ((VarTimeToCombusion < 10 or Target:TimeToDie() < VarTimeToCombusion) and not IgnoreCombustion) then
       --   if HR.Cast(S.GuardianofAzeroth, nil, Settings.Commons.EssenceDisplayStyle) then return "guardian_of_azeroth 793"; end
--
        -- concentrated_flame
       -- if S.ConcentratedFlame:IsCastableP() then
       --   if HR.Cast(S.ConcentratedFlame, nil, Settings.Commons.EssenceDisplayStyle, 40) then return "concentrated_flame 795"; end
      --  end
        
        -- reaping_flames
      --  if (true) then
       --   local ShouldReturn = Everyone.ReapingFlamesCast(Settings.Commons.EssenceDisplayStyle); if ShouldReturn then return ShouldReturn; end
     --   end
--
        -- focused_azerite_beam
       -- if S.FocusedAzeriteBeam:IsCastableP() then
       --   if HR.Cast(S.FocusedAzeriteBeam, nil, Settings.Commons.EssenceDisplayStyle) then return "focused_azerite_beam 797"; end
       -- end

        -- purifying_blast
       -- if S.PurifyingBlast:IsCastableP() then
       --   if HR.Cast(S.PurifyingBlast, nil, Settings.Commons.EssenceDisplayStyle, 40) then return "purifying_blast 799"; end
       -- end

        -- ripple_in_space
       -- if S.RippleInSpace:IsCastableP() then
        --  if HR.Cast(S.RippleInSpace, nil, Settings.Commons.EssenceDisplayStyle) then return "ripple_in_space 801"; end
       -- end

        -- the_unbound_force
       --- if S.TheUnboundForce:IsCastableP() then
       ---   if HR.Cast(S.TheUnboundForce, nil, Settings.Commons.EssenceDisplayStyle, 40) then return "the_unbound_force 803"; end
        ---end

        -- rune_of_power,if=buff.rune_of_power.down&(buff.combustion.down&buff.rune_of_power.down&(variable.time_to_combustion>full_recharge_time|variable.time_to_combustion>target.time_to_die)|variable.disable_combustion)
        --if S.RuneofPower:IsCastableP() and (Player:BuffDownP(S.RuneofPowerBuff) and (Player:BuffDownP(S.CombustionBuff) and Player:BuffDownP(S.RuneofPowerBuff) and (VarTimeToCombusion > S.RuneofPower:FullRechargeTimeP() or VarTimeToCombusion > Target:TimeToDie()) or IgnoreCombustion)) then
       ---  -- if HR.Cast(S.RuneofPower, Settings.Fire.GCDasOffGCD.RuneofPower) then return "rune_of_power 807"; end
       -- end

        -- call_action_list,name=combustion_phase,if=!variable.disable_combustion&variable.time_to_combustion<=0
        if (not IgnoreCombustion and useCDs() and not moving and (talent.runeOfPower and cd.combustion.remain() <= cast.time.runeOfPower() or cd.combustion.remain() == 0) and not firestarterActive or buff.combustion.exists()) then
          if actionList_CombustionPhase then return true end 
        end

        -- fire_blast,use_while_casting=1,use_off_gcd=1,if=(essence.memory_of_lucid_dreams.major|essence.memory_of_lucid_dreams.minor&azerite.blaster_master.enabled)&charges=max_charges&!buff.hot_streak.react&!(buff.heating_up.react&(buff.combustion.up&(action.fireball.in_flight|action.pyroblast.in_flight|action.scorch.executing)|target.health.pct<=30&action.scorch.executing))&!(!buff.heating_up.react&!buff.hot_streak.react&buff.combustion.down&(action.fireball.in_flight|action.pyroblast.in_flight))
        --if S.FireBlast:IsCastableP() and ((Spell:MajorEssenceEnabled(AE.MemoryofLucidDreams) or Spell:EssenceEnabled(AE.MemoryofLucidDreams) and S.BlasterMaster:AzeriteEnabled()) and S.FireBlast:ChargesP() == S.FireBlast:MaxCharges() and Player:BuffDownP(S.HotStreakBuff) and not (Player:BuffP(S.HeatingUpBuff) and (Player:BuffP(S.CombustionBuff) and (S.Fireball:InFlight() or S.Pyroblast:InFlight() or Player:IsCasting(S.Scorch)) or Target:HealthPercentage() <= 30 and Player:IsCasting(S.Scorch))) and not (Player:BuffDownP(S.HeatingUpBuff) and Player:BuffDownP(S.HotStreakBuff) and Player:BuffDownP(S.CombustionBuff) and (S.Fireball:InFlight() or S.Pyroblast:InFlight()))) then
     --     if HR.Cast(S.FireBlast, nil, nil, 40) then return "fire_blast 830"; end
      --  end

        -- call_action_list,name=rop_phase,if=buff.rune_of_power.up&(variable.time_to_combustion>0|variable.disable_combustion)
        if buff.runeOfPower.exists() and not buff.combustion.exists() or IgnoreCombustion then
           if actionList_RopPhase() then return end 
        end

        -- variable,name=fire_blast_pooling,value=talent.rune_of_power.enabled&cooldown.rune_of_power.remains<cooldown.fire_blast.full_recharge_time&(variable.time_to_combustion>action.rune_of_power.full_recharge_time|variable.disable_combustion)&(cooldown.rune_of_power.remains<target.time_to_die|action.rune_of_power.charges>0)|!variable.disable_combustion&variable.time_to_combustion<action.fire_blast.full_recharge_time&variable.time_to_combustion<target.time_to_die
        -- variable,name=phoenix_pooling,value=talent.rune_of_power.enabled&cooldown.rune_of_power.remains<cooldown.phoenix_flames.full_recharge_time&(variable.time_to_combustion>action.rune_of_power.full_recharge_time|variable.disable_combustion)&(cooldown.rune_of_power.remains<target.time_to_die|action.rune_of_power.charges>0)|!variable.disable_combustion&variable.time_to_combustion<action.phoenix_flames.full_recharge_time&variable.time_to_combustion<target.time_to_die
        var.VarPhoenixPooling = talent.RuneofPower and cd.runeOfPower.remains() < cd.phoenixFlames.timeTillFull() and (var.VarTimeToCombusion > cd.runeOfPower.timeTillFull() or IgnoreCombustion) and (cd.runeOfPower.remains() < getTTD("target") or charges.runeOfPower.count() > 0 or not IgnoreCombustion and var.VarTimeToCombusion < cd.phoenixFlames.timeTillFull() and var.VarTimeToCombusion < getTTD("target"))

        -- fire_blast,use_off_gcd=1,use_while_casting=1,if=(!variable.fire_blast_pooling|buff.rune_of_power.up)&(variable.time_to_combustion>0|variable.disable_combustion)&(active_enemies>=variable.hard_cast_flamestrike&(time-buff.combustion.last_expire>variable.delay_flamestrike|variable.disable_combustion))&!firestarter.active&buff.hot_streak.down&(!azerite.blaster_master.enabled|buff.blaster_master.remains<0.5)
        if cast.able.fireBlast() and not var.VarFireBlastPooling or buff.runeOfPower.exists() and var.VarTimeToCombusion > 0 or IgnoreCombustion and #enemies.yards10t >= var.VarHardCastFlamestrike and cast.timeSinceLast.combustion() - 10 > var.VarDelayFlamestrike or IgnoreCombustion and firestarterInactive and not buff.hotStreak.exists() and not traits.BlasterMaster or buff.blasterMaster.remains() < 0.5 then
            if cast.fireBlast() then return true end 
        end

        -- call_action_list,name=standard_rotation,if=variable.time_to_combustion>0|variable.disable_combustion
        if not buff.combustion.exists() and not buff.runeOfPower.exists() or IgnoreCombustion then       
            if actionList_Standard() then return end 
        end
    end

---------------------
--- Begin Profile ---
---------------------
        if buff.iceBlock.exists("player") and php >= 75 then
            cancelBuff(spell.iceBlock)
            br.addonDebug("Cancelling Iceblock")
        end
        if buff.hotStreak.exists("player") and IsAoEPending() then
            SpellStopTargeting()
            br.addonDebug(colorRed.."Aoe Not Cast. Canceling Spell",true)
            return false
        end
        if #enemies.yards8t < 2 then
            if buff.heatingUp.exists("player") and not cast.last.fireBlast() and (buff.combustion.exists("player") or (talent.runeOfPower and buff.runeOfPower.exists("player")) or (charges.fireBlast.timeTillFull() < cd.combustion.remains() or not useCDs())) then
                if cast.fireBlast() then br.addonDebug("Casting Fire Blast") end
            end
        elseif #enemies.yards8t >= 2 then
            if buff.heatingUp.exists("player") then
                if br.timer:useTimer("FB Delay", 0.5) then
                    if cast.fireBlast() then br.addonDebug("Casting Fire Blast") end
                end
            end
        end
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or pause() or mode.rotation == 4 then
            return true
        else
            if isChecked("Pull OoC") and solo and not inCombat then 
                if not moving then
                    if br.timer:useTimer("FB Delay", 1.5) then
                        if cast.fireball() then br.addonDebug("Casting Fireball (Pull Spell)") return end
                    end
                else
                    if br.timer:useTimer("Scorch Delay", 1.5) then
                        if cast.scorch() then br.addonDebug("Casting Scorch (Pull Spell)") return end
                    end
                end
            end
-----------------------
--- Extras Rotation ---
-----------------------
            if actionList_Extras() then return end
--------------------------
--- Defensive Rotation ---
--------------------------
            if actionList_Defensive() then return end
------------------------------
--- Out of Combat Rotation ---
------------------------------
            if actionList_PreCombat() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
            if inCombat and not profileStop then              
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
        -- Trinkets
        
                if actionList_Cooldowns() then return end

        -- The Unbound Force
                if isChecked("Use Essence") and essence.theUnboundForce.active and cd.theUnboundForce.remains() <= gcd and buff.recklessForce.exists("player") then
                    if cast.theUnboundForce() then br.addonDebug("Casting The Unbound Force") return end
                end
        ------------------------------
        -- MIRROR IMAGE --------------
        ------------------------------
                -- mirror_image,if=buff.combustion.down
                if useCDs() and isChecked("Mirror Image") and talent.mirrorImage and not buff.combustion.exists() and cd.combustion.remains() > gcd then
                    if br.timer:useTimer("MI Delay", 2) then
                        if cast.mirrorImage() then br.addonDebug("Casting Mirror Image") return end
                    end
                end
        -- Guardian of Azeroth
                if isChecked("Use Essence") and useCDs() and essence.condensedLifeForce.active and cd.guardianOfAzeroth.remains() <= gcd and not buff.combustion.exists("player") 
                    and not buff.runeOfPower.exists("player") 
                then
                    if cast.guardianOfAzeroth() then br.addonDebug("Casting Guardian of Azeroth") return end
                end
        -- Memory of Lucid Dreams
                if isChecked("Use Essence") and useCDs() and essence.memoryOfLucidDreams.active and cd.memoryOfLucidDreams.remains() <= gcd and cd.combustion.remains() <= gcd 
                    and not moving and (not talent.firestarter or (talent.firestarter and (getHP("target") <= 90) or #enemies.yards8t >= 3))
                then
                    if cast.memoryOfLucidDreams() then br.addonDebug("Casting Memory of Lucid Dreams") return end
                end
        ------------------------------
        -- RUNE OF POWER -------------
        ------------------------------
                if  (useCDs() or (#enemies.yards8t >= getValue("RoP Targets") and charges.runeOfPower.count() == 2)) and not moving and talent.runeOfPower and not buff.runeOfPower.exists("player") then
                    if talent.firestarter then
                        if (cd.combustion.remains() <= gcd and getHP("target") < 90) or (charges.runeOfPower.count() == 2 and (cd.combustion.remains() > 20 or getHP("target") >= 90)) then
                            if cast.runeOfPower() then br.addonDebug("Casting Rune of Power")
                                return
                            end
                        end
                    elseif not talent.firestarter then
                        if cd.combustion.remains() <= gcd or (charges.runeOfPower.count()== 2 or charges.runeOfPower.timeTillFull() < 2) then
                            if cast.runeOfPower() then br.addonDebug("Casting Rune of Power")
                                return
                            end
                        end
                    end
                end

                if spellQueueReady() then 
                    if actionList_Rotation() then return end 
                end


            end

        end --End Rotation Logic
end -- End runRotation
local id = 63
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

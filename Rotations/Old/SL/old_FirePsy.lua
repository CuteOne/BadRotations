local rotationName = "Psy"

local colorRed      = "|cffFF0000"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.flamestrike},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.flamestrike},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.pyroblast},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.iceBlock}
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
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
    -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.01")
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
        section = br.ui:createSection(br.ui.window.profile, "Area of Effect")
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
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
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
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
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
--------------
--- Locals ---
--------------
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local equiped                                       = br.player.equiped
        local essence                                       = br.player.essence
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local healPot                                       = getHealthPot()
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
        local thp                                           = getHP("target")
        local ttd                                           = getTTD
        local units                                         = br.player.units
        local use                                           = br.player.use

        enemies.get(10)
        enemies.get(40)
        enemies.get(8,"target")
        enemies.get(10,"target")

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
                end -- End Pre-Pull        
            end -- End No Combat
        end -- End Action List - PreCombat

        local function actionList_Multi()
        -- Flamestrike
            if buff.hotStreak.exists("player") and #enemies.yards8t >= getValue("FS Targets (Hot Streak)") then
                if createCastFunction("best", false, 1, 8, spell.flamestrike, nil, true) then br.addonDebug("Casting Flamestrike") return end
            end
        -- Fire Blast
            -- if buff.heatingUp.exists("player") then
            --     if br.timer:useTimer("FB Delay", 0.5) then
            --         if cast.fireBlast() then br.addonDebug("Casting Fire Blast") return end
            --     end
            -- end
        -- Flamestrike (Flame Patch)
            if talent.flamePatch and not buff.combustion.exists("player") and not moving and #enemies.yards8t >= getValue("FS Targets (Flame Patch)") then 
                if createCastFunction("best", false, 1, 8, spell.flamestrike, nil, true) then br.addonDebug("Casting Flamestrike") return end
            end
        -- Living Bomb
            if talent.livingBomb and ttd("target") >= 8 and not buff.combustion.exists("player") then
                if cast.livingBomb() then br.addonDebug("Casting Living Bomb") return end
            end
        -- Dragon's Breath
            if (getFacing("player","target") and getDistance("target") <= 6) and not buff.combustion.exists("player") then
                if cast.dragonsBreath("player","cone",1,10) then br.addonDebug("Casting Dragon's Breath") return end
            end
        -- Phoenix Flames
            if talent.phoenixsFlames and charges.phoenixsFlames.count() > 0 then
                if cast.phoenixsFlames() then br.addonDebug("Casting Phoenix Flames") return end
            end
        -- Ripple in Space
            if isChecked("Use Essence") and useCDs() and essence.rippleInSpace.active and cd.rippleInSpace.remains() <= gcd then
                if cast.rippleInSpace("target") then br.addonDebug("Casting Ripple in Space") return end
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
        elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 then
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
        -- Mirror Image
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
        -- Rune of Power
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
            -- Meteor
                if isChecked("Meteor Targets") then
                    if cd.meteor.remain() <= gcd and (useCDs() or #enemies.yards8t >= getValue("Meteor Targets")) and talent.meteor and not isMoving("target") and getDistance("target") < 35 then
                        if talent.runeOfPower and talent.firestarter then
                            if (buff.runeOfPower.exists("player") and cd.combustion.remains() > 40) or (cd.combustion.remains() <= gcd and getHP("target") <= 90) or (#enemies.yards8t >= getValue("Meteor Targets") and isChecked("Use Meteor outside ROP")) then
                                if not isBoss("target") then
                                    if cast.meteor("best",false,1,8) then
                                        br.addonDebug("Casting Meteor")
                                        return
                                    end
                                else
                                    if meteor("target") then return end
                                end
                            end
                        elseif talent.runeOfPower and not talent.firestarter then
                            if (buff.runeOfPower.exists("player") and (cd.combustion.remains() > 40 or cd.combustion.remains() <= gcd)) or (#enemies.yards8t >= getValue("Meteor Targets") and isChecked("Use Meteor outside ROP")) then
                                if not isBoss("target") then
                                    if cast.meteor("best",false,1,8) then
                                        br.addonDebug("Casting Meteor")
                                        return
                                    end
                                else
                                    if meteor("target") then return end
                                end
                            end
                        elseif not talent.runeOfPower then
                            if cd.combustion.remains() <= gcd or cd.combustion.remains() > 40 or #enemies.yards8t >= getValue("Meteor Targets") then
                                if not isBoss("target") then
                                    if cast.meteor("best",false,1,8) then
                                        br.addonDebug("Casting Meteor")
                                        return
                                    end
                                else
                                    if meteor("target") then return end
                                end
                            end
                        end
                    end
                end
            -- Combustion
                if useCDs() and (talent.runeOfPower and buff.runeOfPower.exists("player") or not talent.runeOfPower) and (not talent.meteor or cast.last.meteor() or cd.meteor.remains() > gcd or not isChecked("Meteor Targets")) then
                    if not talent.firestarter then
                        if cast.combustion() then br.addonDebug("Casting Combustion") return end
                    elseif talent.firestarter and (getHP("target") <= 90 or #enemies.yards8t >= getValue("Combustion Targets")) then
                        if cast.combustion() then br.addonDebug("Casting Combustion") return end
                    end
                end
            -- Hyperthread Wristwraps
                if equiped.hyperthreadWristWraps and canUseItem(item.hyperthreadWristWraps) and useCDs() and buff.combustion.exists('player') 
                    and ((talent.flameOn and charges.fireBlast.count() <= 1) or charges.fireBlast.count() == 0) and fbTracker >= 2 
                then
                    if use.hyperthreadWristWraps() then br.addonDebug("Using Hyperthread Wristwraps") end
                end
            -- Blood of the Enemy
                if isChecked("Use Essence") and useCDs() and essence.bloodOfTheEnemy.active and cd.bloodOfTheEnemy.remains() <= gcd and not buff.combustion.exists("player") 
                    and (#enemies.yards10t >= 2 or isBoss("target"))
                then
                    if cast.bloodOfTheEnemy() then br.addonDebug("Casting Blood of the Enemy") return end
                end
            -- Worldvein Resonance
                if isChecked("Use Essence") and useCDs() and essence.worldveinResonance.active and cd.worldveinResonance.remains() <= gcd and not buff.combustion.exists("player") 
                    and not buff.runeOfPower("player") 
                then
                    if cast.worldveinResonance() then br.addonDebug("Casting Worldvein Resonance") return end
                end 
        -- Focused Azerite Beam
                if isChecked("Use Essence") and essence.focusedAzeriteBeam.active and cd.focusedAzeriteBeam.remains() <= gcd and ((essence.focusedAzeriteBeam.rank < 3 and not moving) 
                    or essence.focusedAzeriteBeam.rank >= 3) and not buff.combustion.exists("player") and not buff.runeOfPower.exists("player")
                    and getFacing("player","target") and (getEnemiesInRect(10,25,false,false) >= getOptionValue("Azerite Beam Units") or (useCDs() and (getEnemiesInRect(10,40,false,false) >= 1 or (getDistance("target") < 6 and isBoss("target")))))
                then
                    if cast.focusedAzeriteBeam() then br.addonDebug("Casting Focused Azerite Beam") return end
                end
        -- Purfying Blast
                if isChecked("Use Essence") and essence.purifyingBlast.active and cd.purifyingBlast.remains() <= gcd and not buff.combustion.exists("player") 
                    and not buff.runeOfPower.exists("player") and (#enemies.yards8t >= 2 or isBoss("target")) 
                then
                    if createCastFunction("best", false, 1, 8, spell.purifyingBlast, nil, true) then br.addonDebug("Casting Purifying Blast") return end
                end
        -- Multi Target ActionList
                if #enemies.yards8t >= 2 and (not buff.combustion.exists("player") or (mode.combustion == 1 and buff.combustion.exists("player"))) and mode.rotation ~= 3 then
                    if actionList_Multi() then return end
                end
        -- Pyroblast
                if buff.hotStreak.exists("player") then 
                        if cast.pyroblast() then br.addonDebug("Casting Pyroblast") return end
                elseif talent.pyroclasm and (buff.pyroclasm.exists("player") and (buff.combustion.remains() > getCastTime(spell.pyroblast) or not buff.combustion.exists("player"))) then
                    if br.timer:useTimer("PB Delay",5) then
                        if cast.pyroblast() then br.addonDebug("Casting Pyroblast") return end
                    end
                end
        -- Fire Blast
                -- if buff.heatingUp.exists("player") and not cast.last.fireBlast() and (buff.combustion.exists("player") or (talent.runeOfPower and buff.runeOfPower.exists("player")) or (charges.fireBlast.timeTillFull() < cd.combustion.remains() or not useCDs())) then
                --     if cast.fireBlast() then br.addonDebug("Casting Fire Blast") return end
                -- end
        -- Living Bomb
                if talent.livingBomb and #enemies.yards8t >= 1 then
                    if cast.livingBomb() then br.addonDebug("Casting Living Bomb") return end
                end
        -- Phoenix Flames
                if talent.phoenixsFlames and charges.phoenixsFlames.count() > 0 then
                    if talent.runeOfPower then
                        if buff.runeOfPower.exists("player") or buff.combustion.exists("player") then
                            if cast.phoenixsFlames() then br.addonDebug("Casting Phoenix Flames") return end
                        end
                    elseif not talent.runeOfPower then
                        if buff.combustion.exists("player") or buff.heatingUp.exists("player") then
                            if cast.phoenixsFlames() then br.addonDebug("Casting Phoenix Flames") return end
                        end
                    end
                end
        -- Dragon's Breath
                if talent.alexstraszasFury and (getFacing("player","target") and getDistance("target") <= 6) and buff.heatingUp.exists("player")  then
                    if cast.dragonsBreath("player","cone",1,10) then br.addonDebug("Casting Dragon's Breath") return end
                end
        -- Concentrated Flame
                if isChecked("Use Essence") and essence.concentratedFlame.active and cd.concentratedFlame.remain() <= gcd and not cast.last.concentratedFlame() then
                    if php <= 50 then
                        if cast.concentratedFlame("player") then br.addonDebug("Casting Concentrated Flame (Heal)") return end
                    elseif GetUnitExists("target") then
                        if cast.concentratedFlame("target") then br.addonDebug("Casting Concentrated Flame (Damage)") return end
                    end
                end
        -- Ripple In Space
                if isChecked("Use Essence") and useCDs() and essence.rippleInSpace.active and cd.rippleInSpace.remains() <= gcd and not buff.combustion.exists("player") and
                    not buff.runeOfPower.exists("player") and (#enemies.yards8t >= 2 or isBoss("target"))
                then
                    if cast.rippleInSpace("target") then br.addonDebug("Casting Ripple in Space") return end
                end
        -- Scorch
                if (talent.searingTouch and getHP("target") < 30) or (buff.combustion.remains() > getCastTime(spell.scorch)) then
                    if cast.scorch() then br.addonDebug("Casting Scorch") return end
                end
        -- Fireball
                if not moving and not buff.hotStreak.exists("player") then
                    if cast.fireball() then br.addonDebug("Casting Fireball") return end
                end
        -- Scorch
                if moving then
                    if cast.scorch() then br.addonDebug("Casting Scorch") return end
                end
            end
        end --End Rotation Logic
end -- End runRotation
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
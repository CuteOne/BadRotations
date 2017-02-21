local rotationName = "Vilt"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.bladeFlurry },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladeFlurry },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.saberSlash },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.crimsonVial }
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.adrenalineRush },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.adrenalineRush },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.adrenalineRush }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.riposte },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.riposte }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.kick },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.kick }
    };
    CreateButton("Interrupt",4,0)
-- Cleave Button
    CleaveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = br.player.spell.bladeFlurry },
        [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = br.player.spell.saberSlash }
    };
    CreateButton("Cleave",5,0)
-- Pick Pocket Button
    PickerModes = {
      [1] = { mode = "Auto", value = 2 , overlay = "Auto Pick Pocket Enabled", tip = "Profile will attempt to Pick Pocket prior to combat.", highlight = 1, icon = br.player.spell.pickPocket},
      [2] = { mode = "Only", value = 1 , overlay = "Only Pick Pocket Enabled", tip = "Profile will attempt to Sap and only Pick Pocket, no combat.", highlight = 0, icon = br.player.spell.pickPocket},
      [3] = { mode = "Off", value = 3, overlay = "Pick Pocket Disabled", tip = "Profile will not use Pick Pocket.", highlight = 0, icon = br.player.spell.pickPocket}
    };
    CreateButton("Picker",6,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- Opening Attack
            br.ui:createDropdown(section, "Opener", {"Ambush", "Cheap Shot", "Saber Slash"},  1, "|cffFFFFFFSelect Attack to Break Stealth with")
            -- mfd prpull
            br.ui:createCheckbox(section, "Marked For Death - Precombat")
            -- RTb Prepull
            br.ui:createCheckbox(section, "RTB Prepull")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Stealth
            br.ui:createDropdown(section, "Stealth", {"|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards"},  1, "Stealth method.")
            -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        br.ui:checkSectionState(section)
        ------------------------
        --- OFFENSIVE OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Offensive")
            -- Agi Pot
            br.ui:createCheckbox(section, "Agi-Pot")
            -- Sprint with Boots
            br.ui:createCheckbox(section, "Sprint with Legendary Boots")
            -- Marked For Death
            br.ui:createDropdown(section, "Marked For Death", {"|cff00FF00Target", "|cffFFDD00Lowest"}, 1)
            -- Vanish
            br.ui:createCheckbox(section,  "Vanish")
            -- Racial
            br.ui:createCheckbox(section,  "Racial")
            -- Pistol Shot OOR
            br.ui:createSpinner(section, "Pistol Shot out of range", 85,  5,  100,  5,  "|cffFFFFFFCheck to use Pistol Shot out of range and energy to use at.")
            -- CB
            br.ui:createSpinner(section, "Cannonball Barrage", 3, 0, 10, 1)
            -- KS
            br.ui:createCheckbox(section, "Killing Spree")
            -- RTB
            br.ui:createDropdown(section, "RTB", {"|cff00FF007.1.5 Logic (Default)", "|cffFFDD007.1 Logic", "|cffFF00001+"}, 1)
            -- BF
            br.ui:createSpinner(section,  "Blade Flurry", 3, 0, 5, 1)
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healing Potion/Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Crimson Vial
            br.ui:createSpinner(section, "Crimson Vial",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Feint
            br.ui:createSpinner(section, "Feint", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Riposte
            br.ui:createSpinner(section, "Riposte",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Cloak with KS
             br.ui:createCheckbox(section, "Cloak Killing Spree")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Kick
            br.ui:createCheckbox(section, "Kick")
            -- Gouge
            br.ui:createCheckbox(section, "Gouge")
            -- Blind
            br.ui:createCheckbox(section, "Blind")
            -- Parley
            br.ui:createCheckbox(section, "Parley")
            -- Between the Eyes
            br.ui:createCheckbox(section, "Between the Eyes")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Cleave Toggle
            br.ui:createDropdown(section,  "Cleave Mode", br.dropOptions.Toggle,  6)
            -- Pick Pocket Toggle
            br.ui:createDropdown(section,  "Pick Pocket Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)
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
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Cleave",0.25)
        br.player.mode.cleave = br.data.settings[br.selectedSpec].toggles["Cleave"]
        UpdateToggle("Picker",0.25)
        br.player.mode.pickPocket = br.data.settings[br.selectedSpec].toggles["Picker"]

--------------
--- Locals ---
--------------
        if profileStop == nil then profileStop = false end
        local addsIn                                        = 999
        local artifact                                      = br.player.artifact
        local attacktar                                     = UnitCanAttack("target","player")
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local castable                                      = br.player.cast.debug
        local cd                                            = br.player.cd
        local charge                                        = br.player.charges
        local combo, comboDeficit, comboMax                 = br.player.power.amount.comboPoints, br.player.power.comboPoints.deficit, br.player.power.comboPoints.max
        local cTime                                         = getCombatTime()
        local deadtar                                       = UnitIsDeadOrGhost("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = enemies or {}
        local flaskBuff, canFlask                           = getBuffRemain("player",br.player.flask.wod.buff.agilityBig), canUse(br.player.flask.wod.agilityBig)
        local gcd                                           = br.player.gcd
        local glyph                                         = br.player.glyph
        local hastar                                        = ObjectExists("target")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local mode                                          = br.player.mode
        local multidot                                      = (br.player.mode.cleave == 1 or br.player.mode.rotation ~= 3)
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local power, powerDeficit, powerRegen               = br.player.power.amount.energy, br.player.power.energy.deficit, br.player.power.regen
        local pullTimer                                     = br.DBM:getPulltimer()
        local rtbCount                                      = br.rtbCount
        local solo                                          = #br.friend < 2
        local spell                                         = br.player.spell
        local stealth                                       = br.player.buff.stealth.exists()
        local stealthing                                    = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowmeld.exists()
        local talent                                        = br.player.talent
        local time                                          = getCombatTime()
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.ttm
        local units                                         = units or {}
        local lootDelay                                     = getOptionValue("LootDelay")
        local rtbReroll                                     = true

        units.dyn5 = br.player.units(5)
        units.dyn30 = br.player.units(30)
        enemies.yards5 = br.player.enemies(5)
        enemies.yards8 = br.player.enemies(8)
        enemies.yards20 = br.player.enemies(20)
        enemies.yards30 = br.player.enemies(30)

        if talent.acrobaticStikes then rangeMod = 3 else rangeMod = 0 end
        if leftCombat == nil then leftCombat = GetTime() end
        if talent.deeperStrategem then dStrat = 1 else dStrat = 0 end
        if talent.quickDraw then qDraw = 1 else qDraw = 0 end
        if talent.ghostlyStrike and not debuff.ghostlyStrike.exists(units.dyn5) then gsBuff = 1 else gsBuff = 0 end
        if buff.broadsides.exists() then broadUp = 1 else broadUp = 0 end
        if buff.broadsides.exists() or buff.jollyRoger.exists() then broadRoger = 1 else broadRoger = 0 end
        if talent.alacrity and buff.alacrity.stack() <= 4 then lowAlacrity = 1 else lowAlacrity = 0 end
        if talent.anticipation then antital = 1 else antital = 0 end
        if cd.deathFromAbove == 0 then dfaCooldown = 1 else dfaCooldown = 0 end
        if vanishTime == nil then vanishTime = GetTime() end
        if buff.hiddenBlade.exists() then hBss = 1 else hBss = 0 end

        ------------------------------------------
        --------------Roll the Bones--------------
        ------------------------------------------

        if buff.rollTheBones == nil then buff.rollTheBones = {} end
        buff.rollTheBones.count    = 0
        buff.rollTheBones.duration = 0
        buff.rollTheBones.remain   = 0
        for k,v in pairs(spell.buffs.rollTheBones) do
            if UnitBuffID("player",v) ~= nil then
                buff.rollTheBones.count    = buff.rollTheBones.count + 1
                buff.rollTheBones.duration = getBuffDuration("player",v)
                buff.rollTheBones.remain   = getBuffRemain("player",v)
            end
        end

        if getOptionValue("RTB") == 1 then
            if not talent.sliceAndDice and (buff.rollTheBones.count >= 3 or buff.trueBearing.exists()) then
                rtbReroll = false
            else
                rtbReroll = true
            end
        end

        if getOptionValue("RTB") == 2 then
            if not talent.sliceAndDice and (buff.rollTheBones.count >= 2  or buff.trueBearing.exists() or (buff.sharkInfestedWaters.exists() and (buff.adrenalineRush.exists() or debuff.curseOfTheDreadblades.exists("player")))) then
                rtbReroll = false
            else
                rtbReroll = true
            end
        end

        if getOptionValue("RTB") == 3 then
            if not talent.sliceAndDice and buff.rollTheBones.count >= 1 then
                rtbReroll = false
             else
                rtbReroll = true
            end
        end

        -----------------------------------------
        -----------------RTB End-----------------
        -----------------------------------------

        -- ss_useable_noreroll,value=(combo_points<5+talent.deeper_stratagem.enabled-(buff.broadsides.up|buff.jolly_roger.up)-(talent.alacrity.enabled&buff.alacrity.stack<=4))
        if combo < 5 + dStrat - broadRoger - lowAlacrity - hBss then
            ssUsableNoreroll = true
        else
            ssUsableNoreroll = false
        end
        -- ss_useable,value=(talent.anticipation.enabled&combo_points<4)|(!talent.anticipation.enabled&((variable.rtb_reroll&combo_points<4+talent.deeper_stratagem.enabled)|(!variable.rtb_reroll&variable.ss_useable_noreroll)))
        if (talent.anticipation and combo < 4) or (not talent.anticipation and ((rtbReroll and combo < 4 + dStrat) or (not rtbReroll and ssUsableNoreroll))) then
            ssUsable = true
        else
            ssUsable = false
        end

        if buff.trueBearing.exists() and cd.markedForDeath > 1 and not cd.markedForDeath == 0 and cd.markedForDeath <= combo*2 and not debuff.curseOfTheDreadblades.exists("player") and lastSpell~=1856 then
            clearMFD = true
        else
            clearMFD = false
        end

        -- stealth_condition,value=(combo_points.deficit>=2+2*(talent.ghostly_strike.enabled&!debuff.ghostly_strike.up)+buff.broadsides.up&energy>60&!buff.jolly_roger.up&!buff.hidden_blade.up&!buff.curse_of_the_dreadblades.up)
        if (comboDeficit >= 2 + (2 * gsBuff) + broadUp) and power > 58 and not buff.jollyRoger.exists() and not buff.hiddenBlade.exists() and not debuff.curseOfTheDreadblades.exists("player") and not buff.stealth.exists() and not solo and isChecked("Vanish") and useCDs() and cd.vanish == 0 then
        --if (not solo or isDummy("target")) and inCombat and cd.vanish == 0 and not rtbReroll and ((comboDeficit >= 2 + 2 * gsBuff + broadUp) and power > 58 and (not buff.jollyRoger.exists() or buff.trueBearing.exists()) and not buff.hiddenBlade.exists() and not debuff.curseOfTheDreadblades["player"].exists()) then
            stealthable = true
        else
            stealthable = false
        end

        -- Custom Functions
        local function usePickPocket()
            if mode.pickPocket == 1 or mode.pickPocket == 2 then
                return true
            else
                return false
            end
        end

        local function isPicked(thisUnit)   --  Pick Pocket Testing
            if thisUnit == nil then thisUnit = "target" end
            if GetObjectExists(thisUnit) then
                if myTarget ~= UnitGUID(thisUnit) then
                    canPickpocket = true
                    myTarget = UnitGUID(thisUnit)
                elseif not (UnitCreatureType(units.dyn30) == "Humanoid" or UnitCreatureType(units.dyn30) == "Demon" or UnitCreatureType(units.dyn30) == "Aberration") then
                    canPickpocket = false
                end
            end
            if (canPickpocket == false or mode.pickPocket == 3 or GetNumLootItems()>0) and not isDummy() then
                return true
            else
                return false
            end
        end

--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
    -- Pick Pocket
            if usePickPocket() and stealth and not inCombat then
                if UnitCanAttack(units.dyn5,"player") and (UnitExists("target") or mode.pickPocket == 2) and mode.pickPocket ~= 3 then
                    if not isPicked(units.dyn5) and not isDummy(units.dyn5) and getDistance(units.dyn5) <= 6 then
                        if debuff.sap.remain(units.dyn5) < 1 and mode.pickPocket ~= 1 then
                            if cast.sap(units.dyn5) then return end
                        end
                        if cast.pickPocket() then return end
                    end
                end
            end
    -- Pistol Shot
            if isChecked("Pistol Shot out of range") and isValidUnit("target") and power >= getOptionValue("Pistol Shot out of range") and (combo < comboMax or ttm <= 1.5) and (inCombat and getDistance("target") > 7) and not stealthing then
                if cast.pistolShot("target") then return end
            end
        end -- End Action List - Extras
    -- Action List - Defensives
        local function actionList_Defensive()
            if useDefensive() and not stealth then
            -- Health Pot/Healthstone
                if isChecked("Healing Potion/Healthstone") and php <= getOptionValue("Healing Potion/Healthstone")
                    and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healPot) then
                        useItem(healPot)
                    end
                end
            -- Crimson Vial
                if isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") then
                    if cast.crimsonVial() then return end
                end
            -- Feint
                if isChecked("Feint") and php <= getOptionValue("Feint") and inCombat and not buff.feint then
                    if cast.feint() then return end
                end
            -- Riposte
                if isChecked("Riposte") and php <= getOptionValue("Riposte") and inCombat then
                    if cast.riposte() then return end
                end
            end
        end -- End Action List - Defensive
    -- Mythic Dungeon Logic
        --[[local function actionList_MythicDungeon()
        end]]
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() and not stealth then
                for i = 1, #enemies.yards20 do
                    local thisUnit = enemies.yards20[i]
                    local distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) and hasThreat(thisUnit) then
                        if distance < 5 then
        -- Kick
                            -- kick
                            if isChecked("Kick") then
                                if cast.kick(thisUnit) then return end
                            end
                            if cd.kick ~= 0 then
        -- Gouge
                                if isChecked("Gouge") and getFacing(thisUnit,"player") then
                                    if cast.gouge(thisUnit) then return end
                                end
                            end
                        end
                        if (cd.kick ~= 0 and cd.gouge ~= 0) or (distance >= 5 and distance < 15) then
        -- Blind
                            if isChecked("Blind") then
                                if cast.blind(thisUnit) then return end
                            end
                            if isChecked("Parley") then
                                if cast.parley(thisUnit) then return end
                            end
                        end
        -- Between the Eyes
                        if ((cd.kick ~= 0 and cd.gouge ~= 0) or distance >= 5) and (cd.blind ~= 0 or level < 38 or distance >= 15) then
                            if isChecked("Between the Eyes") then
                                if cast.betweenTheEyes(thisUnit) then return end
                            end
                        end
                    end
                end
            end -- End Interrupt and No Stealth Check
        end -- End Action List - Interrupts
    -- Action List - Blade Flurry
        local function actionList_BladeFlurry()
        -- Blade Flurry
            if #getEnemies("player",7) < 2 and buff.bladeFlurry.exists() then
                -- if cast.bladeFlurry() then return end
                if not delayBladeFlurry or delayBladeFlurry == 0 then
                    delayBladeFlurry = GetTime() + getOptionValue("Blade Flurry")
                elseif delayBladeFlurry < GetTime() then
                    CastSpellByName(GetSpellInfo(spell.bladeFlurry),"player");
                end
            end
            if ((#getEnemies("player",7) >=2 and buff.bladeFlurry.exists()) or (#getEnemies("player",7) < 2 and not buff.bladeFlurry.exists())) and delayBladeFlurry then
                delayBladeFlurry = 0
            end
            -- blade_flurry,if=spell_targets.blade_flurry>=2&!buff.blade_flurry.up
            if #getEnemies("player",7) >= 2 and not buff.bladeFlurry.exists() then
                CastSpellByName(GetSpellInfo(spell.bladeFlurry),"player");
            end
        end
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            if useCDs() and getDistance("target") <= 6 and attacktar and inCombat then
        -- Trinkets
                if isChecked("Trinkets") then
                    if hasBloodlust() or ttd("target") <= 20 or comboDeficit <= 2 then
                        if canUse(13) then
                            useItem(13)
                        end
                        if canUse(14) then
                            useItem(14)
                        end
                    end
                end
        -- Pots
                if isChecked("Agi-Pot") then
                    if ttd("target") <= 25 or buff.adrenalineRush.exists() or hasBloodLust() then
                        if canUse(127844) and inRaid then
                                useItem(127844)
                        end
                        else
                        if canUse(142117) and inRaid then
                               useItem(142117)
                        end
                    end
                end
        -- Cannonball Barrage
                -- cannonball_barrage,if=spell_targets.cannonball_barrage>=1
                if #enemies.yards8 >= getOptionValue("Cannonball Barrage") and isChecked("Cannonball Barrage") then
                    if cast.cannonballBarrage("best",false,#enemies.yards8,8) then return end
                end
        -- Adrenaline Rush
                -- adrenaline_rush,if=!buff.adrenaline_rush.up&energy.deficit>0
                if not buff.adrenalineRush.exists() and powerDeficit > 0 and cd.saberSlash == 0 then
                    if cast.adrenalineRush() then return end
                end
        -- Sprint
                -- sprint,if=equipped.thraxis_tricksy_treads&!variable.ss_useable
                if isChecked("Sprint with Legendary Boots") and hasEquiped(137031) and not ssUsable then
                    if cast.sprint() then return end
                end
        -- Curse of the Dreadblades
                -- curse_of_the_dreadblades,if=combo_points.deficit>=4&(!talent.ghostly_strike.enabled|debuff.ghostly_strike.up)
                if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) and (cd.saberSlash == 0 or cd.pistolShot == 0) then
                    if comboDeficit >= 4 and (power >= 48 or buff.opportunity.exists()) and (not talent.ghostlyStrike or debuff.ghostlyStrike.exists(units.dyn5)) then
                        if cast.curseOfTheDreadblades() then return end
                    end
                end
            end -- End Cooldown Usage Check
        end -- End Action List - Cooldowns
    -- Action List - PreCombat
        local function actionList_PreCombat()
        -- Stealth
            -- stealth
            --[[if isChecked("Stealth") and (not IsResting() or isDummy("target")) then
                if getOptionValue("Stealth") == 1 then
                    if cast.stealth() then return end
                end
                if getOptionValue("Stealth") == 2 then
                    for i=1, #enemies.yards20 do
                        local thisUnit = enemies.yards20
                        if getDistance(thisUnit) < 20 then
                            if ObjectExists(thisUnit) and UnitCanAttack(thisUnit,"player") and GetTime()-leftCombat > lootDelay then
                                if cast.stealth() then return end
                            end
                        end
                    end
                end
            end]]
            if not stealth and #enemies.yards20 > 0 and getOptionValue("Stealth") == 3 and not IsResting() and GetTime()-leftCombat > lootDelay then
                        for i = 1, #enemies.yards20 do
                            local thisUnit = enemies.yards20[i]
                            if UnitIsEnemy(thisUnit,"player") or isDummy("target") then
                                if cast.stealth("player") then return end
                            end
                        end
                    end
        -- Marked for Death
            -- marked_for_death
            if isChecked("Marked For Death - Precombat") and getDistance("target") < 30 and isValidUnit("target") then
                if cast.markedForDeath("target") then return end
            end
        -- Roll The Bones
            -- roll_the_bones,if=!talent.slice_and_dice.enabled
            if isChecked("RTB Prepull") and not talent.sliceAndDice and not buff.rollTheBones.count == 0 and isValidUnit("target") and getDistance("target") <= 5 then
                if cast.rollTheBones() then return end
            end
        end -- End Action List - PreCombat
    -- Action List - Finishers
        local function actionList_Finishers()
        -- Between the Eyes
            -- between_the_eyes,if=equipped.greenskins_waterlogged_wristcuffs&!buff.greenskins_waterlogged_wristcuffs.up
            if hasEquiped(137099) and not buff.greenskinsWaterloggedWristcuffs.exists() then
                if cast.betweenTheEyes() then return end
            end
        -- Run Through
            -- run_through,if=!talent.death_from_above.enabled|energy.time_to_max<cooldown.death_from_above.remain()s+3.5
            if not talent.deathFromAbove or ttm < cd.deathFromAbove + 3.5 then
                if cast.runThrough() then return end
            end
        end -- End Action List - Finishers
    -- Action List - Build
        local function actionList_Build()
        -- Ghostly Strike
            -- ghostly_strike,if=combo_points.deficit>=1+buff.broadsides.up&!buff.curse_of_the_dreadblades.up&
            --(debuff.ghostly_strike.remain()s<debuff.ghostly_strike.duration*0.3|(cooldown.curse_of_the_dreadblades.remain()s<3&debuff.ghostly_strike.remain()s<14))&(combo_points>=3|(variable.rtb_reroll&time>=10))
            if comboDeficit >= (1 + broadUp) and not debuff.curseOfTheDreadblades.exists("player") and ((not debuff.ghostlyStrike.exists() or debuff.ghostlyStrike.refresh())
                or (cd.curseOfTheDreadblades < 3 and debuff.ghostlyStrike.remain() < 14 and useCDs())) and (combo >= 3 or (rtbReroll and (cTime >= 10 or solo)))
            then
                if cast.ghostlyStrike("target") then return end
            end
        -- Pistol Shot
            -- pistol_shot,if=combo_points.deficit>=1+buff.broadsides.up&buff.opportunity.up&(energy.time_to_max>2-talent.quick_draw.enabled|(buff.blunderbuss.up&buff.greenskins_waterlogged_wristcuffs.up))
            if comboDeficit >= (1 + broadUp) and buff.opportunity.exists() and ((ttm > 2 - qDraw) or (buff.adrenalineRush.exists() and ttm > 1.5) or (castable.blunderbuss and buff.greenskinsWaterloggedWristcuffs.exists())) and not stealthing then
                if cast.pistolShot("target") then return end
            end
        -- Saber Slash
            -- saber_slash
            if ssUsable then
                if cast.saberSlash() then return end
            end
        end -- End Action List - Build
    -- Action List - Stealth
        local function actionList_Stealth()
        -- Ambush/Cheap Shot
            -- ambush
            if isChecked("Opener") and isValidUnit("target") and getDistance("target") <= 5 and stealthing and (canPickpocket == false or inRaid or isDummy) then
                if getOptionValue("Opener") == 1 then
                    if power <= 60 then
                        return true
                    else
                        if cast.ambush() then return end
                    end
                elseif getOptionValue("Opener") == 2 then
                        if power <= 40 then
                            return true
                        else
                            if cast.cheapShot() then return end
                    end
                else if getOptionValue("Opener") == 3 then
                        if power <= 50 then
                            return true
                        else
                            if cast.saberSlash() then return end
                        end
                    end
                end
            end
        -- Vanish
            -- vanish,if=variable.stealth_condition
            if isChecked("Vanish") and (stealthable or (hasEquiped(144236) and buff.trueBearing.exists())) and isValidUnit("target") and getDistance("target") <= 5 then
                if cast.vanish() then vanishTime = GetTime(); return end
            end
        -- Shadowmeld
            -- shadowmeld,if=variable.stealth_condition
            if isChecked("Use Racial") and br.player.race == "NightElf" and stealthable and inCombat and isValidUnit(units.dyn5)
                and getDistance(units.dyn5) < 5 and not buff.vanish.exists() and cd.vanish ~= 0 and not moving then
                if cast.shadowmeld() then return end
            end
        end
---------------------
--- Begin Profile ---
---------------------
    --Profile Stop | Pause
        if not inCombat and not hastar and profileStop == true then
            profileStop = false
        elseif (inCombat and profileStop == true) or pause() or (IsMounted() or IsFlying()) or mode.rotation == 4 then
            if inCombat and mode.rotation == 4 then StopAttack() end
            return true
        else
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
            if (not inCombat or buff.stealth.exists()) then
                if actionList_PreCombat() then return end
            end
--------------------------
--- In Combat Rotation ---
--------------------------
            if profileStop==false then
               -- if UnitIsDeadOrGhost("target") then ClearTarget(); end
                if not stealthing or level < 5 then
------------------------------
--- In Combat - Interrupts ---
------------------------------
                    --if actionList_MythicDungeon() then return end

                    if actionList_Interrupts() then return end
--------------------------------
--- In Combat - Blade Flurry ---
--------------------------------
                    if actionList_BladeFlurry() then return end
-----------------------------
--- In Combat - Cooldowns ---
-----------------------------
                    if actionList_Cooldowns() then return end
                end
---------------------------
--- In Combat - Stealth ---
---------------------------
                if --[[getDistance(units.dyn5) <= 5 and isValidUnit(units.dyn5) inCombat and]] isValidUnit(units.dyn5) then
                    -- call_action_list,name=stealth,if=stealthed|cooldown.vanish.up|cooldown.shadowmeld.up
                    if stealthing or cd.vanish == 0 or cd.shadowmeld == 0 then
                        if actionList_Stealth() then return end
                    end
----------------------------------
--- In Combat - Begin Rotation ---
----------------------------------
                    -- if not buff.stealth and not buff.vanish and not buff.shadowmeld and GetTime() > vanishTime + 2 and getDistance(units.dyn5) < 5 then
                    if not stealthing and inCombat then
                        StartAttack()
        -- Marked for Death
                        if isChecked("Marked For Death") then
                            if getOptionValue("Marked For Death") == 2 then
                                for i = 1, #enemies.yards30 do
                                    local thisUnit = enemies.yards30[i]
                                    if comboDeficit >= 6 then comboDeficit = (5 + dStrat) end
                                    if ttd(thisUnit) > 0 and ttd(thisUnit) <= 100 then
                                        if ttd(thisUnit) < comboDeficit*1.2 then
                                            if cast.markedForDeath(thisUnit) then return end
                                        end
                                    end
                                end
                            end
                        end

                -- Marked For Death
                        if isChecked("Marked For Death") then
                            if getOptionValue("Marked For Death") == 1 and getDistance("target") <= 5 then
                                -- marked_for_death,if=combo_points.deficit>=4+talent.deeper_strategem.enabled+talent.anticipation.enabled
                                if comboDeficit >= 4 + dStrat + antital then
                                    if cast.markedForDeath("target") then return end
                                end
                            end
                        end
        -- Death from Above
                        -- death_from_above,if=energy.time_to_max>2&!variable.ss_useable_noreroll
                        if ttm > 2 and not ssUsableNoreroll then
                            if cast.deathFromAbove() then return end
                        end
        -- Slice and Dice
                        -- slice_and_dice,if=!variable.ss_useable&buff.slice_and_dice.remain()s<target.time_to_die&buff.slice_and_dice.remain()s<(1+combo_points)*1.8
                        if not ssUsable and buff.sliceAndDice.remain() < ttd(units.dyn5) and buff.sliceAndDice.remain() < (1 + combo) * 1.8 then
                            if cast.sliceAndDice() then return end
                        end
        -- Roll the Bones
                        -- roll_the_bones,if=!variable.ss_useable&buff.roll_the_bones.remain()s<target.time_to_die&(buff.roll_the_bones.remain()s<=3|variable.rtb_reroll)
                        if isChecked("RTB") and not ssUsable and buff.rollTheBones.remain < ttd("target") and (buff.rollTheBones.remain <= 3 or rtbReroll) and not talent.sliceAndDice then
                            if cast.rollTheBones() then return end
                        end
        -- Killing Spree
                        -- killing_spree,if=energy.time_to_max>5|energy<15
                        if useCDs() and isChecked("Killing Spree") and (ttm > 5 or power < 15) then
                            if isChecked("Cloak Killing Spree") and cd.cloakOfShadows == 0 then
                                if cast.cloakOfShadows then end
                            end
                            if cast.killingSpree() then return end
                        end
        -- Build
                        -- call_action_list,name=build
                        if GetTime() > vanishTime + 1 then
                            if actionList_Build() then return end
                        end
        -- Finishers
                        -- call_action_list,name=finish,if=!variable.ss_useable
                        if not ssUsable or clearMFD then
                            if actionList_Finishers() then return end
                        end
        -- Gouge
                        -- gouge,if=talent.dirty_tricks.enabled&combo_points.deficit>=1
                        if talent.dirtyTricks and comboDeficit >= 1 and not debuff.curseOfTheDreadblades.exists("player") then
                            for i = 1, #enemies.yards5 do
                                local thisUnit = enemies.yards5[i]
                                if not isBoss(thisUnit) and getFacing(thisUnit,"player") then
                                    if cast.gouge(thisUnit) then return end
                                end
                            end
                        end
                    end
                end
            end -- End In Combat
        end -- End Profile
end -- runRotation
local id = 260
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

--Version 1.0.0
local rotationName = "Panglo2"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.thunderClap},
        [2] = {mode = "Off", value = 2, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
    }
    CreateButton("Rotation", 1, 0)
    -- Cooldown Button
    CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Based on settings", highlight = 1, icon = br.player.spell.avatar},
        [2] = {mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.avatar},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.avatar}
    }
    CreateButton("Cooldown", 2, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.shieldWall},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.shieldWall}
    }
    CreateButton("Defensive", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.pummel},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel}
    }
    CreateButton("Interrupt", 4, 0)
    -- Movement Button
    MoverModes = {
        [1] = {mode = "On", value = 1, overlay = "Mover Enabled", tip = "Will use Charge/Heroic Leap.", highlight = 1, icon = br.player.spell.charge},
        [2] = {mode = "Off", value = 2, overlay = "Mover Disabled", tip = "Will NOT use Charge/Heroic Leap.", highlight = 0, icon = br.player.spell.charge}
    }
    CreateButton("Mover", 5, 0)
    TauntModes = {
        [1] = {mode = "Dun", value = 1, overlay = "Taunt only in Dungeon", tip = "Taunt will be used in dungeons.", highlight = 1, icon = br.player.spell.taunt},
        [2] = {mode = "All", value = 2, overlay = "Auto Taunt Enabled", tip = "Taunt will be used everywhere.", highlight = 1, icon = br.player.spell.taunt},
        [3] = {mode = "Off", value = 3, overlay = "Auto Taunt Disabled", tip = "Taunt will not be used.", highlight = 0, icon = br.player.spell.taunt}
    }
    CreateButton("Taunt", 6, 0)
    -- Movement Button
    ShieldModes = {
        [1] = {mode = "On", value = 1, overlay = "Shield Block Enabled", tip = "Will use Shield Block", highlight = 1, icon = br.player.spell.shieldBlock},
        [2] = {mode = "Off", value = 2, overlay = "Shield Block Disabled", tip = "Will NOT use Shield Block", highlight = 0, icon = br.player.spell.shieldBlock}
    }
    CreateButton("Shield", 0, 1)
    -- Movement Button
    ReflectModes = {
        [1] = {mode = "On", value = 1, overlay = "Spell Reflect Enabled", tip = "Will use Spell Reflect", highlight = 1, icon = br.player.spell.spellReflection},
        [2] = {mode = "Off", value = 2, overlay = "Spell Reflect Disabled", tip = "Will NOT use Spell Reflect", highlight = 0, icon = br.player.spell.spellReflection}
    }
    CreateButton("Reflect", 1, 1)
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
        section = br.ui:createSection(br.ui.window.profile, "General - Version 1.000")
        -- br.ui:createDropdown(section,"leap test",{"behind","forward","random"}, 1)
        br.ui:createCheckbox(section, "Open World Defensives", "Use this checkbox to ensure defensives are used while in Open World")
        -- Berserker Rage
        br.ui:createCheckbox(section, "Berserker Rage", "Check to use Berserker Rage")
        -- lol charge
        br.ui:createCheckbox(section, "Charge OoC")
        -- High Rage Dump
        br.ui:createSpinner(section, "High Rage Dump", 85, 1, 100, 1, "|cffFFFFFF Set to number of units to use Ignore Pain or Revenge at")
        -- Aoe Threshold
        br.ui:createSpinnerWithout(section, "Aoe Priority", 3, 1, 10, 1, "Set number of units to prioritise TC and Revenge")
        -- Shout Check
        br.ui:createCheckbox(section, "Battle Shout", "Enable automatic party buffing")
        br.ui:createCheckbox(section, "Pig Catcher", "Catch the freehold Pig in the ring of booty")

        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Trinkets
        br.ui:createDropdownWithout(section, "Trinkets", {"Always", "When CDs are enabled", "Never", "With Avatar"}, 1, "Decide when Trinkets will be used.")
        br.ui:createDropdownWithout(section, "Trinket 1 Mode", {"|cffFFFFFFNormal", "|cffFFFFFFGround"}, 1, "", "|cffFFFFFFSelect Trinkets mode.")
        br.ui:createDropdownWithout(section, "Trinket 2 Mode", {"|cffFFFFFFNormal", "|cffFFFFFFGround"}, 1, "", "|cffFFFFFFSelect Trinkets mode.")
        -- Avatar
        br.ui:createCheckbox(section, "Avatar")
        -- Avatar Spinner
        br.ui:createSpinnerWithout(section, "Avatar Mob Count", 5, 0, 10, 1, "|cffFFFFFFEnemies to cast Avatar when using AUTO CDS")
        -- Demoralizing Shout
        br.ui:createDropdownWithout(section, "Demoralizing Shout - CD", {"Always", "When CDs are enabled", "Never"}, 1)
        -- Ravager
        br.ui:createCheckbox(section, "Ravager")
        -- Dragons Roar
        br.ui:createCheckbox(section, "Dragon Roar")
        -- Shockwave
        br.ui:createCheckbox(section, "Racial", "Automatically Use racials with Avatar")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        --Smart Spell reflect
        br.ui:createCheckbox(section, "Smart Spell Reflect", "Auto reflect spells in instances")
        br.ui:createSpinnerWithout(section, "Smart Spell Reflect Percent", 65, 0, 95, 5, "Spell reflect when spell is X % complete, ex. 90 = 90% complete")
        -- Engi Belt stuff thanks to Lak
        br.ui:createSpinner(section, "Engineering Belt", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Healthstone
        br.ui:createSpinner(section, "Healthstone/Potion", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Demoralizing Shout
        br.ui:createSpinner(section, "Demoralizing Shout", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Last Stand
        br.ui:createCheckbox(section, "Last Stand Filler", "Use Last Stand as a filler with the Bolster Talent")
        br.ui:createSpinner(section, "Last Stand", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Rallying Cry
        br.ui:createSpinner(section, "Rallying Cry", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Shield Wall
        br.ui:createSpinner(section, "Shield Wall", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Shockwave
        br.ui:createSpinner(section, "Shockwave - HP", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinner(section, "Shockwave - Units", 3, 1, 10, 1, "|cffFFBB00Minimal units to cast on.")
        -- Spell Reflection
        br.ui:createSpinner(section, "Spell Reflection", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Storm Bolt
        br.ui:createSpinner(section, "Storm Bolt", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Feng is a god
        br.ui:createCheckbox(section, "Storm Bolt Logic", "Stun specific Spells and Mobs")
        -- Pummel
        br.ui:createCheckbox(section, "Pummel")
        -- Intimidating Shout
        br.ui:createCheckbox(section, "Intimidating Shout - Int")
        -- Shockwave
        br.ui:createCheckbox(section, "Shockwave - Int")
        -- Storm Bolt
        br.ui:createCheckbox(section, "Storm Bolt - Int")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Corruption Management")
        br.ui:createCheckbox(section,"Corruption Radar On")
        br.ui:createCheckbox(section,"Use Storm Bolt on TFTB")
        br.ui:createCheckbox(section, "Use Int Shout on TFTB")
        br.ui:createDropdownWithout(section, "Use Cloak", { "snare", "Eye", "THING", "Never" }, 4, "", "")
        br.ui:createSpinnerWithout(section, "Eye Of Corruption Stacks - Cloak", 1, 0, 20, 1)
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

local function ipCapCheck()
    if br.player.buff.ignorePain.exists() then
        local ipValue = tonumber((select(1, GetSpellDescription(190456):match("%d+%S+%d"):gsub("%D", ""))), 10)
        local ipMax = math.floor(ipValue * 1.3)
        local ipCurrent = tonumber((select(16, UnitBuffID("player", 190456))), 10)
        if ipCurrent == nil then
            ipCurrent = 0
            return
        end
        if ipCurrent <= (ipMax * 0.2) then
            ---print("IP below cap")
            return true
        else
            --print("dont cast IP")
            return false
        end
    else
        --print("IP not on")
        return true
    end
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    if br.timer:useTimer("debugProtection", 0.1) then
        --Print("Running: "..rotationName)

        ---------------
        --- Toggles ---
        ---------------
        UpdateToggle("Rotation", 0.25)
        UpdateToggle("Cooldown", 0.25)
        UpdateToggle("Defensive", 0.25)
        UpdateToggle("Interrupt", 0.25)
        UpdateToggle("Mover", 0.25)
        UpdateToggle("Taunt", 0.25)
        UpdateToggle("Holdcd", 0.25)
        br.player.ui.mode.mover = br.data.settings[br.selectedSpec].toggles["Mover"]
        br.player.ui.mode.taunt = br.data.settings[br.selectedSpec].toggles["Taunt"]
        br.player.ui.mode.shield = br.data.settings[br.selectedSpec].toggles["Shield"]
        br.player.ui.mode.reflect = br.data.settings[br.selectedSpec].toggles["Reflect"]
        --------------
        --- Locals ---
        --------------
        local buff = br.player.buff
        local cast = br.player.cast
        local combatTime = getCombatTime()
        local cd = br.player.cd
        local charges = br.player.charges
        local deadMouse = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff = br.player.debuff
        local enemies = br.player.enemies
        local falling, swimming, flying, moving = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player") > 0
        local friendly = friendly or GetUnitIsFriend("target", "player")
        local gcd = br.player.gcd
        local gcdMax = br.player.gcdMax
        local healPot = getHealthPot()
        local inCombat = br.player.inCombat
        local inInstance = br.player.instance == "party"
        local inRaid = br.player.instance == "raid"
        local lowestHP = br.friend[1].unit
        local mode = br.player.ui.mode
        local perk = br.player.perk
        local php = br.player.health
        local playerMouse = UnitIsPlayer("mouseover")
        local power, powerMax, powerGen = br.player.power.rage.amount(), br.player.power.rage.max(), br.player.power.rage.regen()
        local pullTimer = br.DBM:getPulltimer()
        local race = br.player.race
        local racial = br.player.getRacial()
        local rage, powerDeficit = br.player.power.rage.amount(), br.player.power.rage.deficit()
        local solo = br.player.instance == "none"
        local spell = br.player.spell
        local talent = br.player.talent
        local thp = getHP("target")
        local ttd = getTTD
        local ttm = br.player.power.rage.ttm()
        local units = br.player.units
        local hasAggro = UnitThreatSituation("player")
        if hasAggro == nil then
            hasAggro = 0
        end
        if timersTable then
            wipe(timersTable)
        end

        units.get(5)
        units.get(8)

        enemies.get(5, nil, nil, nil, spell.pummel)
        enemies.get(8, nil, nil, nil, spell.intimidatingShout)
        enemies.get(10)
        enemies.get(20)
        enemies.get(30, nil, nil, nil, spell.taunt)

        if leftCombat == nil then
            leftCombat = GetTime()
        end
        if profileStop == nil then
            profileStop = false
        end

        local reflectID = {
            --Battle of Dazar'alor
            [283572] = "Sacred Blade",
            [284449] = "Reckoning",
            [286988] = "Divine Burst",
            [282036] = "Fireball",
            [286988] = "Searing Embers",
            [286646] = "Gigavolt Charge",
            [282182] = "Buster Cannon",
            --Uldir
            [279669] = "Bacterial Outbreak",
            [279660] = "Endemic Virus",
            [274262] = "Explosive Corruption",
            --Reaping
            [288693] = "Grave Bolt",
            --Atal'Dazar
            [250096] = "Wracking Pain",
            [253562] = "Wildfire",
            [252923] = "Venom Blast",
            --Kings Rest
            [267618] = "Drain Fluids",
            [267308] = "Lighting Bolt",
            [270493] = "Spectral Bolt",
            [269973] = "Deathly Chill",
            [270923] = "Shadow Bolt",
            --Free Hold
            [259092] = "Lightning Bolt",
            [281420] = "Water Bolt",
            --Siege of Boralus
            [272588] = "Rotting Wounds",
            [272581] = "Water Spray",
            [257063] = "Brackish Bolt",
            [272571] = "Choking Waters",
            -- Temple of Sethraliss
            [263318] = "Jolt",
            [263775] = "Gust",
            [268061] = "Chain Lightning",
            [272820] = "Shock",
            [268013] = "Flame Shock",
            [274642] = "Lava Burst",
            [268703] = "Lightning Bolt",
            [272699] = "Venomous Spit",
            --Shrine of the Storm
            [265001] = "Sea Blast",
            [264560] = "Choking Brine",
            [264144] = "Undertow",
            [268347] = "Void Bolt",
            [267969] = "Water Blast",
            [268233] = "Electrifying Shock",
            [268315] = "Lash",
            [268177] = "Windblast",
            [268273] = "Deep Smash",
            [268317] = "Rip Mind",
            [265001] = "Sea Blast",
            [274703] = "Void Bolt",
            [268214] = "Carve Flesh",
            --Motherlode
            [259856] = "Chemical Burn",
            [260318] = "Alpha Cannon",
            [262794] = "Energy Lash",
            [263202] = "Rock Lance",
            [262268] = "Caustic Compound",
            [263262] = "Shale Spit",
            [263628] = "Charged Claw",
            --Underrot
            [260879] = "Blood Bolt",
            [265084] = "Blood Bolt",
            --Tol Dagor
            [257777] = "Crippling Shiv",
            [257033] = "Fuselighter",
            [258150] = "Salt Blast",
            [258869] = "Blaze",
            --Waycrest Manor
            [260701] = "Bramble Bolt",
            [260700] = "Ruinous Bolt",
            [260699] = "Soul Bolt",
            [268271] = "Wracking Chord",
            [261438] = "Wasting Strike",
            [261440] = "Virulent Pathogen",
            [266225] = "Darkened Lightning",
            [273653] = "Shadow Claw",
            [265881] = "Decaying Touch",
            [264153] = "Spit",
            [278444] = "Infest",
            --Operation: Mechagn
            [298669] = "Taze",
            [300764] = "slimebolt",
            [300650] = "suffocating smog",
            [294195] = "arcing zap",
            [291878] = "pulse blast"
        }
        local Storm_unitList = {
            [131009] = "Spirit of Gold",
            [134388] = "A Knot of Snakes",
            [129758] = "Irontide Grenadier"
        }
        --- Quick maths ---
        local function mainTank()
            if (#enemies.yards30 >= 1 and (hasAggro >= 2)) or isChecked("Open World Defensives") then
                return true
            else
                return false
            end
        end

        local function rageCap()
            if not isExplosive("target") and cast.able.revenge() and rage >= getValue("High Rage Dump") and (not ipCapCheck() or not mainTank()) then
                --print("dumping R")
                if cast.revenge() then
                    return
                end
            end
        end

        ------Stuff with the things ------

        local function actionList_Extras()
            if isChecked("Charge OoC") then
                if cast.able.intercept("target") and getDistance("player", "target") <= 25 and not inCombat then
                    if cast.intercept("target") then
                        return
                    end
                end
            end

            if isChecked("Battle Shout") and cast.able.battleShout() then
                for i = 1, #br.friend do
                    local thisUnit = br.friend[i].unit
                    if not UnitIsDeadOrGhost(thisUnit) and getDistance(thisUnit) < 100 and getBuffRemain(thisUnit, spell.battleShout) < 60 then
                        if cast.battleShout() then
                            return
                        end
                    end
                end
            end
            if inCombat and (getOptionValue("Trinkets") == 1 or (buff.avatar.exists() and getOptionValue("Trinkets") == 4)) then
                if canTrinket(13) and getOptionValue("Trinket 1 Mode") == 1 then
                    useItem(13)
                elseif canTrinket(13) and getOptionValue("Trinket 1 Mode") == 2 then
                    useItemGround("target", 13, 40, 0, nil)
                end

                if canTrinket(14) and getOptionValue("Trinket 2 Mode") == 1 then
                    useItem(14)
                elseif canTrinket(14) and getOptionValue("Trinket 2 Mode") == 2 then
                    useItemGround("target", 14, 40, 0, nil)
                end
            end
        end

        local function offGCD()
            if inCombat then 
                if cast.able.ignorePain() and rage >= getValue("High Rage Dump") and mainTank() and ipCapCheck() then
                    --print("dumping IP")
                    CastSpellByName(GetSpellInfo(190456))
                end

                if useDefensive() then
                    if mode.reflect == 1 and isChecked("Smart Spell Reflect") then
                        for i = 1, #enemies.yards30 do
                            local thisUnit = enemies.yards30[i]
                            local _, _, _, startCast, endCast, _, _, _, spellcastID = UnitCastingInfo(thisUnit)

                            if UnitTarget("player") and reflectID[spellcastID] and (((GetTime() * 1000) - startCast) / (endCast - startCast) * 100) > getOptionValue("Smart Spell Reflect Percent") then
                                if cast.spellReflection() then
                                    return
                                end
                            end
                        end
                    end

                    if mode.shield == 1 and cast.able.shieldBlock() and mainTank() and (not buff.shieldBlock.exists() or (buff.shieldBlock.remain() <= (gcd * 1.5))) and not buff.lastStand.exists() and rage >= 30 then
                        if cast.shieldBlock() then
                            return
                        end
                    end

                    if talent.bolster and isChecked("Last Stand Filler") and not buff.shieldBlock.exists() and cd.shieldBlock.remain() > gcd and mainTank() then
                        if cast.lastStand() then
                            return
                        end
                    end

                    if cast.able.ignorePain() and mainTank() and ipCapCheck() then
                        if buff.vengeanceIgnorePain.exists() and rage >= 42 then
                            CastSpellByName(GetSpellInfo(190456))
                        end
                        if rage >= 55 and not buff.vengeanceRevenge.exists() then
                            CastSpellByName(GetSpellInfo(190456))
                        end
                    end

                    if isChecked("Shield Wall") and php <= getOptionValue("Shield Wall") and cd.lastStand.remain() > 0 and not buff.lastStand.exists() then
                        if cast.shieldWall() then
                            return
                        end
                    end
                end

                if isChecked("Berserker Rage") and hasNoControl(spell.berserkerRage) then
                    if cast.berserkerRage() then
                        return
                    end
                end

                for i = 1, #enemies.yards20 do
                    local thisUnit = enemies.yards20[i]
                    local unitDist = getDistance(thisUnit)
                    if not isExplosive(thisUnit) and canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                        if isChecked("Pummel") and unitDist < 6 then
                            if cast.pummel(thisUnit) then
                                return
                            end
                        end
                    end
                end

                if br.player.ui.mode.taunt == 1 and inInstance then
                    for i = 1, #enemies.yards30 do
                        local thisUnit = enemies.yards30[i]
                        if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
                            if cast.taunt(thisUnit) then
                                return
                            end
                        end
                    end
                end -- End Taunt
                if br.player.ui.mode.taunt == 2 then
                    for i = 1, #enemies.yards30 do
                        local thisUnit = enemies.yards30[i]
                        if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
                            if cast.taunt(thisUnit) then
                                return
                            end
                        end
                    end
                end -- End Taunt
            end
        end
        
        local function actionList_Interrupts()
            if useInterrupts() then
                if isChecked("Storm Bolt Logic") then
                    if cast.able.stormBolt() then
                        local Storm_list = {
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
                        for i = 1, #enemies.yards20 do
                            local thisUnit = enemies.yards20[i]
                            local distance = getDistance(thisUnit)
                            for k, v in pairs(Storm_list) do
                                if (Storm_unitList[GetObjectID(thisUnit)] ~= nil or UnitCastingInfo(thisUnit) == GetSpellInfo(v) or UnitChannelInfo(thisUnit) == GetSpellInfo(v)) and getBuffRemain(thisUnit, 226510) == 0 and distance <= 20 then
                                    if cast.stormBolt(thisUnit) then
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
                for i = 1, #enemies.yards20 do
                    local thisUnit = enemies.yards20[i]
                    local unitDist = getDistance(thisUnit)
                    local targetMe = UnitIsUnit("player", thisUnit) or false
                    if not isExplosive(thisUnit) and canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                        if isChecked("Intimidating Shout - Int") and unitDist <= 8 then
                            if cast.intimidatingShout() then
                                return
                            end
                        end
                        if isChecked("Shockwave - Int") and unitDist < 10 then
                            if cast.shockwave() then
                                return
                            end
                        end
                    end
                end
            end
        end
    
        local function actionList_Moving()
            if br.player.ui.mode.mover == 1 then
                if cast.able.intercept("target") and getDistance("player", "target") >= 8 and getDistance("player", "target") <= 25 then
                    CastSpellByName(GetSpellInfo(spell.intercept))
                end
            end
        end

        local function actionList_Cooldowns()
            if useCDs() and #enemies.yards5 >= 1 then
                if isChecked("Avatar") then
                    --print("cd avatar")
                    if cast.avatar() then
                        return
                    end
                end
                if rage <= 100 and not moving and getOptionValue("Demoralizing Shout - CD") == 2 then
                    if cast.demoralizingShout() then
                        return
                    end
                end
                if not isExplosive("target") and talent.ravager then
                    if cast.ravager("best", false, 1, 8) then
                        return
                    end
                end
                if isChecked("Racial") and (race == "Orc" or race == "Troll" or race == "LightforgedDraenei") and useCDs() and buff.avatar.exists() then
                    if cast.racial("player") then
                        return
                    end
                end
                if isChecked("Racial") and useCDs() and buff.avatar.exists() then
                    CastSpellByName("Berserking")
                end
                --Use Trinkets
                if inCombat and (getOptionValue("Trinkets") == 2 or (buff.avatar.exists() and getOptionValue("Trinkets") == 4)) then
                    if canTrinket(13) and getOptionValue("Trinket 1 Mode") == 1 then
                        useItem(13)
                    elseif canTrinket(13) and getOptionValue("Trinket 1 Mode") == 2 then
                        useItemGround("target", 13, 40, 0, nil)
                    end

                    if canTrinket(14) and getOptionValue("Trinket 2 Mode") == 1 then
                        useItem(14)
                    elseif canTrinket(14) and getOptionValue("Trinket 2 Mode") == 2 then
                        useItemGround("target", 14, 40, 0, nil)
                    end
                end
            end
        end

        local function actionList_Defensives()
            if useDefensive() then
                --Spell Reflect logic
                if php <= 65 and cast.able.victoryRush() then
                    if cast.victoryRush() then
                        return
                    end
                end
                if isChecked("Engineering Belt") and php <= getOptionValue("Engineering Belt") and canUseItem(6) then
                    useItem(6)
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
                if isChecked("Demoralizing Shout") and php <= getOptionValue("Demoralizing Shout") and getOptionValue("Demoralizing Shout - CD") == 1 then
                    if cast.demoralizingShout() then
                        return
                    end
                end
                if isChecked("Last Stand") and php <= getOptionValue("Last Stand") then
                    if cast.lastStand() then
                        return
                    end
                end
                if isChecked("Rallying Cry") and php <= getOptionValue("Rallying Cry") then
                    if cast.rallyingCry() then
                        return
                    end
                end
                if ((isChecked("Shockwave - HP") and php <= getOptionValue("Shockwave - HP")) or (isChecked("Shockwave - Units") and #enemies.yards8 >= getOptionValue("Shockwave - Units") and not moving)) then
                    if cast.shockwave() then
                        return
                    end
                end
                if mode.reflect == 1 and isChecked("Spell Reflection") and php <= getOptionValue("Spell Reflection") then
                    if cast.spellReflection() then
                        return
                    end
                end
                if isChecked("Storm Bolt") and php <= getOptionValue("Storm Bolt") then
                    if cast.stormBolt() then
                        return
                    end
                end
            end
        end

        local function actionList_Single()
            --Avatar units
            if isChecked("Avatar") and (#enemies.yards8 >= getOptionValue("Avatar Mob Count")) and br.player.ui.mode.cooldown == 1 then
                ---print("norm avatar")
                if cast.avatar() then
                    return
                end
            end

            -- Heroic Throw
            if not isExplosive("target") and #enemies.yards10 == 0 and isChecked("Use Heroic Throw") then
                if cast.heroicThrow("target") then
                    return
                end
            end

            --Use Demo Shout on CD
            if getOptionValue("Demoralizing Shout - CD") == 1 and rage <= 100 and not moving then
                if cast.demoralizingShout() then
                    return
                end
            end

            -- Ravager Usage
            if not isExplosive("target") and isChecked("Ravager") then
                if cast.ravager("target", "ground") then
                    return
                end
            end

            --Dragon Roar
            if not isExplosive("target") and isChecked("Dragon Roar") and not moving then
                if cast.dragonRoar() then
                    return
                end
            end

            --High Priority Thunder Clap
            if not isExplosive("target") and #enemies.yards8 >= getValue("Aoe Priority") or debuff.demoralizingShout.exists(units.dyn8) then
                if cast.thunderClap() then
                    return
                end
            end

            -- Shield Slam
            if cast.shieldSlam() then
                return
            end

            -- High Prio Revenge
            if not isExplosive("target") and #enemies.yards8 >= getValue("Aoe Priority") and (buff.revenge.exists() or rage >= getValue("High Rage Dump")) then
                if cast.revenge() then
                    return
                end
            end

            -- Low Prio Thunder Clap
            if not isExplosive("target") and talent.cracklingThunder then
                if cast.thunderClap("player", nil, 1, 12) then
                    return
                end
            else
                if cast.thunderClap("player", nil, 1, 8) then
                    return
                end
            end

            -- Revenge
            if not isExplosive("target") and buff.revenge.exists() or (buff.vengeanceRevenge.exists() and rage >= 50) then
                if cast.revenge() then
                    return
                end
            end

            --avoid rage cap
            if rageCap() then
                return
            end

            --Less Victorious
            if php <= 75 and (talent.impendingVictory or buff.victorious.exists()) and not (cast.able.shieldSlam() or cast.able.thunderClap()) then
                if cast.victoryRush() then
                    return
                end
            end
            --Devestate
            if cd.shieldSlam.remain() > (gcdMax / 2) and (isExplosive("target") or cd.thunderClap.remain() > (gcdMax / 2)) then
                if cast.devastate() then
                    return
                end
            end
        end

        local function corruptionstuff()
            if br.player.equiped.shroudOfResolve and canUseItem(br.player.items.shroudOfResolve) then
                if getValue("Use Cloak") == 1 and debuff.graspingTendrils.exists("player") or getValue("Use Cloak") == 2 and getDebuffStacks("player", 315161) >= getOptionValue("Eye Of Corruption Stacks - Cloak") or getValue("Use Cloak") == 3 and debuff.grandDelusions.exists("player") then
                    if br.player.use.shroudOfResolve() then
                        return
                    end
                end
            end
            if isChecked("Corruption Radar On") then
                for i = 1, GetObjectCountBR() do
                    local object = GetObjectWithIndex(i)
                    local ID = ObjectID(object)
                    if isChecked("Use Storm Bolt on TFTB") then
                        if ID == 161895 then
                            local x1, y1, z1 = ObjectPosition("player")
                            local x2, y2, z2 = ObjectPosition(object)
                            local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                            if distance <= 8 and isChecked("Use Int Shout on TFTB") and cd.intimidatingShout.remains() <= gcd then
                                if cast.intimidatingShout(object) then 
                                    return true
                                end
                            end
                            if distance < 10 and not isLongTimeCCed(object) and cd.stormBolt.remains() <= gcd then
                                if cast.stormBolt(object) then 
                                    return true
                                end
                            end
                        end
                    end -- end the thing
                end
            end
        end

        local function technoViking()
            --Use Demo Shout on CD
            if getOptionValue("Demoralizing Shout - CD") == 1 and rage <= 100 then
                if cast.demoralizingShout() then
                    return
                end
            end

            --stomp your feet
            if not isExplosive("target") and talent.cracklingThunder then
                if cast.thunderClap("player", nil, 1, 12) then
                    return
                end
            else
                if cast.thunderClap("player", nil, 1, 8) then
                    return
                end
            end
            -- High Prio revenge
            if not isExplosive("target") and #enemies.yards8 >= getValue("Aoe Priority") and (buff.revenge.exists() or rage >= getValue("High Rage Dump")) then
                if cast.revenge() then
                    return
                end
            end
            -- Rest
            if not cast.able.thunderClap() then
                if cast.shieldSlam() then
                    return
                end
            end
            -- Recover
            if not isExplosive("target") and not (cast.able.thunderClap()) and (buff.revenge.exists() or rage >= getValue("High Rage Dump")) then
                if cast.revenge() then
                    return
                end
            end
            -- Drink
            if not (cast.able.shieldSlam() or cast.able.thunderClap()) and ipCapCheck() and rage >= 55 then
                CastSpellByName(GetSpellInfo(190456))
            end
            if not cast.able.shieldSlam() or (isExplosive("target") or cast.able.thunderClap()) then
                if cast.devastate() then
                    return
                end
            end
        end

        if offGCD() then return end

        --- Lets do things now
        if pause(true) or (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) or mode.rotation == 2 then
            return true
        else
            -- combat check
            if not inCombat and not IsMounted() then
                if isChecked("Pig Catcher") then
                    bossHelper()
                end
                if actionList_Extras() then
                    return
                end
            end
            if inCombat and profileStop == false and not (IsMounted() or IsFlying()) and #enemies.yards8 >= 1 then
                if getDistance(units.dyn5) < 5 then
                    StartAttack()
                end

                if corruptionstuff() then
                    return
                end

                if actionList_Extras() then
                    return
                end

                --I totally did this .. MOHAHAHA ... but Panglo said I could, eh!
                if actionList_Interrupts() then
                    return
                end

                if actionList_Defensives() then
                    return
                end

                if actionList_Moving() then
                    return
                end

                if actionList_Cooldowns() then
                    return
                end

                if (talent.unstoppableForce and buff.avatar.exists()) then
                    if technoViking() then
                        return
                    end
                end

                if not (talent.unstoppableForce and buff.avatar.exists()) then
                    if actionList_Single() then
                        return
                    end
                end
            end
        end
    --pause
    end
    --timer
end
--runrotation
local id = 73
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

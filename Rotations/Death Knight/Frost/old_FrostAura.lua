local rotationName = "Aura"
---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.howlingBlast },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.howlingBlast },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.frostStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.deathStrike}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.pillarOfFrost },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.pillarOfFrost },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.pillarOfFrost }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.iceboundFortitude },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.iceboundFortitude }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.mindFreeze }
    };
    CreateButton("Interrupt",4,0)
    -- Interrupt Button
    EmpowerModes = {
        [1] = { mode = "On", value = 1 , overlay = "ERW Enabled", tip = "ERW will be used.", highlight = 1, icon = br.player.spell.empowerRuneWeapon },
        [2] = { mode = "Off", value = 2 , overlay = "ERW Disabled", tip = "ERW will not be used.", highlight = 0, icon = br.player.spell.empowerRuneWeapon }
    };
    CreateButton("Empower",5,0)
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
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Death Grip
            br.ui:createCheckbox(section,"Death Grip")
            -- Path of Frost
            br.ui:createCheckbox(section,"Path of Frost")
            br.ui:createSpinner(section, "BoS Rune Power",  80,  0,  100,  5, "|cffFFFFFFSet to desired rune power needed to use Breath of Sindragosa. Min: 1 / Max: 10 / Interval: 1")
            br.ui:createCheckbox(section, "Trinkets")
        br.ui:checkSectionState(section)
        ------------------------
        --- TARGET   OPTIONS --- 
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Targets")
        br.ui:createSpinnerWithout(section, "Pillar of Frost Targets",  3,  1,  10,  1, "|cffFFFFFFSet to desired number of targets needed to use Pillar of Frost. Min: 1 / Max: 10 / Interval: 1")
        br.ui:createSpinnerWithout(section, "Frostwyrm's Fury Targets",  3,  1,  10,  1, "|cffFFFFFFSet to desired number of targets needed to use Frostwyrm's Fury. Min: 1 / Max: 10 / Interval: 1")
        br.ui:createSpinnerWithout(section, "BoS Targets",  3,  1,  10,  1, "|cffFFFFFFSet to desired number of targets needed to use Breath of Sindragosa. Min: 1 / Max: 10 / Interval: 1")
        br.ui:createSpinnerWithout(section, "Remorseless Winter Targets",  3,  1,  10,  1, "|cffFFFFFFSet to desired number of targets needed to use Remorseless Winter. Min: 1 / Max: 10 / Interval: 1")
        br.ui:createSpinnerWithout(section, "Frostscythe Targets",  3,  1,  10,  1, "|cffFFFFFFSet to desired number of targets needed to use Frostscythe. Min: 1 / Max: 10 / Interval: 1")
        br.ui:createSpinnerWithout(section, "Glacial Advance Targets",  5,  1,  10,  1,  "|cffFFFFFFSet to desired targets to use Glacial Advance on. Min: 1 / Max: 10 / Interval: 1")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healing Potion/Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Anti-Magic Shell
            br.ui:createSpinner(section, "Anti-Magic Shell",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Blinding Sleet
            br.ui:createSpinner(section, "Blinding Sleet",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Death Strike
            br.ui:createSpinner(section, "Death Strike",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Icebound Fortitude
            br.ui:createSpinner(section, "Icebound Fortitude",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Raise Ally
            br.ui:createCheckbox(section,"Raise Ally")
            br.ui:createDropdownWithout(section, "Raise Ally - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            --Asphyxiate
            br.ui:createCheckbox(section, "Asphyxiate")
            -- Mind Freeze
            br.ui:createCheckbox(section, "Mind Freeze")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
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
    if br.timer:useTimer("debugFrost", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
        --Print("Running: "..rotationName)
--------------
--- Locals ---
--------------
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk        
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power, br.player.powerMax, br.player.powerRegen
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local runicPower                                    = br.player.power.runicPower.amount()
        local runicPowerDeficit                             = br.player.power.runicPower.deficit()
        local runes                                         = br.player.power.runes.amount()
        local runesFrac                                     = br.player.power.runes.frac()
        local runesTTM                                      = br.player.power.runes.ttm
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttm                                           = br.player.timeToMax
        local units                                         = br.player.units
        local use                                           = br.player.use
        
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        units.get(30)

        enemies.get(8)
        enemies.get(10)
        enemies.get(15)
        enemies.get(20)
        enemies.get(10,"target")
        enemies.get(30)
        enemies.get(30,"target")


        frostFeverCount = 0
        for i=1, #enemies.yards10 do
            local frostFeverRemain = getDebuffRemain(enemies.yards10[i],spell.debuffs.frostFever,"player") or 0
            if frostFeverRemain > 0  then
                frostFeverCount = frostFeverCount + 1
            end
        end

        

--------------------
--- Action Lists ---
--------------------
        -- Action List - Extras
        local function actionList_Extras()
            profileDebug = "Extras"
        -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                        profileStop = true
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        return true
                    end
                end
            end
        -- Chains of Ice
            if isChecked("Chains of Ice") then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if not debuff.chainsOfIce.exists(thisUnit) and not getFacing(thisUnit,"player") and getFacing("player",thisUnit)
                        and isMoving(thisUnit) and getDistance(thisUnit) > 8 and inCombat
                    then
                        if cast.chainsOfIce(thisUnit) then return true end
                    end
                end
            end
        -- Death Grip
            if isChecked("Death Grip") then
                if inCombat and isValidUnit(units.dyn30) and getDistance(units.dyn30) > 8 and not isDummy(units.dyn30) then
                    if cast.deathGrip(units.dyn30) then return true end
                end
            end
        -- Path of Frost
            if isChecked("Path of Frost") then
                if not inCombat and swimming and not buff.pathOfFrost.exists() then
                    if cast.pathOfFrost() then return true end
                end
            end
        end -- End Action List - Extras
        -- Action List - Defensive
        local function actionList_Defensive()
            profileDebug = "Defensive"
            if useDefensive() and not IsMounted() then
        -- Healthstone
                if isChecked("Healing Potion/Healthstone") and php <= getOptionValue("Healing Potion/Healthstone") and inCombat and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
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
        -- Anti-Magic Shell
                if isChecked("Anti-Magic Shell") and php < getOptionValue("Anti-Magic Shell") and inCombat then
                    if cast.antiMagicShell() then return true end
                end
        -- Blinding Sleet
                if isChecked("Blinding Sleet") and php < getOptionValue("Blinding Sleet") and inCombat then
                    if cast.blindingSleet() then return true end
                end
        -- Death Strike
                if isChecked("Death Strike") and inCombat and (buff.darkSuccor.exists() or php < getOptionValue("Death Strike"))
                    and (not talent.breathOfSindragosa or ((cd.breathOfSindragosa.remain() > 15 and not breathOfSindragosaActive or not useCDs()) or not isChecked("Breath of Sindragosa")))
                then
                    if cast.deathStrike() then return true end
                end
        -- Icebound Fortitude
                if isChecked("Icebound Fortitude") and php < getOptionValue("Icebound Fortitude") and inCombat then
                    if cast.iceboundFortitude() then return true end
                end
        -- Raise Ally
                if isChecked("Raise Ally") then
                    if getOptionValue("Raise Ally - Target")==1
                        and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player")
                    then
                        if cast.raiseAlly("target","dead") then return true end
                    end
                    if getOptionValue("Raise Ally - Target")==2
                        and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player")
                    then
                        if cast.raiseAlly("mouseover","dead") then return true end
                    end
                end
            end -- End Use Defensive Check
        end -- End Action List - Defensive
        -- Action List - Interrupts
        local function actionList_Interrupts()
            profileDebug = "Interrupts"
            if useInterrupts() then
            -- Mind Freeze
                if isChecked("Mind Freeze") then
                    for i=1, #enemies.yards15 do
                        thisUnit = enemies.yards15[i]
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if cast.mindFreeze(thisUnit) then return true end
                        end
                    end
                end
                --Asphyxiate
                if isChecked("Asphyxiate") then
                    for i=1, #enemies.yards20 do
                        thisUnit = enemies.yards20[i]
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if cast.asphyxiate(thisUnit) then return true end
                        end
                    end
                end
            end -- End Use Interrupts Check
        end -- End Action List - Interrupts
        local function actionList_ST()
            -- Howling Blast
            if not debuff.frostFever.exists("target") then
                if cast.howlingBlast() then return true end
            end
            -- Frost Strike (Icy Talons)
            if talent.icyTalons and buff.icyTalons.exists() and buff.icyTalons.remain() <= gcdMax and talent.breathOfSindragosa and (cd.breathOfSindragosa.remain() > gcdMax or not useCDs()) and not buff.breathOfSindragosa.exists() then
                if cast.frostStrike() then return true end
            end
            -- Pillar of Frost
            if useCDs() then
                if cast.pillarOfFrost() then return true end
            end
            -- Frostwyrm's Fury
            if talent.frostwyrmsFury and useCDs() then
                if cast.frostwyrmsFury() then return true end
            end
            -- Breath of Sindragosa
            if runicPower >= getValue("BoS Rune Power") and #enemies.yards8 >= getValue("BoS Targets") and useCDs() then
                if cast.breathOfSindragosa(nil,"cone",1,8) then return true end
            end
            -- Chains of Ice
            if talent.coldHeart and buff.coldHeart.stack() >= 20 then
                if cast.chainsOfIce() then return true end
            end
            -- Remorseless Winter
            if #enemies.yards8 > 0 then
                if cast.remorselessWinter() then return true end
            end
            -- Frostscythe
            if talent.frostscythe and buff.killingMachine.exists() and #enemies.yards8 >= getValue("Frostscythe Targets") then
                if cast.frostscythe() then return true end
            end
            -- Obliterate (Killing Machine)
            if buff.killingMachine.exists() and runes >= 2 then
                if cast.obliterate() then return true end
            end
            -- Howling Blast (Rime)
            if buff.rime.exists() then
                if cast.howlingBlast() then return true end
            end
            -- Frost Strike
            if (talent.breathOfSindragosa and (cd.breathOfSindragosa.remain() > gcdMax or not useCDs()) and not buff.breathOfSindragosa.exists()) or not talent.breathOfSindragosa then
                if cast.frostStrike() then return true end
            end
            -- Howling Blast (Pillar of Frost)
            if (buff.pillarOfFrost.exists() or not useCDs()) and not buff.killingMachine.exists() and runes >= 2 then
                if cast.howlingBlast() then return true end
            end
            -- Obliterate 
            if runes >= 2 then
                if cast.obliterate() then return true end
            end
            -- Horn of Winter
            if talent.hornOfWinter then
                if cast.hornOfWinter() then return true end
            end
            -- Empower Rune Weapon
            if mode.empower == 1 and useCDs then
                if cast.empowerRuneWeapon() then return true end
            end
        end

        local function actionList_AoE()
            -- Glacial Advance
            if talent.glacialAdvance and talent.icyTalons and buff.icyTalons.remain() <= gcdMax and getEnemiesInRect(5,20) >= getOptionValue("Glacial Advance Targets") and (not talent.breathOfSindragosa or cd.breathOfSindragosa.remain() > 15 or not useCDs()) then
                if cast.glacialAdvance() then return true end
            end
            -- Pillar of Frost
            if getSpellCD(spell.pillarOfFrost) <= gcd and #enemies.yards8 >= getValue("Pillar of Frost Targets") and useCDs() then
                if cast.pillarOfFrost() then return true end
            end
            -- Frostwyrm's Fury
            if talent.frostwyrmsFury and getEnemiesInRect(5,40) >= getValue("Frostwyrm's Fury Targets") and useCDs() then
                if cast.frostwyrmsFury() then return true end
            end
            -- Breath of Sindragosa
            if runicPower >= getValue("BoS Rune Power") and useCDs() then
                if cast.breathOfSindragosa(nil,"cone",1,8) then return true end
            end
            -- Frostscythe
            if talent.frostscythe and buff.killingMachine.exists() then
                if cast.frostscythe() then return true end
            end
            if talent.coldHeart and buff.coldHeart.stack() >= 20 then
                if cast.chainsOfIce() then return true end
            end
            -- Remorseless Winter
            if runes >= 1 and #enemies.yards8 >= getOptionValue("Remorseless Winter Targets") then
                if cast.remorselessWinter() then return true end
            end
            -- Howling Blast
            if buff.rime.exists() or frostFeverCount < #enemies.yards10 then
                if cast.howlingBlast() then return true end
            end
            -- Obliterate
            if buff.killingMachine.exists() then
                if cast.obliterate() then return true end
            end
            -- Glacial Advance (No Icy Talons)
            if talent.glacialAdvance and not talent.breathOfSindragosa and getEnemiesInRect(5,20) >= getOptionValue("Glacial Advance Targets") then
                if cast.glacialAdvance() then return true end
            end
            if talent.glacialAdvance and talent.breathOfSindragosa and (cd.breathOfSindragosa.remain() > gcdMax or not useCDs()) and not buff.breathOfSindragosa.exists() and getEnemiesInRect(5,20) >= getOptionValue("Glacial Advance Targets") then
                if cast.glacialAdvance() then return true end
            end
            -- Frostscythe 
            if talent.frostscythe then
                if cast.frostscythe() then return true end
            end
            -- Howling Blast (Rime)
            if runes >= 3 or #enemies.yards10t >= 5 or buff.rime.exists() then
                if cast.howlingBlast() then return true end
            end
            -- Horn Winter
            if talent.hornOfWinter then
                if cast.hornOfWinter() then return true end
            end
            -- Empower Rune Weapon
            if mode.empower == 1 and useCDs() then
                if cast.empowerRuneWeapon() then return true end
            end
            -- Frost Strike
            if not talent.breathOfSindragosa then
                if cast.frostStrike() then return true end
            end
            if talent.breathOfSindragosa and (cd.breathOfSindragosa.remain() > gcdMax or not useCDs()) and not buff.breathOfSindragosa.exists() then
                if cast.frostStrike() then return true end
            end
        end

-----------------
--- Rotations ---
-----------------
        -- Pause
        if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or mode.rotation == 4 then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat  then
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                if actionList_Extras() then return true end
                if actionList_Defensive() then return true end
                if getDistance("target") < 5 then
                    StartAttack()
                end
                if actionList_Interrupts() then return true end
                -- Potions
                --Racials
                if useCDs() then
                    if hasItem(166801) and canUseItem(166801) then
                        br.addonDebug("Using Sapphire of Brilliance")
                        useItem(166801)
                    end
                    if (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") then
                        if race == "LightforgedDraenei" then
                        if cast.racial("target","ground") then return true end
                        else
                        if cast.racial("player") then return true end
                        end
                    end
                end
                -- Trinkets
                if isChecked("Trinkets") and useCDs() and getSpellCD(spell.pillarOfFrost) > gcd then
                    use.slot(13)
                    use.slot(14)
                end
                if not debuff.frostFever.exists("target") and (not talent.breathOfSindragosa or (cd.breathOfSindragosa.remain() > 15 or not useCDs())) then
                    if cast.howlingBlast() then return true end
                end
                if talent.glacialAdvance and talent.icyTalons and buff.icyTalons.remain() <= gcdMax and getEnemiesInRect(5,20) >= getOptionValue("Glacial Advance Targets") and (not talent.breathOfSindragosa or (cd.breathOfSindragosa.remain() > 15 or not useCDs())) then
                    if cast.glacialAdvance() then return true end
                end
                if talent.icyTalons and buff.icyTalons.remain() <= gcdMax and (not talent.breathOfSindragosa or (cd.breathOfSindragosa.remain() > 15 or not useCDs())) then
                    if cast.frostStrike() then return true end
                end
                if (#enemies.yards10t > 1 and (mode.rotation ~= 3 and mode.rotation ~= 2)) or mode.rotation == 2 then
                    if actionList_AoE() then return true end
                else
                    if (#enemies.yards10t <= 1 and (mode.rotation ~= 2 and mode.rotation ~= 3)) or mode.rotation == 3 then
                        if actionList_ST() then return true end
                    end
                end
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation 
local id = 0 --Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

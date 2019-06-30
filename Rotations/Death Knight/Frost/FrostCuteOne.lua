local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
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
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.empowerRuneWeapon },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.empowerRuneWeapon },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.empowerRuneWeapon }
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
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Death Grip
            br.ui:createCheckbox(section,"Death Grip")
            -- Glacial Advance
            br.ui:createSpinner(section, "Glacial Advance",  5,  1,  10,  1,  "|cffFFFFFFSet to desired targets to use Glacial Advance on. Min: 1 / Max: 10 / Interval: 1")
            -- Path of Frost
            br.ui:createCheckbox(section,"Path of Frost")
            -- Remorseless Winter
            br.ui:createSpinnerWithout(section, "Remorseless Winter",  1,  1,  10,  1,  "|cffFFFFFFSet to desired targets to use Remorseless Winter on. Min: 1 / Max: 10 / Interval: 1")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Breath of Sindragosa - Debug
            br.ui:createCheckbox(section, "Breath Of Sindragosa Debug", "|cffFFFFFFShows when BoS is active and time it is active for.")
            -- Heart Essence
            br.ui:createCheckbox(section, "Use Essence")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Countless Armies","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- Breath of Sindragosa
            br.ui:createSpinner(section,"Breath of Sindragosa", 30, 10, 100, 5, "|cffFFFFFFSet to desired runic power level to use. Min: 10 / Max: 100 / Interval: 5")
            -- Empower Rune Weapon
            br.ui:createCheckbox(section,"Empower Rune Weapon")
            -- Frostwyrm's Fury
            br.ui:createDropdownWithout(section, "Frostwyrm's Fury", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Frostwyrm's Fury.")
            br.ui:createSpinnerWithout(section, "Frostwyrm's Fury Units",  5,  1,  10,  1,  "|cffFFFFFFSet to desired targets to use Frostwyrm's Fury on. Min: 1 / Max: 10 / Interval: 1")
            -- Horn of Valor
            br.ui:createCheckbox(section,"Horn of Valor")
            -- Obliteration
            br.ui:createCheckbox(section,"Obliteration")
            -- Pillar of Frost
            br.ui:createDropdownWithout(section, "Pillar of Frost", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Pillar of Frost Ability.")
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
        --- INTERRUPT OPTIONS ---
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
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Cleave Toggle
            br.ui:createDropdownWithout(section,  "Cleave Mode", br.dropOptions.Toggle,  6)
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
        -- Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
--------------
--- Locals ---
--------------
        local attacktar         = UnitCanAttack("target", "player")
        local buff              = br.player.buff
        local cast              = br.player.cast
        local cd                = br.player.cd
        local charges           = br.player.charges
        local deadtar           = UnitIsDeadOrGhost("target") or isDummy()
        local debuff            = br.player.debuff
        local enemies           = br.player.enemies
        local equiped           = br.player.equiped
        local gcd               = br.player.gcd
        local gcdMax            = br.player.gcdMax
        local glyph             = br.player.glyph
        local healPot           = getHealthPot()
        local inCombat          = br.player.inCombat
        local item              = br.player.item
        local level             = br.player.level
        local mode              = br.player.mode
        local moving            = GetUnitSpeed("player")>0
        local php               = br.player.health
        local power             = br.player.power
        local pullTimer         = br.DBM:getPulltimer()
        local racial            = br.player.getRacial()
        local runicPower        = br.player.power.runicPower.amount()
        local runicPowerDeficit = br.player.power.runicPower.deficit()
        local runes             = br.player.power.runes.amount()
        local runesFrac         = br.player.power.runes.frac()
        local runesTTM          = br.player.power.runes.ttm
        local swimming          = IsSwimming()
        local talent            = br.player.talent
        local trait             = br.player.traits
        local ttd               = getTTD
        local units             = br.player.units
        local use               = br.player.use

    -- Dynamic Units
        units.get(5)
        units.get(30)
        units.get(40)

    -- Enemies Tables
        enemies.get(8)
        enemies.get(10,"target")
        enemies.get(15)
        enemies.get(20)
        enemies.get(30)

    -- Special Enemy Counts
        enemies.yards8f   = getEnemiesInCone(180,8)
        enemies.yards20r  = getEnemiesInRect(10,20,false) or 0
        enemies.yards40r  = getEnemiesInRect(10,40,false) or 0

        if breathOfSindragosaActive == nil then breathOfSindragosaActive = false end
        if breathOfSindragosaActive and not breathTimerSet then currentBreathTime = GetTime(); breathTimerSet = true end
        if not breathOfSindragosaActive then breathTimerSet = false end --; breathTimer = GetTime() end
        if currentBreathTime == nil then breathTimer = 0 end
        if breathTimerSet then breathTimer = round2(GetTime() - currentBreathTime,2) end
        if profileDebug == nil or not inCombat then profileDebug = "None" end
        if not cd.frostwyrmsFury.exists() then frostWyrmUp = 1 else frostWyrmUp = 0 end
        if talent.runicAttenuation then attenuation = 1 else attenuation = 0 end

        if isChecked("Breath Of Sindragosa Debug") then
            ChatOverlay("Breath Active: "..tostring(breathOfSindragosaActive).." | Breath Timer: "..breathTimer)
        end

        -- ChatOverlay(tostring(profileDebug))

    -- Profile Stop
        if profileStop == nil then profileStop = false end
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
            if isChecked("Chains of Ice") and cast.able.chainsOfIce() then
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
            if isChecked("Death Grip") and cast.able.deathGrip() then
                if inCombat and isValidUnit(units.dyn30) and getDistance(units.dyn30) > 8 and not isDummy(units.dyn30) then
                    if cast.deathGrip(units.dyn30) then return true end
                end
            end
        -- Path of Frost
            if isChecked("Path of Frost") and cast.able.pathOfFrost() then
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
                if isChecked("Healing Potion/Healthstone") and php <= getOptionValue("Healing Potion/Healthstone") and inCombat and (hasHealthPot() or hasItem(5512)) then
                    if canUseItem(5512) then
                        useItem(5512)
                    elseif canUseItem(healPot) then
                        useItem(healPot)
                    end
                end
        -- Anti-Magic Shell
                if isChecked("Anti-Magic Shell") and cast.able.antiMagicShell() and php < getOptionValue("Anti-Magic Shell") and inCombat then
                    if cast.antiMagicShell() then return true end
                end
        -- Blinding Sleet
                if isChecked("Blinding Sleet") and cast.able.blindingSleet() and php < getOptionValue("Blinding Sleet") and inCombat then
                    if cast.blindingSleet() then return true end
                end
        -- Death Strike
                if isChecked("Death Strike") and cast.able.deathStrike() and inCombat and (buff.darkSuccor.exists() or php < getOptionValue("Death Strike"))
                    and not breathOfSindragosaActive
                then
                    if cast.deathStrike() then return true end
                end
        -- Icebound Fortitude
                if isChecked("Icebound Fortitude") and cast.able.iceboundFortitude() and php < getOptionValue("Icebound Fortitude") and inCombat then
                    if cast.iceboundFortitude() then return true end
                end
        -- Raise Ally
                if isChecked("Raise Ally") then
                    if cast.able.raiseAlly("target","dead") and getOptionValue("Raise Ally - Target")==1
                        and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player")
                    then
                        if cast.raiseAlly("target","dead") then return true end
                    end
                    if cast.able.raiseAlly("mouseover","dead") and getOptionValue("Raise Ally - Target")==2
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
                if isChecked("Mind Freeze") and cast.able.mindFreeze() then
                    for i=1, #enemies.yards15 do
                        thisUnit = enemies.yards15[i]
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if cast.mindFreeze(thisUnit) then return true end
                        end
                    end
                end
        --Asphyxiate
                if isChecked("Asphyxiate") and cast.able.asphyxiate() then
                    for i=1, #enemies.yards20 do
                        thisUnit = enemies.yards20[i]
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if cast.asphyxiate(thisUnit) then return true end
                        end
                    end
                end
            end -- End Use Interrupts Check
        end -- End Action List - Interrupts
    -- Action List - Cold Heart
        local function actionList_ColdHeart()
            profileDebug = "Cold Heart"
        -- Chains of Ice
            -- chains_of_ice,if=buff.cold_heart.stack>5&target.time_to_die<gcd
            if cast.able.chainsOfIce() and (buff.coldHeart.stack() > 5 and ttd(units.dyn5) < gcdMax) then
                if cast.chainsOfIce() then return true end
            end
            -- chains_of_ice,if=(buff.pillar_of_frost.remains<=gcd*(1+cooldown.frostwyrms_fury.ready)|buff.pillar_of_frost.remains<rune.time_to_3)&buff.pillar_of_frost.up&azerite.icy_citadel.rank<=2
            if cast.able.chainsOfIce() and ((buff.pillarOfFrost.remain() <= gcdMax * (1 + frostWyrmUp) or buff.pillarOfFrost.remain() < runesTTM(3)) 
                and buff.pillarOfFrost.exists() and trait.icyCitadel.rank <= 2) 
            then
                if cast.chainsOfIce() then return true end
            end
            -- chains_of_ice,if=buff.pillar_of_frost.remains<8&buff.unholy_strength.remains<gcd*(1+cooldown.frostwyrms_fury.ready)&buff.unholy_strength.remains&buff.pillar_of_frost.up&azerite.icy_citadel.rank<=2
            if cast.able.chainsOfIce() and buff.pillarOfFrost.remain() < 8 and buff.unholyStrength.remain() < gcdMax * (1 + frostWyrmUp) 
                and buff.unholyStrength.exists() and buff.pillarOfFrost.exists() and trait.icyCitadel.rank <= 2
            then
                if cast.chainsOfIce() then return true end 
            end
            -- chains_of_ice,if=(buff.icy_citadel.remains<4|buff.icy_citadel.remains<rune.time_to_3)&buff.icy_citadel.up&azerite.icy_citadel.rank>2
            if cast.able.chainsOfIce() and (buff.icyCitadel.remain() < 4 or buff.icyCitadel.remain() < runesTTM(3)) and buff.icyCitadel.exists() and trait.icyCitadel.rank > 2 then
                if cast.chainsOfIce() then return true end 
            end
            -- chains_of_ice,if=buff.icy_citadel.up&buff.unholy_strength.up&azerite.icy_citadel.rank>2
            if cast.able.chainsOfIce() and (buff.icyCitadel.exists() and buff.unholyStrength.exists() and trait.icyCitadel.rank > 2) then
                if cast.chainsOfIce() then return true end
            end
        end -- End Action List - Cold Heart
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            profileDebug = "Cooldowns"
            if getDistance(units.dyn5) < 5 then
        -- Trinkets
                -- use_item,name=horn_of_valor,if=buff.pillar_of_frost.up&(!talent.breath_of_sindragosa.enabled|!cooldown.breath_of_sindragosa.remains)
                if isChecked("Trinkets") and useCDs() then
                    use.slot(13)
                    use.slot(14)
                end
        -- Potion
                -- potion,if=buff.pillar_of_frost.up&buff.empower_rune_weapon.up
                if isChecked("Potion") and useCDs() and raid then
                    if buff.pillarOfFrost.exists() and buff.empowerRuneWeapon.exists() then
                        use.potionOfProlongedPower()
                    end
                end
        -- Racial: Orc Blood Fury | Troll Berserking
                -- blood_fury,if=buff.pillar_of_frost.up&buff.empower_rune_weapon.up
                -- berserking,if=buff.pillar_of_frost.up
                if isChecked("Racial") and useCDs() and cast.able.racial() and buff.pillarOfFrost.exists()
                    and (br.player.race == "Troll" or (br.player.race == "Orc" and buff.empowerRuneWeapon.exists()))
                then
                    if cast.racial() then return true end
                end
        -- Pillar of Frost
                -- pillar_of_frost,if=cooldown.empower_rune_weapon.remains
                if getOptionValue("Pillar of Frost") == 1 or (getOptionValue("Pillar of Frost") == 2 and useCDs()) and getDistance(units.dyn5) < 5 then
                    if cast.able.pillarOfFrost() and ((cd.empowerRuneWeapon.remain() > gcdMax and runicPower >= getOptionValue("Breath of Sindragosa") - 10) 
                        or not talent.breathOfSindragosa or cd.breathOfSindragosa.remain() > 40 or not isChecked("Breath of Sindragosa") or not useCDs()) 
                    then
                        if cast.pillarOfFrost() then return true end
                    end
                end
        -- Breath of Sindragosa
                -- breath_of_sindragosa,use_off_gcd=1,if=cooldown.empower_rune_weapon.remains&cooldown.pillar_of_frost.remains
                if isChecked("Breath of Sindragosa") and useCDs() and cast.able.breathOfSindragosa()
                    and runicPower >= getOptionValue("Breath of Sindragosa") and cd.empowerRuneWeapon.remain() > gcdMax and cd.pillarOfFrost.remain() > gcdMax
                then
                    if cast.breathOfSindragosa(nil,"cone",1,8) then return true end
                end
        -- Empower Rune Weapon
                if isChecked("Empower Rune Weapon") and useCDs() then
                    -- empower_rune_weapon,if=cooldown.pillar_of_frost.ready&!talent.breath_of_sindragosa.enabled&rune.time_to_5>gcd&runic_power.deficit>=10|target.time_to_die<20
                    if cast.able.empowerRuneWeapon() and (not cd.pillarOfFrost.exists() and (not talent.breathOfSindragosa or not isChecked("Breath of Sindragosa"))
                        and runesTTM(5) > gcdMax and (runicPowerDeficit >= 10 or (ttd(units.dyn5) < 20 and not isDummy()))) 
                    then
                        if cast.empowerRuneWeapon() then return true end
                    end
                    -- empower_rune_weapon,if=(cooldown.pillar_of_frost.ready|target.1.time_to_die<20)&talent.breath_of_sindragosa.enabled&runic_power>60
                    if cast.able.empowerRuneWeapon() and (cd.pillarOfFrost.remain() < gcdMax or (ttd(units.dyn5) < 20 and not isDummy())) 
                        and talent.breathOfSindragosa and isChecked("Breath of Sindragosa") 
                        and runicPower >= getOptionValue("Breath of Sindragosa") - 10 and cd.breathOfSindragosa.remain() < gcdMax
                    then
                        if cast.empowerRuneWeapon() then return true end
                    end
                end
        -- Call Action List - Cold Heart
                -- call_action_list,name=cold_heart,if=talent.cold_heart.enabled&((buff.cold_heart.stack>=10&debuff.razorice.stack=5)|target.time_to_die<=gcd)
                if useCDs() and talent.coldHeart and ((buff.coldHeart.stack() >= 10 and debuff.razorice.stack(units.dyn5) == 5) or ttd(units.dyn5) <= gcdMax) then
                    if actionList_ColdHeart() then return true end
                end
        -- Frostwyrm's Fury
                if getOptionValue("Frostwyrm's Fury") == 1 or (getOptionValue("Frostwyrm's Fury") == 2 and useCDs())
                    and cast.able.frostwyrmsFury() and enemies.yards40r >= getOptionValue("Frostwyrm's Fury")
                then
                    -- frostwyrms_fury,if=(buff.pillar_of_frost.remains<=gcd|(buff.pillar_of_frost.remains<8&buff.unholy_strength.remains<=gcd&buff.unholy_strength.up))&buff.pillar_of_frost.up&azerite.icy_citadel.rank<=2
                    if (buff.pillarOfFrost.remain() <= gcdMax or (buff.pillarOfFrost.remain() < 8 
                        and buff.unholyStrength.remain() <= gcdMax and buff.unholyStrength.exists())) 
                        and buff.pillarOfFrost.exists() and trait.icyCitadel.rank <= 2
                    then
                        if cast.frostwyrmsFury() then return true end
                    end
                    -- frostwyrms_fury,if=(buff.icy_citadel.remains<=gcd|(buff.icy_citadel.remains<8&buff.unholy_strength.remains<=gcd&buff.unholy_strength.up))&buff.icy_citadel.up&azerite.icy_citadel.rank>2
                    if (buff.icyCitadel.remain() <= gcdMax or (buff.icyCitadel.remain() < 8 and buff.unholyStrength.remain() <= gcdMax and buff.unholyStrength.exists()))
                        and buff.icyCitadel.exists() and trait.icyCitadel.rank > 2
                    then 
                        if cast.frostwyrmsFury() then return true end 
                    end
                    -- frostwyrms_fury,if=target.time_to_die<gcd|(target.time_to_die<cooldown.pillar_of_frost.remains&buff.unholy_strength.up)
                    if (ttd(units.dyn5) < gcdMax or (ttd(units.dyn5) < cd.pillarOfFrost.remain() and buff.unholyStrength.exists())) then 
                        if cast.frostwyrmsFury() then return true end
                    end
                end
            end -- End Use Cooldowns Check
        end -- End Action List - Cooldowns
    -- Action List - Essences
        local function actionList_Essences()
        -- Blood of the Enemy
            -- blood_of_the_enemy,if=buff.pillar_of_frost.remains<10&cooldown.breath_of_sindragosa.remains|buff.pillar_of_frost.remains<10&!talent.breath_of_sindragosa.enabled
            if useCDs() and cast.able.bloodOfTheEnemy() and buff.pillarOfFrost.remain() < 10 and cd.breathOfSindragosa.remain() > gcdMax 
                or buff.pillarOfFrost.remain() < 10 and not talent.breathOfSindragosa 
            then
                if cast.bloodOfTheEnemy() then return true end 
            end
        -- Guardian of Azeroth
            -- guardian_of_azeroth
            if useCDs() and cast.able.guardianOfAzeroth() then
                if cast.guardianOfAzeroth() then return true end
            end
        -- Focused Azerite Beam
            -- focused_azerite_beam,if=!buff.pillar_of_frost.up&!buff.breath_of_sindragosa.up
            if cast.able.focusedAzeriteBeam() and not buff.pillarOfFrost.exists() and not breathOfSindragosaActive then 
                if cast.focusedAzeriteBeam() then return true end 
            end
        -- Concentrated Flame
            -- concentrated_flame,if=!buff.pillar_of_frost.up&!buff.breath_of_sindragosa.up&dot.concentrated_flame_burn.remains=0
            if cast.able.concentratedFlame() and not buff.pillarOfFrost.exists() 
                and not breathOfSindragosaActive and not debuff.concentratedFlame.exists(units.dyn5) 
            then
                if cast.concentratedFlame() then return true end 
            end
        -- Purifying Blast
            -- purifying_blast,if=!buff.pillar_of_frost.up&!buff.breath_of_sindragosa.up
            if useCDs() and cast.able.purifyingBlast() and not buff.pillarOfFrost.exists() and not breathOfSindragosaActive then
                if cast.purifyingBlast() then return true end 
            end
        -- Worldvein Resonance
            -- worldvein_resonance,if=!buff.pillar_of_frost.up&!buff.breath_of_sindragosa.up
            if cast.able.worldveinResonance() and not buff.pillarOfFrost.exists() and not breathOfSindragosaActive then
                if cast.worldveinResonance() then return true end 
            end
        -- Ripple In Space
            -- ripple_in_space,if=!buff.pillar_of_frost.up&!buff.breath_of_sindragosa.up
            if useCDs() and cast.able.rippleInSpace() and not buff.pillarOfFrost.exists() and not breathOfSindragosaActive then
                if cast.rippleInSpace() then return true end 
            end
        -- Memory of Lucid Dreams
            -- memory_of_lucid_dreams,if=buff.empower_rune_weapon.remains<5&buff.breath_of_sindragosa.up|(rune.time_to_2>gcd&runic_power<50)
            if useCDs() and cast.able.memoryOfLucidDreams() and buff.empowerRuneWeapon.remain() < 5 
                and breathOfSindragosaActive or (runesTTM(2) > gcdMax and runicPower < 50)
            then 
                if cast.memoryOfLucidDreams() then return true end 
            end
        end
    -- Action List - Breath of Sindragosa Pooling
        local function actionList_BoSPooling()
            profileDebug = "Breath Of Sindragosa - Pooling"
        -- Howling Blast
            -- howling_blast,if=buff.rime.up
            if cast.able.howlingBlast() and (buff.rime.exists()) and #enemies.yards10t > 0 then
                if cast.howlingBlast() then return true end
            end
        -- Obliterate
            -- obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&&runic_power.deficit>=25&!talent.frostscythe.enabled
            if cast.able.obliterate() and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remain(units.dyn5) < 10) 
                and runicPowerDeficit >= 25 and not talent.frostscythe 
            then
                if cast.obliterate() then return true end 
            end
            -- obliterate,if=runic_power.deficit>=25
            if cast.able.obliterate() and runicPowerDeficit >= 25 then
                if cast.obliterate() then return true end
            end
        -- Glacial Advance
            -- glacial_advance,if=runic_power.deficit<20&spell_targets.glacial_advance>=2&cooldown.pillar_of_frost.remains>5
            if cast.able.glacialAdvance() and runicPowerDeficit < 20 and enemies.yards20r >= getOptionValue("Glacial Advance") and cd.pillarOfFrost.remain() > 5 then
                if cast.glacialAdvance(nil,"rect",1,10) then return true end
            end
        -- Frost Strike
            -- frost_strike,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&runic_power.deficit<20&!talent.frostscythe.enabled&cooldown.pillar_of_frost.remains>5
            if cast.able.frostStrike() and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remain(units.dyn5) < 10) 
                and runicPowerDeficit >= 20 and not talent.frostscythe and cd.pillarOfFrost.remain() > 5
            then
                if cast.frostStrike() then return true end
            end
            -- frost_strike,if=runic_power.deficit<20&cooldown.pillar_of_frost.remains>5
            if cast.able.frostStrike() and (runicPowerDeficit < 20 and cd.pillarOfFrost.remain() > 5) then
                if cast.frostStrike() then return true end
            end
        -- Frostscythe
            -- frostscythe,if=buff.killing_machine.up&runic_power.deficit>(15+talent.runic_attenuation.enabled*3)&spell_targets.frostscythe>=2
            if cast.able.frostscythe() and (buff.killingMachine.exists() and runicPowerDeficit > (15 + attenuation * 3))
                and enemies.yards8f >= 2
            then
                if cast.frostscythe() then return true end
            end
            -- frostscythe,if=runic_power.deficit>=(35+talent.runic_attenuation.enabled*3)&spell_targets.frostscythe>=2
            if cast.able.frostscythe() and (runicPowerDeficit > (15 + attenuation * 3) and enemies.yards8f >= 2) then
                if cast.frostscythe() then return true end
            end
        -- Obliterate
            -- obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&runic_power.deficit>=(35+talent.runic_attenuation.enabled*3)&!talent.frostscythe.enabled
            if cast.able.obliterate() and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remain(units.dyn5) < 10) 
                and runicPowerDeficit >= (35 + attenuation * 3) and not talent.frostscythe
            then
                if cast.obliterate() then return true end
            end
            -- obliterate,if=runic_power.deficit>=(35+talent.runic_attenuation.enabled*3)
            if cast.able.obliterate() and (runicPowerDeficit >= (35 + attenuation * 3)) then
                if cast.obliterate() then return true end
            end
        -- Glacial Advance
            -- glacial_advance,if=cooldown.pillar_of_frost.remains>rune.time_to_4&runic_power.deficit<40&spell_targets.glacial_advance>=2
            if cast.able.glacialAdvance() and (cd.pillarOfFrost.remain() > runesTTM(4) and runicPowerDeficit < 40
                and ((mode.rotation == 1 and enemies.yards20r >= getOptionValue("Glacial Advance")) or (mode.rotation == 2 and enemies.yards20r > 0))) then
                if cast.glacialAdvance(nil,"rect",1,10) then return true end
            end
        -- Frost Strike
            -- frost_strike,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&cooldown.pillar_of_frost.remains>rune.time_to_4&runic_power.deficit<40&!talent.frostscythe.enabled
            if cast.able.frostStrike() and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remain(units.dyn5) < 10) 
                and cd.pillarOfFrost.remain() > runesTTM(4) and runicPowerDeficit < 40 and not talent.frostscythe
            then
                if cast.frostStrike() then return true end
            end
            -- frost_strike,if=cooldown.pillar_of_frost.remains>rune.time_to_4&runic_power.deficit<40
            if cast.able.frostStrike() and (cd.pillarOfFrost.remain() > runesTTM(4) and runicPowerDeficit < 40) then
                if cast.frostStrike() then return true end
            end
        end
    -- Action List - Breath of Sindragosa Ticking
        local function actionList_BoSTicking()
            profileDebug = "Breath Of Sindragosa - Ticking"
        -- Obliterate
            -- obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&runic_power<=30&!talent.frostscythe.enabled
            if cast.able.obliterate() and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remain(units.dyn5) < 10) 
                and runicPower <= 20 and not talent.frostscythe 
            then
                if cast.obliterate() then return true end 
            end
            -- obliterate,if=runic_power<=32
            if cast.able.obliterate() and (runicPower <= 32) then
                if cast.obliterate() then return true end
            end
        -- Remorseless Winter
            -- remorseless_winter,if=talent.gathering_storm.enabled
            if cast.able.remorselessWinter() and (talent.gatheringStorm) and #enemies.yards8 >= getOptionValue("Remorseless Winter") then
                if cast.remorselessWinter() then return true end
            end
        -- Howling Blast
            -- howling_blast,if=buff.rime.up
            if cast.able.howlingBlast() and (buff.rime.exists()) then
                if cast.howlingBlast() then return true end
            end
        -- Obliterate
            -- obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&rune.time_to_5<gcd|runic_power<=45&!talent.frostscythe.enabled
            if cast.able.obliterate() and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remain(units.dyn5) < 10) 
                and runesTTM(5) <= gcdMax or runicPower <= 45 and not talent.frostscythe 
            then
                if cast.obliterate() then return true end 
            end
            -- obliterate,if=rune.time_to_5<gcd|runic_power<=45
            if cast.able.obliterate() and (runesTTM(5) < gcdMax or runicPower <= 45) then
                if cast.obliterate() then return true end
            end
        -- Frostscythe
            -- frostscythe,if=buff.killing_machine.up&spell_targets.frostscythe>=2
            if cast.able.frostscythe() and (buff.killingMachine.exists()) and enemies.yards8f >= 2 then
                if cast.frostscythe() then return true end
            end
        -- Horn of Winter
            -- horn_of_winter,if=runic_power.deficit>=32&rune.time_to_3>gcd
            if cast.able.hornOfWinter() and (runicPowerDeficit >= 32 and runesTTM(3) > gcdMax) then
                if cast.hornOfWinter() then return true end
            end
        -- Remorseless Winter
            -- remorseless_winter
            if cast.able.remorselessWinter() and #enemies.yards8 >= getOptionValue("Remorseless Winter") then
                if cast.remorselessWinter() then return true end
            end
        -- Frostscythe
            -- frostscythe,if=spell_targets.frostscythe>=2
            if cast.able.frostscythe() and ((mode.rotation == 1 and enemies.yards8f >= 2) or (mode.rotation == 2 and enemies.yards8f > 0)) then
                if cast.frostscythe() then return true end
            end
        -- Obliterate
            -- obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&runic_power.deficit>25|rune>3&!talent.frostscythe.enabled
            if cast.able.obliterate() and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remain(units.dyn5) < 10) 
                and runicPowerDeficit > 25 or runes > 3 and not talent.frostscythe 
            then
                if cast.obliterate() then return true end 
            end
            -- obliterate,if=runic_power.deficit>25|rune>3
            if cast.able.obliterate() and (runicPowerDeficit > 25 or runes > 3) then
                if cast.obliterate() then return true end
            end
        -- Racial: Arcane Torrent
            -- arcane_torrent,if=runic_power.deficit>20
            if cast.able.racial() and (runicPowerDeficit > 20 and race == "BloodElf") then
                if cast.racial() then return true end
            end
        end
    -- Action List - Obliteration
        local function actionList_Obliteration()
            profileDebug = "Obliteration"
        -- Remorseless Winter
            -- remorseless_winter,if=talent.gathering_storm.enabled
            if cast.able.remorselessWinter() and (talent.gatheringStorm and #enemies.yards8 >= getOptionValue("Remorseless Winter")) then
                if cast.remorselessWinter() then return true end
            end
        -- Obliterate
            -- obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&!talent.frostscythe.enabled&!buff.rime.up&spell_targets.howling_blast>=3
            if cast.able.obliterate() and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remain(units.dyn5) < 10) 
                and (not talent.frostscythe and not buff.rime.exists()
                and ((mode.rotation == 1 and #enemies.yards10t >= 3) or (mode.rotation == 2 and #enemies.yards10t > 0)))
            then
                if cast.obliterate() then return true end
            end
            -- obliterate,if=!talent.frostscythe.enabled&!buff.rime.up&spell_targets.howling_blast>=3
            if cast.able.obliterate() and (not talent.frostscythe and not buff.rime.exists()
                and ((mode.rotation == 1 and #enemies.yards10t >= 3) or (mode.rotation == 2 and #enemies.yards10t > 0)))
            then
                if cast.obliterate() then return true end
            end
        -- Frostscythe
            -- frostscythe,if=(buff.killing_machine.react|(buff.killing_machine.up&(prev_gcd.1.frost_strike|prev_gcd.1.howling_blast|prev_gcd.1.glacial_advance)))&(rune.time_to_4>gcd|spell_targets.frostscythe>=2)
            if cast.able.frostscythe() and ((buff.killingMachine.exists() or (buff.killingMachine.exists()
                and (cast.last.frostStrike(1) or cast.last.howlingBlast(1) or cast.last.glacialAdvance(1)))) and (runesTTM(4) > gcdMax
                or ((mode.rotation == 1 and enemies.yards8f >= 2) or (mode.rotation == 2 and enemies.yards8f > 0))))
            then
                if cast.frostscythe() then return true end
            end
        -- Obliterate
            -- obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&buff.killing_machine.react|(buff.killing_machine.up&(prev_gcd.1.frost_strike|prev_gcd.1.howling_blast|prev_gcd.1.glacial_advance))
            if cast.able.obliterate() and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remain(units.dyn5) < 10) 
                and (buff.killingMachine.exists() or (buff.killingMachine.exists() 
                and (cast.last.frostStrike(1) or cast.last.howlingBlast(1) or cast.last.glacialAdvance(1)))) 
            then
                if cast.obliterate() then return true end
            end
            -- obliterate,if=buff.killing_machine.react|(buff.killing_machine.up&(prev_gcd.1.frost_strike|prev_gcd.1.howling_blast|prev_gcd.1.glacial_advance))
            if cast.able.obliterate() and (buff.killingMachine.exists() or (buff.killingMachine.exists() and (cast.last.frostStrike(1) or cast.last.howlingBlast(1) or cast.last.glacialAdvance(1)))) then
                if cast.obliterate() then return true end
            end
        -- Glacial Advance
            -- glacial_advance,if=(!buff.rime.up|runic_power.deficit<10|rune.time_to_2>gcd)&spell_targets.glacial_advance>=2
            if cast.able.glacialAdvance() and ((not buff.rime.exists() or runicPowerDeficit < 10 or runesTTM(2) > gcdMax)
                and ((mode.rotation == 1 and enemies.yards20r >= getOptionValue("Glacial Advance")) or (mode.rotation == 2 and enemies.yards20r > 0)))
            then
                if cast.glacialAdvance(nil,"rect",1,10) then return true end
            end
        -- Howling Blast
            -- howling_blast,if=buff.rime.up&spell_targets.howling_blast>=2
            if cast.able.howlingBlast() and (buff.rime.exists() and ((mode.rotation == 1 and #enemies.yards10t >= 2) or (mode.rotation == 2 and #enemies.yards10t > 0))) then
                if cast.howlingBlast() then return true end
            end
        -- Frost Strike
            -- frost_strike,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&!buff.rime.up|runic_power.deficit<10|rune.time_to_2>gcd&!talent.frostscythe.enabled
            if cast.able.frostStrike() and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remain(units.dyn5) < 10)
                and (not buff.rime.exists() or runicPowerDeficit < 10 or runesTTM(2) > gcdMax) and not talent.frostscythe 
            then
                if cast.frostStrike() then return true end
            end
            -- frost_strike,if=!buff.rime.up|runic_power.deficit<10|rune.time_to_2>gcd
            if cast.able.frostStrike() and (not buff.rime.exists() or runicPowerDeficit < 10 or runesTTM(2) > gcdMax) then
                if cast.frostStrike() then return true end
            end
        -- Howling Blast
            -- howling_blast,if=buff.rime.up
            if cast.able.howlingBlast() and (buff.rime.exists()) and #enemies.yards10t > 0 then
                if cast.howlingBlast() then return true end
            end
        -- Obliterate
            -- obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&!talent.frostscythe.enabled
            if cast.able.obliterate() and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remain(units.dyn5) < 10) and not talent.frostscythe then
                if cast.obliterate() then return true end
            end
            -- obliterate
            if cast.able.obliterate() then
                if cast.obliterate() then return true end
            end
        end -- End Action List - Obliteration
    -- Action List - Aoe
        local function actionList_Aoe()
        -- Remorseless Winter
            -- remorseless_winter,if=talent.gathering_storm.enabled|(azerite.frozen_tempest.rank&spell_targets.remorseless_winter>=3&!buff.rime.up)
            if cast.able.remorselessWinter() and (talent.gatheringStorm 
                or (trait.frozenTempest.active and #enemies.yards8 >= getOptionValue("Remorseless Winter") and not buff.rime.exists())) 
            then
                if cast.remorselessWinter() then return true end
            end
        -- Glacial Advance
            -- glacial_advance,if=talent.frostscythe.enabled
            if cast.able.glacialAdvance() and (talent.frostscythe) and enemies.yards20r >= getOptionValue("Glacial Advance") then
                if cast.glacialAdvance(nil,"rect",1,10) then return true end
            end
        -- Frost Strike
            -- frost_strike,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&cooldown.remorseless_winter.remains<=2*gcd&talent.gathering_storm.enabled&!talent.frostscythe.enabled
            if cast.able.frostStrike() and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remain(units.dyn5) < 10) 
                and cd.remorselessWinter.remain() <= 2 * gcdMax and talent.gatheringStorm and not talent.frostscythe 
            then
                if cast.frostStrike() then return true end 
            end
            -- frost_strike,if=cooldown.remorseless_winter.remains<=2*gcd&talent.gathering_storm.enabled
            if cast.able.frostStrike() and (cd.remorselessWinter.remain() <= 2 * gcdMax and talent.gatheringStorm) then
                if cast.frostStrike() then return true end
            end
        -- Howling Blast
            -- howling_blast,if=buff.rime.up
            if cast.able.howlingBlast() and (buff.rime.exists()) and #enemies.yards10t > 0 then
                if cast.howlingBlast() then return true end
            end
        -- Frostscythe
            -- frostscythe,if=buff.killing_machine.up
            if cast.able.frostscythe() and (buff.killingMachine.exists()) and enemies.yards8f then
                if cast.frostscythe() then return true end
            end
        -- Glacial Advance
            -- glacial_advance,if=runic_power.deficit<(15+talent.runic_attenuation.enabled*3)
            if cast.able.glacialAdvance() and (runicPowerDeficit < (15 + attenuation * 3) and enemies.yards20r >= getOptionValue("Glacial Advance")) then
                if cast.glacialAdvance(nil,"rect",1,10) then return true end
            end
        -- Frost Strike
            -- frost_strike,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&runic_power.deficit<(15+talent.runic_attenuation.enabled*3)&!talent.frostscythe.enabled
            if cast.able.frostStrike() and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remain(units.dyn5) < 10) 
                and runicPowerDeficit < (15 + attenuation * 3) and not talent.frostscythe 
            then
                if cast.frostStrike() then return true end 
            end
            -- frost_strike,if=runic_power.deficit<(15+talent.runic_attenuation.enabled*3)
            if cast.able.frostStrike() and (runicPowerDeficit < (15 + attenuation * 3)) then
                if cast.frostStrike() then return true end
            end
        -- Remorseless Winter
            -- remorseless_winter
            if cast.able.remorselessWinter() and #enemies.yards8 >= getOptionValue("Remorseless Winter") then
                if cast.remorselessWinter() then return true end
            end
        -- Frostscythe
            -- frostscythe
            if cast.able.frostscythe() and enemies.yards8f > 0 then
                if cast.frostscythe() then return true end
            end
        -- Obliterate
            -- obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&runic_power.deficit>(25+talent.runic_attenuation.enabled*3)&!talent.frostscythe.enabled
            if cast.able.obliterate() and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remain(units.dyn5) < 10) 
                and runicPowerDeficit < (25 + attenuation * 3) and not talent.frostscythe 
            then
                if cast.obliterate() then return true end 
            end
            -- obliterate,if=runic_power.deficit>(25+talent.runic_attenuation.enabled*3)
            if cast.able.obliterate() and (runicPowerDeficit > (25 + attenuation * 3)) then
                if cast.obliterate() then return true end
            end
        -- Glacial Advance
            -- glacial_advance
            if cast.able.glacialAdvance() and enemies.yards20r >= getOptionValue("Glacial Advance") then
                if cast.glacialAdvance(nil,"rect",1,10) then return true end
            end
        -- Frost Strike
            -- frost_strike,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&!talent.frostscythe.enabled
            if cast.able.frostStrike() and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remain(units.dyn5) < 10) and not talent.frostscythe then
                if cast.frostStrike() then return true end 
            end
            -- frost_strike
            if cast.able.frostStrike() then
                if cast.frostStrike() then return true end
            end
        -- Horn of Winter
            -- horn_of_winter
            if cast.able.hornOfWinter() then
                if cast.hornOfWinter() then return true end
            end
        -- Racial: Arcane Torrent
            -- arcane_torrent
            if cast.able.racial() and (race == "BloodElf") then
                if cast.racial() then return true end
            end
        end -- End Action List - Aoe
    -- Action List - Standard
        local function actionList_Standard()
            profileDebug = "Standard"
        -- Remorseless Winter
            -- remorseless_winter
            if cast.able.remorselessWinter() and #enemies.yards8 >= getOptionValue("Remorseless Winter") then
                if cast.remorselessWinter() then return true end
            end
        -- Frost Strike
            -- frost_strike,if=cooldown.remorseless_winter.remains<=2*gcd&talent.gathering_storm.enabled
            if cast.able.frostStrike() and (cd.remorselessWinter.remain() <= 2 * gcdMax and talent.gatheringStorm) then
                if cast.frostStrike() then return true end
            end
        -- Howling Blast
            -- howling_blast,if=buff.rime.up
            if cast.able.howlingBlast() and (buff.rime.exists()) and #enemies.yards10t > 0 then
                if cast.howlingBlast() then return true end
            end
        -- Obliterate
            -- obliterate,if=!buff.frozen_pulse.up&talent.frozen_pulse.enabled
            if cast.able.obliterate() and (not buff.frozenPulse.exists() and talent.frozenPulse) then
                if cast.obliterate() then return true end
            end
        -- Frost Strike
            -- frost_strike,if=runic_power.deficit<(15+talent.runic_attenuation.enabled*3)
            if cast.able.frostStrike() and (runicPowerDeficit < (15 + attenuation * 3)) then
                if cast.frostStrike() then return true end
            end
        -- Frostscythe
            -- frostscythe,if=buff.killing_machine.up&rune.time_to_4>=gcd
            if cast.able.frostscythe() and (buff.killingMachine.exists() and runesTTM(4) >= gcdMax) and enemies.yards8f > 0 then
                if cast.frostscythe() then return true end
            end
        -- Obliterate
            -- obliterate,if=runic_power.deficit>(25+talent.runic_attenuation.enabled*3)
            if cast.able.obliterate() and (runicPowerDeficit > (25 + attenuation * 3)) then
                if cast.obliterate() then return true end
            end
        -- Frost Strike
            -- frost_strike
            if cast.able.frostStrike() then
                if cast.frostStrike() then return true end
            end
        -- Horn of Winter
            -- horn_of_winter
            if cast.able.hornOfWinter() then
                if cast.hornOfWinter() then return true end
            end
        -- Racial: Arcane Torrent
            -- arcane_torrent
            if cast.able.racial() and (race == "BloodElf") then
                if cast.racial() then return true end
            end
        end -- End Action List - Standard
    -- Action List - Pre-Combat
        local function actionList_PreCombat()
            profileDebug = "Pre-Combat"
        -- Flask / Crystal
            -- flask,type=flask_of_the_countless_armies
            if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheCountlessArmies.exists() then
                if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                if buff.felFocus.exists() then buff.felFocus.cancel() end
                if use.flaskOfTheCountlessArmies() then return true end
            end
            if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() then
                if buff.flaskOfTheCountlessArmies.exists() then buff.flaskOfTheCountlessArmies.cancel() end
                if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                if use.repurposedFelFocuser() then return true end
            end
            if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() then
                if buff.flaskOfTheCountlessArmies.exists() then buff.flaskOfTheCountlessArmies.cancel() end
                if buff.felFocus.exists() then buff.felFocus.cancel() end
                if use.oraliusWhisperingCrystal() then return true end
            end
        -- Flask / Crystal
            -- flask,name=countless_armies
            if isChecked("Flask / Crystal") and not (IsFlying() or IsMounted()) then
                if (raid or solo) and not (buff.strenthFlaskLow or buff.strengthFlaskBig) then--Draenor Str Flasks
                    if not UnitBuffID("player",176151) and canUseItem(118922) then --Draenor Insanity Crystal
                        if br.player.useCrystal() then return true end
                    end
                end
            end
        -- Food
            -- food,type=food,name=fishbrul_special
        -- Augmentation
            -- augmentation,name=defiled
        -- Potion
            -- potion,name=old_war
        -- Pre-pull
            if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

            end -- Pre-Pull
            if isValidUnit("target") and not inCombat then
        -- -- Howling Blast
        --         if cast.able.howlingBlast("target") then
        --             if cast.howlingBlast("target") then return true end
        --         end
        -- -- Death Grip
        --         if isChecked("Death Grip - Pre-Combat") and cast.able.deathGrip("target") then --and not cast.able.howlingBlast("target") then
        --             if cast.deathGrip("target") then return true end
        --         end
        -- -- Dark Command
        --         if isChecked("Dark Command") and cast.able.darkCommand("target") and not (isChecked("Death Grip") or cast.able.deathGrip("target")) then -- and not cast.able.howlingBlast("target") then
        --             if cast.darkCommand("target") then return true end
        --         end
        -- Start Attack
                StartAttack()
            end
        end -- End Action List - PreCombat
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or IsFlying() or IsMounted() or pause() or mode.rotation==4 then
            return true
        else
-----------------------
--- Extras Rotation ---
-----------------------
            if actionList_Extras() then return true end
--------------------------
--- Defensive Rotation ---
--------------------------
            if actionList_Defensive() then return true end
------------------------------
--- Out of Combat Rotation ---
------------------------------
            if actionList_PreCombat() then return true end
--------------------------
--- In Combat Rotation ---
--------------------------
        -- Combat Start
            if inCombat and profileStop==false and isValidUnit(units.dyn5) then
                profileDebug = "Combat Rotation"
                -- auto_attack
                if getDistance(units.dyn5) < 5 then
                    StartAttack()
                end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return true end
    -----------------------------
    --- In Combat - Cooldowns ---
    -----------------------------
                if actionList_Cooldowns() then return true end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                if getOptionValue("APL Mode") == 1 then
                    if not breathOfSindragosaActive then
        -- Howling Blast
                        -- howling_blast,if=!dot.frost_fever.ticking&(!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>15)
                        if cast.able.howlingBlast() and (not debuff.frostFever.exists() and (not talent.breathOfSindragosa or cd.breathOfSindragosa.remain() > 15)) and #enemies.yards10t > 0 then
                            if cast.howlingBlast() then return true end
                        end
        -- Glacial Advance
                        -- glacial_advance,if=buff.icy_talons.remains<=gcd&buff.icy_talons.up&spell_targets.glacial_advance>=2&(!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>15)
                        if cast.able.glacialAdvance() and (buff.icyTalons.remain() <= gcdMax and buff.icyTalons.exists()
                            and ((mode.rotation == 1 and enemies.yards20r >= getOptionValue("Glacial Advance")) or (mode.rotation == 2 and enemies.yards20r > 0))
                            and (not talent.breathOfSindragosa or cd.breathOfSindragosa.remain() > 15))
                        then
                            if cast.glacialAdvance(nil,"rect",1,10) then return true end
                        end
        -- Frost Strike
                        -- frost_strike,if=buff.icy_talons.remains<=gcd&buff.icy_talons.up&(!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>15)
                        if cast.able.frostStrike() and (buff.icyTalons.remain() <= gcdMax and buff.icyTalons.exists() and (not talent.breathOfSindragosa or cd.breathOfSindragosa.remain() > 15)) then
                            if cast.frostStrike() then return true end
                        end
                    end
        -- Action List - Essences
                    -- call_action_list,name=essences
                    if isChecked("Use Essence") then 
                        if actionList_Essences() then return true end
                    end
        -- Action List - Cooldowns
                    -- call_action_list,name=cooldowns
                    if actionList_Cooldowns() then return true end
        -- Action List - BoS Pooling
                    -- run_action_list,name=bos_pooling,if=talent.breath_of_sindragosa.enabled&((cooldown.breath_of_sindragosa.remains=0&cooldown.pillar_of_frost.remains<10)|(cooldown.breath_of_sindragosa.remains<20&target.1.time_to_die<35))
                    if isChecked("Breath of Sindragosa") and useCDs() and not breathOfSindragosaActive
                        and talent.breathOfSindragosa and ((cd.breathOfSindragosa.remain() == 0 and cd.pillarOfFrost.remain() < 10) 
                            or (cd.breathOfSindragosa.remain() < 20 and ttd(units.dyn5) < 35))
                    then
                        if actionList_BoSPooling() then return true end
                    end 
        -- Action List - BoS Ticking
                    -- run_action_list,name=bos_ticking,if=buff.breath_of_sindragosa.up
                    if breathOfSindragosaActive then
                        if actionList_BoSTicking() then return true end
                    end
                    if not breathOfSindragosaActive and (not isChecked("Breath of Sindragosa") 
                        or (isChecked("Breath of Sindragosa") and not useCDs()) or not talent.breathOfSindragosa or cd.breathOfSindragosa.remain() >= 5) 
                    then
        -- Action List - Obliteration
                        -- run_action_list,name=obliteration,if=buff.pillar_of_frost.up&talent.obliteration.enabled
                        if buff.pillarOfFrost.exists() and talent.obliteration then
                            if actionList_Obliteration() then return true end
                        end
        -- Action List - AoE
                        -- run_action_list,name=aoe,if=active_enemies>=2
                        if #enemies.yards8 >= 2 then
                            if actionList_Aoe() then return true end
                        end
        -- Action List - Standard
                        -- call_action_list,name=standard
                        if actionList_Standard() then return true end
                    end
                end -- End Simc APL
            end -- End Combat Check
        end -- End Rotation Pause
end -- runRotation
local id = 251
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

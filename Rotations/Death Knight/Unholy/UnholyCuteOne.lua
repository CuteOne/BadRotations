local rotationName = "CuteOne"
local br = br
---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    local spell = br.player.spell
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of enemies in range.", highlight = 1, icon = spell.scourgeStrike },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = spell.scourgeStrike },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = spell.deathAndDecay },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = spell.deathCoil }
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = spell.armyOfTheDead },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = spell.armyOfTheDead },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = spell.armyOfTheDead }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = spell.iceboundFortitude },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = spell.iceboundFortitude }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = spell.mindFreeze }
    };
    CreateButton("Interrupt",4,0)
-- Death And Decay Button
    DndModes = {
        [1] = { mode = "On", value = 1 , overlay = "DnD Enabled", tip = "Will use DnD.", highlight = 1, icon = spell.deathAndDecay },
        [2] = { mode = "Off", value = 2 , overlay = "DnD Disabled", tip = "will NOT use DnD.", highlight = 0, icon = spell.deathAndDecay }
    };
    CreateButton("Dnd",5,0)

end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable
    local section
    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Chains of Ice
            br.ui:createCheckbox(section, "Chains of Ice")
            -- Control Undead
            br.ui:createCheckbox(section, "Control Undead")
            -- Dark Command
            br.ui:createCheckbox(section, "Dark Command","|cffFFFFFFWill taunt selected target to begin combat.")
            -- Death Grip
            br.ui:createCheckbox(section, "Death Grip","|cffFFFFFFWill grip units out that are >8yrds away from you while in combat.")
            br.ui:createCheckbox(section, "Death Grip - Pre-Combat","|cffFFFFFFWill grip selected target to begin combat.")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Path of Frost
            br.ui:createCheckbox(section, "Path of Frost")
            -- Heart Essence
            br.ui:createCheckbox(section, "Use Essence")
        br.ui:checkSectionState(section)
        -------------------
        --- PET OPTIONS ---
        -------------------
        section = br.ui:createSection(br.ui.window.profile, "Pet Management")
            -- Raise Dead
            br.ui:createCheckbox(section, "Raise Dead")
            -- Pet Target
            br.ui:createDropdownWithout(section, "Pet Target", {"Dynamic Unit", "Only Target", "Any Unit"},1,"Select how you want pet to acquire targets.")
            -- Auto Attack/Passive
            br.ui:createCheckbox(section, "Auto Attack/Passive")
            -- Claw
            br.ui:createCheckbox(section, "Claw")
            -- Gnaw
            br.ui:createCheckbox(section, "Gnaw")
            -- Huddle
            br.ui:createSpinner(section, "Huddle", 30, 0, 100, 5, "|cffFFFFFFPet Health Percent to Cast At")
            -- Leap
            br.ui:createCheckbox(section, "Leap")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Cooldowns Time To Die Limit
            br.ui:createSpinnerWithout(section,  "Cooldowns Time To Die Limit",  30,  0,  40,  1,  "|cffFFFFFFTarget Time to die limit for using cooldowns (in sec).")        
            -- Augment Rune
            br.ui:createCheckbox(section, "Augment Rune")
            -- Potion
            br.ui:createCheckbox(section, "Potion")
            -- Elixir
            br.ui:createDropdownWithout(section, "Elixir", {"Flask of the Undertow","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
            -- Racial
            br.ui:createCheckbox(section, "Racial")
            -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use trinkets.")
            -- Ashvane's Razor Coral Stacks
            br.ui:createSpinnerWithout(section, "Ashvane's Razor Coral Stacks", 1, 1, 30, 1, "|cffFFBB00 Number of debuff stacks to cast trinket (Default=1 'SimC').")
            -- Azerite Beam Units
            br.ui:createSpinnerWithout(section, "Azerite Beam Units", 3, 1, 10, 1, "|cffFFBB00Number of Targets to use Azerite Beam on.")
            -- Apocalypse
            br.ui:createDropdownWithout(section, "Apocalypse", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Apocalypse.")
            -- Army of the Dead
            br.ui:createDropdownWithout(section, "Army of the Dead", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Army of the Dead.")
            -- Dark Transformation
            br.ui:createDropdownWithout(section, "Dark Transformation", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Dark Transformation.")
            -- Soul Reaper
            br.ui:createDropdownWithout(section, "Soul Reaper", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Soul Reaper.")
            -- Summon Gargoyle
            br.ui:createCheckbox(section, "Summon Gargoyle")
            -- Unholy BLight
            br.ui:createDropdownWithout(section, "Unholy Blight", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Unholy Blight.")
            -- Unholy Frenzy
            br.ui:createDropdownWithout(section, "Unholy Frenzy", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Unholy Frenzy.")
            br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to use at.")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to use at.")
            -- Anti-Magic Shell
            br.ui:createSpinner(section, "Anti-Magic Shell", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Death Strike
            br.ui:createSpinner(section, "Death Strike", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Death Pact
            br.ui:createSpinner(section, "Death Pact", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Icebound Fortitude
            br.ui:createSpinner(section, "Icebound Fortitude", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Raise Ally
            br.ui:createDropdown(section, "Raise Ally", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Mind Freeze
            br.ui:createCheckbox(section, "Mind Freeze")
            -- Death Grip
            br.ui:createCheckbox(section, "Death Grip (Interrupt)")
            -- Asphyxiate
            br.ui:createCheckbox(section, "Asphyxiate")
            -- Asphyxiate Logic
            br.ui:createCheckbox(section, "Asphyxiate Logic")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At (0 is random)")
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
--------------
--- Locals ---
--------------
    -- BR Player API
    local buff                                          = br.player.buff
    local cast                                          = br.player.cast
    local cd                                            = br.player.cd
    local debuff                                        = br.player.debuff
    local enemies                                       = br.player.enemies
    local equiped                                       = br.player.equiped
    local essence                                       = br.player.essence
    local gcd                                           = br.player.gcdMax
    local inCombat                                      = br.player.inCombat
    local inRaid                                        = br.player.instance=="raid"
    local mode                                          = br.player.mode
    local pet                                           = br.player.pet
    local runes                                         = br.player.power.runes.amount()
    local runeDeficit                                   = br.player.power.runes.deficit()
    local runesTTM                                      = br.player.power.runes.ttm
    local runicPower                                    = br.player.power.runicPower.amount()
    local runicPowerDeficit                             = br.player.power.runicPower.deficit()
    local talent                                        = br.player.talent
    local trait                                         = br.player.traits
    local units                                         = br.player.units
    local use                                           = br.player.use
    -- Other Locals
    local apocBypass
    local combatTime                                    = getCombatTime()
    local level                                         = UnitLevel("player")
    local petCombat                                     = UnitAffectingCombat("pet")
    local php                                           = getHP("player")
    local ttd                                           = getTTD
    local pullTimer                                     = PullTimerRemain()
    local thisUnit                                      = nil

    -- Units Declaration
    units.get(5)
    units.get(30)
    units.get(30,true)
    units.get(40)
    -- Enemies Declaration
    enemies.get(5)
    enemies.get(8)
    enemies.get(8,"target")
    enemies.get(8,"player",false,true) -- makes enemies.yards8f
    enemies.get(15)
    enemies.get(20)
    enemies.get(30)
    enemies.get(40)
    enemies.get(45)
    enemies.get(40,"player",true)
    enemies.yards8r = getEnemiesInRect(10,20,false) or 0

    -- Nil Checks
    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end

    -- Numeric Returns
    if buff.unholyFrenzy.exists() then frenzied = 1 else frenzied = 0 end

    -- Variables
    -- variable,name=pooling_for_gargoyle,value=cooldown.summon_gargoyle.remains<5&talent.summon_gargoyle.enabled
    poolForGargoyle = cd.summonGargoyle.remain() < 5 and talent.summonGargoyle
    deathAndDecayRemain = 0
    if (cd.deathAndDecay.remain() - 10) > 0 then deathAndDecayRemain = (cd.deathAndDecay.remain() - 10) end
    apocBypass = getOptionValue("Apocalypse") == 3 or (getOptionValue("Apocalypse") == 2 and not useCDs()) or level < 75

    --Asphyxiate Logic
    local Asphyxiate_unitList = {
        [131009] = "Spirit of Gold",
        [134388] = "A Knot of Snakes",
        [129758] = "Irontide Grenadier"
    }
--------------------
--- Action Lists ---
--------------------
    local function actionList_PetManagement()
        local function getCurrentPetMode()
            local petMode = "None"
            for i = 1, NUM_PET_ACTION_SLOTS do
                local name, _, _,isActive = GetPetActionInfo(i)
                if isActive then
                    if name == "PET_MODE_ASSIST" then petMode = "Assist" end
                    if name == "PET_MODE_DEFENSIVE" then petMode = "Defensive" end
                    if name == "PET_MODE_PASSIVE" then petMode = "Passive" end
                end
            end
            return petMode
        end

        local friendUnit = br.friend[1].unit
        local petActive = IsPetActive()
        local petCombat = UnitAffectingCombat("pet")
        local petDead = UnitIsDeadOrGhost("pet")
        local petDistance = getDistance("pettarget","pet") or 99
        local petExists = UnitExists("pet")
        local petMode = getCurrentPetMode()
        local validTarget = UnitExists("pettarget") or (not UnitExists("pettarget") and isValidUnit("target")) or isDummy()
        if petExists and petActive and deadPet then deadPet = false end
        if waitForPetToAppear == nil or IsMounted() or IsFlying() or UnitHasVehicleUI("player") or CanExitVehicle("player") then
            waitForPetToAppear = GetTime()
        elseif isChecked("Raise Dead") then
            if waitForPetToAppear ~= nil and GetTime() - waitForPetToAppear > 2 then
                if cast.able.raiseDead() and (deadPet or (not deadPet and not (petActive or petExists))
                    or (talent.allWillServe and not pet.risenSkulker.exists()))
                then
                    if cast.raiseDead() then waitForPetToAppear = GetTime(); return end
                end
            end
        end
        if isChecked("Auto Attack/Passive") then
            -- Set Pet Mode Out of Comat / Set Mode Passive In Combat
            if (not inCombat and petMode == "Passive") or (inCombat and (petMode == "Defensive" or petMode == "Passive")) then
                PetAssistMode()
            elseif not inCombat and petMode == "Assist" and #enemies.yards40nc > 0 then
                PetDefensiveMode()
            elseif inCombat and petMode ~= "Passive" and #enemies.yards40 == 0 then
                PetPassiveMode()
            end
            -- Pet Attack / retreat
            if (not UnitExists("pettarget") or not validTarget) and (inCombat or petCombat) then
                if getOptionValue("Pet Target") == 1 and isValidUnit(units.dyn40) then
                    PetAttack(units.dyn40)
                elseif getOptionValue("Pet Target") == 2 and validTarget then
                    PetAttack("target")
                elseif getOptionValue("Pet Target") == 3 then
                    for i=1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if (isValidUnit(thisUnit) or isDummy()) then PetAttack(thisUnit); break end
                    end
                end
            elseif (not inCombat or (inCombat and not validTarget and not isValidUnit("target") and not isDummy())) and IsPetAttackActive() then
                PetStopAttack()
                PetFollow()
            end
        end
        -- Huddle
        if isChecked("Huddle") and cast.able.huddle() and (inCombat or petCombat) and getHP("pet") <= getOptionValue("Huddle") then
            if cast.huddle() then return end
        end
        -- Claw
        if isChecked("Claw") and cast.able.claw("pettarget") and not buff.huddle.exists("pet") and validTarget and getDistance("pettarget","pet") < 5 then
            if cast.claw("pettarget") then return end
        end
        -- Gnaw
        if isChecked("Gnaw") and cast.able.gnaw() and not buff.huddle.exists("pet") then
            for i=1, #enemies.yards5 do
                thisUnit = enemies.yards5[i]
                if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                    if cast.gnaw(thisUnit) then return true end
                end
            end
        end
        -- Leap
        if isChecked("Leap") and cast.able.leap("pettarget") and not buff.huddle.exists("pet") and validTarget and getDistance("pettarget","pet") > 8 then
            if cast.leap("pettarget") then return end
        end
    end
    local function actionList_Extras()
    -- Dummy Test
        if isChecked("DPS Testing") then
            if GetObjectExists("target") then
                if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                    StopAttack()
                    ClearTarget()
                    Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                    profileStop = true
                end
            end
        end -- End Dummy Test
    -- Chains of Ice
        if isChecked("Chains of Ice") and cast.able.chainsOfIce() then
            for i = 1, #enemies.yards30 do
                thisUnit = enemies.yards30[i]
                if not debuff.chainsOfIce.exists(thisUnit) and not getFacing(thisUnit,"player") and getFacing("player",thisUnit)
                    and isMoving(thisUnit) and getDistance(thisUnit) > 8 and inCombat
                then
                    if cast.chainsOfIce(thisUnit) then return end
                end
            end
        end
    -- Control Undead
        if isChecked("Control Undead") and cast.able.controlUndead() then
            for i = 1, #enemies.yards30 do
                thisUnit = enemies.yards30[i]
                if isUndead(thisUnit) and not isDummy(thisUnit) and not isBoss(thisUnit) and UnitLevel(thisUnit) <= level + 1 then
                    if cast.controlUndead(thisUnit) then return end
                end
            end
        end
    -- Death Grip
        if isChecked("Death Grip") and cast.able.deathGrip() then
            thisUnit = talent.deathsReach and units.dyn40 or units.dyn30
            if inCombat and getDistance(thisUnit) > 8 and ((talent.deathsReach and getDistance(thisUnit) < 40) or getDistance(thisUnit) < 30) and not isDummy(thisUnit) then
                if cast.deathGrip() then return end
            end
        end
    -- Path of Frost
        if isChecked("Path of Frost") and cast.able.pathOfFrost() then
            if not inCombat and swimming and not buff.pathOfFrost.exists() then
                if cast.pathOfFrost() then return end
            end
        end
    end -- End Action List - Extras
    local function actionList_Defensive()
        -- Anti-Magic Shell
        if isChecked("Anti-Magic Shell") and cast.able.antiMagicShell() and php < getOptionValue("Anti-Magic Shell") then
            if cast.antiMagicShell() then return end
        end
        -- Death Strike
        if isChecked("Death Strike") and cast.able.deathStrike() and (php < getOptionValue("Death Strike") or buff.darkSuccor.exists()) then
            if cast.deathStrike() then return end
        end
        -- Death Pact
        if isChecked("Death Pact") and cast.able.deathPact() and php < getOptionValue("Death Pact") then
            if cast.deathPact() then return end
        end
        -- Icebound Fortitude
        if isChecked("Icebound Fortitude") and cast.able.iceboundFortitude() and php < getOptionValue("Icebound Fortitude") then
            if cast.iceboundFortitude() then return end
        end
        -- Raise Ally
        if isChecked("Raise Ally") then
            if getOptionValue("Raise Ally")==1 and cast.able.raiseAlly("target","dead")
                and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player")
            then
                if cast.raiseAlly("target","dead") then return true end
            end
            if getOptionValue("Raise Ally")==2 and cast.able.raiseAlly("mouseover","dead")
                and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player")
            then
                if cast.raiseAlly("mouseover","dead") then return true end
            end
        end
    end -- End Action List - Defensive
    local function actionList_Interrupts()
        if useInterrupts() then
        -- Mind Freeze
            if isChecked("Mind Freeze") and cast.able.mindFreeze() then
                for i=1, #enemies.yards15 do
                    thisUnit = enemies.yards15[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                        if cast.mindFreeze(thisUnit) then return true end
                    end
                end
            end
        --Asphyxiate
            if isChecked("Asphyxiate") and cast.able.asphyxiate() and cd.mindFreeze.remain() > gcd then
                for i=1, #enemies.yards20 do
                    thisUnit = enemies.yards20[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                        if cast.asphyxiate(thisUnit) then return true end
                    end
                end
            end
        --Death Grip
            if isChecked("Death Grip (Interrupt)") and cast.able.deathGrip() and getDistance(thisUnit) > 8 and ((talent.deathsReach and getDistance(thisUnit) < 40) or getDistance(thisUnit) < 30) then
                if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                    if cast.deathGrip() then return true end
                end
            end
        --Asphyxiate Logic
            if isChecked("Asphyxiate Logic") then
                if cast.able.asphyxiate() then
                    local Asphyxiate_list = {
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
                        for k, v in pairs(Asphyxiate_list) do
                            if (Asphyxiate_unitList[GetObjectID(thisUnit)] ~= nil or UnitCastingInfo(thisUnit) == GetSpellInfo(v) or UnitChannelInfo(thisUnit) == GetSpellInfo(v)) and getBuffRemain(thisUnit, 226510) == 0 and distance <= 20 then
                                if cast.asphyxiate() then
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
    end-- End Action List - Interrupts
    local function actionList_Cooldowns()
        local groupTTD = 0
        for i = 1, #enemies.yards45 do
            thisUnit = enemies.yards45[i]
            groupTTD = groupTTD + ttd(thisUnit)
        end
    -- Army of the Dead
        -- army_of_the_dead
        if (getOptionValue("Army of the Dead") == 1 or (getOptionValue("Army of the Dead") == 2 and useCDs())) and groupTTD >= getOptionValue("CDs TTD Limit") 
        and cast.able.armyOfTheDead() 
        then
            if cast.armyOfTheDead() then return end
        end
    -- Apocalypse
        -- apocalypse,if=debuff.festering_wound.stack>=4
        if (getOptionValue("Apocalypse") == 1 or (getOptionValue("Apocalypse") == 2 and useCDs()))
            and cast.able.apocalypse() and debuff.festeringWound.stack(units.dyn5) >= 4 and groupTTD >= getOptionValue("CDs TTD Limit") 
        then
            if cast.apocalypse(units.dyn5) then return end
        end
    -- Dark Transformation
        -- dark_transformation
        if pet.active.exists() and cast.able.darkTransformation()
            and (getOptionValue("Dark Transformation") == 1 or (getOptionValue("Dark Transformation") == 2 and useCDs())) and groupTTD >= getOptionValue("CDs TTD Limit")
        then
            if cast.darkTransformation() then return end
        end
    -- Summon Gargoyle
        -- summon_gargoyle,if=runic_power.deficit<14
        if isChecked("Summon Gargoyle") and cast.able.summonGargoyle() and runicPowerDeficit < 14 and groupTTD >= getOptionValue("CDs TTD Limit") then
            if cast.summonGargoyle() then return end
        end
    -- Unholy Frenzy
        if (getOptionValue("Unholy Frenzy") == 1 or (getOptionValue("Unholy Frenzy") == 2 and useCDs())) and cast.able.unholyFrenzy() and groupTTD >= getOptionValue("CDs TTD Limit")
        then
            -- unholy_frenzy,if=debuff.festering_wound.stack<4
            if debuff.festeringWound.stack(units.dyn5) < 4 and groupTTD >= getOptionValue("CDs TTD Limit") then
                if cast.unholyFrenzy() then return end
            end
            -- unholy_frenzy,if=essence.vision_of_perfection.enabled|(essence.condensed_lifeforce.enabled&pet.apoc_ghoul.active)|debuff.festering_wound.stack<4&!(equipped.ramping_amplitude_gigavolt_engine|azerite.magus_of_the_dead.enabled)|cooldown.apocalypse.remains<2&(equipped.ramping_amplitude_gigavolt_engine|azerite.magus_of_the_dead.enabled)
            if essence.visionOfPerfection.active or (essence.condensedLifeForce.active and pet.apocalypseGhoul.exists()) or debuff.festeringWound.stack(units.dyn5) < 4
                and not (equiped.rampingAmplitudeGigavoltEngine() or trait.magusOfTheDead.active) or cd.apocalypse.remain() < 2
                and (equiped.rampingAmplitudeGigavoltEngine or trait.magusOfTheDead.active) and groupTTD >= getOptionValue("CDs TTD Limit")
            then
                if cast.unholyFrenzy() then return end
            end
            -- unholy_frenzy,if=active_enemies>=2&((cooldown.death_and_decay.remains<=gcd&!talent.defile.enabled)|(cooldown.defile.remains<=gcd&talent.defile.enabled))
            if ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0))
                and ((cd.deathAndDecay.remain() <= gcd and not talent.defile) or (cd.defile.remain() <= gcd and talent.defile)) and groupTTD >= getOptionValue("CDs TTD Limit")
            then
                if cast.unholyFrenzy() then return end
            end
        end
    -- Soul Reaper
        if (getOptionValue("Soul Reaper") == 1 or (getOptionValue("Soul Reaper") == 2 and useCDs())) and cast.able.soulReaper() then
            -- soul_reaper,target_if=target.time_to_die<8&target.time_to_die>4
            if ttd(units.dyn5) < 8 and ttd(units.dyn5) > 4 then
                if cast.soulReaper() then return end
            end
            -- soul_reaper,if=(!raid_event.adds.exists|raid_event.adds.in>20)&rune<=(1-buff.unholy_frenzy.up)
            if ((mode.rotation == 1 and #enemies.yards8 == 1) or (mode.rotation == 3 and #enemies.yards8 > 0) or isDummy()) and runes <= (1- frenzied) and groupTTD >= getOptionValue("CDs TTD Limit") 
            then
                if cast.soulReaper() then return end
            end
        end
    -- Unholy Blight
        -- unholu_blight
        if (getOptionValue("Unholy Frenzy") == 1 or (getOptionValue("Unholy Frenzy") == 2 and useCDs())) and cast.able.unholyBlight("player","aoe",1,10) and groupTTD >= getOptionValue("CDs TTD Limit") then
            if cast.unholyBlight("player","aoe",1,10) then return end
        end
    end -- End Action List - Cooldowns
    local function actionList_Essences()
        if isChecked("Use Essence") then
            -- Memory of Lucid Dreams
            -- memory_of_lucid_dreams,if=rune.time_to_1>gcd&runic_power<40
            if useCDs() and cast.able.memoryOfLucidDreams() and runesTTM(1) > gcd and runicPower < 40 then
                if cast.memoryOfLucidDreams() then return end
            end
            -- blood_of_the_enemy,if=(cooldown.death_and_decay.remains&spell_targets.death_and_decay>1)|(cooldown.defile.remains&spell_targets.defile>1)|(cooldown.apocalypse.remains&active_enemies=1)
            if useCDs() and cast.able.bloodOfTheEnemy() and ((cd.deathAndDecay.remain() > 0 and #enemies.yards8t > 1)
                or (cd.defile.remain() > 0 and #enemies.yards8t > 1) or ((cd.apocalypse.remain() > 0 or apocBypass) and #enemies.yards5 == 1))
            then
                if cast.bloodOfTheEnemy() then return end
            end
            -- guardian_of_azeroth,if=cooldown.apocalypse.ready
            if useCDs() and cast.able.guardianOfAzeroth() and cd.apocalypse.remain() == 0 then
                if cast.guardianOfAzeroth() then return end
            end
            -- the_unbound_force,if=buff.reckless_force.up|buff.reckless_force_counter.stack<11
            if cast.able.theUnboundForce() and (buff.recklessForce.exists() or buff.recklessForceCounter.stack() < 11) then
                if cast.theUnboundForce() then return end
            end
            -- focused_azerite_beam,if=!death_and_decay.ticking
            if cast.able.focusedAzeriteBeam() and (#enemies.yards8f >= getOptionValue("Azerite Beam Units") or (useCDs() and #enemies.yards8f > 0)) and deathAndDecayRemain == 0  then
                local minCount = useCDs() and 1 or getOptionValue("Azerite Beam Units")
                if cast.focusedAzeriteBeam(nil,"cone",minCount, 8) then
                    return true
                end
            end
            -- concentrated_flame,if=dot.concentrated_flame_burn.remains=0
            if cast.able.concentratedFlame() and not debuff.concentratedFlame.exists(units.dyn5) then
                if cast.concentratedFlame() then return end
            end
            -- purifying_blast,if=!death_and_decay.ticking
            if useCDs() and cast.able.purifyingBlast() and deathAndDecayRemain == 0 then
                if cast.purifyingBlast("best", nil, 1, 8) then return true end
            end
            -- worldvein_resonance,if=talent.army_of_the_damned.enabled&essence.vision_of_perfection.minor&buff.unholy_strength.up|essence.vision_of_perfection.minor&pet.apoc_ghoul.active|talent.army_of_the_damned.enabled&pet.apoc_ghoul.active&cooldown.army_of_the_dead.remains>60|talent.army_of_the_damned.enabled&pet.army_ghoul.active
            if cast.able.worldveinResonance() and talent.armyOfTheDamned and essence.visionOfPerfection.minor
                and buff.unholyStrength.exists() or essence.visionOfPerfection.minor and pet.apocalypseGhoul.active()
                or talent.armyOfTheDamned and pet.apocalypseGhoul.active() and cd.armyOfTheDead.remain() > 60
                or talent.armyOfTheDamned and pet.armyOfTheDead.active()
            then
                if cast.worldveinResonance() then return end
            end
            -- worldvein_resonance,if=!death_and_decay.ticking&buff.unholy_strength.up&!essence.vision_of_perfection.minor&!talent.army_of_the_damned.enabled|target.time_to_die<cooldown.apocalypse.remains
            if cast.able.worldveinResonance() and deathAndDecayRemain == 0 and buff.unholyStrength.exists()
                and not essence.visionOfPerfection.minor and not talent.armyOfTheDamned
                or ttd(units.dyn5) < cd.apocalypse.remain() or apocBypass
            then
                if cast.worldveinResonance() then return end
            end
            -- ripple_in_space,if=!death_and_decay.ticking
            if useCDs() and cast.able.rippleInSpace() and deathAndDecayRemain == 0 then
                if cast.rippleInSpace() then return end
            end
            -- reaping_flames
            if cast.able.reapingFlames() then
                if cast.reapingFlames() then return end
            end
        end
    end
    local function actionList_AOE()
    -- Death and Decay
        -- death_and_decay,if=cooldown.apocalypse.remains
        if mode.dnd == 1 and cast.able.deathAndDecay() and not talent.defile
            and (cd.apocalypse.remain() > 0 or apocBypass)
        then
            if cast.deathAndDecay("best",nil,1,8) then return end
        end
    -- Defile
        -- defile
        if mode.dnd == 1 and cast.able.defile() then
            if cast.defile("best",nil,1,8) then return end
        end
    -- Epidemic
        -- epidemic,if=death_and_decay.ticking&rune<2&!variable.pooling_for_gargoyle
        if cast.able.epidemic() and (deathAndDecayRemain > 0 or not cast.able.deathAndDecay()) and runes < 2 and not poolForGargoyle then
            if cast.epidemic() then return end
        end
    -- Death Coil
        -- death_coil,if=death_and_decay.ticking&rune<2&!variable.pooling_for_gargoyle
        if cast.able.deathCoil() and (deathAndDecayRemain > 0 or not cast.able.deathAndDecay()) and runes < 2 and not poolForGargoyle then
            if cast.deathCoil() then return end
        end
    -- Scourge Strike
        -- scourge_strike,if=death_and_decay.ticking&cooldown.apocalypse.remains
        if cast.able.scourgeStrike() and not talent.clawingShadows and deathAndDecayRemain > 0
            and (cd.apocalypse.remain() > 0 or apocBypass)
            and debuff.festeringWound.stack(units.dyn5) > 0
        then
            if cast.scourgeStrike() then return end
        end
    -- Clawing Shadows
        -- clawing_shadows,if=death_and_decay.ticking&cooldown.apocalypse.remains
        if cast.able.clawingShadows() and deathAndDecayRemain > 0
            and (cd.apocalypse.remain() > 0 or apocBypass)
        then
            if cast.clawingShadows() then return end
        end
    -- Epidemic
        -- epidemic,if=!variable.pooling_for_gargoyle
        if cast.able.epidemic() and not poolForGargoyle then
            if cast.epidemic() then return end
        end
    -- Festering Strike
        -- festering_strike,target_if=debuff.festering_wound.stack<=1&cooldown.death_and_decay.remains
        if cast.able.festeringStrike() and (cd.deathAndDecay.remain() > 0 or level < 56) then
            for i = 1, #enemies.yards5 do
                thisUnit = enemies.yards5[i]
                if debuff.festeringWound.stack(thisUnit) <= 1 then
                    if cast.festeringStrike(thisUnit) then return end
                end
            end
        end
        -- festering_strike,if=talent.bursting_sores.enabled&spell_targets.bursting_sores>=2&debuff.festering_wound.stack<=1
        if cast.able.festeringStrike() and talent.burstingSores and debuff.festeringWound.stack(units.dyn5) <= 1
            and ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0))
        then
            if cast.festeringStrike(units.dyn5) then return end
        end
    -- Death Coil
        -- death_coil,if=buff.sudden_doom.react&rune.deficit>=4
        if cast.able.deathCoil() and buff.suddenDoom.exists() and runeDeficit >= 4 then
            if cast.deathCoil() then return end
        end
        -- death_coil,if=buff.sudden_doom.react&!variable.pooling_for_gargoyle|pet.gargoyle.exists
        if cast.able.deathCoil() and buff.suddenDoom.exists() and (not poolForGargoyle or pet.gargoyle.exists()) then
            if cast.deathCoil() then return end
        end
        -- death_coil,if=runic_power.deficit<14&(cooldown.apocalypse.remains>5|debuff.festering_wound.stack>4)&!variable.pooling_for_gargoyle
        if cast.able.deathCoil() and runicPowerDeficit < 14 and not poolForGargoyle
            and (cd.apocalypse.remain() > 5 or apocBypass or debuff.festeringWound.stack(units.dyn5) > 4)
        then
            if cast.deathCoil() then return end
        end
    -- Scourge Strike
        -- scourge_strike,if=((debuff.festering_wound.up&cooldown.apocalypse.remains>5)|debuff.festering_wound.stack>4)&(cooldown.army_of_the_dead.remains>5|death_knight.disable_aotd)
        if cast.able.scourgeStrike() and not talent.clawingShadows
            and ((debuff.festeringWound.exists(units.dyn5) and (cd.apocalypse.remain() > 5 or apocBypass)) or debuff.festeringWound.stack(units.dyn5) > 4)
            and (cd.armyOfTheDead.remain() > 5 or not isChecked("Army of the Dead") or not useCDs() or level < 82)
        then
            if cast.scourgeStrike() then return end
        end
    -- Clawing Shadows
        -- clawing_shadows,if=((debuff.festering_wound.up&cooldown.apocalypse.remains>5)|debuff.festering_wound.stack>4)&(cooldown.army_of_the_dead.remains>5|death_knight.disable_aotd)
        if cast.able.clawingShadows() and talent.clawingShadows
            and ((debuff.festeringWound.exists(units.dyn5) and (cd.apocalypse.remain() > 5 or apocBypass)) or debuff.festeringWound.stack(units.dyn5) > 4)
            and (cd.armyOfTheDead.remain() > 5 or not isChecked("Army of the Dead") or not useCDs() or level < 82)
        then
            if cast.clawingShadows() then return end
        end
    -- Death Coil
        -- death_coil,if=runic_power.deficit<20&!variable.pooling_for_gargoyle
        if cast.able.deathCoil() and runicPowerDeficit < 20 and not poolForGargoyle then
            if cast.deathCoil() then return end
        end
    -- Festering Strike
        -- festering_strike,if=((((debuff.festering_wound.stack<4&!buff.unholy_frenzy.up)|debuff.festering_wound.stack<3)&cooldown.apocalypse.remains<3)|debuff.festering_wound.stack<1)&(cooldown.army_of_the_dead.remains>5|death_knight.disable_aotd)
        if cast.able.festeringStrike() and (cd.armyOfTheDead.remain() > 5 or not isChecked("Army of the Dead") or not useCDs() or level < 82)
            and ((((debuff.festeringWound.stack(units.dyn5) < 4 and not buff.unholyFrenzy.exists())
                or debuff.festeringWound.stack(units.dyn5) < 3) and cd.apocalypse.remain() < 3)
                    or debuff.festeringWound.stack(units.dyn5) < 1)
        then
            if cast.festeringStrike(units.dyn5) then return end
        end
    -- Death Coil
        -- death_coil,if=!variable.pooling_for_gargoyle
        if cast.able.deathCoil() and not poolForGargoyle then
            if cast.deathCoil() then return end
        end
    end -- End Action List - AOE
    local function actionList_Single()
    -- Death Coil
        -- death_coil,if=buff.sudden_doom.react&!variable.pooling_for_gargoyle|pet.gargoyle.exists
        if cast.able.deathCoil() and buff.suddenDoom.exists() and (not poolForGargoyle or pet.gargoyle.exists()) then
            if cast.deathCoil() then return end
        end
        -- death_coil,if=runic_power.deficit<14&(cooldown.apocalypse.remains>5|debuff.festering_wound.stack>4)&!variable.pooling_for_gargoyle
        if cast.able.deathCoil() and runicPowerDeficit < 14 and (cd.apocalypse.remain() > 5 or apocBypass or debuff.festeringWound.stack(units.dyn5) > 4) and not poolForGargoyle then
            if cast.deathCoil() then return end
        end
    -- Death and Decay
        -- death_and_decay,if=talent.pestilence.enabled&cooldown.apocalypse.remains
        if mode.dnd == 1 and cast.able.deathAndDecay() and not talent.defile and talent.pestilence
            and (cd.apocalypse.remain() > 0 or apocBypass)
        then
            if cast.deathAndDecay("best",nil,1,8) then return end
        end
    -- Defile
        -- defile,if=cooldown.apocalypse.remains
        if mode.dnd == 1 and cast.able.defile() and (cd.apocalypse.remain() > 0 or apocBypass) then
            if cast.defile("best",nil,1,8) then return end
        end
    -- Scourge Strike
        -- scourge_strike,if=((debuff.festering_wound.up&(cooldown.apocalypse.remains>5&(!essence.vision_of_perfection.enabled|!talent.unholy_frenzy.enabled)|essence.vision_of_perfection.enabled&talent.unholy_frenzy.enabled&(cooldown.unholy_frenzy.remains>6&azerite.magus_of_the_dead.enabled|!azerite.magus_of_the_dead.enabled&cooldown.apocalypse.remains>4)))|debuff.festering_wound.stack>4)&(cooldown.army_of_the_dead.remains>5|death_knight.disable_aotd)
        if cast.able.scourgeStrike() and not talent.clawingShadows and (cd.armyOfTheDead.remain() > 5 or not isChecked("Army of the Dead") or not useCDs() or level < 82)
            and ((debuff.festeringWound.exists(units.dyn5) and ((cd.apocalypse.remain() > 5 or apocBypass) and (not essence.visionOfPerfection.active or not talent.unholyFrenzy)
                or essence.visionOfPerfection.active and talent.unholyFrenzy and (cd.unholyFrenzy.remain() > 6 and trait.magusOfTheDead.active
                or not trait.magusOfTheDead.active and (cd.apocalypse.remain() > 4 or apocBypass))))
                or debuff.festeringWound.stack(units.dyn5) > 4)
        then
            if cast.scourgeStrike() then return end
        end
    -- Clawing Shadows
        -- clawing_shadows,if=((debuff.festering_wound.up&(cooldown.apocalypse.remains>5&(!essence.vision_of_perfection.enabled|!talent.unholy_frenzy.enabled)|essence.vision_of_perfection.enabled&talent.unholy_frenzy.enabled&(cooldown.unholy_frenzy.remains>6&azerite.magus_of_the_dead.enabled|!azerite.magus_of_the_dead.enabled&cooldown.apocalypse.remains>4)))|debuff.festering_wound.stack>4)&(cooldown.army_of_the_dead.remains>5|death_knight.disable_aotd)
        if cast.able.clawingShadows() and talent.clawingShadows and (cd.armyOfTheDead.remain() > 5 or not isChecked("Army of the Dead") or not useCDs() or level < 82)
            and ((debuff.festeringWound.exists(units.dyn5) and ((cd.apocalypse.remain() > 5 or apocBypass) and (not essence.visionOfPerfection.active or not talent.unholyFrenzy)
            or essence.visionOfPerfection.active and talent.unholyFrenzy and (cd.unholyFrenzy.remain() > 6 and trait.magusOfTheDead.active
            or not trait.magusOfTheDead.active and (cd.apocalypse.remain() > 4 or apocBypass))))
            or debuff.festeringWound.stack(units.dyn5) > 4)
        then
            if cast.clawingShadows() then return end
        end
    -- Death Coil
        -- death_coil,if=runic_power.deficit<20&!variable.pooling_for_gargoyle
        if cast.able.deathCoil() and runicPowerDeficit < 20 and not poolForGargoyle then
            if cast.deathCoil() then return end
        end
    -- Festering Strike
        -- festering_strike,if=debuff.festering_wound.stack<4&(cooldown.apocalypse.remains<3&(!essence.vision_of_perfection.enabled|!talent.unholy_frenzy.enabled|essence.vision_of_perfection.enabled&talent.unholy_frenzy.enabled&(cooldown.unholy_frenzy.remains<7&azerite.magus_of_the_dead.enabled|!azerite.magus_of_the_dead.enabled)))|debuff.festering_wound.stack<1&(cooldown.army_of_the_dead.remains>5|death_knight.disable_aotd)
        if cast.able.festeringStrike() and (cd.armyOfTheDead.remain() > 5 or not isChecked("Army of the Dead") or not useCDs() or level < 82)
            and (debuff.festeringWound.stack(units.dyn5) < 4 and (cd.apocalypse.remain() < 3
            and (not essence.visionOfPerfection.active or not talent.unholyFrenzy or essence.visionOfPerfection.active and talent.unholyFrenzy
            and (cd.unholyFrenzy.remain() < 7 and trait.magusOfTheDead.active or not trait.magusOfTheDead.active))) or debuff.festeringWound.stack() < 1)
        then
            if cast.festeringStrike(units.dyn5) then return end
        end
    -- Death Coil
        -- death_coil,if=!variable.pooling_for_gargoyle
        if cast.able.deathCoil() and not poolForGargoyle then
            if cast.deathCoil() then return end
        end
    end -- End Action List - Single
    local function actionList_PreCombat()
    -- Flask / Crystal
        -- flask,type=flask_of_the_seventh_demon
        if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheUndertow.exists() and use.able.flaskOfTheUndertow() then
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if use.flaskOfTheUndertow() then return true end
        end
        if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and use.able.repurposedFelFocuser() then
            if buff.flaskOfTheUndertow.exists() then buff.flaskOfTheUndertow.cancel() end
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
            if use.repurposedFelFocuser() then return true end
        end
        if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and use.able.oraliusWhisperingCrystal() then
            if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if use.oraliusWhisperingCrystal() then return true end
        end
        -- Pre-pull
        if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
    -- Potion
            if isChecked("Potion") and use.able.battlePotionOfStrength() and useCDs() and raid then
                use.battlePotionOfStrength()
            end
    -- Army of the Dead
            if isChecked("Army of the Dead") and useCDs() and pullTimer <= 2 then
                if cast.armyOfTheDead() then return end
            end
    -- Azshara's Font of Power
            if (getOptionValue("Trinkets") == 1 or (getOptionValue("Trinkets") == 2 and useCDs())) and equiped.azsharasFontOfPower() and use.able.azsharasFontOfPower() and not isMoving("player") and not inCombat and pullTimer <= getOptionValue("Pre-Pull Timer") then
                if use.azsharasFontOfPower() then return true end
            end               
        end 
    -- Pre-Pull
        if isValidUnit("target") and not inCombat then
    -- Death Grip
            if isChecked("Death Grip - Pre-Combat") and cast.able.deathGrip("target") and not isDummy()
                and getDistance("target") > 8 and ((talent.deathsReach and getDistance("target") < 40) or getDistance("target") < 30)
            then
                if cast.deathGrip("target") then return true end
            end
    -- Dark Command
            if isChecked("Dark Command") and cast.able.darkCommand("target") and not (isChecked("Death Grip") or cast.able.deathGrip("target")) then
                if cast.darkCommand("target") then return true end
            end
    -- Start Attack
            StartAttack()
        end
    end -- End Action List - PreCombat
-----------------
--- Rotations ---
-----------------
    -- Profile Stop | Pause
    if not inCombat and not GetObjectExists("target") and profileStop then
        profileStop = false
    elseif (inCombat and profileStop) or pause() or mode.rotation == 4 then
        if isChecked("Auto Attack/Passive") and pause(true) and IsPetAttackActive() then
            PetStopAttack()
            PetFollow()
        end
        return true
    else
--------------------
--- Pet Rotation ---
--------------------
        if actionList_PetManagement() then return true end
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
        if inCombat and not profileStop and GetObjectExists("target") then
            -- auto_attack
            if not IsAutoRepeatSpell(GetSpellInfo(6603)) and getDistance(units.dyn5) < 5 then
                StartAttack(units.dyn5)
            end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
            if actionList_Interrupts() then return true end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
            if getOptionValue("APL Mode") == 1 then
                if getDistance(units.dyn5) < 5 then
            -- Racial
                    -- arcane_torrent,if=runic_power.deficit>65&(cooldown.summon_gargoyle.remains|!talent.summon_gargoyle.enabled)&rune.deficit>=5
                    -- blood_fury,if=pet.gargoyle.exists|!talent.summon_gargoyle.enabled
                    -- berserking,if=pet.gargoyle.exists|!talent.summon_gargoyle.enabled
                    if isChecked("Racial") and cast.able.racial()
                        and ((race == "BloodElf" and runicPowerDeficit > 65 and (cd.summonGargoyle.remain() > 0 or not talent.summonGargoyle) and runeDeficit >= 5)
                            or ((race == "Orc" or race == "Troll") and (pet.gargoyle.exists() or not talent.summonGargoyle)))
                    then
                        if cast.racial("player") then return end
                    end
            -- Augment Rune
                    if isChecked("Augment Rune") and use.able.battleScarredAugmentRune() and inRaid then
                        use.battleScarredAugmentRune()
                    end
            -- Trinkets
                    if (getOptionValue("Trinkets") == 1 or (getOptionValue("Trinkets") == 2 and useCDs())) and getDistance(units.dyn5) < 5 then
                        for i = 13, 14 do
                            if use.able.slot(i) then
                                -- All Others
                                -- use_items,if=time>20|!equipped.ramping_amplitude_gigavolt_engine|!equipped.vision_of_demise
                                if combatTime > 20 or not (equiped.azsharasFontOfPower(i) or equiped.ashvanesRazorCoral(i) or equiped.visionOfDemise(i)
                                    or equiped.rampingAmplitudeGigavoltEngine(i) or equiped.bygoneBeeAlmanac(i)
                                    or equiped.jesHowler(i) or equiped.galecallersBeak(i) or equiped.grongsPrimalRage(i))
                                then
                                    use.slot(i)
                                end
                                -- Azshara's Font of Power
                                -- actions+=/use_item,name=azsharas_font_of_power,if=(essence.vision_of_perfection.enabled&!talent.unholy_frenzy.enabled)|(!essence.condensed_lifeforce.major&!essence.vision_of_perfection.enabled)
                                if equiped.azsharasFontOfPower(i) and ((essence.visionOfPerfection.active and not talent.unholyFrenzy) 
                                    or (not essence.condensedLifeForce.major and not essence.visionOfPerfection.active)) and not isMoving
                                then
                                use.slot(i)
                                end  
                                -- actions+=/use_item,name=azsharas_font_of_power,if=cooldown.apocalypse.remains<14&(essence.condensed_lifeforce.major|essence.vision_of_perfection.enabled&talent.unholy_frenzy.enabled)
                                if equiped.azsharasFontOfPower(i) and cd.apocalypse.remain() < 14 and (essence.condensedLifeForce.major or essence.visionOfPerfection.active) and talent.unholyFrenzy and not isMoving then
                                use.slot(i)
                                end
                                -- actions+=/use_item,name=azsharas_font_of_power,if=target.1.time_to_die<cooldown.apocalypse.remains+34
                                if equiped.azsharasFontOfPower(i) and  ttd(units.dyn5) < cd.apocalypse.remain() + 34 and not isMoving then
                                use.slot(i)
                                end
                                -- Ashvanes Razor Coral
                                -- use_item,name=ashvanes_razor_coral,if=debuff.razor_coral_debuff.stack<1
                                if equiped.ashvanesRazorCoral(i) and (cd.azsharasFontOfPower.remain() > 0 or not equiped.azsharasFontOfPower()) and debuff.razorCoral.stack(units.dyn5) == getOptionValue("Ashvane's Razor Coral Stacks") then
                                    use.slot(i)
                                end
                                -- use_item,name=ashvanes_razor_coral,if=(pet.guardian_of_azeroth.active&pet.apoc_ghoul.active)|(cooldown.apocalypse.remains<gcd&!essence.condensed_lifeforce.enabled&!talent.unholy_frenzy.enabled)|(target.1.time_to_die<cooldown.apocalypse.remains+20)|(cooldown.apocalypse.remains<gcd&target.1.time_to_die<cooldown.condensed_lifeforce.remains+20)|(buff.unholy_frenzy.up&!essence.condensed_lifeforce.enabled)
                                if equiped.ashvanesRazorCoral(i) and (cd.azsharasFontOfPower.remain() > 0 or not equiped.azsharasFontOfPower()) and ((pet.guardianOfAzeroth.exists() and pet.apocalypseGhoul.exists())
                                    or (cd.apocalypse.remain() < gcd and not essence.condensedLifeForce.active and not talent.unholyFrenzy)
                                    or (ttd(units.dyn5) < cd.apocalypse.remain() + 20) or (cd.apocalypse.remain() < gcd and ttd(units.dyn5) < cd.guardianOfAzeroth.remain() + 20)
                                    or (buff.unholyFrenzy.exists() and not essence.condensedLifeForce.active))
                                then
                                    use.slot(i)
                                end
                                -- Vision of Demise
                                -- use_item,name=vision_of_demise,if=(cooldown.apocalypse.ready&debuff.festering_wound.stack>=4&essence.vision_of_perfection.enabled)|buff.unholy_frenzy.up|pet.gargoyle.exists
                                if equiped.visionOfDemise(i) and ((cd.apocalypse.remain() == 0 and debuff.festeringWound.stack(units.dyn5) >= 4
                                    and essence.visionOfPerfection.active) or buff.unholyFrenzy.exists() or pet.gargoyle.exists())
                                then
                                    use.slot(i)
                                end
                                -- Ramping Amplitude Gigavolt Engine
                                -- use_item,name=ramping_amplitude_gigavolt_engine,if=cooldown.apocalypse.remains<2|talent.army_of_the_damned.enabled|raid_event.adds.in<5
                                if equiped.rampingAmplitudeGigavoltEngine(i) and (cd.apocalypse.remain() < 2 or talent.armyOfTheDamned) then
                                    use.slot(i)
                                end
                                -- Bygone Bee Almanac
                                -- use_item,name=bygone_bee_almanac,if=cooldown.summon_gargoyle.remains>60|!talent.summon_gargoyle.enabled&time>20|!equipped.ramping_amplitude_gigavolt_engine
                                if equiped.bygoneBeeAlmanac(i) and (cd.summonGargoyle.remain() > 60
                                    or (not talent.summonGargoyle and combatTime > 20) or not equiped.rampingAmplitudeGigavoltEngine(i))
                                then
                                    use.slot(i)
                                end
                                -- Jes Howler
                                -- use_item,name=jes_howler,if=pet.gargoyle.exists|!talent.summon_gargoyle.enabled&time>20|!equipped.ramping_amplitude_gigavolt_engine
                                if equiped.jesHowler(i) and (pet.gargoyle.exists() or (not talent.summonGargoyle and combatTime > 20)
                                    or not equiped.rampingAmplitudeGigavoltEngine(i))
                                then
                                    use.slot(i)
                                end
                                -- Galecaller's Beak
                                -- use_item,name=galecallers_beak,if=pet.gargoyle.exists|!talent.summon_gargoyle.enabled&time>20|!equipped.ramping_amplitude_gigavolt_engine
                                if equiped.galecallersBeak(i) and (pet.gargoyle.exists() or (not talent.summonGargoyle and combatTime > 20)
                                    or not equiped.rampingAmplitudeGigavoltEngine(i))
                                then
                                    use.slot(i)
                                end
                                -- Grong's Primal Rage
                                -- use_item,name=grongs_primal_rage,if=rune<=3&(time>20|!equipped.ramping_amplitude_gigavolt_engine)
                                if equiped.grongsPrimalRage(i) and runes <= 3 and (combatTime > 20 or not equiped.rampingAmplitudeGigavoltEngine()) then
                                    use.slot(i)
                                end
                            end
                        end
                    end
            -- Potion
                    -- potion,if=cooldown.army_of_the_dead.ready|pet.gargoyle.exists|buff.unholy_frenzy.up
                    if isChecked("Potion") and inRaid and useCDs() and use.able.battlePotionOfStrength()
                        and (cd.armyOfTheDead.remain() == 0 or pet.gargoyle.exists() or buff.unholyFrenzy.exists())
                    then
                        use.battlePotionOfStrength()
                    end
            -- Outbreak
                    -- outbreak,target_if=(dot.virulent_plague.tick_time_remains+tick_time<=dot.virulent_plague.remains)&dot.virulent_plague.remains<=gcd
                    if cast.able.outbreak(units.dyn30AOE) and debuff.virulentPlague.remain(units.dyn30AOE) <= gcd then
                        if cast.outbreak(units.dyn30AOE) then return end
                    end
            -- Call Action List - Essences
                    -- call_action_list,name=essences
                    if actionList_Essences() then return end
            -- Call Action List - Cooldowns
                    -- call_action_list,name=cooldowns
                    if actionList_Cooldowns() then return end
                end
            -- Run Action List - AOE
                -- run_action_list,name=aoe,if=active_enemies>=2
                if ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                    if actionList_AOE() then return end
                end
            -- Call Action List - Single
                -- call_action_list,name=generic
                if ((mode.rotation == 1 and #enemies.yards8 < 2) or (mode.rotation == 3 and #enemies.yards8 > 0)) then
                    if actionList_Single() then return end
                end
            end -- End SimC APL
        end -- End Rotation
    end -- End Pause Check
end -- End runRotation

-- Add To Rotation List
local id = 252
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

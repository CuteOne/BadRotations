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
    DnDModes = {
        [1] = { mode = "On", value = 1 , overlay = "DnD Enabled", tip = "Will use DnD.", highlight = 1, icon = spell.deathAndDecay },
        [2] = { mode = "Off", value = 2 , overlay = "DnD Disabled", tip = "will NOT use DnD.", highlight = 0, icon = spell.deathAndDecay }
    };
    CreateButton("DnD",5,0)

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
            -- Path of Frost 
            br.ui:createCheckbox(section, "Path of Frost")
        br.ui:checkSectionState(section)
        -------------------
        --- PET OPTIONS ---
        -------------------
        section = br.ui:createSection(br.ui.window.profile, "Pet Management")            
            -- Raise Dead 
            br.ui:createCheckbox(section, "Raise Dead")
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
            -- Apocalypse 
            br.ui:createDropdownWithout(section, "Apocalypse", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Apocalypse.")
            -- Army of the Dead
            br.ui:createCheckbox(section, "Army of the Dead")
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
            -- Asphyxiate
            br.ui:createCheckbox(section, "Asphyxiate")
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
---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
    local UpdateToggle = UpdateToggle
    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Defensive",0.25)
    UpdateToggle("Interrupt",0.25)
    UpdateToggle("DnD",0.25)
    br.player.mode.dnd = br.data.settings[br.selectedSpec].toggles["DnD"]
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
    local gcd                                           = br.player.gcdMax
    local inCombat                                      = br.player.inCombat
    local inRaid                                        = br.player.instance=="raid"
    local mode                                          = br.player.mode
    local pet                                           = br.player.pet
    local runes                                         = br.player.power.runes.amount()
    local runeDeficit                                   = br.player.power.runes.deficit()
    local runicPower                                    = br.player.power.runicPower.amount()
    local runicPowerDeficit                             = br.player.power.runicPower.deficit()
    local talent                                        = br.player.talent
    local units                                         = br.player.units
    local use                                           = br.player.use
    -- Other Locals
    local level                                         = UnitLevel("player")
    local petCombat                                     = UnitAffectingCombat("pet")
    local php                                           = getHP("player")
    local ttd                                           = getTTD

    -- Units Declaration
    units.get(5)
    units.get(30)
    units.get(30,true)
    units.get(40)
    -- Enemies Declaration
    enemies.get(5)
    enemies.get(8)
    enemies.get(15)
    enemies.get(20)
    enemies.get(30)
    enemies.get(40)

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

--------------------
--- Action Lists ---
--------------------
    local function actionList_PetManagement()
        if UnitExists("pet") and IsPetActive() and deadPet then deadPet = false end
        if waitForPetToAppear == nil or IsMounted() or IsFlying() or UnitHasVehicleUI("player") or CanExitVehicle("player") then
            waitForPetToAppear = GetTime()
        elseif isChecked("Raise Dead") then
            if waitForPetToAppear ~= nil and GetTime() - waitForPetToAppear > 2 then
                if UnitIsDeadOrGhost("pet") or deadPet or (not deadPet and not (IsPetActive() or UnitExists("pet"))) 
                    or (talent.allWillServe and not pet.risenSkulker.exists()) 
                then 
                    Print("Raising the Dead!")
                    if cast.raiseDead() then waitForPetToAppear = GetTime(); return end 
                end
            end
        end
        if isChecked("Auto Attack/Passive") then
            -- Set Pet Mode Out of Comat / Set Mode Passive In Combat
            if petMode == nil then petMode = "None" end
            if not inCombat then
                if petMode == "Passive" then
                    if petMode == "Assist" then PetAssistMode() end
                    if petMode == "Defensive" then PetDefensiveMode() end
                end
                for i = 1, NUM_PET_ACTION_SLOTS do
                    local name, _, _, _, isActive = GetPetActionInfo(i)
                    if isActive then
                        if name == "PET_MODE_ASSIST" then petMode = "Assist" end
                        if name == "PET_MODE_DEFENSIVE" then petMode = "Defensive" end
                    end
                end
            elseif inCombat and petMode ~= "Passive" then
                PetPassiveMode()
                petMode = "Passive"
            end
            -- Pet Attack / retreat
            if (not UnitExists("pettarget") or not isValidUnit("pettarget")) and (inCombat or petCombat) then
                for i=1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if isValidUnit(thisUnit) or isDummy() then
                        PetAttack(thisUnit)
                        break;
                    end
                end
            elseif (not inCombat or (inCombat and not isValidUnit("pettarget") and not isDummy())) and IsPetAttackActive() then
                PetStopAttack()
                PetFollow()
            end
            -- if inCombat and (isValidUnit("target") or isDummy()) and getDistance("target") < 40 and not GetUnitIsUnit("target","pettarget") then
            --     -- Print("Pet is switching to your target.")
            --     PetAttack()
            -- end
            -- if (not inCombat or (inCombat and not isValidUnit("pettarget") and not isDummy())) and IsPetAttackActive() then
            --     PetStopAttack()
            --     PetFollow()
            -- end
        end
        -- Huddle
        if isChecked("Huddle") and cast.able.huddle() and (inCombat or petCombat) and getHP("pet") <= getOptionValue("Huddle") then
            if cast.huddle() then return end
        end
        -- Claw
        if isChecked("Claw") and cast.able.claw("pettarget") and not buff.huddle.exists("pet") and isValidUnit("pettarget") and getDistance("pettarget","pet") < 5 then
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
        if isChecked("Leap") and cast.able.leap("pettarget") and not buff.huddle.exists("pet") and isValidUnit("pettarget") and getDistance("pettarget","pet") > 8 then
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
        end -- End useInterrupts check
    end -- End Action List - Interrupts
    local function actionList_Cooldowns()
    -- Army of the Dead 
        -- army_of_the_dead
        if isChecked("Army of the Dead") and useCDs() and cast.able.armyOfTheDead() then 
            if cast.armyOfTheDead() then return end 
        end 
    -- Apocalypse 
        -- apocalypse,if=debuff.festering_wound.stack>=4
        if (getOptionValue("Apocalypse") == 1 or (getOptionValue("Apocalypse") == 2 and useCDs())) 
            and cast.able.apocalypse() and debuff.festeringWound.stack(units.dyn5) >= 4 
        then 
            if cast.apocalypse(units.dyn5) then return end 
        end
    -- Dark Transformation 
        -- dark_transformation
        if pet.active.exists() and cast.able.darkTransformation()
            and (getOptionValue("Dark Transformation") == 1 or (getOptionValue("Dark Transformation") == 2 and useCDs())) 
        then 
            if cast.darkTransformation() then return end 
        end 
    -- Summon Gargoyle 
        -- summon_gargoyle,if=runic_power.deficit<14
        if isChecked("Summon Gargoyle") and cast.able.summonGargoyle() and runicPowerDeficit < 14 then 
            if cast.summonGargoyle() then return end 
        end
    -- Unholy Frenzy 
        if (getOptionValue("Unholy Frenzy") == 1 or (getOptionValue("Unholy Frenzy") == 2 and useCDs())) and cast.able.unholyFrenzy() then
            -- unholy_frenzy,if=debuff.festering_wound.stack<4
            if debuff.festeringWound.stack(units.dyn5) < 4 then 
                if cast.unholyFrenzy() then return end 
            end 
            -- unholy_frenzy,if=active_enemies>=2&((cooldown.death_and_decay.remains<=gcd&!talent.defile.enabled)|(cooldown.defile.remains<=gcd&talent.defile.enabled))
            if ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0))
                and ((cd.deathAndDecay.remain() <= gcd and not talent.defile) or (cd.defile.remain() <= gcd and talent.defile))
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
            if ((mode.rotation == 1 and #enemies.yards8 == 1) or (mode.rotation == 3 and #enemies.yards8 > 0) or isDummy()) and runes <= (1- frenzied) then 
                if cast.soulReaper() then return end 
            end
        end 
    -- Unholy Blight
        -- unholu_blight
        if (getOptionValue("Unholy Frenzy") == 1 or (getOptionValue("Unholy Frenzy") == 2 and useCDs())) and cast.able.unholyBlight("player","aoe",1,10) then
            if cast.unholyBlight("player","aoe",1,10) then return end 
        end
    end -- End Action List - Cooldowns
    local function actionList_AOE()
    -- Death and Decay 
        -- death_and_decay,if=cooldown.apocalypse.remains 
        if mode.dnd == 1 and cast.able.deathAndDecay("best",nil,1,8) and not talent.defile 
            and (cd.apocalypse.remain() > 0 or getOptionValue("Apocalypse") == 3 or (getOptionValue("Apocalypse") == 2 and not useCDs()) or level < 75) 
        then 
            if cast.deathAndDecay("best",nil,1,8) then return end 
        end
    -- Defile 
        -- defile 
        if mode.dnd == 1 and cast.able.defile("best",nil,1,8) then 
            if cast.defile("best",nil,1,8) then return end 
        end 
    -- Epidemic 
        -- epidemic,if=death_and_decay.ticking&rune<2&!variable.pooling_for_gargoyle
        if cast.able.epidemic() and (deathAndDecayRemain > 0 or not cast.able.deathAndDecay("best",nil,1,8)) and runes < 2 and not poolForGargoyle then 
            if cast.epidemic() then return end 
        end
    -- Death Coil
        -- death_coil,if=death_and_decay.ticking&rune<2&!variable.pooling_for_gargoyle
        if cast.able.deathCoil() and (deathAndDecayRemain > 0 or not cast.able.deathAndDecay("best",nil,1,8)) and runes < 2 and not poolForGargoyle then 
            if cast.deathCoil() then return end 
        end 
    -- Scourge Strike 
        -- scourge_strike,if=death_and_decay.ticking&cooldown.apocalypse.remains
        if cast.able.scourgeStrike() and not talent.clawingShadows and deathAndDecayRemain > 0
            and (cd.apocalypse.remain() > 0 or getOptionValue("Apocalypse") == 3 or (getOptionValue("Apocalypse") == 2 and not useCDs()) or level < 75) 
            and debuff.festeringWound.stack(units.dyn5) > 0
        then 
            if cast.scourgeStrike() then return end 
        end
    -- Clawing Shadows
        -- clawing_shadows,if=death_and_decay.ticking&cooldown.apocalypse.remains
        if cast.able.clawingShadows() and deathAndDecayRemain > 0
            and (cd.apocalypse.remain() > 0 or getOptionValue("Apocalypse") == 3 or (getOptionValue("Apocalypse") == 2 and not useCDs()) or level < 75) 
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
            if cast.able.deathCoil() then return end 
        end 
        -- death_coil,if=buff.sudden_doom.react&!variable.pooling_for_gargoyle|pet.gargoyle.active
        if cast.able.deathCoil() and buff.suddenDoom.exists() and (not poolForGargoyle or pet.gargoyle.exists()) then 
            if cast.able.deathCoil() then return end 
        end
        -- death_coil,if=runic_power.deficit<14&(cooldown.apocalypse.remains>5|debuff.festering_wound.stack>4)&!variable.pooling_for_gargoyle
        if cast.able.deathCoil() and runicPowerDeficit < 14 and not poolForGargoyle 
            and (cd.apocalypse.remain() > 5 or debuff.festeringWound.stack(units.dyn5) > 4)
        then 
            if cast.deathCoil() then return end 
        end 
    -- Scourge Strike 
        -- scourge_strike,if=((debuff.festering_wound.up&cooldown.apocalypse.remains>5)|debuff.festering_wound.stack>4)&cooldown.army_of_the_dead.remains>5
        if cast.able.scourgeStrike() and not talent.clawingShadows 
            and (cd.armyOfTheDead.remain() > 5 or not isChecked("Army of the Dead") or not useCDs() or level < 82)
            and ((debuff.festeringWound.exists(units.dyn5) and cd.apocalypse.remain() > 5) or debuff.festeringWound.stack(units.dyn5) > 4)
        then 
            if cast.scourgeStrike() then return end 
        end
    -- Clawing Shadows 
        -- clawing_shadows,if=((debuff.festering_wound.up&cooldown.apocalypse.remains>5)|debuff.festering_wound.stack>4)&cooldown.army_of_the_dead.remains>5
        if cast.able.clawingShadows() and (cd.armyOfTheDead.remain() > 5 or not isChecked("Army of the Dead") or not useCDs() or level < 82)
            and ((debuff.festeringWound.exists(units.dyn5) and cd.apocalypse.remain() > 5) or debuff.festeringWound.stack(units.dyn5) > 4)
        then 
            if cast.clawingShadows() then return end 
        end
    -- Death Coil 
        -- death_coil,if=runic_power.deficit<20&!variable.pooling_for_gargoyle
        if cast.able.deathCoil() and runicPowerDeficit < 20 and not poolForGargoyle then 
            if cast.deathCoil() then return end 
        end 
    -- Festering Strike 
        -- festering_strike,if=((((debuff.festering_wound.stack<4&!buff.unholy_frenzy.up)|debuff.festering_wound.stack<3)&cooldown.apocalypse.remains<3)|debuff.festering_wound.stack<1)&cooldown.army_of_the_dead.remains>5
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
        -- death_coil,if=buff.sudden_doom.react&!variable.pooling_for_gargoyle|pet.gargoyle.active
        if cast.able.deathCoil() and buff.suddenDoom.exists() and (not poolForGargoyle or pet.gargoyle.exists()) then 
            if cast.deathCoil() then return end 
        end 
        -- death_coil,if=runic_power.deficit<14&(cooldown.apocalypse.remains>5|debuff.festering_wound.stack>4)&!variable.pooling_for_gargoyle
        if cast.able.deathCoil() and runicPowerDeficit < 14 and (cd.apocalypse.remain() > 5 or debuff.festeringWound.stack(units.dyn5) > 4) and not poolForGargoyle then 
            if cast.deathCoil() then return end 
        end 
    -- Death and Decay 
        -- death_and_decay,if=talent.pestilence.enabled&cooldown.apocalypse.remains
        if mode.dnd == 1 and cast.able.deathAndDecay("best",nil,1,8) and not talent.defile and talent.pestilence
            and (cd.apocalypse.remain() > 0 or getOptionValue("Apocalypse") == 3 or (getOptionValue("Apocalypse") == 2 and not useCDs()) or level < 75) 
        then 
            if cast.deathAndDecay("best",nil,1,8) then return end 
        end 
    -- Defile 
        -- defile,if=cooldown.apocalypse.remains
        if mode.dnd == 1 and cast.able.defile("best",nil,1,8) and (cd.apocalypse.remain() > 0 or getOptionValue("Apocalypse") == 3 or (getOptionValue("Apocalypse") == 2 and not useCDs()) or level < 75) then
            if cast.defile("best",nil,1,8) then return end
        end
    -- Scourge Strike 
        -- scourge_strike,if=((debuff.festering_wound.up&cooldown.apocalypse.remains>5)|debuff.festering_wound.stack>4)&cooldown.army_of_the_dead.remains>5
        if cast.able.scourgeStrike() and not talent.clawingShadows and (cd.armyOfTheDead.remain() > 5 or not isChecked("Army of the Dead") or not useCDs() or level < 82) 
            and ((debuff.festeringWound.exists(units.dyn5) and cd.apocalypse.remain() > 5) or debuff.festeringWound.stack(units.dyn5) > 4)
        then 
            if cast.scourgeStrike() then return end 
        end 
    -- Clawing Shadows
        -- clawing_shadows,if=((debuff.festering_wound.up&cooldown.apocalypse.remains>5)|debuff.festering_wound.stack>4)&cooldown.army_of_the_dead.remains>5
        if cast.able.clawingShadows() and (cd.armyOfTheDead.remain() > 5 or not isChecked("Army of the Dead") or not useCDs() or level < 82) 
            and ((debuff.festeringWound.exists(units.dyn5) and cd.apocalypse.remain() > 5) or debuff.festeringWound.stack(units.dyn5) > 4)
        then 
            if cast.clawingShadows() then return end 
        end 
    -- Death Coil 
        -- death_coil,if=runic_power.deficit<20&!variable.pooling_for_gargoyle
        if cast.able.deathCoil() and runicPowerDeficit < 20 and not poolForGargoyle then 
            if cast.deathCoil() then return end 
        end 
    -- Festering Strike
        -- festering_strike,if=((((debuff.festering_wound.stack<4&!buff.unholy_frenzy.up)|debuff.festering_wound.stack<3)&cooldown.apocalypse.remains<3)|debuff.festering_wound.stack<1)&cooldown.army_of_the_dead.remains>5
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
        end -- Pre-Pull
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
        if isChecked("Auto Attack/Passive") and pause() and IsPetAttackActive() then
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
                    -- blood_fury,if=pet.gargoyle.active|!talent.summon_gargoyle.enabled
                    -- berserking,if=pet.gargoyle.active|!talent.summon_gargoyle.enabled
                    if isChecked("Racial") and cast.able.racial()
                        and ((race == "BloodElf" and runicPowerDeficit > 65 and (cd.summonGargoyle.remain() > 0 or not talent.summonGargoyle) and runeDeficit >= 5)
                            or ((race == "Orc" or race == "Troll") and (pet.gargoyle.exists() or not talent.summonGargoyle)))
                    then 
                        if cast.racial("player") then return end 
                    end
            -- Trinkets
                    -- use_items
                    -- use_item,name=bygone_bee_almanac,if=cooldown.summon_gargoyle.remains>60|!talent.summon_gargoyle.enabled
                    -- use_item,name=jes_howler,if=pet.gargoyle.active|!talent.summon_gargoyle.enabled
                    -- use_item,name=galecallers_beak,if=pet.gargoyle.active|!talent.summon_gargoyle.enabled
                    if isChecked("Augment Rune") and use.able.battleScarredAugmentRune() and inRaid then 
                        use.battleScarredAugmentRune() 
                    end
                    if (getOptionValue("Trinkets") == 1 or (getOptionValue("Trinkets") == 2 and useCDs())) and getDistance(units.dyn5) < 5 then
                        for i = 13, 14 do
                            if use.able.slot(i) 
                                and (not (equiped.bygoneBeeAlmanac(i) or equiped.jesHowler(i) or equiped.galecallersBeak(i))
                                    or (equiped.bygoneBeeAlmanac(i) and (cd.summonGargoyle.remain() > 60 or not talent.summonGargoyle))
                                    or (equiped.jesHowler(i) and (pet.gargoyle.exists() or not talent.summonGargoyle))
                                    or (equiped.galecallersBeak(i) and (pet.gargoyle.exist() or not talent.summonGargoyle)))
                            then
                                use.slot(i)
                            end
                        end
                    end
            -- Potion 
                    -- potion,if=cooldown.army_of_the_dead.ready|pet.gargoyle.active|buff.unholy_frenzy.up
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
            -- Call Action List - Cooldowns
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
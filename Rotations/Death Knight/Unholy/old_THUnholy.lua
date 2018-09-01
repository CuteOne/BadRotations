local rotationName = "THUnholy" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 0, icon = br.player.spell.deathAndDecay },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.deathAndDecay },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.furiousSlash },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.summonGargoyle },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.darkArbiter },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.battleCry }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.corpseShield },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.enragedRegeneration }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel }
    };
    CreateButton("Interrupt",4,0)
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- local Functions
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Toogle Section
    local function uncheck(Value)
        if br.data~=nil then
             print(Value)
            br.data.settings[br.selectedSpec][br.selectedProfile][Value.. "Check"] = false
        end
    end
-- ObjectCheck 
     local function GetObjExists(objectID)
         for i = 1,GetObjectCount() do
             local thisUnit = GetObjectWithIndex(i)
             if GetObjectExists(thisUnit) and GetObjectID(thisUnit) == objectID then
                 return true
             end
         end
         return false
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
            -- Remove Spells from queue with CD
            br.ui:createSpinner(section, "SpellQueue Clear",  5,  0,  100,  5,  "|cffFFBB00Remove spell if cd is greater.")
            --Autotarget
            br.ui:createCheckbox(section,"Auto Target","Target none/friendly switch to enemy within 8y")
            -- Debug
            br.ui:createCheckbox(section,"Debug Info")

        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Potion of prolongued Power
            br.ui:createCheckbox(section,"Potion")
            -- Dark Transformation
            br.ui:createDropdownWithout(section, "Dark Transformation", {"|cff00FF00Units or Boss","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Dark Transformation ability.")
            br.ui:createSpinnerWithout(section, "Dark Transformation Units",  1,  1,  10,  1,  "|cffFFFFFFSet to desired targets to use Dark Transformation on. Min: 1 / Max: 10 / Interval: 1")
            --Death and Decay
            br.ui:createSpinnerWithout(section, "Death and Decay", 1, 1, 10, 1, "|cffFFFFFFSet to desired targets to use Death and Decay on. Min: 1 / Max: 10 / Interval: 1")
            br.ui:createSpinnerWithout(section, "DnD Festering Wounds", 1, 0, 8, 1, "|cffFFFFFFSet to Number of Wounds must exists before DnD. Min: 0 / Max: 8")
            --Asphyxiate
            --br.ui:createCheckbox(section,"Asphyxiate")
            --Summon Gargoyle
            br.ui:createCheckbox(section,"Summon Gargoyle")

        br.ui:checkSectionState(section)
        ------------------------
        --- Pet OPTIONS --- -- 
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Pet")
        -- Auto Summon
            br.ui:createCheckbox(section,"Auto Summon")
        --Auto Attack
            br.ui:createCheckbox(section,"Pet Attack")
         br.ui:checkSectionState(section)    
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  61,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
             -- Anti-Magic Shell
            br.ui:createSpinner(section, "Anti-Magic Shell",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
             -- Death Strike
            br.ui:createSpinner(section, "Death Strike",  70,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Icebound Fortitude
            br.ui:createSpinner(section, "Icebound Fortitude",  35,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Corpse Shield
            br.ui:createSpinner(section, "Corpse Shield",  59,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Raise Ally
            br.ui:createCheckbox(section,"Raise Ally")
            br.ui:createDropdownWithout(section, "Raise Ally - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")

        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Leap
            br.ui:createCheckbox(section,"Leap")
            -- Mind Freeze
            br.ui:createCheckbox(section,"Mind Freeze")
            -- Asphyxiate Kick
            br.ui:createCheckbox(section,"Asphyxiate Kick")
            -- DeathGrip
            br.ui:createCheckbox(section,"Death Grip")
            -- Interrupt Percentage
            br.ui:createSpinner(section,"InterruptAt",  17,  0,  85,  5,  "|cffFFBB00Cast Percentage to use at (+-5%).")    
        br.ui:checkSectionState(section)

        ---------------------
        --- PVP Option    ---
        ---------------------
         section = br.ui:createSection(br.ui.window.profile,  "PVP")
            -- Necrotic Strike
            br.ui:createCheckbox(section,"Necrotic Strike")
            -- Chains of Ice
            br.ui:createCheckbox(section,"Chains of Ice", "Chains target")
            -- Chians of Ice Focus
            br.ui:createCheckbox(section,"Chains of Ice Focus", "Chains focus target")
            -- AMS Counter
            br.ui:createCheckbox(section,"AMS Counter")
            -- Necro Spam
            br.ui:createSpinner(section,  "Necro Spam",  45,  0,  100,  5,  "|cffFFBB00Prefer Necro at X percent dampening.")
            --Eye of Leotheras
            br.ui:createCheckbox(section, "Eye of Leotheras", "Pause CR on Eye of Leotheras Debuff")
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
    if br.timer:useTimer("debugUnholy", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
--------------
--- Locals ---
--------------
        local lastSpell         = lastCast
        local bop               = UnitBuff("target","Blessing of Protection") ~= nil
        local cloak             = UnitBuff("target","Cloak of Shadows") ~= nil or UnitBuff("target","Anti-Magic Shell") ~= nil
        local immunDS           = UnitBuff("target","Divine Shield") ~= nil 
        local immunIB           = UnitBuff("target","Ice Block") ~= nil
        local immunAotT         = UnitBuff("target","Aspect of the Turtle") ~= nil
        local immunCyclone      = UnitBuff("target","Cyclone") ~= nil
        local immun             = immun or immunIB or immunAotT or immunDS or immunCyclone
        local attacktar         = UnitCanAttack("target", "player")
        local buff              = br.player.buff
        local cast              = br.player.cast
        local cd                = br.player.cd
        local charges           = br.player.charges
        local deadtar           = UnitIsDeadOrGhost("target") or isDummy()
        local playertar         = UnitIsPlayer("target")
        local debuff            = br.player.debuff
        local enemies           = br.player.enemies
        local petMinion         = false
        local petRisen          = false
        local gcd               = br.player.gcd
        local glyph             = br.player.glyph
        local inCombat          = br.player.inCombat
        local level             = br.player.level
        local mode              = br.player.mode
        local moving            = GetUnitSpeed("player")>0
        local normalMob         = not(useCDs() or playertar)
        local php               = br.player.health
        local power             = br.player.power
        local pullTimer         = br.DBM:getPulltimer()
        local racial            = br.player.getRacial()
        local runicPower        = br.player.power.runicPower.amount()
        local runicPowerDeficit = br.player.power.runicPower.deficit()
        local runes             = br.player.power.runes.frac()
        local swimming          = IsSwimming()
        local talent            = br.player.talent
        local t19_2pc           = TierScan("T19") >= 2
        local t19_4pc           = TierScan("T19") >= 4
        local ttd               = getTTD
        local units             = br.player.units

        units.get(5)
        units.get(8)
        units.get(30)
        enemies.get(8)
        enemies.get(10)
        enemies.get(10,"target")
        enemies.get(15)
        enemies.get(30)
        enemies.get(40)
                
        if lastSpell == nil or not inCombat then lastSpell = 0 end
        if profileStop == nil then profileStop = false end
        if waitfornextVirPlague == nil or objIDLastVirPlagueTarget == nil then
            waitfornextVirPlague = GetTime() - 10
            objIDLastVirPlagueTarget = 0
        end 
        if waitForPetToAppear == nil then waitForPetToAppear = 0 end
        if waitforNextKick == nil then waitforNextKick = 0 end     
        if waitfornextPrint == nil or printevery2S == nil then
            waitfornextPrint = GetTime()
            printevery2S = true
        elseif waitfornextPrint <= GetTime() -2 then
            printevery2S = true
            waitfornextPrint = GetTime()
        else
            printevery2S = false
        end
        if waitforNextIoC == nil then waitforNextIoC = 0 end
        if waitforNextIoCFocus == nil then waitforNextIoCFocus = 0 end

-------------------
--- Raise Pet   ---
-------------------
        if not inCombat and not IsMounted() and isChecked("Auto Summon") and not GetUnitExists("pet") and (UnitIsDead("pet") ~= nil or UnitIsDead("pet") == false) then
            if waitForPetToAppear ~= nil and waitForPetToAppear < GetTime() - 2 and onlyOneTry ~= nil and not onlyOneTry then
                onlyOneTry = true
                if cast.raiseDead() then return end
            end

            if waitForPetToAppear == nil then
                waitForPetToAppear = GetTime()
            end
        else
            onlyOneTry = false
        end

--------------------
--- Action Lists ---
--------------------
    ---------------------------------------------------------------------------------------------------------------------------------
    -- Action List - Cooldowns
    ---------------------------------------------------------------------------------------------------------------------------------
        local function actionList_Cooldowns()
            if isChecked("Debug Info") then Print("actionList_Cooldowns") end
        --Racial
            if isChecked("Racial") and (((br.player.race == "Troll" or br.player.race == "Orc"))
                or (br.player.race == "BloodElf" and runicPowerDeficit > 20)) and getSpellCD(racial) == 0
                and (not talent.soulReaper or (not debuff.soulReaper.exists("target") or buff.soulReaper.stack("player") == 3))
                and getDistance("target") < 5
            then
                if castSpell("player",racial,false,false,false) then return end
            end
        --Dark Transformation
            if  (    
                    (   getOptionValue("Dark Transformation") == 1 --Units or Boss
                        and #enemies.yards10 >= getOptionValue("Dark Transformation Units") 
                        or useCDs() 
                        or playertar
                    )   
                    or 
                    (   getOptionValue("Dark Transformation") == 2 --Cooldown only
                        and (
                                useCDs() or playertar
                            )
                    )
                )
                and not immun
                and not bop
                and (((hasEquiped(137075) and not (cd.apocalypse.remain() < 10)) or playertar) or not hasEquiped(137075))
                and getDistance("target") < 5
                and (not talent.darkArbiter or (talent.darkArbiter and cd.summonGargoyle.remain() > 60))
                and (not talent.soulReaper or (not debuff.soulReaper.exists("target") or buff.soulReaper.stack("player") == 3))
                and not (buff.soulReaper.stack("player") == 3 and cd.summonGargoyle.remain() <= 0)
            then
                if cast.darkTransformation() then return end
            end
        --Death and Decay
            if #enemies.yards10 >= getOptionValue("Death and Decay") and debuff.festeringWound.stack("target") >= getOptionValue("DnD Festering Wounds") and not isMoving("player") then
                if cast.deathAndDecay("player") then return end
            end
        --Potion
            if useCDs() and isChecked("Potion") and getDistance("target") < 15 and not isDummy() and not playertar then
                --Old War
                if hasItem(127844) and canUse(127844) then
                    useItem(127844)
                end
                --Prolongued Power
                if hasItem(142117) and canUse(142117) then
                    useItem(142117)
                end
            end
        --Blighted Runeweapon
            if talent.blightedRuneWeapon
                and (not talent.soulReaper or (not debuff.soulReaper.exists("target") or buff.soulReaper.stack("player") == 3))
                and getDistance("target") < 5
                and not immun
                and not bop 
            then
                if cast.blightedRuneWeapon() then return end
            end
        --Summon Gargoyle
            if isChecked("Summon Gargoyle") 
                and (useCDs() or playertar)
                and (not talent.soulReaper or buff.soulReaper.stack("player") == 3 or (not debuff.soulReaper.exists("target") and cd.soulReaper.remain() > 30))
                and cd.summonGargoyle.remain() <= 0 
                and (not talent.darkArbiter or runicPowerDeficit <= 10)
            then
                if cast.summonGargoyle() then return end               
            end
        end
    ---------------------------------------------------------------------------------------------------------------------------------    
    -- Action List - Defensive
    ---------------------------------------------------------------------------------------------------------------------------------
        local function actionList_Defensive()
            if isChecked("Debug Info") then Print("actionList_Defensive") end
            if useDefensive() and not IsMounted() and inCombat then
            --- AMS Counter
                if isChecked("AMS Counter") 
                    and UnitDebuff("player","Soul Reaper") ~= nil
                then                    
                    if cast.antiMagicShell() then print("AMS Counter - Soul Reaper") return end
                end
            --Healthstone
                if isChecked("Healthstone") 
                    and php <= getOptionValue("Healthstone")     
                    and hasItem(5512)
                then
                    if canUse(5512) then
                        useItem(5512)
                    end
                end
            -- Death Strike
                if isChecked("Death Strike")  
                    and (buff.darkSuccor.exists() and (php < getOptionValue("Death Strike") or buff.darkSuccor.remain() < 2))
                    or  runicPower >= 45  
                    and php < getOptionValue("Death Strike") 
                    and (not talent.darkArbiter or (cd.darkArbiter.remain() <= 3 and not (useCDs() or playertar)))
                then
                     -- Death strike everything in reach
                    if getDistance("target") > 5 or immun or bop then
                        for i=1, #getEnemies("player",20) do
                            thisUnit = getEnemies("player",20)[i]
                            distance = getDistance(thisUnit)
                            if distance < 5 and getFacing("player",thisUnit) then
                                if cast.deathStrike(thisUnit) then print("Random Hit Deathstrike") return end
                            end
                        end
                    else
                        if cast.deathStrike("target") then return end
                    end
                end
            -- Icebound Fortitude
                if isChecked("Icebound Fortitude") 
                    and php < getOptionValue("Icebound Fortitude") 
                then
                    if cast.iceboundFortitude() then return end
                end
            -- Corpse Shield
                if isChecked("Corpse Shield") 
                    and php < getOptionValue("Corpse Shield") 
                then
                    if cast.corpseShield() then return end
                end
            -- Anti-Magic Shell
                if isChecked("Anti-Magic Shell") and php <= getOptionValue("Anti-Magic Shell") then
                    if cast.antiMagicShell() then return end
                end
            -- Raise Ally
                if isChecked("Raise Ally") then
                    if getOptionValue("Raise Ally - Target")==1
                        and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                    then
                        if cast.raiseAlly("target","dead") then return end
                    end
                    if getOptionValue("Raise Ally - Target")==2
                        and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                    then
                        if cast.raiseAlly("mouseover","dead") then return end
                    end
                end
            end
        end
    ---------------------------------------------------------------------------------------------------------------------------------
    -- Action List - DebuffReader
    ---------------------------------------------------------------------------------------------------------------------------------
        local function actionList_DebuffReader()
            if startDampeningTimer == nil then startDampeningTimer = false end
            if printDampeningTimer == nil then printDampeningTimer = true end

            if debuff.dampening.exists("player") and not startDampeningTimer then
                startDampeningTimer = true
                printDampeningTimer = true
                dampeningStartTime = GetTime()                            
            elseif not debuff.dampening.exists("player") then
                startDampeningTimer = false
            end

            if startDampeningTimer then
                dampeningCount = math.floor((GetTime() - dampeningStartTime) / 10) + 1
            else
                dampeningCount = 0
            end
            if isChecked("Necro Spam") and dampeningCount >= getOptionValue("Necro Spam")  and printDampeningTimer then
                Print("Dampening level reached -> Necro Spam active")
                printDampeningTimer = false
            end
        end
    ---------------------------------------------------------------------------------------------------------------------------------    
    -- Action List - Extras
    ---------------------------------------------------------------------------------------------------------------------------------
        local function actionList_Extras()        
            if isChecked("Debug Info") then Print("actionList_Extras") end
        -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                        profileStop = true
                        StopAttack()
                        ClearTarget()
                        PetStopAttack()
                        PetPassiveMode()
                        Print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        return true
                    end
                end
            end
        -- Chains of Ice
            if isChecked("Chains of Ice") then
                if waitforNextIoC < GetTime() -1.5 then
                    if playertar 
                        and (not debuff.chainsOfIce.exists("target"))
                        and (not talent.soulReaper or not debuff.soulReaper.exists("target") or (buff.soulReaper.stack("player") == 3)  or  getDistance("target") > 5)
                        and not (UnitBuff("target","Blessing of Freedom") ~= nil)
                        and not immun
                        and not cloak
                        and isMoving("target") 
                        and getDistance("target") <= 30
                        and inCombat
                    then
                        if cast.chainsOfIce("target","aoe") then waitforNextIoC = GetTime() return end
                    end
                end
                
            end
        --Chains of Ice focus
            if isChecked("Chains of Ice Focus") then
                if waitforNextIoCFocus < GetTime() -1.5 then
                    if GetUnitExists("focus")
                        and (not debuff.chainsOfIce.exists("focus"))
                        and (not talent.soulReaper or not debuff.soulReaper.exists("target") or (buff.soulReaper.stack("player") == 3))
                        and not (UnitBuff("focus","Blessing of Freedom") ~= nil)
                        and not immun
                        and not cloak
                        and isMoving("focus") 
                        and getDistance("focus") <= 30
                    then
                        if cast.chainsOfIce("focus","aoe") then waitforNextIoCFocus = GetTime() return end
                    end
                end
            end
        --Virulent Plague
            if GetUnitExists("target") and ((objIDLastVirPlagueTarget ~= ObjectID("target")) or (waitfornextVirPlague < GetTime() - 6)) then
                if (not debuff.virulentPlague.exists("target")
                    or debuff.virulentPlague.remain("target") < 1.5) 
                    and not debuff.soulReaper.exists("target")
                    and not immun
                    and not cloak
                    and UnitIsDeadOrGhost("target") ~= nil
                then
                    if cast.outbreak("target","aoe") then 
                        waitfornextVirPlague = GetTime() 
                        objIDLastVirPlagueTarget = ObjectID("target")
                        return 
                    end
                end
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if not debuff.virulentPlague.exists(thisUnit) 
                        and UnitAffectingCombat(thisUnit) 
                        and not cloak
                        and not immun
                    then
                        if cast.outbreak(thisUnit,"aoe") then 
                            waitfornextVirPlague = GetTime() 
                            return 
                        end
                        break
                    end
                end
            end
        end
    ---------------------------------------------------------------------------------------------------------------------------------
    -- Action List - Interrupts
    ---------------------------------------------------------------------------------------------------------------------------------
        local function actionList_Interrupts()
            if isChecked("Debug Info") then Print("actionList_Interrupts") end
            if useInterrupts() then
                if waitforNextKick < GetTime() -2 then
                    if cd.mindFreeze.remain() <= 0 
                        or cd.deathGrip.remain() <= 0 
                        or cd.asphyxiate.remain() <= 0 
                        or (not talent.sludgeBelcher and cd.leap.remain() <= 0) 
                        or (talent.sludgeBelcher and cd.hook.remain() <= 0) 
                    then
                        if kickpercent == nil or kickCommited == nil or kickCommited then
                            kickCommited = false
                            kickpercent = getOptionValue("InterruptAt") + math.random(-5,5)
                            print("new Kickpercent : ", kickpercent)
                        end
                        for i=1, #enemies.yards30 do
                            thisUnit = enemies.yards30[i]
                            if inCombat 
                                and (UnitIsPlayer(thisUnit) or not playertar)
                                and isValidUnit(thisUnit) 
                                and not isDummy(thisUnit) 
                                and canInterrupt(thisUnit,kickpercent)
                                and not immunDS
                                and not immunAotT
                            then  
                                -- Leap Dark Transormation
                                if getDistance(thisUnit) > 5
                                    and getDistance(thisUnit) < 30
                                then
                                    if talent.sludgeBelcher then
                                        if cast.hook(thisUnit) then waitforNextKick = GetTime(); print("Hook Kick"); kickCommited = true; return end
                                    elseif buff.darkTransformation.exists("pet")
                                    then
                                        if cast.leap(thisUnit) then waitforNextKick = GetTime(); print("Leap Kick"); kickCommited = true; return end
                                    end
                                end
                                -- Mind Freeze
                                if isChecked("Mind Freeze") 
                                   -- and cd.mindFreeze.remain() == 0 
                                    and getDistance(thisUnit) < 15 
                                    and getFacing("player",thisUnit) 
                                then
                                    if cast.mindFreeze(thisUnit) then waitforNextKick = GetTime(); print("Mind Freeze"); kickCommited = true; return end
                                end
                                --Asphyxiate
                                if isChecked("Asphyxiate Kick") 
                                    and talent.asphyxiate
                                    and getDistance(thisUnit) < 20 
                                    and getFacing("player",thisUnit) 
                                then
                                    if cast.asphyxiate(thisUnit) then waitforNextKick = GetTime(); print("Asphyxiate Kick"); kickCommited = true; return end
                                end
                                -- DeathGrip
                                if isChecked("Death Grip") 
                                    and getDistance("target") < 5
                                    and getFacing("player",thisUnit) 
                                then
                                    if cast.deathGrip(thisUnit) then waitforNextKick = GetTime(); print ("Grip Kick"); kickCommited = true; return end
                                end
                            end
                        end --endfor
                    end --Kick auf CD                
                end --Timer
            end -- End Use Interrupts Check
        end -- End Action List - Interrupts
    ---------------------------------------------------------------------------------------------------------------------------------
    -- Action List - Pet Management
    ---------------------------------------------------------------------------------------------------------------------------------
        local function actionList_PetManagement()
            if isChecked("Debug Info") then Print("actionList_PetManagement") end
            if not IsMounted() then
            --Corpse Shield
                if buff.corpseShield.exists() then
                    if talent.sludgeBelcher then
                        if cast.protectiveBile() then return end
                    else
                        if cast.huddle() then return end
                    end
                end
            --PetDismiss
                if getHP("pet") < 20 
                    and GetUnitExists("pet")
                    and not buff.corpseShield.exists() 
                then
                    print("Pet Dismiss - Low Health")
                    PetDismiss()
                end
            --Auto Summon
                if isChecked("Auto Summon") and not GetUnitExists("pet") and (UnitIsDead("pet") ~= nil or UnitIsDead("pet") == false) then
                    if waitForPetToAppear < GetTime() - 2 then
                        if cast.raiseDead() then waitForPetToAppear = GetTime(); return end
                    end
                end
            -- Pet Attack / retreat
                if  isChecked("Pet Attack") then
                    if inCombat and isValidUnit(units.dyn30) and getDistance(units.dyn30) < 30 then
                        if not UnitIsUnit("target","pettarget") and attacktar and not IsPetAttackActive() then
                            PetAttack()
                            PetAssistMode()
                        end
                    else
                        if IsPetAttackActive() then
                            PetStopAttack()
                            PetPassiveMode()
                        end
                    end
                end
            end
        end
    ---------------------------------------------------------------------------------------------------------------------------------
    -- Action List - Soul Reaper Debuff
    ---------------------------------------------------------------------------------------------------------------------------------
        local function actionList_SoulReaperDebuff()
        --Apocalypse
            if cd.apocalypse.remain() <= 0
                and debuff.festeringWound.stack("target") >= 7
                and not immun
                and not bop
            then
                if cast.apocalypse("target") then return end
            end
        --ScourgeStrike if Soulreaper
            if debuff.festeringWound.stack("target") >= 1
                and not immun
            then
                if talent.clawingShadows then
                    if cast.clawingShadows("target") then return end
                else
                    if cast.scourgeStrike("target") then return end
                end
            elseif not immun then
                if cast.festeringStrike("target") then return end
            end
        end
    ---------------------------------------------------------------------------------------------------------------------------------
    -- Action List - Soul Reaper
    ---------------------------------------------------------------------------------------------------------------------------------
        local function actionList_SoulReaper()
            if isChecked("Debug Info") then Print("actionList_SoulReaper") end
            if printevery2S then
               -- print(runicPowerDeficit, runicPower, runes)
            end
           
          
        --Soul Reaper if artifact == 0 and festeringWound > 6
            if debuff.festeringWound.stack("target") >= 7
                and cd.apocalypse.remain() <= 0
                and not immun
                and not bop
                and not cloak
            then 
                if cast.soulReaper("target") then return end
            end  
        --Apocalypse
            if cd.apocalypse.remain() <= 0
                and cd.soulReaper.remain() > 10
                and debuff.festeringWound.stack("target") >= 7
                and not immun
                and not bop
            then
                if cast.apocalypse("target") then return end
            end
        --ScourgeStrike spam DnD
            if buff.deathAndDecay.exists("player")
                and #enemies.yards10 > 2
                and runicPowerDeficit > 13
                and not immun
                and not cloak
            then
                if playertar and isChecked("Necro Spam") and dampeningCount >= getOptionValue("Necro Spam") then 
                    if cast.necroticStrike("target") then
                        return 
                    elseif talent.clawingShadows then
                        if cast.clawingShadows("target") then return end
                    else
                        if cast.scourgeStrike("target") then return end
                    end
                elseif talent.clawingShadows then
                    if cast.clawingShadows("target") then return end
                else
                    if cast.scourgeStrike("target") then return end
                end
            end      
        --ScourgeStrike if Scourge of Worlds / Necrosis
            if (debuff.scourgeOfWorlds.exists("target")  or buff.necrosis.exists("player"))
                and debuff.festeringWound.stack("target") > 1
                and runicPowerDeficit > 13
                and (not (cd.apocalypse.remain() == 0) or getDistance("target") > 5 )
                and not (cd.soulReaper.remain() < 5)
                and not immun
                and not cloak
            then
                if playertar and isChecked("Necro Spam") and dampeningCount >= getOptionValue("Necro Spam") then 
                    if cast.necroticStrike("target") then
                        return 
                    elseif talent.clawingShadows then
                        if cast.clawingShadows("target") then return end
                    else
                        if cast.scourgeStrike("target") then return end
                    end
                elseif talent.clawingShadows then
                    if cast.clawingShadows("target") then return end
                else
                    if cast.scourgeStrike("target") then return end
                end
            end           
        --Death Coil
            if (runicPower >= 80
                or (buff.suddenDoom.exists() and buff.suddenDoom.remain() < 8))
                and (not buff.necrosis.exists("player") or ((not br.player.artifact.doubleDoom.enabled() or buff.suddenDoom.stack("player") > 1) and buff.suddenDoom.remain() < 2) or runicPowerDeficit <= 20)
                and not immun
                and not cloak
            then
                if cast.deathCoil("target") then return end
            end
        --Festering Strike
            if ((debuff.festeringWound.stack("target") < 5)
                or (debuff.festeringWound.stack("target") < 8 and cd.apocalypse.remain() == 0))
                and not immun
                and not bop
                then
                if cast.festeringStrike("target") then return end
            end
        --Soul Reaper if not artifact== 0
            if debuff.festeringWound.stack("target") >= 3 
                and cd.soulReaper.remain() <= 0
                and not (cd.apocalypse.remain() <= 0) 
                and runes >= 3.6
                and not immun
                and not bop
                and not cloak
            then
                if cast.soulReaper("target") then return end
            end
        --Scourge
            if debuff.festeringWound.stack("target") > 3
                and (not (cd.soulReaper.remain() < 5) or runes > 4)
                and runes > 2
                and not immun
                and not cloak
            then
                if playertar and isChecked("Necrotic Strike") then 
                    if cast.necroticStrike("target") then 
                        return 
                    elseif talent.clawingShadows then
                        if cast.clawingShadows("target") then return end
                    else
                        if cast.scourgeStrike("target") then return end
                    end
                elseif talent.clawingShadows then
                    if cast.clawingShadows("target") then return end
                else
                    if cast.scourgeStrike("target") then return end
                end
            end
        --Clawing Shadow  is out of range
            if  talent.clawingShadows 
                and getDistance("target") > 5 
                and runes > 2 
                and not cloak
                and not immun
            then
                if cast.clawingShadows("target") then return end
            end
        --DeathCoil
            if getDistance("target") > 5 
                and not immun
                and not cloak
            then
                if cast.deathCoil("target") then return end
            end
        end
    ---------------------------------------------------------------------------------------------------------------------------------
    -- Action List - Dark Arbiter
    ---------------------------------------------------------------------------------------------------------------------------------
        local function actionList_PreDarkArbiter()
        --Apocalypse
            if cd.apocalypse.remain() <= 0
                and debuff.festeringWound.stack("target") >= 7
                and not immun
                and not bop
            then
                if cast.apocalypse("target") then return end
            end
        --ScourgeStrike if Scourge of Worlds / Death and Decay
            if (debuff.scourgeOfWorlds.exists("target") or buff.deathAndDecay.exists())
                and debuff.festeringWound.stack("target") > 1
                and runicPower < 90
                and (not (cd.apocalypse.remain() == 0) or getDistance("target") > 5)
                and not immun
                and not cloak
            then
                if playertar and isChecked("Necro Spam") and dampeningCount >= getOptionValue("Necro Spam") then 
                    if cast.necroticStrike("target") then
                        return 
                    elseif talent.clawingShadows then
                        if cast.clawingShadows("target") then return end
                    else
                        if cast.scourgeStrike("target") then return end
                    end
                elseif talent.clawingShadows then
                    if cast.clawingShadows("target") then return end
                else
                    if cast.scourgeStrike("target") then return end
                end
            end           
        --Death Coil
            if normalMob or cd.darkArbiter.remain() >= 5 then
                if runicPowerDeficit <= 20
                    or (buff.suddenDoom.exists() and buff.suddenDoom.remain() < 8)
                
                    and (not buff.necrosis.exists("player") or buff.suddenDoom.remain() < 2 or runicPowerDeficit < 20)
                    and not immun
                    and not cloak
                then
                    if cast.deathCoil("target") then return end
                end
            end
        --Festering Strike
            if ((debuff.festeringWound.stack("target") < 5)
                or (debuff.festeringWound.stack("target") < 8 and cd.apocalypse.remain() == 0))
                and not immun
                and not bop
                then
                if cast.festeringStrike("target") then return end
            end
        --Scourge
            if debuff.festeringWound.stack("target") > 3
                and runes > 2
                and not immun
                and not cloak
            then
                if playertar and isChecked("Necrotic Strike") then 
                    if cast.necroticStrike("target") then 
                        return 
                    elseif talent.clawingShadows then
                        if cast.clawingShadows("target") then return end
                    else
                        if cast.scourgeStrike("target") then return end
                    end
                elseif talent.clawingShadows then
                    if cast.clawingShadows("target") then return end
                else
                    if cast.scourgeStrike("target") then return end
                end
            end
        --Clawing Shadow  is out of range
            if  talent.clawingShadows 
                and getDistance("target") > 5 
                and runes > 2 
                and not cloak
                and not immun
            then
                if cast.clawingShadows("target") then return end
            end
        --DeathCoil
            if getDistance("target") > 5 
                and cd.darkArbiter.remain() >= 5
                and not immun
                and not cloak
            then
                if cast.deathCoil("target") then return end
            end
        end
    ---------------------------------------------------------------------------------------------------------------------------------
    -- Action List - Dark Arbiter exist
    ---------------------------------------------------------------------------------------------------------------------------------
        local function actionList_DarkArbiter()
            --Apocalypse
                if cd.apocalypse.remain() <= 0
                    and debuff.festeringWound.stack("target") >= 7
                    and runicPowerDeficit > 21
                    and not immun
                    and not bop
                then
                    if cast.apocalypse("target") then return end
                end
            --Dark Transformation
                if hasEquiped(137075)  then 
                    if cast.darkTransformation() then return end
                end
            --DeathCoil Dump        
                if not immun and not cloak
                then
                    if cast.deathCoil("target") then return end
                end
            --Festering Strike
                if runes >= 2 and debuff.festeringWound.stack("target") < 5 then
                    if cast.festeringStrike("target") then return end
                end
            --Scourge
                if playertar and isChecked("Necro Spam") and dampeningCount >= getOptionValue("Necro Spam") then 
                    if cast.necroticStrike("target") then
                        return 
                    elseif talent.clawingShadows then
                        if cast.clawingShadows("target") then return end
                    else
                        if cast.scourgeStrike("target") then return end
                    end
                elseif talent.clawingShadows then
                    if cast.clawingShadows("target") then return end
                else
                    if cast.scourgeStrike("target") then return end
                end
                
        end
    ---------------------------------------------------------------------------------------------------------------------------------
    -- Action List -Generic
    ---------------------------------------------------------------------------------------------------------------------------------
        local function actionList_Generic()
            --ScourgeStrike spam DnD
            if buff.deathAndDecay.exists("player")
                and #enemies.yards10 > 2
                and not immun
                and not cloak
            then
                if playertar and isChecked("Necro Spam") and dampeningCount >= getOptionValue("Necro Spam") then 
                    if cast.necroticStrike("target") then
                        return 
                    elseif talent.clawingShadows then
                        if cast.clawingShadows("target") then return end
                    else
                        if cast.scourgeStrike("target") then return end
                    end
                elseif talent.clawingShadows then
                    if cast.clawingShadows("target") then return end
                else
                    if cast.scourgeStrike("target") then return end
                end
            end  
            --Death Coil
            if (runicPower >= 80
                or (buff.suddenDoom.exists() and buff.suddenDoom.remain() < 8))
                and ((not buff.necrosis.exists("player") or buff.suddenDoom.remain() < 2) or runicPowerDeficit >= 20)
                and not immun
                and not cloak
            then
                if cast.deathCoil("target") then return end
            end
            --Festering Strike
            if ((debuff.festeringWound.stack("target") < 5)
                or (debuff.festeringWound.stack("target") < 8 and cd.apocalypse.remain() == 0))
                and not immun
                and not bop
                then
                if cast.festeringStrike("target") then return end
            end
            --Scourge
            if debuff.festeringWound.stack("target") > 3
                and (not (cd.soulReaper.remain() < 5) or runes > 4)
                and runes > 2
                and not immun
                and not cloak
            then
                if playertar and isChecked("Necrotic Strike") then 
                    if cast.necroticStrike("target") then 
                        return 
                    elseif talent.clawingShadows then
                        if cast.clawingShadows("target") then return end
                    else
                        if cast.scourgeStrike("target") then return end
                    end
                elseif talent.clawingShadows then
                    if cast.clawingShadows("target") then return end
                else
                    if cast.scourgeStrike("target") then return end
                end
            end
            --Clawing Shadow  is out of range
            if  talent.clawingShadows 
                and getDistance("target") > 5 
                and runes > 2 
                and not cloak
                and not immun
            then
                if cast.clawingShadows("target") then return end
            end
            --DeathCoil
            if getDistance("target") > 5 
                and not immun
                and not cloak
            then
                if cast.deathCoil("target") then return end
            end
        end
-----------------
--- Rotations ---
-----------------
        -- Pause
        if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or mode.rotation == 4 then
            if isChecked("Debug Info") then Print("Rotation Pause") end
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                if isChecked("Debug Info") then Print("OOC") end
                startDampeningTimer = false
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat and not IsMounted() and getBuffRemain("player", 192002 ) < 10 then
                if isChecked("Debug Info") then Print("inCombat") end

                if debuff.dampening ~= nil then
                    if actionList_DebuffReader() then return end
                end

                if isChecked("Eye of Leotheras") and UnitDebuff("player","Eye Of Leotheras") ~= nil then
                    ClearTarget()
                    Print("Warning : Eye of Leotheras detected")
                    return
                end

                if isChecked("Auto Target") 
                    and not GetUnitExists("target")
                    or (not UnitIsEnemy("target", "player") and not UnitIsDeadOrGhost("target")) 
                then
                    if #enemies.yards8 > 0 and UnitAffectingCombat(enemies.yards8[1]) then
                        TargetUnit(enemies.yards8[1])
                    end
                end

            ---------------------------
            --- Queue Casting
            ---------------------------
                if isChecked("Queue Casting") and not UnitChannelInfo("player") then
                    -- Catch for spells not registering on Combat log
                    if castQueue() then return end
                end
            ---------------------------
            --- SoulReaper          ---
            ---------------------------
                if talent.soulReaper and debuff.soulReaper.exists("target") and buff.soulReaper.stack("player") < 3  then
                    if actionList_SoulReaperDebuff() then return end
                else             
                ---------------------------
                --- Extras              ---
                ---------------------------
                    if actionList_Extras() then return end
                ---------------------------
                --- Cooldowns           ---
                ---------------------------
                    if actionList_Cooldowns() then return end
                ---------------------------
                --- Interrupt           ---
                ---------------------------
                   if actionList_Interrupts() then return end
                ---------------------------
                --- Pet Logic           ---
                ---------------------------
                    if actionList_PetManagement() then return end
                ---------------------------
                --- Defensive Rotation  ---
                ---------------------------
                    if actionList_Defensive() then return end
                ---------------------------
                --- Dark Arbiter Exist  ---
                ---------------------------
                    if talent.darkArbiter then
                        if GetObjExists(100876) then
                            if actionList_DarkArbiter() then return end
                        else
                            if actionList_PreDarkArbiter() then return end
                        end                
                ---------------------------
                --- Soul Reaper         ---
                ---------------------------
                    elseif talent.soulReaper then
                        if actionList_SoulReaper() then return end
                    else
                        if actionList_Generic() then return end
                    end
                ---------------------------
                --- Queue               ---
                ---------------------------
                    if #br.player.queue ~= 0 and isChecked("SpellQueue Clear") then
                        for i = 1, #br.player.queue do
                            if br.player.queue[i].name == nil then
                                tremove(br.player.queue,i)
                            elseif getSpellCD(br.player.queue[i].name) >=  getOptionValue("SpellQueue Clear") then
                                Print("Removed |cFFFF0000"..br.player.queue[i].name.. "|r cause CD")
                                tremove(br.player.queue,i)
                            end
                        end
                    end
                end

                if isChecked("Debug Info") then uncheck("Debug Info") end
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation 
local id = 0 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
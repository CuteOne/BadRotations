local rotationName = "immy"
immy = true

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "", value = 1 , overlay = "DPS Rotation Enabled", tip = "Enable DPS Rotation", highlight = 1, icon = br.player.spell.toxicBlade},
        [2] = { mode = "", value = 2 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.crimsonVial}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button

-- Blade Flurry Button
    CleaveModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "Cleave on.", highlight = 1, icon = br.player.spell.rupture},
        [2] = { mode = "", value = 2 , overlay = "", tip = "Cleave off.", highlight = 0, icon = br.player.spell.rupture}
    };
    CreateButton("Cleave",2,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.kick},
        [2] = { mode = "", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.kick}
    };
    CreateButton("Interrupt",3,0)
    SpecialModes = {
      [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.vendetta},
      [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.vendetta},
    };
    CreateButton("Special",4,0)     

    OpenerModes = {
      [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.garrote},
      [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.garrote},
    };
    CreateButton("Opener",4,1)

    FeintModes = {
      [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.feint},
      [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.feint},
    };
    CreateButton("Feint",5,1)

    TBExModes = {
      [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.exsanguinate},
      [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.exsanguinate},
    };
    CreateButton("TBEx",5,0)      

   
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
            br.ui:createDropdown(section, "Stealth", {"|cff00FF00Always", "|cffFF000020Yards"},  2, "Stealthing method.")
            br.ui:createCheckbox(section, "Debug")
        br.ui:checkSectionState(section)
        ------------------------
        --- OFFENSIVE OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Offensive")
                -- Trinkets
            br.ui:createCheckbox(section, "Trinkets")
            br.ui:createCheckbox(section, "Galecaller")
            br.ui:createCheckbox(section, "Racial")
            br.ui:createCheckbox(section, "No Pooling")
            br.ui:createCheckbox(section, "Apply Deadly Poison in melee")
            --br.ui:createCheckbox(section, "Toxic Blade/Exsa")
            br.ui:createCheckbox(section, "Opener refresh")
            br.ui:createCheckbox(section, "Toxic Blade on cd")
            br.ui:createSpinnerWithout(section, "Dots HP Limit", 15, 0, 105, 1, "|cffFFFFFFHP *10k hp for dots to be AOE casted/refreshed on.")
            br.ui:createSpinnerWithout(section, "Max Garrotes refresh SS",  3,  1,  6,  1,  "max garrotes ss")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            br.ui:createSpinner(section, "Healing Potion/Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            br.ui:createSpinner(section, "Crimson Vial",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            br.ui:createSpinner(section, "Feint", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            br.ui:createSpinner(section, "Evasion",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            br.ui:createCheckbox(section, "Kick")
            br.ui:createCheckbox(section, "Kidneyshot")
            br.ui:createCheckbox(section, "Blind")
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
        UpdateToggle("Interrupt",0.25)
        br.player.mode.interrupt = br.data.settings[br.selectedSpec].toggles["Interrupt"]
        UpdateToggle("Cleave",0.25)
        br.player.mode.cleave = br.data.settings[br.selectedSpec].toggles["Cleave"]        
        UpdateToggle("Opener",0.25)
        br.player.mode.opener = br.data.settings[br.selectedSpec].toggles["Opener"]        
        UpdateToggle("Feint",0.25)
        br.player.mode.feint = br.data.settings[br.selectedSpec].toggles["Feint"]
        UpdateToggle("TBEx",0.25)
        br.player.mode.tbex = br.data.settings[br.selectedSpec].toggles["TBEx"]
        UpdateToggle("Special",0.25)
        br.player.mode.special = br.data.settings[br.selectedSpec].toggles["Special"]        

--------------
--- Locals ---
--------------
        if profileStop == nil then profileStop = false end
        local attacktar                                     = UnitCanAttack("target","player")
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local cd                                            = br.player.cd
        local combo, comboDeficit, comboMax                 = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
        local combospend                                    = ComboMaxSpend()
        local cTime                                         = getCombatTime()
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local gcd                                           = getSpellCD(61304)
        local hastar                                        = GetObjectExists("target")
        local healPot                                       = getHealthPot()
        local inCombat                                      = isInCombat("player")
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local mode                                          = br.player.mode
        local multidot                                      = (br.player.mode.cleave == 1 or br.player.mode.rotation == 2) and br.player.mode.rotation ~= 3
        local php                                           = br.player.health
        local power, powerDeficit, powerRegen               = br.player.power.energy.amount(), br.player.power.energy.deficit(), br.player.power.energy.regen()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local solo                                          = #br.friend < 2
        local spell                                         = br.player.spell
        local stealth                                       = br.player.buff.stealth.exists()
        local stealthingAll                                 = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowmeld.exists()
        local stealthingRogue                               = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or (br.player.buff.subterfuge.exists() and br.player.buff.subterfuge.remain() >= 0.3)
        local stealthingMantle                              = br.player.buff.stealth.exists() or br.player.buff.vanish.exists()
        local talent                                        = br.player.talent
        local trait                                         = br.player.traits
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.energy.ttm()
        local units                                         = br.player.units
        local lootDelay                                     = getOptionValue("LootDelay")



        --if stealthingRogue then print(br.player.buff.subterfuge.remain()) end

        dotHPLimit = getOptionValue("Dots HP Limit") * 10000
        

        units.get(5)
        units.get(20)
        enemies.get(5)
        enemies.get(9)
        enemies.get(20)

        if GetUnitExists("target") and #br.player.enemies.yards5 > 1 then
            table.sort(br.player.enemies.yards5, function(x,y)
                return UnitHealth(x) > UnitHealth(y)
            end)

            table.sort(br.player.enemies.yards5, function(x)
                if  GetUnitIsUnit(x, "target") then
                    return true
                else
                    return false
                end
            end)
        end      
        
        local function bleedscount()
            local counter = 0
            for k, v in pairs(br.enemy) do
            local thisUnit = br.enemy[k].unit
        -- check if unit is valid
                if GetObjectExists(thisUnit) then
            -- increase counter for each occurences
                    if UnitDebuffID(thisUnit,703,"player") and UnitDebuffID(thisUnit,2818,"player") then
                    counter = counter + 1
                    end   
                    if UnitDebuffID(thisUnit,1943,"player") and UnitDebuffID(thisUnit,2818,"player") then
                    counter = counter + 1
                    end
                end
            end
            return tonumber(counter)
        end

        --print(bleedscount())
        --if ssbug == nil then ssbug = 0 end
        local singleTarget = ((mode.rotation == 1 and #enemies.yards9 < 2) or (mode.rotation == 3 and #enemies.yards9 > 0))

        --local bleeds = debuff.garrote.count() + debuff.rupture.count()
            --Energy_Regen_Combined = Player:EnergyRegen() + Rogue.PoisonedBleeds() * 7 / (2 * Player:SpellHaste());

        local energyRegenCombined = powerRegen + bleedscount() * 7 / (2*1/(1+(GetHaste()/100)))
        --print(energyRegenCombined)
        local BleedTickTime, ExsanguinatedBleedTickTime = 2 / GetHaste(), 1 / GetHaste()

        if mode.opener == 2 or opener == nil then
            RUP1 = false
            GAR1 = false
            VEN1 = false
            MUTI1 = false
            RUP2 = false
            EXS1 = false
            opener = false
            if isChecked("Opener refresh") then
            toggle("Opener",1)
            end
        end
        

        -- if ssbuggy ~= nil then
        -- print(ssbuggy)
        -- end
        -- if ssbuggytime ~= nil then
        --     if GetTime() >= ssbuggytime + ssbuggytime1
        --         then ssbug = 0 
        --     end
        -- end
 

        -- local function ngs()
        --         local counter = 0
        --         for i = 1, #enemies.yards40 do
        --                     local thisUnit = enemies.yards40[i]
        --                     if debuff.garrote.applied(thisUnit) > 1 and debuff.garrote.exists(thisUnit) then 
        --                         counter = counter + 1
        --                     end
        --         end
        --     return tonumber(counter)
        -- end
        -- print(ngs())
        --if ngs() == 0 then ssbug = false end

        local ttdval = #enemies.yards9 <= 1 and 4 or 12
        --if getCombatTime() == 0 or cast.last.vanish() then garrotecountbuff = debuff.garrote.remainCount(1) end

        local function waitshit()
            if (mode.special == 2 and (not isBoss() or isDummy())) or mode.special == 1 then
                 return true
            else
                return false
            end
        end




    --     local function Evaluate_Garrote_Target(unit)
    --   return TargetUnit:DebuffRefreshableP(S.Garrote, 5.4)
    --     and (TargetUnit:PMultiplier(S.Garrote) <= 1 or TargetUnit:DebuffRemainsP(S.Garrote) <= (HL.Exsanguinated(TargetUnit, "Garrote") and ExsanguinatedBleedTickTime or BleedTickTime) and EmpoweredDotRefresh())
    --     and (not HL.Exsanguinated(TargetUnit, "Garrote") or TargetUnit:DebuffRemainsP(S.Garrote) <= 1.5 and EmpoweredDotRefresh())
    --     and Rogue.CanDoTUnit(TargetUnit, GarroteDMGThreshold);
    -- end
        --local lowestDot = debuff.garrote.lowest(5,"remain")

        local function EmpoweredDotRefresh()
            return #enemies.get(9) >= 3 + (trait.shroudedSuffocation.active() and 1 or 0)
        end
        
            SLASH_SPECIAL1 = "/bursterino"
            SlashCmdList["SPECIAL"] = function(msg)
            if mode.special == 2 then
                    if toggle("Special",1) then return true end
                end
            end         


        local function usefiller() 
           -- return ((comboDeficit > 1 and debuff.garrote.remain("target") > 4) or powerDeficit <= 25 + energyRegenCombined or not singleTarget) and true or false
           return (comboDeficit > 1 or powerDeficit <= 25 + energyRegenCombined or not singleTarget) and true or false
        end

        -- local function bfrange()
        --     if talent.acrobaticStikes then return #enemies.get(9) end
        --     else return #enemies.get(6) end
        -- end

        if leftCombat == nil then leftCombat = GetTime() end
        --if vanishTime == nil then vanishTime = GetTime() end

        

        
--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        --[[local function actionList_Extras()
        end -- End Action List - Extras]]
    -- Action List - DefensiveModes
        local function actionList_Defensive()
            SLASH_FEINT1 = "/feinterino"
            SlashCmdList["FEINT"] = function(msg)
            if not buff.feint.exists() or (buff.feint.exists() and buff.feint.remain() <= 0.8) or isDeBuffed("player", 230139) and mode.feint == 2 then
                    if toggle("Feint",1) then return end
                end
            end 
            -- Feint
                if mode.feint == 1 and not buff.feint.exists() then
                    if cast.feint() and toggle("Feint",2) then return end
                end

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
                if cast.able.crimsonVial() and isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") then
                    if cast.crimsonVial() then return end
                end
            -- Feint
                if cast.able.feint() and isChecked("Feint") and php <= getOptionValue("Feint") and inCombat and not buff.feint then
                    if cast.feint() then return end
                end
            -- Evasion
                if cast.able.evasion() and isChecked("Evasion") and php <= getOptionValue("Evasion") and inCombat then
                    if cast.evasion() then return end
                end
            end
        end -- End Action List - Defensive

        local function actionList_Stealthed()            
                        


                if talent.subterfuge then
                    if cast.able.garrote() then

                        -- if buff.subterfuge.remain() <= 1.4 and buff.subterfuge.remain() >= 0.4 and debuff.garrote.remain() < 18 and debuff.garrote.exists() and cd.vanish.remain() >= 110 then
                        --     if cast.garrote("target") then print("last sec subt garr"); return true end
                        -- end
                        -- --# Subterfuge: Override normal Garrotes with snapshot versions
                        -- --actions.stealthed+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&remains<=10&pmultiplier<=1&target.time_to_die-remains>2
                        -- if buff.subterfuge.remain() <= 1.2 and buff.subterfuge.remain() >= 0.4 and debuff.garrote.remain() < 5.4 and debuff.garrote.exists() then
                        --     if cast.garrote() then print("last sec subt garrote target"); return true end
                        -- end

                        for i = 1, #enemies.yards5 do
                            local thisUnit = enemies.yards5[i]
                            if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                if debuff.garrote.remain(thisUnit) < 5.4 and debuff.garrote.exists(thisUnit)
                                    and (getOptionCheck("Enhanced Time to Die") and ttd(thisUnit) > 5 or true)
                                    then
                                    if cast.garrote(thisUnit) then 
                                        if isChecked("Debug") then print("refresh garrote stealth") end
                                    return true end
                                end
                            end
                        end

                        -- # Subterfuge + Shrouded Suffocation: Apply early Rupture that will be refreshed for pandemic.
                        -- actions.stealthed+=/rupture,if=talent.subterfuge.enabled&azerite.shrouded_suffocation.enabled&!dot.rupture.ticking
                        
                        -- if buff.subterfuge.remain() <= 1.2 and buff.subterfuge.remain() >= 0.2 and not debuff.garrote.exists() then
                        --     if cast.garrote() then 
                        --         if isChecked("Debug") then print("apply new garrote target") end
                        --     return true end
                        -- end

                        for i = 1, #enemies.yards5 do
                            local thisUnit = enemies.yards5[i]
                            if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                if not debuff.garrote.exists(thisUnit)
                                    and (getOptionCheck("Enhanced Time to Die") and ttd(thisUnit) > 5 or true)
                                    then
                                    if cast.garrote(thisUnit) then 
                                        if isChecked("Debug") then print("apply new garrote target stealth") end
                                    return true end
                                end
                            end
                        end


                    end
                end

                        if mode.special == 1 and cast.able.rupture() and combo >=4 and s((cd.exsanguinate.remain() <= 2 and talent.exsanguinate ) or not debuff.rupture.exists()) then
                            if isChecked("Debug") then print("refresh rupture subt cds toggle on") end
                            if cast.rupture() then return true end
                        end

                        for i = 1, #enemies.yards5 do
                            local thisUnit = enemies.yards5[i]
                            if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                if (combo == 4 and debuff.rupture.remain(thisUnit) < 6 or combo == 5 and debuff.rupture.remain(thisUnit) < 7.2 ) and cast.able.rupture()
                                    and (not debuff.rupture.exsang(thisUnit) or debuff.rupture.remain(thisUnit) <= ExsanguinatedBleedTickTime*2 and EmpoweredDotRefresh())
                                    and (getOptionCheck("Enhanced Time to Die") and ttd(thisUnit) > 12 or true) --and (ttd(thisUnit) > 4 - debuff.rupture.remain(thisUnit) or ttd(thisUnit) > 9999)
                                then
                                    if cast.able.rupture() then
                                        if cast.rupture(thisUnit) then 
                                        if isChecked("Debug") then print("rupture refresh subt") end
                                        return true end
                                    end
                                end
                            end
                        end


                        for i = 1, #enemies.yards5 do
                            local thisUnit = enemies.yards5[i]
                            if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                if combo >= 3 and not debuff.rupture.exists(thisUnit) and cast.able.rupture()
                                    and (getOptionCheck("Enhanced Time to Die") and ttd(thisUnit) > 12 or true) --and (ttd(thisUnit) > 4 - debuff.rupture.remain(thisUnit) or ttd(thisUnit) > 9999)
                                then
                                    if cast.able.rupture() then
                                        if cast.rupture(thisUnit) then 
                                        if isChecked("Debug") then print("rupture cp>=3 no rupt subt") end
                                        return true end
                                    end
                                end
                            end
                        end

                        for i = 1, #enemies.yards5 do
                            local thisUnit = enemies.yards5[i]
                            if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                if debuff.garrote.exists(thisUnit) and cast.able.garrote() and not debuff.rupture.exsang(thisUnit)
                                    then
                                    if cast.garrote(thisUnit) then 
                                        if isChecked("Debug") then print("apply garrote on rupt subt") end
                                    return true end
                                end
                            end
                        end

                        if cast.able.envenom() and combo == ComboMaxSpend()-1 then 
                            if cast.envenom() then return true end
                            if isChecked("Debug") then print("envenom stealth") end
                        end

                        return
        end        
    -- Action List - Interrupts
        local function actionList_Interrupts()
                for i = 1, #enemies.yards20 do
                    local thisUnit = enemies.yards20[i]
                    local distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) and hasThreat(thisUnit) then
                        if distance < 5 then
                            if cast.able.kick() and isChecked("Kick") then
                                if cast.kick(thisUnit) then return end
                            end
                            if cd.kick.remain() ~= 0 or not cast.able.kick() then
                                if cast.able.kidneyShot() and combo > 0 and isChecked("Kidneyshot") then
                                    if cast.kidneyShot(thisUnit) then return end
                                end                                                                
                            end
                        end
                        if  (distance >= 5 and distance < 15) or (not cast.able.kick() and not cast.able.kidneyShot())
                         then
                            if cast.able.blind() and isChecked("Blind") then
                                if cast.blind(thisUnit) then return end
                            end
                        end
                    end
                end
        end -- End Action List - Interrupts
        local function actionList_Special()


                    if mode.tbex == 1 then
                        
                        if debuff.garrote.applied(GetObjectWithGUID(UnitGUID("target"))) < 1.8 and not debuff.garrote.exsang(GetObjectWithGUID(UnitGUID("target"))) and debuff.garrote.remain("target") < 6 and cast.able.vanish() and not cd.garrote.exists() then
                            if gcd >= 0.5 then return true end
                            if power <= 70 then return true end
                            if isChecked("Debug") then print("vanish tb cd") end
                            if cast.vanish() then 
                                if actionList_Stealthed() then return end
                            end
                        end
                    end

                    if isChecked("Toxic Blade on cd") and getDistance("target") <= 5  then
                        

                        if cast.able.toxicBlade() and not stealthingRogue then 
                            if cast.toxicBlade() then return end
                        end

                    end


                    if isChecked("Apply Deadly Poison in melee") then
                            for i = 1, #enemies.yards5 do
                                local thisUnit = enemies.yards5[i]
                                    if UnitDebuffID(thisUnit,268756) or
                                        ((debuff.garrote.exists(thisUnit) or debuff.rupture.exists(thisUnit)) and not debuff.deadlyPoison.exists(thisUnit))
                                      then
                                        --print("refresh poison melee")
                                        local firsttarget = GetObjectWithGUID(UnitGUID("target"))
                                        CastSpellByID(6603,thisUnit)
                                        CastSpellByID(6603,firsttarget)
                                    end
                            end
                    end


            -- if getDistance(units.dyn5) <= 5 then

            --     if not debuff.garrote.exists("target") and comboDeficit >= 2 then
            --         if cast.vanish() then end
            --         if cast.garrote() then return end
            --     end            
            -- --pool for vanish
            -- if cd.vendetta.remain() > 0 and cd.exsanguinate.remain() > 0 and not cd.garrote.exists() and ((debuff.garrote.applied("target") > 1 and debuff.garrote.remain("target") < gcd) or not debuff.garrote.exists("target")) and comboDeficit >= 2 then
            --     if debuff.garrote.remain("target") > 0 then return true end

            -- end


            -- end
            -- if cd.vendetta.remain() > 0 and cd.exsanguinate.remain() > 0 and not cd.garrote.exists() and not debuff.garrote.exists("target") then
            --     if comboDeficit >= 2 and not debuff.garrote.exists() then

            -- end



            -- if stealthingRogue and debuff.garrote.exists() and combo==ComboMaxSpend() and debuff.rupture.refresh() then
            --     if cast.rupture() then return end
            -- end

            -- if stealthingRogue and (cast.last.rupture() or comboDeficit >= 2) then
            --     if cast.garrote() then return end
            -- end
        end
        local function actionList_Open()
            --if (opener == false and time < 1) and (isDummy("target") or isBoss("target")) and (cd.vanish > 0 or not buff.shadowBlades.exists()) then Print("Opener failed due do cds"); opener = true end
            if trait.shroudedSuffocation.rank() > 0 then
                if talent.exsanguinate then
                        if not RUP1 and cast.able.rupture() then
                            if cast.rupture() then RUP1 = true; end
                        elseif RUP1 and not GAR1 and cast.able.garrote() then
                            if cast.garrote() then GAR1 = true; end
                        elseif GAR1 and not VEN1 and cast.able.vendetta() then
                            if canUse(13) then
                               useItem(13)
                            end
                            if canUse(14) then
                               useItem(14)
                            end
                            if cast.vendetta() then VEN1 = true; end
                        elseif VEN1 and not MUTI1 and cast.able.mutilate() then
                            if cast.mutilate() then MUTI1 = true; end
                        elseif MUTI1 and not RUP2 and cast.able.rupture() then
                            if cast.rupture() then RUP2 = true; end
                        elseif RUP2 and not EXS1 and cast.able.exsanguinate() then
                            if cast.exsanguinate() then EXS1 = true; end
                            Print("Opener Complete")
                            opener = true
                            toggle("Opener",2)
                            return true
                        end
                    end
                if talent.toxicBlade then
                        if not RUP1 and cast.able.rupture() then
                            if cast.rupture() then RUP1 = true; end
                        elseif RUP1 and not GAR1 and cast.able.garrote() then
                            if cast.garrote() then GAR1 = true; end
                        elseif GAR1 and not VEN1 and cast.able.vendetta() then
                            if canUse(13) then
                               useItem(13)
                            end
                            if canUse(14) then
                               useItem(14)
                            end
                            if cast.vendetta() then VEN1 = true; end
                        elseif VEN1 and not MUTI1 and cast.able.toxicBlade() then
                            if cast.toxicBlade() then MUTI1 = true; end
                        elseif MUTI1 and not RUP2 and cast.able.envenom() then
                            if cast.envenom() then RUP2 = true; end
                        elseif RUP2 and not EXS1 and cast.able.mutilate() then
                            if cast.mutilate() then EXS1 = true; end
                            Print("Opener Complete")
                            opener = true
                            toggle("Opener",2)
                            return true
                        end
                end                
            end

            if trait.shroudedSuffocation.rank() <= 0 then
                if talent.exsanguinate then
                        if not RUP1 and cast.able.rupture() then
                            if cast.rupture() then RUP1 = true; end
                        elseif RUP1 and not GAR1 and cast.able.garrote() then
                            if cast.garrote() then GAR1 = true;
                             end
                        elseif GAR1 and not VEN1 and cast.able.vendetta() then
                            if canUse(13) then
                               useItem(13)
                            end
                            if canUse(14) then
                               useItem(14)
                            end
                            if cast.vendetta() then VEN1 = true; end
                        elseif VEN1 and not MUTI1 and cast.able.mutilate() then
                            if cast.mutilate() then MUTI1 = true; end
                        elseif MUTI1 and not RUP2 and cast.able.rupture() then
                            if cast.rupture() then RUP2 = true; end
                        elseif RUP2 and not EXS1 and cast.able.exsanguinate() then
                            if cast.exsanguinate() then EXS1 = true; end
                            Print("Opener Complete")
                            opener = true
                            toggle("Opener",2)
                            return true
                        end
                end
                if talent.toxicBlade then
                        if  combo < 4 and not GAR1 and cast.able.mutilate() then
                            if cast.mutilate() then RUP1 = true; end
                        elseif not GAR1 and combo >= 4 and cast.able.rupture() then
                            if cast.rupture() then GAR1 = true; end
                        elseif GAR1 and not VEN1 and cast.able.vendetta() then
                            if canUse(13) then
                               useItem(13)
                            end
                            if canUse(14) then
                               useItem(14)
                            end
                            if cast.vendetta() then VEN1 = true; end
                        elseif VEN1 and not MUTI1 and cast.able.mutilate() then
                            if cast.mutilate() then MUTI1 = true; end
                        elseif MUTI1 and not RUP2 and cast.able.toxicBlade() then
                            if cast.toxicBlade() then RUP2 = true; end
                            Print("Opener Complete")
                            opener = true
                            toggle("Opener",2)
                            return true
                        end
                end                
            end            
            
        end
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            if getDistance("target") < 5 then
            if mode.special == 1 then
                if talent.exsanguinate then
                    

                    if not debuff.rupture.exists() and combo >= 2 then 
                        if isChecked("Debug") then print("new rupt cd") end
                        if cast.rupture() then return true end
                    end

                    if cast.able.garrote() and not debuff.garrote.exsang(GetObjectWithGUID(UnitGUID("target"))) and debuff.garrote.applied(GetObjectWithGUID(UnitGUID("target"))) <= 1 and debuff.garrote.remain() <= 12 and cd.vanish.remain() >= 5 then
                        if isChecked("Debug") then print("garrote new cd") end
                        if cast.garrote() then return true end
                    end

                    if cd.exsanguinate.remain() <= 5 and debuff.garrote.remain() > 10 and combo >= 4 and debuff.rupture.remain("target") <= 20 and cast.able.rupture() then
                        if isChecked("Debug") then print("rupt before exsa cd") end
                        if cast.rupture() then return true end
                    end

                    if power <= 30 and cast.able.vendetta() then
                            if isChecked("Trinkets") then
                                if canUse(13) then
                                    useItem(13)
                                end
                                if canUse(14) then
                                    useItem(14)
                                end
                            end                  
                        if isChecked("Debug") then print("vendetta power use cd") end  
                        if cast.vendetta() then return true end
                    end
                    
                    if not cd.garrote.exists() and (debuff.garrote.applied(GetObjectWithGUID(UnitGUID("target"))) <= 1 or debuff.garrote.remain() <= 5.4) and cast.able.vanish() and not debuff.garrote.exsang(GetObjectWithGUID(UnitGUID("target"))) then 
                        if gcd >= 0.2 then return true end
                        if isChecked("Debug") then print("vanish cd exsa") end
                        if cast.vanish() then 
                            if actionList_Stealthed() then return true end
                        end
                    end

                    if debuff.garrote.remain() >= 5.4 and debuff.rupture.remain() >= 4 + (4 * comboMax) and (debuff.vendetta.exists() or cd.vendetta.remain() >=5) and (debuff.garrote.applied(GetObjectWithGUID(UnitGUID("target"))) <= 1 or cd.vanish.remain() >= 5) then
                            if isChecked("Galecaller") then
                                -- use_item,name=galecallers_boon,if=cooldown.vendetta.remains<=1&(!talent.subterfuge.enabled|dot.garrote.pmultiplier>1)|cooldown.vendetta.remains>45
                                if canUse(13) and hasEquiped(159614, 13) then
                                    useItem(13)
                                end
                                if canUse(14) and hasEquiped(159614, 14) then
                                    useItem(14)
                                end
                            end
                        if isChecked("Debug") then print("exsa cd") end
                        if cast.exsanguinate() then return true end
                    end

                    if cast.able.vendetta() then
                            if isChecked("Trinkets") then
                                if canUse(13) then
                                    useItem(13)
                                end
                                if canUse(14) then
                                    useItem(14)
                                end
                            end
                        if isChecked("Debug") then print("vendetta cd") end
                        if cast.vendetta() then return true end
                    end

                    if cd.vanish.remain() >= 5 and cd.vendetta.remain() >= 5 and cd.exsanguinate.remain() >= 5 then
                        toggle("Special",2)
                    end
                end

                if talent.toxicBlade then

                     if cast.able.vendetta() then
                            if isChecked("Trinkets") then
                                if canUse(13) then
                                    useItem(13)
                                end
                                if canUse(14) then
                                    useItem(14)
                                end
                            end
                        if isChecked("Debug") then print("vendetta tb talent cd") end
                        if cast.vendetta() then return true end
                    end

                    if cast.able.toxicBlade() then
                        if isChecked("Debug") then print("tb cd") end
                        if cast.toxicBlade() then return true end
                    end

                    if not cd.garrote.exists() and (debuff.garrote.applied(GetObjectWithGUID(UnitGUID("target"))) <= 1 or debuff.garrote.remain() <= 5.4) and cast.able.vanish() then 
                        if gcd >= 0.5 then return true end
                        if power <= 70 then return true end
                        if isChecked("Debug") then print("vanish tb cd") end
                        if cast.vanish() then 
                            if actionList_Stealthed() then return end
                        end
                    end

                    if cd.vanish.remain() >= 5 and cd.vendetta.remain() >= 5 and cd.toxicBlade.remain() >= 5 then
                        toggle("Special",2)
                    end
                end
            end
            end

        end -- End Action List - Cooldowns
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not stealth and cast.able.stealth() then
                if isChecked("Stealth") and (not IsResting() or isDummy("target")) then
                    if getOptionValue("Stealth") == 1 then
                        if cast.stealth("player") then return end
                    end
                    if #enemies.yards20 > 0 and getOptionValue("Stealth") == 2 and not IsResting() and GetTime()-leftCombat > lootDelay then
                        for i = 1, #enemies.yards20 do
                            local thisUnit = enemies.yards20[i]
                            if UnitIsEnemy(thisUnit,"player") or isDummy("target") then
                                if cast.stealth("player") then return end
                            end
                        end
                    end
                end
            end



            if not inCombat and buff.deadlyPoison.remain() <= 600 then
                if cast.deadlyPoison("player") then return end
            end
        end -- End Action List - PreCombat

        local function actionList_Dot()
       
            if not cd.garrote.exists() then
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                        --print(debuff.garrote.remain(thisUnit))+
                            if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                    if debuff.garrote.remain(thisUnit) < 5.4   
                                        and debuff.garrote.applied(thisUnit) <= 1 
                                        and (not debuff.garrote.exsang(thisUnit) or (debuff.garrote.remain(thisUnit) <= ExsanguinatedBleedTickTime*2 and EmpoweredDotRefresh()))
                                    and (getOptionCheck("Enhanced Time to Die") and (ttd(thisUnit) > ttdval - debuff.garrote.remain(thisUnit) or ttd(thisUnit) > 20) or true)
                                    and (mode.special == 2 or (mode.special == 1 and cd.vanish.exists())) 
                                    then
                                        if comboDeficit >= 1 then
                                            if (cast.pool.garrote() or ((debuff.garrote.exsang(thisUnit) or debuff.garrote.applied(thisUnit) > 1) and debuff.garrote.remain(thisUnit) <= 1 )) and debuff.garrote.count() <= 1 then return true end
                                                if isChecked("Debug") then print("garrote dot") end
                                                if cast.garrote(thisUnit) then return true end
                                        elseif comboDeficit <= 0 and debuff.rupture.remain(thisUnit) <= 7.2 and #enemies.yards5 <= 1 then
                                                if isChecked("Debug") then print("rip for garrote refresh") end
                                                if cast.rupture(thisUnit) then return end
                                        elseif comboDeficit <= 0 and #enemies.yards5 <= 1 then
                                                if isChecked("Debug") then print("env for garrote refresh") end
                                                if cast.envenom("target") then return end
                                            end
                                        end
                            end
                    end
            end
        

        
         -- actions.dot+=/crimson_tempest,if=spell_targets>=2&remains<2+(spell_targets>=5)&combo_points>=4

        if cast.able.crimsonTempest() and talent.crimsonTempest and combo >=4 and #enemies.yards9 >= 2 and debuff.crimsonTempest.remain(units.dyn5) < 2 + (#enemies.yards9 >= 5 and 1 or 0) then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                        if power < 35 then return true end
                        if getDistance(thisUnit) < 5 then
                            if isChecked("Debug") then print("ct dot") end
                            if cast.crimsonTempest("player") then return true end
                        end
                    end
                end
        end

        if combo >= 4 then

            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                        if (combo == 4 and debuff.rupture.remain(thisUnit) < 6 or combo == 5 and debuff.rupture.remain(thisUnit) < 7.2 ) 
                        and (debuff.rupture.applied(thisUnit) <= 1 or (debuff.rupture.remain(thisUnit) <= (debuff.rupture.exsang(thisUnit) and ExsanguinatedBleedTickTime or BleedTickTime) and EmpoweredDotRefresh()))
                        and (not debuff.rupture.exsang(thisUnit) or debuff.rupture.remain(thisUnit) <= ExsanguinatedBleedTickTime*2 and EmpoweredDotRefresh()) --and (ttd(thisUnit) > 4 - debuff.rupture.remain(thisUnit) or ttd(thisUnit) > 9999)
                        and (getOptionCheck("Enhanced Time to Die") and ttd(thisUnit) > 6 or true)
                        then
                            if cast.able.rupture() then
                                if isChecked("Debug") then print("rupture dot") end
                                if cast.rupture(thisUnit) then return true end
                            end
                        end
                end
            end
        end

        if cast.able.envenom() and combo >= ComboMaxSpend() - 1  and (debuff.vendetta.exists("target") or debuff.rupture.exsang(units.dyn5) or debuff.toxicBlade.exists("target") or
         (talent.elaboratePlanning and buff.elaboratePlanning.exists() and buff.elaboratePlanning.remain() <= 0.3) or powerDeficit <= 25 + energyRegenCombined or #enemies.yards5 >= 2)
         and (not talent.exsanguinate or cd.exsanguinate.remain() > 2 or mode.special == 2)
         and not (debuff.rupture.exsang(units.dyn5) and debuff.rupture.remain() <= 2)
          then
            if isChecked("Debug") then print("envenom dot") end
            if cast.envenom() then return true end
        end

        end -- End Action List - Build

        local function actionList_Direct()   
        -- actions.direct=envenom,if=combo_points>=4+talent.deeper_stratagem.enabled&(debuff.vendetta.up|debuff.toxic_blade.up|energy.deficit<=25+variable.energy_regen_combined|spell_targets.fan_of_knives>=2)&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)

        
        --pooling shit

        if cast.able.fanOfKnives() and (buff.hiddenBlades.stack() >= 19 or #enemies.yards9 >= 4 + (stealthingRogue and 1 or 0) + (trait.DoubleDose.rank() > 2 and 1 or 0 )) then
            if isChecked("Debug") then print("fok aoe") end
            if cast.fanOfKnives("player") then return  end
        end
        -- actions.direct+=/fan_of_knives,if=variable.use_filler&(buff.hidden_blades.stack>=19|spell_targets.fan_of_knives>=2+stealthed.rogue|buff.the_dreadlords_deceit.stack>=29)
        -- if  cast.able.fanOfKnives() and (#enemies.yards9 >= 2 + (stealthingRogue and 1 or 0) or buff.hiddenBlades.stack() >= 19) then
        --     if cast.fanOfKnives() then return end
        -- end

        if cast.able.fanOfKnives() and #enemies.yards9 >= 3 then
            for i = 1, #enemies.yards9 do
                    local thisUnit = enemies.yards9[i]
                        if not debuff.woundPoison.exists(thisUnit) then
                            if isChecked("Debug") then print("fok refresh poison") end
                            if cast.fanOfKnives("player") then return end
                        end
            end
        end

        if cast.able.mutilate() and #enemies.yards5 == 2 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                    if not debuff.woundPoison.exists(thisUnit) then
                        if isChecked("Debug") then print("muti refresh poison") end
                        if cast.mutilate(thisUnit) then return end
                    end
            end
        end

        --muti
        if cast.able.mutilate()  then
            if isChecked("Debug") then print("muti") end
            if cast.mutilate() then return end
        end

        end -- End Action List - Finishers
    -- Action List - Opener
        -- local function actionList_Opener()                    
        -- -- Opener
            
 
        -- end
    -- Action List - Stealth
        
---------------------
--- Begin Profile ---
---------------------
    --Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop == true) or (mode.opener == 1 and inCombat and buff.stealth.exists())  or pause() or (IsMounted() or IsFlying()) or mode.rotation == 2 then
            return true
        else
            --print(debuff.garrote.exsang("target"))
            -- print("RUP1 is "..tostring(RUP1))
            -- print("GAR1 is "..tostring(GAR1))
            -- print("VEN1 is "..tostring(VEN1))
            --print(trait.shroudedSuffocation.rank())
            --print(debuff.garrote.applied(units.dyn5))
            --print(waitshit())
            -- if ssbuggy ~= nil then
            --     print("___________________")
            --ngs()
            --print(gcd)
            ---print(getDistance("target"))
            --print(isInRange(1329,"target"))
            --print(ssbug)
            -- print(ssbuggytime1)
            -- if debuff.rupture.exsang["target"] or debuff.garrote.exsang["target"] then
            --     print("exsanguinated")
            -- end    
            -- print("below rupt")
            -- print(debuff.rupture.exsang("target"))
            -- print("below garrote")
            --print(debuff.rupture.exsang(units.dyn5))
            -- end
            --print(#enemies.yards5)
            --print("target Distance is - "..getDistance("target")..". Current dist is - "..currentDist)
            --print(debuff.rupture.exsang(units.dyn5).."exsang rupt")
            --print(debuff.garrote.exsang(units.dyn5).."exsang garrote")
            -- print(tostring(Evaluate_Garrote_Target("target")).."evaluate")
            -- print(tostring(debuff.rupture.refresh(units.dyn5)).."rupture")
            -- print(energyRegenCombined)
            -- print(debuff.garrote.applied(units.dyn5).." garrote coef")
            -- print(debuff.rupture.applied(units.dyn5).." ruptu coef")
            --print("Garrote calc"..debuff.garrote.calc()..". Rupture calc: "..debuff.rupture.calc()..".Print applied garrote"..debuff.rupture.applied())
            --print(bleeds)
           -- print(debuff.rupture.remain())
            --print(rtbReroll())
            --print(br.player.power.energy.ttm())
            -- if cast.sinisterStrike() then return end
           -- print(getDistance("target"))
            --print(inRange(193315,"target"))
           -- print(IsSpellInRange(193315,"target"))
            --if castSpell("target",193315,true,false,false,true,false,true,false,false) then return end
            --RunMacroText("/cast Коварный удар")

            if actionList_Defensive() then return end

            if actionList_PreCombat() then return end

            if inCombat or cast.last.vanish() then

                if mode.opener == 1 then
                    if actionList_Open() then return end
                    return
                end 
                if not stealth then
                    StartAttack(units.dyn5)

                    if mode.interrupt == 1 then
                        if actionList_Interrupts() then end
                    end                    
                end    
                if mode.special == 1 then
                    if actionList_Cooldowns() then return end
                end

                if stealthingRogue then
                    if actionList_Stealthed() then return true end
                    return
                end
                --print(#br.player.enemies.yards5)
                --print(stealthingRogue)
                --print(bleeds)
                

                if not stealth and mode.opener == 2   then
                    if actionList_Special() then end

                    --StartAttack()
                end                
                --print(garrotecountbuff.."garrote........"..getCombatTime())





                if not stealthingRogue then
                    if actionList_Dot() then return end

                    if usefiller() then
                        if actionList_Direct() then return end
                    end

                    if isChecked("Racial") and cast.able.racial() and ((race == "Nightborne" or race == "LightforgedDraenei")
                        or (race == "BloodElf" and br.player.power.energy.deficit() >= 15 + energyRegenCombined))
                    then
                        if cast.racial() then return true end
                    end
                end

            end -- End In Combat
        end -- End Profile
end -- runRotation
local id = 259
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
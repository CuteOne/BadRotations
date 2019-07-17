local rotationName = "JR" -- Change to name of profile listed in options drop down
-- TODO
    -- Not Implemented yet:
        -- Symbol of Hope
        -- Divine Star

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- DPS Button
    DPSModes = {
        [1] = { mode = "On", value = 1 , overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 1, icon = br.player.spell.smite },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.smite }
    };
    CreateButton("DPS",1,0)
-- Cleave Button
    CleaveModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cleave Enabled", tip = "AoE Damage Spells Enabled.", highlight = 0, icon = br.player.spell.holyNova },
        [2] = { mode = "Mult", value = 2 , overlay = "Cleave Disabled", tip = "Single Target Damage Only.", highlight = 0, icon = br.player.spell.holyNova }
    };
    CreateButton("Cleave",2,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.guardianSpirit },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.guardianSpirit },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used. Cast Manually.", highlight = 0, icon = br.player.spell.guardianSpirit }
    };
    CreateButton("Cooldown",3,0)
-- Decurse Button
    DecurseModes = {
        [1] = { mode = "On", value = 1 , overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 1, icon = br.player.spell.purify },
        [2] = { mode = "Off", value = 2 , overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.purify }
    };
    CreateButton("Decurse",4,0)
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
        -- Cast Timing Debug
            br.ui:createCheckbox(section,"Cast Timing Debug", "Print elapsed time for code that might be taking a long time to execute")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "Enables/Disables DPS Testing", "Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Angelic Feather
            br.ui:createCheckbox(section,"Angelic Feather", "Cast Angelic Feather on Self when moving")
        -- Body and Mind
            br.ui:createCheckbox(section,"Body and Mind", "Cast Body and Mind on Self when moving")
        -- Elixir
            br.ui:createDropdown(section,"Elixir", {"Flask of the Whispered Pact","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "Set Elixir to use.")
        -- Min Mana to DPS
            br.ui:createSpinner(section, "Minimum Mana to DPS",  50,  0,  100,  5,  "Uncheck to NOT use mana for DPS", "Below this value, do not use mana for DPS.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
        -- Group Heal Spam
            br.ui:createDropdown(section, "Spam Group Heals Hotkey", br.dropOptions.Toggle, 6, "Spam Group Healing (Sanctify,PoH) at cursor location.")
        -- Guardian Spirit
            br.ui:createSpinnerWithout(section, "Guardian Spirit",  15,  0,  100,  5,  "Health Percent to Cast At")
        -- Guardian Spirit Tank Only
            br.ui:createCheckbox(section,"Guardian Spirit Tank Only",  "Enable/Disable")
        -- Light of T'uure
            if br.player.artifact.lightOfTuure then
                br.ui:createSpinnerWithout(section, "Light of Tuure",  40,  0,  100,  5,  "Health Percent to Cast At")
                br.ui:createCheckbox(section,"Light of Tuure Tank Only",  "Enable/Disable")
            end
        -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"1st Only","2nd Only","Both","None"}, 4, "Select Trinket Usage.")
        -- The Deceiver's Grand Design
            if hasEquiped(147007) then
                br.ui:createCheckbox(section, "The Deceivers Grand Design")
            end
        -- Velen's Future Sight
            if hasEquiped(144258) then
                br.ui:createCheckbox(section, "Velens Future Sight", "Will use Velens when several friendly units are hurt, in conjuction with HW:Sanctify")
                br.ui:createCheckbox(section, "Velens On Cooldown", "Cast Velens every time it is available")
            end
        -- Racials
            -- Blood Elf 
            if (br.player.race == "BloodElf") then
                br.ui:createSpinner(section, "Arcane Torrent", 50, 0, 100, 5, "Enable/Disable", "Mana Percent to Cast At")
            end

        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Desperate Prayer
            br.ui:createSpinner(section, "Desperate Prayer",  25,  0,  100,  5,  "Health Percent to Cast At")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "Health Percent to Cast At")
        -- Fade
            br.ui:createCheckbox(section, "Fade")
        br.ui:checkSectionState(section)
        -------------------------
        --- OOC HEALING OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Out-Of-Combat Healing")
            -- Prayer of Mending 
            br.ui:createCheckbox(section,"Prayer of Mending","Enable/Disable", true)
            br.ui:createCheckbox(section,"Prayer of Mending Pre-Stack","Pre-Stack PoM on tanks", true)
        br.ui:checkSectionState(section)
        -------------------------
        --- HEALING OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Healing Options")
        -- Holy Word: Serenity
            br.ui:createSpinnerWithout(section, "Holy Word: Serenity",  60,  0,  100,  5,  "Health Percent to Cast At")
        -- Flash Heal
            br.ui:createSpinnerWithout(section, "Flash Heal",  75,  0,  100,  5,  "Health Percent to Cast At")
        -- Heal
            br.ui:createSpinner(section, "Heal",  75,  0,  100,  5,   "Enable/Disable", "Health Percent to Cast At")
        -- Binding Heal
            if br.player.talent.bindingHeal then
                br.ui:createSpinnerWithout(section, "Binding Heal",  90,  0,  100,  5,  "Health Percent to Cast At") 
            end
        -- Renew
            br.ui:createSpinner(section, "Renew",  85,  0,  100,  5,   "Enable/Disable", "Health Percent to Cast At") 
            br.ui:createSpinner(section, "Renew on Tanks",  90,  0,  100,  5,   "Enable/Disable", "Health Percent to Cast At")
            br.ui:createSpinner(section, "Renew while moving",  80,  0,  100,  5,  "Enable/Disable", "Health Percent to Cast At")
        -- Holy Word: Sanctify
            br.ui:createSpinnerWithout(section, "Holy Word: Sanctify",  75,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Holy Word: Sanctify Targets",  3,  0,  40,  1,  "Minimum Holy Word: Sanctify Targets")
        -- Prayer of Healing
            br.ui:createSpinnerWithout(section, "Prayer of Healing",  75,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Prayer of Healing Targets",  3,  0,  40,  1,  "Minimum Prayer of Healing Targets")
        -- Divine Star
            -- br.ui:createSpinner(section, "Divine Star",  80,  0,  100,  5,  "Enables/Disables Divine Star usage.", "Health Percent to Cast At")
            -- br.ui:createSpinnerWithout(section, "Min Divine Star Targets",  3,  1,  40,  1,  "Minimum Divine Star Targets (This includes you)")
        -- Circle of Healing
            if br.player.talent.circleOfHealing then
                br.ui:createSpinnerWithout(section, "Circle of Healing",  75,  0,  100,  5,  "Health Percent to Cast At")
                br.ui:createSpinnerWithout(section, "Circle of Healing Targets",  3,  0,  40,  1,  "Minimum Circle of Healing Targets")
            end
        -- Halo
            if br.player.talent.halo then
                br.ui:createSpinner(section, "Halo",  75,  0,  100,  5,   "Enable/Disable", "Health Percent to Cast At") 
                br.ui:createSpinnerWithout(section, "Halo Targets",  3,  0,  40,  1,  "Minimum Halo Targets")
            end
        -- Mass Dispel
            br.ui:createSpinner(section, "Automatic Mass Dispel",  3,  0,  5,  1,   "Enable/Disable", "Minimum Mass Dispel Targets")
            br.ui:createDropdown(section, "Mass Dispel Hotkey", br.dropOptions.Toggle, 6, "Enables/Disables Mass Dispel usage.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section,  "DPS Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cleave Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Cooldowns Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section,  "Decurse Mode", br.dropOptions.Toggle,  6)
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
    UpdateToggle("DPS",0.25)
    UpdateToggle("Cleave",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Decurse",0.25)

    br.player.mode.dps = br.data.settings[br.selectedSpec].toggles["DPS"]
    br.player.mode.cleave = br.data.settings[br.selectedSpec].toggles["Cleave"]
    br.player.mode.decurse = br.data.settings[br.selectedSpec].toggles["Decurse"]

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
    local falling, swimming, flying, mounted            = getFallTime(), IsSwimming(), IsFlying(), IsMounted()
    local gcd                                           = br.player.gcd
    local inCombat                                      = br.player.inCombat
    local inInstance                                    = br.player.instance=="party"
    local inRaid                                        = br.player.instance=="raid"
    local item                                          = br.player.spell.items
    local level                                         = br.player.level
    local mana                                          = br.player.power.mana.percent()
    local mode                                          = br.player.mode
    local moving                                        = isMoving("player") and not br.player.buff.norgannonsForesight.exists()
    local perk                                          = br.player.perk        
    local php                                           = br.player.health
    local healPot                                       = getHealthPot()
    local power, powmax, powgen                         = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
    local pullTimer                                     = br.DBM:getPulltimer()
    local race                                          = br.player.race
    local racial                                        = br.player.getRacial()
    local recharge                                      = br.player.recharge
    local spell                                         = br.player.spell
    local talent                                        = br.player.talent
    local ttm                                           = br.player.timeToMax
    local use                                           = br.player.use

    local lowest                                        = {}    --Lowest Unit
    lowest.hp                                           = br.friend[1].hp
    lowest.role                                         = br.friend[1].role
    lowest.unit                                         = br.friend[1].unit
    lowest.range                                        = br.friend[1].range
    lowest.guid                                         = br.friend[1].guid    

    local units                                         = units or {}
    units.dyn40 = br.player.units(40)
    local enemies                                       = enemies or {}
    enemies.yards12 = br.player.enemies(12)
    enemies.yards40 = br.player.enemies(40)

    local friends                                       = friends or {}                  
    friends.yards40 = getAllies("player",40)

    local tanks = getTanksTable()
    -- local myTanks = {}
    -- local lowestTank = nil
    -- for i=1, #tanks do
    --     if UnitInRange(tanks[i].unit) 
    --         and not UnitIsDeadOrGhost(tanks[i].unit) 
    --         and UnitInPhase(tanks[i].unit) 
    --         and UnitIsVisible(tanks[i].unit) 
    --         and getLineOfSight("player", tanks[i].unit) 
    --     then
    --         tinsert(myTanks, tanks[i])
    --         if lowestTank == nil or lowestTank.hp > tanks[i].hp then lowestTank = tanks[i] end
    --     end
    -- end

    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end

---***************************************************************************************************************************
--- Action List Extras *******************************************************************************************************
---***************************************************************************************************************************
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
    -- Moving
        if moving then
            if isChecked("Angelic Feather") and talent.angelicFeather and not buff.angelicFeather.exists("player") and not UnitAura("player",GetSpellInfo(224098)) then
                cast.angelicFeather("player")
                --RunMacroText("/cast [@Player] Angelic Feather")
            end
            -- Body and Mind
            if isChecked("Body and Mind") and talent.bodyAndMind and not UnitAura("player",GetSpellInfo(224098)) then
                if cast.bodyAndMind("player") then return true end
            end
        end
    -- Flask/Elixir
        -- flask,type=flask_of_the_whispered_pact
        if isChecked("Elixir") then
            if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheWhisperedPact.exists() and canUseItem(item.flaskOfTheWhisperedPact) then
                if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                if buff.felFocus.exists() then buff.felFocus.cancel() end
                if use.flaskOfTheWhisperedPact() then return end
            end
            if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and canUseItem(item.repurposedFelFocuser) then
                if buff.flaskOfTheWhisperedPact.exists() then buff.flaskOfTheWhisperedPact.cancel() end
                if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                if use.repurposedFelFocuser() then return end
            end
            if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUseItem(item.oraliusWhisperingCrystal) then
                if buff.flaskOfTheWhisperedPact.exists() then buff.flaskOfTheWhisperedPact.cancel() end
                if buff.felFocus.exists() then buff.felFocus.cancel() end
                if use.oraliusWhisperingCrystal() then return end
            end
        end
    -- Pre-Pot Timer
        if isChecked("Pre-Pot Timer") and pullTimer <= getOptionValue("Pre-Pot Timer") then
            if pullTimer <= getOptionValue("Pre-Pot Timer") then
                if canUseItem(142117) and not buff.prolongedPower.exists() then
                    useItem(142117)
                    return true
                end
            end
        end
    end -- End Action List - Extras


---***************************************************************************************************************************
--- Action List Spam Group Heals *********************************************************************************************
---***************************************************************************************************************************
    local function actionList_SpamGroupHeals()
    -- Velens
        if isChecked("Velens Future Sight") and hasEquiped(144258) then
            if GetItemCooldown(144258)==0 then
                useItem(144258)
            end
        end
    -- Holy Word: Sanctify
        if cd.holyWordSanctify.remain() == 0 then
            CastSpellByName(GetSpellInfo(spell.holyWordSanctify),"cursor")
            return true
        end
    -- Circle of Healing
        if talent.circleOfHealing and cd.circleOfHealing.remain() == 0 then
            CastSpellByName(GetSpellInfo(spell.circleOfHealing),"cursor")
            return true
        end
    -- Prayer of Healing
        if not moving and cast.prayerOfHealing("player") then return true end
    end
    


---***************************************************************************************************************************
--- Action List DPS **********************************************************************************************************
---***************************************************************************************************************************
    local function actionList_DPS()
        if isChecked("Minimum Mana to DPS") and mana >= getValue("Minimum Mana to DPS") then
            if mode.cleave == 1 and #enemies.yards12 > 2 then
                if cast.holyNova("player") then return true end
            end
            if cast.holyWordChastise(units.dyn40) then return true end
            if cast.holyFire(units.dyn40) then return true end
            if not (mode.cleave == 1 and #enemies.yards12 > 2) then
                if cast.smite(units.dyn40) then return true end
            end
        else
            if cast.smite(units.dyn40) then return true end
        end
    end


---***************************************************************************************************************************
--- Action List Emergencies and Cooldowns ************************************************************************************
---***************************************************************************************************************************
    local function actionList_Emergency()
    -- Velens on cooldown
        if hasEquiped(144258) then
            if isChecked("Velens on Cooldown") and useCDs() then
                if GetItemCooldown(144258)==0 then
                    useItem(144258)
                end
            end
        end
    -- The Deceiver's Grand Design
        if isChecked("The Deceivers Grand Design") and hasEquiped(147007) and canUseItem(147007) then
            local localizedName = select(1,GetItemInfo(147007))
            for i=1, #tanks do
                thisTank = tanks[i]
                if UnitInRange(thisTank.unit) and not buff.guidingHand.exists(thisTank.unit) then
                    UseItemByName(localizedName, thisTank.unit)
                end
            end
            if #tanks == 0 then
                for i = 1, #friends.yards40 do
                    if not buff.guidingHand.exists(friends.yards40[i].unit) then
                        if cast.purify(friends.yards40[i].unit) then return true end
                    end
                end
            end
        end
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
    -- Fade
        if isChecked("Fade") and not solo and cd.fade.remain() == 0 then
            local myThreat = UnitThreatSituation("player")
            if myThreat ~= nil and myThreat >= 2 then
                cast.fade("player")
            end
        end
    -- Group Heals Spam Hotkey
        if isChecked("Spam Group Heals Hotkey") and (SpecificToggle("Spam Group Heals Hotkey") and not GetCurrentKeyBoardFocus()) then
            if actionList_SpamGroupHeals() then return true end
        end
    -- Guardian Spirit
        if useCDs() and cd.guardianSpirit.remain() == 0 then
            for i=1, #tanks do
                if tanks[i].hp <= getValue("Guardian Spirit") then
                    if cast.guardianSpirit(tanks[i].unit, "aoe") then return true end
                end
            end
            if not isChecked("Guardian Spirit Tank Only") and lowest.hp <= getValue("Guardian Spirit") then
                if cast.guardianSpirit(lowest.unit, "aoe") then return true end
            end
        end
    -- Desperate Prayer
        if useCDs() and isChecked("Desperate Prayer") and cd.desperatePrayer.remain() == 0 and php <= getValue("Desperate Prayer") then
            if cast.desperatePrayer() then return true end
        end
    -- Light of T'uure
        if useCDs() and cd.lightOfTuure.remain() == 0 then
            for i=1, #tanks do
                if tanks[i].hp <= getValue("Light of Tuure") then
                    if cast.lightOfTuure(tanks[i].unit, "aoe") then return true end
                end
            end
            if not isChecked("Light of Tuure Tank Only") and lowest.hp <= getValue("Light of Tuure") then
                if cast.lightOfTuure(lowest.unit, "aoe") then return true end
            end
        end
    -- Mass Dispell (by hotkey)
        if isChecked("Mass Dispel Hotkey") and (SpecificToggle("Mass Dispel Hotkey") and cd.massDispel.remain() == 0 and not GetCurrentKeyBoardFocus()) then
            CastSpellByName(GetSpellInfo(spell.massDispel),"cursor")
            return true
        end
    -- Arcane Torrent
        if useCDs() and isChecked("Arcane Torrent") and mana <= getValue("Arcane Torrent") and br.player.race == "BloodElf" then
            if castSpell("player",racial,false,false,false) then return end
        end
    end


---***************************************************************************************************************************
--- Action List Heals ********************************************************************************************************
---***************************************************************************************************************************
    local function actionList_Heal()
    -- Holy Word: Serenity
        if cd.holyWordSerenity.remain() == 0 then
            for i=1, #tanks do
                if tanks[i].hp <= getValue("Holy Word: Serenity") then
                    if cast.holyWordSerenity(tanks[i].unit, "aoe") then return true end
                end
            end
            if lowest.hp <= getValue("Holy Word: Serenity") then
                if cast.holyWordSerenity(lowest.unit, "aoe") then return true end
            end
        end
    -- Cures - Single Taret
        -- Purify
        if br.player.mode.decurse == 1 and cd.purify.remain() == 0 then
            for i=1, #tanks do
                thisTank = tanks[i]
                if canDispel(thisTank.unit,spell.purify) then
                    if cast.purify(thisTank) then return true end
                end
            end
            for i = 1, #friends.yards40 do
                if canDispel(friends.yards40[i].unit,spell.purify) then
                    if cast.purify(friends.yards40[i].unit) then return true end
                end
            end
        end
    -- Flash Heal (with Surge of Light proc)
        if talent.surgeOfLight and buff.surgeOfLight.exists() then
            for i=1, #tanks do
                thisTank = tanks[i]
                if thisTank.hp <= getValue("Flash Heal") then
                    if cast.flashHeal(thisTank.unit, "aoe") then return true end
                end
            end
            if lowest.hp <= getValue("Flash Heal") then
                if cast.flashHeal(lowest.unit, "aoe") then return true end
            end
        end
    -- Check for group healing candidate targets
        local sanctifyCandidates = {}
        local circleOfHealingCandidates = {}
        local haloCandidates = {}
        local groupHealCandidates = {}
        local bindingHealCandidates = {}
        local decurseCandidates = {}
        for i=1, #friends.yards40 do
            if cd.holyWordSanctify.remain() == 0 and friends.yards40[i].hp < getValue("Holy Word: Sanctify") then
                tinsert(sanctifyCandidates,friends.yards40[i])
            end
            if friends.yards40[i].hp < getValue("Prayer of Healing") then
                tinsert(groupHealCandidates,friends.yards40[i])
            end
            if talent.circleOfHealing and cd.circleOfHealing.remain() == 0 and friends.yards40[i].hp < getValue("Circle of Healing") then
                tinsert(circleOfHealingCandidates,friends.yards40[i])
            end
            if talent.halo and cd.halo.remain() == 0 and friends.yards40[i].hp < getValue("Circle of Healing") and getDistance(br.friend[i].unit) <= 30  then
                tinsert(haloCandidates,friends.yards40[i])
            end
            if talent.bindingHeal and friends.yards40[i].hp < getValue("Binding Heal") then
                tinsert(bindingHealCandidates,friends.yards40[i])
            end
            if canDispel(friends.yards40[i].unit,spell.massDispel) then
                tinsert(decurseCandidates,friends.yards40[i])
            end
        end
    -- Holy Word: Sanctify
        if cd.holyWordSanctify.remain() == 0 and #sanctifyCandidates >= getValue("Holy Word: Sanctify Targets") then
            -- get the best ground location to heal most or all of them
            local sancStartTime = debugprofilestop()
            local loc = getBestGroundCircleLocation(sanctifyCandidates,getValue("Holy Word: Sanctify Targets"),6,10)
            if isChecked("Cast Timing Debug") then
                local elaps = debugprofilestop() - sancStartTime
                if elaps > 10 then
                    print(format("HW:Sanctify took %f ms", elaps))
                end
            end
            if loc ~= nil then
                -- Lots of people need heals. Good a time as any to use trinkets...
                -- If you can think of a better time to use them, feel free to modify
                if (getOptionValue("Trinkets") == 1 or getOptionValue("Trinkets") == 3) and canUseItem(13) then
                    useItem(13)
                end
                if (getOptionValue("Trinkets") == 2 or getOptionValue("Trinkets") == 3) and canUseItem(14) then
                    useItem(14)
                end
                -- Velens
                if isChecked("Velens Future Sight") and hasEquiped(144258) then
                    if GetItemCooldown(144258)==0 then
                        useItem(144258)
                    end
                end
                if castGroundAtLocation(loc, spell.holyWordSanctify) then return true end
            end 
        end
    -- Prayer of Mending
        if not inCombat and cd.prayerOfMending.remain() == 0 and isChecked("Prayer of Mending") and isChecked("Prayer of Mending Pre-Stack") then
            local pomTarget = tanks[1]
            for i=1, #tanks do
                thisTank = tanks[i]
                if UnitInRange(thisTank.unit) then
                    if not buff.prayerOfMending.exists(thisTank.unit) or buff.prayerOfMending.remain(thisTank.unit) < buff.prayerOfMending.remain(pomTarget.unit) then pomTarget = thisTank end
                end
            end
            if pomTarget ~= nil then 
                if cast.prayerOfMending(pomTarget.unit) then return true end
            end
        end
        if inCombat and isChecked("Prayer of Mending") and cd.prayerOfMending.remain() == 0 then
            local pomTarget = tanks[1]
            for i=1, #tanks do
                thisTank = tanks[i]
                if UnitInRange(thisTank.unit) then
                    if not buff.prayerOfMending.exists(thisTank.unit) or buff.prayerOfMending.remain(thisTank.unit) < buff.prayerOfMending.remain(pomTarget.unit) then pomTarget = thisTank end
                end
            end
            if pomTarget == nil then pomTarget = lowest end
            if cast.prayerOfMending(pomTarget.unit) then return true end
        end
    -- Halo
        if inCombat and talent.halo and not moving and cd.halo.remain() == 0 and #haloCandidates >= getValue("Halo Targets") then
            if cast.halo() then return true end
        end
    -- Circle of Healing
        if talent.circleOfHealing and cd.circleOfHealing.remain() == 0 and #circleOfHealingCandidates >= getValue("Circle of Healing Targets") then
            -- get the best ground location to heal most or all of them
            local loc = getBestGroundCircleLocation(circleOfHealingCandidates,getValue("Circle of Healing Targets"),5,30)
            if loc ~= nil then
                if castGroundAtLocation(loc, spell.circleOfHealing) then return true end
            end 
        end
    -- Prayer of Healing
        if not moving and #groupHealCandidates >= getValue("Prayer of Healing Targets") then
            local pohStartTime = debugprofilestop()
            if castWiseAoEHeal(br.friend,spell.prayerOfHealing,40,getValue("Prayer of Healing"),getValue("Prayer of Healing Targets"),5,false,true)  then return true end
            if isChecked("Cast Timing Debug") then
                local elaps = debugprofilestop() - pohStartTime
                if elaps > 10 then
                    print(format("Prayer of Healing took %f ms", elaps))
                end
            end
        end 
    -- Flash Heal
        for i=1, #tanks do
            thisTank = tanks[i]
            if thisTank.hp <= getValue("Flash Heal") then
                if cast.flashHeal(thisTank.unit, "aoe") then return true end
            end
        end
        if lowest.hp <= getValue("Flash Heal") then
            if cast.flashHeal(lowest.unit, "aoe") then return true end
        end
    -- Mass Dispel
        if br.player.mode.decurse == 1 and cd.massDispel.remain() == 0 and isChecked("Automatic Mass Dispell") and #decurseCandidates >= getvalue("Automatic Mass Dispel") then
            local loc = getBestGroundCircleLocation(decurseCandidates,getValue("Automatic Mass Dispel"),5,15)
            if loc ~= nil then
                if castGroundAtLocation(loc, spell.massDispel) then return true end
            end 
        end
    -- Heal
        if isChecked("Heal") then
            for i=1, #tanks do
                thisTank = tanks[i]
                if thisTank.hp <= getValue("Heal") then
                    if cast.heal(thisTank.unit, "aoe") then return true end
                end
            end
            if lowest.hp <= getValue("Heal") then
                if cast.heal(lowest.unit, "aoe") then return true end
            end
        end
    -- Binding Heal
        if talent.bindingHeal and not moving and #bindingHealCandidates >= 2 then
            for i=1, #tanks do
                thisTank = tanks[i]
                if thisTank.hp <= getValue("Binding Heal") and not GetUnitIsUnit(thisTank.unit,"player") then
                    if cast.bindingHeal(thisTank.unit, "aoe") then return true end
                end
            end
            if lowest.hp <= getValue("Binding Heal") and not GetUnitIsUnit(lowest.unit,"player") then
                if cast.bindingHeal(lowest.unit, "aoe") then return true end
            end
        end
    -- Renew
        if isChecked("Renew on Tanks") then
            for i=1, #tanks do
                thisTank = tanks[i]
                if thisTank.hp <= getValue("Renew on Tanks") and not buff.renew.exists(thisTank.unit) then
                    if cast.renew(thisTank.unit, "aoe") then return true end
                end
            end
        end
        if isChecked("Renew") then
            for i = 1, #friends.yards40 do
                if friends.yards40[i].hp < getValue("Renew while moving") then
                    if not buff.renew.exists(friends.yards40[i].unit) then
                        if cast.renew(friends.yards40[i].unit, "aoe") then return true end
                    end
                else
                    break
                end
            end
        end
        if isChecked("Renew while moving") and moving then
            for i=1, #tanks do
                thisTank = tanks[i]
                if thisTank.hp <= getValue("Renew while moving") and not buff.renew.exists(thisTank.unit) then
                    if cast.renew(thisTank.unit, "aoe") then return true end
                end
            end
            for i = 1, #friends.yards40 do
                if friends.yards40[i].hp < getValue("Renew while moving") then
                    if not buff.renew.exists(friends.yards40[i].unit) then
                        if cast.renew(friends.yards40[i].unit, "aoe") then return true end
                    end
                else
                    break
                end
            end
        end
    end


-----------------
--- Rotations ---
-----------------
    -- Pause
    if pause() or isCastingSpell(spell.divineHymn) or mounted or flying then
        return true
    else
---------------------------------
--- Out Of Combat ---------------
---------------------------------
        if actionList_Extras() then return end
        if not inCombat then
            if actionList_Heal() then return end
        end -- End Out of Combat Rotation
-----------------------------
--- In Combat --------------- 
-----------------------------
        if inCombat then
            if lowest.hp < 60 and isCastingSpell(spell.smite) and getCastTime(spell.smite) > 0.2 then SpellStopCasting() end
            if actionList_Emergency() then return end
            if actionList_Heal() then return end
            if mode.dps == 1 then
                actionList_DPS()
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation 
local id = 0 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
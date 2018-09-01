local rotationName = "JR" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Cleave Button
    CleaveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Cleave Enabled", tip = "AoE Damage Spells Enabled.", highlight = 1, icon = br.player.spell.purgeTheWicked },
        [2] = { mode = "Off", value = 2 , overlay = "Cleave Disabled", tip = "Single Target Damage Only.", highlight = 0, icon = br.player.spell.purgeTheWicked }
    };
    CreateButton("Cleave",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.rapture },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.rapture },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used. Cast Manually.", highlight = 0, icon = br.player.spell.rapture }
    };
    CreateButton("Cooldown",2,0)
-- Decurse Button
    DecurseModes = {
        [1] = { mode = "On", value = 1 , overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 1, icon = br.player.spell.purify },
        [2] = { mode = "Off", value = 2 , overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.purify }
    };
    CreateButton("Decurse",3,0)
-- Atonement Spread Button
    AtonesModes = {
        [1] = { mode = "Off", value = 1 , overlay = "Atonement Spread Disabled", tip = "Oh Shit! Spread Atonements!", highlight = 0, icon = br.player.spell.powerWordRadiance },
        [2] = { mode = "On", value = 2 , overlay = "Atonement Spread Enabled", tip = "Oh Shit!", highlight = 1, icon = br.player.spell.powerWordRadiance }
    };
    CreateButton("Atones",4,0)
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
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "Enables/Disables DPS Testing", "Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Angelic Feather
            if br.player.talent.angelicFeather then
                br.ui:createCheckbox(section,"Angelic Feather", "Cast Angelic Feather on Self when moving")
            end
        -- Body and Soul
            if br.player.talent.bodyAndSoul then
                br.ui:createCheckbox(section,"Body and Soul", "Cast Power Word Shield on Self when moving")
            end
        -- Elixir
            br.ui:createDropdown(section,"Elixir", {"Flask of the Whispered Pact","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "Set Elixir to use.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
        -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"1st Only","2nd Only","Both","None"}, 4, "Select Trinket Usage.")
        -- The Deceiver's Grand Design
            if hasEquiped(147007) then
                br.ui:createCheckbox(section, "The Deceivers Grand Design")
            end
        -- Velen's Future Sight
            if hasEquiped(144258) then
                br.ui:createCheckbox(section, "Velens Future Sight")
            end
        -- Racials
            -- Blood Elf 
            if (br.player.race == "BloodElf") then
                br.ui:createSpinner(section, "Arcane Torrent", 50, 0, 100, 5, "Enable/Disable", "Mana Percent to Cast At")
            end
            --Pain Suppression Tank
            br.ui:createSpinner(section, "Pain Suppression Tank",  30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 30")
            --Pain Suppression
            br.ui:createSpinner(section, "Pain Suppression",  15,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At. Default: 15")

        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "Health Percent to Cast At")
        -- Fade
            br.ui:createCheckbox(section, "Fade")
        br.ui:checkSectionState(section)
        -------------------------
        --- HEALING OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Healing Options")
        -- Shadow Mend
            br.ui:createSpinnerWithout(section, "Shadow Mend",  40,  0,  100,  5,  "Health Percent to Cast At")
        -- Shadow Mend - Out of Combat
            br.ui:createSpinnerWithout(section, "Shadow Mend Out of Combat",  70,  0,  100,  5,  "Health Percent to Cast At")
        -- Atonement Threshold
            br.ui:createSpinnerWithout(section, "Atonement Threshold",  75,  0,  100,  5,  "Health Percent to Apply Atonement")
        -- Power Word: Radiance
            br.ui:createSpinner(section, "Power Word: Radiance",  40,  0,  100,  5,  "Health Percent to cast at, regardless of atonement situation")
            br.ui:createSpinnerWithout(section, "Power Word: Radiance Targets",  3,  0,  40,  1,  "Minimum Power Word: Radiance Targets")
        -- Shadow Covenant
            if br.player.talent.shadowCovenant then
                br.ui:createSpinner(section, "Shadow Covenant",  60,  0,  100,  5,  "Health Percent to cast at")
                br.ui:createSpinnerWithout(section, "Shadow Covenant Targets",  3,  0,  40,  1,  "Minimum Shadow Covenant Targets")
            end
        -- Mass Dispel
            br.ui:createSpinner(section, "Automatic Mass Dispel",  3,  0,  5,  1,   "Enable/Disable", "Minimum Mass Dispel Targets")
            br.ui:createDropdown(section, "Mass Dispel Hotkey", br.dropOptions.Toggle, 6, "Enables/Disables Mass Dispel usage.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cleave Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Cooldowns Mode", br.dropOptions.Toggle,  6)
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
    UpdateToggle("Cleave",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Decurse",0.25)
    UpdateToggle("Atones",0.25)

    br.player.mode.cleave = br.data.settings[br.selectedSpec].toggles["Cleave"]
    br.player.mode.decurse = br.data.settings[br.selectedSpec].toggles["Decurse"]
    br.player.mode.spreadatonement = br.data.settings[br.selectedSpec].toggles["Atones"]

--------------
--- Locals ---
--------------
    local artifact                                      = br.player.artifact
    local buff                                          = br.player.buff
    local cast                                          = br.player.cast
    local cd                                            = br.player.cd
    local charges                                       = br.player.charges
    local debuff                                        = br.player.debuff
    local falling, swimming, flying, mounted            = getFallTime(), IsSwimming(), IsFlying(), IsMounted()
    local inCombat                                      = br.player.inCombat
    local item                                          = br.player.spell.items
    local mana                                          = br.player.power.mana.percent()
    local mode                                          = br.player.mode
    local moving                                        = isMoving("player") and not br.player.buff.norgannonsForesight.exists()
    local healPot                                       = getHealthPot()
    local race                                          = br.player.race
    local racial                                        = br.player.getRacial()
    local recharge                                      = br.player.recharge
    local solo                                          = br.player.instance=="none"
    local spell                                         = br.player.spell
    local talent                                        = br.player.talent
    local ttd                                           = getTTD
    local use                                           = br.player.use

    local lowest                                        = {}    --Lowest Unit
    lowest.hp                                           = br.friend[1].hp
    lowest.role                                         = br.friend[1].role
    lowest.unit                                         = br.friend[1].unit
    lowest.range                                        = br.friend[1].range
    lowest.guid                                         = br.friend[1].guid    

    local units                                         = br.player.units
    units.get(40)
    local enemies                                       = br.player.enemies
    enemies.get(12)
    enemies.get(40)

    local friends                                       = friends or {}                  
    friends.yards40 = getAllies("player",40)

    local tanks = getTanksTable()
    local focusTank = getFocusedTank()
    if focusTank == nil then focusTank = lowest end

    local spreadPhase = spreadPhase or 0
    local spreadCount = spreadCount or 15
    local spreadStartTime = spreadStartTime or 0

    local atonements = {}          -- number of friends with atonement
    local notAtonements = {}       -- number of friends without atonement
    local needAtonement = {}       -- number of friends with hp below Atonement threshold
    local radianceTargets = {}     -- number of friends with hp below PW:R value
    local covenantTargets = {}     -- number of friends with hp below Shadow Covenant value
    local shortAtonements = {}     -- atonement is up, but less than 5 seconds remaining
    local burstHealCandidates = {} -- atonement > 2 secs and below shadow mend threshold
    for i=1, #friends.yards40 do
        if buff.atonement.exists(friends.yards40[i].unit) then
            tinsert(atonements, friends.yards40[i])
        else
            tinsert(notAtonements, friends.yards40[i])
            if friends.yards40[i].hp < getValue("Atonement Threshold") and not buff.powerWordShield.exists(friends.yards40[i]) then
                tinsert(needAtonement,friends.yards40[i])
            end
        end
        if buff.atonement.remain(friends.yards40[i].unit) < 5 and not buff.powerWordShield.exists(friends.yards40[i]) then
            tinsert(shortAtonements,friends.yards40[i])
        end
        if friends.yards40[i].hp < getValue("Power Word: Radiance") then
            tinsert(radianceTargets,friends.yards40[i])
        end
        if friends.yards40[i].hp < getValue("Shadow Covenant") then
            tinsert(covenantTargets,friends.yards40[i])
        end
        if friends.yards40[i].hp < 60 and buff.atonement.remain(friends.yards40[i].unit) >= 2 then
            tinsert(burstHealCandidates,friends.yards40[i])
        end
    end

---***************************************************************************************************************************
--- Action List Extras *******************************************************************************************************
---***************************************************************************************************************************
    local function actionList_Extras()
    -- Oh Shit Button Pressed
        if spreadPhase == 0 and mode.spreadatonement == 2 then
            spreadStartTime = GetTime()
            spreadPhase = 1
            spreadCount = 15
            if spreadCount > #notAtonements + #shortAtonements then spreadCount = #notAtonements + #shortAtonements end
        end
        -- if lots of atonements to spread, and not enough PW:R charges to get then, use Rapture
        if useCDs() and cd.rapture.remain() == 0 and spreadCount - 5*charges.powerWordRadiance.count() >= 10 then
            cast.rapture("player") -- off GCD
        end
        if mode.spreadatonement == 2 and (#notAtonements == 0 or spreadCount < 1 or GetTime() > spreadStartTime + 9) then
            -- finished spreading atonements
            toggle("Atones", "1")
            if isChecked("Velens Future Sight") and hasEquiped(144258) and ((#friends.yards40 - #burstHealCandidates) / #friends.yards40 >= 0.6 or #burstHealCandidates > 10) then
                if GetItemCooldown(144258)==0 then
                    useItem(144258)
                end
            end
            if talent.evengelism and cd.evangelism.remain() == 0 then
                if cast.evangelism("player") then return true end
            end
        end
        if mode.spreadatonement == 1 then
            spreadPhase = 0
            spreadCount = 15
        end
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
    -- Run speed on Self
        if moving then
            if isChecked("Angelic Feather") and talent.angelicFeather and not buff.angelicFeather.exists("player") and not UnitAura("player",GetSpellInfo(224098)) then
                cast.angelicFeather("player")
                --RunMacroText("/cast [@Player] Angelic Feather")
            end
            -- Body and Soul
            if isChecked("Body and Soul") and talent.bodyAndSoul and not buff.bodyAndSoul.exists("player") and not UnitAura("player",GetSpellInfo(224098)) then
                if cast.powerWordShield("player") then return true end
            end
        end
    -- Flask/Elixir
        -- flask,type=flask_of_the_whispered_pact
        if isChecked("Elixir") then
            if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheWhisperedPact.exists() and canUse(item.flaskOfTheWhisperedPact) then
                if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                if buff.felFocus.exists() then buff.felFocus.cancel() end
                if use.flaskOfTheWhisperedPact() then return end
            end
            if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and canUse(item.repurposedFelFocuser) then
                if buff.flaskOfTheWhisperedPact.exists() then buff.flaskOfTheWhisperedPact.cancel() end
                if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                if use.repurposedFelFocuser() then return end
            end
            if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUse(item.oraliusWhisperingCrystal) then
                if buff.flaskOfTheWhisperedPact.exists() then buff.flaskOfTheWhisperedPact.cancel() end
                if buff.felFocus.exists() then buff.felFocus.cancel() end
                if use.oraliusWhisperingCrystal() then return end
            end
        end
    -- Pre-Pot Timer
        if isChecked("Pre-Pot Timer") and pullTimer <= getOptionValue("Pre-Pot Timer") then
            if pullTimer <= getOptionValue("Pre-Pot Timer") then
                if canUse(142117) and not buff.prolongedPower.exists() then
                    useItem(142117)
                    return true
                end
            end
        end
    end -- End Action List - Extras

---***************************************************************************************************************************
--- Action List Cooldowns ****************************************************************************************************
---***************************************************************************************************************************
    local function actionList_Cooldowns()
    -- Velen's Future Sight
            if #burstHealCandidates / #friends.yards40 >= 0.6 or #burstHealCandidates > 8 then
                if isChecked("Velens Future Sight") and hasEquiped(144258) then
                    if GetItemCooldown(144258)==0 then
                        useItem(144258)
                    end
                end
            end
    -- Pot/Stoned
            if isChecked("Pot/Stoned") and br.player.health <= getOptionValue("Pot/Stoned")
                and inCombat and (hasHealthPot() or hasItem(5512))
            then
                if canUse(5512) then
                    useItem(5512)
                elseif canUse(healPot) then
                    useItem(healPot)
                end
            end
    -- Fade
        if isChecked("Fade") and not solo and cd.fade.remain() == 0 then
            local myThreat = UnitThreatSituation("player")
            if myThreat ~= nil and myThreat >= 2 then
                cast.fade("player") -- off GCD
            end
        end
    -- Pain Suppression Tank
        if isChecked("Pain Suppression Tank") and inCombat then
            for i=1, #tanks do
                if tanks[i].hp < getOptionValue("Pain Suppression Tank") then 
                    cast.painSuppression(tanks[i].unit) -- off GCD
                end
            end
        end
    -- Light's Wrath
        if #friends.yards40 > 1 then
            if getSpellCD(spell.lightsWrath) == 0 and (#burstHealCandidates / #friends.yards40 >= 0.6 or #burstHealCandidates > 10) then
                if cast.lightsWrath(units.dyn40) then return true end
            end
        end 
    end
---***************************************************************************************************************************
--- Action List Heal *********************************************************************************************************
---***************************************************************************************************************************
    local function actionList_Heal()
    -- The Deceiver's Grand Design
        if isChecked("The Deceivers Grand Design") and hasEquiped(147007) and canUse(147707) then
            local localizedName = select(1,GetItemInfo(147007))
            for i=1, #tanks do
                thisTank = tanks[i]
                if UnitInRange(thisTank.unit) and not buff.guidingHand.exists(thisTank.unit) then
                    UseItemByName(localizedName, thisTank.unit)
                end
            end
        end
    -- Power Word: Shield on tanks
        if inCombat and cd.powerWordShield.remain() == 0 then
            local pwsTarget = tanks[1]
            for i=1, #tanks do
                if not buff.powerWordShield.exists(tanks[i].unit) or buff.powerWordShield.remain(tanks[i].unit) < buff.powerWordShield.remain(pwsTarget.unit) then pwsTarget = tanks[i] end
            end
            if pwsTarget == nil then pwsTarget = lowest end
            if not buff.powerWordShield.exists(pwsTarget.unit) then
                if cast.powerWordShield(pwsTarget.unit, "aoe") then return true end
            end 
        end
    -- Spread Atonements 
        if mode.spreadatonement == 2 then
            -- use all charges of PW:R to apply mass atonements
            if spreadCount >= 4 and charges.powerWordRadiance.count() > 0 then
                if cast.powerWordRadiance(notAtonements[1].unit, "aoe") then 
                    spreadCount = spreadCount - 5
                    return true 
                end
            end
        end
    -- Mass Dispell (by hotkey)
        if mode.decurse == 1 and isChecked("Mass Dispel Hotkey") and (SpecificToggle("Mass Dispel Hotkey") and cd.massDispel.remain() == 0 and not GetCurrentKeyBoardFocus()) then
            CastSpellByName(GetSpellInfo(spell.massDispel),"cursor")
            return true
        end
    -- Cures - Single Taret
        -- Purify
        if mode.decurse == 1 and cd.purify.remain() == 0 then
            for i=1, #tanks do
                thisTank = tanks[i]
                if canDispel(thisTank.unit,spell.purify) then
                    if cast.purify(thisTank, "aoe") then return true end
                end
            end
            for i = 1, #friends.yards40 do
                if canDispel(friends.yards40[i].unit,spell.purify) then
                    if cast.purify(friends.yards40[i].unit, "aoe") then return true end
                end
            end
        end
    -- Power Word: Radiance
        if isChecked("Power Word: Radiance") and #radianceTargets >= getOptionValue("Power Word: Radiance Targets") and cd.powerWordRadiance.remain() == 0 then
            if castWiseAoEHeal(br.friend,spell.powerWordRadiance,30,getValue("Power Word: Radiance"),getValue("Power Word: Radiance Targets"),5,false,false)  then
                if mode.spreadatonement == 2 then
                    spreadCount = spreadCount - 5
                end
                return true 
            end
        end
    -- Shadow Covenant
        if talent.shadowCovenant and isChecked("Shadow Covenant") then
            if castWiseAoEHeal(br.friend,spell.shadowCovenant,30,getValue("Shadow Covenant"),getValue("Shadow Covenant Targets"),5,false,false)  then return true end
        end
    -- Radiance if 4+ targets need atonement, and have 2 charges of Radiance
        if #needAtonement >= 4 and charges.powerWordRadiance.count() > 1 then
            for i=1, #needAtonement do
                if cast.powerWordRadiance(needAtonement[i].unit, "aoe") then
                    if mode.spreadatonement == 2 then
                        spreadCount = spreadCount - 1
                    end
                    return true 
                end
            end
        end
    -- Shadow Mend
        if not moving and inCombat and lowest.hp < getOptionValue("Shadow Mend") then 
            if cast.shadowMend(lowest.unit, "aoe") then
                if mode.spreadatonement == 2 then
                    spreadCount = spreadCount - 1
                end
                return true 
            end
        end
        if not moving and not inCombat and lowest.hp < getOptionValue("Shadow Mend Out of Combat") then 
            if cast.shadowMend(lowest.unit, "aoe") then
                if mode.spreadatonement == 2 then
                    spreadCount = spreadCount - 1
                end
                return true 
            end
        end
    -- Mass Dispel
        if mode.decurse == 1 and cd.massDispel.remain() == 0 and isChecked("Automatic Mass Dispell") and #decurseCandidates >= getvalue("Automatic Mass Dispel") then
            local loc = getBestGroundCircleLocation(decurseCandidates,getValue("Automatic Mass Dispel"),5,15)
            if loc ~= nil then
                if castGroundAtLocation(loc, spell.massDispel) then return true end
            end 
        end
    -- Atonements
        if #needAtonement > 0 and #atonements < 5 then
            if inCombat and not buff.atonement.exists(needAtonement[1].unit) and needAtonement[1].hp < getValue("Atonement Threshold") then
                if buff.rapture.exists() then
                    if cast.powerWordShield(needAtonement[1].unit) then
                        if mode.spreadatonement == 2 then
                            spreadCount = spreadCount - 1
                        end
                        return true 
                    end
                elseif cast.powerWordShield(needAtonement[1].unit, "aoe") then
                    if mode.spreadatonement == 2 then
                        spreadCount = spreadCount - 1
                    end
                    return true 
                end
            end
        end
        if mode.spreadatonement == 2 and (#notAtonements > 0  or #shortAtonements > 0) then
            local thisUnit = nil
            if #notAtonements > 0 then thisUnit = notAtonements[1].unit else thisUnit = shortAtonements[1].unit end
            if buff.rapture.exists() then
                if cast.powerWordShield(thisUnit, "aoe") then
                    spreadCount = spreadCount - 1
                    return true 
                end
            elseif cast.powerWordShield(thisUnit, "aoe") then 
                spreadCount = spreadCount - 1
                return true 
            end
        end
    -- Arcane Torrent
        if useCDs() and isChecked("Arcane Torrent") and mana <= getValue("Arcane Torrent") and br.player.race == "BloodElf" then
            if castSpell("player",racial,false,false,false) then return true end
        end
    end

---***************************************************************************************************************************
--- Action List DPS **********************************************************************************************************
---***************************************************************************************************************************
    local function actionList_DPS()
    -- Purge the Wicked / Shadow Word: Pain
        if talent.purgeTheWicked then
            if not debuff.purgeTheWicked.exists(units.dyn40) then
                if cast.purgeTheWicked(units.dyn40, "aoe") then return true end
            end
            for i=1,#enemies.yards40 do
                if mode.cleave == 1 and not debuff.purgeTheWicked.exists(enemies.yards40[i]) then
                    if cast.purgeTheWicked(enemies.yards40[i], "aoe") then return true end
                end
            end
        else
            if not debuff.shadowWordPain.exists(units.dyn40) then
                if cast.shadowWordPain(units.dyn40, "aoe") then return true end
            end
            for i=1,#enemies.yards40 do
                if mode.cleave == 1 and not debuff.shadowWordPain.exists(enemies.yards40[i]) then
                    if cast.shadowWordPain(enemies.yards40[i], "aoe") then return true end
                end
            end
        end
    -- Schism
        if not moving and talent.schism and cd.schism.remain() == 0 and cd.penance.remain() < 6 then
            if cast.schism(units.dyn40) then return true end
        end
    -- Penance
        if not talent.schism then
            if cast.penance(units.dyn40) then return true end
        else
            if debuff.schism.exists(units.dyn40) or cd.schism.remain() > 4 then
                if cast.penance(units.dyn40) then return true end
            end
        end
    -- Power Word: Solace
        if talent.powerWordSolace then
            if cast.powerWordSolace(units.dyn40) then return true end
        end
    -- Smite
        if cast.smite(units.dyn40) then return true end
    end

-----------------
--- Rotations ---
-----------------
    local consecutives = consecutives or 0
    -- Pause
    if pause() or mounted or flying then
        return true
    else
        if actionList_Extras() then return end
        if actionList_Cooldowns() then return end
        if consecutives < 2 then
            if actionList_Heal() then 
                consecutives = consecutives + 1
                return 
            else
                consecutives = 0
            end
        end
        if inCombat then
            actionList_DPS()
        end
    end -- Pause
end -- End runRotation 

local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
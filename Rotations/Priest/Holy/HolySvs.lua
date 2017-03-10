local rotationName = "Svs" 

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range", highlight = 1, icon = br.player.spell.holyWordSanctify },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used", highlight = 0, icon = br.player.spell.prayerOfHealing },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used", highlight = 0, icon = br.player.spell.heal },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.holyFire}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection", highlight = 1, icon = br.player.spell.guardianSpirit },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target", highlight = 0, icon = br.player.spell.guardianSpirit },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used", highlight = 0, icon = br.player.spell.guardianSpirit }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns", highlight = 1, icon = br.player.spell.desperatePrayer },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used", highlight = 0, icon = br.player.spell.desperatePrayer }
    };
    CreateButton("Defensive",3,0)
-- Decurse Button
    DecurseModes = {
        [1] = { mode = "On", value = 1 , overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 1, icon = br.player.spell.purify },
        [2] = { mode = "Off", value = 2 , overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.purify }
    };
    CreateButton("Decurse",4,0)
-- DPS Button
    DPSModes = {
        [1] = { mode = "On", value = 1 , overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 1, icon = br.player.spell.smite },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.renew }
    };
    CreateButton("DPS",5,0)
end

--------------
--- COLORS ---
--------------
    local colorBlue     = "|cff00CCFF"
    local colorGreen    = "|cff00FF00"
    local colorRed      = "|cffFF0000"
    local colorWhite    = "|cffFFFFFF"
    local colorGold     = "|cffFFDD11"

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
    -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            br.ui:createCheckbox(section,"OOC Healing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Angelic Feather
            br.ui:createCheckbox(section,"Angelic Feather","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAngelic Feather usage|cffFFBB00.")
        -- Body and Mind
            br.ui:createCheckbox(section,"Body and Mind","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFBody and Mind usage|cffFFBB00.")
        -- Dispel Magic
            br.ui:createCheckbox(section,"Dispel Magic","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFDispel Magic usage|cffFFBB00.")
        -- Mass Dispel
            br.ui:createDropdown(section, "Mass Dispel", br.dropOptions.Toggle, 6, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." Mass Dispel usage.")
        -- Racial
            br.ui:createCheckbox(section, "Racial")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Flask / Crystal
            br.ui:createCheckbox(section,"Flask / Crystal")
         -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Divine Hymn
            br.ui:createSpinner(section, "Divine Hymn",  50,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Divine Hymn Targets",  3,  0,  40,  1,  "Minimum Divine Hymn Targets")
        -- Symbol of Hope
            br.ui:createSpinner(section, "Symbol of Hope",  50,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Symbol of Hope Targets",  3,  0,  40,  1,  "Minimum Symbol of Hope Targets")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at");
        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percentage to use at")
            end
        -- Desperate Prayer
            br.ui:createSpinner(section, "Desperate Prayer",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at");
        br.ui:checkSectionState(section)
        -- Healing Options
        section = br.ui:createSection(br.ui.window.profile, "Healing Options")
        -- Leap of Faith
            br.ui:createSpinner(section, "Leap of Faith",  20,  0,  100,  5,  "Health Percent to Cast At")
        -- Guardian Spirit
            br.ui:createSpinner(section, "Guardian Spirit",  30,  0,  100,  5,  "Health Percent to Cast At")
        -- Renew
            br.ui:createSpinner(section, "Renew",  90,  0,  100,  1,  "Health Percent to Cast At")
        -- Prayer of Mending
            br.ui:createSpinner(section, "Prayer of Mending",  80,  0,  100,  1,  "Health Percent to Cast At")
        -- Light of T'uure
            br.ui:createSpinner(section, "Light of T'uure",  80,  0,  100,  5,  "Health Percent to Cast At")
        -- Heal
            br.ui:createSpinner(section, "Heal",  70,  0,  100,  5,  "Health Percent to Cast At")
        -- Flash Heal
            br.ui:createSpinner(section, "Flash Heal",  60,  0,  100,  5,  "Health Percent to Cast At")
        -- Flash Heal Surge of Light
            br.ui:createSpinner(section, "Flash Heal Surge of Light",  80,  0,  100,  5,  "Health Percent to Cast At")
        -- Holy Word: Serenity
            br.ui:createSpinner(section, "Holy Word: Serenity",  50,  0,  100,  5,  "Health Percent to Cast At")
            -- Holy Word: Sanctify
            br.ui:createSpinner(section, "Holy Word: Sanctify",  85,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Holy Word: Sanctify Targets",  3,  0,  40,  1,  "Minimum Holy Word: Sanctify Targets")
        -- Prayer of Healing
            br.ui:createSpinner(section, "Prayer of Healing",  80,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinner(section, "Prayer of Healing Targets",  3,  0,  40,  1,  "Minimum Prayer of Healing Targets")
            br.ui:createSpinner(section, "Divine Star",  80,  0,  100,  5,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Divine Star usage.", colorWhite.."Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Min Divine Star Targets",  3,  1,  40,  1,  colorBlue.."Minimum Divine Star Targets "..colorGold.."(This includes you)")
            br.ui:createCheckbox(section,"Show Divine Star Area",colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."area of effect drawing.")
            -- Halo
            br.ui:createSpinner(section, "Halo",  70,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Halo Targets",  3,  0,  40,  1,  "Minimum Halo Targets")
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
    if br.timer:useTimer("debugHoly", 0.1) then
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Decurse",0.25)
        UpdateToggle("DPS",0.25)
        br.player.mode.decurse = br.data.settings[br.selectedSpec].toggles["Decurse"]
        br.player.mode.dps = br.data.settings[br.selectedSpec].toggles["DPS"]

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
        local enemies                                       = enemies or {}
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk        
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power.amount.mana, br.player.power.mana.max, br.player.power.regen
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local recharge                                      = br.player.recharge
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttm                                           = br.player.power.ttm
        local units                                         = units or {}

        local lowest                                        = {}    --Lowest Unit
        lowest.hp                                           = br.friend[1].hp
        lowest.role                                         = br.friend[1].role
        lowest.unit                                         = br.friend[1].unit
        lowest.range                                        = br.friend[1].range
        lowest.guid                                         = br.friend[1].guid                      
        local tank                                          = {}    --Tank
        local averageHealth                                 = 0

        units.dyn5 = br.player.units(5)
        units.dyn8AoE = br.player.units(8,true)
        units.dyn40 = br.player.units(40)

        enemies.yards5  = br.player.enemies(5)
        enemies.yards8  = br.player.enemies(8)
        enemies.yards8t = br.player.enemies(8,br.player.units(8,true))
        enemies.yards40 = br.player.enemies(40)

--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
        -- Dummy Test
            if isChecked("DPS Testing") then
                if ObjectExists("target") then
                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end -- End Dummy Test
        -- Moving
            if isMoving("player") then
                if isChecked("Angelic Feather") and talent.angelicFeather and not buff.angelicFeather.exists("player") then
                    if cast.angelicFeather("player") then
                        RunMacroText("/stopspelltarget")
                    end
                end
                -- Body and Mind
                if isChecked("Body and Mind") and talent.bodyAndMind then
                    if cast.bodyAndMind("player") then return end
                end
            end
        -- Mass Dispel
            if isChecked("Mass Dispel") and (SpecificToggle("Mass Dispel") and not GetCurrentKeyBoardFocus()) then
                CastSpellByName(GetSpellInfo(spell.massDispel),"cursor")
                return true
            end
        end -- End Action List - Extras
        -- Action List - Pre-Combat
        function actionList_PreCombat()
        -- Renew
            if isChecked("Renew") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Renew") and not buff.renew.exists(br.friend[i].unit) then
                        if cast.renew(br.friend[i].unit) then return end
                    end
                end                    
            end
        -- Heal
            if isChecked("Heal") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Heal") then
                        if cast.heal(br.friend[i].unit) then return end
                    end
                end                    
            end
        -- Flash Heal
            if isChecked("Flash Heal") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Flash Heal") then
                        if cast.flashHeal(br.friend[i].unit) then return end
                    end
                end                    
            end
        -- Flash Heal Surge of Light
            if isChecked("Flash Heal Surge of Light") and talent.surgeOfLight and buff.surgeOfLight.exists() then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Flash Heal Surge of Light") then
                        if cast.flashHeal(br.friend[i].unit) then return end
                    end
                end                    
            end
        end  -- End Action List - Pre-Combat
        local function actionList_Defensive()
            if useDefensive() then
            -- Healthstone
                if isChecked("Healthstone") and php <= getOptionValue("Healthstone")
                    and inCombat and  hasItem(5512)
                then
                    if canUse(5512) then
                        useItem(5512)
                    end
                end
            -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                        end
                    end
                end
            -- Gift of the Naaru
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                    if castSpell("player",racial,false,false,false) then return end
                end
            -- Desperate Prayer
                if isChecked("Desperate Prayer") and php <= getOptionValue("Desperate Prayer") and inCombat then
                    if cast.desperatePrayer() then return end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
        function actionList_Cooldowns()
            if useCDs() then
            -- Divine Hymn
                if isChecked("Divine Hymn") then
                    if getLowAllies(getValue("Divine Hymn")) >= getValue("Divine Hymn Targets") then    
                        if cast.divineHymn() then return end    
                    end
                end
            -- Symbol of Hope
                if isChecked("Symbol of Hope") then
                    if getLowAllies(getValue("Symbol of Hope")) >= getValue("Symbol of Hope Targets") then    
                        if cast.symbolOfHope() then return end    
                    end
                end
            -- Trinkets
                if isChecked("Trinkets") then
                    if canUse(11) then
                        useItem(11)
                    end
                    if canUse(12) then
                        useItem(12)
                    end
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                    if castSpell("player",racial,false,false,false) then return end
                end
            end -- End useCooldowns check
        end -- End Action List - Cooldowns
        -- AOE Healing
        function actionList_AOEHealing()
        -- Holy Word: Serenity -> Holy Word: Sanctify -> Prayer of Healing Combo
            if buff.blessingOfTuure.exists() then
                if cast.holyWordSerenity(lowest.unit) then return end
            end
            if buff.divinity.exists() then
                if castGroundAtBestLocation(spell.holyWordSanctify, 20, 0, 40, 0, "heal") then return end
            end
            if isChecked("Prayer of Healing") and buff.echoOfLight.exists() then
                if getLowAllies(getValue("Prayer of Healing")) >= getValue("Prayer of Healing Targets") then
                    if cast.prayerOfHealing(lowest.unit) then return end    
                end
            end
        -- Holy Word: Sanctify
            if isChecked("Holy Word: Sanctify") and not moving then
                if getLowAllies(getValue("Holy Word: Sanctify")) >= getValue("Holy Word: Sanctify Targets") then
                    if castGroundAtBestLocation(spell.holyWordSanctify, 20, 0, 40, 0, "heal") then return end
                end
            end
        -- Prayer of Healing
            if isChecked("Prayer of Healing") then
                if getLowAllies(getValue("Prayer of Healing")) >= getValue("Prayer of Healing Targets") then
                    if cast.prayerOfHealing(lowest.unit) then return end    
                end
            end
        -- Divine Star
            if isChecked("Divine Star") and talent.divineStar then
                if getUnitsInRect(7,24,isChecked("Show Divine Star Area"),getValue("Divine Star")) >= getValue("Min Divine Star Targets") then
                    if cast.divineStar("player") then return true end
                end
            end
        --Halo
            if isChecked("Halo") and talent.halo then
                if getLowAllies(getValue("Halo")) >= getValue("Halo Targets") then    
                    if cast.halo() then return end    
                end
            end
        end -- End Action List - AOE Healing
        -- Single Target
        function actionList_SingleTarget()
        -- Leap of Faith
            if isChecked("Leap of Faith") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Leap of Faith") then
                        if cast.leapOfFaith(br.friend[i].unit) then return end
                    end
                end                    
            end
        -- Guardian Spirit
            if isChecked("Guardian Spirit") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Guardian Spirit") then
                        if cast.guardianSpirit(br.friend[i].unit) then return end
                    end
                end                    
            end
        -- Purify
            if br.player.mode.decurse == 1 then
                for i = 1, #br.friend do
                    for n = 1,40 do
                        local buff,_,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                        if buff then
                            if bufftype == "Curse" or bufftype == "Magic" then
                                if cast.purify(br.friend[i].unit) then return end
                            end
                        end
                    end
                end
            end
        -- Holy Word: Serenity
            if isChecked("Holy Word: Serenity") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Holy Word: Serenity") then
                        if cast.holyWordSerenity(br.friend[i].unit) then return end
                    end
                end
            end 
        -- Flash Heal
            if isChecked("Flash Heal") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Flash Heal") then
                        if cast.flashHeal(br.friend[i].unit) then return end
                    end
                end                    
            end
        -- Flash Heal Surge of Light
            if isChecked("Flash Heal Surge of Light") and talent.surgeOfLight and buff.surgeOfLight.remain() > 1.5 then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Flash Heal Surge of Light") then
                        if cast.flashHeal(br.friend[i].unit) then return end
                    end
                end                    
            end
        -- Prayer of Mending
            if isChecked("Prayer of Mending") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Prayer of Mending") and not buff.prayerOfMending.exists(br.friend[i].unit) then
                        if cast.prayerOfMending(br.friend[i].unit) then return end
                    end
                end                    
            end
        -- Light of T'uure
            if isChecked("Light of T'uure") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Light of T'uure") then
                        if cast.lightOfTuure(br.friend[i].unit) then return end
                    end
                end                    
            end
        -- Heal
            if isChecked("Heal") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Heal") then
                        if cast.heal(br.friend[i].unit) then return end
                    end
                end                    
            end
        -- Renew
            if isChecked("Renew") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Renew") and not buff.renew.exists(br.friend[i].unit) then
                        if cast.renew(br.friend[i].unit) then return end
                    end
                end                    
            end
        -- Dispel Magic
            if isChecked("Dispel Magic") and canDispel("target",spell.dispelMagic) and not isBoss() and ObjectExists("target") then
                if cast.dispelMagic() then return end
            end
        -- Moving
            if isMoving("player") then
                if isChecked("Angelic Feather") and talent.angelicFeather and not buff.angelicFeather.exists("player") then
                    if cast.angelicFeather("player") then
                        RunMacroText("/stopspelltarget")
                    end
                end
                -- Body and Mind
                if isChecked("Body and Mind") and talent.bodyAndMind then
                    if cast.bodyAndMind("player") then return end
                end
            end
        end -- End Action List - Single Target
        -- DPS
        function actionList_DPS()
        -- Holy Word: Chastise
            if cast.holyWordChastise() then return end
        -- Holy Fire
            if cast.holyFire() then return end
        -- Divine Star
            if getDistance("player","target") < 24 and getFacing("player","target",10) then
                if cast.divineStar() then return end
            end
        -- Smite
            if #enemies.yards8 < 3 then
                if cast.smite() then return end
            end
        -- Holy Nova
            if #enemies.yards8 >= 3 and getDistance(units.dyn8AoE) < 12 and level > 25 then
                if cast.holyNova() then return end
            end
        end
-----------------
--- Rotations ---
-----------------
        -- Pause
        if pause() or mode.rotation == 4 then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and not IsMounted() then
                actionList_Extras()
                if isChecked("OOC Healing") then
                    actionList_PreCombat()
                end
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat and not IsMounted() then
                actionList_Defensive()
                actionList_Cooldowns()
            	actionList_AOEHealing()
            	actionList_SingleTarget()
                if br.player.mode.dps == 1 then
                    actionList_DPS()
                end
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation 
local id = 257
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
local rotationName = "Svs" 

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range", highlight = 1, icon = br.player.spell.wildGrowth },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used", highlight = 0, icon = br.player.spell.wildGrowth },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used", highlight = 0, icon = br.player.spell.regrowth },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.rejuvenation}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection", highlight = 1, icon = br.player.spell.tranquility },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target", highlight = 0, icon = br.player.spell.tranquility },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used", highlight = 0, icon = br.player.spell.tranquility }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns", highlight = 1, icon = br.player.spell.barkskin },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used", highlight = 0, icon = br.player.spell.barkskin }
    };
    CreateButton("Defensive",3,0)
-- Decurse Button
    DecurseModes = {
        [1] = { mode = "On", value = 1 , overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 1, icon = br.player.spell.naturesCure },
        [2] = { mode = "Off", value = 2 , overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.naturesCure }
    };
    CreateButton("Decurse",4,0)
-- DPS Button
    DPSModes = {
        [1] = { mode = "On", value = 1 , overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 1, icon = br.player.spell.rake },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.regrowth }
    };
    CreateButton("DPS",5,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
    -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            br.ui:createCheckbox(section,"OOC Healing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.")
        -- Travel Shapeshifts
            br.ui:createCheckbox(section,"Auto Shapeshifts","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to best form for situation|cffFFBB00.")
        -- Break Crowd Control
            br.ui:createCheckbox(section,"Break Crowd Control","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to break crowd control|cffFFBB00.")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Flask / Crystal
            br.ui:createCheckbox(section,"Flask / Crystal")
         -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        --Incarnation: Tree of Life
            br.ui:createSpinner(section, "Incarnation: Tree of Life",  60,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinner(section, "Incarnation: Tree of Life Targets",  3,  0,  40,  1,  "Minimum Flourish Targets")
-- Tranquility
            br.ui:createSpinner(section, "Tranquility",  50,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinner(section, "Tranquility Targets",  3,  0,  40,  1,  "Minimum Tranquility Targets")
        -- Flourish
            br.ui:createSpinner(section, "Flourish",  80,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinner(section, "Flourish Targets",  3,  0,  40,  1,  "Minimum Flourish Targets")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Rebirth
            br.ui:createCheckbox(section,"Rebirth")
            br.ui:createDropdownWithout(section, "Rebirth - Target", {"|cff00FF00Target","|cffFF0000Mouseover","|cffFFBB00Auto"}, 1, "|cffFFFFFFTarget to cast on")
        -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at");
        -- Barkskin
            br.ui:createSpinner(section, "Barkskin",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at");
        -- Renewal
            br.ui:createSpinner(section, "Renewal",  70,  0,  100,  5,  "|cffFFBB00Health Percentage to use at");
        br.ui:checkSectionState(section)
    -- Healing Options
        section = br.ui:createSection(br.ui.window.profile, "Healing")
        -- Efflorescence
            br.ui:createCheckbox(section,"Efflorescence","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFEfflorescence usage|cffFFBB00.")
            br.ui:createSpinner(section, "Efflorescence recast delay", 15, 8, 29, 2, "|cffFFFFFFDelay to recast Efflo in seconds|cffFFBB00.","", true)
        -- Lifebloom
            br.ui:createCheckbox(section,"Lifebloom","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFLifebloom usage|cffFFBB00.")
        -- Cenarion Ward
            br.ui:createSpinner(section, "Cenarion Ward",  70,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Rejuvenaion
            br.ui:createSpinner(section, "Rejuvenation",  90,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Max Rejuvenation Targets",  10,  0,  20,  1,  "|cffFFFFFFMaximum Rejuvenation Targets","", true)
        -- Germination
            br.ui:createSpinner(section, "Germination",  70,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createCheckbox(section,"Germination on tank only","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFGermination on tank usage|cffFFBB00.")
        -- Regrowth
            br.ui:createSpinner(section, "Regrowth",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Regrowth Clearcasting
            br.ui:createSpinner(section, "Regrowth Clearcasting",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Regrowth on tank
            br.ui:createCheckbox(section,"Keep Regrowth on tank","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFRegrowth usage|cffFFBB00.")
        -- Swiftmend
            br.ui:createSpinner(section, "Swiftmend",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Healing Touch
            br.ui:createSpinner(section, "Healing Touch",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Ironbark
            br.ui:createSpinner(section, "Ironbark",  30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Wild Growth
            br.ui:createSpinner(section, "Wild Growth",  80,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinner(section, "Wild Growth Targets",  3,  0,  40,  1,  "Minimum Wild Growth Targets")            
        -- Essence of G'Hanir
            br.ui:createSpinner(section, "Essence of G'Hanir",  70,  0,  100,  5,  "Health Percent to Cast At") 
            br.ui:createSpinner(section, "Essence of G'Hanir Targets",  3,  0,  40,  1,  "Minimum Wild Growth Targets")
        br.ui:checkSectionState(section)
    -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
        -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
        -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
        -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
        -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugRestoration", 0.1) then
        --print("Running: "..rotationName)

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
        local clearcast                                     = br.player.buff.clearcasting.exists
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local combo                                         = br.player.power.amount.comboPoints
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
        local stealthed                                     = UnitBuffID("player",5215) ~= nil
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mana                                          = br.player.power.mana.percent
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk        
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power.amount.mana, br.player.power.mana.max, br.player.power.regen
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local recharge                                      = br.player.recharge
        local rejuvCount                                    = 0
        local rkTick                                        = 3
        local rpTick                                        = 2
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local travel, flight, cat, moonkin, noform          = br.player.buff.travelForm.exists(), br.player.buff.flightForm.exists(), br.player.buff.catForm.exists(), br.player.buff.moonkinForm.exists(), GetShapeshiftForm()==0
        local ttm                                           = br.player.power.ttm
        local units                                         = units or {}
        local lowestTank                                    = {}    --Tank
        local bloomCount                                    = 0
        local tHp                                           = 95

        units.dyn5 = br.player.units(5)
        units.dyn8    = br.player.units(8)
        units.dyn40 = br.player.units(40)

        enemies.yards5  = br.player.enemies(5)
        enemies.yards8  = br.player.enemies(8)
        enemies.yards40 = br.player.enemies(40)

        if isCastingSpell(spell.healingTouch) and buff.clearcasting.exists() then
            SpellStopCasting()
        end

        --ChatOverlay("|cff00FF00Abundance stacks: "..buff.abundance.stack().."")

--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
        -- Shapeshift Form Management
            if isChecked("Auto Shapeshifts") then
            -- Flight Form
                if IsFlyableArea() and ((not (isInDraenor() or isInLegion())) or isKnown(191633)) and not swimming and falling > 1 and level>=58 then
                    if cast.travelForm() then return end
                end
            -- Travel Form
                if swimming and not travel and not hastar and not deadtar and not buff.prowl.exists() then
                    if cast.travelForm() then return end
                end
                if moving and not travel and not IsMounted() and not IsIndoors() then
                    if cast.travelForm() then return end
                end
            -- Cat Form
                if not cat and not IsMounted() then
                    -- Cat Form when not swimming or flying or stag and not in combat
                    if not inCombat and moving and not swimming and not flying and not travel and not isValidUnit("target") then
                        if cast.catForm() then return end
                    end
                end
            end -- End Shapeshift Form Management
        end -- End Action List - Extras
        -- Action List - Pre-Combat
        function actionList_PreCombat()
            -- Rejuvenation
            if isChecked("Rejuvenation") then
                rejuvCount = 0
                for i=1, #br.friend do
                    if buff.rejuvenation.remain(br.friend[i].unit) > 1 then
                        rejuvCount = rejuvCount + 1
                    end
                end
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Germination") and talent.germination and (rejuvCount < getValue("Max Rejuvenation Targets")) and not buff.rejuvenationGermination.exists(br.friend[i].unit) then
                        if cast.rejuvenation(br.friend[i].unit) then return end
                    elseif br.friend[i].hp <= getValue("Rejuvenation") and buff.rejuvenation.remain(br.friend[i].unit) <= 1 and (rejuvCount < getValue("Max Rejuvenation Targets")) then
                        if cast.rejuvenation(br.friend[i].unit) then return end     
                    end
                end
            end
            -- Regrowth
           if isChecked("Regrowth") and lastSpell ~= spell.regrowth then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Regrowth Clearcasting") and buff.clearcasting.remain() > 1.5 then
                        if cast.regrowth(br.friend[i].unit) then return end     
                    elseif br.friend[i].hp <= getValue("Regrowth") and buff.regrowth.remain(br.friend[i].unit) <= 1 then
                        if cast.regrowth(br.friend[i].unit) then return end     
                    end
                end
            end
            -- Swiftmend
           if isChecked("Swiftmend") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Swiftmend") then
                        if cast.swiftmend(br.friend[i].unit) then return end     
                    end
                end
            end
        end  -- End Action List - Pre-Combat
        function actionList_Cooldowns()
            if useCDs() then
            -- Incarnation: Tree of Life
                if isChecked("Incarnation: Tree of Life") and talent.incarnationTreeOfLife and not buff.incarnationTreeOfLife.exists() and not isCastingSpell(spell.tranquility) then
                    if getLowAllies(getValue("Incarnation: Tree of Life")) >= getValue("Incarnation: Tree of Life Targets") then    
                        if cast.incarnationTreeOfLife() then return end    
                    end
                end
            -- Flourish
                if isChecked("Flourish") and talent.flourish and not isCastingSpell(spell.tranquility) then
                    if getLowAllies(getValue("Flourish")) >= getValue("Flourish Targets") then    
                        if cast.flourish() then return end    
                    end
                end
            -- Tranquility
                if isChecked("Tranquility") and not isCastingSpell(spell.tranquility) and not buff.incarnationTreeOfLife.exists() then
                    if getLowAllies(getValue("Tranquility")) >= getValue("Tranquility Targets") then    
                        if cast.tranquility() then return end    
                    end
                end
            -- Innervate
                if not isCastingSpell(spell.tranquility) and mana ~= nil then
                    if getLowAllies(getValue("Essence of G'Hanir")) >= getValue("Essence of G'Hanir Targets") and mana < 80 then    
                        if cast.innervate("player") then return end    
                    end
                end
            -- Trinkets
                if isChecked("Trinkets") and getDistance(units.dyn5) < 5 then
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
            -- Wild Growth
            if isChecked("Wild Growth") and not isCastingSpell(spell.tranquility) and not moving then
                if getLowAllies(getValue("Wild Growth")) >= getValue("Wild Growth Targets") then    
                    if cast.wildGrowth() then return end    
                end
            end
            -- Essence of G'Hanir
            if isChecked("Essence of G'Hanir") and not isCastingSpell(spell.tranquility) then
                if getLowAllies(getValue("Essence of G'Hanir")) >= getValue("Essence of G'Hanir Targets") then    
                    if cast.essenceOfGhanir() then return end    
                end
            end
        end
        -- Single Target
        function actionList_SingleTarget()
            -- Nature's Cure
            if br.player.mode.decurse == 1 then
                for i = 1, #br.friend do
                    for n = 1,40 do
                        local buff,_,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                        if buff then
                            if bufftype == "Curse" or bufftype == "Magic" or bufftype == "Poison" then
                                if cast.naturesCure(br.friend[i].unit) then return end
                            end
                        end
                    end
                end
            end
            -- Ironbark
            if isChecked("Ironbark") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Ironbark") then
                        if cast.ironbark(br.friend[i].unit) then return end     
                    end
                end
            end
            -- Swiftmend
           if isChecked("Swiftmend") and not isCastingSpell(spell.tranquility) then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Swiftmend") then
                        if cast.swiftmend(br.friend[i].unit) then return end     
                    end
                end
            end
            -- Lifebloom
            if isChecked("Lifebloom") and not isCastingSpell(spell.tranquility) then
                if inInstance then    
                    for i = 1, #br.friend do
                        if not buff.lifebloom.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                            if cast.lifebloom(br.friend[i].unit) then return end
                        end
                    end              
                else 
                    if inRaid then
                        bloomCount = 0
                        for i=1, #br.friend do
                            if buff.lifebloom.exists(br.friend[i].unit) then
                                bloomCount = bloomCount + 1
                            end
                        end
                        for i = 1, #br.friend do
                            if bloomCount < 1 and not buff.lifebloom.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                                if cast.lifebloom(br.friend[i].unit) then return end
                            end
                        end
                    end
                end
            end
            -- Cenarion Ward
           if isChecked("Cenarion Ward") and talent.cenarionWard and not isCastingSpell(spell.tranquility) then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Cenarion Ward") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" and not buff.cenarionWard.exists(br.friend[i].unit) then
                        if cast.cenarionWard(br.friend[i].unit) then return end     
                    end
                end
            end
            -- Regrowth
           if isChecked("Regrowth") and lastSpell ~= spell.regrowth then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Regrowth Clearcasting") and buff.clearcasting.remain() > 1.5 then
                        if cast.regrowth(br.friend[i].unit) then return end
                    elseif isChecked("Keep Regrowth on tank") and buff.lifebloom.exists(br.friend[i].unit) and buff.regrowth.remain(br.friend[i].unit) <= 1 and br.friend[i].hp <= getValue("Regrowth") then
                        if cast.regrowth(br.friend[i].unit) then return end
                    elseif br.friend[i].hp <= getValue("Regrowth") and buff.regrowth.remain(br.friend[i].unit) <= 1 then
                        if talent.abundance and buff.abundance.stack() < 3 then
                            if cast.regrowth(br.friend[i].unit) then return end
                        elseif not talent.abundance then
                            if cast.regrowth(br.friend[i].unit) then return end
                        end
                    end
                end
            end
            -- Healing Touch with abundance stacks >= 5
           if isChecked("Healing Touch") and not isCastingSpell(spell.tranquility) then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Healing Touch") and talent.abundance and buff.abundance.stack() >= 5 then
                        if cast.healingTouch(br.friend[i].unit) then return end
                    end
                end
            end
            -- Rejuvenation
            if isChecked("Rejuvenation") then
                rejuvCount = 0
                for i=1, #br.friend do
                    if buff.rejuvenation.remain(br.friend[i].unit) > 1 then
                        rejuvCount = rejuvCount + 1
                    end
                end
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Germination") and talent.germination and (rejuvCount < getValue("Max Rejuvenation Targets")) and not buff.rejuvenationGermination.exists(br.friend[i].unit) then
                        if isChecked("Germination on tank only") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                            if cast.rejuvenation(br.friend[i].unit) then return end
                        elseif not isChecked("Germination on tank only") then
                            if cast.rejuvenation(br.friend[i].unit) then return end
                        end
                    elseif br.friend[i].hp <= getValue("Rejuvenation") and buff.rejuvenation.remain(br.friend[i].unit) <= 1 and (rejuvCount < getValue("Max Rejuvenation Targets")) then
                        if cast.rejuvenation(br.friend[i].unit) then return end     
                    end
                end
            end
            -- Healing Touch
           if isChecked("Healing Touch") and not isCastingSpell(spell.tranquility) then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Healing Touch") then
                        if talent.abundance and buff.abundance.stack() >= 3 then
                            --ChatOverlay("Casting HT! |cff00FF00Abundance stacks: "..buff.abundance.stack().."")
                            if cast.healingTouch(br.friend[i].unit) then return end
                        elseif not talent.abundance then
                            if cast.healingTouch(br.friend[i].unit) then return end
                        end
                    end
                end
            end
            -- Oh Shit! Regrowth
           if isChecked("Regrowth") and not isCastingSpell(spell.tranquility) then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= 30 then 
                        if talent.abundance and buff.abundance.stack() < 3 then
                            if cast.regrowth(br.friend[i].unit) then return end
                        elseif not talent.abundance then
                            if cast.regrowth(br.friend[i].unit) then return end
                        end
                    end
                end
            end
            -- Ephemeral Paradox trinket
            if hasEquiped(140805) and getBuffRemain("player", 225766) > 2 then
                if cast.healingTouch("player") then return end
            end
        end
    -- Action List - DPS
        local function actionList_DPS()
        -- Guardian Affinity/Level < 45
            if talent.guardianAffinity or level < 45 then
            -- Sunfire
                if not debuff.sunfire.exists(units.dyn40) then
                    if cast.sunfire(units.dyn40) then return end
                end
            -- Moonfire
                if not debuff.moonfire.exists(units.dyn40) then
                    if cast.moonfire(units.dyn40) then return end
                end
            -- Solar Wrath
                if cast.solarWrath() then return end
            end 
        -- Feral Affinity
            if talent.feralAffinity then
            -- Cat form
                if not cat and getDistance(units.dyn5) < 5 then
                    if cast.catForm() then return end
                end
            -- Rake
                if combo < 5 then
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                        if getDistance(thisUnit) < 5 then
                            if not debuff.rake.exists(thisUnit) then
                                if cast.rake(thisUnit) then return end
                            end
                        end
                    end
                end
            -- Rip
                if combo == 5 then
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                        if getDistance(thisUnit) < 5 then
                            if not debuff.rip.exists(thisUnit) or debuff.rip.remain(thisUnit) < 4 then
                               if cast.rip(thisUnit) then return end
                            end
                        end
                    end
                end
            -- Ferocious Bite
                if combo == 5 then
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                        if getDistance(thisUnit) < 5 and debuff.rip.exists(thisUnit) then
                            if cast.ferociousBite(thisUnit) then return end
                        end
                    end
                end
            -- Swipe
                if ((mode.rotation == 1 and #enemies.yards8 >= 6) or mode.rotation == 2) then
                    if cast.swipe("player") then return end
                end
            -- Shred
                if combo < 5 and debuff.rake.exists(units.dyn5) and (((mode.rotation == 1 and #enemies.yards8 < 3) or mode.rotation == 3) or level < 32) then
                    if cast.shred(units.dyn5) then return end
                end
            end -- End - Feral Affinity
        -- Balance Affinity 
            if talent.balanceAffinity then
            -- Moonkin form
                if not moonkin and not moving and not travel and not IsMounted() then
                    if cast.moonkinForm() then return end
                end
            -- Lunar Strike 3 charges
                if buff.lunarEmpowerment.stack() == 3 then
                    if cast.lunarStrike() then return end
                end
            -- Starsurge
                if cast.starsurge() then return end
            -- Sunfire
                if not debuff.sunfire.exists(units.dyn40) then
                    if cast.sunfire(units.dyn40) then return end
                end
            -- Moonfire
                if not debuff.moonfire.exists(units.dyn40) then
                    if cast.moonfire(units.dyn40) then return end
                end
            -- Lunar Strike charged
                if buff.lunarEmpowerment.exists() then
                    if cast.lunarStrike() then return end
                end
            -- Solar Wrath charged
                if buff.solarEmpowerment.exists() then
                    if cast.solarWrath() then return end
                end
            -- Solar Wrath uncharged
                if cast.solarWrath() then return end
            -- Lunar Strike uncharged
                if cast.lunarStrike() then return end
            end -- End -- Balance Affinity
        end -- End Action List - DPS
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
            if not inCombat and not IsMounted() and not stealthed and getBuffRemain("player", 192002 ) < 10 then
                actionList_Extras()
                if isChecked("OOC Healing") then
                    actionList_PreCombat()
                end
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat and not IsMounted() and not stealthed and getBuffRemain("player", 192002 ) < 10 then
            -- Barkskin
                if isChecked("Barkskin") then
                    if php <= getOptionValue("Barkskin") and inCombat then
                        if cast.barkskin() then return end
                    end
                end
            -- Renewal
                if isChecked("Renewal") and talent.renewal then
                    if php <= getOptionValue("Renewal") and inCombat then
                        if cast.renewal() then return end
                    end
                end
            -- Healthstone
                if isChecked("Healthstone") and php <= getOptionValue("Healthstone") 
                    and inCombat and (hasHealthPot() or hasItem(5512)) 
                then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healPot) then
                        useItem(healPot)
                    end
                end
            -- Rebirth
                if isChecked("Rebirth") then
                    if getOptionValue("Rebirth - Target") == 1 
                        and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                    then
                        if cast.rebirth("target","dead") then return end
                    end
                    if getOptionValue("Rebirth - Target") == 2 
                        and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                    then
                        if cast.rebirth("mouseover","dead") then return end
                    end
                    if getOptionValue("Rebirth - Target") == 3 then
                        for i =1, #br.friend do
                            if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsFriend(br.friend[i].unit,"player") then
                                if cast.rebirth(br.friend[i].unit,"dead") then return end
                            end
                        end
                    end
                end
            -- Efflorescence
                if isChecked("Efflorescence") and not moving and (not LastEfflorescenceTime or GetTime() - LastEfflorescenceTime > getOptionValue("Efflorescence recast delay")) then
                    -- castGroundAtBestLocation(spellID, radius, minUnits, maxRange, minRange, spellType)
                    if castGroundAtBestLocation(spell.efflorescence, 20, 0, 40, 0, "heal") then
                        LastEfflorescenceTime = GetTime()
                        return 
                    end
                end
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
local id = 105
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

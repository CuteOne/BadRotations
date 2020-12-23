local rotationName = "immyc"
immy = true
local br = br
br.rogueTables = {}
local rogueTables = br.rogueTables
rogueTables.enemyTable5, rogueTables.enemyTable10, rogueTables.enemyTable30 = {}, {}, {}
local enemyTable5, enemyTable10, enemyTable30 = rogueTables.enemyTable5, rogueTables.enemyTable10, rogueTables.enemyTable30

---------------
--- Toggles ---
---------------
local function createToggles()
    RotationModes = {
        [1] = { mode = "", value = 1 , overlay = "DPS Rotation Enabled", tip = "Enable DPS Rotation", highlight = 1, icon = br.player.spell.toxicBlade},
        [2] = { mode = "", value = 2 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.crimsonVial}
    };
    CreateButton("Rotation",1,0)
    CleaveModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "Cleave on.", highlight = 1, icon = br.player.spell.rupture},
        [2] = { mode = "", value = 2 , overlay = "", tip = "Cleave off.", highlight = 0, icon = br.player.spell.rupture}
    };
    CreateButton("Cleave",2,0)
    InterruptModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.kick},
        [2] = { mode = "T", value = 2 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.kick},
        [3] = { mode = "", value = 3 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.kick}
    };
    CreateButton("Interrupt",3,0)
    StunModes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.kidneyShot},
        [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.kidneyShot}
    };
    CreateButton("Stun",3,1)
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
    CreateButton("Feint",2,1)
    Van1Modes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.crimsonTempest},
        [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.crimsonTempest},
    };
    CreateButton("Van1",5,0)   
    Van2Modes = {
        [1] = { mode = "", value = 1 , overlay = "", tip = "", highlight = 1, icon = br.player.spell.vanish},
        [2] = { mode = "", value = 2 , overlay = "", tip = "", highlight = 0, icon = br.player.spell.vanish},
    };
    CreateButton("Van2",5,1)   
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
            br.ui:createCheckbox(section, "debug2")            
            br.ui:createCheckbox(section, "Show hitbox+back")
            br.ui:createCheckbox(section, "Viable targets")
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
            br.ui:createCheckbox(section, "Search for orb/ghuunies")
            br.ui:createCheckbox(section, "Check AA")
            br.ui:createCheckbox(section, "Opener refresh")
            br.ui:createCheckbox(section, "Exsa no vendetta opener")
            br.ui:createCheckbox(section, "Toxic Blade on cd")
            br.ui:createSpinnerWithout(section, "Dots HP Limit", 15, 0, 105, 1, "|cffFFFFFFHP *10k hp for dots to be AOE casted/refreshed on.")
            --br.ui:createSpinnerWithout(section, "Max Garrotes refresh SS",  3,  1,  6,  1,  "max garrotes ss")
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


        section = br.ui:createSection(br.ui.window.profile, "Special")
            br.ui:createCheckbox(section, "AutoKidney", "|cffFFFFFF Auto Kidney dangerous casts")
            br.ui:createCheckbox(section, "AutoBlind", "|cffFFFFFF Auto Blind dangerous casts")
            br.ui:createCheckbox(section, "ShadowStep cam fixed", "Cam fix for perverts")
        br.ui:checkSectionState(section)

        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            br.ui:createCheckbox(section, "Kick")
            br.ui:createCheckbox(section, "Kidneyshot")
            br.ui:createCheckbox(section, "Blind")
            br.ui:createSpinner(section,  "Interrupt At",  0,  0,  100,  5,  "|cffFFBB00Cast Percentage to use at.")
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
--if not incomingskillz then incomingskillz = {} end
local f = CreateFrame("Frame")
--check = {}
            
            -- function f:NAME_PLATE_UNIT_ADDED(unit)
            --     check[UnitGUID(unit)] = unit
            -- end
            -- function f:NAME_PLATE_UNIT_REMOVED(unit)
            --     check[UnitGUID(unit)] = nil
            -- end
            
            -- function f:COMBAT_LOG_EVENT_UNFILTERED(_,eventType,hideCaster,sourceGUID,srcName,sourceFlags,sourceRaidFlags,destGUID,destName,destFlags, destRaidFlags,spellID,spellName,_,param1,_,_,param4)
            --     if subevent == "SPELL_CAST_START" then
            --         local unit = check[sourceGUID]
            --         if unit and UnitIsUnit(unit.."target", "player") and bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 then
            --             cloak = true
            --         end
            --     end
            -- end
            -- function f:PLAYER_REGEN_DISABLED()
            --     print("123")
            -- end
            -- function f:PLAYER_REGEN_ENABLED()
            --     print("1234")
            -- end
            -- f:SetScript("OnEvent", function(self, event, ...)
            --     f[event](self, ...)
            -- end)
            -- f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            f:RegisterEvent("UNIT_SPELLCAST_SENT")
            --f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
            f:RegisterEvent("UNIT_AURA")
            -- f:RegisterEvent("NAME_PLATE_UNIT_ADDED")
            -- f:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
            f:SetScript("OnEvent", function(self, event, ...)
                -- if event == NAME_PLATE_UNIT_ADDED(unit) then
                --     check[guid(unit)] = unit
                -- end
                -- if event == NAME_PLATE_UNIT_REMOVED(unit) then
                --     check[guid(unit)] = nil
                -- end
                
                if event == "UNIT_SPELLCAST_SENT" then
                    local source    = select(1,...)
                    local spell     = select(4,...)
                    if source == "player" and spell == 36554 and isChecked("ShadowStep cam fixed") then
                        face = ObjectFacing("player")
                    end
                    --print(encounterID)
                end
                if event == "UNIT_AURA" then
                    local source    = select(1,...)
                    if face ~= nil and source == "player" then
                        FaceDirection(face, true)
                        face = nil
                    end
                end
                -- if event == "UNIT_SPELLCAST_SUCCEEDED" then
                --     local source    = select(1,...)
                --     local spell     = select(3,...)
                --     if source == "player" and spell == 36554 then
                --             print("ss")
                --             FaceDirection(face, true)
                --             face = nil
                --     end
                --     --print(encounterID)
                -- end
                -- if event == "PLAYER_REGEN_ENABLED" then
                --     encounterID = false
                -- end
                -- if event == "COMBAT_LOG_EVENT_UNFILTERED" then
                --     local _,eventType,hideCaster,sourceGUID,srcName,sourceFlags,sourceRaidFlags,destGUID,destName,destFlags, destRaidFlags,spellID,spellName,_,param1,_,_,param4 = CombatLogGetCurrentEventInfo()
                --     if eventType == "SPELL_CAST_SUCCESS" and sourceGUID == UnitGUID("player") then
                --         if spellID == 36554 then 
                            
                --         end
                --     end
                -- --     -- if eventType == "SWING_DAMAGE" and srcName == UnitName("player") then
                -- --     --     shadtechn = shadtechn + 1
                -- --     -- end
                -- --     -- if eventType == "SPELL_DAMAGE" and srcName == UnitName("player") then
                -- --     --     if spellID == 121473 then
                -- --     --         shadtechn = shadtechn + 1
                -- --     --     end
                -- --     -- end
                -- --     -- if eventType == "SPELL_ENERGIZE" and srcName == UnitName("player") and spellID == 196911 then
                -- --     --      shadtechn = 0
                -- --     -- end
                -- --     -- if eventType == "SPELL_CAST_START" then
                -- --     --     spellonPlayerTEndTime, _, _, _, spellonPlayer = select(5,UnitCastingInfo(GetObjectWithGUID(sourceGUID)))
                -- --     --     local finishTime = spellonPlayerTEndTime - GetTime()
                -- --     --     tinsert(incomingskillz,{id = spellID, unit = GetObjectWithGUID(sourceGUID), time = spellonPlayerTEndTime})
                -- --     --     print(CombatLogGetCurrentEventInfo())
                -- --     --     print(finishTime)
                -- --     -- end
                -- --     if eventType == "SPELL_CAST_SUCCESS" and destGUID == UnitGUID("player") then
                -- --         --print(spellID)
                -- --     end
                -- end
            end)
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
        br.player.ui.mode.interrupt = br.data.settings[br.selectedSpec].toggles["Interrupt"]
        UpdateToggle("Cleave",0.25)
        br.player.ui.mode.cleave = br.data.settings[br.selectedSpec].toggles["Cleave"]        
        UpdateToggle("Opener",0.25)
        br.player.ui.mode.opener = br.data.settings[br.selectedSpec].toggles["Opener"]
        UpdateToggle("Stun",0.25)
        br.player.ui.mode.stun = br.data.settings[br.selectedSpec].toggles["Stun"]      
        UpdateToggle("Feint",0.25)
        br.player.ui.mode.feint = br.data.settings[br.selectedSpec].toggles["Feint"]
        UpdateToggle("Van1",0.25)
        br.player.ui.mode.van1 = br.data.settings[br.selectedSpec].toggles["Van1"]
        UpdateToggle("Van2",0.25)
        br.player.ui.mode.van2 = br.data.settings[br.selectedSpec].toggles["Van2"]        
        UpdateToggle("Special",0.25)
        br.player.ui.mode.special = br.data.settings[br.selectedSpec].toggles["Special"]        
--------------
--- Locals ---
--------------
        local attacktar                                     = UnitCanAttack("target","player")
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local poolcast                                      = br.player.poolcast
        local cd                                            = br.player.cd
        local combo, comboDeficit, comboMax                 = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
        local combospend                                    = ComboMaxSpend()
        local cTime                                         = getCombatTime()
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local gcd                                           = getSpellCD(61304)
        local gcdMax                                        = br.player.gcdMax
        local hastar                                        = GetObjectExists("target")
        local healPot                                       = getHealthPot()
        local inCombat                                      = isInCombat("player")
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local mode                                          = br.player.ui.mode
        local multidot                                      = (br.player.ui.mode.cleave == 1 or br.player.ui.mode.rotation == 2) and br.player.ui.mode.rotation ~= 3
        local php                                           = br.player.health
        local power, powerDeficit, powerRegen               = br.player.power.energy.amount(), br.player.power.energy.deficit(), br.player.power.energy.regen()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local solo                                          = #br.friend < 2
        local spell                                         = br.player.spell
        local stealth                                       = br.player.buff.stealth.exists()
        local stealthingAll                                 = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowmeld.exists()
        local stealthingRogue                               = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or (br.player.buff.subterfuge.exists() and br.player.buff.subterfuge.remain() >= 0.3)
        local talent                                        = br.player.talent
        local trait                                         = br.player.traits
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.energy.ttm()
        local units                                         = br.player.units
        local lootDelay                                     = getOptionValue("LootDelay")
        --if stealthingRogue then print(br.player.buff.subterfuge.remain()) end
        --if asd then MouselookStop() end
        dotHPLimit = getOptionValue("Dots HP Limit") * 10000
        local sSActive
        if trait.shroudedSuffocation.active then sSActive = 1 else sSActive = 0 end


--______________________________________
    enemies.get(20)
    enemies.get(20,"player",true)
    enemies.get(30)

    local function isTotem(unit)
        local eliteTotems = { -- totems we can dot
            [125977] = "Reanimate Totem",
            [127315] = "Reanimate Totem",
            [146731] = "Zombie Dust Totem"
        }
        local creatureType = UnitCreatureType(unit)
        local objectID = GetObjectID(unit)
        if creatureType ~= nil and eliteTotems[objectID] == nil then
            if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then return true end
        end
        return false
    end

    local function noDotCheck(unit)
        if isChecked("Dot Blacklist") and (noDotUnits[GetObjectID(unit)] or UnitIsCharmed(unit)) then return true end
        if isTotem(unit) then return true end
        local unitCreator = UnitCreator(unit)
        if unitCreator ~= nil and UnitIsPlayer(unitCreator) ~= nil and UnitIsPlayer(unitCreator) == true then return true end
        if GetObjectID(unit) == 137119 and getBuffRemain(unit, 271965) > 0 then return true end
        return false
    end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function clearTable(t)
        local count = #t
        for i=0, count do t[i]=nil end
    end

    clearTable(enemyTable5)
    clearTable(enemyTable10)
    clearTable(enemyTable30)
    local deadlyPoison10 = true
    if #enemies.yards30 > 0 then
        local highestHP
        local lowestHP
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if (not noDotCheck(thisUnit) or GetUnitIsUnit(thisUnit, "target")) and not UnitIsDeadOrGhost(thisUnit) and (mode.cleave == 1 or (mode.cleave == 2 and GetUnitIsUnit(thisUnit, "target"))) then
                local enemyUnit = {}
                enemyUnit.unit = thisUnit
                enemyUnit.ttd = ttd(thisUnit)
                enemyUnit.distance = getDistance(thisUnit)
                enemyUnit.hpabs = UnitHealth(thisUnit)
                enemyUnit.facing = getFacing("player",thisUnit)
                tinsert(enemyTable30, enemyUnit)
                if highestHP == nil or highestHP < enemyUnit.hpabs then highestHP = enemyUnit.hpabs end
                if lowestHP == nil or lowestHP > enemyUnit.hpabs then lowestHP = enemyUnit.hpabs end
                if enemyTable30.lowestTTDUnit == nil or enemyTable30.lowestTTD > enemyUnit.ttd then
                    enemyTable30.lowestTTDUnit = enemyUnit.unit
                    enemyTable30.lowestTTD = enemyUnit.ttd
                end
            end
        end
        if #enemyTable30 > 1 then
            for i = 1, #enemyTable30 do
                local hpNorm = (10-1)/(highestHP-lowestHP)*(enemyTable30[i].hpabs-highestHP)+10 -- normalization of HP value, high is good
                if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0/0) then hpNorm = 0 end -- NaN check
                local enemyScore = hpNorm
                if enemyTable30[i].facing then enemyScore = enemyScore + 30 end -- ??
                if enemyTable30[i].ttd > 1.5 then enemyScore = enemyScore + 5 end
                if enemyTable30[i].distance <= 5 then enemyScore = enemyScore + 30 end
                local raidTarget = GetRaidTargetIndex(enemyTable30[i].unit)
                if raidTarget ~= nil then 
                    enemyScore = enemyScore + raidTarget * 3
                    if raidTarget == 8 then enemyScore = enemyScore + 5 end
                end
                --if UnitBuffID(enemyTable30[i].unit, 277242) then enemyScore = enemyScore + 50 end -- ghuun check
                if UnitBuffID(enemyTable30[i].unit, 79140) then enemyScore = enemyScore + 50 end  --vend score
                enemyTable30[i].enemyScore = enemyScore
            end
            table.sort(enemyTable30, function(x,y)
                return x.enemyScore > y.enemyScore
            end)
        end
        for i = 1, #enemyTable30 do
            local thisUnit = enemyTable30[i]
            local fokIgnore = {
                [120651]=true -- Explosive
            }
            local objectID = GetObjectID(thisUnit.unit)
            if thisUnit.distance <= 10 then
                if fokIgnore[objectID] == nil and not isTotem(thisUnit.unit) then
                    tinsert(enemyTable10, thisUnit)
                    if deadlyPoison10 and not debuff.deadlyPoison.exists(thisUnit.unit) then deadlyPoison10 = false end
                end
                --if debuff.garrote.remain(thisUnit.unit) > 0.5 then garroteCount = garroteCount + 1 end
                if thisUnit.distance <= 5 then
                    tinsert(enemyTable5, thisUnit)
                end
            end
        end
        if #enemyTable5 > 1 then
            table.sort(enemyTable5, function(x)
                if GetUnitIsUnit(x.unit, "target") then
                    return true
                else
                    return false
                end
            end)
        end
        if isChecked("Auto Target") and inCombat and #enemyTable30 > 0 and ((GetUnitExists("target") and UnitIsDeadOrGhost("target") and not GetUnitIsUnit(enemyTable30[1].unit, "target")) or not GetUnitExists("target")) then
            TargetUnit(enemyTable30[1].unit)
        end
    end
    --Just nil fixes
    if enemyTable30.lowestTTD == nil then enemyTable30.lowestTTD = 999 end
    local enemies10 = #enemyTable10
    local ttdval = enemies10 <= 1 and 4 or 12

    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        


           
        
        local function bleedscount()
            local counter = 0
            for k, v in pairs(br.enemy) do
            local thisUnit = br.enemy[k].unit
                if GetObjectExists(thisUnit) then
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
        -- local function viabletargetcount()
        --     local counter = 0
        --     for i = 1, #enemies.yards5 do
        --                 local thisUnit = enemies.yards5[i]
        --                 if UnitHealth(thisUnit) > dotHPLimit and donotdot(thisUnit) then 
        --                     counter = counter + 1
        --                 end
        --     end
        --     return tonumber(counter)
        -- end
        --if #enemies.yards9 < 2 then singleTarget = true else singleTarget = false end
        --local bleeds = debuff.garrote.count() + debuff.rupture.count()
            --Energy_Regen_Combined = energy.regen+poisoned_bleeds*7%(2*spell_haste);
        local energyRegenCombined = powerRegen + bleedscount() * 7 % (2 * (GetHaste()/100))
        --local energyRegenCombined = powerRegen + bleedscount() * 7 / (2*(1 / (1 + (GetHaste() / 100))))
        local BleedTickTime, ExsanguinatedBleedTickTime = 2 / GetHaste(), 1 / GetHaste()
        --print(ExsanguinatedBleedTickTime)
        if mode.opener == 2 or opener == nil then
            RUP1 = false
            GAR1 = false
            VEN1 = false
            MUTI1 = false
            RUP2 = false
            EXS1 = false
            VAN1 = false
            VANGAR = false
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
        --if getCombatTime() == 0 or cast.last.vanish() then garrotecountbuff = debuff.garrote.remainCount(1) end
        -- local function waitshit()
        --     if (mode.special == 2 and (not isBoss() or isDummy())) or mode.special == 1 then
        --          return true
        --     else
        --         return false
        --     end
        -- end
        -- function dotrangelos()
        -- local function drawHealers(healer)
        -- local LibDraw                   = LibStub("LibDraw-1.0")
        -- local facing                    = ObjectFacing("player")
        -- local playerX, playerY, playerZ = GetObjectPosition("player")
        -- local locateX, locateY, locateZ = GetObjectPosition(healer)
        -- local healerX, healerY, healerZ = GetObjectPosition(healer)
        -- if getLineOfSight("player",healer) then
        --     LibDraw.SetColor(0, 255, 0)
        -- else
        --     LibDraw.SetColor(255, 0, 0)
        -- end
        --     return LibDraw.Line(playerX, playerY, playerZ, healerX, healerY, healerZ)
        -- end
        -- for i = 1, #br.friend do
        --     local thisUnit = br.friend[i].unit
        --         if not GetUnitIsUnit(thisUnit,"player") and  UnitGroupRolesAssigned(thisUnit) == "HEALER" then
        --             drawHealers(thisUnit)
        --         end
        --     end
        -- end
        local dontdot = {
            [134503] = true, -- small adds on vel'
            [120651] = true, -- explosive orb
            [141851] = true, -- ghuunies
            [138530] = true, -- 1st uldirboss blob small ?
            --[144081] = true, -- dummy test
        }
        local function donotdot(unit)
            if dontdot[GetObjectID(unit)] or UnitHealth(unit) <= dotHPLimit then return false else return true end
        end
        local function viabletargetcount()
            local counter = 0
            for i = 1, #enemyTable5 do
                        local thisUnit = enemyTable5[i].unit
                        if UnitHealth(thisUnit) > dotHPLimit and donotdot(thisUnit) then 
                            counter = counter + 1
                        end
            end
            return tonumber(counter)
        end
        local function canvangar()
            local counter = 0
            for i = 1, #enemyTable5 do
                        local thisUnit = enemyTable5[i].unit
                        if donotdot(thisUnit) and debuff.garrote.remain(thisUnit) <= 5.4 and not debuff.garrote.exsang(thisUnit) then 
                            counter = counter + 1
                        end
            end
            return tonumber(counter)
            --if tonumber(counter) >= 3 then return true else return false end
        end
        local function fokcccheck()
            if getOptionCheck("Don't break CCs") then
                for i = 1, enemies10 do
                    local thisUnit = enemyTable10[i].unit
                        if isLongTimeCCed(thisUnit) then
                            return false
                        else return true
                        end
                end
            else return true
            end        
        end
        --print(donotdot("target"))
    --     local function Evaluate_Garrote_Target(unit)
    --   return TargetUnit:DebuffRefreshableP(S.Garrote, 5.4)
    --     and (TargetUnit:PMultiplier(S.Garrote) <= 1 or TargetUnit:DebuffRemainsP(S.Garrote) <= (HL.Exsanguinated(TargetUnit, "Garrote") and ExsanguinatedBleedTickTime or BleedTickTime) and EmpoweredDotRefresh())
    --     and (not HL.Exsanguinated(TargetUnit, "Garrote") or TargetUnit:DebuffRemainsP(S.Garrote) <= 1.5 and EmpoweredDotRefresh())
    --     and Rogue.CanDoTUnit(TargetUnit, GarroteDMGThreshold);
    -- end
        --local lowestDot = debuff.garrote.lowest(5,"remain")
        local function showviable()
            if GetUnitExists("target") and not UnitIsDeadOrGhost("target") then
                for i = 1, #br.om do
                            local thisUnit = br.om[i]
                            --print(thisUnit.unit)
                                if donotdot(thisUnit.unit) and ttd(thisUnit.unit) >= 5 then
                                        -- then
                                        local tX,tY,tZ = GetObjectPosition(thisUnit.unit)
                                        local playerX, playerY, playerZ = GetObjectPosition("player")
                                            if tX and tY  then
                                                if (getDistance(thisUnit.unit) > 5 and getDistance(thisUnit.unit) < 10) or (not getFacing("player",thisUnit.unit) and getDistance(thisUnit.unit) < 5)  then
                                                        LibDraw.SetColorRaw(1, 0, 0, 1)
                                                        LibDraw.Circle(tX, tY, playerZ, 1)
                                                        
                                                end
                                            end
                                end
                end
            end
        end
        -- if isChecked("Show hitbox+back") then
        --     if GetUnitExists("target") and not UnitIsDeadOrGhost("target") then
        --         local LibDraw = LibStub("LibDraw-1.0")
        --         local playerX, playerY, playerZ = GetObjectPosition("player")
        --         local tX,tY,tZ = GetObjectPosition("target")
        --         local combatReachUnit = max(1.5, UnitCombatReach("target"))
        --         local combatRange = max(6, UnitCombatReach("player") + combatReachUnit + 1.3)
        --         if DrawTime == nil then DrawTime = GetTime() end
        --         if tX and tY then
        --             LibDraw.clearCanvas()
        --                     LibDraw.Circle(tX, tY, playerZ, combatRange)
        --         end
        --     end
        -- end        
        
        local function startaa()
            for i = 1, #enemyTable5 do
                if not getFacing("player","target") then
                    local thisUnit = enemyTable5[i].unit
                    local firsttarget = GetObjectWithGUID(UnitGUID("target"))
                                        -- CastSpellByID(6603,thisUnit)
                                        -- CastSpellByID(6603,firsttarget)
                    --CastSpellByID(6603,thisUnit)
                    if cast.auto(thisUnit) then end
                    if cast.auto(firsttarget) then end
                end
            end
        end
        local function EmpoweredDotRefresh()
            return #enemies.get(9) >= 3 + (trait.shroudedSuffocation.active and 1 or 0)
        end
                  
            SLASH_SPECIAL1 = "/bursterino"
            SlashCmdList["SPECIAL"] = function(msg)
            if mode.special == 2 then
                    if toggle("Special",1) then return true end
                end
            end  

            -- SLASH_SPECIAL2 = "/shadowsteperino"
            -- SlashCmdList["SPECIAL"] = function(msg)
            --     local cd = GetSpellCooldown(36554)
            --     if cd == 0 then
            --         local face = ObjectFacing("Player");
            --         if cast.shadowstep("target") then C_Timer.After(.13, function() FaceDirection(face, true); end); return true end
            --     end
            -- end       
        local function waitenvenom()
            if --not (#enemies.yards5 <= 1 and debuff.rupture.remain("target") <= 3) and
                debuff.vendetta.exists("target") 
                --or debuff.rupture.exsang(units.dyn5)
                or debuff.garrote.exsang(units.dyn5)
                or debuff.toxicBlade.exists("target")
                or talent.elaboratePlanning and buff.elaboratePlanning.exists() and buff.elaboratePlanning.remain() <= 0.3
                or powerDeficit <= 25 + energyRegenCombined
                or debuff.rupture.exsang(units.dyn5) and debuff.rupture.remain(units.dyn5) <= 2
                or isChecked("No Pooling")
                or enemies10 >= 2
                or solo
            then
                return true
            else 
                return false
            end
        end
        function getapdmg(offHand)
            local useOH = offHand or false
            local wdpsCoeff = 6
            local ap = UnitAttackPower("player")
            local minDamage, maxDamage, minOffHandDamage, maxOffHandDamage, physicalBonusPos, physicalBonusNeg, percent = UnitDamage("player")
            local speed, offhandSpeed = UnitAttackSpeed("player")
                if useOH and offhandSpeed then
                    local wSpeed = offhandSpeed * (1 + GetHaste() / 100)
                    local wdps = (minOffHandDamage + maxOffHandDamage) / wSpeed / percent - ap / wdpsCoeff
                return (ap + wdps * wdpsCoeff) * 0.5
                else
                    local wSpeed = speed * (1 + GetHaste() / 100)
                    local wdps = (minDamage + maxDamage) / 2 / wSpeed / percent - ap / wdpsCoeff
                return ap + wdps * wdpsCoeff
            end
        end
        local function getctinitial()
            return(
                getapdmg() * 
                (combo + 1) * enemies10 * 0.036 *
                (1 + (GetMasteryEffect("player") / 100)) *
                (1 + ((GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100)) 
                * 1.27
                )
        end
        --print(getctinitial())
        local function getenvdamage(unit)
            if unit == nil then unit = "target" end
            local apMod         = getapdmg()
            local envcoef       = 0.16
            local auramult      = 1.27
            local masterymult   = (1 + (GetMasteryEffect("player") / 100))
            local versmult      = (1 + ((GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100))
            if talent.DeeperStratagem then dsmod = 1.05 else dsmod = 1 end 
            if debuff.toxicBlade.exists(unit) then tbmod = 1.3 else tbmod = 1 end
            return(
                    apMod * combo * envcoef * auramult * tbmod * dsmod * masterymult * versmult
                    )
        end
        --print(getenvdamage())

        local function burnpool()
            for i = 1, #enemyTable5 do
                        local thisUnit = enemyTable5[i].unit
                            if GetObjectID(thisUnit) == 120651 or GetObjectID(thisUnit) == 141851 --and getFacing("player", thisUnit) 
                                then
                                    if combo >= 4 or getenvdamage(thisUnit) >=  UnitHealth(thisUnit) then
                                        if cast.pool.envenom() then ChatOverlay("Pooling For env  adds") return true end
                                        if cast.envenom(thisUnit) then
                                            if isChecked("Debug") then print("env burn targets") end
                                        return true end
                                    else
                                        if cast.pool.mutilate() then ChatOverlay("Pooling For mutilate adds") return true end
                                        if cast.mutilate(thisUnit) then
                                            if isChecked("Debug") then print("muti burn targets") end
                                        return true end
                                    end
                            end
            end
        end
        

        -- local function poolcast(spell,unit)
        --     if cast.pool[spell] then return true end
        --     if CastSpellByID(spell,unit) then return end
        -- end

        local function usefiller() 
            -- return ((comboDeficit > 1 and debuff.garrote.remain("target") > 4) or powerDeficit <= 25 + energyRegenCombined or not singleTarget) and true or false
            return (comboDeficit > 1 or powerDeficit <= 25 + energyRegenCombined) and true or false
        end

        -- local function bfrange()
        --     if talent.acrobaticStikes then return #enemies.get(9) end
        --     else return #enemies.get(6) end
        -- end

        --if leftCombat == nil then leftCombat = GetTime() end
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
                    if toggle("Feint",1) then return true end
                end
            end 
            -- Feint
                if mode.feint == 1 and not buff.feint.exists() then
                    if cast.feint() and toggle("Feint",2) then return true end
                end

            if useDefensive() and not stealth then
            -- Health Pot/Healthstone
                if isChecked("Healing Potion/Healthstone") and php <= getOptionValue("Healing Potion/Healthstone")
                    and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUseItem(5512) then
                        useItem(5512)
                    elseif canUseItem(healPot) then
                        useItem(healPot)
                    end
                end
            -- Crimson Vial
                if cast.able.crimsonVial() and isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") then
                    if cast.crimsonVial() then return true end
                end
            -- Feint
                if cast.able.feint() and isChecked("Feint") and php <= getOptionValue("Feint") and inCombat and not buff.feint then
                    if cast.feint() then return true end
                end
            -- Evasion
                if cast.able.evasion() and isChecked("Evasion") and php <= getOptionValue("Evasion") and inCombat then
                    if cast.evasion() then return end
                end
            end
        end -- End Action List - Defensive

        local function actionList_Stealthed()            
                        
                --actions.stealthed=rupture,if=combo_points>=4&(talent.nightstalker.enabled|talent.subterfuge.enabled&(talent.exsanguinate.enabled&cooldown.exsanguinate.remains<=2|!ticking)&variable.single_target)&target.time_to_die-remains>6
                -- if cast.able.rupture() and combo >= 4 and (talent.nightstalker or talent.subterfuge and (talent.exsanguinate and mode.special == 2 and cd.exsanguinate.remain() <= 2 or not debuff.rupture.exists("target")) and viabletargetcount() == 1) and ttd("target") > 6 then
                --     if isChecked("Debug") then print("rupt ns/exsa") end
                --     if cast.rupture() then return true end
                -- end


                -- # Subterfuge: Apply or Refresh with buffed Garrotes
                -- actions.stealthed+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&refreshable&target.time_to_die-remains>2
                if talent.subterfuge then
                        -- if buff.subterfuge.remain() <= 1.4 and buff.subterfuge.remain() >= 0.4 and debuff.garrote.remain() < 18 and debuff.garrote.exists() and cd.vanish.remain() >= 110 then
                        --     if cast.garrote("target") then print("last sec subt garr"); return true end
                        -- end
                        -- --# Subterfuge: Override normal Garrotes with snapshot versions
                        -- --actions.stealthed+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&remains<=10&pmultiplier<=1&target.time_to_die-remains>2
                        -- if buff.subterfuge.remain() <= 1.2 and buff.subterfuge.remain() >= 0.4 and debuff.garrote.remain() < 5.4 and debuff.garrote.exists() then
                        --     if cast.garrote() then print("last sec subt garrote target"); return true end
                        -- end
                        -- if buff.subterfuge.remain() <= gcdMax and buff.subterfuge.exists() and debuff.garrote.remain("target") <= 17 and getDistance("target") <= 5 and donotdot("target") then
                        --     if cast.garrote("target") then
                        --         if isChecked("Debug") then print("refresh garrote target last cd subt") end
                        --     return true end
                        -- end
                        if debuff.garrote.remain("target") <= 12 and donotdot("target") and buff.subterfuge.exists("player") and buff.subterfuge.remain("player") <= 0.5 + gcdMax then
                            if cast.garrote("target") then return true end
                        end

                        for i = 1, #enemyTable5 do
                            local thisUnit = enemyTable5[i].unit
                            if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                if debuff.garrote.remain(thisUnit) <= 5.4 and debuff.garrote.exists(thisUnit) and not debuff.garrote.exsang(thisUnit)
                                    and (getOptionCheck("Enhanced Time to Die") and enemyTable5[i].ttd > 2 or true)
                                    and donotdot(thisUnit)
                                    --and getFacing("player", thisUnit)
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

                        for i = 1, #enemyTable5 do
                            local thisUnit = enemyTable5[i].unit
                            if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                if not debuff.garrote.exists(thisUnit)
                                    and (getOptionCheck("Enhanced Time to Die") and enemyTable5[i].ttd > 2 or true)
                                    and donotdot(thisUnit)
                                    --and getFacing("player", thisUnit)
                                then
                                    if cast.garrote(thisUnit) then 
                                        if isChecked("Debug") then print("apply new garrote target stealth") end
                                    return true end
                                end
                            end
                        end

                        --# Subterfuge: Override normal Garrotes with snapshot versions
                        --actions.stealthed+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&remains<=10&pmultiplier<=1&target.time_to_die-remains>2
                        for i = 1, #enemyTable5 do
                            local thisUnit = enemyTable5[i].unit
                            if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                    if debuff.garrote.remain(thisUnit) <= 10 and debuff.garrote.applied(thisUnit) <= 1
                                    and (getOptionCheck("Enhanced Time to Die") and enemyTable5[i].ttd > 2 or true)
                                    and donotdot(thisUnit)
                                    --and getFacing("player", thisUnit)
                                then
                                    
                                    if cast.garrote(thisUnit) then 
                                        if isChecked("Debug") then print("override garrote with subt") end
                                    return true end
                                end
                            end
                        end

                        for i = 1, #enemyTable5 do
                            local thisUnit = enemyTable5[i].unit
                            if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                    if debuff.garrote.remain(thisUnit) <= 17 and trait.shroudedSuffocation.rank > 0
                                    and (getOptionCheck("Enhanced Time to Die") and enemyTable5[i].ttd > 2 or true)
                                    and donotdot(thisUnit)
                                    --and getFacing("player", thisUnit)
                                then
                                    
                                    if cast.garrote(thisUnit) then 
                                        print(buff.subterfuge.remain())
                                        if isChecked("Debug") then print("garrote pop < 15") end
                                    return true end
                                end
                            end
                        end
                end

                        -- if mode.special == 1 and cast.able.rupture() and combo >=4 and s((cd.exsanguinate.remain() <= 2 and talent.exsanguinate ) or not debuff.rupture.exists()) then
                        --     if isChecked("Debug") then print("refresh rupture subt cds toggle on") end
                        --     if cast.rupture() then return true end
                        -- end
                        -- # Subterfuge + Shrouded Suffocation: Apply early Rupture that will be refreshed for pandemic.
                        -- actions.stealthed+=/rupture,if=talent.subterfuge.enabled&azerite.shrouded_suffocation.enabled&!dot.rupture.ticking
                        if #enemyTable5 <= 2 then
                            if cast.able.rupture("target") and talent.subterfuge and viabletargetcount() == 1 and trait.shroudedSuffocation.rank > 0 and not debuff.rupture.exists() --and getFacing("player", "target") 
                                then
                                if cast.rupture("target") then 
                                    if isChecked("Debug") then print("early rupt") end
                                return true end
                            end




                            for i = 1, #enemyTable5 do
                                local thisUnit = enemyTable5[i].unit
                                if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                    if (combo == 4 and debuff.rupture.remain(thisUnit) < 6 or combo == 5 and debuff.rupture.remain(thisUnit) < 7.2 ) and cast.able.rupture()
                                        and (not debuff.rupture.exsang(thisUnit) or debuff.rupture.remain(thisUnit) <= ExsanguinatedBleedTickTime*2 and EmpoweredDotRefresh())
                                        and (getOptionCheck("Enhanced Time to Die") and enemyTable5[i].ttd > 12 or true)
                                        --and getFacing("player", thisUnit) --and (ttd(thisUnit) > 4 - debuff.rupture.remain(thisUnit) or ttd(thisUnit) > 9999)
                                    then
                                        if cast.able.rupture(thisUnit) then
                                            if cast.rupture(thisUnit) then 
                                                if isChecked("Debug") then print("rupture refresh subt") end
                                            return true end
                                        end
                                    end
                                end
                            end

                        
                            for i = 1, #enemyTable5 do
                                local thisUnit = enemyTable5[i].unit
                                if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                    if combo >= 3 and not debuff.rupture.exists(thisUnit) and cast.able.rupture(thisUnit)
                                        and (getOptionCheck("Enhanced Time to Die") and enemyTable5[i].ttd > 12 or true)
                                        --and getFacing("player", thisUnit) --and (ttd(thisUnit) > 4 - debuff.rupture.remain(thisUnit) or ttd(thisUnit) > 9999)
                                    then
                                            if cast.rupture(thisUnit) then 
                                                if isChecked("Debug") then print("rupture cp>=3 no rupt subt") end
                                            return true end
                                    end
                                end
                            end
                        end

                        for i = 1, #enemyTable5 do
                            local thisUnit = enemyTable5[i].unit
                            if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                if debuff.garrote.exists(thisUnit) and not debuff.garrote.exsang(thisUnit) and combo <= 3
                                    --and getFacing("player", thisUnit)
                                then
                                    if cast.garrote(thisUnit) then 
                                        if isChecked("Debug") then print("apply garrote on rupt subt") end
                                    return true end
                                end
                            end
                        end

                        for i = 1, #enemyTable5 do
                            local thisUnit = enemyTable5[i].unit
                            if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                if debuff.rupture.exists(thisUnit) and (combo == 4 and debuff.rupture.remain(thisUnit) < 6 or combo == 5 and debuff.rupture.remain(thisUnit) < 7.2 ) and not debuff.rupture.exsang(thisUnit)
                                    --and getFacing("player", thisUnit)
                                then
                                    if cast.rupture(thisUnit) then 
                                        if isChecked("Debug") then print("rupt 4cp") end
                                    return true end
                                end
                            end
                        end

                        if combo >= 4 then 
                            for i = 1, #enemyTable5 do
                            local thisUnit = enemyTable5[i].unit
                            if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                --if getFacing("player", thisUnit)
                                --then
                                    if cast.envenom(thisUnit) then 
                                        if isChecked("Debug") then print("env stealth") end
                                    return true end
                                --end
                            end
                        end
                        end

                        return
        end        
    -- Action List - Interrupts
        local function actionList_Interrupts()
                if mode.interrupt == 1 then
                    for i = 1, #enemies.yards30 do
                        local thisUnit = enemies.yards30[i]
                        local distance = getDistance(thisUnit)
                        if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                            if distance <= 5 then
                                if cast.able.kick(thisUnit) and isChecked("Kick") then
                                    if cast.kick(thisUnit) then return end
                                end
                                if cd.kick.remain() ~= 0 or not cast.able.kick() then
                                    if cast.able.kidneyShot(thisUnit) and combo > 0 and isChecked("Kidneyshot") then
                                        if cast.kidneyShot(thisUnit) then return true end
                                    end                                                                
                                end
                            end
                            if  (distance >= 5 and distance < 15) or (not cast.able.kick(thisUnit) and not cast.able.kidneyShot(thisUnit)) then
                                if cast.able.blind(thisUnit) and isChecked("Blind") then
                                    if cast.blind(thisUnit) then return true end
                                end
                            end
                        end
                    end
                elseif mode.interrupt == 2 then 
                        if canInterrupt("target",getOptionValue("Interrupt At")) then
                            if distance <= 5 then
                                if cast.able.kick("target") and isChecked("Kick") then
                                    if cast.kick("target") then return end
                                end
                                if cd.kick.remain() ~= 0 or not cast.able.kick("target") then
                                    if cast.able.kidneyShot("target") and combo > 0 and isChecked("Kidneyshot") then
                                        if cast.kidneyShot("target") then return true end
                                    end                                                                
                                end
                            end
                            if  (distance >= 5 and distance < 15) or (not cast.able.kick("target") and not cast.able.kidneyShot("target")) then
                                if cast.able.blind("target") and isChecked("Blind") then
                                    if cast.blind("target") then return true end
                                end
                            end
                        end
                end
        end -- End Action List - Interrupts
        local function actionList_Special()
                    if mode.van1 == 1 and (not solo or isDummy("target")) then
                        
                        -- if debuff.garrote.applied(GetObjectWithGUID(UnitGUID("target"))) < 1.8 and not debuff.garrote.exsang(GetObjectWithGUID(UnitGUID("target"))) and debuff.garrote.remain("target") < 6 and cast.able.vanish() and not cd.garrote.exists() then
                        --     if gcd >= 0.5 then return true end
                        --     if power <= 70 then return true end
                        --     if isChecked("Debug") then print("vanish tb cd") end
                        --     if cast.vanish() then 
                        --         if actionList_Stealthed() then return true end
                        --     end
                        -- end

                        if  canvangar() >= 2 and cast.able.garrote() and cast.able.vanish() then
                            if gcd >= 0.5 then ChatOverlay("Pooling gcd For vanish") return true end
                            if power <= 70 then return true end
                            if cast.vanish() then 
                                if isChecked("Debug") then print("vanish aoe use") end
                                if actionList_Stealthed() then return true end
                            end
                        end
                        
                    end

                    if mode.van2 == 1 and (not solo or isDummy("target")) then
                        
                        -- if debuff.garrote.applied(GetObjectWithGUID(UnitGUID("target"))) < 1.8 and not debuff.garrote.exsang(GetObjectWithGUID(UnitGUID("target"))) and debuff.garrote.remain("target") < 6 and cast.able.vanish() and not cd.garrote.exists() then
                        --     if gcd >= 0.5 then return true end
                        --     if power <= 70 then return true end
                        --     if isChecked("Debug") then print("vanish tb cd") end
                        --     if cast.vanish() then 
                        --         if actionList_Stealthed() then return true end
                        --     end
                        -- end

                        if cast.able.vanish() and cast.able.garrote() and not debuff.garrote.exsang(GetObjectWithGUID(UnitGUID("target"))) and debuff.garrote.applied("target") <= 1 and debuff.garrote.remain("target") <= 5.4 then
                            if gcd >= 0.5 then ChatOverlay("Pooling gcd For vanish") return true end
                            if power <= 70 then return true end
                            if cast.vanish() then 
                                if isChecked("Debug") then print("vanish solo use") end
                                if actionList_Stealthed() then return true end
                            end
                        end

                    end


                    if isChecked("Apply Deadly Poison in melee") then
                            for i = 1, #enemyTable5 do
                                local thisUnit = enemyTable5[i].unit
                                    if UnitDebuffID(thisUnit,268756) or
                                        ((debuff.garrote.exists(thisUnit) or debuff.rupture.exists(thisUnit)) and not debuff.deadlyPoison.exists(thisUnit)) then
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

        local function actionList_OpenNoVend()

        if not br.player.moving and isChecked("Galecaller") then
            -- use_item,name=galecallers_boon,if=cooldown.vendetta.remains<=1&(!talent.subterfuge.enabled|dot.garrote.pmultiplier>1)|cooldown.vendetta.remains>45
            if canUseItem(13) and hasEquiped(159614, 13) then
                useItem(13)
            end
            if canUseItem(14) and hasEquiped(159614, 14) then
                useItem(14)
            end
        end


        if not RUP1 and cast.able.rupture() then
            if cast.rupture() then RUP1 = true; end
        elseif RUP1 and not GAR1 and cast.able.garrote() then
            if cast.garrote() then GAR1 = true; end
        elseif GAR1 and not VEN1 and cast.able.mutilate() then
            if cast.mutilate() then VEN1 = true; end            
        elseif VEN1 and not MUTI1 and cast.able.rupture() then
            if cast.rupture() then MUTI1 = true; end
        elseif MUTI1 and not RUP2 and cast.able.exsanguinate() then
            if cast.exsanguinate() then RUP2 = true; end
        if RUP2 then
            Print("Opener Complete")
            opener = true
            toggle("Opener",2)
        end
            return 
        end

        end

        local function actionList_Open()
            --if (opener == false and time < 1) and (isDummy("target") or isBoss("target")) and (cd.vanish > 0 or not buff.shadowBlades.exists()) then Print("Opener failed due do cds"); opener = true end
        if talent.subterfuge then
            if trait.shroudedSuffocation.rank > 0 then
                if talent.exsanguinate then
                        if not RUP1 and cast.able.rupture("target") then
                            if cast.rupture("target") then RUP1 = true; end
                        elseif RUP1 and not GAR1 and cast.able.garrote("target") then
                            if cast.garrote("target") then GAR1 = true; end
                        elseif GAR1 and not VEN1 and cast.able.vendetta("target") then
                            if isChecked("Racial") then
                                if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" then
                                    if cast.racial("player") then end
                                end
                            end
                            if canUseItem(13) then
                                useItem(13)
                            end
                            if canUseItem(14) then
                                useItem(14)
                            end
                            if cast.vendetta("target") then VEN1 = true; end
                        elseif VEN1 and not MUTI1 and cast.able.mutilate("target") then
                            if cast.mutilate("target") then MUTI1 = true; end
                        elseif MUTI1 and not RUP2 and cast.able.rupture("target") then
                            if cast.rupture("target") then RUP2 = true; end
                        elseif RUP2 and not EXS1 and cast.able.exsanguinate("target") then
                            if cast.exsanguinate("target") then EXS1 = true; end
                        if EXS1 then
                            Print("Opener Complete")
                            opener = true
                            toggle("Opener",2)
                        end
                            return 
                        end
                end
                if talent.toxicBlade then
                        if not RUP1 and cast.able.rupture() then
                            if cast.rupture() then RUP1 = true; end
                        elseif RUP1 and not GAR1 and cast.able.garrote() then
                            if cast.garrote() then GAR1 = true; end
                        elseif GAR1 and not VEN1 and cast.able.vendetta() then
                            if isChecked("Racial") then
                                if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" then
                                    if cast.racial("player") then end
                                end
                            end
                            if canUseItem(13) then
                                useItem(13)
                            end
                            if canUseItem(14) then
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

            if trait.shroudedSuffocation.rank <= 0 then
                if talent.exsanguinate then
                        if not RUP1 and cast.able.mutilate() then
                            if cast.mutilate() then RUP1 = true; end
                        elseif RUP1 and not GAR1 and cast.able.rupture() then
                            if cast.rupture() then GAR1 = true; end
                        elseif GAR1 and not VEN1 and cast.able.vendetta() then
                            if isChecked("Racial") then
                                if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" then
                                    if cast.racial("player") then end
                                end
                            end
                            if canUseItem(13) then
                                useItem(13)
                            end
                            if canUseItem(14) then
                                useItem(14)
                            end
                            if cast.vendetta() then VEN1 = true; end
                        elseif VEN1 and not MUTI1 and cast.able.mutilate() and combo < ComboMaxSpend() - 1 then
                            if cast.mutilate() then end
                        elseif VEN1 and not MUTI1 and combo >= ComboMaxSpend() - 1 then MUTI1 = true
                        elseif MUTI1 and not RUP2 and cast.able.rupture() then
                            if cast.rupture() then RUP2 = true; end
                        elseif RUP2 and not VAN1 then
                            if gcd >= 0.2 then ChatOverlay("Pooling gcd For vanish") return true end
                            if cast.vanish() then VAN1 = true; end
                        elseif VAN1 and not VANGAR and cast.able.garrote() then
                            if cast.garrote() then VANGAR = true; end
                        elseif VANGAR and not EXS1 and cast.able.exsanguinate() then
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
                            if isChecked("Racial") then
                                if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" then
                                    if cast.racial("player") then end
                                end
                            end
                            if canUseItem(13) then
                                useItem(13)
                            end
                            if canUseItem(14) then
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
        end -- subt talent

        if talent.masterAssassin then
            if  not GAR1 and cast.able.mutilate() then
                if cast.mutilate("target") then GAR1 = true; end
            elseif GAR1 and not RUP1 and cast.able.rupture() then
                if cast.rupture("target") then RUP1 = true; end
            elseif RUP1 and not VEN1 and cast.able.vendetta() then
                if isChecked("Racial") then
                    if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" then
                        if cast.racial("player") then end
                    end
                end
                if canUseItem(13) then
                    useItem(13)
                end
                if canUseItem(14) then
                    useItem(14)
                end
                if cast.vendetta("target") then VEN1 = true; end
            elseif VEN1 and not MUTI1 then
                if gcd >= 0.2 then ChatOverlay("Pooling gcd For vanish") return true end
                if cast.vanish() then MUTI1 = true; end
            elseif MUTI1 and not RUP2 and cast.able.toxicBlade() then
                if cast.toxicBlade("target") then RUP2 = true; end
                Print("Opener Complete")
                opener = true
                toggle("Opener",2)
                return true
            end
        end -- ma

        end
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            if getDistance("target") < 5 then
                if mode.special == 1 then
                    if isChecked("Racial") and debuff.vendetta.exists("target") and ttd("target") > 5  then
                        if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" then
                            if cast.racial("player") then
                                if isChecked("Debug") then print("racial") end
                            return true end
                        end
                    end

                    if talent.exsanguinate then
                        if not debuff.rupture.exists("target") and combo >= 2 then 
                            if cast.rupture("target") then
                                if isChecked("Debug") then print("new rupt cd") end 
                            return true end
                        end

                        if cast.able.garrote("target") and not debuff.garrote.exsang(GetObjectWithGUID(UnitGUID("target"))) and debuff.garrote.applied(GetObjectWithGUID(UnitGUID("target"))) <= 1 and debuff.garrote.remain("target") <= 12 and mode.van1 ~= 1 and mode.van2 ~= 1 then
                            if cast.garrote("target") then
                                if isChecked("Debug") then print("garrote new cd") end
                            return true end
                        end

                        if cd.exsanguinate.remain() <= 5 and (debuff.garrote.remain() > 10 or debuff.garrote.applied(GetObjectWithGUID(UnitGUID("target"))) > 1) and combo >= 4 and debuff.rupture.remain("target") <= 20 and cast.able.rupture() then
                            if cast.rupture() then
                                if isChecked("Debug") then print("rupt before exsa cd") end
                            return true end
                        end

                        if power <= 30 and cast.able.vendetta("target") then
                                if isChecked("Trinkets") then
                                    if canUseItem(13) then
                                        useItem(13)
                                    end
                                    if canUseItem(14) then
                                        useItem(14)
                                    end
                                end                  
                            if cast.vendetta("target") then
                                if isChecked("Debug") then print("vendetta power use cd") end
                            return true end
                        end
                        
                        -- if (not solo or isDummy("target")) and not cd.garrote.exists() and (debuff.garrote.applied(GetObjectWithGUID(UnitGUID("target"))) <= 1 or debuff.garrote.remain() <= 5.4) and cast.able.vanish() and not debuff.garrote.exsang(GetObjectWithGUID(UnitGUID("target"))) then 
                        --     if gcd >= 0.2 then ChatOverlay("Pooling gcd For vanish") return true end
                        --     if isChecked("Debug") then print("vanish cd exsa") end
                        --     if cast.vanish() then 
                        --         if actionList_Stealthed() then return true end
                        --     end
                        -- end

                        if debuff.garrote.remain() >= 5.4 and debuff.rupture.remain() >= 4 + (4 * comboMax) and (debuff.vendetta.exists() or cd.vendetta.remain() >=5) then
                                if isChecked("Galecaller") then
                                    -- use_item,name=galecallers_boon,if=cooldown.vendetta.remains<=1&(!talent.subterfuge.enabled|dot.garrote.pmultiplier>1)|cooldown.vendetta.remains>45
                                    if canUseItem(13) and hasEquiped(159614, 13) then
                                        useItem(13)
                                    end
                                    if canUseItem(14) and hasEquiped(159614, 14) then
                                        useItem(14)
                                    end
                                end
                            if cast.exsanguinate("target") then
                                if isChecked("Debug") then print("exsa cd") end
                            return true end
                        end

                        if cast.able.vendetta("target") then
                                if isChecked("Trinkets") then
                                    if canUseItem(13) then
                                        useItem(13)
                                    end
                                    if canUseItem(14) then
                                        useItem(14)
                                    end
                                end
                            if cast.vendetta("target") then
                                if isChecked("Debug") then print("vendetta cd") end
                            return true end
                        end

                        if cd.vendetta.remain() >= 5 and cd.exsanguinate.remain() >= 5 then
                            toggle("Special",2)
                        end
                    end

                    if talent.toxicBlade then

                        if cast.able.vendetta() then
                                if isChecked("Trinkets") then
                                    if canUseItem(13) then
                                        useItem(13)
                                    end
                                    if canUseItem(14) then
                                        useItem(14)
                                    end
                                end
                            if isChecked("Debug") then print("vendetta tb talent cd") end
                            if cast.vendetta("target") then return true end
                        end

                        if cast.able.toxicBlade() then
                            if isChecked("Debug") then print("tb cd") end
                            if cast.toxicBlade() then return true end
                        end

                        if (not solo or isDummy("target")) and not cd.garrote.exists() and (debuff.garrote.applied(GetObjectWithGUID(UnitGUID("target"))) <= 1 or debuff.garrote.remain() <= 5.4) and cast.able.vanish() then 
                            if gcd >= 0.5 then ChatOverlay("Pooling gcd For vanish") return true end
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
                if isChecked("Stealth") then
                    if getOptionValue("Stealth") == 1 then
                        if cast.stealth("player") then return true end
                    end
                    if #enemies.yards20 > 0 and getOptionValue("Stealth") == 2  then
                        for i = 1, #enemies.yards20 do
                            local thisUnit = enemies.yards20[i]
                            if UnitIsEnemy(thisUnit,"player") or isDummy("target") then
                                if cast.stealth("player") then return true end
                            end
                        end
                    end
                end
            end



            if not inCombat and buff.deadlyPoison.remain() <= 600 and not br.moving and cast.able.deadlyPoison() then
                if cast.deadlyPoison("player") then return true end
            end
        end -- End Action List - PreCombat

        local function actionList_Dot()

        -- garrote outside of cds
                    for i = 1, #enemyTable5 do
                            local thisUnit = enemyTable5[i].unit
                            --print(debuff.garrote.remain(thisUnit))+
                            if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                                    if ((debuff.garrote.remain(thisUnit) <= 5.4 and debuff.garrote.applied(thisUnit) <= 1 and not debuff.garrote.exsang(thisUnit))
                                        or (debuff.garrote.remain(thisUnit) <= ExsanguinatedBleedTickTime*2 and EmpoweredDotRefresh()))
                                        and mode.van1 ~= 1 and mode.van2 ~= 1
                                        and (getOptionCheck("Enhanced Time to Die") and enemyTable5[i].ttd > ttdval - debuff.garrote.remain(thisUnit) or true)
                                        and mode.special == 2  
                                        and donotdot(thisUnit) --and getFacing("player", thisUnit)
                                        and cd.garrote.remain() <= gcdMax
                                        and (ttm >= 2 
                                            --powerDeficit >= 60
                                            or debuff.vendetta.exists(thisUnit) and GetUnitIsUnit(thisUnit, "target"))
                                        --and bleedscount() <= 5                                        
                                    then
                                        if comboDeficit >= 1 then
                                            -- if (cast.pool.garrote() or ((debuff.garrote.exsang(thisUnit) or debuff.garrote.applied(thisUnit) > 1) and debuff.garrote.remain(thisUnit) <= 1 )) and debuff.garrote.count() <= 1 then return true end
                                                if cast.pool.garrote() then ChatOverlay("Pooling For Garrote") return true end
                                                if cast.garrote(thisUnit) then
                                                    if isChecked("Debug") then print("garrote dot") end
                                                return true end
                                        elseif (ttm <= 2 or debuff.garrote.remain(thisUnit) <= gcdMax + 0.5) and  comboDeficit <= 0 and debuff.rupture.remain(thisUnit) <= 7.2 and #enemyTable5 <= 1 then
                                                if cast.rupture(thisUnit) then
                                                    if isChecked("Debug") then print("rip for garrote refresh") end
                                                return true end
                                        elseif (ttm <= 1 or debuff.garrote.remain(thisUnit) <= gcdMax + 0.5) and comboDeficit <= 0 and #enemyTable5 <= 1 then
                                                if cast.envenom(thisUnit) then
                                                    if isChecked("Debug") then print("env for garrote refresh") end
                                                return true end
                                        end
                                    end
                            end
                    end
        

        
        -- actions.dot+=/crimson_tempest,if=spell_targets>=2&remains<2+(spell_targets>=5)&combo_points>=4

        if cast.able.crimsonTempest() and fokcccheck()  and talent.crimsonTempest and combo >=4 and enemies10 >= 3 and debuff.crimsonTempest.remain() < 2 + (enemies10 >= 5 and 1 or 0)
                --and not (GetObjectID(units.dyn5) == 120651 or GetObjectID(units.dyn5) == 141851)
                then
                if cast.crimsonTempest("player") then
                    if isChecked("Debug") then print("ct 1st dot") end
                return true end
                -- for i = 1, #enemies.yards5 do
                --     local thisUnit = enemies.yards5[i]
                --     if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                --         if power < 35 then return true end
                --         if getDistance(thisUnit) < 5 then
                --             if cast.crimsonTempest("player") then
                --                 if isChecked("Debug") then print("ct dot") end
                --             return true end
                --         end
                --     end
                -- end
        end


        if combo >= 4 then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                        if (combo == 4 and debuff.rupture.remain(thisUnit) < 6 or combo == 5 and debuff.rupture.remain(thisUnit) < 7.2 ) 
                        and (debuff.rupture.applied(thisUnit) <= 1 or (debuff.rupture.remain(thisUnit) <= (debuff.rupture.exsang(thisUnit) and ExsanguinatedBleedTickTime or BleedTickTime) and EmpoweredDotRefresh()))
                        and (not debuff.rupture.exsang(thisUnit) or debuff.rupture.remain(thisUnit) <= ExsanguinatedBleedTickTime*2 and EmpoweredDotRefresh()) --and (ttd(thisUnit) > 4 - debuff.rupture.remain(thisUnit) or ttd(thisUnit) > 9999)
                        and (getOptionCheck("Enhanced Time to Die") and enemyTable5[i].ttd > 6 or true)
                        --and cast.able.rupture()
                        --ghuun or explosive orb check
                        --and not (GetObjectID(thisUnit) == 120651 or GetObjectID(thisUnit) == 141851)                        
                        and donotdot(thisUnit)
                        then
                                if cast.rupture(thisUnit) then
                                    if isChecked("Debug") then print("rupture dot") end
                                return true end
                        end
                end
            end
        end

        if cast.able.crimsonTempest() and talent.crimsonTempest and combo >=4 and enemies10 >= 3 
                and getctinitial() >= getenvdamage()
                --and not (GetObjectID(units.dyn5) == 120651 or GetObjectID(units.dyn5) == 141851)
                then
                if cast.crimsonTempest("player") then return true end
                -- for i = 1, #enemies.yards5 do
                --     local thisUnit = enemies.yards5[i]
                --     if multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot) then
                --         if power < 35 then return true end
                --         if getDistance(thisUnit) < 5 then
                --             if cast.crimsonTempest("player") then
                --                 if isChecked("Debug") then print("ct dot") end
                --             return true end
                --         end
                --     end
                -- end
        end

        if debuff.garrote.exists("target") and debuff.garrote.remain("target") <= gcdMax and combo <=4 and #enemyTable5 <= 1 then
            return true
        end
    
        if combo >= ComboMaxSpend() - 1 and waitenvenom() then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                if cast.envenom(thisUnit) then
                    if isChecked("Debug") then print("envenom dot apl") end
                return true end
            end
        end


        end -- End Action List - Build

        local function actionList_Direct()   
        -- actions.direct=envenom,if=combo_points>=4+talent.deeper_stratagem.enabled&(debuff.vendetta.up|debuff.toxic_blade.up|energy.deficit<=25+variable.energy_regen_combined|spell_targets.fan_of_knives>=2)&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)
            -- if isChecked("Search for orb/ghuunies") then
            --     for i = 1, #enemies.yards5 do
            --             local thisUnit = enemies.yards5[i]
            --                 if GetObjectID(thisUnit) == 120651 then
            --                     if isChecked("Debug") then print("muti explosive") end
            --                     if cast.able.mutilate(thisUnit) and getFacing("player", thisUnit) then
            --                         if cast.mutilate(thisUnit) then return end
            --                     end
            --                 end
            --     end
            -- end
        
        -- if cast.able.mutilate() and GetObjectID(x) == 144081 or GetObjectID(x) == 141851  then
        --     if isChecked("Debug") then print("muti") end
        --     if cast.mutilate() then return end
        -- end
        
        --pooling shit
        if fokcccheck() and trait.echoingBlades.active and enemies10 >= 2 then
            if cast.fanOfKnives("player") then
                if isChecked("Debug") then print("fok aoe") end
            return true end
        end

        if fokcccheck() and (buff.hiddenBlades.stack() >= 19 or enemies10 >= 4 + (stealthingRogue and 1 or 0)) then
            if cast.fanOfKnives("player") then
                if isChecked("Debug") then print("fok aoe") end
            return true end
        end
        -- actions.direct+=/fan_of_knives,if=variable.use_filler&(buff.hidden_blades.stack>=19|spell_targets.fan_of_knives>=2+stealthed.rogue|buff.the_dreadlords_deceit.stack>=29)
        -- if  cast.able.fanOfKnives() and (#enemies.yards9 >= 2 + (stealthingRogue and 1 or 0) or buff.hiddenBlades.stack() >= 19) then
        --     if cast.fanOfKnives() then return end
        -- end

        if enemies10 >= 3 and fokcccheck() and not deadlyPoison10 then
            if cast.fanOfKnives("player") then
                if isChecked("Debug") then print("fok refresh poison") end
            return true end
        end

        if #enemyTable5 == 2 then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                    if not debuff.woundPoison.exists(thisUnit) --and getFacing("player", thisUnit) 
                        then
                        if cast.mutilate(thisUnit) then
                            if isChecked("Debug") then print("muti refresh poison") end
                        return true end
                    end
            end
        end

        --muti

        for i = 1,#enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                    --if getFacing("player", thisUnit) then
                        if cast.mutilate(thisUnit) then
                            if isChecked("Debug") then print("muti") end
                        return true end
                    --end
        end
        end -- End Action List - Finishers
    -- Action List - Mythic Stuff
        local function actionList_Stun()
            local stunList = { -- Stolen from feng pala
            [274400] = true, [274383] = true, [257756] = true, [276292] = true, [268273] = true, [256897] = true, [272542] = true, [272888] = true, [269266] = true, [258317] = true, [258864] = true,
            [259711] = true, [258917] = true, [264038] = true, [253239] = true, [269931] = true, [270084] = true, [270482] = true, [270506] = true, [270507] = true, [267433] = true, [267354] = true,
            [268702] = true, [268846] = true, [268865] = true, [258908] = true, [264574] = true, [272659] = true, [272655] = true, [267237] = true, [265568] = true, [277567] = true, [265540] = true
            }
            for i=1, #enemies.yards20 do
                local thisUnit = enemies.yards20[i]
                local distance = getDistance(thisUnit)
                if (isChecked("AutoKidney") and distance <= 5  and combo > 0) or isChecked("AutoBlind") and distance <= 15 then
                    local interruptID, castStartTime
                    if UnitCastingInfo(thisUnit) then
                        castStartTime = select(4,UnitCastingInfo(thisUnit))
                        interruptID = select(9,UnitCastingInfo(thisUnit))
                    elseif UnitChannelInfo(thisUnit) then
                        castStartTime = select(4,UnitChannelInfo(thisUnit))
                        interruptID = select(7,GetSpellInfo(UnitChannelInfo(thisUnit)))
                    end
                    if interruptID ~=nil and stunList[interruptID] and (GetTime()-(castStartTime/1000)) > 0.1 then
                        if cast.kidneyShot(thisUnit) then return true end
                    end
                    if interruptID ~=nil and stunList[interruptID] and (GetTime()-(castStartTime/1000)) > 0.1 and (distance > 5 or cd.kidneyShot.remain() > 1.5) then
                        if cast.blind(thisUnit) then return true end
                    end
                end
            end
        end
        
        local function MythicStuff()
            

            local cloakPlayerlist = {
            }  

            local evasionPlayerlist = {
            }

            local cloaklist = {
            }

            local evasionlist = {
            }

            local feintlist = {
            }   

            if eID then
                local bosscount = 0
                for i = 1, 5 do
                    if GetUnitExists("boss"..i) then
                        bosscount = bosscount + 1
                    end
                end
                for i = 1, bosscount do
                    if UnitCastingInfo("boss"..i) then
                        BossSpellEnd,_,_,_,BossSpell = select(5,UnitCastingInfo("boss"..i))
                        --print(BossSpellEnd)
                    elseif UnitChannelInfo("boss"..i) then
                        BossSpellEnd = select(4,UnitChannelInfo("boss"..i))
                        BossSpell = select(7,GetSpellInfo(UnitChannelInfo("boss"..i)))
                        --print(BossSpell)
                    end
                    if BossSpellEnd ~= nil and BossSpellEnd/1000 <= GetTime() + 2 then
                        if GetUnitIsUnit("player","boss"..i.."target") then
                            if BossSpell ~= nil and cloakPlayerlist[BossSpell] then
                                if cast.able.cloakOfShadows("player") then
                                    if cast.cloakOfShadows("player") then return true end
                                end
                            elseif BossSpell ~= nil and evasionPlayerlist[BossSpell] then
                                if cast.able.evasion("player") then
                                    if cast.evasion("player") then return true end
                                end
                            end
                        else
                            if BossSpell ~= nil and cloaklist[BossSpell] then
                                if cast.able.cloakOfShadows("player") then
                                    if cast.cloakOfShadows("player") then return true end
                                end
                            elseif BossSpell ~= nil and evasionlist[BossSpell] then
                                if cast.able.evasion("player") then
                                    if cast.evasion("player") then return true end
                                end
                            elseif BossSpell ~= nil and feintlist[BossSpell] then
                                if cast.pool.feint("player") and not cd.feint.exists() then return true end
                                if cast.able.feint("player") then
                                    if cast.feint("player") then return true end
                                end
                            end
                        end
                    end
                end
            end
            
            
            -- AddEventCallback("ENCOUNTER_START",function(...) encounterID = select(1,...) end)
            -- AddEventCallback("PLAYER_REGEN_ENABLED",function() encounterID = false end)
            --print(encounterID)
                -- if encounterID == 1004 then --- KR, 1st boss
                --     if UnitCastingInfo("boss1") then
                --         Boss1Cast,_,_,_,Boss1CastEnd = UnitCastingInfo("boss1")
                --     elseif UnitChannelInfo("boss1") then
                --         Boss1Cast,_,_,_,Boss1CastEnd = UnitChannelInfo("boss1")
                --     end
                --     if cast.able.cloakOfShadows("player") and
                --         spellonPlayer == 265773 and
                --         spellonPlayerTEndTime >= GetTime() + 3
                --     then
                --         if cast.cloakOfShadows("player") then 
                --             if isChecked("Debug") then print("cloak auto") end
                --         return end
                --     end
                -- end
                --print(spellonPlayer)
        end
---------------------
--- Begin Profile ---
---------------------
    --Profile Stop | Pause
    --print(swingTimer)
        -- poolcast.mutilate()
        -- if not IsMouselooking() then print("not") end
        -- if IsMouselooking() then print("yes") end
            -- print(debuff.rupture.duration("target"))
        if MythicStuff() then end

        if not inCombat then
            if actionList_PreCombat() then return end
        end
        if buff.stealth.exists() or isCasting("player") or pause() or (IsMounted() or IsFlying()) or mode.rotation == 2 
        then
            return true
        else
            
            --print(fokcccheck())
            --print(#enemies.yards5)
            --print(ttm)
            --print(energyRegenCombined)
            --print(debuff.garrote.exsang("target"))
            -- print("RUP1 is "..tostring(RUP1))
            -- print("GAR1 is "..tostring(GAR1))
            -- print("VEN1 is "..tostring(VEN1))
            --print(trait.shroudedSuffocation.rank)
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
            -- if GetObjectID(units.dyn5) == 144081 then
            --     print("123")
            -- end
            --print(getSpellCD(703))
            --if actionList_Defensive() then return end
            if cd.vanish.remain() >= 10 then
                if mode.van2 == 1 then toggle("Van2",2) end
                if mode.van1 == 1 then toggle("Van1",2) end
            end
            if actionList_Defensive() then return end
            if mode.opener == 1 then
                if isChecked("Exsa no vendetta opener") then
                    if actionList_OpenNoVend() then end
                else if actionList_Open() then end
                end
                return true
            end
            if inCombat and not stealth and isValidUnit("target") and getDistance("target") <= 5 then
                StartAttack()
            end
            ChatOverlay("rotating")
            -- if isChecked("Search for orb/ghuunies") and br.player.instance=="party" then
            --     if burnpool() then return end
            -- end
            
            if inCombat or (cast.last.vanish() and (br.player.instance=="party" or isDummy("target"))) then
                if isChecked("Viable targets") then
                    LibDraw.clearCanvas()
                    showviable()
                end
                if not stealthingRogue then
                    if actionList_Special() then return end
                end
                if not stealth then
                    if mode.stun == 1 then
                        if actionList_Stun() then return end
                    end
                    if swingTimer == 0 and isChecked("Check AA") then
                        startaa()
                    end
                    if actionList_Interrupts() then end
                end    
                if stealthingRogue then
                    if actionList_Stealthed() then return end
                    return
                end
                if mode.special == 1 then
                    if actionList_Cooldowns() then return end
                end
                --print(#br.player.enemies.yards5)
                --print(stealthingRogue)
                --print(bleeds)
                if not stealth and mode.opener == 2   then
                    if isChecked("Search for orb/ghuunies") and br.player.instance=="party" then
                        if burnpool() then return end
                    end
                    if isChecked("Toxic Blade on cd") and getDistance("target") <= 5  then
                        if cast.able.toxicBlade() and not stealthingRogue and ttd("target") >= 5 then 
                            if cast.toxicBlade() then return true end
                        end
                    end
                    
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
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
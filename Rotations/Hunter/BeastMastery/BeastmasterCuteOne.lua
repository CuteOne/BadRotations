local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.cobraShot },
        --[2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.volley },
        [2] = { mode = "Sing", value = 2 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.killCommand },
        --[4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.aspectOfTheWild}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.aspectOfTheWild },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.aspectOfTheWild },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.aspectOfTheWild }
    };
       CreateButton("Cooldown",2,0)
-- BW Button
    BestialWrathModes = {
        [1] = { mode = "On", value = 1 , overlay = "Will use BW", tip = "Will use bw according to rotation", highlight = 1, icon = br.player.spell.bestialWrath },
        [2] = { mode = "Off", value = 2 , overlay = "Will hold BW", tip = "Will hold BW until toggled again", highlight = 0, icon = br.player.spell.bestialWrath }
    };
    CreateButton("BestialWrath",3,0)       
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.aspectOfTheTurtle },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.aspectOfTheTurtle }
    };
    CreateButton("Defensive",4,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterShot },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterShot }
    };
    CreateButton("Interrupt",5,0)
    -- MD Button
    MisdirectionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    CreateButton("Misdirection",6,0)
    -- Murder of crows
    MurderofCrowsModes = {
        [1] = { mode = "On", value = 1 , overlay = "Always use MoC", tip = "Will Use Murder of Crows At All Times", highlight = 1, icon = br.player.spell.aMurderOfCrows },
        [2] = { mode = "CD", value = 2 , overlay = "Use MoC only on Cooldowns", tip = "Will Use Murder of Crows Only on Cooldowns", highlight = 0, icon = br.player.spell.aMurderOfCrows }
    };
    CreateButton("MurderofCrows",7,0)
    --Pet summon
    PetSummonModes = {
        [1] = { mode = "On", value = 1 , overlay = "Summon Pet 1", tip = "Summon Pet 1", highlight = 1, icon = br.player.spell.callPet1 },
        [2] = { mode = "On", value = 2 , overlay = "Summon Pet 2", tip = "Summon Pet 2", highlight = 1, icon = br.player.spell.callPet2 },
        [3] = { mode = "On", value = 3 , overlay = "Summon Pet 3", tip = "Summon Pet 3", highlight = 1, icon = br.player.spell.callPet3 },
        [4] = { mode = "On", value = 4 , overlay = "Summon Pet 4", tip = "Summon Pet 4", highlight = 1, icon = br.player.spell.callPet4 },
        [5] = { mode = "On", value = 5 , overlay = "Summon Pet 5", tip = "Summon Pet 5", highlight = 1, icon = br.player.spell.callPet5 },
        [6] = { mode = "off", value = 6 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.callPet }
    };
    CreateButton("PetSummon",8,0)

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
        -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- AoE Units
            br.ui:createSpinnerWithout(section, "Units To AoE", 2, 1, 10, 1, "|cffFFFFFFSet to desired units to start AoE at.")
        -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        -- Opener
            br.ui:createCheckbox(section, "Opener")
        br.ui:checkSectionState(section)
    -- Pet Options
        section = br.ui:createSection(br.ui.window.profile, "Pet")
        -- Auto Summon
           -- br.ui:createDropdown(section, "Auto Summon", {"Pet 1","Pet 2","Pet 3","Pet 4","Pet 5","No Pet"}, 1, "Select the pet you want to use")
        -- Auto Attack/Passive
            br.ui:createCheckbox(section, "Auto Attack/Passive")
        -- Auto Growl
            br.ui:createCheckbox(section, "Auto Growl")
        -- Mend Pet
            br.ui:createSpinner(section, "Mend Pet",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
		-- Spirit Mend
			br.ui:createSpinner(section, "Spirit Mend", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Pet Attacks
            br.ui:createCheckbox(section, "Pet Attacks")
        -- Purge
            br.ui:createDropdown(section, "Purge", {"Every Unit","Only Target"}, 2, "Select if you want Purge only Target or every Unit arround the Pet")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Agi Pot
            br.ui:createCheckbox(section,"Potion")
        -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Seventh Demon","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF001st Only","|cff00FF002nd Only","|cffFFFF00Both","|cffFF0000None"}, 1, "|cffFFFFFFSelect Trinket Usage.")
        -- Bestial Wrath
            br.ui:createCheckbox(section,"Bestial Wrath")
        -- Trueshot
            br.ui:createCheckbox(section,"Aspect of the Wild")
        -- Stampede
            br.ui:createCheckbox(section,"Stampede")
        -- A Murder of Crows / Barrage
            br.ui:createCheckbox(section,"A Murder Of Crows / Barrage")
            -- Spitting Cobra
            br.ui:createCheckbox(section,"Spitting Cobra")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Engineering: Shield-o-tronic
            br.ui:createSpinner(section, "Shield-o-tronic",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Aspect of the Turtle
            br.ui:createSpinner(section, "Aspect Of The Turtle",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Concussive Shot
            br.ui:createSpinner(section, "Concussive Shot", 10, 5, 40, 5, "|cffFFBB00Minmal range to use at.")
        -- Disengage
            br.ui:createSpinner(section, "Disengage", 5, 5, 40, 5, "|cffFFBB00Minmal range to use at.")
        -- Exhilaration
            br.ui:createSpinner(section, "Exhilaration",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Feign Death
            br.ui:createSpinner(section, "Feign Death", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Counter Shot
            br.ui:createCheckbox(section,"Counter Shot")
	-- Intimidation
            br.ui:createCheckbox(section,"Intimidation")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  6)
        -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  6)
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
    -- if br.timer:useTimer("debugBeastmaster", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("BestialWrath",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        br.player.mode.misdirection = br.data.settings[br.selectedSpec].toggles["Misdirection"]
        UpdateToggle("Misdirection", 0.25)
        br.player.mode.PetSummon = br.data.settings[br.selectedSpec].toggles["PetSummon"]
        UpdateToggle("PetSummon", 0.25)
        br.player.mode.murderofcrows = br.data.settings[br.selectedSpec].toggles["MurderofCrows"]
        UpdateToggle("murderofcrows",0.25)

        if isChecked("Spirit Mend") then br.friend:Update() end


--------------
--- Locals ---
--------------
        local addsExist                                     = false
        local addsIn                                        = 999
        local animality                                     = false
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local canFlask                                      = canUse(br.player.flask.wod.agilityBig)
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local combo                                         = br.player.comboPoints
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadPets                                      = deadPet
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local fatality                                      = false
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or GetUnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local hasMouse                                      = GetObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local item                                          = br.player.spell.items
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].hp
        local mode                                          = br.player.mode
        local multidot                                      = (br.player.mode.cleave == 1 or br.player.mode.rotation == 2) and br.player.mode.rotation ~= 3
        local perk                                          = br.player.perk
        local pethp                                         = getHP("pet")
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local potion                                        = br.player.potion
        local power, powerMax, powerRegen, powerDeficit     = br.player.power.focus.amount(), br.player.power.focus.max(), br.player.power.focus.regen(), br.player.power.focus.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local solo                                          = #br.friend < 2
        local friendsInRange                                = friendsInRange
        local spell                                         = br.player.spell
        local t19_2pc                                       = TierScan("T19") >= 2
        local t20_2pc                                       = TierScan("T20") >= 2
        local talent                                        = br.player.talent
        local trait                                         = br.player.traits
        local trinketProc                                   = false
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.focus.ttm()
        local units                                         = br.player.units
        local use                                           = br.player.use
        local openerCount


        units.get(40)
        enemies.get(40)

        if GetObjectExists("pet") then
            enemies.get(8,"pet")
            enemies.get(5,"pet")
            enemies.get(20,"pet")
        end

        local lowestUnit = lowestUnit or units.dyn40
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if debuff.bestialFerocity.exists(thisUnit) then
                if debuff.bestialFerocity.exists(lowestUnit) then
                    lowestFerocity = debuff.bestialFerocity.remain(lowestUnit)
                else
                    lowestFerocity = 40
                end
                if debuff.bestialFerocity.remain(thisUnit) < lowestFerocity then
                    lowestUnit = thisUnit
                end
            end
        end

        function TankInRange()
            if isChecked("Auto Growl") then
                    if #br.friend > 1 then
                        for i = 1, #br.friend do
                            local friend = br.friend[i]
                            if friend.GetRole()== "TANK" and not UnitIsDeadOrGhost(friend.unit) and getDistance(friend.unit) < 100 then
                            return true
                            end
                        end
                    end
            end
            return false
        end


        function TankInRange()
                    if #br.friend > 1 then
                        for i = 1, #br.friend do
                            local friend = br.friend[i]
                            if friend.GetRole()== "TANK" and not UnitIsDeadOrGhost(friend.unit) and getDistance(friend.unit) < 100 then
                            return true
                            end
                        end
                    end
            return false
        end

        local bestUnit = "target"
        local lowestAbs = 999
        for i = 1, #enemies.yards40 do
          local thisUnit = enemies.yards40[i]
          local ttdAbs = math.abs(ttd(thisUnit)-14)
          if ttdAbs < lowestAbs then 
            bestUnit = enemies.yards40[i]
            lowestAbs = ttdAbs
          end
        end

   		if leftCombat == nil then leftCombat = GetTime() end
		if profileStop == nil then profileStop = false end
        if opener == nil then opener = false end
        if openerCount == nil then openerCount = 0 end

        -- Opener Reset
        if not inCombat and not GetObjectExists("target") then
			openerCount = 0
            OPN1 = false
            MOC1 = false
            KC1 = false
            CS1 = false
            opener = false
        end

        -- if UnitExists(units.dyn40) then
        --     ChatOverlay("Exists: "..tostring(GetUnitExists(units.dyn40))..", Not Dead: "..tostring(not UnitIsDeadOrGhost(units.dyn40))..", Enemy: "
        --         ..tostring(not GetUnitIsFriend(units.dyn40, "player") or UnitIsEnemy(units.dyn40, "player"))..", Attack: "..tostring(UnitCanAttack("player",units.dyn40))..", Safe: "
        --         ..tostring(isSafeToAttack(units.dyn40))..", in LoS: "..tostring(getLineOfSight("player", units.dyn40))..", in Phase: "..tostring(UnitInPhase(units.dyn40)))
        -- end

--------------------
--- Action Lists ---
--------------------
    -- Action List - Pet Management
        local function actionList_PetManagement()
            if UnitExists("pet") and IsPetActive() and deadPet then deadPet = false end
            if IsMounted() or IsFlying() or UnitHasVehicleUI("player") or CanExitVehicle("player") then
                waitForPetToAppear = GetTime()
            elseif br.player.mode.PetSummon ~= 6 then
                local callPet = spell["callPet"..br.player.mode.PetSummon]
                if waitForPetToAppear ~= nil and GetTime() - waitForPetToAppear > 2 then
                    if cast.able.dismissPet() and UnitExists("pet") and IsPetActive() and (callPet == nil or UnitName("pet") ~= select(2,GetCallPetSpellInfo(callPet))) then
                        if cast.dismissPet() then waitForPetToAppear = GetTime(); return true end
                    elseif callPet ~= nil then
                        if UnitIsDeadOrGhost("pet") or deadPet then
                            if cast.able.revivePet() then
                                if cast.revivePet() then waitForPetToAppear = GetTime(); return true end
                            end
                        elseif not deadPet and not (IsPetActive() or UnitExists("pet")) and not buff.playDead.exists("pet") then
                            if castSpell("player",callPet,false,false,false) then waitForPetToAppear = GetTime(); return true end
                        end
                    end
                end
                
                if waitForPetToAppear == nil then
                    waitForPetToAppear = GetTime()
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
                if inCombat and (isValidUnit("target") or isDummy()) and getDistance("target") < 40 and not GetUnitIsUnit("target","pettarget") then
                    -- Print("Pet is switching to your target.")
                    PetAttack()
                end
                if (not inCombat or (inCombat and not isValidUnit("pettarget") and not isDummy())) and IsPetAttackActive() then
                    PetStopAttack()
                    PetFollow()
                end
            end

            -- Spirit Mend
            if isChecked("Spirit Mend") and UnitExists("pet") and not UnitIsDeadOrGhost("pet") and not deadPets and lowestHP < getOptionValue("Spirit Mend") then
                local thisUnit = br.friend[1].unit
                if cast.spiritmend(thisUnit) then return end
            end

            -- Purge
            if isChecked("Purge") and getValue("Purge") == 1 then
                for i = 1, #enemies.yards5p do 
                    local thisUnit = enemies.yards5p[i]
                                --your dispel logic
                        if canDispel(thisUnit,spell.spiritShock) then
                            if cast.able.spiritShock(thisUnit) then
                                if castSpell(thisUnit,spell.spiritShock,true,false,false,false,false,true) then
                                         print("casting dispel on ".. UnitName(thisUnit))
                                    return end
                            elseif cast.able.chiJiTranq(thisUnit) then
                                if castSpell(thisUnit,spell.chiJiTranq,true,false,false,false,false,true) then
                                         print("casting dispel on ".. UnitName(thisUnit))
                                    return end
                            elseif cast.able.naturesGrace(thisUnit) then
                                if castSpell(thisUnit,spell.naturesGrace,true,false,false,false,false,true) then
                                         print("casting dispel on ".. UnitName(thisUnit))
                                    return end
                            elseif cast.able.netherShock(thisUnit) then
                                if castSpell(thisUnit,spell.netherShock,true,false,false,false,false,true) then
                                         print("casting dispel on ".. UnitName(thisUnit))
                                    return end
                            elseif cast.able.sonicBlast(thisUnit) then
                                if castSpell(thisUnit,spell.sonicBlast,true,false,false,false,false,true) then
                                         print("casting dispel on ".. UnitName(thisUnit))
                                    return end
                            elseif cast.able.soothingWater(thisUnit) then
                                if castSpell(thisUnit,spell.soothingWater,true,false,false,false,false,true) then
                                         print("casting dispel on ".. UnitName(thisUnit))
                                    return end
                            elseif cast.able.sporeCloud(thisUnit) then
                                if castSpell(thisUnit,spell.sporeCloud,true,false,false,false,false,true) then
                                         print("casting dispel on ".. UnitName(thisUnit))
                                    return end
                            end
                        end
                end
        elseif isChecked("Purge") and getValue("Purge") == 2 then
                if  canDispel("target",spell.spiritShock) then
                      if cast.able.spiritShock("target") then
                                if castSpell("target",spell.spiritShock,true,false,false,false,false,true) then
                                         print("casting dispel on ".. UnitName(thisUnit))
                                    return end
                            elseif cast.able.chiJiTranq("target") then
                                if castSpell("target",spell.chiJiTranq,true,false,false,false,false,true) then
                                         print("casting dispel on ".. UnitName(thisUnit))
                                    return end
                            elseif cast.able.naturesGrace("target") then
                                if castSpell("target",spell.naturesGrace,true,false,false,false,false,true) then
                                         print("casting dispel on ".. UnitName(thisUnit))
                                    return end
                            elseif cast.able.netherShock("target") then
                                if castSpell("target",spell.netherShock,true,false,false,false,false,true) then
                                         print("casting dispel on ".. UnitName(thisUnit))
                                    return end
                            elseif cast.able.sonicBlast("target") then
                                if castSpell("target",spell.sonicBlast,true,false,false,false,false,true) then
                                         print("casting dispel on ".. UnitName(thisUnit))
                                    return end
                            elseif cast.able.soothingWater("target") then
                                if castSpell("target",spell.soothingWater,true,false,false,false,false,true) then
                                         print("casting dispel on ".. UnitName(thisUnit))
                                    return end
                            elseif cast.able.sporeCloud("target") then
                                if castSpell("target",spell.sporeCloud,true,false,false,false,false,true) then
                                         print("casting dispel on ".. UnitName(thisUnit))
                                    return end
                                end
                            end
                        end

            -- Growl
            if isChecked("Auto Growl") then
                local petGrowl = GetSpellInfo(2649)
                if isTankInRange() then
                    DisableSpellAutocast(petGrowl)
                else
                    EnableSpellAutocast(petGrowl)
                end
            end
            -- Mend Pet
            if isChecked("Mend Pet") and UnitExists("pet") and not UnitIsDeadOrGhost("pet") and not deadPets and getHP("pet") < getOptionValue("Mend Pet") and not buff.mendPet.exists("pet") then
                if cast.mendPet() then return end
            end
			-- Spirit Mend
            if isChecked("Spirit Mend") and UnitExists("pet") and not UnitIsDeadOrGhost("pet") and not deadPets and lowestHP < getOptionValue("Spirit Mend") then
                local thisUnit = br.friend[1]
                if cast.spiritmend(thisUnit) then return end
            end
        end
    -- Action List - Extras
        local function actionList_Extras()
        -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        PetStopAttack()
                        PetFOllow()
                        Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end -- End Dummy Test
        -- Misdirection
            if mode.misdirection == 1 then
                  if isValidUnit("target") then
                      if inInstance or inRaid then
                          for i = 1, #br.friend do
                              if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and UnitAffectingCombat(br.friend[i].unit) then
                                  if cast.misdirection(br.friend[i].unit) then return end
                              end
                          end
                      else
                          if GetUnitExists("pet") then
                              if cast.misdirection("pet") then return end
                          end
                      end
                  end
            end
        end -- End Action List - Extras
    -- Action List - Defensive
        local function actionList_Defensive()
            if useDefensive() then
        -- Pot/Stoned
                if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned")
                    and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healPot) then
                        useItem(healPot)
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
        -- Engineering: Shield-o-tronic
                if isChecked("Shield-o-tronic") and php <= getOptionValue("Shield-o-tronic")
                    and inCombat and canUse(118006)
                then
                    useItem(118006)
                end
        -- Aspect of the Turtle
                if isChecked("Aspect Of The Turtle") and php <= getOptionValue("Aspect Of The Turtle") then
                    if cast.aspectOfTheTurtle("player") then return end
                end
        -- Concussive Shot
                if isChecked("Concussive Shot") and getDistance("target") < getOptionValue("Concussive Shot") and isValidUnit("target") then
                    if cast.concussiveShot("target") then return end
                end
        -- Disengage
                if isChecked("Disengage") and getDistance("target") < getOptionValue("Disengage") and isValidUnit("target") then
                    if cast.disengage("player") then return end
                end
        -- Exhilaration
                if isChecked("Exhilaration") and php <= getOptionValue("Exhilaration") then
                    if cast.exhilaration("player") then return end
                end
        -- Feign Death
                if isChecked("Feign Death") and php <= getOptionValue("Feign Death") then
                    if cast.feignDeath("player") then return end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
	        -- Counter Shot
                if isChecked("Counter Shot") then
                    for i=1, #enemies.yards40 do
                    thisUnit = enemies.yards40[i]
                        if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                            if cast.counterShot(thisUnit) then return end
                        end
                    end
                end
            -- Intimidation
                if isChecked("Intimidation") and not UnitIsDeadOrGhost("pet") and not deadPets then
                    for i=1, #enemies.yards40 do
                        thisUnit = enemies.yards40[i]
                        if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                            if cast.intimidation(thisUnit) then return end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            if useCDs() then
            -- Trinkets
                -- use_items
                if getOptionValue("Trinkets") ~= 4 then
                    if (getOptionValue("Trinkets") == 1 or getOptionValue("Trinkets") == 3) and canUse(13) then
                        useItem(13)
                    end
                    if (getOptionValue("Trinkets") == 2 or getOptionValue("Trinkets") == 3) and canUse(14) then
                        useItem(14)
                    end
                end
            -- Racial
                -- arcane_torrent,if=focus.deficit>=30
                -- berserking,if=buff.bestial_wrath.remains>7
                -- blood_fury,if=buff.bestial_wrath.remains>7
                if isChecked("Racial") then
                    if (buff.bestialWrath.remain() > 7 and (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei")) or (powerDeficit >= 30 and race == "BloodElf")
                    then
                        if race == "LightforgedDraenei" then
                            if cast.racial("target","ground") then return true end
                        else
                            if cast.racial("player") then return true end
                        end
                    end
                end
            -- Potion
                -- potion,if=buff.bestial_wrath.up&buff.aspect_of_the_wild.up
                if isChecked("Potion") and canUse(142117) and inRaid and (buff.bestialWrath.exists() or level < 40) and (buff.aspectOfTheWild.exists() or level < 26) then
                    useItem(142117);
                    return true
                end
                if isChecked("A Murder Of Crows / Barrage") then
                    if cast.aMurderOfCrows(bestUnit) then return end
                end
                --actions+=/spitting_cobra
                if isChecked("Spitting Cobra") and talent.spittingCobra then
                    if cast.spittingCobra() then return end
                end
                --actions+=/stampede,if=buff.bestial_wrath.up|cooldown.bestial_wrath.remains<gcd|target.time_to_die<15
                if isChecked("Stampede") and talent.stampede and (buff.bestialWrath.exists() or cd.bestialWrath.remain() < gcdmax or ttd(units.dyn40) < 15) then
                    if cast.stampede() then return end
                end
				--Aspect of the wild
        		if isChecked("Aspect of the Wild") and useCDs() and (not trait.primalInstincts.active() or (trait.primalInstincts.active() and charges.barbedShot.frac() < 0.9)) and ((buff.bestialWrath.exists() and buff.bestialWrath.remain() >= 13) or cd.bestialWrath.remain() <= gcd) then
        			if cast.aspectOfTheWild() then return end
        		end

            end -- End useCooldowns check
        end -- End Action List - Cooldowns
    -- Action List - Opener
        function actionList_Opener()
		-- Start Attack
            -- auto_attack
            if isChecked("Opener") and isBoss("target") and opener == false then
                if isValidUnit("target") and getDistance("target") < 40 then
            -- Begin
					if not OPN1 then
                        Print("Starting Opener")
                        openerCount = openerCount + 1
                        OPN1 = true
                    elseif OPN1 and not MOC1 then
            -- A Murder of Crows
                        -- a_murder_of_crows
                        if useCDs() and isChecked("A Murder Of Crows / Barrage") then
       					    if castOpener("aMurderOfCrows","MOC1",openerCount) then openerCount = openerCount + 1; return end
                        else
                            Print(openerCount..": A Murder of Crows (Uncastable)")
                            openerCount = openerCount + 1
                            MOC1 = true
                        end
                    elseif MOC1 and not KC1 then
            -- Kill Command
                        -- kill_command
                        if cast.able.killCommand() then
                            if castOpener("killCommand","KC1",openerCount) then openerCount = openerCount + 1; return end
                        else
                            Print(openerCount..": Kill Command (Uncastable)")
                            openerCount = openerCount + 1
                            KC1 = true
                        end
                    elseif KC1 and not CS1 then
       		-- Cobra Shot
                        -- cobra_shot
                        if cast.able.cobraShot() then
       					    if castOpener("cobraShot","CS1",openerCount) then openerCount = openerCount + 1; return end
                        else
                            Print(openerCount..": Cobra Shot (Uncastable)")
                            openerCount = openerCount + 1
                            CS1 = true
                        end
            -- Finish (rip exists)
                    elseif CS1 then
                        Print("Opener Complete")
                        openerCount = 0
                        opener = true
                        return
       				end
                end
			elseif (UnitExists("target") and not isBoss("target")) or not isChecked("Opener") then
				opener = true
			end
        end -- End Action List - Opener
    -- Action List - Pre-Combat
        local function actionList_PreCombat()
            rotationDebug = "Pre-Combat"
            if not inCombat and not buff.feignDeath.exists() then
            -- Flask / Crystal
                -- flask,type=flask_of_the_seventh_demon
                if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfTheSeventhDemon.exists() and canUse(item.flaskOfTheSeventhDemon) then
                    if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                    if buff.felFocus.exists() then buff.felFocus.cancel() end
                    if use.flaskOfTheSeventhDemon() then return end
                end
                if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and canUse(item.repurposedFelFocuser) then
                    if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                    if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                    if use.repurposedFelFocuser() then return end
                end
                if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUse(item.oraliusWhisperingCrystal) then
                    if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                    if buff.felFocus.exists() then buff.felFocus.cancel() end
                    if use.oraliusWhisperingCrystal() then return end
                end
            -- Summon Pet
                -- summon_pet
                if actionList_PetManagement() then return end
                if isValidUnit("target") and getDistance("target") < 40 and opener == true then
            -- Cobra Shot
                    if cast.cobraShot("target") then return end
            -- Auto Shot
                    StartAttack()
                end
            end
        -- Opener
            if actionList_Opener() then return true end
        end
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or (IsMounted() or IsFlying()) or pause() or buff.feignDeath.exists() or mode.rotation==4 then
            if not pause() and IsPetAttackActive() then
                PetStopAttack()
                PetFollow()
            end
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
    -----------------
    --- Pet Logic ---
    -----------------
            if actionList_PetManagement() then return end
    -----------------
    --- Defensive ---
    -----------------
            if actionList_Defensive() then return end
    ------------------
    --- Pre-Combat ---
    ------------------
            if actionList_PreCombat() then return end
-----------------------------
--- In Combat - Rotations ---
-----------------------------
            if inCombat and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 and opener == true then
    -----------------
    --- Pet Logic ---
    -----------------
                if actionList_PetManagement() then return end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Extras() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                if getOptionValue("APL Mode") == 1 then
            -- Start Attack
                    StartAttack()
                    --Hold rotation for perfect Frenzy placement
					if (charges.barbedShot.recharge() <= 1.5 or charges.barbedShot.frac() >= 1) and buff.frenzy.exists("pet") and buff.frenzy.remain("pet") <= 1.5 and buff.frenzy.remain("pet") > 0.5 then return end
                    --actions+=/barbed_shot,if=pet.cat.buff.frenzy.up&pet.cat.buff.frenzy.remains<=gcd.max
                    if (buff.frenzy.exists("pet") and buff.frenzy.remain("pet") <= gcdMax) or (useCDs() and trait.primalInstincts.active() and cd.aspectOfTheWild.remain() <= gcdMax and charges.barbedShot.frac() >= 1) or charges.barbedShot.frac() >= 2 then
                        if cast.barbedShot() then return end
                    end
                    --Pet Attacks
                    if not UnitIsDeadOrGhost("pet") and not deadPets and isChecked("Pet Attacks") then
                      if getDistance("pettarget","pet") < 5 then
                        --Claw
                        cast.claw("pettarget")
                        --Bite
                        cast.bite("pettarget")
                        --Smack
                        cast.smack("pettarget")
                      end
                      --PetAttack
                      PetAttack()
                    end
					--Cooldowns
                    if actionList_Cooldowns() then return end
					-- actions+=/barbed_shot,if=pet.cat.buff.frenzy.down|full_recharge_time<gcd.max
                    if not buff.frenzy.exists("pet") and charges.barbedShot.frac() >= 2 then
                        if cast.barbedShot() then return end
                    end
                    -- actions+=/bestial_wrath,if=!buff.bestial_wrath.up
                    if isChecked("Bestial Wrath") and mode.BestialWrath == 1 and not buff.bestialWrath.exists() then
                        if cast.bestialWrath() then return end
                    end
                    -- Murder of crows
                    if mode.murderofcrows == 1 and isChecked("A Murder Of Crows / Barrage") then
                        if cast.aMurderOfCrows(bestUnit) then return end
                    end
                    -- actions+=/multishot,if=spell_targets>2&(pet.cat.buff.beast_cleave.remains<gcd.max|pet.cat.buff.beast_cleave.down)
                    if ((mode.rotation == 1 and #enemies.yards8p >= getOptionValue("Units To AoE") and #enemies.yards8p > 2) or mode.rotation == 2)
                        and (buff.beastCleave.remain("pet") < gcdMax or not buff.beastCleave.exists("pet"))
                    then
                        if cast.multiShot() then return end
                    end
                    -- actions+=/kill_command if target hp < 35%
                    if cast.able.killCommand() and getHP("pettarget") < 35 then
                        if cast.killCommand("pettarget") then return end
                      end
                    -- actions+=/chimaera_shot
                    if talent.chimaeraShot then
                        if cast.chimaeraShot() then return end
                    end
                    -- actions+=/kill_command
                    if cast.able.killCommand() then
                      if cast.killCommand("pettarget") then return end
                    end
                    -- actions+=/dire_beast
                    if talent.direBeast then
                        if cast.direBeast() then return end
                    end
                    -- actions+=/barrage
                    if isChecked("A Murder Of Crows / Barrage") and #enemies.yards8p >= 1 then
                        if cast.barrage() then return end
                    end
                    -- actions+=/multishot,if=spell_targets>1&(pet.cat.buff.beast_cleave.remains<gcd.max|pet.cat.buff.beast_cleave.down)
                    if (mode.rotation == 1 and #enemies.yards8p >= getOptionValue("Units To AoE") and #enemies.yards8p > 1)
                        and (buff.beastCleave.remain("pet") < gcdMax or not buff.beastCleave.exists("pet"))then
                        if cast.multiShot() then return end
                    end
                    -- actions+=/cobra_shot,if=(active_enemies<2|cooldown.kill_command.remains>focus.time_to_max)&(buff.bestial_wrath.up&active_enemies>1|cooldown.kill_command.remains>1+gcd&cooldown.bestial_wrath.remains>focus.time_to_max|focus-cost+focus.regen*(cooldown.kill_command.remains-1)>action.kill_command.cost)
                    if (#enemies.yards8p < 2 or cd.killCommand.remain() > ttm) and ((buff.bestialWrath.exists() and #enemies.yards8p > 1) or
                        (cd.killCommand.remain() > 1 + gcdMax and cd.bestialWrath.remain() > ttm) or power > 90)
                    then
                        if cast.cobraShot() then return end
                    end
                end -- End SimC APL
			end --End In Combat
        end --End Rotation Logic
    end
local id = 253
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

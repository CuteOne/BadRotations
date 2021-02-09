local rotationName = "CuteOneArhTest"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.rapidFire },
        --[2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.volley },
        [2] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.arcaneShot },
        --[4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.aspectOfTheWild}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.trueshot },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.trueshot },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.concussiveShot }
    };
   	CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.aspectOfTheTurtle },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.aspectOfTheTurtle }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterShot },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterShot }
    };
    CreateButton("Interrupt",4,0)
    -- MD Button
    MisdirectionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    CreateButton("Misdirection",5,0)
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
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF001st Only","|cff00FF002nd Only","|cffFFFF00Both","|cffFF0000None"}, 1, "|cffFFFFFFSelect Trinket Usage.")
        -- Trueshot
            br.ui:createCheckbox(section,"Trueshot")
        -- Double tao
            br.ui:createCheckbox(section,"Double tap")
        -- Murder of crows
            br.ui:createCheckbox(section,"Murder of crows")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Engineering: Shield-o-tronic
            br.ui:createSpinner(section, "Shield-o-tronic",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Exhilaration
            br.ui:createSpinner(section, "Exhilaration",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Counter Shot
            br.ui:createCheckbox(section,"Counter Shot")
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
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        br.player.ui.mode.misdirection = br.data.settings[br.selectedSpec].toggles["Misdirection"]
        UpdateToggle("Misdirection", 0.25)
        -- br.player.ui.mode.murderofcrows = br.data.settings[br.selectedSpec].toggles["MurderofCrows"]
        -- UpdateToggle("MurderofCrows",0.25)


--------------
--- Locals ---
--------------
        local addsExist                                     = false
        local addsIn                                        = 999
        local animality                                     = false
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local canFlask                                      = canUseItem(br.player.flask.wod.agilityBig)
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
        local item                                          = br.player.items
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].hp
        local mode                                          = br.player.ui.mode
        local multidot                                      = (br.player.ui.mode.cleave == 1 or br.player.ui.mode.rotation == 2) and br.player.ui.mode.rotation ~= 3
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


        units.dyn40 = units.get(40 * (1 + GetMasteryEffect()/100))
        units.get(45)
        enemies.yards40 = enemies.get(40 * (1 + GetMasteryEffect()/100))
        enemies.get(45)
        enemies.get(8,"target")

   		if leftCombat == nil then leftCombat = GetTime() end
		if profileStop == nil then profileStop = false end
        if opener == nil then opener = false end
        if openerCount == nil then openerCount = 0 end

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


--------------------
--- Action Lists ---
--------------------
			    -- Action List - Single
                function actionList_Single()

                    --Aimed shot supposed to cast aimed shot at units under careful aim talent influence
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                            if (getHP(thisUnit) > 80 or getHP(thisUnit) < 20) and ttd("thisUnit") > (cast.time.aimedShot() + 2) then
                                if cast.aimedShot(thisUnit) then return true end
                            end
                    end
                    --Arcane shot actions.st+=/arcane_shot,if=buff.precise_shots.up&(cooldown.aimed_shot.full_recharge_time<gcd*buff.precise_shots.stack+action.aimed_shot.cast_time|buff.lethal_shots.up)
					if buff.preciseShots.exists() and (cd.aimedShot.remain() < gcdMax * buff.preciseShots.stack() + cast.time.aimedShot() or buff.lethalShots.exists()) then
						if cast.arcaneShot() then return end
					end
					--Rapid fire actions.st+=/rapid_fire,if=(!talent.lethal_shots.enabled|buff.lethal_shots.up)&azerite.focused_fire.enabled|azerite.in_the_rhythm.rank>1
					if (not talent.lethalShots or buff.lethalShots.exists()) or (trait.focusedFire.active or trait.inTheRhythm.rank > 1) then
						if cast.rapidFire() then return end
					end
					--Aimed shot actions.st+=/aimed_shot,if=buff.precise_shots.down&(buff.double_tap.down&full_recharge_time<cast_time+gcd|buff.lethal_shots.up)
					if not buff.preciseShots.exists() and (not buff.doubleTap.exists() and charges.aimedShot.timeTillFull() < cast.time.aimedShot() + gcdMax or buff.lethalShots.exists()) then
						if cast.aimedShot() then return end
					end
					--Rapid fire actions.st+=/rapid_fire,if=!talent.lethal_shots.enabled|buff.lethal_shots.up
					if not talent.lethalShots or buff.lethalShots.exists() then
						if cast.rapidFire() then return end
					end 
					--Aimed shot actions.st+=/aimed_shot,if=buff.precise_shots.down&(!talent.steady_focus.enabled&focus>70|!talent.lethal_shots.enabled|buff.lethal_shots.up)
					if not buff.preciseShots.exists() and (not talent.steadyFocus and power > 70 or not talent.lethalShots or buff.lethalShots.exists()) then
						if cast.aimedShot() then return end
					end
					--Arcane shot actions.st+=/arcane_shot,if=buff.precise_shots.up|focus>60&(!talent.lethal_shots.enabled|buff.lethal_shots.up)
					if buff.preciseShots.exists() or power > 60 and (not talent.lethalShots or buff.lethalShots.exists()) then
						if cast.arcaneShot() then return end
					end
					--Steady shot actions.st+=/steady_shot,if=focus+cast_regen<focus.max|(talent.lethal_shots.enabled&buff.lethal_shots.down)
					if (power + (cast.regen.steadyShot() + 10) < powerMax) or (talent.lethalShots and not buff.lethalShots.exists()) then
						if cast.steadyShot() then return end
					end
                    --Arcane shot actions.st+=/arcane_shot
                    if power > 70 then
                    if cast.arcaneShot() then return end
                    end
			 end		
					
			-- Action List - AOE
            function actionList_AOE()
                    --Aimed shot supposed to cast aimed shot at units under careful aim talent influence
                    for i = 1, #enemies.yards8t do
                        local thisUnit = #enemies.yards8t[i]
                            if buff.trickShots.exists() and (getHP(thisUnit) > 80 or getHP(thisUnit) < 20) and ttd("thisUnits") > (cast.time.aimedShot() + 1) then
                                if cast.aimedShot(thisUnit) then return true end
                            end
                    end
                    --Aimed shot actions.st+=/aimed_shot,if=buff.precise_shots.down&(buff.double_tap.down&full_recharge_time<cast_time+gcd|buff.lethal_shots.up)
					if buff.trickShots.exists() and not buff.preciseShots.exists() then
						if cast.aimedShot() then return end
					end
					--Rapid fire actions.trickshots+=/rapid_fire,if=buff.trick_shots.up&!talent.barrage.enabled
					if buff.trickShots.exists() then
						if cast.rapidFire() then return end
					end
					--Aimed shot actions.trickshots+=/aimed_shot,if=buff.trick_shots.up&buff.precise_shots.down&buff.double_tap.down&(!talent.lethal_shots.enabled|buff.lethal_shots.up|focus>60)
					if buff.trickShots.exists() and not buff.preciseShots.exists() and not buff.doubleTap.exists() then
						if cast.aimedShot() then return end
					end
                    --multishot actions.trickshots+=/multishot,if=buff.trick_shots.down|(buff.precise_shots.up|buff.lethal_shots.up)&(!talent.barrage.enabled&buff.steady_focus.down&focus>45|focus>70)
					if (not buff.trickShots.exists() or buff.preciseShots.exists()) or power > 70 then
						if cast.multishot() then return end
					end
					--Steady shot actions.trickshots+=/steady_shot,if=focus+cast_regen<focus.max|(talent.lethal_shots.enabled&buff.lethal_shots.down)
					if ((power + (cast.regen.steadyShot() + 10)) < powerMax) then
                        if cast.steadyShot() then return end
                    end
                end

            -- Action List - Cooldowns
            function actionList_Cooldowns()
                if useCDs() then

            -- Trinkets
            -- use_items
            if getOptionValue("Trinkets") ~= 4 then
                if (getOptionValue("Trinkets") == 1 or getOptionValue("Trinkets") == 3) and canUseItem(13) then
                    useItem(13)
            end
            if (getOptionValue("Trinkets") == 2 or getOptionValue("Trinkets") == 3) and canUseItem(14) then
                    useItem(14)
                    end
            end                    

					--Murder of crows actions.st+=/a_murder_of_crows
                    if talent.aMurderOfCrows and isChecked("Murder of crows") then
                        if cast.aMurderOfCrows(bestUnit) then return end
                    end    

                --Trueshot
                if isChecked("Trueshot") and
                charges.aimedShot.count() < 1 and charges.aimedShot.recharge() > gcdMax then
                    if cast.trueshot() then return end
                end

                --DoubleTap
                if isChecked("Double tap") and
                cast.able.rapidFire() or cd.rapidFire.remain() < gcdMax then
                   if cast.doubleTap() then return end
                end
            end
        end

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
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop==true then
        profileStop = false
    elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 then
        return true
    else
-----------------------------
--- In Combat - Rotations ---
-----------------------------
        if not inCombat and not (IsFlying() or IsMounted()) then
            if isValidUnit("target") and getDistance("target") < 45 then
                -- Start Attack
                StartAttack()
            end
        end
        if inCombat and profileStop==false and isValidUnit(units.dyn45) then
    ---------------------------
    --- Action Lists ---
    ---------------------------
            if getOptionValue("APL Mode") == 1 then
                -- Cooldowns
                if actionList_Cooldowns() then return end
                -- Action List - Single
                if #enemies.yards8t < 3 or mode.rotation == 3 then
                    if actionList_Single() then return end
                end
                -- Action List - AOE
                if #enemies.yards8t > 2 or mode.rotation ~= 2 then
                    if actionList_AOE() then return end
                end        
            end
        end
    end --End In Combat
end --End Rotation Logic  
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
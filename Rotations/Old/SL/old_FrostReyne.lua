local rotationName = "ReyneFrostAboEdit"

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "This is the only mode for this rotation.", highlight = 0, icon = br.player.spell.whirlwind }
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.berserk },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.berserk },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.berserk }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "No Defensives", tip = "This rotation does not use defensives.", highlight = 1, icon = br.player.spell.enragedRegeneration }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "No Interrupts", tip = "This rotation does not use interrupts.", highlight = 1, icon = br.player.spell.pummel }
    };
    CreateButton("Interrupt",4,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Trinkets
            br.ui:createCheckbox(section,"Icy Veins")
		-- Trinkets
            br.ui:createCheckbox(section,"Trinket 1", "Use Trinket 1 on Cooldown.")
            br.ui:createCheckbox(section,"Trinket 2", "Use Trinket 2 on Cooldown.")
        -- Mirror Image
            br.ui:createCheckbox(section,"Mirror Image")
        br.ui:checkSectionState(section)
    -- Frozen Orb I guess
        frozenOrbSection = br.ui:createSection(br.ui.window.profile, "Frozen Orb")
            -- Should we use frozen orb?
            br.ui:createCheckbox(frozenOrbSection, "Use Frozen Orb")
        br.ui:checkSectionState(frozenOrbSection)
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
    if br.timer:useTimer("debugFrost", 0.1) then
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
        local addsExist                                     = false
        local addsIn                                        = 999
        local activePet                                     = br.player.pet
        local activePetId                                   = br.player.petId
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local castable                                      = br.player.cast.debug
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local friendly                                      = friendly or GetUnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = GetObjectExists("mouseover")
        local hasPet                                        = IsPetActive()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.ui.mode
        local moveIn                                        = 999
        local moving                                        = isMoving("player")
        local perk                                          = br.player.perk
        local petInfo                                       = br.player.petInfo
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount, br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units
        local dt                                            = date("%H:%M:%S")
        local debug                                         = false

        units.get(40)
        enemies.get(8, "target")
        enemies.get(12)
        enemies.get(30)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

--------------------
--- Action Lists ---
--------------------

-- Action List - Movement     
    local function actionList_move()
        if moving then
            cast.iceLance()
        end
        if not buff.iceFloes.exists() and moving then
            cast.iceFloes()
        return end
        -- Flurry on Brain Freeze Proc
        if buff.brainFreeze.exists() and not buff.fingersOfFrost.exists() then
            if cast.flurry() then return end
        end
        -- Ice Lance after Flurry Cast w/o Glacial Spike
        if not buff.fingersOfFrost.exists() and cast.last.flurry() and cast.able.iceLance() and not talent.glacialSpike then
            if cast.iceLance() then return end
        end
        -- Ice Barrier
        if moving and not buff.fingersOfFrost.exists() and not buff.iceBarrier.exists() then
            cast.iceBarrier()
        end
        -- Ice Lance
        if not cast.last.flurry() and cast.able.iceLance() then
            if cast.iceLance() then return end
        end
    end

-- Action List - Area of Effect
    local function actionList_AOE()
        -- Ice Lance after Flurry Cast
        if not buff.fingersOfFrost.exists() and cast.last.flurry() and cast.able.iceLance() then
            if cast.iceLance() then return end
        end
        -- Cast Mirror Image if CDs are enabled
        if cast.able.mirrorImage() and useCDs() and isChecked("Mirror Image") then
            if cast.mirrorImage() then return end
        end
        -- Cast Icy Veins if CDs are enabled
        if cast.able.icyVeins() and useCDs() and isChecked("Icy Veins") then
            if cast.icyVeins() then return end
        end
        -- Cast Frozen Orb on Cooldown
        if isChecked("Use Frozen Orb") then
            if cast.frozenOrb() then return end
        end
        -- Blizzard with 3 targets
        if cast.able.blizzard("best",nil,3,8) then
            if cast.blizzard("best",nil,3,8) then return end
        end
        -- Comet Storm
        if cast.able.cometStorm() then
            if cast.cometStorm() then return end
        end
        -- Flurry on Brain Freeze Proc
        if buff.brainFreeze.exists() and not buff.fingersOfFrost.exists() and buff.icicles.stack() < 3 then
            if cast.flurry() then return end
        end
        -- Ice lance with Fingers of Frost
        if buff.fingersOfFrost.exists() then
            if cast.iceLance() then return end
        end
        -- Cast Ebonbolt with 5 icicles and no Brain Freeze
        if cast.able.ebonbolt() and buff.icicles.stack() == 5 and not buff.brainFreeze.exists() then
           if cast.ebonbolt() then return end
        end
        -- Glacial Spike
        if cast.able.glacialSpike() and buff.brainFreeze.exists() then
            if cast.glacialSpike() then return end
        end
        -- Filler Frostbolt Cast
        if cast.frostbolt() then return end
    end

-- Action List - Glacial Spike
    local function actionList_gs()
        -- Ice Lance after Flurry Cast
        if not buff.fingersOfFrost.exists() and cast.last.flurry() and cast.able.iceLance() then
            if cast.iceLance() then return end
        end
        if moving then
            if actionList_move() then return end
        end
        -- Cast Mirror Image if CDs are enabled
        if cast.able.mirrorImage() and useCDs() and isChecked("Mirror Image") then
            if cast.mirrorImage() then return end
        end
        -- Cast Icy Veins if CDs are enabled
        if cast.able.icyVeins() and useCDs() and isChecked("Icy Veins") then
            if cast.icyVeins() then return end
        end
        -- Flurry on Brain Freeze Proc
        if buff.brainFreeze.exists() and not buff.fingersOfFrost.exists() and buff.icicles.stack() < 3 then
            if cast.flurry() then return end
        end
		-- Shatter
		if cast.last.glacialSpike() and buff.brainFreeze.exists() then 
		    if cast.flurry() then return end
		end	
        -- Frozen Orb
         if isChecked("Use Frozen Orb") then
            if cast.frozenOrb() then return end
        end
        -- Blizzard with 3 targets
        if cast.able.blizzard("best",nil,3,8) then
            if cast.blizzard("best",nil,3,8) then return end
        end
        -- Blizzard with 2 targets and Freezing Rain
        if cast.able.blizzard("best",nil,2,8) and buff.freezingRain.exists() then
            if cast.blizzard("best",nil,2,8) then return end
        end
        -- Ice lance with Fingers of Frost
        if buff.fingersOfFrost.exists() and not cast.last.glacialSpike() then
            if cast.iceLance() then return end
        end
        -- Comet Storm
        if cast.able.cometStorm() then
            if cast.cometStorm() then return end
        end
        -- Cast Ebonbolt with 5 icicles and no Brain Freeze
        if cast.able.ebonbolt() and buff.icicles.stack() == 5 and not buff.brainFreeze.exists() then
            if cast.ebonbolt() then return end
        end
        -- Glacial Spike
        if cast.able.glacialSpike() and buff.brainFreeze.exists() then
            if cast.glacialSpike() then return end
        end
        -- Blizzard with 1 Target and Freezing Rain
        if cast.able.blizzard("best",nil,1,8) and buff.freezingRain.exists() then
            if cast.blizzard("best",nil,1,8) then return end
        end
        -- Filler Frostbolt Cast
        if cast.frostbolt() then return end
    end

-- Action List - Thermal Void
    local function actionList_tv()
        -- Ice Lance after Flurry Cast
        if not buff.fingersOfFrost.exists() and cast.last.flurry() and cast.able.iceLance() then
            if cast.iceLance() then return end
        end
        if moving then
            if actionList_move() then return end
        end
        -- Cast Mirror Image if CDs are enabled
        if cast.able.mirrorImage() and useCDs() and isChecked("Mirror Image") then
            if cast.mirrorImage() then return end
        end
        -- Cast Icy Veins if CDs are enabled
        if cast.able.icyVeins() and useCDs() and isChecked("Icy Veins") then
            if cast.icyVeins() then return end
        end
        -- Flurry on Brain Freeze Proc
        if buff.brainFreeze.exists() and not buff.fingersOfFrost.exists() then
            if cast.flurry() then return end
        end
        -- Cast Frozen Orb on Cooldown
         if isChecked("Use Frozen Orb") then
            if cast.frozenOrb() then return end
        end
        -- Blizzard with 3 targets
        if cast.able.blizzard("best",nil,3,8) then
            if cast.blizzard("best",nil,3,8) then return end
        end
        -- Blizzard with 2 targets and Freezing Rain
        if #enemies.yards8t == 2 and buff.freezingRain.exists() then
            cast.blizzard("target")
            local X,Y,Z = ObjectPosition("target")
            ClickPosition(X,Y,Z)
        end
        -- Ice lance with Fingers of Frost
        if buff.fingersOfFrost.exists() then
            if cast.iceLance() then return end
        end
        -- Filler Frostbolt Cast
        if cast.frostbolt() then return end
    end

-----------------
--- Rotations ---
-----------------
        -- Pause
        if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or mode.rotation == 4 then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then

            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
        if inCombat then
            -- Use Movement rotation if moving
            if moving then
                if actionList_move() then return end
            end
            -- Use AoE rotation if 5 or more mobs
            if #enemies.yards8t >= 5 then
                if actionList_AOE() then return end
            end
			--trinket
			if isChecked("Trinket 1") and canUseItem(13) then
                        useItem(13)
                        return true
            end
            if isChecked("Trinket 2") and canUseItem(14) then
                        useItem(14)
                        return true
            end
            -- Glacial Spike Rotation
            if talent.glacialSpike then
                if actionList_gs() then return end
            end
             -- Thermal Void Rotation
            if talent.thermalVoid then
                if actionList_tv() then return end
            end
            -- Ray of Frost
            if talent.rayOfFrost then
                Print("Ray of Frost is not supported with this profile.")
                Print("Please use a real talent.")
            end
            end -- End In Combat Rotation

        end -- Pause
    end -- End Timer
end -- End runRotation 
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

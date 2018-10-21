local rotationName = "ReyneBalance"

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
    -- Celestial Alignment
        br.ui:createCheckbox(section,"Celestial Alignment")
    -- Warrior of Elune
        br.ui:createCheckbox(section,"Warrior of Elune")
    -- Fury of Elune
        br.ui:createCheckbox(section,"Fury of Elune")
    -- Force of Nature
        br.ui:createCheckbox(section,"Force of Nature")   
    -- Incarnation
        br.ui:createCheckbox(section,"Incarnation")   
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
    if br.timer:useTimer("debugBalance", 0.1) then
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
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
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
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk
        local petInfo                                       = br.player.petInfo
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount, br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units
        local dt                                            = date("%H:%M:%S")
        local trait                                         = br.player.traits
        
        -- Balance Locals
        local astralPower                                   = br.player.power.astralPower.amount()
        local astralPowerDeficit                            = br.player.power.astralPower.deficit()
        local travel                                        = br.player.buff.travelForm.exists()
        local flight                                        = br.player.buff.flightForm.exists()
        local chicken                                       = br.player.buff.balanceForm.exists()
        local cat                                           = br.player.buff.catForm.exists()
        local bear                                          = br.player.buff.bearForm.exists()
        local noform                                        = GetShapeshiftForm()==0
        local hasteAmount                                   = 1/(1+(GetHaste()/100))
        local latency                                       = getLatency()

        units.get(40)
        enemies.get(15, "target")
        enemies.get(8, "target")
        enemies.get(40)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

--------------------
--- Action Lists ---
--------------------

-- Action List - Single/Two Target
local function actionList_main()

    -- Make sure we're in moonkin form if we're not in another form
    if noform then
        if cast.balanceForm() then return end
    end

    -- Apply Moonfire and Sunfire to all targets that will live longer than six seconds
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        if debuff.moonfire.remain(thisUnit) < 3 and ttd(thisUnit) > 3 then
            if cast.moonfire(thisUnit,"aoe") then return true end
        elseif isValidUnit(thisUnit) and ttd(thisUnit) > 3 and debuff.sunfire.remain(thisUnit) < 3 then
            if cast.sunfire(thisUnit,"aoe") then return true end
        elseif isValidUnit(thisUnit) and ttd(thisUnit) > 3 and debuff.stellarFlare.remain(thisUnit) < 3 then
            if cast.stellarFlare(thisUnit,"aoe") then return true end
        end
    end

    -- Cooldowns
        -- Cast Force of Nature
        if cast.able.forceOfNature() and useCDs() and isChecked("Force of Nature") and astralPowerDeficit > 20 then
            if cast.forceOfNature("best") then return end
        end

        -- Cast Fury of Elune
        if cast.able.furyOfElune() and useCDs() and isChecked("Fury of Elune") then
            if cast.furyOfElune() then return end
        end

        -- Cast Incarnation
        if cast.able.incarnationChoseOfElune() and useCDs() and isChecked("Incarnation") and astralPower >= 40 then
            if cast.incarnationChoseOfElune() then return end
        end

        -- Cast Celestial Alignment
        if cast.able.celestialAlignment() and useCDs() and isChecked("Celestial Alignment") and astralPower >= 40 then
            if cast.celestialAlignment() then return end
        end

    -- trait.brainStorm.active()



    -- Cast Starfall with Lunar Shrapnel
    if cast.able.starfall("best", nil, 2, 15) and talent.soulOfTheForest and talent.stellarDrift and trait.lunarShrapnel.active() then
        if cast.starfall() then return end
    end

    -- Cast Starfall
    if cast.able.starfall("best", nil, 3, 15) then
        if cast.starfall() then return end
    end

    -- Cast Starsurge
    if cast.able.starsurge() and (buff.lunarEmpowerment.stack() < 3 and buff.solarEmpowerment.stack() < 3) and not cast.able.starfall("best", nil, 3, 15) then
        if cast.starsurge() then return end
    end

     -- Apply Moonfire and Sunfire to all targets that can be refreshed
     for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        if isValidUnit(thisUnit) and ttd(thisUnit) > 5.4 and debuff.sunfire.remain(thisUnit) < 5.4 then
            if cast.sunfire(thisUnit,"aoe") then return true end
        elseif isValidUnit(thisUnit) and ttd(thisUnit) > 7.2 and debuff.stellarFlare.remain(thisUnit) < 7.2 then
            if cast.stellarFlare(thisUnit,"aoe") then return true end
        elseif debuff.moonfire.remain(thisUnit) < 6.6 and ttd(thisUnit) > 6.6 then
            if cast.moonfire(thisUnit,"aoe") then return true end
        end
    end

    -- Cast New Moon
    if cast.able.newMoon() and astralPowerDeficit > (10 * (1+ buff.newMoonController.stack())) then
        if cast.newMoon() then return end
    end

    -- Cast Solar Wrath with Empowerment
    if cast.able.solarWrath() and buff.solarEmpowerment.stack() == 3 then
        if cast.solarWrath() then return end
    end

    -- Cast Lunar Strike with Empowerment
    if cast.able.lunarStrike() and buff.lunarEmpowerment.exists() then
        if cast.lunarStrike() then return end
    end

    -- Cast Lunar Strike with Warrior of Elune
    if cast.able.lunarStrike() and buff.warriorOfElune.exists() then
        if cast.lunarStrike() then return end
    end    

    -- Cast Solar Wrath with Empowerment
    if cast.able.solarWrath() and buff.solarEmpowerment.exists() then
        if cast.solarWrath() then return end
    end

    -- Cast Lunar Strike without empowerment, with cleave
    if cast.able.lunarStrike() and #enemies.yards8t >= 3 then
        if cast.lunarStrike() then return end
    end

    -- Cast Solar Wrath without empowerment, without cleave
    if cast.able.solarWrath() then
        if cast.solarWrath() then return end
    end

    if cast.able.moonfire() and moving then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if cast.moonfire(thisUnit,"aoe") then return true end
        end
    end

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
            if actionList_main() then return end
            end -- End In Combat Rotation

        end -- Pause
    end -- End Timer
end -- End runRotation 


local id = 102
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
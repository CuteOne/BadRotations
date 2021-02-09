local rotationName = "ReyneArcane"

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
            br.ui:createCheckbox(section,"Presence of Mind")
        -- Mirror Image
            br.ui:createCheckbox(section,"Mirror Image")
        -- Arcane Power
            br.ui:createCheckbox(section,"Arcane Power")
        -- Charged Up
            br.ui:createCheckbox(section,"Charged Up")
        -- Charged Up
            br.ui:createCheckbox(section,"Rune of Power")
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
    if br.timer:useTimer("debugArcane", 0.1) then
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
        local arcaneCharges                                 = br.player.power.arcaneCharges.amount()
        local arcaneChargesMax                              = br.player.power.arcaneCharges.max()
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.ui.mode
        local perk                                          = br.player.perk        
        local php                                           = br.player.health
        local power                                         = br.player.power.mana.amount()
        local powerPercent                                  = br.player.power.mana.percent()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttm                                           = br.player.timeToMax
        local units                                         = br.player.units
        local trait                                         = br.player.traits
        
        units.get(40)
        enemies.get(15, "target")
        enemies.get(8, "target")
        enemies.get(10)
        enemies.get(40)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

--------------------
--- Action Lists ---
--------------------

local function actionList_main()

    -- Mirror image when Arcane Power is not active, on CD
    if not buff.arcanePower.exists() and useCDs() and isChecked("Mirror Image") then
        if cast.mirrorImage() then return end
    end

    -- Use Evocation to get a full stack of Brain Storm before using Arcane Power.
    if cast.able.evocation() and cd.arcanePower.remain() < getCastTime(spell.evocation) and arcaneCharges == 4 and trait.brainStorm.active then
        if cast.evocation() then return end
    end

    -- Cast Rune of power just before Arcane Power, or if you are at 2 charges.
    if cast.able.runeOfPower() and isChecked("Rune of Power") and (cd.arcanePower.remain() < getCastTime(spell.runeOfPower) and arcaneCharges == 4) or (charges.runeOfPower.count() == 2 and cd.arcanePower.remain() > 12) then
        if cast.runeOfPower() then return end
    end

    -- Use Arcane Power at 4 Arcane Charges
    if cast.able.arcanePower() and isChecked("Arcane Power") and arcaneCharges == 4 then
        if cast.arcanePower() then return end
    end

    -- If you are at max Arcane Charges with RoT proc, use Arcane Blast instead of Missiles.
    if cast.able.arcaneBlast() and buff.ruleOfThrees.exists() and arcaneCharges == 4 then
        if cast.arcaneBlast() then return end
    end

    -- Use Arcane Missiles when you have RoT up and Arcane Power is down. Not with Galvanizing Spark
    if cast.able.arcaneMissiles() and buff.ruleOfThrees.exists() and not buff.arcanePower.exists() and not cast.able.arcaneExplosion("player","aoe", 3, 10) and not trait.galvanizingSpark.active then
        if cast.arcaneMissiles() then return end
    end

    -- Use Arcane Missiles with clearcasting if Arcane Power is down. (Req. NOT Amplification)
    if cast.able.arcaneMissiles() and buff.clearcasting.exists() and not buff.arcanePower.exists() and not cast.able.arcaneExplosion("player","aoe", 3, 10) and not talent.amplification then
        if cast.arcaneMissiles() then return end
    end

    -- Use Arcane Missiles with Clearcasting & Amplification talented
    if cast.able.arcaneMissiles() and buff.clearcasting.exists() and not cast.able.arcaneExplosion("player","aoe", 3, 10) and talent.amplification then
        if cast.arcaneMissiles() then return end
    end    

    -- Use Charged Up when you can get 3 charges from it
    if cast.able.chargedUp() and isChecked("Charged Up") and arcaneCharges <= 1 then
        if cast.chargedUp() then return end
    end

    -- Nether Tempest when it is in 30% refresh
    if cast.able.netherTempest() and (not debuff.netherTempest.exists(units.get(40)) and arcaneCharges == 4) or (debuff.netherTempest.refresh(units.get(40)) and not buff.runeOfPower.exists() and not buff.arcanePower.exists()) then
        if cast.netherTempest() then return end
    end

    -- Use Arcane Orb when you need 2 Arcane Charges
    if cast.able.arcaneOrb() and arcaneCharges < 3 then
        if cast.arcaneOrb() then return end
    end

    -- Use Arcane Explosion on 3+ targets. Also other stuff
    if cast.able.arcaneExplosion("player","aoe", 3, 10) and (buff.arcanePower.exists() or cast.able.evocation() or (powerPercent > 85)) and not trait.brainStorm.active then
        if cast.arcaneExplosion("player","aoe", 3, 10) then return end
    end
    
    -- Use Arcane Explosion of 3+ targets. Burn mana with Rune of Power up
    if cast.able.arcaneExplosion("player","aoe", 3, 10) and buff.runeOfPower.exists() and not trait.brainStorm.active then
        if cast.arcaneExplosion("player","aoe", 3, 10) then return end
    end

    -- Use Arcane Explosion if 3+ targets with Brain Storm
    if cast.able.arcaneExplosion("player","aoe", 3, 10) and trait.brainStorm.active then
        if cast.arcaneExplosion("player","aoe", 3, 10) then return end
    end

    -- Use PoM near end of Arcane Power or Rune of Power
    if cast.able.presenceOfMind() and useCDs() and isChecked("Presence of Mind") and (buff.arcanePower.exists() and buff.arcanePower.remain() < getCastTime(spell.arcaneBlast) * 2) or (buff.runeOfPower.exists() and buff.runeOfPower.remain() < getCastTime(spell.arcaneBlast) * 2) then
        if cast.presenceOfMind() then return end
    end

    -- If you have Rules of Threes up, use Arcane Blast
    if cast.able.arcaneBlast() and not trait.brainStorm.active and trait.galvanizingSpark.active and not cast.able.arcaneExplosion("player","aoe", 3, 10) then
        if cast.arcaneBlast() then return end
    end

    -- Spend mana at will with Arcane Power, or when Evocation is ready to use. Dump mana above 85%
    if cast.able.arcaneBlast() and not trait.brainStorm.active and #enemies.yards10 < 3 and (buff.arcanePower.exists() or cast.able.evocation() or (powerPercent > 85)) then
        if cast.arcaneBlast() then return end
    end

    -- Burn mana with Rune of Power up
    if cast.able.arcaneBlast() and buff.runeOfPower.exists() and #enemies.yards10 < 3 then
        if cast.arcaneBlast() then return end
    end

    -- Arcane Blast with Brain Storm
    if cast.able.arcaneBlast() and #enemies.yards10 < 3 and trait.brainStorm.active then
        if cast.arcaneBlast() then return end
    end

    -- Evocate when you don't have enough mana to cast Arcane Blast. Cancel at 85%
    if cast.able.evocation() and not trait.brainStorm.active then
        if cast.evocation() then return end -- Somehow cancel at 85% max mana
    end

    -- If you used Arcane Power at low mana and run out of mana for arcane blast before arcane power fades use Arcane Missiles if possible.
    if cast.able.arcaneMissiles() and buff.clearcasting.exists() or buff.ruleOfThrees.exists() and buff.arcanePower.exists() then
        if cast.arcaneMissiles() then return end
    end

    -- If you don't have Arcane Power, Rune of Power, or Evocation ready to use, dump your Arcane Charges with Arcane Barrage when you get to 4 charges.
    if cast.able.arcaneBarrage() and arcaneCharges == 4 then
        if cast.arcaneBarrage() then return end
    end

    -- Explosion without brain storm
    if cast.able.arcaneExplosion("player","aoe", 3, 10) then
        if cast.arcaneExplosion() then return end
    end

    -- Arcane Blast without Brain Storm
    if cast.able.arcaneBlast() and #enemies.yards10 < 3 then 
        if cast.arcaneBlast() then return end
    end

    -- Supernova with talent (please god never take this)
    if cast.able.supernova() then
        if cast.supernova() then return end
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
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
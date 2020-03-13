local rotationName = "Lemon" -- Change to name of profile listed in options drop down

local colorPurple   = "|cffC942FD"
local colorBlue     = "|cff00CCFF"
local colorGreen    = "|cff00FF00"
local colorRed      = "|cffFF0000"
local colorWhite    = "|cffFFFFFF"
local colorGold     = "|cffFFDD11"
local colorLegendary= "|cffff8000"
local colorBlueMage = "|cff68ccef"
---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.deathAndDecay },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.deathAndDecay },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.furiousSlash },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.enragedRegeneration}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.summonGargoyle },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.darkArbiter },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.battleCry }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.corpseShield },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.enragedRegeneration }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel }
    };
    CreateButton("Interrupt",4,0)
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
        br.ui:createDropdownWithout(section, "Artifact", {colorWhite.."Everything",colorWhite.."Cooldowns",colorWhite.."Never"}, 1, colorWhite.."When to use Artifact Ability.")
        br.ui:checkSectionState(section)
         ------------------------
        --- ITEM OPTIONS --- -- Define Item Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Items")
        br.ui:createCheckbox(section, "Potion")
        br.ui:createCheckbox(section,"Flask / Crystal")
        br.ui:createDropdownWithout(section, "Trinket 1 Condition", {colorWhite.."On Cooldown",colorWhite.."On Boss Health",colorWhite.."On Self Health"}, 1, colorWhite.."On Cooldown = Use Trinket whenever available, value doesn't matter; On Boss Health = Use Trinket when boss health is below value; On Self Health = Use Trinket when your health is below value;")
        br.ui:createSpinner(section, "Trinket 1",  80,  0,  100,  5,  colorRed.."When to use Trinket 1")
        br.ui:createDropdownWithout(section, "Trinket 2 Condition", {colorWhite.."On Cooldown",colorWhite.."On Boss Health",colorWhite.."On Self Health"}, 1, colorWhite.."On Cooldown = Use Trinket whenever available, value doesn't matter; On Boss Health = Use Trinket when boss health is below value; On Self Health = Use Trinket when your health is below value;")
        br.ui:createSpinner(section, "Trinket 2",  60,  0,  100,  5,  colorRed.."When to use Trinket 2")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
        br.ui:createCheckbox(section, "Use Racial")
        br.ui:createCheckbox(section, "Gargoyle / Dark Arbiter")
        br.ui:createCheckbox(section, colorGreen.."Dark Transformation")
        br.ui:checkSectionState(section)
        ------------------------
        --- Pet OPTIONS --- -- 
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Pet")
        -- Auto Summon
            br.ui:createCheckbox(section,"Auto Summon")
        --Auto Attack
            br.ui:createCheckbox(section,"Pet Attack")
         br.ui:checkSectionState(section)    
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  61,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
             -- Anti-Magic Shell
            br.ui:createSpinner(section, "Anti-Magic Shell",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
             -- Death Strike
            br.ui:createSpinner(section, "Death Strike",  70,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Icebound Fortitude
            br.ui:createSpinner(section, "Icebound Fortitude",  35,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Corpse Shield
            br.ui:createSpinner(section, "Corpse Shield",  59,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Raise Ally
            br.ui:createCheckbox(section,"Raise Ally")
            br.ui:createDropdownWithout(section, "Raise Ally - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")

        br.ui:checkSectionState(section)
         -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Leap
            br.ui:createCheckbox(section,"Leap")
            -- Mind Freeze
            br.ui:createCheckbox(section,"Mind Freeze")
            -- Asphyxiate Kick
            br.ui:createCheckbox(section,"Asphyxiate Kick")
            -- DeathGrip
            br.ui:createCheckbox(section,"Death Grip")
            -- Interrupt Percentage
            br.ui:createSpinner(section,"InterruptAt",  17,  0,  85,  5,  "|cffFFBB00Cast Percentage to use at (+-5%).")    

        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
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
    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Defensive",0.25)
    UpdateToggle("Interrupt",0.25)
--------------
--- Locals ---
--------------
    local lastSpell                                     = lastCast
    local bop                                           = UnitBuff("target","Blessing of Protection") ~= nil
    local cloak                                         = UnitBuff("target","Cloak of Shadows") ~= nil or UnitBuff("target","Anti-Magic Shell") ~= nil
    local immunDS                                       = UnitBuff("target","Divine Shield") ~= nil 
    local immunIB                                       = UnitBuff("target","Ice Block") ~= nil
    local immunAotT                                     = UnitBuff("target","Aspect of the Turtle") ~= nil
    local immunCyclone                                  = UnitBuff("target","Cyclone") ~= nil
    local immun                                         = immun or immunIB or immunAotT or immunDS or immunCyclone
    local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
    local attacktar                                     = UnitCanAttack("target", "player")
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
    local mode                                          = br.player.mode
    local perk                                          = br.player.perk        
    local php                                           = br.player.health
    local power, powmax, powgen                         = br.player.power, br.player.powerMax, br.player.powerRegen
    local runicPower                                    = br.player.power.runicPower.amount()
    local rune                                          = br.player.power.runes.frac()
    local pullTimer                                     = br.DBM:getPulltimer()
    local race                                          = br.player.race
    local runicPowerDeficit                             = br.player.power.runicPower.deficit()
    local racial                                        = br.player.getRacial()
    local spell                                         = br.player.spell
    local talent                                        = br.player.talent
    local ttm                                           = br.player.timeToMax
    local units                                         = br.player.units
    local ttd                                           = getTTD

    units.get(5)
    units.get(8)
    units.get(30)
    enemies.get(5)
    enemies.get(8)
    enemies.get(10)
    enemies.get(10,"target")
    enemies.get(15)
    enemies.get(30)
    enemies.get(40)
    
    if lastSpell == nil or not inCombat then lastSpell = 0 end
    if profileStop == nil then profileStop = false end
    if waitForPetToAppear == nil then waitForPetToAppear = 0 end
    
    if waitfornextVirPlague == nil or objIDLastVirPlagueTarget == nil then
        waitfornextVirPlague = GetTime() - 10
        objIDLastVirPlagueTarget = 0
    end
    
    if not inCombat and not IsMounted() and isChecked("Auto Summon") and not GetUnitExists("pet") and (UnitIsDead("pet") ~= nil or UnitIsDead("pet") == false) then
        if waitForPetToAppear ~= nil and waitForPetToAppear < GetTime() - 2 and onlyOneTry ~= nil and not onlyOneTry then
            onlyOneTry = true
            if cast.raiseDead() then return end
        end

        if waitForPetToAppear == nil then
            waitForPetToAppear = GetTime()
        end
    else
        onlyOneTry = false
    end
    
    local function GetObjExists(objectID)
        for i = 1,GetObjectCountBR() do
            local thisUnit = GetObjectWithIndex(i)
            if GetObjectExists(thisUnit) and GetObjectID(thisUnit) == objectID then
                return true
            end
        end
        return false
    end
-----------------
--- Rotations ---
-----------------
    -- Pause
    local function actionList_Defensive()
        if useDefensive() and not IsMounted() and inCombat then
        --- AMS Counter
            if isChecked("AMS Counter") 
                and UnitDebuff("player","Soul Reaper") ~= nil
            then                    
                if cast.antiMagicShell() then print("AMS Counter - Soul Reaper") return end
            end
        --Healthstone
            if isChecked("Healthstone") 
                and php <= getOptionValue("Healthstone")     
                and hasItem(5512)
            then
                if canUseItem(5512) then
                    useItem(5512)
                end
            end
        -- Death Strike
            if isChecked("Death Strike")  
                and (buff.darkSuccor.exists() and (php < getOptionValue("Death Strike") or buff.darkSuccor.remain() < 2))
                or  runicPower >= 45  
                and php < getOptionValue("Death Strike") 
                and (not talent.darkArbiter or (cd.darkArbiter.remain() <= 3 and not (useCDs() or playertar)))
            then
                 -- Death strike everything in reach
                if getDistance("target") > 5 or immun or bop then
                    for i=1, #getEnemies("player",20) do
                        thisUnit = getEnemies("player",20)[i]
                        distance = getDistance(thisUnit)
                        if distance < 5 and getFacing("player",thisUnit) then
                            if cast.deathStrike(thisUnit) then print("Random Hit Deathstrike") return true end
                        end
                    end
                else
                    if cast.deathStrike() then return true end
                    
                end
            end
        -- Icebound Fortitude
            if isChecked("Icebound Fortitude") 
                and php < getOptionValue("Icebound Fortitude") 
            then
                if cast.iceboundFortitude() then return true end
            end
        -- Corpse Shield
            if isChecked("Corpse Shield") 
                and php < getOptionValue("Corpse Shield") 
            then
                if cast.corpseShield() then return true end
            end
        -- Anti-Magic Shell
            if isChecked("Anti-Magic Shell") and php <= getOptionValue("Anti-Magic Shell") then
                if cast.antiMagicShell() then return true end
            end
        -- Raise Ally
            if isChecked("Raise Ally") then
                if getOptionValue("Raise Ally - Target")==1
                    and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                then
                    if cast.raiseAlly("target","dead") then return true end
                end
                if getOptionValue("Raise Ally - Target")==2
                    and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                then
                    if cast.raiseAlly("mouseover","dead") then return true end
                end
            end
        end
        return false
    end
    
    
    
    local function actionList_AOE()
        if #enemies.yards10 >= 2 and not isMoving("player") then
            if cast.deathAndDecay("player") then return true end
        end
        --actions.aoe+=/epidemic,if=spell_targets.epidemic>4
        if #enemies.yards30 > 4 then
            if cast.epidemic() then return true end
        end
        --actions.aoe+=/scourge_strike,if=spell_targets.scourge_strike>=2&(dot.death_and_decay.ticking|dot.defile.ticking)
        if #enemies.yards5 >= 2 and cd.deathAndDecay.remain() > 20 then
            if cast.scourgeStrike() then return true end
        end
        --actions.aoe+=/clawing_shadows,if=spell_targets.clawing_shadows>=2&(dot.death_and_decay.ticking|dot.defile.ticking)
        if #enemies.yards5 >= 2 and cd.deathAndDecay.remain() > 20 and talent.clawingShadows then
            if cast.clawingShadows() then return true end
        end
        --actions.aoe+=/epidemic,if=spell_targets.epidemic>2
        if #enemies.yards30 > 2 then
            if cast.epidemic() then return true end
        end
        return false
        
    end
    
    local function actionList_Valkyr()
        --actions.valkyr=death_coil
        if cd.deathCoil.remain() == 0 then
            if cast.deathCoil() then return true end
        end
        
        --actions.valkyr+=/apocalypse,if=debuff.festering_wound.stack>=6
        if cd.apocalypse.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]      
                if debuff.festeringWound.stack(thisUnit) >= 6 then
                    if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) then
                        if cast.apocalypse(thisUnit) then return true end
                    end
                end
            end
        end
        
        --actions.valkyr+=/festering_strike,if=debuff.festering_wound.stack<6&cooldown.apocalypse.remains<3
        if cd.festeringStrike.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]      
                if debuff.festeringWound.stack(thisUnit) < 6 and cd.apocalypse.remain() < 3 then
                    if cast.festeringStrike(thisUnit) then return true end
                end
            end
        end
        
        --actions.valkyr+=/call_action_list,name=aoe,if=active_enemies>=2
        if #enemies.yards10 >= 2 then
            if actionList_AOE() then return true end
        end
        
        --actions.valkyr+=/festering_strike,if=debuff.festering_wound.stack<=4
        if cd.festeringStrike.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]      
                if debuff.festeringWound.stack(thisUnit) <= 4 then
                    if cast.festeringStrike(thisUnit) then return true end
                end
            end
        end
        
        --actions.valkyr+=/scourge_strike,if=debuff.festering_wound.up
        if cd.scourgeStrike.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if debuff.festeringWound.exists(thisUnit) then
                    if cast.scourgeStrike(thisUnit) then return true end
                end
            end
        end
        
        --actions.valkyr+=/clawing_shadows,if=debuff.festering_wound.up
        if cd.clawingShadows.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if debuff.festeringWound.exists(thisUnit) then
                    if cast.clawingShadows(thisUnit) then return true end
                end
            end
        end
        
        return false
    end

    
    local function actionList_Generic()
        --actions.generic=dark_arbiter,if=!equipped.137075&runic_power.deficit<30
        if not hasEquiped(137075) and runicPowerDeficit < 30 and talent.darkArbiter and isChecked("Gargoyle / Dark Arbiter") and useCDs() and cd.darkArbiter.remain() == 0 then
            if cast.darkArbiter() then return true end
        end
        
        if cd.apocalypse.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]      
                if hasEquiped(137075) and debuff.festeringWound.stack(thisUnit) >= 6 and talent.darkArbiter then
                    if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) then
                        if cast.apocalypse(thisUnit) then return true end
                    end
                end
            end
        end
        
        --actions.generic+=/dark_arbiter,if=equipped.137075&runic_power.deficit<30&cooldown.dark_transformation.remains<2
        if hasEquiped(137075) and runicPowerDeficit < 30 and cd.darkTransformation.remain() < 2 and isChecked("Gargoyle / Dark Arbiter") and useCDs() and cd.darkArbiter.remain() == 0 then
            if cast.darkArbiter() then return true end
        end

        --actions.generic+=/summon_gargoyle,if=!equipped.137075,if=rune<=3
        if not talent.darkArbiter and not hasEquiped(137075) and rune<= 3 and isChecked("Gargoyle / Dark Arbiter") and useCDs() then
            if cast.summonGargoyle() then return true end
        end

        --actions.generic+=/chains_of_ice,if=buff.unholy_strength.up&buff.cold_heart.stack>19
        if cd.chainsOfIce.remain() == 0 then
            if buff.unholyStrength.exists() and buff.coldHeart.stack() == 20 then
                if cast.chainsOfIce() then return true end
            end
        end
        
        if cd.chainsOfIce.remain() == 0 then
            if buff.unholyStrength.exists() and buff.unholyStrength.remain() < gcd and buff.coldHeart.stack() > 16 then
                if cast.chainsOfIce() then return true end
            end
        end
        
        if cd.chainsOfIce.remain() == 0 then
            if buff.coldHeart.stack() >= 4 and ttd(units.dyn5) <= gcd then
                if cast.chainsOfIce() then return end
            end
        end
        
        --actions.generic+=/summon_gargoyle,if=equipped.137075&cooldown.dark_transformation.remains<10&rune<=3
        if hasEquiped(137075) and cd.darkTransformation.remain() < 10 and rune <= 3 and isChecked("Gargoyle / Dark Arbiter") and useCDs() then
            if cast.summonGargoyle() then return true end
        end
        
        --actions.generic+=/soul_reaper,if=debuff.festering_wound.stack>=6&cooldown.apocalypse.remains<4
        if cd.soulReaper.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]      
                if debuff.festeringWound.stack(thisUnit) >= 6 and cd.apocalypse.remain() < 4 then
                    if cast.soulReaper(thisUnit) then return true end
                end
            end
        end
        --actions.generic+=/apocalypse,if=debuff.festering_wound.stack>=6
        if cd.apocalypse.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]      
                if debuff.festeringWound.stack(thisUnit) >= 6 then
                    if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) then
                        if cast.apocalypse(thisUnit) then return true end
                    end
                end
            end
        end
        
        --actions.generic+=/death_coil,if=runic_power.deficit<10
        if runicPowerDeficit < 10 then
            if cast.deathCoil() then return true end
        end
        --actions.generic+=/death_coil,if=!talent.dark_arbiter.enabled&buff.sudden_doom.up&!buff.necrosis.up&rune<=3
        if not talent.darkArbiter and buff.suddenDoom.exists() and not buff.necrosis.exists() and rune <= 3 then
            if cast.deathCoil() then return true end
        end

        --actions.generic+=/death_coil,if=talent.dark_arbiter.enabled&buff.sudden_doom.up&cooldown.dark_arbiter.remains>5&rune<=3
        if talent.darkArbiter and buff.suddenDoom.exists() and cd.darkArbiter.remain() > 5 and rune <= 3 then
            if cast.deathCoil() then return true end
        end

        --actions.generic+=/festering_strike,if=debuff.festering_wound.stack<6&cooldown.apocalypse.remains<=6
        if cd.festeringStrike.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]      
                if debuff.festeringWound.stack(thisUnit) < 6 and cd.apocalypse.remain() <= 6 then
                    if cast.festeringStrike(thisUnit) then return true end
                end
            end
        end
        
        --actions.generic+=/soul_reaper,if=debuff.festering_wound.stack>=3
        if cd.soulReaper.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]      
                if debuff.festeringWound.stack(thisUnit) >= 3 then
                    if cast.soulReaper(thisUnit) then return true end
                end
            end
        end
        --actions.generic+=/festering_strike,if=debuff.soul_reaper.up&!debuff.festering_wound.up
        if cd.festeringStrike.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]      
                if debuff.soulReaper.exists(thisUnit) and not debuff.festeringWound.exists(thisUnit) then
                    if cast.festeringStrike(thisUnit) then return true end
                end
            end
        end
        
        --actions.generic+=/scourge_strike,if=debuff.soul_reaper.up&debuff.festering_wound.stack>=1
        if cd.soulReaper.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]      
                if debuff.festeringWound.stack(thisUnit) >= 1 then
                    if cast.soulReaper(thisUnit) then return true end
                end
            end
        end

        --actions.generic+=/clawing_shadows,if=debuff.soul_reaper.up&debuff.festering_wound.stack>=1
        if cd.clawingShadows.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]      
                if debuff.festeringWound.stack(thisUnit) >= 1 and debuff.soulReaper.exists(thisUnit)then
                    if cast.clawingShadows(thisUnit) then return true end
                end
            end
        end
        --actions.generic+=/defile
        if talent.defile then
            if cast.defile("player") then return true end
        end

        --actions.generic+=/call_action_list,name=aoe,if=active_enemies>=2
        if #enemies.yards30 >= 2 and (mode.rotation == 1 or mode.rotation == 2) then
            if actionList_AOE() then return true end
        end

        --actions.generic+=/festering_strike,if=debuff.festering_wound.stack<=2&(debuff.festering_wound.stack<=4|(buff.blighted_rune_weapon.up|talent.castigator.enabled))&runic_power.deficit>5&(runic_power.deficit>23|!talent.castigator.enabled)
        if cd.festeringStrike.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]      
                if debuff.festeringWound.stack(thisUnit) <=2 and (debuff.festeringWound.stack(thisUnit) <= 4 or (buff.blightedRuneWeapon.exists() or talent.castigator)) and runicPowerDeficit >5 and (runicPowerDeficit >23 or not talent.castigator) then
                    if cast.festeringStrike(thisUnit) then return true end
                end
            end
        end

        --actions.generic+=/death_coil,if=!buff.necrosis.up&talent.necrosis.enabled&rune.time_to_4>gcd
        if not buff.necrosis.exists() and talent.necrosis and runeTimeTill(4) > gcd then
            if cast.deathCoil() then return true end
        end
        
        --actions.generic+=/scourge_strike,if=(buff.necrosis.react|buff.unholy_strength.react|rune>=2)&debuff.festering_wound.stack>=1&(debuff.festering_wound.stack>=3|!(talent.castigator.enabled|equipped.132448))&runic_power.deficit>9&(runic_power.deficit>23|!talent.castigator.enabled)
        if cd.scourgeStrike.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if (buff.necrosis.exists() or buff.unholyStrength.exists() or rune>=2) and debuff.festeringWound.stack(thisUnit) >=1 and(debuff.festeringWound.stack(thisUnit) >=3 or not(talent.castigator or hasEquiped(132448))) and runicPowerDeficit > 9 and (runicPowerDeficit >23 or not talent.castigator) then
                    if cast.scourgeStrike(thisUnit) then return true end
                end
            end
        end
        --actions.generic+=/clawing_shadows,if=(buff.necrosis.react|buff.unholy_strength.react|rune>=2)&debuff.festering_wound.stack>=1&(debuff.festering_wound.stack>=3|!equipped.132448)&runic_power.deficit>9
        if cd.clawingShadows.remain() == 0 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]      
                if (buff.necrosis.exists() or buff.unholyStrength.exists() or rune>=2) and debuff.festeringWound.stack(thisUnit) >=1 and(debuff.festeringWound.stack(thisUnit) >=3 or not  hasEquiped(132448)) and runicPowerDeficit > 9 then
                    if cast.clawingShadows(thisUnit) then return true end
                end
            end
        end
        --actions.generic+=/death_coil,if=talent.shadow_infusion.enabled&talent.dark_arbiter.enabled&!buff.dark_transformation.up&cooldown.dark_arbiter.remains>10
        if talent.shadowInfusion and talent.darkArbiter and not buff.darkTransformation.exists() and cd.darkArbiter.remain() > 10 then
            if cast.deathCoil() then return true end
        end
        --actions.generic+=/death_coil,if=talent.shadow_infusion.enabled&!talent.dark_arbiter.enabled&!buff.dark_transformation.up
        if talent.shadowInfusion and not talent.darkArbiter and not buff.darkTransformation.exists() then
            if cast.deathCoil() then return true end
        end
        --actions.generic+=/death_coil,if=talent.dark_arbiter.enabled&cooldown.dark_arbiter.remains>10
        if talent.darkArbiter and cd.darkArbiter.remain() > 10 then
            if cast.deathCoil() then return true end
        end
        --actions.generic+=/death_coil,if=!talent.shadow_infusion.enabled&!talent.dark_arbiter.enabled
        if talent.darkArbiter and cd.darkArbiter.remain() > 10 then
            if cast.deathCoil() then return true end
        end

        return false
    
    end

    
    
    local function actionList_INTERRUPT()
        if useInterrupts() then
            for i = 1, #enemies.yards30 do
                thisUnit = enemies.yards30[i]
                if inCombat 
                    and (UnitIsPlayer(thisUnit) or not playertar)
                    and isValidUnit(thisUnit) 
                    and not isDummy(thisUnit) 
                    and canInterrupt(thisUnit,kickpercent)
                    and not immunDS
                    and not immunAotT
                then
                    if getDistance(thisUnit) > 5
                        and getDistance(thisUnit) < 30
                    then
                        if talent.sludgeBelcher then
                            if canInterrupt(thisUnit,getValue("Interrupt at") + math.random(-5,5)) then
                                if cast.hook(thisUnit) then return true end
                            end
                        elseif buff.darkTransformation.exists("pet")
                        then
                            if canInterrupt(thisUnit,getValue("Interrupt at") + math.random(-5,5)) then
                                if cast.leap(thisUnit) then return true end
                            end
                        end
                    end
                    
                    if isChecked("Mind Freeze") and cd.mindFreeze.remain() == 0 and getDistance(thisUnit) < 15 then
                        if canInterrupt(thisUnit,getValue("Interrupt at") + math.random(-5,5) ) then
                            if cast.mindFreeze(thisUnit) then return true end
                        end
                    end
                    
                    if isChecked("Asphyxiate Kick") and talent.asphyxiate and getDistance(thisUnit) < 20 then
                        if canInterrupt(thisUnit,getValue("Interrupt at") + math.random(-5,5) ) then
                            if cast.asphyxiate(thisUnit) then return true end
                        end
                    end
                    
                    if isChecked("Death Grip") then
                        if canInterrupt(thisUnit,getValue("Interrupt at") + math.random(-5,5)) then
                            if cast.deathGrip(thisUnit) then return true end
                        end
                    end
                end
            end
        end
        return false
    end
    
    local function actionList_PRECOMBAT()
        if not IsMounted() then
            if isChecked("Flask / Crystal") then
                if inRaid and canUseItem(br.player.flask.wod.intellectBig) and not UnitBuffID("player",br.player.flask.wod.intellectBig) then
                    useItem(br.player.flask.wod.intellectBig)
                    return true
                end
                if not UnitBuffID("player",br.player.flask.wod.intellectBig) and canUseItem(118922) then --Draenor Insanity Crystal
                    useItem(118922)
                    return true
                end
            end
            return false
        end
    end
        
    local function actionList_Pet()
        if buff.corpseShield.exists() then
            if talent.sludgeBelcher then
                if cast.protectiveBile() then return end
            else
                if cast.huddle() then return end
            end
        end
        
        if getHP("pet") < 20 
            and GetUnitExists("pet")
            and not buff.corpseShield.exists() 
        then
            print("Pet Dismiss - Low Health")
            PetDismiss()
        end
        
        if isChecked("Auto Summon") and not GetUnitExists("pet") and (UnitIsDead("pet") ~= nil or UnitIsDead("pet") == false) then
            if waitForPetToAppear < GetTime() - 2 then
                if cast.raiseDead() then waitForPetToAppear = GetTime(); return end
            end
        end
        
        if inCombat and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 and isChecked("Pet Attack") then
            if not UnitIsUnit("target","pettarget") then
            if not GetUnitIsUnit("target","pettarget") then
                PetAttack()
            end
        else
            if IsPetAttackActive() then
                PetStopAttack()
            end
        end
        
        return false
    end  

---------------------
--- Begin Profile ---
--------------------- 
    
    if not inCombat and not hastar and profileStop==true then
        profileStop = false
    elseif (inCombat and profileStop==true) or IsMounted() or IsFlying() or pause() or mode.rotation==4 then
        if not pause() and IsPetAttackActive() then
            PetStopAttack()
            PetFollow()
        end
        return true

    else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
        if not inCombat and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
            StopAttack()
            if actionList_PRECOMBAT() then return end
        end
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
        if inCombat then
            if actionList_INTERRUPT() then return end
            --actions+=/mind_freeze
            --actions+=/arcane_torrent,if=runic_power.deficit>20
            
            if isChecked("Use Racial") then
                if getSpellCD(br.player.getRacial()) == 0 and (race == "Orc" or race == "Troll") then
                    if debug == true then Print("Casting Racial") end
                    if br.player.castRacial() then
                        if debug == true then Print("Casted Racial") end
                    end
                end
            end
            --actions+=/blood_fury
            --actions+=/berserking
            --actions+=/use_items
            
            if getOptionValue("Trinket 1 Condition") == 1 then 
                if isChecked("Trinket 1") and inCombat and canUseItem(13) then
                    if useItem(13) then return end
                end
            end


            if getOptionValue("Trinket 1 Condition") == 2 then
                if isChecked("Trinket 1") and inCombat then 
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if isBoss(thisUnit) and getHP(thisUnit) <= getValue("Trinket 1") and canUseItem(13) then
                            if useItem(13) then return end
                        end
                    end
                end
            end

            if getOptionValue("Trinket 1 Condition") == 3 then
                if isChecked("Trinket 1") and inCombat and health <= getValue("Trinket 1") and canUseItem(13) then
                    if useItem(13) then return end
                end
            end
            
            if getOptionValue("Trinket 2 Condition") == 1 then 
                if isChecked("Trinket 2") and inCombat and canUseItem(14) then
                    if useItem(14) then return end
                end
            end

            if getOptionValue("Trinket 1 Condition") == 2 then
                if isChecked("Trinket 1") and inCombat then 
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if isBoss(thisUnit) and getHP(thisUnit) <= getValue("Trinket 1") and canUseItem(14) then
                            if useItem(14) then return end
                        end
                    end
                end
            end

            if getOptionValue("Trinket 2 Condition") == 3 then
                if isChecked("Trinket 2") and inCombat and health <= getValue("Trinket 2") and canUseItem(14) then
                    if useItem(14) then return end
                end
            end
            
            --actions+=/use_item,name=ring_of_collapsing_futures,if=(buff.temptation.stack=0&target.time_to_die>60)|target.time_to_die<60
            if isChecked("Ring of Collapsing Futures") and hasEquiped(142173) and canUseItem(142173) and not debuff.temptation.exists("player") then
                useItem(142173)
            end
            
            --actions+=/potion,if=buff.unholy_strength.react
            if useCDs() and isChecked("Potion") and inRaid then
                if buff.unholyStrength.exists() then
                    if canUseItem(142117) then
                        if useItem(142117) then return end
                    end
                end
            end
            --actions+=/outbreak,target_if=!dot.virulent_plague.ticking
            if GetUnitExists("target") and ((objIDLastVirPlagueTarget ~= ObjectID("target")) or (waitfornextVirPlague < GetTime() - 6)) then
                if (not debuff.virulentPlague.exists("target")
                    or debuff.virulentPlague.remain("target") < 1.5) 
                    and not debuff.soulReaper.exists("target")
                    and not immun
                    and not cloak
                    and UnitIsDeadOrGhost("target") ~= nil
                then
                    if cast.outbreak("target","aoe") then 
                        waitfornextVirPlague = GetTime() 
                        objIDLastVirPlagueTarget = ObjectID("target")
                        return 
                    end
                end
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if not debuff.virulentPlague.exists(thisUnit) 
                        and UnitAffectingCombat(thisUnit) 
                        and not cloak
                        and not immun
                    then
                        if cast.outbreak(thisUnit,"aoe") then 
                            waitfornextVirPlague = GetTime() 
                            return 
                        end
                        break
                    end
                end
            end
            
            --actions+=/dark_transformation,if=equipped.137075&cooldown.dark_arbiter.remains>165
            if isChecked(colorGreen.."Dark Transformation") and hasEquiped(137075) and cd.darkArbiter.remain() > 165 then
                if cast.darkTransformation() then return end
            end
            --actions+=/dark_transformation,if=equipped.137075&!talent.shadow_infusion.enabled&cooldown.dark_arbiter.remains>55
            if isChecked(colorGreen.."Dark Transformation") and hasEquiped(137075) and not talent.shadowInfusion and cd.darkArbiter.remain() > 55 then
                if cast.darkTransformation() then return end
            end
            --actions+=/dark_transformation,if=equipped.137075&talent.shadow_infusion.enabled&cooldown.dark_arbiter.remains>35
            if isChecked(colorGreen.."Dark Transformation") and hasEquiped(137075) and talent.shadowInfusion and cd.darkArbiter.remain() > 35 then
                if cast.darkTransformation() then return end
            end
            --actions+=/dark_transformation,if=equipped.137075&target.time_to_die<cooldown.dark_arbiter.remains-8
            if isChecked(colorGreen.."Dark Transformation") and hasEquiped(137075) and ttd(units.dyn5) < cd.darkArbiter.remain() - 8 then
                if cast.darkTransformation() then return end
            end
            --actions+=/dark_transformation,if=equipped.137075&cooldown.summon_gargoyle.remains>160
            if isChecked(colorGreen.."Dark Transformation") and hasEquiped(137075) and cd.summonGargoyle.remain() > 160 then
                if cast.darkTransformation() then return end
            end
            --actions+=/dark_transformation,if=equipped.137075&!talent.shadow_infusion.enabled&cooldown.summon_gargoyle.remains>55
            if isChecked(colorGreen.."Dark Transformation") and hasEquiped(137075) and not talent.shadowInfusion and cd.summonGargoyle.remain() > 55 then
                if cast.darkTransformation() then return end
            end
            --actions+=/dark_transformation,if=equipped.137075&talent.shadow_infusion.enabled&cooldown.summon_gargoyle.remains>35
            if isChecked(colorGreen.."Dark Transformation") and hasEquiped(137075) and talent.shadowInfusion and cd.summonGargoyle.remain() > 35 then
                if cast.darkTransformation() then return end
            end
            --actions+=/dark_transformation,if=equipped.137075&target.time_to_die<cooldown.summon_gargoyle.remains-8
            if isChecked(colorGreen.."Dark Transformation") and hasEquiped(137075) and ttd(units.dyn5) < cd.summonGargoyle.remain() - 8 then
                if cast.darkTransformation() then return end
            end
            --actions+=/dark_transformation,if=!equipped.137075&rune<=3
            if isChecked(colorGreen.."Dark Transformation") and not hasEquiped(137075) and rune <= 3 then
                if cast.darkTransformation() then return end
            end
            
            if actionList_Pet() then return end
            
            --actions+=/army_of_the_dead
            if actionList_Defensive() then return end
            
            --actions+=/blighted_rune_weapon,if=rune<=3
            if talent.blightedRuneWeapon and rune <= 3 then
                if cast.blightedRuneWeapon() then return end
            end
            --actions+=/run_action_list,name=valkyr,if=talent.dark_arbiter.enabled&pet.valkyr_battlemaiden.active
            if talent.darkArbiter then 
                if GetObjExists(100876) then
                    if actionList_Valkyr() then return end
                end
            end
            
            if actionList_Generic() then return end

        end
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

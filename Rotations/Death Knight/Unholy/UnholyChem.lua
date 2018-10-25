local rotationName = "Chem - 8.0.1" -- Change to name of profile listed in options drop down

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
        -- section = br.ui:createSection(br.ui.window.profile,  "General")
        -- br.ui:createDropdownWithout(section, "Artifact", {colorWhite.."Everything",colorWhite.."Cooldowns",colorWhite.."Never"}, 1, colorWhite.."When to use Artifact Ability.")
        -- br.ui:checkSectionState(section)
         ------------------------
        --- ITEM OPTIONS --- -- Define Item Options
        ------------------------
        -- section = br.ui:createSection(br.ui.window.profile,  "Items")
        -- br.ui:createCheckbox(section, "Potion")
        -- br.ui:createCheckbox(section,"Flask / Crystal")
        -- br.ui:createDropdownWithout(section, "Trinket 1 Condition", {colorWhite.."On Cooldown",colorWhite.."On Boss Health",colorWhite.."On Self Health"}, 1, colorWhite.."On Cooldown = Use Trinket whenever available, value doesn't matter; On Boss Health = Use Trinket when boss health is below value; On Self Health = Use Trinket when your health is below value;")
        -- br.ui:createSpinner(section, "Trinket 1",  80,  0,  100,  5,  colorRed.."When to use Trinket 1")
        -- br.ui:createDropdownWithout(section, "Trinket 2 Condition", {colorWhite.."On Cooldown",colorWhite.."On Boss Health",colorWhite.."On Self Health"}, 1, colorWhite.."On Cooldown = Use Trinket whenever available, value doesn't matter; On Boss Health = Use Trinket when boss health is below value; On Self Health = Use Trinket when your health is below value;")
        -- br.ui:createSpinner(section, "Trinket 2",  60,  0,  100,  5,  colorRed.."When to use Trinket 2")
        -- br.ui:checkSectionState(section)
        ----------------------
        -- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
        br.ui:createCheckbox(section, "Racial")
        br.ui:createCheckbox(section, "Apocalypse")
        br.ui:createCheckbox(section, "Army of the Dead")
        br.ui:createCheckbox(section, "Dark Transformation")
        br.ui:createCheckbox(section, "Summmon Gargoyle")
        br.ui:createCheckbox(section, "Unholy Frenzy")
        br.ui:createCheckbox(section, "Soul Reaper")
        br.ui:createCheckbox(section, "Unholy Blight")
        br.ui:checkSectionState(section)
        ------------------------
        --- Pet OPTIONS --- -- 
        ------------------------
        -- section = br.ui:createSection(br.ui.window.profile, "Pet")
        -- -- Auto Summon
        --     br.ui:createCheckbox(section,"Auto Summon")
        -- --Auto Attack
        --     br.ui:createCheckbox(section,"Pet Attack")
        --  br.ui:checkSectionState(section)    
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
            -- Raise Ally
            br.ui:createCheckbox(section,"Raise Ally")
            br.ui:createDropdownWithout(section, "Raise Ally - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")

        br.ui:checkSectionState(section)
         -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Mind Freeze
            br.ui:createCheckbox(section,"Mind Freeze")
            -- Asphyxiate Kick
            br.ui:createCheckbox(section,"Asphyxiate")
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
    if br.timer:useTimer("debugUnholy", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
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
        local gcdMax                                        = br.player.gcdMax
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk
        local pet                                           = br.player.pet
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power, br.player.powerMax, br.player.powerRegen
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local runicPower                                    = br.player.power.runicPower.amount()
        local runicPowerDeficit                             = br.player.power.runicPower.deficit()
        local runes                                         = br.player.power.runes.frac()
        local runesDeficit                                  = 6 - runes
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local ttm                                           = br.player.timeToMax
        local units                                         = br.player.units
        
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        local poolingForGargoyle = 0

        units.get(5)
        units.get(30,true)

        enemies.get(8)       -- Bonestorm
        enemies.get(10)     -- blood boil
        enemies.get(30)
        enemies.get(40)

        if waitfornextVirPlague == nil or objIDLastVirPlagueTarget == nil then
            waitfornextVirPlague = GetTime() - 10
            objIDLastVirPlagueTarget = 0
        end 

        if waitForPetToAppear == nil then waitForPetToAppear = 0 end
        if waitforNextKick == nil then waitforNextKick = 0 end     

-------------------
--- Raise Pet   ---
-------------------
        if not inCombat and not IsMounted() and not GetUnitExists("pet") and (UnitIsDead("pet") ~= nil or UnitIsDead("pet") == false) then
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

        local function actionList_Defensive()
          if useDefensive() and not IsMounted() and inCombat then
          --Healthstone
              if isChecked("Healthstone") 
                  and php <= getOptionValue("Healthstone")     
                  and hasItem(5512)
              then
                  if canUse(5512) then
                      useItem(5512)
                  end
              end
          -- Death Strike
              if isChecked("Death Strike")  
                  and (buff.darkSuccor.exists() and (php < getOptionValue("Death Strike") or buff.darkSuccor.remain() < 2))
                  or  runicPower >= 45  
                  and php < getOptionValue("Death Strike") 
              then
                   -- Death strike everything in reach
                  if getDistance("target") > 5 then
                      for i=1, #enemies.yards8 do
                          thisUnit = enemies.yards8[i]
                          distance = getDistance(thisUnit)
                          if distance < 5 and getFacing("player",thisUnit) then
                              if cast.deathStrike(thisUnit) then print("Random Hit Deathstrike") return true end
                          end
                      end
                  end
              end
          -- Icebound Fortitude
              if isChecked("Icebound Fortitude") 
                  and php < getOptionValue("Icebound Fortitude") 
              then
                  if cast.iceboundFortitude() then return true end
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

        local function actionList_Interrupts()
          if useInterrupts() then
              for i = 1, #enemies.yards30 do
                  thisUnit = enemies.yards30[i]
                  if inCombat 
                      and (UnitIsPlayer(thisUnit) or not playertar)
                      and isValidUnit(thisUnit) 
                      and not isDummy(thisUnit) 
                      and canInterrupt(thisUnit, getOptionValue("InterruptAt"))

                  then
                      if isChecked("Mind Freeze") and cd.mindFreeze.remain() == 0 and getDistance(thisUnit) < 15 then
                          if canInterrupt(thisUnit,getValue("Interrupt at") + math.random(-5,5) ) then
                              if cast.mindFreeze(thisUnit) then return true end
                          end
                      end
                      
                      if isChecked("Asphyxiate") and talent.asphyxiate and getDistance(thisUnit) < 20 then
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
--------------------
--- Action Lists ---
--------------------
local function actionList_Generic()
  -- death_coil,if=buff.sudden_doom.react&!variable.pooling_for_gargoyle|pet.gargoyle.active
  if cast.able.deathCoil() and (buff.suddenDoom.exists() and not poolingForGargoyle or (talent.summonGargoyle and pet.gargoyle.active)) then
      if cast.deathCoil("target") then return end
  end
  -- death_coil,if=runic_power.deficit<14&(cooldown.apocalypse.remains>5|debuff.festering_wound.stack>4)&!variable.pooling_for_gargoyle
  if cast.able.deathCoil() and (runicPowerDeficit < 14 and (cd.apocalypse.remain() > 5 or debuff.festeringWound.stack("target") > 4) and not poolingForGargoyle) then
      if cast.deathCoil("target") then return end
  end
  -- death_and_decay,if=talent.pestilence.enabled&cooldown.apocalypse.remains
  if cast.able.deathAndDecay() and (talent.pestilence and cd.apocalypse.remain()) then
      if cast.deathAndDecay("player") then return end
  end
  -- defile,if=cooldown.apocalypse.remains
  if talent.defile and cast.able.defile() and (cd.apocalypse.remain()) then
      if cast.defile("player") then return end
  end
  -- scourge_strike,if=((debuff.festering_wound.up&cooldown.apocalypse.remains>5)|debuff.festering_wound.stack>4)&cooldown.army_of_the_dead.remains>5
  if cast.able.scourgeStrike() and (((debuff.festeringWound.exists("target") and cd.apocalypse.remain() > 5) or debuff.festeringWound.stack("target") > 4) and cd.armyOfTheDead.remain() > 5) then
      if cast.scourgeStrike("target") then return end
  end
  -- clawing_shadows,if=((debuff.festering_wound.up&cooldown.apocalypse.remains>5)|debuff.festering_wound.stack>4)&cooldown.army_of_the_dead.remains>5
  if talent.clawingShadows and cast.able.clawingShadows() and (((debuff.festeringWound.exists("target") and cd.apocalypse.remain() > 5) or debuff.festeringWound.stack("target") > 4) and cd.armyOfTheDead.remain() > 5) then
      if cast.clawingShadows("target") then return end
  end
  -- death_coil,if=runic_power.deficit<20&!variable.pooling_for_gargoyle
  if cast.able.deathCoil() and (runicPowerDeficit < 20 and not poolingForGargoyle) then
      if cast.deathCoil("target") then return end
  end
  -- festering_strike,if=((((debuff.festering_wound.stack<4&!buff.unholy_frenzy.up)|debuff.festering_wound.stack<3)&cooldown.apocalypse.remains<3)|debuff.festering_wound.stack<1)&cooldown.army_of_the_dead.remains>5
  if cast.able.festeringStrike() and (((((debuff.festeringWound.stack("target") < 4 and not buff.unholyFrenzy.exists()) or debuff.festeringWound.stack("target") < 3) and cd.apocalypse.remain() < 3) or debuff.festeringWound.stack("target") < 1) and cd.armyOfTheDead.remain() > 5) then
      if cast.festeringStrike("target") then return end
  end
  -- death_coil,if=!variable.pooling_for_gargoyle
  if cast.able.deathCoil() and (not poolingForGargoyle) then
      if cast.deathCoil("target") then return end
  end
end

local function actionList_Aoe()
  -- death_and_decay,if=cooldown.apocalypse.remains
  if cast.able.deathAndDecay() and (cd.apocalypse.remain()) then
      if cast.deathAndDecay("player") then return end
  end
  -- defile
  if talent.defile and cast.able.defile() then
      if cast.defile("player") then return end
  end
  -- epidemic,if=death_and_decay.ticking&rune<2&!variable.pooling_for_gargoyle
  if cast.able.epidemic() and (buff.deathAndDecay.exists("player") and runes < 2 and not poolingForGargoyle) then
      if cast.epidemic() then return end
  end
  -- death_coil,if=death_and_decay.ticking&rune<2&!variable.pooling_for_gargoyle
  if cast.able.deathCoil() and (buff.deathAndDecay.exists("player") and runes < 2 and not poolingForGargoyle) then
      if cast.deathCoil("target") then return end
  end
  -- scourge_strike,if=death_and_decay.ticking&cooldown.apocalypse.remains
  if cast.able.scourgeStrike() and (buff.deathAndDecay.exists("player") and cd.apocalypse.remain()) then
      if cast.scourgeStrike("target") then return end
  end
  -- clawing_shadows,if=death_and_decay.ticking&cooldown.apocalypse.remains
  if cast.able.clawingShadows() and (buff.deathAndDecay.exists("player") and cd.apocalypse.remain()) then
      if cast.clawingShadows("target") then return end
  end
  -- epidemic,if=!variable.pooling_for_gargoyle
  if cast.able.epidemic() and (not poolingForGargoyle) then
      if cast.epidemic() then return end
  end
  -- festering_strike,target_if=debuff.festering_wound.stack<=1&cooldown.death_and_decay.remains
  if cast.able.festeringStrike() and (debuff.festeringWound.stack("target") <= 1 and cd.deathAndDecay.remain()) then
      if cast.festeringStrike("target") then return end
  end
  -- festering_strike,if=talent.bursting_sores.enabled&spell_targets.bursting_sores>=2&debuff.festering_wound.stack<=1
  if cast.able.festeringStrike() and (talent.burstingSores and #enemies.yards8 >= 2 and debuff.festeringWound.stack("target") <= 1) then
      if cast.festeringStrike("target") then return end
  end
  -- death_coil,if=buff.sudden_doom.react&rune.deficit>=4
  if cast.able.deathCoil() and (buff.suddenDoom.exists() and runesDeficit >= 4) then
      if cast.deathCoil("target") then return end
  end
  -- death_coil,if=buff.sudden_doom.react&!variable.pooling_for_gargoyle|pet.gargoyle.active
  if cast.able.deathCoil() and (buff.suddenDoom.exists() and not poolingForGargoyle or (talent.summonGargoyle and pet.gargoyle.active)) then
      if cast.deathCoil("target") then return end
  end
  -- death_coil,if=runic_power.deficit<14&(cooldown.apocalypse.remains>5|debuff.festering_wound.stack>4)&!variable.pooling_for_gargoyle
  if cast.able.deathCoil() and (runicPowerDeficit < 14 and (cd.apocalypse.remain() > 5 or debuff.festeringWound.stack() > 4) and not poolingForGargoyle) then
      if cast.deathCoil("target") then return end
  end
  -- scourge_strike,if=((debuff.festering_wound.up&cooldown.apocalypse.remains>5)|debuff.festering_wound.stack>4)&cooldown.army_of_the_dead.remains>5
  if cast.able.scourgeStrike() and (((debuff.festeringWound.exists("target") and cd.apocalypse.remain() > 5) or debuff.festeringWound.stack("target") > 4) and cd.armyOfTheDead.remain() > 5) then
      if cast.scourgeStrike("target") then return end
  end
  -- clawing_shadows,if=((debuff.festering_wound.up&cooldown.apocalypse.remains>5)|debuff.festering_wound.stack>4)&cooldown.army_of_the_dead.remains>5
  if cast.able.clawingShadows() and (((debuff.festeringWound.exists("target") and cd.apocalypse.remain() > 5) or debuff.festeringWound.stack("target") > 4) and cd.armyOfTheDead.remain() > 5) then
      if cast.clawingShadows("target") then return end
  end
  -- death_coil,if=runic_power.deficit<20&!variable.pooling_for_gargoyle
  if cast.able.deathCoil() and (runicPowerDeficit < 20 and not poolingForGargoyle) then
      if cast.deathCoil("target") then return end
  end
  -- festering_strike,if=((((debuff.festering_wound.stack<4&!buff.unholy_frenzy.up)|debuff.festering_wound.stack<3)&cooldown.apocalypse.remains<3)|debuff.festering_wound.stack<1)&cooldown.army_of_the_dead.remains>5
  if cast.able.festeringStrike() and (((((debuff.festeringWound.stack("target") < 4 and not buff.unholyFrenzy.exists()) or debuff.festeringWound.stack("target") < 3) and cd.apocalypse.remain() < 3) or debuff.festeringWound.stack("target") < 1) and cd.armyOfTheDead.remain() > 5) then
      if cast.festeringStrike("target") then return end
  end
  -- death_coil,if=!variable.pooling_for_gargoyle
  if cast.able.deathCoil() and (not poolingForGargoyle) then
      if cast.deathCoil("target") then return end
  end
end


local function actionList_Cooldowns()
  if isChecked("Racial") then
      -- arcane_torrent,if=runic_power.deficit>65&(cooldown.summon_gargoyle.remains|!talent.summon_gargoyle.enabled)&rune.deficit>=5
    if br.player.race == "BloodElf" and cast.able.racial() and (runicPowerDeficit > 65 and (not talent.summonGargoyle or cd.summonGargoyle.remain()) and runesDeficit >= 5) then
        if cast.racial() then return end
    end
    -- blood_fury,if=pet.gargoyle.active|!talent.summon_gargoyle.enabled
    if br.player.race == "Orc" and cast.able.racial() and (not talent.summonGargoyle or pet.gargoyle.active) then
        if cast.racial() then return end
    end
    -- berserking,if=pet.gargoyle.active|!talent.summon_gargoyle.enabled
    if br.player.race == "Troll" and cast.able.racial() and (not talent.summonGargoyle or pet.gargoyle.active) then
        if cast.racial() then return end
    end
  end

  -- army_of_the_dead
  if isChecked("Army of the Dead") and cast.able.armyOfTheDead() then
      if cast.armyOfTheDead() then return end
  end
  -- apocalypse,if=debuff.festering_wound.stack>=4
  if isChecked("Apocalypse") and  cast.able.apocalypse() and (debuff.festeringWound.stack("target") >= 4) then
      if cast.apocalypse("target") then return end
  end
  -- dark_transformation
  if  isChecked("Dark Transformation") and cast.able.darkTransformation() then
      if cast.darkTransformation() then return end
  end
  -- summon_gargoyle,if=runic_power.deficit<14
  if  isChecked("Summon Gargoyle") and talent.summonGargoyle and cast.able.summonGargoyle() and (runicPowerDeficit < 14) then
      if cast.summonGargoyle() then return end
  end
  -- unholy_frenzy,if=debuff.festering_wound.stack<4
  if  isChecked("Unholy Frenzy") and cast.able.unholyFrenzy() and (debuff.festeringWound.stack("target") < 4) then
      if cast.unholyFrenzy() then return end
  end
  -- unholy_frenzy,if=active_enemies>=2&((cooldown.death_and_decay.remains<=gcd&!talent.defile.enabled)|(cooldown.defile.remains<=gcd&talent.defile.enabled))
  if  isChecked("Unholy Frenzy") and cast.able.unholyFrenzy() and (#enemies.yards8 >= 2 and ((cd.deathAndDecay.remain() <= gcdMax and not talent.defile) or (cd.defile.remain() <= gcdMax and talent.defile))) then
      if cast.unholyFrenzy() then return end
  end
  -- soul_reaper,target_if=target.time_to_die<8&target.time_to_die>4
  if  isChecked("Soul Reaper") and talent.soulReaper and cast.able.soulReaper() and (ttd("target") < 8 and ttd("target") > 4) then
      if cast.soulReaper("target") then return end
  end
  -- -- soul_reaper,if=(!raid_event.adds.exists|raid_event.adds.in>20)&rune<=(1-buff.unholy_frenzy.up)
  -- if cast.able.soulReaper() and ((not raid_event.adds.exists or raid_event.adds.in > 20) and runes <= (1 - buff.unholyFrenzy.exists())) then
  --     if cast.soulReaper() then return end
  -- end
  -- unholy_blight
  if  isChecked("Unholy Blight") and cast.able.unholyBlight() then
      if cast.unholyBlight() then return end
  end
end

local function actionList_Rotation()
  -- # Executed before combat begins. Accepts non-harmful actions only.
  -- variable,name=pooling_for_gargoyle,value=cooldown.summon_gargoyle.remains<5&talent.summon_gargoyle.enabled
  if talent.summonGargoyle and cd.summonGargoyle.remains() < 5 then
    poolingForGargoyle = 1
  end
  -- use_item,name=bygone_bee_almanac,if=cooldown.summon_gargoyle.remains>60|!talent.summon_gargoyle.enabled
  --TODO: parsing use_item
  -- use_item,name=jes_howler,if=pet.gargoyle.active|!talent.summon_gargoyle.enabled
  --TODO: parsing use_item
  -- use_item,name=galecallers_beak,if=pet.gargoyle.active|!talent.summon_gargoyle.enabled
  --TODO: parsing use_item

  -- potion,if=cooldown.army_of_the_dead.ready|pet.gargoyle.active|buff.unholy_frenzy.up
  -- if cast.able.potion() and (not cd.armyOfTheDead.exists() or pet.gargoyle.active or buff.unholyFrenzy.exists()) then
  --     if cast.potion() then return end
  -- end


  -- outbreak,target_if=(dot.virulent_plague.tick_time_remains+tick_time<=dot.virulent_plague.remains)&dot.virulent_plague.remains<=gcd
  -- if cast.able.outbreak() and ((dot.virulent_plague.tick_time_remains + tick_time <= debuff.virulentPlague.remain()) and debuff.virulentPlague.remain() <= gcdMax) then
  --     if cast.outbreak("target") then return end
  -- end

    if GetUnitExists("target") and ((objIDLastVirPlagueTarget ~= ObjectID("target")) or (waitfornextVirPlague < GetTime() - 6)) then
      if (not debuff.virulentPlague.exists("target")
          or debuff.virulentPlague.remain("target") < 1.5) 
          and not debuff.soulReaper.exists("target")
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
          then
              if cast.outbreak(thisUnit,"aoe") then 
                  waitfornextVirPlague = GetTime() 
                  return 
              end
              break
          end
      end
  end

  -- call_action_list,name=cooldowns
  if actionList_Cooldowns() then return end
  -- run_action_list,name=aoe,if=active_enemies>=2
  if #enemies.yards10 >= 2 then
      if actionList_Aoe() then return end
  end
  -- call_action_list,name=generic
  if actionList_Generic() then return end
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
                -- print("No up to date rotation found for this spec.")
              return
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat then
                if actionList_Interrupts() then return end
                if actionList_Defensive() then return end
                return actionList_Rotation()
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation 
local id = 252 --Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
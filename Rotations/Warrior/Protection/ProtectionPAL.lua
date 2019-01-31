---  Protection Warrior for 8.1 by Laksmackt and Rebecca  - 01/2019
--- Left Alt on Mouseover = Heroic Throw
--- Special Credits to Panglo for his Awesome Ignore Pain function ! :)

local rotationName = "ProtectionPAL"

---------------
--- Toggles ---
---------------
local function createToggles()
  -- Rotation Button
  RotationModes = {
    [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 0, icon = br.player.spell.whirlwind },
    [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladestorm },
    [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.furiousSlash },
  };
  CreateButton("Rotation",1,0)
  -- Cooldown Button
  CooldownModes = {
    [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.battleCry },
    [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.battleCry },
    [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.battleCry }
  };
  CreateButton("Cooldown",2,0)
  -- Defensive Button
  DefensiveModes = {
    [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.enragedRegeneration },
    [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.enragedRegeneration }
  };
  CreateButton("Defensive",3,0)
  -- Interrupt Button
  InterruptModes = {
    [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Use Interrupts.", highlight = 1, icon = br.player.spell.pummel },
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

    br.ui:checkSectionState(section)
    ------------------------
    --- Cooldowns
    ------------------------
    section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")

    br.ui:checkSectionState(section)
    -------------------------
    --- Defensives
    -------------------------
    section = br.ui:createSection(br.ui.window.profile, "Defensive")
    br.ui:createSpinner(section, "Demoralizing Shout",  75,  0,  100,  5,  "Your Health % to be cast at")

    br.ui:checkSectionState(section)

    -------------------------
    --- Spell Usage ---
    -------------------------
    section = br.ui:createSection(br.ui.window.profile,  "Spell Usage")
    br.ui:createCheckbox(section, "Berserker Rage", "Use Berserker Rage on loss of Control")
    br.ui:createCheckbox(section, "Devastate", "Use Devastate")
    br.ui:createCheckbox(section, "Shield Slam", "Use Shield Slam")
    br.ui:createCheckbox(section, "Dragon Roar", "Use Dragon Roar")
    br.ui:createCheckbox(section, "Revenge", "Use Revenge")
    br.ui:createSpinner(section, "Victory Rush - Impending Victory", 80,  0,  100,  5, "Your Health % to be cast at")

    br.ui:checkSectionState(section)

    -------------------------
    --- Interrupts
    -------------------------
    section = br.ui:createSection(br.ui.window.profile, "Interrupts")
    br.ui:createCheckbox(section, "Storm Bolt Interrupt", "Use Storm Bolt as an Interrupt")
    br.ui:createCheckbox(section, "Shockwave Interrupt", "Use Shockwave as an Interrupt")
    br.ui:createCheckbox(section, "Pummel Interrupt", "Use Pummel as an Interrupt")
    br.ui:createCheckbox(section, "Intimidating Shout Interrupt", "Use Intimidating Shout as an Interrupt")
    br.ui:createSpinner(section,  "InterruptAt",  55,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")

    br.ui:checkSectionState(section)
    -------------------------
    --- Modifiers  ---
    -------------------------
    section = br.ui:createSection(br.ui.window.profile,  "Modifiers")
    br.ui:createDropdown(section,"Heroic Leap Hotkey", br.dropOptions.Toggle, 7, "Hold down the set hotkey and Heroic Leap will be casted at mouse cursor on next GCD.")
    br.ui:createDropdown(section,"Intercept Hotkey", br.dropOptions.Toggle, 7, "Hold down the set hotkey and Intercept will be casted at the current Mouseover target on next GCD.")

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
  if br.timer:useTimer("debugFury", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
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
    local pullTimer                                     = br.DBM:getPulltimer()
    local race                                          = br.player.race
    local thisUnit                                      = thisUnit
    local racial                                        = br.player.getRacial()
    local spell                                         = br.player.spell
    local talent                                        = br.player.talent
    local ttm                                           = br.player.timeToMax
    local units                                         = br.player.units

    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end
    units.get(5)
    units.get(8)

    enemies.get(5)
    enemies.get(8)
    enemies.get(10)
    enemies.get(20)
    enemies.get(30)
    enemies.get(40)
    --------------------
    --- Action Lists ---
    --------------------

    -----------------
    --- Rotations ---
    -----------------
    -- Pause
    if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or mode.rotation == 4 then
      return true
    else
      ---------------------------------
      ---       Functions           ---
      ---------------------------------
        -- Thanks to Panglo
      local function ipCapCheck()
        if buff.ignorePain.exists() then
            local ipValue = tonumber((select(1, GetSpellDescription(190456):match("%d+%S+%d"):gsub("%D",""))),10)
            local ipMax = math.floor(ipValue * 1.3)
            local ipCurrent = tonumber((select(16, UnitBuffID("player", 190456))),10)
            if ipCurrent == nil then ipCurrent = 0 return end
            if ipCurrent <= (ipMax * 0.2) then
                ---print("IP below cap")
                return true
            else
                --print("dont cast IP")
                return false
            end
        else
            --print("IP not on")
            return true
        end
      end




      local function antislow()
        if isChecked("Berserker Rage") and hasNoControl(spell.berserkerRage) then
          if cast.berserkerRage() then return end
        end
      end


      local function Defensives()
        if useDefensive() then
          if isChecked("Demoralizing Shout") and php <= getOptionValue("Demoralizing Shout") and cast.able.demoralizingShout() then
            if cast.demoralizingShout() then return true end
          end
        end
      end

      local function Interrupts()
        if useInterrupts() then
          for i=1, #enemies.yards20 do
            thisUnit = enemies.yards20[i]
            unitDist = getDistance(thisUnit)
            targetMe = UnitIsUnit("player",thisUnit) or false
            if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
              if isChecked("Pummel Interrupt") and unitDist < 6 then
                if cast.pummel(thisUnit) then return end
              end
              if isChecked("Intimidating Shout Interrupt") and unitDist <= 8 then
                if cast.intimidatingShout() then return end
              end
              if isChecked("Shockwave Interrupt") and unitDist < 10 then
                if cast.shockwave() then return end
              end
              if isChecked("Storm Bolt Interrupt") and unitDist < 20 then
                if cast.stormBolt() then return end
              end
            end
          end
        end
      end

      local function AttackSpells()
        if cast.able.thunderClap() and talent.cracklingThunder then
          if cast.thunderClap("player",nil,1,12) then return end
        elseif not talent.cracklingThunder then
          if cast.thunderClap("player",nil,1,8) then return end
        end

        if isChecked("Revenge") and cast.able.revenge() then
          for i = 1, #enemies.yards8 do
            thisUnit = enemies.yards8[i]
            if getFacing("player",thisUnit) then
              if cast.revenge(thisUnit) then return end
            end
          end
        end

        if isChecked("Dragon Roar") and talent.dragonRoar and cast.able.dragonRoar(nil,"aoe") then
          if cast.dragonRoar(nil,"aoe") then return end
        end

        if isChecked("Shield Slam") and cast.able.shieldSlam() then
          for i = 1, #enemies.yards8 do
            thisUnit = enemies.yards8[i]
            if getFacing("player",thisUnit) then
              if cast.shieldSlam(thisUnit) then return end
            end
          end
        end

        if isChecked("Devastate") and cast.able.devastate() then
          for i = 1, #enemies.yards8 do
            thisUnit = enemies.yards8[i]
            if getFacing("player",thisUnit) then
              if cast.devastate(thisUnit) then return end
            end
          end
        end

        if isChecked("Victory Rush - Impending Victory") and (cast.able.victoryRush() or cast.able.impendingVictory()) and php <= getOptionValue("Victory Rush - Impending Victory") and buff.victorious.exists() then
            if talent.impendingVictory then
                if cast.impendingVictory() then return end
            else
                if cast.victoryRush() then return end
            end
        end

        end

      -----------------------------
      ---      Rotation itself  ---
      -----------------------------
      if inCombat and not (IsMounted() or IsFlying()) and #enemies.yards8 == 1 then
        if Defensives() then return end
        if AttackSpells() then return end
        if antislow() then return end
        if Interrupts() then return end
      end



      -----------------------------
      ---      Modifiers        ---
      -----------------------------
      if isChecked("Heroic Leap Hotkey") and SpecificToggle("Heroic Leap Hotkey") then
        CastSpellByName(GetSpellInfo(spell.heroicLeap),"cursor")  return end
        if IsLeftAltKeyDown() and cast.able.heroicThrow("mouseover") and getDistance("player","mouseover") >= 8 and getDistance("player","mouseover") <= 30  then
          CastSpellByName(GetSpellInfo(spell.heroicThrow),"mouseover") return end

          if isChecked("Intercept Hotkey") and SpecificToggle("Intercept Hotkey") then
            if GetUnitIsFriend("mouseover") and cast.able.intercept("mouseover") and getDistance("player","mouseover") >= 0 and getDistance("player","mouseover") <= 25 then
              if cast.intercept("mouseover") then return end
            elseif not GetUnitIsFriend("mouseover") and cast.able.intercept("mouseover") and getDistance("player","mouseover") >= 8 and getDistance("player","mouseover") <= 25 then
              if cast.intercept("mouseover") then return end
            end
          end

      if cast.able.battleShout("player") then
        for i = 1, #br.friend do
          if not buff.battleShout.exists(br.friend[i].unit,"any") and getDistance("player", br.friend[i].unit) < 100 and
          not UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsPlayer(br.friend[i].unit) then
            if cast.battleShout() then return end
          end
        end
      end

        end -- Pause
      end -- End Timer
    end -- End runRotation
    local id = 73 -- Change to the spec id profile is for.
    if br.rotations[id] == nil then br.rotations[id] = {} end
    tinsert(br.rotations[id],{
      name = rotationName,
      toggles = createToggles,
      options = createOptions,
      run = runRotation,
    })

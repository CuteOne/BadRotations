local rotationName = "BroAlpha"

---------------
--- Toggles ---
---------------
local function createToggles()
  -- Rotation Button
  RotationModes = {
    [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.aimedShot},
    [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.multishot},
    [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.arcaneShot},
    [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.aspectOfTheCheetah}
  };
  CreateButton("Rotation",1,0)
  -- Cooldown Button
  CooldownModes = {
    [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.trueshot},
    [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.trueshot},
    [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.trueshot}
  };
  CreateButton("Cooldown",2,0)
  -- Defensive Button
  DefensiveModes = {
    [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.aspectOfTheTurtle},
    [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.aspectOfTheTurtle}
  };
  CreateButton("Defensive",3,0)
  -- Interrupt Button
  InterruptModes = {
    [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterShot},
    [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterShot}
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
    section = br.ui:createSection(br.ui.window.profile, "General")
    br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
    br.ui:createSpinner(section, "DPS Testing",  2,  1,  5,  1,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
    br.ui:checkSectionState(section)
    section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
    br.ui:createCheckbox(section,"Potion")
    br.ui:createCheckbox(section,"Flask")
    br.ui:createCheckbox(section,"Racial")
    br.ui:createCheckbox(section,"Trinkets")
    br.ui:createCheckbox(section,"Trueshot")
    br.ui:checkSectionState(section)
    section = br.ui:createSection(br.ui.window.profile, "Defensive")
    br.ui:createSpinner(section, "Healthstone",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
    br.ui:createSpinner(section, "Exhilaration",  40,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
    br.ui:createSpinner(section, "Aspect Of The Turtle",  20,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
    br.ui:createSpinner(section, "Feign Death", 5, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
    br.ui:checkSectionState(section)
    section = br.ui:createSection(br.ui.window.profile, "Interrupts")
    br.ui:createCheckbox(section,"Counter Shot")
    br.ui:createSpinner(section, "Interrupt At",  50,  0,  100,  5,  "|cffFFFFFFCast Percent to Cast At")
    br.ui:checkSectionState(section)
    section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
    br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  6)
    br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  6)
    br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
    br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
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
  --print("Running: "..rotationName)

  ---------------
  --- Toggles ---
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
  local animality                                     = false
  local artifact                                      = br.player.artifact
  local buff                                          = br.player.buff
  local canFlask                                      = canUseItem(br.player.flask.wod.agilityBig)
  local cast                                          = br.player.cast
  local combatTime                                    = getCombatTime()
  local cd                                            = br.player.cd
  local charges                                       = br.player.charges
  local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
  local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
  local debuff, debuffcount                           = br.player.debuff, br.player.debuffcount
  local enemies                                       = enemies or {}
  local explosiveTarget                               = explosiveTarget
  local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
  local fatality                                      = false
  local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
  local friendly                                      = friendly or UnitIsFriend("target", "player")
  local gcd                                           = br.player.gcd
  local gcdMax                                        = br.player.gcdMax
  local hasMouse                                      = GetObjectExists("mouseover")
  local healPot                                       = getHealthPot()
  local inCombat                                      = UnitAffectingCombat("player") --br.player.inCombat
  local inInstance                                    = br.player.instance=="party"
  local inRaid                                        = br.player.instance=="raid"
  local item                                          = br.player.spell.items
  local level                                         = br.player.level
  local lootDelay                                     = getOptionValue("LootDelay")
  local lowestHP                                      = br.friend[1].unit
  local mode                                          = br.player.mode
  local multidot                                      = (br.player.mode.cleave == 1 or br.player.mode.rotation == 2) and br.player.mode.rotation ~= 3
  local perk                                          = br.player.perk
  local php                                           = br.player.health
  local playerMouse                                   = UnitIsPlayer("mouseover")
  local potion                                        = br.player.potion
  local power, powerMax, powerRegen, powerDeficit     = br.player.power.focus.amount(), br.player.power.focus.max(), br.player.power.focus.regen(), br.player.power.focus.deficit()
  local pullTimer                                     = br.DBM:getPulltimer()
  local racial                                        = br.player.getRacial()
  local solo                                          = #br.friend < 2
  local friendsInRange                                = friendsInRange
  local spell                                         = br.player.spell
  local t20_2pc                                       = TierScan("T20") >= 2
  local talent                                        = br.player.talent
  local trinketProc                                   = false
  local ttd                                           = getTTD
  local ttm                                           = br.player.power.focus.ttm()
  local units                                         = units or {}
  local use                                           = br.player.use

  enemies.yards40 = br.player.enemies(51)
  enemies.yards8t = br.player.enemies(8,br.player.units(51,true))

  if leftCombat == nil then leftCombat = GetTime() end
  if profileStop == nil then profileStop = false end

  -----------------
  --- Varaibles ---
  -----------------
  local vulnWindow = debuff.vulnerable.remain("target") - 0.1 or 0
  local aimedExecute = math.max(cast.time.aimedShot(),gcdMax)
  local vulnAimCast = math.floor(vulnWindow / aimedExecute) or 0

  if vulnAimCast > 0 then
    if vulnAimCast > math.floor((power + (cast.regen.aimedShot() * (vulnAimCast - 1))) / cast.cost.aimedShot()) then
      vulnAimCast = math.floor((power + (cast.regen.aimedShot() * (vulnAimCast - 1))) / cast.cost.aimedShot())
    end
  end

  local canGCD = vulnWindow < cast.time.aimedShot() or vulnWindow > (vulnAimCast * aimedExecute) + gcdMax + 0.2
  local attackHaste = 1 / (1 + (UnitSpellHaste("player") / 100))

  --------------------
  --- Action Lists ---
  --------------------
  -- Action List - Extras
  local function actionList_Extras()
    -- Dummy Test
    if isChecked("DPS Testing") then
      if GetObjectExists("target") then
        if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
          StopAttack()
          ClearTarget()
          print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
          profileStop = true
        end
      end
    end -- End Dummy Test
    -- Volley,toggle=on
    if talent.volley and not buff.volley.exists() then
      if cast.volley("player") then return end
    end
  end -- End Action List - Extras
  -- Action List - Defensive
  local function actionList_Defensive()
    if useDefensive() then
      -- Healthstone
      if isChecked("Healthstone") and php <= getOptionValue("Healthstone")
      and inCombat and (hasHealthPot() or hasItem(5512))
      then
        if canUseItem(5512) then
          useItem(5512)
        elseif canUseItem(healPot) then
          useItem(healPot)
        end
      end
      -- Exhilaration
      if isChecked("Exhilaration") and php <= getOptionValue("Exhilaration") then
        if cast.exhilaration("player") then return end
      end
      -- Aspect of the Turtle
      if isChecked("Aspect Of The Turtle") and inCombat and php <= getOptionValue("Aspect Of The Turtle") then
        if cast.aspectOfTheTurtle("player") then return end
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
    end -- End useInterrupts check
  end -- End Action List - Interrupts

  -- Action List - Cooldowns
  local function actionList_Cooldowns()
    rotationDebug = "Cooldowns"
    if useCDs() then
      -- Trinkets
      if isChecked("Trinkets") then
        -- use_item,name=tarnished_sentinel_medallion,if=((cooldown.trueshot.remains<6|cooldown.trueshot.remains>45)&(target.time_to_die>cooldown+duration))|target.time_to_die<25|buff.bullseye.react=30
        if hasEquiped(147017) then
          if cd.trueshot.remain() < 6 or cd.trueshot.remain() > 45 then
            if ttd("target") > (120 + 20) then
              useItem(147017)
            end
          end
          if buff.bullseye.stack() == 30 then
            useItem(147017)
          end
          if isDummy("target") then
            useItem(147017)
          end
        end
      end
      -- Racial: Blood Elf Arcane Torrent
      -- arcane_torrent,if=focus.deficit>=30&(!talent.sidewinders.enabled|cooldown.sidewinders.charges<2)
      if isChecked("Racial") and getSpellCD(racial) == 0 and (powerDeficit >= 30 and br.player.race == "BloodElf")
      then
        if castSpell("player",racial,false,false,false) then return end
      end
      -- Potion
      -- potion,if=(buff.trueshot.react&buff.bloodlust.react)|buff.bullseye.react>=23|((consumable.prolonged_power&target.time_to_die<62)|target.time_to_die<31)
      if isChecked("Potion") and canUseItem(142117) and inRaid then
        if (buff.trueshot.exists() and hasBloodLust()) or buff.bullseye.stack() >= 23 or ttd("target") < 62 then
          useItem(142117)
        end
      end
      --Trueshot
      --trueshot,if=variable.trueshot_cooldown=0|buff.bloodlust.up|(variable.trueshot_cooldown>0&target.time_to_die>(variable.trueshot_cooldown+duration))|buff.bullseye.react>25|target.time_to_die<16
      if isChecked("Trueshot") then
        local trueshotCD = trueshotCD or 0
        if combatTime > 15 and cd.trueshot.remain() == 0 and trueshotCD == 0 then
          trueshotCD = combatTime * 1.1
        else trueshotCD = 0
        end
        if trueshotCD == 0 or hasBloodLust() or (trueshotCD > 0 and ttd("target") > (trueshotCD + buff.trueshot.duration())) or buff.bullseye.stack() >= 25 or ttd("target") < 16 then
          if cast.last.windburst() or cast.last.markedShot() then
            if cast.trueshot("player") then
              print("Cooldown Trueshot cast at "..power.." Focus")
              return
            end
          end
        end
      end
    end -- End useCooldowns check
  end -- End Action List - Cooldowns

  -- Action List - Target Die
  local function actionList_TargetDie()
    -- Windburst
    -- windburst
    if cd.windburst.remain() == 0 then
      if cast.windburst() then
        print("TargetDie Windburst cast at "..power.." Focus")
        return
      end
    end
    -- Aimed Shot
    -- aimed_shot,if=debuff.vulnerability.remains>cast_time&target.time_to_die>cast_time
    if debuff.vulnerable.remain("target") > getCastTime(spell.aimedShot) and ttd("target") > getCastTime(spell.aimedShot) then
      if cast.aimedShot() then
        print("TargetDie Aimed Shot cast at "..power.." Focus")
        return
      end
    end
    -- Marked Shot
    -- marked_shot
    if debuff.huntersMark.exists("target") then
      if cast.markedShot() then
        print("TargetDie Marked Shot cast at "..power.." Focus")
        return
      end
    end
    -- Arcane Shot
    -- arcane_shot
    if cast.arcaneShot() then
      print("TargetDie Arcane Shot cast at "..power.." Focus")
      return
    end
  end -- End Action List - Target Die

  -- Action List - Patient Sniper
  local function actionList_PatientSniper()
    -- Aimed Shot
    -- aimed_shot,if=spell_targets>1&talent.trick_shot.enabled&debuff.vulnerability.remains>cast_time&(buff.sentinels_sight.stack>=spell_targets.multishot*5|buff.sentinels_sight.stack+(spell_targets.multishot%2)>20|buff.lock_and_load.up|(set_bonus.tier20_2pc&!buff.t20_2p_critical_aimed_damage.up&action.aimed_shot.in_flight))
    if (mode.rotation == 1 or mode.rotation == 2) and #enemies.yards8t > 1 and talent.trickShot and debuff.vulnerable.remain("target") > getCastTime(spell.aimedShot) and (buff.sentinelsSight.stack() >= #enemies.yards8t * 5	or buff.sentinelsSight.stack() + (#enemies.yards8t / 2) > 20 or buff.lockAndLoad.exists() or (t20_2pc and not buff.t20_2pc_critical_aimed.exists() and cast.last.aimedShot())) then
      if cast.aimedShot() then
        print("PS Aimed Shot 1 cast at "..power.." Focus")
        return
      end
    end
    -- Marked Shot
    -- marked_shot,if=spell_targets>1
    if (mode.rotation == 1 or mode.rotation == 2) and #enemies.yards8t > 1 and debuff.huntersMark.exists("target") then
      if cast.markedShot() then
        print("PS Marked Shot 2 cast at "..power.." Focus")
        return
      end
    end
    -- Multi-Shot
    -- multi-shot,if=spell_targets>1&(buff.marking_targets.up|buff.trueshot.up)
    if (mode.rotation == 1 or mode.rotation == 2) and #enemies.yards8t > 1 and (buff.markingTargets.exists() or buff.trueshot.exists()) then
      if cast.multishot() then
        print("PS Multi Shot 3 cast at "..power.." Focus")
        return
      end
    end
    -- Windburst
    -- windburst,if=variable.vuln_aim_casts<1&!variable.pooling_for_piercing
    if vulnAimCast < 1 then
      if cast.windburst() then
        print("PS Windburst Shot 4 cast at "..power.." Focus")
        return
      end
    end
    -- A Murder of Crows
    -- a_murder_of_crows,if=(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)&(target.time_to_die>=cooldown+duration|target.health.pct<20|target.time_to_die<16)&variable.vuln_aim_casts=0
    if ((ttd("target") >= (60 + 15) and not buff.trueshot.exists() and cd.trueshot.remain() > 0) or getHP("target") < 20 or ttd("target") < 16) and vulnAimCast == 0 then
      if cast.aMurderOfCrows() then
        print("PS Murder of Crows 5 cast at "..power.." Focus")
        return
      end
    end
    -- Aimed Shot
    -- aimed_shot,if=action.windburst.in_flight&focus+action.arcane_shot.cast_regen+cast_regen>focus.max
    if cast.last.windburst() and power + cast.regen.arcaneShot() + cast.regen.aimedShot() > powerMax then
      if cast.aimedShot() then
        print("PS Aimed Shot 6 cast at "..power.." Focus")
        return
      end
    end
    -- Aimed Shot
    -- aimed_shot,if=debuff.vulnerability.up&buff.lock_and_load.up&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
    if debuff.vulnerable.exists("target") and buff.lockAndLoad.exists("player") then
      if cast.aimedShot() then
        print("PS Aimed Shot 7 cast at "..power.." Focus")
        return
      end
    end
    -- Aimed Shot
    -- aimed_shot,if=spell_targets.multishot>1&debuff.vulnerability.remains>execute_time&(!variable.pooling_for_piercing|(focus>100&lowest_vuln_within.5>(execute_time+gcd.max)))
    if (mode.rotation == 1 or mode.rotation == 2) and #enemies.yards8t > 1 and debuff.vulnerable.remain("target") > aimedExecute and power > 100 then
      if cast.aimedShot() then
        print("PS Aimed Shot 8 cast at "..power.." Focus")
        return
      end
    end
    -- Multi-Shot
    -- multishot,if=spell_targets>1&variable.can_gcd&focus+cast_regen+action.aimed_shot.cast_regen<focus.max&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
    if (mode.rotation == 1 or mode.rotation == 2) and #enemies.yards8t > 1 and canGCD and (power + getCastRegen(spell.multishot) + getCastRegen(spell.aimedShot)) < powerMax then
      if cast.multishot() then
        print("PS Multi Shot 9 cast at "..power.." Focus")
        return
      end
    end
    -- Arcane Shot
    -- arcane_shot,if=spell_targets.multishot=1&(!set_bonus.tier20_2pc|!action.aimed_shot.in_flight|buff.t20_2p_critical_aimed_damage.remains>action.aimed_shot.execute_time+gcd)&variable.vuln_aim_casts>0&variable.can_gcd&focus+cast_regen+action.aimed_shot.cast_regen<focus.max&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd)
    if (mode.rotation == 3 or #enemies.yards8t == 1) and (not t20_2pc or not cast.last.aimedShot() or buff.t20_2pc_critical_aimed.remain() > aimedExecute + gcd) and vulnAimCast > 0 and canGCD and power + cast.regen.arcaneShot() + cast.regen.aimedShot() < powerMax then
      if cast.arcaneShot() then
        print("PS Arcane Shot 10 cast at "..power.." Focus")
        return
      end
    end
    -- Aimed Shot
    -- aimed_shot,if=!talent.sidewinders.enabled&debuff.vulnerability.remains>cast_time&(!variable.pooling_for_piercing|lowest_vuln_within.5>execute_time+gcd.max)
    if not talent.sidewinders and debuff.vulnerable.remain("target") > cast.time.aimedShot() then
      if cast.aimedShot() then
        print("PS Aimed Shot 11 cast at "..power.." Focus")
        return
      end
    end
    -- Marked Shot
    -- marked_shot,if=!talent.sidewinders.enabled&!variable.pooling_for_piercing&!action.windburst.in_flight&(focus>65|buff.trueshot.up|(1%attack_haste)>1.171)
    if not talent.sidewinders and not cast.last.windburst() and (power > 65 or buff.trueshot.exists() or (1 / attackHaste) > 1.171) and debuff.huntersMark.exists("target") then
      if cast.markedShot() then
        print("PS Marked Shot 12 cast at "..power.." Focus")
        return
      end
    end
    -- Aimed Shot
    -- aimed_shot,if=focus+cast_regen>focus.max&!buff.sentinels_sight.up
    if power + cast.regen.aimedShot() > powerMax and not buff.sentinelsSight.exists() then
      if cast.aimedShot() then
        print("PS Aimed Shot 13 cast at "..power.." Focus")
        return
      end
    end
    -- Arcane Shot
    -- arcane_shot,if=spell_targets.multishot=1&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
    if mode.rotation == 3 or #enemies.yards8t == 1 then
      if cast.arcaneShot() then
        print("PS Arcane Shot 14 cast at "..power.." Focus")
        return
      end
    end
    -- Multi-Shot
    -- multishot,if=spell_targets>1&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
    if (mode.rotation == 1 or mode.rotation == 2) and #enemies.yards8t > 1 then
      if cast.multishot() then
        print("PS Multi Shot 15 cast at "..power.." Focus")
        return
      end
    end
  end

  local function marksmanRotation()
    if not inCombat or pause() or (GetUnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or mode.rotation == 4 then
      return false
    else
      if actionList_Extras() then return true end
      if actionList_Defensive() then return true end
      if actionList_Interrupts() then return true end
      if actionList_Cooldowns() then return true end
      if ttd("target") < vulnWindow and #enemies.yards8t == 1 and not isDummy("target") then
        if actionList_TargetDie() then return true end
      end
      if actionList_PatientSniper() then return true end
    end
    return false
  end

  ------------------
  --- START HERE ---
  ------------------
  if marksmanRotation() then return true end
  return false

end -- End runRotation
--local id = 254 -- Change to the spec id profile is for.
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
  name = rotationName,
  toggles = createToggles,
  options = createOptions,
  run = runRotation,
})

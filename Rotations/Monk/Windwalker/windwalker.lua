local rotationName = "P.I.M.P"
local br = br
br.monkTables = {}
local monkTables = br.monkTables
monkTables.enemyTable5,
  monkTables.enemyTable8,
  monkTables.enemyTable20,
  monkTables.burnTable5,
  monkTables.moclist5,
  monkTables.foftable = {}, {}, {}, {}, {}, {}
local enemyTable5,
  enemyTable8,
  enemyTable20,
  burnTable5,
  moclist5,
  foftable = monkTables.enemyTable5, monkTables.enemyTable8, monkTables.enemyTable20, monkTables.burnTable5, monkTables.moclist5, monkTables.foftable

-------- TODO
--wdp abuse
--hitcombo
--bok!
--drawing
--hold cds
---------------
--- Toggles ---
---------------
local function createToggles()
  -- Rotation Button
  RotationModes = {
    [1] = {mode = "", value = 1, overlay = "", tip = "", highlight = 1, icon = br.player.spell.risingSunKick},
    [2] = {mode = "", value = 2, overlay = "", tip = "", highlight = 0, icon = br.player.spell.risingSunKick}
  }
  CreateButton("Rotation", 1, 0)
  CleaveModes = {
    [1] = {mode = "", value = 1, overlay = "", tip = "Everything", highlight = 1, icon = br.player.spell.spinningCraneKick},
    [2] = {mode = "", value = 2, overlay = "", tip = "Cleave", highlight = 0, icon = br.player.spell.whirlingDragonPunch},
    [3] = {mode = "", value = 3, overlay = "", tip = "ST only", highlight = 0, icon = br.player.spell.tigerPalm}
  }
  CreateButton("Cleave", 1, 1)
  OpenerModes = {
    [1] = {mode = "", value = 1, overlay = "", tip = "", highlight = 1, icon = br.player.spell.touchOfDeath},
    [2] = {mode = "", value = 2, overlay = "", tip = "", highlight = 0, icon = br.player.spell.touchOfDeath}
  }
  CreateButton("Opener", 2, 1)
  SpecialModes = {
    [1] = {mode = "", value = 1, overlay = "", tip = "", highlight = 1, icon = br.player.spell.serenity},
    [2] = {mode = "", value = 2, overlay = "", tip = "", highlight = 0, icon = br.player.spell.serenity}
  }
  CreateButton("Special", 2, 0)
  -- Defensive Button
  DefensiveModes = {
    [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dampenHarm},
    [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dampenHarm}
  }
  CreateButton("Defensive", 3, 0)
  -- Interrupt Button
  InterruptModes = {
    [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.spearHandStrike},
    [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.spearHandStrike}
  }
  CreateButton("Interrupt", 4, 0)
  -- Storm, Earth, and Fire Button
  SEFModes = {
    [1] = {mode = "Boss", value = 1, overlay = "Auto SEF on Boss Only", tip = "Will cast Storm, Earth and Fire on Bosses only.", highlight = 1, icon = br.player.spell.stormEarthAndFireFixate},
    [2] = {mode = "On", value = 2, overlay = "Auto SEF Enabled", tip = "Will cast Storm, Earth, and Fire.", highlight = 0, icon = br.player.spell.stormEarthAndFire},
    [3] = {mode = "Off", value = 3, overlay = "Auto SEF Disabled", tip = "Will NOT cast Storm, Earth, and Fire.", highlight = 0, icon = br.player.spell.stormEarthAndFireFixate}
  }
  CreateButton("SEF", 5, 0)
  -- Flying Serpent Kick Button
  FSKModes = {
    [1] = {mode = "On", value = 2, overlay = "Auto FSK Enabled", tip = "Will cast Flying Serpent Kick.", highlight = 1, icon = br.player.spell.flyingSerpentKick},
    [2] = {mode = "Off", value = 1, overlay = "Auto FSK Disabled", tip = "Will NOT cast Flying Serpent Kick.", highlight = 0, icon = br.player.spell.flyingSerpentKickEnd}
  }
  CreateButton("FSK", 6, 0)
  --
  FOFModes = {
    [1] = {mode = "On", value = 1, overlay = "FoF Enabled", tip = "Will cast Fists Of Fury.", highlight = 1, icon = br.player.spell.fistsOfFury},
    [2] = {mode = "Off", value = 2, overlay = "FoF Disabled", tip = "Will NOT cast Fists Of Fury.", highlight = 0, icon = br.player.spell.fistsOfFury}
  }
  CreateButton("FOF", 7, 0)
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
    section = br.ui:createSection(br.ui.window.profile, "General")
    -- APL
    -- br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC", "|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
    -- Dummy DPS Test
    -- br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
    -- Opener
    -- br.ui:createCheckbox(section, "Opener")
    -- Pre-Pull Timer
    br.ui:createSpinner(section, "Pre-Pull Timer", 5, 1, 10, 1, "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
    -- CJL OOR
    -- br.ui:createSpinner(section, "CJL OOR", 100, 5, 160, 5, "Cast CJL when 0 enemies in 8 yds when at X Energy")
    -- Cancel CJL OOR
    -- br.ui:createSpinnerWithout(section, "CJL OOR Cancel", 30, 5, 160, 5, "Cancel CJL OOR when under X Energy")
    -- Chi Burst
    -- br.ui:createSpinnerWithout(section, "Chi Burst Min Units", 1, 1, 10, 1, "|cffFFFFFFSet to the minumum number of units to cast Chi Burst on.")
    -- FoF Targets
    -- br.ui:createSpinnerWithout(section, "Fists of Fury Targets", 1, 1, 10, 1, "|cffFFFFFFSet to the minumum number of units to cast Fists of Fury on.")
    -- Provoke
    -- br.ui:createCheckbox(section, "Provoke", "Will aid in grabbing mobs when solo.")
    -- Roll
    -- br.ui:createCheckbox(section, "Roll")
    -- Spread Mark Cap
    br.ui:createSpinnerWithout(section, "Spread Mark Cap", 5, 0, 10, 1, "|cffFFFFFFSet to limit Mark of the Crane Buffs, 0 for unlimited. Min: 0 / Max: 10 / Interval: 1")
    br.ui:createSpinnerWithout(section, "FoF TTD", 1, 1, 15, 1, "FoF Time To Die")
    -- Tiger's Lust
    br.ui:createCheckbox(section, "Tiger's Lust")
    -- Whirling Dragon Punch
    br.ui:createCheckbox(section, "Whirling Dragon Punch")
    -- Whirling Dragon Punch Targets
    br.ui:createSpinnerWithout(section, "Whirling Dragon Punch Targets", 1, 1, 10, 1, "|cffFFFFFFSet to the minumum number of units to cast Whirling Dragon Punch on.")
    br.ui:createCheckbox(section, "|cffFF0000Force Burn Stuff", "Ghuunies/explosives orb = rip")
    -- br.ui:createCheckbox(section, "Autotarget", "Autotarget")
    br.ui:createCheckbox(section, "Hold cds", "Hold cds")
    br.ui:createCheckbox(section, "Debug", "Debug")
    br.ui:createCheckbox(section, "BlackoutKick execute", "BlackoutKick execute")
    br.ui:createCheckbox(section, "ToD PVP", "ToD PVP")
    br.ui:createCheckbox(section, "WDP abuse", "WDP abuse")
    br.ui:createCheckbox(section, "WDP when moving", "WDP when moving")

    br.ui:checkSectionState(section)
    ------------------------
    --- COOLDOWN OPTIONS ---
    ------------------------
    section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
    -- Flask / Crystal
    -- br.ui:createCheckbox(section, "Flask / Crystal")
    -- Potion
    br.ui:createCheckbox(section, "Potion")
    -- Racial
    br.ui:createCheckbox(section, "Racial")
    -- Touch of the Void
    -- br.ui:createCheckbox(section, "Touch of the Void")
    -- Trinkets
    br.ui:createCheckbox(section, "Trinkets")
    -- Energizing Elixir
    -- br.ui:createDropdownWithout(section, "Energizing Elixir", {"|cff00FF00Everything", "|cffFFFF00Cooldowns", "|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Energizing Elixir.")
    -- SEF Timer/Behavior
    br.ui:createSpinnerWithout(section, "SEF Timer", 0.3, 0, 1, 0.05, "|cffFFFFFFDesired time in seconds to resume rotation after casting SEF so clones can get into place. This value changes based on different factors so requires some testing to find what works best for you.")
    br.ui:createSpinner(section, "Minimum SEF targets", 1, 0, 10, 1, "|cffFFFFFFNumber of enemies for SEF use")

    br.ui:createDropdownWithout(section, "SEF Behavior", {"|cff00FF00Fixate", "|cffFFFF00Go Ham!"}, 1, "|cffFFFFFFStorm, Earth, and Fire Behavior.")
    -- Serenity
    -- br.ui:createDropdownWithout(section, "Serenity", {"|cff00FF00Everything", "|cffFFFF00Cooldowns", "|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Serenity.")
    -- Touch of Death
    br.ui:createCheckbox(section, "Touch of Death")
    -- Xuen
    br.ui:createCheckbox(section, "Xuen")

    br.ui:checkSectionState(section)
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = br.ui:createSection(br.ui.window.profile, "Defensive")
    -- Healthstone
    br.ui:createSpinner(section, "Healing Potion/Healthstone", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
    -- Heirloom Neck
    br.ui:createSpinner(section, "Heirloom Neck", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
    -- Detox
    br.ui:createCheckbox(section, "Detox")
    -- Diffuse Magic/Dampen Harm
    br.ui:createSpinner(section, "Diffuse/Dampen", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
    -- Effuse
    br.ui:createSpinner(section, "Vivify", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
    -- Leg Sweep
    br.ui:createSpinner(section, "Leg Sweep - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
    br.ui:createSpinner(section, "Leg Sweep - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
    -- Resuscitate
    br.ui:createDropdown(section, "Resuscitate", {"|cff00FF00Target", "|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
    -- Touch of Karma
    br.ui:createSpinner(section, "Touch of Karma", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
    br.ui:createCheckbox(section, "Touch of Karma for Insidious Gift at 20stacks")

    br.ui:checkSectionState(section)
    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = br.ui:createSection(br.ui.window.profile, "Interrupts")
    -- Spear Hand Strike
    br.ui:createCheckbox(section, "Spear Hand Strike")
    -- Paralysis
    br.ui:createCheckbox(section, "Paralysis")
    -- Leg Sweep
    br.ui:createCheckbox(section, "Leg Sweep")
    -- Interrupt Percentage
    br.ui:createSpinner(section, "InterruptAt", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
    br.ui:checkSectionState(section)
    ----------------------
    --- TOGGLE OPTIONS ---
    ----------------------
    section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
    -- Single/Multi Toggle
    br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle, 4)
    --Cooldown Key Toggle
    br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle, 3)
    --Defensive Key Toggle
    br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle, 6)
    -- Interrupts Key Toggle
    br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
    -- SEF Toggle
    br.ui:createDropdown(section, "SEF Mode", br.dropOptions.Toggle, 5)
    -- FSK Toggle
    br.ui:createDropdown(section, "FSK Mode", br.dropOptions.Toggle, 5)
    -- Pause Toggle
    br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
    br.ui:checkSectionState(section)
  end
  optionTable = {
    {
      [1] = "Rotation Options",
      [2] = rotationOptions
    }
  }
  return optionTable
end

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
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
-- f:RegisterEvent("UNIT_SPELLCAST_SENT")
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
--f:RegisterEvent("UNIT_AURA")
-- f:RegisterEvent("NAME_PLATE_UNIT_ADDED")
-- f:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
f:SetScript(
  "OnEvent",
  function(self, event, ...)
    -- if event == NAME_PLATE_UNIT_ADDED(unit) then
    --     check[guid(unit)] = unit
    -- end
    -- if event == NAME_PLATE_UNIT_REMOVED(unit) then
    --     check[guid(unit)] = nil
    -- end
    -- if event == "UNIT_AURA" then
    --     local source    = select(1,...)
    --     if source == "player" then
    --         CastSpellByID(152175)
    --     end
    -- end
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
      local source = select(1, ...)
      local spell = select(3, ...)
      if source == "player" then
        if spell == 100780 then
          lastcombo = "tigerPalm"
        elseif spell == 261947 then
          lastcombo = "fistOfTheWhiteTiger"
        elseif spell == 100784 then
          lastcombo = "blackoutKick"
        elseif spell == 123986 then
          lastcombo = "chiBurst"
        elseif spell == 115098 then
          lastcombo = "chiWave"
        elseif spell == 117952 then
          lastcombo = "cracklingJadeLightning"
        elseif spell == 113656 then
          lastcombo = "fistsOfFury"
        elseif spell == 101545 then
          lastcombo = "flyingSerpentKick"
        elseif spell == 107428 then
          lastcombo = "risingSunKick"
        elseif spell == 116847 then
          lastcombo = "rushingJadeWind"
        elseif spell == 101546 then
          lastcombo = "spinningCraneKick"
        elseif spell == 115080 then
          lastcombo = "touchOfDeath"
        elseif spell == 152175 then
          lastcombo = "whirlingDragonPunch"
        end
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
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
      local _,
        eventType,
        hideCaster,
        sourceGUID,
        srcName,
        sourceFlags,
        sourceRaidFlags,
        destGUID,
        destName,
        destFlags,
        destRaidFlags,
        spellID,
        spellName,
        _,
        param1,
        _,
        _,
        param4 = CombatLogGetCurrentEventInfo()
      if eventType == "SPELL_AURA_APPLIED" and srcName == UnitName("player") then
        if spellID == 137639 then
          -- print("start")
          sefend = GetTime() + 15
        end
      end
      if eventType == "SPELL_AURA_REMOVED" and srcName == UnitName("player") then
        if spellID == 137639 then
          -- print("end")
          sefend = nil
        end
      end
    --     -- if eventType == "SWING_DAMAGE" and srcName == UnitName("player") then
    --     --     shadtechn = shadtechn + 1
    --     -- end
    --     -- if eventType == "SPELL_DAMAGE" and srcName == UnitName("player") then
    --     --     if spellID == 121473 then
    --     --         shadtechn = shadtechn + 1
    --     --     end
    --     -- end
    --     -- if eventType == "SPELL_ENERGIZE" and srcName == UnitName("player") and spellID == 196911 then
    --     --      shadtechn = 0
    --     -- end
    --     -- if eventType == "SPELL_CAST_START" then
    --     --     spellonPlayerTEndTime, _, _, _, spellonPlayer = select(5,UnitCastingInfo(GetObjectWithGUID(sourceGUID)))
    --     --     local finishTime = spellonPlayerTEndTime - GetTime()
    --     --     tinsert(incomingskillz,{id = spellID, unit = GetObjectWithGUID(sourceGUID), time = spellonPlayerTEndTime})
    --     --     print(CombatLogGetCurrentEventInfo())
    --     --     print(finishTime)
    --     -- end
    --     if eventType == "SPELL_CAST_SUCCESS" and destGUID == UnitGUID("player") then
    --         --print(spellID)
    --     end
    end
  end
)

----------------
--- ROTATION ---
----------------
local function runRotation()
  --if br.timer:useTimer("debugWindwalker", math.random(0.15,0.3)) then
  --Print("Running: "..rotationName)
  ---------------
  --- Toggles ---
  ---------------
  UpdateToggle("Rotation", 0.25)
  UpdateToggle("Defensive", 0.25)
  UpdateToggle("Interrupt", 0.25)
  br.player.mode.cleave = br.data.settings[br.selectedSpec].toggles["Cleave"]
  br.player.mode.sef = br.data.settings[br.selectedSpec].toggles["SEF"]
  br.player.mode.fsk = br.data.settings[br.selectedSpec].toggles["FSK"]
  br.player.mode.fof = br.data.settings[br.selectedSpec].toggles["FOF"]
  br.player.mode.opener = br.data.settings[br.selectedSpec].toggles["Opener"]
  br.player.mode.special = br.data.settings[br.selectedSpec].toggles["Special"]

  --------------
  --- Locals ---
  --------------
  local buff = br.player.buff
  local cast = br.player.cast
  local cd = br.player.cd
  local charges = br.player.charges
  local chi = br.player.power.chi.amount()
  local chiDeficit = br.player.power.chi.deficit()
  local chiMax = br.player.power.chi.max()
  local combatTime = getCombatTime()
  local debuff = br.player.debuff
  local enemies = br.player.enemies
  local energy = br.player.power.energy.amount()
  local equiped = br.player.equiped
  local gcd = getSpellCD(61304)  
  local has = br.player.has
  local healthPot = getHealthPot() or 0
  local inCombat = br.player.inCombat
  local inRaid = select(2, IsInInstance()) == "raid"
  local level = br.player.level
  local mode = br.player.mode
  local moving = isMoving("player") ~= false or br.player.moving
  local php = br.player.health
  local power, powerDeficit, powerRegen = br.player.power.energy.amount(), br.player.power.energy.deficit(), br.player.power.energy.regen()
  local powerMax = br.player.power.energy.max()
  -- local pullTimer = br.DBM:getPulltimer()
  local race = br.player.race
  local solo = select(2, IsInInstance()) == "none"
  local spell = br.player.spell
  local talent = br.player.talent
  local thp = getHP("target")
  local trait = br.player.traits
  local ttm = br.player.power.energy.ttm()
  local units = br.player.units
  local use = br.player.use

  local spread = false
  if GetKeyState(16) then
    spread = true
  end
  local fotwtcd = cd.fistOfTheWhiteTiger.remain()
  local todcd = cd.touchOfDeath.remain()
  local rskcd = cd.risingSunKick.remain()
  local fofcd = cd.fistsOfFury.remain()
  local wdpcd = cd.whirlingDragonPunch.remain()
  local sefcd = cd.stormEarthAndFire.remain()
  local sckcast = 1.5 / (1 + (GetHaste()/100))
  local fofcast = 4 / (1 + (GetHaste()/100))
    -- print(sckcast)
  -- units.get(5)
  -- enemies.get(5)
  -- enemies.get(8)
  -- enemies.yards12r = getEnemiesInRect(10,12,false) or 0
  -- enemies.yards8c = getEnemiesInCone(45, 8,false, false) or 0
  enemies.get(20, nil, nil, nil, spell.touchOfKarma)
  enemies.get(20, nil, true, nil, spell.touchOfKarma)
  enemies.get(40, nil, true, nil, spell.cracklingJadeLightning)

  if leftCombat == nil then
    leftCombat = GetTime()
  end
  if profileStop == nil then
    profileStop = false
  end

  if mode.opener == 2 or opener == nil then
    open1 = false
    open2 = false
    open3 = false
    open4 = false
    open5 = false
    open6 = false
    open7 = false
    open8 = false
    opener = false
  end

  function getTimeTo50(Unit)
    local max = 50
    local curr = UnitPower(Unit)
    local curr2 = curr
    local _, regen = GetPowerRegen(Unit)
    if select(3, UnitClass("player")) == 11 and GetSpecialization() == 2 and isKnown(114107) then
      curr2 = curr + 4 * getCombo()
    end
    if curr >= 50 then return 0 end
    return (max - curr2) * (1.0 / regen)
  end

  function EnergyRemainingCastRegen()
    -- If we are casting, we check what we will regen until the end of the cast
    if UnitCastingInfo("player") then 
      return powerRegen * (select(5, UnitCastingInfo("player")) - GetTime())
    elseif UnitChannelInfo("player") then
      return powerRegen * (select(5, UnitChannelInfo("player")) - GetTime())
    else
      return powerRegen * gcd 
    end
  end

  -- Predict the expected Energy at the end of the Cast/GCD.
  function EnergyP()
    return math.min(powerMax, power + EnergyRemainingCastRegen())
  end

  function EnergyDeficitPredicted()
    return math.max(0, powerDeficit - EnergyRemainingCastRegen())
end

  function ttmP(energy)
    local EnergyDeficitPredicted = EnergyDeficitPredicted()
    if energy ~= nil then
      EnergyDeficitPredicted = energy - EnergyP()
    end
    if EnergyDeficitPredicted <= 0 then
      return 0
    end
    return EnergyDeficitPredicted / powerRegen
  end

  local function cangetchitp(time)
    -- if time == nil then return end
    local time = math.floor(time)
    local total = EnergyP() 
    local chigot = chi
    local checktime = 0
    local last = false
    -- if lastCombo == "tigerPalm" then
    --   last = true
    -- end
    while checktime < time do
      if total >= 50 and not last then
        total = total - 50
        chigot = chigot + 2
        last = true
      else
        if chigot >= 1 and last then
          chigot = chigot - 1
          last = false
        end
      end
      total = total + powerRegen
      checktime = checktime + 1
    end
    return chigot 
  end
  
  -- print(ttmP(50))
  -- print(getTimeTo50("player")) 
  -- Rushing Jade Wind - Cancel
  if talent.rushingJadeWind and not inCombat and buff.rushingJadeWind.exists() then
    if buff.rushingJadeWind.cancel() then
      return true
    end
  end

  -- local function ShouldBlackout()
  --   if fofcd <= 10 then
  --     fofcd
  --   end

  -- end




  local forcekill = {
    [120651] = true -- explosive orb
    --[141851] = true, -- ghuunies
    --[144081] = true
  }
  -- local holdwdp, holdrsk, holdfof
  --_____________________________________
  local function ttd(unit)
    if UnitIsPlayer(unit) then
      return 999
    end
    local ttdSec = getTTD(unit)
    if getOptionCheck("Enhanced Time to Die") then
      return ttdSec
    end
    if ttdSec == -1 then
      return 999
    end
    return ttdSec
  end

  local function getapdmg(offHand)
    local useOH = offHand or false
    local wdpsCoeff = 6
    local ap = UnitAttackPower("player")
    local minDamage,
      maxDamage,
      minOffHandDamage,
      maxOffHandDamage,
      physicalBonusPos,
      physicalBonusNeg,
      percent = UnitDamage("player")
    local speed,
      offhandSpeed = UnitAttackSpeed("player")
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

  local function bkdamage()
    local apMod = getapdmg()
    local bkcoef = 0.77
    local auramult = 1.1
    local versmult = (1 + ((GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100))
    --if talent.DeeperStratagem then dsmod = 1.05 else dsmod = 1 end
    return (apMod * bkcoef * auramult * versmult)
  end

  local function isTotem(unit)
    local eliteTotems = {
      -- totems we can dot
      [125977] = "Reanimate Totem",
      [127315] = "Reanimate Totem",
      [146731] = "Zombie Dust Totem"
    }
    local creatureType = UnitCreatureType(unit)
    local objectID = GetObjectID(unit)
    if creatureType ~= nil and eliteTotems[objectID] == nil then
      if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then
        return true
      end
    end
    return false
  end

  local function noDotCheck(unit)
    if isChecked("Dot Blacklist") and (noDotUnits[GetObjectID(unit)] or UnitIsCharmed(unit)) then
      return true
    end
    if isTotem(unit) then
      return true
    end
    local unitCreator = UnitCreator(unit)
    if unitCreator ~= nil and UnitIsPlayer(unitCreator) ~= nil and UnitIsPlayer(unitCreator) == true then
      return true
    end
    if GetObjectID(unit) == 137119 and getBuffRemain(unit, 271965) > 0 then
      return true
    end
    return false
  end
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  local function clearTable(t)
    local count = #t
    for i = 0, count do
      t[i] = nil
    end
  end
  -- if getDistance("target") <= 8 then
  --   print(getDistance("target"))
  -- end
  clearTable(enemyTable5)
  clearTable(enemyTable8)
  clearTable(enemyTable20)
  clearTable(burnTable5)
  clearTable(moclist5)
  if #enemies.yards20 > 0 then
    local highestHP
    local lowestHP
    for i = 1, #enemies.yards20 do
      local thisUnit = enemies.yards20[i]
      if not UnitIsDeadOrGhost(thisUnit) then
        local enemyUnit = {}
        enemyUnit.unit = thisUnit
        enemyUnit.ttd = ttd(thisUnit)
        enemyUnit.hpabs = UnitHealth(thisUnit)
        enemyUnit.id = GetObjectID(enemyUnit.unit)
        if IsSpellInRange(GetSpellInfo(116705), enemyUnit.unit) == 1 then
          enemyUnit.distance = 5
          if (isChecked("|cffFF0000Force Burn Stuff") or spread) and forcekill[enemyUnit.id] then
            tinsert(burnTable5, enemyUnit)
          end
        elseif IsSpellInRange(GetSpellInfo(113656), enemyUnit.unit) == 1 then
          enemyUnit.distance = getDistance(enemyUnit.unit)
        else
          enemyUnit.distance = 19
        end

        -- enemyUnit.id
        -- if forc
        tinsert(enemyTable20, enemyUnit)
        if highestHP == nil or highestHP < enemyUnit.hpabs then
          highestHP = enemyUnit.hpabs
        end
        if lowestHP == nil or lowestHP > enemyUnit.hpabs then
          lowestHP = enemyUnit.hpabs
        end
        -- if lowestMark == nil or lowestMark >
        if enemyTable20.lowestTTDUnit == nil or enemyTable20.lowestTTD > enemyUnit.ttd then
          enemyTable20.lowestTTDUnit = enemyUnit.unit
          enemyTable20.lowestTTD = enemyUnit.ttd
        end
      end
    end

    if #enemyTable20 > 1 then
      for i = 1, #enemyTable20 do
        local hpNorm = (10 - 1) / (highestHP - lowestHP) * (enemyTable20[i].hpabs - highestHP) + 10 -- normalization of HP value, high is good
        if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0 / 0) then
          hpNorm = 0
        end -- NaN check
        local enemyScore = hpNorm
        -- if enemyTable20[i].facing then enemyScore = enemyScore + 30 end -- ??
        if enemyTable20[i].ttd > 1.5 then
          enemyScore = enemyScore + 5
        end
        if enemyTable20[i].distance <= 5 then
          enemyScore = enemyScore + 30
        end
        local raidTarget = GetRaidTargetIndex(enemyTable20[i].unit)
        if raidTarget ~= nil then
          enemyScore = enemyScore + raidTarget * 3
          if raidTarget == 8 then
            enemyScore = enemyScore + 5
          end
        end
        --if UnitBuffID(enemyTable30[i].unit, 277242) then enemyScore = enemyScore + 50 end -- ghuun check
        -- ToD Priority
        if UnitBuffID(enemyTable20[i].unit, 115080) then
          enemyScore = enemyScore + 50
        end 
        enemyTable20[i].enemyScore = enemyScore
      end
      table.sort(
        enemyTable20,
        function(x, y)
          return x.enemyScore > y.enemyScore
        end
      )
    -- moclist = enemyTable30
    -- local mokduration =  getDebuffRemain()
    end

    for i = 1, #enemyTable20 do
      local thisUnit = enemyTable20[i]
      if thisUnit.distance <= 8 then
        tinsert(enemyTable8, thisUnit)
      end
      if thisUnit.distance <= 5 then
        tinsert(enemyTable5, thisUnit)
        tinsert(moclist5, thisUnit)
      end
    end
    if #enemyTable5 > 1 then
      table.sort(
        enemyTable5,
        function(x)
          if GetUnitIsUnit(x.unit, "target") then
            return true
          else
            return false
          end
        end
      )
      for i = 1, #moclist5 do
        local thisUnit = moclist5[i].unit
        moclist5[i].mocDuration = debuff.markOfTheCrane.remain(thisUnit)
        -- tinsert(moclist5[i],mocDuration)
      end

      table.sort(
        moclist5,
        function(x, y)
          return x.mocDuration < y.mocDuration
        end
      )
    end

    if inCombat and #enemyTable5 > 0 and ((GetUnitExists("target") and UnitIsDeadOrGhost("target") and not GetUnitIsUnit(enemyTable5[1].unit, "target")) or not GetUnitExists("target")) then
      TargetUnit(enemyTable5[1].unit)
    end
  end
  --Just nil fixes
  if enemyTable20.lowestTTD == nil then
    enemyTable20.lowestTTD = 999
  end

  local function ChiBurstBestRect()
    local function getRectUnit(facing)
      width = 7
      length = 40
      local x, y, z = ObjectPosition("player")
      local facing = facing or 0
      local halfWidth = width/2
      -- Near Left
      local nlX, nlY, nlZ = GetPositionFromPosition(x, y, z, halfWidth, facing + rad(90), 0)
      -- Near Right
      local nrX, nrY, nrZ = GetPositionFromPosition(x, y, z, halfWidth, facing + rad(270), 0)
      -- Far Left
      local flX, flY, flZ = GetPositionFromPosition(nlX, nlY, nlZ, length, facing, 0)
      -- Far Right
      local frX, frY, frZ = GetPositionFromPosition(nrX, nrY, nrZ, length, facing, 0)
        return nlX, nlY, nrX, nrY, frX, frY, flX, flY, flZ, nlZ, nrZ, frZ
    end
    local function isInside(x,y,ax,ay,bx,by,dx,dy)
        local bax = bx - ax
        local bay = by - ay
        local dax = dx - ax
        local day = dy - ay
        if ((x - ax) * bax + (y - ay) * bay <= 0.0) then return false end
        if ((x - bx) * bax + (y - by) * bay >= 0.0) then return false end
        if ((x - ax) * dax + (y - ay) * day <= 0.0) then return false end
        if ((x - dx) * dax + (y - dy) * day >= 0.0) then return false end
        return true
    end
    if moving or isTotem("target") or GetObjectID("target") == 120651 then return end

    if not isKnown(123986) or getSpellCD(123986) ~= 0 then
      return false
    end
    local curFacing = ObjectFacing("player")
    local x, y, z = ObjectPosition("player")
   
    local facing, bestAngle, bestAngleUnitsHit = 0.1, 0, 0
    while facing <= 6.2 do
      local unitsInRect = 0
      local nlX, nlY, nrX, nrY, frX, frY, flX, flY, flZ, nlZ, nrZ, frZ = getRectUnit(facing)
      for i = 1, #enemies.yards40nc do
        local uX, uY, uZ = ObjectPosition(enemies.yards40nc[i])
        if isInside(uX,uY,nlX,nlY,nrX,nrY,frX,frY) then
          if UnitAffectingCombat(enemies.yards40nc[i]) and TraceLine(x, y, z, uX, uY, uZ , 0x100111) then
            unitsInRect = 0
            break
          end
          unitsInRect = unitsInRect + 1
        end
      end
      if unitsInRect > bestAngleUnitsHit then
        bestAngleUnitsHit = unitsInRect
        bestAngle = facing
      end
      facing = facing + 0.05
    end
      -- print(bestAngleUnitsHit .. "      " ..bestAngle)
      if bestAngleUnitsHit >= 1 then
        FaceDirection(bestAngle, true)
        CastSpellByName(GetSpellInfo(123986))
        FaceDirection(curFacing)
        return true
      else
        return false
      end
  end
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- stolen from mr daddy fisker

  


  local function cast5yards(skill, pewpew)
    if (skill == "risingSunKick" and holdrsk) then return end
    if #burnTable5 > 0 then
      for i = 1, #burnTable5 do
        local thisUnit = burnTable5[i].unit
        if pewpew ~= nil then
          if cast[skill](thisUnit) then
            if isChecked("Debug") then
              print("5 yards" .. pewpew .. "burn")
            end
            return true
          end
        end
      end
    end
    if mode.cleave < 3 then
      for i = 1, #moclist5 do
        local thisUnit = moclist5[i].unit
        if pewpew ~= nil then
          if cast[skill](thisUnit) then
            if isChecked("Debug") then
              print("5 yards" .. pewpew)
            end
            return true
          end
        end
      end
    else
      for i = 1, #enemyTable5 do
        local thisUnit = enemyTable5[i].unit
        if pewpew ~= nil then
          if cast[skill](thisUnit) then
            if isChecked("Debug") then
              print("5 yards" .. pewpew)
            end
            return true
          end
        end
      end
    end
  end

  local function cast8yards(skill, pewpew)
    if #enemyTable8 == 0 or isTotem("target") or GetObjectID("target") == 120651 or #burnTable5 > 0 then return end
    if skill == "whirlingDragonPunch" then
      if holdwdp or spread then return 
      else
        if cast.whirlingDragonPunch("player") then
          return true
        end
      end
    else
      if pewpew ~= nil then
        if cast[skill](thisUnit) then
          if isChecked("Debug") then
            print("5 yards" .. pewpew)
          end
          return true
        end
      end
    end
  end
  --------------------
  --- Action Lists ---
  --------------------
  -- Action List - Extras
  local function actionList_Extras()
    -- Tiger's Lust
    if isChecked("Tiger's Lust") then
      if hasNoControl() or (inCombat and getDistance("target") > 10 and isValidUnit("target")) then
        if cast.tigersLust() then
          return true
        end
      end
    end
    -- Resuscitate
    if isChecked("Resuscitate") then
      if getOptionValue("Resuscitate") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player") then
        if cast.resuscitate("target") then
          return true
        end
      end
      if getOptionValue("Resuscitate") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover", "player") then
        if cast.resuscitate("mouseover") then
          return true
        end
      end
    end
    -- Provoke
    if isChecked("Provoke") and not inCombat and select(3, GetSpellInfo(101545)) ~= "INTERFACE\\ICONS\\priest_icon_chakra_green" and cd.flyingSerpentKick.remain() > 1 and getDistance("target") > 10 and isValidUnit("target") and not isBoss("target") then
      if solo or #br.friend == 1 then
        if cast.provoke() then
          return true
        end
      end
    end
    -- Flying Serpent Kick
    if mode.fsk == 1 then
      -- if cast.flyingSerpentKick() then return true end
      if fskcancel ~= nil then
        CastSpellByID(101545)
      end
    end
    -- Roll
    if isChecked("Roll") and getDistance("target") > 10 and isValidUnit("target") and getFacingDistance() < 5 and getFacing("player", "target", 10) then
      if cast.roll() then
        return true
      end
    end
    -- Dummy Test
    -- Crackling Jade Lightning
    -- if isChecked("CJL OOR") and (lastCombo ~= spell.cracklingJadeLightning or buff.hitCombo.stack() <= 1) and #enemies.yards8 == 0 and not isCastingSpell(spell.cracklingJadeLightning) and (hasThreat("target") or isDummy()) and not moving and power >= getOptionValue("CJL OOR") then
    --     if cast.cracklingJadeLightning() then return true end
    --  end
    -- Touch of the Void
    -- if (useCDs() or useAoE()) and isChecked("Touch of the Void") and inCombat and #enemies.yards8 > 0 then
    --     if hasEquiped(128318) then
    --         if GetItemCooldown(128318)==0 then
    --             useItem(128318)
    --         end
    --     end
    -- end
    -- Fixate - Storm, Earth, and Fire
    -- if cast.able.stormEarthAndFireFixate("target") and getOptionValue("SEF Behavior") == 1
    --     and not talent.serenity and not cast.current.fistsOfFury() and not UnitIsUnit(fixateTarget,"target")
    -- then
    --     if cast.stormEarthAndFireFixate("target") then fixateTarget = ObjectPointer("target") return true end
    -- end
  end -- End Action List - Extras
  -- Action List - Defensive
  local function actionList_Defensive()
    -- Pot/Stoned
    if isChecked("Healing Potion/Healthstone") and (use.able.healthstone() or canUse(152494)) and php <= getOptionValue("Healing Potion/Healthstone") and inCombat and (hasItem(152494) or has.healthstone()) then
      if use.able.healthstone() then
        use.healthstone()
      elseif canUse(152494) then
        useItem(152494)
      end
    end
    -- Heirloom Neck
    if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
      if hasEquiped(122668) then
        if GetItemCooldown(122668) == 0 then
          useItem(122668)
        end
      end
    end
    -- Dampen Harm
    if isChecked("Diffuse/Dampen") and php <= getValue("Dampen Harm") and inCombat then
      if cast.dampenHarm() then
        return true
      end
    end
    -- Diffuse Magic
    if isChecked("Diffuse/Dampen") and ((php <= getValue("Diffuse Magic") and inCombat) or canDispel("player", br.player.spell.diffuseMagic)) then
      if cast.diffuseMagic() then
        return true
      end
    end
    -- Detox
    if isChecked("Detox") then
      if canDispel("player", spell.detox) then
        if cast.detox("player") then
          return true
        end
      end
      if UnitIsPlayer("mouseover") and not UnitIsDeadOrGhost("mouseover") then
        if canDispel("mouseover", spell.detox) then
          if cast.detox("mouseover") then
            return true
          end
        end
      end
    end
    -- Leg Sweep
    -- if isChecked("Leg Sweep - HP") and php <= getOptionValue("Leg Sweep - HP") and inCombat and #enemies.yards5 > 0 then
    --     if cast.legSweep() then return true end
    -- end
    -- if isChecked("Leg Sweep - AoE") and #enemies.yards5 >= getOptionValue("Leg Sweep - AoE") then
    --     if cast.legSweep() then return true end
    -- end
    -- Touch of Karma
    if isChecked("Touch of Karma") and php <= getOptionValue("Touch of Karma") and inCombat and IsUsableSpell(spell.touchOfKarma) then
      if cast.touchOfKarma("target") then
      end
    end
    if isChecked("Touch of Karma for Insidious Gift at 20stacks") and IsUsableSpell(spell.touchOfKarma) then
      if getDebuffStacks("player", 295410) >= 20 then
        if cast.touchOfKarma("target") then
        end
      end
    end

    -- Vivify
    if isChecked("Vivify") and php <= getOptionValue("Vivify") and not inCombat and cast.able.vivify() then
      if cast.vivify() then
        return true
      end
    end
  end -- End Action List - Defensive
  -- Action List - Interrupts
  local function actionList_Interrupts()
    for i = 1, #enemyTable5 do
      thisUnit = enemyTable5[i].unit
      distance = enemyTable5[i].distance
      if canInterrupt(thisUnit, getOptionValue("InterruptAt")) then
        if isChecked("Spear Hand Strike") and cast.able.spearHandStrike(thisUnit) and distance < 5 then
          if cast.spearHandStrike(thisUnit) then
            return true
          end
        end
        -- Leg Sweep
        if isChecked("Leg Sweep") and cast.able.legSweep(thisUnit) and (distance < 5 or (talent.tigerTailSweep and distance < 7)) then
          if cast.legSweep(thisUnit) then
            return true
          end
        end
        -- Paralysis
        if isChecked("Paralysis") and cast.able.paralysis(thisUnit) then
          if cast.paralysis(thisUnit) then
            return true
          end
        end
      end
    end
  end -- End Action List - Interrupts

  local function CheckCDS()
    holdfof = false
    holdrsk = false
    holdwdp = false
    holdsef = false
    if isChecked("Hold cds") and todcd <= 30 then
      if not isChecked("WDP abuse") then
        if wdpcd + 22 >= todcd then
          --print("holdwdp = true")
          holdwdp = true
        end
      end
      if rskcd + 9 >= todcd then
        --print("holdrsk = true")
        holdrsk = true
      end
      if fofcd + 17 >= todcd then
        print("holdfof = true")
        holdfof = true
      end
    end
    if isChecked("WDP abuse") and buff.stormEarthAndFire.exists() then
      local sefremains = buff.stormEarthAndFire.remain()
      holdwdp = true
      if buff.stormEarthAndFire.exists() and sefremains < 0.2 then
        CastSpellByID(152175,"player")
      end
      if sefremains >= 5 and sefremains <= 11 then
        holdrsk = true
      end
      --if sefremains >= 5 and sefremains <= 11 then holdfof = true end
      if buff.stormEarthAndFire.exists() then
        ChatOverlay("Waiting for WDP")
      end
      if sefremains <= 1.5 then
        ChatOverlay("Pooling for WDP gcd")
        return true
      end
    end
  end
  -- Action List - Cooldowns
  local function actionList_Cooldowns()
    if #enemyTable5 > 0 and UnitHealth("target") >= 70000 then
      -- print("shitty cd")
      -- invoke_xuen_the_white_tiger
      if talent.invokeXuenTheWhiteTiger and isChecked("Xuen") then
        cast5yards("invokeXuenTheWhiteTiger", "xuen cds")
      end
      if talent.energizingElixir then
        if chiDeficit >= 2 and energy <= 15 then
          if cast.energizingElixir("player") then
            if isChecked("Debug") then
              print("energy elexir cds")
            end
          return true
          end
        end
      end
      if isChecked("Racial") then
        if (race == "BloodElf" and chiDeficit >= 1 and ttmP() >= 0.5) or race == "Orc" or race == "Troll" or race == "LightforgedDraenei" or race == "DarkIronDwarf" or race == "MagharOrc" then
          if race == "LightforgedDraenei" then
            if cast.racial("target", "ground") then
              return true
            end
          else
            if cast.racial("player") then
              return true
            end
          end
        end
      end
      -- Touch of Death
      -- if isChecked("Touch of Death") and thp <= 10 and cast.last.tigerPalm(1) then --and cd.fistsOfFury.remain() < gcd then
      --     if cast.touchOfDeath("target") then return true end
      -- end
      -- -- touch_of_death,if=target.time_to_die>9
      if not isChecked("ToD PVP") and isChecked("Touch of Death") and cd.fistsOfFury.remain() < 1 then
        if isChecked("Trinkets") and cast.able.touchOfDeath("target") then
          if canUse(13) then
            useItem(13)
          end
          if canUse(14) then
            useItem(14)
          end
        end
        if cast.touchOfDeath("target") then
          if isChecked("Debug") then
            print("ToD cd apl")
          end
          return true
        end
      end

      -- Storm, Earth, and Fire
      -- storm_earth_and_fire,if=cooldown.storm_earth_and_fire.charges=2|(cooldown.fists_of_fury.remains<=6&chi>=3&cooldown.rising_sun_kick.remains<=1)|target.time_to_die<=15
      if not talent.serenity and 
        ((charges.stormEarthAndFire.frac() > 1.98 and cd.touchOfDeath.exists()) or (fofcd <= 6 and chi >= 3 and rskcd <= 1 and cd.touchOfDeath.exists() and charges.stormEarthAndFire.recharge() <= todcd) or cast.last.touchOfDeath(1) or (isChecked("Minimum SEF targets") and #enemyTable8 >= getOptionValue("Minimum SEF targets"))) then
        if cast.stormEarthAndFire("target") then
          if isChecked("Trinkets") then
            if canUse(13) then
              useItem(13)
            end
            if canUse(14) then
              useItem(14)
            end
          end
          -- if not isChecked("WDP abuse") then
          --     holdwdp = false
          -- end
          -- holdrsk = false
          -- holdfof = false
          if isChecked("Debug") then
            print("SEF cd apl")
          end
          return true
        end
      end
    -- Serenity
    -- serenity,if=cooldown.rising_sun_kick.remains<=2|target.time_to_die<=12
    -- if (getOptionValue("Serenity") == 1 or (getOptionValue("Serenity") == 2 and useCDs()))
    --     and getDistance(units.dyn5) < 5 and (cd.risingSunKick.remain() <= 2 or ttd <= 12)
    -- then
    --     if cast.serenity() then return end
    end
  end -- End Cooldown - Action List
  local function actionList_Open()
    --if (opener == false and time < 1) and (isDummy("target") or isBoss("target")) and (cd.vanish > 0 or not buff.shadowBlades.exists()) then Print("Opener failed due do cds"); opener = true end
    if talent.whirlingDragonPunch then
      if cast.invokeXuenTheWhiteTiger("target") then  end
      if not open1 then
        if cast.fistOfTheWhiteTiger("target") then
          open1 = true
        end
      elseif open1 and not open2
       then
        if cast.tigerPalm("target") then
          open2 = true
        end
      elseif open2 and not open3 then
        if cast.able.touchOfDeath("target") then
          if canUse(13) then
            useItem(13)
          end
          if canUse(14) then
            useItem(14)
          end
        if cast.touchOfDeath("target") then
          open3 = true
        end
        end
      elseif open3 and not open4 then
        if cast.stormEarthAndFire("target") then
          open4 = true
        end
      elseif open4 and not open5 then
        if cast.risingSunKick("target") then
          open5 = true
        end
      elseif open5 and not open6 then
        if cast.fistsOfFury("target") then
          open6 = true
        end
      elseif open6 and not open7 then
        if cast.whirlingDragonPunch("target") then
          open7 = true
        end
      elseif open7 then
        Print("Opener Complete")
        opener = true
        toggle("Opener", 2)
        return
      end
    end -- subt talent
  end

  -- local function burnexplosive()
  --     local function castburn(skill)
  --         for i =1, #burnlist5 do
  --                 local thisUnit = burnlist5[i].unit
  --                 if cast[skill](thisUnit) then if isChecked("Debug") then print("burn"..skill); end; return true end
  --         end
  --     end
  --     if chiDeficit >= 3 then
  --         castburn("fistOfTheWhiteTiger")
  --     end
  --     castburn("risingSunKick")
  --     if lastcombo ~= "blackoutKick" and (rskcd > 3 or chi >= 3) then
  --         castburn("blackoutKick")
  --     end
  --     castburn("chiWave")
  --     if chi <= 3 then
  --         castburn("tigerPalm")
  --     end
  --     return
  -- end
  local function smartfof(pewpew)
    if mode.fof == 2 or holdfof or #burnTable5 > 0 then return end

    if pewpew == "st" then
      --foftable = enemyTable5
      if #enemyTable5 > 1 then
        for i = 1, #enemyTable5 do
          local thisUnit = enemyTable5[i].unit
          if enemyTable5[i].id == 120651 then
            return
          end
          if enemyTable5[i].facing and enemyTable5[i].ttd >= getOptionValue("FoF TTD") then
            if cast.fistsOfFury(thisUnit) then
              if isChecked("Debug") then
                print("fof used")
              end
              return true
            end
          end
        end
      end
      if ttd("target") >= getOptionValue("FoF TTD") then
        if cast.fistsOfFury("target") then
          if isChecked("Debug") then
            print("fof st")
          end
          return true
        end
      end
    end
  end
  -- Action List - Single Target
  local function actionList_SingleTarget()
    if talent.whirlingDragonPunch and IsUsableSpell(spell.whirlingDragonPunch) and (isChecked("WDP when moving") or not moving) then
      cast8yards("whirlingDragonPunch", "ST WDP")
    end
    if chi >= 5 then
      cast5yards("risingSunKick", "ST RSK chi >=5")
    end

    if ttmP() >= fofcast --or lastcombo == "tigerPalm" or (cd.whirlingDragonPunch.remain() <= 1 and debuff.touchOfDeath.exists("target") and not isChecked("WDP abuse")) 
      then
      smartfof("st")
    end

    -- if isChecked("BlackoutKick execute") and not lastcombo == "blackoutKick" and IsUsableSpell(spell.blackoutKick) then
    --   for i = 1, #enemyTable5 do
    --     if enemyTable5[i].hpabs <= bkdamage() then
    --       if cast.blackoutKick(thisUnit) then
    --         if isChecked("Debug") then
    --           print("bok execute")
    --         end
    --         return true
    --       end
    --     end
    --   end
    -- end
    if fofcd >= 2 or (EnergyP() >= 50 and lastcombo ~= "tigerPalm") then
      cast5yards("risingSunKick", "ST RSK")
    end

    

    

    if IsUsableSpell(spell.fistOfTheWhiteTiger) and chi <= 2 then
      cast5yards("fistOfTheWhiteTiger", "ST FotWT chi <= 2")
    end

    -- if buff.danceOfChiJi.exists("player") and lastcombo ~= "spinningCraneKick"  then
    --   cast8yards("spinningCraneKick"," sck st proc no sef")
    -- end

    if buff.danceOfChiJi.exists("player") and lastcombo ~= "spinningCraneKick"  then
      if chiDeficit >= 2 and lastcombo ~= "tigerPalm" and (not buff.rushingJadeWind.exists() or EnergyP() > 56) then
        cast5yards("tigerPalm", "ST tigerPalm chiDeficit >= 2 before Dance")
      end 
      cast8yards("spinningCraneKick","ST ScK Dance")
    end

    if lastcombo ~= "blackoutKick" and (buff.blackoutKick.exists() or (cangetchitp(rskcd) >= 2 and fofcd >= rskcd + 2) or cangetchitp(fofcd) >= 3) then
      cast5yards("blackoutKick", "ST BlackoutKick")
    end
    --danceOfChiJi + SEF
    -- if buff.danceOfChiJi.exists("player") and lastcombo ~= "spinningCraneKick" and ttm >= sckcast then
    --   cast8yards("spinningCraneKick"," sck st proc sef")
    -- end
    cast5yards("chiWave", "ST chiWave")
    if chiDeficit >= 1 then
      ChiBurstBestRect()
    end
    if chiDeficit >= 2 and lastcombo ~= "tigerPalm" and (not buff.rushingJadeWind.exists() or EnergyP() > 56) then
      cast5yards("tigerPalm", "ST tigerPalm chiDeficit >= 2")
    end
    

    if lastcombo ~= "blackoutKick" 
      and ttmP() < 2 and chiDeficit < 2
      then
      cast5yards("blackoutKick", "ST BlackoutKick Fix")
    end
    

    --flying_serpent_kick,if=prev_gcd.1.blackout_kick&chi>3&buff.swift_roundhouse.stack<2,interrupt=1
    if mode.fsk == 1 and lastcombo ~= "blackoutKick" and chi > 3 and buff.swiftRoundhouse.stack() < 2 then
      if cast.flyingSerpentKick() then
        if isChecked("Debug") then
          print("ST FSK")
        end
        return true
      end
    end

    smartfof("st")

    --     if not wasLastCombo(spell.tigerPalm)
    --         and chi < 4 and ttm <= gcd
    --         -- and ((not (chi >= 2 and cd.risingSunKick.remain() < gcd)
    --         -- and not (chi >= 3 and cd.fistsOfFury.remain() < gcd)
    --         -- and not (talent.fistOfTheWhiteTiger and cd.fistOfTheWhiteTiger.remain() < gcd)) or ttm < 3)
    --     then
    --         if cast.tigerPalm() then return true end
    --     end
    -- -- Whirling Dragon Punch
    --     --Chi Burst (if less than max Chi)
    --     if chi < 5 then
    --         if cast.chiBurst() then return true end
    --     end
    -- --
    -- -- Blackout kick
    --     -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.blackout_kick&(cooldown.rising_sun_kick.remains>3|chi>=3)&(cooldown.fists_of_fury.remains>4|chi>=4|(chi=2&prev_gcd.1.tiger_palm))&buff.swift_roundhouse.stack<2
    --     if not cast.last.blackoutKick(1)
    --         --and ((safeToCastRSK() and safeToCastFoF(1)) or (chi > 0 and chi <= 2 and wasLastCombo(spell.tigerPalm)))
    --         --and ((chi == 1 and cd.risingSunKick.remain() < gcd) or (chi == 2 and cd.fistsOfFury.remain() < gcd) or ttm < 3 or chi > 3)
    --         -- and (((cd.risingSunKick.remain() < gcd and chi < 2) or (cd.fistsOfFury.remain() < gcd and chi < 3) or ttm < 3 or ttd < 3) and wasLastCombo(spell.tigerPalm))
    --         --     or ((chi > 3 or (chi > 2 and cd.risingSunKick.remain() >= gcd)) and cd.fistsOfFury.remain() >= gcd)
    --         --     or (cd.risingSunKick.remain() >= gcd and cd.fistsOfFury.remain() >= gcd)
    --         -- and ((not (chi >= 2 and cd.risingSunKick.remain() < gcd)
    --         -- and not (chi >= 3 and cd.fistsOfFury.remain() < gcd)
    --         -- and not (talent.fistOfTheWhiteTiger and cd.fistOfTheWhiteTiger.remain() < gcd)) or  ttm < 3 or chi > 3)
    --     then
    --         if cast.blackoutKick() then
    -- --             print("st bk")
    -- --         return true end
    -- --     end
    -- -- Chi Wave
    --     -- chi_wave
    --         if cast.chiWave(nil,"aoe") then return true end
    -- -- Chi Burst
    --     -- chi_burst,if=chi.max-chi>=1&active_enemies=1|chi.max-chi>=2
    -- -- Tiger Palm
    --     -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.tiger_palm&chi.max-chi>=2
    --     if not wasLastCombo(spell.tigerPalm)
    --         -- and ((not (chi >= 2 and cd.risingSunKick.remain() < gcd)
    --         -- and not (chi >= 3 and cd.fistsOfFury.remain() < gcd)
    --         -- and not (talent.fistOfTheWhiteTiger and cd.fistOfTheWhiteTiger.remain() < gcd)) or ttm < 3)
    --     then
    --         if cast.tigerPalm() then return true end
    --     end
    -- -- Flying Serpent Kick
    -- -- -- Blackout Kick - Stall Prevention
    -- --     if cast.able.blackoutKick() and wasLastCombo(spell.tigerPalm) then
    -- --         if cast.blackoutKick() then return true end
    -- --     end
    -- -- -- Tiger Palm - Stall Prevention
    -- --     if cast.able.tigerPalm() and not wasLastCombo(spell.tigerPalm) and ttm <= 3 then
    -- --         if cast.tigerPalm() then return true end
    -- --     end
  end -- End Action List - Single Target
  -- Action List - AoE
  local function actionList_AoE()
    if talent.whirlingDragonPunch and fofcd >= wdpcd + 3 and wdpcd < 5  then
      cast5yards("risingSunKick", "rsk aoe before wdp")
    end
    -- Whirling Dragon Punch
    -- whirling_dragon_punch
    if talent.whirlingDragonPunch and IsUsableSpell(spell.whirlingDragonPunch) and (not moving or isChecked("WDP when moving")) then
      cast8yards("whirlingDragonPunch", " WDP AOE")
    end

    -- Fists of Fury
    -- fists_of_fury,if=energy.time_to_max>3
    if ttmP() >= fofcast or lastcombo == "tigerPalm" then
      smartfof("st")
    end

    if isChecked("BlackoutKick execute") and lastcombo ~= "blackoutKick" then
      for i = 1, #enemyTable5 do
        if enemyTable5[i].hpabs <= bkdamage() then
          if cast.blackoutKick(thisUnit) then
            if isChecked("Debug") then
              print("bok execute")
            end
            return true
          end
        end
      end
    end

    -- Chi Burst
    -- chi_burst,if=chi<=3
    if chi < 5 then
      ChiBurstBestRect()
    end
    if buff.danceOfChiJi.exists("player") and lastcombo ~= "spinningCraneKick" then
       cast8yards("spinningCraneKick", "AOE spinningCraneKick Dance Proc")
    end
    -- Rushing Jade Wind
    -- rushing_jade_wind,if=buff.rushing_jade_wind.down
    if talent.rushingJadeWind and not buff.rushingJadeWind.exists() and GetObjectID("target") ~= 120651 then
      if cast.rushingJadeWind("player") then
        if isChecked("Debug") then
          print("aoe jadewind")
        end
        return true
      end
    end
    -- Spinning Crane Kick
    --spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick&(((chi>3|cooldown.fists_of_fury.remains>6)&(chi>=5|cooldown.fists_of_fury.remains>2))|energy.time_to_max<=3)
    if lastcombo ~= "spinningCraneKick" and (((fofcd > 6 or chi > 3) and (chi >= 5 or fofcd > 2)) or ttm <= fofcast) then
      cast8yards("spinningCraneKick", "AOE spinningCraneKick")
    end

    -- Fist of the White Tiger
    -- fist_of_the_white_tiger,if=chi.max-chi>=3
    if chi <= 2 then
      cast5yards("fistOfTheWhiteTiger", "fotwt aoe chi <=2")
    end
    -- Tiger Palm
    -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=chi.max-chi>=2&(!talent.hit_combo.enabled|!prev_gcd.1.tiger_palm)
    if chiDeficit >= 2 and (not talent.hitCombo or lastcombo ~= "tigerPalm") then
      cast5yards("tigerPalm", "AOE tigerPalm")
    end
    -- Chi Wave
    -- chi_wave
    cast5yards("chiWave", "chiWave AOE")
    -- Flying Serpent Kick
    -- flying_serpent_kick,if=buff.bok_proc.down,interrupt=1
    if mode.fsk == 1 and not buff.blackoutKick.exists() then
      if cast.flyingSerpentKick() then
        if isChecked("Debug") then
          print("fsk aoe")
        end
        return true
      end
    end
    -- Blackout Kick
    -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.blackout_kick&(buff.bok_proc.up|(talent.hit_combo.enabled&prev_gcd.1.tiger_palm&chi<4))
    if lastcombo ~= "blackoutKick" and (buff.blackoutKick.exists() or (chi >= 4 and lastcombo == "spinningCraneKick" and ttmP() < 2) or (talent.hitCombo and lastcombo == "tigerPalm" and chi < 4)) then
     cast5yards("blackoutKick", "blackoutKick AOE")
    end
    -- -- Tiger Palm - Stall Prevention
    if not lastcombo ~= "tigerPalm" and energy > 50 then
      if cast.tigerPalm(moclist5[1].unit) then
        if isChecked("Debug") then
          print("tp stall")
        end
        return true
      end
    end
  end -- End Action List - AoE
  local function fixing()
    if ttmP() <= cd.fistsOfFury.remain() and chi >= 4 then
      for i = 1, #enemyTable5 do
        local thisUnit = enemyTable5[i].unit
        if cast.tigerPalm(thisUnit) then
          if isChecked("Debug") then
            print("tp fix")
          end
          return true
        end
      end
    end
  end
  -- Action List - Serenity
  local function actionList_Serenity()
    -- Rising Sun Kick
    -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=active_enemies<3|prev_gcd.1.spinning_crane_kick
    --     if chi >= 2 and  cast.able.risingSunKick(lowestMark) and (#enemies.yards8 < 3 or wasLastCombo(spell.spinningCraneKick)) then
    --         if cast.risingSunKick(lowestMark) then return true end
    --     end
    -- -- Fists of Fury
    --     -- fists_of_fury,if=(buff.bloodlust.up&prev_gcd.1.rising_sun_kick)|buff.serenity.remains<1|(active_enemies>1&active_enemies<5)
    --     if chi >= 3 and  cast.able.fistsOfFury() and ((hasBloodLust() and wasLastCombo(spell.risingSunKick)) or buff.serenity.remain() < 1
    --         or (#enemies.yards8 > 1 and #enemies.yards8 < 5)) and mode.fof == 1
    --     then
    --         if cast.fistsOfFury(nil,"cone",1,45) then return end
    --     end
    -- -- Spinning Crane Kick
    --     -- spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick&(active_enemies>=3|(active_enemies=2&prev_gcd.1.blackout_kick))
    --     if chi >= 2 and not wasLastCombo(spell.spinningCraneKick) and (((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0))
    --         or (((mode.rotation == 1 and #enemies.yards8 == 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) and wasLastCombo(spell.blackoutKick)))
    --     then
    --         if cast.spinningCraneKick(nil,"aoe") then return true end
    --     end
    -- -- Blackout Kick
    --     -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains
    --     if chi >= 1 and cast.able.blackoutKick(lowestMark) and not wasLastCombo(spell.blackoutKick)  then
    --         if cast.blackoutKick(lowestMark) then print("serenity bk") return true end
    --     end
  end -- End Action List - Serenity
  -- Action List - Pre-Combat
  local function actionList_PreCombat()
    if not inCombat then
    end -- End No Combat Check
  end --End Action List - Pre-Combat
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  --- Begin Profile ------ Begin Profile ------ Begin Profile ------ Begin Profile ------ Begin Profile ------ Begin Profile ------ Begin Profile ------ Begin Profile ------ Begin Profile ------ Begin Profile ------ Begin Profile ---
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  if UnitCastingInfo("player") or UnitChannelInfo("player") then
    return true
  end

  -- print(UnitCastingInfo("player"))
  if actionList_PreCombat() then
    return
  end

  -- if isChecked("|cffFFBB00Encounter Logic") then
  --     if MythicStuff() then return end
  -- end
  if (inCombat and profileStop == true) or not inCombat or pause() or (IsMounted() or IsFlying()) or mode.rotation == 2 then
    return true
  else
    
    -- if cast.last.cracklingJadeLightning(1) then
    --   SpellStopCasting()
    -- end
    --print(bkdamage())
    -----------------------
    --- Extras Rotation ---
    -----------------------
    if actionList_Extras() then
      return
    end
    if CheckCDS() then return true end

    --------------------------
    --- Defensive Rotation ---
    --------------------------
    if actionList_Defensive() then
      return
    end
    ---------------------------
    --- Pre-Combat Rotation ---
    ---------------------------
    if actionList_PreCombat() then
      return true
    end
    --if cast.vivify("player") then return true end
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- In Combat Rotation ------ In Combat Rotation ------ In Combat Rotation ------ In Combat Rotation ------ In Combat Rotation ------ In Combat Rotation ------ In Combat Rotation ------ In Combat Rotation ------ In Combat Rotation ---
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- FIGHT!
    if inCombat and profileStop == false then
      if not IsCurrentSpell(6603) and inCombat and isValidUnit("target") and getDistance("target") <= 5 and getFacing("player", "target") then
        StartAttack("target")
      end
      --print(ttm)
      ------------------
      --- Interrupts ---
      ------------------
      -- Run Action List - Interrupts
      if actionList_Interrupts() then
        return
      end

      ----------------------
      --- Start Rotation ---
      ----------------------
      -- Auto Attack
      -- auto_attack
      -- for i = 1, #enemyTable5 do
      --     local thisUnit = enemyTable5[i].unit
      --     if cast.tigerPalm(thisUnit) then return true end
      -- end
      if isChecked("ToD PVP") then
        for i = 1, #enemyTable5 do
          local thisUnit = enemyTable5[i].unit
          if getHP(thisUnit) <= 10 and UnitHealthMax(thisUnit) >= 15000 and not cd.touchOfDeath.exists() then
            --and getFacing("player", thisUnit)
            RunMacroText("/stopcasting")
            if cast.touchOfDeath(thisUnit) then
              return true
            end
          end
        end
      end

      if mode.opener == 1 then 
        if inCombat then
          if actionList_Open() then return true end
        else
          return true 
        end
      end

      --print(lastcombo)
      -- if #burnlist5 > 0 then
      --     if burnexplosive() then return end
      -- end
      -- if isChecked("WDP abuse") and buff.stormEarthAndFire.exists() then
      --     if buff.stormEarthAndFire.remain() <= 0.25 then
      --         if cast.whirlingDragonPunch("player") then
      --             print(buff.stormEarthAndFire.remain())
      --         return true end
      --     end
      --     -- if buff.stormEarthAndFire.remain() <= 0.15 then
      --     --     if cast.risingSunKick("target") then
      --     --         print(buff.stormEarthAndFire.remain())
      --     --     return true end
      --     -- end
      --     return true
      --     --if seftimer - GetTime() <= 0.17 + gcd and buff.stormEarthAndFire.exists() then return true end
      -- end
      -- Call Action List - Serenity
      -- call_action_list,name=serenity,if=buff.serenity.up
      if talent.serenity and buff.serenity.exists() then
        if actionList_Serenity() then
          return true
        end
      end
      -- Xuen
      -- if talent.invokeXuenTheWhiteTiger and useCDs() and isChecked("Xuen") then
      --     if cast.invokeXuenTheWhiteTiger() then return true end
      -- end
      -- print(lastcombo)
      if IsUsableSpell(spell.fistOfTheWhiteTiger) and chiDeficit >= 3 and ttmP() < 1  then
        cast5yards("fistOfTheWhiteTiger", "fotwt general")
      end

      if IsUsableSpell(spell.tigerPalm) and chiDeficit >= 2 and lastcombo ~= "tigerPalm" and ttmP() < 1 then
        cast5yards("tigerPalm", "tp general")
      end
      -- Call Action List - Cooldowns
      -- call_action_list,name=cd
      if mode.special == 1 then
        if actionList_Cooldowns() then
          return true
        end
      end

      if #enemyTable5 >= 3 and mode.cleave < 3 and #burnlist5 == 0 then
        if actionList_AoE() then
          return true
        end
      end
      -- Call Action List - Single Target
      -- call_action_list,name=st,if=active_enemies<3
      if actionList_SingleTarget() then
        return true
      end
      -- Call Action List - AoE
      -- call_action_list,name=aoe,if=active_enemies>=3

      if fixing() then
        return true
      end
    end -- End Combat Check
  end -- End Pause
  --end -- End Timer
end -- End runRotation
local id = 269
if br.rotations[id] == nil then
  br.rotations[id] = {}
end
tinsert(
  br.rotations[id],
  {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation
  }
)

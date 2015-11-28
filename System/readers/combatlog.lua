bb.class = select(3, UnitClass("player"))
bb.guid = UnitGUID("player")
-- specific reader location
bb.read = { }
bb.read.combatLog = { }
bb.read.debugTable = { }
bb.read.enraged = { }
local cl = bb.read
-- will update the bb.read.enraged list
function bb.read.enrageReader(...)
  if getOptionCheck("Enrages Handler") then
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
      destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
    -- here we will take all spell aura and check if we hold this aura in our enrage table
    -- if we find a match, we set the unit to whitelist with time remaining on the buff
    if param == "SPELL_AURA_APPLIED" and destName ~= nil then
      if dispellOffensiveBuffs[spell] ~= nil then
        -- find unit in engine, if its not there, dont add it.
        if destination ~= nil then
          tinsert(bb.read.enraged, 1, {guid = destination,spellType = dispellOffensiveBuffs[spell],buffID = spell})
        end
      end
    end
    if param == "SPELL_AURA_REMOVED" then
      -- look for a match to remove
      local targets = bb.read.enraged
      if #targets > 0 then
        for i = #targets,1,-1 do
          if targets[i].guid == destination and targets[i].buffID == spell then
            tremove(bb.read.enraged, i)
          end
        end
      end
    end
    -- once a buff fades or is dispelled, we want to remove it from whitelist if its there
  end
end
function bb.read.combatLog()
  ---------------------------
  --[[ Combat Log Reader --]]
  local frame = CreateFrame('Frame')
  frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  local function reader(self,event,...)
    local cl = bb.read
    -- this reader intend to hold all the combatlog related stuff. this is gonna be used
    -- with as few checks as possible per class/spec as in raiding environment we have already enough to check
    -- pulse common stuff for all classes
    cl:common(...)
    -- best way is to split per class so lets make a selector for it
    local class = bb.class
    if class == 1 then -- Warrior
      cl:Warrior(...)
    elseif class == 2 then -- Paladin
      cl:Paladin(...)
    elseif class == 3 then -- Hunter
      cl:Hunter(...)
    elseif class == 4 then -- Rogue
      cl:Rogue(...)
    elseif class == 5 then -- Priest
      cl:Priest(...)
    elseif class == 6 then -- Deathknight
      cl:Deathknight(...)
    elseif class == 7 then -- Shaman
      cl:Shaman(...)
    elseif class == 8 then -- Mage
      cl:Mage(...)
    elseif class == 9 then -- Warlock
      cl:Warlock(...)
    elseif class == 10 then -- Monk
      cl:Monk(...)
    elseif class == 11 then -- Druid
      cl:Druid(...)
    end
  end
  -- add event to the reader
  frame:SetScript("OnEvent", reader)
  -- class functions(Alphabetically)
  function cl:common(...)
    bb.read.enrageReader(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
      destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
    ----------------
    --[[Item locks]]
    if source == bb.guid then
      local DPSPotionsSet = {
        [1] = {Buff = 105702, Item = 76093}, -- Intel
        [2] = {Buff = 105697, Item = 76089}, -- Agi
        [3] = {Buff = 105706, Item = 76095}, -- Str
      }
      -- Synapse Springs
      if spell == 126734 then
        synapseUsed = GetTime()
      end
      -- Lifeblood
      if spell == 121279 or spell == 74497 then
        lifeBloodUsed = GetTime()
      end
      -- DPS potions
      for i = 1, #DPSPotionsSet do
        if spell == DPSPotionsSet[i].Buff then
          potionUsed = GetTime()
          if UnitAffectingCombat("player") then
            ChatOverlay("Potion Used, can reuse in 60 secs.")
            potionReuse = false
          else
            ChatOverlay("Potion Used, cannot reuse.")
            potionReuse = true
          end
        end
        -- Lifeblood
        if spell == 121279 or spell == 74497 then
          lifeBloodUsed = GetTime()
        end
        -- DPS potions
        for i = 1, #DPSPotionsSet do
          if spell == DPSPotionsSet[i].Buff then
            potionUsed = GetTime()
            if UnitAffectingCombat("player") then
              ChatOverlay("Potion Used, cannot reuse.")
              potionReuse = false
            else
              ChatOverlay("Potion Used, can reuse in 60 secs.")
              potionReuse = true
            end
          end
        end
      end
    end
    -----------------------------------
    --[[ Item Use Success Recorder ]]
    if param == "SPELL_CAST_SUCCESS" and isInCombat("player") then
      if usePot == nil then
        usePot = true
      end
      if spell == 105697 then --Virmen's Bite Buff
        usePot = false
      end
      if spell == 105708 then --Healing Potions
        usePot = false
      end
    end
    ------------------
    --[[Spell Queues]]
    if getOptionCheck("Queue Casting") then
      -----------------
      --[[ Cast Failed --> Queue]]
      if param == "SPELL_CAST_FAILED" then
        if source == bb.guid then
          if _Queues[spell] ~= true and _Queues[spell] ~= nil then
            if (_Queues[spell] == false or _Queues[spell] < (GetTime() - 10)) and getSpellCD(spell) <= 3 then
              _Queues[spell] = true
              ChatOverlay("Queued "..GetSpellInfo(spell))
            end
          end
        end
      end
      ------------------
      --[[Queue Casted]]
      if param == "SPELL_CAST_SUCCESS" then
        if source == bb.guid then
          if _Queues == nil then _Queues = { } end
          if _Queues and _Queues[spell] ~= nil then
            if _Queues[spell] == true then
              _Queues[spell] = GetTime()
            end
          end
        end
      end
    end
    ---------------
    --[[ Debug --]]
    if getOptionCheck("Debug Frame") == true and source == bb.guid and (param == "SPELL_CAST_SUCCESS" or (param == "SPELL_CAST_FAILED" and getOptionCheck("Display Failcasts"))) then
      -- available locals
      -- timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
      -- destName, destFlags, destRaidFlags, spell, spellName, _, spellType
      -- Add spells we dont want to appear here.
      if SpellID ~= 75              -- Auto Shot
        and SpellID ~= 88263        -- 88263
        --and SpellID ~= 172        -- Corruption
        and SpellID ~= 8690 then    -- Hearthstone
        local color = "|cff12C8FF"
        local white = "|cffFFFFFF"
        local red = "|cffFF001E"
        -- add counters
        if param == "SPELL_CAST_SUCCESS" then
          if BadBoy_data.successCasts == nil then
            BadBoy_data.successCasts = 0
          end
          color = "|cff12C8FF"
          BadBoy_data.successCasts = BadBoy_data.successCasts + 1
        elseif param == "SPELL_CAST_FAILED" then
          if BadBoy_data.failCasts == nil then
            BadBoy_data.failCasts = 0
          end
          color = red
          BadBoy_data.failCasts = BadBoy_data.failCasts + 1
        end
        -- set destination
        if destination == nil or destName == nil then
          debugdest = "\nTarget hidden by log."
        else
          debugdest = "\n"..destName.." "..destination
        end
        -- set spell
        if spell == nil then
          debugSpell = ""
        else
          debugSpell = "\nSpell :"..spellName.." "..spell
        end
        local Power = "\nPower : "..UnitPower("player")
        -- create display row
        local textString = color..BadBoy_data.successCasts..red.."/"..white..getCombatTime()..red.."/"..color..spellName
          ..red..debugdest..color..debugSpell.."|cffFFDD11"..Power
        -- pulse display
        bb.read:display(textString)
      end
    end
    --[[ Last Spell Cast Success ]]
    if source == bb.guid and param == "SPELL_CAST_SUCCESS" then
      -- Add spells we dont want to appear here.
      if spell ~= 155521 then     -- Auspicious Spirits
        secondLastSpellCastSucess = lastSpellCastSuccess
        lastSpellCastSuccess = spell
        lastSpellCastSuccessTime = GetTime()
      end
    end
    --[[ Last Spell Cast Started ]]
    if source == bb.guid and (param == "SPELL_CAST_START" or param == "SPELL_CAST_SUCCESS") then
        -- Add spells we dont want to appear here.
        if spell ~= 120361 or spell ~= 75 then     -- Barrage fires
            if param == "SPELL_CAST_SUCCESS" and (spell ~= 77767 or spell ~= 163485) or param == "SPELL_CAST_START" then
                secondLastSpellStarted = lastSpellStarted
                lastSpellStarted = spell
            end
        end
    end
  end

  function cl:Druid(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
      destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
    -----------
    -- Kitty ---------------
    --[[ Bleed Recorder --]]
    if GetSpecialization() == 2 then
      if source == UnitGUID("player") then
        if destination ~= nil and destination ~= "" then
          local thisUnit = GetObjectWithGUID(destination)
          ripApplied = ripApplied or {}
          rakeApplied = rakeApplied or {}
          if spell == 1079 and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") then
            ripApplied[thisUnit] = FeralCuteOne.getSnapshotValue("rip")
          end
          if spell == 155722 and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") then
            rakeApplied[thisUnit] = FeralCuteOne.getSnapshotValue("rake")
          end
        end
      elseif (not UnitAffectingCombat("player")) and (not IsEncounterInProgress()) then
          ripApplied = {}
          rakeApplied = {}
      end
    end
    -----------------------
    --[[ Moonkin ]]
    if shroomsTable == nil then
      shroomsTable = { }
      shroomsTable[1] = { }
    end
    if source == bb.guid and  param == "SPELL_SUMMON" and (spell == 147349 or spell == 145205) then
      shroomsTable[1].guid = destination
      shroomsTable[1].x = nil
      shroomsTable[1].y = nil
      shroomsTable[1].z = nil
    end
    if (param == "UNIT_DIED" or  param == "UNIT_DESTROYED" or GetTotemInfo(1) ~= true) and shroomsTable ~= nil and shroomsTable[1].guid == destination then
      shroomsTable[1] = { }
    end
    if source == bb.guid and class == 11 and GetSpecialization() == 1 then
      -- Starsurge Casted
      if spell == 78674 and param == "SPELL_CAST_SUCCESS" then
        if core then
          core.lastStarsurge = GetTime()
        end
      end
    end
  end
  function cl:Deathknight(...)
  end
  function cl:Hunter(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
      destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
    --[[ Steady Focus ]]
    if spell == 77767 and param == "SPELL_CAST_SUCCESS" then
      if BadBoy_data["1stFocus"] ~= true then
        BadBoy_data["1stFocus"] = true
      else
        BadBoy_data["1stFocus"] = false
      end
    end
  end
  function cl:Mage(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
      destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
    if source == bb.guid then
      -- Params
      -- SPELL
      -- SPEL_PERIODIC
      -- SPELL_CAST_SUCCESS,
      -- SPELL_DAMAGE,
      -- SPELL_MISSED,
      -- SPELL_AURA_REFRESH,
      -- SPELL_AURA_APPLIED,
      -- SPELL_AURA_APPLIED_DOSE,
      -- SPELL_AURA_APPLIED_REMOVED,
      if param == "SPELL" and spell == 30451 then
      --print("Spell " ..GetTime())
      end
      if param == "SPEL_PERIODIC" and spell == 30451 then
      --print("Spell Periodic " ..GetTime())
      end
      if param == "SPELL_CAST_SUCCESS" and spell == 30451 then
      --print("Spell Cast Success " ..GetTime())
      end
      if param == "SPELL_DAMAGE" and spell == 30451 then
      --print("Spell Damage " ..GetTime())
      end
      if param == "SPELL_MISSED" and spell == 30451 then
      --print("Spell Missed " ..GetTime())
      end
      if param == "SPELL_AURA_REFRESH" and spell == 36032 then
      --print("Spell Aura Refresh " ..GetTime())
      end
      if param == "SPELL_AURA_APPLIED" and spell == 36032 then
      --print("Spell Aura Applied " ..GetTime())
      end
      if param == "SPELL_AURA_APPLIED_DOSE" and spell == 36032 then
      --print("Spell Aura Applied Dose " ..GetTime())
      end
      if param == "SPELL_AURA_REMOVED" and spell == 36032 then
      --print("Spell Aura Removed " ..GetTime())
      end
    end
  end
  function cl:Monk(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
      destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
  end
  function cl:Priest(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
      destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
      -- last VT
      if param == "SPELL_CAST_SUCCESS" and spell==34914 then
        --lastVTTarget=destination
        --lastVTTime=GetTime()
      end
  end
  function cl:Paladin(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
      destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
    -----------------------
    --[[ Class Trinket ]]
    if (source == bb.guid and (spell == 35395 or spell == 53595)) then
      previousT18classTrinket = destination
    end
    --[[ Double Jeopardy ]]
    if spell == 20271 and source == bb.guid and previousJudgmentTarget ~= destination then
      previousJudgmentTarget = destination
    end
  end
  function cl:Rogue(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
      destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
    --------------------------------------
    --[[ Pick Pocket Success Recorder ]]
    if canPickpocket == nil then
      canPickpocket = true
    end
    if param == "SPELL_CAST_SUCCESS" and spell==921 then
      canPickpocket = false
    end
  end
  function cl:Shaman(...) -- 7
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
      destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
  --------------------
  --[[ Fire Totem ]]
  if source == bb.guid and  param == "SPELL_SUMMON" and (spell == _SearingTotem or spell == _MagmaTotem) then
    activeTotem = destination
    activeTotemPosition = GetObjectPosition("player")
  end
  if param == "UNIT_DESTROYED" and activeTotem == destination then
    activeTotem = nil
  end
  end
  function cl:Warlock(...) -- 9
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
      destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
  ---------------------
  --[[ Pet Manager --]]
  if class == 9 then
    if source == bb.guid and param == "SPELL_CAST_SUCCESS" then
      if spell == 688 or spell == 112866 then
        petSummoned = 1
        petSummonedTime = GetTime()
      end
      if spell == 697 or spell == 112867 then
        petSummoned = 2
        petSummonedTime = GetTime()
      end
      if spell == 691 or spell == 112869 then
        petSummoned = 3
        petSummonedTime = GetTime()
      end
      if spell == 712 or spell == 112868 then
        petSummoned = 4
        petSummonedTime = GetTime()
      end
      if spell == 30146 or spell == 112870 then
        petSummoned = 5
        petSummonedTime = GetTime()
      end
    end
  end
  end
  function cl:Warrior(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
      destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
    ----------------------------------
    --[[ Bleed Recorder (Warrior) --]]
    if GetSpecialization("player") == 1 then
      -- snapshot on spellcast
      if source == bb.guid and param == "SPELL_CAST_SUCCESS" then
        if spell == 115767 then
          deepWoundsCastAP = UnitAttackPower("player")
        end
        -- but only record the snapshot if it successfully applied
      elseif source == bb.guid and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") and deepWoundsCastAP ~= nil then
        if spell == 115767 then
          deepWoundsStoredAP = deepWoundsCastAP
        end
      end
    end
  end
end

local _, br = ...
local class = select(3, br.game.UnitClass("player"))
local guid = br.game.UnitGUID("player")
-- specific reader location
br.readers = br.readers or {}
br.readers.combatLog = br.readers.combatLog or {}
br.readers.combatLog.debuffTracker = {}
br.readers.combatLog.enraged = {}
-- The player's swings, melee (mh) and ranged (Auto Shot): when the last landed, when the next is due and
-- the weapon speed then; 0 before the first (unit.swing reads them)
br.readers.combatLog.swing = { mh = { last = 0, next = 0, speed = 0 }, ranged = { last = 0, next = 0, speed = 0 } }
local combatLog = br.readers.combatLog
-- Feral and Assassination bleed snapshots per debuff key and unit: the damage value when it was
-- applied (combatLog.bleed), and whether Exsanguinate sped it up (combatLog.exsa). debuff.X.applied /
-- exsang read them; aura:cleanBleedSnapshots tidies them each tick.
combatLog.bleed = combatLog.bleed or {}
combatLog.exsa = combatLog.exsa or {}

-- TODO: OUTDATED - MoP DPS potions (buff -> item), for the potion-used tracking in combatLog:common
local DPSPotionsSet = {
    [1] = { Buff = 105702, Item = 76093 }, -- Intel
    [2] = { Buff = 105697, Item = 76089 }, -- Agi
    [3] = { Buff = 105706, Item = 76095 }  -- Str
}

-- Pre-register at module load time to avoid ADDON_ACTION_FORBIDDEN in NnLua runtime context
local combatLogFrame = br.game.CreateFrame("Frame")
combatLogFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

-- will update the br.readers.combatLog.enraged list (it wrote to br.read, which doesn't exist, and errored)
function combatLog:enrageReader(...)
    if br.functions.misc:getOptionCheck("Enrages Handler") then
        local timeStamp,
        param,
        hideCaster,
        source,
        sourceName,
        sourceFlags,
        sourceRaidFlags,
        destination,
        destName,
        destFlags,
        destRaidFlags,
        spell,
        spellName,
        _,
        spellType = ... -- the event, read once by the dispatcher
        -- here we will take all spell aura and check if we hold this aura in our enrage table
        -- if we find a match, we set the unit to whitelist with time remaining on the buff
        if param == "SPELL_AURA_APPLIED" and destName ~= nil then
            if br.lists.dispell[spell] ~= nil then
                -- find unit in engine, if its not there, dont add it.
                if destination ~= nil then
                    br.game.tinsert(
                        br.readers.combatLog.enraged,
                        1,
                        { guid = destination, spellType = br.lists.dispell[spell], buffID = spell }
                    )
                end
            end
        end
        if param == "SPELL_AURA_REMOVED" then
            -- look for a match to remove
            local targets = br.readers.combatLog.enraged
            if #targets > 0 then
                for i = #targets, 1, -1 do
                    if targets[i].guid == destination and targets[i].buffID == spell then
                        br.game.tremove(br.readers.combatLog.enraged, i)
                    end
                end
            end
        end
        -- once a buff fades or is dispelled, we want to remove it from whitelist if its there
    end
end

function combatLog:combatLog()
    ---------------------------
    --[[ Combat Log Reader --]]
    local frame = combatLogFrame  -- frame pre-registered at module load time
    -- The event's values are read once (CombatLogGetCurrentEventInfo) and handed to every handler
    -- as arguments; each used to read them again, three times or more per event.
    local dispatch
    local function reader()
        dispatch(br.game.CombatLogGetCurrentEventInfo())
    end
    function dispatch(...)
        -- this reader intend to hold all the combatlog related stuff. this is gonna be used
        -- with as few checks as possible per class/spec as in raiding environment we have already enough to check
        -- pulse common stuff for all classes
        combatLog:common(...)

        -- best way is to split per class so lets make a selector for it
        if class == 1 then      -- Warrior
            combatLog:Warrior(...)
        elseif class == 2 then  -- Paladin
            combatLog:Paladin(...)
        elseif class == 3 then  -- Hunter
            combatLog:Hunter(...)
        elseif class == 4 then  -- Rogue
            combatLog:Rogue(...)
        elseif class == 5 then  -- Priest
            combatLog:Priest(...)
        elseif class == 6 then  -- Deathknight
            combatLog:Deathknight(...)
        elseif class == 7 then  -- Shaman
            combatLog:Shaman(...)
        elseif class == 8 then  -- Mage
            combatLog:Mage(...)
        elseif class == 9 then  -- Warlock
            combatLog:Warlock(...)
        elseif class == 11 then -- Druid
            combatLog:Druid(...)
        elseif class == 12 then -- Demon Hunter
            combatLog:DemonHunter(...)
        elseif class == 13 then -- Evoker
            combatLog:Evoker(...)
        end
    end
    -- add event to the reader
    frame:SetScript("OnEvent", reader)
end

-- class functions(Alphabetically)
function combatLog:common(...)
    br.readers.combatLog:enrageReader(...)
    local timeStamp,
    param,
    hideCaster,
    source,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destination,
    destName,
    destFlags,
    destRaidFlags,
    spell,
    spellName,
    _,
    spellType = ... -- the event, read once by the dispatcher
    guid = guid or br.game.UnitGUID("player") -- the player's GUID doesn't change
    -- Unit Dies - flag the OM so that the next regular OM update cycle cleans up promptly.
    -- Do NOT call updateOM/Update synchronously here: they scan up to 500 objects each and
    -- are called for every UNIT_DIED in the log.  In a raid wipe or big M+ pull, multiple
    -- enemies die in the same frame, stacking full scans inside the event handler and pushing
    -- total Lua time over Blizzard's script budget, which leads to the disconnect.
    if param == "UNIT_DIED" and br.unlocked then
        -- Remove the dead unit from all enemy tracking tables immediately so the rotation
        -- never acts on it, but skip the expensive full-scan.
        local deadUnit = br.game.GetObjectWithGUID(destination)
        if deadUnit ~= nil then
            br.engines.enemiesEngine:forget(deadUnit)
        end
    end
    --[[Combat Validation]]
    if br.rotation ~= nil then
        local inInstance, instanceType = br.game.IsInInstance()
        if br.engines.enemiesEngine.damaged == nil then
            br.engines.enemiesEngine.damaged = {}
        end
        -- Throttle damaged table cleanup to once per second (instead of every combat log event)
        if br.engines.enemiesEngine.damagedCleanupTimer == nil then
            br.engines.enemiesEngine.damagedCleanupTimer = 0
        end
        local currentTime = br.game.GetTime()
        local shouldCleanup = (currentTime - br.engines.enemiesEngine.damagedCleanupTimer) >= 1.0

        if (not inInstance or (instanceType ~= "pvp" and instanceType ~= "arena")) and destination ~= nil
            and (param == "SPELL_DAMAGE" or param == "SWING_DAMAGE")
        then
            -- Group member pointer set: rebuilt at most once per second to give O(1) lookups below.
            -- Previously two separate O(n) loops over healingEngine.friend ran for every single
            -- damage event in the log. In a 20-person raid that was up to 40 ObjectPointer() calls
            -- per event, multiplied by hundreds of events per second during heavy AoE.
            if combatLog._groupPointerSet == nil then combatLog._groupPointerSet = {} end
            if combatLog._groupPointerSetTime == nil then combatLog._groupPointerSetTime = 0 end
            if (currentTime - combatLog._groupPointerSetTime) >= 1.0 then
                combatLog._groupPointerSetTime = currentTime
                local set = {}
                local playerPtr = br.game.ObjectPointer("player")
                if playerPtr then set[playerPtr] = true end
                if br.functions.unit:GetUnitExists("pet") then
                    local petPtr = br.game.ObjectPointer("pet")
                    if petPtr then set[petPtr] = true end
                end
                for i = 1, #br.engines.healingEngine.friend do
                    local friendUnit = br.engines.healingEngine.friend[i].unit
                    if friendUnit then
                        local ptr = br.game.ObjectPointer(friendUnit)
                        if ptr then set[ptr] = true end
                    end
                end
                combatLog._groupPointerSet = set
            end
            local groupSet = combatLog._groupPointerSet

            -- Track units being damaged by player/party/raid
            local sourcePtr = br.game.GetObjectWithGUID(source)
            local damageTarget = br.game.GetObjectWithGUID(destination)
            if damageTarget ~= nil and groupSet[sourcePtr] then
                if br.game.UnitCanAttack("player", damageTarget) then
                    -- The engine's record for the unit (created if the scan hasn't found it yet)
                    local damagedUnit = br.engines.enemiesEngine:track(damageTarget)
                    if damagedUnit then
                        damagedUnit.damageReason = "damaged_by_group"
                        damagedUnit.damageTimestamp = currentTime
                        br.engines.enemiesEngine.damaged[damageTarget] = damagedUnit
                    end
                end
            end

            -- Track units attacking player/party/raid
            local destPtr = br.game.GetObjectWithGUID(destination)
            local attackSource = sourcePtr
            if attackSource ~= nil and groupSet[destPtr] then
                -- The engine's record for the unit (created if the scan hasn't found it yet)
                local attackingUnit = br.engines.enemiesEngine:track(attackSource)
                if attackingUnit then
                    attackingUnit.damageReason = "attacking_group"
                    attackingUnit.damageTimestamp = currentTime
                    br.engines.enemiesEngine.damaged[attackSource] = attackingUnit
                end
            end
        end

        -- Throttled cleanup of damaged table (runs max once per second)
        if shouldCleanup then
            br.engines.enemiesEngine.damagedCleanupTimer = currentTime
            -- More careful cleanup of damaged table
            -- Only remove units that are truly invalid, not just because they haven't been validated yet
            for k, v in pairs(br.engines.enemiesEngine.damaged) do
                local shouldRemove = false
                -- v is the engine's record for the unit
                local unit = v.unit

                -- Remove if unit is dead or ghost
                if br.functions.unit:GetUnitIsDeadOrGhost(unit) then
                    shouldRemove = true
                -- Remove if unit no longer exists
                elseif not br.functions.unit:GetObjectExists(unit) then
                    shouldRemove = true
                -- Remove if not visible
                elseif not br.functions.unit:GetUnitIsVisible(unit) then
                    shouldRemove = true
                -- Remove if player out of combat AND unit was added more than 10 seconds ago
                elseif not br.game.UnitAffectingCombat("player") and v.damageTimestamp and (currentTime - v.damageTimestamp) > 10 then
                    shouldRemove = true
                -- Remove if unit is now friendly (e.g., MC broken)
                elseif not br.game.UnitCanAttack("player", unit) then
                    shouldRemove = true
                -- Remove if unit successfully validated and added to enemy table (job done)
                elseif br.engines.enemiesEngine.enemy[unit] ~= nil then
                    shouldRemove = true
                end

                if shouldRemove then
                    br.engines.enemiesEngine.damaged[k] = nil
                    -- A record the scan never picked up existed only for this table: let it go
                    br.engines.enemiesEngine:release(unit)
                end
            end
        end
    end
    --In flight
    if source == guid and param == "SPELL_CAST_SUCCESS" and br.unlocked and destination ~= nil then --EasyWoWToolbox ~= nil then
        br.functions.InFlight:Add(spell, destination)
    end
    -- br.engines.auraTracker:handleEvent(...)
    ----------------
    --[[Item locks]]
    if source == guid then
        -- DPS potions
        for i = 1, #DPSPotionsSet do
            if spell == DPSPotionsSet[i].Buff then
                br.potionUsed = br.game.GetTime()
                if br.game.UnitAffectingCombat("player") then
                    br.ui.chatOverlay:Show("Potion Used, can reuse in 60 secs.")
                    br.potionReuse = false
                else
                    br.ui.chatOverlay:Show("Potion Used, cannot reuse.")
                    br.potionReuse = true
                end
            end
        end
    end
    --
    ---------------------
    --[[ Swing Timers ]]
    local swing = combatLog.swing
    -- Melee: the player starts auto-attacking (spell 6603 = Attack)
    if param == "SPELL_CAST_SUCCESS" and source == guid and spell == 6603 then
        local speed = br.game.UnitAttackSpeed("player") or 0
        if speed > 0 then
            swing.mh.last  = br.game.GetTime()
            swing.mh.next  = swing.mh.last + speed
            swing.mh.speed = speed
        end
    end

    -- Melee: each swing (hit or miss)
    if (param == "SWING_DAMAGE" or param == "SWING_MISSED") and source == guid then
        local speed = br.game.UnitAttackSpeed("player") or 0
        swing.mh.last  = br.game.GetTime()
        swing.mh.speed = speed
        if speed > 0 then
            swing.mh.next = swing.mh.last + speed
        end
    end

    -- Ranged: Auto Shot fires as SPELL_CAST_SUCCESS with spellId 75 (UnitRangedDamage: lo, hi, speed)
    if param == "SPELL_CAST_SUCCESS" and source == guid and spell == 75 then
        local _, _, rangedSpeed = br.game.UnitRangedDamage("player")
        rangedSpeed = rangedSpeed or 0
        if rangedSpeed > 0 then
            swing.ranged.last  = br.game.GetTime()
            swing.ranged.next  = swing.ranged.last + rangedSpeed
            swing.ranged.speed = rangedSpeed
        end
    end
    -----------------------------------
    --[[ Item Use Success Recorder ]]
    if param == "SPELL_CAST_SUCCESS" then
        if sourceName ~= nil then
            if br.functions.misc:isInCombat("player") and br.functions.unit:GetUnitIsUnit(sourceName, "player") then
                if br.usePot == nil then
                    br.usePot = true
                end
                if spell == 105697 then --Virmen's Bite Buff
                    br.usePot = false
                end
                if spell == 105708 then --Healing Potions
                    br.usePot = false
                end
            end
        end
    end
    ------------------
    --[[Spell Queues]]
    if br.functions.misc:getOptionCheck("Queue Casting") then
        -----------------
        --[[ Cast Failed --> Queue]]
        if param == "SPELL_CAST_FAILED" then
            if sourceName ~= nil then
                if
                    br.functions.misc:isInCombat("player") and br.functions.unit:GetUnitIsUnit(sourceName, "player") and
                    not br.game.C_Spell.IsSpellPassive(spell) and
                    spell ~= br.botSpell and
                    not br.botCast and
                    spell ~= 48018 and
                    spell ~= 48020
                then
                    local notOnCD = true
                    if br.rotation ~= nil then
                        notOnCD = br.functions.spell:getSpellCD(spell) <= br.rotation.state.gcdMax
                    end
                    -- set destination
                    if destination == "" then
                        br.queueDest = nil
                    else
                        br.queueDest = destination
                    end
                    if #br.functions.cast.queue == 0 and notOnCD then
                        br.game.tinsert(br.functions.cast.queue, { id = spell, name = spellName, target = br.queueDest, queuedAt = br.game.GetTime() })
                        if not br.functions.misc:isChecked("Mute Queue") then
                            br.log:say("Queue", "Added " .. br.log.highlight(spellName))
                        end
                    elseif #br.functions.cast.queue ~= 0 then
                        for i = 1, #br.functions.cast.queue do
                            if spell == br.functions.cast.queue[i].id then
                                br.game.tremove(br.functions.cast.queue, i)
                                if not br.functions.misc:isChecked("Mute Queue") then
                                    br.log:say("Queue", "Removed " .. br.log.highlight(spellName))
                                end
                                break
                            elseif notOnCD then
                                br.game.tinsert(br.functions.cast.queue, { id = spell, name = spellName, target = br.queueDest, queuedAt = br.game.GetTime() })
                                if not br.functions.misc:isChecked("Mute Queue") then
                                    br.log:say("Queue", "Added " .. br.log.highlight(spellName))
                                end
                                break
                            end
                        end
                    elseif not br.functions.misc:isChecked("Mute Queue") and not notOnCD then
                        br.log:say("Queue", br.log.highlight(spellName) .. " not added, cooldown greater than gcd")
                    end
                end
            end
        end
        ------------------
        --[[Queue Casted]]
        if sourceName ~= nil then
            if br.functions.misc:isInCombat("player") and br.functions.unit:GetUnitIsUnit(sourceName, "player") then
                local info = br.game.C_Spell.GetSpellInfo(spell)
                local castTime = info and info.castTime or 0
                if
                    (param == "SPELL_CAST_SUCCESS" and castTime == 0) or (param == "SPELL_CAST_START" and castTime > 0) or
                    spell == br.lastCast
                then
                    if br.botCast == true then
                        br.botCast = false
                    end
                    if #br.functions.cast.queue ~= 0 then
                        for i = 1, #br.functions.cast.queue do
                            if spell == br.functions.cast.queue[i].id then
                                br.game.tremove(br.functions.cast.queue, i)
                                if not br.functions.misc:isChecked("Mute Queue") then
                                    br.log:say("Queue", "Cast " .. br.log.highlight(spellName) .. ", removed from the queue")
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    ---------------------------------
    --[[Cast Failed Reason Capture]]
    -- Store the WoW server failure reason string so the cast debug system can report it.
    -- spellType at CLEU position 15 is the failedType string for SPELL_CAST_FAILED events
    -- (e.g. "Out of range", "Not enough mana", "Interrupted").
    -- Use sourceName (player character name) rather than source GUID alone: on TBC private
    -- servers pet ability failures can fire with the player's GUID as source, so the name
    -- check is the reliable discriminator between player and pet cast failures.
    if param == "SPELL_CAST_FAILED" and sourceName == br.game.UnitName("player") then
        if br.functions.lastCast and br.functions.lastCast.lastCastTable then
            if not br.functions.lastCast.lastCastTable.lastFailedReason then
                br.functions.lastCast.lastCastTable.lastFailedReason = {}
            end
            br.functions.lastCast.lastCastTable.lastFailedReason[spell] = spellType
        end
    end
    ---------------------
    --[[Debuff Tracking]]
    if destination ~= nil and destination ~= "" then
        if br.unlocked then --EWT then
            if param == "SPELL_AURA_APPLIED" and spellType == "DEBUFF" then
                local destination = br.game.GetObjectWithGUID(destination)
                local source = br.game.GetObjectWithGUID(source)
                if source ~= nil and br.game.UnitName(source) == br.game.UnitName("player") then
                    source = "player"
                end
                if source == "player" and destination ~= nil then
                    if br.readers.combatLog.debuffTracker[destination] == nil then
                        br.readers.combatLog.debuffTracker[destination] = {}
                    end
                    if br.readers.combatLog.debuffTracker[destination][spell] == nil then
                        br.readers.combatLog.debuffTracker[destination][spell] = {}
                    end
                    br.readers.combatLog.debuffTracker[destination][spell][1] = source
                    br.readers.combatLog.debuffTracker[destination][spell][2] = spell
                    br.readers.combatLog.debuffTracker[destination][spell][3] = destination
                end
            end
        end
    end
    --[[ Last Spell Cast Success ]]
    if source == guid and param == "SPELL_CAST_SUCCESS" then
        -- Add spells we dont want to appear here.
        if spell ~= 155521 then -- Auspicious Spirits
            br.secondLastSpellCastSucess = br.lastSpellCastSuccess
            br.lastSpellCastSuccess = spell
            br.lastSpellCastSuccessTime = br.game.GetTime()
        end
    end
    --[[ Last Spell Cast Started ]]
    if source == guid and (param == "SPELL_CAST_START" or param == "SPELL_CAST_SUCCESS") then
        -- Add spells we dont want to appear here.
        if spell ~= 120361 or spell ~= 75 then -- Barrage fires
            if param == "SPELL_CAST_SUCCESS" and (spell ~= 77767 or spell ~= 163485) or param == "SPELL_CAST_START" then
                br.secondLastSpellStarted = br.lastSpellStarted
                br.lastSpellStarted = spell
            end
        end
    end
    -- Big Raid Damage Tracker
    if br.game.UnitAffectingCombat("player") then
        if param == "SPELL_CAST_START" then
            if spell == 282107 then
                br.pakuWrath = true
            end
        elseif param == "SPELL_CAST_SUCCESS" then
            if spell == 282107 then
                br.pakuWrath = false
            end
        end
    end
    if param == "SPELL_AURA_APPLIED" then
        if spell == 323402 then
            br.shadeUp = true
        end
    end
    if param == "SPELL_AURA_REMOVED" then
        if spell == 323402 then
            br.shadeUp = false
        end
    end
end

function combatLog:Deathknight(...)
    local timeStamp,
    param,
    hideCaster,
    source,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destination,
    destName,
    destFlags,
    destRaidFlags,
    spell,
    spellName,
    _,
    spellType = ... -- the event, read once by the dispatcher
    -- Breath of Sindragosa Active Tracker
    if spell == 152279 and sourceName == br.game.UnitName("player") then
        if param == "SPELL_AURA_APPLIED" then
            br.breathOfSindragosaActive = true
        end
        if param == "SPELL_AURA_REMOVED" then
            br.breathOfSindragosaActive = false
        end
    end
end

function combatLog:DemonHunter(...)
    local timeStamp,
    param,
    hideCaster,
    source,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destination,
    destName,
    destFlags,
    destRaidFlags,
    spell,
    spellName,
    _,
    spellType = ... -- the event, read once by the dispatcher
    if sourceName ~= br.game.UnitName("player") then
        return
    end
    if param == "SPELL_DAMAGE" then
        if spell == 198813 then -- Vengeful Retreat
            -- HackEnabled("NoKnockback", false)
            return
        end
        return
    end
end

function combatLog:Druid(...)
    local timeStamp,
    param,
    hideCaster,
    source,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destination,
    destName,
    destFlags,
    destRaidFlags,
    spell,
    spellName,
    _,
    spellType = ... -- the event, read once by the dispatcher
    -----------
    -- Kitty ---------------
    --[[ Bleed Recorder --]]
    if br.game.C_SpecializationInfo.GetSpecialization() == 2 then
        if source == br.game.UnitGUID("player") then
            if destination ~= nil and destination ~= "" then
                local thisUnit = "target"
                if br.unlocked then --EWT then
                    local destination = br.game.GetObjectWithGUID(destination)
                    if br.functions.unit:GetObjectExists(destination) then
                        thisUnit = destination
                    elseif br.functions.unit:GetObjectExists("target") then
                        thisUnit = br.game.GetObjectWithGUID("target")
                    else
                        thisUnit = br.game.GetObjectWithGUID("player")
                    end
                    if br.rotation ~= nil and br.functions.range:getDistance(thisUnit) < 40 then
                        local debuffID = br.rotation.spells.debuffs
                        local spec = br.loader.selectedSpecID
                        local function snapshot(key)
                            return (spec == 103 or spec == 259) and br.functions.aura:getSnapshotValue(debuffID[key]) or 0
                        end
                        if debuffID ~= nil then
                            local k
                            if spell == debuffID.rake or spell == debuffID.rip then
                                if spell == debuffID.rake then
                                    k = "rake"
                                end
                                if spell == debuffID.rip then
                                    k = "rip"
                                end
                                combatLog.bleed[k] = combatLog.bleed[k] or {}
                                local bleed = combatLog.bleed[k]
                                if bleed[thisUnit] == nil then
                                    bleed[thisUnit] = 0
                                end
                                if param == "SPELL_AURA_REMOVED" then
                                    bleed[thisUnit] = 0
                                    if br.functions.unit:GetUnitIsUnit(thisUnit, "target") then
                                        bleed["target"] = 0
                                    end
                                end
                                if param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH" then
                                    bleed[thisUnit] = snapshot(k)
                                    if br.functions.unit:GetUnitIsUnit(thisUnit, "target") then
                                        bleed["target"] = snapshot(k)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    -----------------------
    --[[ Moonkin ]]
    if br.shroomsTable == nil then
        br.shroomsTable = {}
        br.shroomsTable[1] = {}
    end
    if source == guid and param == "SPELL_SUMMON" and (spell == 147349 or spell == 145205) then
        br.shroomsTable[1].guid = destination
        br.shroomsTable[1].x = nil
        br.shroomsTable[1].y = nil
        br.shroomsTable[1].z = nil
    end
    if
        (param == "UNIT_DIED" or param == "UNIT_DESTROYED") and br.shroomsTable ~= nil and
        br.shroomsTable[1].guid == destination
    then
        br.shroomsTable[1] = {}
    end
    if source == guid and class == 11 and br.game.C_SpecializationInfo.GetSpecialization() == 1 then
        -- Starsurge Casted
        if spell == 78674 and param == "SPELL_CAST_SUCCESS" then
            if br.core then
                br.core.lastStarsurge = br.game.GetTime()
            end
        end
    end
end

function combatLog:Evoker(...)
    local timeStamp,
    param,
    hideCaster,
    source,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destination,
    destName,
    destFlags,
    destRaidFlags,
    spell,
    spellName,
    _,
    spellType = ... -- the event, read once by the dispatcher
    -- if br.functions.unit:GetUnitIsUnit(sourceName, "player") then
    --     print("Param: "..tostring(param)..", Spell: "..tostring(spell)..", SpellName: "..tostring(spellName))
    -- end
end

function combatLog:Hunter(...)
    local timeStamp,
    param,
    hideCaster,
    source,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destination,
    destName,
    destFlags,
    destRaidFlags,
    spell,
    spellName,
    _,
    spellType = ... -- the event, read once by the dispatcher
    --[[ Steady Focus ]]
    if spell == 77767 and param == "SPELL_CAST_SUCCESS" then
        if br.data.settings[br.loader.selectedSpec]["1stFocus"] ~= true then
            br.data.settings[br.loader.selectedSpec]["1stFocus"] = true
        else
            br.data.settings[br.loader.selectedSpec]["1stFocus"] = false
        end
    end
    --[[ Dead Pet Reset ]]
    if br.game.UnitHealth("pet") > 0 then
        br.readers.combatLog.deadPet = false
    end
end

function combatLog:Mage(...)
    local timeStamp,
    param,
    hideCaster,
    source,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destination,
    destName,
    destFlags,
    destRaidFlags,
    spell,
    spellName,
    _,
    spellType = ... -- the event, read once by the dispatcher
    if source == guid then
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
            -- Print("Spell " ..GetTime())
        end
        if param == "SPEL_PERIODIC" and spell == 30451 then
            --Print("Spell Periodic " ..GetTime())
        end
        if param == "SPELL_CAST_SUCCESS" and spell == 30451 then
            --Print("Spell Cast Success " ..GetTime())
        end
        if param == "SPELL_DAMAGE" and spell == 30451 then
            --Print("Spell Damage " ..GetTime())
        end
        if param == "SPELL_MISSED" and spell == 30451 then
            --Print("Spell Missed " ..GetTime())
        end
        if param == "SPELL_AURA_REFRESH" and spell == 36032 then
            --Print("Spell Aura Refresh " ..GetTime())
        end
        if param == "SPELL_AURA_APPLIED" and spell == 36032 then
            --Print("Spell Aura Applied " ..GetTime())
        end
        if param == "SPELL_AURA_APPLIED_DOSE" and spell == 36032 then
            --Print("Spell Aura Applied Dose " ..GetTime())
        end
        if param == "SPELL_AURA_REMOVED" and spell == 36032 then
            --Print("Spell Aura Removed " ..GetTime())
        end
    end
end

function combatLog:Priest(...)
    local timeStamp,
    param,
    hideCaster,
    source,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destination,
    destName,
    destFlags,
    destRaidFlags,
    spell,
    spellName,
    _,
    spellType = ... -- the event, read once by the dispatcher
    if br.game.C_SpecializationInfo.GetSpecialization() == 3 then
        -- Periodic Damage Events
        if param == "SPELL_PERIODIC_DAMAGE" then
            if br.mfTicks == nil then
                br.mfTicks = 0
            end
            -- Mindflay Ticks
            if source == guid and spellName == br.functions.spell:getName(15407) then
                br.mfTicks = br.mfTicks + 1
                br.log:systemDebug("Mindflay + 1 tick" .. "Total Ticks: " .. br.mfTicks)
            end
        end
        -- Corruption was removed.
        if param == "SPELL_AURA_REMOVED" then
            if source == guid then
                -- Mindflay
                if spellName == br.functions.spell:getName(15407) then
                    br.mfTicks = 0
                    br.maxmfTicks = 6
                    br.log:systemDebug("Mindflay ticks reset")
                end
            end
        end

        -- Periodic Damage Events
        if param == "SPELL_DAMAGE" then
            if br.msTicks == nil then
                br.msTicks = 0
            end
            -- Mind Sear Ticks
            if source == guid and spellName == br.functions.spell:getName(48045) and destination == br.game.UnitGUID("target") then
                br.msTicks = br.msTicks + 1
                br.log:systemDebug("Mind Sear + 1 tick" .. "Total Ticks: " .. br.msTicks)
            end
        end
        -- Corruption was removed.
        if param == "SPELL_AURA_REMOVED" then
            if source == guid then
                -- Mindflay
                if spellName == br.functions.spell:getName(48045) then
                    br.msTicks = 0
                    br.maxmsTicks = 6
                    br.log:systemDebug("Mind Sear ticks reset")
                end
            end
        end
    end

    -- last VT
    if br.lastVTTime == nil then
        br.lastVTTime = -999999999
    end
    if param == "SPELL_CAST_START" and spell == 34914 then
        br.lastVTTarget = destination
        br.lastVTTime = br.game.GetTime()
    end
    if param == "SPELL_CAST_FAILED" then
        if spellType == "Interrupted" then
            --print("You moved")
            br.lastVTTarget = nil
            br.lastVTTime = 0
        end
    end
    if not br.discHealCount then
        br.discHealCount = 0
    end
    if sourceName == br.game.UnitName("player") then
        if br.unlocked then
            local thisUnit = br.game.GetObjectWithGUID(destination)
            if
                thisUnit ~= nil and param == "SPELL_CAST_SUCCESS" and
                (br.game.UnitIsFriend(thisUnit, "player") or br.game.UnitIsUnit(thisUnit, "player"))
            then
                --[[ Print("Friend Check: ".. tostring(UnitIsFriend(thisUnit,"player")))
                Print("player Check: ".. tostring(UnitIsUnit(thisUnit,"player")))
                Print("Adding 1 to heal counter") ]]
                br.discHealCount = br.discHealCount + 1
            elseif thisUnit ~= nil and param == "SPELL_CAST_SUCCESS" and not br.game.UnitIsFriend(thisUnit, "player") then
                --[[ Print("Friend Check: ".. tostring(UnitIsFriend(thisUnit,"player")))
                Print("player Check: ".. tostring(UnitIsUnit(thisUnit,"player")))
                Print("Resetting Heal Count") ]]
                br.discHealCount = 0
            end
        end
    end
end

function combatLog:Paladin(...)
    local timeStamp,
    param,
    hideCaster,
    source,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destination,
    destName,
    destFlags,
    destRaidFlags,
    spell,
    spellName,
    _,
    spellType = ... -- the event, read once by the dispatcher
    -----------------------
    --[[ Class Trinket ]]
    if (source == guid and (spell == 35395 or spell == 53595)) then
        br.previousT18classTrinket = destination
    end
    if (source == guid and param == "SPELL_HEAL" and (spell == 184910 or spell == 185101)) then
        br.protPaladinClassTrinketProc = br.game.GetTime()
    end
    --[[ Double Jeopardy ]]
    if spell == 20271 and source == guid and br.previousJudgmentTarget ~= destination then
        br.previousJudgmentTarget = destination
    end
end

function combatLog:Rogue(...)
    local timeStamp,
    param,
    hideCaster,
    source,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destination,
    destName,
    destFlags,
    destRaidFlags,
    spell,
    spellName,
    _,
    spellType = ... -- the event, read once by the dispatcher
    --------------------------------------
    --[[ Pick Pocket Success Recorder ]]
    if br.unpickable == nil then br.unpickable = false end
    if br.pickPocketUnit == nil then br.pickPocketUnit = br.game.UnitGUID("player") end
    if br.pickPocketing == nil then br.pickPocketing = false end
    if param == "SPELL_CAST_START" and spell == 921 then
        br.pickPocketing = true
    end
    if param == "SPELL_CAST_SUCCESS" and spell == 921 then
        br.unpickable = true
        br.pickPocketing = false
    end
    --[[ Bleed Recorder --]]
    if br.game.C_SpecializationInfo.GetSpecialization() == 1 then
        if source == br.game.UnitGUID("player") then
            if destination ~= nil and destination ~= "" then
                local thisUnit = "target"
                if br.unlocked then --EWT then
                    local destination = br.game.GetObjectWithGUID(destination)
                    if br.functions.unit:GetObjectExists(destination) then
                        thisUnit = destination
                    elseif br.functions.unit:GetObjectExists("target") then
                        thisUnit = br.game.GetObjectWithGUID(br.game.UnitGUID("target"))
                    else
                        thisUnit = br.game.GetObjectWithGUID(br.game.UnitGUID("player"))
                    end
                    if br.rotation ~= nil and br.functions.range:getDistance(thisUnit) < 40 then
                        local exsa = combatLog.exsa
                        for _, key in ipairs({ "crimsonTempest", "garrote", "rupture" }) do exsa[key] = exsa[key] or {} end
                        local debuffID = br.rotation.spells.debuffs
                        local k
                        if debuffID ~= nil then
                            if spell == br.rotation.spells.exsanguinate then
                                if exsa.crimsonTempest[thisUnit] == nil then exsa.crimsonTempest[thisUnit] = true end
                                if exsa.garrote[thisUnit] == nil then exsa.garrote[thisUnit] = true end
                                if exsa.rupture[thisUnit] == nil then exsa.rupture[thisUnit] = true end
                                if param == "SPELL_CAST_SUCCESS" then
                                    exsa.rupture[thisUnit] = true
                                    exsa.garrote[thisUnit] = true
                                    exsa.crimsonTempest[thisUnit] = true
                                    if br.functions.unit:GetUnitIsUnit(thisUnit, "target") then
                                        exsa.rupture["target"] = true
                                        exsa.garrote["target"] = true
                                        exsa.crimsonTempest["target"] = true
                                    end
                                end
                            end
                            if spell == debuffID.rupture or spell == debuffID.garrote or spell == debuffID.crimsonTempest then
                                if spell == debuffID.rupture then k = "rupture" end
                                if spell == debuffID.garrote then k = "garrote" end
                                if spell == debuffID.crimsonTempest then k = "crimsonTempest" end
                                combatLog.bleed[k] = combatLog.bleed[k] or {}
                                local bleed = combatLog.bleed[k]
                                local value = 0
                                if param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH" then
                                    local spec = br.loader.selectedSpecID
                                    value = (spec == 103 or spec == 259) and br.functions.aura:getSnapshotValue(debuffID[k]) or 0
                                end
                                if param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH" or param == "SPELL_AURA_REMOVED" then
                                    bleed[thisUnit] = value
                                    exsa[k][thisUnit] = false
                                    if br.functions.unit:GetUnitIsUnit(thisUnit, "target") then
                                        bleed["target"] = value
                                        exsa[k]["target"] = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    -- OUTLAW
    if br.game.C_SpecializationInfo.GetSpecialization() == 2 then
        if source == br.game.UnitGUID("player") then
            if spell == 287916 then
                br.vigorstacks = br.functions.aura:getBuffStacks("player", 287916) or 0
                br.vigorupdate = br.game.GetTime()
                --print(br.vigorstacks..", "..br.vigorupdate)
            end
        end
    end
end

function combatLog:Shaman(...) -- 7
    local timeStamp,
    param,
    hideCaster,
    source,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destination,
    destName,
    destFlags,
    destRaidFlags,
    spell,
    spellName,
    _,
    spellType = ... -- the event, read once by the dispatcher
    --------------------
    --[[ Fire Totem ]]
    if source == guid and param == "SPELL_SUMMON" and (spell == br.rotation.spells.searingTotem or spell == br.rotation.spells.magmaTotem) then
        br.activeTotem = destination
        br.activeTotemPosition = br.functions.unit:GetObjectPosition("player")
    end
    if param == "UNIT_DESTROYED" and br.activeTotem == destination then
        br.activeTotem = nil
    end
end

function combatLog:Warlock(...) -- 9
    local timeStamp,
    param,
    hideCaster,
    source,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destination,
    destName,
    destFlags,
    destRaidFlags,
    spell,
    spellName,
    _,
    spellType = ... -- the event, read once by the dispatcher
    if br.game.C_SpecializationInfo.GetSpecialization() == 1 then
        if source == guid and param == "UNIT_SPELLCAST_CHANNEL_START" then
            -- Drain Soul counter
            if br.game.UnitChannelInfo("player") == br.functions.spell:getName(198590) then
                br.dsTicks = 1
            end
        end

        -- We stopped a channel, reset counters.
        if source == guid and param == "UNIT_SPELLCAST_CHANNEL_STOP" then
            br.dsTicks = 1
        end

        -- CLear dot table after each death/individual combat scenarios.
        if source == guid and param == "PLAYER_REGEN_ENABLED" or param == "PLAYER_REGEN_DISABLED" then
        end

        if param == "UNIT_DIED" then
        end
        --if]] #kinkydots > 0 then for i=1,#kinkydots do if kinkydots[i].guid == destGUID then tremove(kinkydots, i) return true --]]end end end

        -- Corruption was refreshed.
        if param == "SPELL_AURA_REFRESH" then
            -- Drain Soul
            if source == guid and spellName == br.functions.spell:getName(198590) then
                br.dsTicks = 1
                br.maxdsTicks = 5
            end
        end

        -- Successfull Spell Casts
        if param == "SPELL_CAST_SUCCESS" then
            if source == guid then
            end
        end

        -- Periodic Damage Events
        if param == "SPELL_PERIODIC_DAMAGE" then
            if br.dsTicks == nil then
                br.dsTicks = 0
            end
            -- Drain Soul Ticks
            if source == guid and spellName == br.functions.spell:getName(198590) then
                br.dsTicks = br.dsTicks + 1
                br.log:systemDebug("Drain Soul + 1 tick" .. "Total Ticks: " .. br.dsTicks)
            end
        end
        -- Corruption was removed.
        if param == "SPELL_AURA_REMOVED" then
            if source == guid then
                -- Drain Soul
                if spellName == br.functions.spell:getName(198590) then
                    br.dsTicks = 1
                    br.maxdsTicks = 5
                    br.log:systemDebug("Drain Soul ticks reset")
                end
            end
        end

        -- Corruption was applied.
        if param == "SPELL_AURA_APPLIED" then
            if source == guid then
            end
        end
    end
    if br.game.C_SpecializationInfo.GetSpecialization() == 2 then
        -- if source == guid and param == "SPELL_CAST_SUCCESS" then
        --     -- Hand of Guldan
        --     if  == 105174 then
        --         if not br.functions.lastCast.lastCastTable.hog then br.functions.lastCast.lastCastTable.hog = {} end
        --         if br.lastCast then
        --             tinsert(br.functions.lastCast.lastCastTable.hog, 1, GetTime())
        --             if #br.functions.lastCast.lastCastTable.hog == 5 then
        --                 br.functions.lastCast.lastCastTable.hog[5] = nil
        --             end
        --         end
        --     end
        --     -- Line CD
        --     if not br.functions.lastCast.lastCastTable.line_cd then br.functions.lastCast.lastCastTable.line_cd = {} end
        --     br.functions.lastCast.lastCastTable.line_cd[] = GetTime()
        -- end
        -- -- Demonology Manager
        -- -- Imps are summoned
        -- if param == "SPELL_SUMMON" and source == guid and ( == 104317 or  == 279910) then
        --     print("Imp SUMMON")
        -- end
        -- -- Other Demons are summoned
        -- if param == "SPELL_SUMMON" and source == guid and not (spell == 104317 or spell == 279910) then
        --     print("Demon SUMMON")
        -- end
    end
    if br.game.C_SpecializationInfo.GetSpecialization() == 3 then
        -- last Immolate
        if param == "SPELL_CAST_SUCCESS" and spell == 348 then
            br.lastImmolateTarget = destination
            br.lastImmolateTime = br.game.GetTime()
        end
    end
    ---------------------
    --[[ Pet Manager --]]
    if source == guid and param == "SPELL_CAST_SUCCESS" then
        if spell == 688 or spell == 112866 then
            br.petSummoned = 1
            br.petSummonedTime = br.game.GetTime()
        end
        if spell == 697 or spell == 112867 then
            br.petSummoned = 2
            br.petSummonedTime = br.game.GetTime()
        end
        if spell == 691 or spell == 112869 then
            br.petSummoned = 3
            br.petSummonedTime = br.game.GetTime()
        end
        if spell == 712 or spell == 112868 then
            br.petSummoned = 4
            br.petSummonedTime = br.game.GetTime()
        end
        if spell == 30146 or spell == 112870 then
            br.petSummoned = 5
            br.petSummonedTime = br.game.GetTime()
        end
    end
end

function combatLog:Warrior(...)
    local timeStamp,
    param,
    hideCaster,
    source,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destination,
    destName,
    destFlags,
    destRaidFlags,
    spell,
    spellName,
    _,
    spellType = ... -- the event, read once by the dispatcher
    ----------------------------------
    --[[ Bleed Recorder (Warrior) --]]
    if destName == br.game.UnitName("player") then
        br.reflectPlayer = true
    elseif br.debug.timer:useTimer("reflect reset", 0.8) then
        br.reflectPlayer = false
    end
    if br.game.C_SpecializationInfo.GetSpecialization("player") == 1 then
        -- snapshot on spellcast
        if source == guid and param == "SPELL_CAST_SUCCESS" then
            -- but only record the snapshot if it successfully applied
            if spell == 115767 then
                br.deepWoundsCastAP = br.game.UnitAttackPower("player")
            end
        elseif
            source == guid and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") and
            br.deepWoundsCastAP ~= nil
        then
            if spell == 115767 then
                br.deepWoundsStoredAP = br.deepWoundsCastAP
            end
        end
    end
end

br.lifecycle:onStart(20, "combat log reader", function() combatLog:combatLog() end)

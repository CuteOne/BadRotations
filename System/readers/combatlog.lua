br.class = select(3, UnitClass("player"))
br.guid = UnitGUID("player")
-- specific reader location
br.read = {}
br.read.combatLog = {}
br.read.debuffTracker = {}
br.read.enraged = {}
local cl = br.read
-- will update the br.read.enraged list
function br.read.enrageReader(...)
    if getOptionCheck("Enrages Handler") then
        local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
        -- here we will take all spell aura and check if we hold this aura in our enrage table
        -- if we find a match, we set the unit to whitelist with time remaining on the buff
        if param == "SPELL_AURA_APPLIED" and destName ~= nil then
            if br.lists.dispell[spell] ~= nil then
                -- find unit in engine, if its not there, dont add it.
                if destination ~= nil then
                    tinsert(br.read.enraged, 1, {guid = destination, spellType = br.lists.dispell[spell], buffID = spell})
                end
            end
        end
        if param == "SPELL_AURA_REMOVED" then
            -- look for a match to remove
            local targets = br.read.enraged
            if #targets > 0 then
                for i = #targets, 1, -1 do
                    if targets[i].guid == destination and targets[i].buffID == spell then
                        tremove(br.read.enraged, i)
                    end
                end
            end
        end
    -- once a buff fades or is dispelled, we want to remove it from whitelist if its there
    end
end
function br.read.combatLog()
    ---------------------------
    --[[ Combat Log Reader --]]
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    local function reader(self, event, ...)
        local cl = br.read
        -- this reader intend to hold all the combatlog related stuff. this is gonna be used
        -- with as few checks as possible per class/spec as in raiding environment we have already enough to check
        -- pulse common stuff for all classes
        cl:common(...)

        -- best way is to split per class so lets make a selector for it
        local class = br.class
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
        elseif class == 12 then -- Demon Hunter
            cl:DemonHunter(...)
        end
    end
    -- add event to the reader
    frame:SetScript("OnEvent", reader)
end
-- class functions(Alphabetically)
function cl:common(...)
    br.read.enrageReader(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    br.guid = UnitGUID("player")
    --[[Combat Validation]]
    if br.player ~= nil then
        local inInstance, instanceType = IsInInstance()
        if br.damaged == nil then br.damaged = {} end
        if (not inInstance or (instanceType ~= "pvp" and instanceType ~= "arena"))
            and destination ~= nil and (param == "SPELL_DAMAGE" or param == "SWING_DAMAGE")
        then
            local thisUnit = GetObjectWithGUID(destination)
            if br.damaged[thisUnit] == nil and br.units[thisUnit] ~= nil and br.enemy[thisUnit] == nil then
                for i = 1, #br.friend do
                    if ObjectPointer(br.friend[i].unit) == GetObjectWithGUID(source) then
                        if br.damaged[thisUnit] == nil then br.damaged[thisUnit] = thisUnit break end
                    end
                end
            end
        end
        for k,v in pairs(br.damaged) do
            if br.units[v] == nil or not UnitAffectingCombat("player") or UnitIsDeadOrGhost(v) then br.damaged[v] = nil end
        end
    end
    --In flight
    if source == br.guid and param == "SPELL_CAST_SUCCESS" and br.unlocked and destination ~= nil then --EasyWoWToolbox ~= nil then
        br.InFlight.Add(spell, destination)
    end
    -- br.tracker.handleEvent(...)
    ----------------
    --[[Item locks]]
    if source == br.guid then
        -- TODO: OUTDATED - MoP
        local DPSPotionsSet = {
            [1] = {Buff = 105702, Item = 76093}, -- Intel
            [2] = {Buff = 105697, Item = 76089}, -- Agi
            [3] = {Buff = 105706, Item = 76095} -- Str
        }
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
        end
    end
     --
    ---------------------
    --[[ Swing Timer ]] 
    if swingTimer == nil then
        swingTimer = 0
    end
    if nextMH == nil then
        nextMH = GetTime() + UnitAttackSpeed("player")
    end
    if param == "SWING_DAMAGE" and source == br.guid then
        swingTimer = 0
        lastMH = GetTime()
        nextMH = lastMH + UnitAttackSpeed("player")
    end

    if swingTimer then
        if nextMH - GetTime() < 0 then
            swingTimer = 0
        else
            swingTimer = nextMH - GetTime()
        end
    end
    -----------------------------------
    --[[ Item Use Success Recorder ]]
    if param == "SPELL_CAST_SUCCESS" then
        if sourceName ~= nil then
            if isInCombat("player") and GetUnitIsUnit(sourceName, "player") then
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
        end
    end
    ------------------
    --[[Spell Queues]]
    if getOptionCheck("Queue Casting") then
        -----------------
        --[[ Cast Failed --> Queue]]
        if param == "SPELL_CAST_FAILED" then
            if sourceName ~= nil then
                if isInCombat("player") and GetUnitIsUnit(sourceName, "player") and not IsPassiveSpell(spell)
                    and spell ~= botSpell and not botCast and spell ~= 48018 and spell ~= 48020
                then
                    local notOnCD = true
                    if br ~= nil and br.player ~= nil then notOnCD = getSpellCD(spell) <= br.player.gcdMax end
                    -- set destination
                    if destination == "" then
                        queueDest = nil
                    else
                        queueDest = destination
                    end
                    if br.player ~= nil and #br.player.queue == 0 and notOnCD then
                        tinsert(br.player.queue, {id = spell, name = spellName, target = queueDest})
                        if not isChecked("Mute Queue") then
                            Print("Added |cFFFF0000" .. spellName .. "|r to the queue.")
                        end
                    elseif br.player ~= nil and #br.player.queue ~= 0 then
                        for i = 1, #br.player.queue do
                            if spell == br.player.queue[i].id then
                                tremove(br.player.queue,i)
                                if not isChecked("Mute Queue") then
                                    Print("Removed |cFFFF0000" .. spellName .. "|r  from the queue.")
                                end
                                break
                            elseif notOnCD then
                                tinsert(br.player.queue, {id = spell, name = spellName, target = queueDest})
                                if not isChecked("Mute Queue") then
                                    Print("Added |cFFFF0000" .. spellName .. "|r to the queue.")
                                end
                                break
                            end
                        end
                    elseif not isChecked("Mute Queue") and not notOnCD then
                        Print("Spell |cFFFF0000" .. spellName .. "|r not added, cooldown greater than gcd.")
                    end
                end
            end
        end
        ------------------
        --[[Queue Casted]]
        if sourceName ~= nil then
            if isInCombat("player") and GetUnitIsUnit(sourceName, "player") then
                local castTime = select(4, GetSpellInfo(spell)) or 0
                if (param == "SPELL_CAST_SUCCESS" and castTime == 0) or (param == "SPELL_CAST_START" and castTime > 0) or spell == lastCast then
                    if botCast == true then
                        botCast = false
                    end
                    if br.player ~= nil and br.player.queue ~= nil and #br.player.queue ~= 0 then
                        for i = 1, #br.player.queue do
                            if spell == br.player.queue[i].id then
                                tremove(br.player.queue, i)
                                if not isChecked("Mute Queue") then
                                    Print("Cast Success! - Removed |cFFFF0000" .. spellName .. "|r from the queue.")
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    ---------------------
    --[[Debuff Tracking]]
    if destination ~= nil and destination ~= "" then
        if br.unlocked then --EWT then
            if param == "SPELL_AURA_APPLIED" and spellType == "DEBUFF" then
                local destination = GetObjectWithGUID(destination)
                local source = GetObjectWithGUID(source)
                if source ~= nil and UnitName(source) == UnitName("player") then source = "player" end
                if source == "player" and destination ~= nil then
                    if br.read.debuffTracker[destination] == nil then br.read.debuffTracker[destination] = {} end
                    if br.read.debuffTracker[destination][spell] == nil then br.read.debuffTracker[destination][spell] = {} end
                    br.read.debuffTracker[destination][spell][1] = source
                    br.read.debuffTracker[destination][spell][2] = spell
                    br.read.debuffTracker[destination][spell][3] = destination
                end
            end
        end
    end
    ------------------
    --[[Pandemic]]
    if source == UnitGUID("player") then
        if destination ~= nil and destination ~= "" then
            local thisUnit = thisUnit
            if br.unlocked then --EWT then
                local destination = GetObjectWithGUID(destination)
                if GetObjectExists(destination) then
                    thisUnit = destination
                elseif GetObjectExists("target") then
                    thisUnit = GetObjectWithGUID(UnitGUID("target"))
                else
                    thisUnit = GetObjectWithGUID(UnitGUID("player"))
                end
                if br.player ~= nil then
                    local debuff = br.player.debuff
                    local pandemic = br.player.pandemic
                    if br.player["spell"].debuffs ~= nil then
                        if param == "SPELL_AURA_REMOVED" then
                            if not UnitAffectingCombat("player") or not UnitExists(thisUnit) or UnitIsDeadOrGhost(thisUnit) then
                                if pandemic[thisUnit] ~= nil then pandemic[thisUnit] = nil end
                            else
                                for k,v in pairs(br.player["spell"].debuffs) do
                                    if spell == v and pandemic[thisUnit] ~= nil and pandemic[thisUnit][k] ~= nil then
                                        pandemic[thisUnit][k] = 0;
                                        break
                                    end
                                end
                            end
                        end
                        if param == "SPELL_AURA_APPLIED" then
                            for k,v in pairs(br.player["spell"].debuffs) do
                                if thisUnit ~= nil and spell == v then
                                    if pandemic[thisUnit] == nil then pandemic[thisUnit] = {} end
                                    if (pandemic[thisUnit][k] == nil or pandemic[thisUnit][k] == 0
                                        or debuff[k].duration(thisUnit) ~= pandemic[thisUnit][k] + (pandemic[thisUnit][k] * 0.3))
                                    then
                                        --Print("Debuff: "..spellName.." Applied (k = "..k..", v = "..v..", duration = "..debuff[k].duration(thisUnit))
                                        pandemic[thisUnit][k] = debuff[k].duration(thisUnit)
                                        break;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    ---------------
    --[[ Debug --]]
    if getOptionCheck("Rotation Log") == true and source == br.guid and
        (param == "SPELL_CAST_SUCCESS" or (param == "SPELL_CAST_FAILED" and getOptionCheck("Display Failcasts")))
     then
        -- available locals
        -- timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
        -- destName, destFlags, destRaidFlags, spell, spellName, _, spellType
        -- Add spells we dont want to appear here.
        if spell ~= 75 and -- Auto Shot
            spell ~= 88263 and -- 88263
            -- and SpellID ~= 172        -- Corruption
            spell ~= 8690 and -- Hearthstone
            spell ~= 194279 and -- Caltrop DoT
            spell ~= 196771 and
            spell ~= 211793 and
            spell ~= 139546
         then -- Combo Point
            local color = "|cff12C8FF"
            local white = "|cffFFFFFF"
            local red = "|cffFF001E"
            local yellow = "|cffFFDD11"
            if lastCount == nil then
                lastCount = 0
            end
            if castCount == nil then
                castCount = 0
            end
            -- add counters
            if param == "SPELL_CAST_SUCCESS" then
                if br.data.successCasts == nil then
                    br.data.successCasts = 0
                end
                -- color = "|cff12C8FF"
                br.data.successCasts = br.data.successCasts + 1
                castCount = br.data.successCasts
                lastCount = castCount
            elseif param == "SPELL_CAST_FAILED" then
                if br.data.failCasts == nil then
                    br.data.failCasts = 0
                end
                color = red
                br.data.failCasts = br.data.failCasts + 1
                if lastCount == castCount then
                    castCount = lastCount + 1
                elseif castCount > lastCount then
                    castCount = castCount
                else
                    castCount = lastCount
                end
                -- Blizz CastSpellByName bug bypass
                if GetSpellInfo(spell) == GetSpellInfo(botSpell) and spell ~= botSpell then
                    -- Print("Spell Error Bypass: Correct ID = "..botSpell..", Incorrect ID = "..spell..", on "..botUnit)
                    br.castID = true
                end
            end
            -- set destination
            if destination == nil or destName == nil then
                debugdest = "Target not required"
            else
                debugdest = destName --.." "..destination
            end
            -- set spell
            if spell == nil then
                debugSpell = ""
            else
                debugSpell = spell
            end
            local Power = " Power: " .. UnitPower("player")
            -- create display row
            -- local textString = color..br.data.successCasts..red.."/"..white..getCombatTime()..red.."/"..color..spellName
            --   ..red..debugdest..color..debugSpell.."|cffFFDD11"..Power
            -- string.format("%-25s", debugdest)
            local textString = color .. string.format("%-3d", castCount) .. white .. "| " .. yellow .. string.format("%-3.3f", getCombatTime()) ..
                white .. "| " .. color .. string.format("%-6.6d", debugSpell) .. white .. "| " .. color ..  string.format("%-25.25s", spellName) ..
                white .. "| " .. red .. string.format("%.25s", debugdest)
            -- ..white.." | "..yellow..Power
            -- pulse display
            br.ui.window.debug:AddMessage(textString:gsub("\n", " | "))
        end
    end
    --[[ Last Spell Cast Success ]]
    if source == br.guid and param == "SPELL_CAST_SUCCESS" then
        -- Add spells we dont want to appear here.
        if spell ~= 155521 then -- Auspicious Spirits
            secondLastSpellCastSucess = lastSpellCastSuccess
            lastSpellCastSuccess = spell
            lastSpellCastSuccessTime = GetTime()
        end
    end
    --[[ Last Spell Cast Started ]]
    if source == br.guid and (param == "SPELL_CAST_START" or param == "SPELL_CAST_SUCCESS") then
        -- Add spells we dont want to appear here.
        if spell ~= 120361 or spell ~= 75 then -- Barrage fires
            if param == "SPELL_CAST_SUCCESS" and (spell ~= 77767 or spell ~= 163485) or param == "SPELL_CAST_START" then
                secondLastSpellStarted = lastSpellStarted
                lastSpellStarted = spell
            end
        end
    end
    -- Big Raid Damage Tracker
    if UnitAffectingCombat("player") then
        if param == "SPELL_CAST_START" then
            if spell == 282107 then
                pakuWrath = true
            end
        elseif param == "SPELL_CAST_SUCCESS" then
            if spell == 282107 then
                pakuWrath = false
            end
        end
    end
end
function cl:Deathknight(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    -- Breath of Sindragosa Active Tracker
    if spell == 152279 and sourceName == UnitName("player") then
        if param == "SPELL_AURA_APPLIED" then
            breathOfSindragosaActive = true
        end
        if param == "SPELL_AURA_REMOVED" then
            breathOfSindragosaActive = false
        end
    end
end
function cl:DemonHunter(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    if sourceName ~= UnitName("player") then
        return
    end
    if event == "SPELL_DAMAGE" then
        if spell == 198813 then -- Vengeful Retreat
            -- HackEnabled("NoKnockback", false)
            return
        end
        return
    end
end
function cl:Druid(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    -----------
    -- Kitty ---------------
    --[[ Bleed Recorder --]]
    if GetSpecialization() == 2 then
        if source == UnitGUID("player") then
            if destination ~= nil and destination ~= "" then
                local thisUnit = thisUnit
                if br.unlocked then --EWT then
                    local destination = GetObjectWithGUID(destination)
                    if GetObjectExists(destination) then
                        thisUnit = destination
                    elseif GetObjectExists("target") then
                        thisUnit = GetObjectWithGUID(UnitGUID("target"))
                    else
                        thisUnit = GetObjectWithGUID(UnitGUID("player"))
                    end
                    if br.player ~= nil and getDistance(thisUnit) < 40 then
                        local debuff = br.player.debuff
                        local debuffID = br.player["spell"].debuffs
                        if debuffID ~= nil then
                            if spell == debuffID.rake or spell == debuffID.rip then
                                if spell == debuffID.rake then
                                    k = "rake"
                                end
                                if spell == debuffID.rip then
                                    k = "rip"
                                end
                                if debuff[k].bleed == nil then
                                    debuff[k].bleed = {}
                                end
                                if debuff[k].bleed[thisUnit] == nil then
                                    debuff[k].bleed[thisUnit] = 0
                                end
                                if param == "SPELL_AURA_REMOVED" then
                                    debuff[k].bleed[thisUnit] = 0
                                    if GetUnitIsUnit(thisUnit, "target") then
                                        debuff[k].bleed["target"] = 0
                                    end
                                end
                                if param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH" then
                                    debuff[k].bleed[thisUnit] = debuff[k].calc()
                                    if GetUnitIsUnit(thisUnit, "target") then
                                        debuff[k].bleed["target"] = debuff[k].calc()
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
    if shroomsTable == nil then
        shroomsTable = {}
        shroomsTable[1] = {}
    end
    if source == br.guid and param == "SPELL_SUMMON" and (spell == 147349 or spell == 145205) then
        shroomsTable[1].guid = destination
        shroomsTable[1].x = nil
        shroomsTable[1].y = nil
        shroomsTable[1].z = nil
    end
    if
        (param == "UNIT_DIED" or param == "UNIT_DESTROYED" or GetTotemInfo(1) ~= true) and shroomsTable ~= nil and
            shroomsTable[1].guid == destination
     then
        shroomsTable[1] = {}
    end
    if source == br.guid and class == 11 and GetSpecialization() == 1 then
        -- Starsurge Casted
        if spell == 78674 and param == "SPELL_CAST_SUCCESS" then
            if core then
                core.lastStarsurge = GetTime()
            end
        end
    end
end
function cl:Hunter(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    --[[ Steady Focus ]]
    if spell == 77767 and param == "SPELL_CAST_SUCCESS" then
        if br.data.settings[br.selectedSpec]["1stFocus"] ~= true then
            br.data.settings[br.selectedSpec]["1stFocus"] = true
        else
            br.data.settings[br.selectedSpec]["1stFocus"] = false
        end
    end
    --[[ Dead Pet Reset ]]
    if UnitHealth("pet") > 0 then br.deadPet = false end
end
function cl:Mage(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    if source == br.guid then
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
function cl:Monk(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    -- if prevCombo == nil or not UnitAffectingCombat("player") then prevCombo = 6603 end
    if br.player ~= nil and GetSpecialization() == 3 and br.player.spell.fistsOfFury ~= nil then
        local myspell = br.player.spell
        local var 	= br.player.variables
        local comboSpells = {
            [myspell.blackoutKick]              = true,
            [myspell.chiBurst]                  = true,
            [myspell.chiWave]                   = true,
            [myspell.cracklingJadeLightning]    = true,
            [myspell.expelHarm]                 = true,
            [myspell.fistsOfFury]               = true,
            [myspell.fistOfTheWhiteTiger]       = true,
            [myspell.flyingSerpentKick]         = true,
            [myspell.risingSunKick]             = true,
            [myspell.rushingJadeWind]           = true,
            [myspell.spinningCraneKick]         = true,
            [myspell.tigerPalm]                 = true,
            [myspell.touchOfDeath]              = true,
            [myspell.whirlingDragonPunch]       = true,
            [myspell.faelineStomp]              = true,
        }
        if var.lastCombo == nil or not UnitAffectingCombat("player") then var.lastCombo = 6603 end
        if sourceName ~= nil then
            if isInCombat("player") and GetUnitIsUnit(sourceName, "player") then
                -- Last Combo
                if param == "SPELL_CAST_SUCCESS" then
                    -- Print("Last Successful Spell was "..GetSpellInfo(spell).." with ID: "..spell)
                    if comboSpells[spell] and spell ~= var.lastCombo then
                        -- prevCombo = lastCombo
                        var.lastCombo = spell
                        -- Print(GetSpellInfo(var.lastCombo).." Success! ")--- Prev Last Combo was: "..GetSpellInfo(prevCombo))
                    end
                end
            end
        end
    end
end
function cl:Priest(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    if GetSpecialization() == 3 then
        -- Periodic Damage Events
        if param == "SPELL_PERIODIC_DAMAGE" then
            if br.mfTicks == nil then br.mfTicks = 0 end
            -- Mindflay Ticks
            if source == br.guid and spellName == GetSpellInfo(15407) then br.mfTicks = br.mfTicks + 1 br.addonDebug("Mindflay + 1 tick" .. "Total Ticks: " .. br.mfTicks) end
        end
        -- Corruption was removed.
        if param == "SPELL_AURA_REMOVED" then
            if source == br.guid then
                -- Mindflay
                if spellName == GetSpellInfo(15407) then br.mfTicks = 0 br.maxmfTicks = 6 br.addonDebug("Mindflay ticks reset") end
            end
        end

        -- Periodic Damage Events
        if param == "SPELL_DAMAGE" then
            if br.msTicks == nil then br.msTicks = 0 end
            -- Mind Sear Ticks
            if source == br.guid and spellName == GetSpellInfo(48045) and destination == UnitGUID('target') then br.msTicks = br.msTicks + 1 br.addonDebug("Mind Sear + 1 tick" .. "Total Ticks: " .. br.msTicks) end
        end
        -- Corruption was removed.
        if param == "SPELL_AURA_REMOVED" then
            if source == br.guid then
                -- Mindflay
                if spellName == GetSpellInfo(48045) then br.msTicks = 0 br.maxmsTicks = 6 br.addonDebug("Mind Sear ticks reset") end
            end
        end
    end

    -- last VT
    if lastVTTime == nil then
        lastVTTime = -999999999
    end
    if param == "SPELL_CAST_START" and spell == 34914 then
        lastVTTarget = destination
        lastVTTime = GetTime()
    end
    if param == "SPELL_CAST_FAILED" then
        if spellType == "Interrupted" then
            --print("You moved")
            lastVTTarget = nil
            lastVTTime = 0
        end
    end
    if not discHealCount then
        discHealCount = 0
    end
    if sourceName == UnitName("player") then
        if br.unlocked then
            local thisUnit = GetObjectWithGUID(destination)
            if thisUnit~=nil and param == "SPELL_CAST_SUCCESS" and (UnitIsFriend(thisUnit,"player") or UnitIsUnit(thisUnit,"player")) then
                --[[ Print("Friend Check: ".. tostring(UnitIsFriend(thisUnit,"player")))
                Print("player Check: ".. tostring(UnitIsUnit(thisUnit,"player")))
                Print("Adding 1 to heal counter") ]]
                discHealCount = discHealCount + 1
            elseif thisUnit ~= nil and param == "SPELL_CAST_SUCCESS" and not UnitIsFriend(thisUnit, "player") then
                --[[ Print("Friend Check: ".. tostring(UnitIsFriend(thisUnit,"player")))
                Print("player Check: ".. tostring(UnitIsUnit(thisUnit,"player")))
                Print("Resetting Heal Count") ]]
                discHealCount = 0
            end
        end
    end
end
function cl:Paladin(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    -----------------------
    --[[ Class Trinket ]]
    if (source == br.guid and (spell == 35395 or spell == 53595)) then
        previousT18classTrinket = destination
    end
    if (source == br.guid and param == "SPELL_HEAL" and (spell == 184910 or spell == 185101)) then
        protPaladinClassTrinketProc = GetTime()
    end
    --[[ Double Jeopardy ]]
    if spell == 20271 and source == br.guid and previousJudgmentTarget ~= destination then
        previousJudgmentTarget = destination
    end
end
function cl:Rogue(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    --------------------------------------
    --[[ Pick Pocket Success Recorder ]]
    if canPickpocket == nil then
        canPickpocket = true
    end
    if param == "SPELL_CAST_SUCCESS" and spell == 921 then
        canPickpocket = false
    end
    --[[ Bleed Recorder --]]
    if GetSpecialization() == 1 then
        if source == UnitGUID("player") then
            if destination ~= nil and destination ~= "" then
                local thisUnit = thisUnit
                if br.unlocked then --EWT then
                    local destination = GetObjectWithGUID(destination)
                    if GetObjectExists(destination) then
                        thisUnit = destination
                    elseif GetObjectExists("target") then
                        thisUnit = GetObjectWithGUID(UnitGUID("target"))
                    else
                        thisUnit = GetObjectWithGUID(UnitGUID("player"))
                    end
                    if br.player ~= nil and getDistance(thisUnit) < 40 then
                        local debuff = br.player.debuff
                        local debuffID = br.player.spell.debuffs
                        if debuffID ~= nil then
                            if spell == 200806 then
                                if debuff.rupture.exsa == nil then
                                    debuff.rupture.exsa = {}
                                end
                                if debuff.garrote.exsa == nil then
                                    debuff.garrote.exsa = {}
                                end
                                if debuff.garrote.exsa[thisUnit] == nil then
                                    debuff.garrote.exsa[thisUnit] = true
                                end
                                if debuff.rupture.exsa[thisUnit] == nil then
                                    debuff.rupture.exsa[thisUnit] = true
                                end
                                if param == "SPELL_CAST_SUCCESS" then
                                    debuff.rupture.exsa[thisUnit] = true
                                    debuff.garrote.exsa[thisUnit] = true
                                    if GetUnitIsUnit(thisUnit, "target") then
                                        debuff.rupture.exsa["target"] = true
                                        debuff.garrote.exsa["target"] = true
                                    end
                                end
                            end
                            if spell == debuffID.rupture or spell == debuffID.garrote then
                                if spell == debuffID.rupture then
                                    k = "rupture"
                                end
                                if spell == debuffID.garrote then
                                    k = "garrote"
                                end
                                if debuff[k].bleed == nil then
                                    debuff[k].bleed = {}
                                end
                                if param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH" then
                                    debuff[k].bleed[thisUnit] = debuff[k].calc()
                                    debuff[k].exsa[thisUnit] = false
                                    if GetUnitIsUnit(thisUnit, "target") then
                                        debuff[k].bleed["target"] = debuff[k].calc()
                                        debuff[k].exsa["target"] = false
                                    end
                                end
                                if param == "SPELL_AURA_REMOVED" then
                                    debuff[k].bleed[thisUnit] = 0
                                    debuff[k].exsa[thisUnit] = false
                                    if GetUnitIsUnit(thisUnit, "target") then
                                        debuff[k].bleed["target"] = 0
                                        debuff[k].exsa["target"] = false
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
    if GetSpecialization() == 2 then
        if source == UnitGUID("player") then
            if spell == 287916 then
                br.vigorstacks = getBuffStacks("player",287916) or 0
                br.vigorupdate = GetTime()
                --print(br.vigorstacks..", "..br.vigorupdate)
            end
        end
    end
end
function cl:Shaman(...) -- 7
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    --------------------
    --[[ Fire Totem ]]
    if source == br.guid and param == "SPELL_SUMMON" and (spell == _SearingTotem or spell == _MagmaTotem) then
        activeTotem = destination
        activeTotemPosition = GetObjectPosition("player")
    end
    if param == "UNIT_DESTROYED" and activeTotem == destination then
        activeTotem = nil
    end
    -------------
    --[[ Lightning Bolt ]]
    if br.player ~= nil and GetSpecialization() == 2 then
        if sourceName ~= nil then
            if isInCombat("player") and GetUnitIsUnit(sourceName, "player") then
                -- Chain Lightning / Lightning Bolt 
                if lightningStarted == nil then lightningStarted = false end
                if param == "SPELL_CAST_START" then
                    if (spell == br.player.spell.lightningBolt or spell == br.player.spell.chainLightning) and br.player.variables.fillLightning then
                        lightningStarted= true
                    end
                end
                if param == "SPELL_CAST_SUCCESS" then
                    if (spell == br.player.spell.lightningBolt or spell == br.player.spell.chainLightning) and br.player.variables.fillLightning and lightningStarted then
                        br.player.variables.fillLightning = false
                        lightningStarted = false
                    end
                end
            end
        end
    end
end
function cl:Warlock(...) -- 9
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    if GetSpecialization() == 1 then
        if source == br.guid and param == "UNIT_SPELLCAST_CHANNEL_START" then
            -- Drain Soul counter
            if UnitChannelInfo("player") == GetSpellInfo(198590) then br.dsTicks = 1 end
	    end

        -- We stopped a channel, reset counters.
        if source == br.guid and param == "UNIT_SPELLCAST_CHANNEL_STOP" then br.dsTicks = 1 end
        
        -- CLear dot table after each death/individual combat scenarios. 
        if source == br.guid and param == "PLAYER_REGEN_ENABLED" or SubEvent == "PLAYER_REGEN_DISABLED" then  end

        if param == "UNIT_DIED" then     end--if]] #kinkydots > 0 then for i=1,#kinkydots do if kinkydots[i].guid == destGUID then tremove(kinkydots, i) return true --]]end end end 

        -- Corruption was refreshed. 
        if param == "SPELL_AURA_REFRESH" then
        -- Drain Soul
		if source == br.guid and spellName == GetSpellInfo(198590) then br.dsTicks = 1 br.maxdsTicks = 5 end
    end

    -- Successfull Spell Casts
	if param == "SPELL_CAST_SUCCESS" then
		if source == br.guid then
			
		end
	end

    -- Periodic Damage Events
    if param == "SPELL_PERIODIC_DAMAGE" then
        if br.dsTicks == nil then br.dsTicks = 0 end
        -- Drain Soul Ticks
        if source == br.guid and spellName == GetSpellInfo(198590) then br.dsTicks = br.dsTicks + 1 br.addonDebug("Drain Soul + 1 tick" .. "Total Ticks: " .. br.dsTicks) end
    end
    -- Corruption was removed.
	if param == "SPELL_AURA_REMOVED" then
        if source == br.guid then
            -- Drain Soul
			if spellName == GetSpellInfo(198590) then br.dsTicks = 1 br.maxdsTicks = 5 br.addonDebug("Drain Soul ticks reset") end
        end
    end

    -- Corruption was applied. 
    if param == "SPELL_AURA_APPLIED" then
        if source == br.guid then
        end
    end
end
    if GetSpecialization() == 2 then
        -- if source == br.guid and param == "SPELL_CAST_SUCCESS" then
        --     -- Hand of Guldan
        --     if  == 105174 then
        --         if not br.lastCast.hog then br.lastCast.hog = {} end
        --         if br.lastCast then
        --             tinsert(br.lastCast.hog, 1, GetTime())
        --             if #br.lastCast.hog == 5 then
        --                 br.lastCast.hog[5] = nil
        --             end
        --         end
        --     end
        --     -- Line CD
        --     if not br.lastCast.line_cd then br.lastCast.line_cd = {} end
        --     br.lastCast.line_cd[] = GetTime()
        -- end
        -- -- Demonology Manager
        -- -- Imps are summoned
        -- if param == "SPELL_SUMMON" and source == br.guid and ( == 104317 or  == 279910) then
        --     print("Imp SUMMON")
        -- end
        -- -- Other Demons are summoned
        -- if param == "SPELL_SUMMON" and source == br.guid and not (spell == 104317 or spell == 279910) then
        --     print("Demon SUMMON")
        -- end
    end
    if GetSpecialization() == 3 then
        -- last Immolate
        if param == "SPELL_CAST_SUCCESS" and spell == 348 then
            lastImmolateTarget = destination
            lastImmolateTime = GetTime()
        end
    end
    ---------------------
    --[[ Pet Manager --]]
    if class == 9 then
        if source == br.guid and param == "SPELL_CAST_SUCCESS" then
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
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    ----------------------------------
    --[[ Bleed Recorder (Warrior) --]]
    if destName == UnitName("player") then
        reflectPlayer = true
    elseif br.timer:useTimer("reflect reset", 0.8) then
        reflectPlayer = false
    end
    if GetSpecialization("player") == 1 then
        -- snapshot on spellcast
        if source == br.guid and param == "SPELL_CAST_SUCCESS" then
            -- but only record the snapshot if it successfully applied
            if spell == 115767 then
                deepWoundsCastAP = UnitAttackPower("player")
            end
        elseif
            source == br.guid and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") and
                deepWoundsCastAP ~= nil
         then
            if spell == 115767 then
                deepWoundsStoredAP = deepWoundsCastAP
            end
        end
    end
end

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
-- macro used to gather caster/spell/buff on our actual target
SLASH_dumpInfo1 = "/dumpinfo"
function SlashCmdList.dumpInfo(msg, editbox)
    -- find unit in our engines
    for i = 1, #enemiesTable do
        if enemiesTable[i].guid == UnitGUID("target") then
            targetInfo = { }
            targetInfo.name = UnitName("target")
            local thisUnit = enemiesTable[i]
            targetInfo.unitID = thisUnit.id
            for j = 1, #spellCastersTable do
                if spellCastersTable[j].unit == thisUnit.unit then
                    if casterName ~= false then
                        local thisCaster = spellCastersTable[j]
                        targetInfo.spellID = thisCaster.cast
                        targetInfo.lenght = thisCaster.castLenght
                        targetInfo.castInteruptible = castNotInteruptible == false
                        targetInfo.castType = castOrChan
                    end
                end
            end            
            local buff1 = UnitBuff("target",1)
            local buff2 = UnitBuff("target",2)
            local deBuff1 = UnitBuff("target",1)
            local deBuff2 = UnitBuff("target",2)
            if buff1 then
                targetInfo.buff1 = buff1
            end
            if buff2 then
                targetInfo.buff2 = buff2
            end
            if deBuff1 then
                targetInfo.deBuff1 = deBuff1
            end
            if deBuff2 then
                targetInfo.deBuff2 = deBuff2
            end
            RunMacroText("/dump targetInfo")
            targetInfo = { }
            break
        end
    end
end

-- in order to better handle the spells we will need to read spells beign casted from reader rather than scanning for it
-- we will need to find a way to match casters with units in the enemeiesTable probably trough GUID 
-- and add the values live via the handler we will already scan our list of interuptCandidates and only add them to the 
-- spellCastersTable once and then profile side we will deploy functions to read the table.

-- burnUnitCandidates = List of UnitID/Names we should have highest prio on.
-- could declare more filters
burnUnitCandidates = {
    { unitID = 71603 }, -- immersus ooze, kill on sight
    -- Shadowmoon Burial Grounds
    { unitID = 75966 }, -- Defiled Spirit, need to be cc and snared and is not allowed to reach boss.
    { unitID = 75899 }, -- Possessed Soul, 
    { unitID = 76518 }, -- Ritual of Bones, marked one... Todo: Can we check if mobs is marked with skull?
    -- Auchindon
    { unitID = 77812 }, -- Sargerei Souldbinder, cast a MC
    -- Grimrail Depot
    { unitID = 80937 }, -- Gromkar Gunner
} 

-- doNotTouchUnitCandidates - List of units that we should not attack for any reason
-- can declare more filters: buff, debuff
doNotTouchUnitCandidates = { 
    -- Iron Docks
    { unitID = 87451,   buff = 164504, spell = 164426 }, --Fleshrender Nok'gar, do not attack during defensive stance buff, Todo: Should stop when he cast 164504
    { unitID = 1,       buff = 163689 }, -- Never attack Sanguine Sphere
}

crowdControlCandidates = {
    -- Shadowmoon Burial Grounds
    { unitID = 75966, spell = 1 }, -- Defiled Spirit, need to be cc and snared and is not allowed to reach boss.
    { unitID = 76446, spell = 1 }, -- Shadowmoon Enslavers
    { unitID = 75899, spell = 1 }, -- Possessed Soul, only for melee i guess
    { unitID = 79510, spell = 1 }, -- Crackling Pyromaniacs
    -- Grimrail Depot
    { unitID = 81236, spell = 163966 }, -- Grimrail Technicians channeling Activating
    { unitID = 80937, spell = 1 }, -- Gromkar Gunner
    -- Proven Ground
    { unitID = 71414, buff = 142639 }, -- Banana Tosser(Large)
    { unitID = 71415, buff = 142639 }, -- Banana Tosser(Small)
}

-- Units with spells that should be interrupted if possible. Good to have units so we can save interrupting spells when targeting them.
interruptCandidates = {
    -- Shadowmoon Burial Grounds
    { unitID = 75652, spell = 152964 }, -- Void Spawn casting Void Pulse, trash mobs 
    { unitID = 76446, spell = 156776 }, -- Shadowmoon Enslavers channeling Rending Voidlash
    { unitID = 76104, spell = 156717 }, -- Monstrous Corpse Spider casting Death Venom
    --Auchindon
    { unitID = 77812, spell = 154527 }, -- Bend Will, MC a friendly.
    { unitID = 77131, spell = 154623 }, -- Void Mending
    { unitID = 76263, spell = 157794 }, -- Arcane Bomb
    { unitID = 86218, spell = 154415 }, -- Mind Spike
    { unitID = 76284, spell = 154218 }, -- Arbiters Hammer
    { unitID = 76296, spell = 154235 }, -- Arcane Bolt
    { unitID = 79510, spell = 154221 }, -- Fel Blast
    { unitID = 78437, spell = 156854 }, -- Drain Life
    { unitID = 86330, spell = 156854 }, -- Drain Life, Terengor
    { unitID = 86330, spell = 156857 }, -- Rain Of Fire
    { unitID = 86330, spell = 164846 }, -- Chaos Bolt
    { unitID = 86330, spell = 156963 }, -- Incenerate
    --Grimral Depot 
    { unitID = 82579, spell = 166335 }, -- Storm Shield
    -- proving ground DPS
    { unitID = 0, spell = 142238 }, -- Illusionary Mystic (Heal) 
    --{ unitID = 0, spell= 142190} -- Amber Sphere
} 

-- List of units that are hitting hard, ie when its good to use defensive CDs
dangerousUnits  = {
    -- Shadowmoon Burial Grounds
    { unitID = 86234, buff = 162696, spell = 162696 }, -- Sadana buffed with deathspikes
    { unitID = 75829, buff = 152792, spell = 152792 }, -- Nhallish casting Void Blast or buffed
    -- Grimrail Depot
    { unitID = 86226, buff = 161092, spell = 1      }, -- Borkas unmanged Agression
    { unitID = 86226, buff = 178412, spell = 178412 }, -- Borkas unmanged Agression
    --{ unitID = 86226, buff = 1,    spell = 161089 }, -- Borkas Mad Dash, small CD Todo: We should add minor major values to this so we can determine if its a big CD or small to be used
 }

dispellOffensiveBuffs = {
    -- Auchindon
    160312, -- Void Shell
}

longTimeCC = {
    339,    -- Druid - Entangling Roots
    102359, -- Druid - Mass Entanglement
    1499,   -- Hunter - Freezing Trap
    19386,  -- Hunter - Wyvern Sting
    118,    -- Mage - Polymorph
    115078, -- Monk - Paralysis
    20066,  -- Paladin - Repentance
    10326,  -- Paladin - Turn Evil
    9484,   -- Priest - Shackle Undead
    605,    -- Priest - Dominate Mind
    6770,   -- Rogue - Sap
    2094,   -- Rogue - Blind
    51514,  -- Shaman - Hex
    710,    -- Warlock - Banish
    5782,   -- Warlock - Fear
    5484,   -- Warlock - Howl of Terror
    115268, -- Warlock - Mesmerize
    6358,   -- Warlock - Seduction
}


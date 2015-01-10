


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
                        targetInfo.castInterruptible = castNotInterruptible == false
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
    -- old content stuff
    [71603] = { coef = 100, name = "Immersus Oozes" }, -- kill on sight
    -- Shadowmoon Burial Grounds
    [75966] = { coef = 100, name = "Defiled Spirit" }, -- need to be cc and snared and is not allowed to reach boss.
    [75899] = { coef = 100, name = "Possessed Soul" },
    [76518] = { coef = 100, unitMarker = 8 }, -- Ritual of Bones, marked one will be priorised
    -- Auchindon
    [77812] = { coef = 150, name = "Sargerei Souldbinder" }, -- casts a Mind Control
    -- Grimrail Depot
    [80937] = { coef = 100 },
    -- UBRS
    [76222] = { coef = 100 },
    [163061] = { coef = 100 }, -- Windfury Totem
    -- Proving Grounds
    [71070] = { coef = 150, name = "Illusion Banshee" }, -- proving ground (will explode if not burned)
    [71075] = { coef = 150, name = "Illusion Banshee" }, -- proving ground (will explode if not burned)
    [71076] = { coef = 25 }, -- Proving ground healer
}

-- shielding and levels, we should add coef as shield %
shieldedUnitCandidates = {
    -- Proving Grounds
    [71072] = { coef = -90, buff = 142427 }, -- Proving ground Sha shielded (will unshield later so better wait)
    [71064] = { coef = -100, buff = 142174, frontal = true }, -- when shielded and we are in front of unit, dont attack
}

--  low prio

-- doNotTouchUnitCandidates - List of units that we should not attack for any reason
-- can declare more filters: buff, debuff
doNotTouchUnitCandidates = {
    -- Iron Docks
    { unitID = 87451, buff = 164504, spell = 164426 }, --Fleshrender Nok'gar, do not attack during defensive stance buff, Todo: Should stop when he cast 164504
    { unitID = 1, buff = 163689 } -- Never attack Sanguine Sphere
}

-- list of units to stun, either always or udner certain condition such as having a buff or wirldwinding etc
crowdControlCandidates = {
    -- Shadowmoon Burial Grounds
    [75966] = { name = "Defiled Spirit" }, -- need to be cc and snared and is not allowed to reach boss.
    [76446] = { name = "Shadowmoon Enslavers" },
    [75899] = { name = "Possessed Soul" }, -- only for melee i guess
    [79510] = { name = "Crackling Pyromaniacs" },
    -- Grimrail Depot
    [81236] = { name = "Grimrail Technicians", spell = 163966 }, -- channeling Activating
    [80937] = { name = "Gromkar Gunner" },
    -- UBRS
    [76157] = { name = "Black Iron Leadbelcher" }, -- Activates canon, should be when/if moving
    [76935] = { name = "Black Iron Drake-Keeper", fleeing = true }, -- Hhould be stunned/cc when running towards whelps
    -- Proven Ground
    [71415] = { name = "Banana Tosser(Small)", buff = 142639 },
    [71414] = { name = "Banana Tosser(Large)", buff = 142639 }

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
    -- UBRS
    { unitID = 76101, spell = 155504 }, -- Debiliting Ray
    { unitID = 76021, spell = 161199 }, -- Debiliting Fixation from Kyrak
    { unitID = 77037, spell = 167259 }, -- Intimidating shout
    { unitID = 77036, spell = 169151 }, -- Summon Black Iron Veteran
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
    -- UBRS
    153909, -- Frenzy
    161203, -- Rejuvenating Serum
    81173,  -- Frenzy
    --61574, -- Banner of the horde (dummy buff just to test)
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
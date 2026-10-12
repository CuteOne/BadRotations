local _, br = ...
if br.lists == nil then br.lists = {} end

-- Spell 99 is Retail's Incapacitating Roar in the shared long-CC list, but here it's
-- Demoralizing Roar (Rank 1). Left in, every mob a bear Roars reads as crowd
-- controlled, and "Don't break CCs" drops it as a target for the rest of the fight.
if br.lists.longCC then br.lists.longCC[99] = nil end

-- The shared long-CC list only carries Rank 1 IDs, so "Don't break CCs" missed every
-- higher rank. Each ID below was checked against Wowhead's TBC database (2026-10-05).
if br.lists.longCC then
    for _, id in ipairs({
        18657, 18658,                   -- Hibernate (Rank 2-3)
        14308, 14309,                   -- Freezing Trap Effect (Rank 2-3)
        24132, 24133, 27068,            -- Wyvern Sting (Rank 2-4)
        19503,                          -- Scatter Shot
        12824, 12825, 12826,            -- Polymorph (Rank 2-4)
        33041, 33042, 33043,            -- Dragon's Breath (Rank 2-4)
        9485, 10955,                    -- Shackle Undead (Rank 2-3)
        1777, 8629, 11285, 11286, 38764, -- Gouge (Rank 2-6)
        2070, 11297, 30980,             -- Sap (Rank 2-4)
        18647,                          -- Banish (Rank 2)
    }) do
        br.lists.longCC[id] = true
    end
end
-- Fears (Psychic Scream Rank 2-4, Fear Rank 1-3, Howl of Terror Rank 2), see System/Lists/LongCC.lua
if br.lists.longCC then
    for _, id in ipairs({ 8124, 10888, 10890, 5782, 6213, 6215, 17928 }) do br.lists.longCC[id] = "fear" end
end
-- Entangling Roots ranks (Rank 2+): a root, see System/Lists/LongCC.lua
if br.lists.longCC then
    for _, id in ipairs({ 1062, 5195, 5196, 9852, 9853, 26989 }) do br.lists.longCC[id] = "root" end
end

-- Several TBC racials are a different spell per class (checked against Wowhead's TBC
-- database, 2026-10-05).
local playerClass = select(2, br._G.UnitClass("player"))
local berserkingID    = ({ WARRIOR = 26296, ROGUE = 26297 })[playerClass] or 20554
local arcaneTorrentID = (playerClass == "ROGUE") and 25046 or 28730
local bloodFuryID     = ({ SHAMAN = 33697, WARLOCK = 33702 })[playerClass] or 20572

-- cast.racial() is the race's damage racial, so a profile can use it SimC-style ("use
-- racial on cooldown for DPS") without checking race. Races with no damage racial are
-- left out: their racial resolves to 0, which BR treats as "nothing to cast". Every
-- racial also has its own key in the abilities table below.
br.lists.racials = {
    Troll    = berserkingID,    -- Berserking
    BloodElf = arcaneTorrentID, -- Arcane Torrent (mana/energy return)
    Orc      = bloodFuryID,     -- Blood Fury
}

br.lists.spells = {}
br.lists.spells.Shared = {
    Shared = {
        abilities        = {
            autoAttack     = 6603,
            autoShot       = 75,
            fumping        = 39238, -- Fumper (item 31810) channel for the quest "Fumping"; act-through (see misc:pause nonBlockingChannels)
            global         = 5176, -- Classic uses class-specific GCD spells, but we use a default here
            racial         = br.functions.spell:getRacial(),
            -- Each racial by name, for profiles that want a specific one. Only the
            -- player's own race will be known.
            arcaneTorrent     = arcaneTorrentID, -- Blood Elf
            berserking        = berserkingID,    -- Troll
            bloodFury         = bloodFuryID,     -- Orc
            cannibalize       = 20577, -- Undead
            escapeArtist      = 20589, -- Gnome
            giftOfTheNaaru    = 28880, -- Draenei
            perception        = 20600, -- Human (Every Man for Himself, 59752, arrived in WotLK)
            shadowmeld        = 20580, -- Night Elf
            stoneform         = 20594, -- Dwarf
            warStomp          = 20549, -- Tauren
            willOfTheForsaken = 7744,  -- Undead
        },
        buffs            = {
            racial                         = br.functions.spell:getRacial(),
        },
        --TODO Add to API
        itemEnchantments = {
        },
        debuffs          = {
        },
        essences         = {
        },
    },
}

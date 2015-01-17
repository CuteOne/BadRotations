novaEngineTables = { }

-- This is for the Dispel Check, all Debuffs we want dispelled go here
-- valid arguments: stacks = num range = num
novaEngineTables.DispelID = {
    { id = 143579, stacks = 3 }, -- Immersius
    { id = 143434, stacks = 3 }, -- Fallen Protectors
    { id = 144514, stacks = 0 }, -- Norushen
    { id = 144351, stacks = 0 }, -- Sha of Pride
    { id = 146902, stacks = 0 }, -- Galakras(Korga Poisons)
    { id = 143432, stacks = 0 }, -- General Nazgrim
    { id = 142913, stacks = 0, range = 10}, -- Malkorok(Displaced Energy)
    { id = 115181, stacks = 0 }, -- Spoils of Pandaria(Breath of Fire)
    { id = 143791, stacks = 0 }, -- Thok(Corrosive Blood)
    { id = 145206, stacks = 0 }, -- Aqua Bomb(Proving Grounds)
    -- Ko'ragh
    { id = 142913, stacks = 0, range = 5}, -- http://www.wowhead.com/spell=162185/expel-magic-fire
}

-- This is where we house the Debuffs that are bad for our users, and should not be healed when they have it
novaEngineTables.BadDebuffList= {
    104451, -- Ice Tomb
    76577,-- Smoke Bomb
    121949, -- Parasistic Growth
    122784, -- Reshape Life
    122370, -- Reshape Life 2
    123184, -- Dissonance Field
    123255, -- Dissonance Field 2
    123596, -- Dissonance Field 3
    128353, -- Dissonance Field 4
    145832, -- Empowered Touch of Y'Shaarj (mind control garrosh)
    145171, -- Empowered Touch of Y'Shaarj (mind control garrosh)
    145065, -- Empowered Touch of Y'Shaarj (mind control garrosh)
    145071, -- Empowered Touch of Y'Shaarj (mind control garrosh)
    --Brackenspore
    159220, -- http://www.wowhead.com/spell=159220  A debuff that removes 99% of healing so no point healing them

}

-- list of special units we want to heal, these npc will go directly into healing engine(Special Heal must be checked)
novaEngineTables.SpecialHealUnitList = {
    [71604] = "Immersus Oozes" ,
    [6459] = "Boss#3 SoO",
    [6460] = "Boss#3 SoO",
    [6464] = "Boss#3 SoO",
};

-- set dot that need to be healed to max(needs to be topped) to very low values so that engine will priorise them
-- the value used here will be substract from current health, we could use negative values to add back health instead
-- these are checked debuff on allies ie nNova[i].unit wear 145263 and its hp is 70, engine will use 50 instead
novaEngineTables.SpecificHPDebuffs = {
    --{ debuff = 123456, value = 20, stacks = 1 }, -- Exemple.
    --{ debuff = 123456, value = -100, stacks = 3 }, -- Exemple
-- Twin Ogrons
    { debuff = 158241 , value = 20 }, -- http://www.wowhead.com/spell=158241/blaze
    { debuff = 155569 , value = 20 }, -- http://www.wowhead.com/spell=155569/injured
    { debuff = 163374 , value = 20 }, -- http://www.wowhead.com/spell=163374/arcane-volatility
-- Imperator
    { debuff = 157763 , value = 20 }, -- http://www.wowhead.com/spell=157763/fixate
    { debuff = 156225 , value = 40 , stacks = 8 }, --http://www.wowhead.com/spell=156225/branded
    { debuff = 156225 , value = 35 , stacks = 7 }, --http://www.wowhead.com/spell=156225/branded
    { debuff = 156225 , value = 30 , stacks = 6 }, --http://www.wowhead.com/spell=156225/branded
    { debuff = 156225 , value = 25 , stacks = 5 }, --http://www.wowhead.com/spell=156225/branded
    { debuff = 156225 , value = 20 , stacks = 4 }, --http://www.wowhead.com/spell=156225/branded
    { debuff = 156225 , value = 15 , stacks = 3 }, --http://www.wowhead.com/spell=156225/branded
    { debuff = 156225 , value = 10 , stacks = 2 }, --http://www.wowhead.com/spell=156225/branded
    { debuff = 156225 , value = 5  , stacks = 1 }, --http://www.wowhead.com/spell=156225/branded  
--Kargath
    { debuff = 159113 , value = 20 }, --http://www.wowhead.com/spell=159113/impale
    { debuff = 159386 , value = 20 }, --http://www.wowhead.com/spell=159386/iron-bomb
    { debuff = 159413 , value = 30 }, --http://www.wowhead.com/spell=159413/mauling-brew
--Brackenspore
    { debuff = 163241 , value = 40 , stacks = 4 }, --http://www.wowhead.com/spell=163241/rot
    { debuff = 163241 , value = 30 , stacks = 3 }, --http://www.wowhead.com/spell=163241/rot
    { debuff = 163241 , value = 20 , stacks = 2 }, --http://www.wowhead.com/spell=163241/rot
    { debuff = 163241 , value = 20 , stacks = 1 }, --http://www.wowhead.com/spell=163241/rot
    { debuff = 145263 , value = 20 }, -- Proving Grounds Healer Debuff.
}

-- this table will assign role to any unit wearing the unit name
novaEngineTables.roleTable = {
    ["Oto the Protector"] = { role = "TANK", class = "Warrior" }, -- proving grounds tank
    ["Sooli the Survivalist"] = { role = "DPS", class = "Hunter" }, -- proving grounds dps
    ["Ki the Assassin"] = { role = "DPS", class = "Rogue" }, -- proving grounds dps
    ["Kavan the Arcanist"] = { role = "DPS", class = "Mage" }, -- proving grounds dps
}

-- special targets to include when we want to heal npcs
novaEngineTables.SavedSpecialTargets = {
    ["target"] = nil,
    ["mouseover"] = nil,
    ["focus"] = nil,
}

-- ToDo: we need a powerful DoT handler to handle stuff such as hand of purity/heal over time

novaEngineTables.BadlyDeBuffed = {
--High Maul
--Kargath
    159386,    --http://www.wowhead.com/spell=159386/iron-bomb
--Twin Ogron
    158241,    --http://www.wowhead.com/spell=158241/blaze
    155569,    --http://www.wowhead.com/spell=155569/injured
    163374,    --http://www.wowhead.com/spell=163374/arcane-volatility
-- Ko'ragh
    161442,     --http://www.wowhead.com/spell=161242/caustic-energy
--Imperator Margok
    157763,    --http://www.wowhead.com/spell=157763/fixate
--    { id = 142913, stacks = 0, range = 0}, -- Placeholder

}
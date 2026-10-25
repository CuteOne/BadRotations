local _, br = ...
if br.lists == nil then br.lists = {} end
-- NPC and spell IDs the enemies engine, unit validation and healing engine treat specially.
br.lists.unitRules = {
    -- NPCs the enemies engine never tracks
    neverTrack = {
        [129359] = "Sawtooth Shark",
        [129448] = "Hammer Shark",
        [144942] = "Spark Bot",
    },
    -- NPCs whose Enhanced Time to Die counts down to this HP % instead of 0
    ttdPercent = {
        [140853] = 10,
        [149684] = 5,
    },
    -- NPCs that are the player's own pet when summoned (listed in br.engines.enemiesEngine.ownPet, never enemies)
    ownPets = {
        [11492] = "Water Elemental",
    },
    -- NPCs only attacked while they have this buff (or are the player's target)
    attackOnlyWithBuff = {
        [131823] = 260805, -- Waycrest Manor sisters: Focusing Iris
        [131824] = 260805,
        [131825] = 260805,
        [135358] = 260805,
        [135359] = 260805,
        [135360] = 260805,
    },
    -- Other players count as enemies while the player has one of these debuffs ...
    attackPlayersWhilePlayerHas = { 320102 },
    -- ... or while they have one of these
    attackPlayersWithDebuff = { 424495 },
    -- While the player has this debuff, other players are never tracked as enemies
    ignorePlayersWhilePlayerHas = 295249,
    -- Bursting (Mythic+ affix): the player's debuff, checked by Safe Damage Check
    bursting = 240443,
    -- Explosive (Mythic+ affix) orbs: unit.isExplosive
    explosive = {
        [120651] = "Explosives",
    },
    -- Proving Grounds NPC party members: they count as players, by role
    provingGrounds = {
        [72218] = "TANK",    -- Oto the Protector
        [72219] = "DAMAGER", -- Ki the Assassin
        [72220] = "DAMAGER", -- Sooli the Survivalist
        [72221] = "DAMAGER", -- Kavan the Arcanist
    },
}

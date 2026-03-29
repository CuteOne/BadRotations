local _, br = ...
if br.lists == nil then br.lists = {} end

br.lists.racials = {
    -- Alliance
    Dwarf    = 20594,  -- Stoneform
    Gnome    = 20589,  -- Escape Artist
    Human    = 59752,  -- Every Man for Himself
    NightElf = 20580,  -- Shadowmeld
    -- Horde
    Tauren   = 20549,  -- War Stomp
    Troll    = 26297,  -- Berserking
    Scourge  = 7744,   -- Will of the Forsaken
    -- Dynamic lookup base IDs
    _bloodElfBase = 69179,
    _draeneiBase  = 28880,
    _orcBase      = 33702,
}

br.lists.spells = {}
br.lists.spells.Shared = {
    Shared = {
        abilities        = {
            autoAttack     = 6603,
            autoShot       = 75,
            giftOfTheNaaru = br.functions.spell:getRacial("Draenei"), --select(7, GetSpellInfo(GetSpellInfo(28880))),
            global         = 5176, -- Classic uses class-specific GCD spells, but we use a default here
            quakingPalm    = br.functions.spell:getRacial("Pandaren"),
            racial         = br.functions.spell:getRacial(),
            shadowmeld     = br.functions.spell:getRacial("NightElf"),
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

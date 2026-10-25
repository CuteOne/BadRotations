-- WoW client detection and game rules
-- Which client BR runs on (br.api.expansion) and the rules of its game version (br.api.<rule>, one
-- table below). Layers.lua (before this) builds br._G; shared.lua adds the polyfills;
-- Expansions/<name>/Functions.lua holds code only a client needs.
local _, br = ...

br.api = br.api or {}

-- Client flavours by project ID. A flavour without supported = true is recognised by name (Session.log)
-- but runs as "Unknown": BR has no spell lists or rules for it.
local FLAVOURS = {
    [WOW_PROJECT_MAINLINE or -1]                     = { key = "Retail",  supported = true },
    [WOW_PROJECT_MISTS_CLASSIC or -2]                = { key = "MOP",     supported = true },
    [WOW_PROJECT_CATACLYSM_CLASSIC or -3]            = { key = "Cata" },
    [WOW_PROJECT_WRATH_CLASSIC or -4]                = { key = "Wrath" },
    [WOW_PROJECT_BURNING_CRUSADE_CLASSIC or -5]      = { key = "TBC",     supported = true },
    [WOW_PROJECT_CLASSIC or -6]                      = { key = "Classic", supported = true },
    [WOW_PROJECT_CAMELOT or -7]                      = { key = "Forever", supported = true },
}
local flavour = FLAVOURS[WOW_PROJECT_ID]
-- Short key of a supported client ("Retail", "MOP", "TBC", "Classic", "Forever"), else "Unknown"
br.api.expansion = flavour and flavour.supported and flavour.key or "Unknown"
-- The client's name for logs, also for an unsupported one
br.api.flavourName = flavour and flavour.key or ("unknown (project " .. tostring(WOW_PROJECT_ID) .. ")")

br.isForever = br.api.expansion == "Forever"
br.isRetail  = br.api.expansion == "Retail"
br.isMOP     = br.api.expansion == "MOP"

-- Game rules: one row per rule, its default first, then the flavours where it differs.
local RULES = {
    -- spells have rank-specific IDs
    hasSpellRanks         = { false, Classic = true, TBC = true, Forever = true },
    -- talent specialization subfolders (one class-level spec without them)
    hasSubSpecs           = { true, Classic = false, TBC = false, Forever = false },
    -- hero talent trees
    hasHeroTalentTrees    = { false, Retail = true },
    -- C_LossOfControl lets charm-break spells fire while charmed. Forever has C_LossOfControl (API
    -- reference, build 70338), but whether charm-break spells fire while charmed is unverified.
    hasCharmBreakTracking = { false, Retail = true },
    -- BFA trinket/essence channels (Focused Azerite Beam, Cyclotronic Blast, Azshara's Font of Power)
    -- need a follow-up channel lock
    hasBFAItemChannels    = { false, Retail = true },
    -- combo points are kept on the target and lost on a switch (before 6.0.2). Forever: unverified,
    -- the safe choice; its tooltips list combo points as a cost like Retail's (player-held), and the
    -- combo point probe in System/Debugging.lua records a switch to settle it.
    comboPointsOnTarget   = { false, Classic = true, TBC = true, MOP = true, Forever = true },
    -- C_Spell.GetSpellInfo gives minRange and maxRange the other way round. Forever gives them in the
    -- right order (verified in game: Wrath 5176 -> minRange=0, maxRange=30).
    spellRangeSwapped     = { false, Classic = true, TBC = true },
    -- game object dynamic flag the server sets for an active quest ("sparkle"; 0x04 is "activate"),
    -- where known. Forever: verified with /qprobe on 2026-10-11 (the Trial of the Lake Bauble
    -- Container reads 0xC024, a plain object nearby 0x8000); game object names come back empty there.
    questObjectFlag       = { nil, Forever = 0x20 },
}
for name, rule in pairs(RULES) do
    local value = rule[br.api.expansion]
    if value == nil then value = rule[1] end
    br.api[name] = value
end

-- The server's fleeing unit flag (UNIT_FLAG_FLEEING, the same bit in every version). unit:isFleeing reads
-- it where the unlocker provides UnitFlags; without it the flee emote is used. Confirmed in play on
-- Forever 2026-10-12: fleeing mobs read 0x00880800 against 0x00080800.
br.api.fleeingUnitFlag = 0x00800000

-- Whether this client hands out secret values (Retail since Midnight, Forever). Other clients
-- built on the same engine (Anniversary build 70006) carry issecretvalue/canaccessvalue too but
-- never produce a secret, so the functions existing doesn't mean the client uses them.
br.hasSecretValues = (issecretvalue ~= nil or canaccessvalue ~= nil) and (br.isRetail or br.isForever)

-- The talents BR reads, { [talentSpellID] = { active = bool, rank = n } }. By default none:
-- rotations gate talents through cast.able.* and known spells. Retail (C_Traits) and MOP (tiers)
-- read theirs in their own Functions.lua.
br.api.getTalentInfo = function(spec, spellTalents)
    return {}
end

-- The compatibility-layer banner. BR's chat (System/Logging.lua) loads later in the TOC, so the line
-- waits in br.earlyMessages and Logging.lua prints it.
br.earlyMessages = br.earlyMessages or {}
br.earlyMessages[#br.earlyMessages + 1] = "API: " .. br.api.expansion .. " compatibility layer loaded (Build: "
    .. (select(2, GetBuildInfo()) or "?") .. ")"

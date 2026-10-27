-- WoW client detection and game rules
-- Which client BR runs on (br.client.flavour) and the rules of its game version (br.client.rules.<rule>, one
-- table below). Layers.lua (before this) builds br.game; Polyfills.lua adds the polyfills;
-- Expansions/<name>/Functions.lua holds code only a client needs.
local _, br = ...

br.client = br.client or {}

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
br.client.flavour = flavour and flavour.supported and flavour.key or "Unknown"
-- The client's name for logs, also for an unsupported one
br.client.flavourName = flavour and flavour.key or ("unknown (project " .. tostring(WOW_PROJECT_ID) .. ")")

br.client.isForever = br.client.flavour == "Forever"
br.client.isRetail  = br.client.flavour == "Retail"
br.client.isMOP     = br.client.flavour == "MOP"

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
    -- TBC Anniversary: /qprobe 2026-10-26, Azure Snapdragon (181644, quest 9473) reads 0xC024 too, and
    -- game object names come back empty, so without the flag no object matched; a plain object's
    -- flags not yet read there.
    questObjectFlag       = { nil, TBC = 0x20, Forever = 0x20 },
    -- the player can destroy a totem themselves (right-clicking its icon; Wrath on). Not before: TBC
    -- Anniversary's UI does nothing on a right-click (2026-10-26), so BR doesn't either (totem.destroy).
    -- Forever: unverified, the safe choice.
    canDestroyTotems      = { true, Classic = false, TBC = false, Forever = false },
}
br.client.rules = {}
for name, rule in pairs(RULES) do
    local value = rule[br.client.flavour]
    if value == nil then value = rule[1] end
    br.client.rules[name] = value
end

-- The server's fleeing unit flag (UNIT_FLAG_FLEEING, the same bit in every version). unit:isFleeing reads
-- it where the unlocker provides UnitFlags; without it the flee emote is used. Confirmed in play on
-- Forever 2026-10-12: fleeing mobs read 0x00880800 against 0x00080800.
br.client.fleeingUnitFlag = 0x00800000

-- Whether this client hands out secret values (Retail since Midnight, Forever). Other clients
-- built on the same engine (Anniversary build 70006) carry issecretvalue/canaccessvalue too but
-- never produce a secret, so the functions existing doesn't mean the client uses them.
br.client.hasSecretValues = (issecretvalue ~= nil or canaccessvalue ~= nil) and (br.client.isRetail or br.client.isForever)

-- The talents BR reads, { [talentSpellID] = { active = bool, rank = n } }. By default none:
-- rotations gate talents through cast.able.* and known spells. Retail (C_Traits) and MOP (tiers)
-- read theirs in their own Functions.lua.
br.client.getTalentInfo = function(spec, spellTalents)
    return {}
end

-- The compatibility-layer banner. BR's chat (System/Logging.lua) loads later in the TOC, so the line
-- waits in br.earlyMessages and Logging.lua prints it.
br.earlyMessages = br.earlyMessages or {}
br.earlyMessages[#br.earlyMessages + 1] = "API: " .. br.client.flavour .. " compatibility layer loaded (Build: "
    .. (select(2, GetBuildInfo()) or "?") .. ")"

local _, br = ...
--- Player API Builder
-- Builds the profile-facing API on br.player (buff, debuff, cast, cd, unit, ui, module, ...)
-- from the spell lists compiled by br.loader.spellCompiler. Used by builder:new().
br.loader.playerAPI = br.loader.playerAPI or {}
local playerAPI = br.loader.playerAPI
local spellCompiler = br.loader.spellCompiler

-- Builds talent.X (including hero talents) and heroTree.
local function buildTalents(player, spec)
    -- Build Talent Info
    local allTalents = spellCompiler:compileTalents(player, spec)
    -- br.allTalents = allTalents
    if player.talent == nil then player.talent = {} end
    -- Heroic Talent Patching
    local spellListTalents = {} -- Holding table, so the hero talents aren't added to spells.talents
    for k, v in pairs(player.spells.talents) do spellListTalents[k] = v end
    if player.spells.talentsHeroic ~= nil then
        -- Add heroic talents to holding table
        for k, v in pairs(player.spells.talentsHeroic) do spellListTalents[k] = v end
        -- Add in missing heroic talents to allTalents (allTalents only get talents available to spec, not all heroic talents are available)
        if allTalents ~= nil then
            for _, v in pairs(player.spells.talentsHeroic) do
                if allTalents[v] == nil then
                    allTalents[v] = { rank = 0, active = false }
                end
            end
        end
    end

    -- Build Hero Tree Info
    spellCompiler:compileHeroTree(player)

    -- The compiled talent state, for the layers below the profile API (spell:hasTalent / getTalentRank)
    player.talentInfo = allTalents or {}
    player.talentIDs = spellListTalents

    -- Parse Holding Table
    for k, v in pairs(spellListTalents) do
        br.api.talent(player.talent, k, v, allTalents, player.spells)
    end
end

-- Empty Shadowlands tables kept so older profiles indexing them do not error.
local function buildLegacyTables(player)
    -- Conduits (Shadowlands legacy — API calls removed; table preserved for profile compatibility)
    if player.conduit == nil then player.conduit = {} end

    -- Animas (Shadowlands legacy — API calls removed; table preserved for profile compatibility)
    if player.anima == nil then player.anima = {} end

    -- Covenant (Shadowlands legacy — API calls removed; sub-tables preserved for profile compatibility)
    if player.covenant == nil then player.covenant = {} end
    if player.covenant.kyrian == nil then player.covenant.kyrian = {} end
    if player.covenant.venthyr == nil then player.covenant.venthyr = {} end
    if player.covenant.nightFae == nil then player.covenant.nightFae = {} end
    if player.covenant.necrolord == nil then player.covenant.necrolord = {} end
    if player.covenant.none == nil then player.covenant.none = {} end

    -- Runeforge (Shadowlands legacy — API calls removed; table preserved for profile compatibility)
    if player.runeforge == nil then player.runeforge = {} end
end

-- Builds power.<type> functions for every power type.
local function buildPower(player)
    -- Update Power
    if not player.power then player.power = {} end
    player.power.list = {
        mana          = 0,  --SPELL_POWER_MANA, --0,
        rage          = 1,  --SPELL_POWER_RAGE, --1,
        focus         = 2,  --SPELL_POWER_FOCUS, --2,
        energy        = 3,  --SPELL_POWER_ENERGY, --3,
        comboPoints   = 4,  --SPELL_POWER_COMBO_POINTS, --4,
        runes         = 5,  --SPELL_POWER_RUNES, --5,
        runicPower    = 6,  --SPELL_POWER_RUNIC_POWER, --6,
        soulShards    = 7,  --SPELL_POWER_SOUL_SHARDS, --7,
        astralPower   = 8,  --SPELL_POWER_LUNAR_POWER, --8,
        holyPower     = 9,  --SPELL_POWER_HOLY_POWER, --9,
        altPower      = 10, --SPELL_POWER_ALTERNATE_POWER, --10,
        maelstrom     = 11, --SPELL_POWER_MAELSTROM, --11,
        chi           = 12, --SPELL_POWER_CHI, --12,
        insanity      = 13, --SPELL_POWER_INSANITY, --13,
        -- obsolete        = 14,
        -- obsolete2       = 15,
        arcaneCharges = 16, --SPELL_POWER_ARCANE_CHARGES, --16,
        fury          = 17, --SPELL_POWER_FURY, --17,
        pain          = 18, --SPELL_POWER_PAIN, --18,
        essence       = 19, --SPELL_POWER_ESSENCE, -- 19,
    }
    for k, v in pairs(player.power.list) do
        if not player.power[k] then player.power[k] = {} end
        br.api.power(player.power, k, v)
    end
end

-- Builds buff.X and debuff.X functions (ranked auras resolve to the highest known rank).
local function buildAuras(player)
    -- Make Buff Functions from br.api.buffs
    for k, v in pairs(player.spells.buffs) do
        if k ~= "rollTheBones" then
            if player.buff == nil then player.buff = {} end
            if player.buff[k] == nil then player.buff[k] = {} end
            -- if k == "bloodLust" then v = br.functions.aura:getLustID() end
            local resolvedID = spellCompiler:resolve(v)
            if resolvedID ~= v then
                -- Update the spell list to use resolved ID for icon references
                player.spells.buffs[k] = resolvedID
                player.spells[k] = resolvedID
            end
            br.api.buffs(player.buff, k, v) -- the rank list: buff.X picks the current rank itself
        end
    end
    -- Make Debuff Functions from br.api.debuffs
    for k, v in pairs(player.spells.debuffs) do
        if player.debuff == nil then player.debuff = {} end
        if player.debuff[k] == nil then player.debuff[k] = {} end
        local resolvedID = spellCompiler:resolve(v)
        if resolvedID ~= v then
            -- Update the spell list to use resolved ID for icon references
            player.spells.debuffs[k] = resolvedID
            player.spells[k] = resolvedID
        end
        br.api.debuffs(player.debuff[k], k, v) -- the rank list: debuff.X picks the current rank itself
    end
end

-- Builds the units, enemies, unit and totem APIs (once per player object).
local function buildUnitAPIs(player)
    -- Make Units Functions from br.api.units
    if player.units == nil then
        player.units = {}
        br.api.units(player)
    end

    -- Make Enemies Functions from br.api.enemies
    if player.enemies == nil then
        player.enemies = {}
        br.api.enemies(player)
    end

    -- Make Unit Functions from br.api.unit
    if player.unit == nil then
        player.unit = {}
        br.api.unit(player)
    end

    -- Make Totem Functions from br.api.totem
    if player.totem == nil then
        player.totem = {}
        if br.api.totem then
            br.api.totem(player)
        end
    end
end

-- Builds pet.X functions from the pet list.
local function buildPets(player)
    -- Make Pet Functions from br.api.pets
    if player.pets ~= nil then
        for k, v in pairs(player.pets) do
            if player.pet[k] == nil then player.pet[k] = {} end
            local pet = player.pet[k]
            br.api.pets(pet, k, v, player)
        end
    end
end

-- Builds glyph functions, plus glyphOfX -> x convenience aliases.
local function buildGlyphs(player)
    -- Make Glyph Functions from br.api.glyph / br.api.glyphs
    if player.glyph == nil then player.glyph = {} end
    if br.api.glyph then
        br.api.glyph(player)
    end
    if player.spells and player.spells.glyphs then
        for k, v in pairs(player.spells.glyphs) do
            player.glyph[k] = player.glyph[k] or {}
            if br.api.glyphs then
                br.api.glyphs(player.glyph, k, v)
            end
            -- Convenience alias: glyphOfFrostShock -> frostShock
            if type(k) == "string" and k:sub(1, 7) == "glyphOf" then
                local suffix = k:sub(8)
                if suffix and suffix ~= "" then
                    local alias = suffix:sub(1, 1):lower() .. suffix:sub(2)
                    if player.glyph[alias] == nil then
                        player.glyph[alias] = player.glyph[k]
                    end
                end
            end
        end
    end
end

-- Builds cd, charges, equiped, has and use functions for every item.
local function buildItems(player)
    -- The equipped heirloom neck (0 when none) changes with gear, and builds run again on gear changes
    player.items.heirloomNeck = br.functions.item:getHeirloomNeck()
    -- Cycle through Items List
    for item, id in pairs(player.items) do                                --player.spells.items) do
        if player.charges == nil then player.charges = {} end               -- Item Charge Functions
        if player.charges[item] == nil then player.charges[item] = {} end   -- Item Charge Subtables
        if player.cd == nil then player.cd = {} end                         -- Item Cooldown Functions
        if player.equiped == nil then player.equiped = {} end               -- Use Item Debugging
        if player.equiped.socket == nil then player.equiped.socket = {} end -- Item Socket Info
        if player.has == nil then player.has = {} end                       -- Item In Bags
        if player.use == nil then player.use = {} end                       -- Use Item Functions
        if player.use.able == nil then player.use.able = {} end             -- Useable Item Check Functions

        br.api.itemCD(player.cd, item, id)

        br.api.itemCharges(player.charges, item, id)

        br.api.equiped(player.equiped, item, id)

        br.api.has(player.has, item, id)

        br.api.use(player.use, item, id)
    end
end

-- Builds cast, charges, cd and spell functions for every ability.
local function buildAbilities(player)
    -- Cycle through Abilities List
    for spell, id in pairs(player.spells.abilities) do
        if player.charges == nil then player.charges = {} end -- Spell Charge Functions
        if player.cd == nil then player.cd = {} end           -- Spell Cooldown Functions
        if player.spell == nil then player.spell = {} end     -- Spell Functions

        -- Rank tables (Classic-era) resolve to the highest known rank
        local resolvedID = spellCompiler:resolve(id)
        if resolvedID ~= id then
            -- Update the spell list to use resolved ID for icon references
            player.spells.abilities[spell] = resolvedID
            player.spells[spell] = resolvedID
        end

        -- Build Cast Funcitons
        br.api.cast(player, spell, resolvedID)
        -- Build Spell Charges
        br.api.charges(player.charges, spell, resolvedID)
        -- Build Spell Cooldown
        br.api.cd(player, spell, resolvedID)
        -- Build Spell
        br.api.spell(player, spell, resolvedID)
    end
end

-- Ensures cast.racial / cast.able.racial exist even when the race has no racial.
local function buildRacialFallback(player)
    -- Ensure racial cast helpers always exist, even when no racial spell is available.
    if player.cast == nil then player.cast = {} end
    if player.cast.able == nil then player.cast.able = {} end
    if player.cast.racial == nil then
        player.cast.racial = function()
            return false
        end
    end
    if player.cast.able.racial == nil then
        player.cast.able.racial = function()
            return false
        end
    end
end

-- Builds the ui and module APIs (module captures ui, so ui comes first).
local function buildUIAndModules(player)
    -- Make UI Functions from br.api.ui
    if player.ui == nil then
        player.ui = {}
        br.api.ui(player)
    end

    -- Make Action List Functions from br.api.module
    if player.module == nil then
        player.module = {}
        br.api.module(player)
    end
end

--- Builds the profile API on player for the given spec.
-- @param player The br.player object being built (spells already compiled)
-- @param spec Spec ID
function playerAPI:build(player, spec)
    buildTalents(player, spec)
    buildLegacyTables(player)
    buildPower(player)
    buildAuras(player)
    buildUnitAPIs(player)
    buildPets(player)
    buildGlyphs(player)
    buildItems(player)
    buildAbilities(player)
    buildRacialFallback(player)
    buildUIAndModules(player)
end

local _, br = ...

-- Spell List Loader
-- Loads expansion-specific spell lists lazily:
--   Global.lua          (always, once)
--   CLASS/Class.lua     (once per login; class never changes mid-session)
--   CLASS/SpecName.lua  (once per spec; cached so spec re-visits skip the disk read)
--
-- Classic/TBC have no spec system (br.api.hasSubSpecs == false):
--   only Global.lua + CLASS/Class.lua are loaded.
-- MOP/Retail (br.api.hasSubSpecs == true):
--   Global.lua + CLASS/Class.lua + CLASS/<SpecName>.lua are loaded.

if br.lists == nil then br.lists = {} end

-- Set of spec names already loaded this session, e.g. { Balance=true, Feral=true }
br.lists._loadedSpecs = br.lists._loadedSpecs or {}

-- ---------------------------------------------------------------------------
-- Internal helpers
-- ---------------------------------------------------------------------------

local function getFilesLocation()
    local sep = br._G.IsMacClient() and "/" or "\\"
    local wowDir = br._G.GetWoWDirectory() or ""
    if wowDir:match('_retail_') then
        return wowDir .. sep .. 'Interface' .. sep .. 'AddOns' .. sep .. br.loader.addonName, sep
    end
    return wowDir .. sep .. br.loader.addonName, sep
end

local function loadFile(path, label)
    local data = br._G.ReadFile(path)
    if data then
        local func = assert(loadstring(data, label))
        setfenv(func, setmetatable({}, {__index = _G}))
        func(nil, br)
        return true
    end
    return false
end

-- Strips spaces so "Beast Mastery" → "BeastMastery" for file lookup
local function sanitizeSpecName(name)
    return (name:gsub("%s+", ""))
end

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

-- Called once after the unlocker is ready. Loads Global.lua + the player's
-- current class (and spec, on MOP/Retail).
function br.lists:loadExpansionSpells()
    local expansion = br.api.expansion
    if not expansion or expansion == "Unknown" then
        local label = expansion or "Unknown"
        br._G.print("|cffFFFF00Warning:|r " .. label .. " spell lists not yet implemented!")
        return
    end

    local base, sep = getFilesLocation()
    local expBase = base .. sep .. "Expansions" .. sep .. expansion

    -- 1. Global.lua — always loaded first; initialises br.lists.spells
    local globalPath = expBase .. sep .. "Global.lua"
    if not loadFile(globalPath, expansion .. " Global") then
        -- Fallback to legacy monolithic Spells.lua
        br._G.print("|cffFFFF00Warning:|r " .. expansion .. " Global.lua not found; falling back to Spells.lua")
        local legacy = br._G.ReadFile(expBase .. sep .. "Spells.lua")
        if legacy then
            local func = assert(loadstring(legacy, expansion .. " Spells"))
            setfenv(func, setmetatable({}, {__index = _G}))
            func(nil, br)
        else
            br._G.print("|cffFF0000Error:|r " .. expansion .. " spell lists not found!")
        end
        return
    end

    br._G.print("Loading " .. expansion .. " spell lists...")

    -- 2. CLASS/Class.lua
    local class = br._G.select(2, br._G.UnitClass("player"))
    if class then
        local classPath = expBase .. sep .. class .. sep .. "Class.lua"
        if not loadFile(classPath, expansion .. " " .. class .. " Class") then
            br._G.print("|cffFFFF00Warning:|r " .. class .. " Class.lua not found for " .. expansion)
        end
    end

    -- 3. CLASS/SpecName.lua — only on expansions with a spec system
    if br.api.hasSubSpecs then
        local specName = sanitizeSpecName(br.loader.selectedSpec or "")
        if specName ~= "" then
            br.lists:loadSpecSpells(specName)
        end
    end
end

-- Lazy-loads a single spec file. Safe to call multiple times; skips if already
-- loaded this session. Only meaningful when br.api.hasSubSpecs == true.
function br.lists:loadSpecSpells(specName)
    if not br.api.hasSubSpecs then return end

    specName = sanitizeSpecName(specName)
    if specName == "" or br.lists._loadedSpecs[specName] then return end

    local base, sep = getFilesLocation()
    local expBase = base .. sep .. "Expansions" .. sep .. br.api.expansion
    local class   = br._G.select(2, br._G.UnitClass("player"))
    if not class then return end

    local specPath = expBase .. sep .. class .. sep .. specName .. ".lua"
    if loadFile(specPath, br.api.expansion .. " " .. class .. " " .. specName) then
        br.lists._loadedSpecs[specName] = true
    else
        br._G.print("|cffFFFF00Warning:|r " .. specName .. ".lua not found for " .. class .. " in " .. br.api.expansion)
    end
end

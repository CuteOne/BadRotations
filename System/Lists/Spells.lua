local _, br = ...

-- Spell List Loader - loads expansion-specific spell lists
-- This file determines which spell list to load based on the current WoW expansion

if br.lists == nil then br.lists = {} end

-- Defer spell list loading until after unlockers are ready
function br.lists:loadExpansionSpells()
    -- br._G.print("|cff00FFFFBadRotations:|r loadExpansionSpells() called")

    -- Get addon directory path
    local sep = IsMacClient() and "/" or "\\"
    local function getFilesLocation()
        local wowDir = br._G.GetWoWDirectory() or ""
        if wowDir:match('_retail_') then
            return wowDir .. sep .. 'Interface' .. sep .. 'AddOns' .. sep .. br.loader.addonName
        end
        return wowDir .. sep .. br.loader.addonName
    end

    local loadSpellList = function(label)
        local spellData = br._G.ReadFile(getFilesLocation() .. sep .. "System" .. sep .. "Lists" .. sep .. "Expansions" .. sep .. label .. sep .. "Spells.lua")
        if spellData then
            local func = assert(loadstring(spellData, label .. " Spells"))
            setfenv(func, setmetatable({}, {__index = _G}))
            func(nil, br)  -- Pass br as second argument to match "local _, br = ..."
        else
            br._G.print("|cffFF0000Error:|r " .. label .. " spell list not found!")
        end
    end

    -- Load the appropriate spell list based on expansion
    if br.isRetail then
        -- Load Retail spell lists when created
        br._G.print("Loading Retail spell lists...")
        loadSpellList("Retail")
    elseif br.isMOP then
        -- Load MoP Classic spell lists
        br._G.print("Loading MoP spell lists...")
        loadSpellList("MOP")
    elseif br.isCata then
        br._G.print("Loading Cataclysm spell lists...")
        -- Future: Load Cata spell lists
        br._G.print("|cffFFFF00Warning:|r Cataclysm spell lists not yet implemented!")
    elseif br.isWrath then
        br._G.print("Loading Wrath spell lists...")
        -- Future: Load Wrath spell lists
        br._G.print("|cffFFFF00Warning:|r Wrath spell lists not yet implemented!")
    elseif br.isBC then
        br._G.print("Loading Burning Crusade spell lists...")
        -- Future: Load Burning Crusade spell lists
        br._G.print("|cffFFFF00Warning:|r Burning Crusade spell lists not yet implemented!")
    elseif br.isClassic then
        -- Load Classic spell lists
        br._G.print("Loading Classic spell lists...")
        loadSpellList("Classic")
    else
        -- Default to MoP for backward compatibility
        br._G.print("Unknown expansion, no spell lists loaded!")
        -- local mopSpells = br._G.ReadFile(getFilesLocation() .. sep .. "System" .. sep .. "Lists" .. sep .. "Expansions" .. sep .. "MOP" .. sep .. "Spells.lua")
        -- if mopSpells then
        --     local func = assert(loadstring(mopSpells, "MoP Spells (default)"))
        --     setfenv(func, setmetatable({}, {__index = _G}))
        --     func(nil, br)  -- Pass br as second argument to match "local _, br = ..."
        -- end
    end
end

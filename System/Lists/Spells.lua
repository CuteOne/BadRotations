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
        local spellData = br._G.ReadFile(getFilesLocation() .. sep .. "Expansions" .. sep .. label .. sep .. "Spells.lua")
        if spellData then
            local func = assert(loadstring(spellData, label .. " Spells"))
            setfenv(func, setmetatable({}, {__index = _G}))
            func(nil, br)  -- Pass br as second argument to match "local _, br = ..."
        else
            br._G.print("|cffFF0000Error:|r " .. label .. " spell list not found!")
        end
    end

    -- Load the appropriate spell list based on expansion.
    -- br.api.expansion is set by Expansions/<name>/Functions.lua; "Unknown" = unsupported client.
    if br.api.expansion and br.api.expansion ~= "Unknown" then
        br._G.print("Loading " .. br.api.expansion .. " spell lists...")
        loadSpellList(br.api.expansion)
    else
        local label = br.api.expansion or "Unknown"
        br._G.print("|cffFFFF00Warning:|r " .. label .. " spell lists not yet implemented!")
    end
end

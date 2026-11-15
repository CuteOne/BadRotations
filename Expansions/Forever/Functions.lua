-- WoW Forever API Compatibility Layer
-- Handles API differences in Forever (1.60)
local _, br = ...

if not br.client.isForever then return end

-- The unlocker's version of a game name, else the client's (Expansions/Layers.lua)
local base = br.client.base

-- A game value as a plain one, or nil when BR may not use it (a secret value)
local function plain(value)
    if value == nil then return nil end
    local misc = br.functions.misc
    local ok, result = pcall(function()
        if not misc:canUseValue(value) then return nil end
        if type(value) == "number" then return misc:plainNumber(value) end
        return value
    end)
    if not ok then return nil end
    return result
end

-- Talent System - Forever keeps its talent tree in C_Traits like Retail, but one node is one talent of several
-- ranks (Shredding Attacks 0/3) and its taken ranks are node.ranksPurchased: the read Spells.log makes on the live
-- build (System/SpellsLog.lua, 2026-11-14: Shredding Attacks 16966 0/3, Blood Frenzy 16958 2/2). The default
-- reader (Expansions/Flavours.lua) knows no talents, so talent.rank.<key> was always 0 on Forever.
br.client.getTalentInfo = function(spec, spellTalents) -- luacheck: ignore 212
    local talents = {}
    local classTalents, traits = base.C_ClassTalents, base.C_Traits
    if not (classTalents and classTalents.GetActiveConfigID and traits and traits.GetConfigInfo) then return talents end
    local configID = plain(classTalents.GetActiveConfigID())
    if configID == nil then return talents end
    local config = traits.GetConfigInfo(configID)
    for _, treeID in pairs(config and config.treeIDs or {}) do
        for _, nodeID in pairs(traits.GetTreeNodes(treeID) or {}) do
            local node = traits.GetNodeInfo(configID, nodeID)
            if node and plain(node.isVisible) ~= false then
                local taken = plain(node.ranksPurchased) or 0
                local chosen = node.activeEntry and plain(node.activeEntry.entryID)
                for _, entryID in pairs(node.entryIDs or {}) do
                    local entry = traits.GetEntryInfo(configID, entryID)
                    local definition = entry and plain(entry.definitionID) and traits.GetDefinitionInfo(entry.definitionID)
                    local id = definition and plain(definition.spellID)
                    if id then
                        -- a choice node: only the chosen entry has the node's ranks
                        local rank = (#node.entryIDs == 1 or plain(entryID) == chosen) and taken or 0
                        talents[id] = { active = rank > 0, rank = rank }
                    end
                end
            end
        end
    end
    return talents
end

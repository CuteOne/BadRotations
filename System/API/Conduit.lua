---
-- These functions help in retrieving information about conduit powers *Shadowlands*.
-- Conduit functions are stored in br.player.conduit and can be utilized by `local conduit = br.player.conduit` in your profile.
-- `spell` in the table represent the name in the conduit list (Spec, Shared Class, Shared Global Lists) defined in System/List/Spells.lua
-- @module br.player.conduit
local _, br = ...
if br.api == nil then br.api = {} end

br.api.conduit = function(conduit,spell,id)
    local soulbindID = br._G.C_Soulbinds.GetActiveSoulbindID()
    local soulbindData = br._G.C_Soulbinds.GetSoulbindData(soulbindID)
    for _, node in pairs(soulbindData.tree.nodes) do
        local conduitID = br._G.C_Soulbinds.GetInstalledConduitID(node.ID)
        if conduitID > 0 then
            local collectionData = br._G.C_Soulbinds.GetConduitCollectionData(conduitID)
            if collectionData.conduitID > 0 then
                local spellID = br._G.C_Soulbinds.GetConduitSpellID(collectionData.conduitID, collectionData.conduitRank)
                if spellID == id then
                    local spellName, _, spellIcon = br._G.GetSpellInfo(spellID)
                    conduit[spell] = {
                        state = node.state,
                        icon = spellIcon,
                        row = node.row,
                        conduitID = collectionData.conduitID,
                        name = spellName,
                        rank = collectionData.conduitRank,--spellRank,
                        id = spellID,
                        enabled = true;
                    }
                end
            end
        end
    end
    if conduit[spell].name == nil then
        local spellName, _, spellIcon, _, _, _, spellID = br._G.GetSpellInfo(id)

        --- Gets information about a specific conduit.
        -- @field state The current state of the conduit. Default is `0`.
        -- @field icon The icon associated with the conduit, represented by the spell icon.
        -- @field row The row in which the conduit is located. Default is `0`.
        -- @field conduitID The unique identifier for the conduit. Default is `0`.
        -- @field name The name of the conduit, represented by the spell name.
        -- @field rank The rank of the conduit. Currently set to default `0`.
        -- @field id The unique identifier for the spell associated with the conduit.
        -- @field enabled A boolean indicating whether the conduit is enabled. Default is `false`.
        -- @table conduit.spell
        conduit[spell] = {
            state = 0,
            icon = spellIcon,
            row = 0,
            conduitID = 0,
            name = spellName,
            rank = 0,--spellRank,
            id = spellID,
            enabled = false
        }
    end
end
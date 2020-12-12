local br = _G["br"]
if br.api == nil then br.api = {} end
br.api.conduit = function(conduit,k,v)
    local soulbindID = C_Soulbinds.GetActiveSoulbindID()
    local soulbindData = C_Soulbinds.GetSoulbindData(soulbindID)
    for _, node in pairs(soulbindData.tree.nodes) do
        local conduitID = C_Soulbinds.GetInstalledConduitID(node.ID)
        if conduitID > 0 then
            local collectionData = C_Soulbinds.GetConduitCollectionData(conduitID)
            if collectionData.conduitID > 0 then
                local spellID = C_Soulbinds.GetConduitSpellID(collectionData.conduitID, collectionData.conduitRank)
                if spellID == v then
                    local spellName, spellRank, spellIcon = GetSpellInfo(spellID)
                    conduit[k] = {
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

        if conduit[k].name == nil then
            local spellName, spellRank, spellIcon = GetSpellInfo(v)
            conduit[k] = {
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
end
-- Some code which will be needed for legion


--- Getting artifact spellIDs and perks
--  Function:
--  You check the perks after login, spec change or artifact change
--  the powers are stored into the global, as you can only check them with opened artifact window
--  function will open, update the global variable, close the ui so user will not see it
--  isKnown will then also check against the global if the spellID is present
--  IF needed an extra function to check for ranks can be implemented

-- global
bb.artifact = {}
bb.artifact.perks = {}

-- gather the artifact perks
function bb.artifact:collectPerkInfo()
    if HasArtifactEquipped() then
        local forceHide;
        bb.artifact.perks = {}

        -- opens (equipped) arfifact layout
        if not ArtifactFrame:IsShown() then
            forceHide = true
            SocketInventoryItem(16)
        end

        for i, powerID in ipairs(C_ArtifactUI.GetPowers()) do
            --local spellID, cost, currentRank, maxRank, bonusRanks, x, y, prereqsMet, isStart, isGoldMedal, isFinal = C_ArtifactUI.GetPowerInfo(powerID)

            table.insert(bb.artifact.perks, {spellID, cost, currentRank, maxRank, bonusRanks, x, y, prereqsMet, isStart, isGoldMedal, isFinal = C_ArtifactUI.GetPowerInfo(powerID)})
        end

        if ArtifactFrame:IsShown() and forceHide then
            HideUIPanel(ArtifactFrame)
        end
    end
end

-- checks for perk
function bb.artifact:hasPerk(spellID)
    for i=1, #bb.artifact.perks do
        if spellID == bb.artifact.perks[i][1] then
            return true
        end
    end
    return false
end

function isKnown(spellID)
    local spellName = GetSpellInfo(spellID)
    if GetSpellBookItemInfo(tostring(spellName)) ~= nil then
        return true
    end
    if IsPlayerSpell(tonumber(spellID)) == true then
        return true
    end
    -- artifact
    if bb.artifact:hasPerk(spellID) == true then
        return true
    end

    return false
end
--- end of artifact perks


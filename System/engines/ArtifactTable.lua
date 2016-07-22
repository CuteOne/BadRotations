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

--- end of artifact perks

--- Globals related to Artifacts
-- C_ArtifactUI.AcceptChanges
-- C_ArtifactUI.AddPower
-- C_ArtifactUI.ApplyCursorRelicToSlot
-- C_ArtifactUI.CanApplyCursorRelicToSlot
-- C_ArtifactUI.CanApplyRelicItemIDToEquippedArtifactSlot
-- C_ArtifactUI.CanApplyRelicItemIDToSlot
-- C_ArtifactUI.CheckRespecNPC
-- C_ArtifactUI.Clear
-- C_ArtifactUI.ClearForgeCamera
-- C_ArtifactUI.ConfirmRespec
-- C_ArtifactUI.GetAppearanceInfo
-- C_ArtifactUI.GetAppearanceInfoByID
-- C_ArtifactUI.GetAppearanceSetInfo
-- C_ArtifactUI.GetArtifactArtInfo
-- C_ArtifactUI.GetArtifactInfo
-- C_ArtifactUI.GetArtifactKnowledgeLevel
-- C_ArtifactUI.GetArtifactKnowledgeMultiplier
-- C_ArtifactUI.GetArtifactXPRewardTargetInfo
-- C_ArtifactUI.GetCostForPointAtRank
-- C_ArtifactUI.GetEquippedArtifactArtInfo
-- C_ArtifactUI.GetEquippedArtifactInfo
-- C_ArtifactUI.GetEquippedArtifactNumRelicSlots
-- C_ArtifactUI.GetForgeRotation
-- C_ArtifactUI.GetMetaPowerInfo
-- C_ArtifactUI.GetNumAppearanceSets
-- C_ArtifactUI.GetNumRelicSlots
-- C_ArtifactUI.GetPointsRemaining
-- C_ArtifactUI.GetPowerInfo
-- C_ArtifactUI.GetPowerLinks
-- C_ArtifactUI.GetPowers
-- C_ArtifactUI.GetPowersAffectedByRelic
-- C_ArtifactUI.GetPowersAffectedByRelicItemID
-- C_ArtifactUI.GetPreviewAppearance
-- C_ArtifactUI.GetRelicInfo
-- C_ArtifactUI.GetRelicInfoByItemID
-- C_ArtifactUI.GetRelicSlotType
-- C_ArtifactUI.GetRespecArtifactArtInfo
-- C_ArtifactUI.GetRespecArtifactInfo
-- C_ArtifactUI.GetRespecCost
-- C_ArtifactUI.GetTotalPurchasedRanks
-- C_ArtifactUI.IsAtForge
-- C_ArtifactUI.IsPowerKnown
-- C_ArtifactUI.IsViewedArtifactEquipped
-- C_ArtifactUI.SetAppearance
-- C_ArtifactUI.SetForgeCamera
-- C_ArtifactUI.SetForgeRotation
-- C_ArtifactUI.SetPreviewAppearance
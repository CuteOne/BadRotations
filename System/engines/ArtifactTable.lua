local name, addon = ...
local LAD = LibStub("LibArtifactData-1.0")

LAD:ForceUpdate()
local artifactId = select(1,C_ArtifactUI.GetEquippedArtifactInfo())
local id, data = LAD:GetArtifactInfo(artifactId)
-- print(id == artifactID, data.name)
bb.artifact = {}
print(artifactId)
if artifactId ~= nil then
    bb.artifact.id = artifactId
    bb.artifact.info = data
end

-- checks for perk
function hasPerk(spellID)
    if bb.artifact ~= nil then
        if bb.artifact.info.traits ~= nil then
            for i=1, #bb.artifact.info.traits do
                if spellID == bb.artifact.info.traits[i]["spellID"] then
                    return true
                end
            end
        end
    end
    return false
end

function getPerkRank(spellID)
    if bb.artifact ~= nil then
        if bb.artifact.info.traits ~= nil then
            for i=1, #bb.artifact.info.traits do
                if spellID == bb.artifact.info.traits[i]["spellID"] then
                    return bb.artifact.info.traits[i]["currentRank"]
                end
            end
        end
    end
    return 0
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
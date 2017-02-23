local name, addon = ...
local LAD = LibStub("LibArtifactData-1.0")

br.artifact = {}
function updateArtifact()
    local artifactId = select(1,C_ArtifactUI.GetEquippedArtifactInfo())
    local _, data = LAD:GetArtifactInfo(artifactId)
    if br.artifact == nil then br.artifact = {} end
    br.artifact.id = artifactId
    br.artifact.info = data
end

function addon:ARTIFACT_ADDED()
    updateArtifact()
end
function addon:ARTIFACT_EQUIPPED_CHANGED()
    updateArtifact()
end
function addon:ARTIFACT_DATA_MISSING()
    updateArtifact()
end
function addon:ARTIFACT_RELIC_CHANGED()
    updateArtifact()
end
function addon:ARTIFACT_TRAITS_CHANGED()
    updateArtifact()
end

--New: ARTIFACT_RELIC_INFO_RECEIVED  
--Old: ARTIFACT_UPDATE

LAD.RegisterCallback(addon, "ARTIFACT_ADDED")
LAD.RegisterCallback(addon, "ARTIFACT_EQUIPPED_CHANGED")
LAD.RegisterCallback(addon, "ARTIFACT_DATA_MISSING")
LAD.RegisterCallback(addon, "ARTIFACT_RELIC_CHANGED")
LAD.RegisterCallback(addon, "ARTIFACT_TRAITS_CHANGED")

if br.artifact.info == nil then LAD.ForceUpdate() end

-- checks for perk
function hasPerk(spellID)
    if br.artifact ~= nil then
        if br.artifact.info ~= nil then
            if br.artifact.info.traits ~= nil then
                for i=1, #br.artifact.info.traits do
                    if spellID == br.artifact.info.traits[i]["spellID"] then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- checkes for perk rank
function getPerkRank(spellID)
    if br.artifact ~= nil then
        if br.artifact.info ~= nil then
            if br.artifact.info.traits ~= nil then
                for i=1, #br.artifact.info.traits do
                    if spellID == br.artifact.info.traits[i]["spellID"] then
                        return br.artifact.info.traits[i]["currentRank"]
                    end
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
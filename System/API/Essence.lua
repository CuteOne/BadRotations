---
-- This table provides information about essences *Shadowlands*.
-- Essence data is stored in `br.player.essence` and can be utilized by `local essence = br.player.essence` in your profile.
--
-- `br.player.essence` has the following checks:
--
-- * `br.player.essence.active` - Indicates if the essence is active.
--
-- * `br.player.essence.major` - Indicates if the essence is a major essence.
--
-- * `br.player.essence.minor` - Indicates if the essence is a minor essence.
--
-- * `br.player.essence.rank` - Indicates the rank of the essence.
--
-- * `br.player.essence.key` - Indicates the key of the essence.
--
-- * `br.player.essence.id` - Indicates the id of the essence.
--
-- * `br.player.essence.spellID` - Indicates the spellID of the essence.
--
-- @module br.player.essence
local _, br = ...
if br.api == nil then br.api = {} end
br.api.essences = function(essence,k,v)
    -- Find Major/Minor/Active/Rank
    essence.active = false
    essence.major = false
    essence.minor = false
    essence.rank = 0
    local milestoneTable = br._G.C_AzeriteEssence.GetMilestones()
    local GetSpellInfo = br._G["GetSpellInfo"]
    local C_AzeriteEssence = br._G["C_AzeriteEssence"]
    local essenceIdName = GetSpellInfo(GetSpellInfo(v)) or "None"
    local essenceIcon = select(3,GetSpellInfo(v)) or 0
    if milestoneTable then
        for i = 1, #milestoneTable do
            local thisMilestone = milestoneTable[i]
            if not thisMilestone.unlocked then break end
            if thisMilestone.slot ~= nil then
                local milestoneEssence = C_AzeriteEssence.GetMilestoneEssence(thisMilestone.ID)
                if milestoneEssence ~= nil then
                    local rank = C_AzeriteEssence.GetEssenceInfo(milestoneEssence).rank
                    local icon = C_AzeriteEssence.GetEssenceInfo(milestoneEssence).icon
                    if essenceIcon == icon then
                        if thisMilestone.slot == 0 then
                            essence.major = true
                            essence.active = true
                        end
                        if thisMilestone.slot == 1 or thisMilestone.slot == 2 then essence.minor = true end
                        essence.rank = rank
                    end
                end
            end
        end
    end
    -- Other Data
    essence.key = k
    essence.id = v
    essence.spellID = select(7,essenceIdName) or v
end
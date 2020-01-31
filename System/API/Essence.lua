local br = _G["br"]
if br.api == nil then br.api = {} end
br.api.essences = function(essence,k,v)
    -- Find Major/Minor/Active/Rank
    essence.active = false
    essence.major = false
    essence.minor = false
    essence.rank = 0
    local milestoneTable = C_AzeriteEssence.GetMilestones()
    local GetSpellInfo = _G["GetSpellInfo"]
    local C_AzeriteEssence = _G["C_AzeriteEssence"]
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
local br = _G["br"]
if br.api == nil then br.api = {} end
br.api.essences = function(essence,k,v)
    local GetSpellInfo = _G["GetSpellInfo"]
    local C_AzeriteEssence = _G["C_AzeriteEssence"]
    local essenceTable = C_AzeriteEssence.GetEssences()
    local essenceIdName = GetSpellInfo(GetSpellInfo(v)) or "None"
    local essenceIcon = select(3,GetSpellInfo(v)) or 0
    local milestoneTable = C_AzeriteEssence.GetMilestones()
    -- Find Essence Ranks
    for i = 1, #essenceTable do
        local thisEssence = essenceTable[i]
        if thisEssence.icon == essenceIcon then
            essence.essenceID = thisEssence.ID
            essence.rank = thisEssence.rank or 0
            break
        end
    end
    -- Find Major/Minor/Active
    essence.active = false
    essence.major = false
    essence.minor = false
    for i = 1, #milestoneTable do
        local thisMilestone = milestoneTable[i]
        if not thisMilestone.unlocked then break end
        if thisMilestone.slot ~= nil then
            local milestoneEssence = C_AzeriteEssence.GetMilestoneEssence(thisMilestone.ID)
            essence.active = essence.essenceID == milestoneEssence
            if essence.active then
                if thisMilestone.slot == 0 then essence.major = true end
                if thisMilestone.slot == 1 or thisMilestone.slot == 2 then essence.minor = true end
                break
            end
        end
    end
    -- Other Data
    essence.key = k
    essence.id = v
    essence.spellID = select(7,essenceIdName) or v
end
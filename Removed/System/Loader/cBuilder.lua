local level = UnitLevel('player')
local function settingsDirectory()
    return GetWoWDirectory() .. '\\Interface\\AddOns\\' .. br.addonName .. '\\Settings\\'
end

-- local function getFunctions()
-- Build Artifact Info
for k,v in pairs(self.spell.artifacts) do
    if not self.artifact[k] then self.artifact[k] = {} end
    local artifact = self.artifact[k]

    artifact.enabled = function()
        return hasPerk(v)
    end
    artifact.rank = function()
        return getPerkRank(v)
    end
end

-- Get Azerite Essence Info
for k,v in pairs(self.spell.essences) do
    local heartEssence = self.spell.essences['heartEssence']
    if v ~= heartEssence then
        if not self.essence[k] then self.essence[k] = {} end
        local essence = self.essence[k]
        if not IsPassiveSpell(v) then
            self.spell['abilities'][k] = select(7,GetSpellInfo(GetSpellInfo(v))) or v--heartEssence
            self.spell[k] = select(7,GetSpellInfo(GetSpellInfo(v))) or v--heartEssence
        end
        br.api.essences(essence,k,v)
    end
end

local function getTalentTest()
    if specName ~= "Initial" then
        for r = 1, 7 do --search each talent row
            for c = 1, 3 do -- search each talent column
                local _,_,_,_,_,id = GetTalentInfo(r,c,br.activeSpecGroup)
                local name = GetSpellInfo(id)
                local spellFound = false
                -- Check if spell is listed in the Shared Class Talents table.
                if sharedClassSpells then
                    for _, listId in pairs(sharedClassSpells.talents) do
                        if listId == id then spellFound = true break end
                    end
                end
                -- Check if spell is listed in the Specialization Talents table.
                if specSpells then
                    for _, listId in pairs(specSpells.talents) do
                        if listId == id then spellFound = true break end
                    end
                end
                -- If not found in either location, then report it as we need it in one of those 2 locations
                if not spellFound then
                    Print("|cffff0000No spell found for: |r"..tostring(id).." ("..tostring(name)..") |cffff0000was not found, please notify dev to add it to the appropriate Talent table for |r"..playerClass.."|cffff0000.")
                end
            end
        end
    end
end

-- local function getSpellsForSpec(spec)
local function getSpellsTest()
    local function findSpellInTable(id,thisTable)
        for _, listId in pairs(thisTable) do
            if listId == id then return true end
        end
        return false
    end
    local function isPvP(thisText)
        -- From https://github.com/tekkub/wow-globalstrings
        local pvpTalent = {
            ["PvP Talent"] = true, -- DE / US
            ["PvP Talento"] = true, -- FR / IT
            ["JcJ Talento"] = true, -- ES / MX / BR
            ["전적 특성"] = true, -- KR
            ["PvP Талант"] = true, -- RU
            ["PvP 天赋"] = true,-- CN
            ["PvP 天賦"] = true-- TW
        }
        return pvpTalent[thisText] ~= nil
    end
    -- Search each Spell Book Tab
    local numTabs = GetNumSpellTabs()
    for i = 1, numTabs do
        local bookName, _, idxStart, idxTotal = GetSpellTabInfo(i)
        -- Only search spells in the Class and Current Specialization Tabs
        if bookName == UnitClass('player') or (bookName == specName and specName ~= "Initial") then
            -- Print("Book: "..tostring(bookName).." | Start: "..idxStart.." | Total: "..idxTotal)
            for spellIdx = idxStart, idxStart + idxTotal do
                -- Print("Book: "..tostring(bookName).." | Class: "..tostring(UnitClass('player').." | Spec: "..tostring(specName)))
                --local _, id = GetSpellBookItemInfo(spellIdx,"spell")
                local name, subname, id = GetSpellBookItemName(spellIdx,"spell")
                -- Nil Catch
                if id == nil then id = select(7,GetSpellInfo(name)) end
                -- Additional Nil Catch
                if id == nil then id = select(2,GetSpellBookItemInfo(spellIdx,"spell")) end
                -- local name = GetSpellInfo(id)
                -- Print("Name: "..tostring(name).." | ID: "..tostring(id))
                -- Only look at spells that have a level we learn and are not passive
                if GetSpellLevelLearned(id) > 0 and not IsPassiveSpell(id) and not isPvP(subname) then
                    -- Check if spell is listed in the Shared Class Abilities / Shared Class Talents, Specializaiton Abilities / Specilization Talents tables.
                    local spellFound = false
                    -- Search Global Abilities
                    if sharedGlobalSpells then 
                        if sharedGlobalSpells.abilities and not spellFound then spellFound = findSpellInTable(id,sharedGlobalSpells.abilities) end
                        if sharedGlobalSpells.covenants and not spellFound then spellFound = findSpellInTable(id,sharedGlobalSpells.covenants) end
                    end
                    -- Search Class Abilities and Talents
                    if sharedClassSpells then
                        if sharedClassSpells.abilities and not spellFound then spellFound = findSpellInTable(id,sharedClassSpells.abilities) end
                        if sharedClassSpells.covenants and not spellFound then spellFound = findSpellInTable(id,sharedClassSpells.covenants) end
                        if sharedClassSpells.talents and not spellFound then spellFound = findSpellInTable(id,sharedClassSpells.talents) end
                    end
                    -- Search Spec Abilities and Talents
                    if specSpells then
                        if specSpells.abilities and not spellFound then spellFound = findSpellInTable(id,specSpells.abilities) end
                        if specSpells.covenants and not spellFound then spellFound = findSpellInTable(id,specSpells.covenants) end
                        if specSpells.talents and not spellFound then spellFound = findSpellInTable(id,specSpells.talents) end
                    end
                    -- If not found in either location, then report it as we need it in one of those 2 locations
                    if not spellFound then
                        local reportString = "|cffff0000No spell found for: |r"..tostring(id).." ("..tostring(name)..") |cffff0000was not found, please notify dev to add it to the |r"
                        if bookName == UnitClass('player') then reportString = reportString.."|cffffff00Shared" end
                        if bookName == specName and specName ~= "Initial" then reportString = reportString.."|cffffff00"..specName end
                        reportString = reportString.."|cffffff00 Abilities |cffff0000table for |r"..br.classColor..playerClass.."|cffff0000."
                        Print(reportString)
                        -- Add to ability list, This would be nice but only works properly for enUS Locale
                        -- local thisSpell = convertName(name)
                        -- if specSpells.abilities[thisSpell] == nil and sharedClassSpells.abilities[thisSpell] == nil then
                        --     specSpells.abilities[thisSpell] = id
                        --     Print("Spell: "..name.." ("..id..") was added to spell list as "..thisSpell..".")
                        -- end
                    end
                end
            end
        end
    end
end

--function br.loader:new(spec,specName)
--Update Azerite Traits
local function getAzeriteTraitInfo()
    -- Search Each Azerite Spell ID
    if self.spell.traits == nil then return end
    for k, v in pairs(self.spell.traits) do
        self.traits[k] = {}
        self.traits[k].active = false
        self.traits[k].rank = 0
        -- Search Each Equiped Azerite Item
        for _, itemLocation in AzeriteUtil.EnumerateEquipedAzeriteEmpoweredItems() do
            local tierInfo = C_AzeriteEmpoweredItem.GetAllTierInfo(itemLocation)
            -- Search Each Level Of The Azerite Item
            for tier, info in next, tierInfo do
                -- Search Each Power On Level
                for _, powerID in next, info.azeritePowerIDs do
                    local isSelected = C_AzeriteEmpoweredItem.IsPowerSelected(itemLocation, powerID)
                    local powerInfo = C_AzeriteEmpoweredItem.GetPowerInfo(powerID)
                    if powerInfo.spellID == v and isSelected then
                        self.traits[k].active = true
                        self.traits[k].rank = self.traits[k].rank + 1
                    end
                end
            end
        end
    end
end
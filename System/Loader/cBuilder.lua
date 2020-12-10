br.loader = {}
local class = select(2,UnitClass('player'))
local level = UnitLevel('player')
local function getFolderClassName(class)
    local formatClass = class:sub(1,1):upper()..class:sub(2):lower()
    if formatClass == "Deathknight" then formatClass = "Death Knight" end
    if formatClass == "Demonhunter" then formatClass = "Demon Hunter" end
    return formatClass
end
local function getFolderSpecName(class,specID)
    for k, v in pairs(br.lists.spec[class]) do
        if v == specID then return tostring(k) end
    end
end
local function rotationsDirectory()
    return GetWoWDirectory() .. '\\Interface\\AddOns\\' .. br.addonName .. '\\Rotations\\'
end
local function settingsDirectory()
    return GetWoWDirectory() .. '\\Interface\\AddOns\\' .. br.addonName .. '\\Settings\\'
end
local function loadFile(profile,file,support)
    local loadProfile = loadstring(profile,file)
    if loadProfile == nil then
        Print("|cffff0000Failed to Load - |r"..tostring(file).."|cffff0000, contact dev.");
    else
        if support then Print("Loaded Support Rotation: "..file) end
        loadProfile()
    end
end

-- Load Rotation Files
function br.loader.loadProfiles()
    -- Search each Profile in the Spec Folder
    wipe(br.rotations)
    local specID = GetSpecializationInfo(GetSpecialization())
    local folderSpec = getFolderSpecName(class,specID)
    local path = rotationsDirectory() .. getFolderClassName(class) .. '\\' .. folderSpec .. '\\'
    local profiles = GetDirectoryFiles(path .. '*.lua')
    local profileName = ""
    for _, file in pairs(profiles) do
        local profile = ReadFile(path..file)
        local start = string.find(profile,"local id = ",1,true) or 0
        local profileID = 0
        if folderSpec == "Initial" then 
            profileID = tonumber(string.sub(profile,start+10,start+14))
        else
            profileID = tonumber(string.sub(profile,start+10,start+13))
        end
        if profileID == specID then 
            loadFile(profile,file,false)
            -- -- Get Rotation Name from File
            -- start = string.find(profile,"local rotationName = ",1,true) or 0
            -- local endString = string.find(profile,"\n",1,true) or 0
            -- profileName = tostring(string.sub(profile,start+20,endString))
            -- endString = string.find(profile,"\" -",1,true) or 0
            -- if endString > 0 then profileName = tostring(string.sub(profile,start+20,endString)) end
            -- Print("Profile: "..profileName)
        end
    end
    -- path = settingsDirectory() .. getFolderClassName(class) .. '\\' .. folderSpec .. '\\' .. profileName .. '\\' 
    -- local settings = GetDirectoryFiles(path .. '*.lua')
    -- for _, file in pairs(settings) do
    --     Print("File: "..tostring(file).." | Profile: "..profileName)
    -- end
end

-- Load Support Files - Specified in Rotation File
function loadSupport(thisFile) -- Loads support rotation file from Class Folder
    if thisFile == nil then return end
    if br.rotations.support == nil then br.rotations.support = {} end
    wipe(br.rotations.support)
    local file = thisFile..".lua"
    local profile = ReadFile(rotationsDirectory()..getFolderClassName(class)..'\\Support\\'..file)
    loadFile(profile,file,true)
end

-- Generate Profile API
function br.loader:new(spec,specName)
    local loadStart = debugprofilestop()
    local self = cCharacter:new(tostring(select(1,UnitClass("player"))))
    local player = "player" -- if someone forgets ""
    if specName == nil then specName = "Initial" end
    -- Print("Spec: "..spec.." | Spec Name: "..specName)
    -- if not br.loaded then
    --     -- Print("Loader - Loading Profiles")
    --     br.loader.loadProfiles()
    --     br.loaded = true
    -- end

    self.profile = specName

    -- Mandatory !
    if br.rotations[spec] == nil then br.loader.loadProfiles() end
    if br.rotations[spec][br.selectedProfile] then
        self.rotation = br.rotations[spec][br.selectedProfile]
    else
        self.rotation = br.rotations[spec][1]
    end


    -- Spells From Spell Table
    local function getSpellsForSpec(spec)
        local playerClass = select(2,UnitClass('player'))
        local specSpells = br.lists.spells[playerClass][spec]
        local sharedClassSpells = br.lists.spells[playerClass]["Shared"]
        local sharedGlobalSpells = br.lists.spells["Shared"]["Shared"]
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

        -- Get the new spells
        local function getSpells(spellTable)
            -- Look through spell type subtables
            for spellType, spellTypeTable in pairs(spellTable) do
                -- Create spell type subtable in br.player.spell if not already there.
                if self.spell[spellType] == nil then self.spell[spellType] = {} end
                -- Look through spells for spell type
                for spellRef, spellID in pairs(spellTypeTable) do
                    -- Assign spell to br.player.spell for the spell type
                    self.spell[spellType][spellRef] = spellID
                    -- Assign active spells to Abilities Subtable and base br.player.spell
                    if not IsPassiveSpell(spellID)
                        and (spellType == 'abilities' or spellType == 'covenants' or ((spellType == 'traits' or spellType == 'talents') and spec < 1400))
                    then
                        if self.spell.abilities == nil then self.spell.abilities = {} end
                        self.spell.abilities[spellRef] = spellID
                        self.spell[spellRef] = spellID
                    end
                end
            end
        end
        
        -- Spell Test
        -- getSpellsTest()
        -- Talent Test
        -- getTalentTest()
        -- Shared Global Spells
        getSpells(sharedGlobalSpells)
        -- Shared Class Spells
        getSpells(sharedClassSpells)
        -- Spec Spells - Don't Load on Initial Levels
        if br.lists.spells[playerClass][spec] ~= nil then getSpells(specSpells) end

        -- Ending the Race War!
        if self.spell.abilities["racial"] == nil then
            local racialID = br.getRacial()
            self.spell.abilities["racial"] = racialID
            self.spell.buffs["racial"] = racialID
            self.spell["racial"] = racialID
        end
    end

    self.items = br.lists.items
    self.visions = br.lists.visions
    self.pets  = br.lists.pets

    -- Update Talent Info
    local function getTalentInfo()
        local talentFound
        br.activeSpecGroup = GetActiveSpecGroup()
        if self.talent == nil then self.talent = {} end
        if spec > 1400 then return end
        for k,v in pairs(self.spell.talents) do
            talentFound = false
            for r = 1, 7 do --search each talent row
                for c = 1, 3 do -- search each talent column
                    local _,_,_,selected,_,talentID = GetTalentInfo(r,c,br.activeSpecGroup)
                    if v == talentID then
                        talentFound = true
                        -- Add All Matches to Talent List for Boolean Checks
                        self.talent[k] = selected
                        -- Add All Active Ability Matches to Ability/Spell List for Use Checks
                        if not IsPassiveSpell(v) then
                            self.spell['abilities'][k] = v
                            self.spell[k] = v
                        end
                        break;
                    end
                end
                -- If we found the talent, then stop looking for it.
                if talentFound then break end
            end
            -- No matching talent for listed talent id, report to
            if not talentFound then
                Print("|cffff0000No talent found for: |r"..k.." ("..v..") |cffff0000in the talent spell list, please notify profile developer to remove from the list.")
            end
        end
    end

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

    local function getFunctions()
        if not self.spell.abilities then return end
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

        -- Conduits
        for k,v in pairs(self.spell.conduits) do
            if self.conduit == nil then self.conduit = {} end
            if self.conduit[k] == nil then self.conduit[k] = {} end
            br.api.conduit(self.conduit,k,v)
        end


        -- Covenant
        if self.covenant == nil then self.covenant = {} end
        if self.covenant.kyrian == nil then self.covenant.kyrian = {} end
        if self.covenant.venthyr == nil then self.covenant.venthyr = {} end
        if self.covenant.nightFae == nil then self.covenant.nightFae = {} end
        if self.covenant.necrolord == nil then self.covenant.necrolord = {} end
        if self.covenant.none == nil then self.covenant.none = {} end
        -- for k,v in pairs(self.spell.covenants) do
        --     if self.covenant == nil then self.covenant = {} end
        --     if self.covenant[k] == nil then self.covenant[k] = {} end
        --     if k ~= nil then
        --         br.api.covenant(self.covenant,k,v)
        --     end
        -- end
        br.api.covenant(self.covenant)

        -- Runeforge
        if self.spell.runeforges ~= nil then
            for k,v in pairs(self.spell.runeforges) do
                if self.runeforge == nil then self.runeforge = {} end
                if self.runeforge[k] == nil then self.runeforge[k] = {} end
                br.api.runeforge(self.runeforge,k,v)
            end
        end

        -- Update Power
        if not self.power then self.power = {} end
        self.power.list     = {
            mana            = 0, --SPELL_POWER_MANA, --0,
            rage            = 1, --SPELL_POWER_RAGE, --1,
            focus           = 2, --SPELL_POWER_FOCUS, --2,
            energy          = 3, --SPELL_POWER_ENERGY, --3,
            comboPoints     = 4, --SPELL_POWER_COMBO_POINTS, --4,
            runes           = 5, --SPELL_POWER_RUNES, --5,
            runicPower      = 6, --SPELL_POWER_RUNIC_POWER, --6,
            soulShards      = 7, --SPELL_POWER_SOUL_SHARDS, --7,
            astralPower     = 8, --SPELL_POWER_LUNAR_POWER, --8,
            holyPower       = 9, --SPELL_POWER_HOLY_POWER, --9,
            altPower        = 10, --SPELL_POWER_ALTERNATE_POWER, --10,
            maelstrom       = 11, --SPELL_POWER_MAELSTROM, --11,
            chi             = 12, --SPELL_POWER_CHI, --12,
            insanity        = 13, --SPELL_POWER_INSANITY, --13,
            obsolete        = 14,
            obsolete2       = 15,
            arcaneCharges   = 16, --SPELL_POWER_ARCANE_CHARGES, --16,
            fury            = 17, --SPELL_POWER_FURY, --17,
            pain            = 18, --SPELL_POWER_PAIN, --18,
        }
        for k, v in pairs(self.power.list) do
            if not self.power[k] then self.power[k] = {} end
            br.api.power(self.power[k],v)
        end

        -- Make Buff Functions from br.api.buffs
        for k,v in pairs(self.spell.buffs) do
            if k ~= "rollTheBones" then
                if self.buff[k] == nil then self.buff[k] = {} end
                if k == "bloodLust" then v = getLustID() end
                br.api.buffs(self.buff[k],v)
            end
        end
        -- Make Debuff Functions from br.api.debuffs
        for k,v in pairs(self.spell.debuffs) do
            if self.debuff[k] == nil then self.debuff[k] = {} end
            br.api.debuffs(self.debuff[k],k,v)
        end

        self.units.get = function(range,aoe)
            local dynString = "dyn"..range
            if aoe == nil then aoe = false end
            if aoe then dynString = dynString.."AOE" end
            local facing = not aoe
            local thisUnit = dynamicTarget(range, facing)
            -- Build units.dyn varaible
            if self.units[dynString] == nil then self.units[dynString] = {} end
            self.units[dynString] = thisUnit
            return thisUnit -- Backwards compatability for old way
        end

        self.enemies.get = function(range,unit,checkNoCombat,facing)
            if unit == nil then unit = "player" end
            if checkNoCombat == nil then checkNoCombat = false end
            if facing == nil then facing = false end
            local enemyTable = getEnemies(unit,range,checkNoCombat,facing)
            -- Build enemies.yards variable
            local insertTable = "yards"..range -- Ex: enemies.yards8 (returns all enemies around player in 8yrds)
            if unit ~= "player" then insertTable = insertTable..unit:sub(1,1) end -- Ex: enemies.yards8t (returns all enemies around target in 8yrds)
            if checkNoCombat then insertTable = insertTable.."nc" end -- Ex: enemies.yards8tnc (returns all units around target in 8yrds)
            if facing then insertTable = insertTable.."f" end-- Ex: enemies.yards8tncf (returns all units the target is facing in 8yrds)
            -- Add to table
            if self.enemies[insertTable] == nil then self.enemies[insertTable] = {} else wipe(self.enemies[insertTable]) end
            if #enemyTable > 0 then insertTableIntoTable(self.enemies[insertTable],enemyTable) end
            return enemyTable  -- Backwards compatability for old way
        end

        -- Make Unit Functions from br.api.unit
        if self.unit == nil then self.unit = {} br.api.unit(self) end

        -- Make Pet Functions from br.api.pets
        if self.pets ~= nil then
            for k,v in pairs(self.pets) do
                if self.pet[k] == nil then self.pet[k] = {} end
                local pet = self.pet[k]
                br.api.pets(pet,k,v,self)
            end
        end

        -- if self.pet.buff == nil then self.pet.buff = {} end
        -- self.pet.buff.exists = function(buffID,petID)
        --     for k, v in pairs(self.pet) do
        --         local pet = self.pet[k]
        --         if self.pet[k].id == petID and UnitBuffID(k,buffID) ~= nil then return true end
        --     end
        --     return false
        -- end

        -- self.pet.buff.count = function(buffID,petID)
        --     local petCount = 0
        --     for k, v in pairs(self.pet) do
        --         local pet = self.pet[k]
        --         if self.pet[k].id == petID and UnitBuffID(k,buffID) ~= nil then petCount = petCount + 1 end
        --     end
        --     return petCount
        -- end

        -- self.pet.buff.missing = function(buffID,petID)
        --     local petCount = 0
        --     for k, v in pairs(self.pet) do
        --         local pet = self.pet[k]
        --         if self.pet[k].id == petID and UnitBuffID(k,buffID) == nil then petCount = petCount + 1 end
        --     end
        --     return petCount
        -- end


        -- Cycle through Items List
        for k,v in pairs(self.items) do --self.spell.items) do
            if self.charges         == nil then self.charges    = {} end -- Item Charge Functions
            if self.charges[k]      == nil then self.charges[k] = {} end -- Item Charge Subtables
            if self.cd              == nil then self.cd         = {} end -- Item Cooldown Functions
            if self.equiped         == nil then self.equiped    = {} end -- Use Item Debugging
            if self.equiped.socket  == nil then self.equiped.socket = {} end -- Item Socket Info
            if self.has             == nil then self.has        = {} end -- Item In Bags
            if self.use             == nil then self.use        = {} end -- Use Item Functions
            if self.use.able        == nil then self.use.able   = {} end -- Useable Item Check Functions

            br.api.items(self.cd,k,v,"cd")

            br.api.items(self.charges,k,v,"charges")

            br.api.items(self.equiped,k,v,"equiped")

            br.api.items(self.has,k,v,"has")

            br.api.items(self.use,k,v,"use")

            getHeirloomNeck()
        end

        -- Cycle through Abilities List
        for spell,id in pairs(self.spell.abilities) do
            if self.charges             == nil then self.charges            = {} end    -- Spell Charge Functions
            if self.cd                  == nil then self.cd                 = {} end    -- Spell Cooldown Functions

            -- Build Cast Funcitons
            br.api.cast(self,spell,id)
            -- Build Spell Charges
            br.api.spells(self.charges,spell,id,"charges")
            -- Build Spell Cooldown
            br.api.cd(self,spell,id)
            --br.api.spells(self.cd,spell,id,"cd")
            -- build Spell Known
            br.api.spells(self.spell,spell,id,"known")
        end

        -- Make Unit Functions from br.api.unit
        if self.ui == nil then self.ui = {} br.api.unit(self) end

        -- Make Action List Functions from br.api.module
        if self.module == nil then self.module = {} br.api.module(self) end
    end

    if spec == GetSpecializationInfo(GetSpecialization()) and (self.talent == nil or self.cast == nil) then 
        getSpellsForSpec(spec); getTalentInfo(); getAzeriteTraitInfo(); getFunctions(); br.updatePlayerInfo = false 
    end
    ------------------
    --- OOC UPDATE ---
    ------------------

    function self.updateOOC()
        -- Call baseUpdateOOC()
        self.baseUpdateOOC()
    end

    --------------
    --- UPDATE ---
    --------------

    function self.update()
        if spec == GetSpecializationInfo(GetSpecialization()) then 
            -- Call baseUpdate()
            if not UnitAffectingCombat("player") then self.updateOOC() end
            self.baseUpdate()
            self.getBleeds()
            -- Update Player Info on Init, Talent, and Level Change
            if br.updatePlayerInfo then getSpellsForSpec(spec); getTalentInfo(); getAzeriteTraitInfo(); getFunctions(); br.updatePlayerInfo = false end
            self.getToggleModes()
            -- Start selected rotation
            self.startRotation()
        end
    end

    ---------------
    --- BLEEDS  ---
    ---------------
    function self.getBleeds()
        if spec == 103 or spec == 259 then
            for k, v in pairs(self.debuff) do
                if k == "rake" or k == "rip" or k == "rupture" or k == "garrote" then
                    if self.debuff[k].bleed == nil then self.debuff[k].bleed = {} end
                    for l, w in pairs(self.debuff[k].bleed) do
                        if --[[not UnitAffectingCombat("player") or]] UnitIsDeadOrGhost(l) then
                            self.debuff[k].bleed[l] = nil
                        elseif not self.debuff[k].exists(l) then
                            self.debuff[k].bleed[l] = 0
                        end
                    end
                end
            end
        end

        if spec == 259 then
            for k, v in pairs(self.debuff) do
                if k == "garrote" or k == "rupture" then
                    if self.debuff[k].exsa == nil then self.debuff[k].exsa = {} end
                    for l, w in pairs(self.debuff[k].exsa) do
                        if --[[not UnitAffectingCombat("player") or]] UnitIsDeadOrGhost(l) then
                            self.debuff[k].exsa[l] = nil
                        elseif not self.debuff[k].exists(l) then
                            self.debuff[k].exsa[l] = false
                        end
                    end
                end
            end
        end
    end

    ---------------
    --- TOGGLES ---
    ---------------

    function self.getToggleModes()
        for k,v in pairs(br.data.settings[br.selectedSpec].toggles) do
            local toggle = k:sub(1,1):lower()..k:sub(2)
            br.api.ui(self,self.ui)
            self.ui.mode[toggle] = br.data.settings[br.selectedSpec].toggles[k]
            UpdateToggle(k,0.25)
        end
    end

    -- Create the toggle defined within rotation files
    function self.createToggles()
        GarbageButtons()
        if self.rotation ~= nil then
            self.rotation.toggles()
        else
            return
        end
    end

    ---------------
    --- OPTIONS ---
    ---------------

    -- Class options
    -- Options which every Rogue should have
    -- function self.createClassOptions()
    --     -- Class Wrap
    --     local section = br.ui:createSection(br.ui.window.profile,  "Class Options", "Nothing")
    --     br.ui:checkSectionState(section)
    -- end
    -- Create Spell Index
    -- function self.createSpellIndex()
    --     section = br.ui:createSection(br.ui.window.profile,  "Spells - Uncheck to prevent bot use")
    --     for k,v in pairs(self.spell.abilities) do
    --         if v ~= 61304 and v ~= 28880 and v ~= 58984 and v ~= 107079 then
    --             br.ui:createCheckbox(section, "Use: "..tostring(GetSpellInfo(v)),"|cFFED0000 WARNING!".."|cFFFFFFFF Unchecking spell may cause rotation to not function correctly or at all.",true)
    --         end
    --     end
    -- end
     -- Creates the option/profile window
    function self.createOptions()
        -- if br.ui:closeWindow("profile")
        for i = 1, #br.data.settings[br.selectedSpec] do
            local thisProfile = br.data.settings[br.selectedSpec][i]
            if thisProfile ~= br.data.settings[br.selectedSpec][br.selectedProfile] then
                br.ui:closeWindow("profile")
            end
        end
        if br.data.settings[br.selectedSpec][br.selectedProfile] == nil then br.data.settings[br.selectedSpec][br.selectedProfile] = {} end
        br.ui:createProfileWindow(self.profile)

        -- Get the names of all profiles and create rotation dropdown
        local names = {}
        for i=1,#br.rotations[spec] do
            local thisName = br.rotations[spec][i].name
            tinsert(names, thisName)
        end

        br.ui:createRotationDropdown(br.ui.window.profile.parent, names)

        -- Create Base and Class option table
        local optionTable = {
            {
                [1] = "Base Options",
                [2] = self.createBaseOptions,
            },
            -- {
            --     [1] = "Spell Index",
            --     [2] = self.createSpellIndex,
            -- },
        }

        -- -- Get profile defined options
        -- local profileTable = profileTable
        -- if self.rotation~= nil then
        --     profileTable = self.rotation.options()
        -- else
        --     return
        -- end
        --
        -- -- Only add profile pages if they are found
        -- if profileTable then
            insertTableIntoTable(optionTable, self.rotation.options())
        -- end

        -- Create pages dropdown
        br.ui:createPagesDropdown(br.ui.window.profile, optionTable)

        -- br:checkProfileWindowStatus()
        br.ui:checkWindowStatus("profile")
    end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------

    function useAoE()
        local rotation = self.ui.mode.rotation
        if (rotation == 1 and #self.enemies.get(8) >= 3) or rotation == 2 then
            return true
        else
            return false
        end
    end

    function useCDs()
        local cooldown = self.ui.mode.cooldown
        if (cooldown == 1 and isBoss()) or cooldown == 2 or (cooldown == 4 and hasBloodLust()) then
            return true
        else
            return false
        end
    end

    function useDefensive()
        if self.ui.mode.defensive == 1 then
            return true
        else
            return false
        end
    end

    function useInterrupts()
        if self.ui.mode.interrupt == 1 then
            return true
        else
            return false
        end
    end

    function useMfD()
        if self.ui.mode.mfd == 1 then
            return true
        else
            return false
        end
    end

    function useRollForTB()
        if self.ui.mode.RerollTB == 1 then
            return true
        else
            return false
        end
    end

     function useRollForOne()
        if self.ui.mode.RollForOne == 1  then
            return true
        else
            return false
        end
    end

    function ComboMaxSpend()
        return br.player.talent.deeperStratagem and 6 or 5
    end

    function ComboSpend()
        return math.min(br.player.power.comboPoints.amount(), ComboMaxSpend())
    end

    function mantleDuration()
        if hasEquiped(144236) then
            --if br.player.buff.masterAssassinsInitiative.remain("player") > 100 or br.player.buff.masterAssassinsInitiative.remain("player") < 0 then
            if br.player.buff.masterAssassinsInitiative.exists("player") and (getBuffRemain("player",235027) > 100 or getBuffRemain("player",235027) < 100) then
                return br.player.cd.global.remain() + 5
            else
                --return br.player.buff.masterAssassinsInitiative.remain("player")
                if getBuffRemain("player",235027) >= 0 and getBuffRemain("player",235027) < 0.1 then
                    return 0
                else
                    return getBuffRemain("player",235027)
                end
            end
        else
            return 0
        end
    end



    function BleedTarget()
        return (br.player.debuff.garrote.exists("target") and 1 or 0) + (br.player.debuff.rupture.exists("target") and 1 or 0) + (br.player.debuff.internalBleeding.exists("target") and 1 or 0)
    end

    -- Debugging
	br.debug.cpu:updateDebug(loadStart,"rotation.loadTime")
    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------
    -- Return
    return self
end --End function

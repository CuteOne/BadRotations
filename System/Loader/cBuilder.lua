local _, br = ...
br.loader.cBuilder = br.loader.cBuilder or {}
local cBuilder = br.loader.cBuilder

local sep = IsMacClient() and "/" or "\\"
local class = select(2, br._G.UnitClass('player'))
local function getFolderClassName(class)
    local formatClass = class:sub(1, 1):upper() .. class:sub(2):lower()
    if formatClass == "Deathknight" then formatClass = "Death Knight" end
    if formatClass == "Demonhunter" then formatClass = "Demon Hunter" end
    return formatClass
end
local function getFolderSpecName(class, specID)
    if br.isClassic then return class end
    for k, v in pairs(br.lists.spec[class]) do
        if v == specID then return tostring(k) end
    end
    return "Initial"
end
local function getFilesLocation()
    local wowDir = br._G.GetWoWDirectory() or ""
    if wowDir:match('_retail_') then
        return wowDir .. sep .. 'Interface' .. sep .. 'AddOns' .. sep .. br.loader.addonName
    end
    return wowDir .. sep .. br.loader.addonName
end

local function errorhandler(err)
    return br._G.geterrorhandler()(err)
end

local function loadFile(profile, file, support)
    local custom_env = setmetatable({ br = br }, { __index = _G })
    local func, errorMessage = br._G.loadstring(profile, file);
    if not func then
        print("Error: " .. file .. " Cannot Load.  Please inform devs!")
        print("Load Error Message: " .. tostring(errorMessage))
        errorhandler(errorMessage)
        return false
    end
    br._G.setfenv(func, custom_env)

    -- Capture the actual error in the error handler
    local actualError = nil
    local function captureError(err)
        actualError = err
        return errorhandler(err)
    end

    local success = xpcall(func, captureError);
    if not success then
        print('Error: ' .. file .. ' Cannot Run.  Please inform devs!')
        print("Run Error Message: " .. tostring(actualError))
        return false
    end
    return true
end

-- Load Rotation Files
function cBuilder:loadProfiles()
    -- Search each Profile in the Spec Folder
    br._G.wipe(br.loader.rotations)
    local specID = br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization())
    local IDLength = math.floor(math.log10(specID) + 1)
    local folderSpec = getFolderSpecName(class, specID)
    local path = getFilesLocation() .. sep .. 'Rotations' .. sep .. getFolderClassName(class) .. sep .. folderSpec .. sep

    -- br._G.print("Path: " .. tostring(path))
    local profiles = br._G.GetDirectoryFiles(path)
    local matchedProfiles = 0
    -- br._G.print("Profiles: " .. tostring(#profiles))
    for k, file in pairs(profiles) do
        -- br._G.print("Path: " .. path .. ", File: " .. file)
        local profile = br._G.ReadFile(path .. file) or ""
        -- br._G.print("Profile: " .. tostring(profile))

        -- Extract spec ID
        local start = string.find(profile, "local id = ", 1, true) or 0
        local stringEnd = start + IDLength + 10
        local profileID = math.floor(tonumber(string.sub(profile, start + 10, stringEnd)) or 0)

        -- Extract expansion identifier (optional - defaults to br.isMOP for backward compatibility)
        local expansionStart = string.find(profile, 'local expansion = ', 1, true)
        local profileExpansion = nil
        if expansionStart then
            -- Extract the value after "local expansion = " (could be br.isMOP, br.isRetail, etc.)
            local valueStart = expansionStart + 18
            local valueEnd = string.find(profile, '\n', valueStart) or string.find(profile, '\r', valueStart)
            if valueEnd then
                local expansionValue = string.sub(profile, valueStart, valueEnd - 1)
                -- Remove any comments
                local commentPos = string.find(expansionValue, '--', 1, true)
                if commentPos then
                    expansionValue = string.sub(expansionValue, 1, commentPos - 1)
                end
                expansionValue = expansionValue:match("^%s*(.-)%s*$")  -- trim whitespace

                -- Evaluate the expression (e.g., "br.isMOP" becomes true/false)
                local func = loadstring("return " .. expansionValue)
                if func then
                    -- Set the environment so the function has access to br
                    setfenv(func, setmetatable({br = br}, {__index = _G}))
                    profileExpansion = func()
                end
            end
        end

        -- Extract rotation name from profile content
        local profileName = file  -- Default to filename
        local nameStart = string.find(profile, 'local rotationName = "', 1, true)
        if nameStart then
            local valueStart = nameStart + 22  -- Length of 'local rotationName = "'
            local valueEnd = string.find(profile, '"', valueStart)
            if valueEnd then
                profileName = string.sub(profile, valueStart, valueEnd - 1)
            end
        else
            -- Try single quotes if double quotes not found
            nameStart = string.find(profile, "local rotationName = '", 1, true)
            if nameStart then
                local valueStart = nameStart + 22
                local valueEnd = string.find(profile, "'", valueStart)
                if valueEnd then
                    profileName = string.sub(profile, valueStart, valueEnd - 1)
                end
            end
        end

        -- br._G.print("ProfileID: " .. tostring(profileID) .. ", SpecID: " .. tostring(specID) .. ", Expansion: " .. tostring(profileExpansion))

        -- Load only if BOTH spec ID matches and expansion is true
        if profileID == specID and profileExpansion then
            br._G.print("Loading Profile: " .. profileName .. " for expansion: " .. br.api.expansionName)
            loadFile(profile, file, false)
            matchedProfiles = matchedProfiles + 1
        end
    end

    -- Warn if no profiles matched for this expansion
    if matchedProfiles == 0 and #profiles > 0 then
        br._G.print("|cffFF0000BadRotations:|r Found " .. #profiles .. " profile(s) but none matched for " .. br.api.expansionName .. " expansion!")
        br._G.print("|cffFFFF00Create a Retail rotation or change profile expansion markers.|r")
    end
end

-- Load Support Files - Specified in Rotation File
function cBuilder:loadSupport(thisFile)
    -- Loads support rotation file from Class Folder
    if thisFile == nil then return end
    br.loader.rotations.support = br.loader.rotations.support or {}
    if br.loader.rotations.support[thisFile] then
        br._G.wipe(br.loader.rotations.support[thisFile])
    end
    local file = thisFile .. ".lua"
    local profile = br._G.ReadFile(getFilesLocation() ..
        sep .. 'Rotations' .. sep .. getFolderClassName(class) .. sep .. 'Support' .. sep .. file)
    loadFile(profile, file, true)
end

-- Generate Profile API
local loadRotations = false
function cBuilder:new(spec, specName)
    local loadStart = br._G.debugprofilestop()
    local self = br.loader.cCharacter:new()--tostring(select(1, br._G.UnitClass("player"))))
    -- local player = "player" -- if someone forgets ""
    if specName == nil then specName = "Initial" end

    self.profile = specName

    -- Mandatory !
    if br.loader.rotations[spec] == nil then
        cBuilder:loadProfiles()
        br.rotationChanged = true
    end

    if not loadRotations then
        if br.loader.selectedProfile ~= nil and br.loader.rotations[spec] ~= nil and br.loader.rotations[spec][br.loader.selectedProfile] then
            -- br._G.print("Selecting Previous Rotation: " .. br.loader.rotations[spec][br.loader.selectedProfile].name)
            self.rotation = br.loader.rotations[spec][br.loader.selectedProfile]
            loadRotations = true
        elseif br.loader.rotations[spec] ~= nil then
            br._G.print("No Previously Selected Rotation, Defaulting To: " .. br.loader.rotations[spec][1].name)
            self.rotation = br.loader.rotations[spec][1]
            loadRotations = true
        else
            if not loadRotations then
                br._G.print("No Rotations Found!")
                self.rotation = {}
            end
            return
        end
    end

    self.items   = br.lists.items
    self.visions = br.lists.visions
    self.pets    = br.lists.pets

    -- Spells From Spell Table
    local function getSpellsForSpec(spec)
        local playerClass = select(2, br._G.UnitClass('player'))
        local specSpells = br.lists.spells[playerClass][spec]
        local sharedClassSpells = br.lists.spells[playerClass]["Shared"]
        local sharedGlobalSpells = br.lists.spells["Shared"]["Shared"]
        -- Get the new spells
        -- origin: "global" | "sharedClass" | "spec"
        local function getSpells(spellTable, origin)
            self.spells = self.spells or {}
            -- track where each spell entry came from so we can prefer spec-specific entries
            if self.spellSource == nil then self.spellSource = {} end
            -- Look through spell type subtables
            for spellType, spellTypeTable in pairs(spellTable) do
                -- Create spell type subtable in br.player.spells if not already there.
                self.spells[spellType] = self.spells[spellType] or {}
                self.spellSource[spellType] = self.spellSource[spellType] or {}
                -- Look through spells for spell type
                for spellRef, spellID in pairs(spellTypeTable) do
                    -- If spellType is items then add to br.player.spells.items
                    if spellType == 'items' then
                        self.items = self.items or {}
                        self.items[spellRef] = spellID
                    else
                        -- Check if br.api.wow.GetSpellInfo returns a valid spell name
                        local name, _, _, _, _, _, gsiSpellID = br.api.wow.GetSpellInfo(spellID)
                        if spellID == 1449 then
                            print("Debug: Checking spellID 1449 (Name: "..(name or "nil")..", GSI ID: "..(gsiSpellID or "nil")..")")
                        end
                        if type(spellID) ~= "table" then
                            if (not name or gsiSpellID ~= spellID) then
                                -- br._G.print("SpellID not valid: " .. tostring(spellID))
                                br._G.print("|cffff0000"..spellType..": |r" ..
                                    spellRef ..
                                    "|cffff0000 with ID: |r" ..
                                    spellID .. "|cffff0000 is not valid in the list of "..spellType.." Spell List.")
                            end
                        else
                            -- If spellID is a table, then it is a list of spellIDs, so we need to check each one
                            for spellRef, id in pairs(spellID) do
                                local name, _, _, _, _, _, gsiSpellID = br.api.wow.GetSpellInfo(id)
                                if (not name or gsiSpellID ~= id) then
                                    -- br._G.print("SpellID not valid: " .. tostring(id))
                                    br._G.print("|cffff0000"..spellType..": |r" ..
                                        spellRef ..
                                        "|cffff0000 with ID: |r" ..
                                        id .. "|cffff0000 is not valid in the list of "..spellType.." Spell List.")
                                end
                            end
                        end
                        -- Assign spell to br.player.spells for the spell type
                        -- If a spec-specific entry already exists, prefer it (don't overwrite with Shared/global)
                        local existingSource = self.spellSource[spellType][spellRef]
                        if existingSource == "spec" and origin ~= "spec" then
                            -- keep existing spec-specific entry
                        else
                            self.spells[spellType][spellRef] = spellID
                            self.spellSource[spellType][spellRef] = origin or "shared"
                        end
                        -- Assign active spells to Abilities Subtable and base br.player.spells
                        if (spellType == 'abilities' or spellType == 'covenants' or ((spellType == 'traits' or spellType == 'talents' or spellType == 'talentsHeroic') and spec < 1400))
                            and type(spellID) ~= 'table' and not br._G.C_Spell.IsSpellPassive(spellID)
                        then
                            self.spells.abilities = self.spells.abilities or {}
                            -- When mapping into abilities/base table, apply same origin-preference rules
                            local existingAbilitiesSource = self.spellSource["abilities"] and self.spellSource["abilities"][spellRef]
                            if existingAbilitiesSource == "spec" and origin ~= "spec" then
                                -- keep existing spec-specific ability
                            else
                                self.spells.abilities[spellRef] = spellID
                                self.spells[spellRef] = spellID
                                self.spellSource["abilities"] = self.spellSource["abilities"] or {}
                                self.spellSource["abilities"][spellRef] = origin or "shared"
                            end
                        end
                    end
                end
            end
        end
        -- Spell Test
        -- getSpellsTest()
        -- Talent Test
        -- getTalentTest()
        -- Shared Global Spells
        getSpells(sharedGlobalSpells, "global")
        -- Shared Class Spells
        getSpells(sharedClassSpells, "sharedClass")
        -- Spec Spells - Don't Load on Initial Levels
        if br.lists.spells[playerClass][spec] ~= nil then getSpells(specSpells, "spec") end

        -- Ending the Race War!
        if self.spells.abilities["racial"] == nil then
            local racialID = self:getRacial()
            self.spells.abilities["racial"] = racialID
            self.spells.buffs["racial"] = racialID
            self.spells["racial"] = racialID
        end
    end

    -- Update Talent Info
    local function getTalentInfo()
        -- Use expansion-specific talent system
        local allTalents = br.api.wow.getTalentInfo(spec, self.spells.talents)
        if self.talent == nil then self.talent = {} end

        -- Check for active talents not in spell lists (only for actual specs, not Initial profiles)
        if spec < 1400 and br.lists and br.lists.spells then
            local playerClass = select(2, br._G.UnitClass('player'))
            if br.lists.spells[playerClass] and br.lists.spells[playerClass]["Shared"] and br.lists.spells[playerClass][spec] then
                local heroicTalents = br.lists.spells[playerClass]["Shared"]["talentsHeroic"] or {}
                local sharedTalents = br.lists.spells[playerClass]["Shared"]["talents"] or {}
                local specTalents = br.lists.spells[playerClass][spec]["talents"] or {}

                -- Check each active talent from the game
                for talentID, talentData in pairs(allTalents) do
                    if talentData.active then
                        local spellName = br.api.wow.GetSpellInfo(talentID)
                        if spellName then
                            local talentName = br.functions.misc:convertName(spellName)

                            -- Check if talent exists in any spell list
                            if sharedTalents[talentName] == nil and specTalents[talentName] == nil and heroicTalents[talentName] == nil then
                                br._G.print("|cffff0000Talent: |r" .. talentName .. "|cffff0000 with ID: |r" .. talentID .. " is not listed in the Talents Spell List.")
                            -- Check if spell ID matches
                            elseif (specTalents[talentName] ~= nil and specTalents[talentName] ~= talentID) or
                                   (sharedTalents[talentName] ~= nil and sharedTalents[talentName] ~= talentID) or
                                   (heroicTalents[talentName] ~= nil and heroicTalents[talentName] ~= talentID) then
                                local currentID = specTalents[talentName] or sharedTalents[talentName] or heroicTalents[talentName]
                                br._G.print("|cffff0000Talent found in Talent Spell List for |r" .. talentName .. "|cffff0000 with ID: |r" .. currentID .. "|cffff0000 it should be changed to ID: |r" .. talentID .. "|cffff0000.")
                            end
                        end
                    end
                end
            end
        end

        -- Map defined spell talents to talent state
        for name, spellID in pairs(self.spells.talents) do
            local entry = allTalents[spellID]
            if entry then
                self.talent[name] = entry.active
                if entry.active and not br.api.wow.IsPassiveSpell(spellID) then
                    self.spells.abilities[name] = spellID
                    self.spells[name] = spellID
                end
            else
                -- Only warn for actual specs, not Initial profiles (spec > 1400)
                if spec < 1400 then
                    br._G.print("|cffff0000No talent found for: |r" .. name .. " (" .. tostring(spellID) .. ") |cffff0000in the talent spell list; please verify ID or remove.")
                end
            end
        end

        return allTalents
    end

    -- Check if Hero Spec if Active (Retail only)
    local function getHeroTreeInfo()
        if not br.isRetail then return end
        if not br._G.C_ClassTalents or not br._G.C_ClassTalents.GetActiveHeroTalentSpec then return end
        if not br.lists or not br.lists.heroSpec then return end

        local playerClass = select(2, br._G.UnitClass('player'))
        -- Retrieve the active hero talent spec ID
        local activeSpecID = br._G.C_ClassTalents.GetActiveHeroTalentSpec()

        -- Check if the specName exists in the br.lists.heroSpec table
        for class, specs in pairs(br.lists.heroSpec) do
            for spec, specID in pairs(specs) do
                if class == playerClass then
                    if self.heroTree == nil then self.heroTree = {} end
                    if self.heroTree[spec] == nil then self.heroTree[spec] = false end
                    self.heroTree[spec] = specID == activeSpecID or false
                end
            end
        end
    end


    local function getFunctions()
        -- Build Talent Info
        local allTalents = getTalentInfo()
        -- br.allTalents = allTalents
        if self.talent == nil then self.talent = {} end
        -- Heroic Talent Patching
        local spellListTalents = self.spells.talents -- Copy to holding table
        if self.spells.talentsHeroic ~= nil then
            -- Add heroic talents to holding table
            for k, v in pairs(self.spells.talentsHeroic) do spellListTalents[k] = v end
            -- Add in missing heroic talents to allTalents (allTalents only get talents available to spec, not all heroic talents are available)
            if allTalents ~= nil then
                for _, v in pairs(self.spells.talentsHeroic) do
                    if allTalents[v] == nil then
                        allTalents[v] = { rank = 0, active = false }
                    end
                end
            end
        end

        -- Build Hero Tree Info
        getHeroTreeInfo()

        -- Parse Holding Table
        for k, v in pairs(spellListTalents) do
            br.api.talent(self.talent, k, v, allTalents, self.spells)
        end

        if not self.spells.abilities then return end
        -- Build Artifact Info
        for k, v in pairs(self.spells.artifacts) do
            if not self.artifact[k] then self.artifact[k] = {} end
            local artifact = self.artifact[k]

            artifact.enabled = function()
                return br.hasPerk(v)
            end
            artifact.rank = function()
                return br.getPerkRank(v)
            end
        end

        -- Get Azerite Essence Info
        -- for k,v in pairs(self.spells.essences) do
        --     local heartEssence = self.spells.essences['heartEssence']
        --     if v ~= heartEssence then
        --         if not self.essence[k] then self.essence[k] = {} end
        --         local essence = self.essence[k]
        --         if not br._G.C_Spell.IsSpellPassive(v) then
        --             self.spells['abilities'][k] = select(7,br.api.wow.GetSpellInfo(br.api.wow.GetSpellInfo(v))) or v--heartEssence
        --             self.spells[k] = select(7,br.api.wow.GetSpellInfo(br.api.wow.GetSpellInfo(v))) or v--heartEssence
        --         end
        --         br.api.essences(essence,k,v)
        --     end
        -- end

        -- Conduits
        if self.conduit == nil then self.conduit = {} end
        for k, v in pairs(self.spells.conduits) do
            if self.conduit[k] == nil then self.conduit[k] = {} end
            -- br.api.conduit(self.conduit,k,v)
        end

        -- Animas
        if self.anima == nil then self.anima = {} end
        for k, v in pairs(self.spells.animas) do
            if self.anima[k] == nil then self.anima[k] = {} end
            -- br.api.animas(self.anima[k],v)
        end

        -- Covenant
        if self.covenant == nil then self.covenant = {} end
        if self.covenant.kyrian == nil then self.covenant.kyrian = {} end
        if self.covenant.venthyr == nil then self.covenant.venthyr = {} end
        if self.covenant.nightFae == nil then self.covenant.nightFae = {} end
        if self.covenant.necrolord == nil then self.covenant.necrolord = {} end
        if self.covenant.none == nil then self.covenant.none = {} end
        -- br.api.covenant(self.covenant)

        -- Runeforge
        if self.runeforge == nil then self.runeforge = {} end
        if self.spells.runeforges ~= nil then
            for k, v in pairs(self.spells.runeforges) do
                if self.runeforge[k] == nil then self.runeforge[k] = {} end
                -- br.api.runeforge(self.runeforge,k,v)
            end
        end

        -- Update Power
        if not self.power then self.power = {} end
        self.power.list = {
            mana          = 0,  --SPELL_POWER_MANA, --0,
            rage          = 1,  --SPELL_POWER_RAGE, --1,
            focus         = 2,  --SPELL_POWER_FOCUS, --2,
            energy        = 3,  --SPELL_POWER_ENERGY, --3,
            comboPoints   = 4,  --SPELL_POWER_COMBO_POINTS, --4,
            runes         = 5,  --SPELL_POWER_RUNES, --5,
            runicPower    = 6,  --SPELL_POWER_RUNIC_POWER, --6,
            soulShards    = 7,  --SPELL_POWER_SOUL_SHARDS, --7,
            astralPower   = 8,  --SPELL_POWER_LUNAR_POWER, --8,
            holyPower     = 9,  --SPELL_POWER_HOLY_POWER, --9,
            altPower      = 10, --SPELL_POWER_ALTERNATE_POWER, --10,
            maelstrom     = 11, --SPELL_POWER_MAELSTROM, --11,
            chi           = 12, --SPELL_POWER_CHI, --12,
            insanity      = 13, --SPELL_POWER_INSANITY, --13,
            -- obsolete        = 14,
            -- obsolete2       = 15,
            arcaneCharges = 16, --SPELL_POWER_ARCANE_CHARGES, --16,
            fury          = 17, --SPELL_POWER_FURY, --17,
            pain          = 18, --SPELL_POWER_PAIN, --18,
            essence       = 19, --SPELL_POWER_ESSENCE, -- 19,
        }
        for k, v in pairs(self.power.list) do
            if not self.power[k] then self.power[k] = {} end
            br.api.power(self.power, k, v)
        end

        -- Make Buff Functions from br.api.buffs
        for k, v in pairs(self.spells.buffs) do
            if k ~= "rollTheBones" then
                if self.buff == nil then self.buff = {} end
                if self.buff[k] == nil then self.buff[k] = {} end
                -- if k == "bloodLust" then v = br.functions.aura:getLustID() end
                local resolvedID = v
                if br.isClassic and type(v) == "table" then
                    if br.functions.spell and br.functions.spell.getHighestKnownRank then
                        resolvedID = br.functions.spell:getHighestKnownRank(v)
                        if not resolvedID then
                            resolvedID = v[1] -- Safety fallback
                        end
                    else
                        resolvedID = v[1]
                    end
                    -- Update the spell list to use resolved ID for icon references
                    self.spells.buffs[k] = resolvedID
                    self.spells[k] = resolvedID  -- Also update base spells table
                end
                br.api.buffs(self.buff, k, resolvedID)
            end
        end
        -- Make Debuff Functions from br.api.debuffs
        for k, v in pairs(self.spells.debuffs) do
            if self.debuff == nil then self.debuff = {} end
            if self.debuff[k] == nil then self.debuff[k] = {} end
            local resolvedID = v
            if br.isClassic and type(v) == "table" then
                if br.functions.spell and br.functions.spell.getHighestKnownRank then
                    resolvedID = br.functions.spell:getHighestKnownRank(v)
                    if not resolvedID then
                        resolvedID = v[1] -- Safety fallback
                    end
                else
                    resolvedID = v[1]
                end
                -- Update the spell list to use resolved ID for icon references
                self.spells.debuffs[k] = resolvedID
                self.spells[k] = resolvedID  -- Also update base spells table
            end
            br.api.debuffs(self.debuff[k], k, resolvedID)
        end

        -- Make Units Functions from br.api.units
        if self.units == nil then
            self.units = {}
            br.api.units(self)
        end

        -- Make Enemies Functions from br.api.enemies
        if self.enemies == nil then
            self.enemies = {}
            br.api.enemies(self)
        end

        -- Make Unit Functions from br.api.unit
        if self.unit == nil then
            self.unit = {}
            br.api.unit(self)
        end

        -- Make Totem Functions from br.api.totem
        if self.totem == nil then
            self.totem = {}
            if br.api.totem then
                br.api.totem(self)
            end
        end

        -- Make Pet Functions from br.api.pets
        if self.pets ~= nil then
            for k, v in pairs(self.pets) do
                if self.pet[k] == nil then self.pet[k] = {} end
                local pet = self.pet[k]
                br.api.pets(pet, k, v, self)
            end
        end

        -- Make Glyph Functions from br.api.glyph / br.api.glyphs
        if self.glyph == nil then self.glyph = {} end
        if br.api.glyph then
            br.api.glyph(self)
        end
        if self.spells and self.spells.glyphs then
            for k, v in pairs(self.spells.glyphs) do
                self.glyph[k] = self.glyph[k] or {}
                if br.api.glyphs then
                    br.api.glyphs(self.glyph, k, v)
                end
                -- Convenience alias: glyphOfFrostShock -> frostShock
                if type(k) == "string" and k:sub(1, 7) == "glyphOf" then
                    local suffix = k:sub(8)
                    if suffix and suffix ~= "" then
                        local alias = suffix:sub(1, 1):lower() .. suffix:sub(2)
                        if self.glyph[alias] == nil then
                            self.glyph[alias] = self.glyph[k]
                        end
                    end
                end
            end
        end

        -- Cycle through Items List
        for item, id in pairs(self.items) do                                --self.spells.items) do
            if self.charges == nil then self.charges = {} end               -- Item Charge Functions
            if self.charges[item] == nil then self.charges[item] = {} end   -- Item Charge Subtables
            if self.cd == nil then self.cd = {} end                         -- Item Cooldown Functions
            if self.equiped == nil then self.equiped = {} end               -- Use Item Debugging
            if self.equiped.socket == nil then self.equiped.socket = {} end -- Item Socket Info
            if self.has == nil then self.has = {} end                       -- Item In Bags
            if self.use == nil then self.use = {} end                       -- Use Item Functions
            if self.use.able == nil then self.use.able = {} end             -- Useable Item Check Functions

            br.api.itemCD(self.cd, item, id)

            br.api.itemCharges(self.charges, item, id)

            br.api.equiped(self.equiped, item, id)

            br.api.has(self.has, item, id)

            br.api.use(self.use, item, id)

            br.functions.item:getHeirloomNeck()
        end

        -- Cycle through Abilities List
        for spell, id in pairs(self.spells.abilities) do
            if self.charges == nil then self.charges = {} end -- Spell Charge Functions
            if self.cd == nil then self.cd = {} end           -- Spell Cooldown Functions
            if self.spell == nil then self.spell = {} end     -- Spell Functions

            -- Classic WoW: If spell ID is a table (ranks), resolve to highest known rank
            local resolvedID = id
            if br.isClassic and type(id) == "table" then
                -- Get highest known rank from the table
                if br.functions.spell and br.functions.spell.getHighestKnownRank then
                    resolvedID = br.functions.spell:getHighestKnownRank(id)
                    if not resolvedID then
                        resolvedID = id[1] -- Safety fallback
                    end
                else
                    -- Fallback to first rank if function not available
                    resolvedID = id[1]
                end
                -- Update the spell list to use resolved ID for icon references
                self.spells.abilities[spell] = resolvedID
                self.spells[spell] = resolvedID  -- Also update base spells table
            end

            -- Build Cast Funcitons
            br.api.cast(self, spell, resolvedID)
            -- Build Spell Charges
            br.api.charges(self.charges, spell, resolvedID)
            -- Build Spell Cooldown
            br.api.cd(self, spell, resolvedID)
            -- Build Spell
            br.api.spell(self, spell, resolvedID)
        end

        -- Make UI Functions from br.api.ui
        if self.ui == nil then
            self.ui = {}
            br.api.ui(self)
        end

        -- Make Action List Functions from br.api.module
        if self.module == nil then
            self.module = {}
            br.api.module(self)
        end
    end

    if spec == br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization()) and (self.talent == nil or self.cast == nil) then
        getSpellsForSpec(spec); --[[getTalentInfo(); getAzeriteTraitInfo();]] getFunctions(); self.updatePlayer = false
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

    function self:update()
        if spec == br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization()) then
            -- Call baseUpdate()
            if not br._G.UnitAffectingCombat("player") then self.updateOOC() end
            self.baseUpdate()
            self.getBleeds()
            -- Update Player Info on Init, Talent, and Level Change
            if self.updatePlayer then
                getSpellsForSpec(spec)
                -- getTalentInfo()
                -- getAzeriteTraitInfo()
                getFunctions()
                self.updatePlayer = false
            end
            self.getToggleModes()
            self.startRotation()
        end
    end

    ---------------
    --- BLEEDS  ---
    ---------------
    function self.getBleeds()
        if spec == 103 or spec == 259 then
            for k, _ in pairs(self.debuff) do
                if k == "rake" or k == "rip" or k == "rupture" or k == "garrote" or k == "crimsonTempest" then
                    if self.debuff[k].bleed == nil then self.debuff[k].bleed = {} end
                    for l, _ in pairs(self.debuff[k].bleed) do
                        if --[[not UnitAffectingCombat("player") or]] br.functions.unit:GetUnitIsDeadOrGhost(l) then
                            self.debuff[k].bleed[l] = nil
                        elseif not self.debuff[k].exists(l, "EXACT") then
                            self.debuff[k].bleed[l] = 0
                        end
                    end
                end
            end
        end

        if spec == 259 then
            for k, _ in pairs(self.debuff) do
                if k == "crimsonTempest" or k == "garrote" or k == "rupture" then
                    if self.debuff[k].exsa == nil then self.debuff[k].exsa = {} end
                    for l, _ in pairs(self.debuff[k].exsa) do
                        if --[[not UnitAffectingCombat("player") or]] br.functions.unit:GetUnitIsDeadOrGhost(l) then
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
        for k, _ in pairs(br.data.settings[br.loader.selectedSpec].toggles) do
            local toggle = k:sub(1, 1):lower() .. k:sub(2)
            self.ui.mode[toggle] = br.data.settings[br.loader.selectedSpec].toggles[k]
            br.functions.misc:UpdateToggle(k, 0.25)
        end
    end

    -- Create the toggle defined within rotation files
    function self.createToggles()
        br.ui:GarbageButtons()
        if self.rotation ~= nil and self.rotation.toggles ~= nil then
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
    --     for k,v in pairs(self.spells.abilities) do
    --         if v ~= 61304 and v ~= 28880 and v ~= 58984 and v ~= 107079 then
    --             br.ui:createCheckbox(section, "Use: "..tostring(GetSpellInfo(v)),"|cFFED0000 WARNING!".."|cFFFFFFFF Unchecking spell may cause rotation to not function correctly or at all.",true)
    --         end
    --     end
    -- end
    -- Creates the option/profile window
    local names
    function self.createOptions()
        -- if br.ui:closeWindow("profile")
        for i = 1, #br.data.settings[br.loader.selectedSpec] do
            local thisProfile = br.data.settings[br.loader.selectedSpec][i]
            if thisProfile ~= br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] then
                br.ui:closeWindow("profile")
            end
        end
        if br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] == nil then br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] = {} end
        br.ui:createProfileWindow(self.profile)

        -- Get the names of all profiles and create rotation dropdown
        if names == nil then names = {} end
        table.wipe(names)
        if #br.loader.rotations[spec] > 0 then
            for i = 1, #br.loader.rotations[spec] do
                local thisName = br.loader.rotations[spec][i].name
                br._G.tinsert(names, thisName)
            end
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
        if self.rotation.options ~= nil then
            br.functions.custom:insertTableIntoTable(optionTable, self.rotation.options())
        end

        -- Create pages dropdown
        br.ui:createPagesDropdown(br.ui.window.profile, optionTable)

        -- br:checkProfileWindowStatus()
        br.ui:checkWindowStatus("profile")
    end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------

    -- Debugging
    br.debug.cpu:updateDebug(loadStart, "rotation.loadTime")
    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------
    -- Return
    return self
end --End function

local _, br = ...
--- Profile Loader
-- Finds rotation files for the current class/spec on disk and runs them, so they can
-- register themselves in br.loader.rotations. Also loads class Support files. Every file runs with
-- the profile API (br.api.profile, ProfileAPI.lua) as its environment.
br.loader.profileLoader = br.loader.profileLoader or {}
local profileLoader = br.loader.profileLoader

-- The loader's state: the rotations registered per spec ID and what's selected (Bootstrap sets these)
br.loader.addonName = "BadRotations"
br.loader.rotations = {}
br.loader.selectedSpec = "None"
br.loader.selectedSpecID = 0
br.loader.selectedProfile = 1
br.loader.selectedProfileName = "None"
br.loader.settingsFile = "None.lua"

-- Spec folder under Rotations/<Class>/: the spec name on expansions with sub-specs,
-- otherwise the class folder itself (Classic-era profiles live in Rotations/<Class>/<Class>/).
local function getFolderSpecName(class, specID)
    if not br.client.rules.hasSubSpecs then return class end
    for k, v in pairs(br.lists.spec[class]) do
        if v == specID then return tostring(k) end
    end
    return "Initial"
end

-- Rotations/<Class>/ folder for the player, with trailing separator
local function getClassRotationsPath()
    local base, sep = br.functions.misc:getAddonPath()
    local class = select(2, br.game.UnitClass('player'))
    return base .. sep .. 'Rotations' .. sep .. br.functions.misc:getClassFolderName(class) .. sep, sep
end

-- A profile file's error: Errors.log, then the game's error handler
local function errorhandler(err)
    return br.log:reportError(err, br.game.debugstack and br.game.debugstack(2))
end

-- Compiles and runs one rotation/support file in the profile API. Returns true and what the file
-- returned, or false.
local function loadFile(profile, file)
    local func, errorMessage = br.game.loadstring(profile, file);
    if not func then
        br.log:error(file .. " cannot load. Please inform devs! " .. tostring(errorMessage))
        errorhandler(errorMessage)
        return false
    end
    br.game.setfenv(func, br.api.profile)
    br.log.rotation:registerSource(file, profile) -- names where a cast came from (System/RotationLog.lua)

    -- Capture the actual error in the error handler
    local actualError = nil
    local function captureError(err)
        actualError = err
        return errorhandler(err)
    end

    local success, result = xpcall(func, captureError);
    if not success then
        br.log:error(file .. " cannot run. Please inform devs! " .. tostring(actualError))
        return false
    end
    return true, result
end

local KNOWN_EXPANSIONS = { Retail = true, MOP = true, TBC = true, Classic = true, Forever = true }
local FLAG_FIELDS = { "actsWhileCasting", "handlesRacials", "handlesTrinkets" }
-- Every field registerRotation reads; anything else is most likely a typo
local KNOWN_FIELDS = { name = true, specID = true, expansion = true, run = true, toggles = true, options = true,
    author = true }
for _, field in ipairs(FLAG_FIELDS) do KNOWN_FIELDS[field] = true end

-- State for the load in progress: the file being run and what it registered
local loading = { file = nil, seen = {} }

local function warn(message)
    br.log:warning(message)
end

-- value may be a single item or a list (specID); returns true if any item equals wanted
local function matches(value, wanted)
    if type(value) == "table" then
        for _, v in ipairs(value) do
            if v == wanted then return true end
        end
        return false
    end
    return value == wanted
end

-- Checks a registration and returns an error message, or nil when it is valid.
local function validate(def)
    if type(def) ~= "table" then return "registerRotation expects a table" end
    if type(def.name) ~= "string" or def.name == "" then return "missing name" end
    if type(def.run) ~= "function" then return "missing run function" end
    if def.toggles ~= nil and type(def.toggles) ~= "function" then return "toggles must be a function" end
    if def.options ~= nil and type(def.options) ~= "function" and type(def.options) ~= "table" then
        return "options must be a function (the Rotation Options page) or a list of { page name, function }"
    end
    local specIDs = type(def.specID) == "table" and def.specID or { def.specID }
    if #specIDs == 0 then return "missing specID" end
    for _, id in ipairs(specIDs) do
        if type(id) ~= "number" then return "specID must be a number or list of numbers" end
    end
    -- One game version per profile: a profile for another client is a separate file
    if def.expansion == nil then return "missing expansion" end
    if not KNOWN_EXPANSIONS[def.expansion] then
        if type(def.expansion) == "table" then return "expansion must be one game version, not a list" end
        return "unknown expansion \"" .. tostring(def.expansion) .. "\""
    end
    for _, field in ipairs(FLAG_FIELDS) do
        if def[field] ~= nil and type(def[field]) ~= "boolean" then return field .. " must be true or false" end
    end
    if def.author ~= nil and type(def.author) ~= "string" then return "author must be a string" end
    return nil
end

--- Registers a rotation profile. Called by each rotation file as registerRotation (see
-- Rotations/sample rotation.lua). The rotation is offered only when its specID and expansion match the player.
-- @tparam table def name, specID (number or list), expansion (one of KNOWN_EXPANSIONS), run, and
--   optional toggles, options, actsWhileCasting (true: the rotation keeps running while the player
--   casts or channels; it then checks casts itself), handlesRacials / handlesTrinkets (true: the
--   rotation uses racials / trinkets itself, so the shared modules don't), author (shown in README.md)
function br.loader.registerRotation(def)
    local file = loading.file or "?"
    local problem = validate(def)
    if problem then
        warn(file .. ": " .. problem .. " - rotation not registered.")
        return false
    end
    for field in pairs(def) do
        if not KNOWN_FIELDS[field] then warn(file .. ": unknown field \"" .. tostring(field) .. "\" ignored.") end
    end
    loading.seen[#loading.seen + 1] = { file = file, name = def.name, expansion = def.expansion }

    local specID = br.loader.selectedSpecID
    if not matches(def.specID, specID) or not matches(def.expansion, br.client.flavour) then
        return false
    end
    br.loader.rotations[specID] = br.loader.rotations[specID] or {}
    local list = br.loader.rotations[specID]
    for _, existing in ipairs(list) do
        if existing.name == def.name then
            warn(file .. ": a rotation named \"" .. def.name .. "\" is already registered (" .. tostring(existing.file) .. ") - skipped.")
            return false
        end
    end
    local entry = {}
    for k, v in pairs(def) do entry[k] = v end
    entry.file = file
    br.game.tinsert(list, entry)
    return true
end

--- Runs every rotation file in the class/spec folder. Each file calls registerRotation,
-- which keeps the ones for the player's spec and expansion in br.loader.rotations[specID].
function profileLoader:loadProfiles()
    br.game.wipe(br.loader.rotations)
    local specID = br.loader.selectedSpecID
    local class = select(2, br.game.UnitClass('player'))
    local classPath, sep = getClassRotationsPath()
    local path = classPath .. getFolderSpecName(class, specID) .. sep
    local files = br.game.GetDirectoryFiles(path) or {}

    br.game.wipe(loading.seen)
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            loading.file = file
            loadFile(br.game.ReadFile(path .. file) or "", file)
        end
    end
    loading.file = nil

    local list = br.loader.rotations[specID]
    local matchedProfiles = list and #list or 0

    br.loader.noRotationsFoundWarned = br.loader.noRotationsFoundWarned or {}
    if matchedProfiles == 0 then
        -- Warn once per spec per session (login / reload / spec change)
        if not br.loader.noRotationsFoundWarned[specID] then
            br.loader.noRotationsFoundWarned[specID] = true
            if #loading.seen == 0 then
                warn("no rotations found in " .. path)
            else
                local found = {}
                for _, r in ipairs(loading.seen) do
                    found[#found + 1] = r.name .. " (" .. r.expansion .. ")"
                end
                warn("no rotation for spec " .. specID .. " on " .. br.client.flavour .. ". Found: " .. table.concat(found, ", "))
            end
        end
    else
        br.loader.noRotationsFoundWarned[specID] = nil
    end
end

--- Loads a support file (e.g. "PetCuteOne") from Rotations/<Class>/Support/ and returns what it
-- returns (its options and run functions, for the profile that loaded it). Profiles call it as loadSupport.
-- @string thisFile File name without .lua
function profileLoader:loadSupport(thisFile)
    if thisFile == nil then return nil end
    local file = thisFile .. ".lua"
    local classPath, sep = getClassRotationsPath()
    local path = classPath .. 'Support' .. sep .. file
    local profile = br.game.ReadFile(path)
    if profile == nil then
        warn("support file not found: " .. path)
        return nil
    end
    local _, support = loadFile(profile, file)
    return support
end

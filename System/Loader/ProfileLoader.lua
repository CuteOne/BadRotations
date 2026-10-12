local _, br = ...
--- Profile Loader
-- Finds rotation files for the current class/spec on disk and runs them, so they can
-- register themselves in br.loader.rotations. Also loads class Support files.
br.loader.profileLoader = br.loader.profileLoader or {}
local profileLoader = br.loader.profileLoader

-- Spec folder under Rotations/<Class>/: the spec name on expansions with sub-specs,
-- otherwise the class folder itself (Classic-era profiles live in Rotations/<Class>/<Class>/).
local function getFolderSpecName(class, specID)
    if not br.api.hasSubSpecs then return class end
    for k, v in pairs(br.lists.spec[class]) do
        if v == specID then return tostring(k) end
    end
    return "Initial"
end

-- Rotations/<Class>/ folder for the player, with trailing separator
local function getClassRotationsPath()
    local base, sep = br.functions.misc:getAddonPath()
    local class = select(2, br._G.UnitClass('player'))
    return base .. sep .. 'Rotations' .. sep .. br.functions.misc:getClassFolderName(class) .. sep, sep
end

local function errorhandler(err)
    return br._G.geterrorhandler()(err)
end

-- Compiles and runs one rotation/support file. Its environment sees br, and reads globals through
-- br._G, so bare names get BR's versions (expansion shims, unlocker functions, tagged print).
local function loadFile(profile, file)
    local custom_env = setmetatable({ br = br }, { __index = br._G })
    local func, errorMessage = br._G.loadstring(profile, file);
    if not func then
        br._G.print("Error: " .. file .. " Cannot Load.  Please inform devs!")
        br._G.print("Load Error Message: " .. tostring(errorMessage))
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
        br._G.print('Error: ' .. file .. ' Cannot Run.  Please inform devs!')
        br._G.print("Run Error Message: " .. tostring(actualError))
        return false
    end
    return true
end

local KNOWN_EXPANSIONS = { Retail = true, MOP = true, TBC = true, Classic = true, Forever = true }
local METADATA_FIELDS = { "author", "patch", "coverage", "status", "readiness" }

-- State for the load in progress: the file being run and what it registered
local loading = { file = nil, seen = {} }

local function warn(message)
    br._G.print("|cffFF0000BadRotations:|r " .. message)
end

-- value may be a single item or a list; returns true if any item equals wanted
local function matches(value, wanted)
    if type(value) == "table" then
        for _, v in ipairs(value) do
            if v == wanted then return true end
        end
        return false
    end
    return value == wanted
end

local function listText(value)
    return type(value) == "table" and table.concat(value, "/") or tostring(value)
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
    local expansions = type(def.expansion) == "table" and def.expansion or { def.expansion }
    if #expansions == 0 then return "missing expansion" end
    for _, exp in ipairs(expansions) do
        if not KNOWN_EXPANSIONS[exp] then return "unknown expansion \"" .. tostring(exp) .. "\"" end
    end
    -- README metadata is free text; it only has to be a string when present
    for _, field in ipairs(METADATA_FIELDS) do
        if def[field] ~= nil and type(def[field]) ~= "string" then return field .. " must be a string" end
    end
    return nil
end

--- Registers a rotation profile. Called by each rotation file (see Rotations/sample rotation.lua).
-- The rotation is offered only when its specID and expansion match the player.
-- @tparam table def name, specID (number or list), expansion (string or list), run, and optional
--   toggles, options, actsWhileCasting (true: the rotation keeps running while the player casts or
--   channels; it then checks casts itself), plus README metadata: author, patch, coverage, status, readiness
function br.loader.registerRotation(def)
    local file = loading.file or "?"
    local problem = validate(def)
    if problem then
        warn(file .. ": " .. problem .. " - rotation not registered.")
        return false
    end
    loading.seen[#loading.seen + 1] = { file = file, name = def.name, expansion = def.expansion }

    local specID = br.loader.selectedSpecID
    if not matches(def.specID, specID) or not matches(def.expansion, br.api.expansion) then
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
    br._G.tinsert(list, entry)
    return true
end

--- Runs every rotation file in the class/spec folder. Each file calls br.loader.registerRotation,
-- which keeps the ones for the player's spec and expansion in br.loader.rotations[specID].
function profileLoader:loadProfiles()
    br._G.wipe(br.loader.rotations)
    local specID = br.loader.selectedSpecID
    local class = select(2, br._G.UnitClass('player'))
    local classPath, sep = getClassRotationsPath()
    local path = classPath .. getFolderSpecName(class, specID) .. sep
    local files = br._G.GetDirectoryFiles(path) or {}

    br._G.wipe(loading.seen)
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            loading.file = file
            loadFile(br._G.ReadFile(path .. file) or "", file)
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
                    found[#found + 1] = r.name .. " (" .. listText(r.expansion) .. ")"
                end
                warn("no rotation for spec " .. specID .. " on " .. br.api.expansion .. ". Found: " .. table.concat(found, ", "))
            end
        end
    else
        br.loader.noRotationsFoundWarned[specID] = nil
    end
end

--- Loads a support file (e.g. "PetCuteOne") from Rotations/<Class>/Support/.
-- @string thisFile File name without .lua
function profileLoader:loadSupport(thisFile)
    if thisFile == nil then return end
    br.loader.rotations.support = br.loader.rotations.support or {}
    -- A support file sets a table or a function; a table is emptied before the file fills it again
    if type(br.loader.rotations.support[thisFile]) == "table" then
        br._G.wipe(br.loader.rotations.support[thisFile])
    end
    local file = thisFile .. ".lua"
    local classPath, sep = getClassRotationsPath()
    local path = classPath .. 'Support' .. sep .. file
    local profile = br._G.ReadFile(path)
    if profile == nil then
        warn("support file not found: " .. path)
        return
    end
    loadFile(profile, file)
end

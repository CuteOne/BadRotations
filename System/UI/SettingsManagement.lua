local _, br = ...
br.ui.settingsManagement = br.ui.settingsManagement or {}
local settingsManagement = br.ui.settingsManagement
local sep = br.game.IsMacClient() and "/" or "\\"

local function getFolderClassName(class)
	return br.functions.misc:getClassFolderName(class)
end

-- Returns the formatted class folder name for the current player (e.g. "Shaman", "Death Knight").
-- Used by TBC/Classic where hasSubSpecs = false: settings are keyed by class, not spec.
local function getClassFolderName()
	return getFolderClassName(select(2, br.game.UnitClass("player")))
end

-- Normalizes a raw spec name from C_SpecializationInfo for use as a settings key / folder.
-- Retail/MOP (hasSubSpecs = true)  → returns rawSpec unchanged ("Blood", "Enhancement", …).
-- TBC/Classic  (hasSubSpecs = false) → returns the formatted class name ("Shaman", "Death Knight", …)
-- so all specs share one folder and the key is stable across respecs.
function settingsManagement:normalizeSpecKey(rawSpec)
	if not br.client.rules.hasSubSpecs then
		return getClassFolderName()
	end
	return rawSpec
end

-- Folders known to exist (checked or made this session)
local knownDirs = {}
local function checkDirectory(dir)
	if knownDirs[dir] then return end
	if not br.game.DirectoryExists(dir) then
		br.game.CreateDirectory(dir)
		if not br.game.DirectoryExists(dir) then
			-- Return Path
			br.log:error("Creating directory " .. dir .. " failed!")
			return nil
		end
	end
	knownDirs[dir] = true
end

-- Settings/, where every flavour's settings lived before they were split per WoW flavour
local function legacyRoot()
	local base, s = br.functions.misc:getAddonPath()
	return base .. s .. "Settings" .. s, s
end

-- Settings/<Flavour>/: each WoW flavour (br.client.flavour: Retail, Classic, TBC, MOP, Forever) keeps
-- its own settings, so profiles and characters of one flavour never read another's
local function settingsRoot()
	local legacy, s = legacyRoot()
	checkDirectory(legacy)
	local root = legacy .. (br.client.flavour or "Unknown") .. s
	checkDirectory(root)
	return root, s
end

--------------------------------------------------------------------------
-- Table Save/Load code from: http://lua-users.org/wiki/SaveTableToFile --
--------------------------------------------------------------------------
local function exportstring(s)
    return string.format("%q", s)
end

-- Keys in a fixed order, so the same settings always give the same file text
local function keyOrder(a, b)
    local ta, tb = type(a), type(b)
    if ta ~= tb then return ta < tb end
    if ta == "number" or ta == "string" then return a < b end
    return tostring(a) < tostring(b)
end

-- The file text for a table: "return { {table 1}, {table 2}, ... }", where a table value or key is
-- written as {n}, the number of its table (shared and cyclic tables are written once)
local function serialize(tbl)
    local charS, charE = "   ", "\n"
    local out = { "return {" .. charE }
    local tables, lookup = { tbl }, { [tbl] = 1 }
    -- The text for a key or value, or nil for types that aren't saved (functions, ...)
    local function literal(v)
        local vtype = type(v)
        if vtype == "table" then
            if not lookup[v] then
                tables[#tables + 1] = v
                lookup[v] = #tables
            end
            return "{" .. lookup[v] .. "}"
        elseif vtype == "string" then
            return exportstring(v)
        elseif vtype == "number" or vtype == "boolean" then
            return tostring(v)
        end
    end
    for idx, t in ipairs(tables) do
        out[#out + 1] = "-- Table: {" .. idx .. "}" .. charE
        out[#out + 1] = "{" .. charE
        local thandled = {}
        for i, v in ipairs(t) do
            thandled[i] = true
            local value = literal(v)
            if value then out[#out + 1] = charS .. value .. "," .. charE end
        end
        local keys = {}
        for i in pairs(t) do
            if not thandled[i] then keys[#keys + 1] = i end
        end
        table.sort(keys, keyOrder)
        for _, i in ipairs(keys) do
            local key = literal(i)
            if key then
                local value = literal(t[i])
                if value then out[#out + 1] = charS .. "[" .. key .. "]=" .. value .. "," .. charE end
            end
        end
        out[#out + 1] = "}," .. charE
    end
    out[#out + 1] = "}"
    return table.concat(out)
end

-- The Save Function
local function tableSave(tbl, filename)
    br.game.WriteFile(filename, serialize(tbl), false)
end

-- A table from file text written by serialize (nil for no text)
local function parse(file, name)
    if file == nil or file == "" then
        return
    end
    local ftables = br.game.loadstring(file, name)
    local tables
    if (ftables) then
        tables = ftables()
    else
        tables = {}
    end
    for idx = 1, #tables do
        local tolinki = {}
        for i, v in pairs(tables[idx]) do
            if type(v) == "table" then
                tables[idx][i] = tables[v[1]]
            end
            if type(i) == "table" and tables[i[1]] then
                table.insert(tolinki, { i, tables[i[1]] })
            end
        end
        -- link indices
        for _, v in ipairs(tolinki) do
            tables[idx][v[2]], tables[idx][v[1]] = tables[idx][v[1]], nil
        end
    end
    return tables[1]
end

-- The Load Function
local function tableLoad(sfile)
    return parse(br.game.ReadFile(sfile), sfile)
end

-- Live settings files taken over this session from the root before the flavour split (path -> true)
local tookOver = {}

-- The same file at the root before the flavour split, or nil for a path outside this flavour's root
local function legacyPathOf(path)
	local root = settingsRoot()
	if path:sub(1, #root) ~= root then return nil end
	return legacyRoot() .. path:sub(#root + 1)
end

-- A live settings file's table. While this flavour's folder doesn't have the file yet, the same file
-- at the old root (Settings/ before the split) is read instead; the next save writes it into the
-- flavour's folder and the old file stays as it was.
local function loadLive(path)
	local file = tableLoad(path)
	if file then return file end
	local oldPath = legacyPathOf(path)
	file = oldPath and tableLoad(oldPath)
	if file and not tookOver[path] then
		tookOver[path] = true
		br.log:say("Settings", "Took over " .. br.log.highlight(oldPath) .. " for " .. tostring(br.client.flavour)
			.. " (the old file is kept).")
	end
	return file
end

-- Default Settings
function settingsManagement:defaultSettings()
	-- Settings Per Spec
	if br.data.settings[br.loader.selectedSpec] == nil then
		br.data.settings[br.loader.selectedSpec] = {}
	end
	if br.data.settings[br.loader.selectedSpec].toggles == nil then
		br.data.settings[br.loader.selectedSpec].toggles = {}
	end
	if br.data.settings[br.loader.selectedSpec]["RotationDrop"] == nil then
		br.loader.selectedProfile = 1
	else
		br.loader.selectedProfile = br.data.settings[br.loader.selectedSpec]["RotationDrop"]
	end
	if br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] == nil then
		br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] = {}
	end
	-- Define Main Button if no settings exist
	if (br.data.settings and br.data.settings.mainButton == nil) then
		br.data.settings.mainButton = {
			pos = {
				anchor = "CENTER",
				x = -75,
				y = -200
			}
		}
		br.data.settings.buttonSize = 32
		br.data.settings.font = "Fonts/arialn.ttf"
		br.data.settings.fontsize = 16
		br.data.settings.wiped = true
	end
	-- Define Minimap Button if no settings exist
	if (br.data.settings and br.data.settings.minimapButton == nil) then
		br.data.settings.minimapButton = {
			pos = {
				x = 75.70,
				y = -6.63
			}
		}
	end
end

--- Makes the settings folders down to the one asked for and returns its path (ending in the separator).
---@param folder? string A folder under the root (none)
---@param class? string The class file name (the player's)
---@param spec? string The spec folder (the selected spec; the class on clients without specs)
---@param profile? string The profile folder (the selected profile); "Tracker" returns the class folder
---@param instance? string A folder under the profile's
---@param root? string The settings root to build under; this flavour's (Settings/<Flavour>/) by default
---@return string
function settingsManagement:checkDirectories(folder, class, spec, profile, instance, root)
	-- Set Settings Directory
	local mainDir = root or settingsRoot()

	-- Set Folder to Specified Folder if any
	if folder == nil then
		folder = ""
	else
		folder = folder .. sep
	end
	local settingsDir = mainDir .. folder
	checkDirectory(settingsDir)

	-- Set the Class Directory
	if class == nil then
		class = select(2, br.game.UnitClass("player"))
	end
	local classDir = settingsDir .. getFolderClassName(class) .. sep
	checkDirectory(classDir)

	-- Return Spec Directory if Profile is Tracker
	if profile ~= nil and profile == "Tracker" then
		return classDir
	end

	-- Set the Spec Directory
	-- TBC/Classic have no sub-specializations: always use the class name as the spec folder
	-- so settings live at Settings/Shaman/Shaman/Profile/ (not Settings/Shaman/Enhancement/Profile/).
	-- This matches the rotation folder layout where hasSubSpecs = false uses the class folder.
	if not br.client.rules.hasSubSpecs then
		spec = getFolderClassName(class)
	else
		if spec == nil then
			spec = br.loader.selectedSpec
		end
		if spec == nil or spec == "" then
			spec = "Initial"
		end
	end
	local specDir = classDir .. spec .. sep
	checkDirectory(specDir)

	-- Set the Profile Directory
	if profile == nil then
		profile = br.loader.selectedProfileName
	end
	local profileDir = specDir .. profile .. sep
	checkDirectory(profileDir)
	if not instance then return profileDir end
	local instanceDir = profileDir .. instance .. sep
	checkDirectory(instanceDir)
	return instanceDir
end

function settingsManagement:deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[settingsManagement:deepcopy(orig_key)] = settingsManagement:deepcopy(orig_value)
		end
		setmetatable(copy, settingsManagement:deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

--- Runs every window page once without building frames (br.ui.elementOptions.withoutFrames), so
-- every option registers its page and default and appears in br.data.ui for cleanSettings.
-- Returns true only when every page ran: clean-up must never judge from a partial list.
function settingsManagement:registerAllOptions()
	if not br.ui or not br.ui.window then return false end
	local pagesRun, failedPages = 0, {}
	for _, window in pairs(br.ui.window) do
		if type(window) == "table" and window.pages then
			for _, page in ipairs(window.pages) do
				if type(page[2]) == "function" then
					local ok, err = br.ui.elementOptions.withoutFrames(page[2])
					if ok then
						pagesRun = pagesRun + 1
					else
						failedPages[#failedPages + 1] = tostring(page[1]) .. " (" .. tostring(err):sub(1, 80) .. ")"
					end
				end
			end
		end
	end
	if #failedPages > 0 then
		br.log:warning(#failedPages .. " option pages failed to load, settings clean-up skipped:")
		for _, failMsg in ipairs(failedPages) do br.log:more("  - " .. failMsg) end
		return false
	end
	if pagesRun > 0 then br.functions.misc:checkKeyClashes() end
	return pagesRun > 0
end

-- More removals than this in one clean-up are treated as a malfunction and undone
local CLEANUP_MAX_REMOVED = 50

function settingsManagement:cleanSettings()
	if br.data and br.data.settings then
		-- Check if Power toggle is off - if so, skip cleaning as UI was never built
		if br.data.settings[br.loader.selectedSpec] and br.data.settings[br.loader.selectedSpec].toggles and
			br.data.settings[br.loader.selectedSpec].toggles["Power"] ~= 1 then
			br.log:warning("Settings clean-up skipped: BR is toggled off")
			return
		end

		-- Check if br.data.ui exists and has actual page data before attempting cleanup
		-- This prevents cleaning when UI hasn't been fully initialized yet
		if not br.data.ui then
			br.log:warning("Settings clean-up skipped: no option pages are built yet")
			return
		end

		-- Count how many pages exist in br.data.ui (excluding meta keys like PageList, currentPage, totalPages)
		local uiPageCount = 0
		for pageName, pageData in pairs(br.data.ui) do
			if type(pageData) == "table" and pageName ~= "PageList" and pageName ~= "currentPage" and pageName ~= "totalPages" then
				uiPageCount = uiPageCount + 1
			end
		end

		-- If no actual pages exist in br.data.ui, skip cleaning
		if uiPageCount == 0 then
			br.log:warning("Settings clean-up skipped: no option pages found (" .. uiPageCount .. ")")
			return
		end

		-- Single removedItems list shared across Phase 1 (Block A below) and
		-- Phase 2/3 (Block B further down). Previously each block had its own
		-- local, so Phase 1's entries died at Block A's `end` and were silently
		-- dropped before the length check + save-back at the end of Block B —
		-- misplaced-only cleanups never persisted.
		-- Nothing is removed until the whole list is known: a clean-up that looks like a malfunction
		-- then changes nothing. (Putting back a copy instead left the built option windows writing to
		-- the replaced tables, so no change made in them was saved.)
		local removedItems = {}
		local removals = {} -- { table, key } pairs, removed only if the clean-up goes ahead
		local marked = {}   -- table -> { key = true }: each entry listed once
		local function markRemoved(t, key, label)
			marked[t] = marked[t] or {}
			if marked[t][key] then return end
			marked[t][key] = true
			removals[#removals + 1] = { t, key }
			table.insert(removedItems, label)
		end

		if uiPageCount >= 3 then
			local settings = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]

			-- ========================================
			-- PHASE 1: Remove duplicate/misplaced options
			-- ========================================
			-- Build a map of where each option SHOULD exist (from br.data.ui which reflects actual UI)
			local optionToCorrectPage = {}
			for page, pageData in pairs(br.data.ui) do
				if type(pageData) == "table" and page ~= "PageList" and page ~= "currentPage" and page ~= "totalPages" then
					for option, _ in pairs(pageData) do
						if type(option) == "string" then
							optionToCorrectPage[option] = page
						end
					end
				end
			end

			-- Scan all pages in saved settings and remove options that belong on a different page
			for page, pageData in pairs(settings) do
				if type(pageData) == "table" and page ~= "PageList" and page ~= "currentPage" and page ~= "totalPages" then
					for option, _ in pairs(pageData) do
						-- Skip sections - they're UI elements, not settings
						if not option:match("Section$") then
							local correctPage = optionToCorrectPage[option]
							-- If this option exists in UI but on a DIFFERENT page, remove it from here
							-- Only if we actually found where it should be
							if correctPage and type(correctPage) == "string" and correctPage ~= page then
								local cleanName = option:gsub(" Check", ""):gsub(" Drop", ""):gsub(" Status", "")
								markRemoved(pageData, option, cleanName .. " (misplaced on " .. page .. ", should be on " .. correctPage .. ")")
							end
						end
					end
				end
			end
		else
			br.log:say("Settings", "Duplicate check skipped: only " .. uiPageCount .. " option pages built (needs 3+)")
		end

		if br.data.settings[br.loader.selectedSpec] and br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile] then
			local settings = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]

			-- ========================================
			-- PHASE 2: Remove orphaned options
			-- ========================================
			for page, pageData in pairs(settings) do
				if type(pageData) == "table" and type(page) == "string" then
					-- Check if this is an actual page (not PageList, currentPage, etc.)
					if page ~= "PageList" and page ~= "currentPage" and page ~= "totalPages" then
						-- Check if this page exists in br.data.ui
						if not br.data.ui[page] then
							-- Page doesn't exist in UI registry - this might be normal if page hasn't been created yet
							-- Don't wipe settings for pages that haven't been visited/created
							-- br.game.print("|cffFFDD00[cleanSettings] Skipping page '" .. page .. "' - not in UI registry (not created yet)|r")
						else
							-- Page exists in UI, check individual options
							for option, _ in pairs(pageData) do
								-- Skip sections - they're UI elements, not settings
								if not option:match("Section$") then
									-- Check if this option exists in br.data.ui for THIS specific page
									if br.data.ui[page][option] == nil then
										local cleanName = option:gsub(" Check", ""):gsub(" Drop", ""):gsub(" Status", "")
										markRemoved(pageData, option, cleanName .. " (orphaned from " .. page .. ")")
									end
								end
							end
						end
					end
				elseif type(page) == "string" then
					-- This handles settings that aren't in a page structure
					local option = page
					-- Skip sections - they're UI elements, not settings
					if not option:match("Section$") and br.data.ui[option] == nil then
						markRemoved(settings, option, option)
					end
				end
			end

			-- A real clean-up removes a handful of leftovers; this many means options failed to register.
			-- Except right after a file was taken over from before the flavour split: it can hold another
			-- flavour's options (profiles of the same name shared one file), removed here once.
			if #removedItems > CLEANUP_MAX_REMOVED and next(tookOver) == nil then
				br.log:warning("Settings clean-up skipped: it would have removed " .. #removedItems
					.. " settings, which looks like a problem rather than leftovers. Nothing was changed.")
				return
			end
			for _, removal in ipairs(removals) do removal[1][removal[2]] = nil end
			if #removedItems > 0 then
				br.log:say("Settings", "Clean-up removed " .. #removedItems .. " duplicate/orphaned setting(s)")
				-- Save immediately so cleaned settings persist
				br.data.collectGarbage = false -- Prevent re-running cleanup
				settingsManagement:saveSettings()
			end
		end
	end
end

-- Number of backups kept per settings file (savedSettings.lua.bak1 is the newest)
local SETTINGS_BACKUPS = 3
-- Below this many saved values a file is too small for the emptied-settings guard to judge
local GUARD_MIN_VALUES = 40

-- Counts the non-table values in a settings tree (shared/cyclic tables are counted once)
local function countValues(t, seen)
	if type(t) ~= "table" then return 0 end
	seen = seen or {}
	if seen[t] then return 0 end
	seen[t] = true
	local n = 0
	for _, v in pairs(t) do
		if type(v) == "table" then
			n = n + countValues(v, seen)
		else
			n = n + 1
		end
	end
	return n
end

-- Keeps the previous SETTINGS_BACKUPS versions of a file as <file>.bak1 .. .bakN
-- current: the file's text now
local function rotateBackups(path, current)
	for i = SETTINGS_BACKUPS - 1, 1, -1 do
		local older = br.game.ReadFile(path .. ".bak" .. i)
		if older ~= nil and older ~= "" then
			br.game.WriteFile(path .. ".bak" .. (i + 1), older, false)
		end
	end
	br.game.WriteFile(path .. ".bak1", current, false)
end

--------------------------------------------------------------------------
-- Settings storage (S2)
--
-- In memory BR keeps one table per spec/profile slot (br.data.settings[spec][slot]) holding every
-- options page. On disk that table is split by owner:
--   Characters/<Realm>-<Name>/BotOptions.lua            Bot Options pages, window layout, buttons
--   Characters/<Realm>-<Name>/<Spec>/BaseOptions.lua    Base Options pages
--   <Class>/<Spec>/<Profile>/settings.lua               Rotation pages + toggles
--   <Class>/<Spec>/selection.lua                        selected profile
--   Characters/index.lua                                class/specs/last use per character
-- all under Settings/<Flavour>/ (settingsRoot). Files from before the flavour split (directly under
-- Settings/) are read by loadLive until the flavour has its own; the index starts fresh per flavour,
-- so new characters are only seeded from the same flavour.
-- Pages are routed by their storage name: "Bot Options/..." and "Base Options/..." prefixes
-- (set by br.ui:createSection), everything else belongs to the rotation profile.
--------------------------------------------------------------------------

-- Bot Options sections that existed before storage names were prefixed (used by the migration)
local LEGACY_BOT_SECTIONS = {
	["Debug Info"] = true, ["Debug Options"] = true, ["Developer Options"] = true, ["Dungeon Helpers"] = true,
	["Enemies Engine"] = true, ["Export/Import from Settings Folder"] = true,
	["Healing Engine"] = true, ["Healing Options"] = true, ["Load Saved Profiles"] = true,
	["Main Settings"] = true, ["Other Features"] = true, ["Smart Queue"] = true,
}
local LEGACY_BASE_SECTIONS = { ["Base Options"] = true, ["Module Options"] = true }
-- Before S2 the Bot Options "General" section and a rotation's own "General" section shared one
-- page; these are the Bot Options ones (everything else on that page belongs to the rotation).
local LEGACY_BOT_GENERAL_OPTIONS = {
	["Auto Delay"] = true, ["Queue Casting"] = true, ["Auto Loot"] = true, ["Auto-Sell/Repair"] = true,
	["Accept Queues"] = true, ["Overlay Messages"] = true, ["Notify Not Unlocked"] = true,
	["Reset Options"] = true, ["Reset Saved Profiles"] = true, ["Auto Check for Updates"] = true,
	["Bot Update Rate"] = true,
}

-- Splits a legacy slot's shared "General" page into "Bot Options/General" and the rotation's "General"
local function splitLegacyGeneral(slot)
	local general = slot["General"]
	if type(general) ~= "table" then return slot end
	local copy = {}
	for k, v in pairs(slot) do copy[k] = v end
	local bot, rotation = {}, {}
	for key, value in pairs(general) do
		local option = type(key) == "string" and (key:gsub(" Check$", ""):gsub(" Status$", ""):gsub(" Drop$", ""):gsub(" EditBox$", "")) or key
		if LEGACY_BOT_GENERAL_OPTIONS[option] then bot[key] = value else rotation[key] = value end
	end
	copy["Bot Options/General"] = bot
	copy["General"] = rotation
	return copy
end
-- Global UI values kept in br.data.settings (saved with the character's Bot Options)
local GLOBAL_UI_KEYS = { "font", "fontsize", "buttonSize", "wiped", "mainButton", "minimapButton" }
-- Per-spec window layout tables in br.data.settings[spec] (saved with the character's Bot Options)
local WINDOW_KEYS = { "config", "profile", "debug" }
-- Per-spec keys that belong to the selection / profile rather than to a page
local SPEC_RESERVED = { toggles = true, RotationDrop = true, RotationDropValue = true, config = true, profile = true, debug = true }

-- "<Realm>-<Name>" folder key for the current character
local function characterKey()
	local name = br.game.UnitName("player") or "Unknown"
	local realm = (br.game.GetRealmName and br.game.GetRealmName()) or "Realm"
	return (realm .. "-" .. name):gsub("[\\/:%*%?\"<>|]", "_")
end

local function characterDir(key)
	local root, s = settingsRoot()
	local dir = root .. "Characters" .. s
	checkDirectory(dir)
	dir = dir .. (key or characterKey()) .. s
	checkDirectory(dir)
	return dir, s
end

local function botOptionsPath(key)
	return characterDir(key) .. "BotOptions.lua"
end

local function baseOptionsPath(specKey, key)
	local dir, s = characterDir(key)
	dir = dir .. specKey .. s
	checkDirectory(dir)
	return dir .. "BaseOptions.lua"
end

local function indexPath()
	local root, s = settingsRoot()
	checkDirectory(root .. "Characters" .. s)
	return root .. "Characters" .. s .. "index.lua"
end

-- Settings/<Flavour>/<Class>/<Spec>/ folder for the current class and spec
local function specDir()
	local profileDir = settingsManagement:checkDirectories(nil, nil, nil, "Tracker") -- returns the class folder
	local spec = br.loader.selectedSpec
	if spec == nil or spec == "" then spec = "Initial" end
	local dir = profileDir .. spec .. sep
	checkDirectory(dir)
	return dir
end

-- Which file a page/section key belongs to: "bot", "base" or "profile"
local function scopeOf(key)
	if type(key) ~= "string" then return "profile" end
	if key:sub(1, 12) == "Bot Options/" then return "bot" end
	if key:sub(1, 13) == "Base Options/" then return "base" end
	return "profile"
end

-- Maps a pre-S2 page/section key to its storage name (Bot/Base sections gain their prefix)
local function legacyStorageName(key)
	local page, suffix = key, ""
	if key:sub(-8) == " Section" then page, suffix = key:sub(1, -9), " Section" end
	if LEGACY_BOT_SECTIONS[page] then return "Bot Options/" .. page .. suffix end
	if LEGACY_BASE_SECTIONS[page] then return "Base Options/" .. page .. suffix end
	return key
end

local function isEmptyTable(t)
	return type(t) == "table" and next(t) == nil
end

-- Splits one profile slot table into { bot, base, profile } parts.
-- rename: optional function(key) -> storage key (the migration maps legacy names)
local function splitSlot(slot, rename)
	local parts = {
		bot = { pages = {}, sections = {} },
		base = { pages = {}, sections = {} },
		profile = { pages = {}, sections = {}, other = {} },
	}
	for key, value in pairs(slot or {}) do
		if key ~= "PageList" and type(key) == "string" then
			local storageKey = rename and rename(key) or key
			local part = parts[scopeOf(storageKey)]
			if type(value) == "table" then
				if not isEmptyTable(value) then part.pages[storageKey] = settingsManagement:deepcopy(value) end
			elseif storageKey:sub(-8) == " Section" then
				part.sections[storageKey] = value
			elseif part.other then
				part.other[storageKey] = value
			end
		end
	end
	return parts
end

local function mergeInto(slot, part)
	if not part then return end
	for k, v in pairs(part.pages or {}) do slot[k] = settingsManagement:deepcopy(v) end
	for k, v in pairs(part.sections or {}) do slot[k] = v end
	for k, v in pairs(part.other or {}) do slot[k] = v end
end

-- Builds the character file contents (Bot Options pages + layout) from in-memory/legacy data
local function buildBotFile(botPart, globalSettings, specSettings)
	local file = { pages = botPart.pages, sections = botPart.sections, ui = {}, windows = {} }
	for _, k in ipairs(GLOBAL_UI_KEYS) do
		if globalSettings and globalSettings[k] ~= nil then file.ui[k] = settingsManagement:deepcopy(globalSettings[k]) end
	end
	for _, k in ipairs(WINDOW_KEYS) do
		if specSettings and specSettings[k] ~= nil then file.windows[k] = settingsManagement:deepcopy(specSettings[k]) end
	end
	return file
end

-- Below this many reverted options a save is never treated as "reset to defaults"
local GUARD_MIN_REVERTED = 10

-- Counts options that are customised on disk but back at their registered default in memory.
-- Needs the option index (complete once startup reaches RUNNING); returns reverted, customised.
local function countReverted(newPages, diskPages)
	if br.bootstrap.stage ~= "RUNNING" then return 0, 0 end
	local defaults = br.functions.misc:getOptionDefaults()
	local reverted, customised = 0, 0
	for page, diskValues in pairs(diskPages or {}) do
		local pageDefaults = defaults[page]
		if type(diskValues) == "table" and pageDefaults then
			local newValues = (newPages and newPages[page]) or {}
			for key, diskValue in pairs(diskValues) do
				local default = pageDefaults[key]
				if default ~= nil and diskValue ~= default then
					customised = customised + 1
					if newValues[key] == default then reverted = reverted + 1 end
				end
			end
		end
	end
	return reverted, customised
end

-- Settings files whose backups were rotated this session
local backedUp = {}

-- Writes a settings file with the S0 protections: backups, and refusing to replace a full file
-- with a mostly empty one (unless allowEmpty, used for a deliberate reset or snapshot). With the
-- option index available it also refuses a save where most customised options went back to their
-- defaults. A file that would come out the same isn't written. Routine saves keep the file as it
-- was before this session's first save as .bak1 (so a run of saves doesn't push every older copy
-- out); a deliberate write always keeps the file it replaces.
local function writeSettingsFile(path, data, label, allowEmpty)
	local content = serialize(data)
	local current = br.game.ReadFile(path)
	if content == current then return true end
	if not allowEmpty then
		local onDisk = parse(current, path)
		local reverted, customised = countReverted(data.pages, onDisk and onDisk.pages)
		if reverted >= GUARD_MIN_REVERTED and reverted >= customised / 2 then
			br.log:error("Settings not saved (" .. label .. "): " .. reverted .. " of your " .. customised
				.. " customised options are back at their defaults, which looks like settings were lost. Use Reset Options to reset on purpose.")
			return false
		end
		local diskCount = countValues(onDisk)
		local newCount = countValues(data)
		if diskCount >= GUARD_MIN_VALUES and newCount < diskCount / 2 then
			br.log:error("Settings not saved (" .. label .. "): the current settings (" .. newCount
				.. " values) look emptied compared with the saved file (" .. diskCount .. " values).")
			return false
		end
	end
	if (allowEmpty or not backedUp[path]) and current ~= nil and current ~= "" then
		rotateBackups(path, current)
		backedUp[path] = true
	end
	br.game.WriteFile(path, content, false)
	return true
end

-- Records this character's class, spec and time of save (used to seed new characters), once per
-- spec per session
-- Specs already recorded this session (the time is only used to pick the most recent character)
local indexTouched = {}
local function touchIndex(specKey)
	if indexTouched[specKey] then return end
	indexTouched[specKey] = true
	local path = indexPath()
	local index = tableLoad(path) or {}
	local key = characterKey()
	local entry = index[key] or {}
	local now = br.game.time()
	entry.class = select(2, br.game.UnitClass("player"))
	entry.lastUsed = now
	entry.specs = entry.specs or {}
	entry.specs[specKey] = now
	index[key] = entry
	tableSave(index, path)
end

-- Picks another character to copy settings from: same class first, then any; most recent first.
-- wantSpec: prefer characters that have used this spec (for Base Options)
local function pickSeedCharacter(wantSpec)
	local index = tableLoad(indexPath()) or {}
	local me = characterKey()
	local myClass = select(2, br.game.UnitClass("player"))
	local best, bestScore
	for key, entry in pairs(index) do
		if key ~= me and type(entry) == "table" then
			local score = (entry.lastUsed or 0)
			if entry.class == myClass then score = score + 2e9 end
			if wantSpec and entry.specs and entry.specs[wantSpec] then score = score + 1e9 end
			if not bestScore or score > bestScore then best, bestScore = key, score end
		end
	end
	return best
end

local function loadBotFile()
	local path = botOptionsPath()
	local file = loadLive(path)
	if file then return file end
	local source = pickSeedCharacter()
	if source then
		file = tableLoad(botOptionsPath(source))
		if file then
			br.log:say("Settings", "New character: copied Bot Options from " .. br.log.highlight(source) .. ".")
			return file
		end
	end
	return nil
end

local function loadBaseFile(specKey)
	local file = loadLive(baseOptionsPath(specKey))
	if file then return file end
	-- This character's most recently used other spec
	local index = tableLoad(indexPath()) or {}
	local mine = index[characterKey()]
	if mine and mine.specs then
		local bestSpec, bestTime
		for spec, t in pairs(mine.specs) do
			if spec ~= specKey and (not bestTime or t > bestTime) then bestSpec, bestTime = spec, t end
		end
		if bestSpec then
			file = tableLoad(baseOptionsPath(bestSpec))
			if file then
				br.log:say("Settings", "New spec: copied Base Options from your " .. br.log.highlight(bestSpec) .. " settings.")
				return file
			end
		end
	end
	-- Another character (same class/spec preferred)
	local source = pickSeedCharacter(specKey)
	if source then
		local entry = index[source]
		local sourceSpec = (entry and entry.specs and entry.specs[specKey]) and specKey or nil
		if not sourceSpec and entry and entry.specs then
			local t
			for spec, used in pairs(entry.specs) do
				if not t or used > t then sourceSpec, t = spec, used end
			end
		end
		if sourceSpec then
			file = tableLoad(baseOptionsPath(sourceSpec, source))
			if file then
				br.log:say("Settings", "New character: copied Base Options from " .. br.log.highlight(source) .. ".")
				return file
			end
		end
	end
	return nil
end

-- The three settings files ({ bot, base, profile }) from a pre-S2 savedSettings.lua (a dump of br.data)
local function legacyFiles(old, specKey)
	local oldSpec = old.settings and old.settings[specKey] or {}
	local slot = splitLegacyGeneral(oldSpec[oldSpec.RotationDrop or 1] or oldSpec[1] or {})
	local parts = splitSlot(slot, legacyStorageName)
	parts.profile.toggles = settingsManagement:deepcopy(oldSpec.toggles or {})
	return {
		bot = buildBotFile(parts.bot, old.settings, oldSpec),
		base = { pages = parts.base.pages, sections = parts.base.sections },
		profile = parts.profile,
	}
end

-- The three settings files ({ bot, base, profile }) for the settings in memory
local function currentFiles()
	local specSettings = br.data.settings[br.loader.selectedSpec] or {}
	local parts = splitSlot(specSettings[br.loader.selectedProfile] or {})
	parts.profile.toggles = settingsManagement:deepcopy(specSettings.toggles or {})
	return {
		bot = buildBotFile(parts.bot, br.data.settings, specSettings),
		base = { pages = parts.base.pages, sections = parts.base.sections },
		profile = parts.profile,
	}
end

-- One-time conversion of a pre-S2 profile folder (savedSettings.lua + class tracker) to the new
-- files. The old files are left untouched. Bot/Base files are only written if this character
-- doesn't have them yet.
local function migrateProfileFolder(profileDir, specKey)
	local newPath = profileDir .. "settings.lua"
	if loadLive(newPath) then return end
	local old = loadLive(profileDir .. "savedSettings.lua")
	if not old or not old.settings then return end
	local files = legacyFiles(old, specKey)
	tableSave(files.profile, newPath)
	if not loadLive(botOptionsPath()) then tableSave(files.bot, botOptionsPath()) end
	local basePath = baseOptionsPath(specKey)
	if not loadLive(basePath) then tableSave(files.base, basePath) end
	br.log:say("Settings", "Settings for this profile were converted to the new format (old savedSettings.lua kept).")
end

--- Loads a profile's settings (and this character's Bot/Base Options) into memory.
-- @param profile the rotation profile name
function settingsManagement:loadSettings(profile)
	if not br.unlocked then return end
	local spec = br.loader.selectedSpec
	if not spec or spec == "" then spec = "Initial" end
	-- Only reload if not already loaded for this spec/profile (keeps in-memory data otherwise)
	if settingsManagement._lastLoadedSpec == spec and settingsManagement._lastLoadedProfile == profile then
		return
	end
	settingsManagement._lastLoadedSpec = spec
	settingsManagement._lastLoadedProfile = profile
	local profileDir = settingsManagement:checkDirectories(nil, nil, spec, profile)
	if not profileDir then
		br.log:warning("No settings directory found for " .. br.log.highlight(tostring(profile)) .. "!")
		return
	end
	local specKey = br.loader.selectedSpec
	migrateProfileFolder(profileDir, specKey)

	local botFile = loadBotFile() or {}
	local baseFile = loadBaseFile(specKey) or {}
	local profileFile = loadLive(profileDir .. "settings.lua") or {}

	br.ui:closeWindow("all")
	br.data.settings = br.data.settings or {}
	for _, k in ipairs(GLOBAL_UI_KEYS) do
		if botFile.ui and botFile.ui[k] ~= nil then br.data.settings[k] = settingsManagement:deepcopy(botFile.ui[k]) end
	end
	-- Rebuild this spec's table, keeping the current selection
	local previous = br.data.settings[specKey] or {}
	local specSettings = {
		RotationDrop = previous.RotationDrop,
		RotationDropValue = previous.RotationDropValue,
		toggles = settingsManagement:deepcopy(profileFile.toggles or {}),
	}
	for _, k in ipairs(WINDOW_KEYS) do
		if botFile.windows and botFile.windows[k] ~= nil then specSettings[k] = settingsManagement:deepcopy(botFile.windows[k]) end
	end
	local slot = {}
	mergeInto(slot, botFile)
	mergeInto(slot, baseFile)
	mergeInto(slot, profileFile)
	specSettings[specSettings.RotationDrop or 1] = slot
	br.data.settings[specKey] = specSettings
	-- The UI mirror is rebuilt as pages are created
	br.data.ui = nil
	br.game.print("Loaded Settings for Profile " .. tostring(profile))
	br.log.session:profileLoaded(profile)
end

--- Saves the current settings: the character's Bot/Base Options files and the profile's settings
-- file. wipe = true resets them (the "Reset Options" path). quiet = true leaves out the chat lines.
function settingsManagement:saveSettings(wipe, quiet)
	local profile = br.loader.selectedProfileName
	-- "None" means no rotation is loaded; saving it would only store defaults (and create a folder)
	if profile == nil or profile == "" or profile == "None" then
		br.log:warning("Settings not saved: no rotation profile is loaded.")
		return
	end
	local profileDir = settingsManagement:checkDirectories(nil, nil, br.loader.selectedSpec, profile)
	if not profileDir then
		br.log:warning("No settings directory found for " .. br.log.highlight(profile) .. "!")
		return
	end
	local specKey = br.loader.selectedSpec
	local files = wipe and { bot = {}, base = {}, profile = {} } or currentFiles()
	if not quiet then br.game.print("Saving Profiles and Settings to Directory: " .. tostring(profileDir)) end
	writeSettingsFile(botOptionsPath(), files.bot, "Bot Options", wipe)
	writeSettingsFile(baseOptionsPath(specKey), files.base, "Base Options", wipe)
	writeSettingsFile(profileDir .. "settings.lua", files.profile, profile, wipe)
	touchIndex(specKey)
	if not quiet then br.game.print("Saved Settings for Profile " .. profile) end
end

--- Saves right away after a change made in the UI (Power click, toggle bar moved, profile switch),
-- so it survives a crash; logout saves everything anyway. Only once this session's settings were
-- loaded (never defaults over a real file), and without chat lines unless loud.
function settingsManagement:saveIfLoaded(loud)
	if br.bootstrap:canSave() then
		settingsManagement:saveSettings(false, not loud)
	end
end

---------------------
--- Snapshots (copies of the settings files: Load Saved Profiles, Export/Import)
---------------------
local SNAPSHOT_FILES = { bot = "BotOptions.lua", base = "BaseOptions.lua", profile = "settings.lua" }

local function ensureDir(dir)
	checkDirectory(dir)
	return dir
end

--- Folder for one of this profile's named snapshots ("Solo", "Raid", ...):
-- Settings/<Flavour>/<Class>/<Spec>/<Profile>/Snapshots/<name>/
function settingsManagement:snapshotDir(name)
	local profileDir = settingsManagement:checkDirectories(nil, nil, br.loader.selectedSpec, br.loader.selectedProfileName)
	return ensureDir(ensureDir(profileDir .. "Snapshots" .. sep) .. name .. sep)
end

--- Where a snapshot saved before the settings rework would be (Settings/Profile Settings/...), or nil
-- when there are none (so no folders are created for it).
function settingsManagement:legacySnapshotDir(name)
	if not br.game.DirectoryExists(legacyRoot() .. "Profile Settings") then return nil end
	return settingsManagement:checkDirectories("Profile Settings", nil, br.loader.selectedSpec, br.loader.selectedProfileName, name,
		legacyRoot())
end

--- Folder Export writes to and Import reads from: Settings/<Flavour>/Exported Settings/<Class>/<Spec>/<Profile>/
function settingsManagement:exportDir()
	return settingsManagement:checkDirectories("Exported Settings", nil, br.loader.selectedSpec, br.loader.selectedProfileName)
end

--- Saves the current settings into a snapshot folder.
-- @param dir   the folder (snapshotDir / exportDir)
-- @param parts which files: any of "bot" (Bot Options), "base" (Base Options), "profile" (Rotation Options + toggles)
-- @param label shown in chat
function settingsManagement:saveSnapshot(dir, parts, label)
	local files = currentFiles()
	for _, part in ipairs(parts) do
		writeSettingsFile(dir .. SNAPSHOT_FILES[part], files[part], label, true)
	end
	br.game.print("Saved " .. label .. " to " .. dir)
end

--- Replaces the current settings with a snapshot's files and reloads the profile. The replaced files
-- are kept as .bak1. Old-format snapshots (savedSettings.lua) are read too.
-- @param dir   the folder (snapshotDir / exportDir); legacyDir (optional) is where an old-format
--              snapshot of the same settings may be
-- @param parts which files: any of "bot", "base", "profile"
-- @return true when something was loaded
function settingsManagement:loadSnapshot(dir, parts, label, legacyDir)
	local specKey = br.loader.selectedSpec
	local files = {}
	for _, part in ipairs(parts) do files[part] = loadLive(dir .. SNAPSHOT_FILES[part]) end
	if next(files) == nil then
		local old = loadLive(dir .. "savedSettings.lua") or (legacyDir and tableLoad(legacyDir .. "savedSettings.lua"))
		if old and old.settings then
			local converted = legacyFiles(old, specKey)
			for _, part in ipairs(parts) do files[part] = converted[part] end
		end
	end
	if next(files) == nil then
		br.log:warning("No saved " .. label .. " found.")
		return false
	end
	local profileDir = settingsManagement:checkDirectories(nil, nil, specKey, br.loader.selectedProfileName)
	local live = { bot = botOptionsPath(), base = baseOptionsPath(specKey), profile = profileDir .. "settings.lua" }
	for part, data in pairs(files) do writeSettingsFile(live[part], data, label, true) end
	-- Read the files back on the next startup step instead of keeping what is in memory
	settingsManagement._lastLoadedSpec, settingsManagement._lastLoadedProfile = nil, nil
	br.bootstrap:reloadProfile()
	br.game.print("Loaded " .. label .. ".")
	return true
end

--- Reads which profile is selected for this spec (Settings/<Flavour>/<Class>/<Spec>/selection.lua) and sets
-- br.loader.selectedProfileName plus the in-memory RotationDrop/RotationDropValue. Falls back to the
-- pre-S2 class tracker once, then to the first rotation.
function settingsManagement:loadSelection()
	local specID = br.loader.selectedSpecID
	local rotations = br.loader.rotations[specID]
	if rotations == nil or #rotations == 0 then return end
	local specKey = br.loader.selectedSpec
	br.data.settings[specKey] = br.data.settings[specKey] or {}
	local specSettings = br.data.settings[specKey]

	local selection = loadLive(specDir() .. "selection.lua")
	local name = selection and selection.profile
	if name == nil then
		local tracker = loadLive(settingsManagement:checkDirectories(nil, nil, nil, "Tracker") .. "lastProfileTracker.lua")
		name = tracker and tracker[specKey] and tracker[specKey]["RotationDropValue"]
	end
	local index
	for i = 1, #rotations do
		if rotations[i].name == name then index = i break end
	end
	if index == nil then
		if name ~= nil and name ~= "" then
			br.log:warning("Last used rotation \"" .. tostring(name) .. "\" not found, defaulting to " .. br.log.highlight(rotations[1].name))
		end
		index = 1
	end
	br.loader.selectedProfileName = rotations[index].name
	specSettings["RotationDropValue"] = rotations[index].name
	specSettings["RotationDrop"] = index
end

--- Saves the selected profile for this spec. Skipped when the spec has no rotations, so a broken
-- profile never overwrites the last good selection.
function settingsManagement:saveSelection()
	local rotations = br.loader.rotations and br.loader.rotations[br.loader.selectedSpecID]
	if rotations == nil or #rotations == 0 then return end
	local name = br.loader.selectedProfileName
	local valid = false
	for i = 1, #rotations do
		if rotations[i].name == name then valid = true break end
	end
	if not valid then return end
	tableSave({ profile = name }, specDir() .. "selection.lua")
end

-- On logout (and /reload): save, but only once this session's settings were loaded (never defaults
-- over a real file)
br.lifecycle:onLogout(20, "settings", function()
	if not br.bootstrap:canSave() then return end
	br.ui:saveWindowPosition()
	settingsManagement:cleanSettings()
	local profile = br.data.settings[br.loader.selectedSpec] and br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
	if profile and profile["PageList"] then br.game.wipe(profile["PageList"]) end
	if br.functions.misc:getOptionCheck("Reset Options") then
		settingsManagement:saveSettings(true) -- "Reset Options": the defaults are saved instead
	else
		settingsManagement:saveSettings()
	end
	settingsManagement:saveSelection()
end)
